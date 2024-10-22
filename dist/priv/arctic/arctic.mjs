import * as $birl from "../birl/birl.mjs";
import * as $dict from "../gleam_stdlib/gleam/dict.mjs";
import * as $option from "../gleam_stdlib/gleam/option.mjs";
import * as $order from "../gleam_stdlib/gleam/order.mjs";
import * as $result from "../gleam_stdlib/gleam/result.mjs";
import * as $string from "../gleam_stdlib/gleam/string.mjs";
import * as $element from "../lustre/lustre/element.mjs";
import * as $snag from "../snag/snag.mjs";
import { toList, CustomType as $CustomType, makeError } from "./gleam.mjs";

export class Collection extends $CustomType {
  constructor(directory, parse, index, feed, ordering, render, raw_pages) {
    super();
    this.directory = directory;
    this.parse = parse;
    this.index = index;
    this.feed = feed;
    this.ordering = ordering;
    this.render = render;
    this.raw_pages = raw_pages;
  }
}

export class Page extends $CustomType {
  constructor(id, body, metadata, title, blerb, tags, date) {
    super();
    this.id = id;
    this.body = body;
    this.metadata = metadata;
    this.title = title;
    this.blerb = blerb;
    this.tags = tags;
    this.date = date;
  }
}

export class CachedPage extends $CustomType {
  constructor(path, metadata) {
    super();
    this.path = path;
    this.metadata = metadata;
  }
}

export class NewPage extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

export class ProcessedCollection extends $CustomType {
  constructor(collection, pages) {
    super();
    this.collection = collection;
    this.pages = pages;
  }
}

export class RawPage extends $CustomType {
  constructor(id, html) {
    super();
    this.id = id;
    this.html = html;
  }
}

export class Config extends $CustomType {
  constructor(render_home, main_pages, collections, render_spa) {
    super();
    this.render_home = render_home;
    this.main_pages = main_pages;
    this.collections = collections;
    this.render_spa = render_spa;
  }
}

export function get_id(p) {
  if (p instanceof CachedPage) {
    let metadata = p.metadata;
    let $ = $dict.get(metadata, "id");
    if (!$.isOk()) {
      throw makeError(
        "assignment_no_match",
        "arctic",
        80,
        "get_id",
        "Assignment pattern did not match",
        { value: $ }
      )
    }
    let id = $[0];
    return id;
  } else {
    let page = p[0];
    return page.id;
  }
}

export function to_dummy_page(c) {
  if (c instanceof CachedPage) {
    let metadata = c.metadata;
    let title = (() => {
      let _pipe = metadata;
      let _pipe$1 = $dict.get(_pipe, "title");
      return $result.unwrap(_pipe$1, "");
    })();
    let blerb = (() => {
      let _pipe = metadata;
      let _pipe$1 = $dict.get(_pipe, "blerb");
      return $result.unwrap(_pipe$1, "");
    })();
    let tags = (() => {
      let _pipe = metadata;
      let _pipe$1 = $dict.get(_pipe, "tags");
      let _pipe$2 = $result.map(
        _pipe$1,
        (_capture) => { return $string.split(_capture, ","); },
      );
      return $result.unwrap(_pipe$2, toList([]));
    })();
    let date = (() => {
      let _pipe = metadata;
      let _pipe$1 = $dict.get(_pipe, "date");
      let _pipe$2 = $result.try$(_pipe$1, $birl.parse);
      return $option.from_result(_pipe$2);
    })();
    return new Page(get_id(c), toList([]), metadata, title, blerb, tags, date);
  } else {
    let p = c[0];
    return p;
  }
}

export function output_path(input_path) {
  let $ = $string.split(input_path, ".txt");
  if (!$.hasLength(2) || $.tail.head !== "") {
    throw makeError(
      "assignment_no_match",
      "arctic",
      88,
      "output_path",
      "Assignment pattern did not match",
      { value: $ }
    )
  }
  let start = $.head;
  return ("arctic_build/" + start) + "/index.html";
}
