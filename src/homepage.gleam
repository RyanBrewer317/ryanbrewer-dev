import lustre/element.{type Element}
import lustre/element/html
import lustre/attribute
import helpers.{type Post}
import gleam/list

pub fn homepage(posts: List(Post)) -> Element(Nil) {
  html.html(
    [attribute.attribute("lang", "en")],
    [
      helpers.head(
        "Ryan Brewer's Blog",
        "The place Ryan writes his thoughts and shows off cool projects.",
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
      html.body(
        [],
        [
          helpers.navbar(),
          html.div([attribute.attribute("data-lustre-app", "true")], []),
          html.ul(
            [attribute.id("posts-list")],
            list.map(posts, helpers.thumbnail),
          ),
          helpers.tail(),
        ],
      ),
    ],
  )
}
