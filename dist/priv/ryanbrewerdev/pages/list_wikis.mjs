import * as $arctic from "../../arctic/arctic.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { attribute } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $head from "../components/head.mjs";
import * as $navbar from "../components/navbar.mjs";
import { navbar } from "../components/navbar.mjs";
import * as $script_wikis from "../components/script_wikis.mjs";
import { script_wikis } from "../components/script_wikis.mjs";
import * as $tail from "../components/tail.mjs";
import { tail } from "../components/tail.mjs";
import * as $thumbnail from "../components/thumbnail.mjs";
import { toList } from "../gleam.mjs";

function script() {
  return $html.script(
    toList([]),
    "\nfunction searchWikisKeyUp() {\n  // Declare variables\n  const $input = document.getElementById(\"search-wiki\");\n  const q = $input.value.toLowerCase();\n  const $menu = document.getElementById(\"search-wiki-menu\");\n  $menu.replaceChildren(...Array.from($menu.children).sort((a, b) => {\n    const aHits = getHits(q, WIKIS[a.id]);\n    const bHits = getHits(q, WIKIS[b.id]);\n    return bHits - aHits;\n  }));\n}\nfunction getHits(q, w) {\n  let hits = 0;\n  for (const i in w.tags) if (q.includes(w.tags[i])) hits += 2;\n  return hits;\n}\n  ",
  );
}

function searchbox() {
  return $html.input(
    toList([
      $attribute.type_("text"),
      $attribute.id("search-wiki"),
      $attribute.placeholder("Search..."),
      attribute("onkeyup", "searchWikisKeyUp()"),
      attribute("title", "Enter search terms"),
    ]),
  );
}

export function list_wikis(wikis) {
  return $html.div(
    toList([]),
    toList([
      $head.local_head("Search Wiki", "Look through Ryan's personal wiki"),
      script_wikis(wikis),
      script(),
      navbar(),
      $html.div(
        toList([$attribute.id("body")]),
        toList([
          searchbox(),
          $html.ul(
            toList([$attribute.id("search-wiki-menu")]),
            $list.map(wikis, $thumbnail.wiki),
          ),
        ]),
      ),
      tail(),
    ]),
  );
}
