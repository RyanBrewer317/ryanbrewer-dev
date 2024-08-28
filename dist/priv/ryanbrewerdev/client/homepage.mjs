import * as $lustre from "../../lustre/lustre.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { href } from "../../lustre/lustre/attribute.mjs";
import * as $effect from "../../lustre/lustre/effect.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { toList, CustomType as $CustomType, makeError } from "../gleam.mjs";

class Model extends $CustomType {}

function init(_) {
  return [new Model(), $effect.none()];
}

function update(model, _) {
  return [model, $effect.none()];
}

function view(_) {
  return $html.div(
    toList([]),
    toList([
      $html.div(
        toList([]),
        toList([
          $html.div(
            toList([$attribute.id("ryan-and-ivy-img")]),
            toList([
              $html.img(
                toList([
                  $attribute.src("/ryan-and-ivy.jpg"),
                  $attribute.width(300),
                ]),
              ),
              $html.div(
                toList([
                  $attribute.class$("caption"),
                  $attribute.class$("subtle-text"),
                ]),
                toList([text("Me and my lovely wife, Ivy!")]),
              ),
            ]),
          ),
          $html.div(
            toList([]),
            toList([
              $html.h3(toList([]), toList([text("Me.")])),
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
      23,
      "main",
      "Assignment pattern did not match",
      { value: $ }
    )
  }
  let dispatch = $[0];
  return dispatch;
}
