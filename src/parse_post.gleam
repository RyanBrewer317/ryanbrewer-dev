import simplifile.{read}
import gleam/string
import lustre/element.{type Element, text}
import lustre/element/html
import lustre/attribute.{type Attribute, attribute}
import gleam/result.{map_error, try}
import party as p
import helpers.{type Post, Post}

pub type Error {
  FileError(simplifile.FileError)
  ParseError(p.ParseError(Nil))
}

type Command {
  Paragraph
  Subheading
  CodeBlock
  MathBlock
}

pub fn go(filename: String) -> Result(Post, Error) {
  use content <- try(map_error(read(filename), FileError))
  map_error(p.go(parse(), content), ParseError)
}

fn parse() -> p.Parser(Post, Nil) {
  use id <- p.do(parse_id())
  use name <- p.do(parse_name())
  use date <- p.do(parse_date())
  use tags <- p.do(parse_tags())
  use desc <- p.do(parse_description())
  use els <- p.do(p.many(parse_block()))
  p.return(Post(name, id, date, tags, desc, els))
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

fn parse_date() -> p.Parser(helpers.DateTime, Nil) {
  use _ <- p.do(p.string("date:"))
  use _ <- p.do(p.many1(p.alt(p.char(" "), p.char("\t"))))
  use datestr <- p.do(p.many1(p.satisfy(fn(c) { c != "\n" })))
  let assert Ok(date) = helpers.string_to_date(string.concat(datestr))
  use _ <- p.do(p.char("\n"))
  p.return(date)
}

fn parse_description() -> p.Parser(String, Nil) {
  use _ <- p.do(p.string("description:"))
  use _ <- p.do(p.many1(p.alt(p.char(" "), p.char("\t"))))
  use desc <- p.do(p.many1(p.satisfy(fn(c) { c != "\n" })))
  use _ <- p.do(p.char("\n"))
  p.return(string.concat(desc))
}

fn parse_tags() -> p.Parser(List(String), Nil) {
  use _ <- p.do(p.string("tags:"))
  use _ <- p.do(p.many1(p.alt(p.char(" "), p.char("\t"))))
  use tags_str <- p.do(p.many1(p.satisfy(fn(c) { c != "\n" })))
  use _ <- p.do(p.char("\n"))
  p.return(string.split(string.concat(tags_str), ","))
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
    Subheading -> p.return(html.h3([], [text(str)]))
    CodeBlock -> p.return(html.pre([], [html.code([], [text(str)])]))
    MathBlock ->
      p.return(html.div(
        [attribute.class("math-block")],
        [text("\\[" <> str <> "\\]")],
      ))
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
    "code" -> p.return(CodeBlock)
    "math" -> p.return(MathBlock)
  }
}
