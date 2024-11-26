use std::{net::TcpListener, path::Path};

use crate::frb_generated::{StreamSink, FLUTTER_RUST_BRIDGE_HANDLER};
use axum::{
    extract::State,
    routing::{get, post},
    Json, Router,
};
use flutter_rust_bridge::{frb, BaseAsyncRuntime};
use local_ip_address::local_ip;
use serde::Deserialize;
use tokio::runtime::Runtime;
use tokio_util::sync::CancellationToken;
use tower_http::services::ServeDir;
use zipo_lib::{Metrics, Rule, Settings, ZipDir};

#[frb(opaque)]
pub struct ZipoSettings {
    settings: Settings,
}
impl ZipoSettings {
    #[frb(sync)]
    pub fn new() -> Self {
        let settings = Settings::new();
        Self { settings }
    }
    #[frb(sync)]
    pub fn set_separate(&mut self) {
        self.settings.set_separate();
    }
    #[frb(sync)]
    pub fn push_rule(&mut self, filename: String, excludes: Vec<String>) {
        let rule = Rule::new(&filename, &excludes);
        self.settings.push_rule(rule);
    }
}

#[derive(Clone)]
struct MyState {
    path: String,
    stream: StreamSink<String>,
}
#[derive(Deserialize)]
struct DecodeRequest {
    filename: String,
}

async fn decode(Json(DecodeRequest { filename }): Json<DecodeRequest>) -> String {
    urlencoding::decode(&filename).unwrap().into()
}

async fn list(State(state): State<MyState>) -> String {
    state.stream.add("start".to_string()).unwrap();
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
async fn stop(State(state): State<MyState>) {
    state.stream.add("stop".to_string()).unwrap();
}

async fn run_server(
    listener: TcpListener,
    path: String,
    token: CancellationToken,
    stream: StreamSink<String>,
) {
    let serve_dir = ServeDir::new(&path);
    let app = Router::new()
        .nest_service("/files", serve_dir)
        .route("/list", get(list))
        .route("/decode", post(decode))
        .route("/stop", get(stop))
        .with_state(MyState { stream, path });
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
    pub fn new(src_dir: String, dst_dir: String, settings: &ZipoSettings) -> Self {
        let dst_dir_path: &Path = dst_dir.as_ref();
        let z = ZipDir::new(src_dir, &dst_dir_path, settings.settings.clone()).unwrap();
        Self { z, dst_dir }
    }
    #[frb(sync)]
    pub fn get_list(&self) -> Vec<String> {
        self.z.get_src_dir()
    }

    pub fn run(&mut self, stream: StreamSink<i32>) {
        self.z.run(StreamMetrics::new(stream));
    }
    pub fn clear(self) {
        std::fs::remove_dir_all(self.dst_dir).unwrap();
    }
    #[frb(sync)]
    pub fn get_web_server(&self) -> WebHandle {
        let token = CancellationToken::new();
        let (listener, port) = bind_until_success();
        let ip = local_ip().unwrap().to_string();
        let url = format!("http://{}:{}", ip, port);
        WebHandle {
            token,
            url,
            listener: Some(listener),
            dst_dir: self.dst_dir.clone(),
        }
    }
}
pub struct WebHandle {
    token: CancellationToken,
    pub url: String,
    listener: Option<TcpListener>,
    dst_dir: String,
}
impl WebHandle {
    #[frb(sync)]
    pub fn cancel_server(self) {
        self.token.cancel();
    }

    pub fn run(&mut self, stream: StreamSink<String>) {
        let listener = self.listener.take().unwrap();
        let path = self.dst_dir.clone();
        let token = self.token.clone();
        // FLUTTER_RUST_BRIDGE_HANDLER
        //     .async_runtime()
        //     .spawn(run_server(listener, path, token, stream));

        std::thread::spawn(move || {
            // need new Runtime ,FLUTTER_RUST_BRIDGE_HANDLER.async_runtime() have error,maybe stream blocked runtime?
            let runtime = Runtime::new().unwrap();
            let _guard = runtime.enter();
            runtime.block_on(run_server(listener, path, token, stream));
            log::debug!("web server cancel");
        });
    }
}

#[frb(init)]
pub fn init_app() {
    // use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};
    // tracing_subscriber::registry()
    // .with(
    //     tracing_subscriber::EnvFilter::try_from_default_env()
    //         .unwrap_or_else(|_| format!("{}=trace", "zipo").into()),
    // )
    // .with(tracing_subscriber::fmt::layer())
    // .init();
    flutter_rust_bridge::setup_default_user_utils();
}
