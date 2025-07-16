import gleam/result
import client/candle/header.{
  type BinderMode, type Index, type Level, type Neutral, type Pos, type Syntax,
  type Term, type Value, App, AppSyntax, Binder, Cast, CastSyntax, Ctor0, Ctor1,
  Ctor2, Ctor3, DefSyntax, Eq, EqSyntax, ExFalso, ExFalsoSyntax, Fst, FstSyntax,
  Ident, IdentSyntax, Index, Inter, InterT, IntersectionSyntax,
  IntersectionTypeSyntax, KindSort, Lambda, LambdaSyntax, Let, LetSyntax, Level,
  ManyMode, Nat, NatSyntax, NatT, NatTypeSyntax, Pi, PiSyntax, Psi, PsiSyntax,
  Refl, ReflSyntax, SetSort, Snd, SndSyntax, Sort, SortSyntax, TypeMode, VApp,
  VCast, VEq, VExFalso, VFst, VIdent, VInter, VInterT, VLambda, VNat, VNatType,
  VNeutral, VPi, VPsi, VRefl, VSnd, VSort, ZeroMode, inc, pretty_mode,
  pretty_pos, pretty_term, pretty_value,
}

fn erase(t: Value) -> Value {
  case t {
    VNeutral(n) -> VNeutral(erase_neutral(n))
    VLambda(_, ZeroMode, e, p) ->
      erase(e(VNeutral(VIdent("", ZeroMode, Level(0), p))))
    VLambda(x, mode, e, p) -> VLambda(x, mode, fn(arg) { erase(e(arg)) }, p)
    VPi(x, mode, a, b, p) ->
      VPi(x, mode, erase(a), fn(arg) { erase(b(arg)) }, p)
    VEq(a, b, t, p) -> VEq(erase(a), erase(b), erase(t), p)
    VRefl(_, p) -> VLambda("x", ManyMode, fn(x) { x }, p)
    VInter(a, _, _) -> erase(a)
    VInterT(x, a, b, p) -> VInterT(x, erase(a), fn(arg) { erase(b(arg)) }, p)
    VCast(a, _, _, _) -> erase(a)
    VExFalso(a, _) -> erase(a)
    VNat(_, _) | VNatType(_) | VSort(_, _) -> t
  }
}

fn erase_neutral(n: Neutral) -> Neutral {
  case n {
    VIdent(_, _, _, _) -> n
    VApp(ZeroMode, a, _, _) -> erase_neutral(a)
    VApp(m, a, b, p) -> VApp(m, erase_neutral(a), erase(b), p)
    VPsi(e, _, _) -> erase_neutral(e)
    VFst(a, _) -> erase_neutral(a)
    VSnd(a, _) -> erase_neutral(a)
  }
}

fn app(mode: BinderMode, foo: Value, bar: Value) -> Value {
  case foo {
    VNeutral(neutral) ->
      VNeutral(VApp(mode, neutral, bar, header.value_pos(bar)))
    VLambda(_, _, f, _) -> f(bar)
    _ -> panic as "impossible value application"
  }
}

fn psi(pos: Pos, eq: Value, pred: Value) -> Value {
  case eq {
    VNeutral(neutral) -> VNeutral(VPsi(neutral, pred, pos))
    VRefl(_, _) -> VLambda("x", ManyMode, fn(x) { x }, pos)
    _ -> panic as { "impossible equality elimination " <> pretty_value(eq) }
  }
}

fn fst(pos: Pos, inter: Value) -> Value {
  case inter {
    VNeutral(neutral) -> VNeutral(VFst(neutral, pos))
    VInter(a, _, _) -> a
    VCast(a, _, _, _) -> {
      // slightly creative but seems right
      a
    }
    _ -> panic as { "impossible value projection " <> pretty_value(inter) }
  }
}

fn snd(pos: Pos, inter: Value) -> Value {
  case inter {
    VNeutral(neutral) -> VNeutral(VSnd(neutral, pos))
    VInter(_, b, _) -> b
    VCast(a, _, _, _) -> {
      // slightly creative but seems right
      a
    }
    _ -> panic as "impossible value projection"
  }
}

fn lookup(l: List(a), i: Int) -> Result(a, Nil) {
  case l, i {
    [], _ -> Error(Nil)
    [x, ..], 0 -> Ok(x)
    [_, ..rest], i -> lookup(rest, i - 1)
  }
}

pub fn eval(t: Term, env: List(Value)) -> Value {
  case t {
    Ident(_mode, idx, _s, _pos) ->
      case lookup(env, idx.int) {
        Ok(v) -> v
        Error(_) -> panic as "out-of-scope var during eval"
      }
    Ctor0(Sort(SetSort), pos) -> VSort(SetSort, pos)
    Ctor0(Sort(KindSort), pos) -> VSort(KindSort, pos)
    Binder(Pi(mode, t), x, u, pos) ->
      VPi(x, mode, eval(t, env), fn(arg) { eval(u, [arg, ..env]) }, pos)
    Binder(Lambda(mode), x, e, pos) ->
      VLambda(x, mode, fn(arg) { eval(e, [arg, ..env]) }, pos)
    Ctor2(App(mode), foo, bar, _) -> app(mode, eval(foo, env), eval(bar, env))
    Binder(Let(_mode, v), _x, e, _) -> eval(e, [eval(v, env), ..env])
    Ctor0(Nat(n), pos) -> VNat(n, pos)
    Ctor0(NatT, pos) -> VNatType(pos)
    Ctor3(Eq, a, b, t, pos) ->
      VEq(eval(a, env), eval(b, env), eval(t, env), pos)
    Ctor1(Refl, a, pos) -> VRefl(eval(a, env), pos)
    Ctor2(Psi, e, p, pos) -> psi(pos, eval(e, env), eval(p, env))
    Ctor2(Inter, a, b, pos) -> VInter(eval(a, env), eval(b, env), pos)
    Binder(InterT(a), x, b, pos) ->
      VInterT(x, eval(a, env), fn(arg) { eval(b, [arg, ..env]) }, pos)
    Ctor1(Fst, a, pos) -> fst(pos, eval(a, env))
    Ctor1(Snd, a, pos) -> snd(pos, eval(a, env))
    Ctor3(Cast, a, inter, eq, pos) ->
      VCast(eval(a, env), eval(inter, env), eval(eq, env), pos)
    Ctor1(ExFalso, a, pos) -> VExFalso(eval(a, env), pos)
  }
}

pub type Context {
  Context(
    level: Level,
    types: List(Value),
    env: List(Value),
    scope: List(#(String, #(BinderMode, Value))),
  )
}

pub const empty_ctx = Context(Level(0), [], [], [])

fn pretty_hypotheses(scope: List(#(String, #(BinderMode, Value)))) -> String {
  case scope {
    [] -> "\n"
    [#(x, #(_, t)), ..rest] ->
      x <> ": " <> pretty_value(t) <> "\n" <> pretty_hypotheses(rest)
  }
}

fn eq(lvl: Level, a: Value, b: Value) -> Bool {
  eq_helper(lvl, erase(a), erase(b))
}

fn eq_helper(lvl: Level, a: Value, b: Value) -> Bool {
  let eqh = fn(a, b) { eq_helper(lvl, a, b) }
  case a, b {
    VSort(s1, _), VSort(s2, _) -> s1 == s2
    VPi(x, m1, t1, u1, pos), VPi(_, m2, t2, u2, _) -> {
      let dummy = VNeutral(VIdent(x, m1, lvl, pos))
      m1 == m2 && eqh(t1, t2) && eq_helper(inc(lvl), u1(dummy), u2(dummy))
    }
    VLambda(x, m, f, pos), b -> {
      let dummy = VNeutral(VIdent(x, m, lvl, pos))
      eq_helper(inc(lvl), f(dummy), app(m, b, dummy))
    }
    a, VLambda(x, m, f, pos) -> {
      let dummy = VNeutral(VIdent(x, m, lvl, pos))
      eq_helper(inc(lvl), app(m, a, dummy), f(dummy))
    }
    VNeutral(VIdent(_, _, i, _)), VNeutral(VIdent(_, _, j, _)) -> i == j
    VNeutral(VApp(m1, n1, arg1, _)), VNeutral(VApp(m2, n2, arg2, _)) ->
      m1 == m2 && eqh(VNeutral(n1), VNeutral(n2)) && eqh(arg1, arg2)
    VNat(n, _), VNat(m, _) -> n == m
    VNatType(_), VNatType(_) -> True
    VEq(a1, b1, t1, _), VEq(a2, b2, t2, _) ->
      eqh(a1, a2) && eqh(b1, b2) && eqh(t1, t2)
    VRefl(a1, _), VRefl(a2, _) -> eqh(a1, a2)
    VNeutral(VPsi(e1, p1, _)), VNeutral(VPsi(e2, p2, _)) ->
      eqh(VNeutral(e1), VNeutral(e2)) && eqh(p1, p2)
    VInter(a1, b1, _), VInter(a2, b2, _) -> eqh(a1, a2) && eqh(b1, b2)
    VInterT(x, a1, b1, pos), VInterT(_, a2, b2, _) -> {
      let dummy = VNeutral(VIdent(x, TypeMode, lvl, pos))
      eqh(a1, a2) && eq_helper(inc(lvl), b1(dummy), b2(dummy))
    }
    VNeutral(VFst(a1, _)), VNeutral(VFst(a2, _)) ->
      eqh(VNeutral(a1), VNeutral(a2))
    VNeutral(VSnd(a1, _)), VNeutral(VSnd(a2, _)) ->
      eqh(VNeutral(a1), VNeutral(a2))
    VCast(a1, inter1, eq1, _), VCast(a2, inter2, eq2, _) ->
      eqh(a1, a2) && eqh(inter1, inter2) && eqh(eq1, eq2)
    VExFalso(a1, _), VExFalso(a2, _) -> eqh(a1, a2)
    _, _ -> False
  }
}

fn inc_idx(i: Index) -> Index {
  Index(i.int + 1)
}

fn rel_occurs(t: Term, x: Index) -> Result(Pos, Nil) {
  case t {
    Ident(_, y, _, pos) if x == y -> Ok(pos)
    Ident(_, _, _, _) -> Error(Nil)
    Binder(Let(_, v), _, e, _) ->
      result.or(rel_occurs(v, x), rel_occurs(e, inc_idx(x)))
    Binder(_, _, e, _) -> rel_occurs(e, inc_idx(x))
    Ctor0(_, _) -> Error(Nil)
    Ctor1(Refl, _, _) -> Error(Nil)
    Ctor1(_, a, _) -> rel_occurs(a, x)
    Ctor2(App(ZeroMode), a, _, _) -> rel_occurs(a, x)
    Ctor2(Psi, _, _, _) -> Error(Nil)
    Ctor2(_, a, b, _) -> result.or(rel_occurs(a, x), rel_occurs(b, x))
    Ctor3(Cast, a, _, _, _) -> rel_occurs(a, x)
    Ctor3(_, a, b, c, _) ->
      rel_occurs(a, x)
      |> result.or(rel_occurs(b, x))
      |> result.or(rel_occurs(c, x))
  }
}

fn check(ctx: Context, s: Syntax, ty: Value) -> Result(Term, String) {
  case s, ty {
    LambdaSyntax(mode1, x, Ok(xt), body, pos), VPi(_, mode2, a, b, _) -> {
      use mode <- result.try(case mode1, mode2 {
        m1, m2 if m1 == m2 -> Ok(m1)
        ManyMode, TypeMode -> Ok(TypeMode)
        _, _ ->
          Error(
            "mode mismatch: "
            <> pretty_mode(mode1)
            <> " and "
            <> pretty_mode(mode2)
            <> " at "
            <> pretty_pos(pos),
          )
      })
      use #(xt2, _xtt) <- result.try(infer(ctx, xt))
      let xt3 = eval(xt2, ctx.env)
      use _ <- result.try(case eq(ctx.level, xt3, a) {
        True -> Ok(Nil)
        False ->
          Error(
            "type mismatch: " <> pretty_term(xt2) <> " and " <> pretty_value(a),
          )
      })
      let v = VNeutral(VIdent(x, mode, ctx.level, pos))
      let ctx2 =
        Context(
          level: inc(ctx.level),
          types: [a, ..ctx.types],
          env: [v, ..ctx.env],
          scope: [#(x, #(mode, a)), ..ctx.scope],
        )
      use body2 <- result.try(check(ctx2, body, b(v)))
      use _ <- result.try(case mode {
        ZeroMode ->
          case rel_occurs(body2, Index(0)) {
            Ok(pos2) ->
              Error("relevant usage of erased variable at " <> pretty_pos(pos2))
            Error(Nil) -> Ok(Nil)
          }
        _ -> Ok(Nil)
      })
      Ok(Binder(Lambda(mode), x, body2, pos))
    }
    LambdaSyntax(mode1, x, Error(Nil), body, pos), VPi(_, mode2, a, b, _) -> {
      use mode <- result.try(case mode1, mode2 {
        m1, m2 if m1 == m2 -> Ok(m1)
        ManyMode, TypeMode -> Ok(TypeMode)
        _, _ ->
          Error(
            "mode mismatch: "
            <> pretty_mode(mode1)
            <> " and "
            <> pretty_mode(mode2)
            <> " at "
            <> pretty_pos(pos),
          )
      })
      let dummy = VNeutral(VIdent(x, mode, ctx.level, pos))
      let ctx2 =
        Context(
          level: inc(ctx.level),
          types: [a, ..ctx.types],
          env: [dummy, ..ctx.env],
          scope: [#(x, #(mode, a)), ..ctx.scope],
        )
      use body2 <- result.try(check(ctx2, body, b(dummy)))
      Ok(Binder(Lambda(mode), x, body2, pos))
    }
    LetSyntax(x, xt, v, e, pos), ty -> {
      use #(xt2, xtt) <- result.try(infer(ctx, xt))
      use _ <- result.try(case xtt {
        VSort(_, _) -> Ok(Nil)
        _ -> Error("type annotation must be a type")
      })
      let xt2v = eval(xt2, ctx.env)
      use v2 <- result.try(check(ctx, v, xt2v))
      let v3 = eval(v2, ctx.env)
      let ctx2 =
        Context(
          level: inc(ctx.level),
          types: [xt2v, ..ctx.types],
          env: [v3, ..ctx.env],
          scope: [#(x, #(ManyMode, xt2v)), ..ctx.scope],
        )
      use e2 <- result.try(check(ctx2, e, ty))
      Ok(Binder(Let(mode: ManyMode, val: v2), x, e2, pos))
    }
    DefSyntax(x, xt, v, e, pos), ty -> {
      use #(xt2, xtt) <- result.try(infer(ctx, xt))
      use _ <- result.try(case xtt {
        VSort(_, _) -> Ok(Nil)
        _ -> Error("type annotation must be a type")
      })
      let xt2v = eval(xt2, ctx.env)
      use v2 <- result.try(check(ctx, v, xt2v))
      let v3 = eval(v2, ctx.env)
      let ctx2 =
        Context(
          level: inc(ctx.level),
          types: [xt2v, ..ctx.types],
          env: [v3, ..ctx.env],
          scope: [#(x, #(ZeroMode, xt2v)), ..ctx.scope],
        )
      use e2 <- result.try(check(ctx2, e, ty))
      Ok(Binder(Let(mode: ZeroMode, val: v2), x, e2, pos))
    }
    ReflSyntax(x, pos), VEq(a, b, _t, _) -> {
      use #(x2, _xt) <- result.try(infer(ctx, x))
      let x3 = eval(x2, ctx.env)
      use _ <- result.try(case eq(ctx.level, x3, a) {
        True ->
          case eq(ctx.level, x3, b) {
            True -> Ok(Nil)
            False ->
              Error(
                "type mismatch between "
                <> pretty_value(x3)
                <> " and "
                <> pretty_value(b)
                <> " at "
                <> pretty_pos(pos),
              )
          }
        False ->
          Error(
            "type mismatch between "
            <> pretty_value(x3)
            <> " and "
            <> pretty_value(a)
            <> " at "
            <> pretty_pos(pos),
          )
      })
      Ok(Ctor1(Refl, x2, pos))
    }
    IntersectionSyntax(a, b, pos), VInterT(_, at, bt, _) -> {
      use a2 <- result.try(check(ctx, a, at))
      let a3 = eval(a2, ctx.env)
      use b2 <- result.try(check(ctx, b, bt(a3)))
      let b3 = eval(b2, ctx.env)
      use _ <- result.try(case eq(ctx.level, a3, b3) {
        True -> Ok(Nil)
        False ->
          Error(
            "intersection components must be equal (" <> pretty_pos(pos) <> ")",
          )
      })
      Ok(Ctor2(Inter, a2, b2, pos))
    }
    CastSyntax(a, inter, eq, pos), VInterT(_, at, _, _) as intert -> {
      use a2 <- result.try(check(ctx, a, at))
      let a3 = eval(a2, ctx.env)
      use inter2 <- result.try(check(ctx, inter, intert))
      let inter3 = eval(inter2, ctx.env)
      use eq2 <- result.try(check(ctx, eq, VEq(a3, fst(pos, inter3), at, pos)))
      Ok(Ctor3(Cast, a2, inter2, eq2, pos))
    }
    s, ty -> {
      use #(v, ty2) <- result.try(infer(ctx, s))
      case eq(ctx.level, ty, ty2) {
        True -> Ok(v)
        False -> {
          Error(
            pretty_hypotheses(ctx.scope)
            <> "type mismatch between `"
            <> pretty_value(ty)
            <> "` and `"
            <> pretty_value(ty2)
            <> "` at "
            <> pretty_pos(header.get_pos(s)),
          )
        }
      }
    }
  }
}

fn scan(i: Int, l: List(#(k, v)), key: k) -> Result(#(v, Int), Nil) {
  case l {
    [] -> Error(Nil)
    [#(k, v), ..] if k == key -> Ok(#(v, i))
    [_, ..rest] -> scan(i + 1, rest, key)
  }
}

pub fn infer(ctx: Context, s: Syntax) -> Result(#(Term, Value), String) {
  case s {
    IdentSyntax(str, pos) -> {
      case scan(0, ctx.scope, str) {
        Ok(#(#(mode, ty), i)) -> Ok(#(Ident(mode, Index(i), str, pos), ty))
        Error(Nil) -> Error("undefined variable " <> str)
      }
    }
    SortSyntax(SetSort, pos) ->
      Ok(#(Ctor0(Sort(SetSort), pos), VSort(KindSort, pos)))
    SortSyntax(KindSort, _) -> panic as "parsed impossible kind literal"
    PiSyntax(mode, str, a, b, pos) -> {
      use #(a2, at) <- result.try(infer(ctx, a))
      case at {
        VSort(s1, _) -> {
          let mode = case s1, mode {
            KindSort, ManyMode -> TypeMode
            _, _ -> mode
          }
          let dummy = VNeutral(VIdent(str, mode, ctx.level, pos))
          let a3 = eval(a2, ctx.env)
          let ctx2 =
            Context(
              level: inc(ctx.level),
              types: [a3, ..ctx.types],
              env: [dummy, ..ctx.env],
              scope: [#(str, #(mode, a3)), ..ctx.scope],
            )
          use #(b2, bt) <- result.try(infer(ctx2, b))
          case bt, mode {
            VSort(KindSort, _) as s, TypeMode ->
              Ok(#(Binder(Pi(mode, a2), str, b2, pos), s))
            VSort(KindSort, _) as s, ManyMode ->
              Ok(#(Binder(Pi(TypeMode, a2), str, b2, pos), s))
            VSort(KindSort, _), ZeroMode ->
              Error(
                "erased functions can't return types ("
                <> pretty_pos(pos)
                <> ")",
              )
            VSort(SetSort, _), TypeMode ->
              Error(
                "type abstractions must return types ("
                <> pretty_pos(pos)
                <> ")",
              )
            VSort(SetSort, _) as s, _ ->
              Ok(#(Binder(Pi(mode, a2), str, b2, pos), s))
            _, _ -> Error("pi right-side be a type (" <> pretty_pos(pos) <> ")")
          }
        }
        _ -> Error("pi left-side should be a type (" <> pretty_pos(pos) <> ")")
      }
    }
    LambdaSyntax(mode, str, Ok(xt), body, pos) -> {
      use #(xt2, xtt) <- result.try(infer(ctx, xt))
      use _ <- result.try(case mode, xtt {
        ManyMode, VSort(KindSort, _) ->
          Error("relevant lambda binding can't bind types")
        _, VSort(SetSort, _) -> Ok(Nil)
        _, _ -> Error("type annotation in lambda must be a type")
      })
      let xt2v = eval(xt2, ctx.env)
      let v = VNeutral(VIdent(str, mode, ctx.level, pos))
      let ctx2 =
        Context(
          level: inc(ctx.level),
          types: [xt2v, ..ctx.types],
          env: [v, ..ctx.env],
          scope: [#(str, #(mode, xt2v)), ..ctx.scope],
        )
      use #(body2, _body2t) <- result.try(infer(ctx2, body))
      Ok(#(
        Binder(Lambda(mode), str, body2, pos),
        VPi(
          str,
          mode,
          xt2v,
          fn(x) {
            let ctx2 =
              Context(
                inc(ctx.level),
                types: [xt2v, ..ctx.env],
                env: [x, ..ctx.env],
                scope: [#(str, #(mode, xt2v)), ..ctx.scope],
              )
            let assert Ok(#(_, t)) = infer(ctx2, body)
            t
          },
          pos,
        ),
      ))
    }
    LambdaSyntax(_, _, Error(Nil), _, pos) ->
      Error("can't infer the type of the lambda at " <> pretty_pos(pos))
    AppSyntax(mode1, foo, bar, pos) -> {
      use #(foo2, foot) <- result.try(infer(ctx, foo))
      case foot {
        VPi(_, mode2, a, b, _) if mode1 == mode2 -> {
          use bar2 <- result.try(check(ctx, bar, a))
          let t = b(eval(bar2, ctx.env))
          Ok(#(Ctor2(App(mode1), foo2, bar2, pos), t))
        }
        VPi(_, TypeMode, a, b, _) if mode1 == ManyMode -> {
          use bar2 <- result.try(check(ctx, bar, a))
          let t = b(eval(bar2, ctx.env))
          Ok(#(Ctor2(App(TypeMode), foo2, bar2, pos), t))
        }
        VPi(_, mode2, _, _, _) ->
          Error(
            "mode-mismatch between "
            <> pretty_mode(mode1)
            <> " and "
            <> pretty_mode(mode2)
            <> " at "
            <> pretty_pos(pos),
          )
        _ ->
          Error(
            "application to non-function `"
            <> pretty_value(foot)
            <> "` at "
            <> pretty_pos(pos),
          )
      }
    }
    LetSyntax(x, xt, v, e, pos) -> {
      use #(xt2, xtt) <- result.try(infer(ctx, xt))
      use _ <- result.try(case xtt {
        VSort(_, _) -> Ok(Nil)
        _ -> Error("type annotation must be a type")
      })
      let xt2v = eval(xt2, ctx.env)
      use v2 <- result.try(check(ctx, v, xt2v))
      let v3 = eval(v2, ctx.env)
      let ctx2 =
        Context(..ctx, env: [v3, ..ctx.env], scope: [
          #(x, #(ManyMode, xt2v)),
          ..ctx.scope
        ])
      use #(e2, et) <- result.try(infer(ctx2, e))
      Ok(#(Binder(Let(mode: ManyMode, val: v2), x, e2, pos), et))
    }
    DefSyntax(x, xt, v, e, pos) -> {
      use #(xt2, xtt) <- result.try(infer(ctx, xt))
      use _ <- result.try(case xtt {
        VSort(_, _) -> Ok(Nil)
        _ -> Error("type annotation must be a type")
      })
      let xt2v = eval(xt2, ctx.env)
      use v2 <- result.try(check(ctx, v, xt2v))
      let v3 = eval(v2, ctx.env)
      let ctx2 =
        Context(..ctx, env: [v3, ..ctx.env], scope: [
          #(x, #(ZeroMode, xt2v)),
          ..ctx.scope
        ])
      use #(e2, et) <- result.try(infer(ctx2, e))
      Ok(#(Binder(Let(mode: ZeroMode, val: v2), x, e2, pos), et))
    }
    NatSyntax(n, pos) -> Ok(#(Ctor0(Nat(n), pos), VNatType(pos)))
    NatTypeSyntax(pos) -> Ok(#(Ctor0(NatT, pos), VSort(SetSort, pos)))
    EqSyntax(a, b, pos) -> {
      use #(a2, t) <- result.try(infer(ctx, a))
      use b2 <- result.try(check(ctx, b, t))
      let t2 = header.quote(ctx.level, t)
      Ok(#(Ctor3(Eq, a2, b2, t2, pos), VSort(SetSort, pos)))
    }
    ReflSyntax(a, pos) -> {
      use #(a2, t) <- result.try(infer(ctx, a))
      let a3 = eval(a2, ctx.env)
      Ok(#(Ctor1(Refl, a2, pos), VEq(a3, a3, t, pos)))
    }
    PsiSyntax(e, p, pos) -> {
      use #(e2, et) <- result.try(infer(ctx, e))
      case et {
        VEq(a, b, t, _) -> {
          use p2 <- result.try(check(
            ctx,
            p,
            VPi(
              "y",
              TypeMode,
              t,
              fn(y) {
                VPi(
                  "p",
                  TypeMode,
                  VEq(a, y, t, pos),
                  fn(_) { VSort(SetSort, pos) },
                  pos,
                )
              },
              pos,
            ),
          ))
          let p3 = eval(p2, ctx.env)
          let e3 = eval(e2, ctx.env)
          Ok(#(
            Ctor2(Psi, e2, p2, pos),
            VPi(
              "_",
              ManyMode,
              app(TypeMode, app(TypeMode, p3, a), VRefl(a, pos)),
              fn(_) { app(TypeMode, app(TypeMode, p3, b), e3) },
              pos,
            ),
          ))
        }
        _ ->
          Error(
            "Psi requires an equality type, but received "
            <> pretty_term(e2)
            <> " ("
            <> pretty_pos(pos)
            <> ")",
          )
      }
    }
    IntersectionTypeSyntax(x, a, b, pos) -> {
      use a2 <- result.try(check(ctx, a, VSort(SetSort, pos)))
      let dummy = VNeutral(VIdent(x, TypeMode, ctx.level, pos))
      let a3 = eval(a2, ctx.env)
      let ctx2 =
        Context(
          level: inc(ctx.level),
          types: [a3, ..ctx.types],
          env: [dummy, ..ctx.env],
          scope: [#(x, #(TypeMode, a3)), ..ctx.scope],
        )
      use b2 <- result.try(check(ctx2, b, VSort(SetSort, pos)))
      Ok(#(Binder(InterT(a2), x, b2, pos), VSort(SetSort, pos)))
    }
    IntersectionSyntax(a, b, pos) -> {
      use #(a2, at) <- result.try(infer(ctx, a))
      let a3 = eval(a2, ctx.env)
      use #(b2, bt) <- result.try(infer(ctx, b))
      let b3 = eval(b2, ctx.env)
      case eq(ctx.level, a3, b3) {
        True ->
          Ok(#(Ctor2(Inter, a2, b2, pos), VInterT("_", at, fn(_) { bt }, pos)))
        False ->
          Error(
            "Intersection components must be equal (" <> pretty_pos(pos) <> ")",
          )
      }
    }
    FstSyntax(a, pos) -> {
      use #(a2, at) <- result.try(infer(ctx, a))
      case at {
        VInterT(_, a, _, _) -> Ok(#(Ctor1(Fst, a2, pos), a))
        _ ->
          Error("Projection requires intersection (" <> pretty_pos(pos) <> ")")
      }
    }
    SndSyntax(a, pos) -> {
      use #(a2, at) <- result.try(infer(ctx, a))
      let a3 = eval(a2, ctx.env)
      case at {
        VInterT(_, _, b, _) -> Ok(#(Ctor1(Snd, a2, pos), b(fst(pos, a3))))
        _ ->
          Error("Projection requires intersection (" <> pretty_pos(pos) <> ")")
      }
    }
    CastSyntax(a, inter, eq, pos) -> {
      use #(inter2, intert) <- result.try(infer(ctx, inter))
      case intert {
        VInterT(_, at, _, _) -> {
          let inter3 = eval(inter2, ctx.env)
          use a2 <- result.try(check(ctx, a, at))
          let a3 = eval(a2, ctx.env)
          use eq2 <- result.try(check(
            ctx,
            eq,
            VEq(a3, fst(pos, inter3), at, pos),
          ))
          Ok(#(Ctor3(Cast, a2, inter2, eq2, pos), intert))
        }
        _ ->
          Error(
            "cast requires an intersection in the second argument ("
            <> pretty_pos(pos)
            <> ")",
          )
      }
    }
    ExFalsoSyntax(a, pos) -> {
      use a2 <- result.try(check(
        ctx,
        a,
        VEq(ctrue(pos), cfalse(pos), cbool(pos), pos),
      ))
      Ok(#(
        Ctor1(ExFalso, a2, pos),
        VPi("t", ZeroMode, VSort(SetSort, pos), fn(t) { t }, pos),
      ))
    }
  }
}

fn cbool(pos: Pos) -> Value {
  VPi(
    "t",
    ZeroMode,
    VSort(SetSort, pos),
    fn(t) {
      VPi(
        "x",
        ManyMode,
        t,
        fn(_x) { VPi("y", ManyMode, t, fn(_y) { t }, pos) },
        pos,
      )
    },
    pos,
  )
}

fn ctrue(pos: Pos) -> Value {
  VLambda(
    "t",
    ZeroMode,
    fn(_t) {
      VLambda(
        "x",
        ManyMode,
        fn(x) { VLambda("y", ManyMode, fn(_y) { x }, pos) },
        pos,
      )
    },
    pos,
  )
}

fn cfalse(pos: Pos) -> Value {
  VLambda(
    "t",
    ZeroMode,
    fn(_t) {
      VLambda(
        "x",
        ManyMode,
        fn(_x) { VLambda("y", ManyMode, fn(y) { y }, pos) },
        pos,
      )
    },
    pos,
  )
}
