use leptos::*;
use web_sys::MouseEvent;

#[component]
pub fn Logo<T>(cx: Scope, onclick: T) -> impl IntoView where T: Fn(MouseEvent) -> () + 'static {
    view! {
        cx,
        <img on:click=onclick class="logo" src="https://doggo-share-api.doggo-saloon.net/assets/logo-icon.png" />
    }
}