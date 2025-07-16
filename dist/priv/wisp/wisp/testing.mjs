import * as $crypto from "../../gleam_crypto/gleam/crypto.mjs";
import * as $http from "../../gleam_http/gleam/http.mjs";
import * as $request from "../../gleam_http/gleam/http/request.mjs";
import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $bit_array from "../../gleam_stdlib/gleam/bit_array.mjs";
import * as $bytes_tree from "../../gleam_stdlib/gleam/bytes_tree.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import { None, Some } from "../../gleam_stdlib/gleam/option.mjs";
import * as $string from "../../gleam_stdlib/gleam/string.mjs";
import * as $string_tree from "../../gleam_stdlib/gleam/string_tree.mjs";
import * as $uri from "../../gleam_stdlib/gleam/uri.mjs";
import * as $simplifile from "../../simplifile/simplifile.mjs";
import { Ok, Empty as $Empty, makeError, toBitArray, stringBits } from "../gleam.mjs";
import * as $wisp from "../wisp.mjs";
import { Bytes, Empty, File, Text } from "../wisp.mjs";

const FILEPATH = "src/wisp/testing.gleam";

export function string_body(response) {
  let $ = response.body;
  if ($ instanceof Text) {
    let tree = $[0];
    return $string_tree.to_string(tree);
  } else if ($ instanceof Bytes) {
    let bytes = $[0];
    let data = $bytes_tree.to_bit_array(bytes);
    let $1 = $bit_array.to_string(data);
    if (!($1 instanceof Ok)) {
      throw makeError(
        "let_assert",
        FILEPATH,
        "wisp/testing",
        233,
        "string_body",
        "Pattern match failed, no pattern matched the value.",
        {
          value: $1,
          start: 7349,
          end: 7398,
          pattern_start: 7360,
          pattern_end: 7370
        }
      )
    }
    let string = $1[0];
    return string;
  } else if ($ instanceof File) {
    let path = $.path;
    let $1 = $simplifile.read(path);
    if (!($1 instanceof Ok)) {
      throw makeError(
        "let_assert",
        FILEPATH,
        "wisp/testing",
        237,
        "string_body",
        "Pattern match failed, no pattern matched the value.",
        {
          value: $1,
          start: 7444,
          end: 7491,
          pattern_start: 7455,
          pattern_end: 7467
        }
      )
    }
    let contents = $1[0];
    return contents;
  } else {
    return "";
  }
}

export function bit_array_body(response) {
  let $ = response.body;
  if ($ instanceof Text) {
    let tree = $[0];
    return $bytes_tree.to_bit_array($bytes_tree.from_string_tree(tree));
  } else if ($ instanceof Bytes) {
    let tree = $[0];
    return $bytes_tree.to_bit_array(tree);
  } else if ($ instanceof File) {
    let path = $.path;
    let $1 = $simplifile.read_bits(path);
    if (!($1 instanceof Ok)) {
      throw makeError(
        "let_assert",
        FILEPATH,
        "wisp/testing",
        256,
        "bit_array_body",
        "Pattern match failed, no pattern matched the value.",
        {
          value: $1,
          start: 7935,
          end: 7987,
          pattern_start: 7946,
          pattern_end: 7958
        }
      )
    }
    let contents = $1[0];
    return contents;
  } else {
    return toBitArray([]);
  }
}

export const default_secret_key_base = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";

export function request(method, path, headers, body) {
  let _block;
  let $1 = $string.split(path, "?");
  if ($1 instanceof $Empty) {
    _block = [path, new None()];
  } else {
    let $2 = $1.tail;
    if ($2 instanceof $Empty) {
      _block = [path, new None()];
    } else {
      let $3 = $2.tail;
      if ($3 instanceof $Empty) {
        let path$1 = $1.head;
        let query = $2.head;
        _block = [path$1, new Some(query)];
      } else {
        _block = [path, new None()];
      }
    }
  }
  let $ = _block;
  let path$1 = $[0];
  let query = $[1];
  let _pipe = new $request.Request(
    method,
    headers,
    body,
    new $http.Https(),
    "localhost",
    new None(),
    path$1,
    query,
  );
  return $request.set_body(
    _pipe,
    $wisp.create_canned_connection(body, default_secret_key_base),
  );
}

export function get(path, headers) {
  return request(new $http.Get(), path, headers, toBitArray([]));
}

export function post(path, headers, body) {
  return request(
    new $http.Post(),
    path,
    headers,
    toBitArray([stringBits(body)]),
  );
}

export function post_form(path, headers, data) {
  let body = $uri.query_to_string(data);
  let _pipe = request(
    new $http.Post(),
    path,
    headers,
    toBitArray([stringBits(body)]),
  );
  return $request.set_header(
    _pipe,
    "content-type",
    "application/x-www-form-urlencoded",
  );
}

export function post_json(path, headers, data) {
  let body = $json.to_string(data);
  let _pipe = request(
    new $http.Post(),
    path,
    headers,
    toBitArray([stringBits(body)]),
  );
  return $request.set_header(_pipe, "content-type", "application/json");
}

export function head(path, headers) {
  return request(new $http.Head(), path, headers, toBitArray([]));
}

export function put(path, headers, body) {
  return request(new $http.Put(), path, headers, toBitArray([stringBits(body)]));
}

export function put_form(path, headers, data) {
  let body = $uri.query_to_string(data);
  let _pipe = request(
    new $http.Put(),
    path,
    headers,
    toBitArray([stringBits(body)]),
  );
  return $request.set_header(
    _pipe,
    "content-type",
    "application/x-www-form-urlencoded",
  );
}

export function put_json(path, headers, data) {
  let body = $json.to_string(data);
  let _pipe = request(
    new $http.Put(),
    path,
    headers,
    toBitArray([stringBits(body)]),
  );
  return $request.set_header(_pipe, "content-type", "application/json");
}

export function delete$(path, headers, body) {
  return request(
    new $http.Delete(),
    path,
    headers,
    toBitArray([stringBits(body)]),
  );
}

export function delete_form(path, headers, data) {
  let body = $uri.query_to_string(data);
  let _pipe = request(
    new $http.Delete(),
    path,
    headers,
    toBitArray([stringBits(body)]),
  );
  return $request.set_header(
    _pipe,
    "content-type",
    "application/x-www-form-urlencoded",
  );
}

export function delete_json(path, headers, data) {
  let body = $json.to_string(data);
  let _pipe = request(
    new $http.Delete(),
    path,
    headers,
    toBitArray([stringBits(body)]),
  );
  return $request.set_header(_pipe, "content-type", "application/json");
}

export function trace(path, headers) {
  return request(new $http.Trace(), path, headers, toBitArray([]));
}

export function connect(path, headers) {
  return request(new $http.Connect(), path, headers, toBitArray([]));
}

export function options(path, headers) {
  return request(new $http.Options(), path, headers, toBitArray([]));
}

export function patch(path, headers, body) {
  return request(
    new $http.Patch(),
    path,
    headers,
    toBitArray([stringBits(body)]),
  );
}

export function patch_form(path, headers, data) {
  let body = $uri.query_to_string(data);
  let _pipe = request(
    new $http.Patch(),
    path,
    headers,
    toBitArray([stringBits(body)]),
  );
  return $request.set_header(
    _pipe,
    "content-type",
    "application/x-www-form-urlencoded",
  );
}

export function patch_json(path, headers, data) {
  let body = $json.to_string(data);
  let _pipe = request(
    new $http.Patch(),
    path,
    headers,
    toBitArray([stringBits(body)]),
  );
  return $request.set_header(_pipe, "content-type", "application/json");
}

export function set_cookie(req, name, value, security) {
  let _block;
  if (security instanceof $wisp.PlainText) {
    _block = $bit_array.base64_encode(toBitArray([stringBits(value)]), false);
  } else {
    _block = $wisp.sign_message(
      req,
      toBitArray([stringBits(value)]),
      new $crypto.Sha512(),
    );
  }
  let value$1 = _block;
  return $request.set_cookie(req, name, value$1);
}

export const set_header = $request.set_header;
