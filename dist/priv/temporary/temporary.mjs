import * as $envoy from "../envoy/envoy.mjs";
import * as $exception from "../exception/exception.mjs";
import * as $filepath from "../filepath/filepath.mjs";
import * as $crypto from "../gleam_crypto/gleam/crypto.mjs";
import * as $bit_array from "../gleam_stdlib/gleam/bit_array.mjs";
import * as $option from "../gleam_stdlib/gleam/option.mjs";
import { None, Some } from "../gleam_stdlib/gleam/option.mjs";
import * as $result from "../gleam_stdlib/gleam/result.mjs";
import * as $simplifile from "../simplifile/simplifile.mjs";
import { Ok, Error, CustomType as $CustomType } from "./gleam.mjs";
import { is_windows } from "./temporary_ffi.mjs";

class TempFile extends $CustomType {
  constructor(kind, temp_directory, name_prefix, name_suffix) {
    super();
    this.kind = kind;
    this.temp_directory = temp_directory;
    this.name_prefix = name_prefix;
    this.name_suffix = name_suffix;
  }
}

class File extends $CustomType {}

class Directory extends $CustomType {}

export function file() {
  return new TempFile(new File(), new None(), new None(), new None());
}

export function directory() {
  return new TempFile(new Directory(), new None(), new None(), new None());
}

export function in_directory(temp_file, directory) {
  return temp_file.withFields({ temp_directory: new Some(directory) });
}

export function with_prefix(temp_file, name_prefix) {
  return temp_file.withFields({ name_prefix: new Some(name_prefix) });
}

export function with_suffix(temp_file, name_suffix) {
  return temp_file.withFields({ name_suffix: new Some(name_suffix) });
}

function get_random_name() {
  let _pipe = $crypto.strong_random_bytes(16);
  return $bit_array.base16_encode(_pipe);
}

function get_temp_directory() {
  let temp = $result.lazy_or(
    $envoy.get("TMPDIR"),
    () => {
      return $result.lazy_or(
        $envoy.get("TEMP"),
        () => { return $envoy.get("TMP"); },
      );
    },
  );
  if (temp.isOk()) {
    let temp$1 = temp[0];
    return temp$1;
  } else {
    let $ = is_windows();
    if ($) {
      return "C:\\TMP";
    } else {
      return "/tmp";
    }
  }
}

export function create(temp_file, fun) {
  let kind = temp_file.kind;
  let temp_directory = temp_file.temp_directory;
  let name_prefix = temp_file.name_prefix;
  let name_suffix = temp_file.name_suffix;
  let temp = $option.unwrap(temp_directory, get_temp_directory());
  let name = ($option.unwrap(name_prefix, "") + get_random_name()) + $option.unwrap(
    name_suffix,
    "",
  );
  let path = $filepath.join(temp, name);
  let result = (() => {
    if (kind instanceof File) {
      return $simplifile.create_file(path);
    } else {
      return $simplifile.create_directory(path);
    }
  })();
  if (!result.isOk()) {
    let error = result[0];
    return new Error(error);
  } else {
    return $exception.defer(
      () => { return $simplifile.delete$(path); },
      () => { return new Ok(fun(path)); },
    );
  }
}
