import lustre/element.{type Element, text}
import lustre/element/html
import lustre/attribute.{attribute}
import post.{type Post, head, pretty_date}
import gleam/list
import gleam/string_builder.{
  type StringBuilder, append, append_builder, concat, from_string, join,
  to_string,
}

fn script1(posts: List(Post)) -> Element(Nil) {
  use <-
    fn(k: fn() -> List(StringBuilder)) {
      html.script(
        [],
        from_string("const POSTS = {")
        |> append_builder(concat(k()))
        |> append("};")
        |> to_string(),
      )
    }
  use p <- list.map(posts)
  from_string("\"")
  |> append(p.id)
  |> append("\": {\"id\": \"")
  |> append(p.id)
  |> append("\", \"url\": \"")
  |> append("/posts/" <> p.id <> ".html")
  |> append("\", \"title\": \"")
  |> append(p.title)
  |> append("\", \"date\": \"")
  |> append(pretty_date(p.date))
  |> append("\", \"tags\": [")
  |> append_builder(join(
    list.map(
      p.tags,
      fn(tag) {
        from_string("\"")
        |> append(tag)
        |> append("\"")
      },
    ),
    ", ",
  ))
  |> append("], \"description\": \"")
  |> append(p.description)
  |> append("\"},\n")
}

fn script2() -> Element(Nil) {
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

fn thumbnail(post: Post) -> Element(Nil) {
  html.li(
    [attribute.class("post-thumbnail"), attribute.id(post.id)],
    [
      html.h4(
        [],
        [
          html.a(
            [attribute.href("posts/" <> post.id <> ".html")],
            [text(post.title)],
          ),
        ],
      ),
      html.div(
        [attribute.class("post-thumbnail-date")],
        [text(pretty_date(post.date))],
      ),
      html.p([], [text(post.description)]),
    ],
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
      head(
        "Search Posts - Ryan Brewer",
        "Look through Ryan's past posts",
        [
          html.script(
            [attribute.attribute("type", "module")],
            "import '../style.css';",
          ),
          script1(posts),
          script2(),
        ],
      ),
      html.body(
        [],
        [
          html.nav(
            [],
            [
              html.a([attribute.href("/")], [text("Ryan Brewer")]),
              html.a(
                [attribute.href("/search"), attribute.id("nav-search")],
                [text("Search Posts")],
              ),
            ],
          ),
          html.div(
            [attribute.id("body")],
            [
              searchbox(),
              html.ul(
                [attribute.id("search-posts-menu")],
                list.map(posts, thumbnail),
              ),
            ],
          ),
          html.script(
            [attribute.src("/__/firebase/8.10.1/firebase-app.js")],
            "",
          ),
          html.script(
            [attribute.src("/__/firebase/8.10.1/firebase-analytics.js")],
            "",
          ),
          html.script([attribute.src("/__/firebase/init.js")], ""),
        ],
      ),
    ],
  )
}
