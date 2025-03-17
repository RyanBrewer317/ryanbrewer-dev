import * as $arctic from "../../arctic/arctic.mjs";
import * as $birl from "../../birl/birl.mjs";
import * as $int from "../../gleam_stdlib/gleam/int.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import { Some } from "../../gleam_stdlib/gleam/option.mjs";
import * as $string_builder from "../../gleam_stdlib/gleam/string_builder.mjs";
import { append, append_builder, from_string, to_string } from "../../gleam_stdlib/gleam/string_builder.mjs";
import { makeError } from "../gleam.mjs";

function pad(i) {
  let $ = i < 10;
  if ($) {
    return "0" + $int.to_string(i);
  } else {
    return $int.to_string(i);
  }
}

function day(date) {
  let $ = $birl.weekday(date);
  if ($ instanceof $birl.Mon) {
    return "Mon";
  } else if ($ instanceof $birl.Tue) {
    return "Tue";
  } else if ($ instanceof $birl.Wed) {
    return "Wed";
  } else if ($ instanceof $birl.Thu) {
    return "Thu";
  } else if ($ instanceof $birl.Fri) {
    return "Fri";
  } else if ($ instanceof $birl.Sat) {
    return "Sat";
  } else {
    return "Sun";
  }
}

function month(date) {
  let $ = $birl.month(date);
  if ($ instanceof $birl.Jan) {
    return "Jan";
  } else if ($ instanceof $birl.Feb) {
    return "Feb";
  } else if ($ instanceof $birl.Mar) {
    return "Mar";
  } else if ($ instanceof $birl.Apr) {
    return "Apr";
  } else if ($ instanceof $birl.May) {
    return "May";
  } else if ($ instanceof $birl.Jun) {
    return "Jun";
  } else if ($ instanceof $birl.Jul) {
    return "Jul";
  } else if ($ instanceof $birl.Aug) {
    return "Aug";
  } else if ($ instanceof $birl.Sep) {
    return "Sep";
  } else if ($ instanceof $birl.Oct) {
    return "Oct";
  } else if ($ instanceof $birl.Nov) {
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
          16,
          "",
          "Pattern match failed, no pattern matched the value.",
          { value: $ }
        )
      }
      let post_date = $[0];
      let date = $birl.get_day(post_date);
      let time = $birl.get_time_of_day(post_date);
      let _pipe = from_string("    <item>\n      <title>");
      let _pipe$1 = append(_pipe, post.title);
      let _pipe$2 = append(_pipe$1, "</title>\n      <pubDate>");
      let _pipe$3 = append(_pipe$2, day(post_date));
      let _pipe$4 = append(_pipe$3, ", ");
      let _pipe$5 = append(_pipe$4, pad(date.date));
      let _pipe$6 = append(_pipe$5, " ");
      let _pipe$7 = append(_pipe$6, month(post_date));
      let _pipe$8 = append(_pipe$7, " ");
      let _pipe$9 = append(_pipe$8, $int.to_string(date.year));
      let _pipe$10 = append(_pipe$9, " ");
      let _pipe$11 = append(_pipe$10, pad(time.hour));
      let _pipe$12 = append(_pipe$11, ":");
      let _pipe$13 = append(_pipe$12, pad(time.minute));
      let _pipe$14 = append(_pipe$13, ":");
      let _pipe$15 = append(_pipe$14, pad(time.second));
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
  let _pipe$1 = append_builder(_pipe, $string_builder.concat(items));
  let _pipe$2 = append(_pipe$1, "  </channel>\n</rss>");
  return to_string(_pipe$2);
}
