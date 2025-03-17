import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import { None, Some } from "../../gleam_stdlib/gleam/option.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $arctic from "../arctic.mjs";
import { Config, RawPage } from "../arctic.mjs";
import { toList, prepend as listPrepend } from "../gleam.mjs";

export function new$() {
  return new Config(
    (_) => {
      return $html.html(
        toList([]),
        toList([
          $html.head(toList([]), toList([])),
          $html.body(
            toList([]),
            toList([text("No renderer set up for home page")]),
          ),
        ]),
      );
    },
    toList([]),
    toList([]),
    new Some((body) => { return body; }),
  );
}

export function home_renderer(config, renderer) {
  let _record = config;
  return new Config(
    renderer,
    _record.main_pages,
    _record.collections,
    _record.render_spa,
  );
}

export function add_main_page(config, id, body) {
  let _record = config;
  return new Config(
    _record.render_home,
    listPrepend(new RawPage(id, body), config.main_pages),
    _record.collections,
    _record.render_spa,
  );
}

export function add_collection(config, collection) {
  let _record = config;
  return new Config(
    _record.render_home,
    _record.main_pages,
    listPrepend(collection, config.collections),
    _record.render_spa,
  );
}

export function add_spa_frame(config, frame) {
  let _record = config;
  return new Config(
    _record.render_home,
    _record.main_pages,
    _record.collections,
    new Some(frame),
  );
}

export function turn_off_spa(config) {
  let _record = config;
  return new Config(
    _record.render_home,
    _record.main_pages,
    _record.collections,
    new None(),
  );
}
