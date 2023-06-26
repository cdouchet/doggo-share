use std::str::FromStr;

use gloo::console::log;
// use gloo::file::File;
use reqwest_wasm::{
    header::CONTENT_TYPE,
    multipart::{Form, Part},
    ClientBuilder,
};
use uuid::Uuid;

use crate::{
    models::{doggo_file::DoggoFile, doggo_response::DoggoResponse},
    utils::{DoggoClientError, HTTP_CLIENT},
};

pub async fn get_file_info<'a>(id: &'a str) -> Result<DoggoResponse<DoggoFile>, DoggoClientError> {
    let id = match Uuid::from_str(&id) {
        Ok(r) => r,
        Err(err) => {
            eprintln!("Invalid Uuid parse. Err: {err}");
            return Err(DoggoClientError::InvalidIdFormat);
        }
    };
    let client = &HTTP_CLIENT;
    let request = client.get(format!(
        "{}/file/info/{id}", std::env!("BASE_URL")
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
        Ok(r) => Ok(r),
        Err(err) => {
            eprintln!("Invalid JSON response from server. Err: {err}");
            return Err(DoggoClientError::ServerError);
        }
    }
}

pub async fn post_file(
    file: gloo::file::File,
) -> Result<DoggoResponse<DoggoFile>, DoggoClientError> {
    // let file = tokio::fs::File::open(&file).await.unwrap();
    let client = ClientBuilder::new().build().unwrap();
    // let stream = file.stream();
    // let mut reader_stream = ReaderStream::new(file.stream());
    log!("File nameeeeeeeeeeeeeeeeeeeeeeeeee: {}", file.name());
    let form_data = Form::new()
        .part(
            "name",
            Part::text(file.name()).mime_str("text/plain").unwrap(),
        )
        .part(
            "file",
            Part::stream(
                gloo::file::futures::read_as_bytes(&file)
                    .await
                    .expect("Could not read file"),
            )
            .mime_str("application/octet-stream")
            .unwrap(),
        );
    // let cloned_form = Form::new()
    //     .part(
    //         "name",
    //         Part::text(file.name()).mime_str("text/plain").unwrap(),
    //     )
    //     .part(
    //         "file",
    //         Part::stream(
    //             gloo::file::futures::read_as_bytes(&file)
    //                 .await
    //                 .expect("Could not read file"),
    //         ),
    //     );
    // let boundary = form_data.boundary().clone();
    let response = client
        .post(format!("{}/files", std::env!("BASE_URL")))
        .multipart(form_data)
        // .header("Accept", "*/*")
        // .header("Accept-Encoding", "gzip, deflate, br")
        // .header("Connection", "keep-alive")
        // .header(
        //     CONTENT_TYPE,
        //     format!("multipart/form-data: boundary={}", form_data.boundary()),
        // )
        // .header("Content-Type", "multipart/form-data")
        .send()
        .await;

    match response {
        Ok(res) => {
            // let formatted = res
            //     .json::<DoggoResponse<DoggoFile>>()
            //     .await
            //     .expect("Could not parse response body");
            match res.text().await {
                Ok(body) => {
                    log!("Response body: {}", body.clone());
                    let formatted =
                        serde_json::from_str::<DoggoResponse<DoggoFile>>(&body).unwrap();
                    return Ok(formatted);
                }
                Err(err) => {
                    eprintln!("Error getting response body: {err}");
                    return Err(DoggoClientError::InvalidClientParsing);
                }
            }
        }
        Err(err) => {
            eprintln!("Err getting response: {err}");
            return Err(DoggoClientError::ServerError);
        }
    }
}

// pub async fn post_file() -> Result<Json<DoggoResponse<DoggoFile>>, DoggoClientError> {

// }
