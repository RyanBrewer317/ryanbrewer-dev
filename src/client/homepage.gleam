// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import gleam/bool
import gleam/dynamic
import gleam/float
import gleam/io
import gleam/result
import lustre
import lustre/attribute.{href}
import lustre/effect.{type Effect}
import lustre/element.{type Element, text}
import lustre/element/html
import lustre/event

@external(javascript, "/gleam_helpers.mjs", "get_x")
fn get_x() -> Float

@external(javascript, "/gleam_helpers.mjs", "get_y")
fn get_y() -> Float

@external(javascript, "/gleam_helpers.mjs", "get_width")
fn get_width() -> Float

@external(javascript, "/gleam_helpers.mjs", "get_height")
fn get_height() -> Float

@external(javascript, "/gleam_helpers.mjs", "screen_width")
fn screen_width() -> Float

type Model {
  Model(x: Float, y: Float)
}

pub type Msg {
  Nothing
  MoveTo(x: Float, y: Float)
}

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(dispatch) = lustre.start(app, "[data-lustre-app]", Nil)

  dispatch
}

fn init(_) -> #(Model, Effect(Msg)) {
  #(Model(x: screen_width() /. 2.0, y: 350.0), effect.none())
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    Nothing -> #(model, effect.none())
    MoveTo(x, y) -> #(Model(x:, y:), effect.none())
  }
}

fn handle_mousemove(
  sprite_x: Float,
  sprite_y: Float,
  e: dynamic.Dynamic,
) -> Result(Msg, List(dynamic.DecodeError)) {
  use #(x, y) <- result.try(event.mouse_position(e))
  let x_dist = sprite_x -. x
  let y_dist = sprite_y -. y
  let assert Ok(dist) = float.square_root(x_dist *. x_dist +. y_dist *. y_dist)
  let _ = io.debug(dynamic.field("target", dynamic.dynamic)(e))
  use <- bool.guard(when: dist >. 50.0, return: Ok(Nothing))
  let delta_x = x_dist *. 50.0 /. dist
  let delta_y = y_dist *. 50.0 /. dist
  let box_left = get_x()
  let box_right = get_x() +. get_width()
  let box_bottom = get_y()
  let box_top = get_y() +. get_height()
  let candidate_x = sprite_x +. delta_x
  let candidate_y = sprite_y +. delta_y
  let new_x = case candidate_x <. box_left || box_right <. candidate_x {
    True -> get_x() +. get_width() /. 2.0
    False -> candidate_x
  }
  let new_y = case candidate_y <. box_bottom || box_top <. candidate_y {
    True -> get_y() +. get_height() /. 2.0
    False -> candidate_y
  }
  Ok(MoveTo(new_x, new_y))
}

fn view(model: Model) -> Element(Msg) {
  let Model(x, y) = model
  io.debug("hi!")
  html.div(
    [
      attribute.on("mousemove", handle_mousemove(x, y, _)),
      attribute.id("sprite-bounds"),
    ],
    [
      html.div([], [
        // html.div([attribute.id("ryan-and-ivy-img")], [
        //   html.img([attribute.src("/ryan-and-ivy.jpg"), attribute.width(300)]),
        //   html.div([attribute.class("caption"), attribute.class("subtle-text")], [
        //     text("Me and my lovely wife, Ivy!"),
        //   ]),
        // ]),
        html.div([], [
          html.h3([], [text("Me.")]),
          html.div([attribute.id("sprites")], [
            html.div(
              [
                attribute.id("sprite-1"),
                attribute.style([
                  #("top", float.to_string(y) <> "px"),
                  #("left", float.to_string(x) <> "px"),
                ]),
              ],
              [],
            ),
            html.div(
              [
                attribute.id("sprite-2"),
                attribute.style([
                  #("top", float.to_string(y) <> "px"),
                  #("left", float.to_string(x) <> "px"),
                ]),
              ],
              [],
            ),
          ]),
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
      html.h3([attribute.style([#("padding-top", "50pt")])], [
        text("My Website"),
      ]),
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
    ],
  )
}
