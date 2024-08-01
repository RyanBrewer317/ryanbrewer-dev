// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/result.{map_error}
import gleam/string
import helpers.{type Post, type Wiki, Post, Wiki}
import lustre/attribute.{type Attribute, attribute}
import lustre/element.{type Element, text}
import lustre/element/html
import party as p
import shellout
import simplifile
import snag.{type Result}

pub type State {
  State(id: String, counter: Int)
}

type Command {
  Paragraph
  Subheading
  CodeBlock
  MathBlock
  DiagramBlock
}

fn pretty_pos(pos: p.Position) -> String {
  "line " <> int.to_string(pos.row) <> ", column " <> int.to_string(pos.col)
}

pub fn post(filename: String) -> Result(Post) {
  use content <- result.try(
    map_error(simplifile.read(filename), fn(err) {
      snag.new(
        "could not load file `"
        <> filename
        <> "` ("
        <> simplifile.describe_error(err)
        <> ")",
      )
    }),
  )
  map_error(p.go(parse_post(), content), fn(err) {
    snag.new("parse error at " <> pretty_pos(err.pos))
  })
  |> result.flatten
}

pub fn wiki(filename: String) -> Result(Wiki) {
  use content <- result.try(
    map_error(simplifile.read(filename), fn(err) {
      snag.new(
        "could not load file `"
        <> filename
        <> "` ("
        <> simplifile.describe_error(err)
        <> ")",
      )
    }),
  )
  map_error(p.go(parse_wiki(), content), fn(err) {
    snag.new("parse error at " <> pretty_pos(err.pos))
  })
  |> result.flatten
}

fn parse_post() -> p.Parser(Result(Post), Nil) {
  use id <- p.do(parse_id())
  use name <- p.do(parse_name())
  use mb_date <- p.do(parse_date())
  use tags <- p.do(parse_tags())
  use desc <- p.do(parse_description())
  use #(mb_els, _) <- p.do(p.stateful_many(
    State(id: id, counter: 0),
    parse_block(),
  ))
  p.return(
    {
      use date <- result.try(mb_date)
      use els <- result.try(
        result.all(mb_els)
        |> snag.context("couldn't parse post body"),
      )
      Ok(Post(name, id, date, tags, desc, els))
    }
    |> snag.context("couldn't parse post"),
  )
}

fn parse_wiki() -> p.Parser(Result(Wiki), Nil) {
  use id <- p.do(parse_id())
  use name <- p.do(parse_name())
  use tags <- p.do(parse_tags())
  use #(mb_els, _) <- p.do(p.stateful_many(
    State(id: id, counter: 0),
    parse_block(),
  ))
  p.return(
    {
      use els <- result.try(
        result.all(mb_els)
        |> snag.context("couldn't parse post body"),
      )
      Ok(Wiki(name, id, tags, els))
    }
    |> snag.context("couldn't parse post"),
  )
}

fn parse_id() -> p.Parser(String, Nil) {
  use _ <- p.do(p.string("id:"))
  use _ <- p.do(p.many1(p.either(p.char(" "), p.char("\t"))))
  use id_strs <- p.do(p.many1(p.satisfy(fn(c) { c != "\n" })))
  let id = string.concat(id_strs)
  use _ <- p.do(p.char("\n"))
  p.return(id)
}

fn parse_name() -> p.Parser(String, Nil) {
  use _ <- p.do(p.string("name:"))
  use _ <- p.do(p.many1(p.either(p.char(" "), p.char("\t"))))
  use name <- p.do(p.many1(p.satisfy(fn(c) { c != "\n" })))
  use _ <- p.do(p.char("\n"))
  p.return(string.concat(name))
}

fn parse_date() -> p.Parser(Result(helpers.Date), Nil) {
  use _ <- p.do(p.string("date:"))
  use _ <- p.do(p.many1(p.either(p.char(" "), p.char("\t"))))
  use datestr <- p.do(p.many1_concat(p.satisfy(fn(c) { c != "\n" })))
  use _ <- p.do(p.char("\n"))
  helpers.string_to_date(datestr)
  |> map_error(fn(_) { snag.new("couldn't parse date `" <> datestr <> "`") })
  |> p.return
}

fn parse_description() -> p.Parser(String, Nil) {
  use _ <- p.do(p.string("description:"))
  use _ <- p.do(p.many1(p.either(p.char(" "), p.char("\t"))))
  use desc <- p.do(p.many1(p.satisfy(fn(c) { c != "\n" })))
  use _ <- p.do(p.char("\n"))
  p.return(string.concat(desc))
}

fn parse_tags() -> p.Parser(List(String), Nil) {
  use _ <- p.do(p.string("tags:"))
  use _ <- p.do(p.many1(p.either(p.char(" "), p.char("\t"))))
  use tags_str <- p.do(p.many1(p.satisfy(fn(c) { c != "\n" })))
  use _ <- p.do(p.char("\n"))
  p.return(string.split(string.concat(tags_str), ","))
}

fn stateful(a: a) -> fn(s) -> #(a, s) {
  fn(s) { #(a, s) }
}

fn parse_block() -> p.Parser(fn(State) -> #(Result(Element(Nil)), State), Nil) {
  use cmd <- p.do(parse_command())
  use _ <- p.do(p.many(p.either(p.char(" "), p.char("\t"))))
  use _ <- p.do(p.char("\n"))
  use strs <- p.do(
    p.many(p.either(
      p.seq(p.char("\\"), p.char("@")),
      p.satisfy(fn(c) { c != "@" }),
    )),
  )
  let str = string.concat(strs)
  use _ <- p.do(p.string("@end@"))
  case cmd {
    Paragraph ->
      p.return(
        parse_paragraph(str)
        |> stateful,
      )
    Subheading ->
      p.return(
        html.h3([], [text(str)])
        |> Ok
        |> stateful,
      )
    CodeBlock ->
      p.return(
        html.pre([], [html.code([], [text(str)])])
        |> Ok
        |> stateful,
      )
    MathBlock -> {
      use <-
        fn(k) {
          p.return(
            html.div([], k())
            |> Ok
            |> stateful,
          )
        }
      use line <- list.map(string.split(str, on: "\n"))
      html.div([attribute.class("math-block")], [text("\\[" <> line <> "\\]")])
    }
    DiagramBlock -> {
      p.return(fn(state: State) {
        let new_state = State(id: state.id, counter: state.counter + 1)
        let img_filename =
          "image-" <> int.to_string(state.counter) <> "-" <> state.id <> ".svg"
        let out =
          html.div([attribute.class("diagram")], [
            html.img([
              attribute.src("/" <> img_filename),
              attribute.attribute("onload", "this.width *= 2.25;"),
            ]),
          ])
        use <- fn(k) { #(k(), new_state) }
        use exists <- result.try(
          simplifile.verify_is_file("public/" <> img_filename)
          |> map_error(fn(err) {
            snag.new(
              "couldn't check `public/"
              <> img_filename
              <> "` ("
              <> simplifile.describe_error(err)
              <> ")",
            )
          }),
        )
        io.debug(exists)
        // very simple caching: if we've generated an image with this name before, don't do it again
        // this works for now because I can always just delete an image file.
        // But in the future I want an actual caching system that detects updates.
        // Perhaps a sqlite db?
        use <- bool.guard(when: exists, return: Ok(out))
        let latex_code = "
\\documentclass[margin=0pt]{standalone}
\\usepackage{tikz-cd}
\\begin{document}
\\begin{tikzcd}\n" <> str <> "\\end{tikzcd}
\\end{document}"
        use _ <- result.try(
          simplifile.write(latex_code, to: "./diagram-work/diagram.tex")
          |> map_error(fn(err) {
            snag.new(
              "couldn't write to `diagram-work/diagram.tex` ("
              <> simplifile.describe_error(err)
              <> ")",
            )
          }),
        )
        use _ <- result.try(
          shellout.command(
            run: "pdflatex",
            with: ["-interaction", "nonstopmode", "diagram.tex"],
            in: "diagram-work",
            opt: [],
          )
          |> map_error(fn(err) {
            snag.new(
              "couldn't execute `pdflatex -interaction nonstopmode diagram.tex` in `diagram-work` (Code "
              <> int.to_string(err.0)
              <> ": "
              <> err.1,
            )
          }),
        )
        use _ <- result.try(
          shellout.command(
            run: "inkscape",
            with: [
              "-l",
              "--export-filename",
              "../public/" <> img_filename,
              "diagram.pdf",
            ],
            in: "diagram-work",
            opt: [shellout.LetBeStdout],
          )
          |> map_error(fn(err) {
            snag.new(
              "couldn't execute `inkscape -l --export-filename ../public/"
              <> img_filename
              <> " diagram.pdf` in `diagram-work` (Code "
              <> int.to_string(err.0)
              <> ": "
              <> err.1
              <> ")",
            )
          }),
        )
        Ok(out)
      })
    }
  }
}

fn parse_paragraph(s: String) -> Result(Element(Nil)) {
  use els <- result.try(
    p.go(
      {
        use els <- p.do(
          p.many(
            p.choice([
              parse_markup("*", html.i),
              parse_markup("`", html.code),
              parse_link(),
              escape("\\"),
              escape("*"),
              escape("@"),
              escape("`"),
              p.map(p.satisfy(fn(_) { True }), fn(c) { text(c) }),
            ]),
          ),
        )
        p.return(els)
      },
      s,
    )
    |> map_error(fn(_err) { snag.new("parse error in paragraph") }),
  )
  Ok(html.p([], els))
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
  use strs <- p.do(
    p.many(p.either(
      p.seq(p.char("\\"), p.char(char)),
      p.satisfy(fn(c) { c != char }),
    )),
  )
  let str = string.concat(strs)
  use _ <- p.do(p.char(char))
  p.return(el([], [text(str)]))
}

fn parse_command() -> p.Parser(Command, Nil) {
  use _ <- p.do(p.many(p.choice([p.char(" "), p.char("\n"), p.char("\t")])))
  use _ <- p.do(p.char("@"))
  use text <- p.do(p.many1(p.either(p.letter(), p.char("_"))))
  use _ <- p.do(p.char("@"))
  case string.concat(text) {
    "paragraph" -> p.return(Paragraph)
    "subheading" -> p.return(Subheading)
    "code" -> p.return(CodeBlock)
    "math" -> p.return(MathBlock)
    "diagram" -> p.return(DiagramBlock)
    _ -> panic as { "unknown command " <> string.concat(text) }
  }
}
