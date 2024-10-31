import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { attribute, id } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { div, html, script } from "../../lustre/lustre/element/html.mjs";
import * as $head from "../components/head.mjs";
import * as $navbar from "../components/navbar.mjs";
import { navbar } from "../components/navbar.mjs";
import * as $tail from "../components/tail.mjs";
import { tail } from "../components/tail.mjs";
import { toList } from "../gleam.mjs";

export function demos() {
  return $html.div(
    toList([]),
    toList([
      $head.local_head(
        "Demos",
        "Interactive demonstrations of concepts from programming language theory",
      ),
      script(
        toList([attribute("type", "module")]),
        "import { main } from \"/priv/ryanbrewerdev/client/demos.mjs\";\n document.addEventListener(\"DOMContentLoaded\", () => {\n   const dispatch = main({});\n });",
      ),
      navbar(),
      div(
        toList([id("body")]),
        toList([div(toList([attribute("data-lustre-app", "true")]), toList([]))]),
      ),
      tail(),
    ]),
  );
}
