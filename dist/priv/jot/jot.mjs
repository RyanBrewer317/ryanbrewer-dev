import * as $bool from "../gleam_stdlib/gleam/bool.mjs";
import * as $dict from "../gleam_stdlib/gleam/dict.mjs";
import * as $int from "../gleam_stdlib/gleam/int.mjs";
import * as $list from "../gleam_stdlib/gleam/list.mjs";
import * as $option from "../gleam_stdlib/gleam/option.mjs";
import { None, Some } from "../gleam_stdlib/gleam/option.mjs";
import * as $result from "../gleam_stdlib/gleam/result.mjs";
import * as $string from "../gleam_stdlib/gleam/string.mjs";
import {
  Ok,
  Error,
  toList,
  prepend as listPrepend,
  CustomType as $CustomType,
  isEqual,
} from "./gleam.mjs";

export class Document extends $CustomType {
  constructor(content, references, footnotes) {
    super();
    this.content = content;
    this.references = references;
    this.footnotes = footnotes;
  }
}

export class ThematicBreak extends $CustomType {}

export class Paragraph extends $CustomType {
  constructor(attributes, x1) {
    super();
    this.attributes = attributes;
    this[1] = x1;
  }
}

export class Heading extends $CustomType {
  constructor(attributes, level, content) {
    super();
    this.attributes = attributes;
    this.level = level;
    this.content = content;
  }
}

export class Codeblock extends $CustomType {
  constructor(attributes, language, content) {
    super();
    this.attributes = attributes;
    this.language = language;
    this.content = content;
  }
}

export class Linebreak extends $CustomType {}

export class Text extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

export class Link extends $CustomType {
  constructor(content, destination) {
    super();
    this.content = content;
    this.destination = destination;
  }
}

export class Image extends $CustomType {
  constructor(content, destination) {
    super();
    this.content = content;
    this.destination = destination;
  }
}

export class Emphasis extends $CustomType {
  constructor(content) {
    super();
    this.content = content;
  }
}

export class Strong extends $CustomType {
  constructor(content) {
    super();
    this.content = content;
  }
}

export class Footnote extends $CustomType {
  constructor(reference) {
    super();
    this.reference = reference;
  }
}

export class Code extends $CustomType {
  constructor(content) {
    super();
    this.content = content;
  }
}

export class Reference extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

export class Url extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

class Refs extends $CustomType {
  constructor(urls, footnotes) {
    super();
    this.urls = urls;
    this.footnotes = footnotes;
  }
}

class GeneratedHtml extends $CustomType {
  constructor(html, used_footnotes) {
    super();
    this.html = html;
    this.used_footnotes = used_footnotes;
  }
}

function add_attribute(attributes, key, value) {
  if (key === "class") {
    return $dict.upsert(
      attributes,
      key,
      (previous) => {
        if (previous instanceof None) {
          return value;
        } else {
          let previous$1 = previous[0];
          return (previous$1 + " ") + value;
        }
      },
    );
  } else {
    return $dict.insert(attributes, key, value);
  }
}

function drop_lines(loop$in) {
  while (true) {
    let in$ = loop$in;
    if (in$.hasLength(0)) {
      return toList([]);
    } else if (in$.atLeastLength(1) && in$.head === "\n") {
      let rest = in$.tail;
      loop$in = rest;
    } else {
      let c = in$.head;
      let rest = in$.tail;
      return listPrepend(c, rest);
    }
  }
}

function drop_spaces(loop$in) {
  while (true) {
    let in$ = loop$in;
    if (in$.hasLength(0)) {
      return toList([]);
    } else if (in$.atLeastLength(1) && in$.head === " ") {
      let rest = in$.tail;
      loop$in = rest;
    } else {
      let c = in$.head;
      let rest = in$.tail;
      return listPrepend(c, rest);
    }
  }
}

function count_drop_spaces(loop$in, loop$count) {
  while (true) {
    let in$ = loop$in;
    let count = loop$count;
    if (in$.hasLength(0)) {
      return [toList([]), count];
    } else if (in$.atLeastLength(1) && in$.head === " ") {
      let rest = in$.tail;
      loop$in = rest;
      loop$count = count + 1;
    } else {
      let c = in$.head;
      let rest = in$.tail;
      return [listPrepend(c, rest), count];
    }
  }
}

function parse_thematic_break(loop$count, loop$in) {
  while (true) {
    let count = loop$count;
    let in$ = loop$in;
    if (in$.hasLength(0)) {
      let $ = count >= 3;
      if ($) {
        return new Some([new ThematicBreak(), in$]);
      } else {
        return new None();
      }
    } else if (in$.atLeastLength(1) && in$.head === "\n") {
      let $ = count >= 3;
      if ($) {
        return new Some([new ThematicBreak(), in$]);
      } else {
        return new None();
      }
    } else if (in$.atLeastLength(1) && in$.head === " ") {
      let rest = in$.tail;
      loop$count = count;
      loop$in = rest;
    } else if (in$.atLeastLength(1) && in$.head === "\t") {
      let rest = in$.tail;
      loop$count = count;
      loop$in = rest;
    } else if (in$.atLeastLength(1) && in$.head === "-") {
      let rest = in$.tail;
      loop$count = count + 1;
      loop$in = rest;
    } else if (in$.atLeastLength(1) && in$.head === "*") {
      let rest = in$.tail;
      loop$count = count + 1;
      loop$in = rest;
    } else {
      return new None();
    }
  }
}

function slurp_verbatim_line(loop$in, loop$indentation, loop$acc) {
  while (true) {
    let in$ = loop$in;
    let indentation = loop$indentation;
    let acc = loop$acc;
    if (in$.hasLength(0)) {
      return [acc, toList([])];
    } else if (in$.atLeastLength(1) && in$.head === " " && (indentation > 0)) {
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$indentation = indentation - 1;
      loop$acc = acc;
    } else if (in$.atLeastLength(1) && in$.head === "\n") {
      let in$1 = in$.tail;
      return [acc + "\n", in$1];
    } else {
      let c = in$.head;
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$indentation = 0;
      loop$acc = acc + c;
    }
  }
}

function parse_codeblock_end(loop$in, loop$delim, loop$count) {
  while (true) {
    let in$ = loop$in;
    let delim = loop$delim;
    let count = loop$count;
    if (in$.atLeastLength(1) && in$.head === "\n" && (count === 0)) {
      let in$1 = in$.tail;
      return new Some([in$1]);
    } else if (count === 0) {
      return new Some([in$]);
    } else if (in$.atLeastLength(1) && in$.head === " ") {
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$delim = delim;
      loop$count = count;
    } else if (in$.atLeastLength(1) && (in$.head === delim)) {
      let c = in$.head;
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$delim = delim;
      loop$count = count - 1;
    } else if (in$.hasLength(0)) {
      return new Some([in$]);
    } else {
      return new None();
    }
  }
}

function parse_codeblock_content(
  loop$in,
  loop$delim,
  loop$count,
  loop$indentation,
  loop$acc
) {
  while (true) {
    let in$ = loop$in;
    let delim = loop$delim;
    let count = loop$count;
    let indentation = loop$indentation;
    let acc = loop$acc;
    let $ = parse_codeblock_end(in$, delim, count);
    if ($ instanceof None) {
      let $1 = slurp_verbatim_line(in$, indentation, acc);
      let acc$1 = $1[0];
      let in$1 = $1[1];
      loop$in = in$1;
      loop$delim = delim;
      loop$count = count;
      loop$indentation = indentation;
      loop$acc = acc$1;
    } else {
      let in$1 = $[0][0];
      return [acc, in$1];
    }
  }
}

function parse_codeblock_language(loop$in, loop$language) {
  while (true) {
    let in$ = loop$in;
    let language = loop$language;
    if (in$.atLeastLength(1) && in$.head === "`") {
      return new None();
    } else if (in$.hasLength(0)) {
      return new Some([new None(), in$]);
    } else if (in$.atLeastLength(1) && in$.head === "\n" && (language === "")) {
      let in$1 = in$.tail;
      return new Some([new None(), in$1]);
    } else if (in$.atLeastLength(1) && in$.head === "\n") {
      let in$1 = in$.tail;
      return new Some([new Some(language), in$1]);
    } else {
      let c = in$.head;
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$language = language + c;
    }
  }
}

function parse_codeblock_start(loop$in, loop$delim, loop$count) {
  while (true) {
    let in$ = loop$in;
    let delim = loop$delim;
    let count = loop$count;
    if (in$.atLeastLength(1) && (in$.head === delim)) {
      let c = in$.head;
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$delim = delim;
      loop$count = count + 1;
    } else if (in$.atLeastLength(1) && in$.head === "\n" && (count >= 3)) {
      let in$1 = in$.tail;
      return new Some([new None(), count, in$1]);
    } else if (in$.atLeastLength(1) && (count >= 3)) {
      let in$1 = drop_spaces(in$);
      return $option.map(
        parse_codeblock_language(in$1, ""),
        (_use0) => {
          let language = _use0[0];
          let in$2 = _use0[1];
          return [language, count, in$2];
        },
      );
    } else {
      return new None();
    }
  }
}

function parse_codeblock(in$, attrs, delim, indentation) {
  return $option.then$(
    parse_codeblock_start(in$, delim, 1),
    (_use0) => {
      let language = _use0[0];
      let count = _use0[1];
      let in$1 = _use0[2];
      let $ = parse_codeblock_content(in$1, delim, count, indentation, "");
      let content = $[0];
      let in$2 = $[1];
      return new Some([new Codeblock(attrs, language, content), in$2]);
    },
  );
}

function parse_ref_value(loop$in, loop$id, loop$url) {
  while (true) {
    let in$ = loop$in;
    let id = loop$id;
    let url = loop$url;
    if (in$.hasLength(0)) {
      return new Some([id, $string.trim(url), toList([])]);
    } else if (in$.atLeastLength(2) &&
    in$.head === "\n" &&
    in$.tail.head === " ") {
      let in$1 = in$.tail.tail;
      loop$in = drop_spaces(in$1);
      loop$id = id;
      loop$url = url;
    } else if (in$.atLeastLength(1) && in$.head === "\n") {
      let in$1 = in$.tail;
      return new Some([id, $string.trim(url), in$1]);
    } else {
      let c = in$.head;
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$id = id;
      loop$url = url + c;
    }
  }
}

function parse_ref_def(loop$in, loop$id) {
  while (true) {
    let in$ = loop$in;
    let id = loop$id;
    if (in$.atLeastLength(2) && in$.head === "]" && in$.tail.head === ":") {
      let in$1 = in$.tail.tail;
      return parse_ref_value(in$1, id, "");
    } else if (in$.hasLength(0)) {
      return new None();
    } else if (in$.atLeastLength(1) && in$.head === "]") {
      return new None();
    } else if (in$.atLeastLength(1) && in$.head === "\n") {
      return new None();
    } else {
      let c = in$.head;
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$id = id + c;
    }
  }
}

function parse_attribute_value(loop$in, loop$key, loop$value) {
  while (true) {
    let in$ = loop$in;
    let key = loop$key;
    let value = loop$value;
    if (in$.hasLength(0)) {
      return new None();
    } else if (in$.atLeastLength(1) && in$.head === " ") {
      let in$1 = in$.tail;
      return new Some([key, value, in$1]);
    } else if (in$.atLeastLength(1) && in$.head === "}") {
      return new Some([key, value, in$]);
    } else {
      let c = in$.head;
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$key = key;
      loop$value = value + c;
    }
  }
}

function parse_attribute_quoted_value(loop$in, loop$key, loop$value) {
  while (true) {
    let in$ = loop$in;
    let key = loop$key;
    let value = loop$value;
    if (in$.hasLength(0)) {
      return new None();
    } else if (in$.atLeastLength(1) && in$.head === "\"") {
      let in$1 = in$.tail;
      return new Some([key, value, in$1]);
    } else {
      let c = in$.head;
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$key = key;
      loop$value = value + c;
    }
  }
}

function parse_attribute(loop$in, loop$key) {
  while (true) {
    let in$ = loop$in;
    let key = loop$key;
    if (in$.hasLength(0)) {
      return new None();
    } else if (in$.atLeastLength(1) && in$.head === " ") {
      return new None();
    } else if (in$.atLeastLength(2) &&
    in$.head === "=" &&
    in$.tail.head === "\"") {
      let in$1 = in$.tail.tail;
      return parse_attribute_quoted_value(in$1, key, "");
    } else if (in$.atLeastLength(1) && in$.head === "=") {
      let in$1 = in$.tail;
      return parse_attribute_value(in$1, key, "");
    } else {
      let c = in$.head;
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$key = key + c;
    }
  }
}

function parse_attributes_id_or_class(loop$in, loop$id) {
  while (true) {
    let in$ = loop$in;
    let id = loop$id;
    if (in$.hasLength(0)) {
      return new Some([id, in$]);
    } else if (in$.atLeastLength(1) && in$.head === "}") {
      return new Some([id, in$]);
    } else if (in$.atLeastLength(1) && in$.head === " ") {
      return new Some([id, in$]);
    } else if (in$.atLeastLength(1) && in$.head === "#") {
      return new None();
    } else if (in$.atLeastLength(1) && in$.head === ".") {
      return new None();
    } else if (in$.atLeastLength(1) && in$.head === "=") {
      return new None();
    } else if (in$.atLeastLength(1) && in$.head === "\n") {
      return new None();
    } else {
      let c = in$.head;
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$id = id + c;
    }
  }
}

function parse_attributes_end(loop$in, loop$attrs) {
  while (true) {
    let in$ = loop$in;
    let attrs = loop$attrs;
    if (in$.hasLength(0)) {
      return new Some([attrs, toList([])]);
    } else if (in$.atLeastLength(1) && in$.head === "\n") {
      let in$1 = in$.tail;
      return new Some([attrs, in$1]);
    } else if (in$.atLeastLength(1) && in$.head === " ") {
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$attrs = attrs;
    } else {
      return new None();
    }
  }
}

function parse_attributes(loop$in, loop$attrs) {
  while (true) {
    let in$ = loop$in;
    let attrs = loop$attrs;
    let in$1 = drop_spaces(in$);
    if (in$1.hasLength(0)) {
      return new None();
    } else if (in$1.atLeastLength(1) && in$1.head === "}") {
      let in$2 = in$1.tail;
      return parse_attributes_end(in$2, attrs);
    } else if (in$1.atLeastLength(1) && in$1.head === "#") {
      let in$2 = in$1.tail;
      let $ = parse_attributes_id_or_class(in$2, "");
      if ($ instanceof Some) {
        let id = $[0][0];
        let in$3 = $[0][1];
        loop$in = in$3;
        loop$attrs = add_attribute(attrs, "id", id);
      } else {
        return new None();
      }
    } else if (in$1.atLeastLength(1) && in$1.head === ".") {
      let in$2 = in$1.tail;
      let $ = parse_attributes_id_or_class(in$2, "");
      if ($ instanceof Some) {
        let c = $[0][0];
        let in$3 = $[0][1];
        loop$in = in$3;
        loop$attrs = add_attribute(attrs, "class", c);
      } else {
        return new None();
      }
    } else {
      let $ = parse_attribute(in$1, "");
      if ($ instanceof Some) {
        let k = $[0][0];
        let v = $[0][1];
        let in$2 = $[0][2];
        loop$in = in$2;
        loop$attrs = add_attribute(attrs, k, v);
      } else {
        return new None();
      }
    }
  }
}

function id_char(char) {
  if (char === "#") {
    return false;
  } else if (char === "?") {
    return false;
  } else if (char === "!") {
    return false;
  } else if (char === ",") {
    return false;
  } else {
    return true;
  }
}

function id_escape(loop$content, loop$acc) {
  while (true) {
    let content = loop$content;
    let acc = loop$acc;
    if (content.hasLength(0)) {
      return acc;
    } else if (content.atLeastLength(1) &&
    content.head === " " &&
    (isEqual(content.tail, toList([])))) {
      let rest = content.tail;
      return acc;
    } else if (content.atLeastLength(1) &&
    content.head === "\n" &&
    (isEqual(content.tail, toList([])))) {
      let rest = content.tail;
      return acc;
    } else if (content.atLeastLength(1) && content.head === " " && (acc === "")) {
      let rest = content.tail;
      loop$content = rest;
      loop$acc = acc;
    } else if (content.atLeastLength(1) && content.head === "\n" && (acc === "")) {
      let rest = content.tail;
      loop$content = rest;
      loop$acc = acc;
    } else if (content.atLeastLength(1) && content.head === " ") {
      let rest = content.tail;
      loop$content = rest;
      loop$acc = acc + "-";
    } else if (content.atLeastLength(1) && content.head === "\n") {
      let rest = content.tail;
      loop$content = rest;
      loop$acc = acc + "-";
    } else {
      let c = content.head;
      let rest = content.tail;
      loop$content = rest;
      loop$acc = acc + c;
    }
  }
}

function id_sanitise(content) {
  let _pipe = content;
  let _pipe$1 = $string.to_graphemes(_pipe);
  let _pipe$2 = $list.filter(_pipe$1, id_char);
  return id_escape(_pipe$2, "");
}

function take_heading_chars_newline_hash(loop$in, loop$level, loop$acc) {
  while (true) {
    let in$ = loop$in;
    let level = loop$level;
    let acc = loop$acc;
    if (level < 0) {
      return new None();
    } else if (in$.hasLength(0) && (level > 0)) {
      return new None();
    } else if (in$.hasLength(0) && (level === 0)) {
      return new Some([acc, toList([])]);
    } else if (in$.atLeastLength(1) && in$.head === " " && (level === 0)) {
      let in$1 = in$.tail;
      return new Some([acc, in$1]);
    } else if (in$.atLeastLength(1) && in$.head === "#") {
      let rest = in$.tail;
      loop$in = rest;
      loop$level = level - 1;
      loop$acc = acc;
    } else {
      return new None();
    }
  }
}

function take_heading_chars(loop$in, loop$level, loop$acc) {
  while (true) {
    let in$ = loop$in;
    let level = loop$level;
    let acc = loop$acc;
    if (in$.hasLength(0)) {
      return [$list.reverse(acc), toList([])];
    } else if (in$.hasLength(1) && in$.head === "\n") {
      return [$list.reverse(acc), toList([])];
    } else if (in$.atLeastLength(2) &&
    in$.head === "\n" &&
    in$.tail.head === "\n") {
      let in$1 = in$.tail.tail;
      return [$list.reverse(acc), in$1];
    } else if (in$.atLeastLength(2) &&
    in$.head === "\n" &&
    in$.tail.head === "#") {
      let rest = in$.tail.tail;
      let $ = take_heading_chars_newline_hash(
        rest,
        level - 1,
        listPrepend("\n", acc),
      );
      if ($ instanceof Some) {
        let acc$1 = $[0][0];
        let in$1 = $[0][1];
        loop$in = in$1;
        loop$level = level;
        loop$acc = acc$1;
      } else {
        return [$list.reverse(acc), in$];
      }
    } else {
      let c = in$.head;
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$level = level;
      loop$acc = listPrepend(c, acc);
    }
  }
}

function parse_code_end(loop$in, loop$limit, loop$count, loop$content) {
  while (true) {
    let in$ = loop$in;
    let limit = loop$limit;
    let count = loop$count;
    let content = loop$content;
    if (in$.hasLength(0)) {
      return [true, content, in$];
    } else if (in$.atLeastLength(1) && in$.head === "`") {
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$limit = limit;
      loop$count = count + 1;
      loop$content = content;
    } else if (in$.atLeastLength(1) && (limit === count)) {
      return [true, content, in$];
    } else {
      return [false, content + $string.repeat("`", count), in$];
    }
  }
}

function parse_code_content(loop$in, loop$count, loop$content) {
  while (true) {
    let in$ = loop$in;
    let count = loop$count;
    let content = loop$content;
    if (in$.hasLength(0)) {
      return [content, in$];
    } else if (in$.atLeastLength(1) && in$.head === "`") {
      let in$1 = in$.tail;
      let $ = parse_code_end(in$1, count, 1, content);
      let done = $[0];
      let content$1 = $[1];
      let in$2 = $[2];
      if (done) {
        return [content$1, in$2];
      } else {
        loop$in = in$2;
        loop$count = count;
        loop$content = content$1;
      }
    } else {
      let c = in$.head;
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$count = count;
      loop$content = content + c;
    }
  }
}

function parse_code(loop$in, loop$count) {
  while (true) {
    let in$ = loop$in;
    let count = loop$count;
    if (in$.atLeastLength(1) && in$.head === "`") {
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$count = count + 1;
    } else {
      let $ = parse_code_content(in$, count, "");
      let content = $[0];
      let in$1 = $[1];
      let content$1 = (() => {
        let $1 = $string.starts_with(content, " `");
        if ($1) {
          return $string.trim_start(content);
        } else {
          return content;
        }
      })();
      let content$2 = (() => {
        let $1 = $string.ends_with(content$1, "` ");
        if ($1) {
          return $string.trim_end(content$1);
        } else {
          return content$1;
        }
      })();
      return [new Code(content$2), in$1];
    }
  }
}

function take_emphasis_chars(loop$in, loop$close, loop$acc) {
  while (true) {
    let in$ = loop$in;
    let close = loop$close;
    let acc = loop$acc;
    if (in$.hasLength(0)) {
      return new None();
    } else if (in$.atLeastLength(1) && in$.head === "`") {
      return new None();
    } else if (in$.atLeastLength(2) &&
    in$.head === "\t" &&
    (in$.tail.head === close)) {
      let c = in$.tail.head;
      let in$1 = in$.tail.tail;
      loop$in = in$1;
      loop$close = close;
      loop$acc = listPrepend(" ", listPrepend(c, acc));
    } else if (in$.atLeastLength(2) &&
    in$.head === "\n" &&
    (in$.tail.head === close)) {
      let c = in$.tail.head;
      let in$1 = in$.tail.tail;
      loop$in = in$1;
      loop$close = close;
      loop$acc = listPrepend(" ", listPrepend(c, acc));
    } else if (in$.atLeastLength(2) &&
    in$.head === " " &&
    (in$.tail.head === close)) {
      let c = in$.tail.head;
      let in$1 = in$.tail.tail;
      loop$in = in$1;
      loop$close = close;
      loop$acc = listPrepend(" ", listPrepend(c, acc));
    } else if (in$.atLeastLength(1) && (in$.head === close)) {
      let c = in$.head;
      let in$1 = in$.tail;
      let $ = $list.reverse(acc);
      if ($.hasLength(0)) {
        return new None();
      } else {
        let acc$1 = $;
        return new Some([acc$1, in$1]);
      }
    } else {
      let c = in$.head;
      let rest = in$.tail;
      loop$in = rest;
      loop$close = close;
      loop$acc = listPrepend(c, acc);
    }
  }
}

function take_link_chars_destination(
  loop$in,
  loop$is_url,
  loop$inline_in,
  loop$acc
) {
  while (true) {
    let in$ = loop$in;
    let is_url = loop$is_url;
    let inline_in = loop$inline_in;
    let acc = loop$acc;
    if (in$.hasLength(0)) {
      return new None();
    } else if (in$.atLeastLength(1) && in$.head === ")" && (is_url)) {
      let in$1 = in$.tail;
      return new Some([inline_in, new Url(acc), in$1]);
    } else if (in$.atLeastLength(1) && in$.head === "]" && (!is_url)) {
      let in$1 = in$.tail;
      return new Some([inline_in, new Reference(acc), in$1]);
    } else if (in$.atLeastLength(1) && in$.head === "\n" && (is_url)) {
      let rest = in$.tail;
      loop$in = rest;
      loop$is_url = is_url;
      loop$inline_in = inline_in;
      loop$acc = acc;
    } else if (in$.atLeastLength(1) && in$.head === "\n" && (!is_url)) {
      let rest = in$.tail;
      loop$in = rest;
      loop$is_url = is_url;
      loop$inline_in = inline_in;
      loop$acc = acc + " ";
    } else {
      let c = in$.head;
      let rest = in$.tail;
      loop$in = rest;
      loop$is_url = is_url;
      loop$inline_in = inline_in;
      loop$acc = acc + c;
    }
  }
}

function take_link_chars(loop$in, loop$inline_in) {
  while (true) {
    let in$ = loop$in;
    let inline_in = loop$inline_in;
    if (in$.hasLength(0)) {
      return new None();
    } else if (in$.atLeastLength(2) && in$.head === "]" && in$.tail.head === "[") {
      let in$1 = in$.tail.tail;
      let inline_in$1 = $list.reverse(inline_in);
      return take_link_chars_destination(in$1, false, inline_in$1, "");
    } else if (in$.atLeastLength(2) && in$.head === "]" && in$.tail.head === "(") {
      let in$1 = in$.tail.tail;
      let inline_in$1 = $list.reverse(inline_in);
      return take_link_chars_destination(in$1, true, inline_in$1, "");
    } else {
      let c = in$.head;
      let rest = in$.tail;
      loop$in = rest;
      loop$inline_in = listPrepend(c, inline_in);
    }
  }
}

function parse_footnote(loop$in, loop$acc) {
  while (true) {
    let in$ = loop$in;
    let acc = loop$acc;
    if (in$.hasLength(0)) {
      return new None();
    } else if (in$.atLeastLength(1) && in$.head === "]") {
      let rest = in$.tail;
      return new Some([new Footnote(acc), rest]);
    } else {
      let c = in$.head;
      let rest = in$.tail;
      loop$in = rest;
      loop$acc = acc + c;
    }
  }
}

function heading_level(loop$in, loop$level) {
  while (true) {
    let in$ = loop$in;
    let level = loop$level;
    if (in$.atLeastLength(1) && in$.head === "#") {
      let rest = in$.tail;
      loop$in = rest;
      loop$level = level + 1;
    } else if (in$.hasLength(0) && (level > 0)) {
      return new Some([level, toList([])]);
    } else if (in$.atLeastLength(1) && in$.head === " " && (level !== 0)) {
      let rest = in$.tail;
      return new Some([level, rest]);
    } else if (in$.atLeastLength(1) && in$.head === "\n" && (level !== 0)) {
      let rest = in$.tail;
      return new Some([level, rest]);
    } else {
      return new None();
    }
  }
}

function take_inline_text(loop$inlines, loop$acc) {
  while (true) {
    let inlines = loop$inlines;
    let acc = loop$acc;
    if (inlines.hasLength(0)) {
      return acc;
    } else {
      let first = inlines.head;
      let rest = inlines.tail;
      if (first instanceof Text) {
        let text = first[0];
        loop$inlines = rest;
        loop$acc = acc + text;
      } else if (first instanceof Code) {
        let text = first.content;
        loop$inlines = rest;
        loop$acc = acc + text;
      } else if (first instanceof Strong) {
        let inlines$1 = first.content;
        loop$inlines = $list.append(inlines$1, rest);
        loop$acc = acc;
      } else if (first instanceof Emphasis) {
        let inlines$1 = first.content;
        loop$inlines = $list.append(inlines$1, rest);
        loop$acc = acc;
      } else if (first instanceof Link) {
        let nested = first.content;
        let acc$1 = take_inline_text(nested, acc);
        loop$inlines = rest;
        loop$acc = acc$1;
      } else if (first instanceof Image) {
        let nested = first.content;
        let acc$1 = take_inline_text(nested, acc);
        loop$inlines = rest;
        loop$acc = acc$1;
      } else if (first instanceof Linebreak) {
        loop$inlines = rest;
        loop$acc = acc;
      } else {
        loop$inlines = rest;
        loop$acc = acc;
      }
    }
  }
}

function take_paragraph_chars(loop$in, loop$acc) {
  while (true) {
    let in$ = loop$in;
    let acc = loop$acc;
    if (in$.hasLength(0)) {
      return [$list.reverse(acc), toList([])];
    } else if (in$.hasLength(1) && in$.head === "\n") {
      return [$list.reverse(acc), toList([])];
    } else if (in$.atLeastLength(2) &&
    in$.head === "\n" &&
    in$.tail.head === "\n") {
      let rest = in$.tail.tail;
      return [$list.reverse(acc), rest];
    } else {
      let c = in$.head;
      let rest = in$.tail;
      loop$in = rest;
      loop$acc = listPrepend(c, acc);
    }
  }
}

function get_new_footnotes(loop$original_html, loop$new_html, loop$acc) {
  while (true) {
    let original_html = loop$original_html;
    let new_html = loop$new_html;
    let acc = loop$acc;
    let $ = original_html.used_footnotes;
    let $1 = new_html.used_footnotes;
    if ($.atLeastLength(1) && $1.atLeastLength(1) && (isEqual($.head, $1.head))) {
      let original = $.head;
      let new$ = $1.head;
      return acc;
    } else if ($1.atLeastLength(1)) {
      let new$ = $1.head;
      let rest = $1.tail;
      loop$original_html = original_html;
      loop$new_html = (() => {
        let _record = new_html;
        return new GeneratedHtml(_record.html, rest);
      })();
      loop$acc = listPrepend(new$, acc);
    } else {
      return acc;
    }
  }
}

function append_to_html(original_html, str) {
  let _record = original_html;
  return new GeneratedHtml(original_html.html + str, _record.used_footnotes);
}

function close_tag(initial_html, tag) {
  let _record = initial_html;
  return new GeneratedHtml(
    ((initial_html.html + "</") + tag) + ">",
    _record.used_footnotes,
  );
}

function find_footnote_number(
  loop$footnotes_to_check,
  loop$reference,
  loop$used_footnotes
) {
  while (true) {
    let footnotes_to_check = loop$footnotes_to_check;
    let reference = loop$reference;
    let used_footnotes = loop$used_footnotes;
    if (footnotes_to_check.hasLength(0)) {
      let next_number = (() => {
        let _pipe = used_footnotes;
        let _pipe$1 = $list.first(_pipe);
        let _pipe$2 = $result.map(_pipe$1, (f) => { return f[0]; });
        return $result.unwrap(_pipe$2, 0);
      })() + 1;
      return [
        $int.to_string(next_number),
        listPrepend([next_number, reference], used_footnotes),
      ];
    } else if (footnotes_to_check.atLeastLength(1) &&
    (reference === footnotes_to_check.head[1])) {
      let index = footnotes_to_check.head[0];
      let ref = footnotes_to_check.head[1];
      return [$int.to_string(index), used_footnotes];
    } else {
      let rest = footnotes_to_check.tail;
      loop$footnotes_to_check = rest;
      loop$reference = reference;
      loop$used_footnotes = used_footnotes;
    }
  }
}

function destination_attribute(key, destination, refs) {
  let dict = $dict.new$();
  if (destination instanceof Url) {
    let url = destination[0];
    return $dict.insert(dict, key, url);
  } else {
    let id = destination[0];
    let $ = $dict.get(refs.urls, id);
    if ($.isOk()) {
      let url = $[0];
      return $dict.insert(dict, key, url);
    } else {
      return dict;
    }
  }
}

function ordered_attributes_to_html(attributes, html) {
  return $list.fold(
    attributes,
    html,
    (html, pair) => {
      return ((((html + " ") + pair[0]) + "=\"") + pair[1]) + "\"";
    },
  );
}

function open_tag_ordered_attributes(initial_html, tag, attributes) {
  let html = (initial_html.html + "<") + tag;
  let _record = initial_html;
  return new GeneratedHtml(
    ordered_attributes_to_html(attributes, html) + ">",
    _record.used_footnotes,
  );
}

function add_footnote_link(html, footnote_number) {
  let _pipe = html;
  let _pipe$1 = open_tag_ordered_attributes(
    _pipe,
    "a",
    toList([["href", "#fnref" + footnote_number], ["role", "doc-backlink"]]),
  );
  let _pipe$2 = append_to_html(_pipe$1, "↩︎");
  return close_tag(_pipe$2, "a");
}

function attributes_to_html(html, attributes) {
  let _pipe = attributes;
  let _pipe$1 = $dict.to_list(_pipe);
  let _pipe$2 = $list.sort(
    _pipe$1,
    (a, b) => { return $string.compare(a[0], b[0]); },
  );
  return ordered_attributes_to_html(_pipe$2, html);
}

function open_tag(initial_html, tag, attributes) {
  let html = (initial_html.html + "<") + tag;
  let _record = initial_html;
  return new GeneratedHtml(
    attributes_to_html(html, attributes) + ">",
    _record.used_footnotes,
  );
}

function inline_to_html(html, inline, refs) {
  if (inline instanceof Linebreak) {
    let _pipe = html;
    let _pipe$1 = open_tag(_pipe, "br", $dict.new$());
    return append_to_html(_pipe$1, "\n");
  } else if (inline instanceof Text) {
    let text = inline[0];
    return append_to_html(html, text);
  } else if (inline instanceof Strong) {
    let inlines = inline.content;
    let _pipe = html;
    let _pipe$1 = open_tag(_pipe, "strong", $dict.new$());
    let _pipe$2 = inlines_to_html(_pipe$1, inlines, refs);
    return close_tag(_pipe$2, "strong");
  } else if (inline instanceof Emphasis) {
    let inlines = inline.content;
    let _pipe = html;
    let _pipe$1 = open_tag(_pipe, "em", $dict.new$());
    let _pipe$2 = inlines_to_html(_pipe$1, inlines, refs);
    return close_tag(_pipe$2, "em");
  } else if (inline instanceof Link) {
    let text = inline.content;
    let destination = inline.destination;
    let _pipe = html;
    let _pipe$1 = open_tag(
      _pipe,
      "a",
      destination_attribute("href", destination, refs),
    );
    let _pipe$2 = inlines_to_html(_pipe$1, text, refs);
    return close_tag(_pipe$2, "a");
  } else if (inline instanceof Image) {
    let text = inline.content;
    let destination = inline.destination;
    let _pipe = html;
    return open_tag(
      _pipe,
      "img",
      (() => {
        let _pipe$1 = destination_attribute("src", destination, refs);
        return $dict.insert(_pipe$1, "alt", take_inline_text(text, ""));
      })(),
    );
  } else if (inline instanceof Code) {
    let content = inline.content;
    let _pipe = html;
    let _pipe$1 = open_tag(_pipe, "code", $dict.new$());
    let _pipe$2 = append_to_html(_pipe$1, content);
    return close_tag(_pipe$2, "code");
  } else {
    let reference = inline.reference;
    let $ = find_footnote_number(
      html.used_footnotes,
      reference,
      html.used_footnotes,
    );
    let footnote_number = $[0];
    let new_used_footnotes = $[1];
    let footnote_attrs = toList([
      ["id", "fnref" + footnote_number],
      ["href", "#fn" + footnote_number],
      ["role", "doc-noteref"],
    ]);
    let updated_html = (() => {
      let _pipe = html;
      let _pipe$1 = open_tag_ordered_attributes(_pipe, "a", footnote_attrs);
      let _pipe$2 = append_to_html(
        _pipe$1,
        ("<sup>" + footnote_number) + "</sup>",
      );
      return close_tag(_pipe$2, "a");
    })();
    let _record = updated_html;
    return new GeneratedHtml(_record.html, new_used_footnotes);
  }
}

function inlines_to_html(html, inlines, refs) {
  if (inlines.hasLength(0)) {
    return html;
  } else {
    let inline = inlines.head;
    let rest = inlines.tail;
    let html$1 = (() => {
      let _pipe = html;
      let _pipe$1 = inline_to_html(_pipe, inline, refs);
      return inlines_to_html(_pipe$1, rest, refs);
    })();
    let _record = html$1;
    return new GeneratedHtml(
      $string.trim_end(html$1.html),
      _record.used_footnotes,
    );
  }
}

function container_to_html(html, container, refs) {
  let new_html = (() => {
    if (container instanceof ThematicBreak) {
      let _pipe = html;
      return open_tag(_pipe, "hr", $dict.new$());
    } else if (container instanceof Paragraph) {
      let attrs = container.attributes;
      let inlines = container[1];
      let _pipe = html;
      let _pipe$1 = open_tag(_pipe, "p", attrs);
      let _pipe$2 = inlines_to_html(_pipe$1, inlines, refs);
      return close_tag(_pipe$2, "p");
    } else if (container instanceof Codeblock) {
      let attrs = container.attributes;
      let language = container.language;
      let content = container.content;
      let code_attrs = (() => {
        if (language instanceof Some) {
          let lang = language[0];
          return add_attribute(attrs, "class", "language-" + lang);
        } else {
          return attrs;
        }
      })();
      let _pipe = html;
      let _pipe$1 = open_tag(_pipe, "pre", $dict.new$());
      let _pipe$2 = open_tag(_pipe$1, "code", code_attrs);
      let _pipe$3 = append_to_html(_pipe$2, content);
      let _pipe$4 = close_tag(_pipe$3, "code");
      return close_tag(_pipe$4, "pre");
    } else {
      let attrs = container.attributes;
      let level = container.level;
      let inlines = container.content;
      let tag = "h" + $int.to_string(level);
      let _pipe = html;
      let _pipe$1 = open_tag(_pipe, tag, attrs);
      let _pipe$2 = inlines_to_html(_pipe$1, inlines, refs);
      return close_tag(_pipe$2, tag);
    }
  })();
  return append_to_html(new_html, "\n");
}

function containers_to_html_with_last_paragraph(
  loop$containers,
  loop$refs,
  loop$html,
  loop$apply
) {
  while (true) {
    let containers = loop$containers;
    let refs = loop$refs;
    let html = loop$html;
    let apply = loop$apply;
    if (containers.hasLength(0)) {
      return html;
    } else if (containers.hasLength(1)) {
      let container = containers.head;
      if (container instanceof Paragraph) {
        let attrs = container.attributes;
        let inlines = container[1];
        let _pipe = html;
        let _pipe$1 = open_tag(_pipe, "p", attrs);
        let _pipe$2 = inlines_to_html(_pipe$1, inlines, refs);
        let _pipe$3 = apply(_pipe$2);
        return close_tag(_pipe$3, "p");
      } else {
        let _pipe = container_to_html(html, container, refs);
        let _pipe$1 = open_tag(_pipe, "p", $dict.new$());
        let _pipe$2 = apply(_pipe$1);
        return close_tag(_pipe$2, "p");
      }
    } else {
      let container = containers.head;
      let rest = containers.tail;
      let html$1 = container_to_html(html, container, refs);
      loop$containers = rest;
      loop$refs = refs;
      loop$html = html$1;
      loop$apply = apply;
    }
  }
}

function containers_to_html(loop$containers, loop$refs, loop$html) {
  while (true) {
    let containers = loop$containers;
    let refs = loop$refs;
    let html = loop$html;
    if (containers.hasLength(0)) {
      return html;
    } else {
      let container = containers.head;
      let rest = containers.tail;
      let html$1 = container_to_html(html, container, refs);
      loop$containers = rest;
      loop$refs = refs;
      loop$html = html$1;
    }
  }
}

function create_footnotes(loop$document, loop$used_footnotes, loop$html_acc) {
  while (true) {
    let document = loop$document;
    let used_footnotes = loop$used_footnotes;
    let html_acc = loop$html_acc;
    let footnote_to_html = (html, footnote, footnote_number) => {
      let _pipe = $dict.get(document.footnotes, footnote);
      let _pipe$1 = $result.then$(
        _pipe,
        (footnote) => {
          let $ = $list.is_empty(footnote);
          if ($) {
            return new Error(undefined);
          } else {
            return new Ok(footnote);
          }
        },
      );
      let _pipe$2 = $result.map(
        _pipe$1,
        (footnote) => {
          return containers_to_html_with_last_paragraph(
            footnote,
            new Refs(document.references, document.footnotes),
            html,
            (_capture) => {
              return add_footnote_link(_capture, footnote_number);
            },
          );
        },
      );
      return $result.lazy_unwrap(
        _pipe$2,
        () => {
          let _pipe$3 = html;
          let _pipe$4 = open_tag_ordered_attributes(_pipe$3, "p", toList([]));
          let _pipe$5 = add_footnote_link(_pipe$4, footnote_number);
          return close_tag(_pipe$5, "p");
        },
      );
    };
    if (used_footnotes.hasLength(0)) {
      return html_acc;
    } else {
      let footnote_number = used_footnotes.head[0];
      let footnote = used_footnotes.head[1];
      let other_footnotes = used_footnotes.tail;
      let footnote_number$1 = $int.to_string(footnote_number);
      let html = (() => {
        let _pipe = html_acc;
        let _pipe$1 = open_tag(
          _pipe,
          "li",
          $dict.from_list(toList([["id", "fn" + footnote_number$1]])),
        );
        let _pipe$2 = append_to_html(_pipe$1, "\n");
        let _pipe$3 = footnote_to_html(_pipe$2, footnote, footnote_number$1);
        let _pipe$4 = append_to_html(_pipe$3, "\n");
        let _pipe$5 = close_tag(_pipe$4, "li");
        return append_to_html(_pipe$5, "\n");
      })();
      let new_used_footnotes = $list.append(
        get_new_footnotes(html_acc, html, toList([])),
        other_footnotes,
      );
      loop$document = document;
      loop$used_footnotes = new_used_footnotes;
      loop$html_acc = html;
    }
  }
}

export function document_to_html(document) {
  let generated_html = containers_to_html(
    document.content,
    new Refs(document.references, document.footnotes),
    new GeneratedHtml("", toList([])),
  );
  return $bool.guard(
    $list.is_empty(generated_html.used_footnotes),
    generated_html.html,
    () => {
      let footnotes_section_html = (() => {
        let _pipe = generated_html;
        let _pipe$1 = open_tag(
          _pipe,
          "section",
          $dict.from_list(toList([["role", "doc-endnotes"]])),
        );
        let _pipe$2 = append_to_html(_pipe$1, "\n");
        let _pipe$3 = open_tag(_pipe$2, "hr", $dict.new$());
        let _pipe$4 = append_to_html(_pipe$3, "\n");
        let _pipe$5 = open_tag(_pipe$4, "ol", $dict.new$());
        return append_to_html(_pipe$5, "\n");
      })();
      let html_with_footnotes = create_footnotes(
        document,
        $list.reverse(footnotes_section_html.used_footnotes),
        footnotes_section_html,
      );
      return (() => {
        let _pipe = html_with_footnotes;
        let _pipe$1 = close_tag(_pipe, "ol");
        let _pipe$2 = append_to_html(_pipe$1, "\n");
        let _pipe$3 = close_tag(_pipe$2, "section");
        return append_to_html(_pipe$3, "\n");
      })().html;
    },
  );
}

function parse_block_after_indent_checked(
  in$,
  refs,
  ast,
  attrs,
  required_spaces,
  indentation
) {
  return parse_containers(
    in$,
    refs,
    ast,
    attrs,
    indentation,
    (in$, refs, ast, attrs) => {
      return parse_block(in$, refs, ast, attrs, required_spaces);
    },
  );
}

function parse_block(in$, refs, ast, attrs, required_spaces) {
  let in$1 = drop_lines(in$);
  let $ = count_drop_spaces(in$1, 0);
  let in$2 = $[0];
  let spaces_count = $[1];
  return $bool.lazy_guard(
    spaces_count < required_spaces,
    () => { return [$list.reverse(ast), refs, in$2]; },
    () => {
      return parse_block_after_indent_checked(
        in$2,
        refs,
        ast,
        attrs,
        required_spaces,
        spaces_count,
      );
    },
  );
}

function parse_footnote_def(loop$in, loop$refs, loop$id) {
  while (true) {
    let in$ = loop$in;
    let refs = loop$refs;
    let id = loop$id;
    if (in$.atLeastLength(2) && in$.head === "]" && in$.tail.head === ":") {
      let in$1 = in$.tail.tail;
      let $ = count_drop_spaces(in$1, 0);
      let in$2 = $[0];
      let spaces_count = $[1];
      let block_parser = (() => {
        if (in$2.atLeastLength(1) && in$2.head === "\n") {
          return parse_block;
        } else {
          return (in$, refs, ast, attrs, required_spaces) => {
            return parse_block_after_indent_checked(
              in$,
              refs,
              ast,
              attrs,
              required_spaces,
              (4 + $string.length(id)) + spaces_count,
            );
          };
        }
      })();
      let $1 = block_parser(in$2, refs, toList([]), $dict.new$(), 1);
      let block = $1[0];
      let refs$1 = $1[1];
      let rest = $1[2];
      return new Some([id, block, refs$1, rest]);
    } else if (in$.hasLength(0)) {
      return new None();
    } else if (in$.atLeastLength(1) && in$.head === "]") {
      return new None();
    } else if (in$.atLeastLength(1) && in$.head === "\n") {
      return new None();
    } else {
      let c = in$.head;
      let in$1 = in$.tail;
      loop$in = in$1;
      loop$refs = refs;
      loop$id = id + c;
    }
  }
}

function parse_emphasis(in$, close) {
  let $ = take_emphasis_chars(in$, close, toList([]));
  if ($ instanceof None) {
    return new None();
  } else {
    let inline_in = $[0][0];
    let in$1 = $[0][1];
    let $1 = parse_inline(inline_in, "", toList([]));
    let inline = $1[0];
    let inline_in_remaining = $1[1];
    return new Some([inline, $list.append(inline_in_remaining, in$1)]);
  }
}

function parse_inline(loop$in, loop$text, loop$acc) {
  while (true) {
    let in$ = loop$in;
    let text = loop$text;
    let acc = loop$acc;
    if (in$.hasLength(0) && (text === "")) {
      return [$list.reverse(acc), toList([])];
    } else if (in$.hasLength(0)) {
      loop$in = toList([]);
      loop$text = "";
      loop$acc = listPrepend(new Text(text), acc);
    } else if (in$.atLeastLength(2) && in$.head === "\\") {
      let c = in$.tail.head;
      let rest = in$.tail.tail;
      if (c === "\n") {
        loop$in = rest;
        loop$text = "";
        loop$acc = listPrepend(
          new Linebreak(),
          listPrepend(new Text(text), acc),
        );
      } else if (c === " ") {
        loop$in = rest;
        loop$text = text + "&nbsp;";
        loop$acc = acc;
      } else if (c === "!") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "\"") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "#") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "$") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "%") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "&") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "'") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "(") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === ")") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "*") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "+") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === ",") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "-") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === ".") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "/") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === ":") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === ";") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "<") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "=") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === ">") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "?") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "@") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "[") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "\\") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "]") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "^") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "_") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "`") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "{") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "|") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "}") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else if (c === "~") {
        loop$in = rest;
        loop$text = text + c;
        loop$acc = acc;
      } else {
        loop$in = $list.append(toList([c]), rest);
        loop$text = text + "\\";
        loop$acc = acc;
      }
    } else if (in$.atLeastLength(2) &&
    in$.head === "_" &&
    (((in$.tail.head !== " ") && (in$.tail.head !== "\t")) && (in$.tail.head !== "\n"))) {
      let c = in$.tail.head;
      let rest = in$.tail.tail;
      let rest$1 = listPrepend(c, rest);
      let $ = parse_emphasis(rest$1, "_");
      if ($ instanceof None) {
        loop$in = rest$1;
        loop$text = text + "_";
        loop$acc = acc;
      } else {
        let inner = $[0][0];
        let in$1 = $[0][1];
        loop$in = in$1;
        loop$text = "";
        loop$acc = listPrepend(
          new Emphasis(inner),
          listPrepend(new Text(text), acc),
        );
      }
    } else if (in$.atLeastLength(2) &&
    in$.head === "*" &&
    (((in$.tail.head !== " ") && (in$.tail.head !== "\t")) && (in$.tail.head !== "\n"))) {
      let c = in$.tail.head;
      let rest = in$.tail.tail;
      let rest$1 = listPrepend(c, rest);
      let $ = parse_emphasis(rest$1, "*");
      if ($ instanceof None) {
        loop$in = rest$1;
        loop$text = text + "*";
        loop$acc = acc;
      } else {
        let inner = $[0][0];
        let in$1 = $[0][1];
        loop$in = in$1;
        loop$text = "";
        loop$acc = listPrepend(
          new Strong(inner),
          listPrepend(new Text(text), acc),
        );
      }
    } else if (in$.atLeastLength(2) && in$.head === "[" && in$.tail.head === "^") {
      let rest = in$.tail.tail;
      let $ = parse_footnote(rest, "^");
      if ($ instanceof None) {
        loop$in = rest;
        loop$text = text + "[^";
        loop$acc = acc;
      } else if ($ instanceof Some &&
      $[0][1].atLeastLength(1) &&
      $[0][1].head === ":" &&
      (text !== "")) {
        return [$list.reverse(listPrepend(new Text(text), acc)), in$];
      } else if ($ instanceof Some &&
      $[0][1].atLeastLength(1) &&
      $[0][1].head === ":") {
        return [$list.reverse(acc), in$];
      } else {
        let footnote = $[0][0];
        let in$1 = $[0][1];
        loop$in = in$1;
        loop$text = "";
        loop$acc = listPrepend(footnote, listPrepend(new Text(text), acc));
      }
    } else if (in$.atLeastLength(1) && in$.head === "[") {
      let rest = in$.tail;
      let $ = parse_link(rest, (var0, var1) => { return new Link(var0, var1); });
      if ($ instanceof None) {
        loop$in = rest;
        loop$text = text + "[";
        loop$acc = acc;
      } else {
        let link = $[0][0];
        let in$1 = $[0][1];
        loop$in = in$1;
        loop$text = "";
        loop$acc = listPrepend(link, listPrepend(new Text(text), acc));
      }
    } else if (in$.atLeastLength(2) && in$.head === "!" && in$.tail.head === "[") {
      let rest = in$.tail.tail;
      let $ = parse_link(
        rest,
        (var0, var1) => { return new Image(var0, var1); },
      );
      if ($ instanceof None) {
        loop$in = rest;
        loop$text = text + "![";
        loop$acc = acc;
      } else {
        let image = $[0][0];
        let in$1 = $[0][1];
        loop$in = in$1;
        loop$text = "";
        loop$acc = listPrepend(image, listPrepend(new Text(text), acc));
      }
    } else if (in$.atLeastLength(1) && in$.head === "`") {
      let rest = in$.tail;
      let $ = parse_code(rest, 1);
      let code = $[0];
      let in$1 = $[1];
      loop$in = in$1;
      loop$text = "";
      loop$acc = listPrepend(code, listPrepend(new Text(text), acc));
    } else if (in$.atLeastLength(1) && in$.head === "\n") {
      let rest = in$.tail;
      let _pipe = drop_spaces(rest);
      loop$in = _pipe;
      loop$text = text + "\n";
      loop$acc = acc;
    } else {
      let c = in$.head;
      let rest = in$.tail;
      loop$in = rest;
      loop$text = text + c;
      loop$acc = acc;
    }
  }
}

function parse_link(in$, to_inline) {
  let $ = take_link_chars(in$, toList([]));
  if ($ instanceof None) {
    return new None();
  } else {
    let inline_in = $[0][0];
    let ref = $[0][1];
    let in$1 = $[0][2];
    let $1 = parse_inline(inline_in, "", toList([]));
    let inline = $1[0];
    let inline_in_remaining = $1[1];
    let ref$1 = (() => {
      if (ref instanceof Reference && ref[0] === "") {
        return new Reference(take_inline_text(inline, ""));
      } else {
        let ref$1 = ref;
        return ref$1;
      }
    })();
    return new Some(
      [to_inline(inline, ref$1), $list.append(inline_in_remaining, in$1)],
    );
  }
}

function parse_paragraph(in$, attrs) {
  let $ = take_paragraph_chars(in$, toList([]));
  let inline_in = $[0];
  let in$1 = $[1];
  let $1 = parse_inline(inline_in, "", toList([]));
  let inline = $1[0];
  let inline_in_remaining = $1[1];
  return [new Paragraph(attrs, inline), $list.append(inline_in_remaining, in$1)];
}

function parse_heading(in$, refs, attrs) {
  let $ = heading_level(in$, 1);
  if ($ instanceof Some) {
    let level = $[0][0];
    let in$1 = $[0][1];
    let in$2 = drop_spaces(in$1);
    let $1 = take_heading_chars(in$2, level, toList([]));
    let inline_in = $1[0];
    let in$3 = $1[1];
    let $2 = parse_inline(inline_in, "", toList([]));
    let inline = $2[0];
    let inline_in_remaining = $2[1];
    let text = take_inline_text(inline, "");
    let $3 = (() => {
      let $4 = id_sanitise(text);
      if ($4 === "") {
        return [refs, attrs];
      } else {
        let id = $4;
        let $5 = $dict.get(refs.urls, id);
        if ($5.isOk()) {
          return [refs, attrs];
        } else {
          let refs$1 = (() => {
            let _record = refs;
            return new Refs(
              $dict.insert(refs.urls, id, "#" + id),
              _record.footnotes,
            );
          })();
          let attrs$1 = add_attribute(attrs, "id", id);
          return [refs$1, attrs$1];
        }
      }
    })();
    let refs$1 = $3[0];
    let attrs$1 = $3[1];
    let heading = new Heading(attrs$1, level, inline);
    return [heading, refs$1, $list.append(inline_in_remaining, in$3)];
  } else {
    let $1 = parse_paragraph(listPrepend("#", in$), attrs);
    let p = $1[0];
    let in$1 = $1[1];
    return [p, refs, in$1];
  }
}

function parse_containers(in$, refs, ast, attrs, indentation, parser) {
  if (in$.hasLength(0)) {
    return [$list.reverse(ast), refs, toList([])];
  } else if (in$.atLeastLength(1) && in$.head === "{") {
    let in2 = in$.tail;
    let $ = parse_attributes(in2, attrs);
    if ($ instanceof None) {
      let $1 = parse_paragraph(in$, attrs);
      let paragraph = $1[0];
      let in$1 = $1[1];
      return parser(in$1, refs, listPrepend(paragraph, ast), $dict.new$());
    } else {
      let attrs$1 = $[0][0];
      let in$1 = $[0][1];
      return parser(in$1, refs, ast, attrs$1);
    }
  } else if (in$.atLeastLength(1) && in$.head === "#") {
    let in$1 = in$.tail;
    let $ = parse_heading(in$1, refs, attrs);
    let heading = $[0];
    let refs$1 = $[1];
    let in$2 = $[2];
    return parser(in$2, refs$1, listPrepend(heading, ast), $dict.new$());
  } else if (in$.atLeastLength(1) && in$.head === "~") {
    let delim = in$.head;
    let in2 = in$.tail;
    let $ = parse_codeblock(in2, attrs, delim, indentation);
    if ($ instanceof None) {
      let $1 = parse_paragraph(in$, attrs);
      let paragraph = $1[0];
      let in$1 = $1[1];
      return parser(in$1, refs, listPrepend(paragraph, ast), $dict.new$());
    } else {
      let codeblock = $[0][0];
      let in$1 = $[0][1];
      return parser(in$1, refs, listPrepend(codeblock, ast), $dict.new$());
    }
  } else if (in$.atLeastLength(1) && in$.head === "`") {
    let delim = in$.head;
    let in2 = in$.tail;
    let $ = parse_codeblock(in2, attrs, delim, indentation);
    if ($ instanceof None) {
      let $1 = parse_paragraph(in$, attrs);
      let paragraph = $1[0];
      let in$1 = $1[1];
      return parser(in$1, refs, listPrepend(paragraph, ast), $dict.new$());
    } else {
      let codeblock = $[0][0];
      let in$1 = $[0][1];
      return parser(in$1, refs, listPrepend(codeblock, ast), $dict.new$());
    }
  } else if (in$.atLeastLength(1) && in$.head === "-") {
    let in2 = in$.tail;
    let $ = parse_thematic_break(1, in2);
    if ($ instanceof None) {
      let $1 = parse_paragraph(in$, attrs);
      let paragraph = $1[0];
      let in$1 = $1[1];
      return parser(in$1, refs, listPrepend(paragraph, ast), $dict.new$());
    } else {
      let thematic_break = $[0][0];
      let in$1 = $[0][1];
      return parser(in$1, refs, listPrepend(thematic_break, ast), $dict.new$());
    }
  } else if (in$.atLeastLength(1) && in$.head === "*") {
    let in2 = in$.tail;
    let $ = parse_thematic_break(1, in2);
    if ($ instanceof None) {
      let $1 = parse_paragraph(in$, attrs);
      let paragraph = $1[0];
      let in$1 = $1[1];
      return parser(in$1, refs, listPrepend(paragraph, ast), $dict.new$());
    } else {
      let thematic_break = $[0][0];
      let in$1 = $[0][1];
      return parser(in$1, refs, listPrepend(thematic_break, ast), $dict.new$());
    }
  } else if (in$.atLeastLength(2) && in$.head === "[" && in$.tail.head === "^") {
    let in2 = in$.tail.tail;
    let $ = parse_footnote_def(in2, refs, "^");
    if ($ instanceof None) {
      let $1 = parse_paragraph(in$, attrs);
      let paragraph = $1[0];
      let in$1 = $1[1];
      return parser(in$1, refs, listPrepend(paragraph, ast), $dict.new$());
    } else {
      let id = $[0][0];
      let footnote = $[0][1];
      let refs$1 = $[0][2];
      let in$1 = $[0][3];
      let refs$2 = (() => {
        let _record = refs$1;
        return new Refs(
          _record.urls,
          $dict.insert(refs$1.footnotes, id, footnote),
        );
      })();
      return parser(in$1, refs$2, ast, $dict.new$());
    }
  } else if (in$.atLeastLength(1) && in$.head === "[") {
    let in2 = in$.tail;
    let $ = parse_ref_def(in2, "");
    if ($ instanceof None) {
      let $1 = parse_paragraph(in$, attrs);
      let paragraph = $1[0];
      let in$1 = $1[1];
      return parser(in$1, refs, listPrepend(paragraph, ast), $dict.new$());
    } else {
      let id = $[0][0];
      let url = $[0][1];
      let in$1 = $[0][2];
      let refs$1 = (() => {
        let _record = refs;
        return new Refs($dict.insert(refs.urls, id, url), _record.footnotes);
      })();
      return parser(in$1, refs$1, ast, $dict.new$());
    }
  } else {
    let $ = parse_paragraph(in$, attrs);
    let paragraph = $[0];
    let in$1 = $[1];
    return parser(in$1, refs, listPrepend(paragraph, ast), $dict.new$());
  }
}

function parse_document_content(in$, refs, ast, attrs) {
  let in$1 = drop_lines(in$);
  let $ = count_drop_spaces(in$1, 0);
  let in$2 = $[0];
  let spaces_count = $[1];
  return parse_containers(
    in$2,
    refs,
    ast,
    attrs,
    spaces_count,
    parse_document_content,
  );
}

export function parse(djot) {
  let $ = (() => {
    let _pipe = djot;
    let _pipe$1 = $string.replace(_pipe, "\r\n", "\n");
    let _pipe$2 = $string.to_graphemes(_pipe$1);
    return parse_document_content(
      _pipe$2,
      new Refs($dict.new$(), $dict.new$()),
      toList([]),
      $dict.new$(),
    );
  })();
  let ast = $[0];
  let urls = $[1].urls;
  let footnotes = $[1].footnotes;
  return new Document(ast, urls, footnotes);
}

export function to_html(djot) {
  let _pipe = djot;
  let _pipe$1 = parse(_pipe);
  return document_to_html(_pipe$1);
}
