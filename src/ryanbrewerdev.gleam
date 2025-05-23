// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import arctic/build
import arctic/collection
import arctic/config
import components/head
import gleam/io
import helpers
import lustre/attribute
import lustre/element/html
import pages/contact
import pages/cricket
import pages/demos
import pages/feed
import pages/guitar
import pages/homepage
import pages/list_posts
import pages/list_wikis
import pages/projects
import pages/unknown_page
import parse
import render
import snag

pub fn main() {
  let posts =
    collection.new("posts")
    |> collection.with_parser(parse.parse)
    |> collection.with_feed("feed.rss", feed.feed)
    |> collection.with_index(list_posts.list_posts)
    |> collection.with_ordering(helpers.after)
    |> collection.with_renderer(render.post)
  let wiki =
    collection.new("wiki")
    |> collection.with_parser(parse.parse)
    |> collection.with_index(list_wikis.list_wikis)
    |> collection.with_renderer(render.wiki)
  let projects =
    collection.new("projects")
    |> collection.with_parser(parse.parse)
    |> collection.with_index(projects.projects)
    |> collection.with_renderer(render.project)
  let config =
    config.new()
    |> config.add_collection(posts)
    |> config.add_collection(wiki)
    |> config.add_collection(projects)
    |> config.add_main_page("contact", contact.contact())
    |> config.add_main_page("demos", demos.demos())
    |> config.add_main_page("404", unknown_page.unknown_page())
    |> config.add_main_page("cricket", cricket.cricket())
    |> config.add_main_page("guitar", guitar.guitar())
    |> config.add_spa_frame(fn(body) {
      html.html([attribute.attribute("lang", "en")], [
        head.head([
          html.link([attribute.rel("stylesheet"), attribute.href("/style.css")]),
        ]),
        html.body([], [body]),
      ])
    })
    |> config.home_renderer(homepage.homepage)
  let res = build.build(config)
  case res {
    Ok(Nil) -> io.println("Success!")
    Error(err) -> panic as { snag.pretty_print(err) }
  }
}
