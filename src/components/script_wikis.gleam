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

pub fn script_wikis(wikis: List(Wiki)) -> Element(a) {
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
  use w <- list.map(wikis)
  from_string("\"")
  |> append(w.id)
  |> append("\": {\"id\": \"")
  |> append(w.id)
  |> append("\", \"url\": \"")
  |> append("/posts/" <> w.id)
  |> append("\", \"title\": \"")
  |> append(string.replace(each: "\"", with: "\\\"", in: w.title))
  |> append("\", \"tags\": [")
  |> append_builder(join(
    list.map(w.tags, fn(tag) {
      from_string("\"")
      |> append(tag)
      |> append("\"")
    }),
    ", ",
  ))
  |> append("]},\n")
}
