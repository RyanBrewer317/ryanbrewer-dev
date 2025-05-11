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
      html.div([attribute.id("contact-img")], [
        html.img([attribute.src("/ryan-silly.jpg"), attribute.height(273)]),
      ]),
      html.h3([], [text("Ryan Brewer.")]),
      html.p([], [
        html.a(
          [
            attribute.href("https://github.com/RyanBrewer317"),
            attribute.class("contact-link"),
            attribute.target("_blank"),
            attribute.rel("noopener noreferrer"),
          ],
          [
            html.img([
              attribute.src("/github-logo.png"),
              attribute.alt("GitHub logo"),
              attribute.id("github-logo"),
            ]),
            html.span([], [text("GitHub")]),
          ],
        ),
      ]),
      html.p([], [
        html.a(
          [
            attribute.href("https://mathstodon.xyz/@ryanbrewer"),
            attribute.class("contact-link"),
            attribute.target("_blank"),
            attribute.rel("noopener noreferrer"),
          ],
          [
            html.img([
              attribute.src("/mastodon-logo.svg"),
              attribute.alt("Mastodon logo"),
              attribute.id("mastodon-logo"),
            ]),
            html.span([], [text("Mastodon")]),
          ],
        ),
      ]),
      html.p([], [
        html.a(
          [
            attribute.href("https://www.reddit.com/user/hoping1/"),
            attribute.class("contact-link"),
            attribute.target("_blank"),
            attribute.rel("noopener noreferrer"),
          ],
          [
            html.img([
              attribute.src("/reddit-logo.png"),
              attribute.alt("Reddit logo"),
              attribute.id("reddit-logo"),
            ]),
            html.span([], [text("Reddit")]),
          ],
        ),
      ]),
      html.p([], [
        html.a(
          [
            attribute.href("https://www.linkedin.com/in/ryan-brewer-361689156/"),
            attribute.class("contact-link"),
            attribute.target("_blank"),
            attribute.rel("noopener noreferrer"),
          ],
          [
            html.img([
              attribute.src("/linkedin-logo.png"),
              attribute.alt("LinkedIn logo"),
              attribute.id("linkedin-logo"),
            ]),
            html.span([], [text("LinkedIn")]),
          ],
        ),
      ]),
      html.p([], [
        html.a(
          [
            attribute.href("https://ko-fi.com/ryanbrewer"),
            attribute.class("contact-link"),
            attribute.target("_blank"),
            attribute.rel("noopener noreferrer"),
          ],
          [
            html.img([
              attribute.src("/kofi-logo.png"),
              attribute.alt("Ko-fi logo"),
              attribute.id("kofi-logo"),
            ]),
            html.span([], [text("Support")]),
          ],
        ),
      ]),
    ]),
    tail(),
  ])
}
