import * as $birl from "../../birl/birl.mjs";
import * as $dict from "../../gleam_stdlib/gleam/dict.mjs";
import * as $int from "../../gleam_stdlib/gleam/int.mjs";
import * as $io from "../../gleam_stdlib/gleam/io.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import { None, Some } from "../../gleam_stdlib/gleam/option.mjs";
import * as $result from "../../gleam_stdlib/gleam/result.mjs";
import * as $string from "../../gleam_stdlib/gleam/string.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $party from "../../party/party.mjs";
import * as $snag from "../../snag/snag.mjs";
import * as $arctic from "../arctic.mjs";
import * as $page from "../arctic/page.mjs";
import {
  Ok,
  Error,
  toList,
  prepend as listPrepend,
  CustomType as $CustomType,
  makeError,
} from "../gleam.mjs";

class ParsedPage extends $CustomType {
  constructor(metadata, body) {
    super();
    this.metadata = metadata;
    this.body = body;
  }
}

class ParseResult extends $CustomType {
  constructor(val, errors) {
    super();
    this.val = val;
    this.errors = errors;
  }
}

class ParseError extends $CustomType {
  constructor(pos, unexpected) {
    super();
    this.pos = pos;
    this.unexpected = unexpected;
  }
}

class ArcticParser extends $CustomType {
  constructor(parse) {
    super();
    this.parse = parse;
  }
}

class ParseData extends $CustomType {
  constructor(pos, metadata, state) {
    super();
    this.pos = pos;
    this.metadata = metadata;
    this.state = state;
  }
}

export class Position extends $CustomType {
  constructor(line, column) {
    super();
    this.line = line;
    this.column = column;
  }
}

class InlineRule extends $CustomType {
  constructor(left, right, action) {
    super();
    this.left = left;
    this.right = right;
    this.action = action;
  }
}

class PrefixRule extends $CustomType {
  constructor(prefix, action) {
    super();
    this.prefix = prefix;
    this.action = action;
  }
}

class StaticComponent extends $CustomType {
  constructor(name, action) {
    super();
    this.name = name;
    this.action = action;
  }
}

class DynamicComponent extends $CustomType {
  constructor(name) {
    super();
    this.name = name;
  }
}

class ParserBuilder extends $CustomType {
  constructor(inline_rules, prefix_rules, components, start_state) {
    super();
    this.inline_rules = inline_rules;
    this.prefix_rules = prefix_rules;
    this.components = components;
    this.start_state = start_state;
  }
}

export function get_pos(data) {
  return data.pos;
}

export function get_metadata(data) {
  return data.metadata;
}

export function get_state(data) {
  return data.state;
}

function with_pos(data, pos) {
  return new ParseData(pos, data.metadata, data.state);
}

export function with_state(data, state) {
  return new ParseData(data.pos, data.metadata, state);
}

export function new$(start_state) {
  return new ParserBuilder(toList([]), toList([]), toList([]), start_state);
}

export function add_inline_rule(p, left, right, action) {
  return new ParserBuilder(
    listPrepend(new InlineRule(left, right, action), p.inline_rules),
    p.prefix_rules,
    p.components,
    p.start_state,
  );
}

export function add_prefix_rule(p, prefix, action) {
  return new ParserBuilder(
    p.inline_rules,
    listPrepend(new PrefixRule(prefix, action), p.prefix_rules),
    p.components,
    p.start_state,
  );
}

export function add_static_component(p, name, action) {
  return new ParserBuilder(
    p.inline_rules,
    p.prefix_rules,
    listPrepend(new StaticComponent(name, action), p.components),
    p.start_state,
  );
}

export function add_dynamic_component(p, name) {
  return new ParserBuilder(
    p.inline_rules,
    p.prefix_rules,
    listPrepend(new DynamicComponent(name), p.components),
    p.start_state,
  );
}

export function wrap_inline(w) {
  return (el, _, data) => {
    return new Ok([w(toList([]), toList([el])), get_state(data)]);
  };
}

export function wrap_inline_with_attributes(w, attrs) {
  return (el, _, data) => {
    return new Ok([w(attrs, toList([el])), get_state(data)]);
  };
}

export function wrap_prefix(w) {
  return (el, data) => {
    return new Ok([w(toList([]), toList([el])), get_state(data)]);
  };
}

export function wrap_prefix_with_attributes(w, attrs) {
  return (el, data) => {
    return new Ok([w(attrs, toList([el])), get_state(data)]);
  };
}

function parse_metadata(start_dict) {
  return $party.do$(
    $party.perhaps($party.satisfy((c) => { return c !== "\n"; })),
    (res) => {
      if (res.isOk()) {
        let key_first = res[0];
        return $party.do$(
          $party.until(
            $party.satisfy((_) => { return true; }),
            $party.seq($party.whitespace(), $party.char(":")),
          ),
          (key_rest) => {
            return $party.do$(
              $party.whitespace(),
              (_) => {
                return $party.do$(
                  $party.until(
                    $party.satisfy((_) => { return true; }),
                    $party.char("\n"),
                  ),
                  (val) => {
                    let key_str = $string.concat(
                      listPrepend(key_first, key_rest),
                    );
                    let val_str = $string.concat(val);
                    let d = $dict.insert(start_dict, key_str, val_str);
                    return parse_metadata(d);
                  },
                );
              },
            );
          },
        );
      } else {
        return $party.return$(start_dict);
      }
    },
  );
}

function parse_prefix() {
  return $party.many_concat(
    $party.satisfy(
      (_capture) => {
        return $string.contains("~`!#$%^&*-_=+{[|;:<>,./?]}", _capture);
      },
    ),
  );
}

function escaped_char() {
  return $party.do$(
    $party.char("\\"),
    (_) => {
      return $party.do$(
        $party.satisfy((_) => { return true; }),
        (c) => {
          if (c === "n") {
            return $party.return$("\n");
          } else if (c === "t") {
            return $party.return$("\t");
          } else if (c === "f") {
            return $party.return$("\f");
          } else if (c === "r") {
            return $party.return$("\r");
          } else if (c === "u") {
            return $party.do$(
              $party.char("{"),
              (_) => {
                return $party.do$(
                  $party.whitespace(),
                  (_) => {
                    return $party.do$(
                      $party.many1_concat(
                        $party.satisfy(
                          (_capture) => {
                            return $string.contains(
                              "1234567890abcdefABCDEF",
                              _capture,
                            );
                          },
                        ),
                      ),
                      (code_str) => {
                        return $party.do$(
                          $party.whitespace(),
                          (_) => {
                            return $party.do$(
                              $party.char("}"),
                              (_) => {
                                let $ = $int.base_parse(code_str, 16);
                                if (!$.isOk()) {
                                  throw makeError(
                                    "assignment_no_match",
                                    "arctic/parse",
                                    402,
                                    "",
                                    "Assignment pattern did not match",
                                    { value: $ }
                                  )
                                }
                                let code = $[0];
                                return $party.do$(
                                  $party.try$(
                                    $party.return$(undefined),
                                    (_) => {
                                      let _pipe = $string.utf_codepoint(code);
                                      return $result.map_error(
                                        _pipe,
                                        (_) => {
                                          return $snag.new$(
                                            ("unknown unicode codepoint `\\u{" + code_str) + "}",
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  (codepoint) => {
                                    return $party.return$(
                                      $string.from_utf_codepoints(
                                        toList([codepoint]),
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
          } else {
            return $party.return$(c);
          }
        },
      );
    },
  );
}

function invert_res(res, d) {
  if (res.isOk()) {
    let el = res[0][0];
    let state = res[0][1];
    return [
      new Ok(el),
      (() => {
        let _pipe = d;
        return with_state(_pipe, state);
      })(),
    ];
  } else {
    let s = res[0];
    return [new Error(s), d];
  }
}

function parse_component(components) {
  return new ArcticParser(
    (src, data) => {
      let pos = get_pos(data);
      let res = $party.go(
        $party.do$(
          $party.char("@"),
          (_) => {
            return $party.choice(
              $list.map(
                components,
                (component) => {
                  return $party.do$(
                    $party.string(component.name),
                    (_) => {
                      return $party.do$(
                        $party.many(
                          $party.either($party.char(" "), $party.char("\t")),
                        ),
                        (_) => {
                          return $party.do$(
                            $party.perhaps($party.char("(")),
                            (res) => {
                              return $party.do$(
                                (() => {
                                  if (res.isOk()) {
                                    return $party.do$(
                                      $party.whitespace(),
                                      (_) => {
                                        return $party.do$(
                                          $party.sep(
                                            $party.many1_concat(
                                              $party.satisfy(
                                                (c) => {
                                                  return (c !== ",") && (c !== ")");
                                                },
                                              ),
                                            ),
                                            $party.all(
                                              toList([
                                                $party.whitespace(),
                                                $party.char(","),
                                                $party.whitespace(),
                                              ]),
                                            ),
                                          ),
                                          (a) => {
                                            return $party.do$(
                                              $party.whitespace(),
                                              (_) => {
                                                return $party.do$(
                                                  $party.char(")"),
                                                  (_) => {
                                                    return $party.return$(a);
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    return $party.return$(toList([]));
                                  }
                                })(),
                                (args) => {
                                  return $party.do$(
                                    $party.many(
                                      $party.either(
                                        $party.char(" "),
                                        $party.char("\t"),
                                      ),
                                    ),
                                    (_) => {
                                      return $party.do$(
                                        $party.char("\n"),
                                        (_) => {
                                          return $party.do$(
                                            $party.until(
                                              $party.satisfy(
                                                (_) => { return true; },
                                              ),
                                              $party.end(),
                                            ),
                                            (body) => {
                                              if (component instanceof StaticComponent) {
                                                let action = component.action;
                                                return $party.do$(
                                                  $party.pos(),
                                                  (party_pos) => {
                                                    let data2 = (() => {
                                                      let _pipe = data;
                                                      return with_pos(
                                                        _pipe,
                                                        new Position(
                                                          pos.line + party_pos.row,
                                                          pos.column + party_pos.col,
                                                        ),
                                                      );
                                                    })();
                                                    return $party.do$(
                                                      $party.try$(
                                                        $party.return$(
                                                          undefined,
                                                        ),
                                                        (_) => {
                                                          return action(
                                                            args,
                                                            $string.concat(body),
                                                            data2,
                                                          );
                                                        },
                                                      ),
                                                      (el) => {
                                                        return $party.return$(
                                                          new Some(el),
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              } else {
                                                return $party.return$(
                                                  new Some(
                                                    [
                                                      $element.element(
                                                        component.name,
                                                        toList([
                                                          $attribute.attribute(
                                                            "data-parameters",
                                                            $string.join(
                                                              args,
                                                              ",",
                                                            ),
                                                          ),
                                                          $attribute.attribute(
                                                            "data-body",
                                                            $string.concat(body),
                                                          ),
                                                        ]),
                                                        toList([]),
                                                      ),
                                                      get_state(data),
                                                    ],
                                                  ),
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
                    },
                  );
                },
              ),
            );
          },
        ),
        src,
      );
      if (res.isOk()) {
        let t = res[0];
        return new ParseResult(t, toList([]));
      } else {
        let err = res[0];
        if (err instanceof $party.Unexpected) {
          let party_pos = err.pos;
          let s = err.error;
          return new ParseResult(
            new None(),
            toList([
              new ParseError(
                new Position(
                  pos.line + party_pos.row,
                  pos.column + party_pos.col,
                ),
                s,
              ),
            ]),
          );
        } else {
          let party_pos = err.pos;
          let err$1 = err.error;
          return new ParseResult(
            new None(),
            toList([
              new ParseError(
                new Position(
                  pos.line + party_pos.row,
                  pos.column + party_pos.col,
                ),
                err$1.issue,
              ),
            ]),
          );
        }
      }
    },
  );
}

function parse_inline_rule(inline_rules, data) {
  return $party.choice(
    $list.map(
      inline_rules,
      (rule) => {
        return $party.do$(
          $party.string(rule.left),
          (_) => {
            return $party.do$(
              $party.pos(),
              (party_pos) => {
                let pos = get_pos(data);
                let data2 = (() => {
                  let _pipe = data;
                  return with_pos(
                    _pipe,
                    new Position(
                      pos.line + party_pos.row,
                      pos.column + party_pos.col,
                    ),
                  );
                })();
                return $party.do$(
                  $party.try$(
                    $party.lazy(
                      () => {
                        return parse_markup(
                          inline_rules,
                          $party.map(
                            $party.string(rule.right),
                            (_) => { return undefined; },
                          ),
                          data2,
                        );
                      },
                    ),
                    (a) => { return a; },
                  ),
                  (_use0) => {
                    let middle = _use0[0];
                    let data3 = _use0[1];
                    return $party.do$(
                      $party.string(rule.right),
                      (_) => {
                        return $party.do$(
                          $party.perhaps($party.char("(")),
                          (res) => {
                            return $party.do$(
                              (() => {
                                if (res.isOk()) {
                                  return $party.do$(
                                    $party.sep(
                                      $party.many_concat(
                                        $party.either(
                                          escaped_char(),
                                          $party.satisfy(
                                            (c) => {
                                              return (c !== ",") && (c !== ")");
                                            },
                                          ),
                                        ),
                                      ),
                                      $party.char(","),
                                    ),
                                    (args) => {
                                      return $party.do$(
                                        $party.char(")"),
                                        (_) => { return $party.return$(args); },
                                      );
                                    },
                                  );
                                } else {
                                  return $party.return$(toList([]));
                                }
                              })(),
                              (args) => {
                                return $party.return$(
                                  (d) => {
                                    let d2 = with_pos(d, get_pos(data3));
                                    return invert_res(
                                      rule.action(middle, args, d2),
                                      d2,
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
    ),
  );
}

function parse_markup(inline_rules, terminator, data) {
  let _pipe = $party.choice(
    toList([
      parse_inline_rule(inline_rules, data),
      $party.map(
        escaped_char(),
        (c) => { return (d) => { return [new Ok($element.text(c)), d]; }; },
      ),
      $party.do$(
        $party.not(terminator),
        (_) => {
          return $party.do$(
            $party.satisfy((_) => { return true; }),
            (c) => {
              return $party.return$(
                (d) => { return [new Ok($element.text(c)), d]; },
              );
            },
          );
        },
      ),
    ]),
  );
  let _pipe$1 = ((_capture) => { return $party.stateful_many(data, _capture); })(
    _pipe,
  );
  return $party.map(
    _pipe$1,
    (pair) => {
      let results = pair[0];
      let last_data = pair[1];
      return $result.try$(
        $result.all(results),
        (parts) => { return new Ok([$html.span(toList([]), parts), last_data]); },
      );
    },
  );
}

function parse_text(inline_rules, prefix_rules) {
  return new ArcticParser(
    (src, data) => {
      let pos = get_pos(data);
      let res = $party.go(
        $party.do$(
          parse_prefix(),
          (prefix) => {
            return $party.do$(
              $party.many($party.either($party.char(" "), $party.char("\t"))),
              (_) => {
                return $party.do$(
                  $party.pos(),
                  (party_pos) => {
                    let data2 = (() => {
                      let _pipe = data;
                      return with_pos(
                        _pipe,
                        new Position(
                          pos.line + party_pos.row,
                          pos.column + party_pos.col,
                        ),
                      );
                    })();
                    return $party.do$(
                      parse_markup(inline_rules, $party.end(), data2),
                      (res) => {
                        return $party.do$(
                          $party.try$(
                            $party.return$(undefined),
                            (_) => { return res; },
                          ),
                          (_use0) => {
                            let rest = _use0[0];
                            let data3 = _use0[1];
                            return $party.do$(
                              (() => {
                                let $ = $list.find(
                                  prefix_rules,
                                  (rule) => { return rule.prefix === prefix; },
                                );
                                if ($.isOk()) {
                                  let rule = $[0];
                                  return $party.do$(
                                    $party.pos(),
                                    (party_pos) => {
                                      let data4 = (() => {
                                        let _pipe = data3;
                                        return with_pos(
                                          _pipe,
                                          new Position(
                                            pos.line + party_pos.row,
                                            pos.column + party_pos.col,
                                          ),
                                        );
                                      })();
                                      return $party.do$(
                                        $party.try$(
                                          $party.return$(undefined),
                                          (_) => {
                                            return rule.action(rest, data4);
                                          },
                                        ),
                                        (el) => { return $party.return$(el); },
                                      );
                                    },
                                  );
                                } else {
                                  return $party.return$(
                                    [
                                      $html.p(
                                        toList([]),
                                        toList([$element.text(prefix), rest]),
                                      ),
                                      get_state(data3),
                                    ],
                                  );
                                }
                              })(),
                              (el) => { return $party.return$(new Some(el)); },
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
        src,
      );
      if (res.isOk()) {
        let t = res[0];
        return new ParseResult(t, toList([]));
      } else {
        let err = res[0];
        if (err instanceof $party.Unexpected) {
          let party_pos = err.pos;
          let s = err.error;
          return new ParseResult(
            new None(),
            toList([
              new ParseError(
                new Position(
                  party_pos.row + pos.line,
                  party_pos.col + pos.column,
                ),
                s,
              ),
            ]),
          );
        } else {
          let party_pos = err.pos;
          let err$1 = err.error;
          return new ParseResult(
            new None(),
            toList([
              new ParseError(
                new Position(
                  party_pos.row + pos.line,
                  party_pos.col + pos.column,
                ),
                err$1.issue,
              ),
            ]),
          );
        }
      }
    },
  );
}

function parse_page(builder, src) {
  let graphemes = $string.to_graphemes(src);
  let $ = $list.fold(
    graphemes,
    ["", toList([]), 0, 0, false],
    (so_far, c) => {
      let sec = so_far[0];
      let secs = so_far[1];
      let sec_line = so_far[2];
      let curr_line = so_far[3];
      let was_newline = so_far[4];
      if (c === "\n" && (was_newline)) {
        return [
          "",
          listPrepend([sec_line, sec], secs),
          curr_line + 1,
          curr_line + 1,
          true,
        ];
      } else if (c === "\n") {
        return [sec + "\n", secs, sec_line, curr_line + 1, true];
      } else {
        return [sec + c, secs, sec_line, curr_line, false];
      }
    },
  );
  let last_sec = $[0];
  let sections_rev = $[1];
  let last_sec_line = $[2];
  let sections = (() => {
    if (last_sec === "") {
      return $list.reverse(sections_rev);
    } else {
      return $list.reverse(listPrepend([last_sec_line, last_sec], sections_rev));
    }
  })();
  return $result.try$(
    (() => {
      if (sections.hasLength(0)) {
        return $snag.error("empty page");
      } else {
        let h = sections.head;
        let t = sections.tail;
        return new Ok([h, t]);
      }
    })(),
    (_use0) => {
      let meta_sec = _use0[0][1];
      let body = _use0[1];
      let meta_res = $party.go(parse_metadata($dict.new$()), meta_sec);
      let metadata = (() => {
        if (meta_res.isOk()) {
          let sec = meta_res[0];
          return new ParseResult(sec, toList([]));
        } else {
          let err = meta_res[0];
          if (err instanceof $party.Unexpected) {
            let pos = err.pos;
            let s = err.error;
            return new ParseResult(
              $dict.new$(),
              toList([new ParseError(new Position(pos.row, pos.col), s)]),
            );
          } else {
            let pos = err.pos;
            let err$1 = err.error;
            return new ParseResult(
              $dict.new$(),
              toList([
                new ParseError(new Position(pos.row, pos.col), err$1.issue),
              ]),
            );
          }
        }
      })();
      let id = (() => {
        let _pipe = metadata.val;
        let _pipe$1 = $dict.get(_pipe, "id");
        return $result.unwrap(_pipe$1, "[no id]");
      })();
      $io.print(("Starting `" + id) + "`. ");
      let $1 = $list.fold(
        body,
        [builder.start_state, toList([])],
        (so_far, sec) => {
          let state = so_far[0];
          let body_rev = so_far[1];
          let line = sec[0];
          let str = sec[1];
          let res = (() => {
            let $2 = $string.starts_with(str, "@");
            if ($2) {
              return parse_component(builder.components).parse(
                str,
                new ParseData(new Position(line, 0), metadata.val, state),
              );
            } else {
              return parse_text(builder.inline_rules, builder.prefix_rules).parse(
                str,
                new ParseData(new Position(line, 0), metadata.val, state),
              );
            }
          })();
          let new_state = (() => {
            let $2 = res.val;
            if ($2 instanceof Some) {
              let s = $2[0][1];
              return s;
            } else {
              return state;
            }
          })();
          return [new_state, listPrepend(res, body_rev)];
        },
      );
      let body_rev_res = $1[1];
      let $2 = $list.fold(
        body_rev_res,
        [toList([]), toList([])],
        (so_far, res) => {
          let ast_so_far = so_far[0];
          let errors_so_far = so_far[1];
          let val = $option.map(res.val, (pair) => { return pair[0]; });
          return [
            listPrepend(val, ast_so_far),
            $list.append(res.errors, errors_so_far),
          ];
        },
      );
      let body_ast = $2[0];
      let body_errors = $2[1];
      $io.println(("Finished `" + id) + "`.");
      return new Ok(
        new ParseResult(
          new ParsedPage(metadata.val, body_ast),
          $list.append(metadata.errors, body_errors),
        ),
      );
    },
  );
}

export function parse(p, src_name, src) {
  return $result.try$(
    parse_page(p, src),
    (parsed) => {
      let $ = parsed.errors;
      if ($.atLeastLength(1)) {
        let first_e = $.head;
        let rest = $.tail;
        return $snag.error(
          ((("parse errors in `" + src_name) + "` (") + $list.fold(
            rest,
            (((("unexpected " + first_e.unexpected) + " at ") + $int.to_string(
              first_e.pos.line,
            )) + ":") + $int.to_string(first_e.pos.column),
            (s, e) => {
              return (((((s + ", unexpected ") + e.unexpected) + " at ") + $int.to_string(
                e.pos.line,
              )) + ":") + $int.to_string(e.pos.column);
            },
          )) + ")",
        );
      } else {
        return $result.try$(
          (() => {
            let _pipe = $dict.get(parsed.val.metadata, "id");
            return $result.map_error(
              _pipe,
              (_) => { return $snag.new$("no `id` field present"); },
            );
          })(),
          (id) => {
            return $result.try$(
              (() => {
                let $1 = $dict.get(parsed.val.metadata, "date");
                if ($1.isOk()) {
                  let s = $1[0];
                  return $result.try$(
                    (() => {
                      let _pipe = $birl.parse(s);
                      return $result.map_error(
                        _pipe,
                        (_) => {
                          return $snag.new$(("couldn't parse date `" + s) + "`");
                        },
                      );
                    })(),
                    (d) => { return new Ok(new Some(d)); },
                  );
                } else {
                  return new Ok(new None());
                }
              })(),
              (date) => {
                let _pipe = $page.new$(id);
                let _pipe$1 = $page.with_blerb(
                  _pipe,
                  $result.unwrap($dict.get(parsed.val.metadata, "blerb"), ""),
                );
                let _pipe$2 = $page.with_tags(
                  _pipe$1,
                  $result.unwrap(
                    $result.map(
                      $dict.get(parsed.val.metadata, "tags"),
                      (_capture) => { return $string.split(_capture, ","); },
                    ),
                    toList([]),
                  ),
                );
                let _pipe$3 = ((p) => {
                  if (date instanceof Some) {
                    let d = date[0];
                    return $page.with_date(p, d);
                  } else {
                    return p;
                  }
                })(_pipe$2);
                let _pipe$4 = $page.with_title(
                  _pipe$3,
                  $result.unwrap($dict.get(parsed.val.metadata, "title"), ""),
                );
                let _pipe$5 = $page.with_body(
                  _pipe$4,
                  $list.map(
                    parsed.val.body,
                    (section) => {
                      if (section instanceof Some) {
                        let el = section[0];
                        return el;
                      } else {
                        return $html.div(
                          toList([$attribute.class$("arctic-failed-parse")]),
                          toList([]),
                        );
                      }
                    },
                  ),
                );
                return new Ok(_pipe$5);
              },
            );
          },
        );
      }
    },
  );
}
