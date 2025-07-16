// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import arctic.{type CacheablePage}
import components/head
import components/navbar.{navbar}
import components/tail.{tail}
import components/thumbnail
import gleam/list
import lustre/attribute
import lustre/element.{type Element, text}
import lustre/element/html

pub fn projects(projects: List(CacheablePage)) -> Element(Nil) {
  html.div([], [
    head.local_head("Projects", "Ryan's various cool projects"),
    navbar(),
    html.div([attribute.id("body")], [
      html.h3([], [text("Projects")]),
      html.p([], [
        text(
          "
I'm a passionate software developer working on open-source software for safe, reliable, and portable applications. 
I specialize in a formal methods approach to systems design, with a focus on ergonomics.
Via minimality, I hope to make formal theory more accessible outside the ivory tower of academia, 
and easier to put into practice where it matters. 
If my projects seem cool or valuable in any way, consider supporting my work!
        ",
        ),
      ]),
      html.a(
        [
          attribute.id("github"),
          attribute.href("https://github.com/sponsors/RyanBrewer317"),
        ],
        [
          html.img([
            attribute.src("/github-logo.png"),
            attribute.alt("GitHub logo"),
            attribute.id("github-logo"),
          ]),
          html.span([], [text("Sponsor")]),
        ],
      ),
      html.a(
        [attribute.id("kofi"), attribute.href("https://ko-fi.com/ryanbrewer")],
        [
          html.img([
            attribute.src("/kofi-logo.png"),
            attribute.alt("Ko-fi logo"),
            attribute.id("kofi-logo"),
          ]),
          html.span([], [text("Support")]),
        ],
      ),
      html.p([], [text("(I haven't put all my projects here yet!)")]),
      html.ul([], list.map(projects, thumbnail.project)),
    ]),
    tail(),
  ])
}
