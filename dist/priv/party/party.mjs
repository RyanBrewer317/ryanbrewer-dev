import * as $result from "../gleam_stdlib/gleam/result.mjs";
import * as $string from "../gleam_stdlib/gleam/string.mjs";
import {
  Ok,
  Error,
  toList,
  prepend as listPrepend,
  CustomType as $CustomType,
  makeError,
} from "./gleam.mjs";

export class Unexpected extends $CustomType {
  constructor(pos, error) {
    super();
    this.pos = pos;
    this.error = error;
  }
}

export class UserError extends $CustomType {
  constructor(pos, error) {
    super();
    this.pos = pos;
    this.error = error;
  }
}

export class Position extends $CustomType {
  constructor(row, col) {
    super();
    this.row = row;
    this.col = col;
  }
}

class Parser extends $CustomType {
  constructor(parse) {
    super();
    this.parse = parse;
  }
}

export function run(p, src, pos) {
  {
    let f = p.parse;
    return f(src, pos);
  }
}

export function pos() {
  return new Parser((source, p) => { return new Ok([p, source, p]); });
}

export function satisfy(pred) {
  return new Parser(
    (source, pos) => {
      let row = pos.row;
      let col = pos.col;
      if (source.atLeastLength(1)) {
        let h = source.head;
        let t = source.tail;
        let $ = pred(h);
        if ($) {
          if (h === "\n") {
            return new Ok([h, t, new Position(row + 1, 0)]);
          } else {
            return new Ok([h, t, new Position(row, col + 1)]);
          }
        } else {
          return new Error(new Unexpected(pos, h));
        }
      } else {
        return new Error(new Unexpected(pos, "EOF"));
      }
    },
  );
}

export function any_char() {
  return satisfy((_) => { return true; });
}

export function char(c) {
  return satisfy((c2) => { return c === c2; });
}

export function either(p, q) {
  return new Parser(
    (source, pos) => {
      return $result.or(run(p, source, pos), run(q, source, pos));
    },
  );
}

export function choice(ps) {
  return new Parser(
    (source, pos) => {
      if (ps.hasLength(0)) {
        throw makeError(
          "panic",
          "party",
          149,
          "",
          "choice doesn't accept an empty list of parsers",
          {}
        )
      } else if (ps.hasLength(1)) {
        let p = ps.head;
        return run(p, source, pos);
      } else {
        let p = ps.head;
        let t = ps.tail;
        let $ = run(p, source, pos);
        if ($.isOk()) {
          let x = $[0][0];
          let r = $[0][1];
          let pos2 = $[0][2];
          return new Ok([x, r, pos2]);
        } else {
          return run(choice(t), source, pos);
        }
      }
    },
  );
}

export function many(p) {
  return new Parser(
    (source, pos) => {
      let $ = run(p, source, pos);
      if (!$.isOk()) {
        return new Ok([toList([]), source, pos]);
      } else {
        let x = $[0][0];
        let r = $[0][1];
        let pos2 = $[0][2];
        return $result.map(
          run(many(p), r, pos2),
          (res) => { return [listPrepend(x, res[0]), res[1], res[2]]; },
        );
      }
    },
  );
}

export function many1(p) {
  return new Parser(
    (source, pos) => {
      let $ = run(p, source, pos);
      if (!$.isOk()) {
        let e = $[0];
        return new Error(e);
      } else {
        let x = $[0][0];
        let r = $[0][1];
        let pos2 = $[0][2];
        return $result.map(
          run(many(p), r, pos2),
          (res) => { return [listPrepend(x, res[0]), res[1], res[2]]; },
        );
      }
    },
  );
}

export function map(p, f) {
  return new Parser(
    (source, pos) => {
      let $ = run(p, source, pos);
      if ($.isOk()) {
        let x = $[0][0];
        let r = $[0][1];
        let pos2 = $[0][2];
        return new Ok([f(x), r, pos2]);
      } else {
        let e = $[0];
        return new Error(e);
      }
    },
  );
}

export function try$(p, f) {
  return new Parser(
    (source, pos) => {
      let $ = run(p, source, pos);
      if ($.isOk()) {
        let x = $[0][0];
        let r = $[0][1];
        let pos2 = $[0][2];
        let $1 = f(x);
        if ($1.isOk()) {
          let a = $1[0];
          return new Ok([a, r, pos2]);
        } else {
          let e = $1[0];
          return new Error(new UserError(pos, e));
        }
      } else {
        let e = $[0];
        return new Error(e);
      }
    },
  );
}

export function error_map(p, f) {
  return new Parser(
    (source, pos) => {
      let $ = run(p, source, pos);
      if ($.isOk()) {
        let res = $[0];
        return new Ok(res);
      } else {
        let e = $[0];
        if (e instanceof UserError) {
          let pos$1 = e.pos;
          let e$1 = e.error;
          return new Error(new UserError(pos$1, f(e$1)));
        } else {
          let pos$1 = e.pos;
          let s = e.error;
          return new Error(new Unexpected(pos$1, s));
        }
      }
    },
  );
}

export function perhaps(p) {
  return new Parser(
    (source, pos) => {
      let $ = run(p, source, pos);
      if ($.isOk()) {
        let x = $[0][0];
        let r = $[0][1];
        let pos2 = $[0][2];
        return new Ok([new Ok(x), r, pos2]);
      } else {
        return new Ok([new Error(undefined), source, pos]);
      }
    },
  );
}

export function not(p) {
  return new Parser(
    (source, pos) => {
      let $ = run(p, source, pos);
      if ($.isOk()) {
        if (source.atLeastLength(1)) {
          let h = source.head;
          return new Error(new Unexpected(pos, h));
        } else {
          return new Error(new Unexpected(pos, "EOF"));
        }
      } else {
        return new Ok([undefined, source, pos]);
      }
    },
  );
}

export function end() {
  return new Parser(
    (source, pos) => {
      if (source.hasLength(0)) {
        return new Ok([undefined, source, pos]);
      } else {
        let h = source.head;
        return new Error(new Unexpected(pos, h));
      }
    },
  );
}

export function lazy(p) {
  return new Parser((source, pos) => { return run(p(), source, pos); });
}

export function do$(p, f) {
  return new Parser(
    (source, pos) => {
      let $ = run(p, source, pos);
      if ($.isOk()) {
        let x = $[0][0];
        let r = $[0][1];
        let pos2 = $[0][2];
        return run(f(x), r, pos2);
      } else {
        let e = $[0];
        return new Error(e);
      }
    },
  );
}

export function seq(p, q) {
  return do$(p, (_) => { return q; });
}

export function all(ps) {
  if (ps.hasLength(1)) {
    let p = ps.head;
    return p;
  } else if (ps.atLeastLength(1)) {
    let h = ps.head;
    let t = ps.tail;
    return do$(h, (_) => { return all(t); });
  } else {
    throw makeError(
      "panic",
      "party",
      300,
      "all",
      "all(parsers) doesn't accept an empty list of parsers",
      {}
    )
  }
}

export function return$(x) {
  return new Parser((source, pos) => { return new Ok([x, source, pos]); });
}

export function between(open, p, close) {
  return do$(
    open,
    (_) => {
      return do$(
        p,
        (x) => { return do$(close, (_) => { return return$(x); }); },
      );
    },
  );
}

export function sep1(parser, s) {
  return do$(
    parser,
    (first) => {
      return do$(
        many(seq(s, parser)),
        (rest) => { return return$(listPrepend(first, rest)); },
      );
    },
  );
}

export function sep(parser, s) {
  return do$(
    perhaps(sep1(parser, s)),
    (res) => {
      if (res.isOk()) {
        let sequence = res[0];
        return return$(sequence);
      } else {
        return return$(toList([]));
      }
    },
  );
}

export function string(s) {
  let $ = $string.pop_grapheme(s);
  if ($.isOk()) {
    let h = $[0][0];
    let t = $[0][1];
    return do$(
      char(h),
      (c) => { return do$(string(t), (rest) => { return return$(c + rest); }); },
    );
  } else {
    return return$("");
  }
}

export function go(p, src) {
  let $ = run(p, $string.to_graphemes(src), new Position(1, 1));
  if ($.isOk()) {
    let x = $[0][0];
    return new Ok(x);
  } else {
    let e = $[0];
    return new Error(e);
  }
}

export function lowercase_letter() {
  return satisfy(
    (c) => { return $string.contains("abcdefghijklmnopqrstuvwxyz", c); },
  );
}

export function uppercase_letter() {
  return satisfy(
    (c) => { return $string.contains("ABCDEFGHIJKLMNOPQRSTUVWXYZ", c); },
  );
}

export function letter() {
  return either(lowercase_letter(), uppercase_letter());
}

export function digit() {
  return satisfy((c) => { return $string.contains("0123456789", c); });
}

export function alphanum() {
  return either(digit(), letter());
}

export function many_concat(p) {
  let _pipe = many(p);
  return map(_pipe, $string.concat);
}

export function whitespace() {
  return many_concat(choice(toList([char(" "), char("\t"), char("\n")])));
}

export function many1_concat(p) {
  let _pipe = many1(p);
  return map(_pipe, $string.concat);
}

export function digits() {
  return many1_concat(digit());
}

export function whitespace1() {
  return many1_concat(choice(toList([char(" "), char("\t"), char("\n")])));
}

export function fail() {
  return new Parser(
    (source, pos) => {
      if (source.hasLength(0)) {
        return new Error(new Unexpected(pos, "EOF"));
      } else {
        let h = source.head;
        return new Error(new Unexpected(pos, h));
      }
    },
  );
}

export function until(p, terminator) {
  return either(
    do$(terminator, (_) => { return return$(toList([])); }),
    do$(
      p,
      (first) => {
        return do$(
          until(p, terminator),
          (rest) => { return return$(listPrepend(first, rest)); },
        );
      },
    ),
  );
}

export function line() {
  return until(any_char(), char("\n"));
}

export function line_concat() {
  let _pipe = line();
  return map(_pipe, $string.concat);
}

export function stateful_many(state, p) {
  return new Parser(
    (source, pos) => {
      let $ = run(p, source, pos);
      if (!$.isOk()) {
        return new Ok([[toList([]), state], source, pos]);
      } else {
        let f = $[0][0];
        let r = $[0][1];
        let pos2 = $[0][2];
        let $1 = f(state);
        let x = $1[0];
        let s = $1[1];
        return $result.map(
          run(stateful_many(s, p), r, pos2),
          (res) => {
            let rest = res[0][0];
            let s2 = res[0][1];
            let r2 = res[1];
            let pos3 = res[2];
            return [[listPrepend(x, rest), s2], r2, pos3];
          },
        );
      }
    },
  );
}

export function stateful_many1(state, p) {
  return new Parser(
    (source, pos) => {
      let $ = run(p, source, pos);
      if (!$.isOk()) {
        let e = $[0];
        return new Error(e);
      } else {
        let f = $[0][0];
        let r = $[0][1];
        let pos2 = $[0][2];
        let $1 = f(state);
        let x = $1[0];
        let s = $1[1];
        return $result.map(
          run(stateful_many(s, p), r, pos2),
          (res) => {
            let rest = res[0][0];
            let s$1 = res[0][1];
            let r2 = res[1];
            let pos3 = res[2];
            return [[listPrepend(x, rest), s$1], r2, pos3];
          },
        );
      }
    },
  );
}
