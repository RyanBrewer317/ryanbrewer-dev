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
        "Kathy's Song",
        "Simon and Garfunkel",
        "https://cdn.ryanbrewer.dev/kathys-song.mp4",
      ),
      thumbnail(
        "Drifter's Wife",
        "JJ Cale",
        "https://cdn.ryanbrewer.dev/drifters-wife.mp4",
      ),
      thumbnail(
        "The Boxer",
        "Simon and Garfunkel",
        "https://cdn.ryanbrewer.dev/the-boxer.mp4",
      ),
      thumbnail(
        "Blues Run the Game",
        "Jackson C Frank",
        "https://cdn.ryanbrewer.dev/blues-run-the-game.mp4",
      ),
      thumbnail(
        "I Want To Be Alone (Dialogue)",
        "Jackson C Frank",
        "https://cdn.ryanbrewer.dev/i-want-to-be-alone.mp4",
      ),
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
        "Calico Skies",
        "Paul McCartney",
        "https://cdn.ryanbrewer.dev/calico-skies.mp4",
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
        attribute.style("margin-top", "15pt"),
      ],
      [
        html.source([attribute.src(url), attribute.type_("video/mp4")]),
        text("Your browser doesn't support HTML video, unfortunately."),
      ],
    ),
  ])
}
