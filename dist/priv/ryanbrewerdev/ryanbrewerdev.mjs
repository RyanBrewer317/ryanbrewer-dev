import * as $build from "../arctic/arctic/build.mjs";
import * as $collection from "../arctic/arctic/collection.mjs";
import * as $config from "../arctic/arctic/config.mjs";
import * as $io from "../gleam_stdlib/gleam/io.mjs";
import * as $attribute from "../lustre/lustre/attribute.mjs";
import * as $html from "../lustre/lustre/element/html.mjs";
import * as $snag from "../snag/snag.mjs";
import * as $head from "./components/head.mjs";
import { Ok, toList, makeError } from "./gleam.mjs";
import * as $helpers from "./helpers.mjs";
import * as $contact from "./pages/contact.mjs";
import * as $cricket from "./pages/cricket.mjs";
import * as $demos from "./pages/demos.mjs";
import * as $feed from "./pages/feed.mjs";
import * as $guitar from "./pages/guitar.mjs";
import * as $homepage from "./pages/homepage.mjs";
import * as $list_posts from "./pages/list_posts.mjs";
import * as $list_wikis from "./pages/list_wikis.mjs";
import * as $projects from "./pages/projects.mjs";
import * as $unknown_page from "./pages/unknown_page.mjs";
import * as $parse from "./parse.mjs";
import * as $render from "./render.mjs";

const FILEPATH = "src/ryanbrewerdev.gleam";

export function main() {
  let _block;
  let _pipe = $collection.new$("posts");
  let _pipe$1 = $collection.with_parser(_pipe, $parse.parse);
  let _pipe$2 = $collection.with_feed(_pipe$1, "feed.rss", $feed.feed);
  let _pipe$3 = $collection.with_index(_pipe$2, $list_posts.list_posts);
  let _pipe$4 = $collection.with_ordering(_pipe$3, $helpers.after);
  _block = $collection.with_renderer(_pipe$4, $render.post);
  let posts = _block;
  let _block$1;
  let _pipe$5 = $collection.new$("wiki");
  let _pipe$6 = $collection.with_parser(_pipe$5, $parse.parse);
  let _pipe$7 = $collection.with_index(_pipe$6, $list_wikis.list_wikis);
  _block$1 = $collection.with_renderer(_pipe$7, $render.wiki);
  let wiki = _block$1;
  let _block$2;
  let _pipe$8 = $collection.new$("projects");
  let _pipe$9 = $collection.with_parser(_pipe$8, $parse.parse);
  let _pipe$10 = $collection.with_index(_pipe$9, $projects.projects);
  _block$2 = $collection.with_renderer(_pipe$10, $render.project);
  let projects = _block$2;
  let _block$3;
  let _pipe$11 = $config.new$();
  let _pipe$12 = $config.add_collection(_pipe$11, posts);
  let _pipe$13 = $config.add_collection(_pipe$12, wiki);
  let _pipe$14 = $config.add_collection(_pipe$13, projects);
  let _pipe$15 = $config.add_main_page(_pipe$14, "contact", $contact.contact());
  let _pipe$16 = $config.add_main_page(_pipe$15, "demos", $demos.demos());
  let _pipe$17 = $config.add_main_page(
    _pipe$16,
    "404",
    $unknown_page.unknown_page(),
  );
  let _pipe$18 = $config.add_main_page(_pipe$17, "cricket", $cricket.cricket());
  let _pipe$19 = $config.add_main_page(_pipe$18, "guitar", $guitar.guitar());
  let _pipe$20 = $config.add_spa_frame(
    _pipe$19,
    (body) => {
      return $html.html(
        toList([$attribute.attribute("lang", "en")]),
        toList([
          $head.head(
            toList([
              $html.link(
                toList([
                  $attribute.rel("stylesheet"),
                  $attribute.href("/style.css"),
                ]),
              ),
            ]),
          ),
          $html.body(toList([]), toList([body])),
        ]),
      );
    },
  );
  _block$3 = $config.home_renderer(_pipe$20, $homepage.homepage);
  let config = _block$3;
  let res = $build.build(config);
  if (res instanceof Ok) {
    return $io.println("Success!");
  } else {
    let err = res[0];
    throw makeError(
      "panic",
      FILEPATH,
      "ryanbrewerdev",
      67,
      "main",
      $snag.pretty_print(err),
      {}
    )
  }
}
