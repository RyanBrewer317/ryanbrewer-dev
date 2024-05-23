import lustre
import lustre/attribute.{href}
import lustre/element.{type Element, text}
import lustre/element/html.{a, div, p}
import lustre/event
import tinylang
import tinytypedlang

// import party as p
// import gleam/result
// import gleam/string

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(dispatch) = lustre.start(app, "[data-lustre-app]", Nil)

  dispatch
}

type Model {
  Model(code: String, is_typed: Bool)
}

fn init(_) -> Model {
  Model("", False)
}

pub type Msg {
  NewCode(String)
  SetTyping(Bool)
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    NewCode(code) -> Model(code: code, is_typed: model.is_typed)
    SetTyping(typed) -> Model(code: model.code, is_typed: typed)
  }
}

fn view(model: Model) -> Element(Msg) {
  div([], [
    html.div([], [
      html.div([attribute.id("ryan-and-ivy-img")], [
        html.img([attribute.src("/ryan-and-ivy.jpg"), attribute.width(300)]),
        html.div([attribute.class("caption")], [
          text("Me and my lovely wife, Ivy!"),
        ]),
      ]),
      html.div([], [
        html.h3([], [text("Me.")]),
        p([], [
          text(
            "I'm Ryan Brewer.
I'm a passionate software developer working on open-source software 
for safe, reliable, and portable applications.
I specialize in a formal methods approach to systems design, with a focus on ergonomics.
My current biggest project is ",
          ),
          a([href("https://github.com/RyanBrewer317/SaberVM")], [
            text("SaberVM"),
          ]),
          text(
            ",
a lightweight abstract machine for functional languages that aims 
to be formally memory-safe, fault-tolerant, and very small. 
With SaberVM, I'm hoping to broaden accessibility to safe computation, 
both by taking it out of the ivory tower of academia and 
by removing the need for expensive hardware.
Consider supporting my work!
",
          ),
        ]),
        a(
          [
            attribute.id("github"),
            href("https://github.com/sponsors/RyanBrewer317"),
          ],
          [
            html.img([
              attribute.src("/github-logo.png"),
              attribute.alt("GitHub logo"),
              attribute.id("github-logo"),
            ]),
            html.span([], [text("Sponsor")]),
          ],
        ),
        a([attribute.id("kofi"), href("https://ko-fi.com/ryanbrewer")], [
          html.img([
            attribute.src("/kofi-logo.png"),
            attribute.alt("Ko-fi logo"),
            attribute.id("kofi-logo"),
          ]),
          html.span([], [text("Support")]),
        ]),
      ]),
    ]),
    html.h3([attribute.style([#("padding-top", "50pt")])], [text("My Website")]),
    p([], [
      text(
        "This is my website.
I use this as a space to store my ideas, advertise myself and my work, and write blog posts about topics that I love.
Generally I constrain my posts to be about programming language theory or implementations. 
Links to my latest posts can be found below.
This website is hosted by Firebase and written in ",
      ),
      a([href("https://gleam.run")], [text("Gleam")]),
      text(", and the code is up on my "),
      a([href("https://github.com/RyanBrewer317/ryanbrewer-dev")], [
        text("github"),
      ]),
      text(". The only framework used is "),
      a([href("https://lustre.build/")], [text("Lustre")]),
      text("; I did all the scripting, markup, styles, and layout by hand."),
    ]),
    html.h3([attribute.style([#("padding-top", "50pt")])], [
      text("Lambda Calculus in Gleam"),
    ]),
    html.p([], [
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
    ]),
    p([], [
      text(
        "Want types in your lambda calculus?
You can check the box below to switch to a version with a fancy dependent type system!
Type annotations are introduced by ",
      ),
      html.code([], [text("let")]),
      text("-bindings, like "),
      html.code([], [text("let x: A = v; e")]),
      text(", lambdas, like "),
      html.code([], [text("\\x: A. e")]),
      text(", and Pi types, like "),
      html.code([], [text("forall x: A. B")]),
      text(". For lambdas and bindings, the types can often be "),
      a([href("https://ncatlab.org/nlab/show/bidirectional+typechecking")], [
        text("inferred"),
      ]),
      text(". The type of types is "),
      html.code([], [text("Type")]),
      text(", whose type is "),
      a([href("https://cs.brown.edu/courses/cs1951x/docs/logic/girard.html")], [
        text("also "),
        html.code([], [text("Type")]),
      ]),
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
    html.input([
      attribute.type_("checkbox"),
      attribute.id("is-typed"),
      event.on_check(SetTyping),
    ]),
    html.label([attribute.for("is-typed")], [text("dependent types")]),
    html.br([]),
    html.textarea([
      attribute.id("code"),
      attribute.placeholder(case model.is_typed {
        False ->
          "Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)(3)"
        True ->
          "Play with dependent types! Example: let id: forall a: Type. a->a = \\a.\\x.x; id(Int)(3)"
      }),
      event.on_input(NewCode),
    ]),
    html.br([]),
    {
      case model {
        Model("", _) -> text("")
        Model(code, _) ->
          case model.is_typed {
            False -> tinylang.go(code)
            True -> tinytypedlang.go(code)
          }
          |> fn(s) {
            div([], [
              html.strong([], [text("output")]),
              text(": "),
              div([attribute.id("code-output")], [text(s)]),
            ])
          }
      }
    },
  ])
}
