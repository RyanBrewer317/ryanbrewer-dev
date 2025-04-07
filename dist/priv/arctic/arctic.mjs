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
import { Ok, Error, toList, CustomType as $CustomType, makeError } from "./gleam.mjs";

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
  constructor(x0) {
    super();
    this[0] = x0;
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
    if (!$.isOk()) {
      throw makeError(
        "let_assert",
        "arctic",
        82,
        "get_id",
        "Pattern match failed, no pattern matched the value.",
        { value: $ }
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
  if (!$.hasLength(2) || $.tail.head !== "") {
    throw makeError(
      "let_assert",
      "arctic",
      90,
      "output_path",
      "Pattern match failed, no pattern matched the value.",
      { value: $ }
    )
  }
  let start = $.head;
  return ("arctic_build/" + start) + "/index.html";
}

export function parse_date(date) {
  let _pipe = (() => {
    let $ = $string.split(date, "-");
    if ($.hasLength(3)) {
      let year_str = $.head;
      let month_str = $.tail.head;
      let day_str = $.tail.tail.head;
      return $result.try$(
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
      return new Error(undefined);
    }
  })();
  return $result.map_error(
    _pipe,
    (_) => { return $snag.new$(("couldn't parse date `" + date) + "`"); },
  );
}

export function to_dummy_page(c) {
  if (c instanceof CachedPage) {
    let metadata = c.metadata;
    let title = (() => {
      let _pipe = metadata;
      let _pipe$1 = $dict.get(_pipe, "title");
      return $result.unwrap(_pipe$1, "");
    })();
    let blerb = (() => {
      let _pipe = metadata;
      let _pipe$1 = $dict.get(_pipe, "blerb");
      return $result.unwrap(_pipe$1, "");
    })();
    let tags = (() => {
      let _pipe = metadata;
      let _pipe$1 = $dict.get(_pipe, "tags");
      let _pipe$2 = $result.map(
        _pipe$1,
        (_capture) => { return $string.split(_capture, ","); },
      );
      return $result.unwrap(_pipe$2, toList([]));
    })();
    let date = (() => {
      let _pipe = metadata;
      let _pipe$1 = $dict.get(_pipe, "date");
      let _pipe$2 = $result.try$(
        _pipe$1,
        (s) => {
          let _pipe$2 = s;
          let _pipe$3 = parse_date(_pipe$2);
          return $result.map_error(_pipe$3, (_) => { return undefined; });
        },
      );
      return $option.from_result(_pipe$2);
    })();
    return new Page(get_id(c), toList([]), metadata, title, blerb, tags, date);
  } else {
    let p = c[0];
    return p;
  }
}

export function date_to_string(ts) {
  let d = $timestamp.to_calendar(ts, $calendar.utc_offset)[0];
  let month_str = (() => {
    let $ = d.month;
    if ($ instanceof $calendar.January) {
      return "01";
    } else if ($ instanceof $calendar.February) {
      return "02";
    } else if ($ instanceof $calendar.March) {
      return "03";
    } else if ($ instanceof $calendar.April) {
      return "04";
    } else if ($ instanceof $calendar.May) {
      return "05";
    } else if ($ instanceof $calendar.June) {
      return "06";
    } else if ($ instanceof $calendar.July) {
      return "07";
    } else if ($ instanceof $calendar.August) {
      return "08";
    } else if ($ instanceof $calendar.September) {
      return "09";
    } else if ($ instanceof $calendar.October) {
      return "10";
    } else if ($ instanceof $calendar.November) {
      return "11";
    } else {
      return "12";
    }
  })();
  let day_str = (() => {
    let $ = d.day < 10;
    if ($) {
      return "0" + $int.to_string(d.day);
    } else {
      return $int.to_string(d.day);
    }
  })();
  return ((($int.to_string(d.year) + "-") + month_str) + "-") + day_str;
}
