pub trait Metrics:Clone+Send {
    fn tick(&self,_msg:&str){}
    fn finish(self){}
}

#[derive(Clone)]
pub struct NoMetrics;

impl Metrics for NoMetrics{}
