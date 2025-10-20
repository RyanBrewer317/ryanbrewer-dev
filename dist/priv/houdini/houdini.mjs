import * as $escape from "./houdini/internal/escape_js.mjs";

export function escape(string) {
  return $escape.escape(string);
}
