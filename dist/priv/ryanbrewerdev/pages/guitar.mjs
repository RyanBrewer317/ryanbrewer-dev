import * as $attribute from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $head from "../components/head.mjs";
import * as $navbar from "../components/navbar.mjs";
import { navbar } from "../components/navbar.mjs";
import * as $tail from "../components/tail.mjs";
import { tail } from "../components/tail.mjs";
import { toList } from "../gleam.mjs";

function thumbnail(name, artist, url) {
  return $html.div(
    toList([]),
    toList([
      $html.h3(toList([]), toList([text(name)])),
      $html.div(
        toList([$attribute.class$("subtle-text")]),
        toList([text(artist)]),
      ),
      $html.video(
        toList([
          $attribute.width(400),
          $attribute.controls(true),
          $attribute.style(toList([["margin-top", "15pt"]])),
        ]),
        toList([
          $html.source(
            toList([$attribute.src(url), $attribute.type_("video/mp4")]),
          ),
          text("Your browser doesn't support HTML video, unfortunately."),
        ]),
      ),
    ]),
  );
}

export function guitar() {
  return $html.div(
    toList([]),
    toList([
      $head.local_head("Guitar", "Ryan playing guitar"),
      navbar(),
      $html.div(
        toList([$attribute.id("body")]),
        toList([
          $html.h3(toList([]), toList([text("Guitar")])),
          $html.p(
            toList([]),
            toList([
              text(
                "\nThis is a page where I'll throw up some recordings of my covers and songs.\nThey aren't the most polished thing but they're mine and I'm proud of them :)\n        ",
              ),
            ]),
          ),
          thumbnail(
            "Girl From The North Country",
            "Bob Dylan",
            "https://cdn.ryanbrewer.dev/girl-from-the-north-country.mp4",
          ),
          thumbnail(
            "Bless the Telephone",
            "Labi Siffre",
            "https://cdn.ryanbrewer.dev/bless-the-telephone.mp4",
          ),
          thumbnail(
            "Homeward Bound",
            "Simon and Garfunkel",
            "https://cdn.ryanbrewer.dev/homeward-bound.mp4",
          ),
        ]),
      ),
      tail(),
    ]),
  );
}
