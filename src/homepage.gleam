import components/head.{head}
import components/navbar.{navbar}
import components/tail.{tail}
import components/thumbnail.{thumbnail}
import gleam/list
import helpers.{type Post}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn homepage(posts: List(Post)) -> Element(Nil) {
  html.html([attribute.attribute("lang", "en")], [
    head(
      "Ryan Brewer's Blog",
      "The place Ryan writes his thoughts and shows off SaberVM and other cool projects.",
      [
        html.script(
          [attribute.attribute("type", "module")],
          "import '../style.css';",
        ),
        html.script(
          [attribute.attribute("type", "module")],
          "import { main } from \"../src/ryanbrewerdev.gleam\";
 document.addEventListener(\"DOMContentLoaded\", () => {
   const dispatch = main({});
 });",
        ),
      ],
    ),
    html.body([], [
      navbar(),
      html.div([attribute.id("body")], [
        html.div([attribute.attribute("data-lustre-app", "true")], []),
        html.h3([attribute.style([#("padding-top", "50pt")])], [
          element.text("Blog Posts"),
        ]),
        html.ul([attribute.id("posts-list")], list.map(posts, thumbnail)),
      ]),
      tail(),
    ]),
  ])
}
