import * as $list from "../gleam_stdlib/gleam/list.mjs";
import { split, make } from "./splitter_ffi.mjs";

export { split };

export function new$(substrings) {
  let _pipe = substrings;
  let _pipe$1 = $list.filter(_pipe, (x) => { return x !== ""; });
  return make(_pipe$1);
}
