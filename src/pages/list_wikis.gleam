// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import arctic.{type Page}
import components/head.{head}
import components/navbar.{navbar}
import components/script_wikis.{script_wikis}
import components/tail.{tail}
import components/thumbnail
import gleam/list
import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html

// TODO: I should probably switch this to use Lustre for interactivity instead of JS

fn script() -> Element(Nil) {
  html.script(
    [],
    "
function searchWikisKeyUp() {
  // Declare variables
  const $input = document.getElementById(\"search-wiki\");
  const q = $input.value.toLowerCase();
  const $menu = document.getElementById(\"search-wiki-menu\");
  $menu.replaceChildren(...Array.from($menu.children).sort((a, b) => {
    const aHits = getHits(q, WIKIS[a.id]);
    const bHits = getHits(q, WIKIS[b.id]);
    return bHits - aHits;
  }));
}
function getHits(q, w) {
  let hits = 0;
  for (const i in w.tags) if (q.includes(w.tags[i])) hits += 2;
  return hits;
}
  ",
  )
}

fn searchbox() -> Element(Nil) {
  html.input([
    attribute.type_("text"),
    attribute.id("search-wiki"),
    attribute.placeholder("Search..."),
    attribute("onkeyup", "searchWikisKeyUp()"),
    attribute("title", "Enter search terms"),
  ])
}

pub fn list_wikis(wikis: List(Page)) -> Element(Nil) {
  html.html([attribute.attribute("lang", "en")], [
    head("Search Wiki - Ryan Brewer", "Look through Ryan's personal wiki", [
      html.link([attribute.rel("stylesheet"), attribute.href("/style.css")]),
      script_wikis(wikis),
      script(),
    ]),
    html.body([], [
      navbar(),
      html.div([attribute.id("body")], [
        searchbox(),
        html.ul(
          [attribute.id("search-wiki-menu")],
          list.map(wikis, thumbnail.wiki),
        ),
      ]),
      tail(),
    ]),
  ])
}
