import lustre/element.{type Element}
import lustre/element/html
import lustre/attribute.{attribute}

pub fn tail() -> Element(a) {
  html.div([], [
    html.script(
      [attribute.src("https://storage.ko-fi.com/cdn/scripts/overlay-widget.js")],
      "",
    ),
    html.script(
      [],
      "
  kofiWidgetOverlay.draw('ryanbrewer', {
    'type': 'floating-chat',
    'floating-chat.donateButton.text': 'Support me',
    'floating-chat.donateButton.background-color': '#323842',
    'floating-chat.donateButton.text-color': '#fff'
  });
    ",
    ),
    html.script([attribute.src("/__/firebase/8.10.1/firebase-app.js")], ""),
    html.script(
      [attribute.src("/__/firebase/8.10.1/firebase-analytics.js")],
      "",
    ),
    html.script([attribute.src("/__/firebase/init.js")], ""),
    html.script([], "firebase.analytics();"),
  ])
}
