import * as $arctic from "../arctic/arctic.mjs";
import * as $parse from "../arctic/arctic/parse.mjs";
import * as $diagram from "../arctic_plugin_diagram/arctic/plugin/diagram.mjs";
import * as $list from "../gleam_stdlib/gleam/list.mjs";
import * as $result from "../gleam_stdlib/gleam/result.mjs";
import { map_error } from "../gleam_stdlib/gleam/result.mjs";
import * as $string from "../gleam_stdlib/gleam/string.mjs";
import * as $attribute from "../lustre/lustre/attribute.mjs";
import * as $element from "../lustre/lustre/element.mjs";
import { text } from "../lustre/lustre/element.mjs";
import * as $html from "../lustre/lustre/element/html.mjs";
import * as $snag from "../snag/snag.mjs";
import { Ok, toList, Empty as $Empty } from "./gleam.mjs";

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
              $html.a(toList([$attribute.href(url)]), toList([el])),
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
    $diagram.parse("public", (x) => { return x; }, (x) => { return x; }),
  );
  let _pipe$6 = $parse.add_static_component(
    _pipe$5,
    "code",
    (args, body, data) => {
      let body2 = $string.replace(body, "\\n", "\n");
      if (args instanceof $Empty) {
        return new Ok(
          [
            $html.pre(
              toList([]),
              toList([$html.code(toList([]), toList([text(body2)]))]),
            ),
            $parse.get_state(data),
          ],
        );
      } else {
        let $ = args.tail;
        if ($ instanceof $Empty) {
          let lang = args.head;
          return new Ok(
            [
              $html.pre(
                toList([]),
                toList([
                  $html.code(
                    toList([$attribute.class$("language-" + lang)]),
                    toList([text(body2)]),
                  ),
                ]),
              ),
              $parse.get_state(data),
            ],
          );
        } else {
          return new Ok(
            [
              $html.pre(
                toList([]),
                toList([$html.code(toList([]), toList([text(body2)]))]),
              ),
              $parse.get_state(data),
            ],
          );
        }
      }
    },
  );
  let _pipe$7 = $parse.add_static_component(
    _pipe$6,
    "math",
    (_, body, data) => {
      let el = $html.div(
        toList([$attribute.class$("math-block")]),
        toList([text(("\\[" + body) + "\\]")]),
      );
      return new Ok([el, $parse.get_state(data)]);
    },
  );
  return $parse.parse(_pipe$7, path, content);
}
