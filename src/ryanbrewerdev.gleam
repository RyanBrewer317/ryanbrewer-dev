import gleam/int
import lustre
import lustre/element.{type Element, text}
import lustre/element/html.{a, body, button, div, nav, p}
import lustre/attribute.{href, id}
import lustre/event

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(dispatch) = lustre.start(app, "body", Nil)

  dispatch
}

type Model =
  Int

fn init(_) -> Model {
  0
}

pub type Msg {
  Incr
  Decr
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    Incr -> model + 1
    Decr -> model - 1
  }
}

fn view(model: Model) -> Element(Msg) {
  let count = int.to_string(model)

  body(
    [],
    [
      div(
        [],
        [
          nav([], [a([href("https://ryanbrewer.dev")], [text("Ryan Brewer")])]),
          div(
            [id("body")],
            [
              p(
                [],
                [
                  text(
                    "This is my website. It's hosted by Firebase and written mostly in Gleam, and the code is up on ",
                  ),
                  a(
                    [href("https://github.com/RyanBrewer317/ryanbrewer-dev")],
                    [text("my github")],
                  ),
                  text("."),
                ],
              ),
              p([], [text(count)]),
              p(
                [],
                [
                  button([event.on_click(Decr)], [text("-")]),
                  button([event.on_click(Incr)], [text("+")]),
                ],
              ),
              p(
                [],
                [
                  a(
                    [href("https://ryanbrewer.dev/posts/logic-in-types.html")],
                    [text("My first post!")],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      html.script([attribute.src("/__/firebase/8.10.1/firebase-app.js")], ""),
      html.script(
        [attribute.src("/__/firebase/8.10.1/firebase-analytics.js")],
        "",
      ),
      html.script([attribute.src("/__/firebase/init.js")], ""),
    ],
  )
}
