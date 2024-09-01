import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { attribute } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { toList } from "../gleam.mjs";

export function head(title, description, extra) {
  return $html.head(
    toList([]),
    $list.append(
      toList([
        $html.script(
          toList([
            attribute("async", "true"),
            $attribute.src(
              "https://www.googletagmanager.com/gtag/js?id=G-BDZJ8SX3Y1",
            ),
          ]),
          "",
        ),
        $html.script(
          toList([]),
          "\nwindow.dataLayer = window.dataLayer || [];\nfunction gtag(){dataLayer.push(arguments);}\ngtag('js', new Date());\n        ",
        ),
        $html.title(toList([]), title + " - Ryan Brewer"),
        $html.meta(toList([attribute("charset", "UTF-8")])),
        $html.meta(
          toList([
            $attribute.name("viewport"),
            attribute("content", "width=device-width, initial-scale=1.0"),
          ]),
        ),
        $html.meta(
          toList([
            $attribute.name("description"),
            attribute("content", description),
          ]),
        ),
        $html.link(
          toList([
            $attribute.rel("icon"),
            $attribute.type_("image/x-icon"),
            $attribute.href("/favicon.ico"),
          ]),
        ),
        $html.link(
          toList([
            $attribute.rel("alternate"),
            $attribute.type_("application/rss+xml"),
            attribute("title", "Ryan Brewer's Blog"),
            $attribute.href("https://ryanbrewer.dev/feed.rss"),
          ]),
        ),
        $html.link(
          toList([
            $attribute.rel("preconnect"),
            $attribute.href("https://fonts.googleapis.com"),
          ]),
        ),
        $html.link(
          toList([
            $attribute.rel("preconnect"),
            $attribute.href("https://fonts.gstatic.com"),
            attribute("crossorigin", "true"),
          ]),
        ),
        $html.link(
          toList([
            $attribute.rel("stylesheet"),
            $attribute.href(
              "https://fonts.googleapis.com/css2?family=Roboto&display=swap",
            ),
          ]),
        ),
        $html.script(
          toList([
            $attribute.src(
              "https://polyfill.io/v3/polyfill.min.js?features=es6",
            ),
          ]),
          "",
        ),
        $html.script(
          toList([
            attribute("type", "text/javascript"),
            attribute("async", "true"),
            attribute(
              "src",
              "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js",
            ),
          ]),
          "",
        ),
        $html.script(
          toList([]),
          "\nwindow.MathJax = {\n  loader: {load: ['[tex]/unicode']},\n  tex: {packages: {'[+]': ['unicode']}},\n};\n        ",
        ),
        $html.link(
          toList([
            $attribute.rel("stylesheet"),
            $attribute.href(
              "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/atom-one-dark.min.css",
            ),
          ]),
        ),
        $html.script(
          toList([
            $attribute.src(
              "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js",
            ),
          ]),
          "",
        ),
        $html.script(toList([]), "hljs.highlightAll();"),
      ]),
      extra,
    ),
  );
}