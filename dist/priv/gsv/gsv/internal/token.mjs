import * as $list from "../../../gleam_stdlib/gleam/list.mjs";
import * as $string from "../../../gleam_stdlib/gleam/string.mjs";
import { toList, prepend as listPrepend, CustomType as $CustomType } from "../../gleam.mjs";

export class Comma extends $CustomType {}

export class LF extends $CustomType {}

export class CR extends $CustomType {}

export class Doublequote extends $CustomType {}

export class Textdata extends $CustomType {
  constructor(inner) {
    super();
    this.inner = inner;
  }
}

export class Location extends $CustomType {
  constructor(line, column) {
    super();
    this.line = line;
    this.column = column;
  }
}

export function to_lexeme(token) {
  if (token instanceof Comma) {
    return ",";
  } else if (token instanceof LF) {
    return "\n";
  } else if (token instanceof CR) {
    return "\r";
  } else if (token instanceof Doublequote) {
    return "\"";
  } else {
    let str = token.inner;
    return str;
  }
}

function len(token) {
  if (token instanceof Comma) {
    return 1;
  } else if (token instanceof LF) {
    return 1;
  } else if (token instanceof CR) {
    return 1;
  } else if (token instanceof Doublequote) {
    return 1;
  } else {
    let str = token.inner;
    return $string.length(str);
  }
}

export function scan(input) {
  let _pipe = input;
  let _pipe$1 = $string.to_utf_codepoints(_pipe);
  let _pipe$2 = $list.fold(
    _pipe$1,
    toList([]),
    (acc, x) => {
      let $ = $string.utf_codepoint_to_int(x);
      if ($ === 0x2c) {
        return listPrepend(new Comma(), acc);
      } else if ($ === 0x22) {
        return listPrepend(new Doublequote(), acc);
      } else if ($ === 0xa) {
        return listPrepend(new LF(), acc);
      } else if ($ === 0xD) {
        return listPrepend(new CR(), acc);
      } else {
        let cp = $string.from_utf_codepoints(toList([x]));
        if (acc.atLeastLength(1) && acc.head instanceof Textdata) {
          let str = acc.head.inner;
          let rest = acc.tail;
          return listPrepend(new Textdata(str + cp), rest);
        } else {
          return listPrepend(new Textdata(cp), acc);
        }
      }
    },
  );
  return $list.reverse(_pipe$2);
}

function do_with_location(loop$input, loop$acc, loop$curr_loc) {
  while (true) {
    let input = loop$input;
    let acc = loop$acc;
    let curr_loc = loop$curr_loc;
    let line = curr_loc.line;
    let column = curr_loc.column;
    if (input.hasLength(0)) {
      return acc;
    } else if (input.atLeastLength(1) && input.head instanceof LF) {
      let rest = input.tail;
      loop$input = rest;
      loop$acc = listPrepend([new LF(), curr_loc], acc);
      loop$curr_loc = new Location(line + 1, 1);
    } else if (input.atLeastLength(2) &&
    input.head instanceof CR &&
    input.tail.head instanceof LF) {
      let rest = input.tail.tail;
      loop$input = rest;
      loop$acc = listPrepend(
        [new LF(), new Location(line, column + 1)],
        listPrepend([new CR(), curr_loc], acc),
      );
      loop$curr_loc = new Location(line + 1, 1);
    } else {
      let token = input.head;
      let rest = input.tail;
      loop$input = rest;
      loop$acc = listPrepend([token, curr_loc], acc);
      loop$curr_loc = new Location(line, column + len(token));
    }
  }
}

export function with_location(input) {
  let _pipe = do_with_location(input, toList([]), new Location(1, 1));
  return $list.reverse(_pipe);
}
