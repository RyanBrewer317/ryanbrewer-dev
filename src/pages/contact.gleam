// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import components/head
import components/navbar.{navbar}
import components/tail.{tail}
import lustre/attribute
import lustre/element.{type Element, text}
import lustre/element/html

pub fn contact() -> Element(Nil) {
  html.div([], [
    head.local_head("Contact", "Contact information"),
    navbar(),
    html.div([attribute.id("body")], [
      html.p([], [text("ryanbrew317 at gmail")]),
    ]),
    tail(),
  ])
}
