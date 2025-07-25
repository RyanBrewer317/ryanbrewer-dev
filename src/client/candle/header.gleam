import gleam/int
import gleam/list

pub type Ref(a)

@external(javascript, "./ffi.mjs", "get")
pub fn get(ref: Ref(a)) -> a

@external(javascript, "./ffi.mjs", "set")
pub fn set(ref: Ref(a), a: a) -> Nil

@external(javascript, "./ffi.mjs", "make")
pub fn new(a: a) -> Ref(a)

@external(javascript, "./ffi.mjs", "next_id")
pub fn next_id() -> Int

pub type Pos {
  Pos(src: String, line: Int, col: Int)
}

pub fn pretty_pos(pos: Pos) -> String {
  int.to_string(pos.line) <> ":" <> int.to_string(pos.col)
}

pub type BinderMode {
  ZeroMode
  ManyMode
  TypeMode
}

pub fn pretty_mode(m: BinderMode) -> String {
  case m {
    ZeroMode -> "erased"
    ManyMode -> "relevant"
    TypeMode -> "type-abstraction"
  }
}

pub type Sort {
  SetSort
  KindSort
}

pub type SyntaxParam {
  SyntaxParam(mode: BinderMode, name: String, ty: Syntax)
}

pub fn pretty_syntax_param(param: SyntaxParam) -> String {
  case param.mode {
    ZeroMode -> "{" <> param.name <> ": " <> pretty_syntax(param.ty) <> "}"
    ManyMode -> "(" <> param.name <> ": " <> pretty_syntax(param.ty) <> ")"
    TypeMode -> "<" <> param.name <> ": " <> pretty_syntax(param.ty) <> ">"
  }
}

pub type Syntax {
  LambdaSyntax(BinderMode, String, Result(Syntax, Nil), Syntax, pos: Pos)
  IdentSyntax(String, pos: Pos)
  AppSyntax(BinderMode, Syntax, Syntax, pos: Pos)
  LetSyntax(String, Syntax, Syntax, Syntax, pos: Pos)
  DefSyntax(String, Syntax, Syntax, Syntax, pos: Pos)
  NatSyntax(Int, pos: Pos)
  NatTypeSyntax(pos: Pos)
  SortSyntax(Sort, pos: Pos)
  PiSyntax(BinderMode, String, Syntax, Syntax, pos: Pos)
  PsiSyntax(Syntax, Syntax, pos: Pos)
  IntersectionTypeSyntax(String, Syntax, Syntax, pos: Pos)
  IntersectionSyntax(Syntax, Syntax, pos: Pos)
  FstSyntax(Syntax, pos: Pos)
  SndSyntax(Syntax, pos: Pos)
  EqSyntax(Syntax, Syntax, pos: Pos)
  ReflSyntax(Syntax, pos: Pos)
  CastSyntax(Syntax, Syntax, Syntax, pos: Pos)
  ExFalsoSyntax(Syntax, pos: Pos)
  HoleSyntax(pos: Pos)
}

pub fn get_pos(s: Syntax) -> Pos {
  case s {
    LambdaSyntax(_, _, _, _, pos) -> pos
    IdentSyntax(_, pos) -> pos
    AppSyntax(_, _, _, pos) -> pos
    LetSyntax(_, _, _, _, pos) -> pos
    DefSyntax(_, _, _, _, pos) -> pos
    NatSyntax(_, pos) -> pos
    NatTypeSyntax(pos) -> pos
    SortSyntax(_, pos) -> pos
    PiSyntax(_, _, _, _, pos) -> pos
    PsiSyntax(_, _, pos) -> pos
    IntersectionTypeSyntax(_, _, _, pos) -> pos
    IntersectionSyntax(_, _, pos) -> pos
    FstSyntax(_, pos) -> pos
    SndSyntax(_, pos) -> pos
    EqSyntax(_, _, pos) -> pos
    ReflSyntax(_, pos) -> pos
    CastSyntax(_, _, _, pos) -> pos
    ExFalsoSyntax(_, pos) -> pos
    HoleSyntax(pos) -> pos
  }
}

pub fn pretty_syntax(s: Syntax) -> String {
  case s {
    LambdaSyntax(mode, x, Ok(t), e, _) ->
      pretty_syntax_param(SyntaxParam(mode, x, t)) <> "-> " <> pretty_syntax(e)
    LambdaSyntax(mode, x, Error(Nil), e, _) -> {
      let outer = "-> " <> pretty_syntax(e)
      case mode {
        ManyMode -> "(" <> x <> ")" <> outer
        ZeroMode -> "{" <> x <> "}" <> outer
        TypeMode -> "<" <> x <> ">" <> outer
      }
    }
    IdentSyntax(name, _) -> name
    AppSyntax(ManyMode, foo, bar, _) ->
      "(" <> pretty_syntax(foo) <> ")(" <> pretty_syntax(bar) <> ")"
    AppSyntax(ZeroMode, foo, bar, _) ->
      "(" <> pretty_syntax(foo) <> "){" <> pretty_syntax(bar) <> "}"
    AppSyntax(TypeMode, foo, bar, _) ->
      "(" <> pretty_syntax(foo) <> ")<" <> pretty_syntax(bar) <> ">"
    LetSyntax(x, t, v, scope, _) ->
      "let "
      <> x
      <> ": "
      <> pretty_syntax(t)
      <> " = "
      <> pretty_syntax(v)
      <> " in "
      <> pretty_syntax(scope)
    DefSyntax(x, t, v, scope, _) ->
      "def "
      <> x
      <> ": "
      <> pretty_syntax(t)
      <> " = "
      <> pretty_syntax(v)
      <> " in "
      <> pretty_syntax(scope)
    NatSyntax(n, _) -> int.to_string(n)
    NatTypeSyntax(_) -> "Nat"
    SortSyntax(SetSort, _) -> "Set"
    SortSyntax(KindSort, _) -> "Kind"
    PiSyntax(mode, x, t, u, _) ->
      pretty_syntax_param(SyntaxParam(mode, x, t)) <> "=> " <> pretty_syntax(u)
    PsiSyntax(e, prop, _) ->
      "Psi(" <> pretty_syntax(e) <> ", " <> pretty_syntax(prop) <> ")"
    IntersectionTypeSyntax(x, t, u, _) ->
      pretty_syntax_param(SyntaxParam(ManyMode, x, t))
      <> "& "
      <> pretty_syntax(u)
    IntersectionSyntax(l, r, _) ->
      "[" <> pretty_syntax(l) <> ", " <> pretty_syntax(r) <> "]"
    FstSyntax(a, _) -> "(" <> pretty_syntax(a) <> ").1"
    SndSyntax(a, _) -> "(" <> pretty_syntax(a) <> ").2"
    EqSyntax(a, b, _) ->
      "(" <> pretty_syntax(a) <> ") = (" <> pretty_syntax(b) <> ")"
    ReflSyntax(a, _) -> "refl(" <> pretty_syntax(a) <> ")"
    CastSyntax(a, b, eq, _) ->
      "cast("
      <> pretty_syntax(a)
      <> ", "
      <> pretty_syntax(b)
      <> ", "
      <> pretty_syntax(eq)
      <> ")"
    ExFalsoSyntax(a, _) -> "exfalso(" <> pretty_syntax(a) <> ")"
    HoleSyntax(_) -> "_"
  }
}

pub type Index {
  Index(int: Int)
}

pub type Level {
  Level(int: Int)
}

pub fn lvl_to_idx(size: Level, lvl: Level) -> Index {
  Index(size.int - lvl.int - 1)
}

pub type Meta {
  Solved(Value)
  Unsolved(Int)
}

pub type Binder {
  Lambda(mode: BinderMode)
  Pi(mode: BinderMode, ty: Term)
  InterT(ty: Term)
  Let(mode: BinderMode, val: Term)
}

pub type ContextMask {
  ContextMask(has_def: Bool, mode: BinderMode)
}

pub type Ctor0 {
  Meta(Ref(Meta))
  InsertedMeta(Ref(Meta), List(ContextMask))
  Sort(Sort)
  NatT
  Nat(Int)
}

pub type Ctor1 {
  Fst
  Snd
  ExFalso
  Refl
}

pub type Ctor2 {
  App(BinderMode)
  Psi
  Inter
}

pub type Ctor3 {
  Cast
  Eq
}

pub type Term {
  Ident(BinderMode, Index, String, pos: Pos)
  Binder(Binder, String, Term, pos: Pos)
  Ctor0(Ctor0, pos: Pos)
  Ctor1(Ctor1, Term, pos: Pos)
  Ctor2(Ctor2, Term, Term, pos: Pos)
  Ctor3(Ctor3, Term, Term, Term, pos: Pos)
}

pub fn term_pos(t: Term) -> Pos {
  case t {
    Ident(_, _, _, pos) -> pos
    Binder(_, _, _, pos) -> pos
    Ctor0(_, pos) -> pos
    Ctor1(_, _, pos) -> pos
    Ctor2(_, _, _, pos) -> pos
    Ctor3(_, _, _, _, pos) -> pos
  }
}

pub fn pretty_param(
  mode: BinderMode,
  x: String,
  mb_t: Result(Term, Nil),
) -> String {
  let inner = case mb_t {
    Ok(t) -> x <> ": " <> pretty_term(t)
    Error(Nil) -> x
  }
  case mode {
    ManyMode -> "(" <> inner <> ")"
    ZeroMode -> "{" <> inner <> "}"
    TypeMode -> "<" <> inner <> ">"
  }
}

pub fn pretty_term(term: Term) -> String {
  case term {
    Ident(_, _, s, _) -> s
    Binder(Lambda(mode), x, e, _) ->
      pretty_param(mode, x, Error(Nil)) <> "-> " <> pretty_term(e)
    Binder(Pi(ManyMode, t), "_", u, _) ->
      "(" <> pretty_term(t) <> ")=>" <> pretty_term(u)
    Binder(Pi(mode, t), x, u, _) ->
      pretty_param(mode, x, Ok(t)) <> "=> " <> pretty_term(u)
    Binder(InterT(t), x, u, _) ->
      pretty_param(ManyMode, x, Ok(t)) <> "& " <> pretty_term(u)
    Binder(Let(mode, v), x, e, _) ->
      "let "
      <> pretty_param(mode, x, Error(Nil))
      <> " = "
      <> pretty_term(v)
      <> " in "
      <> pretty_term(e)
    Ctor0(Sort(SetSort), _) -> "Set"
    Ctor0(Sort(KindSort), _) -> "Kind"
    Ctor0(NatT, _) -> "Nat"
    Ctor0(Nat(n), _) -> int.to_string(n)
    Ctor0(Meta(ref), _) ->
      case get(ref) {
        Solved(v) -> pretty_value(v)
        Unsolved(i) -> "?m" <> int.to_string(i)
      }
    Ctor0(InsertedMeta(ref, _), pos) -> pretty_term(Ctor0(Meta(ref), pos))
    Ctor1(Fst, a, _) -> ".1(" <> pretty_term(a) <> ")"
    Ctor1(Snd, a, _) -> ".2(" <> pretty_term(a) <> ")"
    Ctor1(ExFalso, a, _) -> "exfalso(" <> pretty_term(a) <> ")"
    Ctor2(App(mode), foo, bar, _) ->
      "("
      <> pretty_term(foo)
      <> ")"
      <> case mode {
        ManyMode -> "(" <> pretty_term(bar) <> ")"
        ZeroMode -> "{" <> pretty_term(bar) <> "}"
        TypeMode -> "<" <> pretty_term(bar) <> ">"
      }
    Ctor1(Refl, a, _) -> "refl(" <> pretty_term(a) <> ")"
    Ctor2(Inter, a, b, _) ->
      "[" <> pretty_term(a) <> ", " <> pretty_term(b) <> "]"
    Ctor3(Eq, a, b, _t, _) ->
      "(" <> pretty_term(a) <> ") = (" <> pretty_term(b) <> ")"
    Ctor3(Cast, a, b, eq, _) ->
      "cast("
      <> pretty_term(a)
      <> ", "
      <> pretty_term(b)
      <> ", "
      <> pretty_term(eq)
      <> ")"
    Ctor2(Psi, eq, p, _) ->
      "Psi(" <> pretty_term(eq) <> ", " <> pretty_term(p) <> ")"
  }
}

pub fn inc(lvl: Level) -> Level {
  Level(lvl.int + 1)
}

pub type Value {
  VIdent(String, BinderMode, Level, List(SpineEntry), Pos)
  VMeta(Ref(Meta), Bool, List(SpineEntry), Pos)
  VSort(Sort, Pos)
  VNat(Int, Pos)
  VNatType(Pos)
  VPi(String, BinderMode, Value, fn(Value) -> Value, Pos)
  VLambda(String, BinderMode, fn(Value) -> Value, Pos)
  VEq(Value, Value, Value, Pos)
  VRefl(Value, Pos)
  VInter(Value, Value, Pos)
  VInterT(String, Value, fn(Value) -> Value, Pos)
  VCast(Value, Value, Value, Pos)
  VExFalso(Value, Pos)
}

pub type SpineEntry {
  VApp(BinderMode, Value, Pos)
  VPsi(Value, Pos)
  VFst(Pos)
  VSnd(Pos)
}

pub fn value_pos(v: Value) -> Pos {
  case v {
    VIdent(_, _, _, spine, pos) ->
      case list.reverse(spine) {
        [] -> pos
        [s, ..] -> spine_pos(s)
      }
    VMeta(_, _, _, pos) -> pos
    VSort(_, pos) -> pos
    VNat(_, pos) -> pos
    VNatType(pos) -> pos
    VPi(_, _, _, _, pos) -> pos
    VLambda(_, _, _, pos) -> pos
    VEq(_, _, _, pos) -> pos
    VRefl(_, pos) -> pos
    VInter(_, _, pos) -> pos
    VInterT(_, _, _, pos) -> pos
    VCast(_, _, _, pos) -> pos
    VExFalso(_, pos) -> pos
  }
}

pub fn spine_pos(s: SpineEntry) -> Pos {
  case s {
    VApp(_, _, pos) -> pos
    VPsi(_, pos) -> pos
    VFst(pos) -> pos
    VSnd(pos) -> pos
  }
}

fn pretty_spine_entry(base: String, s: SpineEntry) -> String {
  case s {
    VApp(ManyMode, b, _) -> "(" <> base <> ")(" <> pretty_value(b) <> ")"
    VApp(ZeroMode, b, _) -> "(" <> base <> "){" <> pretty_value(b) <> "}"
    VApp(TypeMode, b, _) -> "(" <> base <> ")<" <> pretty_value(b) <> ">"
    VPsi(p, _) -> "Psi(" <> base <> ", " <> pretty_value(p) <> ")"
    VFst(_) -> "(" <> base <> ").1"
    VSnd(_) -> "(" <> base <> ").2"
  }
}

pub fn pretty_value(v: Value) -> String {
  case v {
    VIdent(x, _, _, spine, _) -> list.fold(spine, x, pretty_spine_entry)
    VMeta(ref, _, [], _) ->
      case get(ref) {
        Solved(v) -> pretty_value(v)
        Unsolved(i) -> "?m" <> int.to_string(i)
      }
    VMeta(ref, erased, spine, pos) ->
      list.fold(
        spine,
        pretty_value(VMeta(ref, erased, [], pos)),
        pretty_spine_entry,
      )
    VSort(SetSort, _) -> "Set"
    VSort(KindSort, _) -> "Kind"
    VNat(n, _) -> int.to_string(n)
    VNatType(_) -> "Nat"
    VPi("_", mode, a, b, pos) -> {
      let li = pretty_value(a)
      case mode {
        ManyMode -> "(" <> li <> ")"
        ZeroMode -> "{" <> li <> "}"
        TypeMode -> "<" <> li <> ">"
      }
      <> "=> "
      <> pretty_value(b(VIdent("_", mode, Level(0), [], pos)))
    }
    VPi(x, mode, a, b, pos) ->
      {
        case mode {
          ManyMode -> "(" <> x <> ": " <> pretty_value(a) <> ")"
          ZeroMode -> "{" <> x <> ": " <> pretty_value(a) <> "}"
          TypeMode -> "<" <> x <> ": " <> pretty_value(a) <> ">"
        }
      }
      <> "=> "
      <> pretty_value(b(VIdent(x, mode, Level(0), [], pos)))
    VLambda(x, mode, f, pos) ->
      {
        case mode {
          ManyMode -> "(" <> x <> ")"
          ZeroMode -> "{" <> x <> "}"
          TypeMode -> "<" <> x <> ">"
        }
      }
      <> "-> "
      <> pretty_value(f(VIdent(x, mode, Level(0), [], pos)))
    VEq(a, b, t, _) ->
      "("
      <> pretty_value(a)
      <> ") =["
      <> pretty_value(t)
      <> "] ("
      <> pretty_value(b)
      <> ")"
    VRefl(a, _) -> "refl(" <> pretty_value(a) <> ")"
    VInter(a, b, _) -> "[" <> pretty_value(a) <> ", " <> pretty_value(b) <> "]"
    VInterT(x, a, b, pos) ->
      "("
      <> x
      <> ": "
      <> pretty_value(a)
      <> ")& "
      <> pretty_value(b(VIdent(x, TypeMode, Level(0), [], pos)))
    VCast(a, inter, eq, _) ->
      "cast("
      <> pretty_value(a)
      <> ", "
      <> pretty_value(inter)
      <> ", "
      <> pretty_value(eq)
      <> ")"
    VExFalso(a, _) -> "exfalso(" <> pretty_value(a) <> ")"
  }
}

pub fn quote(size: Level, v: Value) -> Term {
  case v {
    VIdent(x, mode, lvl, spine, pos) ->
      list.fold(
        spine,
        Ident(mode, lvl_to_idx(size, lvl), x, pos),
        quote_spine(size),
      )
    VMeta(ref, _, spine, pos) ->
      list.fold(spine, Ctor0(Meta(ref), pos), quote_spine(size))
    VSort(s, p) -> Ctor0(Sort(s), p)
    VNat(n, p) -> Ctor0(Nat(n), p)
    VNatType(p) -> Ctor0(NatT, p)
    VPi(x, mode, a, b, p) -> {
      let n = VIdent(x, mode, size, [], p)
      Binder(Pi(mode, quote(size, a)), x, quote(inc(size), b(n)), p)
    }
    VLambda(x, mode, e, p) -> {
      let n = VIdent(x, mode, size, [], p)
      Binder(Lambda(mode), x, quote(inc(size), e(n)), p)
    }
    VEq(a, b, t, p) ->
      Ctor3(Eq, quote(size, a), quote(size, b), quote(size, t), p)
    VRefl(a, p) -> Ctor1(Refl, quote(size, a), p)
    VInter(a, b, pos) -> Ctor2(Inter, quote(size, a), quote(size, b), pos)
    VInterT(x, a, b, pos) -> {
      let n = VIdent(x, TypeMode, size, [], pos)
      Binder(InterT(quote(size, a)), x, quote(inc(size), b(n)), pos)
    }
    VCast(a, inter, eq, pos) ->
      Ctor3(Cast, quote(size, a), quote(size, inter), quote(size, eq), pos)
    VExFalso(a, pos) -> Ctor1(ExFalso, quote(size, a), pos)
  }
}

fn quote_spine(size: Level) -> fn(Term, SpineEntry) -> Term {
  fn(base, entry) {
    case entry {
      VApp(mode, v, p) -> Ctor2(App(mode), base, quote(size, v), p)
      VPsi(pred, pos) -> Ctor2(Psi, base, quote(size, pred), pos)
      VFst(pos) -> Ctor1(Fst, base, pos)
      VSnd(pos) -> Ctor1(Snd, base, pos)
    }
  }
}
