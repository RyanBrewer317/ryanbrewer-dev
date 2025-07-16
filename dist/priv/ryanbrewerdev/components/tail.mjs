import * as $attribute from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { toList } from "../gleam.mjs";

export function tail() {
  return $html.div(
    toList([]),
    toList([
      $html.p(
        toList([
          $attribute.id("copyright-notice"),
          $attribute.class$("subtle-text"),
        ]),
        toList([text("© 2024 Ryan Brewer.")]),
      ),
      $html.script(
        toList([$attribute.src("/__/firebase/8.10.1/firebase-app.js")]),
        "",
      ),
      $html.script(
        toList([$attribute.src("/__/firebase/8.10.1/firebase-analytics.js")]),
        "",
      ),
      $html.script(toList([$attribute.src("/__/firebase/init.js")]), ""),
      $html.script(toList([]), "firebase.analytics();"),
    ]),
  );
}
