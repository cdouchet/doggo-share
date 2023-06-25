use yew::{function_component, Html, html};

#[function_component]
pub fn Logo() -> Html {
    html! {
        <img src="assets/logo-transparent.png" alt="Doggo Share Logo" />
    }
}