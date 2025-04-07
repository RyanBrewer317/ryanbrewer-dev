import * as $int from "../../../gleam_stdlib/gleam/int.mjs";
import * as $order from "../../../gleam_stdlib/gleam/order.mjs";
import * as $string from "../../../gleam_stdlib/gleam/string.mjs";
import { CustomType as $CustomType, remainderInt, divideFloat, divideInt } from "../../gleam.mjs";

class Duration extends $CustomType {
  constructor(seconds, nanoseconds) {
    super();
    this.seconds = seconds;
    this.nanoseconds = nanoseconds;
  }
}

function normalise(duration) {
  let multiplier = 1_000_000_000;
  let nanoseconds$1 = remainderInt(duration.nanoseconds, multiplier);
  let overflow = duration.nanoseconds - nanoseconds$1;
  let seconds$1 = duration.seconds + (divideInt(overflow, multiplier));
  let $ = nanoseconds$1 >= 0;
  if ($) {
    return new Duration(seconds$1, nanoseconds$1);
  } else {
    return new Duration(seconds$1 - 1, multiplier + nanoseconds$1);
  }
}

export function compare(left, right) {
  let parts = (x) => {
    let $ = x.seconds >= 0;
    if ($) {
      return [x.seconds, x.nanoseconds];
    } else {
      return [x.seconds * -1 - 1, 1_000_000_000 - x.nanoseconds];
    }
  };
  let $ = parts(left);
  let ls = $[0];
  let lns = $[1];
  let $1 = parts(right);
  let rs = $1[0];
  let rns = $1[1];
  let _pipe = $int.compare(ls, rs);
  return $order.break_tie(_pipe, $int.compare(lns, rns));
}

export function difference(left, right) {
  let _pipe = new Duration(
    right.seconds - left.seconds,
    right.nanoseconds - left.nanoseconds,
  );
  return normalise(_pipe);
}

export function add(left, right) {
  let _pipe = new Duration(
    left.seconds + right.seconds,
    left.nanoseconds + right.nanoseconds,
  );
  return normalise(_pipe);
}

function nanosecond_digits(loop$n, loop$position, loop$acc) {
  while (true) {
    let n = loop$n;
    let position = loop$position;
    let acc = loop$acc;
    if (position === 9) {
      return acc;
    } else if ((acc === "") && ((remainderInt(n, 10)) === 0)) {
      loop$n = divideInt(n, 10);
      loop$position = position + 1;
      loop$acc = acc;
    } else {
      let acc$1 = $int.to_string(remainderInt(n, 10)) + acc;
      loop$n = divideInt(n, 10);
      loop$position = position + 1;
      loop$acc = acc$1;
    }
  }
}

export function to_iso8601_string(duration) {
  let split = (total, limit) => {
    let amount = remainderInt(total, limit);
    let remainder = divideInt((total - amount), limit);
    return [amount, remainder];
  };
  let $ = split(duration.seconds, 60);
  let seconds$1 = $[0];
  let rest = $[1];
  let $1 = split(rest, 60);
  let minutes = $1[0];
  let rest$1 = $1[1];
  let $2 = split(rest$1, 24);
  let hours = $2[0];
  let rest$2 = $2[1];
  let days = rest$2;
  let add$1 = (out, value, unit) => {
    if (value === 0) {
      return out;
    } else {
      return (out + $int.to_string(value)) + unit;
    }
  };
  let output = (() => {
    let _pipe = "P";
    let _pipe$1 = add$1(_pipe, days, "D");
    let _pipe$2 = $string.append(_pipe$1, "T");
    let _pipe$3 = add$1(_pipe$2, hours, "H");
    return add$1(_pipe$3, minutes, "M");
  })();
  let $3 = duration.nanoseconds;
  if (seconds$1 === 0 && $3 === 0) {
    return output;
  } else if ($3 === 0) {
    return (output + $int.to_string(seconds$1)) + "S";
  } else {
    let f = nanosecond_digits(duration.nanoseconds, 0, "");
    return (((output + $int.to_string(seconds$1)) + ".") + f) + "S";
  }
}

export function seconds(amount) {
  return new Duration(amount, 0);
}

export function milliseconds(amount) {
  let remainder = remainderInt(amount, 1000);
  let overflow = amount - remainder;
  let nanoseconds$1 = remainder * 1_000_000;
  let seconds$1 = divideInt(overflow, 1000);
  return new Duration(seconds$1, nanoseconds$1);
}

export function nanoseconds(amount) {
  let _pipe = new Duration(0, amount);
  return normalise(_pipe);
}

export function to_seconds(duration) {
  let seconds$1 = $int.to_float(duration.seconds);
  let nanoseconds$1 = $int.to_float(duration.nanoseconds);
  return seconds$1 + (divideFloat(nanoseconds$1, 1_000_000_000.0));
}

export function to_seconds_and_nanoseconds(duration) {
  return [duration.seconds, duration.nanoseconds];
}

export const empty = /* @__PURE__ */ new Duration(0, 0);
