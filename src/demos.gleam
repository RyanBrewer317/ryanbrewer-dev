import components/head.{head}
import components/navbar.{navbar}
import components/tail.{tail}
import lustre
import lustre/attribute.{attribute, class, href, id, placeholder, style}
import lustre/element.{type Element, text}
import lustre/element/html.{
  a, body, br, code, div, h3, html, p, script, strong, textarea,
}
import lustre/event
import tinylang
import tinytypedlang

pub fn demos_page() -> Element(Nil) {
  html([attribute("lang", "en")], [
    head(
      "Demos - Ryan Brewer",
      "Interactive demonstrations of concepts from programming language theory",
      [
        script([attribute("type", "module")], "import '../style.css';"),
        script(
          [attribute("type", "module")],
          "import { main } from \"../src/demos.gleam\";
 document.addEventListener(\"DOMContentLoaded\", () => {
   const dispatch = main({});
 });",
        ),
      ],
    ),
    body([], [
      navbar(),
      div([id("body")], [div([attribute("data-lustre-app", "true")], [])]),
      tail(),
    ]),
  ])
}

type Model {
  Model(untyped_code: String, deptyped_code: String)
}

pub type Msg {
  NewUntypedCode(String)
  NewDepTypedCode(String)
}

fn init(_) -> Model {
  Model("", "")
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    NewUntypedCode(code) ->
      Model(untyped_code: code, deptyped_code: model.deptyped_code)
    NewDepTypedCode(code) ->
      Model(untyped_code: model.untyped_code, deptyped_code: code)
  }
}

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(dispatch) = lustre.start(app, "[data-lustre-app]", Nil)

  dispatch
}

fn view(model: Model) -> Element(Msg) {
  div([], [
    h3([style([#("padding-top", "50pt")])], [text("Lambda Calculus in Gleam")]),
    p([], [
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
      code([], [text("\\var. body")]),
      text(", and are called like "),
      code([], [text("fun(arg)")]),
      text(". There are also positive integers like 7. Try writing "),
      code([], [text("(\\x.x)(2)")]),
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
    ]),
    textarea(
      [
        id("untyped-code"),
        class("code"),
        placeholder(
          "Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)(3)",
        ),
        event.on_input(NewUntypedCode),
      ],
      "",
    ),
    br([]),
    {
      case model {
        Model("", _) -> text("")
        Model(code, _) ->
          tinylang.go(code)
          |> fn(s) {
            div([], [
              strong([], [text("output")]),
              text(": "),
              div([id("untyped-code-output"), class("code-output")], [text(s)]),
            ])
          }
      }
    },
    p([], [
      text(
        "Want types in your lambda calculus?
You can check the box below to switch to a version with a fancy dependent type system!
Type annotations are introduced by ",
      ),
      code([], [text("let")]),
      text("-bindings, like "),
      code([], [text("let x: A = v; e")]),
      text(", lambdas, like "),
      code([], [text("\\x: A. e")]),
      text(", and Pi types, like "),
      code([], [text("forall x: A. B")]),
      text(". For lambdas and bindings, the types can often be "),
      a([href("https://ncatlab.org/nlab/show/bidirectional+typechecking")], [
        text("inferred"),
      ]),
      text(". The type of types is "),
      code([], [text("Type")]),
      text(", whose type is "),
      a([href("https://cs.brown.edu/courses/cs1951x/docs/logic/girard.html")], [
        text("also "),
        code([], [text("Type")]),
      ]),
      text(". The type of numbers is "),
      code([], [text("Int")]),
      text(". The code for this extended evaluator can be found "),
      a(
        [
          href(
            "https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/tinytypedlang.gleam",
          ),
        ],
        [text("here")],
      ),
      text("."),
    ]),
    br([]),
    textarea(
      [
        id("deptyped-code"),
        class("code"),
        placeholder(
          "Play with dependent types! Example: let id: forall a: Type. a->a = \\a.\\x.x; id(Int)(3)",
        ),
        event.on_input(NewDepTypedCode),
      ],
      "",
    ),
    br([]),
    {
      case model {
        Model(_, "") -> text("")
        Model(_, code) ->
          tinytypedlang.go(code)
          |> fn(s) {
            div([], [
              strong([], [text("output")]),
              text(": "),
              div([id("deptyped-code-output"), class("code-output")], [text(s)]),
            ])
          }
      }
    },
  ])
}
