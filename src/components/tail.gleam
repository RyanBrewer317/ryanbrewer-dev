// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import lustre/attribute
import lustre/element.{type Element, text}
import lustre/element/html

pub fn tail() -> Element(a) {
  html.div([], [
    html.p([attribute.id("copyright-notice"), attribute.class("subtle-text")], [
      text("© 2024 Ryan Brewer."),
    ]),
    html.script([attribute.src("/__/firebase/8.10.1/firebase-app.js")], ""),
    html.script(
      [attribute.src("/__/firebase/8.10.1/firebase-analytics.js")],
      "",
    ),
    html.script([attribute.src("/__/firebase/init.js")], ""),
    html.script([], "firebase.analytics();"),
  ])
}
