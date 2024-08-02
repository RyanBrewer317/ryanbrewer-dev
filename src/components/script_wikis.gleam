// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import gleam/list
import gleam/string
import gleam/string_builder.{
  type StringBuilder, append, append_builder, concat, from_string, join,
  to_string,
}
import helpers.{type Wiki}
import lustre/element.{type Element}
import lustre/element/html

pub fn script_wikis(posts: List(Wiki)) -> Element(a) {
  use <-
    fn(k: fn() -> List(StringBuilder)) {
      html.script(
        [],
        from_string("const WIKIS = {")
          |> append_builder(concat(k()))
          |> append("};")
          |> to_string(),
      )
    }
  use p <- list.map(posts)
  from_string("\"")
  |> append(p.id)
  |> append("\": {\"id\": \"")
  |> append(p.id)
  |> append("\", \"url\": \"")
  |> append("/posts/" <> p.id)
  |> append("\", \"title\": \"")
  |> append(string.replace(each: "\"", with: "\\\"", in: p.title))
  |> append("\", \"tags\": [")
  |> append_builder(join(
    list.map(p.tags, fn(tag) {
      from_string("\"")
      |> append(tag)
      |> append("\"")
    }),
    ", ",
  ))
  |> append("\"},\n")
}
