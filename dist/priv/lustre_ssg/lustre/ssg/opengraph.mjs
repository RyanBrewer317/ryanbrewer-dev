import * as $int from "../../../gleam_stdlib/gleam/int.mjs";
import * as $uri from "../../../gleam_stdlib/gleam/uri.mjs";
import * as $attribute from "../../../lustre/lustre/attribute.mjs";
import { attribute } from "../../../lustre/lustre/attribute.mjs";
import * as $html from "../../../lustre/lustre/element/html.mjs";
import { toList } from "../../gleam.mjs";

export function title(text) {
  return $html.meta(
    toList([attribute("property", "og:title"), $attribute.content(text)]),
  );
}

export function website() {
  return $html.meta(
    toList([attribute("property", "og:type"), $attribute.content("website")]),
  );
}

export function url(content) {
  return $html.meta(
    toList([
      attribute("property", "og:url"),
      $attribute.content($uri.to_string(content)),
    ]),
  );
}

export function description(content) {
  return $html.meta(
    toList([
      attribute("property", "og:description"),
      $attribute.content(content),
    ]),
  );
}

export function site_name(content) {
  return $html.meta(
    toList([attribute("property", "og:site_name"), $attribute.content(content)]),
  );
}

export function image(content) {
  return $html.meta(
    toList([
      attribute("property", "og:image"),
      $attribute.content($uri.to_string(content)),
    ]),
  );
}

export function image_type(content) {
  return $html.meta(
    toList([attribute("property", "og:image:type"), $attribute.content(content)]),
  );
}

export function image_width(content) {
  return $html.meta(
    toList([
      attribute("property", "og:image:width"),
      $attribute.content($int.to_string(content)),
    ]),
  );
}

export function image_height(content) {
  return $html.meta(
    toList([
      attribute("property", "og:image:height"),
      $attribute.content($int.to_string(content)),
    ]),
  );
}

export function image_alt(content) {
  return $html.meta(
    toList([attribute("property", "og:image:alt"), $attribute.content(content)]),
  );
}
