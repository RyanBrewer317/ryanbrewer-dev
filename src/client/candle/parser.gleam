import gleam/int
import gleam/list
import gleam/string
import header.{
  type BinderMode, type Pos, type Syntax, type SyntaxParam, AppSyntax,
  CastSyntax, DefSyntax, EqSyntax, ExFalsoSyntax, Explicit, FstSyntax,
  HoleSyntax, IdentSyntax, Implicit, IntersectionSyntax, IntersectionTypeSyntax,
  LambdaSyntax, LetSyntax, ManyMode, NatSyntax, NatTypeSyntax, PiSyntax, Pos,
  PsiSyntax, ReflSyntax, SetSort, SndSyntax, SortSyntax, SyntaxParam, ZeroMode,
}

pub type Parser(a) {
  Parser(run: fn(Pos, List(String)) -> Result(#(Pos, List(String), a), Failure))
}

pub type Failure {
  Bubbler(msg: String, pos: Pos, expected: String)
  Normal(msg: String, pos: Pos, expected: String)
}

pub fn parse(src: String, parser: Parser(a)) -> Result(a, String) {
  case parser.run(Pos("", 1, 1), string.to_graphemes(src)) {
    Ok(#(_, _, a)) -> Ok(a)
    Error(err) ->
      case err.expected {
        "" -> Error(err.msg <> " at " <> header.pretty_pos(err.pos))
        _ ->
          Error(
            err.msg
            <> " at "
            <> header.pretty_pos(err.pos)
            <> ", expected "
            <> err.expected,
          )
      }
  }
}

fn satisfy(pred: fn(String) -> Bool) -> Parser(String) {
  Parser(fn(pos, chars) {
    case chars {
      [] -> Error(Normal("unexpected EOF", pos, ""))
      [c, ..rest] ->
        case pred(c) {
          True ->
            case c {
              "\n" -> Ok(#(Pos(pos.src, pos.line + 1, 1), rest, c))
              _ -> Ok(#(Pos(pos.src, pos.line, pos.col + 1), rest, c))
            }
          False ->
            case c {
              "\n" -> Error(Normal("unexpected newline", pos, ""))
              _ -> Error(Normal("unexpected " <> c, pos, ""))
            }
        }
    }
  })
}

fn map(parser: Parser(a), f: fn(a) -> b) -> Parser(b) {
  Parser(fn(pos, chars) {
    case parser.run(pos, chars) {
      Ok(#(pos2, rest, a)) -> Ok(#(pos2, rest, f(a)))
      Error(e) -> Error(e)
    }
  })
}

fn either(p1: Parser(a), p2: Parser(a)) -> Parser(a) {
  Parser(fn(pos, chars) {
    case p1.run(pos, chars) {
      Ok(out) -> Ok(out)
      Error(Normal(_, _, _)) -> p2.run(pos, chars)
      Error(Bubbler(_, _, _)) as e -> e
    }
  })
}

fn many0(parser: Parser(a)) -> Parser(List(a)) {
  Parser(fn(pos, chars) {
    case parser.run(pos, chars) {
      Ok(#(pos2, rest, a)) ->
        case many0(parser).run(pos2, rest) {
          Ok(#(pos3, rest2, others)) -> Ok(#(pos3, rest2, [a, ..others]))
          Error(Normal(_, _, _)) -> panic as "many0 returned normal failure"
          Error(Bubbler(_, _, _)) as e -> e
        }
      Error(Normal(_, _, _)) -> Ok(#(pos, chars, []))
      Error(Bubbler(_, _, _) as e) -> Error(e)
    }
  })
}

fn do(p1: Parser(a), f: fn(a) -> Parser(b)) -> Parser(b) {
  Parser(fn(pos, chars) {
    case p1.run(pos, chars) {
      Ok(#(pos2, rest, a)) -> f(a).run(pos2, rest)
      Error(e) -> Error(e)
    }
  })
}

fn return(a: a) -> Parser(a) {
  Parser(fn(pos, chars) { Ok(#(pos, chars, a)) })
}

fn many(parser: Parser(a)) -> Parser(List(a)) {
  use first <- do(parser)
  use rest <- do(many0(parser))
  return([first, ..rest])
}

fn label(parser: Parser(a), expected: String) -> Parser(a) {
  Parser(fn(pos, chars) {
    case parser.run(pos, chars) {
      Ok(out) -> Ok(out)
      Error(Normal(msg, p, _)) -> Error(Normal(msg, p, expected))
      e -> e
    }
  })
}

fn commit(k: fn() -> Parser(a)) -> Parser(a) {
  Parser(fn(pos, chars) {
    case k().run(pos, chars) {
      Ok(out) -> Ok(out)
      Error(Normal(msg, p, e)) | Error(Bubbler(msg, p, e)) ->
        Error(Bubbler(msg, p, e))
    }
  })
}

fn maybe_commit(cond: Bool, k: fn() -> Parser(a)) -> Parser(a) {
  case cond {
    True -> commit(k)
    False -> k()
  }
}

fn char(c: String) -> Parser(String) {
  satisfy(fn(c2) { c == c2 }) |> label(c)
}

fn lowercase() -> Parser(String) {
  satisfy(fn(c) {
    string.contains(does: "abcdefghijklmnopqrstuvwxyz", contain: c)
  })
}

fn uppercase() -> Parser(String) {
  satisfy(fn(c) {
    string.contains(does: "ABCDEFGHIJKLMNOPQRSTUVWXYZ", contain: c)
  })
}

fn digit() -> Parser(String) {
  satisfy(fn(c) { string.contains(does: "1234567890", contain: c) })
}

fn alphanum() -> Parser(String) {
  either(lowercase(), either(uppercase(), digit()))
}

fn get_pos() -> Parser(Pos) {
  Parser(fn(pos, chars) { Ok(#(pos, chars, pos)) })
}

fn lazy(thunk: fn() -> Parser(a)) -> Parser(a) {
  Parser(fn(pos, chars) { thunk().run(pos, chars) })
}

fn any_of(parsers: List(Parser(a))) -> Parser(a) {
  case parsers {
    [] -> panic as "any_of on empty parser list"
    [p] -> p
    [p, ..rest] -> either(p, any_of(rest))
  }
}

fn string(s: String) -> Parser(String) {
  map(string_helper(s), fn(_) { s })
  |> label(s)
}

fn string_helper(s: String) -> Parser(String) {
  case string.pop_grapheme(s) {
    Ok(#(c, "")) -> char(c)
    Ok(#(c, rest)) -> do(char(c), fn(_) { string(rest) })
    Error(_) -> panic as "empty string"
  }
}

fn maybe(parser: Parser(a)) -> Parser(Result(a, Nil)) {
  Parser(fn(pos, chars) {
    case parser.run(pos, chars) {
      Ok(#(pos2, rest, a)) -> Ok(#(pos2, rest, Ok(a)))
      Error(Normal(_, _, _)) -> Ok(#(pos, chars, Error(Nil)))
      Error(Bubbler(_, _, _) as e) -> Error(e)
    }
  })
}

fn keyword(s: String) {
  use _ <- do(string(s))
  Parser(fn(pos, chars) {
    case any_of([lowercase(), uppercase(), digit()]).run(pos, chars) {
      Ok(#(_, _, c)) -> Error(Normal("unexpected " <> c, pos, s))
      Error(_) -> Ok(#(pos, chars, s))
    }
  })
}

fn ws(k: fn() -> Parser(a)) -> Parser(a) {
  use _ <- do(
    many0(
      any_of([
        char(" "),
        char("\n"),
        char("\t"),
        {
          use _ <- do(string("//"))
          use _ <- do(many0(satisfy(fn(c) { c != "\n" })))
          char("\n")
        },
      ]),
    ),
  )
  k()
}

fn ident_string() -> Parser(String) {
  use fst <- do(either(uppercase(), lowercase()))
  use rest <- do(
    many0(either(char("_"), alphanum()))
    |> map(string.concat),
  )
  return(fst <> rest)
}

fn pattern_string() -> Parser(String) {
  either(ident_string(), {
    use _ <- do(char("_"))
    use s <- do(
      many0(either(char("_"), alphanum()))
      |> map(string.concat),
    )
    return("_" <> s)
  })
  |> label("identifier")
}

fn ident() -> Parser(Syntax) {
  use pos <- do(get_pos())
  use s <- do(ident_string())
  use <- ws()
  use mb_lam <- do(maybe(string("->")))
  case mb_lam {
    Ok(_) -> {
      use <- commit()
      use body <- do(lazy(expr))
      return(LambdaSyntax(ManyMode, Explicit, s, Error(Nil), body, pos))
    }
    Error(Nil) -> return(IdentSyntax(s, pos))
  }
}

fn hole() -> Parser(Syntax) {
  use pos <- do(get_pos())
  use _ <- do(keyword("?"))
  return(HoleSyntax(pos))
}

fn nat() -> Parser(Syntax) {
  use pos <- do(get_pos())
  use n_str <- do(many(digit()))
  let assert Ok(n) = int.parse(string.concat(n_str))
  return(NatSyntax(n, pos))
}

fn nat_type() -> Parser(Syntax) {
  use pos <- do(get_pos())
  use _ <- do(keyword("Nat"))
  return(NatTypeSyntax(pos))
}

fn type_type() -> Parser(Syntax) {
  use pos <- do(get_pos())
  use _ <- do(keyword("Set"))
  return(SortSyntax(SetSort, pos))
}

fn relevant_but_ignored() -> Parser(Syntax) {
  use pos <- do(get_pos())
  use x <- do(pattern_string())
  use <- commit()
  use <- ws()
  use _ <- do(string("->"))
  use e <- do(lazy(expr))
  return(LambdaSyntax(ManyMode, Explicit, x, Error(Nil), e, pos))
}

fn annotated_binder() -> Parser(Syntax) {
  use pos <- do(get_pos())
  use param <- do(parse_param(should_commit: False))
  use <- commit()
  use <- ws()
  let arrows = case param.mode {
    ManyMode -> [string("->"), string("=>"), string("&")]
    ZeroMode -> [string("->"), string("=>")]
    _ -> panic as "impossible binder mode"
  }
  use res <- do(any_of(arrows) |> label("binding arrow"))
  use e <- do(lazy(expr))
  case res {
    "->" ->
      return(LambdaSyntax(
        param.mode,
        param.implicit,
        param.name,
        Ok(param.ty),
        e,
        pos,
      ))
    "=>" ->
      return(PiSyntax(param.mode, param.implicit, param.name, param.ty, e, pos))
    "&" -> return(IntersectionTypeSyntax(param.name, param.ty, e, pos))
    _ -> panic as "impossible annotated binder"
  }
}

fn erased_binder() -> Parser(Syntax) {
  use pos <- do(get_pos())
  use _ <- do(char("<"))
  use <- commit()
  use e <- do(lazy(expr) |> label("expression or binding"))
  use _ <- do(
    char(">")
    |> label(case e {
      IdentSyntax(_, _) -> ": or >"
      _ -> ">"
    }),
  )
  use <- ws()
  case e {
    IdentSyntax(x, _) -> {
      use res <- do(either(string("->"), string("=>")))
      use body <- do(lazy(expr))
      case res {
        "->" ->
          return(LambdaSyntax(ZeroMode, Explicit, x, Error(Nil), body, pos))
        "=>" -> return(PiSyntax(ZeroMode, Explicit, "_", e, body, pos))
        _ -> panic as "impossible erased binder"
      }
    }
    _ -> {
      use _ <- do(string("=>"))
      use body <- do(lazy(expr))
      return(PiSyntax(ZeroMode, Explicit, "_", e, body, pos))
    }
  }
}

fn parens() -> Parser(Syntax) {
  use pos <- do(get_pos())
  use _ <- do(char("("))
  use <- commit()
  use e <- do(lazy(expr) |> label("expression or binding"))
  use _ <- do(
    char(")")
    |> label(case e {
      IdentSyntax(_, _) -> ": or )"
      _ -> ")"
    }),
  )
  case e {
    IdentSyntax(x, _) -> {
      use <- ws()
      use res <- do(maybe(string("->")))
      case res {
        Error(Nil) -> return(e)
        Ok(_) -> {
          use body <- do(lazy(expr))
          return(LambdaSyntax(ManyMode, Explicit, x, Error(Nil), body, pos))
        }
      }
    }
    _ -> return(e)
  }
}

fn parse_param(should_commit idk: Bool) -> Parser(SyntaxParam) {
  use <- ws()
  use res <- do(any_of([char("("), char("<")]))
  use <- ws()
  use res2 <- do(maybe(char("?")))
  let imp = case res2 {
    Ok(_) -> Implicit
    Error(Nil) -> Explicit
  }
  use <- ws()
  use <- maybe_commit(idk)
  use x <- do(pattern_string())
  use <- ws()
  use _ <- do(char(":"))
  use t <- do(lazy(expr))
  case res {
    "(" -> {
      use _ <- do(char(")"))
      return(SyntaxParam(ManyMode, imp, x, t))
    }
    "<" -> {
      use _ <- do(char(">"))
      return(SyntaxParam(ZeroMode, imp, x, t))
    }
    _ -> panic as "impossible param mode"
  }
}

fn build_pi(pos: Pos, params: List(SyntaxParam), rett: Syntax) -> Syntax {
  case params {
    [] -> rett
    [param, ..rest] -> {
      PiSyntax(
        param.mode,
        param.implicit,
        param.name,
        param.ty,
        build_pi(pos, rest, rett),
        pos,
      )
    }
  }
}

fn build_lambda(pos: Pos, params: List(SyntaxParam), body: Syntax) -> Syntax {
  case params {
    [] -> body
    [param, ..rest] ->
      LambdaSyntax(
        param.mode,
        param.implicit,
        param.name,
        Ok(param.ty),
        build_lambda(pos, rest, body),
        pos,
      )
  }
}

fn let_binding() -> Parser(Syntax) {
  use pos <- do(get_pos())
  use res <- do(either(keyword("let"), keyword("def")))
  use <- ws()
  use <- commit()
  use x <- do(pattern_string())
  use <- ws()
  use params <- do(many0(parse_param(should_commit: True)))
  use <- ws()
  use _ <- do(char(":") |> label(": or parameter"))
  use t <- do(lazy(expr))
  use _ <- do(string(":="))
  use v <- do(lazy(expr))
  use _ <- do(keyword("in"))
  use e <- do(lazy(expr))
  let t = build_pi(pos, params, t)
  let v = build_lambda(pos, params, v)
  case res {
    "let" -> return(LetSyntax(x, t, v, e, pos))
    "def" -> return(DefSyntax(x, t, v, e, pos))
    _ -> panic as "impossible binder"
  }
}

fn refl() -> Parser(Syntax) {
  use pos <- do(get_pos())
  use _ <- do(keyword("refl"))
  use <- ws()
  use _ <- do(char("("))
  use a <- do(lazy(expr))
  use _ <- do(char(")"))
  return(ReflSyntax(a, pos))
}

fn psi() -> Parser(Syntax) {
  use pos <- do(get_pos())
  use _ <- do(keyword("Psi"))
  use <- ws()
  use _ <- do(char("("))
  use eq <- do(lazy(expr))
  use _ <- do(char(","))
  use p <- do(lazy(expr))
  use _ <- do(char(")"))
  return(PsiSyntax(eq, p, pos))
}

fn intersection() -> Parser(Syntax) {
  use pos <- do(get_pos())
  use _ <- do(char("["))
  use <- commit()
  use a <- do(lazy(expr))
  use _ <- do(char(","))
  use b <- do(lazy(expr))
  use _ <- do(char("]"))
  return(IntersectionSyntax(a, b, pos))
}

fn cast() -> Parser(Syntax) {
  use pos <- do(get_pos())
  use _ <- do(keyword("cast"))
  use <- commit()
  use <- ws()
  use _ <- do(char("("))
  use a <- do(lazy(expr))
  use _ <- do(char(","))
  use inter <- do(lazy(expr))
  use _ <- do(char(","))
  use eq <- do(lazy(expr))
  use _ <- do(char(")"))
  return(CastSyntax(a, inter, eq, pos))
}

fn exfalso() -> Parser(Syntax) {
  use pos <- do(get_pos())
  use _ <- do(keyword("exfalso"))
  use <- commit()
  use <- ws()
  use _ <- do(char("("))
  use a <- do(lazy(expr))
  use _ <- do(char(")"))
  return(ExFalsoSyntax(a, pos))
}

pub type Suffix {
  AppSuffix(BinderMode, Syntax, pos: Pos)
  PiSuffix(Syntax, pos: Pos)
  EqSuffix(Syntax, pos: Pos)
  InterSuffix(Syntax, pos: Pos)
  FstSuffix(pos: Pos)
  SndSuffix(pos: Pos)
}

pub fn expr() -> Parser(Syntax) {
  use <- ws()
  use e <- do(label(
    any_of([
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
    "expression",
  ))
  use <- ws()
  use suffices <- do(
    many0({
      use <- ws()
      any_of([
        {
          use pos <- do(get_pos())
          use _ <- do(char("("))
          use <- commit()
          use arg <- do(lazy(expr))
          use _ <- do(char(")"))
          return(AppSuffix(ManyMode, arg, pos))
        },
        {
          use pos <- do(get_pos())
          use _ <- do(char("<"))
          use <- commit()
          use arg <- do(lazy(expr))
          use _ <- do(char(">"))
          return(AppSuffix(ZeroMode, arg, pos))
        },
        {
          use pos <- do(get_pos())
          use _ <- do(string("=>"))
          use <- commit()
          use rett <- do(lazy(expr))
          return(PiSuffix(rett, pos))
        },
        {
          use pos <- do(get_pos())
          use _ <- do(char("="))
          use <- commit()
          use b <- do(lazy(expr))
          return(EqSuffix(b, pos))
        },
        {
          use pos <- do(get_pos())
          use _ <- do(char("&"))
          use <- commit()
          use b <- do(lazy(expr))
          return(InterSuffix(b, pos))
        },
        {
          use pos <- do(get_pos())
          use _ <- do(char("."))
          use <- commit()
          use proj <- do(either(char("1"), char("2")))
          case proj {
            "1" -> return(FstSuffix(pos))
            "2" -> return(SndSuffix(pos))
            _ -> panic as "impossible projection"
          }
        },
      ])
    }),
  )
  let e = case suffices {
    [] -> e
    _ ->
      list.fold(suffices, e, fn(ex, suffix) {
        case suffix {
          AppSuffix(mode, arg, pos) -> AppSyntax(mode, ex, arg, pos)
          PiSuffix(rett, pos) ->
            PiSyntax(ManyMode, Explicit, "_", ex, rett, pos)
          EqSuffix(b, pos) -> EqSyntax(ex, b, pos)
          InterSuffix(b, pos) -> IntersectionTypeSyntax("_", ex, b, pos)
          FstSuffix(pos) -> FstSyntax(ex, pos)
          SndSuffix(pos) -> SndSyntax(ex, pos)
        }
      })
  }
  use <- ws()
  return(e)
}
