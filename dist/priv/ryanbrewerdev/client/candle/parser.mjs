import * as $int from "../../../gleam_stdlib/gleam/int.mjs";
import * as $list from "../../../gleam_stdlib/gleam/list.mjs";
import * as $string from "../../../gleam_stdlib/gleam/string.mjs";
import * as $header from "../../client/candle/header.mjs";
import {
  AppSyntax,
  CastSyntax,
  DefSyntax,
  EqSyntax,
  ExFalsoSyntax,
  Explicit,
  FstSyntax,
  HoleSyntax,
  IdentSyntax,
  Implicit,
  IntersectionSyntax,
  IntersectionTypeSyntax,
  LambdaSyntax,
  LetSyntax,
  ManyMode,
  NatSyntax,
  NatTypeSyntax,
  PiSyntax,
  Pos,
  PsiSyntax,
  ReflSyntax,
  SetSort,
  SndSyntax,
  SortSyntax,
  SyntaxParam,
  ZeroMode,
} from "../../client/candle/header.mjs";
import {
  Ok,
  Error,
  toList,
  Empty as $Empty,
  prepend as listPrepend,
  CustomType as $CustomType,
  makeError,
} from "../../gleam.mjs";

const FILEPATH = "src/client/candle/parser.gleam";

export class Parser extends $CustomType {
  constructor(run) {
    super();
    this.run = run;
  }
}

export class Bubbler extends $CustomType {
  constructor(msg, pos, expected) {
    super();
    this.msg = msg;
    this.pos = pos;
    this.expected = expected;
  }
}

export class Normal extends $CustomType {
  constructor(msg, pos, expected) {
    super();
    this.msg = msg;
    this.pos = pos;
    this.expected = expected;
  }
}

export class AppSuffix extends $CustomType {
  constructor($0, $1, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this.pos = pos;
  }
}

export class PiSuffix extends $CustomType {
  constructor($0, pos) {
    super();
    this[0] = $0;
    this.pos = pos;
  }
}

export class EqSuffix extends $CustomType {
  constructor($0, pos) {
    super();
    this[0] = $0;
    this.pos = pos;
  }
}

export class InterSuffix extends $CustomType {
  constructor($0, pos) {
    super();
    this[0] = $0;
    this.pos = pos;
  }
}

export class FstSuffix extends $CustomType {
  constructor(pos) {
    super();
    this.pos = pos;
  }
}

export class SndSuffix extends $CustomType {
  constructor(pos) {
    super();
    this.pos = pos;
  }
}

function satisfy(pred) {
  return new Parser(
    (pos, chars) => {
      if (chars instanceof $Empty) {
        return new Error(new Normal("unexpected EOF", pos, ""));
      } else {
        let c = chars.head;
        let rest = chars.tail;
        let $ = pred(c);
        if ($) {
          if (c === "\n") {
            return new Ok([new Pos(pos.src, pos.line + 1, 1), rest, c]);
          } else {
            return new Ok([new Pos(pos.src, pos.line, pos.col + 1), rest, c]);
          }
        } else {
          if (c === "\n") {
            return new Error(new Normal("unexpected newline", pos, ""));
          } else {
            return new Error(new Normal("unexpected " + c, pos, ""));
          }
        }
      }
    },
  );
}

function map(parser, f) {
  return new Parser(
    (pos, chars) => {
      let $ = parser.run(pos, chars);
      if ($ instanceof Ok) {
        let pos2 = $[0][0];
        let rest = $[0][1];
        let a = $[0][2];
        return new Ok([pos2, rest, f(a)]);
      } else {
        let e = $[0];
        return new Error(e);
      }
    },
  );
}

function either(p1, p2) {
  return new Parser(
    (pos, chars) => {
      let $ = p1.run(pos, chars);
      if ($ instanceof Ok) {
        let out = $[0];
        return new Ok(out);
      } else {
        let $1 = $[0];
        if ($1 instanceof Bubbler) {
          let e = $;
          return e;
        } else {
          return p2.run(pos, chars);
        }
      }
    },
  );
}

function many0(parser) {
  return new Parser(
    (pos, chars) => {
      let $ = parser.run(pos, chars);
      if ($ instanceof Ok) {
        let pos2 = $[0][0];
        let rest = $[0][1];
        let a = $[0][2];
        let $1 = many0(parser).run(pos2, rest);
        if ($1 instanceof Ok) {
          let pos3 = $1[0][0];
          let rest2 = $1[0][1];
          let others = $1[0][2];
          return new Ok([pos3, rest2, listPrepend(a, others)]);
        } else {
          let $2 = $1[0];
          if ($2 instanceof Bubbler) {
            let e = $1;
            return e;
          } else {
            throw makeError(
              "panic",
              FILEPATH,
              "client/candle/parser",
              85,
              "many0",
              "many0 returned normal failure",
              {}
            )
          }
        }
      } else {
        let $1 = $[0];
        if ($1 instanceof Bubbler) {
          let e = $1;
          return new Error(e);
        } else {
          return new Ok([pos, chars, toList([])]);
        }
      }
    },
  );
}

function do$(p1, f) {
  return new Parser(
    (pos, chars) => {
      let $ = p1.run(pos, chars);
      if ($ instanceof Ok) {
        let pos2 = $[0][0];
        let rest = $[0][1];
        let a = $[0][2];
        return f(a).run(pos2, rest);
      } else {
        let e = $[0];
        return new Error(e);
      }
    },
  );
}

function return$(a) {
  return new Parser((pos, chars) => { return new Ok([pos, chars, a]); });
}

function many(parser) {
  return do$(
    parser,
    (first) => {
      return do$(
        many0(parser),
        (rest) => { return return$(listPrepend(first, rest)); },
      );
    },
  );
}

function label(parser, expected) {
  return new Parser(
    (pos, chars) => {
      let $ = parser.run(pos, chars);
      if ($ instanceof Ok) {
        let out = $[0];
        return new Ok(out);
      } else {
        let $1 = $[0];
        if ($1 instanceof Normal) {
          let msg = $1.msg;
          let p = $1.pos;
          return new Error(new Normal(msg, p, expected));
        } else {
          let e = $;
          return e;
        }
      }
    },
  );
}

function commit(k) {
  return new Parser(
    (pos, chars) => {
      let $ = k().run(pos, chars);
      if ($ instanceof Ok) {
        let out = $[0];
        return new Ok(out);
      } else {
        let $1 = $[0];
        if ($1 instanceof Bubbler) {
          let msg = $1.msg;
          let p = $1.pos;
          let e = $1.expected;
          return new Error(new Bubbler(msg, p, e));
        } else {
          let msg = $1.msg;
          let p = $1.pos;
          let e = $1.expected;
          return new Error(new Bubbler(msg, p, e));
        }
      }
    },
  );
}

function maybe_commit(cond, k) {
  if (cond) {
    return commit(k);
  } else {
    return k();
  }
}

function char(c) {
  let _pipe = satisfy((c2) => { return c === c2; });
  return label(_pipe, c);
}

function get_pos() {
  return new Parser((pos, chars) => { return new Ok([pos, chars, pos]); });
}

function lazy(thunk) {
  return new Parser((pos, chars) => { return thunk().run(pos, chars); });
}

function any_of(parsers) {
  if (parsers instanceof $Empty) {
    throw makeError(
      "panic",
      FILEPATH,
      "client/candle/parser",
      174,
      "any_of",
      "any_of on empty parser list",
      {}
    )
  } else {
    let $ = parsers.tail;
    if ($ instanceof $Empty) {
      let p = parsers.head;
      return p;
    } else {
      let p = parsers.head;
      let rest = $;
      return either(p, any_of(rest));
    }
  }
}

function maybe(parser) {
  return new Parser(
    (pos, chars) => {
      let $ = parser.run(pos, chars);
      if ($ instanceof Ok) {
        let pos2 = $[0][0];
        let rest = $[0][1];
        let a = $[0][2];
        return new Ok([pos2, rest, new Ok(a)]);
      } else {
        let $1 = $[0];
        if ($1 instanceof Bubbler) {
          let e = $1;
          return new Error(e);
        } else {
          return new Ok([pos, chars, new Error(undefined)]);
        }
      }
    },
  );
}

function build_pi(pos, params, rett) {
  if (params instanceof $Empty) {
    return rett;
  } else {
    let param = params.head;
    let rest = params.tail;
    return new PiSyntax(
      param.mode,
      param.implicit,
      param.name,
      param.ty,
      build_pi(pos, rest, rett),
      pos,
    );
  }
}

function build_lambda(pos, params, body) {
  if (params instanceof $Empty) {
    return body;
  } else {
    let param = params.head;
    let rest = params.tail;
    return new LambdaSyntax(
      param.mode,
      param.implicit,
      param.name,
      new Ok(param.ty),
      build_lambda(pos, rest, body),
      pos,
    );
  }
}

export function expr() {
  return ws(
    () => {
      return do$(
        label(
          any_of(
            toList([
              nat_type(),
              type_type(),
              nat(),
              annotated_binder(),
              parens(),
              erased_binder(),
              let_binding(),
              refl(),
              psi(),
              intersection(),
              cast(),
              exfalso(),
              ident(),
              relevant_but_ignored(),
              hole(),
            ]),
          ),
          "expression",
        ),
        (e) => {
          return ws(
            () => {
              return do$(
                many0(
                  ws(
                    () => {
                      return any_of(
                        toList([
                          do$(
                            get_pos(),
                            (pos) => {
                              return do$(
                                char("("),
                                (_) => {
                                  return commit(
                                    () => {
                                      return do$(
                                        lazy(expr),
                                        (arg) => {
                                          return do$(
                                            char(")"),
                                            (_) => {
                                              return return$(
                                                new AppSuffix(
                                                  new ManyMode(),
                                                  arg,
                                                  pos,
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
                          ),
                          do$(
                            get_pos(),
                            (pos) => {
                              return do$(
                                char("<"),
                                (_) => {
                                  return commit(
                                    () => {
                                      return do$(
                                        lazy(expr),
                                        (arg) => {
                                          return do$(
                                            char(">"),
                                            (_) => {
                                              return return$(
                                                new AppSuffix(
                                                  new ZeroMode(),
                                                  arg,
                                                  pos,
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
                          ),
                          do$(
                            get_pos(),
                            (pos) => {
                              return do$(
                                string("=>"),
                                (_) => {
                                  return commit(
                                    () => {
                                      return do$(
                                        lazy(expr),
                                        (rett) => {
                                          return return$(
                                            new PiSuffix(rett, pos),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          do$(
                            get_pos(),
                            (pos) => {
                              return do$(
                                char("="),
                                (_) => {
                                  return commit(
                                    () => {
                                      return do$(
                                        lazy(expr),
                                        (b) => {
                                          return return$(new EqSuffix(b, pos));
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          do$(
                            get_pos(),
                            (pos) => {
                              return do$(
                                char("&"),
                                (_) => {
                                  return commit(
                                    () => {
                                      return do$(
                                        lazy(expr),
                                        (b) => {
                                          return return$(
                                            new InterSuffix(b, pos),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          do$(
                            get_pos(),
                            (pos) => {
                              return do$(
                                char("."),
                                (_) => {
                                  return commit(
                                    () => {
                                      return do$(
                                        either(char("1"), char("2")),
                                        (proj) => {
                                          if (proj === "1") {
                                            return return$(new FstSuffix(pos));
                                          } else if (proj === "2") {
                                            return return$(new SndSuffix(pos));
                                          } else {
                                            throw makeError(
                                              "panic",
                                              FILEPATH,
                                              "client/candle/parser",
                                              614,
                                              "expr",
                                              "impossible projection",
                                              {}
                                            )
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ]),
                      );
                    },
                  ),
                ),
                (suffices) => {
                  let _block;
                  if (suffices instanceof $Empty) {
                    _block = e;
                  } else {
                    _block = $list.fold(
                      suffices,
                      e,
                      (ex, suffix) => {
                        if (suffix instanceof AppSuffix) {
                          let mode = suffix[0];
                          let arg = suffix[1];
                          let pos = suffix.pos;
                          return new AppSyntax(mode, ex, arg, pos);
                        } else if (suffix instanceof PiSuffix) {
                          let rett = suffix[0];
                          let pos = suffix.pos;
                          return new PiSyntax(
                            new ManyMode(),
                            new Explicit(),
                            "_",
                            ex,
                            rett,
                            pos,
                          );
                        } else if (suffix instanceof EqSuffix) {
                          let b = suffix[0];
                          let pos = suffix.pos;
                          return new EqSyntax(ex, b, pos);
                        } else if (suffix instanceof InterSuffix) {
                          let b = suffix[0];
                          let pos = suffix.pos;
                          return new IntersectionTypeSyntax("_", ex, b, pos);
                        } else if (suffix instanceof FstSuffix) {
                          let pos = suffix.pos;
                          return new FstSyntax(ex, pos);
                        } else {
                          let pos = suffix.pos;
                          return new SndSyntax(ex, pos);
                        }
                      },
                    );
                  }
                  let e$1 = _block;
                  return ws(() => { return return$(e$1); });
                },
              );
            },
          );
        },
      );
    },
  );
}

function annotated_binder() {
  return do$(
    get_pos(),
    (pos) => {
      return do$(
        parse_param(false),
        (param) => {
          return commit(
            () => {
              return ws(
                () => {
                  let _block;
                  let $ = param.mode;
                  if ($ instanceof ZeroMode) {
                    _block = toList([string("->"), string("=>")]);
                  } else if ($ instanceof ManyMode) {
                    _block = toList([string("->"), string("=>"), string("&")]);
                  } else {
                    throw makeError(
                      "panic",
                      FILEPATH,
                      "client/candle/parser",
                      310,
                      "annotated_binder",
                      "impossible binder mode",
                      {}
                    )
                  }
                  let arrows = _block;
                  return do$(
                    (() => {
                      let _pipe = any_of(arrows);
                      return label(_pipe, "binding arrow");
                    })(),
                    (res) => {
                      return do$(
                        lazy(expr),
                        (e) => {
                          if (res === "->") {
                            return return$(
                              new LambdaSyntax(
                                param.mode,
                                param.implicit,
                                param.name,
                                new Ok(param.ty),
                                e,
                                pos,
                              ),
                            );
                          } else if (res === "=>") {
                            return return$(
                              new PiSyntax(
                                param.mode,
                                param.implicit,
                                param.name,
                                param.ty,
                                e,
                                pos,
                              ),
                            );
                          } else if (res === "&") {
                            return return$(
                              new IntersectionTypeSyntax(
                                param.name,
                                param.ty,
                                e,
                                pos,
                              ),
                            );
                          } else {
                            throw makeError(
                              "panic",
                              FILEPATH,
                              "client/candle/parser",
                              327,
                              "annotated_binder",
                              "impossible annotated binder",
                              {}
                            )
                          }
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

function intersection() {
  return do$(
    get_pos(),
    (pos) => {
      return do$(
        char("["),
        (_) => {
          return commit(
            () => {
              return do$(
                lazy(expr),
                (a) => {
                  return do$(
                    char(","),
                    (_) => {
                      return do$(
                        lazy(expr),
                        (b) => {
                          return do$(
                            char("]"),
                            (_) => {
                              return return$(new IntersectionSyntax(a, b, pos));
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

function string_helper(s) {
  let $ = $string.pop_grapheme(s);
  if ($ instanceof Ok) {
    let $1 = $[0][1];
    if ($1 === "") {
      let c = $[0][0];
      return char(c);
    } else {
      let c = $[0][0];
      let rest = $1;
      return do$(char(c), (_) => { return string(rest); });
    }
  } else {
    throw makeError(
      "panic",
      FILEPATH,
      "client/candle/parser",
      189,
      "string_helper",
      "empty string",
      {}
    )
  }
}

function string(s) {
  let _pipe = map(string_helper(s), (_) => { return s; });
  return label(_pipe, s);
}

export function parse(src, parser) {
  let $ = parser.run(new Pos("", 1, 1), $string.to_graphemes(src));
  if ($ instanceof Ok) {
    let a = $[0][2];
    return new Ok(a);
  } else {
    let err = $[0];
    let $1 = err.expected;
    if ($1 === "") {
      return new Error((err.msg + " at ") + $header.pretty_pos(err.pos));
    } else {
      return new Error(
        (((err.msg + " at ") + $header.pretty_pos(err.pos)) + ", expected ") + err.expected,
      );
    }
  }
}

function lowercase() {
  return satisfy(
    (c) => { return $string.contains("abcdefghijklmnopqrstuvwxyz", c); },
  );
}

function uppercase() {
  return satisfy(
    (c) => { return $string.contains("ABCDEFGHIJKLMNOPQRSTUVWXYZ", c); },
  );
}

function digit() {
  return satisfy((c) => { return $string.contains("1234567890", c); });
}

function alphanum() {
  return either(lowercase(), either(uppercase(), digit()));
}

function keyword(s) {
  return do$(
    string(s),
    (_) => {
      return new Parser(
        (pos, chars) => {
          let $ = any_of(toList([lowercase(), uppercase(), digit()])).run(
            pos,
            chars,
          );
          if ($ instanceof Ok) {
            let c = $[0][2];
            return new Error(new Normal("unexpected " + c, pos, s));
          } else {
            return new Ok([pos, chars, s]);
          }
        },
      );
    },
  );
}

function ws(k) {
  return do$(
    many0(
      any_of(
        toList([
          char(" "),
          char("\n"),
          char("\t"),
          do$(
            string("//"),
            (_) => {
              return do$(
                many0(satisfy((c) => { return c !== "\n"; })),
                (_) => { return char("\n"); },
              );
            },
          ),
        ]),
      ),
    ),
    (_) => { return k(); },
  );
}

function ident_string() {
  return do$(
    either(uppercase(), lowercase()),
    (fst) => {
      return do$(
        (() => {
          let _pipe = many0(either(char("_"), alphanum()));
          return map(_pipe, $string.concat);
        })(),
        (rest) => { return return$(fst + rest); },
      );
    },
  );
}

function pattern_string() {
  let _pipe = either(
    ident_string(),
    do$(
      char("_"),
      (_) => {
        return do$(
          (() => {
            let _pipe = many0(either(char("_"), alphanum()));
            return map(_pipe, $string.concat);
          })(),
          (s) => { return return$("_" + s); },
        );
      },
    ),
  );
  return label(_pipe, "identifier");
}

function ident() {
  return do$(
    get_pos(),
    (pos) => {
      return do$(
        ident_string(),
        (s) => {
          return ws(
            () => {
              return do$(
                maybe(string("->")),
                (mb_lam) => {
                  if (mb_lam instanceof Ok) {
                    return commit(
                      () => {
                        return do$(
                          lazy(expr),
                          (body) => {
                            return return$(
                              new LambdaSyntax(
                                new ManyMode(),
                                new Explicit(),
                                s,
                                new Error(undefined),
                                body,
                                pos,
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return return$(new IdentSyntax(s, pos));
                  }
                },
              );
            },
          );
        },
      );
    },
  );
}

function hole() {
  return do$(
    get_pos(),
    (pos) => {
      return do$(keyword("?"), (_) => { return return$(new HoleSyntax(pos)); });
    },
  );
}

function nat() {
  return do$(
    get_pos(),
    (pos) => {
      return do$(
        many(digit()),
        (n_str) => {
          let $ = $int.parse($string.concat(n_str));
          if (!($ instanceof Ok)) {
            throw makeError(
              "let_assert",
              FILEPATH,
              "client/candle/parser",
              276,
              "nat",
              "Pattern match failed, no pattern matched the value.",
              {
                value: $,
                start: 6839,
                end: 6889,
                pattern_start: 6850,
                pattern_end: 6855
              }
            )
          }
          let n = $[0];
          return return$(new NatSyntax(n, pos));
        },
      );
    },
  );
}

function nat_type() {
  return do$(
    get_pos(),
    (pos) => {
      return do$(
        keyword("Nat"),
        (_) => { return return$(new NatTypeSyntax(pos)); },
      );
    },
  );
}

function type_type() {
  return do$(
    get_pos(),
    (pos) => {
      return do$(
        keyword("Set"),
        (_) => { return return$(new SortSyntax(new SetSort(), pos)); },
      );
    },
  );
}

function relevant_but_ignored() {
  return do$(
    get_pos(),
    (pos) => {
      return do$(
        pattern_string(),
        (x) => {
          return commit(
            () => {
              return ws(
                () => {
                  return do$(
                    string("->"),
                    (_) => {
                      return do$(
                        lazy(expr),
                        (e) => {
                          return return$(
                            new LambdaSyntax(
                              new ManyMode(),
                              new Explicit(),
                              x,
                              new Error(undefined),
                              e,
                              pos,
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
}

function erased_binder() {
  return do$(
    get_pos(),
    (pos) => {
      return do$(
        char("<"),
        (_) => {
          return commit(
            () => {
              return do$(
                (() => {
                  let _pipe = lazy(expr);
                  return label(_pipe, "expression or binding");
                })(),
                (e) => {
                  return do$(
                    (() => {
                      let _pipe = char(">");
                      return label(
                        _pipe,
                        (() => {
                          if (e instanceof IdentSyntax) {
                            return ": or >";
                          } else {
                            return ">";
                          }
                        })(),
                      );
                    })(),
                    (_) => {
                      return ws(
                        () => {
                          if (e instanceof IdentSyntax) {
                            let x = e[0];
                            return do$(
                              either(string("->"), string("=>")),
                              (res) => {
                                return do$(
                                  lazy(expr),
                                  (body) => {
                                    if (res === "->") {
                                      return return$(
                                        new LambdaSyntax(
                                          new ZeroMode(),
                                          new Explicit(),
                                          x,
                                          new Error(undefined),
                                          body,
                                          pos,
                                        ),
                                      );
                                    } else if (res === "=>") {
                                      return return$(
                                        new PiSyntax(
                                          new ZeroMode(),
                                          new Explicit(),
                                          "_",
                                          e,
                                          body,
                                          pos,
                                        ),
                                      );
                                    } else {
                                      throw makeError(
                                        "panic",
                                        FILEPATH,
                                        "client/candle/parser",
                                        352,
                                        "erased_binder",
                                        "impossible erased binder",
                                        {}
                                      )
                                    }
                                  },
                                );
                              },
                            );
                          } else {
                            return do$(
                              string("=>"),
                              (_) => {
                                return do$(
                                  lazy(expr),
                                  (body) => {
                                    return return$(
                                      new PiSyntax(
                                        new ZeroMode(),
                                        new Explicit(),
                                        "_",
                                        e,
                                        body,
                                        pos,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }
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

function parens() {
  return do$(
    get_pos(),
    (pos) => {
      return do$(
        char("("),
        (_) => {
          return commit(
            () => {
              return do$(
                (() => {
                  let _pipe = lazy(expr);
                  return label(_pipe, "expression or binding");
                })(),
                (e) => {
                  return do$(
                    (() => {
                      let _pipe = char(")");
                      return label(
                        _pipe,
                        (() => {
                          if (e instanceof IdentSyntax) {
                            return ": or )";
                          } else {
                            return ")";
                          }
                        })(),
                      );
                    })(),
                    (_) => {
                      if (e instanceof IdentSyntax) {
                        let x = e[0];
                        return ws(
                          () => {
                            return do$(
                              maybe(string("->")),
                              (res) => {
                                if (res instanceof Ok) {
                                  return do$(
                                    lazy(expr),
                                    (body) => {
                                      return return$(
                                        new LambdaSyntax(
                                          new ManyMode(),
                                          new Explicit(),
                                          x,
                                          new Error(undefined),
                                          body,
                                          pos,
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return return$(e);
                                }
                              },
                            );
                          },
                        );
                      } else {
                        return return$(e);
                      }
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

function parse_param(idk) {
  return ws(
    () => {
      return do$(
        any_of(toList([char("("), char("<")])),
        (res) => {
          return ws(
            () => {
              return do$(
                maybe(char("?")),
                (res2) => {
                  let _block;
                  if (res2 instanceof Ok) {
                    _block = new Implicit();
                  } else {
                    _block = new Explicit();
                  }
                  let imp = _block;
                  return ws(
                    () => {
                      return maybe_commit(
                        idk,
                        () => {
                          return do$(
                            pattern_string(),
                            (x) => {
                              return ws(
                                () => {
                                  return do$(
                                    char(":"),
                                    (_) => {
                                      return do$(
                                        lazy(expr),
                                        (t) => {
                                          if (res === "(") {
                                            return do$(
                                              char(")"),
                                              (_) => {
                                                return return$(
                                                  new SyntaxParam(
                                                    new ManyMode(),
                                                    imp,
                                                    x,
                                                    t,
                                                  ),
                                                );
                                              },
                                            );
                                          } else if (res === "<") {
                                            return do$(
                                              char(">"),
                                              (_) => {
                                                return return$(
                                                  new SyntaxParam(
                                                    new ZeroMode(),
                                                    imp,
                                                    x,
                                                    t,
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            throw makeError(
                                              "panic",
                                              FILEPATH,
                                              "client/candle/parser",
                                              415,
                                              "parse_param",
                                              "impossible param mode",
                                              {}
                                            )
                                          }
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

function let_binding() {
  return do$(
    get_pos(),
    (pos) => {
      return do$(
        either(keyword("let"), keyword("def")),
        (res) => {
          return ws(
            () => {
              return commit(
                () => {
                  return do$(
                    pattern_string(),
                    (x) => {
                      return ws(
                        () => {
                          return do$(
                            many0(parse_param(true)),
                            (params) => {
                              return ws(
                                () => {
                                  return do$(
                                    (() => {
                                      let _pipe = char(":");
                                      return label(_pipe, ": or parameter");
                                    })(),
                                    (_) => {
                                      return do$(
                                        lazy(expr),
                                        (t) => {
                                          return do$(
                                            string(":="),
                                            (_) => {
                                              return do$(
                                                lazy(expr),
                                                (v) => {
                                                  return do$(
                                                    keyword("in"),
                                                    (_) => {
                                                      return do$(
                                                        lazy(expr),
                                                        (e) => {
                                                          let t$1 = build_pi(
                                                            pos,
                                                            params,
                                                            t,
                                                          );
                                                          let v$1 = build_lambda(
                                                            pos,
                                                            params,
                                                            v,
                                                          );
                                                          if (res === "let") {
                                                            return return$(
                                                              new LetSyntax(
                                                                x,
                                                                t$1,
                                                                v$1,
                                                                e,
                                                                pos,
                                                              ),
                                                            );
                                                          } else if (res === "def") {
                                                            return return$(
                                                              new DefSyntax(
                                                                x,
                                                                t$1,
                                                                v$1,
                                                                e,
                                                                pos,
                                                              ),
                                                            );
                                                          } else {
                                                            throw makeError(
                                                              "panic",
                                                              FILEPATH,
                                                              "client/candle/parser",
                                                              470,
                                                              "let_binding",
                                                              "impossible binder",
                                                              {}
                                                            )
                                                          }
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

function refl() {
  return do$(
    get_pos(),
    (pos) => {
      return do$(
        keyword("refl"),
        (_) => {
          return ws(
            () => {
              return do$(
                char("("),
                (_) => {
                  return do$(
                    lazy(expr),
                    (a) => {
                      return do$(
                        char(")"),
                        (_) => { return return$(new ReflSyntax(a, pos)); },
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

function psi() {
  return do$(
    get_pos(),
    (pos) => {
      return do$(
        keyword("Psi"),
        (_) => {
          return ws(
            () => {
              return do$(
                char("("),
                (_) => {
                  return do$(
                    lazy(expr),
                    (eq) => {
                      return do$(
                        char(","),
                        (_) => {
                          return do$(
                            lazy(expr),
                            (p) => {
                              return do$(
                                char(")"),
                                (_) => {
                                  return return$(new PsiSyntax(eq, p, pos));
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

function cast() {
  return do$(
    get_pos(),
    (pos) => {
      return do$(
        keyword("cast"),
        (_) => {
          return commit(
            () => {
              return ws(
                () => {
                  return do$(
                    char("("),
                    (_) => {
                      return do$(
                        lazy(expr),
                        (a) => {
                          return do$(
                            char(","),
                            (_) => {
                              return do$(
                                lazy(expr),
                                (inter) => {
                                  return do$(
                                    char(","),
                                    (_) => {
                                      return do$(
                                        lazy(expr),
                                        (eq) => {
                                          return do$(
                                            char(")"),
                                            (_) => {
                                              return return$(
                                                new CastSyntax(
                                                  a,
                                                  inter,
                                                  eq,
                                                  pos,
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
}

function exfalso() {
  return do$(
    get_pos(),
    (pos) => {
      return do$(
        keyword("exfalso"),
        (_) => {
          return commit(
            () => {
              return ws(
                () => {
                  return do$(
                    char("("),
                    (_) => {
                      return do$(
                        lazy(expr),
                        (a) => {
                          return do$(
                            char(")"),
                            (_) => { return return$(new ExFalsoSyntax(a, pos)); },
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
