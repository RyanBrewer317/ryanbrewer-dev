import client/candle/elab
import gleam/result
import client/candle/header
import client/candle/parser

fn go_helper(code) {
  use s <- result.try(parser.parse(code, parser.expr()))
  use #(t, ty) <- result.try(elab.infer(elab.empty_ctx, s))
  let t2 = elab.eval(t, [])
  Ok(header.pretty_value(t2) <> " : " <> header.pretty_value(ty))
}

pub fn go(code) {
  case go_helper(code) {
    Ok(out) -> out
    Error(err) -> err
  }
}