import * as $arctic from "../arctic/arctic.mjs";
import * as $birl from "../birl/birl.mjs";
import * as $int from "../gleam_stdlib/gleam/int.mjs";
import * as $option from "../gleam_stdlib/gleam/option.mjs";
import { Some } from "../gleam_stdlib/gleam/option.mjs";
import * as $order from "../gleam_stdlib/gleam/order.mjs";
import { negate } from "../gleam_stdlib/gleam/order.mjs";
import { makeError } from "./gleam.mjs";

export function string_to_date(s) {
  return $birl.from_naive(s);
}

export function pretty_date(date) {
  return ((($birl.string_month(date) + " ") + $int.to_string(
    $birl.get_day(date).date,
  )) + ", ") + $int.to_string($birl.get_day(date).year);
}

export function before(p1, p2) {
  let $ = p1.date;
  if (!($ instanceof Some)) {
    throw makeError(
      "let_assert",
      "helpers",
      27,
      "before",
      "Pattern match failed, no pattern matched the value.",
      { value: $ }
    )
  }
  let p1_date = $[0];
  let $1 = p2.date;
  if (!($1 instanceof Some)) {
    throw makeError(
      "let_assert",
      "helpers",
      28,
      "before",
      "Pattern match failed, no pattern matched the value.",
      { value: $1 }
    )
  }
  let p2_date = $1[0];
  return $birl.compare(p1_date, p2_date);
}

export function after(p1, p2) {
  return negate(before(p1, p2));
}
