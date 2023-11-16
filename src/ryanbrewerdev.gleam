// import gleam/int
import lustre
import lustre/element.{text}
// import lustre/element/html
// import lustre/event

pub fn main() {
  let app = lustre.element(text("Hello, world!"))
  let assert Ok(_) = lustre.start(app, "[data-lustre-app]", Nil)

  Nil
}

// type Model = Int

// fn init(_) -> Model {
//     0
// }

// pub type Msg {
//     Incr
//     Decr
// }

// fn update(model: Model, msg: Msg) -> Model {
//     case msg {
//         Incr -> model + 1
//         Decr -> model - 1
//     }
// }

// fn view(model: Model) -> Element(Msg) {
//     let count = int.to_string(model)

//     html.body([], [
//         html.div([], [
//             html.p([], [element.text(count)]),
//             html.p([], [
//                 html.button([event.on_click(Decr)], [element.text("-")]),
//                 html.button([event.on_click(Incr)], [element.text("+")]),
//             ])
//         ])
//     ])
// }