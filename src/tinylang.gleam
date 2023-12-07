import party as p
import gleam/map.{type Map}
import gleam/result
import gleam/int
import gleam/string
import gleam/list

type Expr {
  LInt(Int)
  LVar(String)
  LLambda(String, Expr)
  LCall(Expr, Expr)
}

fn parse_int() -> p.Parser(Expr, e) {
  p.many1(p.digit())
  |> p.map(string.concat)
  |> p.map(int.parse)
  |> p.map(result.lazy_unwrap(_, or: fn() { panic as "parsed int isn't an int" }))
  |> p.map(LInt)
}

fn parse_var_string() -> p.Parser(String, e) {
  use first <- p.do(p.letter())
  use rest <- p.do(p.many(p.alt(p.alphanum(), p.char("_"))))
  p.return(first <> string.concat(rest))
}

fn parse_var() -> p.Parser(Expr, e) {
  parse_var_string()
  |> p.map(LVar)
}

fn parse_lambda() -> p.Parser(Expr, e) {
  use _ <- p.do(p.char("\\"))
  use _ <- p.do(ws())
  use x <- p.do(parse_var_string())
  use _ <- p.do(ws())
  use _ <- p.do(p.char("."))
  use _ <- p.do(ws())
  use e <- p.do(p.lazy(expr))
  p.return(LLambda(x, e))
}

fn expr() -> p.Parser(Expr, e) {
  use _ <- p.do(ws())
  use lit <- p.do(p.choice([
    parse_int(),
    parse_var(),
    parse_lambda(),
    parenthetical(),
  ]))
  use _ <- p.do(ws())
  use args <- p.do(p.many({
    use _ <- p.do(p.char("("))
    use arg <- p.do(p.lazy(expr))
    use _ <- p.do(p.char(")"))
    use _ <- p.do(ws())
    p.return(arg)
  }))
  let e = list.fold(args, lit, LCall)
  p.return(e)
}

fn parenthetical() -> p.Parser(Expr, e) {
  use _ <- p.do(p.char("("))
  use e <- p.do(p.lazy(expr))
  use _ <- p.do(p.char(")"))
  p.return(e)
}

fn ws() -> p.Parser(Nil, e) {
  use _ <- p.do(p.many(p.choice([p.char(" "), p.char("\t"), p.char("\n")])))
  p.return(Nil)
}

type Gen {
  Gen(int: Int)
}

type Wrapped(a) {
  Wrapped(gen: Gen, val: a)
}

fn with_fresh_res(
  gen: Gen,
  f: fn(Gen, Int) -> Result(Wrapped(a), e),
) -> Result(Wrapped(a), e) {
  f(Gen(gen.int + 1), gen.int)
}

fn wrap(a: a, gen: Gen) -> Wrapped(a) {
  Wrapped(gen, a)
}

fn do_wrap_res(gen: Gen, k: fn() -> a) -> Result(Wrapped(a), String) {
  Ok(Wrapped(gen, k()))
}

type IR {
  IRInt(Int)
  IRVar(Int)
  IRLambda(Int, IR)
  IRCall(IR, IR)
}

fn translate(gen: Gen, e: Expr) -> Result(#(IR, Map(Int, String)), String) {
  use Wrapped(_, out) <- result.try(translate_helper(
    gen,
    e,
    map.new(),
    map.new(),
  ))
  Ok(out)
}

fn translate_helper(
  gen: Gen,
  e: Expr,
  renames: Map(String, Int),
  renames2: Map(Int, String),
) -> Result(Wrapped(#(IR, Map(Int, String))), String) {
  case e {
    LInt(i) ->
      Ok(
        #(IRInt(i), renames2)
        |> wrap(gen),
      )
    LVar(x) ->
      case map.get(renames, x) {
        Ok(i) ->
          Ok(
            #(IRVar(i), renames2)
            |> wrap(gen),
          )
        Error(Nil) -> Error("Wait! " <> x <> " isn't defined anywhere!")
      }
    LLambda(x, e) -> {
      use gen, i <- with_fresh_res(gen)
      use Wrapped(gen, #(e, renames2)) <- result.try(translate_helper(
        gen,
        e,
        map.insert(renames, x, i),
        renames2,
      ))
      use <- do_wrap_res(gen)
      #(IRLambda(i, e), map.insert(renames2, i, x))
    }
    LCall(func, arg) -> {
      use Wrapped(gen, #(func, renames2)) <- result.try(translate_helper(
        gen,
        func,
        renames,
        renames2,
      ))
      use Wrapped(gen, #(arg, renames2)) <- result.try(translate_helper(
        gen,
        arg,
        renames,
        renames2,
      ))
      use <- do_wrap_res(gen)
      #(IRCall(func, arg), renames2)
    }
  }
}

fn eval(e: IR) -> IR {
  eval_helper(e, map.new())
}

fn eval_helper(e: IR, heap: Map(Int, IR)) -> IR {
  case e {
    IRInt(_) | IRLambda(_, _) -> e
    IRVar(i) ->
      result.lazy_unwrap(
        map.get(heap, i),
        or: fn() { panic as "undefined after renaming" },
      )
    IRCall(func, arg) -> {
      let func = eval_helper(func, heap)
      let arg = eval_helper(arg, heap)
      case func {
        IRLambda(i, e) -> eval_helper(substitute(from: i, to: arg, in: e), heap)
        _ -> IRCall(func, arg)
      }
    }
  }
}

fn substitute(from old: Int, to new: IR, in e: IR) -> IR {
  let sub = substitute(from: old, to: new, in: _)
  case e {
    IRVar(i) if i == old -> new
    IRLambda(i, _) if i == old -> e
    IRLambda(i, e) -> IRLambda(i, sub(e))
    IRCall(func, arg) -> IRCall(sub(func), sub(arg))
    IRVar(_) | IRInt(_) -> e
  }
}

fn pretty(e: IR, renames: Map(Int, String)) -> String {
  case e {
    IRInt(i) -> int.to_string(i)
    IRVar(i) ->
      result.lazy_unwrap(
        map.get(renames, i),
        or: fn() { panic as "identifier with no rename" },
      )
    IRLambda(i, e) ->
      "\\" <> result.lazy_unwrap(
        map.get(renames, i),
        or: fn() { panic as "parameter with no rename" },
      ) <> ". " <> pretty(e, renames)
    IRCall(func, arg) ->
      pretty(func, renames) <> "(" <> pretty(arg, renames) <> ")"
  }
}

fn squash_res(res: Result(a, a)) -> a {
  case res {
    Ok(a) -> a
    Error(a) -> a
  }
}

pub fn go(code: String) -> String {
  {
    use e <- result.try(result.replace_error(
      p.go(expr(), code),
      "there's a mistake in the notation somewhere; I couldn't understand it!",
    ))
    use #(ir, renames) <- result.try(translate(Gen(0), e))
    let val = eval(ir)
    Ok(pretty(val, renames))
  }
  |> squash_res()
}
