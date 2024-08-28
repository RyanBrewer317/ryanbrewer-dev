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

export function unknown_page() {
  return $html.html(
    toList([$attribute.attribute("lang", "en")]),
    toList([
      head(
        "404 - Ryan Brewer",
        "Unknown Page",
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
            toList([
              $html.span(
                toList([$attribute.id("unknown-page-banner")]),
                toList([text("Unknown Page (404)")]),
              ),
            ]),
          ),
          tail(),
        ]),
      ),
    ]),
  );
}
