import * as $lustre from "../../lustre/lustre.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { class$, href, id, placeholder, style } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { a, br, code, div, h3, p, strong, textarea } from "../../lustre/lustre/element/html.mjs";
import * as $event from "../../lustre/lustre/event.mjs";
import * as $tinylang from "../client/tinylang.mjs";
import * as $tinytypedlang from "../client/tinytypedlang.mjs";
import { toList, CustomType as $CustomType, makeError } from "../gleam.mjs";

class Model extends $CustomType {
  constructor(untyped_code, deptyped_code) {
    super();
    this.untyped_code = untyped_code;
    this.deptyped_code = deptyped_code;
  }
}

export class NewUntypedCode extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

export class NewDepTypedCode extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

function init(_) {
  return new Model("", "");
}

function update(model, msg) {
  if (msg instanceof NewUntypedCode) {
    let code$1 = msg[0];
    return new Model(code$1, model.deptyped_code);
  } else {
    let code$1 = msg[0];
    return new Model(model.untyped_code, code$1);
  }
}

function view(model) {
  return div(
    toList([]),
    toList([
      h3(
        toList([style(toList([["padding-top", "50pt"]]))]),
        toList([text("Lambda Calculus in Gleam")]),
      ),
      p(
        toList([]),
        toList([
          text(
            "\nI study programming language design, and I'm particularly fond of functional programming.\nThat's why I made this website in ",
          ),
          a(toList([href("https://gleam.run")]), toList([text("Gleam")])),
          text(
            ",\na statically-typed functional language\nthat can run anywhere JavaScript can, as well as on Erlang's BEAM VM. \nI've used Gleam to write a lambda calculus evaluator that you can play with below. \nLambda abstractions are written like \n",
          ),
          code(toList([]), toList([text("\\var. body")])),
          text(", and are called like "),
          code(toList([]), toList([text("fun(arg)")])),
          text(". There are also positive integers like 7. Try writing "),
          code(toList([]), toList([text("(\\x.x)(2)")])),
          text(", which evaluates to 2. The code for this can be found "),
          a(
            toList([
              href(
                "https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/client/tinylang.gleam",
              ),
            ]),
            toList([text("here")]),
          ),
          text("."),
        ]),
      ),
      textarea(
        toList([
          id("untyped-code"),
          class$("code"),
          placeholder(
            "Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)(3)",
          ),
          $event.on_input((var0) => { return new NewUntypedCode(var0); }),
        ]),
        model.untyped_code,
      ),
      br(toList([])),
      (() => {
        if (model instanceof Model && model.untyped_code === "") {
          return text("");
        } else {
          let code$1 = model.untyped_code;
          let _pipe = $tinylang.go(code$1);
          return ((s) => {
            return div(
              toList([]),
              toList([
                strong(toList([]), toList([text("output")])),
                text(": "),
                div(
                  toList([id("untyped-code-output"), class$("code-output")]),
                  toList([text(s)]),
                ),
              ]),
            );
          })(_pipe);
        }
      })(),
      p(
        toList([]),
        toList([
          text(
            "Want types in your lambda calculus?\nYou can check the box below to switch to a version with a fancy dependent type system!\nType annotations are introduced by ",
          ),
          code(toList([]), toList([text("let")])),
          text("-bindings, like "),
          code(toList([]), toList([text("let x: A = v; e")])),
          text(", lambdas, like "),
          code(toList([]), toList([text("\\x: A. e")])),
          text(", and Pi types, like "),
          code(toList([]), toList([text("forall x: A. B")])),
          text(". For lambdas and bindings, the types can often be "),
          a(
            toList([
              href("https://ncatlab.org/nlab/show/bidirectional+typechecking"),
            ]),
            toList([text("inferred")]),
          ),
          text(". The type of types is "),
          code(toList([]), toList([text("Type")])),
          text(", whose type is "),
          a(
            toList([
              href(
                "https://cs.brown.edu/courses/cs1951x/docs/logic/girard.html",
              ),
            ]),
            toList([text("also "), code(toList([]), toList([text("Type")]))]),
          ),
          text(". The type of numbers is "),
          code(toList([]), toList([text("Int")])),
          text(". The code for this extended evaluator can be found "),
          a(
            toList([
              href(
                "https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/client/tinytypedlang.gleam",
              ),
            ]),
            toList([text("here")]),
          ),
          text("."),
        ]),
      ),
      br(toList([])),
      textarea(
        toList([
          id("deptyped-code"),
          class$("code"),
          placeholder(
            "Play with dependent types! Example: let id: forall a: Type. a->a = \\a.\\x.x; id(Int)(3)",
          ),
          $event.on_input((var0) => { return new NewDepTypedCode(var0); }),
        ]),
        model.deptyped_code,
      ),
      br(toList([])),
      (() => {
        if (model instanceof Model && model.deptyped_code === "") {
          return text("");
        } else {
          let code$1 = model.deptyped_code;
          let _pipe = $tinytypedlang.go(code$1);
          return ((s) => {
            return div(
              toList([]),
              toList([
                strong(toList([]), toList([text("output")])),
                text(": "),
                div(
                  toList([id("deptyped-code-output"), class$("code-output")]),
                  toList([text(s)]),
                ),
              ]),
            );
          })(_pipe);
        }
      })(),
    ]),
  );
}

export function main() {
  let app = $lustre.simple(init, update, view);
  let $ = $lustre.start(app, "[data-lustre-app]", undefined);
  if (!$.isOk()) {
    throw makeError(
      "let_assert",
      "client/demos",
      37,
      "main",
      "Pattern match failed, no pattern matched the value.",
      { value: $ }
    )
  }
  let dispatch = $[0];
  return dispatch;
}
