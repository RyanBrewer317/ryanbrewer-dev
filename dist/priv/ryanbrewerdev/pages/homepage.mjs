import * as $arctic from "../../arctic/arctic.mjs";
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
import { toList } from "../gleam.mjs";

export function homepage(_) {
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
                toList([]),
                toList([
                  $html.h3(toList([]), toList([text("He/him.")])),
                  $html.p(
                    toList([]),
                    toList([
                      text(
                        "I'm Ryan Brewer.\nI'm a software engineer in San Francisco.\nI've built a few cool open-source ",
                      ),
                      $html.a(
                        toList([href("/projects")]),
                        toList([text("projects")]),
                      ),
                      text(
                        ",\ngenerally related to programming language theory or web development.\nI built a lot of the tech powering this website!\nI also love to play ",
                      ),
                      $html.a(
                        toList([href("/guitar")]),
                        toList([text("guitar")]),
                      ),
                      text(
                        ",\nespecially folk-rock.\nI'm straight and cisgender, using he/him pronouns.\n",
                      ),
                    ]),
                  ),
                ]),
              ),
              $html.div(
                toList([$attribute.id("homepage-flags")]),
                toList([text("🏳️‍🌈🏳️‍⚧️🇵🇸🇺🇦")]),
              ),
              $html.div(
                toList([$attribute.id("homepage-img")]),
                toList([$html.img(toList([$attribute.src("/ryan-ferry.jpg")]))]),
              ),
            ]),
          ),
          $html.p(
            toList([]),
            toList([
              text("Other sites I recommend include "),
              $html.a(
                toList([href("https://blueberrywren.dev/")]),
                toList([text("Wren's blog")]),
              ),
              text(", "),
              $html.a(
                toList([
                  href("https://ehatti.github.io/forest/output/index.xml"),
                ]),
                toList([text("Eashan's notes")]),
              ),
              text(", "),
              $html.a(
                toList([href("https://www.haskellforall.com/")]),
                toList([text("Haskell For All")]),
              ),
              text(", the "),
              $html.a(
                toList([href("https://wiki.xxiivv.com/site/computation.html")]),
                toList([text("XXIIVV wiki")]),
              ),
              text(", and the "),
              $html.a(
                toList([href("https://cybercat.institute/")]),
                toList([text("Cybercat Institute")]),
              ),
              text(". Podcasts I would recommend include "),
              $html.a(
                toList([href("https://www.typetheoryforall.com/")]),
                toList([text("Type Theory Forall")]),
              ),
              text(", the "),
              $html.a(
                toList([href("https://www.kleene.church/#h.k6fig1tqap9i")]),
                toList([text("Church of Logic")]),
              ),
              text(", and the "),
              $html.a(
                toList([href("https://homepage.cs.uiowa.edu/~astump/ittc.html")]),
                toList([text("Iowa Type Theory Commute")]),
              ),
              text(". Youtubers I recommend include "),
              $html.a(
                toList([href("https://www.youtube.com/@RichardSouthwell")]),
                toList([text("Richard Southwell")]),
              ),
              text(", "),
              $html.a(
                toList([href("https://www.youtube.com/@AtticPhilosophy")]),
                toList([text("Mark Jago")]),
              ),
              text(", "),
              $html.a(
                toList([href("https://www.youtube.com/@DrBartosz")]),
                toList([text("Bartosz Milewski")]),
              ),
              text(", and the "),
              $html.a(
                toList([href("https://www.youtube.com/@TheCatsters")]),
                toList([text("Catsters")]),
              ),
              text("."),
            ]),
          ),
        ]),
      ),
      tail(),
    ]),
  );
}
