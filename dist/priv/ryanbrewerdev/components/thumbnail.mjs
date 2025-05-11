import * as $arctic from "../../arctic/arctic.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import { Some } from "../../gleam_stdlib/gleam/option.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { attribute } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { toList, makeError } from "../gleam.mjs";
import * as $helpers from "../helpers.mjs";
import { pretty_date } from "../helpers.mjs";

export function post(cp) {
  let p = $arctic.to_dummy_page(cp);
  let $ = p.date;
  if (!($ instanceof Some)) {
    throw makeError(
      "let_assert",
      "components/thumbnail",
      14,
      "post",
      "Pattern match failed, no pattern matched the value.",
      { value: $ }
    )
  }
  let date = $[0];
  return $html.li(
    toList([$attribute.class$("post-thumbnail"), $attribute.id(p.id)]),
    toList([
      $html.h3(
        toList([]),
        toList([
          $html.a(
            toList([$attribute.href("../posts/" + p.id)]),
            toList([text(p.title)]),
          ),
        ]),
      ),
      $html.div(
        toList([$attribute.class$("subtle-text")]),
        toList([text(pretty_date(date))]),
      ),
      $html.p(toList([]), toList([text(p.blerb)])),
    ]),
  );
}

export function wiki(cw) {
  let w = $arctic.to_dummy_page(cw);
  return $html.li(
    toList([$attribute.class$("wiki-thumbnail"), $attribute.id(w.id)]),
    toList([
      $html.h3(
        toList([]),
        toList([
          $html.a(
            toList([$attribute.href("../wiki/" + w.id)]),
            toList([text(w.title)]),
          ),
        ]),
      ),
    ]),
  );
}

export function project(cp) {
  let p = $arctic.to_dummy_page(cp);
  return $html.li(
    toList([$attribute.class$("project-thumbnail"), $attribute.id(p.id)]),
    toList([
      $html.h3(
        toList([]),
        toList([
          $html.a(
            toList([$attribute.href("../projects/" + p.id)]),
            toList([text(p.title)]),
          ),
        ]),
      ),
      $html.p(toList([]), toList([text(p.blerb)])),
    ]),
  );
}
