pub trait Metrics: Clone + Send {
    fn tick(&self, msg: &str, index: usize);
    fn finish(self) {}
}
#[derive(Clone)]
pub struct NoMetrics;
impl Metrics for NoMetrics {
    fn tick(&self, _msg: &str, _index: usize) {}
}
