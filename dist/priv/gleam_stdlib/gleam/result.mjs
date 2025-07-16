import { Ok, Error, toList, Empty as $Empty, prepend as listPrepend } from "../gleam.mjs";
import * as $list from "../gleam/list.mjs";

export function is_ok(result) {
  if (result instanceof Ok) {
    return true;
  } else {
    return false;
  }
}

export function is_error(result) {
  if (result instanceof Ok) {
    return false;
  } else {
    return true;
  }
}

export function map(result, fun) {
  if (result instanceof Ok) {
    let x = result[0];
    return new Ok(fun(x));
  } else {
    let e = result[0];
    return new Error(e);
  }
}

export function map_error(result, fun) {
  if (result instanceof Ok) {
    let x = result[0];
    return new Ok(x);
  } else {
    let error = result[0];
    return new Error(fun(error));
  }
}

export function flatten(result) {
  if (result instanceof Ok) {
    let x = result[0];
    return x;
  } else {
    let error = result[0];
    return new Error(error);
  }
}

export function try$(result, fun) {
  if (result instanceof Ok) {
    let x = result[0];
    return fun(x);
  } else {
    let e = result[0];
    return new Error(e);
  }
}

export function then$(result, fun) {
  return try$(result, fun);
}

export function unwrap(result, default$) {
  if (result instanceof Ok) {
    let v = result[0];
    return v;
  } else {
    return default$;
  }
}

export function lazy_unwrap(result, default$) {
  if (result instanceof Ok) {
    let v = result[0];
    return v;
  } else {
    return default$();
  }
}

export function unwrap_error(result, default$) {
  if (result instanceof Ok) {
    return default$;
  } else {
    let e = result[0];
    return e;
  }
}

export function unwrap_both(result) {
  if (result instanceof Ok) {
    let a = result[0];
    return a;
  } else {
    let a = result[0];
    return a;
  }
}

export function or(first, second) {
  if (first instanceof Ok) {
    return first;
  } else {
    return second;
  }
}

export function lazy_or(first, second) {
  if (first instanceof Ok) {
    return first;
  } else {
    return second();
  }
}

export function all(results) {
  return $list.try_map(results, (result) => { return result; });
}

function partition_loop(loop$results, loop$oks, loop$errors) {
  while (true) {
    let results = loop$results;
    let oks = loop$oks;
    let errors = loop$errors;
    if (results instanceof $Empty) {
      return [oks, errors];
    } else {
      let $ = results.head;
      if ($ instanceof Ok) {
        let rest = results.tail;
        let a = $[0];
        loop$results = rest;
        loop$oks = listPrepend(a, oks);
        loop$errors = errors;
      } else {
        let rest = results.tail;
        let e = $[0];
        loop$results = rest;
        loop$oks = oks;
        loop$errors = listPrepend(e, errors);
      }
    }
  }
}

export function partition(results) {
  return partition_loop(results, toList([]), toList([]));
}

export function replace(result, value) {
  if (result instanceof Ok) {
    return new Ok(value);
  } else {
    let error = result[0];
    return new Error(error);
  }
}

export function replace_error(result, error) {
  if (result instanceof Ok) {
    let x = result[0];
    return new Ok(x);
  } else {
    return new Error(error);
  }
}

export function values(results) {
  return $list.filter_map(results, (result) => { return result; });
}

export function try_recover(result, fun) {
  if (result instanceof Ok) {
    let value = result[0];
    return new Ok(value);
  } else {
    let error = result[0];
    return fun(error);
  }
}
