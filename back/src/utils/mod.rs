use lazy_static::lazy_static;
use std::env::var;

lazy_static! {
    pub static ref BASE_URL: String = var("BASE_URL").expect("BASE_URL env var must be set");
    pub static ref CARGO_MANIFEST_DIR: String = var("CARGO_MANIFEST_DIR").expect("CARGO_MANIFEST_DIR env var must be set");
    pub static ref API_PORT: String = var("API_PORT").expect("API_POST env var must be set");
}