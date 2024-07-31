// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import contact
import demos
import feed
import gleam/dict
import gleam/io
import gleam/list
import gleam/result.{map_error}
import helpers.{type Post}
import homepage
import list_posts
import lustre/ssg
import parse_post
import render_post
import simplifile
import snag.{type Result}
import unknown_page

const posts_dir = "posts"

const out_dir = "site"

const assets_dir = "public"

fn read_all() -> Result(List(Post)) {
  use paths <- result.try(
    simplifile.get_files(in: posts_dir)
    |> map_error(fn(err) {
      snag.new(
        "couldn't get files in `"
        <> posts_dir
        <> "` ("
        <> simplifile.describe_error(err)
        <> ")",
      )
    }),
  )
  list.try_fold(over: paths, from: [], with: fn(so_far, path) {
    use p <- result.try(parse_post.go(path))
    Ok([p, ..so_far])
  })
  |> result.map(list.reverse)
}

fn build() -> Result(Nil) {
  use posts_unsorted <- result.try(read_all())
  let posts = list.sort(posts_unsorted, helpers.after)
  let indexed_posts =
    list.map(posts, fn(p) { #(p.id, p) })
    |> dict.from_list

  use _ <- result.try(
    ssg.new(out_dir)
    |> ssg.add_dynamic_route("/posts", indexed_posts, render_post.render)
    |> ssg.add_static_route("/", homepage.homepage(posts))
    |> ssg.add_static_route("/search", list_posts.list_posts(posts))
    |> ssg.add_static_route("/contact", contact.contact())
    |> ssg.add_static_route("/demos", demos.demos_page())
    |> ssg.add_static_route("/404", unknown_page.unknown_page())
    |> ssg.build
    |> map_error(fn(err) {
      case err {
        ssg.CannotCreateTempDirectory(file_err) ->
          snag.new(
            "couldn't create temp directory ("
            <> simplifile.describe_error(file_err)
            <> ")",
          )
        ssg.CannotWriteStaticAsset(file_err, path) ->
          snag.new(
            "couldn't put asset at `"
            <> path
            <> "` ("
            <> simplifile.describe_error(file_err)
            <> ")",
          )
        ssg.CannotGenerateRoute(file_err, path) ->
          snag.new(
            "couldn't generate `"
            <> path
            <> "` ("
            <> simplifile.describe_error(file_err)
            <> ")",
          )
        ssg.CannotWriteToOutputDir(file_err) ->
          snag.new(
            "couldn't move from temp directory to output directory ("
            <> simplifile.describe_error(file_err)
            <> ")",
          )
        ssg.CannotCleanupTempDir(file_err) ->
          snag.new(
            "couldn't remove temp directory ("
            <> simplifile.describe_error(file_err)
            <> ")",
          )
      }
    }),
  )
  use _ <- result.try(
    simplifile.create_directory(out_dir <> "/public")
    |> map_error(fn(err) {
      snag.new(
        "couldn't create directory `"
        <> out_dir
        <> "/public` ("
        <> simplifile.describe_error(err)
        <> ")",
      )
    }),
  )
  use _ <- result.try(
    simplifile.copy_directory(at: assets_dir, to: out_dir <> "/public")
    |> map_error(fn(err) {
      snag.new(
        "couldn't copy `"
        <> assets_dir
        <> "` to `"
        <> out_dir
        <> "/public` ("
        <> simplifile.describe_error(err)
        <> ")",
      )
    }),
  )
  use _ <- result.try(
    simplifile.create_file(out_dir <> "/public/feed.rss")
    |> map_error(fn(err) {
      snag.new(
        "couldn't create file `"
        <> out_dir
        <> "/public/feed.rss` ("
        <> simplifile.describe_error(err)
        <> ")",
      )
    }),
  )
  simplifile.write(
    contents: feed.feed(posts),
    to: out_dir <> "/public/feed.rss",
  )
  |> map_error(fn(err) {
    snag.new(
      "couldn't write to `"
      <> out_dir
      <> "/public/feed.rss` ("
      <> simplifile.describe_error(err)
      <> ")",
    )
  })
}

pub fn main() {
  case build() {
    Ok(Nil) -> io.println("Success!")
    Error(err) -> {
      io.print(snag.pretty_print(err))
    }
  }
}
