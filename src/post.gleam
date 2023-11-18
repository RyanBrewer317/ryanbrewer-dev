import simplifile.{read}
import gleam/string
import gleam/order.{type Order}
import lustre/element.{type Element, text}
import lustre/element/html
import lustre/attribute.{type Attribute, attribute}
import gleam/result.{map_error, try}
import birl/time.{type DateTime}
import party as p
import gleam/list
import gleam/int

pub type Post {
  Post(title: String, id: String, date: DateTime, body: List(Element(Nil)))
}

pub type Error {
  FileError(simplifile.FileError)
  ParseError(p.ParseError(Nil))
}

type Command {
  Paragraph
  Subheading
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
    Paragraph -> p.return(parse_paragraph(str))

    Subheading -> p.return(html.h4([], [text(str)]))
  }
}

fn parse_paragraph(p: String) -> Element(Nil) {
  let assert Ok(els) =
    p.go(
      {
        use els <- p.do(p.many(p.choice([
          parse_markup("*", html.i),
          parse_markup("`", html.code),
          parse_link(),
          escape("\\"),
          escape("*"),
          escape("@"),
          escape("`"),
          p.map(p.satisfy(fn(_) { True }), fn(c) { text(c) }),
        ])))
        p.return(els)
      },
      p,
    )
  html.p([], els)
}

fn escape(char: String) -> p.Parser(Element(Nil), Nil) {
  use _ <- p.do(p.char("\\"))
  use _ <- p.do(p.char(char))
  p.return(text(char))
}

fn parse_link() -> p.Parser(Element(Nil), Nil) {
  use _ <- p.do(p.char("["))
  use chars <- p.do(p.many(p.satisfy(fn(c) { c != "]" })))
  let url = string.concat(chars)
  use _ <- p.do(p.string("]("))
  use chars <- p.do(p.many(p.satisfy(fn(c) { c != ")" })))
  let str = string.concat(chars)
  use _ <- p.do(p.char(")"))
  p.return(html.a([attribute.href(url)], [text(str)]))
}

fn parse_markup(
  char: String,
  el: fn(List(Attribute(Nil)), List(Element(Nil))) -> Element(Nil),
) -> p.Parser(Element(Nil), Nil) {
  use _ <- p.do(p.char(char))
  use strs <- p.do(p.many(p.alt(
    p.seq(p.char("\\"), p.char(char)),
    p.satisfy(fn(c) { c != char }),
  )))
  let str = string.concat(strs)
  use _ <- p.do(p.char(char))
  p.return(el([], [text(str)]))
}

fn parse_command() -> p.Parser(Command, Nil) {
  use _ <- p.do(p.many(p.choice([p.char(" "), p.char("\n"), p.char("\t")])))
  use _ <- p.do(p.char("@"))
  use text <- p.do(p.many1(p.alt(p.letter(), p.char("_"))))
  use _ <- p.do(p.char("@"))
  case string.concat(text) {
    "paragraph" -> p.return(Paragraph)
    "subheading" -> p.return(Subheading)
  }
}

fn do(el: a, k: fn() -> List(a)) -> List(a) {
  [el, ..k()]
}

fn finally(end: List(a)) -> List(a) {
  end
}

fn pretty_date(date: DateTime) -> String {
  let time.Date(year, _, day) = time.get_date(date)
  time.string_month(date) <> " " <> int.to_string(day) <> ", " <> int.to_string(
    year,
  )
}

fn render_as_list(post: Post) -> List(Element(Nil)) {
  use <- do(html.h1([], [text(post.title)]))
  use <- do(html.div([attribute.class("date")], [text(pretty_date(post.date))]))
  finally(post.body)
}

pub fn head(title: String, extra: List(Element(Nil))) -> Element(Nil) {
  html.head(
    [],
    list.append(
      [
        html.title([], title),
        html.meta([attribute("charset", "UTF-8")]),
        html.meta([
          attribute.name("viewport"),
          attribute("content", "width=device-width, initial-scale=1.0"),
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
      ],
      extra,
    ),
  )
}

pub fn render(post: Post) -> Element(Nil) {
  html.html(
    [attribute("lang", "en")],
    [
      head(
        post.title,
        [html.script([attribute.type_("module")], "import '../../style.css';")],
      ),
      html.body(
        [],
        [
          html.nav(
            [],
            [
              html.a(
                [attribute.href("https://ryanbrewer.dev")],
                [text("Ryan Brewer")],
              ),
            ],
          ),
          html.div([attribute.id("body")], render_as_list(post)),
        ],
      ),
    ],
  )
}
