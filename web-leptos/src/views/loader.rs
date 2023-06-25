use doggo_share_web_helper::{
    models::{doggo_file::DoggoFile, doggo_response::DoggoResponse},
    utils::DoggoClientError,
};
use leptos::*;
use leptos_dom::*;
use wasm_bindgen::JsCast;
use web_sys::HtmlInputElement;

#[component]
pub fn Loader<T>(cx: Scope, on_data_received: T) -> impl IntoView
where
    T: Fn(Result<DoggoResponse<DoggoFile>, DoggoClientError>) + 'static,
{
    // fn send_data<T>(data: T) where T: Fn(Result<DoggoResponse<DoggoFile>, DoggoClientError>) + 'static {
    //     on_data_received(data);
    // }
    let doggo_upload_response = create_resource(
        cx,
        || (),
        |_| async move {
            let file = document()
                .get_element_by_id("doggo-input")
                .unwrap()
                .dyn_into::<HtmlInputElement>()
                .unwrap()
                .files()
                .unwrap()
                .get(0)
                .unwrap();
            let res = doggo_share_web_helper::api::post_file(gloo::file::File::from(file)).await;
            res
        },
    );

    view! {
        cx,
        <div>
            {move || match doggo_upload_response.read(cx) {
                None => view! { cx, <p>"Envoi de votre fichier"</p>},
                Some(res) => {
                    on_data_received(res);
                    view! {
                        cx,
                        <p>"Fichier envoyé !"</p>
                    }
                }
            }}
        </div>
    }
}
