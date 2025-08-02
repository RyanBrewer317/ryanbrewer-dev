import elab
import gleam/io
import gleam/result
import header
import parser
import simplifile

fn go() {
  let assert Ok(code) = simplifile.read("./candle/main.cd")
  io.println(code)
  io.println("--")
  use s <- result.try(parser.parse(code, parser.expr()))
  // io.println(header.pretty_syntax(s))
  use #(t, ty) <- result.try(elab.infer(elab.empty_ctx, s))
  // io.println(header.pretty_term(t))
  let t2 = elab.eval(t, [])
  io.println(header.pretty_value(t2) <> " : " <> header.pretty_value(ty))
  Ok(Nil)
}

pub fn main() -> Nil {
  case go() {
    Error(e) -> {
      io.println(e)
      Nil
    }
    Ok(Nil) -> Nil
  }
}
