import * as $result from "../../../gleam_stdlib/gleam/result.mjs";
import * as $header from "../../client/candle/header.mjs";
import {
  App,
  AppSyntax,
  Binder,
  Cast,
  CastSyntax,
  Ctor0,
  Ctor1,
  Ctor2,
  Ctor3,
  DefSyntax,
  Eq,
  EqSyntax,
  ExFalso,
  ExFalsoSyntax,
  Fst,
  FstSyntax,
  Ident,
  IdentSyntax,
  Index,
  Inter,
  InterT,
  IntersectionSyntax,
  IntersectionTypeSyntax,
  KindSort,
  Lambda,
  LambdaSyntax,
  Let,
  LetSyntax,
  Level,
  ManyMode,
  Nat,
  NatSyntax,
  NatT,
  NatTypeSyntax,
  Pi,
  PiSyntax,
  Psi,
  PsiSyntax,
  Refl,
  ReflSyntax,
  SetSort,
  Snd,
  SndSyntax,
  Sort,
  SortSyntax,
  TypeMode,
  VApp,
  VCast,
  VEq,
  VExFalso,
  VFst,
  VIdent,
  VInter,
  VInterT,
  VLambda,
  VNat,
  VNatType,
  VNeutral,
  VPi,
  VPsi,
  VRefl,
  VSnd,
  VSort,
  ZeroMode,
  inc,
  pretty_mode,
  pretty_pos,
  pretty_term,
  pretty_value,
} from "../../client/candle/header.mjs";
import {
  Ok,
  Error,
  toList,
  Empty as $Empty,
  prepend as listPrepend,
  CustomType as $CustomType,
  makeError,
  isEqual,
} from "../../gleam.mjs";

const FILEPATH = "src/client/candle/elab.gleam";

export class Context extends $CustomType {
  constructor(level, types, env, scope) {
    super();
    this.level = level;
    this.types = types;
    this.env = env;
    this.scope = scope;
  }
}

function app(mode, foo, bar) {
  if (foo instanceof VNeutral) {
    let neutral = foo[0];
    return new VNeutral(new VApp(mode, neutral, bar, $header.value_pos(bar)));
  } else if (foo instanceof VLambda) {
    let f = foo[2];
    return f(bar);
  } else {
    throw makeError(
      "panic",
      FILEPATH,
      "client/candle/elab",
      49,
      "app",
      "impossible value application",
      {}
    )
  }
}

function psi(pos, eq, pred) {
  if (eq instanceof VNeutral) {
    let neutral = eq[0];
    return new VNeutral(new VPsi(neutral, pred, pos));
  } else if (eq instanceof VRefl) {
    return new VLambda("x", new ManyMode(), (x) => { return x; }, pos);
  } else {
    throw makeError(
      "panic",
      FILEPATH,
      "client/candle/elab",
      57,
      "psi",
      ("impossible equality elimination " + pretty_value(eq)),
      {}
    )
  }
}

function fst(pos, inter) {
  if (inter instanceof VNeutral) {
    let neutral = inter[0];
    return new VNeutral(new VFst(neutral, pos));
  } else if (inter instanceof VInter) {
    let a = inter[0];
    return a;
  } else if (inter instanceof VCast) {
    let a = inter[0];
    return a;
  } else {
    throw makeError(
      "panic",
      FILEPATH,
      "client/candle/elab",
      69,
      "fst",
      ("impossible value projection " + pretty_value(inter)),
      {}
    )
  }
}

function snd(pos, inter) {
  if (inter instanceof VNeutral) {
    let neutral = inter[0];
    return new VNeutral(new VSnd(neutral, pos));
  } else if (inter instanceof VInter) {
    let b = inter[1];
    return b;
  } else if (inter instanceof VCast) {
    let a = inter[0];
    return a;
  } else {
    throw makeError(
      "panic",
      FILEPATH,
      "client/candle/elab",
      81,
      "snd",
      "impossible value projection",
      {}
    )
  }
}

function lookup(loop$l, loop$i) {
  while (true) {
    let l = loop$l;
    let i = loop$i;
    if (l instanceof $Empty) {
      return new Error(undefined);
    } else if (i === 0) {
      let x = l.head;
      return new Ok(x);
    } else {
      let i$1 = i;
      let rest = l.tail;
      loop$l = rest;
      loop$i = i$1 - 1;
    }
  }
}

export function eval$(loop$t, loop$env) {
  while (true) {
    let t = loop$t;
    let env = loop$env;
    if (t instanceof Ident) {
      let idx = t[1];
      let $ = lookup(env, idx.int);
      if ($ instanceof Ok) {
        let v = $[0];
        return v;
      } else {
        throw makeError(
          "panic",
          FILEPATH,
          "client/candle/elab",
          98,
          "eval",
          "out-of-scope var during eval",
          {}
        )
      }
    } else if (t instanceof Binder) {
      let $ = t[0];
      if ($ instanceof Lambda) {
        let x = t[1];
        let e = t[2];
        let pos = t.pos;
        let mode = $.mode;
        return new VLambda(
          x,
          mode,
          (arg) => { return eval$(e, listPrepend(arg, env)); },
          pos,
        );
      } else if ($ instanceof Pi) {
        let x = t[1];
        let u = t[2];
        let pos = t.pos;
        let mode = $.mode;
        let t$1 = $.ty;
        return new VPi(
          x,
          mode,
          eval$(t$1, env),
          (arg) => { return eval$(u, listPrepend(arg, env)); },
          pos,
        );
      } else if ($ instanceof InterT) {
        let x = t[1];
        let b = t[2];
        let pos = t.pos;
        let a = $.ty;
        return new VInterT(
          x,
          eval$(a, env),
          (arg) => { return eval$(b, listPrepend(arg, env)); },
          pos,
        );
      } else {
        let e = t[2];
        let v = $.val;
        loop$t = e;
        loop$env = listPrepend(eval$(v, env), env);
      }
    } else if (t instanceof Ctor0) {
      let $ = t[0];
      if ($ instanceof Sort) {
        let $1 = $[0];
        if ($1 instanceof SetSort) {
          let pos = t.pos;
          return new VSort(new SetSort(), pos);
        } else {
          let pos = t.pos;
          return new VSort(new KindSort(), pos);
        }
      } else if ($ instanceof NatT) {
        let pos = t.pos;
        return new VNatType(pos);
      } else {
        let pos = t.pos;
        let n = $[0];
        return new VNat(n, pos);
      }
    } else if (t instanceof Ctor1) {
      let $ = t[0];
      if ($ instanceof Fst) {
        let a = t[1];
        let pos = t.pos;
        return fst(pos, eval$(a, env));
      } else if ($ instanceof Snd) {
        let a = t[1];
        let pos = t.pos;
        return snd(pos, eval$(a, env));
      } else if ($ instanceof ExFalso) {
        let a = t[1];
        let pos = t.pos;
        return new VExFalso(eval$(a, env), pos);
      } else {
        let a = t[1];
        let pos = t.pos;
        return new VRefl(eval$(a, env), pos);
      }
    } else if (t instanceof Ctor2) {
      let $ = t[0];
      if ($ instanceof App) {
        let foo = t[1];
        let bar = t[2];
        let mode = $[0];
        return app(mode, eval$(foo, env), eval$(bar, env));
      } else if ($ instanceof Psi) {
        let e = t[1];
        let p = t[2];
        let pos = t.pos;
        return psi(pos, eval$(e, env), eval$(p, env));
      } else {
        let a = t[1];
        let b = t[2];
        let pos = t.pos;
        return new VInter(eval$(a, env), eval$(b, env), pos);
      }
    } else {
      let $ = t[0];
      if ($ instanceof Cast) {
        let a = t[1];
        let inter = t[2];
        let eq$1 = t[3];
        let pos = t.pos;
        return new VCast(
          eval$(a, env),
          eval$(inter, env),
          eval$(eq$1, env),
          pos,
        );
      } else {
        let a = t[1];
        let b = t[2];
        let t$1 = t[3];
        let pos = t.pos;
        return new VEq(eval$(a, env), eval$(b, env), eval$(t$1, env), pos);
      }
    }
  }
}

function pretty_hypotheses(scope) {
  if (scope instanceof $Empty) {
    return "\n";
  } else {
    let rest = scope.tail;
    let x = scope.head[0];
    let t = scope.head[1][1];
    return (((x + ": ") + pretty_value(t)) + "\n") + pretty_hypotheses(rest);
  }
}

function eq_helper(loop$lvl, loop$a, loop$b) {
  while (true) {
    let lvl = loop$lvl;
    let a = loop$a;
    let b = loop$b;
    let eqh = (a, b) => { return eq_helper(lvl, a, b); };
    if (b instanceof VNeutral) {
      if (a instanceof VNeutral) {
        let $ = a[0];
        if ($ instanceof VIdent) {
          let $1 = b[0];
          if ($1 instanceof VIdent) {
            let i = $[2];
            let j = $1[2];
            return isEqual(i, j);
          } else {
            return false;
          }
        } else if ($ instanceof VApp) {
          let $1 = b[0];
          if ($1 instanceof VApp) {
            let m1 = $[0];
            let n1 = $[1];
            let arg1 = $[2];
            let m2 = $1[0];
            let n2 = $1[1];
            let arg2 = $1[2];
            return ((isEqual(m1, m2)) && eqh(new VNeutral(n1), new VNeutral(n2))) && eqh(
              arg1,
              arg2,
            );
          } else {
            return false;
          }
        } else if ($ instanceof VPsi) {
          let $1 = b[0];
          if ($1 instanceof VPsi) {
            let e1 = $[0];
            let p1 = $[1];
            let e2 = $1[0];
            let p2 = $1[1];
            return eqh(new VNeutral(e1), new VNeutral(e2)) && eqh(p1, p2);
          } else {
            return false;
          }
        } else if ($ instanceof VFst) {
          let $1 = b[0];
          if ($1 instanceof VFst) {
            let a1 = $[0];
            let a2 = $1[0];
            return eqh(new VNeutral(a1), new VNeutral(a2));
          } else {
            return false;
          }
        } else {
          let $1 = b[0];
          if ($1 instanceof VSnd) {
            let a1 = $[0];
            let a2 = $1[0];
            return eqh(new VNeutral(a1), new VNeutral(a2));
          } else {
            return false;
          }
        }
      } else if (a instanceof VLambda) {
        let b$1 = b;
        let x = a[0];
        let m = a[1];
        let f = a[2];
        let pos = a[3];
        let dummy = new VNeutral(new VIdent(x, m, lvl, pos));
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(m, b$1, dummy);
      } else {
        return false;
      }
    } else if (b instanceof VSort) {
      if (a instanceof VSort) {
        let s2 = b[0];
        let s1 = a[0];
        return isEqual(s1, s2);
      } else if (a instanceof VLambda) {
        let b$1 = b;
        let x = a[0];
        let m = a[1];
        let f = a[2];
        let pos = a[3];
        let dummy = new VNeutral(new VIdent(x, m, lvl, pos));
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(m, b$1, dummy);
      } else {
        return false;
      }
    } else if (b instanceof VNat) {
      if (a instanceof VNat) {
        let m = b[0];
        let n = a[0];
        return n === m;
      } else if (a instanceof VLambda) {
        let b$1 = b;
        let x = a[0];
        let m = a[1];
        let f = a[2];
        let pos = a[3];
        let dummy = new VNeutral(new VIdent(x, m, lvl, pos));
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(m, b$1, dummy);
      } else {
        return false;
      }
    } else if (b instanceof VNatType) {
      if (a instanceof VNatType) {
        return true;
      } else if (a instanceof VLambda) {
        let b$1 = b;
        let x = a[0];
        let m = a[1];
        let f = a[2];
        let pos = a[3];
        let dummy = new VNeutral(new VIdent(x, m, lvl, pos));
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(m, b$1, dummy);
      } else {
        return false;
      }
    } else if (b instanceof VPi) {
      if (a instanceof VPi) {
        let m2 = b[1];
        let t2 = b[2];
        let u2 = b[3];
        let x = a[0];
        let m1 = a[1];
        let t1 = a[2];
        let u1 = a[3];
        let pos = a[4];
        let dummy = new VNeutral(new VIdent(x, m1, lvl, pos));
        return ((isEqual(m1, m2)) && eqh(t1, t2)) && eq_helper(
          inc(lvl),
          u1(dummy),
          u2(dummy),
        );
      } else if (a instanceof VLambda) {
        let b$1 = b;
        let x = a[0];
        let m = a[1];
        let f = a[2];
        let pos = a[3];
        let dummy = new VNeutral(new VIdent(x, m, lvl, pos));
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(m, b$1, dummy);
      } else {
        return false;
      }
    } else if (b instanceof VLambda) {
      if (a instanceof VLambda) {
        let b$1 = b;
        let x = a[0];
        let m = a[1];
        let f = a[2];
        let pos = a[3];
        let dummy = new VNeutral(new VIdent(x, m, lvl, pos));
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(m, b$1, dummy);
      } else {
        let a$1 = a;
        let x = b[0];
        let m = b[1];
        let f = b[2];
        let pos = b[3];
        let dummy = new VNeutral(new VIdent(x, m, lvl, pos));
        loop$lvl = inc(lvl);
        loop$a = app(m, a$1, dummy);
        loop$b = f(dummy);
      }
    } else if (b instanceof VEq) {
      if (a instanceof VLambda) {
        let b$1 = b;
        let x = a[0];
        let m = a[1];
        let f = a[2];
        let pos = a[3];
        let dummy = new VNeutral(new VIdent(x, m, lvl, pos));
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(m, b$1, dummy);
      } else if (a instanceof VEq) {
        let a2 = b[0];
        let b2 = b[1];
        let t2 = b[2];
        let a1 = a[0];
        let b1 = a[1];
        let t1 = a[2];
        return (eqh(a1, a2) && eqh(b1, b2)) && eqh(t1, t2);
      } else {
        return false;
      }
    } else if (b instanceof VRefl) {
      if (a instanceof VLambda) {
        let b$1 = b;
        let x = a[0];
        let m = a[1];
        let f = a[2];
        let pos = a[3];
        let dummy = new VNeutral(new VIdent(x, m, lvl, pos));
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(m, b$1, dummy);
      } else if (a instanceof VRefl) {
        let a2 = b[0];
        let a1 = a[0];
        return eqh(a1, a2);
      } else {
        return false;
      }
    } else if (b instanceof VInter) {
      if (a instanceof VLambda) {
        let b$1 = b;
        let x = a[0];
        let m = a[1];
        let f = a[2];
        let pos = a[3];
        let dummy = new VNeutral(new VIdent(x, m, lvl, pos));
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(m, b$1, dummy);
      } else if (a instanceof VInter) {
        let a2 = b[0];
        let b2 = b[1];
        let a1 = a[0];
        let b1 = a[1];
        return eqh(a1, a2) && eqh(b1, b2);
      } else {
        return false;
      }
    } else if (b instanceof VInterT) {
      if (a instanceof VLambda) {
        let b$1 = b;
        let x = a[0];
        let m = a[1];
        let f = a[2];
        let pos = a[3];
        let dummy = new VNeutral(new VIdent(x, m, lvl, pos));
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(m, b$1, dummy);
      } else if (a instanceof VInterT) {
        let a2 = b[1];
        let b2 = b[2];
        let x = a[0];
        let a1 = a[1];
        let b1 = a[2];
        let pos = a[3];
        let dummy = new VNeutral(new VIdent(x, new TypeMode(), lvl, pos));
        return eqh(a1, a2) && eq_helper(inc(lvl), b1(dummy), b2(dummy));
      } else {
        return false;
      }
    } else if (b instanceof VCast) {
      if (a instanceof VLambda) {
        let b$1 = b;
        let x = a[0];
        let m = a[1];
        let f = a[2];
        let pos = a[3];
        let dummy = new VNeutral(new VIdent(x, m, lvl, pos));
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(m, b$1, dummy);
      } else if (a instanceof VCast) {
        let a2 = b[0];
        let inter2 = b[1];
        let eq2 = b[2];
        let a1 = a[0];
        let inter1 = a[1];
        let eq1 = a[2];
        return (eqh(a1, a2) && eqh(inter1, inter2)) && eqh(eq1, eq2);
      } else {
        return false;
      }
    } else if (a instanceof VLambda) {
      let b$1 = b;
      let x = a[0];
      let m = a[1];
      let f = a[2];
      let pos = a[3];
      let dummy = new VNeutral(new VIdent(x, m, lvl, pos));
      loop$lvl = inc(lvl);
      loop$a = f(dummy);
      loop$b = app(m, b$1, dummy);
    } else if (a instanceof VExFalso) {
      let a2 = b[0];
      let a1 = a[0];
      return eqh(a1, a2);
    } else {
      return false;
    }
  }
}

function inc_idx(i) {
  return new Index(i.int + 1);
}

function rel_occurs(loop$t, loop$x) {
  while (true) {
    let t = loop$t;
    let x = loop$x;
    if (t instanceof Ident) {
      let y = t[1];
      if (isEqual(x, y)) {
        let pos = t.pos;
        return new Ok(pos);
      } else {
        return new Error(undefined);
      }
    } else if (t instanceof Binder) {
      let $ = t[0];
      if ($ instanceof Let) {
        let e = t[2];
        let v = $.val;
        return $result.or(rel_occurs(v, x), rel_occurs(e, inc_idx(x)));
      } else {
        let e = t[2];
        loop$t = e;
        loop$x = inc_idx(x);
      }
    } else if (t instanceof Ctor0) {
      return new Error(undefined);
    } else if (t instanceof Ctor1) {
      let $ = t[0];
      if ($ instanceof Refl) {
        return new Error(undefined);
      } else {
        let a = t[1];
        loop$t = a;
        loop$x = x;
      }
    } else if (t instanceof Ctor2) {
      let $ = t[0];
      if ($ instanceof App) {
        let $1 = $[0];
        if ($1 instanceof ZeroMode) {
          let a = t[1];
          loop$t = a;
          loop$x = x;
        } else {
          let a = t[1];
          let b = t[2];
          return $result.or(rel_occurs(a, x), rel_occurs(b, x));
        }
      } else if ($ instanceof Psi) {
        let a = t[1];
        loop$t = a;
        loop$x = x;
      } else {
        let a = t[1];
        let b = t[2];
        return $result.or(rel_occurs(a, x), rel_occurs(b, x));
      }
    } else {
      let $ = t[0];
      if ($ instanceof Cast) {
        let a = t[1];
        loop$t = a;
        loop$x = x;
      } else {
        let a = t[1];
        let b = t[2];
        let c = t[3];
        let _pipe = rel_occurs(a, x);
        let _pipe$1 = $result.or(_pipe, rel_occurs(b, x));
        return $result.or(_pipe$1, rel_occurs(c, x));
      }
    }
  }
}

function scan(loop$i, loop$l, loop$key) {
  while (true) {
    let i = loop$i;
    let l = loop$l;
    let key = loop$key;
    if (l instanceof $Empty) {
      return new Error(undefined);
    } else {
      let k = l.head[0];
      if (isEqual(k, key)) {
        let v = l.head[1];
        return new Ok([v, i]);
      } else {
        let rest = l.tail;
        loop$i = i + 1;
        loop$l = rest;
        loop$key = key;
      }
    }
  }
}

function cbool(pos) {
  return new VPi(
    "t",
    new ZeroMode(),
    new VSort(new SetSort(), pos),
    (t) => {
      return new VPi(
        "x",
        new ManyMode(),
        t,
        (_) => {
          return new VPi("y", new ManyMode(), t, (_) => { return t; }, pos);
        },
        pos,
      );
    },
    pos,
  );
}

function ctrue(pos) {
  return new VLambda(
    "t",
    new ZeroMode(),
    (_) => {
      return new VLambda(
        "x",
        new ManyMode(),
        (x) => {
          return new VLambda("y", new ManyMode(), (_) => { return x; }, pos);
        },
        pos,
      );
    },
    pos,
  );
}

function cfalse(pos) {
  return new VLambda(
    "t",
    new ZeroMode(),
    (_) => {
      return new VLambda(
        "x",
        new ManyMode(),
        (_) => {
          return new VLambda("y", new ManyMode(), (y) => { return y; }, pos);
        },
        pos,
      );
    },
    pos,
  );
}

export const empty_ctx = /* @__PURE__ */ new Context(
  /* @__PURE__ */ new Level(0),
  /* @__PURE__ */ toList([]),
  /* @__PURE__ */ toList([]),
  /* @__PURE__ */ toList([]),
);

export function infer(ctx, s) {
  if (s instanceof LambdaSyntax) {
    let $ = s[2];
    if ($ instanceof Ok) {
      let mode = s[0];
      let str = s[1];
      let body = s[3];
      let pos = s.pos;
      let xt = $[0];
      return $result.try$(
        infer(ctx, xt),
        (_use0) => {
          let xt2 = _use0[0];
          let xtt = _use0[1];
          return $result.try$(
            (() => {
              if (xtt instanceof VSort) {
                let $1 = xtt[0];
                if ($1 instanceof SetSort) {
                  return new Ok(undefined);
                } else if (mode instanceof ManyMode) {
                  return new Error("relevant lambda binding can't bind types");
                } else {
                  return new Error("type annotation in lambda must be a type");
                }
              } else {
                return new Error("type annotation in lambda must be a type");
              }
            })(),
            (_) => {
              let xt2v = eval$(xt2, ctx.env);
              let v = new VNeutral(new VIdent(str, mode, ctx.level, pos));
              let ctx2 = new Context(
                inc(ctx.level),
                listPrepend(xt2v, ctx.types),
                listPrepend(v, ctx.env),
                listPrepend([str, [mode, xt2v]], ctx.scope),
              );
              return $result.try$(
                infer(ctx2, body),
                (_use0) => {
                  let body2 = _use0[0];
                  return new Ok(
                    [
                      new Binder(new Lambda(mode), str, body2, pos),
                      new VPi(
                        str,
                        mode,
                        xt2v,
                        (x) => {
                          let ctx2$1 = new Context(
                            inc(ctx.level),
                            listPrepend(xt2v, ctx.env),
                            listPrepend(x, ctx.env),
                            listPrepend([str, [mode, xt2v]], ctx.scope),
                          );
                          let $1 = infer(ctx2$1, body);
                          if (!($1 instanceof Ok)) {
                            throw makeError(
                              "let_assert",
                              FILEPATH,
                              "client/candle/elab",
                              488,
                              "infer",
                              "Pattern match failed, no pattern matched the value.",
                              {
                                value: $1,
                                start: 16599,
                                end: 16641,
                                pattern_start: 16610,
                                pattern_end: 16621
                              }
                            )
                          }
                          let t = $1[0][1];
                          return t;
                        },
                        pos,
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      );
    } else {
      let pos = s.pos;
      return new Error(
        "can't infer the type of the lambda at " + pretty_pos(pos),
      );
    }
  } else if (s instanceof IdentSyntax) {
    let str = s[0];
    let pos = s.pos;
    let $ = scan(0, ctx.scope, str);
    if ($ instanceof Ok) {
      let i = $[0][1];
      let mode = $[0][0][0];
      let ty = $[0][0][1];
      return new Ok([new Ident(mode, new Index(i), str, pos), ty]);
    } else {
      return new Error("undefined variable " + str);
    }
  } else if (s instanceof AppSyntax) {
    let mode1 = s[0];
    let foo = s[1];
    let bar = s[2];
    let pos = s.pos;
    return $result.try$(
      infer(ctx, foo),
      (_use0) => {
        let foo2 = _use0[0];
        let foot = _use0[1];
        if (foot instanceof VPi) {
          let mode2 = foot[1];
          if (isEqual(mode1, mode2)) {
            let a = foot[2];
            let b = foot[3];
            return $result.try$(
              check(ctx, bar, a),
              (bar2) => {
                let t = b(eval$(bar2, ctx.env));
                return new Ok([new Ctor2(new App(mode1), foo2, bar2, pos), t]);
              },
            );
          } else {
            let $ = foot[1];
            if ($ instanceof TypeMode) {
              if (isEqual(mode1, new ManyMode())) {
                let a = foot[2];
                let b = foot[3];
                return $result.try$(
                  check(ctx, bar, a),
                  (bar2) => {
                    let t = b(eval$(bar2, ctx.env));
                    return new Ok(
                      [new Ctor2(new App(new TypeMode()), foo2, bar2, pos), t],
                    );
                  },
                );
              } else {
                let mode2$1 = $;
                return new Error(
                  (((("mode-mismatch between " + pretty_mode(mode1)) + " and ") + pretty_mode(
                    mode2$1,
                  )) + " at ") + pretty_pos(pos),
                );
              }
            } else {
              let mode2$1 = $;
              return new Error(
                (((("mode-mismatch between " + pretty_mode(mode1)) + " and ") + pretty_mode(
                  mode2$1,
                )) + " at ") + pretty_pos(pos),
              );
            }
          }
        } else {
          return new Error(
            (("application to non-function `" + pretty_value(foot)) + "` at ") + pretty_pos(
              pos,
            ),
          );
        }
      },
    );
  } else if (s instanceof LetSyntax) {
    let x = s[0];
    let xt = s[1];
    let v = s[2];
    let e = s[3];
    let pos = s.pos;
    return $result.try$(
      infer(ctx, xt),
      (_use0) => {
        let xt2 = _use0[0];
        let xtt = _use0[1];
        return $result.try$(
          (() => {
            if (xtt instanceof VSort) {
              return new Ok(undefined);
            } else {
              return new Error("type annotation must be a type");
            }
          })(),
          (_) => {
            let xt2v = eval$(xt2, ctx.env);
            return $result.try$(
              check(ctx, v, xt2v),
              (v2) => {
                let v3 = eval$(v2, ctx.env);
                let _block;
                let _record = ctx;
                _block = new Context(
                  _record.level,
                  _record.types,
                  listPrepend(v3, ctx.env),
                  listPrepend([x, [new ManyMode(), xt2v]], ctx.scope),
                );
                let ctx2 = _block;
                return $result.try$(
                  infer(ctx2, e),
                  (_use0) => {
                    let e2 = _use0[0];
                    let et = _use0[1];
                    return new Ok(
                      [new Binder(new Let(new ManyMode(), v2), x, e2, pos), et],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  } else if (s instanceof DefSyntax) {
    let x = s[0];
    let xt = s[1];
    let v = s[2];
    let e = s[3];
    let pos = s.pos;
    return $result.try$(
      infer(ctx, xt),
      (_use0) => {
        let xt2 = _use0[0];
        let xtt = _use0[1];
        return $result.try$(
          (() => {
            if (xtt instanceof VSort) {
              return new Ok(undefined);
            } else {
              return new Error("type annotation must be a type");
            }
          })(),
          (_) => {
            let xt2v = eval$(xt2, ctx.env);
            return $result.try$(
              check(ctx, v, xt2v),
              (v2) => {
                let v3 = eval$(v2, ctx.env);
                let _block;
                let _record = ctx;
                _block = new Context(
                  _record.level,
                  _record.types,
                  listPrepend(v3, ctx.env),
                  listPrepend([x, [new ZeroMode(), xt2v]], ctx.scope),
                );
                let ctx2 = _block;
                return $result.try$(
                  infer(ctx2, e),
                  (_use0) => {
                    let e2 = _use0[0];
                    let et = _use0[1];
                    return new Ok(
                      [new Binder(new Let(new ZeroMode(), v2), x, e2, pos), et],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  } else if (s instanceof NatSyntax) {
    let n = s[0];
    let pos = s.pos;
    return new Ok([new Ctor0(new Nat(n), pos), new VNatType(pos)]);
  } else if (s instanceof NatTypeSyntax) {
    let pos = s.pos;
    return new Ok([new Ctor0(new NatT(), pos), new VSort(new SetSort(), pos)]);
  } else if (s instanceof SortSyntax) {
    let $ = s[0];
    if ($ instanceof SetSort) {
      let pos = s.pos;
      return new Ok(
        [
          new Ctor0(new Sort(new SetSort()), pos),
          new VSort(new KindSort(), pos),
        ],
      );
    } else {
      throw makeError(
        "panic",
        FILEPATH,
        "client/candle/elab",
        412,
        "infer",
        "parsed impossible kind literal",
        {}
      )
    }
  } else if (s instanceof PiSyntax) {
    let mode = s[0];
    let str = s[1];
    let a = s[2];
    let b = s[3];
    let pos = s.pos;
    return $result.try$(
      infer(ctx, a),
      (_use0) => {
        let a2 = _use0[0];
        let at = _use0[1];
        if (at instanceof VSort) {
          let s1 = at[0];
          let _block;
          if (mode instanceof ManyMode) {
            if (s1 instanceof KindSort) {
              _block = new TypeMode();
            } else {
              _block = mode;
            }
          } else {
            _block = mode;
          }
          let mode$1 = _block;
          let dummy = new VNeutral(new VIdent(str, mode$1, ctx.level, pos));
          let a3 = eval$(a2, ctx.env);
          let ctx2 = new Context(
            inc(ctx.level),
            listPrepend(a3, ctx.types),
            listPrepend(dummy, ctx.env),
            listPrepend([str, [mode$1, a3]], ctx.scope),
          );
          return $result.try$(
            infer(ctx2, b),
            (_use0) => {
              let b2 = _use0[0];
              let bt = _use0[1];
              if (bt instanceof VSort) {
                let $ = bt[0];
                if ($ instanceof SetSort) {
                  if (mode$1 instanceof TypeMode) {
                    return new Error(
                      ("type abstractions must return types (" + pretty_pos(pos)) + ")",
                    );
                  } else {
                    let s$1 = bt;
                    return new Ok(
                      [new Binder(new Pi(mode$1, a2), str, b2, pos), s$1],
                    );
                  }
                } else if (mode$1 instanceof ZeroMode) {
                  return new Error(
                    ("erased functions can't return types (" + pretty_pos(pos)) + ")",
                  );
                } else if (mode$1 instanceof ManyMode) {
                  let s$1 = bt;
                  return new Ok(
                    [new Binder(new Pi(new TypeMode(), a2), str, b2, pos), s$1],
                  );
                } else {
                  let s$1 = bt;
                  return new Ok(
                    [new Binder(new Pi(mode$1, a2), str, b2, pos), s$1],
                  );
                }
              } else {
                return new Error(
                  ("pi right-side be a type (" + pretty_pos(pos)) + ")",
                );
              }
            },
          );
        } else {
          return new Error(
            ("pi left-side should be a type (" + pretty_pos(pos)) + ")",
          );
        }
      },
    );
  } else if (s instanceof PsiSyntax) {
    let e = s[0];
    let p = s[1];
    let pos = s.pos;
    return $result.try$(
      infer(ctx, e),
      (_use0) => {
        let e2 = _use0[0];
        let et = _use0[1];
        if (et instanceof VEq) {
          let a = et[0];
          let b = et[1];
          let t = et[2];
          return $result.try$(
            check(
              ctx,
              p,
              new VPi(
                "y",
                new TypeMode(),
                t,
                (y) => {
                  return new VPi(
                    "p",
                    new TypeMode(),
                    new VEq(a, y, t, pos),
                    (_) => { return new VSort(new SetSort(), pos); },
                    pos,
                  );
                },
                pos,
              ),
            ),
            (p2) => {
              let p3 = eval$(p2, ctx.env);
              let e3 = eval$(e2, ctx.env);
              return new Ok(
                [
                  new Ctor2(new Psi(), e2, p2, pos),
                  new VPi(
                    "_",
                    new ManyMode(),
                    app(
                      new TypeMode(),
                      app(new TypeMode(), p3, a),
                      new VRefl(a, pos),
                    ),
                    (_) => {
                      return app(new TypeMode(), app(new TypeMode(), p3, b), e3);
                    },
                    pos,
                  ),
                ],
              );
            },
          );
        } else {
          return new Error(
            ((("Psi requires an equality type, but received " + pretty_term(e2)) + " (") + pretty_pos(
              pos,
            )) + ")",
          );
        }
      },
    );
  } else if (s instanceof IntersectionTypeSyntax) {
    let x = s[0];
    let a = s[1];
    let b = s[2];
    let pos = s.pos;
    return $result.try$(
      check(ctx, a, new VSort(new SetSort(), pos)),
      (a2) => {
        let dummy = new VNeutral(new VIdent(x, new TypeMode(), ctx.level, pos));
        let a3 = eval$(a2, ctx.env);
        let ctx2 = new Context(
          inc(ctx.level),
          listPrepend(a3, ctx.types),
          listPrepend(dummy, ctx.env),
          listPrepend([x, [new TypeMode(), a3]], ctx.scope),
        );
        return $result.try$(
          check(ctx2, b, new VSort(new SetSort(), pos)),
          (b2) => {
            return new Ok(
              [
                new Binder(new InterT(a2), x, b2, pos),
                new VSort(new SetSort(), pos),
              ],
            );
          },
        );
      },
    );
  } else if (s instanceof IntersectionSyntax) {
    let a = s[0];
    let b = s[1];
    let pos = s.pos;
    return $result.try$(
      infer(ctx, a),
      (_use0) => {
        let a2 = _use0[0];
        let at = _use0[1];
        let a3 = eval$(a2, ctx.env);
        return $result.try$(
          infer(ctx, b),
          (_use0) => {
            let b2 = _use0[0];
            let bt = _use0[1];
            let b3 = eval$(b2, ctx.env);
            let $ = eq(ctx.level, a3, b3);
            if ($) {
              return new Ok(
                [
                  new Ctor2(new Inter(), a2, b2, pos),
                  new VInterT("_", at, (_) => { return bt; }, pos),
                ],
              );
            } else {
              return new Error(
                ("Intersection components must be equal (" + pretty_pos(pos)) + ")",
              );
            }
          },
        );
      },
    );
  } else if (s instanceof FstSyntax) {
    let a = s[0];
    let pos = s.pos;
    return $result.try$(
      infer(ctx, a),
      (_use0) => {
        let a2 = _use0[0];
        let at = _use0[1];
        if (at instanceof VInterT) {
          let a$1 = at[1];
          return new Ok([new Ctor1(new Fst(), a2, pos), a$1]);
        } else {
          return new Error(
            ("Projection requires intersection (" + pretty_pos(pos)) + ")",
          );
        }
      },
    );
  } else if (s instanceof SndSyntax) {
    let a = s[0];
    let pos = s.pos;
    return $result.try$(
      infer(ctx, a),
      (_use0) => {
        let a2 = _use0[0];
        let at = _use0[1];
        let a3 = eval$(a2, ctx.env);
        if (at instanceof VInterT) {
          let b = at[2];
          return new Ok([new Ctor1(new Snd(), a2, pos), b(fst(pos, a3))]);
        } else {
          return new Error(
            ("Projection requires intersection (" + pretty_pos(pos)) + ")",
          );
        }
      },
    );
  } else if (s instanceof EqSyntax) {
    let a = s[0];
    let b = s[1];
    let pos = s.pos;
    return $result.try$(
      infer(ctx, a),
      (_use0) => {
        let a2 = _use0[0];
        let t = _use0[1];
        return $result.try$(
          check(ctx, b, t),
          (b2) => {
            let t2 = $header.quote(ctx.level, t);
            return new Ok(
              [
                new Ctor3(new Eq(), a2, b2, t2, pos),
                new VSort(new SetSort(), pos),
              ],
            );
          },
        );
      },
    );
  } else if (s instanceof ReflSyntax) {
    let a = s[0];
    let pos = s.pos;
    return $result.try$(
      infer(ctx, a),
      (_use0) => {
        let a2 = _use0[0];
        let t = _use0[1];
        let a3 = eval$(a2, ctx.env);
        return new Ok([new Ctor1(new Refl(), a2, pos), new VEq(a3, a3, t, pos)]);
      },
    );
  } else if (s instanceof CastSyntax) {
    let a = s[0];
    let inter = s[1];
    let eq$1 = s[2];
    let pos = s.pos;
    return $result.try$(
      infer(ctx, inter),
      (_use0) => {
        let inter2 = _use0[0];
        let intert = _use0[1];
        if (intert instanceof VInterT) {
          let at = intert[1];
          let inter3 = eval$(inter2, ctx.env);
          return $result.try$(
            check(ctx, a, at),
            (a2) => {
              let a3 = eval$(a2, ctx.env);
              return $result.try$(
                check(ctx, eq$1, new VEq(a3, fst(pos, inter3), at, pos)),
                (eq2) => {
                  return new Ok(
                    [new Ctor3(new Cast(), a2, inter2, eq2, pos), intert],
                  );
                },
              );
            },
          );
        } else {
          return new Error(
            ("cast requires an intersection in the second argument (" + pretty_pos(
              pos,
            )) + ")",
          );
        }
      },
    );
  } else {
    let a = s[0];
    let pos = s.pos;
    return $result.try$(
      check(ctx, a, new VEq(ctrue(pos), cfalse(pos), cbool(pos), pos)),
      (a2) => {
        return new Ok(
          [
            new Ctor1(new ExFalso(), a2, pos),
            new VPi(
              "t",
              new ZeroMode(),
              new VSort(new SetSort(), pos),
              (t) => { return t; },
              pos,
            ),
          ],
        );
      },
    );
  }
}

function check(ctx, s, ty) {
  if (s instanceof LambdaSyntax) {
    let $ = s[2];
    if ($ instanceof Ok) {
      if (ty instanceof VPi) {
        let mode1 = s[0];
        let x = s[1];
        let body = s[3];
        let pos = s.pos;
        let xt = $[0];
        let mode2 = ty[1];
        let a = ty[2];
        let b = ty[3];
        return $result.try$(
          (() => {
            let m1 = mode1;
            let m2 = mode2;
            if (isEqual(m1, m2)) {
              return new Ok(m1);
            } else {
              if (mode2 instanceof TypeMode) {
                if (mode1 instanceof ManyMode) {
                  return new Ok(new TypeMode());
                } else {
                  return new Error(
                    (((("mode mismatch: " + pretty_mode(mode1)) + " and ") + pretty_mode(
                      mode2,
                    )) + " at ") + pretty_pos(pos),
                  );
                }
              } else {
                return new Error(
                  (((("mode mismatch: " + pretty_mode(mode1)) + " and ") + pretty_mode(
                    mode2,
                  )) + " at ") + pretty_pos(pos),
                );
              }
            }
          })(),
          (mode) => {
            return $result.try$(
              infer(ctx, xt),
              (_use0) => {
                let xt2 = _use0[0];
                let xt3 = eval$(xt2, ctx.env);
                return $result.try$(
                  (() => {
                    let $1 = eq(ctx.level, xt3, a);
                    if ($1) {
                      return new Ok(undefined);
                    } else {
                      return new Error(
                        (("type mismatch: " + pretty_term(xt2)) + " and ") + pretty_value(
                          a,
                        ),
                      );
                    }
                  })(),
                  (_) => {
                    let v = new VNeutral(new VIdent(x, mode, ctx.level, pos));
                    let ctx2 = new Context(
                      inc(ctx.level),
                      listPrepend(a, ctx.types),
                      listPrepend(v, ctx.env),
                      listPrepend([x, [mode, a]], ctx.scope),
                    );
                    return $result.try$(
                      check(ctx2, body, b(v)),
                      (body2) => {
                        return $result.try$(
                          (() => {
                            if (mode instanceof ZeroMode) {
                              let $1 = rel_occurs(body2, new Index(0));
                              if ($1 instanceof Ok) {
                                let pos2 = $1[0];
                                return new Error(
                                  "relevant usage of erased variable at " + pretty_pos(
                                    pos2,
                                  ),
                                );
                              } else {
                                return new Ok(undefined);
                              }
                            } else {
                              return new Ok(undefined);
                            }
                          })(),
                          (_) => {
                            return new Ok(
                              new Binder(new Lambda(mode), x, body2, pos),
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
        let s$1 = s;
        let ty$1 = ty;
        return $result.try$(
          infer(ctx, s$1),
          (_use0) => {
            let v = _use0[0];
            let ty2 = _use0[1];
            let $1 = eq(ctx.level, ty$1, ty2);
            if ($1) {
              return new Ok(v);
            } else {
              return new Error(
                (((((pretty_hypotheses(ctx.scope) + "type mismatch between `") + pretty_value(
                  ty$1,
                )) + "` and `") + pretty_value(ty2)) + "` at ") + pretty_pos(
                  $header.get_pos(s$1),
                ),
              );
            }
          },
        );
      }
    } else if (ty instanceof VPi) {
      let mode1 = s[0];
      let x = s[1];
      let body = s[3];
      let pos = s.pos;
      let mode2 = ty[1];
      let a = ty[2];
      let b = ty[3];
      return $result.try$(
        (() => {
          let m1 = mode1;
          let m2 = mode2;
          if (isEqual(m1, m2)) {
            return new Ok(m1);
          } else {
            if (mode2 instanceof TypeMode) {
              if (mode1 instanceof ManyMode) {
                return new Ok(new TypeMode());
              } else {
                return new Error(
                  (((("mode mismatch: " + pretty_mode(mode1)) + " and ") + pretty_mode(
                    mode2,
                  )) + " at ") + pretty_pos(pos),
                );
              }
            } else {
              return new Error(
                (((("mode mismatch: " + pretty_mode(mode1)) + " and ") + pretty_mode(
                  mode2,
                )) + " at ") + pretty_pos(pos),
              );
            }
          }
        })(),
        (mode) => {
          let dummy = new VNeutral(new VIdent(x, mode, ctx.level, pos));
          let ctx2 = new Context(
            inc(ctx.level),
            listPrepend(a, ctx.types),
            listPrepend(dummy, ctx.env),
            listPrepend([x, [mode, a]], ctx.scope),
          );
          return $result.try$(
            check(ctx2, body, b(dummy)),
            (body2) => {
              return new Ok(new Binder(new Lambda(mode), x, body2, pos));
            },
          );
        },
      );
    } else {
      let s$1 = s;
      let ty$1 = ty;
      return $result.try$(
        infer(ctx, s$1),
        (_use0) => {
          let v = _use0[0];
          let ty2 = _use0[1];
          let $1 = eq(ctx.level, ty$1, ty2);
          if ($1) {
            return new Ok(v);
          } else {
            return new Error(
              (((((pretty_hypotheses(ctx.scope) + "type mismatch between `") + pretty_value(
                ty$1,
              )) + "` and `") + pretty_value(ty2)) + "` at ") + pretty_pos(
                $header.get_pos(s$1),
              ),
            );
          }
        },
      );
    }
  } else if (s instanceof LetSyntax) {
    let ty$1 = ty;
    let x = s[0];
    let xt = s[1];
    let v = s[2];
    let e = s[3];
    let pos = s.pos;
    return $result.try$(
      infer(ctx, xt),
      (_use0) => {
        let xt2 = _use0[0];
        let xtt = _use0[1];
        return $result.try$(
          (() => {
            if (xtt instanceof VSort) {
              return new Ok(undefined);
            } else {
              return new Error("type annotation must be a type");
            }
          })(),
          (_) => {
            let xt2v = eval$(xt2, ctx.env);
            return $result.try$(
              check(ctx, v, xt2v),
              (v2) => {
                let v3 = eval$(v2, ctx.env);
                let ctx2 = new Context(
                  inc(ctx.level),
                  listPrepend(xt2v, ctx.types),
                  listPrepend(v3, ctx.env),
                  listPrepend([x, [new ManyMode(), xt2v]], ctx.scope),
                );
                return $result.try$(
                  check(ctx2, e, ty$1),
                  (e2) => {
                    return new Ok(
                      new Binder(new Let(new ManyMode(), v2), x, e2, pos),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  } else if (s instanceof DefSyntax) {
    let ty$1 = ty;
    let x = s[0];
    let xt = s[1];
    let v = s[2];
    let e = s[3];
    let pos = s.pos;
    return $result.try$(
      infer(ctx, xt),
      (_use0) => {
        let xt2 = _use0[0];
        let xtt = _use0[1];
        return $result.try$(
          (() => {
            if (xtt instanceof VSort) {
              return new Ok(undefined);
            } else {
              return new Error("type annotation must be a type");
            }
          })(),
          (_) => {
            let xt2v = eval$(xt2, ctx.env);
            return $result.try$(
              check(ctx, v, xt2v),
              (v2) => {
                let v3 = eval$(v2, ctx.env);
                let ctx2 = new Context(
                  inc(ctx.level),
                  listPrepend(xt2v, ctx.types),
                  listPrepend(v3, ctx.env),
                  listPrepend([x, [new ZeroMode(), xt2v]], ctx.scope),
                );
                return $result.try$(
                  check(ctx2, e, ty$1),
                  (e2) => {
                    return new Ok(
                      new Binder(new Let(new ZeroMode(), v2), x, e2, pos),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  } else if (s instanceof IntersectionSyntax) {
    if (ty instanceof VInterT) {
      let a = s[0];
      let b = s[1];
      let pos = s.pos;
      let at = ty[1];
      let bt = ty[2];
      return $result.try$(
        check(ctx, a, at),
        (a2) => {
          let a3 = eval$(a2, ctx.env);
          return $result.try$(
            check(ctx, b, bt(a3)),
            (b2) => {
              let b3 = eval$(b2, ctx.env);
              return $result.try$(
                (() => {
                  let $ = eq(ctx.level, a3, b3);
                  if ($) {
                    return new Ok(undefined);
                  } else {
                    return new Error(
                      ("intersection components must be equal (" + pretty_pos(
                        pos,
                      )) + ")",
                    );
                  }
                })(),
                (_) => { return new Ok(new Ctor2(new Inter(), a2, b2, pos)); },
              );
            },
          );
        },
      );
    } else {
      let s$1 = s;
      let ty$1 = ty;
      return $result.try$(
        infer(ctx, s$1),
        (_use0) => {
          let v = _use0[0];
          let ty2 = _use0[1];
          let $ = eq(ctx.level, ty$1, ty2);
          if ($) {
            return new Ok(v);
          } else {
            return new Error(
              (((((pretty_hypotheses(ctx.scope) + "type mismatch between `") + pretty_value(
                ty$1,
              )) + "` and `") + pretty_value(ty2)) + "` at ") + pretty_pos(
                $header.get_pos(s$1),
              ),
            );
          }
        },
      );
    }
  } else if (s instanceof ReflSyntax) {
    if (ty instanceof VEq) {
      let x = s[0];
      let pos = s.pos;
      let a = ty[0];
      let b = ty[1];
      return $result.try$(
        infer(ctx, x),
        (_use0) => {
          let x2 = _use0[0];
          let x3 = eval$(x2, ctx.env);
          return $result.try$(
            (() => {
              let $ = eq(ctx.level, x3, a);
              if ($) {
                let $1 = eq(ctx.level, x3, b);
                if ($1) {
                  return new Ok(undefined);
                } else {
                  return new Error(
                    (((("type mismatch between " + pretty_value(x3)) + " and ") + pretty_value(
                      b,
                    )) + " at ") + pretty_pos(pos),
                  );
                }
              } else {
                return new Error(
                  (((("type mismatch between " + pretty_value(x3)) + " and ") + pretty_value(
                    a,
                  )) + " at ") + pretty_pos(pos),
                );
              }
            })(),
            (_) => { return new Ok(new Ctor1(new Refl(), x2, pos)); },
          );
        },
      );
    } else {
      let s$1 = s;
      let ty$1 = ty;
      return $result.try$(
        infer(ctx, s$1),
        (_use0) => {
          let v = _use0[0];
          let ty2 = _use0[1];
          let $ = eq(ctx.level, ty$1, ty2);
          if ($) {
            return new Ok(v);
          } else {
            return new Error(
              (((((pretty_hypotheses(ctx.scope) + "type mismatch between `") + pretty_value(
                ty$1,
              )) + "` and `") + pretty_value(ty2)) + "` at ") + pretty_pos(
                $header.get_pos(s$1),
              ),
            );
          }
        },
      );
    }
  } else if (s instanceof CastSyntax) {
    if (ty instanceof VInterT) {
      let intert = ty;
      let a = s[0];
      let inter = s[1];
      let eq$1 = s[2];
      let pos = s.pos;
      let at = ty[1];
      return $result.try$(
        check(ctx, a, at),
        (a2) => {
          let a3 = eval$(a2, ctx.env);
          return $result.try$(
            check(ctx, inter, intert),
            (inter2) => {
              let inter3 = eval$(inter2, ctx.env);
              return $result.try$(
                check(ctx, eq$1, new VEq(a3, fst(pos, inter3), at, pos)),
                (eq2) => {
                  return new Ok(new Ctor3(new Cast(), a2, inter2, eq2, pos));
                },
              );
            },
          );
        },
      );
    } else {
      let s$1 = s;
      let ty$1 = ty;
      return $result.try$(
        infer(ctx, s$1),
        (_use0) => {
          let v = _use0[0];
          let ty2 = _use0[1];
          let $ = eq(ctx.level, ty$1, ty2);
          if ($) {
            return new Ok(v);
          } else {
            return new Error(
              (((((pretty_hypotheses(ctx.scope) + "type mismatch between `") + pretty_value(
                ty$1,
              )) + "` and `") + pretty_value(ty2)) + "` at ") + pretty_pos(
                $header.get_pos(s$1),
              ),
            );
          }
        },
      );
    }
  } else {
    let s$1 = s;
    let ty$1 = ty;
    return $result.try$(
      infer(ctx, s$1),
      (_use0) => {
        let v = _use0[0];
        let ty2 = _use0[1];
        let $ = eq(ctx.level, ty$1, ty2);
        if ($) {
          return new Ok(v);
        } else {
          return new Error(
            (((((pretty_hypotheses(ctx.scope) + "type mismatch between `") + pretty_value(
              ty$1,
            )) + "` and `") + pretty_value(ty2)) + "` at ") + pretty_pos(
              $header.get_pos(s$1),
            ),
          );
        }
      },
    );
  }
}

function erase_neutral(loop$n) {
  while (true) {
    let n = loop$n;
    if (n instanceof VIdent) {
      return n;
    } else if (n instanceof VApp) {
      let $ = n[0];
      if ($ instanceof ZeroMode) {
        let a = n[1];
        loop$n = a;
      } else {
        let m = $;
        let a = n[1];
        let b = n[2];
        let p = n[3];
        return new VApp(m, erase_neutral(a), erase(b), p);
      }
    } else if (n instanceof VPsi) {
      let e = n[0];
      loop$n = e;
    } else if (n instanceof VFst) {
      let a = n[0];
      loop$n = a;
    } else {
      let a = n[0];
      loop$n = a;
    }
  }
}

function erase(loop$t) {
  while (true) {
    let t = loop$t;
    if (t instanceof VNeutral) {
      let n = t[0];
      return new VNeutral(erase_neutral(n));
    } else if (t instanceof VSort) {
      return t;
    } else if (t instanceof VNat) {
      return t;
    } else if (t instanceof VNatType) {
      return t;
    } else if (t instanceof VPi) {
      let x = t[0];
      let mode = t[1];
      let a = t[2];
      let b = t[3];
      let p = t[4];
      return new VPi(x, mode, erase(a), (arg) => { return erase(b(arg)); }, p);
    } else if (t instanceof VLambda) {
      let $ = t[1];
      if ($ instanceof ZeroMode) {
        let e = t[2];
        let p = t[3];
        loop$t = e(
          new VNeutral(new VIdent("", new ZeroMode(), new Level(0), p)),
        );
      } else {
        let x = t[0];
        let mode = $;
        let e = t[2];
        let p = t[3];
        return new VLambda(x, mode, (arg) => { return erase(e(arg)); }, p);
      }
    } else if (t instanceof VEq) {
      let a = t[0];
      let b = t[1];
      let t$1 = t[2];
      let p = t[3];
      return new VEq(erase(a), erase(b), erase(t$1), p);
    } else if (t instanceof VRefl) {
      let p = t[1];
      return new VLambda("x", new ManyMode(), (x) => { return x; }, p);
    } else if (t instanceof VInter) {
      let a = t[0];
      loop$t = a;
    } else if (t instanceof VInterT) {
      let x = t[0];
      let a = t[1];
      let b = t[2];
      let p = t[3];
      return new VInterT(x, erase(a), (arg) => { return erase(b(arg)); }, p);
    } else if (t instanceof VCast) {
      let a = t[0];
      loop$t = a;
    } else {
      let a = t[0];
      loop$t = a;
    }
  }
}

function eq(lvl, a, b) {
  return eq_helper(lvl, erase(a), erase(b));
}
