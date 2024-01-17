import lustre/element.{type Element, text}
import lustre/element/html
import lustre/attribute
import components/head.{head}
import components/navbar.{navbar}
import components/tail.{tail}

pub fn contact() -> Element(Nil) {
  html.html([attribute.attribute("lang", "en")], [
    head("Contact - Ryan Brewer", "Contact information", [
      html.script([attribute.type_("module")], "import '../style.css';"),
    ]),
    html.body([], [
      navbar(),
      html.div([attribute.id("body")], [
        html.p([], [text("ryanbrew317 at gmail")]),
      ]),
      tail(),
    ]),
  ])
}
