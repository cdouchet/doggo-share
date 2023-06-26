use std::time::Duration;

use dotenvy::dotenv;
use lazy_static::lazy_static;
use serde::{Deserialize, Serialize};

lazy_static! {
    pub static ref HTTP_CLIENT: reqwest_wasm::Client = reqwest_wasm::ClientBuilder::new()
        // .connect_timeout(Duration::from_secs(30))
        // .gzip(true)
        .build()
        .expect("Could not build HTTP client");
    // pub static ref BASE_URL: String = {
    //     std::env!("BASE_URL").expect("BASE_URL env var must be set")};
}

#[derive(Serialize, Deserialize, Clone)]
pub enum DoggoClientError {
    InvalidIdFormat,
    ServerError,
    InvalidClientParsing,
}
