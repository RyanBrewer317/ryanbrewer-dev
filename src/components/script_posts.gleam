import lustre/element.{type Element}
import lustre/element/html
import gleam/list
import gleam/string
import gleam/string_builder.{
  type StringBuilder, append, append_builder, concat, from_string, join,
  to_string,
}
import helpers.{type Post, pretty_date}

pub fn script_posts(posts: List(Post)) -> Element(a) {
  use <-
    fn(k: fn() -> List(StringBuilder)) {
      html.script(
        [],
        from_string("const POSTS = {")
        |> append_builder(concat(k()))
        |> append("};")
        |> to_string(),
      )
    }
  use p <- list.map(posts)
  from_string("\"")
  |> append(p.id)
  |> append("\": {\"id\": \"")
  |> append(p.id)
  |> append("\", \"url\": \"")
  |> append("/posts/" <> p.id <> ".html")
  |> append("\", \"title\": \"")
  |> append(string.replace(each: "\"", with: "\\\"", in: p.title))
  |> append("\", \"date\": \"")
  |> append(pretty_date(p.date))
  |> append("\", \"tags\": [")
  |> append_builder(join(
    list.map(p.tags, fn(tag) {
      from_string("\"")
      |> append(tag)
      |> append("\"")
    }),
    ", ",
  ))
  |> append("], \"description\": \"")
  |> append(string.replace(each: "\"", with: "\\\"", in: p.description))
  |> append("\"},\n")
}
