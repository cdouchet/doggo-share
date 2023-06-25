use leptos::*;
use leptos_dom::*;
use web_sys::MouseEvent;

use crate::components::doggo_button::DoggoButton;

#[component]
pub fn NextButton<T>(cx: Scope, visible: bool, onclick: T) -> impl IntoView
where
    T: Fn(MouseEvent) -> () + 'static,
{

    if visible {
        return view! {
            cx,
            <div>
                <DoggoButton text="Envoyer".to_string() onclick=onclick />
            </div>
        };
    } else {
        return view! {
            cx,
            <div>
            </div>
        };
    }
}
