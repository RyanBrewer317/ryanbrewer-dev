import * as $attribute from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $head from "../components/head.mjs";
import { head } from "../components/head.mjs";
import * as $navbar from "../components/navbar.mjs";
import { navbar } from "../components/navbar.mjs";
import * as $tail from "../components/tail.mjs";
import { tail } from "../components/tail.mjs";
import { toList } from "../gleam.mjs";

export function contact() {
  return $html.html(
    toList([$attribute.attribute("lang", "en")]),
    toList([
      head(
        "Contact - Ryan Brewer",
        "Contact information",
        toList([
          $html.link(
            toList([$attribute.rel("stylesheet"), $attribute.href("/style.css")]),
          ),
        ]),
      ),
      $html.body(
        toList([]),
        toList([
          navbar(),
          $html.div(
            toList([$attribute.id("body")]),
            toList([$html.p(toList([]), toList([text("ryanbrew317 at gmail")]))]),
          ),
          tail(),
        ]),
      ),
    ]),
  );
}
