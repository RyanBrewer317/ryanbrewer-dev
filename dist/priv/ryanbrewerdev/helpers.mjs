import * as $arctic from "../arctic/arctic.mjs";
import * as $int from "../gleam_stdlib/gleam/int.mjs";
import * as $option from "../gleam_stdlib/gleam/option.mjs";
import { Some } from "../gleam_stdlib/gleam/option.mjs";
import * as $order from "../gleam_stdlib/gleam/order.mjs";
import { negate } from "../gleam_stdlib/gleam/order.mjs";
import * as $calendar from "../gleam_time/gleam/time/calendar.mjs";
import * as $timestamp from "../gleam_time/gleam/time/timestamp.mjs";
import { makeError } from "./gleam.mjs";

const FILEPATH = "src/helpers.gleam";

export function string_to_date(s) {
  return $timestamp.parse_rfc3339(s);
}

export function pretty_date(ts) {
  let date = $timestamp.to_calendar(ts, $calendar.utc_offset)[0];
  return ((($calendar.month_to_string(date.month) + " ") + $int.to_string(
    date.day,
  )) + ", ") + $int.to_string(date.year);
}

export function before(p1, p2) {
  let $ = p1.date;
  if (!($ instanceof Some)) {
    throw makeError(
      "let_assert",
      FILEPATH,
      "helpers",
      29,
      "before",
      "Pattern match failed, no pattern matched the value.",
      { value: $, start: 774, end: 808, pattern_start: 785, pattern_end: 798 }
    )
  }
  let p1_date = $[0];
  let $1 = p2.date;
  if (!($1 instanceof Some)) {
    throw makeError(
      "let_assert",
      FILEPATH,
      "helpers",
      30,
      "before",
      "Pattern match failed, no pattern matched the value.",
      { value: $1, start: 811, end: 845, pattern_start: 822, pattern_end: 835 }
    )
  }
  let p2_date = $1[0];
  return $timestamp.compare(p1_date, p2_date);
}

export function after(p1, p2) {
  return negate(before(p1, p2));
}
