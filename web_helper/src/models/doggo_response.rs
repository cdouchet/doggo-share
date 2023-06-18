use serde::Deserialize;

use super::doggo_file::DoggoFile;

#[derive(Deserialize)]
pub struct DoggoResponse<T> {
    pub description: String,
    pub data: T
}