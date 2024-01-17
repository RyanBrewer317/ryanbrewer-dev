import lustre/element.{type Element}
import lustre/element/html
import lustre/attribute.{attribute}

pub fn tail() -> Element(a) {
  html.div([], [
    html.script([attribute.src("/__/firebase/8.10.1/firebase-app.js")], ""),
    html.script([attribute.src("/__/firebase/8.10.1/firebase-analytics.js")], "",
    ),
    html.script([attribute.src("/__/firebase/init.js")], ""),
    html.script([], "firebase.analytics();"),
  ])
}
