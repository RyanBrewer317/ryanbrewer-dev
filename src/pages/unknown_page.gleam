// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import components/head.{head}
import components/navbar.{navbar}
import components/tail.{tail}
import lustre/attribute
import lustre/element.{type Element, text}
import lustre/element/html

pub fn unknown_page() -> Element(Nil) {
  html.html([attribute.attribute("lang", "en")], [
    head("404 - Ryan Brewer", "Unknown Page", [
      html.link([attribute.rel("stylesheet"), attribute.href("/style.css")]),
    ]),
    html.body([], [
      navbar(),
      html.div([attribute.id("body")], [
        html.span([attribute.id("unknown-page-banner")], [
          text("Unknown Page (404)"),
        ]),
      ]),
      html.script(
        [],
        "
if (window.location.pathname === '/search.html')
  window.location.href = '/posts';
if (window.location.pathname === '/search')
  window.location.href = '/posts';
if (window.location.pathname === '/contact.html')
  window.location.href = '/contact';
if (window.location.pathname === '/demos.html')
  window.location.href = '/demos';
if (window.location.pathname === '/404.html')
  window.location.href = '/404';
if (window.location.pathname === '/posts/announcing-svm.html')
  window.location.href = '/posts/announcing-sabervm';
if (window.location.pathname === '/posts/beginners-guide-pl-academia.html')
  window.location.href = '/posts/beginners-guide-pl-academia';
if (window.location.pathname === '/posts/first-post.html')
  window.location.href = '/posts/first-post';
if (window.location.pathname === '/posts/getting-started-category-theory.html')
  window.location.href = '/posts/getting-started-category-theory';
if (window.location.pathname === '/posts/implicit-products-better-forall.html')
  window.location.href = '/posts/implicit-products-better-forall';
if (window.location.pathname === '/posts/logic-in-types.html')
  window.location.href = '/posts/logic-in-types';
if (window.location.pathname === '/posts/safe-mmm-with-coeffects.html')
  window.location.href = '/posts/safe-mmm-with-coeffects';
if (window.location.pathname === '/posts/security-crashing-modal-logic.html')
  window.location.href = '/posts/security-crashing-modal-logic';
if (window.location.pathname === '/posts/simple-programming-languages.html')
  window.location.href = '/posts/simple-programming-languages';
if (window.location.pathname === '/posts/type-of-sprintf.html')
  window.location.href = '/posts/type-of-sprintf';
if (window.location.pathname === '/posts/typechecking-sabervm.html')
  window.location.href = '/posts/typechecking-sabervm';
if (window.location.pathname === '/posts/cricket.html')
  window.location.href = '/posts/cricket';
      ",
      ),
      tail(),
    ]),
  ])
}
