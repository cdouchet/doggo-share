use actix_web::{error, HttpResponse, http::header::ContentType};
use derive_more::Display;
use reqwest::StatusCode;

#[derive(Display, Debug)]
#[display(fmt = r#"{{"name": {}, "status_code": {}}}"#, name, status_code)]
pub struct DoggoError<'a> {
    name: &'a str,
    status_code: StatusCode,
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
    pub fn not_implemented() -> Self {
        Self {
            name: "Not implemented",
            status_code: StatusCode::BAD_REQUEST
        }
    }
    pub fn internal_server_error() -> Self {
        Self {
            name: "Internal Server Error",
            status_code: StatusCode::INTERNAL_SERVER_ERROR
        }
    }
}