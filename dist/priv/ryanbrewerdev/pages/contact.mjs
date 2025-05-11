import * as $attribute from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $head from "../components/head.mjs";
import * as $navbar from "../components/navbar.mjs";
import { navbar } from "../components/navbar.mjs";
import * as $tail from "../components/tail.mjs";
import { tail } from "../components/tail.mjs";
import { toList } from "../gleam.mjs";

export function contact() {
  return $html.div(
    toList([]),
    toList([
      $head.local_head("Contact", "Contact information"),
      navbar(),
      $html.div(
        toList([$attribute.id("body")]),
        toList([
          $html.div(
            toList([$attribute.id("contact-img")]),
            toList([
              $html.img(
                toList([
                  $attribute.src("/ryan-silly.jpg"),
                  $attribute.height(273),
                ]),
              ),
            ]),
          ),
          $html.h3(toList([]), toList([text("Ryan Brewer.")])),
          $html.p(
            toList([]),
            toList([
              $html.a(
                toList([
                  $attribute.href("https://github.com/RyanBrewer317"),
                  $attribute.class$("contact-link"),
                  $attribute.target("_blank"),
                  $attribute.rel("noopener noreferrer"),
                ]),
                toList([
                  $html.img(
                    toList([
                      $attribute.src("/github-logo.png"),
                      $attribute.alt("GitHub logo"),
                      $attribute.id("github-logo"),
                    ]),
                  ),
                  $html.span(toList([]), toList([text("GitHub")])),
                ]),
              ),
            ]),
          ),
          $html.p(
            toList([]),
            toList([
              $html.a(
                toList([
                  $attribute.href("https://mathstodon.xyz/@ryanbrewer"),
                  $attribute.class$("contact-link"),
                  $attribute.target("_blank"),
                  $attribute.rel("noopener noreferrer"),
                ]),
                toList([
                  $html.img(
                    toList([
                      $attribute.src("/mastodon-logo.svg"),
                      $attribute.alt("Mastodon logo"),
                      $attribute.id("mastodon-logo"),
                    ]),
                  ),
                  $html.span(toList([]), toList([text("Mastodon")])),
                ]),
              ),
            ]),
          ),
          $html.p(
            toList([]),
            toList([
              $html.a(
                toList([
                  $attribute.href("https://www.reddit.com/user/hoping1/"),
                  $attribute.class$("contact-link"),
                  $attribute.target("_blank"),
                  $attribute.rel("noopener noreferrer"),
                ]),
                toList([
                  $html.img(
                    toList([
                      $attribute.src("/reddit-logo.png"),
                      $attribute.alt("Reddit logo"),
                      $attribute.id("reddit-logo"),
                    ]),
                  ),
                  $html.span(toList([]), toList([text("Reddit")])),
                ]),
              ),
            ]),
          ),
          $html.p(
            toList([]),
            toList([
              $html.a(
                toList([
                  $attribute.href(
                    "https://www.linkedin.com/in/ryan-brewer-361689156/",
                  ),
                  $attribute.class$("contact-link"),
                  $attribute.target("_blank"),
                  $attribute.rel("noopener noreferrer"),
                ]),
                toList([
                  $html.img(
                    toList([
                      $attribute.src("/linkedin-logo.png"),
                      $attribute.alt("LinkedIn logo"),
                      $attribute.id("linkedin-logo"),
                    ]),
                  ),
                  $html.span(toList([]), toList([text("LinkedIn")])),
                ]),
              ),
            ]),
          ),
          $html.p(
            toList([]),
            toList([
              $html.a(
                toList([
                  $attribute.href("https://ko-fi.com/ryanbrewer"),
                  $attribute.class$("contact-link"),
                  $attribute.target("_blank"),
                  $attribute.rel("noopener noreferrer"),
                ]),
                toList([
                  $html.img(
                    toList([
                      $attribute.src("/kofi-logo.png"),
                      $attribute.alt("Ko-fi logo"),
                      $attribute.id("kofi-logo"),
                    ]),
                  ),
                  $html.span(toList([]), toList([text("Support")])),
                ]),
              ),
            ]),
          ),
        ]),
      ),
      tail(),
    ]),
  );
}
