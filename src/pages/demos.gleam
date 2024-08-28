// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import components/head.{head}
import components/navbar.{navbar}
import components/tail.{tail}
import lustre/attribute.{attribute, id}
import lustre/element.{type Element}
import lustre/element/html.{body, div, html, script}

pub fn demos() -> Element(Nil) {
  html([attribute("lang", "en")], [
    head(
      "Demos - Ryan Brewer",
      "Interactive demonstrations of concepts from programming language theory",
      [
        html.link([attribute.rel("stylesheet"), attribute.href("/style.css")]),
        script(
          [attribute("type", "module")],
          "import { main } from \"/priv/ryanbrewerdev/client/demos.mjs\";
 document.addEventListener(\"DOMContentLoaded\", () => {
   const dispatch = main({});
 });",
        ),
      ],
    ),
    body([], [
      navbar(),
      div([id("body")], [div([attribute("data-lustre-app", "true")], [])]),
      tail(),
    ]),
  ])
}
