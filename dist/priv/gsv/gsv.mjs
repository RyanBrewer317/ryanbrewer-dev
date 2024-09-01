import * as $int from "../gleam_stdlib/gleam/int.mjs";
import * as $list from "../gleam_stdlib/gleam/list.mjs";
import * as $result from "../gleam_stdlib/gleam/result.mjs";
import * as $string from "../gleam_stdlib/gleam/string.mjs";
import { toList, CustomType as $CustomType, makeError } from "./gleam.mjs";
import * as $ast from "./gsv/internal/ast.mjs";
import { ParseError } from "./gsv/internal/ast.mjs";
import * as $token from "./gsv/internal/token.mjs";
import { Location } from "./gsv/internal/token.mjs";

export class Windows extends $CustomType {}

export class Unix extends $CustomType {}

export function to_lists(input) {
  let _pipe = input;
  let _pipe$1 = $token.scan(_pipe);
  let _pipe$2 = $token.with_location(_pipe$1);
  let _pipe$3 = $ast.parse(_pipe$2);
  return $result.nil_error(_pipe$3);
}

export function to_lists_or_panic(input) {
  let res = (() => {
    let _pipe = input;
    let _pipe$1 = $token.scan(_pipe);
    let _pipe$2 = $token.with_location(_pipe$1);
    return $ast.parse(_pipe$2);
  })();
  if (res.isOk()) {
    let lol = res[0];
    return lol;
  } else {
    let line = res[0].location.line;
    let column = res[0].location.column;
    let msg = res[0].message;
    throw makeError(
      "panic",
      "gsv",
      31,
      "to_lists_or_panic",
      (((((("[" + "line ") + $int.to_string(line)) + " column ") + $int.to_string(
        column,
      )) + "] of csv: ") + msg),
      {}
    )
    return toList([toList([])]);
  }
}

export function to_lists_or_error(input) {
  let _pipe = input;
  let _pipe$1 = $token.scan(_pipe);
  let _pipe$2 = $token.with_location(_pipe$1);
  let _pipe$3 = $ast.parse(_pipe$2);
  return $result.map_error(
    _pipe$3,
    (e) => {
      let line = e.location.line;
      let column = e.location.column;
      let msg = e.message;
      return ((((("[" + "line ") + $int.to_string(line)) + " column ") + $int.to_string(
        column,
      )) + "] of csv: ") + msg;
    },
  );
}

function le_to_string(le) {
  if (le instanceof Windows) {
    return "\r\n";
  } else {
    return "\n";
  }
}

export function from_lists(input, separator, line_ending) {
  let _pipe = input;
  let _pipe$1 = $list.map(
    _pipe,
    (row) => {
      return $list.map(
        row,
        (entry) => {
          let entry$1 = $string.replace(entry, "\"", "\"\"");
          let $ = ($string.contains(entry$1, separator) || $string.contains(
            entry$1,
            "\n",
          )) || $string.contains(entry$1, "\"");
          if ($) {
            return ("\"" + entry$1) + "\"";
          } else {
            return entry$1;
          }
        },
      );
    },
  );
  let _pipe$2 = $list.map(
    _pipe$1,
    (row) => { return $string.join(row, separator); },
  );
  return $string.join(_pipe$2, le_to_string(line_ending));
}
