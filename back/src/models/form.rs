use actix_multipart::form::{MultipartForm, tempfile::TempFile, text::Text};

#[derive(MultipartForm)]
pub struct UploadMultipart {
    name: Text<String>,
    #[multipart(rename = "file")]
    pub file: TempFile
}

impl<'a> UploadMultipart {
    pub fn name(&'a self) -> &'a str {
        &self.name.0
    }
}