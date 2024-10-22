import * as $attribute from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $head from "../components/head.mjs";
import { head } from "../components/head.mjs";
import * as $navbar from "../components/navbar.mjs";
import { navbar } from "../components/navbar.mjs";
import * as $tail from "../components/tail.mjs";
import { tail } from "../components/tail.mjs";
import { toList } from "../gleam.mjs";

export function unknown_page() {
  return $html.html(
    toList([$attribute.attribute("lang", "en")]),
    toList([
      head(
        "404 - Ryan Brewer",
        "Unknown Page",
        toList([
          $html.link(
            toList([$attribute.rel("stylesheet"), $attribute.href("/style.css")]),
          ),
        ]),
      ),
      $html.body(
        toList([]),
        toList([
          navbar(),
          $html.div(
            toList([$attribute.id("body")]),
            toList([
              $html.span(
                toList([$attribute.id("unknown-page-banner")]),
                toList([text("Unknown Page (404)")]),
              ),
            ]),
          ),
          $html.script(
            toList([]),
            "\nif (window.location.pathname === '/search.html')\n  window.location.href = '/posts';\nif (window.location.pathname === '/search')\n  window.location.href = '/posts';\nif (window.location.pathname === '/contact.html')\n  window.location.href = '/contact';\nif (window.location.pathname === '/demos.html')\n  window.location.href = '/demos';\nif (window.location.pathname === '/404.html')\n  window.location.href = '/404';\nif (window.location.pathname === '/posts/announcing-svm.html')\n  window.location.href = '/posts/announcing-sabervm';\nif (window.location.pathname === '/posts/beginners-guide-pl-academia.html')\n  window.location.href = '/posts/beginners-guide-pl-academia';\nif (window.location.pathname === '/posts/first-post.html')\n  window.location.href = '/posts/first-post';\nif (window.location.pathname === '/posts/getting-started-category-theory.html')\n  window.location.href = '/posts/getting-started-category-theory';\nif (window.location.pathname === '/posts/implicit-products-better-forall.html')\n  window.location.href = '/posts/implicit-products-better-forall';\nif (window.location.pathname === '/posts/logic-in-types.html')\n  window.location.href = '/posts/logic-in-types';\nif (window.location.pathname === '/posts/safe-mmm-with-coeffects.html')\n  window.location.href = '/posts/safe-mmm-with-coeffects';\nif (window.location.pathname === '/posts/security-crashing-modal-logic.html')\n  window.location.href = '/posts/security-crashing-modal-logic';\nif (window.location.pathname === '/posts/simple-programming-languages.html')\n  window.location.href = '/posts/simple-programming-languages';\nif (window.location.pathname === '/posts/type-of-sprintf.html')\n  window.location.href = '/posts/type-of-sprintf';\nif (window.location.pathname === '/posts/typechecking-sabervm.html')\n  window.location.href = '/posts/typechecking-sabervm';\nif (window.location.pathname === '/posts/cricket.html')\n  window.location.href = '/posts/cricket';\n      ",
          ),
          tail(),
        ]),
      ),
    ]),
  );
}
