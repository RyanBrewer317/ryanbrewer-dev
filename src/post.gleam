import simplifile.{read}
import gleam/string
import gleam/order.{type Order}
import lustre/element.{type Element, text}
import lustre/element/html
import lustre/attribute.{class}
import gleam/result.{map_error, try}
import birl/time.{type DateTime}
import party as p
import gleam/list

pub type Post {
  Post(title: String, id: String, date: DateTime, body: List(Element(Nil)))
}

pub type Error {
  FileError(simplifile.FileError)
  ParseError(p.ParseError(Nil))
}

type Command {
  Paragraph
}

pub fn before(p1: Post, p2: Post) -> Order {
  time.compare(p1.date, p2.date)
}

pub fn post(filename: String) -> Result(Post, Error) {
  use content <- try(map_error(read(filename), FileError))
  map_error(p.go(parse(), content), ParseError)
}

fn parse() -> p.Parser(Post, Nil) {
  use id <- p.do(parse_id())
  use name <- p.do(parse_name())
  use date <- p.do(parse_date())
  use els <- p.do(p.many(parse_block()))
  p.return(Post(name, id, date, els))
}

fn parse_id() -> p.Parser(String, Nil) {
  use _ <- p.do(p.string("id:"))
  use _ <- p.do(p.many1(p.alt(p.char(" "), p.char("\t"))))
  use id <- p.do(p.many1(p.satisfy(fn(c) { c != "\n" })))
  use _ <- p.do(p.char("\n"))
  p.return(string.concat(id))
}

fn parse_name() -> p.Parser(String, Nil) {
  use _ <- p.do(p.string("name:"))
  use _ <- p.do(p.many1(p.alt(p.char(" "), p.char("\t"))))
  use name <- p.do(p.many1(p.satisfy(fn(c) { c != "\n" })))
  use _ <- p.do(p.char("\n"))
  p.return(string.concat(name))
}

fn parse_date() -> p.Parser(time.DateTime, Nil) {
  use _ <- p.do(p.string("date:"))
  use _ <- p.do(p.many1(p.alt(p.char(" "), p.char("\t"))))
  use datestr <- p.do(p.many1(p.satisfy(fn(c) { c != "\n" })))
  let assert Ok(date) = time.from_naive(string.concat(datestr))
  use _ <- p.do(p.char("\n"))
  p.return(date)
}

fn parse_block() -> p.Parser(Element(Nil), Nil) {
  use cmd <- p.do(parse_command())
  use strs <- p.do(p.many(p.alt(
    p.seq(p.char("\\"), p.char("@")),
    p.satisfy(fn(c) { c != "@" }),
  )))
  let str = string.concat(strs)
  use _ <- p.do(p.string("@end@"))
  case cmd {
    Paragraph -> {
      p.return(html.p([], [text(str)]))
    }
  }
}

fn parse_command() -> p.Parser(Command, Nil) {
  use _ <- p.do(p.many(p.choice([p.char(" "), p.char("\n"), p.char("\t")])))
  use _ <- p.do(p.char("@"))
  use text <- p.do(p.many1(p.alt(p.letter(), p.char("_"))))
  use _ <- p.do(p.char("@"))
  case string.concat(text) {
    "paragraph" -> p.return(Paragraph)
  }
}

fn do(el: a, k: fn() -> List(a)) -> List(a) {
  [el, ..k()]
}

fn finally(end: List(a)) -> List(a) {
  end
}

fn render_as_list(post: Post) -> List(Element(Nil)) {
  use <- do(html.h1([], [text(post.title)]))
  use <- do(html.div([class("date")], [text(time.to_naive(post.date))]))
  finally(post.body)
}

pub fn head(title: String, extra: List(Element(Nil))) -> Element(Nil) {
  html.head(
    [],
    list.append(
      [
        html.title([], title),
        html.meta([attribute.attribute("charset", "UTF-8")]),
        html.meta([
          attribute.attribute("name", "viewport"),
          attribute.attribute(
            "content",
            "width=device-width, initial-scale=1.0",
          ),
        ]),
        html.link([
          attribute.attribute("rel", "preconnect"),
          attribute.attribute("href", "https://fonts.googleapis.com"),
        ]),
        html.link([
          attribute.attribute("rel", "preconnect"),
          attribute.attribute("href", "https://fonts.gstatic.com"),
          attribute.attribute("crossorigin", "true"),
        ]),
        html.link([
          attribute.attribute("rel", "stylesheet"),
          attribute.attribute(
            "href",
            "https://fonts.googleapis.com/css2?family=Roboto&display=swap",
          ),
        ]),
      ],
      extra,
    ),
  )
}

pub fn render(post: Post) -> Element(Nil) {
  html.html(
    [attribute.attribute("lang", "en")],
    [
      head(
        post.title,
        [
          html.script(
            [attribute.attribute("type", "module")],
            "import '../public/style.css';",
          ),
        ],
      ),
      html.body([], render_as_list(post)),
    ],
  )
}
