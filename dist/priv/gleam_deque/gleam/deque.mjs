import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import {
  Ok,
  Error,
  toList,
  Empty as $Empty,
  prepend as listPrepend,
  CustomType as $CustomType,
  isEqual,
} from "../gleam.mjs";

class Deque extends $CustomType {
  constructor(in$, out) {
    super();
    this.in = in$;
    this.out = out;
  }
}

export function new$() {
  return new Deque(toList([]), toList([]));
}

export function from_list(list) {
  return new Deque(toList([]), list);
}

export function to_list(deque) {
  let _pipe = deque.out;
  return $list.append(_pipe, $list.reverse(deque.in));
}

export function is_empty(deque) {
  return (isEqual(deque.in, toList([]))) && (isEqual(deque.out, toList([])));
}

export function length(deque) {
  return $list.length(deque.in) + $list.length(deque.out);
}

export function push_back(deque, item) {
  return new Deque(listPrepend(item, deque.in), deque.out);
}

export function push_front(deque, item) {
  return new Deque(deque.in, listPrepend(item, deque.out));
}

export function pop_back(loop$deque) {
  while (true) {
    let deque = loop$deque;
    let $ = deque.in;
    if ($ instanceof $Empty) {
      let $1 = deque.out;
      if ($1 instanceof $Empty) {
        return new Error(undefined);
      } else {
        let out = $1;
        loop$deque = new Deque($list.reverse(out), toList([]));
      }
    } else {
      let out = deque.out;
      let first = $.head;
      let rest = $.tail;
      let deque$1 = new Deque(rest, out);
      return new Ok([first, deque$1]);
    }
  }
}

export function pop_front(loop$deque) {
  while (true) {
    let deque = loop$deque;
    let $ = deque.out;
    if ($ instanceof $Empty) {
      let $1 = deque.in;
      if ($1 instanceof $Empty) {
        return new Error(undefined);
      } else {
        let in$ = $1;
        loop$deque = new Deque(toList([]), $list.reverse(in$));
      }
    } else {
      let in$ = deque.in;
      let first = $.head;
      let rest = $.tail;
      let deque$1 = new Deque(in$, rest);
      return new Ok([first, deque$1]);
    }
  }
}

export function reverse(deque) {
  return new Deque(deque.out, deque.in);
}

function check_equal(loop$xs, loop$x_tail, loop$ys, loop$y_tail, loop$eq) {
  while (true) {
    let xs = loop$xs;
    let x_tail = loop$x_tail;
    let ys = loop$ys;
    let y_tail = loop$y_tail;
    let eq = loop$eq;
    if (ys instanceof $Empty) {
      if (y_tail instanceof $Empty) {
        if (x_tail instanceof $Empty) {
          if (xs instanceof $Empty) {
            return true;
          } else {
            return false;
          }
        } else if (xs instanceof $Empty) {
          loop$xs = $list.reverse(x_tail);
          loop$x_tail = toList([]);
          loop$ys = ys;
          loop$y_tail = y_tail;
          loop$eq = eq;
        } else {
          return false;
        }
      } else if (x_tail instanceof $Empty) {
        loop$xs = xs;
        loop$x_tail = x_tail;
        loop$ys = $list.reverse(y_tail);
        loop$y_tail = toList([]);
        loop$eq = eq;
      } else if (xs instanceof $Empty) {
        loop$xs = $list.reverse(x_tail);
        loop$x_tail = toList([]);
        loop$ys = ys;
        loop$y_tail = y_tail;
        loop$eq = eq;
      } else {
        loop$xs = xs;
        loop$x_tail = x_tail;
        loop$ys = $list.reverse(y_tail);
        loop$y_tail = toList([]);
        loop$eq = eq;
      }
    } else if (xs instanceof $Empty) {
      if (x_tail instanceof $Empty) {
        return false;
      } else {
        loop$xs = $list.reverse(x_tail);
        loop$x_tail = toList([]);
        loop$ys = ys;
        loop$y_tail = y_tail;
        loop$eq = eq;
      }
    } else {
      let y = ys.head;
      let ys$1 = ys.tail;
      let x = xs.head;
      let xs$1 = xs.tail;
      let $ = eq(x, y);
      if ($) {
        loop$xs = xs$1;
        loop$x_tail = x_tail;
        loop$ys = ys$1;
        loop$y_tail = y_tail;
        loop$eq = eq;
      } else {
        return false;
      }
    }
  }
}

export function is_logically_equal(a, b, element_is_equal) {
  return check_equal(a.out, a.in, b.out, b.in, element_is_equal);
}

export function is_equal(a, b) {
  return check_equal(
    a.out,
    a.in,
    b.out,
    b.in,
    (a, b) => { return isEqual(a, b); },
  );
}
