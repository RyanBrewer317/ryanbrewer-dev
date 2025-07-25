import * as $bool from "../gleam_stdlib/gleam/bool.mjs";
import * as $option from "../gleam_stdlib/gleam/option.mjs";
import * as $order from "../gleam_stdlib/gleam/order.mjs";
import * as $yielder from "../gleam_yielder/gleam/yielder.mjs";
import { Ok, Error, CustomType as $CustomType } from "./gleam.mjs";

class Forward extends $CustomType {}

class Backward extends $CustomType {}

export function create(validate, negate_step, add, compare) {
  let adjust_step = (a, b, step) => {
    let negated_step = negate_step(step);
    let $ = compare(a, b);
    let $1 = compare(a, add(a, step));
    let $2 = compare(a, add(a, negated_step));
    if ($ instanceof $order.Lt) {
      if ($2 instanceof $order.Lt) {
        if ($1 instanceof $order.Lt) {
          return new Ok(new $option.Some([new Forward(), step]));
        } else {
          return new Ok(new $option.Some([new Forward(), negated_step]));
        }
      } else if ($2 instanceof $order.Eq) {
        if ($1 instanceof $order.Lt) {
          return new Ok(new $option.Some([new Forward(), step]));
        } else if ($1 instanceof $order.Eq) {
          return new Ok(new $option.None());
        } else {
          return new Error(undefined);
        }
      } else if ($1 instanceof $order.Lt) {
        return new Ok(new $option.Some([new Forward(), step]));
      } else {
        return new Error(undefined);
      }
    } else if ($ instanceof $order.Eq) {
      return new Ok(new $option.None());
    } else if ($2 instanceof $order.Eq) {
      if ($1 instanceof $order.Eq) {
        return new Ok(new $option.None());
      } else if ($1 instanceof $order.Gt) {
        return new Ok(new $option.Some([new Backward(), step]));
      } else {
        return new Error(undefined);
      }
    } else if ($2 instanceof $order.Gt) {
      if ($1 instanceof $order.Gt) {
        return new Ok(new $option.Some([new Backward(), step]));
      } else {
        return new Ok(new $option.Some([new Backward(), negated_step]));
      }
    } else if ($1 instanceof $order.Gt) {
      return new Ok(new $option.Some([new Backward(), step]));
    } else {
      return new Error(undefined);
    }
  };
  return (a, b, s) => {
    return $bool.guard(
      !validate(a) || !validate(b),
      new Error(undefined),
      () => {
        let $ = adjust_step(a, b, s);
        if ($ instanceof Ok) {
          let $1 = $[0];
          if ($1 instanceof $option.Some) {
            let direction = $1[0][0];
            let step = $1[0][1];
            return new Ok(
              $yielder.unfold(
                a,
                (current) => {
                  let $2 = compare(current, b);
                  if (direction instanceof Forward) {
                    if ($2 instanceof $order.Gt) {
                      return new $yielder.Done();
                    } else {
                      return new $yielder.Next(current, add(current, step));
                    }
                  } else if ($2 instanceof $order.Lt) {
                    return new $yielder.Done();
                  } else {
                    return new $yielder.Next(current, add(current, step));
                  }
                },
              ),
            );
          } else {
            return new Ok($yielder.once(() => { return a; }));
          }
        } else {
          return new Error(undefined);
        }
      },
    );
  };
}

export function create_infinite(validate, add, compare) {
  let is_step_zero = (a, s) => {
    let $ = compare(a, add(a, s));
    if ($ instanceof $order.Eq) {
      return true;
    } else {
      return false;
    }
  };
  return (a, s) => {
    return $bool.guard(
      !validate(a),
      new Error(undefined),
      () => {
        return $bool.guard(
          is_step_zero(a, s),
          (() => {
            let _pipe = $yielder.once(() => { return a; });
            return new Ok(_pipe);
          })(),
          () => {
            let _pipe = $yielder.unfold(
              a,
              (current) => {
                return new $yielder.Next(current, add(current, s));
              },
            );
            return new Ok(_pipe);
          },
        );
      },
    );
  };
}
