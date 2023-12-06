import lustre/element.{type Element}
import lustre/element/html
import lustre/attribute.{attribute}
import gleam/list
import helpers.{type Post}

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

pub fn list_posts(posts: List(Post)) -> Element(Nil) {
  html.html(
    [attribute.attribute("lang", "en")],
    [
      helpers.head(
        "Search Posts - Ryan Brewer",
        "Look through Ryan's past posts",
        [
          html.script(
            [attribute.attribute("type", "module")],
            "import '../style.css';",
          ),
          helpers.script_posts(posts),
          script(),
        ],
      ),
      html.body(
        [],
        [
          helpers.navbar(),
          html.div(
            [attribute.id("body")],
            [
              searchbox(),
              html.ul(
                [attribute.id("search-posts-menu")],
                list.map(posts, helpers.thumbnail),
              ),
            ],
          ),
          helpers.tail(),
        ],
      ),
    ],
  )
}
