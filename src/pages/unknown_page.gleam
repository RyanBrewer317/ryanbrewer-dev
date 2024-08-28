// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import components/head.{head}
import components/navbar.{navbar}
import components/tail.{tail}
import lustre/attribute
import lustre/element.{type Element, text}
import lustre/element/html

pub fn unknown_page() -> Element(Nil) {
  html.html([attribute.attribute("lang", "en")], [
    head("404 - Ryan Brewer", "Unknown Page", [
      html.link([attribute.rel("stylesheet"), attribute.href("/style.css")]),
    ]),
    html.body([], [
      navbar(),
      html.div([attribute.id("body")], [
        html.span([attribute.id("unknown-page-banner")], [
          text("Unknown Page (404)"),
        ]),
      ]),
      tail(),
    ]),
  ])
}
