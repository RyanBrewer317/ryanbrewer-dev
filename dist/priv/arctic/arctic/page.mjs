import * as $dict from "../../gleam_stdlib/gleam/dict.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import { None, Some } from "../../gleam_stdlib/gleam/option.mjs";
import * as $timestamp from "../../gleam_time/gleam/time/timestamp.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $arctic from "../arctic.mjs";
import { Page } from "../arctic.mjs";
import { toList } from "../gleam.mjs";

export function new$(id) {
  return new Page(id, toList([]), $dict.new$(), "", "", toList([]), new None());
}

export function with_body(p, body) {
  let _record = p;
  return new Page(
    _record.id,
    body,
    _record.metadata,
    _record.title,
    _record.blerb,
    _record.tags,
    _record.date,
  );
}

export function with_metadata(p, key, val) {
  let _record = p;
  return new Page(
    _record.id,
    _record.body,
    $dict.insert(p.metadata, key, val),
    _record.title,
    _record.blerb,
    _record.tags,
    _record.date,
  );
}

export function replace_metadata(p, metadata) {
  let _record = p;
  return new Page(
    _record.id,
    _record.body,
    metadata,
    _record.title,
    _record.blerb,
    _record.tags,
    _record.date,
  );
}

export function with_title(p, title) {
  let _record = p;
  return new Page(
    _record.id,
    _record.body,
    _record.metadata,
    title,
    _record.blerb,
    _record.tags,
    _record.date,
  );
}

export function with_blerb(p, blerb) {
  let _record = p;
  return new Page(
    _record.id,
    _record.body,
    _record.metadata,
    _record.title,
    blerb,
    _record.tags,
    _record.date,
  );
}

export function with_tags(p, tags) {
  let _record = p;
  return new Page(
    _record.id,
    _record.body,
    _record.metadata,
    _record.title,
    _record.blerb,
    tags,
    _record.date,
  );
}

export function with_date(p, date) {
  let _record = p;
  return new Page(
    _record.id,
    _record.body,
    _record.metadata,
    _record.title,
    _record.blerb,
    _record.tags,
    new Some(date),
  );
}
