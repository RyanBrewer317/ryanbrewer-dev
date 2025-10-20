import { do_escape } from "../../houdini.ffi.mjs";

export function escape(text) {
  return do_escape(text);
}
