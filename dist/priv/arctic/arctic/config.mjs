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
  return config.withFields({ render_home: renderer });
}

export function add_main_page(config, id, body) {
  return config.withFields({
    main_pages: listPrepend(new RawPage(id, body), config.main_pages)
  });
}

export function add_collection(config, collection) {
  return config.withFields({
    collections: listPrepend(collection, config.collections)
  });
}

export function add_spa_frame(config, frame) {
  return config.withFields({ render_spa: new Some(frame) });
}

export function turn_off_spa(config) {
  return config.withFields({ render_spa: new None() });
}
