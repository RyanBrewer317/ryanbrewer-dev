import lustre
import lustre/element.{type Element, text}
import lustre/element/html.{a, div, p}
import lustre/attribute.{href}
import lustre/event
import tinylang

// import party as p
// import gleam/result
// import gleam/string

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(dispatch) = lustre.start(app, "[data-lustre-app]", Nil)

  dispatch
}

type Model =
  String

fn init(_) -> Model {
  ""
}

pub type Msg {
  NewCode(String)
}

fn update(_model: Model, msg: Msg) -> Model {
  case msg {
    NewCode(code) -> code
  }
}

fn view(model: Model) -> Element(Msg) {
  div(
    [],
    [
      html.h3([], [text("My Website")]),
      p(
        [],
        [
          text(
            "This is my website. It's hosted by Firebase and written mostly in ",
          ),
          a([href("https://gleam.run")], [text("Gleam")]),
          text(", and the code is up on my "),
          a(
            [href("https://github.com/RyanBrewer317/ryanbrewer-dev")],
            [text("github")],
          ),
          text(". The only framework used is "),
          a([href("https://lustre.build/")], [text("Lustre")]),
          text("; scripting, markup, styles, and layout were all done by hand."),
        ],
      ),
      html.h3([], [text("Lambda Calculus in Gleam")]),
      html.p(
        [],
        [
          text(
            "
I study programming language design, and I'm particularly fond of functional programming.
That's why I made this website in ",
          ),
          a([href("https://gleam.run")], [text("Gleam")]),
          text(
            ",
a statically-typed functional language
that can run anywhere JavaScript can, as well as on Erlang's BEAM VM. 
I've used Gleam to write a lambda calculus evaluator that you can play with below. 
Lambda abstractions are written like 
",
          ),
          html.code([], [text("\\var. body")]),
          text(", and are called like "),
          html.code([], [text("fun(arg)")]),
          text(". There are also positive integers like 7. Try writing "),
          html.code([], [text("(\\x.x)(2)")]),
          text(", which evaluates to 2. The code for this can be found "),
          a(
            [
              href(
                "https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/tinylang.gleam",
              ),
            ],
            [text("here")],
          ),
          text("."),
        ],
      ),
      html.textarea([
        attribute.id("code"),
        attribute.placeholder(
          "Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)(3)",
        ),
        event.on_input(NewCode),
      ]),
      html.br([]),
      {
        case model {
          "" -> text("")
          code ->
            tinylang.go(code)
            // |> p.go(parse_output(), _)
            // |> result.unwrap(or: [
            //   text("There's a bug in this website! I can't show this output."),
            // ])
            |> fn(s) {
              div(
                [],
                [
                  html.strong([], [text("output ")]),
                  text(" (variables may be renamed): "),
                  div([attribute.id("code-output")], [text(s)]),
                ],
              )
            }
        }
      },
    ],
  )
}
/// this is legacy: the current lambda calculus implementation doesn't use subscripts.
// fn subscript_parser() -> p.Parser(Element(a), e) {
//   use _ <- p.do(p.char("_"))
//   use n <- p.do(p.map(p.many1(p.digit()), string.concat))
//   p.return(html.sub(
//     [attribute.style([#("font-size", "9pt"), #("margin-right", "1px")])],
//     [text(n)],
//   ))
// }

// fn normal_parser() -> p.Parser(Element(a), e) {
//   p.many(p.satisfy(fn(c) { c != "_" }))
//   |> p.map(string.concat)
//   |> p.map(text)
// }

// fn parse_output() -> p.Parser(List(Element(a)), e) {
//   p.many(p.alt(subscript_parser(), normal_parser()))
// }
