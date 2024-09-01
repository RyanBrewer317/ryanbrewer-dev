import * as $birl from "../../birl/birl.mjs";
import * as $dict from "../../gleam_stdlib/gleam/dict.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import { None, Some } from "../../gleam_stdlib/gleam/option.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $arctic from "../arctic.mjs";
import { Page } from "../arctic.mjs";
import { toList } from "../gleam.mjs";

export function new$(id) {
  return new Page(id, toList([]), $dict.new$(), "", "", toList([]), new None());
}

export function with_body(p, body) {
  return p.withFields({ body: body });
}

export function with_metadata(p, key, val) {
  return p.withFields({ metadata: $dict.insert(p.metadata, key, val) });
}

export function replace_metadata(p, metadata) {
  return p.withFields({ metadata: metadata });
}

export function with_title(p, title) {
  return p.withFields({ title: title });
}

export function with_blerb(p, blerb) {
  return p.withFields({ blerb: blerb });
}

export function with_tags(p, tags) {
  return p.withFields({ tags: tags });
}

export function with_date(p, date) {
  return p.withFields({ date: new Some(date) });
}
