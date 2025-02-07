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
        toList([
          $attribute.href("/"),
          $attribute.id("nav-home"),
          attribute(
            "onclick",
            "let p=new URL(location.href).pathname;if(p=='/'){document.getElementById('nav').classList.remove('dropdown')}document.body.classList.remove('noscroll');",
          ),
        ]),
        toList([text("Ryan Brewer")]),
      ),
      $html.a(
        toList([
          $attribute.href("/posts"),
          $attribute.id("nav-posts"),
          attribute(
            "onclick",
            "let p=new URL(location.href).pathname;if(p=='/posts'||p=='/posts/'){document.getElementById('nav').classList.remove('dropdown')}document.body.classList.remove('noscroll');",
          ),
        ]),
        toList([text("Posts")]),
      ),
      $html.a(
        toList([
          $attribute.href("/wiki"),
          $attribute.id("nav-wiki"),
          attribute(
            "onclick",
            "let p=new URL(location.href).pathname;if(p=='/wiki'||p=='/wiki/'){document.getElementById('nav').classList.remove('dropdown')}document.body.classList.remove('noscroll');",
          ),
        ]),
        toList([text("Wiki")]),
      ),
      $html.a(
        toList([
          $attribute.href("/contact"),
          $attribute.id("nav-contact"),
          attribute(
            "onclick",
            "let p=new URL(location.href).pathname;if(p=='/contact'||p=='/contact/'){document.getElementById('nav').classList.remove('dropdown')}document.body.classList.remove('noscroll');",
          ),
        ]),
        toList([text("Contact")]),
      ),
      $html.a(
        toList([
          $attribute.href("/demos"),
          $attribute.id("nav-demos"),
          attribute(
            "onclick",
            "let p=new URL(location.href).pathname;if(p=='/demos'||p=='/demos/'){document.getElementById('nav').classList.remove('dropdown')}document.body.classList.remove('noscroll');",
          ),
        ]),
        toList([text("Demos")]),
      ),
      $html.a(
        toList([
          $attribute.href("/feed.rss"),
          $attribute.id("nav-subscribe"),
          $attribute.attribute("onclick", "window.location.href = '/feed.rss'"),
        ]),
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
