
use std::time::Duration;

use lazy_static::lazy_static;
use serde::{Serialize, Deserialize};

lazy_static! {
    pub static ref HTTP_CLIENT: reqwest_wasm::Client = reqwest_wasm::ClientBuilder::new()
        // .connect_timeout(Duration::from_secs(30))
        // .gzip(true)
        .build()
        .expect("Could not build HTTP client");
}

#[derive(Serialize, Deserialize, Clone)]
pub enum DoggoClientError {
    InvalidIdFormat,
    ServerError,
    InvalidClientParsing
}