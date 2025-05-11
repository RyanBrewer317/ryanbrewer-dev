// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import arctic.{type ProcessedCollection}
import components/head
import components/navbar.{navbar}
import components/tail.{tail}
import lustre/attribute.{href}
import lustre/element.{type Element, text}
import lustre/element/html

pub fn homepage(_collections: List(ProcessedCollection)) -> Element(Nil) {
  html.div([], [
    head.local_head(
      "Ryan Brewer's Blog",
      "The place Ryan writes his thoughts and shows off cool projects!",
    ),
    navbar(),
    html.div([attribute.id("body")], [
      html.div([], [
        html.div([], [
          html.h3([], [text("He/him.")]),
          html.p([], [
            text(
              "I'm Ryan Brewer.
I'm a software engineer in San Francisco.
I've built a few cool open-source ",
            ),
            html.a([href("/projects")], [text("projects")]),
            text(
              ",
generally related to programming language theory or web development.
I built a lot of the tech powering this website!
I also love to play ",
            ),
            html.a([href("/guitar")], [text("guitar")]),
            text(
              ",
especially folk-rock.
I'm straight and cisgender, using he/him pronouns.
",
            ),
          ]),
        ]),
        html.div(
          [
            attribute.id("homepage-flags"),
            attribute.style([
              #("text-align", "center"),
              #("font-size", "inherit"),
            ]),
          ],
          [
            text("I support: "),
            html.span(
              [
                attribute.style([
                  #("font-size", "30pt"),
                  #("position", "relative"),
                  #("top", "7.5pt"),
                ]),
              ],
              [text("🏳️‍🌈🏳️‍⚧️🇵🇸🇺🇦")],
            ),
          ],
        ),
        html.div([attribute.id("homepage-img")], [
          html.img([attribute.src("/ryan-ferry.jpg")]),
        ]),
      ]),
      html.p([], [
        text("Other sites I recommend include "),
        html.a([href("https://blueberrywren.dev/")], [text("Wren's blog")]),
        text(", "),
        html.a([href("https://ehatti.github.io/forest/output/index.xml")], [
          text("Eashan's notes"),
        ]),
        text(", "),
        html.a([href("https://www.haskellforall.com/")], [
          text("Haskell For All"),
        ]),
        text(", the "),
        html.a([href("https://wiki.xxiivv.com/site/computation.html")], [
          text("XXIIVV wiki"),
        ]),
        text(", and the "),
        html.a([href("https://cybercat.institute/")], [
          text("Cybercat Institute"),
        ]),
        text(". Podcasts I would recommend include "),
        html.a([href("https://www.typetheoryforall.com/")], [
          text("Type Theory Forall"),
        ]),
        text(", the "),
        html.a([href("https://www.kleene.church/#h.k6fig1tqap9i")], [
          text("Church of Logic"),
        ]),
        text(", and the "),
        html.a([href("https://homepage.cs.uiowa.edu/~astump/ittc.html")], [
          text("Iowa Type Theory Commute"),
        ]),
        text(". Youtubers I recommend include "),
        html.a([href("https://www.youtube.com/@RichardSouthwell")], [
          text("Richard Southwell"),
        ]),
        text(", "),
        html.a([href("https://www.youtube.com/@AtticPhilosophy")], [
          text("Mark Jago"),
        ]),
        text(", "),
        html.a([href("https://www.youtube.com/@DrBartosz")], [
          text("Bartosz Milewski"),
        ]),
        text(", and the "),
        html.a([href("https://www.youtube.com/@TheCatsters")], [
          text("Catsters"),
        ]),
        text("."),
      ]),
    ]),
    tail(),
  ])
}
