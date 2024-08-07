// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import arctic.{type Page}
import components/head.{head}
import components/navbar.{navbar}
import components/tail.{tail}
import gleam/option.{Some}
import helpers
import lustre/attribute.{attribute}
import lustre/element.{type Element, text}
import lustre/element/html

fn do(el: a, k: fn() -> List(a)) -> List(a) {
  [el, ..k()]
}

fn finally(end: List(a)) -> List(a) {
  end
}

fn render_post_as_list(post: Page) -> List(Element(Nil)) {
  use <- do(html.h1([], [text(post.title)]))
  let assert Some(date) = post.date
  use <- do(
    html.div([attribute.class("date")], [text(helpers.pretty_date(date))]),
  )
  finally(post.body)
}

fn render_wiki_as_list(wiki: Page) -> List(Element(Nil)) {
  use <- do(html.h1([], [text(wiki.title)]))
  finally(wiki.body)
}

pub fn post(post: Page) -> Element(Nil) {
  html.html([attribute("lang", "en")], [
    head(post.title, post.blerb, [
      html.script([attribute.type_("module")], "import '../../../style.css';"),
    ]),
    html.body([], [
      navbar(),
      html.div([attribute.id("body")], render_post_as_list(post)),
      tail(),
    ]),
  ])
}

pub fn wiki(wiki: Page) -> Element(Nil) {
  html.html([attribute("lang", "en")], [
    head(wiki.title, "", [
      html.script([attribute.type_("module")], "import '../../../style.css';"),
    ]),
    html.body([], [
      navbar(),
      html.div([attribute.id("body")], render_wiki_as_list(wiki)),
      tail(),
    ]),
  ])
}
