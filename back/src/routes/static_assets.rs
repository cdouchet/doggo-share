use actix_web::{HttpResponse, web, HttpRequest};
use doggo_share_models::handlers::error::DoggoError;

use crate::{ utils::CARGO_MANIFEST_DIR};

#[get("/art/{id}")]
pub async fn get_art<'a>(id: web::Path<String>, req: HttpRequest) -> Result<HttpResponse, DoggoError<'a>> {
    let id = match id.parse::<u8>() {
        Ok(id) => id,
        Err(_) => return Err(DoggoError::invalid_id_format())
    };
    let file = match actix_files::NamedFile::open_async(format!("{}/art/{}.png", *CARGO_MANIFEST_DIR, id)).await {
        Ok(f) => f,
        Err(_) => return Err(DoggoError::not_found())
    };
    Ok(file.into_response(&req))
}