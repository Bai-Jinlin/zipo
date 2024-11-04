use std::{net::TcpListener, path::Path};

use crate::frb_generated::StreamSink;
use axum::{extract::State, routing::{get, post}, Json, Router};
use flutter_rust_bridge::frb;
use local_ip_address::local_ip;
use serde::Deserialize;
use tokio::runtime::Runtime;
use tokio_util::sync::CancellationToken;
use tower_http::services::ServeDir;
use zipo_lib::{Metrics, Settings, ZipDir};


#[derive(Clone)]
struct MyState{
    path:String,
    stream:StreamSink<String>
}
#[derive(Deserialize)]
struct DecodeRequest{
    filename:String
}

async fn decode(Json(DecodeRequest{filename}):Json<DecodeRequest>)->String{
    urlencoding::decode(&filename).unwrap().into()
}

async fn list(State(state):State<MyState>) -> String {
    let dir = std::fs::read_dir(state.path).unwrap();
    let mut ret = String::new();

    for entry in dir {
        let entry = entry.unwrap();
        let path = entry.path();
        if path.extension().unwrap() != "zip" {
            continue;
        }
        let filename = path.file_name().unwrap().to_string_lossy();
        //ios short cut url encode is bad,so manual.
        let filename = urlencoding::encode(&filename);
        ret.push_str(&filename);
        ret.push('\n');
    }
    if !ret.is_empty() {
        ret.pop();
    }
    ret
}
async fn done(State(state):State<MyState>){
    state.stream.add("done".to_string()).unwrap();
}

async fn run_server(listener: TcpListener, path: String, token: CancellationToken,stream:StreamSink<String>) {
    let serve_dir = ServeDir::new(&path);
    let app=Router::new()
        .nest_service("/files", serve_dir)
        .route("/list", get(list))
        .route("/decode", post(decode))
        .route("/done", get(done))
        .with_state(MyState{
            stream,
            path
        });
    axum::serve(tokio::net::TcpListener::from_std(listener).unwrap(), app)
        .with_graceful_shutdown(token.cancelled_owned())
        .await
        .unwrap();
}

fn bind_until_success() -> (TcpListener, u16) {
    let mut port = 8080;
    loop {
        if let Ok(listener) = std::net::TcpListener::bind(("0.0.0.0", port)) {
            break (listener, port);
        } 
        port += 1;
    }
}


#[derive(Clone)]
#[frb(opaque)]
struct StreamMetrics {
    stream: StreamSink<i32>,
}

impl StreamMetrics {
    fn new(stream: StreamSink<i32>) -> Self {
        Self { stream }
    }
}
impl Metrics for StreamMetrics {
    fn tick(&self, _msg: &str, index: usize) {
        self.stream.add(index as _).unwrap();
    }
    fn finish(self) {}
}

pub struct Zipo {
    z: ZipDir,
    pub dst_dir: String,
}
impl Zipo {
    #[frb(sync)]
    pub fn new(src_dir: String, dst_dir: String) -> Self {
        let settings = Settings::new().unwrap();
        let dst_dir_path: &Path = dst_dir.as_ref();
        let z = ZipDir::new(src_dir, &dst_dir_path, settings).unwrap();
        Self { z, dst_dir }
    }
    #[frb(sync)]
    pub fn get_list(&self) -> Vec<String> {
        self.z.get_src_dir()
    }

    pub fn run(&mut self, stream: StreamSink<i32>) {
        self.z.run(StreamMetrics::new(stream));
    }
    #[frb(sync)]
    pub fn get_web_server(self) -> WebHandle{
        let token = CancellationToken::new();
        let (listener, port) = bind_until_success();
        let ip = local_ip().unwrap().to_string();
        let url = format!("http://{}:{}", ip, port);
        WebHandle {
            token,
            url,
            listener:Some(listener),
            dst_dir: self.dst_dir.clone(),
        }

    }

}
pub struct WebHandle {
    token: CancellationToken,
    pub url: String,
    listener : Option<TcpListener>,
    dst_dir:String,
}
impl WebHandle {
    #[frb(sync)]
    pub fn cancel_server(self) {
        self.token.cancel();
    }
    
    pub fn run(&mut self,stream:StreamSink<String>){
        let listener = self.listener.take().unwrap();
        let path = self.dst_dir.clone();
        let token = self.token.clone(); 

        std::thread::spawn(move||{
            // need new Runtime ,FLUTTER_RUST_BRIDGE_HANDLER.async_runtime() have error,maybe stream blocked runtime?
            Runtime::new().unwrap().block_on(
                run_server(listener, path, token, stream)
            );
        });
    }
}

#[frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}
