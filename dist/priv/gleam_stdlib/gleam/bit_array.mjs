import { toList, remainderInt } from "../gleam.mjs";
import * as $int from "../gleam/int.mjs";
import * as $order from "../gleam/order.mjs";
import * as $string from "../gleam/string.mjs";
import {
  bit_array_from_string as from_string,
  length as byte_size,
  bit_array_slice as slice,
  bit_array_concat as concat,
  encode64 as base64_encode,
  decode64,
  base16_encode,
  base16_decode,
  bit_array_inspect as do_inspect,
  bit_array_compare as compare,
  bit_array_to_string as do_to_string,
} from "../gleam_stdlib.mjs";

export {
  base16_decode,
  base16_encode,
  base64_encode,
  byte_size,
  compare,
  concat,
  from_string,
  slice,
};

export function append(first, second) {
  return concat(toList([first, second]));
}

export function base64_decode(encoded) {
  let padded = (() => {
    let $ = remainderInt(byte_size(from_string(encoded)), 4);
    if ($ === 0) {
      return encoded;
    } else {
      let n = $;
      return $string.append(encoded, $string.repeat("=", 4 - n));
    }
  })();
  return decode64(padded);
}

export function base64_url_encode(input, padding) {
  let _pipe = base64_encode(input, padding);
  let _pipe$1 = $string.replace(_pipe, "+", "-");
  return $string.replace(_pipe$1, "/", "_");
}

export function base64_url_decode(encoded) {
  let _pipe = encoded;
  let _pipe$1 = $string.replace(_pipe, "-", "+");
  let _pipe$2 = $string.replace(_pipe$1, "_", "/");
  return base64_decode(_pipe$2);
}

export function inspect(input) {
  return do_inspect(input, "<<") + ">>";
}

export function is_utf8(bits) {
  return do_is_utf8(bits);
}

function do_is_utf8(bits) {
  let $ = to_string(bits);
  if ($.isOk()) {
    return true;
  } else {
    return false;
  }
}

export function to_string(bits) {
  return do_to_string(bits);
}
