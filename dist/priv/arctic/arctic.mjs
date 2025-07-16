import * as $dict from "../gleam_stdlib/gleam/dict.mjs";
import * as $int from "../gleam_stdlib/gleam/int.mjs";
import * as $option from "../gleam_stdlib/gleam/option.mjs";
import * as $order from "../gleam_stdlib/gleam/order.mjs";
import * as $result from "../gleam_stdlib/gleam/result.mjs";
import * as $string from "../gleam_stdlib/gleam/string.mjs";
import * as $calendar from "../gleam_time/gleam/time/calendar.mjs";
import * as $timestamp from "../gleam_time/gleam/time/timestamp.mjs";
import * as $element from "../lustre/lustre/element.mjs";
import * as $snag from "../snag/snag.mjs";
import {
  Ok,
  Error,
  toList,
  Empty as $Empty,
  NonEmpty as $NonEmpty,
  CustomType as $CustomType,
  makeError,
} from "./gleam.mjs";

const FILEPATH = "src/arctic.gleam";

export class Collection extends $CustomType {
  constructor(directory, parse, index, feed, ordering, render, raw_pages) {
    super();
    this.directory = directory;
    this.parse = parse;
    this.index = index;
    this.feed = feed;
    this.ordering = ordering;
    this.render = render;
    this.raw_pages = raw_pages;
  }
}

export class Page extends $CustomType {
  constructor(id, body, metadata, title, blerb, tags, date) {
    super();
    this.id = id;
    this.body = body;
    this.metadata = metadata;
    this.title = title;
    this.blerb = blerb;
    this.tags = tags;
    this.date = date;
  }
}

export class CachedPage extends $CustomType {
  constructor(path, metadata) {
    super();
    this.path = path;
    this.metadata = metadata;
  }
}

export class NewPage extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class ProcessedCollection extends $CustomType {
  constructor(collection, pages) {
    super();
    this.collection = collection;
    this.pages = pages;
  }
}

export class RawPage extends $CustomType {
  constructor(id, html) {
    super();
    this.id = id;
    this.html = html;
  }
}

export class Config extends $CustomType {
  constructor(render_home, main_pages, collections, render_spa) {
    super();
    this.render_home = render_home;
    this.main_pages = main_pages;
    this.collections = collections;
    this.render_spa = render_spa;
  }
}

export function get_id(p) {
  if (p instanceof CachedPage) {
    let metadata = p.metadata;
    let $ = $dict.get(metadata, "id");
    if (!($ instanceof Ok)) {
      throw makeError(
        "let_assert",
        FILEPATH,
        "arctic",
        82,
        "get_id",
        "Pattern match failed, no pattern matched the value.",
        {
          value: $,
          start: 2581,
          end: 2625,
          pattern_start: 2592,
          pattern_end: 2598
        }
      )
    }
    let id = $[0];
    return id;
  } else {
    let page = p[0];
    return page.id;
  }
}

export function output_path(input_path) {
  let $ = $string.split(input_path, ".txt");
  if (
    $ instanceof $Empty ||
    $.tail instanceof $Empty ||
    $.tail.tail instanceof $NonEmpty ||
    $.tail.head !== ""
  ) {
    throw makeError(
      "let_assert",
      FILEPATH,
      "arctic",
      90,
      "output_path",
      "Pattern match failed, no pattern matched the value.",
      {
        value: $,
        start: 2730,
        end: 2787,
        pattern_start: 2741,
        pattern_end: 2752
      }
    )
  }
  let start = $.head;
  return ("arctic_build/" + start) + "/index.html";
}

export function parse_date(date) {
  let _block;
  let $ = $string.split(date, "-");
  if ($ instanceof $Empty) {
    _block = new Error(undefined);
  } else {
    let $1 = $.tail;
    if ($1 instanceof $Empty) {
      _block = new Error(undefined);
    } else {
      let $2 = $1.tail;
      if ($2 instanceof $Empty) {
        _block = new Error(undefined);
      } else {
        let $3 = $2.tail;
        if ($3 instanceof $Empty) {
          let year_str = $.head;
          let month_str = $1.head;
          let day_str = $2.head;
          _block = $result.try$(
            $int.parse(year_str),
            (year) => {
              return $result.try$(
                $int.parse(month_str),
                (month_int) => {
                  return $result.try$(
                    $int.parse(day_str),
                    (day) => {
                      return $result.try$(
                        (() => {
                          if (month_int === 1) {
                            return new Ok(new $calendar.January());
                          } else if (month_int === 2) {
                            return new Ok(new $calendar.February());
                          } else if (month_int === 3) {
                            return new Ok(new $calendar.March());
                          } else if (month_int === 4) {
                            return new Ok(new $calendar.April());
                          } else if (month_int === 5) {
                            return new Ok(new $calendar.May());
                          } else if (month_int === 6) {
                            return new Ok(new $calendar.June());
                          } else if (month_int === 7) {
                            return new Ok(new $calendar.July());
                          } else if (month_int === 8) {
                            return new Ok(new $calendar.August());
                          } else if (month_int === 9) {
                            return new Ok(new $calendar.September());
                          } else if (month_int === 10) {
                            return new Ok(new $calendar.October());
                          } else if (month_int === 11) {
                            return new Ok(new $calendar.November());
                          } else if (month_int === 12) {
                            return new Ok(new $calendar.December());
                          } else {
                            return new Error(undefined);
                          }
                        })(),
                        (month) => {
                          return new Ok(
                            $timestamp.from_calendar(
                              new $calendar.Date(year, month, day),
                              new $calendar.TimeOfDay(0, 0, 0, 0),
                              $calendar.utc_offset,
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
        } else {
          _block = new Error(undefined);
        }
      }
    }
  }
  let _pipe = _block;
  return $result.map_error(
    _pipe,
    (_) => { return $snag.new$(("couldn't parse date `" + date) + "`"); },
  );
}

export function to_dummy_page(c) {
  if (c instanceof CachedPage) {
    let metadata = c.metadata;
    let _block;
    let _pipe = metadata;
    let _pipe$1 = $dict.get(_pipe, "title");
    _block = $result.unwrap(_pipe$1, "");
    let title = _block;
    let _block$1;
    let _pipe$2 = metadata;
    let _pipe$3 = $dict.get(_pipe$2, "blerb");
    _block$1 = $result.unwrap(_pipe$3, "");
    let blerb = _block$1;
    let _block$2;
    let _pipe$4 = metadata;
    let _pipe$5 = $dict.get(_pipe$4, "tags");
    let _pipe$6 = $result.map(
      _pipe$5,
      (_capture) => { return $string.split(_capture, ","); },
    );
    _block$2 = $result.unwrap(_pipe$6, toList([]));
    let tags = _block$2;
    let _block$3;
    let _pipe$7 = metadata;
    let _pipe$8 = $dict.get(_pipe$7, "date");
    let _pipe$9 = $result.try$(
      _pipe$8,
      (s) => {
        let _pipe$9 = s;
        let _pipe$10 = parse_date(_pipe$9);
        return $result.map_error(_pipe$10, (_) => { return undefined; });
      },
    );
    _block$3 = $option.from_result(_pipe$9);
    let date = _block$3;
    return new Page(get_id(c), toList([]), metadata, title, blerb, tags, date);
  } else {
    let p = c[0];
    return p;
  }
}

export function date_to_string(ts) {
  let d = $timestamp.to_calendar(ts, $calendar.utc_offset)[0];
  let _block;
  let $ = d.month;
  if ($ instanceof $calendar.January) {
    _block = "01";
  } else if ($ instanceof $calendar.February) {
    _block = "02";
  } else if ($ instanceof $calendar.March) {
    _block = "03";
  } else if ($ instanceof $calendar.April) {
    _block = "04";
  } else if ($ instanceof $calendar.May) {
    _block = "05";
  } else if ($ instanceof $calendar.June) {
    _block = "06";
  } else if ($ instanceof $calendar.July) {
    _block = "07";
  } else if ($ instanceof $calendar.August) {
    _block = "08";
  } else if ($ instanceof $calendar.September) {
    _block = "09";
  } else if ($ instanceof $calendar.October) {
    _block = "10";
  } else if ($ instanceof $calendar.November) {
    _block = "11";
  } else {
    _block = "12";
  }
  let month_str = _block;
  let _block$1;
  let $1 = d.day < 10;
  if ($1) {
    _block$1 = "0" + $int.to_string(d.day);
  } else {
    _block$1 = $int.to_string(d.day);
  }
  let day_str = _block$1;
  return ((($int.to_string(d.year) + "-") + month_str) + "-") + day_str;
}
