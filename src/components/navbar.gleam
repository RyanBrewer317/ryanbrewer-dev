import lustre/attribute.{attribute}
import lustre/element.{type Element, text}
import lustre/element/html

pub fn navbar() -> Element(a) {
  html.nav([], [
    html.a([attribute.href("/"), attribute.id("nav-home")], [
      text("Ryan Brewer"),
    ]),
    html.a([attribute.href("/search"), attribute.id("nav-search")], [
      text("Posts"),
    ]),
    html.a([attribute.href("/contact.html"), attribute.id("nav-contact")], [
      text("Contact"),
    ]),
    html.a([attribute.href("/feed.rss"), attribute.id("nav-subscribe")], [
      html.img([
        attribute.src("/rss-icon.png"),
        attribute.id("rss-subscribe-icon"),
      ]),
      text("Subscribe"),
    ]),
  ])
}
