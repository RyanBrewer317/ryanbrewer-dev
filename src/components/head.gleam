// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import gleam/list
import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html

pub fn local_head(title: String, description: String) -> Element(Nil) {
  html.div([], [
    html.link([
      attribute.rel("preload"),
      attribute.attribute("as", "image"),
      attribute.href("/ryan-silly.jpg"),
    ]),
    html.link([attribute.rel("prefetch"), attribute.href("/ryan-silly-2.png")]),
    html.title([], title <> " - Ryan Brewer"),
    html.meta([attribute.name("description"), attribute("content", description)]),
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
    html.script(
      [],
      "
window.MathJax = {
  loader: {load: ['[tex]/unicode','[tex]/bussproofs']},
  tex: {packages: {'[+]': ['unicode','bussproofs']}},
};
        ",
    ),
    html.script([], "hljs.highlightAll();"),
  ])
}

pub fn head(extra: List(Element(Nil))) -> Element(Nil) {
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
        html.meta([attribute("charset", "UTF-8")]),
        html.meta([
          attribute.name("viewport"),
          attribute("content", "width=device-width, initial-scale=1.0"),
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
        html.script(
          [attribute.src("https://polyfill.io/v3/polyfill.min.js?features=es6")],
          "",
        ),
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
      ],
      extra,
    ),
  )
}
