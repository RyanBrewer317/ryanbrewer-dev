import * as $int from "../../gleam_stdlib/gleam/int.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import { None, Some } from "../../gleam_stdlib/gleam/option.mjs";
import * as $order from "../../gleam_stdlib/gleam/order.mjs";
import { Eq } from "../../gleam_stdlib/gleam/order.mjs";
import * as $string from "../../gleam_stdlib/gleam/string.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $snag from "../../snag/snag.mjs";
import * as $arctic from "../arctic.mjs";
import { Collection, RawPage } from "../arctic.mjs";
import * as $parse from "../arctic/parse.mjs";
import { Ok, toList, prepend as listPrepend } from "../gleam.mjs";

export function with_parser(c, parser) {
  return new Collection(
    c.directory,
    parser,
    c.index,
    c.feed,
    c.ordering,
    c.render,
    c.raw_pages,
  );
}

export function default_parser() {
  return (src_name, src) => {
    let parser = (() => {
      let _pipe = $parse.new$(undefined);
      let _pipe$1 = $parse.add_inline_rule(
        _pipe,
        "*",
        "*",
        $parse.wrap_inline($html.i),
      );
      let _pipe$2 = $parse.add_prefix_rule(
        _pipe$1,
        "#",
        $parse.wrap_prefix($html.h1),
      );
      return $parse.add_static_component(
        _pipe$2,
        "image",
        (args, label, data) => {
          if (args.hasLength(1)) {
            let url = args.head;
            return new Ok(
              [
                $html.img(toList([$attribute.src(url), $attribute.alt(label)])),
                undefined,
              ],
            );
          } else {
            let pos = $parse.get_pos(data);
            return $snag.error(
              (((("bad @image arguments `" + $string.join(args, ", ")) + "` at ") + $int.to_string(
                pos.line,
              )) + ":") + $int.to_string(pos.column),
            );
          }
        },
      );
    })();
    return $parse.parse(parser, src_name, src);
  };
}

export function new$(dir) {
  return new Collection(
    dir,
    default_parser(),
    new None(),
    new None(),
    (_, _1) => { return new Eq(); },
    (_) => {
      return $html.html(
        toList([]),
        toList([
          $html.head(toList([]), toList([])),
          $html.body(
            toList([]),
            toList([
              text(("No renderer set up for collection \"" + dir) + "\"."),
            ]),
          ),
        ]),
      );
    },
    toList([]),
  );
}

export function with_index(c, index) {
  return new Collection(
    c.directory,
    c.parse,
    new Some(index),
    c.feed,
    c.ordering,
    c.render,
    c.raw_pages,
  );
}

export function with_feed(c, filename, render) {
  return new Collection(
    c.directory,
    c.parse,
    c.index,
    new Some([filename, render]),
    c.ordering,
    c.render,
    c.raw_pages,
  );
}

export function with_ordering(c, ordering) {
  return new Collection(
    c.directory,
    c.parse,
    c.index,
    c.feed,
    ordering,
    c.render,
    c.raw_pages,
  );
}

export function with_renderer(c, renderer) {
  return new Collection(
    c.directory,
    c.parse,
    c.index,
    c.feed,
    c.ordering,
    renderer,
    c.raw_pages,
  );
}

export function with_raw_page(c, id, body) {
  return new Collection(
    c.directory,
    c.parse,
    c.index,
    c.feed,
    c.ordering,
    c.render,
    listPrepend(new RawPage(id, body), c.raw_pages),
  );
}
