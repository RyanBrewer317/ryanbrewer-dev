// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import gleam/list
import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html

pub fn head(
  title: String,
  description: String,
  extra: List(Element(Nil)),
) -> Element(Nil) {
  html.head(
    [],
    list.append(
      [
        html.script(
          [
            attribute("async", "true"),
            attribute.src(
              "https://www.googletagmanager.com/gtag/js?id=G-BDZJ8SX3Y1",
            ),
          ],
          "",
        ),
        html.script(
          [],
          "
window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('js', new Date());
        ",
        ),
        html.title([], title <> " - Ryan Brewer"),
        html.meta([attribute("charset", "UTF-8")]),
        html.meta([
          attribute.name("viewport"),
          attribute("content", "width=device-width, initial-scale=1.0"),
        ]),
        html.meta([
          attribute.name("description"),
          attribute("content", description),
        ]),
        html.link([
          attribute.rel("icon"),
          attribute.type_("image/x-icon"),
          attribute.href("/favicon.ico"),
        ]),
        html.link([
          attribute.rel("alternate"),
          attribute.type_("application/rss+xml"),
          attribute("title", "Ryan Brewer's Blog"),
          attribute.href("https://ryanbrewer.dev/feed.rss"),
        ]),
        html.link([
          attribute.rel("preconnect"),
          attribute.href("https://fonts.googleapis.com"),
        ]),
        html.link([
          attribute.rel("preconnect"),
          attribute.href("https://fonts.gstatic.com"),
          attribute("crossorigin", "true"),
        ]),
        html.link([
          attribute.rel("stylesheet"),
          attribute.href(
            "https://fonts.googleapis.com/css2?family=Roboto&display=swap",
          ),
        ]),
        html.script(
          [attribute.src("https://polyfill.io/v3/polyfill.min.js?features=es6")],
          "",
        ),
        html.script(
          [
            attribute("type", "text/javascript"),
            attribute("async", "true"),
            attribute(
              "src",
              "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js",
            ),
          ],
          "",
        ),
        html.link([
          attribute.rel("stylesheet"),
          attribute.type_("text/css"),
          attribute.href("https://tikzjax.com/v1/fonts.css"),
        ]),
        html.script([attribute.src("https://tikzjax.com/v1/tikzjax.js")], ""),
        html.link([
          attribute.rel("stylesheet"),
          attribute.href(
            "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/atom-one-dark.min.css",
          ),
        ]),
        html.script(
          [
            attribute.src(
              "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js",
            ),
          ],
          "",
        ),
        html.script([], "hljs.highlightAll();"),
      ],
      extra,
    ),
  )
}
