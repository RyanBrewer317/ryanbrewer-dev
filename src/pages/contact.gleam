// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import components/head.{head}
import components/navbar.{navbar}
import components/tail.{tail}
import lustre/attribute
import lustre/element.{type Element, text}
import lustre/element/html

pub fn contact() -> Element(Nil) {
  html.html([attribute.attribute("lang", "en")], [
    head("Contact - Ryan Brewer", "Contact information", [
      html.link([attribute.rel("stylesheet"), attribute.href("/style.css")]),
    ]),
    html.body([], [
      navbar(),
      html.div([attribute.id("body")], [
        html.p([], [text("ryanbrew317 at gmail")]),
      ]),
      tail(),
    ]),
  ])
}
