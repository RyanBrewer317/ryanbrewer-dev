import * as $arctic from "../../arctic/arctic.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { attribute } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $navbar from "../components/navbar.mjs";
import { navbar } from "../components/navbar.mjs";
import * as $script_posts from "../components/script_posts.mjs";
import { script_posts } from "../components/script_posts.mjs";
import * as $tail from "../components/tail.mjs";
import { tail } from "../components/tail.mjs";
import * as $thumbnail from "../components/thumbnail.mjs";
import { toList } from "../gleam.mjs";

function script() {
  return $html.script(
    toList([]),
    "\nfunction searchPostsKeyUp() {\n  // Declare variables\n  const $input = document.getElementById(\"search-posts\");\n  const q = $input.value.toLowerCase();\n  const $menu = document.getElementById(\"search-posts-menu\");\n  $menu.replaceChildren(...Array.from($menu.children).sort((a, b) => {\n    const aHits = getHits(q, POSTS[a.id]);\n    const bHits = getHits(q, POSTS[b.id]);\n    return bHits - aHits;\n  }));\n}\nfunction getHits(q, p) {\n  let hits = 0;\n  for (const i in p.tags) if (q.includes(p.tags[i])) hits += 2;\n  const words = p.description.split(\" \");\n  for (const i in words) if (q.includes(words[i])) hits += 1;\n  return hits;\n}\n  ",
  );
}

function searchbox() {
  return $html.input(
    toList([
      $attribute.type_("text"),
      $attribute.id("search-posts"),
      $attribute.placeholder("Search..."),
      attribute("onkeyup", "searchPostsKeyUp()"),
      attribute("title", "Enter search terms"),
    ]),
  );
}

export function list_posts(posts) {
  return $html.div(
    toList([]),
    toList([
      $html.title(toList([]), "Search Posts - Ryan Brewer"),
      $html.meta(
        toList([
          $attribute.name("description"),
          $attribute.attribute("content", "Search Ryan's past posts"),
        ]),
      ),
      script_posts(posts),
      script(),
      navbar(),
      $html.div(
        toList([$attribute.id("body")]),
        toList([
          searchbox(),
          $html.ul(
            toList([$attribute.id("search-posts-menu")]),
            $list.map(posts, $thumbnail.post),
          ),
        ]),
      ),
      tail(),
    ]),
  );
}
