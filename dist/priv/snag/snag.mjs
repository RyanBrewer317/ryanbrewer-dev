import * as $int from "../gleam_stdlib/gleam/int.mjs";
import * as $list from "../gleam_stdlib/gleam/list.mjs";
import * as $string from "../gleam_stdlib/gleam/string.mjs";
import * as $string_tree from "../gleam_stdlib/gleam/string_tree.mjs";
import * as $gleam from "./gleam.mjs";
import { Error, toList, prepend as listPrepend, CustomType as $CustomType } from "./gleam.mjs";

export class Snag extends $CustomType {
  constructor(issue, cause) {
    super();
    this.issue = issue;
    this.cause = cause;
  }
}

export function new$(issue) {
  return new Snag(issue, toList([]));
}

export function error(issue) {
  return new Error(new$(issue));
}

export function layer(snag, issue) {
  return new Snag(issue, listPrepend(snag.issue, snag.cause));
}

export function context(result, issue) {
  if (result.isOk()) {
    return result;
  } else {
    let snag = result[0];
    return new Error(layer(snag, issue));
  }
}

function pretty_print_cause(cause) {
  let _pipe = cause;
  let _pipe$1 = $list.index_map(
    _pipe,
    (line, index) => {
      return $string.concat(
        toList(["  ", $int.to_string(index), ": ", line, "\n"]),
      );
    },
  );
  return $string_tree.from_strings(_pipe$1);
}

export function pretty_print(snag) {
  let tree = $string_tree.from_strings(
    toList(["error: ", snag.issue, "\n"]),
  );
  return $string_tree.to_string(
    (() => {
      let $ = snag.cause;
      if ($.hasLength(0)) {
        return tree;
      } else {
        let cause = $;
        let _pipe = tree;
        let _pipe$1 = $string_tree.append(_pipe, "\ncause:\n");
        return $string_tree.append_tree(
          _pipe$1,
          pretty_print_cause(cause),
        );
      }
    })(),
  );
}

export function line_print(snag) {
  let _pipe = listPrepend($string.append("error: ", snag.issue), snag.cause);
  return $string.join(_pipe, " <- ");
}
