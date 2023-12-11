import lustre/element.{type Element, text}
import lustre/element/html
import lustre/attribute.{attribute}
import gleam/list
import gleam/string
import gleam/string_builder.{
  type StringBuilder, append, append_builder, concat, from_string, join,
  to_string,
}
import birl/time
import gleam/int
import gleam/order.{type Order, negate}

pub type DateTime =
  time.DateTime

pub fn string_to_date(s: String) -> Result(DateTime, Nil) {
  time.from_naive(s)
}

pub fn pretty_date(date: DateTime) -> String {
  let time.Date(year, _, day) = time.get_date(date)
  time.string_month(date) <> " " <> int.to_string(day) <> ", " <> int.to_string(
    year,
  )
}

pub fn before(p1: Post, p2: Post) -> Order {
  time.compare(p1.date, p2.date)
}

pub fn after(p1: Post, p2: Post) -> Order {
  negate(before(p1, p2))
}

pub type Post {
  Post(
    title: String,
    id: String,
    date: DateTime,
    tags: List(String),
    description: String,
    body: List(Element(Nil)),
  )
}

pub fn thumbnail(post: Post) -> Element(a) {
  html.li(
    [attribute.class("post-thumbnail"), attribute.id(post.id)],
    [
      html.h3(
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

pub fn script_posts(posts: List(Post)) -> Element(a) {
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
  |> append(string.replace(each: "\"", with: "\\\"", in: p.title))
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
  |> append(string.replace(each: "\"", with: "\\\"", in: p.description))
  |> append("\"},\n")
}

pub fn head(
  title: String,
  description: String,
  extra: List(Element(Nil)),
) -> Element(Nil) {
  html.head(
    [],
    list.append(
      [
        html.script(
          [
            attribute("async", "true"),
            attribute.src(
              "https://www.googletagmanager.com/gtag/js?id=G-BDZJ8SX3Y1",
            ),
          ],
          "",
        ),
        html.script(
          [],
          "
window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('js', new Date());
        ",
        ),
        html.title([], title <> " - Ryan Brewer"),
        html.meta([attribute("charset", "UTF-8")]),
        html.meta([
          attribute.name("viewport"),
          attribute("content", "width=device-width, initial-scale=1.0"),
        ]),
        html.meta([
          attribute.name("description"),
          attribute("content", description),
        ]),
        html.link([
          attribute.rel("icon"),
          attribute.type_("image/x-icon"),
          attribute.href("/favicon.ico"),
        ]),
        html.link([
          attribute.rel("alternate"),
          attribute.type_("application/rss+xml"),
          attribute("title", "Ryan Brewer's Blog"),
          attribute.href("https://ryanbrewer.dev/feed.rss"),
        ]),
        html.link([
          attribute.rel("preconnect"),
          attribute.href("https://fonts.googleapis.com"),
        ]),
        html.link([
          attribute.rel("preconnect"),
          attribute.href("https://fonts.gstatic.com"),
          attribute("crossorigin", "true"),
        ]),
        html.link([
          attribute.rel("stylesheet"),
          attribute.href(
            "https://fonts.googleapis.com/css2?family=Roboto&display=swap",
          ),
        ]),
        html.script(
          [attribute.src("https://polyfill.io/v3/polyfill.min.js?features=es6")],
          "",
        ),
        html.script(
          [
            attribute("type", "text/javascript"),
            attribute("async", "true"),
            attribute(
              "src",
              "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js",
            ),
          ],
          "",
        ),
        html.link([
          attribute.rel("stylesheet"),
          attribute.href(
            "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/atom-one-dark.min.css",
          ),
        ]),
        html.script(
          [
            attribute.src(
              "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js",
            ),
          ],
          "",
        ),
        html.script([], "hljs.highlightAll();"),
      ],
      extra,
    ),
  )
}

pub fn navbar() -> Element(a) {
  html.nav(
    [],
    [
      html.a(
        [attribute.href("/"), attribute.id("nav-home")],
        [text("Ryan Brewer")],
      ),
      html.a(
        [attribute.href("/search"), attribute.id("nav-search")],
        [text("Posts")],
      ),
      html.a(
        [attribute.href("/feed.rss"), attribute.id("nav-subscribe")],
        [
          html.img([
            attribute.src("/rss-icon.png"),
            attribute.id("rss-subscribe-icon"),
          ]),
          text("Subscribe"),
        ],
      ),
    ],
  )
}

pub fn tail() -> Element(a) {
  html.div(
    [],
    [
      html.script([attribute.src("/__/firebase/8.10.1/firebase-app.js")], ""),
      html.script(
        [attribute.src("/__/firebase/8.10.1/firebase-analytics.js")],
        "",
      ),
      html.script([attribute.src("/__/firebase/init.js")], ""),
      html.script([], "firebase.analytics();"),
    ],
  )
}
