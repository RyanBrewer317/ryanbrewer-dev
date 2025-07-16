import * as $arctic from "../../arctic/arctic.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
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

export function projects(projects) {
  return $html.div(
    toList([]),
    toList([
      $head.local_head("Projects", "Ryan's various cool projects"),
      navbar(),
      $html.div(
        toList([$attribute.id("body")]),
        toList([
          $html.h3(toList([]), toList([text("Projects")])),
          $html.p(
            toList([]),
            toList([
              text(
                "\nI'm a passionate software developer working on open-source software for safe, reliable, and portable applications. \nI specialize in a formal methods approach to systems design, with a focus on ergonomics.\nVia minimality, I hope to make formal theory more accessible outside the ivory tower of academia, \nand easier to put into practice where it matters. \nIf my projects seem cool or valuable in any way, consider supporting my work!\n        ",
              ),
            ]),
          ),
          $html.a(
            toList([
              $attribute.id("github"),
              $attribute.href("https://github.com/sponsors/RyanBrewer317"),
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
              $attribute.href("https://ko-fi.com/ryanbrewer"),
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
          $html.p(
            toList([]),
            toList([text("(I haven't put all my projects here yet!)")]),
          ),
          $html.ul(toList([]), $list.map(projects, $thumbnail.project)),
        ]),
      ),
      tail(),
    ]),
  );
}
