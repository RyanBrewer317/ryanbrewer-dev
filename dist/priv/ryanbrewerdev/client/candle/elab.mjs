import * as $stdlib$dict from "../../../gleam_stdlib/dict.mjs";
import * as $dict from "../../../gleam_stdlib/gleam/dict.mjs";
import * as $int from "../../../gleam_stdlib/gleam/int.mjs";
import * as $list from "../../../gleam_stdlib/gleam/list.mjs";
import * as $result from "../../../gleam_stdlib/gleam/result.mjs";
import * as $header from "../../client/candle/header.mjs";
import {
  App,
  AppSyntax,
  Binder,
  Cast,
  CastSyntax,
  ContextMask,
  Ctor0,
  Ctor1,
  Ctor2,
  Ctor3,
  DefSyntax,
  Eq,
  EqSyntax,
  ExFalso,
  ExFalsoSyntax,
  Explicit,
  Fst,
  FstSyntax,
  HoleSyntax,
  Ident,
  IdentSyntax,
  Implicit,
  Index,
  InsertedMeta,
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
  Meta,
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
  Solved,
  Sort,
  SortSyntax,
  TypeMode,
  Unsolved,
  VApp,
  VCast,
  VEq,
  VExFalso,
  VFst,
  VIdent,
  VInter,
  VInterT,
  VLambda,
  VMeta,
  VNat,
  VNatType,
  VPi,
  VPsi,
  VRefl,
  VSnd,
  VSort,
  ZeroMode,
  get,
  inc,
  lvl_to_idx,
  new$,
  next_id,
  pretty_mode,
  pretty_pos,
  pretty_term,
  pretty_value,
  set,
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
  bitArraySlice,
  bitArraySliceToInt,
  BitArray as $BitArray,
  List as $List,
  UtfCodepoint as $UtfCodepoint,
} from "../../gleam.mjs";

const FILEPATH = "src/client/candle/elab.gleam";

export class Context extends $CustomType {
  constructor(level, types, env, scope, mask) {
    super();
    this.level = level;
    this.types = types;
    this.env = env;
    this.scope = scope;
    this.mask = mask;
  }
}

class PartialRenaming extends $CustomType {
  constructor(domain_size, codomain_size, renaming) {
    super();
    this.domain_size = domain_size;
    this.codomain_size = codomain_size;
    this.renaming = renaming;
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

function fresh_meta(ctx, pos) {
  let ref = new$(new Unsolved(next_id()));
  return new Ctor0(new InsertedMeta(ref, ctx.mask), pos);
}

function lift(pr) {
  return new PartialRenaming(
    inc(pr.domain_size),
    inc(pr.codomain_size),
    $dict.insert(pr.renaming, pr.codomain_size, pr.domain_size),
  );
}

function lambdas_helper(lvl, body, x) {
  let $ = isEqual(x, lvl);
  if ($) {
    return body;
  } else {
    return new Binder(
      new Lambda(new ManyMode(), new Explicit()),
      "x" + $int.to_string(x.int + 1),
      lambdas_helper(lvl, body, inc(x)),
      $header.term_pos(body),
    );
  }
}

function lambdas(lvl, body) {
  return lambdas_helper(lvl, body, new Level(0));
}

function and(a, b) {
  if (a instanceof Ok) {
    if (b instanceof Ok) {
      let $ = a[0];
      if ($) {
        let $1 = b[0];
        if ($1) {
          return new Ok(true);
        } else {
          return new Ok(false);
        }
      } else {
        return new Ok(false);
      }
    } else {
      let err = b[0];
      return new Error(err);
    }
  } else {
    let err = a[0];
    return new Error(err);
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
        let $1 = $.mode;
        if ($1 instanceof ZeroMode) {
          let e = t[2];
          loop$t = e;
          loop$x = inc_idx(x);
        } else {
          let e = t[2];
          let v = $.val;
          return $result.or(rel_occurs(v, x), rel_occurs(e, inc_idx(x)));
        }
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
    new Explicit(),
    new VSort(new SetSort(), pos),
    (t) => {
      return new VPi(
        "x",
        new ManyMode(),
        new Explicit(),
        t,
        (_) => {
          return new VPi(
            "y",
            new ManyMode(),
            new Explicit(),
            t,
            (_) => { return t; },
            pos,
          );
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
    new Explicit(),
    (_) => {
      return new VLambda(
        "x",
        new ManyMode(),
        new Explicit(),
        (x) => {
          return new VLambda(
            "y",
            new ManyMode(),
            new Explicit(),
            (_) => { return x; },
            pos,
          );
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
    new Explicit(),
    (_) => {
      return new VLambda(
        "x",
        new ManyMode(),
        new Explicit(),
        (_) => {
          return new VLambda(
            "y",
            new ManyMode(),
            new Explicit(),
            (y) => { return y; },
            pos,
          );
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
  /* @__PURE__ */ toList([]),
);

export function infer(ctx, s) {
  if (s instanceof LambdaSyntax) {
    let $ = s[3];
    if ($ instanceof Ok) {
      let mode = s[0];
      let imp = s[1];
      let str = s[2];
      let body = s[4];
      let pos = s.pos;
      let xt = $[0];
      return $result.try$(
        infer(ctx, xt),
        (_use0) => {
          let xt2 = _use0[0];
          let xtt = _use0[1];
          return $result.try$(
            (() => {
              let $1 = force(xtt);
              if ($1 instanceof VSort) {
                let $2 = $1[0];
                if ($2 instanceof SetSort) {
                  return new Ok(undefined);
                } else if (mode instanceof ZeroMode) {
                  return new Ok(undefined);
                } else if (mode instanceof ManyMode) {
                  return new Error(
                    "relevant lambda binding can't bind types" + pretty_pos(pos),
                  );
                } else {
                  return new Error(
                    "type annotation in lambda must be a type " + pretty_pos(
                      pos,
                    ),
                  );
                }
              } else {
                return new Error(
                  "type annotation in lambda must be a type " + pretty_pos(pos),
                );
              }
            })(),
            (_) => {
              let xt2v = eval$(xt2, ctx.env);
              let v = new VIdent(str, mode, ctx.level, toList([]), pos);
              let ctx2 = new Context(
                inc(ctx.level),
                listPrepend(xt2v, ctx.types),
                listPrepend(v, ctx.env),
                listPrepend([str, [mode, xt2v]], ctx.scope),
                listPrepend(new ContextMask(false, mode), ctx.mask),
              );
              return $result.try$(
                infer(ctx2, body),
                (_use0) => {
                  let body2 = _use0[0];
                  return new Ok(
                    [
                      new Binder(new Lambda(mode, imp), str, body2, pos),
                      new VPi(
                        str,
                        mode,
                        imp,
                        xt2v,
                        (x) => {
                          let ctx2$1 = new Context(
                            inc(ctx.level),
                            listPrepend(xt2v, ctx.types),
                            listPrepend(x, ctx.env),
                            listPrepend([str, [mode, xt2v]], ctx.scope),
                            listPrepend(new ContextMask(false, mode), ctx.mask),
                          );
                          let $1 = infer(ctx2$1, body);
                          if (!($1 instanceof Ok)) {
                            throw makeError(
                              "let_assert",
                              FILEPATH,
                              "client/candle/elab",
                              849,
                              "infer",
                              "Pattern match failed, no pattern matched the value.",
                              {
                                value: $1,
                                start: 27525,
                                end: 27567,
                                pattern_start: 27536,
                                pattern_end: 27547
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
    let icit = s[1];
    let foo = s[2];
    let bar = s[3];
    let pos = s.pos;
    return $result.try$(
      infer(ctx, foo),
      (_use0) => {
        let foo2 = _use0[0];
        let foot = _use0[1];
        let _block;
        if (icit instanceof Implicit) {
          _block = [foo2, foot];
        } else {
          _block = insert(ctx, foo2, foot);
        }
        let $ = _block;
        let foo2$1 = $[0];
        let foot$1 = $[1];
        let $1 = force(foot$1);
        if ($1 instanceof VPi) {
          let $2 = $1[2];
          if ($2 instanceof Explicit) {
            if (isEqual(icit, new Implicit())) {
              return new Error(
                "unexpected implicit application at " + pretty_pos(pos),
              );
            } else {
              let mode2 = $1[1];
              if (isEqual(mode1, mode2)) {
                let a = $1[3];
                let b = $1[4];
                return $result.try$(
                  check(ctx, bar, a),
                  (bar2) => {
                    let t = b(eval$(bar2, ctx.env));
                    return new Ok(
                      [new Ctor2(new App(mode1, icit), foo2$1, bar2, pos), t],
                    );
                  },
                );
              } else {
                let $3 = $1[1];
                if ($3 instanceof TypeMode) {
                  if (isEqual(mode1, new ZeroMode())) {
                    let a = $1[3];
                    let b = $1[4];
                    return $result.try$(
                      check(ctx, bar, a),
                      (bar2) => {
                        let t = b(eval$(bar2, ctx.env));
                        return new Ok(
                          [
                            new Ctor2(
                              new App(new TypeMode(), new Explicit()),
                              foo2$1,
                              bar2,
                              pos,
                            ),
                            t,
                          ],
                        );
                      },
                    );
                  } else {
                    let mode2$1 = $3;
                    return new Error(
                      (((("mode-mismatch between " + pretty_mode(mode1)) + " and ") + pretty_mode(
                        mode2$1,
                      )) + " at ") + pretty_pos(pos),
                    );
                  }
                } else {
                  let mode2$1 = $3;
                  return new Error(
                    (((("mode-mismatch between " + pretty_mode(mode1)) + " and ") + pretty_mode(
                      mode2$1,
                    )) + " at ") + pretty_pos(pos),
                  );
                }
              }
            }
          } else {
            let mode2 = $1[1];
            if (isEqual(mode1, mode2)) {
              let a = $1[3];
              let b = $1[4];
              return $result.try$(
                check(ctx, bar, a),
                (bar2) => {
                  let t = b(eval$(bar2, ctx.env));
                  return new Ok(
                    [new Ctor2(new App(mode1, icit), foo2$1, bar2, pos), t],
                  );
                },
              );
            } else {
              let $3 = $1[1];
              if ($3 instanceof TypeMode) {
                if (isEqual(mode1, new ZeroMode())) {
                  let a = $1[3];
                  let b = $1[4];
                  return $result.try$(
                    check(ctx, bar, a),
                    (bar2) => {
                      let t = b(eval$(bar2, ctx.env));
                      return new Ok(
                        [
                          new Ctor2(
                            new App(new TypeMode(), new Explicit()),
                            foo2$1,
                            bar2,
                            pos,
                          ),
                          t,
                        ],
                      );
                    },
                  );
                } else {
                  let mode2$1 = $3;
                  return new Error(
                    (((("mode-mismatch between " + pretty_mode(mode1)) + " and ") + pretty_mode(
                      mode2$1,
                    )) + " at ") + pretty_pos(pos),
                  );
                }
              } else {
                let mode2$1 = $3;
                return new Error(
                  (((("mode-mismatch between " + pretty_mode(mode1)) + " and ") + pretty_mode(
                    mode2$1,
                  )) + " at ") + pretty_pos(pos),
                );
              }
            }
          }
        } else {
          let foot$2 = $1;
          let a = eval$(fresh_meta(ctx, pos), ctx.env);
          let b = (x) => {
            let ctx2 = new Context(
              inc(ctx.level),
              listPrepend(a, ctx.types),
              listPrepend(x, ctx.env),
              listPrepend(
                ["x", [mode1, new VSort(new SetSort(), pos)]],
                ctx.scope,
              ),
              listPrepend(new ContextMask(false, mode1), ctx.mask),
            );
            return eval$(fresh_meta(ctx2, pos), ctx2.env);
          };
          let res = unify(
            ctx.level,
            foot$2,
            new VPi("x", mode1, new Explicit(), a, b, pos),
          );
          if (res instanceof Ok) {
            let $2 = res[0];
            if ($2) {
              return $result.try$(
                check(ctx, bar, a),
                (bar2) => {
                  let t = b(eval$(bar2, ctx.env));
                  return new Ok(
                    [
                      new Ctor2(
                        new App(mode1, new Explicit()),
                        foo2$1,
                        bar2,
                        pos,
                      ),
                      t,
                    ],
                  );
                },
              );
            } else {
              return new Error("calling non-function at " + pretty_pos(pos));
            }
          } else {
            let err = res[0];
            return new Error(err);
          }
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
            let $ = force(xtt);
            if ($ instanceof VSort) {
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
                  listPrepend(new ContextMask(true, new ManyMode()), ctx.mask),
                );
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
            let $ = force(xtt);
            if ($ instanceof VSort) {
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
                  listPrepend(new ContextMask(true, new ZeroMode()), ctx.mask),
                );
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
        772,
        "infer",
        "parsed impossible kind literal",
        {}
      )
    }
  } else if (s instanceof PiSyntax) {
    let mode = s[0];
    let imp = s[1];
    let str = s[2];
    let a = s[3];
    let b = s[4];
    let pos = s.pos;
    return $result.try$(
      infer(ctx, a),
      (_use0) => {
        let a2 = _use0[0];
        let at = _use0[1];
        let $ = force(at);
        if ($ instanceof VSort) {
          let dummy = new VIdent(str, mode, ctx.level, toList([]), pos);
          let a3 = eval$(a2, ctx.env);
          let ctx2 = new Context(
            inc(ctx.level),
            listPrepend(a3, ctx.types),
            listPrepend(dummy, ctx.env),
            listPrepend([str, [mode, a3]], ctx.scope),
            listPrepend(new ContextMask(false, mode), ctx.mask),
          );
          return $result.try$(
            infer(ctx2, b),
            (_use0) => {
              let b2 = _use0[0];
              let bt = _use0[1];
              let $1 = force(bt);
              if ($1 instanceof VSort) {
                let $2 = $1[0];
                if ($2 instanceof SetSort) {
                  if (mode instanceof TypeMode) {
                    return new Error(
                      ("type abstractions must return types (" + pretty_pos(pos)) + ")",
                    );
                  } else {
                    let s$1 = $1;
                    return new Ok(
                      [new Binder(new Pi(mode, imp, a2), str, b2, pos), s$1],
                    );
                  }
                } else if (mode instanceof ZeroMode) {
                  let s$1 = $1;
                  return new Ok(
                    [
                      new Binder(new Pi(new TypeMode(), imp, a2), str, b2, pos),
                      s$1,
                    ],
                  );
                } else if (mode instanceof ManyMode) {
                  return new Error(
                    ("relevant functions can't return types (" + pretty_pos(pos)) + ")",
                  );
                } else {
                  let s$1 = $1;
                  return new Ok(
                    [new Binder(new Pi(mode, imp, a2), str, b2, pos), s$1],
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
        let $ = force(et);
        if ($ instanceof VEq) {
          let a = $[0];
          let b = $[1];
          let t = $[2];
          let pi = (x, t, u) => {
            return new VPi(x, new TypeMode(), new Explicit(), t, u, pos);
          };
          let t1 = pi(
            "y",
            t,
            (y) => {
              return pi(
                "p",
                new VEq(a, y, t, pos),
                (_) => { return new VSort(new SetSort(), pos); },
              );
            },
          );
          return $result.try$(
            check(ctx, p, t1),
            (p2) => {
              let p3 = eval$(p2, ctx.env);
              let e3 = eval$(e2, ctx.env);
              let pi2 = (x, t, u) => {
                return new VPi(x, new ManyMode(), new Explicit(), t, u, pos);
              };
              let app2 = (f, x) => {
                return app(pos, new TypeMode(), new Explicit(), f, x);
              };
              let t2 = pi2(
                "_",
                app2(app2(p3, a), new VRefl(a, pos)),
                (_) => { return app2(app2(p3, b), e3); },
              );
              return new Ok([new Ctor2(new Psi(), e2, p2, pos), t2]);
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
        let dummy = new VIdent(x, new TypeMode(), ctx.level, toList([]), pos);
        let a3 = eval$(a2, ctx.env);
        let ctx2 = new Context(
          inc(ctx.level),
          listPrepend(a3, ctx.types),
          listPrepend(dummy, ctx.env),
          listPrepend([x, [new TypeMode(), a3]], ctx.scope),
          listPrepend(new ContextMask(false, new TypeMode()), ctx.mask),
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
            let $ = unify(ctx.level, a3, b3);
            if ($ instanceof Ok) {
              let $1 = $[0];
              if ($1) {
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
            } else {
              let err = $[0];
              return new Error(err);
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
        let $ = force(at);
        if ($ instanceof VInterT) {
          let a$1 = $[1];
          return new Ok([new Ctor1(new Fst(), a2, pos), a$1]);
        } else {
          let at$1 = $;
          let a$1 = eval$(fresh_meta(ctx, pos), ctx.env);
          let b = (x) => {
            let ctx2 = new Context(
              inc(ctx.level),
              listPrepend(a$1, ctx.types),
              listPrepend(x, ctx.env),
              listPrepend(
                ["x", [new TypeMode(), new VSort(new SetSort(), pos)]],
                ctx.scope,
              ),
              listPrepend(new ContextMask(false, new TypeMode()), ctx.mask),
            );
            return eval$(fresh_meta(ctx2, pos), ctx2.env);
          };
          let res = unify(ctx.level, at$1, new VInterT("x", a$1, b, pos));
          if (res instanceof Ok) {
            let $1 = res[0];
            if ($1) {
              return new Ok([new Ctor1(new Fst(), a2, pos), a$1]);
            } else {
              return new Error(
                "projection requires intersection at " + pretty_pos(pos),
              );
            }
          } else {
            let err = res[0];
            return new Error(err);
          }
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
        let $ = force(at);
        if ($ instanceof VInterT) {
          let b = $[2];
          return new Ok([new Ctor1(new Snd(), a2, pos), b(fst(pos, a3))]);
        } else {
          let at$1 = $;
          let a$1 = eval$(fresh_meta(ctx, pos), ctx.env);
          let b = (x) => {
            let ctx2 = new Context(
              inc(ctx.level),
              listPrepend(a$1, ctx.types),
              listPrepend(x, ctx.env),
              listPrepend(
                ["x", [new TypeMode(), new VSort(new SetSort(), pos)]],
                ctx.scope,
              ),
              listPrepend(new ContextMask(false, new TypeMode()), ctx.mask),
            );
            return eval$(fresh_meta(ctx2, pos), ctx2.env);
          };
          let res = unify(ctx.level, at$1, new VInterT("x", a$1, b, pos));
          if (res instanceof Ok) {
            let $1 = res[0];
            if ($1) {
              let t = b(eval$(a2, ctx.env));
              return new Ok([new Ctor1(new Snd(), a2, pos), t]);
            } else {
              return new Error(
                "projection requires intersection at " + pretty_pos(pos),
              );
            }
          } else {
            let err = res[0];
            return new Error(err);
          }
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
    let eq = s[2];
    let pos = s.pos;
    return $result.try$(
      infer(ctx, inter),
      (_use0) => {
        let inter2 = _use0[0];
        let intert = _use0[1];
        let $ = force(intert);
        if ($ instanceof VInterT) {
          let at = $[1];
          let inter3 = eval$(inter2, ctx.env);
          return $result.try$(
            check(ctx, a, at),
            (a2) => {
              let a3 = eval$(a2, ctx.env);
              return $result.try$(
                check(ctx, eq, new VEq(a3, fst(pos, inter3), at, pos)),
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
  } else if (s instanceof ExFalsoSyntax) {
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
              new Explicit(),
              new VSort(new SetSort(), pos),
              (t) => { return t; },
              pos,
            ),
          ],
        );
      },
    );
  } else {
    let pos = s.pos;
    let x = fresh_meta(ctx, pos);
    let xt = eval$(fresh_meta(ctx, pos), ctx.env);
    return new Ok([x, xt]);
  }
}

function check(ctx, s, ty) {
  let $ = force(ty);
  if (s instanceof LambdaSyntax) {
    if ($ instanceof VPi) {
      let imp1 = s[1];
      let imp2 = $[2];
      if (isEqual(imp1, imp2)) {
        let mode1 = s[0];
        let x = s[2];
        let annot = s[3];
        let body = s[4];
        let pos = s.pos;
        let mode2 = $[1];
        let a = $[3];
        let b = $[4];
        return $result.try$(
          (() => {
            let m1 = mode1;
            let m2 = mode2;
            if (isEqual(m1, m2)) {
              return new Ok(m1);
            } else {
              if (mode2 instanceof TypeMode) {
                if (mode1 instanceof ZeroMode) {
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
              (() => {
                if (annot instanceof Ok) {
                  let xt = annot[0];
                  return $result.try$(
                    infer(ctx, xt),
                    (_use0) => {
                      let xt2 = _use0[0];
                      let xt3 = eval$(xt2, ctx.env);
                      return $result.try$(
                        (() => {
                          let $1 = unify(ctx.level, xt3, a);
                          if ($1 instanceof Ok) {
                            let $2 = $1[0];
                            if ($2) {
                              return new Ok(undefined);
                            } else {
                              return new Error(
                                (("type mismatch: " + pretty_term(xt2)) + " and ") + pretty_value(
                                  a,
                                ),
                              );
                            }
                          } else {
                            let err = $1[0];
                            return new Error(err);
                          }
                        })(),
                        (_) => { return new Ok(undefined); },
                      );
                    },
                  );
                } else {
                  return new Ok(undefined);
                }
              })(),
              (_) => {
                let dummy = new VIdent(x, mode, ctx.level, toList([]), pos);
                let ctx2 = new Context(
                  inc(ctx.level),
                  listPrepend(a, ctx.types),
                  listPrepend(dummy, ctx.env),
                  listPrepend([x, [mode, a]], ctx.scope),
                  listPrepend(new ContextMask(false, mode), ctx.mask),
                );
                return $result.try$(
                  check(ctx2, body, b(dummy)),
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
                          new Binder(new Lambda(mode, imp1), x, body2, pos),
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
        let $1 = $[2];
        if ($1 instanceof Implicit) {
          let t = s;
          let x = $[0];
          let mode = $[1];
          let a = $[3];
          let b = $[4];
          let pos = $[5];
          let dummy = new VIdent(x, mode, ctx.level, toList([]), pos);
          let ctx2 = new Context(
            inc(ctx.level),
            listPrepend(a, ctx.types),
            listPrepend(dummy, ctx.env),
            listPrepend([x, [mode, a]], ctx.scope),
            listPrepend(new ContextMask(false, mode), ctx.mask),
          );
          return $result.try$(
            check(ctx2, t, b(dummy)),
            (body2) => {
              return new Ok(
                new Binder(new Lambda(mode, new Implicit()), x, body2, pos),
              );
            },
          );
        } else {
          let s$1 = s;
          let ty$1 = $;
          return $result.try$(
            infer(ctx, s$1),
            (_use0) => {
              let t = _use0[0];
              let ty2 = _use0[1];
              let $2 = insert(ctx, t, ty2);
              let t$1 = $2[0];
              let ty2$1 = $2[1];
              let $3 = unify(ctx.level, ty$1, ty2$1);
              if ($3 instanceof Ok) {
                let $4 = $3[0];
                if ($4) {
                  return new Ok(t$1);
                } else {
                  return new Error(
                    (((("type mismatch between `" + pretty_value(ty$1)) + "` and `") + pretty_value(
                      ty2$1,
                    )) + "` at ") + pretty_pos($header.get_pos(s$1)),
                  );
                }
              } else {
                let err = $3[0];
                return new Error(err);
              }
            },
          );
        }
      }
    } else {
      let s$1 = s;
      let ty$1 = $;
      return $result.try$(
        infer(ctx, s$1),
        (_use0) => {
          let t = _use0[0];
          let ty2 = _use0[1];
          let $1 = insert(ctx, t, ty2);
          let t$1 = $1[0];
          let ty2$1 = $1[1];
          let $2 = unify(ctx.level, ty$1, ty2$1);
          if ($2 instanceof Ok) {
            let $3 = $2[0];
            if ($3) {
              return new Ok(t$1);
            } else {
              return new Error(
                (((("type mismatch between `" + pretty_value(ty$1)) + "` and `") + pretty_value(
                  ty2$1,
                )) + "` at ") + pretty_pos($header.get_pos(s$1)),
              );
            }
          } else {
            let err = $2[0];
            return new Error(err);
          }
        },
      );
    }
  } else if (s instanceof LetSyntax) {
    if ($ instanceof VPi) {
      let $1 = $[2];
      if ($1 instanceof Implicit) {
        let t = s;
        let x = $[0];
        let mode = $[1];
        let a = $[3];
        let b = $[4];
        let pos = $[5];
        let dummy = new VIdent(x, mode, ctx.level, toList([]), pos);
        let ctx2 = new Context(
          inc(ctx.level),
          listPrepend(a, ctx.types),
          listPrepend(dummy, ctx.env),
          listPrepend([x, [mode, a]], ctx.scope),
          listPrepend(new ContextMask(false, mode), ctx.mask),
        );
        return $result.try$(
          check(ctx2, t, b(dummy)),
          (body2) => {
            return new Ok(
              new Binder(new Lambda(mode, new Implicit()), x, body2, pos),
            );
          },
        );
      } else {
        let ty$1 = $;
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
                let $2 = force(xtt);
                if ($2 instanceof VSort) {
                  return new Ok(undefined);
                } else {
                  return new Error(
                    "type annotation must be a type " + pretty_pos(pos),
                  );
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
                      listPrepend(
                        new ContextMask(true, new ManyMode()),
                        ctx.mask,
                      ),
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
      }
    } else {
      let ty$1 = $;
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
              let $1 = force(xtt);
              if ($1 instanceof VSort) {
                return new Ok(undefined);
              } else {
                return new Error(
                  "type annotation must be a type " + pretty_pos(pos),
                );
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
                    listPrepend(new ContextMask(true, new ManyMode()), ctx.mask),
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
    }
  } else if (s instanceof DefSyntax) {
    if ($ instanceof VPi) {
      let $1 = $[2];
      if ($1 instanceof Implicit) {
        let t = s;
        let x = $[0];
        let mode = $[1];
        let a = $[3];
        let b = $[4];
        let pos = $[5];
        let dummy = new VIdent(x, mode, ctx.level, toList([]), pos);
        let ctx2 = new Context(
          inc(ctx.level),
          listPrepend(a, ctx.types),
          listPrepend(dummy, ctx.env),
          listPrepend([x, [mode, a]], ctx.scope),
          listPrepend(new ContextMask(false, mode), ctx.mask),
        );
        return $result.try$(
          check(ctx2, t, b(dummy)),
          (body2) => {
            return new Ok(
              new Binder(new Lambda(mode, new Implicit()), x, body2, pos),
            );
          },
        );
      } else {
        let ty$1 = $;
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
                let $2 = force(xtt);
                if ($2 instanceof VSort) {
                  return new Ok(undefined);
                } else {
                  return new Error(
                    "type annotation must be a type " + pretty_pos(pos),
                  );
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
                      listPrepend(
                        new ContextMask(true, new ZeroMode()),
                        ctx.mask,
                      ),
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
      }
    } else {
      let ty$1 = $;
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
              let $1 = force(xtt);
              if ($1 instanceof VSort) {
                return new Ok(undefined);
              } else {
                return new Error(
                  "type annotation must be a type " + pretty_pos(pos),
                );
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
                    listPrepend(new ContextMask(true, new ZeroMode()), ctx.mask),
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
    }
  } else if (s instanceof IntersectionSyntax) {
    if ($ instanceof VPi) {
      let $1 = $[2];
      if ($1 instanceof Implicit) {
        let t = s;
        let x = $[0];
        let mode = $[1];
        let a = $[3];
        let b = $[4];
        let pos = $[5];
        let dummy = new VIdent(x, mode, ctx.level, toList([]), pos);
        let ctx2 = new Context(
          inc(ctx.level),
          listPrepend(a, ctx.types),
          listPrepend(dummy, ctx.env),
          listPrepend([x, [mode, a]], ctx.scope),
          listPrepend(new ContextMask(false, mode), ctx.mask),
        );
        return $result.try$(
          check(ctx2, t, b(dummy)),
          (body2) => {
            return new Ok(
              new Binder(new Lambda(mode, new Implicit()), x, body2, pos),
            );
          },
        );
      } else {
        let s$1 = s;
        let ty$1 = $;
        return $result.try$(
          infer(ctx, s$1),
          (_use0) => {
            let t = _use0[0];
            let ty2 = _use0[1];
            let $2 = insert(ctx, t, ty2);
            let t$1 = $2[0];
            let ty2$1 = $2[1];
            let $3 = unify(ctx.level, ty$1, ty2$1);
            if ($3 instanceof Ok) {
              let $4 = $3[0];
              if ($4) {
                return new Ok(t$1);
              } else {
                return new Error(
                  (((("type mismatch between `" + pretty_value(ty$1)) + "` and `") + pretty_value(
                    ty2$1,
                  )) + "` at ") + pretty_pos($header.get_pos(s$1)),
                );
              }
            } else {
              let err = $3[0];
              return new Error(err);
            }
          },
        );
      }
    } else if ($ instanceof VInterT) {
      let a = s[0];
      let b = s[1];
      let pos = s.pos;
      let at = $[1];
      let bt = $[2];
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
                  let $1 = unify(ctx.level, a3, b3);
                  if ($1 instanceof Ok) {
                    let $2 = $1[0];
                    if ($2) {
                      return new Ok(undefined);
                    } else {
                      return new Error(
                        ((((("intersection components must be equal (" + pretty_value(
                          a3,
                        )) + ", ") + pretty_value(b3)) + ", ") + pretty_pos(pos)) + ")",
                      );
                    }
                  } else {
                    let err = $1[0];
                    return new Error(err);
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
      let ty$1 = $;
      return $result.try$(
        infer(ctx, s$1),
        (_use0) => {
          let t = _use0[0];
          let ty2 = _use0[1];
          let $1 = insert(ctx, t, ty2);
          let t$1 = $1[0];
          let ty2$1 = $1[1];
          let $2 = unify(ctx.level, ty$1, ty2$1);
          if ($2 instanceof Ok) {
            let $3 = $2[0];
            if ($3) {
              return new Ok(t$1);
            } else {
              return new Error(
                (((("type mismatch between `" + pretty_value(ty$1)) + "` and `") + pretty_value(
                  ty2$1,
                )) + "` at ") + pretty_pos($header.get_pos(s$1)),
              );
            }
          } else {
            let err = $2[0];
            return new Error(err);
          }
        },
      );
    }
  } else if (s instanceof ReflSyntax) {
    if ($ instanceof VPi) {
      let $1 = $[2];
      if ($1 instanceof Implicit) {
        let t = s;
        let x = $[0];
        let mode = $[1];
        let a = $[3];
        let b = $[4];
        let pos = $[5];
        let dummy = new VIdent(x, mode, ctx.level, toList([]), pos);
        let ctx2 = new Context(
          inc(ctx.level),
          listPrepend(a, ctx.types),
          listPrepend(dummy, ctx.env),
          listPrepend([x, [mode, a]], ctx.scope),
          listPrepend(new ContextMask(false, mode), ctx.mask),
        );
        return $result.try$(
          check(ctx2, t, b(dummy)),
          (body2) => {
            return new Ok(
              new Binder(new Lambda(mode, new Implicit()), x, body2, pos),
            );
          },
        );
      } else {
        let s$1 = s;
        let ty$1 = $;
        return $result.try$(
          infer(ctx, s$1),
          (_use0) => {
            let t = _use0[0];
            let ty2 = _use0[1];
            let $2 = insert(ctx, t, ty2);
            let t$1 = $2[0];
            let ty2$1 = $2[1];
            let $3 = unify(ctx.level, ty$1, ty2$1);
            if ($3 instanceof Ok) {
              let $4 = $3[0];
              if ($4) {
                return new Ok(t$1);
              } else {
                return new Error(
                  (((("type mismatch between `" + pretty_value(ty$1)) + "` and `") + pretty_value(
                    ty2$1,
                  )) + "` at ") + pretty_pos($header.get_pos(s$1)),
                );
              }
            } else {
              let err = $3[0];
              return new Error(err);
            }
          },
        );
      }
    } else if ($ instanceof VEq) {
      let x = s[0];
      let pos = s.pos;
      let a = $[0];
      let b = $[1];
      return $result.try$(
        infer(ctx, x),
        (_use0) => {
          let x2 = _use0[0];
          let x3 = eval$(x2, ctx.env);
          return $result.try$(
            (() => {
              let $1 = unify(ctx.level, x3, a);
              if ($1 instanceof Ok) {
                let $2 = $1[0];
                if ($2) {
                  let $3 = unify(ctx.level, x3, b);
                  if ($3 instanceof Ok) {
                    let $4 = $3[0];
                    if ($4) {
                      return new Ok(undefined);
                    } else {
                      return new Error(
                        (((("type mismatch between " + pretty_value(x3)) + " and ") + pretty_value(
                          b,
                        )) + " at ") + pretty_pos(pos),
                      );
                    }
                  } else {
                    let err = $3[0];
                    return new Error(err);
                  }
                } else {
                  return new Error(
                    (((("type mismatch between " + pretty_value(x3)) + " and ") + pretty_value(
                      a,
                    )) + " at ") + pretty_pos(pos),
                  );
                }
              } else {
                let err = $1[0];
                return new Error(err);
              }
            })(),
            (_) => { return new Ok(new Ctor1(new Refl(), x2, pos)); },
          );
        },
      );
    } else {
      let s$1 = s;
      let ty$1 = $;
      return $result.try$(
        infer(ctx, s$1),
        (_use0) => {
          let t = _use0[0];
          let ty2 = _use0[1];
          let $1 = insert(ctx, t, ty2);
          let t$1 = $1[0];
          let ty2$1 = $1[1];
          let $2 = unify(ctx.level, ty$1, ty2$1);
          if ($2 instanceof Ok) {
            let $3 = $2[0];
            if ($3) {
              return new Ok(t$1);
            } else {
              return new Error(
                (((("type mismatch between `" + pretty_value(ty$1)) + "` and `") + pretty_value(
                  ty2$1,
                )) + "` at ") + pretty_pos($header.get_pos(s$1)),
              );
            }
          } else {
            let err = $2[0];
            return new Error(err);
          }
        },
      );
    }
  } else if (s instanceof CastSyntax) {
    if ($ instanceof VPi) {
      let $1 = $[2];
      if ($1 instanceof Implicit) {
        let t = s;
        let x = $[0];
        let mode = $[1];
        let a = $[3];
        let b = $[4];
        let pos = $[5];
        let dummy = new VIdent(x, mode, ctx.level, toList([]), pos);
        let ctx2 = new Context(
          inc(ctx.level),
          listPrepend(a, ctx.types),
          listPrepend(dummy, ctx.env),
          listPrepend([x, [mode, a]], ctx.scope),
          listPrepend(new ContextMask(false, mode), ctx.mask),
        );
        return $result.try$(
          check(ctx2, t, b(dummy)),
          (body2) => {
            return new Ok(
              new Binder(new Lambda(mode, new Implicit()), x, body2, pos),
            );
          },
        );
      } else {
        let s$1 = s;
        let ty$1 = $;
        return $result.try$(
          infer(ctx, s$1),
          (_use0) => {
            let t = _use0[0];
            let ty2 = _use0[1];
            let $2 = insert(ctx, t, ty2);
            let t$1 = $2[0];
            let ty2$1 = $2[1];
            let $3 = unify(ctx.level, ty$1, ty2$1);
            if ($3 instanceof Ok) {
              let $4 = $3[0];
              if ($4) {
                return new Ok(t$1);
              } else {
                return new Error(
                  (((("type mismatch between `" + pretty_value(ty$1)) + "` and `") + pretty_value(
                    ty2$1,
                  )) + "` at ") + pretty_pos($header.get_pos(s$1)),
                );
              }
            } else {
              let err = $3[0];
              return new Error(err);
            }
          },
        );
      }
    } else if ($ instanceof VInterT) {
      let intert = $;
      let a = s[0];
      let inter = s[1];
      let eq = s[2];
      let pos = s.pos;
      let at = $[1];
      return $result.try$(
        check(ctx, a, at),
        (a2) => {
          let a3 = eval$(a2, ctx.env);
          return $result.try$(
            check(ctx, inter, intert),
            (inter2) => {
              let inter3 = eval$(inter2, ctx.env);
              return $result.try$(
                check(ctx, eq, new VEq(a3, fst(pos, inter3), at, pos)),
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
      let ty$1 = $;
      return $result.try$(
        infer(ctx, s$1),
        (_use0) => {
          let t = _use0[0];
          let ty2 = _use0[1];
          let $1 = insert(ctx, t, ty2);
          let t$1 = $1[0];
          let ty2$1 = $1[1];
          let $2 = unify(ctx.level, ty$1, ty2$1);
          if ($2 instanceof Ok) {
            let $3 = $2[0];
            if ($3) {
              return new Ok(t$1);
            } else {
              return new Error(
                (((("type mismatch between `" + pretty_value(ty$1)) + "` and `") + pretty_value(
                  ty2$1,
                )) + "` at ") + pretty_pos($header.get_pos(s$1)),
              );
            }
          } else {
            let err = $2[0];
            return new Error(err);
          }
        },
      );
    }
  } else if ($ instanceof VPi) {
    let $1 = $[2];
    if ($1 instanceof Implicit) {
      let t = s;
      let x = $[0];
      let mode = $[1];
      let a = $[3];
      let b = $[4];
      let pos = $[5];
      let dummy = new VIdent(x, mode, ctx.level, toList([]), pos);
      let ctx2 = new Context(
        inc(ctx.level),
        listPrepend(a, ctx.types),
        listPrepend(dummy, ctx.env),
        listPrepend([x, [mode, a]], ctx.scope),
        listPrepend(new ContextMask(false, mode), ctx.mask),
      );
      return $result.try$(
        check(ctx2, t, b(dummy)),
        (body2) => {
          return new Ok(
            new Binder(new Lambda(mode, new Implicit()), x, body2, pos),
          );
        },
      );
    } else {
      let s$1 = s;
      let ty$1 = $;
      return $result.try$(
        infer(ctx, s$1),
        (_use0) => {
          let t = _use0[0];
          let ty2 = _use0[1];
          let $2 = insert(ctx, t, ty2);
          let t$1 = $2[0];
          let ty2$1 = $2[1];
          let $3 = unify(ctx.level, ty$1, ty2$1);
          if ($3 instanceof Ok) {
            let $4 = $3[0];
            if ($4) {
              return new Ok(t$1);
            } else {
              return new Error(
                (((("type mismatch between `" + pretty_value(ty$1)) + "` and `") + pretty_value(
                  ty2$1,
                )) + "` at ") + pretty_pos($header.get_pos(s$1)),
              );
            }
          } else {
            let err = $3[0];
            return new Error(err);
          }
        },
      );
    }
  } else {
    let s$1 = s;
    let ty$1 = $;
    return $result.try$(
      infer(ctx, s$1),
      (_use0) => {
        let t = _use0[0];
        let ty2 = _use0[1];
        let $1 = insert(ctx, t, ty2);
        let t$1 = $1[0];
        let ty2$1 = $1[1];
        let $2 = unify(ctx.level, ty$1, ty2$1);
        if ($2 instanceof Ok) {
          let $3 = $2[0];
          if ($3) {
            return new Ok(t$1);
          } else {
            return new Error(
              (((("type mismatch between `" + pretty_value(ty$1)) + "` and `") + pretty_value(
                ty2$1,
              )) + "` at ") + pretty_pos($header.get_pos(s$1)),
            );
          }
        } else {
          let err = $2[0];
          return new Error(err);
        }
      },
    );
  }
}

function unify_spines(loop$lvl, loop$spine1, loop$spine2) {
  while (true) {
    let lvl = loop$lvl;
    let spine1 = loop$spine1;
    let spine2 = loop$spine2;
    if (spine2 instanceof $Empty) {
      if (spine1 instanceof $Empty) {
        return new Ok(true);
      } else {
        return new Ok(false);
      }
    } else {
      let $ = spine2.head;
      if ($ instanceof VApp) {
        if (spine1 instanceof $Empty) {
          return new Ok(false);
        } else {
          let $1 = spine1.head;
          if ($1 instanceof VApp) {
            let rest2 = spine2.tail;
            let mode2 = $[0];
            let icit2 = $[1];
            let arg2 = $[2];
            let rest1 = spine1.tail;
            let mode1 = $1[0];
            let icit1 = $1[1];
            let arg1 = $1[2];
            let _pipe = new Ok(isEqual(mode1, mode2));
            let _pipe$1 = and(_pipe, new Ok(isEqual(icit1, icit2)));
            let _pipe$2 = and(_pipe$1, unify_helper(lvl, arg1, arg2));
            return and(_pipe$2, unify_spines(lvl, rest1, rest2));
          } else {
            return new Ok(false);
          }
        }
      } else if ($ instanceof VPsi) {
        if (spine1 instanceof $Empty) {
          return new Ok(false);
        } else {
          let $1 = spine1.head;
          if ($1 instanceof VPsi) {
            let rest2 = spine2.tail;
            let pred2 = $[0];
            let rest1 = spine1.tail;
            let pred1 = $1[0];
            let _pipe = unify_helper(lvl, pred1, pred2);
            return and(_pipe, unify_spines(lvl, rest1, rest2));
          } else {
            return new Ok(false);
          }
        }
      } else if ($ instanceof VFst) {
        if (spine1 instanceof $Empty) {
          return new Ok(false);
        } else {
          let $1 = spine1.head;
          if ($1 instanceof VFst) {
            let rest2 = spine2.tail;
            let rest1 = spine1.tail;
            loop$lvl = lvl;
            loop$spine1 = rest1;
            loop$spine2 = rest2;
          } else {
            return new Ok(false);
          }
        }
      } else if (spine1 instanceof $Empty) {
        return new Ok(false);
      } else {
        let $1 = spine1.head;
        if ($1 instanceof VSnd) {
          let rest2 = spine2.tail;
          let rest1 = spine1.tail;
          loop$lvl = lvl;
          loop$spine1 = rest1;
          loop$spine2 = rest2;
        } else {
          return new Ok(false);
        }
      }
    }
  }
}

function unify_helper(loop$lvl, loop$a, loop$b) {
  while (true) {
    let lvl = loop$lvl;
    let a = loop$a;
    let b = loop$b;
    let uh = (a, b) => { return unify_helper(lvl, a, b); };
    let $ = force(a);
    let $1 = force(b);
    if ($1 instanceof VIdent) {
      if ($ instanceof VIdent) {
        let j = $1[2];
        let spine2 = $1[3];
        let i = $[2];
        let spine1 = $[3];
        let _pipe = new Ok(isEqual(i, j));
        return and(_pipe, unify_spines(lvl, spine1, spine2));
      } else if ($ instanceof VMeta) {
        let t = $1;
        let m = $[0];
        let sp = $[2];
        return solve(lvl, m, sp, t);
      } else if ($ instanceof VLambda) {
        let b$1 = $1;
        let x = $[0];
        let m = $[1];
        let icit = $[2];
        let f = $[3];
        let pos = $[4];
        let dummy = new VIdent(x, m, lvl, toList([]), pos);
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(pos, m, icit, b$1, dummy);
      } else {
        return new Ok(false);
      }
    } else if ($1 instanceof VMeta) {
      if ($ instanceof VMeta) {
        let meta2 = $1;
        let m2 = $1[0];
        let spine2 = $1[2];
        let m1 = $[0];
        let spine1 = $[2];
        let $2 = get(m1);
        let $3 = get(m2);
        if ($3 instanceof Unsolved) {
          if ($2 instanceof Unsolved) {
            let j = $3[0];
            let i = $2[0];
            if (i === j) {
              return unify_spines(lvl, spine1, spine2);
            } else {
              return solve(lvl, m1, spine1, meta2);
            }
          } else {
            throw makeError(
              "panic",
              FILEPATH,
              "client/candle/elab",
              455,
              "unify_helper",
              "`panic` expression evaluated.",
              {}
            )
          }
        } else {
          throw makeError(
            "panic",
            FILEPATH,
            "client/candle/elab",
            455,
            "unify_helper",
            "`panic` expression evaluated.",
            {}
          )
        }
      } else if ($ instanceof VLambda) {
        let t = $;
        let m = $1[0];
        let sp = $1[2];
        return solve(lvl, m, sp, t);
      } else {
        let t = $;
        let m = $1[0];
        let sp = $1[2];
        return solve(lvl, m, sp, t);
      }
    } else if ($1 instanceof VSort) {
      if ($ instanceof VMeta) {
        let t = $1;
        let m = $[0];
        let sp = $[2];
        return solve(lvl, m, sp, t);
      } else if ($ instanceof VSort) {
        let s2 = $1[0];
        let s1 = $[0];
        return new Ok(isEqual(s1, s2));
      } else if ($ instanceof VLambda) {
        let b$1 = $1;
        let x = $[0];
        let m = $[1];
        let icit = $[2];
        let f = $[3];
        let pos = $[4];
        let dummy = new VIdent(x, m, lvl, toList([]), pos);
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(pos, m, icit, b$1, dummy);
      } else {
        return new Ok(false);
      }
    } else if ($1 instanceof VNat) {
      if ($ instanceof VMeta) {
        let t = $1;
        let m = $[0];
        let sp = $[2];
        return solve(lvl, m, sp, t);
      } else if ($ instanceof VNat) {
        let m = $1[0];
        let n = $[0];
        return new Ok(n === m);
      } else if ($ instanceof VLambda) {
        let b$1 = $1;
        let x = $[0];
        let m = $[1];
        let icit = $[2];
        let f = $[3];
        let pos = $[4];
        let dummy = new VIdent(x, m, lvl, toList([]), pos);
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(pos, m, icit, b$1, dummy);
      } else {
        return new Ok(false);
      }
    } else if ($1 instanceof VNatType) {
      if ($ instanceof VMeta) {
        let t = $1;
        let m = $[0];
        let sp = $[2];
        return solve(lvl, m, sp, t);
      } else if ($ instanceof VNatType) {
        return new Ok(true);
      } else if ($ instanceof VLambda) {
        let b$1 = $1;
        let x = $[0];
        let m = $[1];
        let icit = $[2];
        let f = $[3];
        let pos = $[4];
        let dummy = new VIdent(x, m, lvl, toList([]), pos);
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(pos, m, icit, b$1, dummy);
      } else {
        return new Ok(false);
      }
    } else if ($1 instanceof VPi) {
      if ($ instanceof VMeta) {
        let t = $1;
        let m = $[0];
        let sp = $[2];
        return solve(lvl, m, sp, t);
      } else if ($ instanceof VPi) {
        let m2 = $1[1];
        let imp2 = $1[2];
        let t2 = $1[3];
        let u2 = $1[4];
        let x = $[0];
        let m1 = $[1];
        let imp1 = $[2];
        let t1 = $[3];
        let u1 = $[4];
        let pos = $[5];
        let dummy = new VIdent(x, m1, lvl, toList([]), pos);
        let _pipe = new Ok(isEqual(m1, m2));
        let _pipe$1 = and(_pipe, new Ok(isEqual(imp1, imp2)));
        let _pipe$2 = and(_pipe$1, uh(t1, t2));
        return and(_pipe$2, unify_helper(inc(lvl), u1(dummy), u2(dummy)));
      } else if ($ instanceof VLambda) {
        let b$1 = $1;
        let x = $[0];
        let m = $[1];
        let icit = $[2];
        let f = $[3];
        let pos = $[4];
        let dummy = new VIdent(x, m, lvl, toList([]), pos);
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(pos, m, icit, b$1, dummy);
      } else {
        return new Ok(false);
      }
    } else if ($1 instanceof VLambda) {
      if ($ instanceof VMeta) {
        let t = $1;
        let m = $[0];
        let sp = $[2];
        return solve(lvl, m, sp, t);
      } else if ($ instanceof VLambda) {
        let b$1 = $1;
        let x = $[0];
        let m = $[1];
        let icit = $[2];
        let f = $[3];
        let pos = $[4];
        let dummy = new VIdent(x, m, lvl, toList([]), pos);
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(pos, m, icit, b$1, dummy);
      } else {
        let a$1 = $;
        let x = $1[0];
        let m = $1[1];
        let icit = $1[2];
        let f = $1[3];
        let pos = $1[4];
        let dummy = new VIdent(x, m, lvl, toList([]), pos);
        loop$lvl = inc(lvl);
        loop$a = app(pos, m, icit, a$1, dummy);
        loop$b = f(dummy);
      }
    } else if ($1 instanceof VEq) {
      if ($ instanceof VMeta) {
        let t = $1;
        let m = $[0];
        let sp = $[2];
        return solve(lvl, m, sp, t);
      } else if ($ instanceof VLambda) {
        let b$1 = $1;
        let x = $[0];
        let m = $[1];
        let icit = $[2];
        let f = $[3];
        let pos = $[4];
        let dummy = new VIdent(x, m, lvl, toList([]), pos);
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(pos, m, icit, b$1, dummy);
      } else if ($ instanceof VEq) {
        let a2 = $1[0];
        let b2 = $1[1];
        let t2 = $1[2];
        let a1 = $[0];
        let b1 = $[1];
        let t1 = $[2];
        let _pipe = uh(a1, a2);
        let _pipe$1 = and(_pipe, uh(b1, b2));
        return and(_pipe$1, uh(t1, t2));
      } else {
        return new Ok(false);
      }
    } else if ($1 instanceof VRefl) {
      if ($ instanceof VMeta) {
        let t = $1;
        let m = $[0];
        let sp = $[2];
        return solve(lvl, m, sp, t);
      } else if ($ instanceof VLambda) {
        let b$1 = $1;
        let x = $[0];
        let m = $[1];
        let icit = $[2];
        let f = $[3];
        let pos = $[4];
        let dummy = new VIdent(x, m, lvl, toList([]), pos);
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(pos, m, icit, b$1, dummy);
      } else if ($ instanceof VRefl) {
        let a2 = $1[0];
        let a1 = $[0];
        return uh(a1, a2);
      } else {
        return new Ok(false);
      }
    } else if ($1 instanceof VInter) {
      if ($ instanceof VMeta) {
        let t = $1;
        let m = $[0];
        let sp = $[2];
        return solve(lvl, m, sp, t);
      } else if ($ instanceof VLambda) {
        let b$1 = $1;
        let x = $[0];
        let m = $[1];
        let icit = $[2];
        let f = $[3];
        let pos = $[4];
        let dummy = new VIdent(x, m, lvl, toList([]), pos);
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(pos, m, icit, b$1, dummy);
      } else if ($ instanceof VInter) {
        let a2 = $1[0];
        let b2 = $1[1];
        let a1 = $[0];
        let b1 = $[1];
        let _pipe = uh(a1, a2);
        return and(_pipe, uh(b1, b2));
      } else {
        return new Ok(false);
      }
    } else if ($1 instanceof VInterT) {
      if ($ instanceof VMeta) {
        let t = $1;
        let m = $[0];
        let sp = $[2];
        return solve(lvl, m, sp, t);
      } else if ($ instanceof VLambda) {
        let b$1 = $1;
        let x = $[0];
        let m = $[1];
        let icit = $[2];
        let f = $[3];
        let pos = $[4];
        let dummy = new VIdent(x, m, lvl, toList([]), pos);
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(pos, m, icit, b$1, dummy);
      } else if ($ instanceof VInterT) {
        let a2 = $1[1];
        let b2 = $1[2];
        let x = $[0];
        let a1 = $[1];
        let b1 = $[2];
        let pos = $[3];
        let dummy = new VIdent(x, new TypeMode(), lvl, toList([]), pos);
        let _pipe = uh(a1, a2);
        return and(_pipe, unify_helper(inc(lvl), b1(dummy), b2(dummy)));
      } else {
        return new Ok(false);
      }
    } else if ($1 instanceof VCast) {
      if ($ instanceof VMeta) {
        let t = $1;
        let m = $[0];
        let sp = $[2];
        return solve(lvl, m, sp, t);
      } else if ($ instanceof VLambda) {
        let b$1 = $1;
        let x = $[0];
        let m = $[1];
        let icit = $[2];
        let f = $[3];
        let pos = $[4];
        let dummy = new VIdent(x, m, lvl, toList([]), pos);
        loop$lvl = inc(lvl);
        loop$a = f(dummy);
        loop$b = app(pos, m, icit, b$1, dummy);
      } else if ($ instanceof VCast) {
        let a2 = $1[0];
        let inter2 = $1[1];
        let eq2 = $1[2];
        let a1 = $[0];
        let inter1 = $[1];
        let eq1 = $[2];
        let _pipe = uh(a1, a2);
        let _pipe$1 = and(_pipe, uh(inter1, inter2));
        return and(_pipe$1, uh(eq1, eq2));
      } else {
        return new Ok(false);
      }
    } else if ($ instanceof VMeta) {
      let t = $1;
      let m = $[0];
      let sp = $[2];
      return solve(lvl, m, sp, t);
    } else if ($ instanceof VLambda) {
      let b$1 = $1;
      let x = $[0];
      let m = $[1];
      let icit = $[2];
      let f = $[3];
      let pos = $[4];
      let dummy = new VIdent(x, m, lvl, toList([]), pos);
      loop$lvl = inc(lvl);
      loop$a = f(dummy);
      loop$b = app(pos, m, icit, b$1, dummy);
    } else if ($ instanceof VExFalso) {
      let a2 = $1[0];
      let a1 = $[0];
      return uh(a1, a2);
    } else {
      return new Ok(false);
    }
  }
}

function rename_spine(meta, pr, base, rev_spine) {
  if (rev_spine instanceof $Empty) {
    return new Ok(base);
  } else {
    let $ = rev_spine.head;
    if ($ instanceof VApp) {
      let rest = rev_spine.tail;
      let mode = $[0];
      let icit = $[1];
      let arg = $[2];
      let pos = $[3];
      return $result.try$(
        rename_spine(meta, pr, base, rest),
        (base2) => {
          return $result.try$(
            rename(meta, pr, arg),
            (arg2) => {
              return new Ok(new Ctor2(new App(mode, icit), base2, arg2, pos));
            },
          );
        },
      );
    } else if ($ instanceof VPsi) {
      let rest = rev_spine.tail;
      let pred = $[0];
      let pos = $[1];
      return $result.try$(
        rename_spine(meta, pr, base, rest),
        (base2) => {
          return $result.try$(
            rename(meta, pr, pred),
            (pred2) => {
              return new Ok(new Ctor2(new Psi(), base2, pred2, pos));
            },
          );
        },
      );
    } else if ($ instanceof VFst) {
      let rest = rev_spine.tail;
      let pos = $[0];
      return $result.try$(
        rename_spine(meta, pr, base, rest),
        (base2) => { return new Ok(new Ctor1(new Fst(), base2, pos)); },
      );
    } else {
      let rest = rev_spine.tail;
      let pos = $[0];
      return $result.try$(
        rename_spine(meta, pr, base, rest),
        (base2) => { return new Ok(new Ctor1(new Snd(), base2, pos)); },
      );
    }
  }
}

function rename(meta, pr, v) {
  let $ = force(v);
  if ($ instanceof VIdent) {
    let x = $[0];
    let mode = $[1];
    let lvl = $[2];
    let spine = $[3];
    let pos = $[4];
    let $1 = $dict.get(pr.renaming, lvl);
    if ($1 instanceof Ok) {
      let lvl2 = $1[0];
      return rename_spine(
        meta,
        pr,
        new Ident(mode, lvl_to_idx(pr.domain_size, lvl2), x, pos),
        $list.reverse(spine),
      );
    } else {
      return new Error(
        (("unify error: variable " + x) + " escaping scope at ") + pretty_pos(
          pos,
        ),
      );
    }
  } else if ($ instanceof VMeta) {
    let ref = $[0];
    let spine = $[2];
    let pos = $[3];
    let $1 = get(ref);
    let $2 = get(meta);
    if ($2 instanceof Unsolved) {
      if ($1 instanceof Unsolved) {
        let j = $2[0];
        let i = $1[0];
        if (i === j) {
          return new Error(
            "unify error: occurs check failure at " + pretty_pos(pos),
          );
        } else {
          return rename_spine(
            meta,
            pr,
            new Ctor0(new Meta(ref), pos),
            $list.reverse(spine),
          );
        }
      } else {
        throw makeError(
          "panic",
          FILEPATH,
          "client/candle/elab",
          300,
          "rename",
          "`panic` expression evaluated.",
          {}
        )
      }
    } else {
      throw makeError(
        "panic",
        FILEPATH,
        "client/candle/elab",
        300,
        "rename",
        "`panic` expression evaluated.",
        {}
      )
    }
  } else if ($ instanceof VSort) {
    let s = $[0];
    let pos = $[1];
    return new Ok(new Ctor0(new Sort(s), pos));
  } else if ($ instanceof VNat) {
    let n = $[0];
    let pos = $[1];
    return new Ok(new Ctor0(new Nat(n), pos));
  } else if ($ instanceof VNatType) {
    let pos = $[0];
    return new Ok(new Ctor0(new NatT(), pos));
  } else if ($ instanceof VPi) {
    let x = $[0];
    let mode = $[1];
    let imp = $[2];
    let a = $[3];
    let b = $[4];
    let pos = $[5];
    return $result.try$(
      rename(meta, pr, a),
      (a2) => {
        return $result.try$(
          rename(
            meta,
            lift(pr),
            b(new VIdent(x, mode, pr.codomain_size, toList([]), pos)),
          ),
          (b2) => {
            return new Ok(new Binder(new Pi(mode, imp, a2), x, b2, pos));
          },
        );
      },
    );
  } else if ($ instanceof VLambda) {
    let x = $[0];
    let mode = $[1];
    let imp = $[2];
    let e = $[3];
    let pos = $[4];
    return $result.try$(
      rename(
        meta,
        lift(pr),
        e(new VIdent(x, mode, pr.codomain_size, toList([]), pos)),
      ),
      (e2) => { return new Ok(new Binder(new Lambda(mode, imp), x, e2, pos)); },
    );
  } else if ($ instanceof VEq) {
    let a = $[0];
    let b = $[1];
    let t = $[2];
    let pos = $[3];
    return $result.try$(
      rename(meta, pr, a),
      (a2) => {
        return $result.try$(
          rename(meta, pr, b),
          (b2) => {
            return $result.try$(
              rename(meta, pr, t),
              (t2) => { return new Ok(new Ctor3(new Eq(), a2, b2, t2, pos)); },
            );
          },
        );
      },
    );
  } else if ($ instanceof VRefl) {
    let a = $[0];
    let pos = $[1];
    return $result.try$(
      rename(meta, pr, a),
      (a2) => { return new Ok(new Ctor1(new Refl(), a2, pos)); },
    );
  } else if ($ instanceof VInter) {
    let a = $[0];
    let b = $[1];
    let pos = $[2];
    return $result.try$(
      rename(meta, pr, a),
      (a2) => {
        return $result.try$(
          rename(meta, pr, b),
          (b2) => { return new Ok(new Ctor2(new Inter(), a2, b2, pos)); },
        );
      },
    );
  } else if ($ instanceof VInterT) {
    let x = $[0];
    let a = $[1];
    let b = $[2];
    let pos = $[3];
    return $result.try$(
      rename(meta, pr, a),
      (a2) => {
        return $result.try$(
          rename(
            meta,
            lift(pr),
            b(new VIdent(x, new TypeMode(), pr.codomain_size, toList([]), pos)),
          ),
          (b2) => { return new Ok(new Binder(new InterT(a2), x, b2, pos)); },
        );
      },
    );
  } else if ($ instanceof VCast) {
    let a = $[0];
    let b = $[1];
    let c = $[2];
    let pos = $[3];
    return $result.try$(
      rename(meta, pr, a),
      (a2) => {
        return $result.try$(
          rename(meta, pr, b),
          (b2) => {
            return $result.try$(
              rename(meta, pr, c),
              (c2) => { return new Ok(new Ctor3(new Cast(), a2, b2, c2, pos)); },
            );
          },
        );
      },
    );
  } else {
    let a = $[0];
    let pos = $[1];
    return $result.try$(
      rename(meta, pr, a),
      (a2) => { return new Ok(new Ctor1(new ExFalso(), a2, pos)); },
    );
  }
}

function erase(loop$t) {
  while (true) {
    let t = loop$t;
    let $ = force(t);
    if ($ instanceof VIdent) {
      let x = $[0];
      let mode = $[1];
      let lvl = $[2];
      let spine = $[3];
      let pos = $[4];
      return new VIdent(x, mode, lvl, erase_spine(spine), pos);
    } else if ($ instanceof VMeta) {
      let ref = $[0];
      let spine = $[2];
      let pos = $[3];
      return new VMeta(ref, true, spine, pos);
    } else if ($ instanceof VSort) {
      return t;
    } else if ($ instanceof VNat) {
      return t;
    } else if ($ instanceof VNatType) {
      return t;
    } else if ($ instanceof VPi) {
      let x = $[0];
      let mode = $[1];
      let imp = $[2];
      let a = $[3];
      let b = $[4];
      let p = $[5];
      return new VPi(
        x,
        mode,
        imp,
        erase(a),
        (arg) => { return erase(b(arg)); },
        p,
      );
    } else if ($ instanceof VLambda) {
      let $1 = $[1];
      if ($1 instanceof ZeroMode) {
        let e = $[3];
        let p = $[4];
        loop$t = e(new VIdent("", new ZeroMode(), new Level(0), toList([]), p));
      } else {
        let x = $[0];
        let mode = $1;
        let imp = $[2];
        let e = $[3];
        let p = $[4];
        return new VLambda(x, mode, imp, (arg) => { return erase(e(arg)); }, p);
      }
    } else if ($ instanceof VEq) {
      let a = $[0];
      let b = $[1];
      let t$1 = $[2];
      let p = $[3];
      return new VEq(erase(a), erase(b), erase(t$1), p);
    } else if ($ instanceof VRefl) {
      let p = $[1];
      return new VLambda(
        "x",
        new ManyMode(),
        new Explicit(),
        (x) => { return x; },
        p,
      );
    } else if ($ instanceof VInter) {
      let a = $[0];
      loop$t = a;
    } else if ($ instanceof VInterT) {
      let x = $[0];
      let a = $[1];
      let b = $[2];
      let p = $[3];
      return new VInterT(x, erase(a), (arg) => { return erase(b(arg)); }, p);
    } else if ($ instanceof VCast) {
      let a = $[0];
      loop$t = a;
    } else {
      let a = $[0];
      loop$t = a;
    }
  }
}

export function force(loop$v) {
  while (true) {
    let v = loop$v;
    if (v instanceof VMeta) {
      let meta = v;
      let ref = v[0];
      let erased = v[1];
      let spine = v[2];
      let $ = get(ref);
      if ($ instanceof Solved) {
        if (erased) {
          let v$1 = $[0];
          loop$v = erase(apply_spine(v$1, spine));
        } else {
          let v$1 = $[0];
          loop$v = apply_spine(v$1, spine);
        }
      } else {
        return meta;
      }
    } else {
      return v;
    }
  }
}

function erase_spine(loop$spine) {
  while (true) {
    let spine = loop$spine;
    if (spine instanceof $Empty) {
      return toList([]);
    } else {
      let $ = spine.head;
      if ($ instanceof VApp) {
        let $1 = $[0];
        if ($1 instanceof ZeroMode) {
          let rest = spine.tail;
          loop$spine = rest;
        } else {
          let rest = spine.tail;
          let mode = $1;
          let icit = $[1];
          let arg = $[2];
          let pos = $[3];
          return listPrepend(
            new VApp(mode, icit, erase(arg), pos),
            erase_spine(rest),
          );
        }
      } else {
        let rest = spine.tail;
        loop$spine = rest;
      }
    }
  }
}

function app(pos, mode, icit, foo, bar) {
  let $ = force(foo);
  if ($ instanceof VIdent) {
    let x = $[0];
    let mode2 = $[1];
    let lvl = $[2];
    let spine = $[3];
    let pos2 = $[4];
    return new VIdent(
      x,
      mode2,
      lvl,
      $list.append(spine, toList([new VApp(mode, icit, bar, pos)])),
      pos2,
    );
  } else if ($ instanceof VMeta) {
    let ref = $[0];
    let erased = $[1];
    let spine = $[2];
    let pos2 = $[3];
    return new VMeta(
      ref,
      erased,
      $list.append(spine, toList([new VApp(mode, icit, bar, pos)])),
      pos2,
    );
  } else if ($ instanceof VLambda) {
    let f = $[3];
    return f(bar);
  } else {
    let v = $;
    throw makeError(
      "panic",
      FILEPATH,
      "client/candle/elab",
      79,
      "app",
      ((("impossible value application " + pretty_value(v)) + " ") + pretty_pos(
        $header.value_pos(v),
      )),
      {}
    )
  }
}

function apps(loop$pos, loop$foo, loop$env, loop$mask) {
  while (true) {
    let pos = loop$pos;
    let foo = loop$foo;
    let env = loop$env;
    let mask = loop$mask;
    if (mask instanceof $Empty) {
      if (env instanceof $Empty) {
        return foo;
      } else {
        let _block;
        {
          echo($list.length(env), "src/client/candle/elab.gleam", 102);
          echo($list.length(mask), "src/client/candle/elab.gleam", 103);
          _block = "";
        }
        throw makeError(
          "panic",
          FILEPATH,
          "client/candle/elab",
          101,
          "apps",
          _block,
          {}
        )
      }
    } else {
      let $ = mask.head.has_def;
      if ($) {
        if (env instanceof $Empty) {
          let _block;
          {
            echo($list.length(env), "src/client/candle/elab.gleam", 102);
            echo($list.length(mask), "src/client/candle/elab.gleam", 103);
            _block = "";
          }
          throw makeError(
            "panic",
            FILEPATH,
            "client/candle/elab",
            101,
            "apps",
            _block,
            {}
          )
        } else {
          let mask2 = mask.tail;
          let env2 = env.tail;
          loop$pos = pos;
          loop$foo = foo;
          loop$env = env2;
          loop$mask = mask2;
        }
      } else if (env instanceof $Empty) {
        let _block;
        {
          echo($list.length(env), "src/client/candle/elab.gleam", 102);
          echo($list.length(mask), "src/client/candle/elab.gleam", 103);
          _block = "";
        }
        throw makeError(
          "panic",
          FILEPATH,
          "client/candle/elab",
          101,
          "apps",
          _block,
          {}
        )
      } else {
        let mask2 = mask.tail;
        let mode = mask.head.mode;
        let v = env.head;
        let env2 = env.tail;
        return app(pos, mode, new Explicit(), apps(pos, foo, env2, mask2), v);
      }
    }
  }
}

function psi(pos, eq, pred) {
  let $ = force(eq);
  if ($ instanceof VIdent) {
    let x = $[0];
    let mode = $[1];
    let lvl = $[2];
    let spine = $[3];
    let pos2 = $[4];
    return new VIdent(
      x,
      mode,
      lvl,
      $list.append(spine, toList([new VPsi(pred, pos)])),
      pos2,
    );
  } else if ($ instanceof VMeta) {
    let ref = $[0];
    let erased = $[1];
    let spine = $[2];
    let pos2 = $[3];
    return new VMeta(
      ref,
      erased,
      $list.append(spine, toList([new VPsi(pred, pos)])),
      pos2,
    );
  } else if ($ instanceof VRefl) {
    return new VLambda(
      "x",
      new ManyMode(),
      new Explicit(),
      (x) => { return x; },
      pos,
    );
  } else {
    throw makeError(
      "panic",
      FILEPATH,
      "client/candle/elab",
      116,
      "psi",
      ("impossible equality elimination " + pretty_value(eq)),
      {}
    )
  }
}

function fst(pos, inter) {
  let $ = force(inter);
  if ($ instanceof VIdent) {
    let x = $[0];
    let mode = $[1];
    let lvl = $[2];
    let spine = $[3];
    let pos2 = $[4];
    return new VIdent(
      x,
      mode,
      lvl,
      $list.append(spine, toList([new VFst(pos)])),
      pos2,
    );
  } else if ($ instanceof VMeta) {
    let ref = $[0];
    let erased = $[1];
    let spine = $[2];
    let pos2 = $[3];
    return new VMeta(
      ref,
      erased,
      $list.append(spine, toList([new VFst(pos)])),
      pos2,
    );
  } else if ($ instanceof VInter) {
    let a = $[0];
    return a;
  } else if ($ instanceof VCast) {
    let a = $[0];
    return a;
  } else {
    throw makeError(
      "panic",
      FILEPATH,
      "client/candle/elab",
      131,
      "fst",
      ("impossible value projection " + pretty_value(inter)),
      {}
    )
  }
}

function snd(pos, inter) {
  let $ = force(inter);
  if ($ instanceof VIdent) {
    let x = $[0];
    let mode = $[1];
    let lvl = $[2];
    let spine = $[3];
    let pos2 = $[4];
    return new VIdent(
      x,
      mode,
      lvl,
      $list.append(spine, toList([new VSnd(pos)])),
      pos2,
    );
  } else if ($ instanceof VMeta) {
    let ref = $[0];
    let erased = $[1];
    let spine = $[2];
    let pos2 = $[3];
    return new VMeta(
      ref,
      erased,
      $list.append(spine, toList([new VSnd(pos)])),
      pos2,
    );
  } else if ($ instanceof VInter) {
    let b = $[1];
    return b;
  } else if ($ instanceof VCast) {
    let a = $[0];
    return a;
  } else {
    throw makeError(
      "panic",
      FILEPATH,
      "client/candle/elab",
      146,
      "snd",
      "impossible value projection",
      {}
    )
  }
}

function apply_spine(loop$v, loop$spine) {
  while (true) {
    let v = loop$v;
    let spine = loop$spine;
    if (spine instanceof $Empty) {
      return v;
    } else {
      let $ = spine.head;
      if ($ instanceof VApp) {
        let rest = spine.tail;
        let mode = $[0];
        let icit = $[1];
        let arg = $[2];
        let pos = $[3];
        loop$v = app(pos, mode, icit, v, arg);
        loop$spine = rest;
      } else if ($ instanceof VPsi) {
        let rest = spine.tail;
        let arg = $[0];
        let pos = $[1];
        loop$v = psi(pos, v, arg);
        loop$spine = rest;
      } else if ($ instanceof VFst) {
        let rest = spine.tail;
        let pos = $[0];
        loop$v = fst(pos, v);
        loop$spine = rest;
      } else {
        let rest = spine.tail;
        let pos = $[0];
        loop$v = snd(pos, v);
        loop$spine = rest;
      }
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
          174,
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
        let imp = $.implicit;
        return new VLambda(
          x,
          mode,
          imp,
          (arg) => { return eval$(e, listPrepend(arg, env)); },
          pos,
        );
      } else if ($ instanceof Pi) {
        let x = t[1];
        let u = t[2];
        let pos = t.pos;
        let mode = $.mode;
        let imp = $.implicit;
        let t$1 = $.ty;
        return new VPi(
          x,
          mode,
          imp,
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
      if ($ instanceof Meta) {
        let pos = t.pos;
        let ref = $[0];
        return new VMeta(ref, false, toList([]), pos);
      } else if ($ instanceof InsertedMeta) {
        let pos = t.pos;
        let ref = $[0];
        let mask = $[1];
        return apps(pos, new VMeta(ref, false, toList([]), pos), env, mask);
      } else if ($ instanceof Sort) {
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
        let pos = t.pos;
        let mode = $[0];
        let icit = $[1];
        return app(pos, mode, icit, eval$(foo, env), eval$(bar, env));
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
        let eq = t[3];
        let pos = t.pos;
        return new VCast(eval$(a, env), eval$(inter, env), eval$(eq, env), pos);
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

function invert_helper(spine) {
  if (spine instanceof $Empty) {
    return new Ok([new Level(0), $dict.new$()]);
  } else {
    let $ = spine.head;
    if ($ instanceof VApp) {
      let rest = spine.tail;
      let bar = $[2];
      let pos = $[3];
      return $result.try$(
        invert_helper(rest),
        (_use0) => {
          let domain = _use0[0];
          let renaming = _use0[1];
          let $1 = force(bar);
          if ($1 instanceof VIdent) {
            let $2 = $1[3];
            if ($2 instanceof $Empty) {
              let x = $1[0];
              let lvl = $1[2];
              let $3 = $dict.get(renaming, lvl);
              if ($3 instanceof Ok) {
                return new Error(
                  ((("unification error: " + x) + " not in renaming scope (") + pretty_pos(
                    pos,
                  )) + ")",
                );
              } else {
                return new Ok(
                  [inc(domain), $dict.insert(renaming, lvl, domain)],
                );
              }
            } else {
              let v = $1;
              return new Error(
                (("unification error: non-variable " + pretty_value(v)) + " in spine at ") + pretty_pos(
                  pos,
                ),
              );
            }
          } else {
            let v = $1;
            return new Error(
              (("unification error: non-variable " + pretty_value(v)) + " in spine at ") + pretty_pos(
                pos,
              ),
            );
          }
        },
      );
    } else if ($ instanceof VPsi) {
      let pos = $[1];
      return new Error(
        "unification error: can't invert meta with psi at " + pretty_pos(pos),
      );
    } else if ($ instanceof VFst) {
      let pos = $[0];
      return new Error(
        "unification error: can't invert meta with projection at " + pretty_pos(
          pos,
        ),
      );
    } else {
      let pos = $[0];
      return new Error(
        "unification error: can't invert meta with projection at " + pretty_pos(
          pos,
        ),
      );
    }
  }
}

function invert(codomain_size, spine) {
  return $result.try$(
    invert_helper($list.reverse(spine)),
    (_use0) => {
      let domain_size = _use0[0];
      let renaming = _use0[1];
      return new Ok(new PartialRenaming(domain_size, codomain_size, renaming));
    },
  );
}

function solve(gamma, ref, lhs, rhs) {
  return $result.try$(
    invert(gamma, lhs),
    (pr) => {
      return $result.try$(
        rename(ref, pr, rhs),
        (rhs2) => {
          let solution = eval$(lambdas(pr.domain_size, rhs2), toList([]));
          set(ref, new Solved(solution));
          return new Ok(true);
        },
      );
    },
  );
}

function unify(lvl, a, b) {
  return unify_helper(lvl, erase(a), erase(b));
}

function insert(loop$ctx, loop$t, loop$v) {
  while (true) {
    let ctx = loop$ctx;
    let t = loop$t;
    let v = loop$v;
    let $ = force(v);
    if (t instanceof Binder) {
      let $1 = t[0];
      if ($1 instanceof Lambda) {
        let $2 = $1.implicit;
        if ($2 instanceof Implicit) {
          return [t, v];
        } else if ($ instanceof VPi) {
          let $3 = $[2];
          if ($3 instanceof Implicit) {
            let mode = $[1];
            let b = $[4];
            let pos = $[5];
            let m = fresh_meta(ctx, pos);
            let m2 = eval$(m, ctx.env);
            loop$ctx = ctx;
            loop$t = new Ctor2(new App(mode, new Implicit()), t, m, pos);
            loop$v = b(m2);
          } else {
            return [t, v];
          }
        } else {
          return [t, v];
        }
      } else if ($ instanceof VPi) {
        let $2 = $[2];
        if ($2 instanceof Implicit) {
          let mode = $[1];
          let b = $[4];
          let pos = $[5];
          let m = fresh_meta(ctx, pos);
          let m2 = eval$(m, ctx.env);
          loop$ctx = ctx;
          loop$t = new Ctor2(new App(mode, new Implicit()), t, m, pos);
          loop$v = b(m2);
        } else {
          return [t, v];
        }
      } else {
        return [t, v];
      }
    } else if ($ instanceof VPi) {
      let $1 = $[2];
      if ($1 instanceof Implicit) {
        let mode = $[1];
        let b = $[4];
        let pos = $[5];
        let m = fresh_meta(ctx, pos);
        let m2 = eval$(m, ctx.env);
        loop$ctx = ctx;
        loop$t = new Ctor2(new App(mode, new Implicit()), t, m, pos);
        loop$v = b(m2);
      } else {
        return [t, v];
      }
    } else {
      return [t, v];
    }
  }
}

function echo(value, file, line) {
  const grey = "\u001b[90m";
  const reset_color = "\u001b[39m";
  const file_line = `${file}:${line}`;
  const string_value = echo$inspect(value);

  if (globalThis.process?.stderr?.write) {
    // If we're in Node.js, use `stderr`
    const string = `${grey}${file_line}${reset_color}\n${string_value}\n`;
    process.stderr.write(string);
  } else if (globalThis.Deno) {
    // If we're in Deno, use `stderr`
    const string = `${grey}${file_line}${reset_color}\n${string_value}\n`;
    globalThis.Deno.stderr.writeSync(new TextEncoder().encode(string));
  } else {
    // Otherwise, use `console.log`
    // The browser's console.log doesn't support ansi escape codes
    const string = `${file_line}\n${string_value}`;
    globalThis.console.log(string);
  }

  return value;
}

function echo$inspectString(str) {
  let new_str = '"';
  for (let i = 0; i < str.length; i++) {
    let char = str[i];
    if (char == "\n") new_str += "\\n";
    else if (char == "\r") new_str += "\\r";
    else if (char == "\t") new_str += "\\t";
    else if (char == "\f") new_str += "\\f";
    else if (char == "\\") new_str += "\\\\";
    else if (char == '"') new_str += '\\"';
    else if (char < " " || (char > "~" && char < "\u{00A0}")) {
      new_str +=
        "\\u{" +
        char.charCodeAt(0).toString(16).toUpperCase().padStart(4, "0") +
        "}";
    } else {
      new_str += char;
    }
  }
  new_str += '"';
  return new_str;
}

function echo$inspectDict(map) {
  let body = "dict.from_list([";
  let first = true;

  let key_value_pairs = [];
  map.forEach((value, key) => {
    key_value_pairs.push([key, value]);
  });
  key_value_pairs.sort();
  key_value_pairs.forEach(([key, value]) => {
    if (!first) body = body + ", ";
    body = body + "#(" + echo$inspect(key) + ", " + echo$inspect(value) + ")";
    first = false;
  });
  return body + "])";
}

function echo$inspectCustomType(record) {
  const props = globalThis.Object.keys(record)
    .map((label) => {
      const value = echo$inspect(record[label]);
      return isNaN(parseInt(label)) ? `${label}: ${value}` : value;
    })
    .join(", ");
  return props
    ? `${record.constructor.name}(${props})`
    : record.constructor.name;
}

function echo$inspectObject(v) {
  const name = Object.getPrototypeOf(v)?.constructor?.name || "Object";
  const props = [];
  for (const k of Object.keys(v)) {
    props.push(`${echo$inspect(k)}: ${echo$inspect(v[k])}`);
  }
  const body = props.length ? " " + props.join(", ") + " " : "";
  const head = name === "Object" ? "" : name + " ";
  return `//js(${head}{${body}})`;
}

function echo$inspect(v) {
  const t = typeof v;
  if (v === true) return "True";
  if (v === false) return "False";
  if (v === null) return "//js(null)";
  if (v === undefined) return "Nil";
  if (t === "string") return echo$inspectString(v);
  if (t === "bigint" || t === "number") return v.toString();
  if (globalThis.Array.isArray(v))
    return `#(${v.map(echo$inspect).join(", ")})`;
  if (v instanceof $List)
    return `[${v.toArray().map(echo$inspect).join(", ")}]`;
  if (v instanceof $UtfCodepoint)
    return `//utfcodepoint(${String.fromCodePoint(v.value)})`;
  if (v instanceof $BitArray) return echo$inspectBitArray(v);
  if (v instanceof $CustomType) return echo$inspectCustomType(v);
  if (echo$isDict(v)) return echo$inspectDict(v);
  if (v instanceof Set)
    return `//js(Set(${[...v].map(echo$inspect).join(", ")}))`;
  if (v instanceof RegExp) return `//js(${v})`;
  if (v instanceof Date) return `//js(Date("${v.toISOString()}"))`;
  if (v instanceof Function) {
    const args = [];
    for (const i of Array(v.length).keys())
      args.push(String.fromCharCode(i + 97));
    return `//fn(${args.join(", ")}) { ... }`;
  }
  return echo$inspectObject(v);
}

function echo$inspectBitArray(bitArray) {
  // We take all the aligned bytes of the bit array starting from `bitOffset`
  // up to the end of the section containing all the aligned bytes.
  let endOfAlignedBytes =
    bitArray.bitOffset + 8 * Math.trunc(bitArray.bitSize / 8);
  let alignedBytes = bitArraySlice(
    bitArray,
    bitArray.bitOffset,
    endOfAlignedBytes,
  );

  // Now we need to get the remaining unaligned bits at the end of the bit array.
  // They will start after `endOfAlignedBytes` and end at `bitArray.bitSize`
  let remainingUnalignedBits = bitArray.bitSize % 8;
  if (remainingUnalignedBits > 0) {
    let remainingBits = bitArraySliceToInt(
      bitArray,
      endOfAlignedBytes,
      bitArray.bitSize,
      false,
      false,
    );
    let alignedBytesArray = Array.from(alignedBytes.rawBuffer);
    let suffix = `${remainingBits}:size(${remainingUnalignedBits})`;
    if (alignedBytesArray.length === 0) {
      return `<<${suffix}>>`;
    } else {
      return `<<${Array.from(alignedBytes.rawBuffer).join(", ")}, ${suffix}>>`;
    }
  } else {
    return `<<${Array.from(alignedBytes.rawBuffer).join(", ")}>>`;
  }
}

function echo$isDict(value) {
  try {
    // We can only check if an object is a stdlib Dict if it is one of the
    // project's dependencies.
    // The `Dict` class is the default export of `stdlib/dict.mjs`
    // that we import as `$stdlib$dict`.
    return value instanceof $stdlib$dict.default;
  } catch {
    // If stdlib is not one of the project's dependencies then `$stdlib$dict`
    // will not have been imported and the check will throw an exception meaning
    // we can't check if something is actually a `Dict`.
    return false;
  }
}

