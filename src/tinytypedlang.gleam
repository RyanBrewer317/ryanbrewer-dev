import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import party as p

type Expr {
  LInt(Int)
  LVar(String)
  LLambda(String, Option(Expr), Expr)
  LCall(Expr, Expr)
  LUniverse
  LIntType
  LPi(String, Expr, Expr)
  LBinding(String, Option(Expr), Expr, Expr)
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
  use res <- p.do(p.perhaps(p.char(":")))
  use mb_t <- p.do(case res {
    Ok(_) -> p.map(p.lazy(expr), Some)
    Error(_) -> p.return(None)
  })
  use _ <- p.do(p.char("."))
  use _ <- p.do(ws())
  use e <- p.do(p.lazy(expr))
  p.return(LLambda(x, mb_t, e))
}

fn parse_universe() -> p.Parser(Expr, e) {
  use _ <- p.do(p.string("Type"))
  use _ <- p.do(p.not(p.alt(p.alphanum(), p.char("_"))))
  p.return(LUniverse)
}

fn parse_int_type() -> p.Parser(Expr, e) {
  use _ <- p.do(p.string("Int"))
  use _ <- p.do(p.not(p.alt(p.alphanum(), p.char("_"))))
  p.return(LIntType)
}

fn parse_pi_type() -> p.Parser(Expr, e) {
  use _ <- p.do(p.string("forall"))
  use _ <- p.do(p.not(p.alt(p.alphanum(), p.char("_"))))
  use _ <- p.do(ws())
  use x <- p.do(parse_var_string())
  use _ <- p.do(ws())
  use _ <- p.do(p.char(":"))
  use _ <- p.do(ws())
  use a <- p.do(p.lazy(expr))
  use _ <- p.do(p.char("."))
  use b <- p.do(p.lazy(expr))
  p.return(LPi(x, a, b))
}

fn parse_binding() -> p.Parser(Expr, e) {
  use _ <- p.do(p.string("let "))
  use _ <- p.do(ws())
  use x <- p.do(parse_var_string())
  use _ <- p.do(ws())
  use res <- p.do(p.perhaps(p.char(":")))
  use mb_t <- p.do(case res {
    Ok(_) -> p.map(p.lazy(expr), Some)
    Error(_) -> p.return(None)
  })
  use _ <- p.do(p.string("="))
  use v <- p.do(p.lazy(expr))
  use _ <- p.do(p.char(";"))
  use e <- p.do(p.lazy(expr))
  p.return(LBinding(x, mb_t, v, e))
}

fn expr() -> p.Parser(Expr, e) {
  use _ <- p.do(ws())
  use lit <- p.do(
    p.choice([
      parse_int(),
      parse_universe(),
      parse_int_type(),
      parse_pi_type(),
      parse_binding(),
      parse_var(),
      parse_lambda(),
      parenthetical(),
    ]),
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
  use res <- p.do(p.perhaps(p.string("->")))
  use e <- p.do(case res {
    Ok(_) -> {
      use rett <- p.do(p.lazy(expr))
      p.return(LPi("_", e, rett))
    }
    Error(_) -> p.return(e)
  })
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
  IRLambda(Int, String, Option(IR), IR)
  IRCall(IR, IR)
  IRUniverse
  IRIntType
  IRPi(Int, String, IR, IR)
  IRBinding(Int, String, Option(IR), IR, IR)
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
    LLambda(x, mb_t, e) -> {
      use gen, i <- with_fresh_res(gen)
      use w <- result.try(translate_helper(gen, e, dict.insert(renames, x, i)))
      use #(mb_t, gen) <- result.try(case mb_t {
        Some(t) ->
          result.map(translate_helper(gen, t, renames), fn(w) {
            #(Some(w.val), w.gen)
          })
        None -> Ok(#(None, gen))
      })
      IRLambda(i, x, mb_t, w.val)
      |> Wrapped(gen)
      |> Ok
    }
    LCall(func, arg) -> {
      use w1 <- result.try(translate_helper(gen, func, renames))
      use w2 <- result.try(translate_helper(w1.gen, arg, renames))
      IRCall(w1.val, w2.val)
      |> Wrapped(w2.gen)
      |> Ok
    }
    LUniverse -> Ok(Wrapped(IRUniverse, gen))
    LIntType -> Ok(Wrapped(IRIntType, gen))
    LPi(x, a, b) -> {
      use gen, i <- with_fresh_res(gen)
      use w1 <- result.try(translate_helper(gen, a, renames))
      use w2 <- result.try(translate_helper(
        w1.gen,
        b,
        dict.insert(renames, x, i),
      ))
      IRPi(i, x, w1.val, w2.val)
      |> Wrapped(w2.gen)
      |> Ok
    }
    LBinding(x, mb_t, v, e) -> {
      use gen, i <- with_fresh_res(gen)
      use #(mb_t, gen) <- result.try(case mb_t {
        Some(t) ->
          result.map(translate_helper(gen, t, renames), fn(w) {
            #(Some(w.val), w.gen)
          })
        None -> Ok(#(None, gen))
      })
      let renames = dict.insert(renames, x, i)
      use w2 <- result.try(translate_helper(gen, v, renames))
      use w3 <- result.try(translate_helper(w2.gen, e, renames))
      IRBinding(i, x, mb_t, w2.val, w3.val)
      |> Wrapped(w3.gen)
      |> Ok
    }
  }
}

fn subst(e: IR, i: Int, v: IR) -> IR {
  let s = subst(_, i, v)
  case e {
    IRInt(n) -> IRInt(n)
    IRVar(i2, _) ->
      case i == i2 {
        True -> v
        False -> e
      }
    IRLambda(i, x, mb_t, e) -> IRLambda(i, x, option.map(mb_t, s), s(e))
    IRCall(f, a) -> IRCall(s(f), s(a))
    IRUniverse -> IRUniverse
    IRIntType -> IRIntType
    IRPi(i, x, a, b) -> IRPi(i, x, s(a), s(b))
    IRBinding(i, x, mb_t, v, e) ->
      IRBinding(i, x, option.map(mb_t, s), s(v), s(e))
  }
}

fn type_eq(e1: IR, e2: IR, heap: Dict(Int, IR)) -> Bool {
  case eval_helper(e1, heap), eval_helper(e2, heap) {
    IRVar(i1, _), IRVar(i2, _) -> i1 == i2
    IRIntType, IRIntType -> True
    IRUniverse, IRUniverse -> True
    IRPi(i1, x, a1, b1), IRPi(i2, _, a2, b2) ->
      type_eq(a1, a2, heap) && type_eq(subst(b2, i2, IRVar(i1, x)), b1, heap)
    _, _ -> False
  }
}

fn infer_type(
  e: IR,
  gamma: Dict(Int, IR),
  heap: Dict(Int, IR),
) -> Result(IR, String) {
  case e {
    IRInt(_) -> Ok(IRIntType)
    IRVar(i, x) ->
      result.map_error(dict.get(gamma, i), fn(_) {
        "Variable " <> x <> " is not defined in the current context."
      })
    IRCall(func, arg) -> {
      use func_t <- result.try(infer_type(func, gamma, heap))
      case func_t {
        IRPi(i, _, param_t, ret_t) -> {
          use _ <- result.try(type_check(arg, param_t, gamma, heap))
          Ok(subst(ret_t, i, arg))
        }
        _ ->
          Error(
            "Type error. Expected a function type, but found " <> pretty(func_t),
          )
      }
    }
    IRPi(i, _, a, b) -> {
      use _ <- result.try(type_check(a, IRUniverse, gamma, heap))
      use _ <- result.try(type_check(
        b,
        IRUniverse,
        dict.insert(gamma, i, a),
        heap,
      ))
      Ok(IRUniverse)
    }
    IRIntType -> Ok(IRUniverse)
    IRUniverse -> Ok(IRUniverse)
    IRBinding(i, _, Some(t), v, e) -> {
      use _ <- result.try(type_check(v, t, gamma, heap))
      infer_type(e, dict.insert(gamma, i, t), dict.insert(heap, i, v))
    }
    IRBinding(i, _, None, v, e) -> {
      use v_t <- result.try(infer_type(v, gamma, heap))
      infer_type(e, dict.insert(gamma, i, v_t), dict.insert(heap, i, v))
    }
    IRLambda(i, x, Some(arg_t), e) -> {
      use t <- result.try(infer_type(e, dict.insert(gamma, i, arg_t), heap))
      Ok(IRPi(i, x, arg_t, t))
    }
    IRLambda(_, _, _, _) ->
      Error(
        "Type error. Can't infer the type of this lambda. Try annotating it with a `let` expression.",
      )
  }
}

fn type_check(
  e: IR,
  expected: IR,
  gamma: Dict(Int, IR),
  heap: Dict(Int, IR),
) -> Result(Nil, String) {
  case e {
    IRLambda(i, x, mb_t, e) ->
      case expected {
        IRPi(i2, _, param_t, ret_t) -> {
          use _ <- result.try(type_check(
            e,
            subst(ret_t, i2, IRVar(i, x)),
            dict.insert(gamma, i, param_t),
            heap,
          ))
          case mb_t {
            Some(x_t) ->
              case type_eq(x_t, param_t, heap) {
                True -> Ok(Nil)
                False ->
                  Error(
                    "Type mismatch in lambda parameter. Expected "
                    <> pretty(param_t)
                    <> " but found "
                    <> pretty(x_t)
                    <> ".",
                  )
              }
            None -> Ok(Nil)
          }
        }
        _ ->
          Error(
            "Type mismatch. Expected "
            <> pretty(expected)
            <> " but found a lambda.",
          )
      }
    _ -> {
      use t <- result.try(infer_type(e, gamma, heap))
      case type_eq(t, expected, heap) {
        True -> Ok(Nil)
        False ->
          Error(
            "Type mismatch. Expected "
            <> pretty(expected)
            <> " but found "
            <> pretty(t)
            <> ".",
          )
      }
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
        IRLambda(i, _, _, e) -> eval_helper(e, dict.insert(heap, i, arg))
        _ -> IRCall(func, arg)
      }
    }
    IRUniverse -> IRUniverse
    IRIntType -> IRIntType
    IRBinding(i, _, _, v, e) ->
      eval_helper(e, dict.insert(heap, i, eval_helper(v, heap)))
    // evaluate the body without giving the argument a value;
    // the evaluator will get as far as it can
    IRLambda(i, x, mb_t, e) -> IRLambda(i, x, mb_t, eval_helper(e, heap))
    IRPi(i, x, a, b) -> IRPi(i, x, eval_helper(a, heap), eval_helper(b, heap))
  }
}

fn occurs(x: Int, e: IR) -> Bool {
  case e {
    IRVar(i, _) -> i == x
    IRLambda(_, _, Some(t), e) -> occurs(x, t) || occurs(x, e)
    IRLambda(_, _, None, e) -> occurs(x, e)
    IRCall(func, arg) -> occurs(x, func) || occurs(x, arg)
    IRPi(_, _, a, b) -> occurs(x, a) || occurs(x, b)
    IRBinding(_, _, Some(t), v, e) ->
      occurs(x, t) || occurs(x, v) || occurs(x, e)
    IRBinding(_, _, None, v, e) -> occurs(x, v) || occurs(x, e)
    _ -> False
  }
}

fn pretty(e: IR) -> String {
  case e {
    IRInt(i) -> int.to_string(i)
    IRVar(_, x) -> x
    IRLambda(_, x, Some(t), e) ->
      "\\" <> x <> ": " <> pretty(t) <> ". " <> pretty(e)
    IRLambda(_, x, None, e) -> "\\" <> x <> ". " <> pretty(e)
    IRCall(IRLambda(_, _, _, _) as func, arg) ->
      "(" <> pretty(func) <> ")(" <> pretty(arg) <> ")"
    IRCall(func, arg) -> pretty(func) <> "(" <> pretty(arg) <> ")"
    IRUniverse -> "Type"
    IRIntType -> "Int"
    IRPi(i, x, a, b) ->
      case occurs(i, b) {
        True -> "forall " <> x <> ": " <> pretty(a) <> ". " <> pretty(b)
        False ->
          case a {
            IRInt(_) | IRVar(_, _) | IRUniverse | IRIntType ->
              pretty(a) <> "->" <> pretty(b)
            IRLambda(_, _, _, _)
            | IRCall(_, _)
            | IRPi(_, _, _, _)
            | IRBinding(_, _, _, _, _) ->
              "(" <> pretty(a) <> ") -> " <> pretty(b)
          }
      }
    IRBinding(_, x, Some(t), v, e) ->
      "let "
      <> x
      <> ": "
      <> pretty(t)
      <> " = "
      <> pretty(v)
      <> ";\n"
      <> pretty(e)
    IRBinding(_, x, None, v, e) ->
      "let " <> x <> " = " <> pretty(v) <> ";\n" <> pretty(e)
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
    use _ <- result.try(infer_type(ir, dict.new(), dict.new()))
    let val = eval(ir)
    Ok(pretty(val))
  }
  |> squash_res()
}
