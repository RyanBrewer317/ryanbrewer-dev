import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html

pub fn tail() -> Element(a) {
  html.div([], [
    html.div([attribute.style([#("height", "100pt")])], []),
    html.script([attribute.src("/__/firebase/8.10.1/firebase-app.js")], ""),
    html.script(
      [attribute.src("/__/firebase/8.10.1/firebase-analytics.js")],
      "",
    ),
    html.script([attribute.src("/__/firebase/init.js")], ""),
    html.script([], "firebase.analytics();"),
  ])
}
