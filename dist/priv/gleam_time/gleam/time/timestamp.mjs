import * as $bit_array from "../../../gleam_stdlib/gleam/bit_array.mjs";
import * as $float from "../../../gleam_stdlib/gleam/float.mjs";
import * as $int from "../../../gleam_stdlib/gleam/int.mjs";
import * as $list from "../../../gleam_stdlib/gleam/list.mjs";
import * as $order from "../../../gleam_stdlib/gleam/order.mjs";
import * as $result from "../../../gleam_stdlib/gleam/result.mjs";
import * as $string from "../../../gleam_stdlib/gleam/string.mjs";
import {
  Ok,
  Error,
  toList,
  prepend as listPrepend,
  CustomType as $CustomType,
  remainderInt,
  divideFloat,
  divideInt,
  toBitArray,
  bitArraySlice,
} from "../../gleam.mjs";
import * as $calendar from "../../gleam/time/calendar.mjs";
import * as $duration from "../../gleam/time/duration.mjs";
import { system_time as get_system_time } from "../../gleam_time_ffi.mjs";

class Timestamp extends $CustomType {
  constructor(seconds, nanoseconds) {
    super();
    this.seconds = seconds;
    this.nanoseconds = nanoseconds;
  }
}

function normalise(timestamp) {
  let multiplier = 1_000_000_000;
  let nanoseconds = remainderInt(timestamp.nanoseconds, multiplier);
  let overflow = timestamp.nanoseconds - nanoseconds;
  let seconds = timestamp.seconds + (divideInt(overflow, multiplier));
  let $ = nanoseconds >= 0;
  if ($) {
    return new Timestamp(seconds, nanoseconds);
  } else {
    return new Timestamp(seconds - 1, multiplier + nanoseconds);
  }
}

export function compare(left, right) {
  return $order.break_tie(
    $int.compare(left.seconds, right.seconds),
    $int.compare(left.nanoseconds, right.nanoseconds),
  );
}

export function system_time() {
  let $ = get_system_time();
  let seconds = $[0];
  let nanoseconds = $[1];
  return normalise(new Timestamp(seconds, nanoseconds));
}

export function difference(left, right) {
  let seconds = $duration.seconds(right.seconds - left.seconds);
  let nanoseconds = $duration.nanoseconds(right.nanoseconds - left.nanoseconds);
  return $duration.add(seconds, nanoseconds);
}

export function add(timestamp, duration) {
  let $ = $duration.to_seconds_and_nanoseconds(duration);
  let seconds = $[0];
  let nanoseconds = $[1];
  let _pipe = new Timestamp(
    timestamp.seconds + seconds,
    timestamp.nanoseconds + nanoseconds,
  );
  return normalise(_pipe);
}

function pad_digit(digit, desired_length) {
  let _pipe = $int.to_string(digit);
  return $string.pad_start(_pipe, desired_length, "0");
}

function duration_to_minutes(duration) {
  return $float.round(divideFloat($duration.to_seconds(duration), 60.0));
}

function modulo(n, m) {
  let $ = $int.modulo(n, m);
  if ($.isOk()) {
    let n$1 = $[0];
    return n$1;
  } else {
    return 0;
  }
}

function floored_div(numerator, denominator) {
  let n = divideFloat($int.to_float(numerator), denominator);
  return $float.round($float.floor(n));
}

function to_civil(minutes) {
  let raw_day = floored_div(minutes, (60.0 * 24.0)) + 719_468;
  let era = (() => {
    let $ = raw_day >= 0;
    if ($) {
      return divideInt(raw_day, 146_097);
    } else {
      return divideInt((raw_day - 146_096), 146_097);
    }
  })();
  let day_of_era = raw_day - era * 146_097;
  let year_of_era = divideInt(
    (((day_of_era - (divideInt(day_of_era, 1460))) + (divideInt(
      day_of_era,
      36_524
    ))) - (divideInt(day_of_era, 146_096))),
    365
  );
  let year = year_of_era + era * 400;
  let day_of_year = day_of_era - ((365 * year_of_era + (divideInt(
    year_of_era,
    4
  ))) - (divideInt(year_of_era, 100)));
  let mp = divideInt((5 * day_of_year + 2), 153);
  let month = (() => {
    let $ = mp < 10;
    if ($) {
      return mp + 3;
    } else {
      return mp - 9;
    }
  })();
  let day = (day_of_year - (divideInt((153 * mp + 2), 5))) + 1;
  let year$1 = (() => {
    let $ = month <= 2;
    if ($) {
      return year + 1;
    } else {
      return year;
    }
  })();
  return [year$1, month, day];
}

function to_calendar_from_offset(timestamp, offset) {
  let total = timestamp.seconds + offset * 60;
  let seconds = modulo(total, 60);
  let total_minutes = floored_div(total, 60.0);
  let minutes = divideInt(modulo(total, 60 * 60), 60);
  let hours = divideInt(modulo(total, 24 * 60 * 60), 60 * 60);
  let $ = to_civil(total_minutes);
  let year = $[0];
  let month = $[1];
  let day = $[2];
  return [year, month, day, hours, minutes, seconds];
}

export function to_calendar(timestamp, offset) {
  let offset$1 = duration_to_minutes(offset);
  let $ = to_calendar_from_offset(timestamp, offset$1);
  let year = $[0];
  let month = $[1];
  let day = $[2];
  let hours = $[3];
  let minutes = $[4];
  let seconds = $[5];
  let month$1 = (() => {
    if (month === 1) {
      return new $calendar.January();
    } else if (month === 2) {
      return new $calendar.February();
    } else if (month === 3) {
      return new $calendar.March();
    } else if (month === 4) {
      return new $calendar.April();
    } else if (month === 5) {
      return new $calendar.May();
    } else if (month === 6) {
      return new $calendar.June();
    } else if (month === 7) {
      return new $calendar.July();
    } else if (month === 8) {
      return new $calendar.August();
    } else if (month === 9) {
      return new $calendar.September();
    } else if (month === 10) {
      return new $calendar.October();
    } else if (month === 11) {
      return new $calendar.November();
    } else {
      return new $calendar.December();
    }
  })();
  let nanoseconds = timestamp.nanoseconds;
  let date = new $calendar.Date(year, month$1, day);
  let time = new $calendar.TimeOfDay(hours, minutes, seconds, nanoseconds);
  return [date, time];
}

function do_remove_trailing_zeros(loop$reversed_digits) {
  while (true) {
    let reversed_digits = loop$reversed_digits;
    if (reversed_digits.hasLength(0)) {
      return toList([]);
    } else if (reversed_digits.atLeastLength(1) && (reversed_digits.head === 0)) {
      let digit = reversed_digits.head;
      let digits = reversed_digits.tail;
      loop$reversed_digits = digits;
    } else {
      let reversed_digits$1 = reversed_digits;
      return $list.reverse(reversed_digits$1);
    }
  }
}

function remove_trailing_zeros(digits) {
  let reversed_digits = $list.reverse(digits);
  return do_remove_trailing_zeros(reversed_digits);
}

function do_get_zero_padded_digits(loop$number, loop$digits, loop$count) {
  while (true) {
    let number = loop$number;
    let digits = loop$digits;
    let count = loop$count;
    if ((number <= 0) && (count >= 9)) {
      let number$1 = number;
      return digits;
    } else if (number <= 0) {
      let number$1 = number;
      loop$number = number$1;
      loop$digits = listPrepend(0, digits);
      loop$count = count + 1;
    } else {
      let number$1 = number;
      let digit = remainderInt(number$1, 10);
      let number$2 = floored_div(number$1, 10.0);
      loop$number = number$2;
      loop$digits = listPrepend(digit, digits);
      loop$count = count + 1;
    }
  }
}

function get_zero_padded_digits(number) {
  return do_get_zero_padded_digits(number, toList([]), 0);
}

function show_second_fraction(nanoseconds) {
  let $ = $int.compare(nanoseconds, 0);
  if ($ instanceof $order.Lt) {
    return "";
  } else if ($ instanceof $order.Eq) {
    return "";
  } else {
    let second_fraction_part = (() => {
      let _pipe = nanoseconds;
      let _pipe$1 = get_zero_padded_digits(_pipe);
      let _pipe$2 = remove_trailing_zeros(_pipe$1);
      let _pipe$3 = $list.map(_pipe$2, $int.to_string);
      return $string.join(_pipe$3, "");
    })();
    return "." + second_fraction_part;
  }
}

export function to_rfc3339(timestamp, offset) {
  let offset$1 = duration_to_minutes(offset);
  let $ = to_calendar_from_offset(timestamp, offset$1);
  let years = $[0];
  let months = $[1];
  let days = $[2];
  let hours = $[3];
  let minutes = $[4];
  let seconds = $[5];
  let offset_minutes = modulo(offset$1, 60);
  let offset_hours = $int.absolute_value(floored_div(offset$1, 60.0));
  let n2 = (_capture) => { return pad_digit(_capture, 2); };
  let n4 = (_capture) => { return pad_digit(_capture, 4); };
  let out = "";
  let out$1 = ((((out + n4(years)) + "-") + n2(months)) + "-") + n2(days);
  let out$2 = out$1 + "T";
  let out$3 = ((((out$2 + n2(hours)) + ":") + n2(minutes)) + ":") + n2(seconds);
  let out$4 = out$3 + show_second_fraction(timestamp.nanoseconds);
  let $1 = $int.compare(offset$1, 0);
  if ($1 instanceof $order.Eq) {
    return out$4 + "Z";
  } else if ($1 instanceof $order.Gt) {
    return (((out$4 + "+") + n2(offset_hours)) + ":") + n2(offset_minutes);
  } else {
    return (((out$4 + "-") + n2(offset_hours)) + ":") + n2(offset_minutes);
  }
}

function is_leap_year(year) {
  return ((remainderInt(year, 4)) === 0) && (((remainderInt(year, 100)) !== 0) || ((remainderInt(
    year,
    400
  )) === 0));
}

function parse_sign(bytes) {
  if (bytes.byteAt(0) === 43 &&
  (bytes.bitSize >= 8 && (bytes.bitSize - 8) % 8 === 0)) {
    let remaining_bytes = bitArraySlice(bytes, 8);
    return new Ok(["+", remaining_bytes]);
  } else if (bytes.byteAt(0) === 45 &&
  (bytes.bitSize >= 8 && (bytes.bitSize - 8) % 8 === 0)) {
    let remaining_bytes = bitArraySlice(bytes, 8);
    return new Ok(["-", remaining_bytes]);
  } else {
    return new Error(undefined);
  }
}

function accept_byte(bytes, value) {
  if ((bytes.bitSize >= 8 && (bytes.bitSize - 8) % 8 === 0) &&
  (bytes.byteAt(0) === value)) {
    let byte = bytes.byteAt(0);
    let remaining_bytes = bitArraySlice(bytes, 8);
    return new Ok(remaining_bytes);
  } else {
    return new Error(undefined);
  }
}

function accept_empty(bytes) {
  if (bytes.bitSize == 0) {
    return new Ok(undefined);
  } else {
    return new Error(undefined);
  }
}

function julian_day_from_ymd(year, month, day) {
  let adjustment = divideInt((14 - month), 12);
  let adjusted_year = (year + 4800) - adjustment;
  let adjusted_month = (month + 12 * adjustment) - 3;
  return (((((day + (divideInt((153 * adjusted_month + 2), 5))) + 365 * adjusted_year) + (divideInt(
    adjusted_year,
    4
  ))) - (divideInt(adjusted_year, 100))) + (divideInt(adjusted_year, 400))) - 32_045;
}

export function from_unix_seconds(seconds) {
  return new Timestamp(seconds, 0);
}

export function from_unix_seconds_and_nanoseconds(seconds, nanoseconds) {
  let _pipe = new Timestamp(seconds, nanoseconds);
  return normalise(_pipe);
}

export function to_unix_seconds(timestamp) {
  let seconds = $int.to_float(timestamp.seconds);
  let nanoseconds = $int.to_float(timestamp.nanoseconds);
  return seconds + (divideFloat(nanoseconds, 1_000_000_000.0));
}

export function to_unix_seconds_and_nanoseconds(timestamp) {
  return [timestamp.seconds, timestamp.nanoseconds];
}

const seconds_per_day = 86_400;

const seconds_per_hour = 3600;

const seconds_per_minute = 60;

function offset_to_seconds(sign, hours, minutes) {
  let abs_seconds = hours * seconds_per_hour + minutes * seconds_per_minute;
  if (sign === "-") {
    return - abs_seconds;
  } else {
    return abs_seconds;
  }
}

function julian_seconds_from_parts(year, month, day, hours, minutes, seconds) {
  let julian_day_seconds = julian_day_from_ymd(year, month, day) * seconds_per_day;
  return ((julian_day_seconds + hours * seconds_per_hour) + minutes * seconds_per_minute) + seconds;
}

const nanoseconds_per_second = 1_000_000_000;

const byte_colon = 0x3A;

const byte_minus = 0x2D;

const byte_zero = 0x30;

const byte_nine = 0x39;

function do_parse_second_fraction_as_nanoseconds(
  loop$bytes,
  loop$acc,
  loop$power
) {
  while (true) {
    let bytes = loop$bytes;
    let acc = loop$acc;
    let power = loop$power;
    let power$1 = divideInt(power, 10);
    if ((bytes.bitSize >= 8 && (bytes.bitSize - 8) % 8 === 0) &&
    (((0x30 <= bytes.byteAt(0)) && (bytes.byteAt(0) <= 0x39)) && (power$1 < 1))) {
      let byte = bytes.byteAt(0);
      let remaining_bytes = bitArraySlice(bytes, 8);
      loop$bytes = remaining_bytes;
      loop$acc = acc;
      loop$power = power$1;
    } else if ((bytes.bitSize >= 8 && (bytes.bitSize - 8) % 8 === 0) &&
    ((0x30 <= bytes.byteAt(0)) && (bytes.byteAt(0) <= 0x39))) {
      let byte = bytes.byteAt(0);
      let remaining_bytes = bitArraySlice(bytes, 8);
      let digit = byte - 0x30;
      loop$bytes = remaining_bytes;
      loop$acc = acc + digit * power$1;
      loop$power = power$1;
    } else {
      return new Ok([acc, bytes]);
    }
  }
}

function parse_second_fraction_as_nanoseconds(bytes) {
  if (bytes.byteAt(0) === 46 &&
  (bytes.bitSize >= 16 && (bytes.bitSize - 16) % 8 === 0) &&
  ((0x30 <= bytes.byteAt(1)) && (bytes.byteAt(1) <= 0x39))) {
    let byte = bytes.byteAt(1);
    let remaining_bytes = bitArraySlice(bytes, 16);
    return do_parse_second_fraction_as_nanoseconds(
      toBitArray([byte, remaining_bytes]),
      0,
      nanoseconds_per_second,
    );
  } else if (bytes.byteAt(0) === 46 &&
  (bytes.bitSize >= 8 && (bytes.bitSize - 8) % 8 === 0)) {
    return new Error(undefined);
  } else {
    return new Ok([0, bytes]);
  }
}

function do_parse_digits(loop$bytes, loop$count, loop$acc, loop$k) {
  while (true) {
    let bytes = loop$bytes;
    let count = loop$count;
    let acc = loop$acc;
    let k = loop$k;
    if (k >= count) {
      return new Ok([acc, bytes]);
    } else if ((bytes.bitSize >= 8 && (bytes.bitSize - 8) % 8 === 0) &&
    ((0x30 <= bytes.byteAt(0)) && (bytes.byteAt(0) <= 0x39))) {
      let byte = bytes.byteAt(0);
      let remaining_bytes = bitArraySlice(bytes, 8);
      loop$bytes = remaining_bytes;
      loop$count = count;
      loop$acc = acc * 10 + (byte - 0x30);
      loop$k = k + 1;
    } else {
      return new Error(undefined);
    }
  }
}

function parse_digits(bytes, count) {
  return do_parse_digits(bytes, count, 0, 0);
}

function parse_year(bytes) {
  return parse_digits(bytes, 4);
}

function parse_month(bytes) {
  return $result.try$(
    parse_digits(bytes, 2),
    (_use0) => {
      let month = _use0[0];
      let bytes$1 = _use0[1];
      let $ = (1 <= month) && (month <= 12);
      if ($) {
        return new Ok([month, bytes$1]);
      } else {
        return new Error(undefined);
      }
    },
  );
}

function parse_day(bytes, year, month) {
  return $result.try$(
    parse_digits(bytes, 2),
    (_use0) => {
      let day = _use0[0];
      let bytes$1 = _use0[1];
      return $result.try$(
        (() => {
          if (month === 1) {
            return new Ok(31);
          } else if (month === 3) {
            return new Ok(31);
          } else if (month === 5) {
            return new Ok(31);
          } else if (month === 7) {
            return new Ok(31);
          } else if (month === 8) {
            return new Ok(31);
          } else if (month === 10) {
            return new Ok(31);
          } else if (month === 12) {
            return new Ok(31);
          } else if (month === 4) {
            return new Ok(30);
          } else if (month === 6) {
            return new Ok(30);
          } else if (month === 9) {
            return new Ok(30);
          } else if (month === 11) {
            return new Ok(30);
          } else if (month === 2) {
            let $ = is_leap_year(year);
            if ($) {
              return new Ok(29);
            } else {
              return new Ok(28);
            }
          } else {
            return new Error(undefined);
          }
        })(),
        (max_day) => {
          let $ = (1 <= day) && (day <= max_day);
          if ($) {
            return new Ok([day, bytes$1]);
          } else {
            return new Error(undefined);
          }
        },
      );
    },
  );
}

function parse_hours(bytes) {
  return $result.try$(
    parse_digits(bytes, 2),
    (_use0) => {
      let hours = _use0[0];
      let bytes$1 = _use0[1];
      let $ = (0 <= hours) && (hours <= 23);
      if ($) {
        return new Ok([hours, bytes$1]);
      } else {
        return new Error(undefined);
      }
    },
  );
}

function parse_minutes(bytes) {
  return $result.try$(
    parse_digits(bytes, 2),
    (_use0) => {
      let minutes = _use0[0];
      let bytes$1 = _use0[1];
      let $ = (0 <= minutes) && (minutes <= 59);
      if ($) {
        return new Ok([minutes, bytes$1]);
      } else {
        return new Error(undefined);
      }
    },
  );
}

function parse_seconds(bytes) {
  return $result.try$(
    parse_digits(bytes, 2),
    (_use0) => {
      let seconds = _use0[0];
      let bytes$1 = _use0[1];
      let $ = (0 <= seconds) && (seconds <= 60);
      if ($) {
        return new Ok([seconds, bytes$1]);
      } else {
        return new Error(undefined);
      }
    },
  );
}

function parse_numeric_offset(bytes) {
  return $result.try$(
    parse_sign(bytes),
    (_use0) => {
      let sign = _use0[0];
      let bytes$1 = _use0[1];
      return $result.try$(
        parse_hours(bytes$1),
        (_use0) => {
          let hours = _use0[0];
          let bytes$2 = _use0[1];
          return $result.try$(
            accept_byte(bytes$2, byte_colon),
            (bytes) => {
              return $result.try$(
                parse_minutes(bytes),
                (_use0) => {
                  let minutes = _use0[0];
                  let bytes$1 = _use0[1];
                  let offset_seconds = offset_to_seconds(sign, hours, minutes);
                  return new Ok([offset_seconds, bytes$1]);
                },
              );
            },
          );
        },
      );
    },
  );
}

function parse_offset(bytes) {
  if (bytes.byteAt(0) === 90 &&
  (bytes.bitSize >= 8 && (bytes.bitSize - 8) % 8 === 0)) {
    let remaining_bytes = bitArraySlice(bytes, 8);
    return new Ok([0, remaining_bytes]);
  } else if (bytes.byteAt(0) === 122 &&
  (bytes.bitSize >= 8 && (bytes.bitSize - 8) % 8 === 0)) {
    let remaining_bytes = bitArraySlice(bytes, 8);
    return new Ok([0, remaining_bytes]);
  } else {
    return parse_numeric_offset(bytes);
  }
}

const byte_t_lowercase = 0x74;

const byte_t_uppercase = 0x54;

function accept_date_time_separator(bytes) {
  if ((bytes.bitSize >= 8 && (bytes.bitSize - 8) % 8 === 0) &&
  ((bytes.byteAt(0) === 0x54) || (bytes.byteAt(0) === 0x74))) {
    let byte = bytes.byteAt(0);
    let remaining_bytes = bitArraySlice(bytes, 8);
    return new Ok(remaining_bytes);
  } else {
    return new Error(undefined);
  }
}

const julian_seconds_unix_epoch = 210_866_803_200;

function from_date_time(
  year,
  month,
  day,
  hours,
  minutes,
  seconds,
  second_fraction_as_nanoseconds,
  offset_seconds
) {
  let julian_seconds = julian_seconds_from_parts(
    year,
    month,
    day,
    hours,
    minutes,
    seconds,
  );
  let julian_seconds_since_epoch = julian_seconds - julian_seconds_unix_epoch;
  let _pipe = new Timestamp(
    julian_seconds_since_epoch - offset_seconds,
    second_fraction_as_nanoseconds,
  );
  return normalise(_pipe);
}

export function from_calendar(date, time, offset) {
  let month = (() => {
    let $ = date.month;
    if ($ instanceof $calendar.January) {
      return 1;
    } else if ($ instanceof $calendar.February) {
      return 2;
    } else if ($ instanceof $calendar.March) {
      return 3;
    } else if ($ instanceof $calendar.April) {
      return 4;
    } else if ($ instanceof $calendar.May) {
      return 5;
    } else if ($ instanceof $calendar.June) {
      return 6;
    } else if ($ instanceof $calendar.July) {
      return 7;
    } else if ($ instanceof $calendar.August) {
      return 8;
    } else if ($ instanceof $calendar.September) {
      return 9;
    } else if ($ instanceof $calendar.October) {
      return 10;
    } else if ($ instanceof $calendar.November) {
      return 11;
    } else {
      return 12;
    }
  })();
  return from_date_time(
    date.year,
    month,
    date.day,
    time.hours,
    time.minutes,
    time.seconds,
    time.nanoseconds,
    $float.round($duration.to_seconds(offset)),
  );
}

export function parse_rfc3339(input) {
  let bytes = $bit_array.from_string(input);
  return $result.try$(
    parse_year(bytes),
    (_use0) => {
      let year = _use0[0];
      let bytes$1 = _use0[1];
      return $result.try$(
        accept_byte(bytes$1, byte_minus),
        (bytes) => {
          return $result.try$(
            parse_month(bytes),
            (_use0) => {
              let month = _use0[0];
              let bytes$1 = _use0[1];
              return $result.try$(
                accept_byte(bytes$1, byte_minus),
                (bytes) => {
                  return $result.try$(
                    parse_day(bytes, year, month),
                    (_use0) => {
                      let day = _use0[0];
                      let bytes$1 = _use0[1];
                      return $result.try$(
                        accept_date_time_separator(bytes$1),
                        (bytes) => {
                          return $result.try$(
                            parse_hours(bytes),
                            (_use0) => {
                              let hours = _use0[0];
                              let bytes$1 = _use0[1];
                              return $result.try$(
                                accept_byte(bytes$1, byte_colon),
                                (bytes) => {
                                  return $result.try$(
                                    parse_minutes(bytes),
                                    (_use0) => {
                                      let minutes = _use0[0];
                                      let bytes$1 = _use0[1];
                                      return $result.try$(
                                        accept_byte(bytes$1, byte_colon),
                                        (bytes) => {
                                          return $result.try$(
                                            parse_seconds(bytes),
                                            (_use0) => {
                                              let seconds = _use0[0];
                                              let bytes$1 = _use0[1];
                                              return $result.try$(
                                                parse_second_fraction_as_nanoseconds(
                                                  bytes$1,
                                                ),
                                                (_use0) => {
                                                  let second_fraction_as_nanoseconds = _use0[0];
                                                  let bytes$2 = _use0[1];
                                                  return $result.try$(
                                                    parse_offset(bytes$2),
                                                    (_use0) => {
                                                      let offset_seconds = _use0[0];
                                                      let bytes$3 = _use0[1];
                                                      return $result.try$(
                                                        accept_empty(bytes$3),
                                                        (_use0) => {
                                                          
                                                          return new Ok(
                                                            from_date_time(
                                                              year,
                                                              month,
                                                              day,
                                                              hours,
                                                              minutes,
                                                              seconds,
                                                              second_fraction_as_nanoseconds,
                                                              offset_seconds,
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}
