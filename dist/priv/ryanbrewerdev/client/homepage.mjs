import * as $bool from "../../gleam_stdlib/gleam/bool.mjs";
import * as $dynamic from "../../gleam_stdlib/gleam/dynamic.mjs";
import * as $float from "../../gleam_stdlib/gleam/float.mjs";
import * as $io from "../../gleam_stdlib/gleam/io.mjs";
import * as $result from "../../gleam_stdlib/gleam/result.mjs";
import * as $lustre from "../../lustre/lustre.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { href } from "../../lustre/lustre/attribute.mjs";
import * as $effect from "../../lustre/lustre/effect.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $event from "../../lustre/lustre/event.mjs";
import { Ok, toList, CustomType as $CustomType, makeError, divideFloat } from "../gleam.mjs";
import { get_x, get_y, get_width, get_height, screen_width } from "/gleam_helpers.mjs";

class Model extends $CustomType {
  constructor(x, y) {
    super();
    this.x = x;
    this.y = y;
  }
}

export class Nothing extends $CustomType {}

export class MoveTo extends $CustomType {
  constructor(x, y) {
    super();
    this.x = x;
    this.y = y;
  }
}

function init(_) {
  return [new Model(divideFloat(screen_width(), 2.0), 350.0), $effect.none()];
}

function update(model, msg) {
  if (msg instanceof Nothing) {
    return [model, $effect.none()];
  } else {
    let x = msg.x;
    let y = msg.y;
    return [new Model(x, y), $effect.none()];
  }
}

function handle_mousemove(sprite_x, sprite_y, e) {
  return $result.try$(
    $event.mouse_position(e),
    (_use0) => {
      let x = _use0[0];
      let y = _use0[1];
      let x_dist = sprite_x - x;
      let y_dist = sprite_y - y;
      let $ = $float.square_root((x_dist * x_dist) + (y_dist * y_dist));
      if (!$.isOk()) {
        throw makeError(
          "assignment_no_match",
          "client/homepage",
          67,
          "",
          "Assignment pattern did not match",
          { value: $ }
        )
      }
      let dist = $[0];
      let $1 = $io.debug($dynamic.field("target", $dynamic.dynamic)(e));
      
      return $bool.guard(
        dist > 50.0,
        new Ok(new Nothing()),
        () => {
          let delta_x = divideFloat((x_dist * 50.0), dist);
          let delta_y = divideFloat((y_dist * 50.0), dist);
          let box_left = get_x();
          let box_right = get_x() + get_width();
          let box_bottom = get_y();
          let box_top = get_y() + get_height();
          let candidate_x = sprite_x + delta_x;
          let candidate_y = sprite_y + delta_y;
          let new_x = (() => {
            let $2 = (candidate_x < box_left) || (box_right < candidate_x);
            if ($2) {
              return get_x() + (divideFloat(get_width(), 2.0));
            } else {
              return candidate_x;
            }
          })();
          let new_y = (() => {
            let $2 = (candidate_y < box_bottom) || (box_top < candidate_y);
            if ($2) {
              return get_y() + (divideFloat(get_height(), 2.0));
            } else {
              return candidate_y;
            }
          })();
          return new Ok(new MoveTo(new_x, new_y));
        },
      );
    },
  );
}

function view(model) {
  let x = model.x;
  let y = model.y;
  $io.debug("hi!");
  return $html.div(
    toList([
      $attribute.on(
        "mousemove",
        (_capture) => { return handle_mousemove(x, y, _capture); },
      ),
      $attribute.id("sprite-bounds"),
    ]),
    toList([
      $html.div(
        toList([]),
        toList([
          $html.div(
            toList([]),
            toList([
              $html.h3(toList([]), toList([text("Me.")])),
              $html.div(
                toList([$attribute.id("sprites")]),
                toList([
                  $html.div(
                    toList([
                      $attribute.id("sprite-1"),
                      $attribute.style(
                        toList([
                          ["top", $float.to_string(y) + "px"],
                          ["left", $float.to_string(x) + "px"],
                        ]),
                      ),
                    ]),
                    toList([]),
                  ),
                  $html.div(
                    toList([
                      $attribute.id("sprite-2"),
                      $attribute.style(
                        toList([
                          ["top", $float.to_string(y) + "px"],
                          ["left", $float.to_string(x) + "px"],
                        ]),
                      ),
                    ]),
                    toList([]),
                  ),
                ]),
              ),
              $html.p(
                toList([]),
                toList([
                  text(
                    "I'm Ryan Brewer.\nI'm a passionate software developer working on open-source software \nfor safe, reliable, and portable applications.\nI specialize in a formal methods approach to systems design, with a focus on ergonomics.\nMy current biggest project is ",
                  ),
                  $html.a(
                    toList([href("https://github.com/RyanBrewer317/SaberVM")]),
                    toList([text("SaberVM")]),
                  ),
                  text(
                    ",\na lightweight abstract machine for functional languages that aims \nto be formally memory-safe, fault-tolerant, and very small. \nWith SaberVM, I'm hoping to broaden accessibility to safe computation, \nboth by taking it out of the ivory tower of academia and \nby removing the need for expensive hardware.\nConsider supporting my work!\n",
                  ),
                ]),
              ),
              $html.a(
                toList([
                  $attribute.id("github"),
                  href("https://github.com/sponsors/RyanBrewer317"),
                ]),
                toList([
                  $html.img(
                    toList([
                      $attribute.src("/github-logo.png"),
                      $attribute.alt("GitHub logo"),
                      $attribute.id("github-logo"),
                    ]),
                  ),
                  $html.span(toList([]), toList([text("Sponsor")])),
                ]),
              ),
              $html.a(
                toList([
                  $attribute.id("kofi"),
                  href("https://ko-fi.com/ryanbrewer"),
                ]),
                toList([
                  $html.img(
                    toList([
                      $attribute.src("/kofi-logo.png"),
                      $attribute.alt("Ko-fi logo"),
                      $attribute.id("kofi-logo"),
                    ]),
                  ),
                  $html.span(toList([]), toList([text("Support")])),
                ]),
              ),
            ]),
          ),
        ]),
      ),
      $html.h3(
        toList([$attribute.style(toList([["padding-top", "50pt"]]))]),
        toList([text("My Website")]),
      ),
      $html.p(
        toList([]),
        toList([
          text(
            "This is my website.\nI use this as a space to store my ideas, advertise myself and my work, and write blog posts about topics that I love.\nGenerally I constrain my posts to be about programming language theory or implementations. \nLinks to my latest posts can be found below.\nThis website is hosted by Firebase and written in ",
          ),
          $html.a(toList([href("https://gleam.run")]), toList([text("Gleam")])),
          text(", and the code is up on my "),
          $html.a(
            toList([href("https://github.com/RyanBrewer317/ryanbrewer-dev")]),
            toList([text("github")]),
          ),
          text(". The only framework used is "),
          $html.a(
            toList([href("https://lustre.build/")]),
            toList([text("Lustre")]),
          ),
          text("; I did all the scripting, markup, styles, and layout by hand."),
        ]),
      ),
    ]),
  );
}

export function main() {
  let app = $lustre.application(init, update, view);
  let $ = $lustre.start(app, "[data-lustre-app]", undefined);
  if (!$.isOk()) {
    throw makeError(
      "assignment_no_match",
      "client/homepage",
      43,
      "main",
      "Assignment pattern did not match",
      { value: $ }
    )
  }
  let dispatch = $[0];
  return dispatch;
}
