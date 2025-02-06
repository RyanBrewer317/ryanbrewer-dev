// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import lustre/attribute.{attribute}
import lustre/element.{type Element, text}
import lustre/element/html

pub fn navbar() -> Element(a) {
  html.nav([attribute.id("nav")], [
    html.div(
      [
        attribute.id("nav-dropdown"),
        attribute(
          "onclick",
          "document.getElementById('nav').classList.toggle('dropdown');document.body.classList.toggle('noscroll');",
        ),
      ],
      [text("☰")],
    ),
    html.a(
      [
        attribute.href("/"),
        attribute.id("nav-home"),
        attribute(
          "onclick",
          "document.getElementById('nav').classList.remove('dropdown');document.body.classList.remove('noscroll');",
        ),
      ],
      [text("Ryan Brewer")],
    ),
    html.a(
      [
        attribute.href("/posts"),
        attribute.id("nav-posts"),
        attribute(
          "onclick",
          "document.getElementById('nav').classList.remove('dropdown');document.body.classList.remove('noscroll');",
        ),
      ],
      [text("Posts")],
    ),
    html.a(
      [
        attribute.href("/wiki"),
        attribute.id("nav-wiki"),
        attribute(
          "onclick",
          "document.getElementById('nav').classList.remove('dropdown');document.body.classList.remove('noscroll');",
        ),
      ],
      [text("Wiki")],
    ),
    html.a(
      [
        attribute.href("/contact"),
        attribute.id("nav-contact"),
        attribute(
          "onclick",
          "document.getElementById('nav').classList.remove('dropdown');document.body.classList.remove('noscroll');",
        ),
      ],
      [text("Contact")],
    ),
    html.a(
      [
        attribute.href("/demos"),
        attribute.id("nav-demos"),
        attribute(
          "onclick",
          "document.getElementById('nav').classList.remove('dropdown');document.body.classList.remove('noscroll');",
        ),
      ],
      [text("Demos")],
    ),
    html.a(
      [
        attribute.href("/feed.rss"),
        attribute.id("nav-subscribe"),
        attribute.attribute("onclick", "window.location.href = '/feed.rss'"),
      ],
      [
        html.img([
          attribute.src("/rss-icon.png"),
          attribute.id("rss-subscribe-icon"),
        ]),
        text("Subscribe"),
      ],
    ),
  ])
}
