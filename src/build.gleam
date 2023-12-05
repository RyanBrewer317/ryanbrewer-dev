import gleam/list
import gleam/map
import homepage
import list_posts
import lustre/ssg
import simplifile
import post.{type Post}

const posts_dir = "posts"

const out_dir = "site"

const assets_dir = "public"

fn read_all() -> List(Post) {
  let assert Ok(paths) = simplifile.get_files(in: posts_dir)
  list.map(
    paths,
    fn(filename) {
      let assert Ok(post) = post.post(filename)
      post
    },
  )
}

pub fn main() {
  let posts = read_all()
  // let chron_order = list.sort(posts, by: post.before)
  let indexed_posts =
    list.map(posts, fn(post) { #(post.id, post) })
    |> map.from_list

  ssg.new(out_dir)
  |> ssg.add_dynamic_route("/posts", indexed_posts, post.render)
  |> ssg.add_static_route("/", homepage.homepage())
  |> ssg.add_static_route("/search", list_posts.list_posts(posts))
  |> ssg.build
  let assert Ok(_) = simplifile.create_directory(out_dir <> "/public")
  simplifile.copy_directory(at: assets_dir, to: out_dir <> "/public")
}
