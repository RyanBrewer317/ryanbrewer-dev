// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import arctic.{type CacheablePage}
import gleam/float
import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/result
import gleam/string_tree.{append, append_tree, from_string, to_string}
import gleam/time/calendar
import gleam/time/timestamp

pub fn feed(posts: List(CacheablePage)) -> String {
  let items = {
    use cacheable_post <- list.map(list.reverse(posts))
    let post = arctic.to_dummy_page(cacheable_post)
    let assert Some(post_date) = post.date
    let #(date, time) = timestamp.to_calendar(post_date, calendar.utc_offset)
    from_string("    <item>\n      <title>")
    |> append(post.title)
    |> append("</title>\n      <pubDate>")
    |> append(day(post_date))
    |> append(", ")
    |> append(pad(date.day))
    |> append(" ")
    |> append(month(post_date))
    |> append(" ")
    |> append(int.to_string(date.year))
    |> append(" ")
    |> append(pad(time.hours))
    |> append(":")
    |> append(pad(time.minutes))
    |> append(":")
    |> append(pad(time.seconds))
    |> append(" PST</pubDate>\n      <link>https://ryanbrewer.dev/posts/")
    |> append(post.id)
    |> append("/</link>\n      <guid>https://ryanbrewer.dev/posts/")
    |> append(post.id)
    |> append("/</guid>\n      <description><![CDATA[")
    |> append(post.blerb)
    |> append("  Read more <a href=\"https://ryanbrewer.dev/posts/")
    |> append(post.id)
    |> append("/\">here</a>!]]></description>\n    </item>\n")
  }
  from_string(
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
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
  |> append_tree(string_tree.concat(items))
  |> append("  </channel>\n</rss>")
  |> to_string
}

fn pad(i: Int) -> String {
  case i < 10 {
    True -> "0" <> int.to_string(i)
    False -> int.to_string(i)
  }
}

fn day(ts: timestamp.Timestamp) -> String {
  let weekday =
    ts
    |> timestamp.to_unix_seconds()
    |> fn(n) { n /. 86_400.0 }
    |> float.truncate()
    |> fn(n) { n + 4 }
    |> int.modulo(7)
    |> result.lazy_unwrap(fn() { panic })
  case weekday {
    0 -> "Sun"
    1 -> "Mon"
    2 -> "Tue"
    3 -> "Wed"
    4 -> "Thu"
    5 -> "Fri"
    6 -> "Sat"
    _ -> panic
  }
}

fn month(date: timestamp.Timestamp) -> String {
  case { timestamp.to_calendar(date, calendar.utc_offset).0 }.month {
    calendar.January -> "Jan"
    calendar.February -> "Feb"
    calendar.March -> "Mar"
    calendar.April -> "Apr"
    calendar.May -> "May"
    calendar.June -> "Jun"
    calendar.July -> "Jul"
    calendar.August -> "Aug"
    calendar.September -> "Sep"
    calendar.October -> "Oct"
    calendar.November -> "Nov"
    calendar.December -> "Dec"
  }
}
