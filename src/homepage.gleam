import lustre/element.{type Element}
import lustre/element/html
import lustre/attribute
import post.{head}

pub fn homepage() -> Element(Nil) {
  html.html(
    [attribute.attribute("lang", "en")],
    [
      head(
        "Ryan Brewer's Blog",
        [
          html.script(
            [attribute.attribute("type", "module")],
            "import '../public/style.css';",
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
        [html.div([attribute.attribute("data-lustre-app", "true")], [])],
      ),
    ],
  )
}
