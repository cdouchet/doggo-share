use actix_web::{error, http::header::ContentType, HttpResponse};
use derive_more::Display;
use reqwest::StatusCode;

#[derive(Display, Debug)]
#[display(fmt = r#"{{"name": {}, "status_code": {}}}"#, name, status_code)]
pub struct DoggoError<'a> {
    name: &'a str,
    status_code: StatusCode,
}

impl<'a> From<diesel::result::Error> for DoggoError<'a> {
    fn from(value: diesel::result::Error) -> Self {
        match value {
            _ => DoggoError::internal_server_error(),
        }
    }
}

impl error::ResponseError for DoggoError<'_> {
    fn error_response(&self) -> HttpResponse {
        HttpResponse::build(self.status_code)
            .insert_header(ContentType::json())
            .body(self.to_string())
    }

    fn status_code(&self) -> StatusCode {
        self.status_code
    }
}

impl<'a> DoggoError<'a> {
    pub fn internal_server_error() -> Self {
        Self {
            name: "Internal Server Error",
            status_code: StatusCode::INTERNAL_SERVER_ERROR,
        }
    }

    pub fn bad_request(msg: &'a str) -> Self {
        Self {
            name: msg,
            status_code: StatusCode::BAD_REQUEST,
        }
    }

    pub fn not_implemented() -> Self {
        Self {
            name: "Not Implemented",
            status_code: StatusCode::INTERNAL_SERVER_ERROR,
        }
    }

    pub fn invalid_id_format() -> Self {
        Self {
            name: "Invalid ID format",
            status_code: StatusCode::BAD_REQUEST,
        }
    }

    pub fn not_found() -> Self {
        Self {
            name: "Not Found",
            status_code: StatusCode::NOT_FOUND,
        }
    }
}
