// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import arctic.{type Config, Config}
import arctic/build
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/order
import helpers
import pages/contact
import pages/cricket
import pages/demos
import pages/feed
import pages/homepage
import pages/list_posts
import pages/list_wikis
import pages/unknown_page
import parse
import render
import snag

pub fn main() {
  let config =
    Config(
      main_pages: [
        arctic.MainPage(id: "contact", html: contact.contact()),
        arctic.MainPage(id: "demos", html: demos.demos()),
        arctic.MainPage(id: "404", html: unknown_page.unknown_page()),
        arctic.MainPage(id: "cricket", html: cricket.cricket()),
      ],
      render_home: fn(collections) {
        let assert Ok(posts) =
          list.find(collections, fn(c) { c.collection.directory == "posts" })
        homepage.homepage(posts.pages)
      },
    )
  let res =
    build.build(config, [
      arctic.Collection(
        directory: "posts",
        parse: parse.post,
        index: Some(list_posts.list_posts),
        rss: Some(feed.feed),
        ordering: helpers.after,
        render: render.post,
      ),
      arctic.Collection(
        directory: "wiki",
        parse: parse.wiki,
        index: Some(list_wikis.list_wikis),
        rss: None,
        ordering: fn(_, _) { order.Eq },
        render: render.wiki,
      ),
    ])
  case res {
    Ok(Nil) -> io.println("Success!")
    Error(err) -> io.println(snag.pretty_print(err))
  }
}
