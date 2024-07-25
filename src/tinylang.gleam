import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import party as p

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
  use rest <- p.do(p.many(p.either(p.alphanum(), p.char("_"))))
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
  use lit <- p.do(
    p.choice([parse_int(), parse_var(), parse_lambda(), parenthetical()]),
  )
  use _ <- p.do(ws())
  use args <- p.do(
    p.many({
      use _ <- p.do(p.char("("))
      use arg <- p.do(p.lazy(expr))
      use _ <- p.do(p.char(")"))
      use _ <- p.do(ws())
      p.return(arg)
    }),
  )
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
  Wrapped(val: a, gen: Gen)
}

fn with_fresh_res(
  gen: Gen,
  f: fn(Gen, Int) -> Result(Wrapped(a), e),
) -> Result(Wrapped(a), e) {
  f(Gen(gen.int + 1), gen.int)
}

type IR {
  IRInt(Int)
  IRVar(Int, String)
  IRLambda(Int, String, IR)
  IRCall(IR, IR)
}

fn translate(gen: Gen, e: Expr) -> Result(IR, String) {
  use w <- result.try(translate_helper(gen, e, dict.new()))
  Ok(w.val)
}

fn translate_helper(
  gen: Gen,
  e: Expr,
  renames: Dict(String, Int),
) -> Result(Wrapped(IR), String) {
  case e {
    LInt(i) -> Ok(Wrapped(IRInt(i), gen))
    LVar(x) ->
      case dict.get(renames, x) {
        Ok(i) -> Ok(Wrapped(IRVar(i, x), gen))
        Error(Nil) -> Error("Wait! " <> x <> " isn't defined anywhere!")
      }
    LLambda(x, e) -> {
      use gen, i <- with_fresh_res(gen)
      use w <- result.try(translate_helper(gen, e, dict.insert(renames, x, i)))
      IRLambda(i, x, w.val)
      |> Wrapped(w.gen)
      |> Ok
    }
    LCall(func, arg) -> {
      use w1 <- result.try(translate_helper(gen, func, renames))
      use w2 <- result.try(translate_helper(w1.gen, arg, renames))
      IRCall(w1.val, w2.val)
      |> Wrapped(w2.gen)
      |> Ok
    }
  }
}

fn eval(e: IR) -> IR {
  eval_helper(e, dict.new())
}

fn eval_helper(e: IR, heap: Dict(Int, IR)) -> IR {
  case e {
    IRInt(_) -> e
    IRVar(i, _) ->
      case dict.get(heap, i) {
        Ok(val) -> val
        Error(Nil) -> e
      }
    IRCall(func, arg) -> {
      let func = eval_helper(func, heap)
      let arg = eval_helper(arg, heap)
      case func {
        IRLambda(i, _, e) -> eval_helper(e, dict.insert(heap, i, arg))
        _ -> IRCall(func, arg)
      }
    }
    IRLambda(i, x, e) ->
      // evaluate the body without giving the argument a value;
      // the evaluator will get as far as it can
      IRLambda(i, x, eval_helper(e, heap))
  }
}

fn pretty(e: IR) -> String {
  case e {
    IRInt(i) -> int.to_string(i)
    IRVar(_, x) -> x
    IRLambda(_, x, e) -> "\\" <> x <> ". " <> pretty(e)
    IRCall(IRLambda(_, _, _) as func, arg) ->
      "(" <> pretty(func) <> ")(" <> pretty(arg) <> ")"
    IRCall(func, arg) -> pretty(func) <> "(" <> pretty(arg) <> ")"
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
    use ir <- result.try(translate(Gen(0), e))
    let val = eval(ir)
    Ok(pretty(val))
  }
  |> squash_res()
}
