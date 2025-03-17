import * as $build from "../arctic/arctic/build.mjs";
import * as $collection from "../arctic/arctic/collection.mjs";
import * as $config from "../arctic/arctic/config.mjs";
import * as $io from "../gleam_stdlib/gleam/io.mjs";
import * as $list from "../gleam_stdlib/gleam/list.mjs";
import * as $attribute from "../lustre/lustre/attribute.mjs";
import * as $html from "../lustre/lustre/element/html.mjs";
import * as $snag from "../snag/snag.mjs";
import * as $head from "./components/head.mjs";
import { toList, makeError } from "./gleam.mjs";
import * as $helpers from "./helpers.mjs";
import * as $contact from "./pages/contact.mjs";
import * as $cricket from "./pages/cricket.mjs";
import * as $demos from "./pages/demos.mjs";
import * as $feed from "./pages/feed.mjs";
import * as $homepage from "./pages/homepage.mjs";
import * as $list_posts from "./pages/list_posts.mjs";
import * as $list_wikis from "./pages/list_wikis.mjs";
import * as $unknown_page from "./pages/unknown_page.mjs";
import * as $parse from "./parse.mjs";
import * as $render from "./render.mjs";

export function main() {
  let posts = (() => {
    let _pipe = $collection.new$("posts");
    let _pipe$1 = $collection.with_parser(_pipe, $parse.parse);
    let _pipe$2 = $collection.with_feed(_pipe$1, "feed.rss", $feed.feed);
    let _pipe$3 = $collection.with_index(_pipe$2, $list_posts.list_posts);
    let _pipe$4 = $collection.with_ordering(_pipe$3, $helpers.after);
    return $collection.with_renderer(_pipe$4, $render.post);
  })();
  let wiki = (() => {
    let _pipe = $collection.new$("wiki");
    let _pipe$1 = $collection.with_parser(_pipe, $parse.parse);
    let _pipe$2 = $collection.with_index(_pipe$1, $list_wikis.list_wikis);
    return $collection.with_renderer(_pipe$2, $render.wiki);
  })();
  let config = (() => {
    let _pipe = $config.new$();
    let _pipe$1 = $config.add_collection(_pipe, posts);
    let _pipe$2 = $config.add_collection(_pipe$1, wiki);
    let _pipe$3 = $config.add_main_page(_pipe$2, "contact", $contact.contact());
    let _pipe$4 = $config.add_main_page(_pipe$3, "demos", $demos.demos());
    let _pipe$5 = $config.add_main_page(
      _pipe$4,
      "404",
      $unknown_page.unknown_page(),
    );
    let _pipe$6 = $config.add_main_page(_pipe$5, "cricket", $cricket.cricket());
    let _pipe$7 = $config.add_spa_frame(
      _pipe$6,
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
    return $config.home_renderer(
      _pipe$7,
      (collections) => {
        let $ = $list.find(
          collections,
          (c) => { return c.collection.directory === "posts"; },
        );
        if (!$.isOk()) {
          throw makeError(
            "let_assert",
            "ryanbrewerdev",
            56,
            "",
            "Pattern match failed, no pattern matched the value.",
            { value: $ }
          )
        }
        let posts$1 = $[0];
        return $homepage.homepage(posts$1.pages);
      },
    );
  })();
  let res = $build.build(config);
  if (res.isOk() && !res[0]) {
    return $io.println("Success!");
  } else {
    let err = res[0];
    throw makeError(
      "panic",
      "ryanbrewerdev",
      63,
      "main",
      $snag.pretty_print(err),
      {}
    )
  }
}
