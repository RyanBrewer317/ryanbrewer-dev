import helpers.{type Post}
import gleam/string_builder.{append, append_builder, from_string, to_string}
import gleam/list
import gleam/int
import birl

pub fn feed(posts: List(Post)) -> String {
  let items = {
    use post <- list.map(list.reverse(posts))
    let date = birl.get_day(post.date)
    let time = birl.get_time_of_day(post.date)
    from_string("    <item>\n      <title>")
    |> append(post.title)
    |> append("</title>\n      <pubDate>")
    |> append(day(post.date))
    |> append(", ")
    |> append(pad(date.date))
    |> append(" ")
    |> append(month(post.date))
    |> append(" ")
    |> append(int.to_string(date.year))
    |> append(" ")
    |> append(pad(time.hour))
    |> append(":")
    |> append(pad(time.minute))
    |> append(":")
    |> append(pad(time.second))
    |> append(" PST</pubDate>\n      <link>https://ryanbrewer.dev/posts/")
    |> append(post.id)
    |> append(".html</link>\n      <guid>https://ryanbrewer.dev/posts/")
    |> append(post.id)
    |> append(".html</guid>\n      <description><![CDATA[")
    |> append(post.description)
    |> append("  Read more <a href=\"https://ryanbrewer.dev/posts/")
    |> append(post.id)
    |> append(".html\">here</a>!]]></description>\n    </item>\n")
  }
  from_string(
    "
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<rss version=\"2.0\" xmlns:atom=\"http://www.w3.org/2005/Atom\">
  <channel>
    <title>Ryan's Blog</title>
    <link>https://ryanbrewer.dev</link>
    <atom:link href=\"https://ryanbrewer.dev/feed.rss\" rel=\"self\" type=\"application/rss+xml\" />
    <description>
      Ryan Brewer's personal blog, covering ideas in programming languages, software, logic, abstract math, and analytic philosophy.
    </description>
    <language>en-us</language>
",
  )
  |> append_builder(string_builder.concat(items))
  |> append("  </channel>\n</rss>")
  |> to_string
}

fn pad(i: Int) -> String {
  case i < 10 {
    True -> "0" <> int.to_string(i)
    False -> int.to_string(i)
  }
}

fn day(date: birl.Time) -> String {
  case birl.weekday(date) {
    birl.Mon -> "Mon"
    birl.Tue -> "Tue"
    birl.Wed -> "Wed"
    birl.Thu -> "Thu"
    birl.Fri -> "Fri"
    birl.Sat -> "Sat"
    birl.Sun -> "Sun"
  }
}

fn month(date: birl.Time) -> String {
  case birl.month(date) {
    birl.Jan -> "Jan"
    birl.Feb -> "Feb"
    birl.Mar -> "Mar"
    birl.Apr -> "Apr"
    birl.May -> "May"
    birl.Jun -> "Jun"
    birl.Jul -> "Jul"
    birl.Aug -> "Aug"
    birl.Sep -> "Sep"
    birl.Oct -> "Oct"
    birl.Nov -> "Nov"
    birl.Dec -> "Dec"
  }
}
