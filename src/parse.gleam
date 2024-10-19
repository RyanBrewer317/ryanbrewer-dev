// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import arctic.{type Page}
import arctic/parse
import arctic/plugin/diagram
import gleam/list
import gleam/result.{map_error}
import gleam/string
import lustre/attribute.{attribute}
import lustre/element.{text}
import lustre/element/html
import snag.{type Result}

pub fn parse(path: String, content: String) -> Result(Page) {
  parse.new(0)
  |> parse.add_inline_rule("*", "*", parse.wrap_inline(html.i))
  |> parse.add_inline_rule("`", "`", parse.wrap_inline(html.code))
  |> parse.add_inline_rule("[", "]", fn(el, args, data) {
    use url <- result.try(
      list.first(args)
      |> map_error(fn(_) { snag.new("bad parameters for link") }),
    )
    Ok(#(html.a([attribute.href(url)], [el]), parse.get_state(data)))
  })
  |> parse.add_prefix_rule("###", parse.wrap_prefix(html.h3))
  |> parse.add_static_component(
    "diagram",
    diagram.parse("public", fn(x) { x }, fn(x) { x }),
  )
  |> parse.add_static_component("code", fn(args, body, data) {
    let body2 = string.replace(body, "\\n", "\n")
    case args {
      [lang] ->
        Ok(#(
          html.pre([], [
            html.code([attribute.class("language-" <> lang)], [text(body2)]),
          ]),
          parse.get_state(data),
        ))
      _ ->
        Ok(#(
          html.pre([], [html.code([], [text(body2)])]),
          parse.get_state(data),
        ))
    }
  })
  |> parse.add_static_component("math", fn(_args, body, data) {
    use <- fn(k) { Ok(#(html.div([], k()), parse.get_state(data))) }
    use line <- list.map(string.split(body, on: "\n"))
    html.div([attribute.class("math-block")], [text("\\[" <> line <> "\\]")])
  })
  |> parse.parse(path, content)
}
