import * as $arctic from "../arctic/arctic.mjs";
import * as $parse from "../arctic/arctic/parse.mjs";
import * as $bool from "../gleam_stdlib/gleam/bool.mjs";
import * as $dict from "../gleam_stdlib/gleam/dict.mjs";
import * as $int from "../gleam_stdlib/gleam/int.mjs";
import * as $list from "../gleam_stdlib/gleam/list.mjs";
import * as $result from "../gleam_stdlib/gleam/result.mjs";
import { map_error } from "../gleam_stdlib/gleam/result.mjs";
import * as $string from "../gleam_stdlib/gleam/string.mjs";
import * as $attribute from "../lustre/lustre/attribute.mjs";
import { attribute } from "../lustre/lustre/attribute.mjs";
import * as $element from "../lustre/lustre/element.mjs";
import { text } from "../lustre/lustre/element.mjs";
import * as $html from "../lustre/lustre/element/html.mjs";
import * as $shellout from "../shellout/shellout.mjs";
import * as $simplifile from "../simplifile/simplifile.mjs";
import * as $snag from "../snag/snag.mjs";
import { Ok, toList, makeError } from "./gleam.mjs";

export function parse(path, content) {
  let _pipe = $parse.new$(0);
  let _pipe$1 = $parse.add_inline_rule(
    _pipe,
    "*",
    "*",
    $parse.wrap_inline($html.i),
  );
  let _pipe$2 = $parse.add_inline_rule(
    _pipe$1,
    "`",
    "`",
    $parse.wrap_inline($html.code),
  );
  let _pipe$3 = $parse.add_inline_rule(
    _pipe$2,
    "[",
    "]",
    (el, args, data) => {
      return $result.try$(
        (() => {
          let _pipe$3 = $list.first(args);
          return map_error(
            _pipe$3,
            (_) => { return $snag.new$("bad parameters for link"); },
          );
        })(),
        (url) => {
          return new Ok(
            [
              $html.a(toList([$attribute.src(url)]), toList([el])),
              $parse.get_state(data),
            ],
          );
        },
      );
    },
  );
  let _pipe$4 = $parse.add_prefix_rule(
    _pipe$3,
    "###",
    $parse.wrap_prefix($html.h3),
  );
  let _pipe$5 = $parse.add_static_component(
    _pipe$4,
    "diagram",
    (_, body, data) => {
      let counter = $parse.get_state(data);
      let $ = $dict.get($parse.get_metadata(data), "id");
      if (!$.isOk()) {
        throw makeError(
          "assignment_no_match",
          "parse",
          35,
          "",
          "Assignment pattern did not match",
          { value: $ }
        )
      }
      let id = $[0];
      let img_filename = ((("image-" + $int.to_string(counter)) + "-") + id) + ".svg";
      let out = [
        $html.div(
          toList([$attribute.class$("diagram")]),
          toList([
            $html.img(
              toList([
                $attribute.src("/" + img_filename),
                $attribute.attribute("onload", "this.width *= 2.25;"),
              ]),
            ),
          ]),
        ),
        counter + 1,
      ];
      return $result.try$(
        (() => {
          let _pipe$5 = $simplifile.verify_is_file("public/" + img_filename);
          return map_error(
            _pipe$5,
            (err) => {
              return $snag.new$(
                ((("couldn't check `public/" + img_filename) + "` (") + $simplifile.describe_error(
                  err,
                )) + ")",
              );
            },
          );
        })(),
        (exists) => {
          return $bool.guard(
            exists,
            new Ok(out),
            () => {
              let latex_code = ("\n\\documentclass[margin=0pt]{standalone}\n\\usepackage{tikz-cd}\n\\begin{document}\n\\begin{tikzcd}\n" + body) + "\\end{tikzcd}\n\\end{document}";
              return $result.try$(
                (() => {
                  let _pipe$5 = $simplifile.write(
                    "./diagram-work/diagram.tex",
                    latex_code,
                  );
                  return map_error(
                    _pipe$5,
                    (err) => {
                      return $snag.new$(
                        ("couldn't write to `diagram-work/diagram.tex` (" + $simplifile.describe_error(
                          err,
                        )) + ")",
                      );
                    },
                  );
                })(),
                (_) => {
                  return $result.try$(
                    (() => {
                      let _pipe$5 = $shellout.command(
                        "pdflatex",
                        toList(["-interaction", "nonstopmode", "diagram.tex"]),
                        "diagram-work",
                        toList([]),
                      );
                      return map_error(
                        _pipe$5,
                        (err) => {
                          return $snag.new$(
                            (("couldn't execute `pdflatex -interaction nonstopmode diagram.tex` in `diagram-work` (Code " + $int.to_string(
                              err[0],
                            )) + ": ") + err[1],
                          );
                        },
                      );
                    })(),
                    (_) => {
                      return $result.try$(
                        (() => {
                          let _pipe$5 = $shellout.command(
                            "inkscape",
                            toList([
                              "-l",
                              "--export-filename",
                              "../public/" + img_filename,
                              "diagram.pdf",
                            ]),
                            "diagram-work",
                            toList([new $shellout.LetBeStdout()]),
                          );
                          return map_error(
                            _pipe$5,
                            (err) => {
                              return $snag.new$(
                                ((((("couldn't execute `inkscape -l --export-filename ../public/" + img_filename) + " diagram.pdf` in `diagram-work` (Code ") + $int.to_string(
                                  err[0],
                                )) + ": ") + err[1]) + ")",
                              );
                            },
                          );
                        })(),
                        (_) => { return new Ok(out); },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    },
  );
  let _pipe$6 = $parse.add_static_component(
    _pipe$5,
    "code",
    (_, body, data) => {
      return new Ok(
        [
          $html.pre(
            toList([]),
            toList([$html.code(toList([]), toList([text(body)]))]),
          ),
          $parse.get_state(data),
        ],
      );
    },
  );
  let _pipe$7 = $parse.add_static_component(
    _pipe$6,
    "math",
    (_, body, data) => {
      return ((k) => {
        return new Ok([$html.div(toList([]), k()), $parse.get_state(data)]);
      })(
        () => {
          return $list.map(
            $string.split(body, "\n"),
            (line) => {
              return $html.div(
                toList([$attribute.class$("math-block")]),
                toList([text(("\\[" + line) + "\\]")]),
              );
            },
          );
        },
      );
    },
  );
  return $parse.parse(_pipe$7, path, content);
}
