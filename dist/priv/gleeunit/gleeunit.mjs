import * as $list from "../gleam_stdlib/gleam/list.mjs";
import * as $result from "../gleam_stdlib/gleam/result.mjs";
import * as $string from "../gleam_stdlib/gleam/string.mjs";
import { CustomType as $CustomType } from "./gleam.mjs";
import { main as do_main } from "./gleeunit_ffi.mjs";

class Utf8 extends $CustomType {}

class GleeunitProgress extends $CustomType {}

class Colored extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Verbose extends $CustomType {}

class NoTty extends $CustomType {}

class Report extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

function gleam_to_erlang_module_name(path) {
  let $ = $string.ends_with(path, ".gleam");
  if ($) {
    let _pipe = path;
    let _pipe$1 = $string.replace(_pipe, ".gleam", "");
    return $string.replace(_pipe$1, "/", "@");
  } else {
    let _pipe = path;
    let _pipe$1 = $string.split(_pipe, "/");
    let _pipe$2 = $list.last(_pipe$1);
    let _pipe$3 = $result.unwrap(_pipe$2, path);
    return $string.replace(_pipe$3, ".erl", "");
  }
}

export function main() {
  return do_main();
}
