import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { attribute } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { toList } from "../gleam.mjs";

export function navbar() {
  return $html.nav(
    toList([$attribute.id("nav")]),
    toList([
      $html.div(
        toList([
          $attribute.id("nav-dropdown"),
          attribute(
            "onclick",
            "document.getElementById('nav').classList.toggle('dropdown');document.body.classList.toggle('noscroll');",
          ),
        ]),
        toList([text("☰")]),
      ),
      $html.a(
        toList([$attribute.href("/"), $attribute.id("nav-home")]),
        toList([text("Ryan Brewer")]),
      ),
      $html.a(
        toList([$attribute.href("/posts"), $attribute.id("nav-posts")]),
        toList([text("Posts")]),
      ),
      $html.a(
        toList([$attribute.href("/wiki"), $attribute.id("nav-wiki")]),
        toList([text("Wiki")]),
      ),
      $html.a(
        toList([$attribute.href("/contact"), $attribute.id("nav-contact")]),
        toList([text("Contact")]),
      ),
      $html.a(
        toList([$attribute.href("/demos"), $attribute.id("nav-demos")]),
        toList([text("Demos")]),
      ),
      $html.a(
        toList([$attribute.href("/feed.rss"), $attribute.id("nav-subscribe")]),
        toList([
          $html.img(
            toList([
              $attribute.src("/rss-icon.png"),
              $attribute.id("rss-subscribe-icon"),
            ]),
          ),
          text("Subscribe"),
        ]),
      ),
    ]),
  );
}
