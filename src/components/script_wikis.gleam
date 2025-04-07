// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import arctic.{type CacheablePage}
import gleam/list
import gleam/string
import gleam/string_tree.{
  type StringTree, append, append_tree, concat, from_string, join, to_string,
}
import lustre/element.{type Element}
import lustre/element/html

pub fn script_wikis(wikis: List(CacheablePage)) -> Element(a) {
  use <-
    fn(k: fn() -> List(StringTree)) {
      html.script(
        [],
        from_string("const WIKIS = {")
          |> append_tree(concat(k()))
          |> append("};")
          |> to_string(),
      )
    }
  use cw <- list.map(wikis)
  let w = arctic.to_dummy_page(cw)
  from_string("\"")
  |> append(w.id)
  |> append("\": {\"id\": \"")
  |> append(w.id)
  |> append("\", \"url\": \"")
  |> append("/posts/" <> w.id)
  |> append("\", \"title\": \"")
  |> append(string.replace(each: "\"", with: "\\\"", in: w.title))
  |> append("\", \"tags\": [")
  |> append_tree(join(
    list.map(w.tags, fn(tag) {
      from_string("\"")
      |> append(tag)
      |> append("\"")
    }),
    ", ",
  ))
  |> append("]},\n")
}
