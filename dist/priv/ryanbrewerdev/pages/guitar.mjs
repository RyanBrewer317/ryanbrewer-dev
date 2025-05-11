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
        ]),
      ),
      tail(),
    ]),
  );
}
