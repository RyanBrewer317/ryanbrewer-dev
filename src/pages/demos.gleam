// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import components/head
import components/navbar.{navbar}
import components/tail.{tail}
import lustre/attribute.{attribute, id}
import lustre/element.{type Element}
import lustre/element/html.{div, html, script}

pub fn demos() -> Element(Nil) {
  html.div([], [
    head.local_head(
      "Demos",
      "Interactive demonstrations of concepts from programming language theory",
    ),
    script(
      [attribute("type", "module")],
      "import { main } from \"/priv/ryanbrewerdev/client/demos.mjs\";
 document.addEventListener(\"DOMContentLoaded\", () => {
   const dispatch = main({});
 });",
    ),
    navbar(),
    div([id("body")], [div([attribute("data-lustre-app", "true")], [])]),
    tail(),
  ])
}
