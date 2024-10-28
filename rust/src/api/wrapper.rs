use std::{net::SocketAddr, path::Path};

use axum::{
    routing::get,
    Router,
};
use flutter_rust_bridge::{frb, BaseAsyncRuntime};
use local_ip_address::local_ip;
use tokio_util::sync::CancellationToken;
use tower_http::services::ServeDir;
use zipo_lib::{Metrics,Settings, ZipDir};
use crate::frb_generated::FLUTTER_RUST_BRIDGE_HANDLER;

fn list(path: String) -> String {
    let dir = std::fs::read_dir(path).unwrap();
    let mut ret = String::new();

    for entry in dir {
        let entry = entry.unwrap();
        let path = entry.path();
        if path.extension().unwrap() != "zip" {
            continue;
        }
        let filename = path.file_name().unwrap().to_string_lossy();
        ret.push_str(&filename);
        ret.push('\n');
    }
    if !ret.is_empty() {
        ret.pop();
    }
    ret
}

fn get_app(path: &str) -> Router {
    let serve_dir = ServeDir::new(path);
    let path = path.to_string();
    Router::new()
        .route("/list", get(move || async { list(path) }))
        .nest_service("/files", serve_dir)
}


async fn _run_server(port:u16,path:String,token:CancellationToken){
    let app = get_app(&path);
    let addr = SocketAddr::from(([0, 0, 0, 0], port));
    let listener = tokio::net::TcpListener::bind(addr).await.unwrap();
    axum::serve(listener, app).with_graceful_shutdown(token.cancelled_owned()).await.unwrap();
}

pub struct WebHandle{
    token:CancellationToken,
    pub url:String
}
impl WebHandle{
    #[frb(sync)]
    pub fn cancel_server(&self){
        self.token.cancel();
    }
}

#[frb(sync)]
pub fn run_web_server(port:u16,path:String) ->WebHandle{
    let token = CancellationToken::new();
    let cloned_token = token.clone();
    FLUTTER_RUST_BRIDGE_HANDLER.async_runtime().spawn(_run_server(port,path,cloned_token));
    let ip = local_ip().unwrap().to_string();
    let url=format!("http://{}:{}",ip,port);
    
    WebHandle{token,url}
}
#[derive(Clone)]
#[frb(opaque)]
struct LogMetrics;
impl Metrics for LogMetrics{
    fn tick(&self,msg:&str){
        log::debug!("{}",msg);
    }
    fn finish(self){}
}

pub fn zip_dir(src_dir:String,dst_dir:String)->anyhow::Result<()>{
    let settings = Settings::new()?;
    let dst_dir :&Path = dst_dir.as_ref();
    let mut zipo = ZipDir::new(src_dir, dst_dir, settings)?;
    zipo.run(LogMetrics);
    
    Ok(())
}

#[frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}
