use std::time::Duration;

use lazy_static::lazy_static;

lazy_static! {
    pub static ref HTTP_CLIENT: reqwest::Client = reqwest::ClientBuilder::new()
        .connect_timeout(Duration::from_secs(30))
        .gzip(true)
        .build()
        .expect("Could not build HTTP client");
}

pub enum DoggoClientError {
    InvalidIdFormat,
    ServerError
}