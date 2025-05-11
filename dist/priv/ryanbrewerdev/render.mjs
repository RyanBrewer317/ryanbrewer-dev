import * as $arctic from "../arctic/arctic.mjs";
import * as $option from "../gleam_stdlib/gleam/option.mjs";
import { Some } from "../gleam_stdlib/gleam/option.mjs";
import * as $attribute from "../lustre/lustre/attribute.mjs";
import { attribute } from "../lustre/lustre/attribute.mjs";
import * as $element from "../lustre/lustre/element.mjs";
import { text } from "../lustre/lustre/element.mjs";
import * as $html from "../lustre/lustre/element/html.mjs";
import * as $head from "./components/head.mjs";
import * as $navbar from "./components/navbar.mjs";
import { navbar } from "./components/navbar.mjs";
import * as $tail from "./components/tail.mjs";
import { tail } from "./components/tail.mjs";
import { toList, prepend as listPrepend, makeError } from "./gleam.mjs";
import * as $helpers from "./helpers.mjs";

function do$(el, k) {
  return listPrepend(el, k());
}

function finally$(end) {
  return end;
}

function render_post_as_list(post) {
  return do$(
    $html.h1(toList([]), toList([text(post.title)])),
    () => {
      let $ = post.date;
      if (!($ instanceof Some)) {
        throw makeError(
          "let_assert",
          "render",
          25,
          "",
          "Pattern match failed, no pattern matched the value.",
          { value: $ }
        )
      }
      let date = $[0];
      return do$(
        $html.div(
          toList([$attribute.class$("date")]),
          toList([text($helpers.pretty_date(date))]),
        ),
        () => { return finally$(post.body); },
      );
    },
  );
}

function render_wiki_as_list(wiki) {
  return do$(
    $html.h1(toList([]), toList([text(wiki.title)])),
    () => { return finally$(wiki.body); },
  );
}

export function post(post) {
  return $html.div(
    toList([]),
    toList([
      $head.local_head(post.title, post.blerb),
      navbar(),
      $html.div(toList([$attribute.id("body")]), render_post_as_list(post)),
      tail(),
    ]),
  );
}

export function wiki(wiki) {
  return $html.div(
    toList([]),
    toList([
      $head.local_head(wiki.title, wiki.blerb),
      navbar(),
      $html.div(toList([$attribute.id("body")]), render_wiki_as_list(wiki)),
      tail(),
    ]),
  );
}

export function project(project) {
  return $html.div(
    toList([]),
    toList([
      $head.local_head(project.title, project.blerb),
      navbar(),
      $html.div(toList([$attribute.id("body")]), render_wiki_as_list(project)),
      tail(),
    ]),
  );
}
