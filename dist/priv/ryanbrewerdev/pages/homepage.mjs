import * as $arctic from "../../arctic/arctic.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { href } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $head from "../components/head.mjs";
import * as $navbar from "../components/navbar.mjs";
import { navbar } from "../components/navbar.mjs";
import * as $tail from "../components/tail.mjs";
import { tail } from "../components/tail.mjs";
import * as $thumbnail from "../components/thumbnail.mjs";
import { toList } from "../gleam.mjs";

export function homepage(posts) {
  return $html.div(
    toList([]),
    toList([
      $head.local_head(
        "Ryan Brewer's Blog",
        "The place Ryan writes his thoughts and shows off cool projects!",
      ),
      navbar(),
      $html.div(
        toList([$attribute.id("body")]),
        toList([
          $html.div(
            toList([]),
            toList([
              $html.div(
                toList([$attribute.id("homepage-img")]),
                toList([
                  $html.img(
                    toList([
                      $attribute.src("/ryan-silly.jpg"),
                      $attribute.width(340),
                    ]),
                  ),
                ]),
              ),
              $html.div(
                toList([]),
                toList([
                  $html.h3(toList([]), toList([text("Me.")])),
                  $html.p(
                    toList([]),
                    toList([
                      text(
                        "I'm Ryan Brewer.\nI'm a passionate software developer working on open-source software \nfor safe, reliable, and portable applications.\nI specialize in a formal methods approach to systems design, with a focus on ergonomics.\nIn general, my projects aim to be formally memory-safe, fault-tolerant, and very lightweight. \nVia minimality, I hope to make formal theory more accessible outside the ivory tower of academia,\nand easier to put into practice where it matters.\nOne of my bigger projects is ",
                      ),
                      $html.a(
                        toList([href("https://arctic-framework.org")]),
                        toList([text("Arctic")]),
                      ),
                      text(
                        ",\nA friendly web framework for easily building fast web applications in Gleam!\nArctic powers this website, as well as the one I just linked.\n",
                      ),
                    ]),
                  ),
                  $html.a(
                    toList([
                      $attribute.id("github"),
                      href("https://github.com/sponsors/RyanBrewer317"),
                    ]),
                    toList([
                      $html.img(
                        toList([
                          $attribute.src("/github-logo.png"),
                          $attribute.alt("GitHub logo"),
                          $attribute.id("github-logo"),
                        ]),
                      ),
                      $html.span(toList([]), toList([text("Sponsor")])),
                    ]),
                  ),
                  $html.a(
                    toList([
                      $attribute.id("kofi"),
                      href("https://ko-fi.com/ryanbrewer"),
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
          $html.h3(
            toList([$attribute.style(toList([["padding-top", "50pt"]]))]),
            toList([text("My Website")]),
          ),
          $html.p(
            toList([]),
            toList([
              text(
                "This is my website.\nI use this as a space to store my ideas, advertise myself and my work, and write blog posts about topics that I love.\nGenerally I constrain my posts to be about programming language theory or implementations. \nLinks to my latest posts can be found below. I also have a useful ",
              ),
              $html.a(toList([href("/wiki")]), toList([text("wiki")])),
              text(
                " of concepts I've studied, expressed accessibly.\nA good explanation is the best proof of my own understanding, and an exciting challenge. \nThis website is hosted by Firebase and written in ",
              ),
              $html.a(
                toList([href("https://gleam.run")]),
                toList([text("Gleam")]),
              ),
              text(", and the code is up on my "),
              $html.a(
                toList([href("https://github.com/RyanBrewer317/ryanbrewer-dev")]),
                toList([text("github")]),
              ),
              text(
                ". Instead of a typical web framework, I wrote my own web framework called ",
              ),
              $html.a(
                toList([href("https://arctic-framework.org")]),
                toList([text("Arctic")]),
              ),
              text(" on top of the amazing "),
              $html.a(
                toList([href("https://lustre.build/")]),
                toList([text("Lustre")]),
              ),
              text(
                ". Scripting, markup, styles, etc. for this site are all done by me :)",
              ),
            ]),
          ),
          $html.h3(
            toList([$attribute.style(toList([["padding-top", "50pt"]]))]),
            toList([$element.text("Blog Posts")]),
          ),
          $html.ul(
            toList([$attribute.id("posts-list")]),
            $list.map(posts, $thumbnail.post),
          ),
        ]),
      ),
      tail(),
    ]),
  );
}
