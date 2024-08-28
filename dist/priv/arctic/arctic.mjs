import * as $birl from "../birl/birl.mjs";
import * as $dict from "../gleam_stdlib/gleam/dict.mjs";
import * as $option from "../gleam_stdlib/gleam/option.mjs";
import * as $order from "../gleam_stdlib/gleam/order.mjs";
import * as $element from "../lustre/lustre/element.mjs";
import * as $snag from "../snag/snag.mjs";
import { CustomType as $CustomType } from "./gleam.mjs";

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
  constructor(render_home, main_pages, collections) {
    super();
    this.render_home = render_home;
    this.main_pages = main_pages;
    this.collections = collections;
  }
}
