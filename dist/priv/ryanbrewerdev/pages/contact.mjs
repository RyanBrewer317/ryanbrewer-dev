import * as $attribute from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $navbar from "../components/navbar.mjs";
import { navbar } from "../components/navbar.mjs";
import * as $tail from "../components/tail.mjs";
import { tail } from "../components/tail.mjs";
import { toList } from "../gleam.mjs";

export function contact() {
  return $html.div(
    toList([]),
    toList([
      $html.title(toList([]), "Contact - Ryan Brewer"),
      $html.meta(
        toList([
          $attribute.name("description"),
          $attribute.attribute("content", "Contact information"),
        ]),
      ),
      navbar(),
      $html.div(
        toList([$attribute.id("body")]),
        toList([$html.p(toList([]), toList([text("ryanbrew317 at gmail")]))]),
      ),
      tail(),
    ]),
  );
}
