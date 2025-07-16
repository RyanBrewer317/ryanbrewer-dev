import * as $regexp from "../../gleam_regexp/gleam/regexp.mjs";
import * as $int from "../../gleam_stdlib/gleam/int.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import * as $order from "../../gleam_stdlib/gleam/order.mjs";
import * as $result from "../../gleam_stdlib/gleam/result.mjs";
import * as $string from "../../gleam_stdlib/gleam/string.mjs";
import {
  Ok,
  Error,
  toList,
  Empty as $Empty,
  NonEmpty as $NonEmpty,
  prepend as listPrepend,
  CustomType as $CustomType,
  makeError,
  remainderInt,
  divideInt,
} from "../gleam.mjs";

const FILEPATH = "src/birl/duration.gleam";

export class Duration extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class MicroSecond extends $CustomType {}

export class MilliSecond extends $CustomType {}

export class Second extends $CustomType {}

export class Minute extends $CustomType {}

export class Hour extends $CustomType {}

export class Day extends $CustomType {}

export class Week extends $CustomType {}

export class Month extends $CustomType {}

export class Year extends $CustomType {}

export function add(a, b) {
  let a$1 = a[0];
  let b$1 = b[0];
  return new Duration(a$1 + b$1);
}

export function subtract(a, b) {
  let a$1 = a[0];
  let b$1 = b[0];
  return new Duration(a$1 - b$1);
}

export function scale_up(value, factor) {
  let value$1 = value[0];
  return new Duration(value$1 * factor);
}

export function scale_down(value, factor) {
  let value$1 = value[0];
  return new Duration(divideInt(value$1, factor));
}

export function micro_seconds(value) {
  return new Duration(value);
}

export function compare(a, b) {
  let dta = a[0];
  let dtb = b[0];
  let $ = dta === dtb;
  let $1 = dta < dtb;
  if ($) {
    return new $order.Eq();
  } else if ($1) {
    return new $order.Lt();
  } else {
    return new $order.Gt();
  }
}

function extract(duration, unit_value) {
  return [divideInt(duration, unit_value), remainderInt(duration, unit_value)];
}

const milli_second = 1000;

export function milli_seconds(value) {
  return new Duration(value * milli_second);
}

const second = 1_000_000;

export function seconds(value) {
  return new Duration(value * second);
}

const minute = 60_000_000;

export function minutes(value) {
  return new Duration(value * minute);
}

const hour = 3_600_000_000;

export function hours(value) {
  return new Duration(value * hour);
}

const day = 86_400_000_000;

export function days(value) {
  return new Duration(value * day);
}

const week = 604_800_000_000;

export function weeks(value) {
  return new Duration(value * week);
}

const month = 2_592_000_000_000;

export function months(value) {
  return new Duration(value * month);
}

const year = 31_536_000_000_000;

export function years(value) {
  return new Duration(value * year);
}

export function new$(values) {
  let _pipe = values;
  let _pipe$1 = $list.fold(
    _pipe,
    0,
    (total, current) => {
      let $ = current[1];
      if ($ instanceof MicroSecond) {
        let amount = current[0];
        return total + amount;
      } else if ($ instanceof MilliSecond) {
        let amount = current[0];
        return total + amount * milli_second;
      } else if ($ instanceof Second) {
        let amount = current[0];
        return total + amount * second;
      } else if ($ instanceof Minute) {
        let amount = current[0];
        return total + amount * minute;
      } else if ($ instanceof Hour) {
        let amount = current[0];
        return total + amount * hour;
      } else if ($ instanceof Day) {
        let amount = current[0];
        return total + amount * day;
      } else if ($ instanceof Week) {
        let amount = current[0];
        return total + amount * week;
      } else if ($ instanceof Month) {
        let amount = current[0];
        return total + amount * month;
      } else {
        let amount = current[0];
        return total + amount * year;
      }
    },
  );
  return new Duration(_pipe$1);
}

export function decompose(duration) {
  let value = duration[0];
  let absolute_value = $int.absolute_value(value);
  let $ = extract(absolute_value, year);
  let years$1 = $[0];
  let remaining = $[1];
  let $1 = extract(remaining, month);
  let months$1 = $1[0];
  let remaining$1 = $1[1];
  let $2 = extract(remaining$1, week);
  let weeks$1 = $2[0];
  let remaining$2 = $2[1];
  let $3 = extract(remaining$2, day);
  let days$1 = $3[0];
  let remaining$3 = $3[1];
  let $4 = extract(remaining$3, hour);
  let hours$1 = $4[0];
  let remaining$4 = $4[1];
  let $5 = extract(remaining$4, minute);
  let minutes$1 = $5[0];
  let remaining$5 = $5[1];
  let $6 = extract(remaining$5, second);
  let seconds$1 = $6[0];
  let remaining$6 = $6[1];
  let $7 = extract(remaining$6, milli_second);
  let milli_seconds$1 = $7[0];
  let remaining$7 = $7[1];
  let _pipe = toList([
    [years$1, new Year()],
    [months$1, new Month()],
    [weeks$1, new Week()],
    [days$1, new Day()],
    [hours$1, new Hour()],
    [minutes$1, new Minute()],
    [seconds$1, new Second()],
    [milli_seconds$1, new MilliSecond()],
    [remaining$7, new MicroSecond()],
  ]);
  let _pipe$1 = $list.filter(_pipe, (item) => { return item[0] > 0; });
  return $list.map(
    _pipe$1,
    (item) => {
      let $8 = value < 0;
      if ($8) {
        return [-1 * item[0], item[1]];
      } else {
        return item;
      }
    },
  );
}

function unit_values(unit) {
  if (unit instanceof MicroSecond) {
    return 1;
  } else if (unit instanceof MilliSecond) {
    return milli_second;
  } else if (unit instanceof Second) {
    return second;
  } else if (unit instanceof Minute) {
    return minute;
  } else if (unit instanceof Hour) {
    return hour;
  } else if (unit instanceof Day) {
    return day;
  } else if (unit instanceof Week) {
    return week;
  } else if (unit instanceof Month) {
    return month;
  } else {
    return year;
  }
}

export function blur_to(duration, unit) {
  let unit_value = unit_values(unit);
  let value = duration[0];
  let $ = extract(value, unit_value);
  let unit_counts = $[0];
  let remaining = $[1];
  let $1 = remaining >= (divideInt(unit_value * 2, 3));
  if ($1) {
    return unit_counts + 1;
  } else {
    return unit_counts;
  }
}

function inner_blur(loop$values) {
  while (true) {
    let values = loop$values;
    if (values instanceof $Empty) {
      return [0, new MicroSecond()];
    } else {
      let $ = values.tail;
      if ($ instanceof $Empty) {
        let single = values.head;
        return single;
      } else {
        let smaller = values.head;
        let larger = $.head;
        let rest = $.tail;
        let smaller_unit_value = unit_values(smaller[1]);
        let larger_unit_value = unit_values(larger[1]);
        let at_least_two_thirds = smaller[0] * smaller_unit_value < (divideInt(
          larger_unit_value * 2,
          3
        ));
        let _block;
        if (at_least_two_thirds) {
          _block = larger;
        } else {
          _block = [larger[0] + 1, larger[1]];
        }
        let rounded = _block;
        loop$values = listPrepend(rounded, rest);
      }
    }
  }
}

export function blur(duration) {
  let _pipe = decompose(duration);
  let _pipe$1 = $list.reverse(_pipe);
  return inner_blur(_pipe$1);
}

const accurate_month = 2_629_746_000_000;

const accurate_year = 31_556_952_000_000;

export function accurate_new(values) {
  let _pipe = values;
  let _pipe$1 = $list.fold(
    _pipe,
    0,
    (total, current) => {
      let $ = current[1];
      if ($ instanceof MicroSecond) {
        let amount = current[0];
        return total + amount;
      } else if ($ instanceof MilliSecond) {
        let amount = current[0];
        return total + amount * milli_second;
      } else if ($ instanceof Second) {
        let amount = current[0];
        return total + amount * second;
      } else if ($ instanceof Minute) {
        let amount = current[0];
        return total + amount * minute;
      } else if ($ instanceof Hour) {
        let amount = current[0];
        return total + amount * hour;
      } else if ($ instanceof Day) {
        let amount = current[0];
        return total + amount * day;
      } else if ($ instanceof Week) {
        let amount = current[0];
        return total + amount * week;
      } else if ($ instanceof Month) {
        let amount = current[0];
        return total + amount * accurate_month;
      } else {
        let amount = current[0];
        return total + amount * accurate_year;
      }
    },
  );
  return new Duration(_pipe$1);
}

export function accurate_decompose(duration) {
  let value = duration[0];
  let absolute_value = $int.absolute_value(value);
  let $ = extract(absolute_value, accurate_year);
  let years$1 = $[0];
  let remaining = $[1];
  let $1 = extract(remaining, accurate_month);
  let months$1 = $1[0];
  let remaining$1 = $1[1];
  let $2 = extract(remaining$1, week);
  let weeks$1 = $2[0];
  let remaining$2 = $2[1];
  let $3 = extract(remaining$2, day);
  let days$1 = $3[0];
  let remaining$3 = $3[1];
  let $4 = extract(remaining$3, hour);
  let hours$1 = $4[0];
  let remaining$4 = $4[1];
  let $5 = extract(remaining$4, minute);
  let minutes$1 = $5[0];
  let remaining$5 = $5[1];
  let $6 = extract(remaining$5, second);
  let seconds$1 = $6[0];
  let remaining$6 = $6[1];
  let $7 = extract(remaining$6, milli_second);
  let milli_seconds$1 = $7[0];
  let remaining$7 = $7[1];
  let _pipe = toList([
    [years$1, new Year()],
    [months$1, new Month()],
    [weeks$1, new Week()],
    [days$1, new Day()],
    [hours$1, new Hour()],
    [minutes$1, new Minute()],
    [seconds$1, new Second()],
    [milli_seconds$1, new MilliSecond()],
    [remaining$7, new MicroSecond()],
  ]);
  let _pipe$1 = $list.filter(_pipe, (item) => { return item[0] > 0; });
  return $list.map(
    _pipe$1,
    (item) => {
      let $8 = value < 0;
      if ($8) {
        return [-1 * item[0], item[1]];
      } else {
        return item;
      }
    },
  );
}

const year_units = /* @__PURE__ */ toList(["y", "year", "years"]);

const month_units = /* @__PURE__ */ toList(["mon", "month", "months"]);

const week_units = /* @__PURE__ */ toList(["w", "week", "weeks"]);

const day_units = /* @__PURE__ */ toList(["d", "day", "days"]);

const hour_units = /* @__PURE__ */ toList(["h", "hour", "hours"]);

const minute_units = /* @__PURE__ */ toList(["m", "min", "minute", "minutes"]);

const second_units = /* @__PURE__ */ toList([
  "s",
  "sec",
  "secs",
  "second",
  "seconds",
]);

const milli_second_units = /* @__PURE__ */ toList([
  "ms",
  "msec",
  "msecs",
  "millisecond",
  "milliseconds",
  "milli-second",
  "milli-seconds",
  "milli_second",
  "milli_seconds",
]);

const units = /* @__PURE__ */ toList([
  [/* @__PURE__ */ new Year(), year_units],
  [/* @__PURE__ */ new Month(), month_units],
  [/* @__PURE__ */ new Week(), week_units],
  [/* @__PURE__ */ new Day(), day_units],
  [/* @__PURE__ */ new Hour(), hour_units],
  [/* @__PURE__ */ new Minute(), minute_units],
  [/* @__PURE__ */ new Second(), second_units],
  [/* @__PURE__ */ new MilliSecond(), milli_second_units],
]);

export function parse(expression) {
  let $ = $regexp.from_string("([+|\\-])?\\s*(\\d+)\\s*(\\w+)?");
  if (!($ instanceof Ok)) {
    throw makeError(
      "let_assert",
      FILEPATH,
      "birl/duration",
      328,
      "parse",
      "Pattern match failed, no pattern matched the value.",
      {
        value: $,
        start: 8616,
        end: 8689,
        pattern_start: 8627,
        pattern_end: 8633
      }
    )
  }
  let re = $[0];
  let _block;
  let $2 = $string.starts_with(expression, "accurate:");
  if ($2) {
    let $3 = $string.split(expression, ":");
    if (
      $3 instanceof $Empty ||
      $3.tail instanceof $Empty ||
      $3.tail.tail instanceof $NonEmpty
    ) {
      throw makeError(
        "let_assert",
        FILEPATH,
        "birl/duration",
        334,
        "parse",
        "Pattern match failed, no pattern matched the value.",
        {
          value: $3,
          start: 8803,
          end: 8861,
          pattern_start: 8814,
          pattern_end: 8829
        }
      )
    }
    let expression$1 = $3.tail.head;
    _block = [accurate_new, expression$1];
  } else {
    _block = [new$, expression];
  }
  let $1 = _block;
  let constructor = $1[0];
  let expression$1 = $1[1];
  let $3 = (() => {
    let _pipe = expression$1;
    let _pipe$1 = $string.lowercase(_pipe);
    let _pipe$2 = ((_capture) => { return $regexp.scan(re, _capture); })(
      _pipe$1,
    );
    return $list.try_map(
      _pipe$2,
      (item) => {
        let $4 = item.submatches;
        if ($4 instanceof $Empty) {
          return new Error(undefined);
        } else {
          let $5 = $4.tail;
          if ($5 instanceof $Empty) {
            return new Error(undefined);
          } else {
            let $6 = $5.tail;
            if ($6 instanceof $Empty) {
              let $7 = $5.head;
              if ($7 instanceof $option.Some) {
                let sign_option = $4.head;
                let amount_string = $7[0];
                return $result.then$(
                  $int.parse(amount_string),
                  (amount) => {
                    if (sign_option instanceof $option.Some) {
                      let $8 = sign_option[0];
                      if ($8 === "-") {
                        return new Ok([-1 * amount, new MicroSecond()]);
                      } else if ($8 === "+") {
                        return new Ok([amount, new MicroSecond()]);
                      } else {
                        return new Error(undefined);
                      }
                    } else {
                      return new Ok([amount, new MicroSecond()]);
                    }
                  },
                );
              } else {
                return new Error(undefined);
              }
            } else {
              let $7 = $6.tail;
              if ($7 instanceof $Empty) {
                let $8 = $6.head;
                if ($8 instanceof $option.Some) {
                  let $9 = $5.head;
                  if ($9 instanceof $option.Some) {
                    let sign_option = $4.head;
                    let unit = $8[0];
                    let amount_string = $9[0];
                    return $result.then$(
                      $int.parse(amount_string),
                      (amount) => {
                        return $result.then$(
                          $list.find(
                            units,
                            (item) => { return $list.contains(item[1], unit); },
                          ),
                          (_use0) => {
                            let unit$1 = _use0[0];
                            if (sign_option instanceof $option.Some) {
                              let $10 = sign_option[0];
                              if ($10 === "-") {
                                return new Ok([-1 * amount, unit$1]);
                              } else if ($10 === "+") {
                                return new Ok([amount, unit$1]);
                              } else {
                                return new Error(undefined);
                              }
                            } else {
                              return new Ok([amount, unit$1]);
                            }
                          },
                        );
                      },
                    );
                  } else {
                    return new Error(undefined);
                  }
                } else {
                  return new Error(undefined);
                }
              } else {
                return new Error(undefined);
              }
            }
          }
        }
      },
    );
  })();
  if ($3 instanceof Ok) {
    let values = $3[0];
    let _pipe = values;
    let _pipe$1 = constructor(_pipe);
    return new Ok(_pipe$1);
  } else {
    return new Error(undefined);
  }
}
