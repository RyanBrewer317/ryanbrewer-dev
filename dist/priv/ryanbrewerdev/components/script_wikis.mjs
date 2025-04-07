import * as $arctic from "../../arctic/arctic.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $string from "../../gleam_stdlib/gleam/string.mjs";
import * as $string_tree from "../../gleam_stdlib/gleam/string_tree.mjs";
import { append, append_tree, concat, from_string, join, to_string } from "../../gleam_stdlib/gleam/string_tree.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { toList } from "../gleam.mjs";

export function script_wikis(wikis) {
  return ((k) => {
    return $html.script(
      toList([]),
      (() => {
        let _pipe = from_string("const WIKIS = {");
        let _pipe$1 = append_tree(_pipe, concat(k()));
        let _pipe$2 = append(_pipe$1, "};");
        return to_string(_pipe$2);
      })(),
    );
  })(
    () => {
      return $list.map(
        wikis,
        (cw) => {
          let w = $arctic.to_dummy_page(cw);
          let _pipe = from_string("\"");
          let _pipe$1 = append(_pipe, w.id);
          let _pipe$2 = append(_pipe$1, "\": {\"id\": \"");
          let _pipe$3 = append(_pipe$2, w.id);
          let _pipe$4 = append(_pipe$3, "\", \"url\": \"");
          let _pipe$5 = append(_pipe$4, "/posts/" + w.id);
          let _pipe$6 = append(_pipe$5, "\", \"title\": \"");
          let _pipe$7 = append(_pipe$6, $string.replace(w.title, "\"", "\\\""));
          let _pipe$8 = append(_pipe$7, "\", \"tags\": [");
          let _pipe$9 = append_tree(
            _pipe$8,
            join(
              $list.map(
                w.tags,
                (tag) => {
                  let _pipe$9 = from_string("\"");
                  let _pipe$10 = append(_pipe$9, tag);
                  return append(_pipe$10, "\"");
                },
              ),
              ", ",
            ),
          );
          return append(_pipe$9, "]},\n");
        },
      );
    },
  );
}
