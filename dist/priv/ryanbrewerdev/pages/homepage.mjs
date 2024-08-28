import * as $arctic from "../../arctic/arctic.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $head from "../components/head.mjs";
import { head } from "../components/head.mjs";
import * as $navbar from "../components/navbar.mjs";
import { navbar } from "../components/navbar.mjs";
import * as $tail from "../components/tail.mjs";
import { tail } from "../components/tail.mjs";
import * as $thumbnail from "../components/thumbnail.mjs";
import { toList } from "../gleam.mjs";

export function homepage(posts) {
  return $html.html(
    toList([$attribute.attribute("lang", "en")]),
    toList([
      head(
        "Ryan Brewer's Blog",
        "The place Ryan writes his thoughts and shows off SaberVM and other cool projects.",
        toList([
          $html.link(
            toList([$attribute.rel("stylesheet"), $attribute.href("/style.css")]),
          ),
          $html.script(
            toList([$attribute.attribute("type", "module")]),
            "import { main } from \"/priv/ryanbrewerdev/client/homepage.mjs\";\n document.addEventListener(\"DOMContentLoaded\", () => {\n   const dispatch = main({});\n });",
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
              $html.div(
                toList([$attribute.attribute("data-lustre-app", "true")]),
                toList([]),
              ),
              $html.h3(
                toList([$attribute.style(toList([["padding-top", "50pt"]]))]),
                toList([$element.text("Blog Posts")]),
              ),
              $html.ul(
                toList([$attribute.id("posts-list")]),
                $list.map(posts, $thumbnail.post),
              ),
            ]),
          ),
          tail(),
        ]),
      ),
    ]),
  );
}
