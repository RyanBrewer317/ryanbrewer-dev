// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import arctic.{type CacheablePage}
import components/head
import components/navbar.{navbar}
import components/script_posts.{script_posts}
import components/tail.{tail}
import components/thumbnail
import gleam/list
import lustre/attribute.{attribute}
import lustre/element.{type Element, text}
import lustre/element/html

// TODO: I should probably switch this to use Lustre for interactivity instead of JS

fn script() -> Element(Nil) {
  html.script(
    [],
    "
function searchPostsKeyUp() {
  // Declare variables
  const $input = document.getElementById(\"search-posts\");
  const q = $input.value.toLowerCase();
  const $menu = document.getElementById(\"search-posts-menu\");
  $menu.replaceChildren(...Array.from($menu.children).sort((a, b) => {
    const aHits = getHits(q, POSTS[a.id]);
    const bHits = getHits(q, POSTS[b.id]);
    return bHits - aHits;
  }));
}
function getHits(q, p) {
  let hits = 0;
  for (const i in p.tags) if (q.includes(p.tags[i])) hits += 2;
  const words = p.description.split(\" \");
  for (const i in words) if (q.includes(words[i])) hits += 1;
  return hits;
}
  ",
  )
}

fn searchbox() -> Element(Nil) {
  html.input([
    attribute.type_("text"),
    attribute.id("search-posts"),
    attribute.placeholder("Search..."),
    attribute("onkeyup", "searchPostsKeyUp()"),
    attribute("title", "Enter search terms"),
  ])
}

pub fn list_posts(posts: List(CacheablePage)) -> Element(Nil) {
  html.div([], [
    head.local_head("Search Posts", "Search Ryan's past posts"),
    script_posts(posts),
    script(),
    navbar(),
    html.div([attribute.id("body")], [
      searchbox(),
      html.a(
        [
          attribute.href("/feed.rss"),
          attribute.id("subscribe-tech-blog"),
          attribute.attribute("onclick", "window.location.href = '/feed.rss'"),
        ],
        [
          html.img([
            attribute.src("/rss-icon.png"),
            attribute.id("rss-subscribe-icon"),
          ]),
          text("Subscribe"),
        ],
      ),
      html.ul(
        [attribute.id("search-posts-menu")],
        list.map(posts, thumbnail.post),
      ),
    ]),
    tail(),
  ])
}
