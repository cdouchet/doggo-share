use std::str::FromStr;

use actix_web::web::Json;
use uuid::Uuid;

use crate::{
    models::{doggo_file::DoggoFile, doggo_response::DoggoResponse},
    utils::{DoggoClientError, HTTP_CLIENT},
};

pub async fn get_file_info<'a>(
    id: &'a str,
) -> Result<Json<DoggoResponse<DoggoFile>>, DoggoClientError> {
    let id = match Uuid::from_str(&id) {
        Ok(r) => r,
        Err(err) => {
            eprintln!("Invalid Uuid parse. Err: {err}");
            return Err(DoggoClientError::InvalidIdFormat);
        }
    };
    let client = &HTTP_CLIENT;
    let request = client.get(format!(
        "http://doggo-share.doggo-saloon.net/file/info/{id}"
    ));
    let response = request.send().await;
    let response = match response {
        Ok(r) => r,
        Err(err) => {
            eprintln!("Error getting reponse from doggo share server. Err: {err}");
            return Err(DoggoClientError::ServerError);
        }
    };
    let parsed = response.json::<DoggoResponse<DoggoFile>>().await;
    match parsed {
        Ok(r) => Ok(Json(r)),
        Err(err) => {
            eprintln!("Invalid JSON response from server. Err: {err}");
            return Err(DoggoClientError::ServerError);
        }
    }
}

// pub async fn post_file() -> Result<Json<DoggoResponse<DoggoFile>>, DoggoClientError> {

// }