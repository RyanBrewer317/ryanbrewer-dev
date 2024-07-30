// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import helpers.{type Post, pretty_date}
import lustre/attribute.{attribute}
import lustre/element.{type Element, text}
import lustre/element/html

pub fn thumbnail(post: Post) -> Element(a) {
  html.li([attribute.class("post-thumbnail"), attribute.id(post.id)], [
    html.h3([], [
      html.a([attribute.href("posts/" <> post.id <> ".html")], [
        text(post.title),
      ]),
    ]),
    html.div([attribute.class("subtle-text")], [text(pretty_date(post.date))]),
    html.p([], [text(post.description)]),
  ])
}
