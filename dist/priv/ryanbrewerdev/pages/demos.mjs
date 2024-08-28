import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { attribute, id } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { body, div, html, script } from "../../lustre/lustre/element/html.mjs";
import * as $head from "../components/head.mjs";
import { head } from "../components/head.mjs";
import * as $navbar from "../components/navbar.mjs";
import { navbar } from "../components/navbar.mjs";
import * as $tail from "../components/tail.mjs";
import { tail } from "../components/tail.mjs";
import { toList } from "../gleam.mjs";

export function demos() {
  return html(
    toList([attribute("lang", "en")]),
    toList([
      head(
        "Demos - Ryan Brewer",
        "Interactive demonstrations of concepts from programming language theory",
        toList([
          $html.link(
            toList([$attribute.rel("stylesheet"), $attribute.href("/style.css")]),
          ),
          script(
            toList([attribute("type", "module")]),
            "import { main } from \"/priv/ryanbrewerdev/client/demos.mjs\";\n document.addEventListener(\"DOMContentLoaded\", () => {\n   const dispatch = main({});\n });",
          ),
        ]),
      ),
      body(
        toList([]),
        toList([
          navbar(),
          div(
            toList([id("body")]),
            toList([
              div(toList([attribute("data-lustre-app", "true")]), toList([])),
            ]),
          ),
          tail(),
        ]),
      ),
    ]),
  );
}
