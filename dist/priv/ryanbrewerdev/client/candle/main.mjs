import * as $result from "../../../gleam_stdlib/gleam/result.mjs";
import * as $elab from "../../client/candle/elab.mjs";
import * as $header from "../../client/candle/header.mjs";
import * as $parser from "../../client/candle/parser.mjs";
import { Ok, toList } from "../../gleam.mjs";

function go_helper(code) {
  return $result.try$(
    $parser.parse(code, $parser.expr()),
    (s) => {
      return $result.try$(
        $elab.infer($elab.empty_ctx, s),
        (_use0) => {
          let t = _use0[0];
          let ty = _use0[1];
          let t2 = $elab.eval$(t, toList([]));
          return new Ok(
            ($header.pretty_value(t2) + " : ") + $header.pretty_value(ty),
          );
        },
      );
    },
  );
}

export function go(code) {
  let $ = go_helper(code);
  if ($ instanceof Ok) {
    let out = $[0];
    return out;
  } else {
    let err = $[0];
    return err;
  }
}
