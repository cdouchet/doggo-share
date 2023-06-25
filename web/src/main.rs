mod components;
mod views;

use components::doggo_input_file::DoggoInputFile;
use views::home::Home;

fn main() {
    yew::Renderer::<Home>::new().render();
}