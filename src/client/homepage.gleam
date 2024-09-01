// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import lustre
import lustre/attribute.{href}
import lustre/effect.{type Effect}
import lustre/element.{type Element, text}
import lustre/element/html

// This Lustre boilerplate is mostly so I have the option of interactivity if I want. 
// I want to publish this stack as a Gleam library at some point,
// for static-site-generation-driven personal websites.

type Model {
  Model
}

pub type Msg

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(dispatch) = lustre.start(app, "[data-lustre-app]", Nil)

  dispatch
}

fn init(_) -> #(Model, Effect(Msg)) {
  #(Model, effect.none())
}

fn update(model: Model, _msg: Msg) -> #(Model, Effect(Msg)) {
  #(model, effect.none())
}

fn view(_model: Model) -> Element(Msg) {
  html.div([], [
    html.div([], [
      // html.div([attribute.id("ryan-and-ivy-img")], [
      //   html.img([attribute.src("/ryan-and-ivy.jpg"), attribute.width(300)]),
      //   html.div([attribute.class("caption"), attribute.class("subtle-text")], [
      //     text("Me and my lovely wife, Ivy!"),
      //   ]),
      // ]),
      html.div([], [
        html.h3([], [text("Me.")]),
        html.p([], [
          text(
            "I'm Ryan Brewer.
I'm a passionate software developer working on open-source software 
for safe, reliable, and portable applications.
I specialize in a formal methods approach to systems design, with a focus on ergonomics.
My current biggest project is ",
          ),
          html.a([href("https://github.com/RyanBrewer317/SaberVM")], [
            text("SaberVM"),
          ]),
          text(
            ",
a lightweight abstract machine for functional languages that aims 
to be formally memory-safe, fault-tolerant, and very small. 
With SaberVM, I'm hoping to broaden accessibility to safe computation, 
both by taking it out of the ivory tower of academia and 
by removing the need for expensive hardware.
Consider supporting my work!
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
    html.h3([attribute.style([#("padding-top", "50pt")])], [text("My Website")]),
    html.p([], [
      text(
        "This is my website.
I use this as a space to store my ideas, advertise myself and my work, and write blog posts about topics that I love.
Generally I constrain my posts to be about programming language theory or implementations. 
Links to my latest posts can be found below.
This website is hosted by Firebase and written in ",
      ),
      html.a([href("https://gleam.run")], [text("Gleam")]),
      text(", and the code is up on my "),
      html.a([href("https://github.com/RyanBrewer317/ryanbrewer-dev")], [
        text("github"),
      ]),
      text(". The only framework used is "),
      html.a([href("https://lustre.build/")], [text("Lustre")]),
      text("; I did all the scripting, markup, styles, and layout by hand."),
    ]),
  ])
}
