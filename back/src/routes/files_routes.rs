use std::{
    fs::{self, File},
    str::FromStr,
};

use actix_multipart::form::MultipartForm;
use actix_web::{
    web::{self, Data, Json},
    HttpRequest, HttpResponse,
};
use diesel::{
    query_dsl::methods::FilterDsl, BoolExpressionMethods, ExpressionMethods, RunQueryDsl,
};
use doggo_share_models::{doggo_file::{DoggoFile}, handlers::error::DoggoError};
use serde::Deserialize;
use uuid::Uuid;

use crate::{
    db::Pool,
    models::{
        form::UploadMultipart,
        response::{DoggoResponse, file::NewDoggoFile},
    },
    utils::{BASE_URL, CARGO_MANIFEST_DIR},
};

pub async fn get_asset_links_json<'b>(req: HttpRequest) -> Result<HttpResponse, DoggoError<'b>> {
    let file = match actix_files::NamedFile::open_async(
        format!("{}/../assetlinks.json", *CARGO_MANIFEST_DIR),
    )
    .await
    {
        Ok(r) => r,
        Err(err) => {
            eprintln!("Error getting assetlinks.json file: {err}");
            return Err(DoggoError::not_found());
        }
    };
    return Ok(file.into_response(&req));
}

#[get("/apple-app-site-association")]
pub async fn get_apple_app_site_association<'b>(
    req: HttpRequest,
) -> Result<HttpResponse, DoggoError<'b>> {
    let file = match actix_files::NamedFile::open_async(
        format!("{}/../apple-app-site-association", *CARGO_MANIFEST_DIR),
    )
    .await
    {
        Ok(r) => r,
        Err(err) => {
            eprintln!("Error getting apple file: {err}");
            return Err(DoggoError::not_found());
        }
    };
    return Ok(file.into_response(&req));
}


#[get("/assets/{name}")]
pub async fn get_asset<'b>(
    name: web::Path<String>,
    req: HttpRequest
) -> Result<HttpResponse, DoggoError<'b>> {
    let name = name.into_inner();
    let file = match actix_files::NamedFile::open_async(format!("{}/art/{}", *CARGO_MANIFEST_DIR, name)).await {
        Ok(r) => r,
        Err(err) => return Err(DoggoError::not_found())
    };
    Ok(file.into_response(&req))
}

#[get("/file/info/{id}")]
pub async fn get_file_info<'a, 'b>(
    path: web::Path<String>,
    pool: web::Data<Pool>,
) -> Result<Json<DoggoResponse<'a, DoggoFile>>, DoggoError<'b>> {
    let id = path.into_inner();
    let uid = match Uuid::from_str(&id) {
        Ok(uid) => uid,
        Err(_) => return Err(DoggoError::invalid_id_format()),
    };
    use crate::schema::files;
    let conn = &mut pool.get().unwrap();
    match files::table
        .filter(files::id.eq(uid))
        .get_result::<DoggoFile>(conn)
    {
        Ok(f) => {
            return Ok(Json(DoggoResponse {
                description: "Associated file",
                data: f,
            }))
        }
        Err(_) => {
            return Err(DoggoError::not_found());
        }
    }
}

#[get("/f/{id}/{name}")]
pub async fn get_file<'a, 'b>(
    req: HttpRequest,
    path: web::Path<(String, String)>,
    pool: Data<Pool>,
) -> Result<HttpResponse, DoggoError<'b>> {
    let (id, name) = path.into_inner();
    let uid = match Uuid::from_str(&id) {
        Ok(uid) => uid,
        Err(_) => return Err(DoggoError::invalid_id_format()),
    };
    use crate::schema::files;
    let conn = &mut pool.get().unwrap();
    match files::table
        .filter(files::id.eq(uid).and(files::name.eq(&name)))
        .get_result::<DoggoFile>(conn)
    {
        Ok(f) => {
            let file = match actix_files::NamedFile::open_async(f.local_url).await {
                Ok(r) => r,
                Err(_) => return Err(DoggoError::not_found()),
            };
            return Ok(file.into_response(&req));
        }
        Err(err) => match err {
            diesel::result::Error::NotFound => return Err(DoggoError::not_found()),
            _ => return Err(DoggoError::internal_server_error()),
        },
    }
}

#[post("/files")]
pub async fn upload_file<'a, 'b>(
    form: MultipartForm<UploadMultipart>,
    pool: Data<Pool>,
) -> Result<Json<DoggoResponse<'a, DoggoFile>>, DoggoError<'b>> {
    let id = Uuid::new_v4();
    let mime = match form.name().split('.').last() {
        Some(m) => m,
        None => "",
    };
    let local_url = format!("{}/files/{}.{}", *CARGO_MANIFEST_DIR, id, mime);
    // while let Some(e) = form.next().await {
    //     println!("test");
    //     match e {
    //         Ok(f) => {
    //             println!("ok");
    //             all_fields.push(f);
    //             println!("hello");
    //         }
    //         Err(err) => {
    //             println!("bad");
    //             eprintln!("Error in parsing form data: {err}");
    //             return Err(DoggoError::bad_request("Invalid Multipart form-data"));
    //         }
    //     }
    // }
    let temp_path = form.file.file.path();
    File::create(&local_url).expect("Could not create file");
    fs::copy(temp_path, &local_url).expect("Could not copy temp file into persitent file");
    // let form_file = form.file;

    // form.file.file.persist(&local_url);
    let file_name = form.name();

    let net_url = format!("{}/f/{}/{}", BASE_URL.to_string(), id, file_name);
    let new_file = NewDoggoFile {
        id,
        name: String::from(file_name),
        net_url,
        local_url: local_url.clone(),
    };
    use crate::schema::files;
    let conn = &mut pool.get().unwrap();
    match diesel::insert_into(files::table)
        .values(new_file)
        .get_result::<DoggoFile>(conn)
    {
        Ok(file) => {
            return Ok(Json(DoggoResponse {
                data: file,
                description: "Returned file",
            }))
        }
        Err(err) => {
            eprintln!("{err}");
            return Err(DoggoError::internal_server_error());
        }
    }
}

#[get("/files")]
pub async fn all_files<'a, 'b>(
    pool: Data<Pool>,
) -> Result<Json<DoggoResponse<'a, Vec<DoggoFile>>>, DoggoError<'b>> {
    let loaded_files = DoggoFile::get_all(pool)?;
    Ok(Json(DoggoResponse {
        data: loaded_files,
        description: "All files",
    }))
}
