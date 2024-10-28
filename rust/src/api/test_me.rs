use crate::frb_generated::StreamSink;


fn test_send<T:Send>(_:T){}


fn stream(s:StreamSink<i32>){
    test_send(s);
}