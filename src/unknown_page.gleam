import components/head.{head}
import components/navbar.{navbar}
import components/tail.{tail}
import lustre/attribute
import lustre/element.{type Element, text}
import lustre/element/html

pub fn unknown_page() -> Element(Nil) {
  html.html([attribute.attribute("lang", "en")], [
    head("404 - Ryan Brewer", "Unknown Page", [
      html.script([attribute.type_("module")], "import '../style.css';"),
    ]),
    html.body([], [
      navbar(),
      html.div([attribute.id("body")], [
        html.span([attribute.id("unknown-page-banner")], [
          text("Unknown Page (404)"),
        ]),
      ]),
      tail(),
    ]),
  ])
}
