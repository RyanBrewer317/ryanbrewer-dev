import * as $dict from "../../gleam_stdlib/gleam/dict.mjs";
import * as $int from "../../gleam_stdlib/gleam/int.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $result from "../../gleam_stdlib/gleam/result.mjs";
import * as $string from "../../gleam_stdlib/gleam/string.mjs";
import * as $p from "../../party/party.mjs";
import { Ok, Error, toList, CustomType as $CustomType, makeError } from "../gleam.mjs";

class LInt extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

class LVar extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

class LLambda extends $CustomType {
  constructor(x0, x1) {
    super();
    this[0] = x0;
    this[1] = x1;
  }
}

class LCall extends $CustomType {
  constructor(x0, x1) {
    super();
    this[0] = x0;
    this[1] = x1;
  }
}

class Gen extends $CustomType {
  constructor(int) {
    super();
    this.int = int;
  }
}

class Wrapped extends $CustomType {
  constructor(val, gen) {
    super();
    this.val = val;
    this.gen = gen;
  }
}

class IRInt extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

class IRVar extends $CustomType {
  constructor(x0, x1) {
    super();
    this[0] = x0;
    this[1] = x1;
  }
}

class IRLambda extends $CustomType {
  constructor(x0, x1, x2) {
    super();
    this[0] = x0;
    this[1] = x1;
    this[2] = x2;
  }
}

class IRCall extends $CustomType {
  constructor(x0, x1) {
    super();
    this[0] = x0;
    this[1] = x1;
  }
}

function parse_int() {
  let _pipe = $p.many1($p.digit());
  let _pipe$1 = $p.map(_pipe, $string.concat);
  let _pipe$2 = $p.map(_pipe$1, $int.parse);
  let _pipe$3 = $p.map(
    _pipe$2,
    (_capture) => {
      return $result.lazy_unwrap(
        _capture,
        () => {
          throw makeError(
            "panic",
            "client/tinylang",
            23,
            "",
            "parsed int isn't an int",
            {}
          )
        },
      );
    },
  );
  return $p.map(_pipe$3, (var0) => { return new LInt(var0); });
}

function parse_var_string() {
  return $p.do$(
    $p.letter(),
    (first) => {
      return $p.do$(
        $p.many($p.either($p.alphanum(), $p.char("_"))),
        (rest) => { return $p.return$(first + $string.concat(rest)); },
      );
    },
  );
}

function parse_var() {
  let _pipe = parse_var_string();
  return $p.map(_pipe, (var0) => { return new LVar(var0); });
}

function ws() {
  return $p.do$(
    $p.many($p.choice(toList([$p.char(" "), $p.char("\t"), $p.char("\n")]))),
    (_) => { return $p.return$(undefined); },
  );
}

function with_fresh_res(gen, f) {
  return f(new Gen(gen.int + 1), gen.int);
}

function translate_helper(gen, e, renames) {
  if (e instanceof LInt) {
    let i = e[0];
    return new Ok(new Wrapped(new IRInt(i), gen));
  } else if (e instanceof LVar) {
    let x = e[0];
    let $ = $dict.get(renames, x);
    if ($.isOk()) {
      let i = $[0];
      return new Ok(new Wrapped(new IRVar(i, x), gen));
    } else {
      return new Error(("Wait! " + x) + " isn't defined anywhere!");
    }
  } else if (e instanceof LLambda) {
    let x = e[0];
    let e$1 = e[1];
    return with_fresh_res(
      gen,
      (gen, i) => {
        return $result.try$(
          translate_helper(gen, e$1, $dict.insert(renames, x, i)),
          (w) => {
            let _pipe = new IRLambda(i, x, w.val);
            let _pipe$1 = new Wrapped(_pipe, w.gen);
            return new Ok(_pipe$1);
          },
        );
      },
    );
  } else {
    let func = e[0];
    let arg = e[1];
    return $result.try$(
      translate_helper(gen, func, renames),
      (w1) => {
        return $result.try$(
          translate_helper(w1.gen, arg, renames),
          (w2) => {
            let _pipe = new IRCall(w1.val, w2.val);
            let _pipe$1 = new Wrapped(_pipe, w2.gen);
            return new Ok(_pipe$1);
          },
        );
      },
    );
  }
}

function translate(gen, e) {
  return $result.try$(
    translate_helper(gen, e, $dict.new$()),
    (w) => { return new Ok(w.val); },
  );
}

function eval_helper(loop$e, loop$heap) {
  while (true) {
    let e = loop$e;
    let heap = loop$heap;
    if (e instanceof IRInt) {
      return e;
    } else if (e instanceof IRVar) {
      let i = e[0];
      let $ = $dict.get(heap, i);
      if ($.isOk()) {
        let val = $[0];
        return val;
      } else {
        return e;
      }
    } else if (e instanceof IRCall) {
      let func = e[0];
      let arg = e[1];
      let func$1 = eval_helper(func, heap);
      let arg$1 = eval_helper(arg, heap);
      if (func$1 instanceof IRLambda) {
        let i = func$1[0];
        let e$1 = func$1[2];
        loop$e = e$1;
        loop$heap = $dict.insert(heap, i, arg$1);
      } else {
        return new IRCall(func$1, arg$1);
      }
    } else {
      let i = e[0];
      let x = e[1];
      let e$1 = e[2];
      return new IRLambda(i, x, eval_helper(e$1, heap));
    }
  }
}

function eval$(e) {
  return eval_helper(e, $dict.new$());
}

function pretty(e) {
  if (e instanceof IRInt) {
    let i = e[0];
    return $int.to_string(i);
  } else if (e instanceof IRVar) {
    let x = e[1];
    return x;
  } else if (e instanceof IRLambda) {
    let x = e[1];
    let e$1 = e[2];
    return (("\\" + x) + ". ") + pretty(e$1);
  } else if (e instanceof IRCall && e[0] instanceof IRLambda) {
    let func = e[0];
    let arg = e[1];
    return ((("(" + pretty(func)) + ")(") + pretty(arg)) + ")";
  } else {
    let func = e[0];
    let arg = e[1];
    return ((pretty(func) + "(") + pretty(arg)) + ")";
  }
}

function squash_res(res) {
  if (res.isOk()) {
    let a = res[0];
    return a;
  } else {
    let a = res[0];
    return a;
  }
}

function expr() {
  return $p.do$(
    ws(),
    (_) => {
      return $p.do$(
        $p.choice(
          toList([parse_int(), parse_var(), parse_lambda(), parenthetical()]),
        ),
        (lit) => {
          return $p.do$(
            ws(),
            (_) => {
              return $p.do$(
                $p.many(
                  $p.do$(
                    $p.char("("),
                    (_) => {
                      return $p.do$(
                        $p.lazy(expr),
                        (arg) => {
                          return $p.do$(
                            $p.char(")"),
                            (_) => {
                              return $p.do$(
                                ws(),
                                (_) => { return $p.return$(arg); },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                (args) => {
                  let e = $list.fold(
                    args,
                    lit,
                    (var0, var1) => { return new LCall(var0, var1); },
                  );
                  return $p.return$(e);
                },
              );
            },
          );
        },
      );
    },
  );
}

function parse_lambda() {
  return $p.do$(
    $p.char("\\"),
    (_) => {
      return $p.do$(
        ws(),
        (_) => {
          return $p.do$(
            parse_var_string(),
            (x) => {
              return $p.do$(
                ws(),
                (_) => {
                  return $p.do$(
                    $p.char("."),
                    (_) => {
                      return $p.do$(
                        ws(),
                        (_) => {
                          return $p.do$(
                            $p.lazy(expr),
                            (e) => { return $p.return$(new LLambda(x, e)); },
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

function parenthetical() {
  return $p.do$(
    $p.char("("),
    (_) => {
      return $p.do$(
        $p.lazy(expr),
        (e) => { return $p.do$($p.char(")"), (_) => { return $p.return$(e); }); },
      );
    },
  );
}

export function go(code) {
  let _pipe = $result.try$(
    $result.replace_error(
      $p.go(expr(), code),
      "there's a mistake in the notation somewhere; I couldn't understand it!",
    ),
    (e) => {
      return $result.try$(
        translate(new Gen(0), e),
        (ir) => {
          let val = eval$(ir);
          return new Ok(pretty(val));
        },
      );
    },
  );
  return squash_res(_pipe);
}
