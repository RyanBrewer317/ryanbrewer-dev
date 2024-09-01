import * as $list from "../../../gleam_stdlib/gleam/list.mjs";
import * as $result from "../../../gleam_stdlib/gleam/result.mjs";
import { Ok, Error, toList, prepend as listPrepend, CustomType as $CustomType } from "../../gleam.mjs";
import * as $token from "../../gsv/internal/token.mjs";
import { CR, Comma, Doublequote, LF, Location, Textdata } from "../../gsv/internal/token.mjs";

class Beginning extends $CustomType {}

class JustParsedField extends $CustomType {}

class JustParsedComma extends $CustomType {}

class JustParsedNewline extends $CustomType {}

class JustParsedCR extends $CustomType {}

class InsideEscapedString extends $CustomType {}

export class ParseError extends $CustomType {
  constructor(location, message) {
    super();
    this.location = location;
    this.message = message;
  }
}

function parse_p(loop$input, loop$parse_state, loop$llf) {
  while (true) {
    let input = loop$input;
    let parse_state = loop$parse_state;
    let llf = loop$llf;
    if (input.hasLength(0) && parse_state instanceof Beginning) {
      return new Error(new ParseError(new Location(0, 0), "Empty input"));
    } else if (input.hasLength(0)) {
      let llf$1 = llf;
      return new Ok(llf$1);
    } else if (input.atLeastLength(1) &&
    input.head[0] instanceof Textdata &&
    parse_state instanceof Beginning &&
    llf.hasLength(0)) {
      let str = input.head[0].inner;
      let remaining_tokens = input.tail;
      loop$input = remaining_tokens;
      loop$parse_state = new JustParsedField();
      loop$llf = toList([toList([str])]);
    } else if (input.atLeastLength(1) &&
    input.head[0] instanceof Doublequote &&
    parse_state instanceof Beginning &&
    llf.hasLength(0)) {
      let remaining_tokens = input.tail;
      loop$input = remaining_tokens;
      loop$parse_state = new InsideEscapedString();
      loop$llf = toList([toList([""])]);
    } else if (input.atLeastLength(1) && parse_state instanceof Beginning) {
      let tok = input.head[0];
      let loc = input.head[1];
      return new Error(
        new ParseError(
          loc,
          "Unexpected start to csv content: " + $token.to_lexeme(tok),
        ),
      );
    } else if (input.atLeastLength(1) &&
    input.head[0] instanceof Comma &&
    parse_state instanceof JustParsedField) {
      let remaining_tokens = input.tail;
      let llf$1 = llf;
      loop$input = remaining_tokens;
      loop$parse_state = new JustParsedComma();
      loop$llf = llf$1;
    } else if (input.atLeastLength(1) &&
    input.head[0] instanceof LF &&
    parse_state instanceof JustParsedField) {
      let remaining_tokens = input.tail;
      let llf$1 = llf;
      loop$input = remaining_tokens;
      loop$parse_state = new JustParsedNewline();
      loop$llf = llf$1;
    } else if (input.atLeastLength(1) &&
    input.head[0] instanceof CR &&
    parse_state instanceof JustParsedField) {
      let remaining_tokens = input.tail;
      let llf$1 = llf;
      loop$input = remaining_tokens;
      loop$parse_state = new JustParsedCR();
      loop$llf = llf$1;
    } else if (input.atLeastLength(1) && parse_state instanceof JustParsedField) {
      let tok = input.head[0];
      let loc = input.head[1];
      return new Error(
        new ParseError(
          loc,
          "Expected comma or newline after field, found: " + $token.to_lexeme(
            tok,
          ),
        ),
      );
    } else if (input.atLeastLength(1) &&
    input.head[0] instanceof LF &&
    parse_state instanceof JustParsedCR) {
      let remaining_tokens = input.tail;
      let llf$1 = llf;
      loop$input = remaining_tokens;
      loop$parse_state = new JustParsedNewline();
      loop$llf = llf$1;
    } else if (input.atLeastLength(1) && parse_state instanceof JustParsedCR) {
      let tok = input.head[0];
      let loc = input.head[1];
      return new Error(
        new ParseError(
          loc,
          "Expected \"\\n\" after \"\\r\", found: " + $token.to_lexeme(tok),
        ),
      );
    } else if (input.atLeastLength(1) &&
    input.head[0] instanceof Textdata &&
    parse_state instanceof JustParsedComma &&
    llf.atLeastLength(1)) {
      let str = input.head[0].inner;
      let remaining_tokens = input.tail;
      let curr_line = llf.head;
      let previously_parsed_lines = llf.tail;
      loop$input = remaining_tokens;
      loop$parse_state = new JustParsedField();
      loop$llf = listPrepend(
        listPrepend(str, curr_line),
        previously_parsed_lines,
      );
    } else if (input.atLeastLength(1) &&
    input.head[0] instanceof Doublequote &&
    parse_state instanceof JustParsedComma &&
    llf.atLeastLength(1)) {
      let remaining_tokens = input.tail;
      let curr_line = llf.head;
      let previously_parsed_lines = llf.tail;
      loop$input = remaining_tokens;
      loop$parse_state = new InsideEscapedString();
      loop$llf = listPrepend(
        listPrepend("", curr_line),
        previously_parsed_lines,
      );
    } else if (input.atLeastLength(1) &&
    input.head[0] instanceof Comma &&
    parse_state instanceof JustParsedComma &&
    llf.atLeastLength(1)) {
      let remaining_tokens = input.tail;
      let curr_line = llf.head;
      let previously_parsed_lines = llf.tail;
      loop$input = remaining_tokens;
      loop$parse_state = new JustParsedComma();
      loop$llf = listPrepend(
        listPrepend("", curr_line),
        previously_parsed_lines,
      );
    } else if (input.atLeastLength(1) &&
    input.head[0] instanceof CR &&
    parse_state instanceof JustParsedComma &&
    llf.atLeastLength(1)) {
      let remaining_tokens = input.tail;
      let curr_line = llf.head;
      let previously_parsed_lines = llf.tail;
      loop$input = remaining_tokens;
      loop$parse_state = new JustParsedCR();
      loop$llf = listPrepend(
        listPrepend("", curr_line),
        previously_parsed_lines,
      );
    } else if (input.atLeastLength(1) &&
    input.head[0] instanceof LF &&
    parse_state instanceof JustParsedComma &&
    llf.atLeastLength(1)) {
      let remaining_tokens = input.tail;
      let curr_line = llf.head;
      let previously_parsed_lines = llf.tail;
      loop$input = remaining_tokens;
      loop$parse_state = new JustParsedNewline();
      loop$llf = listPrepend(
        listPrepend("", curr_line),
        previously_parsed_lines,
      );
    } else if (input.atLeastLength(1) && parse_state instanceof JustParsedComma) {
      let tok = input.head[0];
      let loc = input.head[1];
      return new Error(
        new ParseError(
          loc,
          "Expected escaped or non-escaped string after comma, found: " + $token.to_lexeme(
            tok,
          ),
        ),
      );
    } else if (input.atLeastLength(1) &&
    input.head[0] instanceof Textdata &&
    parse_state instanceof JustParsedNewline) {
      let str = input.head[0].inner;
      let remaining_tokens = input.tail;
      let llf$1 = llf;
      loop$input = remaining_tokens;
      loop$parse_state = new JustParsedField();
      loop$llf = listPrepend(toList([str]), llf$1);
    } else if (input.atLeastLength(1) &&
    input.head[0] instanceof Doublequote &&
    parse_state instanceof JustParsedNewline &&
    llf.atLeastLength(1)) {
      let remaining_tokens = input.tail;
      let curr_line = llf.head;
      let previously_parsed_lines = llf.tail;
      loop$input = remaining_tokens;
      loop$parse_state = new InsideEscapedString();
      loop$llf = listPrepend(
        listPrepend("", curr_line),
        previously_parsed_lines,
      );
    } else if (input.atLeastLength(1) &&
    parse_state instanceof JustParsedNewline) {
      let tok = input.head[0];
      let loc = input.head[1];
      return new Error(
        new ParseError(
          loc,
          "Expected escaped or non-escaped string after newline, found: " + $token.to_lexeme(
            tok,
          ),
        ),
      );
    } else if (input.atLeastLength(2) &&
    input.head[0] instanceof Doublequote &&
    input.tail.head[0] instanceof Doublequote &&
    parse_state instanceof InsideEscapedString &&
    llf.atLeastLength(1) &&
    llf.head.atLeastLength(1)) {
      let remaining_tokens = input.tail.tail;
      let str = llf.head.head;
      let rest_curr_line = llf.head.tail;
      let previously_parsed_lines = llf.tail;
      loop$input = remaining_tokens;
      loop$parse_state = new InsideEscapedString();
      loop$llf = listPrepend(
        listPrepend(str + "\"", rest_curr_line),
        previously_parsed_lines,
      );
    } else if (input.atLeastLength(1) &&
    input.head[0] instanceof Doublequote &&
    parse_state instanceof InsideEscapedString) {
      let remaining_tokens = input.tail;
      let llf$1 = llf;
      loop$input = remaining_tokens;
      loop$parse_state = new JustParsedField();
      loop$llf = llf$1;
    } else if (input.atLeastLength(1) &&
    parse_state instanceof InsideEscapedString &&
    llf.atLeastLength(1) &&
    llf.head.atLeastLength(1)) {
      let other_token = input.head[0];
      let remaining_tokens = input.tail;
      let str = llf.head.head;
      let rest_curr_line = llf.head.tail;
      let previously_parsed_lines = llf.tail;
      loop$input = remaining_tokens;
      loop$parse_state = new InsideEscapedString();
      loop$llf = listPrepend(
        listPrepend(str + $token.to_lexeme(other_token), rest_curr_line),
        previously_parsed_lines,
      );
    } else {
      let tok = input.head[0];
      let loc = input.head[1];
      return new Error(
        new ParseError(loc, "Unexpected token: " + $token.to_lexeme(tok)),
      );
    }
  }
}

export function parse(input) {
  let inner_rev = $result.try$(
    parse_p(input, new Beginning(), toList([])),
    (llf) => {
      return $list.try_map(llf, (lf) => { return new Ok($list.reverse(lf)); });
    },
  );
  return $result.try$(inner_rev, (ir) => { return new Ok($list.reverse(ir)); });
}
