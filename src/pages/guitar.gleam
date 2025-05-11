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
      thumbnail(
        "Girl From The North Country",
        "Bob Dylan",
        "https://cdn.ryanbrewer.dev/girl-from-the-north-country.mp4",
      ),
      thumbnail(
        "Bless the Telephone",
        "Labi Siffre",
        "https://cdn.ryanbrewer.dev/bless-the-telephone.mp4",
      ),
      thumbnail(
        "Homeward Bound",
        "Simon and Garfunkel",
        "https://cdn.ryanbrewer.dev/homeward-bound.mp4",
      ),
      thumbnail(
        "The Only Living Boy in New York",
        "Simon and Garfunkel",
        "https://cdn.ryanbrewer.dev/the-only-living-boy-in-new-york.mp4",
      ),
    ]),
    tail(),
  ])
}

fn thumbnail(name: String, artist: String, url: String) -> Element(Nil) {
  html.div([], [
    html.h3([], [text(name)]),
    html.div([attribute.class("subtle-text")], [text(artist)]),
    html.video(
      [
        attribute.width(400),
        attribute.controls(True),
        attribute.style([#("margin-top", "15pt")]),
      ],
      [
        html.source([attribute.src(url), attribute.type_("video/mp4")]),
        text("Your browser doesn't support HTML video, unfortunately."),
      ],
    ),
  ])
}
