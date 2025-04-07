import * as $arctic from "../../arctic/arctic.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import { Some } from "../../gleam_stdlib/gleam/option.mjs";
import * as $string from "../../gleam_stdlib/gleam/string.mjs";
import * as $string_tree from "../../gleam_stdlib/gleam/string_tree.mjs";
import { append, append_tree, concat, from_string, join, to_string } from "../../gleam_stdlib/gleam/string_tree.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { toList, makeError } from "../gleam.mjs";
import * as $helpers from "../helpers.mjs";
import { pretty_date } from "../helpers.mjs";

export function script_posts(posts) {
  return ((k) => {
    return $html.script(
      toList([]),
      (() => {
        let _pipe = from_string("const POSTS = {");
        let _pipe$1 = append_tree(_pipe, concat(k()));
        let _pipe$2 = append(_pipe$1, "};");
        return to_string(_pipe$2);
      })(),
    );
  })(
    () => {
      return $list.map(
        posts,
        (cp) => {
          let p = $arctic.to_dummy_page(cp);
          let $ = p.date;
          if (!($ instanceof Some)) {
            throw makeError(
              "let_assert",
              "components/script_posts",
              29,
              "",
              "Pattern match failed, no pattern matched the value.",
              { value: $ }
            )
          }
          let date = $[0];
          let _pipe = from_string("\"");
          let _pipe$1 = append(_pipe, p.id);
          let _pipe$2 = append(_pipe$1, "\": {\"id\": \"");
          let _pipe$3 = append(_pipe$2, p.id);
          let _pipe$4 = append(_pipe$3, "\", \"url\": \"");
          let _pipe$5 = append(_pipe$4, "/posts/" + p.id);
          let _pipe$6 = append(_pipe$5, "\", \"title\": \"");
          let _pipe$7 = append(_pipe$6, $string.replace(p.title, "\"", "\\\""));
          let _pipe$8 = append(_pipe$7, "\", \"date\": \"");
          let _pipe$9 = append(_pipe$8, pretty_date(date));
          let _pipe$10 = append(_pipe$9, "\", \"tags\": [");
          let _pipe$11 = append_tree(
            _pipe$10,
            join(
              $list.map(
                p.tags,
                (tag) => {
                  let _pipe$11 = from_string("\"");
                  let _pipe$12 = append(_pipe$11, tag);
                  return append(_pipe$12, "\"");
                },
              ),
              ", ",
            ),
          );
          let _pipe$12 = append(_pipe$11, "], \"description\": \"");
          let _pipe$13 = append(
            _pipe$12,
            $string.replace(p.blerb, "\"", "\\\""),
          );
          return append(_pipe$13, "\"},\n");
        },
      );
    },
  );
}
