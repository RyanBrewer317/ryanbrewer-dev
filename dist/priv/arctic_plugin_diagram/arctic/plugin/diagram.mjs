import * as $parse from "../../../arctic/arctic/parse.mjs";
import * as $bool from "../../../gleam_stdlib/gleam/bool.mjs";
import * as $dict from "../../../gleam_stdlib/gleam/dict.mjs";
import * as $int from "../../../gleam_stdlib/gleam/int.mjs";
import * as $io from "../../../gleam_stdlib/gleam/io.mjs";
import * as $result from "../../../gleam_stdlib/gleam/result.mjs";
import { map_error } from "../../../gleam_stdlib/gleam/result.mjs";
import * as $attribute from "../../../lustre/lustre/attribute.mjs";
import * as $html from "../../../lustre/lustre/element/html.mjs";
import * as $shellout from "../../../shellout/shellout.mjs";
import * as $simplifile from "../../../simplifile/simplifile.mjs";
import * as $snag from "../../../snag/snag.mjs";
import { Ok, toList, makeError } from "../../gleam.mjs";

export function parse(dir, get_id, to_state) {
  return (_, body, data) => {
    let counter = get_id($parse.get_state(data));
    let $ = $dict.get($parse.get_metadata(data), "id");
    if (!$.isOk()) {
      throw makeError(
        "assignment_no_match",
        "arctic/plugin/diagram",
        17,
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
      to_state(counter + 1),
    ];
    return $result.try$(
      (() => {
        let _pipe = $simplifile.is_file((dir + "/") + img_filename);
        return map_error(
          _pipe,
          (err) => {
            return $snag.new$(
              ((((("couldn't check `" + dir) + "/") + img_filename) + "` (") + $simplifile.describe_error(
                err,
              )) + ")",
            );
          },
        );
      })(),
      (exists) => {
        $io.debug(img_filename);
        return $bool.guard(
          exists,
          new Ok(out),
          () => {
            let latex_code = ("\n\\documentclass[margin=0pt]{standalone}\n\\usepackage{tikz-cd}\n\\begin{document}\n\\begin{tikzcd}\n" + body) + "\\end{tikzcd}\n\\end{document}";
            return $result.try$(
              (() => {
                let _pipe = $simplifile.write(
                  "./diagram-work/diagram.tex",
                  latex_code,
                );
                return map_error(
                  _pipe,
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
                    let _pipe = $shellout.command(
                      "pdflatex",
                      toList(["-interaction", "nonstopmode", "diagram.tex"]),
                      "diagram-work",
                      toList([]),
                    );
                    return map_error(
                      _pipe,
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
                    $io.debug("made diagram.pdf");
                    return $result.try$(
                      (() => {
                        let _pipe = $shellout.command(
                          "inkscape",
                          toList([
                            "-l",
                            "--export-filename",
                            (("../" + dir) + "/") + img_filename,
                            "diagram.pdf",
                          ]),
                          "diagram-work",
                          toList([new $shellout.LetBeStdout()]),
                        );
                        return map_error(
                          _pipe,
                          (err) => {
                            return $snag.new$(
                              ((((((("couldn't execute `inkscape -l --export-filename ../" + dir) + "/") + img_filename) + " diagram.pdf` in `diagram-work` (Code ") + $int.to_string(
                                err[0],
                              )) + ": ") + err[1]) + ")",
                            );
                          },
                        );
                      })(),
                      (_) => {
                        $io.debug((("made " + dir) + "/") + img_filename);
                        return new Ok(out);
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
  };
}
