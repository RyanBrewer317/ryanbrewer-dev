// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import components/head
import components/navbar.{navbar}
import components/tail.{tail}
import lustre/attribute
import lustre/element.{type Element, text}
import lustre/element/html

pub fn guitar() -> Element(Nil) {
  html.div([], [
    head.local_head("Guitar", "Ryan playing guitar"),
    navbar(),
    html.div([attribute.id("body")], [
      html.h3([], [text("Guitar")]),
      html.p([], [
        text(
          "
This is a page where I'll throw up some recordings of my covers and songs.
They aren't the most polished thing but they're mine and I'm proud of them :)
        ",
        ),
      ]),
    ]),
    tail(),
  ])
}
