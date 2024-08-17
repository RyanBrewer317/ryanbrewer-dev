// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import arctic.{type Page}
import arctic/parse
import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/result.{map_error}
import gleam/string
import lustre/attribute.{attribute}
import lustre/element.{text}
import lustre/element/html
import shellout
import simplifile
import snag.{type Result}

fn pretty_pos(pos: parse.Position) -> String {
  "line " <> int.to_string(pos.line) <> ", column " <> int.to_string(pos.column)
}

pub fn parse(path: String, content: String) -> Result(Page) {
  parse.new(0)
  |> parse.add_inline_rule("*", "*", parse.wrap_inline(html.i))
  |> parse.add_inline_rule("`", "`", parse.wrap_inline(html.code))
  |> parse.add_inline_rule("[", "]", fn(el, args, data) {
    use url <- result.try(
      list.first(args)
      |> map_error(fn(_) {
        snag.new(
          "bad parameters for link at " <> pretty_pos(parse.get_pos(data)),
        )
      }),
    )
    Ok(#(html.a([attribute.src(url)], [el]), parse.get_state(data)))
  })
  |> parse.add_prefix_rule("###", parse.wrap_prefix(html.h3))
  |> parse.add_static_component("diagram", fn(_args, body, data) {
    // TODO: use pos for error messages
    let counter = parse.get_state(data)
    let assert Ok(id) = dict.get(parse.get_metadata(data), "id")
    let img_filename = "image-" <> int.to_string(counter) <> "-" <> id <> ".svg"
    let out = #(
      html.div([attribute.class("diagram")], [
        html.img([
          attribute.src("/" <> img_filename),
          attribute.attribute("onload", "this.width *= 2.25;"),
        ]),
      ]),
      counter + 1,
    )
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
    // very simple caching: if we've generated an image with this name before, don't do it again
    // this works for now because I can always just delete an image file.
    // But in the future I want an actual caching system that detects updates.
    // Perhaps a sqlite db?
    use <- bool.guard(when: exists, return: Ok(out))
    let latex_code = "
\\documentclass[margin=0pt]{standalone}
\\usepackage{tikz-cd}
\\begin{document}
\\begin{tikzcd}\n" <> body <> "\\end{tikzcd}
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
  |> parse.add_static_component("code", fn(_args, body, data) {
    Ok(#(html.pre([], [html.code([], [text(body)])]), parse.get_state(data)))
  })
  |> parse.add_static_component("math", fn(_args, body, data) {
    use <- fn(k) { Ok(#(html.div([], k()), parse.get_state(data))) }
    use line <- list.map(string.split(body, on: "\n"))
    html.div([attribute.class("math-block")], [text("\\[" <> line <> "\\]")])
  })
  |> parse.parse(path, content)
}
