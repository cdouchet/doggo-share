use gloo::{
    file::{callbacks::FileReader, File},
    utils::document,
};
use std::fs::DirBuilder;
use web_sys::{Event, FileList, HtmlInputElement, MouseEvent, Element};
use yew::{html, use_memo, Callback, Component, Context, Html, TargetCast};

#[derive(Clone)]
struct FileDetails {
    name: String,
    file_type: String,
    data: Vec<u8>,
}

pub enum Msg {
    Loaded(String, String, Vec<u8>),
    DoggoFile(File),
    None,
}

pub struct DoggoInputFile {
    reader: Option<FileReader>,
    file: Option<FileDetails>,
}

impl Component for DoggoInputFile {
    type Message = Msg;
    type Properties = ();

    fn create(_: &Context<Self>) -> Self {
        Self {
            reader: None,
            file: None,
        }
    }

    fn update(&mut self, ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            Msg::Loaded(file_name, file_type, data) => {
                self.file = Some(FileDetails {
                    name: file_name.clone(),
                    file_type,
                    data,
                });
                self.reader = None;
                true
            }
            Msg::DoggoFile(file) => {
                let file_name = file.name();
                let file_type = file.raw_mime_type();
                let task = {
                    let link = ctx.link().clone();
                    let file_name = file_name.clone();
                    gloo::file::callbacks::read_as_bytes(&file, move |res| {
                        link.send_message(Msg::Loaded(
                            file_name,
                            file_type,
                            res.expect("Failed to read file"),
                        ))
                    })
                };
                self.reader = Some(task);
                true
            }
            _ => true,
        }
    }

    fn view(&self, ctx: &Context<Self>) -> yew::Html {
        html! {
            <div id="doggo-input-component">
                <input id="doggo-input" type="file" multiple={false} onchange={ctx.link().callback(move |e: Event| {
                    let input: HtmlInputElement = e.target_unchecked_into();
                    Self::upload_files(input.files())
                })} />
                if self.file.is_none() {
                    <p>{ "Choisissez un fichier" }</p>
                } else {
                    <p>{ self.file.clone().unwrap().name }</p>
                }
                <div style="width: 50px; height: 50px; background-color: black; color: white;" class="input-button" onclick={on_button_click}>
                    <p>{ "Choisissez vos fichiers" }</p>
                </div>
            </div>
        }
    }
}


fn on_button_click(_: MouseEvent) {
        // let input: Element = document().get_element_by_id("doggo-input").unwrap();
        // // let input = input.dyn_into::<HtmlInputElement>().unwrap();
        // let input: HtmlInputElement = document().get_element_by_id("doggo-input").unwrap();
        // input.click();
}


impl DoggoInputFile {
    fn upload_files(files: Option<FileList>) -> Msg {
        let mut result = Vec::<File>::new();

        if let Some(files) = files {
            let files = js_sys::try_iter(&files)
                .unwrap()
                .unwrap()
                .map(|v| web_sys::File::from(v.unwrap()))
                .map(File::from);
            result.extend(files);
        }
        if !result.is_empty() {
            return Msg::DoggoFile(result.first().unwrap().clone());
        }
        Msg::None
    }
}
