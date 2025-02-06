// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import arctic.{type CacheablePage}
import components/head
import components/navbar.{navbar}
import components/tail.{tail}
import components/thumbnail
import gleam/list
import lustre/attribute.{href}
import lustre/element.{type Element, text}
import lustre/element/html

pub fn homepage(posts: List(CacheablePage)) -> Element(Nil) {
  html.div([], [
    head.local_head(
      "Ryan Brewer's Blog",
      "The place Ryan writes his thoughts and shows off cool projects!",
    ),
    navbar(),
    html.div([attribute.id("body")], [
      html.div([], [
        html.div([attribute.id("homepage-img")], [
          html.img([attribute.src("/ryan-silly.jpg"), attribute.width(340)]),
        ]),
        html.div([], [
          html.h3([], [text("Me.")]),
          html.p([], [
            text(
              "I'm Ryan Brewer.
I'm a passionate software developer working on open-source software 
for safe, reliable, and portable applications.
I specialize in a formal methods approach to systems design, with a focus on ergonomics.
In general, my projects aim to be formally memory-safe, fault-tolerant, and very lightweight. 
Via minimality, I hope to make formal theory more accessible outside the ivory tower of academia,
and easier to put into practice where it matters.
One of my bigger projects is ",
            ),
            html.a([href("https://arctic-framework.org")], [text("Arctic")]),
            text(
              ",
A friendly web framework for easily building fast web applications in Gleam!
Arctic powers this website, as well as the one I just linked.
",
            ),
          ]),
          html.a(
            [
              attribute.id("github"),
              href("https://github.com/sponsors/RyanBrewer317"),
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
          html.a([attribute.id("kofi"), href("https://ko-fi.com/ryanbrewer")], [
            html.img([
              attribute.src("/kofi-logo.png"),
              attribute.alt("Ko-fi logo"),
              attribute.id("kofi-logo"),
            ]),
            html.span([], [text("Support")]),
          ]),
        ]),
      ]),
      html.h3([attribute.style([#("padding-top", "50pt")])], [
        text("My Website"),
      ]),
      html.p([], [
        text(
          "This is my website.
I use this as a space to store my ideas, advertise myself and my work, and write blog posts about topics that I love.
Generally I constrain my posts to be about programming language theory or implementations. 
Links to my latest posts can be found below. I also have a useful ",
        ),
        html.a([href("/wiki")], [text("wiki")]),
        text(
          " of concepts I've studied, expressed accessibly.
A good explanation is the best proof of my own understanding, and an exciting challenge. 
This website is hosted by Firebase and written in ",
        ),
        html.a([href("https://gleam.run")], [text("Gleam")]),
        text(", and the code is up on my "),
        html.a([href("https://github.com/RyanBrewer317/ryanbrewer-dev")], [
          text("github"),
        ]),
        text(
          ". Instead of a typical web framework, I wrote my own web framework called ",
        ),
        html.a([href("https://arctic-framework.org")], [text("Arctic")]),
        text(" on top of the amazing "),
        html.a([href("https://lustre.build/")], [text("Lustre")]),
        text(
          ". Scripting, markup, styles, etc. for this site are all done by me :)",
        ),
      ]),
      html.h3([attribute.style([#("padding-top", "50pt")])], [
        element.text("Blog Posts"),
      ]),
      html.ul([attribute.id("posts-list")], list.map(posts, thumbnail.post)),
    ]),
    tail(),
  ])
}
