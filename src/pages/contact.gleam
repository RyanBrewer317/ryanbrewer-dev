// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import components/navbar.{navbar}
import components/tail.{tail}
import lustre/attribute
import lustre/element.{type Element, text}
import lustre/element/html

pub fn contact() -> Element(Nil) {
  html.div([], [
    html.title([], "Contact - Ryan Brewer"),
    html.meta([
      attribute.name("description"),
      attribute.attribute("content", "Contact information"),
    ]),
    navbar(),
    html.div([attribute.id("body")], [
      html.p([], [text("ryanbrew317 at gmail")]),
    ]),
    tail(),
  ])
}
