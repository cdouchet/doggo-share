use leptos::*;
use leptos_dom::*;
use web_sys::MouseEvent;

#[component]
pub fn DoggoButton<T>(cx: Scope, text: String, onclick: T) -> impl IntoView
where
    T: Fn(MouseEvent) -> () + 'static,
{
    view! {
        cx,
        <div class="doggo-button" on:click=onclick>
            <p class="doggo-button-text">{text}</p>
        </div>
    }
}
