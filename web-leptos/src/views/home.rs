use std::future::Future;

use doggo_share_web_helper::{
    models::{doggo_file::DoggoFile, doggo_response::DoggoResponse},
    utils::DoggoClientError,
};
use leptos::*;
use leptos_dom::*;
use rand::Rng;
use wasm_bindgen::JsCast;
use web_sys::{HtmlElement, HtmlInputElement, MouseEvent};

use crate::{
    components::{doggo_button::DoggoButton, logo::Logo, next_button::NextButton},
    views::loader::Loader, utils::show_copy_success,
};

#[component]
pub fn Home(cx: Scope) -> impl IntoView {
    // let home2 = document().get_element_by_id("home-2").unwrap().dyn_ref::<HtmlElement>().expect("error ").style();
    let random_number = rand::thread_rng().gen_range(0..4);

    // document()
    //     .get_element_by_id("home-2")
    //     .unwrap()
    // .dyn_into::<HtmlElement>()
    // .expect("Error parsing element")
    // .style()
    // .set_property(
    //     "background-image",
    //     &format!(
    //         "https://doggo-share.doggo-saloon.net/art/{}.png",
    //         random_number
    //     ),
    // ).expect("Could not set background-image property on home-2");

    // let onclick = move |e| {};

    let (file_name, set_file_name) = create_signal(cx, "Choisissez un fichier".to_string());
    let (visible_next, set_visible_next) = create_signal(cx, false);
    let (uploading, set_uploading) = create_signal(cx, false);
    let (file_res, set_file_res) =
        create_signal::<Option<Result<DoggoResponse<DoggoFile>, DoggoClientError>>>(cx, None);

    fn get_doggo_input() -> HtmlInputElement {
        document()
            .get_element_by_id("doggo-input")
            .unwrap()
            .dyn_into::<HtmlInputElement>()
            .unwrap()
    }

    let return_to_home = move |e| {
        set_uploading.update(|val| *val = false);
        set_file_res.update(|val| *val = None);
        set_visible_next.update(|val| *val = false);
        set_file_name.update(|val| *val = "Choisissez un fichier".to_string());
    };

    let onclick = move |e: MouseEvent| {
        let input = document().get_element_by_id("doggo-input").unwrap();
        let input = input.dyn_into::<HtmlInputElement>().unwrap();
        input.click();
    };

    let on_file_sent = move |res| {
        set_uploading.update(|val| *val = false);
        set_file_res.update(|val| *val = Some(res));
    };

    let onsend = move |e| {
        set_uploading.update(|val| *val = true);
    };

    let onchange = move |e| {
        let input = get_doggo_input();
        match input.files() {
            Some(files) => match files.get(0) {
                Some(f) => {
                    set_file_name.update(|value| *value = f.name());
                    set_visible_next.update(|val| *val = true);
                }
                None => {}
            },
            None => {}
        }
    };

    // view! {
    //     cx,
    //     <div id="doggo-input-div">
    //         <input id="doggo-input" type="file" multiple=false />
    //         <div on:click=onclick id="doggo-input-button">
    //             <p>"Add files !"</p>
    //         </div>
    //     </div>
    // }

    view! {
        cx,
        <div id="home">
        <input id="doggo-input" type="file" multiple=false on:change=onchange visible=false />
            <div id="home-1">
                <Logo onclick=return_to_home />
                {move || match uploading() {
                    true => view! {cx, <Loader on_data_received=on_file_sent /><div></div>},
                    false => match file_res() {
                    Some(res) => {
                        match res {
                            Ok(res) => {
                                // let net2 = res.data.net_url.clone();
                                let url = res.data.net_url.clone();

                                view! {
                                cx,
                                <h2>"Votre lien pour "<a target="_blank" rel="noopener noreferrer" href={url}>{res.data.name}</a>" est prêt"</h2>
                                <div style="height: 30px;"></div>
                                <DoggoButton text="Copier le lien".to_string() onclick=move |_e| {
                                    let window = web_sys::window().expect("No global 'window' exists");
                                    if cfg!(web_sys_unstable_apis) {
                                        let clipboard = window.navigator().clipboard().expect("No clipboard for this project");
                                        let _ = clipboard.write_text(&res.data.net_url);
                                        let _ = show_copy_success();
                                    }
                                } />
                                <div style="height: 30px;"></div>
                                <DoggoButton text="Terminer".to_string() onclick=return_to_home />
                            }},
                            Err(err) => view! {
                                cx,
                                <p>"Une erreur est survenue. Veuillez réessayer"</p>
                                <p></p>
                            }
                        }
                    },
                    None => view! {
                        cx,
                        <h3 id="title-phrase">"Doggo Share vous permet d'envoyer des fichiers sans limite de taille et à grande vitesse."</h3>
                    <p>{file_name}</p>
                    <DoggoButton text="Ajouter un fichier".to_string() onclick=onclick />
                    <div style="height: 60px;"></div>
                    {move || if visible_next() {
                        view! {
                            cx,
                            <div>
                                <DoggoButton text="Envoyer".to_string() onclick=onsend />
                            </div>
                        }
                    } else {
                        view! {
                            cx,
                            <div>
                            </div>
                        }
                    }}
                        }}
                    }}
            </div>
            <div id="home-2"></div>
            <div id="copy-pop-up">
                    <p>"Lien copié !"</p>
            </div>
        </div>
    }
}
