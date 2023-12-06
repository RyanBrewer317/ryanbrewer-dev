import lustre/element.{type Element, text}
import lustre/element/html
import lustre/attribute.{attribute}
import helpers.{type Post, Post}

fn do(el: a, k: fn() -> List(a)) -> List(a) {
  [el, ..k()]
}

fn finally(end: List(a)) -> List(a) {
  end
}

fn render_as_list(post: Post) -> List(Element(Nil)) {
  use <- do(html.h1([], [text(post.title)]))
  use <- do(html.div(
    [attribute.class("date")],
    [text(helpers.pretty_date(post.date))],
  ))
  finally(post.body)
}

pub fn render(post: Post) -> Element(Nil) {
  html.html(
    [attribute("lang", "en")],
    [
      helpers.head(
        post.title,
        post.description,
        [html.script([attribute.type_("module")], "import '../../style.css';")],
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
          html.div([attribute.id("body")], render_as_list(post)),
          helpers.tail(),
        ],
      ),
    ],
  )
}
