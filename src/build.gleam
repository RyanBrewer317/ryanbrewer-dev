import gleam/list
import gleam/map
import homepage
import list_posts
import lustre/ssg
import simplifile
import render_post
import parse_post
import contact
import feed
import helpers.{type Post}

const posts_dir = "posts"

const out_dir = "site"

const assets_dir = "public"

fn read_all() -> List(Post) {
  let assert Ok(paths) = simplifile.get_files(in: posts_dir)
  list.map(paths, fn(filename) {
    let assert Ok(p) = parse_post.go(filename)
    p
  })
}

pub fn main() {
  let posts = list.sort(read_all(), helpers.after)
  let indexed_posts =
    list.map(posts, fn(p) { #(p.id, p) })
    |> map.from_list

  ssg.new(out_dir)
  |> ssg.add_dynamic_route("/posts", indexed_posts, render_post.render)
  |> ssg.add_static_route("/", homepage.homepage(posts))
  |> ssg.add_static_route("/search", list_posts.list_posts(posts))
  |> ssg.add_static_route("/contact", contact.contact())
  |> ssg.build
  let assert Ok(_) = simplifile.create_directory(out_dir <> "/public")
  let assert Ok(_) =
    simplifile.copy_directory(at: assets_dir, to: out_dir <> "/public")
  let assert Ok(_) = simplifile.create_file(out_dir <> "/public/feed.rss")
  let assert Ok(_) =
    simplifile.write(
      contents: feed.feed(posts),
      to: out_dir
      <> "/public/feed.rss",
    )
}
