import * as $dict from "../gleam_stdlib/gleam/dict.mjs";
import * as $list from "../gleam_stdlib/gleam/list.mjs";
import * as $result from "../gleam_stdlib/gleam/result.mjs";
import * as $string from "../gleam_stdlib/gleam/string.mjs";
import * as $glearray from "../glearray/glearray.mjs";
import {
  Ok,
  Error,
  toList,
  Empty as $Empty,
  prepend as listPrepend,
  CustomType as $CustomType,
} from "./gleam.mjs";
import { slice as slice_bytes, drop_bytes } from "./gsv_ffi.mjs";

export class UnescapedQuote extends $CustomType {
  constructor(position) {
    super();
    this.position = position;
  }
}

export class UnclosedEscapedField extends $CustomType {
  constructor(start) {
    super();
    this.start = start;
  }
}

export class Windows extends $CustomType {}

export class Unix extends $CustomType {}

class ParsingEscapedField extends $CustomType {}

class ParsingUnescapedField extends $CustomType {}

class SeparatorFound extends $CustomType {}

class NewlineFound extends $CustomType {}

class QuotSep extends $CustomType {}

class Sep extends $CustomType {}

class NoSep extends $CustomType {}

function line_ending_to_string(le) {
  if (le instanceof Windows) {
    return "\r\n";
  } else {
    return "\n";
  }
}

function escape_field(field, separator) {
  let $ = $string.contains(field, "\"");
  if ($) {
    return ("\"" + $string.replace(field, "\"", "\"\"")) + "\"";
  } else {
    let $1 = $string.contains(field, separator) || $string.contains(field, "\n");
    if ($1) {
      return ("\"" + field) + "\"";
    } else {
      return field;
    }
  }
}

export function from_lists(rows, separator, line_ending) {
  let line_ending$1 = line_ending_to_string(line_ending);
  let _pipe = $list.map(
    rows,
    (row) => {
      let _pipe = $list.map(
        row,
        (_capture) => { return escape_field(_capture, separator); },
      );
      return $string.join(_pipe, separator);
    },
  );
  let _pipe$1 = $string.join(_pipe, line_ending$1);
  return $string.append(_pipe$1, line_ending$1);
}

function row_dict_to_list(row, headers) {
  return $list.map(
    headers,
    (header) => {
      let $ = $dict.get(row, header);
      if ($ instanceof Ok) {
        let field = $[0];
        return field;
      } else {
        return "";
      }
    },
  );
}

export function from_dicts(rows, separator, line_ending) {
  if (rows instanceof $Empty) {
    return "";
  } else {
    let _block;
    let _pipe = rows;
    let _pipe$1 = $list.flat_map(_pipe, $dict.keys);
    let _pipe$2 = $list.unique(_pipe$1);
    _block = $list.sort(_pipe$2, $string.compare);
    let headers = _block;
    let rows$1 = $list.map(
      rows,
      (_capture) => { return row_dict_to_list(_capture, headers); },
    );
    return from_lists(listPrepend(headers, rows$1), separator, line_ending);
  }
}

function extract_field(string, from, length, status) {
  let field = slice_bytes(string, from, length);
  if (status instanceof ParsingEscapedField) {
    return $string.replace(field, "\"\"", "\"");
  } else if (status instanceof ParsingUnescapedField) {
    return field;
  } else if (status instanceof SeparatorFound) {
    return field;
  } else {
    return field;
  }
}

function do_parse(
  loop$string,
  loop$original,
  loop$field_start,
  loop$field_length,
  loop$row,
  loop$rows,
  loop$status,
  loop$field_separator
) {
  while (true) {
    let string = loop$string;
    let original = loop$original;
    let field_start = loop$field_start;
    let field_length = loop$field_length;
    let row = loop$row;
    let rows = loop$rows;
    let status = loop$status;
    let field_separator = loop$field_separator;
    let sep_len = $string.length(field_separator);
    let _block;
    let $1 = $string.starts_with(string, field_separator);
    if ($1) {
      _block = [$string.drop_start(string, sep_len), sep_len, new Sep()];
    } else {
      let $2 = $string.starts_with(string, "\"" + field_separator);
      if ($2) {
        _block = [
          $string.drop_start(string, sep_len + 1),
          sep_len + 1,
          new QuotSep(),
        ];
      } else {
        _block = [string, 0, new NoSep()];
      }
    }
    let $ = _block;
    let remaining = $[0];
    let skip = $[1];
    let sep = $[2];
    if (status instanceof ParsingEscapedField) {
      if (sep instanceof QuotSep) {
        let rest = remaining;
        let field = extract_field(original, field_start, field_length, status);
        let row$1 = listPrepend(field, row);
        let start = (field_start + field_length) + skip;
        loop$string = rest;
        loop$original = original;
        loop$field_start = start;
        loop$field_length = 0;
        loop$row = row$1;
        loop$rows = rows;
        loop$status = new SeparatorFound();
        loop$field_separator = field_separator;
      } else if (sep instanceof NoSep) {
        if (remaining === "\"") {
          let field = extract_field(original, field_start, field_length, status);
          let row$1 = $list.reverse(listPrepend(field, row));
          return new Ok($list.reverse(listPrepend(row$1, rows)));
        } else if (remaining === "") {
          return new Error(new UnclosedEscapedField(field_start));
        } else if (remaining.startsWith("\"\n")) {
          let rest = remaining.slice(2);
          let field = extract_field(original, field_start, field_length, status);
          let row$1 = $list.reverse(listPrepend(field, row));
          let rows$1 = listPrepend(row$1, rows);
          let field_start$1 = (field_start + field_length) + 2;
          loop$string = rest;
          loop$original = original;
          loop$field_start = field_start$1;
          loop$field_length = 0;
          loop$row = toList([]);
          loop$rows = rows$1;
          loop$status = new NewlineFound();
          loop$field_separator = field_separator;
        } else if (remaining.startsWith("\"\r\n")) {
          let rest = remaining.slice(3);
          let field = extract_field(original, field_start, field_length, status);
          let row$1 = $list.reverse(listPrepend(field, row));
          let rows$1 = listPrepend(row$1, rows);
          let field_start$1 = (field_start + field_length) + 3;
          loop$string = rest;
          loop$original = original;
          loop$field_start = field_start$1;
          loop$field_length = 0;
          loop$row = toList([]);
          loop$rows = rows$1;
          loop$status = new NewlineFound();
          loop$field_separator = field_separator;
        } else if (remaining.startsWith("\"\"")) {
          let rest = remaining.slice(2);
          loop$string = rest;
          loop$original = original;
          loop$field_start = field_start;
          loop$field_length = field_length + 2;
          loop$row = row;
          loop$rows = rows;
          loop$status = status;
          loop$field_separator = field_separator;
        } else if (remaining.startsWith("\"")) {
          return new Error(new UnescapedQuote(field_start + field_length));
        } else {
          let _block$1;
          if (status instanceof ParsingEscapedField) {
            _block$1 = new ParsingEscapedField();
          } else if (status instanceof ParsingUnescapedField) {
            _block$1 = new ParsingUnescapedField();
          } else if (status instanceof SeparatorFound) {
            _block$1 = new ParsingUnescapedField();
          } else {
            _block$1 = new ParsingUnescapedField();
          }
          let status$1 = _block$1;
          let rest = drop_bytes(string, 1);
          loop$string = rest;
          loop$original = original;
          loop$field_start = field_start;
          loop$field_length = field_length + 1;
          loop$row = row;
          loop$rows = rows;
          loop$status = status$1;
          loop$field_separator = field_separator;
        }
      } else {
        let _block$1;
        if (status instanceof ParsingEscapedField) {
          _block$1 = new ParsingEscapedField();
        } else if (status instanceof ParsingUnescapedField) {
          _block$1 = new ParsingUnescapedField();
        } else if (status instanceof SeparatorFound) {
          _block$1 = new ParsingUnescapedField();
        } else {
          _block$1 = new ParsingUnescapedField();
        }
        let status$1 = _block$1;
        let rest = drop_bytes(string, 1);
        loop$string = rest;
        loop$original = original;
        loop$field_start = field_start;
        loop$field_length = field_length + 1;
        loop$row = row;
        loop$rows = rows;
        loop$status = status$1;
        loop$field_separator = field_separator;
      }
    } else if (status instanceof ParsingUnescapedField) {
      if (sep instanceof Sep) {
        let rest = remaining;
        let field = extract_field(original, field_start, field_length, status);
        let row$1 = listPrepend(field, row);
        let start = (field_start + field_length) + skip;
        loop$string = rest;
        loop$original = original;
        loop$field_start = start;
        loop$field_length = 0;
        loop$row = row$1;
        loop$rows = rows;
        loop$status = new SeparatorFound();
        loop$field_separator = field_separator;
      } else if (sep instanceof NoSep) {
        if (remaining === "") {
          let field = extract_field(original, field_start, field_length, status);
          let row$1 = $list.reverse(listPrepend(field, row));
          return new Ok($list.reverse(listPrepend(row$1, rows)));
        } else if (remaining.startsWith("\n")) {
          let rest = remaining.slice(1);
          let field = extract_field(original, field_start, field_length, status);
          let row$1 = $list.reverse(listPrepend(field, row));
          let rows$1 = listPrepend(row$1, rows);
          let field_start$1 = (field_start + field_length) + 1;
          loop$string = rest;
          loop$original = original;
          loop$field_start = field_start$1;
          loop$field_length = 0;
          loop$row = toList([]);
          loop$rows = rows$1;
          loop$status = new NewlineFound();
          loop$field_separator = field_separator;
        } else if (remaining.startsWith("\r\n")) {
          let rest = remaining.slice(2);
          let field = extract_field(original, field_start, field_length, status);
          let row$1 = $list.reverse(listPrepend(field, row));
          let rows$1 = listPrepend(row$1, rows);
          let field_start$1 = (field_start + field_length) + 2;
          loop$string = rest;
          loop$original = original;
          loop$field_start = field_start$1;
          loop$field_length = 0;
          loop$row = toList([]);
          loop$rows = rows$1;
          loop$status = new NewlineFound();
          loop$field_separator = field_separator;
        } else if (remaining.startsWith("\"")) {
          return new Error(new UnescapedQuote(field_start + field_length));
        } else {
          let _block$1;
          if (status instanceof ParsingEscapedField) {
            _block$1 = new ParsingEscapedField();
          } else if (status instanceof ParsingUnescapedField) {
            _block$1 = new ParsingUnescapedField();
          } else if (status instanceof SeparatorFound) {
            _block$1 = new ParsingUnescapedField();
          } else {
            _block$1 = new ParsingUnescapedField();
          }
          let status$1 = _block$1;
          let rest = drop_bytes(string, 1);
          loop$string = rest;
          loop$original = original;
          loop$field_start = field_start;
          loop$field_length = field_length + 1;
          loop$row = row;
          loop$rows = rows;
          loop$status = status$1;
          loop$field_separator = field_separator;
        }
      } else {
        let _block$1;
        if (status instanceof ParsingEscapedField) {
          _block$1 = new ParsingEscapedField();
        } else if (status instanceof ParsingUnescapedField) {
          _block$1 = new ParsingUnescapedField();
        } else if (status instanceof SeparatorFound) {
          _block$1 = new ParsingUnescapedField();
        } else {
          _block$1 = new ParsingUnescapedField();
        }
        let status$1 = _block$1;
        let rest = drop_bytes(string, 1);
        loop$string = rest;
        loop$original = original;
        loop$field_start = field_start;
        loop$field_length = field_length + 1;
        loop$row = row;
        loop$rows = rows;
        loop$status = status$1;
        loop$field_separator = field_separator;
      }
    } else if (status instanceof SeparatorFound) {
      if (sep instanceof Sep) {
        let rest = remaining;
        let field = extract_field(original, field_start, field_length, status);
        let row$1 = listPrepend(field, row);
        let start = (field_start + field_length) + skip;
        loop$string = rest;
        loop$original = original;
        loop$field_start = start;
        loop$field_length = 0;
        loop$row = row$1;
        loop$rows = rows;
        loop$status = new SeparatorFound();
        loop$field_separator = field_separator;
      } else if (sep instanceof NoSep) {
        if (remaining === "") {
          let row$1 = $list.reverse(listPrepend("", row));
          return new Ok($list.reverse(listPrepend(row$1, rows)));
        } else if (remaining.startsWith("\n")) {
          let rest = remaining.slice(1);
          let row$1 = $list.reverse(listPrepend("", row));
          let rows$1 = listPrepend(row$1, rows);
          loop$string = rest;
          loop$original = original;
          loop$field_start = field_start + 1;
          loop$field_length = 0;
          loop$row = toList([]);
          loop$rows = rows$1;
          loop$status = new NewlineFound();
          loop$field_separator = field_separator;
        } else if (remaining.startsWith("\r\n")) {
          let rest = remaining.slice(2);
          let row$1 = $list.reverse(listPrepend("", row));
          let rows$1 = listPrepend(row$1, rows);
          loop$string = rest;
          loop$original = original;
          loop$field_start = field_start + 2;
          loop$field_length = 0;
          loop$row = toList([]);
          loop$rows = rows$1;
          loop$status = new NewlineFound();
          loop$field_separator = field_separator;
        } else if (remaining.startsWith("\"")) {
          let rest = remaining.slice(1);
          loop$string = rest;
          loop$original = original;
          loop$field_start = field_start + 1;
          loop$field_length = 0;
          loop$row = row;
          loop$rows = rows;
          loop$status = new ParsingEscapedField();
          loop$field_separator = field_separator;
        } else {
          let _block$1;
          if (status instanceof ParsingEscapedField) {
            _block$1 = new ParsingEscapedField();
          } else if (status instanceof ParsingUnescapedField) {
            _block$1 = new ParsingUnescapedField();
          } else if (status instanceof SeparatorFound) {
            _block$1 = new ParsingUnescapedField();
          } else {
            _block$1 = new ParsingUnescapedField();
          }
          let status$1 = _block$1;
          let rest = drop_bytes(string, 1);
          loop$string = rest;
          loop$original = original;
          loop$field_start = field_start;
          loop$field_length = field_length + 1;
          loop$row = row;
          loop$rows = rows;
          loop$status = status$1;
          loop$field_separator = field_separator;
        }
      } else {
        let _block$1;
        if (status instanceof ParsingEscapedField) {
          _block$1 = new ParsingEscapedField();
        } else if (status instanceof ParsingUnescapedField) {
          _block$1 = new ParsingUnescapedField();
        } else if (status instanceof SeparatorFound) {
          _block$1 = new ParsingUnescapedField();
        } else {
          _block$1 = new ParsingUnescapedField();
        }
        let status$1 = _block$1;
        let rest = drop_bytes(string, 1);
        loop$string = rest;
        loop$original = original;
        loop$field_start = field_start;
        loop$field_length = field_length + 1;
        loop$row = row;
        loop$rows = rows;
        loop$status = status$1;
        loop$field_separator = field_separator;
      }
    } else if (sep instanceof Sep) {
      let rest = remaining;
      let field = extract_field(original, field_start, field_length, status);
      let row$1 = listPrepend(field, row);
      let start = (field_start + field_length) + skip;
      loop$string = rest;
      loop$original = original;
      loop$field_start = start;
      loop$field_length = 0;
      loop$row = row$1;
      loop$rows = rows;
      loop$status = new SeparatorFound();
      loop$field_separator = field_separator;
    } else if (sep instanceof NoSep) {
      if (remaining === "") {
        return new Ok($list.reverse(rows));
      } else if (remaining.startsWith("\n")) {
        let rest = remaining.slice(1);
        loop$string = rest;
        loop$original = original;
        loop$field_start = field_start + 1;
        loop$field_length = 0;
        loop$row = row;
        loop$rows = rows;
        loop$status = status;
        loop$field_separator = field_separator;
      } else if (remaining.startsWith("\r\n")) {
        let rest = remaining.slice(2);
        loop$string = rest;
        loop$original = original;
        loop$field_start = field_start + 2;
        loop$field_length = 0;
        loop$row = row;
        loop$rows = rows;
        loop$status = status;
        loop$field_separator = field_separator;
      } else if (remaining.startsWith("\"")) {
        let rest = remaining.slice(1);
        loop$string = rest;
        loop$original = original;
        loop$field_start = field_start + 1;
        loop$field_length = 0;
        loop$row = row;
        loop$rows = rows;
        loop$status = new ParsingEscapedField();
        loop$field_separator = field_separator;
      } else {
        let _block$1;
        if (status instanceof ParsingEscapedField) {
          _block$1 = new ParsingEscapedField();
        } else if (status instanceof ParsingUnescapedField) {
          _block$1 = new ParsingUnescapedField();
        } else if (status instanceof SeparatorFound) {
          _block$1 = new ParsingUnescapedField();
        } else {
          _block$1 = new ParsingUnescapedField();
        }
        let status$1 = _block$1;
        let rest = drop_bytes(string, 1);
        loop$string = rest;
        loop$original = original;
        loop$field_start = field_start;
        loop$field_length = field_length + 1;
        loop$row = row;
        loop$rows = rows;
        loop$status = status$1;
        loop$field_separator = field_separator;
      }
    } else {
      let _block$1;
      if (status instanceof ParsingEscapedField) {
        _block$1 = new ParsingEscapedField();
      } else if (status instanceof ParsingUnescapedField) {
        _block$1 = new ParsingUnescapedField();
      } else if (status instanceof SeparatorFound) {
        _block$1 = new ParsingUnescapedField();
      } else {
        _block$1 = new ParsingUnescapedField();
      }
      let status$1 = _block$1;
      let rest = drop_bytes(string, 1);
      loop$string = rest;
      loop$original = original;
      loop$field_start = field_start;
      loop$field_length = field_length + 1;
      loop$row = row;
      loop$rows = rows;
      loop$status = status$1;
      loop$field_separator = field_separator;
    }
  }
}

export function to_lists(loop$input, loop$field_separator) {
  while (true) {
    let input = loop$input;
    let field_separator = loop$field_separator;
    let $ = $string.starts_with(input, field_separator);
    if (input.startsWith("\n")) {
      let rest = input.slice(1);
      loop$input = rest;
      loop$field_separator = field_separator;
    } else if (input.startsWith("\r\n")) {
      let rest = input.slice(2);
      loop$input = rest;
      loop$field_separator = field_separator;
    } else if (input.startsWith("\"")) {
      let rest = input.slice(1);
      return do_parse(
        rest,
        input,
        1,
        0,
        toList([]),
        toList([]),
        new ParsingEscapedField(),
        field_separator,
      );
    } else if ($) {
      let rest = input;
      return do_parse(
        $string.drop_start(rest, $string.length(field_separator)),
        input,
        1,
        0,
        toList([""]),
        toList([]),
        new SeparatorFound(),
        field_separator,
      );
    } else {
      return do_parse(
        input,
        input,
        0,
        0,
        toList([]),
        toList([]),
        new ParsingUnescapedField(),
        field_separator,
      );
    }
  }
}

export function to_dicts(input, field_separator) {
  return $result.map(
    to_lists(input, field_separator),
    (rows) => {
      if (rows instanceof $Empty) {
        return toList([]);
      } else {
        let headers = rows.head;
        let rows$1 = rows.tail;
        let headers$1 = $glearray.from_list(headers);
        return $list.map(
          rows$1,
          (row) => {
            return $list.index_fold(
              row,
              $dict.new$(),
              (row, field, index) => {
                if (field === "") {
                  return row;
                } else {
                  let $ = $glearray.get(headers$1, index);
                  if ($ instanceof Ok) {
                    let header = $[0];
                    return $dict.insert(row, header, field);
                  } else {
                    return row;
                  }
                }
              },
            );
          },
        );
      }
    },
  );
}
