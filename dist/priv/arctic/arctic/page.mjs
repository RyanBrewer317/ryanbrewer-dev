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
  return new Page(p.id, body, p.metadata, p.title, p.blerb, p.tags, p.date);
}

export function with_metadata(p, key, val) {
  return new Page(
    p.id,
    p.body,
    $dict.insert(p.metadata, key, val),
    p.title,
    p.blerb,
    p.tags,
    p.date,
  );
}

export function replace_metadata(p, metadata) {
  return new Page(p.id, p.body, metadata, p.title, p.blerb, p.tags, p.date);
}

export function with_title(p, title) {
  return new Page(p.id, p.body, p.metadata, title, p.blerb, p.tags, p.date);
}

export function with_blerb(p, blerb) {
  return new Page(p.id, p.body, p.metadata, p.title, blerb, p.tags, p.date);
}

export function with_tags(p, tags) {
  return new Page(p.id, p.body, p.metadata, p.title, p.blerb, tags, p.date);
}

export function with_date(p, date) {
  return new Page(
    p.id,
    p.body,
    p.metadata,
    p.title,
    p.blerb,
    p.tags,
    new Some(date),
  );
}
