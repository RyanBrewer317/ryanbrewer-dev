// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import arctic.{type CacheablePage}
import gleam/option.{Some}
import helpers.{pretty_date}
import lustre/attribute.{attribute}
import lustre/element.{type Element, text}
import lustre/element/html

pub fn post(cp: CacheablePage) -> Element(a) {
  let p = arctic.to_dummy_page(cp)
  let assert Some(date) = p.date
  html.li([attribute.class("post-thumbnail"), attribute.id(p.id)], [
    html.h3([], [html.a([attribute.href("../posts/" <> p.id)], [text(p.title)])]),
    html.div([attribute.class("subtle-text")], [text(pretty_date(date))]),
    html.p([], [text(p.blerb)]),
  ])
}

pub fn wiki(cw: CacheablePage) -> Element(Nil) {
  let w = arctic.to_dummy_page(cw)
  html.li([attribute.class("wiki-thumbnail"), attribute.id(w.id)], [
    html.h3([], [html.a([attribute.href("../wiki/" <> w.id)], [text(w.title)])]),
  ])
}

pub fn project(cp: CacheablePage) -> Element(a) {
  let p = arctic.to_dummy_page(cp)
  html.li([attribute.class("project-thumbnail"), attribute.id(p.id)], [
    html.h3([], [
      html.a([attribute.href("../projects/" <> p.id)], [text(p.title)]),
    ]),
    html.p([], [text(p.blerb)]),
  ])
}
