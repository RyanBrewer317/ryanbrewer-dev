import * as $attribute from "../../../lustre/lustre/attribute.mjs";
import { attribute } from "../../../lustre/lustre/attribute.mjs";
import * as $element from "../../../lustre/lustre/element.mjs";
import { element } from "../../../lustre/lustre/element.mjs";
import { toList, prepend as listPrepend } from "../../gleam.mjs";

export function feed(attrs, children) {
  return element(
    "feed",
    listPrepend(attribute("xmlns", "http://www.w3.org/2005/Atom"), attrs),
    children,
  );
}

export function entry(attrs, children) {
  return element("entry", attrs, children);
}

export function id(attrs, uri) {
  return element("id", attrs, toList([$element.text(uri)]));
}

export function title(attrs, title) {
  return element(
    "title",
    listPrepend(attribute("type", "html"), attrs),
    toList([$element.text(title)]),
  );
}

export function updated(attrs, iso_timestamp) {
  return element("updated", attrs, toList([$element.text(iso_timestamp)]));
}

export function published(attrs, iso_timestamp) {
  return element("published", attrs, toList([$element.text(iso_timestamp)]));
}

export function author(attrs, children) {
  return element("author", attrs, children);
}

export function contributor(attrs, children) {
  return element("contributor", attrs, children);
}

export function source(attrs, children) {
  return element("source", attrs, children);
}

export function link(attrs) {
  return $element.advanced("", "link", attrs, toList([]), true, false);
}

export function name(attrs, name) {
  return element("name", attrs, toList([$element.text(name)]));
}

export function email(attrs, email) {
  return element("email", attrs, toList([$element.text(email)]));
}

export function uri(attrs, uri) {
  return element("uri", attrs, toList([$element.text(uri)]));
}

export function category(attrs) {
  return $element.advanced("", "category", attrs, toList([]), true, false);
}

export function generator(attrs, name) {
  return element("generator", attrs, toList([$element.text(name)]));
}

export function icon(attrs, path) {
  return element("icon", attrs, toList([$element.text(path)]));
}

export function logo(attrs, path) {
  return element("logo", attrs, toList([$element.text(path)]));
}

export function rights(attrs, rights) {
  return element("rights", attrs, toList([$element.text(rights)]));
}

export function subtitle(attrs, subtitle) {
  return element(
    "subtitle",
    listPrepend(attribute("type", "html"), attrs),
    toList([$element.text(subtitle)]),
  );
}

export function summary(attrs, summary) {
  return element(
    "summary",
    listPrepend(attribute("type", "html"), attrs),
    toList([$element.text(summary)]),
  );
}

export function content(attrs, content) {
  return element(
    "content",
    listPrepend(attribute("type", "html"), attrs),
    toList([$element.text(content)]),
  );
}
