import * as $arctic from "../../arctic/arctic.mjs";
import * as $float from "../../gleam_stdlib/gleam/float.mjs";
import * as $int from "../../gleam_stdlib/gleam/int.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import { Some } from "../../gleam_stdlib/gleam/option.mjs";
import * as $result from "../../gleam_stdlib/gleam/result.mjs";
import * as $string_tree from "../../gleam_stdlib/gleam/string_tree.mjs";
import { append, append_tree, from_string, to_string } from "../../gleam_stdlib/gleam/string_tree.mjs";
import * as $calendar from "../../gleam_time/gleam/time/calendar.mjs";
import * as $timestamp from "../../gleam_time/gleam/time/timestamp.mjs";
import { makeError, divideFloat } from "../gleam.mjs";

function pad(i) {
  let $ = i < 10;
  if ($) {
    return "0" + $int.to_string(i);
  } else {
    return $int.to_string(i);
  }
}

function day(ts) {
  let weekday = (() => {
    let _pipe = ts;
    let _pipe$1 = $timestamp.to_unix_seconds(_pipe);
    let _pipe$2 = ((n) => { return divideFloat(n, 86_400.0); })(_pipe$1);
    let _pipe$3 = $float.truncate(_pipe$2);
    let _pipe$4 = ((n) => { return n + 4; })(_pipe$3);
    let _pipe$5 = $int.modulo(_pipe$4, 7);
    return $result.lazy_unwrap(
      _pipe$5,
      () => {
        throw makeError(
          "panic",
          "pages/feed",
          80,
          "",
          "`panic` expression evaluated.",
          {}
        )
      },
    );
  })();
  if (weekday === 0) {
    return "Sun";
  } else if (weekday === 1) {
    return "Mon";
  } else if (weekday === 2) {
    return "Tue";
  } else if (weekday === 3) {
    return "Wed";
  } else if (weekday === 4) {
    return "Thu";
  } else if (weekday === 5) {
    return "Fri";
  } else if (weekday === 6) {
    return "Sat";
  } else {
    throw makeError(
      "panic",
      "pages/feed",
      89,
      "day",
      "`panic` expression evaluated.",
      {}
    )
  }
}

function month(date) {
  let $ = $timestamp.to_calendar(date, $calendar.utc_offset)[0].month;
  if ($ instanceof $calendar.January) {
    return "Jan";
  } else if ($ instanceof $calendar.February) {
    return "Feb";
  } else if ($ instanceof $calendar.March) {
    return "Mar";
  } else if ($ instanceof $calendar.April) {
    return "Apr";
  } else if ($ instanceof $calendar.May) {
    return "May";
  } else if ($ instanceof $calendar.June) {
    return "Jun";
  } else if ($ instanceof $calendar.July) {
    return "Jul";
  } else if ($ instanceof $calendar.August) {
    return "Aug";
  } else if ($ instanceof $calendar.September) {
    return "Sep";
  } else if ($ instanceof $calendar.October) {
    return "Oct";
  } else if ($ instanceof $calendar.November) {
    return "Nov";
  } else {
    return "Dec";
  }
}

export function feed(posts) {
  let items = $list.map(
    $list.reverse(posts),
    (cacheable_post) => {
      let post = $arctic.to_dummy_page(cacheable_post);
      let $ = post.date;
      if (!($ instanceof Some)) {
        throw makeError(
          "let_assert",
          "pages/feed",
          19,
          "",
          "Pattern match failed, no pattern matched the value.",
          { value: $ }
        )
      }
      let post_date = $[0];
      let $1 = $timestamp.to_calendar(post_date, $calendar.utc_offset);
      let date = $1[0];
      let time = $1[1];
      let _pipe = from_string("    <item>\n      <title>");
      let _pipe$1 = append(_pipe, post.title);
      let _pipe$2 = append(_pipe$1, "</title>\n      <pubDate>");
      let _pipe$3 = append(_pipe$2, day(post_date));
      let _pipe$4 = append(_pipe$3, ", ");
      let _pipe$5 = append(_pipe$4, pad(date.day));
      let _pipe$6 = append(_pipe$5, " ");
      let _pipe$7 = append(_pipe$6, month(post_date));
      let _pipe$8 = append(_pipe$7, " ");
      let _pipe$9 = append(_pipe$8, $int.to_string(date.year));
      let _pipe$10 = append(_pipe$9, " ");
      let _pipe$11 = append(_pipe$10, pad(time.hours));
      let _pipe$12 = append(_pipe$11, ":");
      let _pipe$13 = append(_pipe$12, pad(time.minutes));
      let _pipe$14 = append(_pipe$13, ":");
      let _pipe$15 = append(_pipe$14, pad(time.seconds));
      let _pipe$16 = append(
        _pipe$15,
        " PST</pubDate>\n      <link>https://ryanbrewer.dev/posts/",
      );
      let _pipe$17 = append(_pipe$16, post.id);
      let _pipe$18 = append(
        _pipe$17,
        "/</link>\n      <guid>https://ryanbrewer.dev/posts/",
      );
      let _pipe$19 = append(_pipe$18, post.id);
      let _pipe$20 = append(_pipe$19, "/</guid>\n      <description><![CDATA[");
      let _pipe$21 = append(_pipe$20, post.blerb);
      let _pipe$22 = append(
        _pipe$21,
        "  Read more <a href=\"https://ryanbrewer.dev/posts/",
      );
      let _pipe$23 = append(_pipe$22, post.id);
      return append(_pipe$23, "/\">here</a>!]]></description>\n    </item>\n");
    },
  );
  let _pipe = from_string(
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<rss version=\"2.0\" xmlns:atom=\"http://www.w3.org/2005/Atom\">\n  <channel>\n    <title>Ryan's Blog</title>\n    <link>https://ryanbrewer.dev</link>\n    <atom:link href=\"https://ryanbrewer.dev/feed.rss\" rel=\"self\" type=\"application/rss+xml\" />\n    <description>\n      Ryan Brewer's personal blog, covering ideas in programming languages, software, logic, abstract math, and analytic philosophy.\n    </description>\n    <language>en-us</language>\n",
  );
  let _pipe$1 = append_tree(_pipe, $string_tree.concat(items));
  let _pipe$2 = append(_pipe$1, "  </channel>\n</rss>");
  return to_string(_pipe$2);
}
