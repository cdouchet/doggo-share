use doggo_share_web_helper::models::doggo_file::DoggoFile;
use uuid::Uuid;
use yew::{Component, html};

pub struct Home {
    last_links: Vec<DoggoFile>
}

pub enum Msg {
    AddLink(DoggoFile),
    RemoveLink(Uuid),
}

impl Component for Home {
    type Message = Msg;
    type Properties = ();

    fn create(ctx: &yew::Context<Self>) -> Self {
        Self {
            last_links: Vec::new()
        }
    }

    fn view(&self, ctx: &yew::Context<Self>) -> yew::Html {
        html! {
            <div id="home">
                
            </div>
        }
    }
}