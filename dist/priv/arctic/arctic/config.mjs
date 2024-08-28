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
  );
}

export function home_renderer(config, renderer) {
  return new Config(renderer, config.main_pages, config.collections);
}

export function add_main_page(config, id, body) {
  return new Config(
    config.render_home,
    listPrepend(new RawPage(id, body), config.main_pages),
    config.collections,
  );
}

export function add_collection(config, collection) {
  return new Config(
    config.render_home,
    config.main_pages,
    listPrepend(collection, config.collections),
  );
}
