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
      $html.script(
        toList([]),
        "\nfunction click_nav_home_link() {\n  let p=new URL(location.href).pathname;\n  if(p=='/'){\n    document.getElementById('nav').classList.remove('dropdown');\n  }\n  document.body.classList.remove('noscroll');\n}\nfunction click_nav_link(route) {\n  let p=new URL(location.href).pathname;\n  if(p==route||p==route+'/'){\n    document.getElementById('nav').classList.remove('dropdown');\n  }\n  document.body.classList.remove('noscroll');\n}\n    ",
      ),
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
        toList([
          $attribute.href("/"),
          $attribute.id("nav-home"),
          attribute("onclick", "click_nav_home_link()"),
        ]),
        toList([text("Ryan Brewer")]),
      ),
      $html.a(
        toList([
          $attribute.href("/contact"),
          $attribute.id("nav-contact"),
          attribute("onclick", "click_nav_link('/contact')"),
        ]),
        toList([text("Contact")]),
      ),
      $html.a(
        toList([
          $attribute.href("/demos"),
          $attribute.id("nav-demos"),
          attribute("onclick", "click_nav_link('/demos')"),
        ]),
        toList([text("Demos")]),
      ),
      $html.a(
        toList([
          $attribute.href("/posts"),
          $attribute.id("nav-posts"),
          attribute("onclick", "click_nav_link('/posts')"),
        ]),
        toList([text("Posts")]),
      ),
      $html.a(
        toList([
          $attribute.href("/projects"),
          $attribute.id("nav-projects"),
          attribute("onclick", "click_nav_link('/projects')"),
        ]),
        toList([text("Projects")]),
      ),
    ]),
  );
}
