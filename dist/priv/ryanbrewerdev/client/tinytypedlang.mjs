import * as $dict from "../../gleam_stdlib/gleam/dict.mjs";
import * as $int from "../../gleam_stdlib/gleam/int.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import { None, Some } from "../../gleam_stdlib/gleam/option.mjs";
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
  constructor(x0, x1, x2) {
    super();
    this[0] = x0;
    this[1] = x1;
    this[2] = x2;
  }
}

class LCall extends $CustomType {
  constructor(x0, x1) {
    super();
    this[0] = x0;
    this[1] = x1;
  }
}

class LUniverse extends $CustomType {}

class LIntType extends $CustomType {}

class LPi extends $CustomType {
  constructor(x0, x1, x2) {
    super();
    this[0] = x0;
    this[1] = x1;
    this[2] = x2;
  }
}

class LBinding extends $CustomType {
  constructor(x0, x1, x2, x3) {
    super();
    this[0] = x0;
    this[1] = x1;
    this[2] = x2;
    this[3] = x3;
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
  constructor(x0, x1, x2, x3) {
    super();
    this[0] = x0;
    this[1] = x1;
    this[2] = x2;
    this[3] = x3;
  }
}

class IRCall extends $CustomType {
  constructor(x0, x1) {
    super();
    this[0] = x0;
    this[1] = x1;
  }
}

class IRUniverse extends $CustomType {}

class IRIntType extends $CustomType {}

class IRPi extends $CustomType {
  constructor(x0, x1, x2, x3) {
    super();
    this[0] = x0;
    this[1] = x1;
    this[2] = x2;
    this[3] = x3;
  }
}

class IRBinding extends $CustomType {
  constructor(x0, x1, x2, x3, x4) {
    super();
    this[0] = x0;
    this[1] = x1;
    this[2] = x2;
    this[3] = x3;
    this[4] = x4;
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
            "client/tinytypedlang",
            29,
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

function parse_universe() {
  return $p.do$(
    $p.string("Type"),
    (_) => {
      return $p.do$(
        $p.not($p.either($p.alphanum(), $p.char("_"))),
        (_) => { return $p.return$(new LUniverse()); },
      );
    },
  );
}

function parse_int_type() {
  return $p.do$(
    $p.string("Int"),
    (_) => {
      return $p.do$(
        $p.not($p.either($p.alphanum(), $p.char("_"))),
        (_) => { return $p.return$(new LIntType()); },
      );
    },
  );
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
    let mb_t = e[1];
    let e$1 = e[2];
    return with_fresh_res(
      gen,
      (gen, i) => {
        return $result.try$(
          translate_helper(gen, e$1, $dict.insert(renames, x, i)),
          (w) => {
            return $result.try$(
              (() => {
                if (mb_t instanceof Some) {
                  let t = mb_t[0];
                  return $result.map(
                    translate_helper(gen, t, renames),
                    (w) => { return [new Some(w.val), w.gen]; },
                  );
                } else {
                  return new Ok([new None(), w.gen]);
                }
              })(),
              (_use0) => {
                let mb_t$1 = _use0[0];
                let gen$1 = _use0[1];
                let _pipe = new IRLambda(i, x, mb_t$1, w.val);
                let _pipe$1 = new Wrapped(_pipe, gen$1);
                return new Ok(_pipe$1);
              },
            );
          },
        );
      },
    );
  } else if (e instanceof LCall) {
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
  } else if (e instanceof LUniverse) {
    return new Ok(new Wrapped(new IRUniverse(), gen));
  } else if (e instanceof LIntType) {
    return new Ok(new Wrapped(new IRIntType(), gen));
  } else if (e instanceof LPi) {
    let x = e[0];
    let a = e[1];
    let b = e[2];
    return with_fresh_res(
      gen,
      (gen, i) => {
        return $result.try$(
          translate_helper(gen, a, renames),
          (w1) => {
            return $result.try$(
              translate_helper(w1.gen, b, $dict.insert(renames, x, i)),
              (w2) => {
                let _pipe = new IRPi(i, x, w1.val, w2.val);
                let _pipe$1 = new Wrapped(_pipe, w2.gen);
                return new Ok(_pipe$1);
              },
            );
          },
        );
      },
    );
  } else {
    let x = e[0];
    let mb_t = e[1];
    let v = e[2];
    let e$1 = e[3];
    return with_fresh_res(
      gen,
      (gen, i) => {
        return $result.try$(
          (() => {
            if (mb_t instanceof Some) {
              let t = mb_t[0];
              return $result.map(
                translate_helper(gen, t, renames),
                (w) => { return [new Some(w.val), w.gen]; },
              );
            } else {
              return new Ok([new None(), gen]);
            }
          })(),
          (_use0) => {
            let mb_t$1 = _use0[0];
            let gen$1 = _use0[1];
            let renames$1 = $dict.insert(renames, x, i);
            return $result.try$(
              translate_helper(gen$1, v, renames$1),
              (w2) => {
                return $result.try$(
                  translate_helper(w2.gen, e$1, renames$1),
                  (w3) => {
                    let _pipe = new IRBinding(i, x, mb_t$1, w2.val, w3.val);
                    let _pipe$1 = new Wrapped(_pipe, w3.gen);
                    return new Ok(_pipe$1);
                  },
                );
              },
            );
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

function subst(e, i, v) {
  let s = (_capture) => { return subst(_capture, i, v); };
  if (e instanceof IRInt) {
    let n = e[0];
    return new IRInt(n);
  } else if (e instanceof IRVar) {
    let i2 = e[0];
    let $ = i === i2;
    if ($) {
      return v;
    } else {
      return e;
    }
  } else if (e instanceof IRLambda) {
    let i$1 = e[0];
    let x = e[1];
    let mb_t = e[2];
    let e$1 = e[3];
    return new IRLambda(i$1, x, $option.map(mb_t, s), s(e$1));
  } else if (e instanceof IRCall) {
    let f = e[0];
    let a = e[1];
    return new IRCall(s(f), s(a));
  } else if (e instanceof IRUniverse) {
    return new IRUniverse();
  } else if (e instanceof IRIntType) {
    return new IRIntType();
  } else if (e instanceof IRPi) {
    let i$1 = e[0];
    let x = e[1];
    let a = e[2];
    let b = e[3];
    return new IRPi(i$1, x, s(a), s(b));
  } else {
    let i$1 = e[0];
    let x = e[1];
    let mb_t = e[2];
    let v$1 = e[3];
    let e$1 = e[4];
    return new IRBinding(i$1, x, $option.map(mb_t, s), s(v$1), s(e$1));
  }
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
        let e$1 = func$1[3];
        loop$e = e$1;
        loop$heap = $dict.insert(heap, i, arg$1);
      } else {
        return new IRCall(func$1, arg$1);
      }
    } else if (e instanceof IRUniverse) {
      return new IRUniverse();
    } else if (e instanceof IRIntType) {
      return new IRIntType();
    } else if (e instanceof IRBinding) {
      let i = e[0];
      let v = e[3];
      let e$1 = e[4];
      loop$e = e$1;
      loop$heap = $dict.insert(heap, i, eval_helper(v, heap));
    } else if (e instanceof IRLambda) {
      let i = e[0];
      let x = e[1];
      let mb_t = e[2];
      let e$1 = e[3];
      return new IRLambda(i, x, mb_t, eval_helper(e$1, heap));
    } else {
      let i = e[0];
      let x = e[1];
      let a = e[2];
      let b = e[3];
      return new IRPi(i, x, eval_helper(a, heap), eval_helper(b, heap));
    }
  }
}

function type_eq(e1, e2, heap) {
  let $ = eval_helper(e1, heap);
  let $1 = eval_helper(e2, heap);
  if ($ instanceof IRVar && $1 instanceof IRVar) {
    let i1 = $[0];
    let i2 = $1[0];
    return i1 === i2;
  } else if ($ instanceof IRIntType && $1 instanceof IRIntType) {
    return true;
  } else if ($ instanceof IRUniverse && $1 instanceof IRUniverse) {
    return true;
  } else if ($ instanceof IRPi && $1 instanceof IRPi) {
    let i1 = $[0];
    let x = $[1];
    let a1 = $[2];
    let b1 = $[3];
    let i2 = $1[0];
    let a2 = $1[2];
    let b2 = $1[3];
    return type_eq(a1, a2, heap) && type_eq(
      subst(b2, i2, new IRVar(i1, x)),
      b1,
      heap,
    );
  } else {
    return false;
  }
}

function eval$(e) {
  return eval_helper(e, $dict.new$());
}

function occurs(loop$x, loop$e) {
  while (true) {
    let x = loop$x;
    let e = loop$e;
    if (e instanceof IRVar) {
      let i = e[0];
      return i === x;
    } else if (e instanceof IRLambda && e[2] instanceof Some) {
      let t = e[2][0];
      let e$1 = e[3];
      return occurs(x, t) || occurs(x, e$1);
    } else if (e instanceof IRLambda && e[2] instanceof None) {
      let e$1 = e[3];
      loop$x = x;
      loop$e = e$1;
    } else if (e instanceof IRCall) {
      let func = e[0];
      let arg = e[1];
      return occurs(x, func) || occurs(x, arg);
    } else if (e instanceof IRPi) {
      let a = e[2];
      let b = e[3];
      return occurs(x, a) || occurs(x, b);
    } else if (e instanceof IRBinding && e[2] instanceof Some) {
      let t = e[2][0];
      let v = e[3];
      let e$1 = e[4];
      return (occurs(x, t) || occurs(x, v)) || occurs(x, e$1);
    } else if (e instanceof IRBinding && e[2] instanceof None) {
      let v = e[3];
      let e$1 = e[4];
      return occurs(x, v) || occurs(x, e$1);
    } else {
      return false;
    }
  }
}

function pretty(e) {
  if (e instanceof IRInt) {
    let i = e[0];
    return $int.to_string(i);
  } else if (e instanceof IRVar) {
    let x = e[1];
    return x;
  } else if (e instanceof IRLambda && e[2] instanceof Some) {
    let x = e[1];
    let t = e[2][0];
    let e$1 = e[3];
    return (((("\\" + x) + ": ") + pretty(t)) + ". ") + pretty(e$1);
  } else if (e instanceof IRLambda && e[2] instanceof None) {
    let x = e[1];
    let e$1 = e[3];
    return (("\\" + x) + ". ") + pretty(e$1);
  } else if (e instanceof IRCall && e[0] instanceof IRLambda) {
    let func = e[0];
    let arg = e[1];
    return ((("(" + pretty(func)) + ")(") + pretty(arg)) + ")";
  } else if (e instanceof IRCall) {
    let func = e[0];
    let arg = e[1];
    return ((pretty(func) + "(") + pretty(arg)) + ")";
  } else if (e instanceof IRUniverse) {
    return "Type";
  } else if (e instanceof IRIntType) {
    return "Int";
  } else if (e instanceof IRPi) {
    let i = e[0];
    let x = e[1];
    let a = e[2];
    let b = e[3];
    let $ = occurs(i, b);
    if ($) {
      return (((("forall " + x) + ": ") + pretty(a)) + ". ") + pretty(b);
    } else {
      if (a instanceof IRInt) {
        return (pretty(a) + "->") + pretty(b);
      } else if (a instanceof IRVar) {
        return (pretty(a) + "->") + pretty(b);
      } else if (a instanceof IRUniverse) {
        return (pretty(a) + "->") + pretty(b);
      } else if (a instanceof IRIntType) {
        return (pretty(a) + "->") + pretty(b);
      } else if (a instanceof IRLambda) {
        return (("(" + pretty(a)) + ") -> ") + pretty(b);
      } else if (a instanceof IRCall) {
        return (("(" + pretty(a)) + ") -> ") + pretty(b);
      } else if (a instanceof IRPi) {
        return (("(" + pretty(a)) + ") -> ") + pretty(b);
      } else {
        return (("(" + pretty(a)) + ") -> ") + pretty(b);
      }
    }
  } else if (e instanceof IRBinding && e[2] instanceof Some) {
    let x = e[1];
    let t = e[2][0];
    let v = e[3];
    let e$1 = e[4];
    return (((((("let " + x) + ": ") + pretty(t)) + " = ") + pretty(v)) + ";\n") + pretty(
      e$1,
    );
  } else {
    let x = e[1];
    let v = e[3];
    let e$1 = e[4];
    return (((("let " + x) + " = ") + pretty(v)) + ";\n") + pretty(e$1);
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

function type_check(e, expected, gamma, heap) {
  if (e instanceof IRLambda) {
    let i = e[0];
    let x = e[1];
    let mb_t = e[2];
    let e$1 = e[3];
    if (expected instanceof IRPi) {
      let i2 = expected[0];
      let param_t = expected[2];
      let ret_t = expected[3];
      return $result.try$(
        type_check(
          e$1,
          subst(ret_t, i2, new IRVar(i, x)),
          $dict.insert(gamma, i, param_t),
          heap,
        ),
        (_) => {
          if (mb_t instanceof Some) {
            let x_t = mb_t[0];
            let $ = type_eq(x_t, param_t, heap);
            if ($) {
              return new Ok(undefined);
            } else {
              return new Error(
                ((("Type mismatch in lambda parameter. Expected " + pretty(
                  param_t,
                )) + " but found ") + pretty(x_t)) + ".",
              );
            }
          } else {
            return new Ok(undefined);
          }
        },
      );
    } else {
      return new Error(
        ("Type mismatch. Expected " + pretty(expected)) + " but found a lambda.",
      );
    }
  } else {
    return $result.try$(
      infer_type(e, gamma, heap),
      (t) => {
        let $ = type_eq(t, expected, heap);
        if ($) {
          return new Ok(undefined);
        } else {
          return new Error(
            ((("Type mismatch. Expected " + pretty(expected)) + " but found ") + pretty(
              t,
            )) + ".",
          );
        }
      },
    );
  }
}

function infer_type(e, gamma, heap) {
  if (e instanceof IRInt) {
    return new Ok(new IRIntType());
  } else if (e instanceof IRVar) {
    let i = e[0];
    let x = e[1];
    return $result.map_error(
      $dict.get(gamma, i),
      (_) => {
        return ("Variable " + x) + " is not defined in the current context.";
      },
    );
  } else if (e instanceof IRCall) {
    let func = e[0];
    let arg = e[1];
    return $result.try$(
      infer_type(func, gamma, heap),
      (func_t) => {
        if (func_t instanceof IRPi) {
          let i = func_t[0];
          let param_t = func_t[2];
          let ret_t = func_t[3];
          return $result.try$(
            type_check(arg, param_t, gamma, heap),
            (_) => { return new Ok(subst(ret_t, i, arg)); },
          );
        } else {
          return new Error(
            "Type error. Expected a function type, but found " + pretty(func_t),
          );
        }
      },
    );
  } else if (e instanceof IRPi) {
    let i = e[0];
    let a = e[2];
    let b = e[3];
    return $result.try$(
      type_check(a, new IRUniverse(), gamma, heap),
      (_) => {
        return $result.try$(
          type_check(b, new IRUniverse(), $dict.insert(gamma, i, a), heap),
          (_) => { return new Ok(new IRUniverse()); },
        );
      },
    );
  } else if (e instanceof IRIntType) {
    return new Ok(new IRUniverse());
  } else if (e instanceof IRUniverse) {
    return new Ok(new IRUniverse());
  } else if (e instanceof IRBinding && e[2] instanceof Some) {
    let i = e[0];
    let t = e[2][0];
    let v = e[3];
    let e$1 = e[4];
    return $result.try$(
      type_check(v, t, gamma, heap),
      (_) => {
        return infer_type(
          e$1,
          $dict.insert(gamma, i, t),
          $dict.insert(heap, i, v),
        );
      },
    );
  } else if (e instanceof IRBinding && e[2] instanceof None) {
    let i = e[0];
    let v = e[3];
    let e$1 = e[4];
    return $result.try$(
      infer_type(v, gamma, heap),
      (v_t) => {
        return infer_type(
          e$1,
          $dict.insert(gamma, i, v_t),
          $dict.insert(heap, i, v),
        );
      },
    );
  } else if (e instanceof IRLambda && e[2] instanceof Some) {
    let i = e[0];
    let x = e[1];
    let arg_t = e[2][0];
    let e$1 = e[3];
    return $result.try$(
      infer_type(e$1, $dict.insert(gamma, i, arg_t), heap),
      (t) => { return new Ok(new IRPi(i, x, arg_t, t)); },
    );
  } else {
    return new Error(
      "Type error. Can't infer the type of this lambda. Try annotating it with a `let` expression.",
    );
  }
}

function expr() {
  return $p.do$(
    ws(),
    (_) => {
      return $p.do$(
        $p.choice(
          toList([
            parse_int(),
            parse_universe(),
            parse_int_type(),
            parse_pi_type(),
            parse_binding(),
            parse_var(),
            parse_lambda(),
            parenthetical(),
          ]),
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
                  return $p.do$(
                    $p.perhaps($p.string("->")),
                    (res) => {
                      return $p.do$(
                        (() => {
                          if (res.isOk()) {
                            return $p.do$(
                              $p.lazy(expr),
                              (rett) => {
                                return $p.return$(new LPi("_", e, rett));
                              },
                            );
                          } else {
                            return $p.return$(e);
                          }
                        })(),
                        (e) => { return $p.return$(e); },
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

function parse_pi_type() {
  return $p.do$(
    $p.string("forall"),
    (_) => {
      return $p.do$(
        $p.not($p.either($p.alphanum(), $p.char("_"))),
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
                        $p.char(":"),
                        (_) => {
                          return $p.do$(
                            ws(),
                            (_) => {
                              return $p.do$(
                                $p.lazy(expr),
                                (a) => {
                                  return $p.do$(
                                    $p.char("."),
                                    (_) => {
                                      return $p.do$(
                                        $p.lazy(expr),
                                        (b) => {
                                          return $p.return$(new LPi(x, a, b));
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
                    $p.perhaps($p.char(":")),
                    (res) => {
                      return $p.do$(
                        (() => {
                          if (res.isOk()) {
                            return $p.map(
                              $p.lazy(expr),
                              (var0) => { return new Some(var0); },
                            );
                          } else {
                            return $p.return$(new None());
                          }
                        })(),
                        (mb_t) => {
                          return $p.do$(
                            $p.char("."),
                            (_) => {
                              return $p.do$(
                                ws(),
                                (_) => {
                                  return $p.do$(
                                    $p.lazy(expr),
                                    (e) => {
                                      return $p.return$(new LLambda(x, mb_t, e));
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

function parse_binding() {
  return $p.do$(
    $p.string("let "),
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
                    $p.perhaps($p.char(":")),
                    (res) => {
                      return $p.do$(
                        (() => {
                          if (res.isOk()) {
                            return $p.map(
                              $p.lazy(expr),
                              (var0) => { return new Some(var0); },
                            );
                          } else {
                            return $p.return$(new None());
                          }
                        })(),
                        (mb_t) => {
                          return $p.do$(
                            $p.string("="),
                            (_) => {
                              return $p.do$(
                                $p.lazy(expr),
                                (v) => {
                                  return $p.do$(
                                    $p.char(";"),
                                    (_) => {
                                      return $p.do$(
                                        $p.lazy(expr),
                                        (e) => {
                                          return $p.return$(
                                            new LBinding(x, mb_t, v, e),
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
          return $result.try$(
            infer_type(ir, $dict.new$(), $dict.new$()),
            (_) => {
              let val = eval$(ir);
              return new Ok(pretty(val));
            },
          );
        },
      );
    },
  );
  return squash_res(_pipe);
}
