// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import client/candle/main as candle
import client/tinylang
import client/tinytypedlang
import lustre
import lustre/attribute.{class, href, id, placeholder, style}
import lustre/element.{type Element, text}
import lustre/element/html.{a, br, code, div, h3, p, strong, textarea}
import lustre/event

type Model {
  Model(untyped_code: String, deptyped_code: String, candle_code: String)
}

pub type Msg {
  NewUntypedCode(String)
  NewDepTypedCode(String)
  NewCandleCode(String)
}

fn init(_) -> Model {
  Model("", "", "")
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    NewUntypedCode(code) -> Model(..model, untyped_code: code)
    NewDepTypedCode(code) -> Model(..model, deptyped_code: code)
    NewCandleCode(code) -> Model(..model, candle_code: code)
  }
}

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(dispatch) = lustre.start(app, "[data-lustre-app]", Nil)

  dispatch
}

fn view(model: Model) -> Element(Msg) {
  div([], [
    h3([style("padding-top", "50pt")], [text("Lambda Calculus in Gleam")]),
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
            "https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/client/tinylang.gleam",
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
      model.untyped_code,
    ),
    br([]),
    {
      case model {
        Model("", _, _) -> text("")
        Model(code, _, _) ->
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
            "https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/client/tinytypedlang.gleam",
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
      model.deptyped_code,
    ),
    br([]),
    {
      case model {
        Model(_, "", _) -> text("")
        Model(_, code, _) ->
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
    p([], [
      text(
        "Lastly, here's a simple proof assistant called Candle, implementing Andrew Marmaduke's ",
      ),
      a(
        [
          href(
            "https://iro.uiowa.edu/esploro/outputs/doctoral/A-proof-theoretic-redesign-of-the/9984697941302771",
          ),
        ],
        [text("PhD thesis")],
      ),
      text(". To see more example Candle code, check out this "),
      a(
        [
          href(
            "https://github.com/RyanBrewer317/candle_gleam/blob/f0dcb9f7368dd325c335acfd4deb2d2e86560b5f/candle/main.cd",
          ),
        ],
        [text("big file")],
      ),
      text("."),
    ]),
    br([]),
    textarea(
      [
        id("candle-code"),
        class("code"),
        placeholder(
          "Play with Candle! Example: 
let proof{A: Set}{B: Set}{x: A}{y: B}
  : (x = x) & (y = y)
  := [refl(x), refl(y)] in
2",
        ),
        event.on_input(NewCandleCode),
      ],
      model.candle_code,
    ),
    br([]),
    {
      case model {
        Model(_, _, "") -> text("")
        Model(_, _, code) ->
          candle.go(code)
          |> fn(s) {
            div([], [
              strong([], [text("output")]),
              text(": "),
              div([id("candle-code-output"), class("code-output")], [text(s)]),
            ])
          }
      }
    },
  ])
}
