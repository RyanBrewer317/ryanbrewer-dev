import * as $bool from "../gleam_stdlib/gleam/bool.mjs";
import * as $dict from "../gleam_stdlib/gleam/dict.mjs";
import * as $int from "../gleam_stdlib/gleam/int.mjs";
import * as $list from "../gleam_stdlib/gleam/list.mjs";
import * as $option from "../gleam_stdlib/gleam/option.mjs";
import { None, Some } from "../gleam_stdlib/gleam/option.mjs";
import * as $result from "../gleam_stdlib/gleam/result.mjs";
import * as $string from "../gleam_stdlib/gleam/string.mjs";
import * as $houdini from "../houdini/houdini.mjs";
import * as $splitter from "../splitter/splitter.mjs";
import {
  Ok,
  Error,
  toList,
  Empty as $Empty,
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
  constructor(attributes, content) {
    super();
    this.attributes = attributes;
    this.content = content;
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

export class RawBlock extends $CustomType {
  constructor(content) {
    super();
    this.content = content;
  }
}

export class BulletList extends $CustomType {
  constructor(layout, style, items) {
    super();
    this.layout = layout;
    this.style = style;
    this.items = items;
  }
}

export class Linebreak extends $CustomType {}

export class NonBreakingSpace extends $CustomType {}

export class Text extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
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

export class Tight extends $CustomType {}

export class Loose extends $CustomType {}

export class Reference extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class Url extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Refs extends $CustomType {
  constructor(urls, footnotes) {
    super();
    this.urls = urls;
    this.footnotes = footnotes;
  }
}

class Splitters extends $CustomType {
  constructor(verbatim_line_end, codeblock_language, inline, link_destination) {
    super();
    this.verbatim_line_end = verbatim_line_end;
    this.codeblock_language = codeblock_language;
    this.inline = inline;
    this.link_destination = link_destination;
  }
}

class GeneratedHtml extends $CustomType {
  constructor(html, used_footnotes) {
    super();
    this.html = html;
    this.used_footnotes = used_footnotes;
  }
}

class NoTrim extends $CustomType {}

class TrimLast extends $CustomType {}

function add_attribute(attributes, key, value) {
  if (key === "class") {
    return $dict.upsert(
      attributes,
      key,
      (previous) => {
        if (previous instanceof Some) {
          let previous$1 = previous[0];
          return (previous$1 + " ") + value;
        } else {
          return value;
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
    if (in$ === "") {
      return "";
    } else if (in$.startsWith("\n")) {
      let rest = in$.slice(1);
      loop$in = rest;
    } else {
      let other = in$;
      return other;
    }
  }
}

function drop_spaces(loop$in) {
  while (true) {
    let in$ = loop$in;
    if (in$ === "") {
      return "";
    } else if (in$.startsWith(" ")) {
      let rest = in$.slice(1);
      loop$in = rest;
    } else {
      let other = in$;
      return other;
    }
  }
}

function count_drop_spaces(loop$in, loop$count) {
  while (true) {
    let in$ = loop$in;
    let count = loop$count;
    if (in$ === "") {
      return ["", count];
    } else if (in$.startsWith(" ")) {
      let rest = in$.slice(1);
      loop$in = rest;
      loop$count = count + 1;
    } else {
      let other = in$;
      return [other, count];
    }
  }
}

function parse_thematic_break(loop$count, loop$in) {
  while (true) {
    let count = loop$count;
    let in$ = loop$in;
    if (in$ === "") {
      if (count >= 3) {
        return new Some([new ThematicBreak(), in$]);
      } else {
        return new None();
      }
    } else if (in$.startsWith("\n")) {
      if (count >= 3) {
        return new Some([new ThematicBreak(), in$]);
      } else {
        return new None();
      }
    } else if (in$.startsWith(" ")) {
      let rest = in$.slice(1);
      loop$count = count;
      loop$in = rest;
    } else if (in$.startsWith("\t")) {
      let rest = in$.slice(1);
      loop$count = count;
      loop$in = rest;
    } else if (in$.startsWith("-")) {
      let rest = in$.slice(1);
      loop$count = count + 1;
      loop$in = rest;
    } else if (in$.startsWith("*")) {
      let rest = in$.slice(1);
      loop$count = count + 1;
      loop$in = rest;
    } else {
      return new None();
    }
  }
}

function slurp_verbatim_line(
  loop$in,
  loop$indentation,
  loop$acc,
  loop$splitters
) {
  while (true) {
    let in$ = loop$in;
    let indentation = loop$indentation;
    let acc = loop$acc;
    let splitters = loop$splitters;
    let $ = $splitter.split(splitters.verbatim_line_end, in$);
    let $1 = $[1];
    if ($1 === "\n") {
      let before = $[0];
      let in$1 = $[2];
      return [(acc + before) + "\n", in$1];
    } else if ($1 === " ") {
      let $2 = $[0];
      if ($2 === "") {
        if (indentation > 0) {
          let in$1 = $[2];
          loop$in = in$1;
          loop$indentation = indentation - 1;
          loop$acc = acc;
          loop$splitters = splitters;
        } else {
          let before = $2;
          let split = $1;
          let in$1 = $[2];
          loop$in = in$1;
          loop$indentation = indentation;
          loop$acc = (acc + before) + split;
          loop$splitters = splitters;
        }
      } else {
        let before = $2;
        let split = $1;
        let in$1 = $[2];
        loop$in = in$1;
        loop$indentation = indentation;
        loop$acc = (acc + before) + split;
        loop$splitters = splitters;
      }
    } else {
      let before = $[0];
      let split = $1;
      let in$1 = $[2];
      loop$in = in$1;
      loop$indentation = indentation;
      loop$acc = (acc + before) + split;
      loop$splitters = splitters;
    }
  }
}

function parse_codeblock_end(loop$in, loop$delim, loop$count) {
  while (true) {
    let in$ = loop$in;
    let delim = loop$delim;
    let count = loop$count;
    if (in$.startsWith("\n")) {
      if (count === 0) {
        let in$1 = in$.slice(1);
        return new Some(in$1);
      } else {
        if (count === 0) {
          return new Some(in$);
        } else {
          let $ = $string.pop_grapheme(in$);
          if ($ instanceof Ok) {
            let c = $[0][0];
            if (c === delim) {
              let in$1 = $[0][1];
              loop$in = in$1;
              loop$delim = delim;
              loop$count = count - 1;
            } else {
              return new None();
            }
          } else {
            return new Some(in$);
          }
        }
      }
    } else if (in$.startsWith(" ")) {
      if (count === 0) {
        return new Some(in$);
      } else {
        let in$1 = in$.slice(1);
        loop$in = in$1;
        loop$delim = delim;
        loop$count = count;
      }
    } else if (count === 0) {
      return new Some(in$);
    } else {
      let $ = $string.pop_grapheme(in$);
      if ($ instanceof Ok) {
        let c = $[0][0];
        if (c === delim) {
          let in$1 = $[0][1];
          loop$in = in$1;
          loop$delim = delim;
          loop$count = count - 1;
        } else {
          return new None();
        }
      } else {
        return new Some(in$);
      }
    }
  }
}

function parse_codeblock_content(
  loop$in,
  loop$delim,
  loop$count,
  loop$indentation,
  loop$acc,
  loop$splitters
) {
  while (true) {
    let in$ = loop$in;
    let delim = loop$delim;
    let count = loop$count;
    let indentation = loop$indentation;
    let acc = loop$acc;
    let splitters = loop$splitters;
    let $ = parse_codeblock_end(in$, delim, count);
    if ($ instanceof Some) {
      let in$1 = $[0];
      return [acc, in$1];
    } else {
      let $1 = slurp_verbatim_line(in$, indentation, acc, splitters);
      let acc$1 = $1[0];
      let in$1 = $1[1];
      loop$in = in$1;
      loop$delim = delim;
      loop$count = count;
      loop$indentation = indentation;
      loop$acc = acc$1;
      loop$splitters = splitters;
    }
  }
}

function parse_codeblock_language(in$, splitters, language) {
  let $ = $splitter.split(splitters.codeblock_language, in$);
  let $1 = $[1];
  if ($1 === "`") {
    return new None();
  } else if ($1 === "\n") {
    let a = $[0];
    if ((a === "") && (language === "")) {
      return new Some([new None(), in$]);
    } else {
      let a$1 = $[0];
      let in$1 = $[2];
      return new Some([new Some(language + a$1), in$1]);
    }
  } else {
    return new Some([new None(), in$]);
  }
}

function parse_codeblock_start(loop$in, loop$splitters, loop$delim, loop$count) {
  while (true) {
    let in$ = loop$in;
    let splitters = loop$splitters;
    let delim = loop$delim;
    let count = loop$count;
    if (in$.startsWith("`")) {
      let c = "`";
      if (c === delim) {
        let in$1 = in$.slice(1);
        loop$in = in$1;
        loop$splitters = splitters;
        loop$delim = delim;
        loop$count = count + 1;
      } else {
        if (count >= 3) {
          let in$1 = drop_spaces(in$);
          return $option.map(
            parse_codeblock_language(in$1, splitters, ""),
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
    } else if (in$.startsWith("~")) {
      let c = "~";
      if (c === delim) {
        let in$1 = in$.slice(1);
        loop$in = in$1;
        loop$splitters = splitters;
        loop$delim = delim;
        loop$count = count + 1;
      } else {
        if (count >= 3) {
          let in$1 = drop_spaces(in$);
          return $option.map(
            parse_codeblock_language(in$1, splitters, ""),
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
    } else if (in$.startsWith("\n")) {
      if (count >= 3) {
        let in$1 = in$.slice(1);
        return new Some([new None(), count, in$1]);
      } else {
        if (count >= 3) {
          let in$1 = drop_spaces(in$);
          return $option.map(
            parse_codeblock_language(in$1, splitters, ""),
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
    } else if (in$ === "") {
      return new None();
    } else if (count >= 3) {
      let in$1 = drop_spaces(in$);
      return $option.map(
        parse_codeblock_language(in$1, splitters, ""),
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

function parse_codeblock(in$, attrs, delim, indentation, splitters) {
  let out = parse_codeblock_start(in$, splitters, delim, 1);
  return $option.then$(
    out,
    (_use0) => {
      let language = _use0[0];
      let count = _use0[1];
      let in$1 = _use0[2];
      let $ = parse_codeblock_content(
        in$1,
        delim,
        count,
        indentation,
        "",
        splitters,
      );
      let content = $[0];
      let in$2 = $[1];
      if (language instanceof Some) {
        let $1 = language[0];
        if ($1 === "=html") {
          return new Some([new RawBlock($string.trim_end(content)), in$2]);
        } else {
          return new Some([new Codeblock(attrs, language, content), in$2]);
        }
      } else {
        return new Some([new Codeblock(attrs, language, content), in$2]);
      }
    },
  );
}

function parse_ref_value(loop$in, loop$id, loop$url) {
  while (true) {
    let in$ = loop$in;
    let id = loop$id;
    let url = loop$url;
    if (in$.startsWith("\n ")) {
      let in$1 = in$.slice(2);
      loop$in = drop_spaces(in$1);
      loop$id = id;
      loop$url = url;
    } else if (in$.startsWith("\n")) {
      let in$1 = in$.slice(1);
      return new Some([id, $string.trim(url), in$1]);
    } else {
      let $ = $string.pop_grapheme(in$);
      if ($ instanceof Ok) {
        let c = $[0][0];
        let in$1 = $[0][1];
        loop$in = in$1;
        loop$id = id;
        loop$url = url + c;
      } else {
        return new Some([id, $string.trim(url), ""]);
      }
    }
  }
}

function parse_ref_def(loop$in, loop$id) {
  while (true) {
    let in$ = loop$in;
    let id = loop$id;
    if (in$.startsWith("]:")) {
      let in$1 = in$.slice(2);
      return parse_ref_value(in$1, id, "");
    } else if (in$ === "") {
      return new None();
    } else if (in$.startsWith("]")) {
      return new None();
    } else if (in$.startsWith("\n")) {
      return new None();
    } else {
      let $ = $string.pop_grapheme(in$);
      if ($ instanceof Ok) {
        let c = $[0][0];
        let in$1 = $[0][1];
        loop$in = in$1;
        loop$id = id + c;
      } else {
        return new None();
      }
    }
  }
}

function parse_attribute_value(loop$in, loop$key, loop$value) {
  while (true) {
    let in$ = loop$in;
    let key = loop$key;
    let value = loop$value;
    if (in$ === "") {
      return new None();
    } else if (in$.startsWith(" ")) {
      let in$1 = in$.slice(1);
      return new Some([key, value, in$1]);
    } else if (in$.startsWith("}")) {
      return new Some([key, value, in$]);
    } else {
      let $ = $string.pop_grapheme(in$);
      if ($ instanceof Ok) {
        let c = $[0][0];
        let in$1 = $[0][1];
        loop$in = in$1;
        loop$key = key;
        loop$value = value + c;
      } else {
        return new None();
      }
    }
  }
}

function parse_attribute_quoted_value(loop$in, loop$key, loop$value) {
  while (true) {
    let in$ = loop$in;
    let key = loop$key;
    let value = loop$value;
    if (in$ === "") {
      return new None();
    } else if (in$.startsWith("\"")) {
      let in$1 = in$.slice(1);
      return new Some([key, value, in$1]);
    } else {
      let $ = $string.pop_grapheme(in$);
      if ($ instanceof Ok) {
        let c = $[0][0];
        let in$1 = $[0][1];
        loop$in = in$1;
        loop$key = key;
        loop$value = value + c;
      } else {
        return new None();
      }
    }
  }
}

function parse_attribute(loop$in, loop$key) {
  while (true) {
    let in$ = loop$in;
    let key = loop$key;
    if (in$ === "") {
      return new None();
    } else if (in$.startsWith(" ")) {
      return new None();
    } else if (in$.startsWith("=\"")) {
      let in$1 = in$.slice(2);
      return parse_attribute_quoted_value(in$1, key, "");
    } else if (in$.startsWith("=")) {
      let in$1 = in$.slice(1);
      return parse_attribute_value(in$1, key, "");
    } else {
      let $ = $string.pop_grapheme(in$);
      if ($ instanceof Ok) {
        let c = $[0][0];
        let in$1 = $[0][1];
        loop$in = in$1;
        loop$key = key + c;
      } else {
        return new None();
      }
    }
  }
}

function parse_attributes_id_or_class(loop$in, loop$id) {
  while (true) {
    let in$ = loop$in;
    let id = loop$id;
    if (in$ === "") {
      return new Some([id, in$]);
    } else if (in$.startsWith("}")) {
      return new Some([id, in$]);
    } else if (in$.startsWith(" ")) {
      return new Some([id, in$]);
    } else if (in$.startsWith("#")) {
      return new None();
    } else if (in$.startsWith(".")) {
      return new None();
    } else if (in$.startsWith("=")) {
      return new None();
    } else if (in$.startsWith("\n")) {
      return new None();
    } else {
      let $ = $string.pop_grapheme(in$);
      if ($ instanceof Ok) {
        let c = $[0][0];
        let in$1 = $[0][1];
        loop$in = in$1;
        loop$id = id + c;
      } else {
        return new Some([id, in$]);
      }
    }
  }
}

function parse_attributes_end(loop$in, loop$attrs) {
  while (true) {
    let in$ = loop$in;
    let attrs = loop$attrs;
    if (in$ === "") {
      return new Some([attrs, ""]);
    } else if (in$.startsWith("\n")) {
      let in$1 = in$.slice(1);
      return new Some([attrs, in$1]);
    } else if (in$.startsWith(" ")) {
      let in$1 = in$.slice(1);
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
    if (in$1 === "") {
      return new None();
    } else if (in$1.startsWith("}")) {
      let in$2 = in$1.slice(1);
      return parse_attributes_end(in$2, attrs);
    } else if (in$1.startsWith("#")) {
      let in$2 = in$1.slice(1);
      let $ = parse_attributes_id_or_class(in$2, "");
      if ($ instanceof Some) {
        let id = $[0][0];
        let in$3 = $[0][1];
        loop$in = in$3;
        loop$attrs = add_attribute(attrs, "id", id);
      } else {
        return new None();
      }
    } else if (in$1.startsWith(".")) {
      let in$2 = in$1.slice(1);
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

function id_sanitise(content) {
  let _pipe = content;
  let _pipe$1 = $string.replace(_pipe, "#", "");
  let _pipe$2 = $string.replace(_pipe$1, "?", "");
  let _pipe$3 = $string.replace(_pipe$2, "!", "");
  let _pipe$4 = $string.replace(_pipe$3, ",", "");
  let _pipe$5 = $string.trim(_pipe$4);
  let _pipe$6 = $string.replace(_pipe$5, " ", "-");
  return $string.replace(_pipe$6, "\n", "-");
}

function take_heading_chars_newline_hash(loop$in, loop$level, loop$acc) {
  while (true) {
    let in$ = loop$in;
    let level = loop$level;
    let acc = loop$acc;
    if (level < 0) {
      return new None();
    } else {
      if (in$ === "") {
        if (level > 0) {
          return new None();
        } else {
          if (level === 0) {
            return new Some([acc, ""]);
          } else {
            return new None();
          }
        }
      } else if (in$.startsWith(" ")) {
        if (level === 0) {
          let in$1 = in$.slice(1);
          return new Some([acc, in$1]);
        } else {
          return new None();
        }
      } else if (in$.startsWith("#")) {
        let rest = in$.slice(1);
        loop$in = rest;
        loop$level = level - 1;
        loop$acc = acc;
      } else {
        return new None();
      }
    }
  }
}

function take_heading_chars(loop$in, loop$level, loop$acc) {
  while (true) {
    let in$ = loop$in;
    let level = loop$level;
    let acc = loop$acc;
    if (in$ === "") {
      return [acc, ""];
    } else if (in$ === "\n") {
      return [acc, ""];
    } else if (in$.startsWith("\n\n")) {
      let in$1 = in$.slice(2);
      return [acc, in$1];
    } else if (in$.startsWith("\n#")) {
      let rest = in$.slice(2);
      let $ = take_heading_chars_newline_hash(rest, level - 1, acc + "\n");
      if ($ instanceof Some) {
        let acc$1 = $[0][0];
        let in$1 = $[0][1];
        loop$in = in$1;
        loop$level = level;
        loop$acc = acc$1;
      } else {
        return [acc, in$];
      }
    } else {
      let $ = $string.pop_grapheme(in$);
      if ($ instanceof Ok) {
        let c = $[0][0];
        let in$1 = $[0][1];
        loop$in = in$1;
        loop$level = level;
        loop$acc = acc + c;
      } else {
        return [acc, ""];
      }
    }
  }
}

function parse_code_end(loop$in, loop$limit, loop$count, loop$content) {
  while (true) {
    let in$ = loop$in;
    let limit = loop$limit;
    let count = loop$count;
    let content = loop$content;
    if (in$ === "") {
      return [true, content, in$];
    } else if (in$.startsWith("`")) {
      let in$1 = in$.slice(1);
      loop$in = in$1;
      loop$limit = limit;
      loop$count = count + 1;
      loop$content = content;
    } else if (limit === count) {
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
    if (in$ === "") {
      return [content, in$];
    } else if (in$.startsWith("`")) {
      let in$1 = in$.slice(1);
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
      let $ = $string.pop_grapheme(in$);
      if ($ instanceof Ok) {
        let c = $[0][0];
        let in$1 = $[0][1];
        loop$in = in$1;
        loop$count = count;
        loop$content = content + c;
      } else {
        return [content, in$];
      }
    }
  }
}

function parse_code(loop$in, loop$count) {
  while (true) {
    let in$ = loop$in;
    let count = loop$count;
    if (in$.startsWith("`")) {
      let in$1 = in$.slice(1);
      loop$in = in$1;
      loop$count = count + 1;
    } else {
      let $ = parse_code_content(in$, count, "");
      let content = $[0];
      let in$1 = $[1];
      let _block;
      let $1 = $string.starts_with(content, " `");
      if ($1) {
        _block = $string.trim_start(content);
      } else {
        _block = content;
      }
      let content$1 = _block;
      let _block$1;
      let $2 = $string.ends_with(content$1, "` ");
      if ($2) {
        _block$1 = $string.trim_end(content$1);
      } else {
        _block$1 = content$1;
      }
      let content$2 = _block$1;
      return [new Code(content$2), in$1];
    }
  }
}

function take_emphasis_chars(loop$in, loop$close, loop$acc) {
  while (true) {
    let in$ = loop$in;
    let close = loop$close;
    let acc = loop$acc;
    if (in$ === "") {
      return new None();
    } else if (in$.startsWith("`")) {
      return new None();
    } else if (in$.startsWith("\t")) {
      let ws = "\t";
      let in$1 = in$.slice(1);
      let $ = $string.pop_grapheme(in$1);
      if ($ instanceof Ok) {
        let c = $[0][0];
        if (c === close) {
          let in$2 = $[0][1];
          loop$in = in$2;
          loop$close = close;
          loop$acc = (acc + ws) + c;
        } else {
          loop$in = in$1;
          loop$close = close;
          loop$acc = acc + ws;
        }
      } else {
        loop$in = in$1;
        loop$close = close;
        loop$acc = acc + ws;
      }
    } else if (in$.startsWith("\n")) {
      let ws = "\n";
      let in$1 = in$.slice(1);
      let $ = $string.pop_grapheme(in$1);
      if ($ instanceof Ok) {
        let c = $[0][0];
        if (c === close) {
          let in$2 = $[0][1];
          loop$in = in$2;
          loop$close = close;
          loop$acc = (acc + ws) + c;
        } else {
          loop$in = in$1;
          loop$close = close;
          loop$acc = acc + ws;
        }
      } else {
        loop$in = in$1;
        loop$close = close;
        loop$acc = acc + ws;
      }
    } else if (in$.startsWith(" ")) {
      let ws = " ";
      let in$1 = in$.slice(1);
      let $ = $string.pop_grapheme(in$1);
      if ($ instanceof Ok) {
        let c = $[0][0];
        if (c === close) {
          let in$2 = $[0][1];
          loop$in = in$2;
          loop$close = close;
          loop$acc = (acc + ws) + c;
        } else {
          loop$in = in$1;
          loop$close = close;
          loop$acc = acc + ws;
        }
      } else {
        loop$in = in$1;
        loop$close = close;
        loop$acc = acc + ws;
      }
    } else {
      let $ = $string.pop_grapheme(in$);
      if ($ instanceof Ok) {
        let c = $[0][0];
        if ((c === close) && (acc === "")) {
          return new None();
        } else {
          let c$1 = $[0][0];
          if (c$1 === close) {
            let in$1 = $[0][1];
            return new Some([acc, in$1]);
          } else {
            let c$2 = $[0][0];
            let in$1 = $[0][1];
            loop$in = in$1;
            loop$close = close;
            loop$acc = acc + c$2;
          }
        }
      } else {
        return new None();
      }
    }
  }
}

function take_link_chars_destination(
  loop$in,
  loop$is_url,
  loop$inline_in,
  loop$splitters,
  loop$acc
) {
  while (true) {
    let in$ = loop$in;
    let is_url = loop$is_url;
    let inline_in = loop$inline_in;
    let splitters = loop$splitters;
    let acc = loop$acc;
    let $ = $splitter.split(splitters.link_destination, in$);
    let $1 = $[1];
    if ($1 === ")") {
      if (is_url) {
        let a = $[0];
        let in$1 = $[2];
        return new Some([inline_in, new Url(acc + a), in$1]);
      } else {
        return new None();
      }
    } else if ($1 === "]") {
      if (!is_url) {
        let a = $[0];
        let in$1 = $[2];
        return new Some([inline_in, new Reference(acc + a), in$1]);
      } else {
        return new None();
      }
    } else if ($1 === "\n") {
      if (is_url) {
        let a = $[0];
        let rest = $[2];
        loop$in = rest;
        loop$is_url = is_url;
        loop$inline_in = inline_in;
        loop$splitters = splitters;
        loop$acc = acc + a;
      } else {
        if (!is_url) {
          let a = $[0];
          let rest = $[2];
          loop$in = rest;
          loop$is_url = is_url;
          loop$inline_in = inline_in;
          loop$splitters = splitters;
          loop$acc = (acc + a) + " ";
        } else {
          return new None();
        }
      }
    } else {
      return new None();
    }
  }
}

function take_link_chars(loop$in, loop$inline_in, loop$splitters) {
  while (true) {
    let in$ = loop$in;
    let inline_in = loop$inline_in;
    let splitters = loop$splitters;
    let $ = $string.split_once(in$, "]");
    if ($ instanceof Ok) {
      let $1 = $[0][1];
      if ($1.startsWith("[")) {
        let before = $[0][0];
        let in$1 = $1.slice(1);
        return take_link_chars_destination(
          in$1,
          false,
          inline_in + before,
          splitters,
          "",
        );
      } else if ($1.startsWith("(")) {
        let before = $[0][0];
        let in$1 = $1.slice(1);
        return take_link_chars_destination(
          in$1,
          true,
          inline_in + before,
          splitters,
          "",
        );
      } else {
        let before = $[0][0];
        let in$1 = $1;
        loop$in = in$1;
        loop$inline_in = inline_in + before;
        loop$splitters = splitters;
      }
    } else {
      return new None();
    }
  }
}

function parse_footnote(loop$in, loop$acc) {
  while (true) {
    let in$ = loop$in;
    let acc = loop$acc;
    if (in$ === "") {
      return new None();
    } else if (in$.startsWith("]")) {
      let rest = in$.slice(1);
      return new Some([new Footnote(acc), rest]);
    } else {
      let $ = $string.pop_grapheme(in$);
      if ($ instanceof Ok) {
        let c = $[0][0];
        let rest = $[0][1];
        loop$in = rest;
        loop$acc = acc + c;
      } else {
        return new None();
      }
    }
  }
}

function heading_level(loop$in, loop$level) {
  while (true) {
    let in$ = loop$in;
    let level = loop$level;
    if (in$.startsWith("#")) {
      let rest = in$.slice(1);
      loop$in = rest;
      loop$level = level + 1;
    } else if (in$ === "") {
      if (level > 0) {
        return new Some([level, ""]);
      } else {
        return new None();
      }
    } else if (in$.startsWith(" ")) {
      if (level !== 0) {
        let rest = in$.slice(1);
        return new Some([level, rest]);
      } else {
        return new None();
      }
    } else if (in$.startsWith("\n")) {
      if (level !== 0) {
        let rest = in$.slice(1);
        return new Some([level, rest]);
      } else {
        return new None();
      }
    } else {
      return new None();
    }
  }
}

function take_inline_text(loop$inlines, loop$acc) {
  while (true) {
    let inlines = loop$inlines;
    let acc = loop$acc;
    if (inlines instanceof $Empty) {
      return acc;
    } else {
      let first = inlines.head;
      let rest = inlines.tail;
      if (first instanceof Linebreak) {
        loop$inlines = rest;
        loop$acc = acc;
      } else if (first instanceof NonBreakingSpace) {
        loop$inlines = rest;
        loop$acc = acc + " ";
      } else if (first instanceof Text) {
        let text = first[0];
        loop$inlines = rest;
        loop$acc = acc + text;
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
      } else if (first instanceof Emphasis) {
        let inlines$1 = first.content;
        loop$inlines = $list.append(inlines$1, rest);
        loop$acc = acc;
      } else if (first instanceof Strong) {
        let inlines$1 = first.content;
        loop$inlines = $list.append(inlines$1, rest);
        loop$acc = acc;
      } else if (first instanceof Footnote) {
        loop$inlines = rest;
        loop$acc = acc;
      } else {
        let text = first.content;
        loop$inlines = rest;
        loop$acc = acc + text;
      }
    }
  }
}

function take_list_item_chars(loop$in, loop$acc, loop$style) {
  while (true) {
    let in$ = loop$in;
    let acc = loop$acc;
    let style = loop$style;
    let _block;
    let $1 = $string.split_once(in$, "\n");
    if ($1 instanceof Ok) {
      let content = $1[0][0];
      let in$1 = $1[0][1];
      _block = [in$1, acc + content];
    } else {
      _block = ["", acc + in$];
    }
    let $ = _block;
    let in$1 = $[0];
    let acc$1 = $[1];
    if (in$1.startsWith(" ")) {
      let in$2 = in$1.slice(1);
      loop$in = in$2;
      loop$acc = acc$1 + "\n ";
      loop$style = style;
    } else if (in$1.startsWith("- ")) {
      if (style === "-") {
        let in$2 = in$1.slice(2);
        return [acc$1, in$2, false];
      } else {
        return [acc$1, in$1, true];
      }
    } else if (in$1.startsWith("\n- ")) {
      if (style === "-") {
        let in$2 = in$1.slice(3);
        return [acc$1, in$2, false];
      } else {
        return [acc$1, in$1, true];
      }
    } else if (in$1.startsWith("* ")) {
      if (style === "*") {
        let in$2 = in$1.slice(2);
        return [acc$1, in$2, false];
      } else {
        return [acc$1, in$1, true];
      }
    } else if (in$1.startsWith("\n* ")) {
      if (style === "*") {
        let in$2 = in$1.slice(3);
        return [acc$1, in$2, false];
      } else {
        return [acc$1, in$1, true];
      }
    } else {
      return [acc$1, in$1, true];
    }
  }
}

function take_paragraph_chars(in$) {
  let $ = $string.split_once(in$, "\n\n");
  if ($ instanceof Ok) {
    let content = $[0][0];
    let in$1 = $[0][1];
    return [content, in$1];
  } else {
    let $1 = $string.ends_with(in$, "\n");
    if ($1) {
      return [$string.drop_end(in$, 1), ""];
    } else {
      return [in$, ""];
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
    if ($1 instanceof $Empty) {
      return acc;
    } else if ($ instanceof $Empty) {
      let new$ = $1.head;
      let rest = $1.tail;
      loop$original_html = original_html;
      loop$new_html = (() => {
        let _record = new_html;
        return new GeneratedHtml(_record.html, rest);
      })();
      loop$acc = listPrepend(new$, acc);
    } else {
      let new$ = $1.head;
      let original = $.head;
      if (isEqual(original, new$)) {
        return acc;
      } else {
        let new$1 = $1.head;
        let rest = $1.tail;
        loop$original_html = original_html;
        loop$new_html = (() => {
          let _record = new_html;
          return new GeneratedHtml(_record.html, rest);
        })();
        loop$acc = listPrepend(new$1, acc);
      }
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
    if (footnotes_to_check instanceof $Empty) {
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
    } else {
      let ref = footnotes_to_check.head[1];
      if (reference === ref) {
        let index = footnotes_to_check.head[0];
        return [$int.to_string(index), used_footnotes];
      } else {
        let rest = footnotes_to_check.tail;
        loop$footnotes_to_check = rest;
        loop$reference = reference;
        loop$used_footnotes = used_footnotes;
      }
    }
  }
}

function destination_attribute(key, destination, refs) {
  let dict = $dict.new$();
  if (destination instanceof Reference) {
    let id = destination[0];
    let $ = $dict.get(refs.urls, id);
    if ($ instanceof Ok) {
      let url = $[0];
      return $dict.insert(dict, key, $houdini.escape(url));
    } else {
      return dict;
    }
  } else {
    let url = destination[0];
    return $dict.insert(dict, key, $houdini.escape(url));
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

function list_items_to_html(loop$html, loop$layout, loop$items, loop$refs) {
  while (true) {
    let html = loop$html;
    let layout = loop$layout;
    let items = loop$items;
    let refs = loop$refs;
    if (items instanceof $Empty) {
      return html;
    } else {
      let $ = items.head;
      if ($ instanceof $Empty) {
        let item = $;
        let rest = items.tail;
        let _pipe = html;
        let _pipe$1 = open_tag(_pipe, "li", $dict.new$());
        let _pipe$2 = append_to_html(_pipe$1, "\n");
        let _pipe$3 = ((_capture) => {
          return containers_to_html(item, refs, _capture);
        })(_pipe$2);
        let _pipe$4 = append_to_html(_pipe$3, "\n");
        let _pipe$5 = close_tag(_pipe$4, "li");
        let _pipe$6 = append_to_html(_pipe$5, "\n");
        loop$html = _pipe$6;
        loop$layout = layout;
        loop$items = rest;
        loop$refs = refs;
      } else {
        let $1 = $.tail;
        if ($1 instanceof $Empty) {
          let $2 = $.head;
          if ($2 instanceof Paragraph) {
            if (isEqual(layout, new Tight())) {
              let rest = items.tail;
              let inlines = $2.content;
              let _pipe = html;
              let _pipe$1 = open_tag(_pipe, "li", $dict.new$());
              let _pipe$2 = append_to_html(_pipe$1, "\n");
              let _pipe$3 = inlines_to_html(
                _pipe$2,
                inlines,
                refs,
                new TrimLast(),
              );
              let _pipe$4 = append_to_html(_pipe$3, "\n");
              let _pipe$5 = close_tag(_pipe$4, "li");
              let _pipe$6 = append_to_html(_pipe$5, "\n");
              loop$html = _pipe$6;
              loop$layout = layout;
              loop$items = rest;
              loop$refs = refs;
            } else {
              let item = $;
              let rest = items.tail;
              let _pipe = html;
              let _pipe$1 = open_tag(_pipe, "li", $dict.new$());
              let _pipe$2 = append_to_html(_pipe$1, "\n");
              let _pipe$3 = ((_capture) => {
                return containers_to_html(item, refs, _capture);
              })(_pipe$2);
              let _pipe$4 = append_to_html(_pipe$3, "\n");
              let _pipe$5 = close_tag(_pipe$4, "li");
              let _pipe$6 = append_to_html(_pipe$5, "\n");
              loop$html = _pipe$6;
              loop$layout = layout;
              loop$items = rest;
              loop$refs = refs;
            }
          } else {
            let item = $;
            let rest = items.tail;
            let _pipe = html;
            let _pipe$1 = open_tag(_pipe, "li", $dict.new$());
            let _pipe$2 = append_to_html(_pipe$1, "\n");
            let _pipe$3 = ((_capture) => {
              return containers_to_html(item, refs, _capture);
            })(_pipe$2);
            let _pipe$4 = append_to_html(_pipe$3, "\n");
            let _pipe$5 = close_tag(_pipe$4, "li");
            let _pipe$6 = append_to_html(_pipe$5, "\n");
            loop$html = _pipe$6;
            loop$layout = layout;
            loop$items = rest;
            loop$refs = refs;
          }
        } else {
          let item = $;
          let rest = items.tail;
          let _pipe = html;
          let _pipe$1 = open_tag(_pipe, "li", $dict.new$());
          let _pipe$2 = append_to_html(_pipe$1, "\n");
          let _pipe$3 = ((_capture) => {
            return containers_to_html(item, refs, _capture);
          })(_pipe$2);
          let _pipe$4 = append_to_html(_pipe$3, "\n");
          let _pipe$5 = close_tag(_pipe$4, "li");
          let _pipe$6 = append_to_html(_pipe$5, "\n");
          loop$html = _pipe$6;
          loop$layout = layout;
          loop$items = rest;
          loop$refs = refs;
        }
      }
    }
  }
}

function containers_to_html(loop$containers, loop$refs, loop$html) {
  while (true) {
    let containers = loop$containers;
    let refs = loop$refs;
    let html = loop$html;
    if (containers instanceof $Empty) {
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

function container_to_html(html, container, refs) {
  let _block;
  if (container instanceof ThematicBreak) {
    let _pipe = html;
    _block = open_tag(_pipe, "hr", $dict.new$());
  } else if (container instanceof Paragraph) {
    let attrs = container.attributes;
    let inlines = container.content;
    let _pipe = html;
    let _pipe$1 = open_tag(_pipe, "p", attrs);
    let _pipe$2 = inlines_to_html(_pipe$1, inlines, refs, new TrimLast());
    _block = close_tag(_pipe$2, "p");
  } else if (container instanceof Heading) {
    let attrs = container.attributes;
    let level = container.level;
    let inlines = container.content;
    let tag = "h" + $int.to_string(level);
    let _pipe = html;
    let _pipe$1 = open_tag(_pipe, tag, attrs);
    let _pipe$2 = inlines_to_html(_pipe$1, inlines, refs, new TrimLast());
    _block = close_tag(_pipe$2, tag);
  } else if (container instanceof Codeblock) {
    let attrs = container.attributes;
    let language = container.language;
    let content = container.content;
    let _block$1;
    if (language instanceof Some) {
      let lang = language[0];
      _block$1 = add_attribute(attrs, "class", "language-" + lang);
    } else {
      _block$1 = attrs;
    }
    let code_attrs = _block$1;
    let _pipe = html;
    let _pipe$1 = open_tag(_pipe, "pre", $dict.new$());
    let _pipe$2 = open_tag(_pipe$1, "code", code_attrs);
    let _pipe$3 = append_to_html(_pipe$2, $houdini.escape(content));
    let _pipe$4 = close_tag(_pipe$3, "code");
    _block = close_tag(_pipe$4, "pre");
  } else if (container instanceof RawBlock) {
    let content = container.content;
    let _record = html;
    _block = new GeneratedHtml(html.html + content, _record.used_footnotes);
  } else {
    let layout = container.layout;
    let items = container.items;
    let _pipe = html;
    let _pipe$1 = open_tag(_pipe, "ul", $dict.new$());
    let _pipe$2 = append_to_html(_pipe$1, "\n");
    let _pipe$3 = list_items_to_html(_pipe$2, layout, items, refs);
    _block = close_tag(_pipe$3, "ul");
  }
  let new_html = _block;
  return append_to_html(new_html, "\n");
}

function inline_to_html(html, inline, refs, trim) {
  if (inline instanceof Linebreak) {
    let _pipe = html;
    let _pipe$1 = open_tag(_pipe, "br", $dict.new$());
    return append_to_html(_pipe$1, "\n");
  } else if (inline instanceof NonBreakingSpace) {
    let _pipe = html;
    return append_to_html(_pipe, "&nbsp;");
  } else if (inline instanceof Text) {
    let text = inline[0];
    let text$1 = $houdini.escape(text);
    if (trim instanceof NoTrim) {
      return append_to_html(html, text$1);
    } else {
      return append_to_html(html, $string.trim_end(text$1));
    }
  } else if (inline instanceof Link) {
    let text = inline.content;
    let destination = inline.destination;
    let _pipe = html;
    let _pipe$1 = open_tag(
      _pipe,
      "a",
      destination_attribute("href", destination, refs),
    );
    let _pipe$2 = inlines_to_html(_pipe$1, text, refs, trim);
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
        return $dict.insert(
          _pipe$1,
          "alt",
          $houdini.escape(take_inline_text(text, "")),
        );
      })(),
    );
  } else if (inline instanceof Emphasis) {
    let inlines = inline.content;
    let _pipe = html;
    let _pipe$1 = open_tag(_pipe, "em", $dict.new$());
    let _pipe$2 = inlines_to_html(_pipe$1, inlines, refs, trim);
    return close_tag(_pipe$2, "em");
  } else if (inline instanceof Strong) {
    let inlines = inline.content;
    let _pipe = html;
    let _pipe$1 = open_tag(_pipe, "strong", $dict.new$());
    let _pipe$2 = inlines_to_html(_pipe$1, inlines, refs, trim);
    return close_tag(_pipe$2, "strong");
  } else if (inline instanceof Footnote) {
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
    let _block;
    let _pipe = html;
    let _pipe$1 = open_tag_ordered_attributes(_pipe, "a", footnote_attrs);
    let _pipe$2 = append_to_html(
      _pipe$1,
      ("<sup>" + footnote_number) + "</sup>",
    );
    _block = close_tag(_pipe$2, "a");
    let updated_html = _block;
    let _record = updated_html;
    return new GeneratedHtml(_record.html, new_used_footnotes);
  } else {
    let content = inline.content;
    let content$1 = $houdini.escape(content);
    let _pipe = html;
    let _pipe$1 = open_tag(_pipe, "code", $dict.new$());
    let _pipe$2 = append_to_html(_pipe$1, content$1);
    return close_tag(_pipe$2, "code");
  }
}

function inlines_to_html(loop$html, loop$inlines, loop$refs, loop$trim) {
  while (true) {
    let html = loop$html;
    let inlines = loop$inlines;
    let refs = loop$refs;
    let trim = loop$trim;
    if (inlines instanceof $Empty) {
      return html;
    } else {
      let $ = inlines.tail;
      if ($ instanceof $Empty) {
        if (isEqual(trim, new TrimLast())) {
          let inline = inlines.head;
          let _pipe = html;
          return inline_to_html(_pipe, inline, refs, trim);
        } else {
          let inline = inlines.head;
          let rest = $;
          let _pipe = html;
          let _pipe$1 = inline_to_html(_pipe, inline, refs, new NoTrim());
          loop$html = _pipe$1;
          loop$inlines = rest;
          loop$refs = refs;
          loop$trim = trim;
        }
      } else {
        let inline = inlines.head;
        let rest = $;
        let _pipe = html;
        let _pipe$1 = inline_to_html(_pipe, inline, refs, new NoTrim());
        loop$html = _pipe$1;
        loop$inlines = rest;
        loop$refs = refs;
        loop$trim = trim;
      }
    }
  }
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
    if (containers instanceof $Empty) {
      return html;
    } else {
      let $ = containers.tail;
      if ($ instanceof $Empty) {
        let container = containers.head;
        if (container instanceof Paragraph) {
          let attrs = container.attributes;
          let inlines = container.content;
          let _pipe = html;
          let _pipe$1 = open_tag(_pipe, "p", attrs);
          let _pipe$2 = inlines_to_html(_pipe$1, inlines, refs, new TrimLast());
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
        let rest = $;
        let html$1 = container_to_html(html, container, refs);
        loop$containers = rest;
        loop$refs = refs;
        loop$html = html$1;
        loop$apply = apply;
      }
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
    if (used_footnotes instanceof $Empty) {
      return html_acc;
    } else {
      let other_footnotes = used_footnotes.tail;
      let footnote_number = used_footnotes.head[0];
      let footnote = used_footnotes.head[1];
      let footnote_number$1 = $int.to_string(footnote_number);
      let _block;
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
      _block = append_to_html(_pipe$5, "\n");
      let html = _block;
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
      let _block;
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
      _block = append_to_html(_pipe$5, "\n");
      let footnotes_section_html = _block;
      let html_with_footnotes = create_footnotes(
        document,
        $list.reverse(footnotes_section_html.used_footnotes),
        footnotes_section_html,
      );
      let _block$1;
      let _pipe$6 = html_with_footnotes;
      let _pipe$7 = close_tag(_pipe$6, "ol");
      let _pipe$8 = append_to_html(_pipe$7, "\n");
      let _pipe$9 = close_tag(_pipe$8, "section");
      _block$1 = append_to_html(_pipe$9, "\n");
      return _block$1.html;
    },
  );
}

function parse_block(
  loop$in,
  loop$refs,
  loop$splitters,
  loop$ast,
  loop$attrs,
  loop$required_spaces
) {
  while (true) {
    let in$ = loop$in;
    let refs = loop$refs;
    let splitters = loop$splitters;
    let ast = loop$ast;
    let attrs = loop$attrs;
    let required_spaces = loop$required_spaces;
    let in$1 = drop_lines(in$);
    let $ = count_drop_spaces(in$1, 0);
    let in$2 = $[0];
    let indentation = $[1];
    let $1 = indentation < required_spaces;
    if ($1) {
      return [$list.reverse(ast), refs, in$2];
    } else {
      let $2 = parse_container(in$2, refs, splitters, attrs, indentation);
      let in$3 = $2[0];
      let refs$1 = $2[1];
      let container = $2[2];
      let attrs$1 = $2[3];
      let _block;
      if (container instanceof Some) {
        let container$1 = container[0];
        _block = listPrepend(container$1, ast);
      } else {
        _block = ast;
      }
      let ast$1 = _block;
      if (in$3 === "") {
        return [$list.reverse(ast$1), refs$1, in$3];
      } else {
        loop$in = in$3;
        loop$refs = refs$1;
        loop$splitters = splitters;
        loop$ast = ast$1;
        loop$attrs = attrs$1;
        loop$required_spaces = required_spaces;
      }
    }
  }
}

function parse_container(in$, refs, splitters, attrs, indentation) {
  if (in$ === "") {
    return [in$, refs, new None(), $dict.new$()];
  } else if (in$.startsWith("{")) {
    let in2 = in$.slice(1);
    let $ = parse_attributes(in2, attrs);
    if ($ instanceof Some) {
      let attrs$1 = $[0][0];
      let in$1 = $[0][1];
      return [in$1, refs, new None(), attrs$1];
    } else {
      let $1 = parse_paragraph(in$, attrs, splitters);
      let paragraph = $1[0];
      let in$1 = $1[1];
      return [in$1, refs, new Some(paragraph), $dict.new$()];
    }
  } else if (in$.startsWith("#")) {
    let in$1 = in$.slice(1);
    let $ = parse_heading(in$1, refs, splitters, attrs);
    let heading = $[0];
    let refs$1 = $[1];
    let in$2 = $[2];
    return [in$2, refs$1, new Some(heading), $dict.new$()];
  } else if (in$.startsWith("~")) {
    let delim = "~";
    let in2 = in$.slice(1);
    let $ = parse_codeblock(in2, attrs, delim, indentation, splitters);
    if ($ instanceof Some) {
      let codeblock = $[0][0];
      let in$1 = $[0][1];
      return [in$1, refs, new Some(codeblock), $dict.new$()];
    } else {
      let $1 = parse_paragraph(in$, attrs, splitters);
      let paragraph = $1[0];
      let in$1 = $1[1];
      return [in$1, refs, new Some(paragraph), $dict.new$()];
    }
  } else if (in$.startsWith("`")) {
    let delim = "`";
    let in2 = in$.slice(1);
    let $ = parse_codeblock(in2, attrs, delim, indentation, splitters);
    if ($ instanceof Some) {
      let codeblock = $[0][0];
      let in$1 = $[0][1];
      return [in$1, refs, new Some(codeblock), $dict.new$()];
    } else {
      let $1 = parse_paragraph(in$, attrs, splitters);
      let paragraph = $1[0];
      let in$1 = $1[1];
      return [in$1, refs, new Some(paragraph), $dict.new$()];
    }
  } else if (in$.startsWith("-")) {
    let style = "-";
    let in2 = in$.slice(1);
    let $ = parse_thematic_break(1, in2);
    if ($ instanceof Some) {
      let thematic_break = $[0][0];
      let in$1 = $[0][1];
      return [in$1, refs, new Some(thematic_break), $dict.new$()];
    } else if (in2.startsWith(" ")) {
      let in2$1 = in2.slice(1);
      let $1 = parse_bullet_list(
        in2$1,
        refs,
        attrs,
        style,
        new Tight(),
        toList([]),
        splitters,
      );
      let list = $1[0];
      let in$1 = $1[1];
      return [in$1, refs, new Some(list), $dict.new$()];
    } else if (in2.startsWith("\n")) {
      let in2$1 = in2.slice(1);
      let $1 = parse_bullet_list(
        in2$1,
        refs,
        attrs,
        style,
        new Tight(),
        toList([]),
        splitters,
      );
      let list = $1[0];
      let in$1 = $1[1];
      return [in$1, refs, new Some(list), $dict.new$()];
    } else {
      let $1 = parse_paragraph(in$, attrs, splitters);
      let paragraph = $1[0];
      let in$1 = $1[1];
      return [in$1, refs, new Some(paragraph), $dict.new$()];
    }
  } else if (in$.startsWith("*")) {
    let style = "*";
    let in2 = in$.slice(1);
    let $ = parse_thematic_break(1, in2);
    if ($ instanceof Some) {
      let thematic_break = $[0][0];
      let in$1 = $[0][1];
      return [in$1, refs, new Some(thematic_break), $dict.new$()];
    } else if (in2.startsWith(" ")) {
      let in2$1 = in2.slice(1);
      let $1 = parse_bullet_list(
        in2$1,
        refs,
        attrs,
        style,
        new Tight(),
        toList([]),
        splitters,
      );
      let list = $1[0];
      let in$1 = $1[1];
      return [in$1, refs, new Some(list), $dict.new$()];
    } else if (in2.startsWith("\n")) {
      let in2$1 = in2.slice(1);
      let $1 = parse_bullet_list(
        in2$1,
        refs,
        attrs,
        style,
        new Tight(),
        toList([]),
        splitters,
      );
      let list = $1[0];
      let in$1 = $1[1];
      return [in$1, refs, new Some(list), $dict.new$()];
    } else {
      let $1 = parse_paragraph(in$, attrs, splitters);
      let paragraph = $1[0];
      let in$1 = $1[1];
      return [in$1, refs, new Some(paragraph), $dict.new$()];
    }
  } else if (in$.startsWith("[^")) {
    let in2 = in$.slice(2);
    let $ = parse_footnote_def(in2, refs, splitters, "^");
    if ($ instanceof Some) {
      let id = $[0][0];
      let footnote = $[0][1];
      let refs$1 = $[0][2];
      let in$1 = $[0][3];
      let _block;
      let _record = refs$1;
      _block = new Refs(
        _record.urls,
        $dict.insert(refs$1.footnotes, id, footnote),
      );
      let refs$2 = _block;
      return [in$1, refs$2, new None(), $dict.new$()];
    } else {
      let $1 = parse_paragraph(in$, attrs, splitters);
      let paragraph = $1[0];
      let in$1 = $1[1];
      return [in$1, refs, new Some(paragraph), $dict.new$()];
    }
  } else if (in$.startsWith("[")) {
    let in2 = in$.slice(1);
    let $ = parse_ref_def(in2, "");
    if ($ instanceof Some) {
      let id = $[0][0];
      let url = $[0][1];
      let in$1 = $[0][2];
      let _block;
      let _record = refs;
      _block = new Refs($dict.insert(refs.urls, id, url), _record.footnotes);
      let refs$1 = _block;
      return [in$1, refs$1, new None(), $dict.new$()];
    } else {
      let $1 = parse_paragraph(in$, attrs, splitters);
      let paragraph = $1[0];
      let in$1 = $1[1];
      return [in$1, refs, new Some(paragraph), $dict.new$()];
    }
  } else {
    let $ = parse_paragraph(in$, attrs, splitters);
    let paragraph = $[0];
    let in$1 = $[1];
    return [in$1, refs, new Some(paragraph), $dict.new$()];
  }
}

function parse_footnote_def(loop$in, loop$refs, loop$splitters, loop$id) {
  while (true) {
    let in$ = loop$in;
    let refs = loop$refs;
    let splitters = loop$splitters;
    let id = loop$id;
    if (in$.startsWith("]:")) {
      let in$1 = in$.slice(2);
      let $ = count_drop_spaces(in$1, 0);
      let in$2 = $[0];
      let spaces_count = $[1];
      let _block;
      if (in$2.startsWith("\n")) {
        _block = parse_block;
      } else {
        _block = (in$, refs, splitters, ast, attrs, required_spaces) => {
          return parse_block_after_indent_checked(
            in$,
            refs,
            splitters,
            ast,
            attrs,
            required_spaces,
            (4 + $string.length(id)) + spaces_count,
          );
        };
      }
      let block_parser = _block;
      let $1 = block_parser(in$2, refs, splitters, toList([]), $dict.new$(), 1);
      let block = $1[0];
      let refs$1 = $1[1];
      let rest = $1[2];
      return new Some([id, block, refs$1, rest]);
    } else if (in$ === "") {
      return new None();
    } else if (in$.startsWith("]")) {
      return new None();
    } else if (in$.startsWith("\n")) {
      return new None();
    } else {
      let $ = $string.pop_grapheme(in$);
      if ($ instanceof Ok) {
        let c = $[0][0];
        let in$1 = $[0][1];
        loop$in = in$1;
        loop$refs = refs;
        loop$splitters = splitters;
        loop$id = id + c;
      } else {
        return new None();
      }
    }
  }
}

function parse_document_content(
  loop$in,
  loop$refs,
  loop$splitters,
  loop$ast,
  loop$attrs
) {
  while (true) {
    let in$ = loop$in;
    let refs = loop$refs;
    let splitters = loop$splitters;
    let ast = loop$ast;
    let attrs = loop$attrs;
    let in$1 = drop_lines(in$);
    let $ = count_drop_spaces(in$1, 0);
    let in$2 = $[0];
    let spaces_count = $[1];
    let $1 = parse_container(in$2, refs, splitters, attrs, spaces_count);
    let in$3 = $1[0];
    let refs$1 = $1[1];
    let container = $1[2];
    let attrs$1 = $1[3];
    let _block;
    if (container instanceof Some) {
      let container$1 = container[0];
      _block = listPrepend(container$1, ast);
    } else {
      _block = ast;
    }
    let ast$1 = _block;
    if (in$3 === "") {
      return [$list.reverse(ast$1), refs$1, in$3];
    } else {
      loop$in = in$3;
      loop$refs = refs$1;
      loop$splitters = splitters;
      loop$ast = ast$1;
      loop$attrs = attrs$1;
    }
  }
}

export function parse(djot) {
  let splitters = new Splitters(
    $splitter.new$(toList([" ", "\n"])),
    $splitter.new$(toList(["`", "\n"])),
    $splitter.new$(toList(["\\", "_", "*", "[^", "[", "![", "`", "\n"])),
    $splitter.new$(toList([")", "]", "\n"])),
  );
  let refs = new Refs($dict.new$(), $dict.new$());
  let _block;
  let _pipe = djot;
  let _pipe$1 = $string.replace(_pipe, "\r\n", "\n");
  _block = parse_document_content(
    _pipe$1,
    refs,
    splitters,
    toList([]),
    $dict.new$(),
  );
  let $ = _block;
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

function parse_block_after_indent_checked(
  in$,
  refs,
  splitters,
  ast,
  attrs,
  required_spaces,
  indentation
) {
  let $ = parse_container(in$, refs, splitters, attrs, indentation);
  let in$1 = $[0];
  let refs$1 = $[1];
  let container = $[2];
  let attrs$1 = $[3];
  let _block;
  if (container instanceof Some) {
    let container$1 = container[0];
    _block = listPrepend(container$1, ast);
  } else {
    _block = ast;
  }
  let ast$1 = _block;
  if (in$1 === "") {
    return [$list.reverse(ast$1), refs$1, in$1];
  } else {
    return parse_block(in$1, refs$1, splitters, ast$1, attrs$1, required_spaces);
  }
}

function parse_list_item(
  loop$in,
  loop$refs,
  loop$attrs,
  loop$splitters,
  loop$children
) {
  while (true) {
    let in$ = loop$in;
    let refs = loop$refs;
    let attrs = loop$attrs;
    let splitters = loop$splitters;
    let children = loop$children;
    let $ = parse_container(in$, refs, splitters, attrs, 0);
    let in$1 = $[0];
    let refs$1 = $[1];
    let container = $[2];
    let attrs$1 = $[3];
    let _block;
    if (container instanceof Some) {
      let container$1 = container[0];
      _block = listPrepend(container$1, children);
    } else {
      _block = children;
    }
    let children$1 = _block;
    if (in$1 === "") {
      return $list.reverse(children$1);
    } else {
      loop$in = in$1;
      loop$refs = refs$1;
      loop$attrs = attrs$1;
      loop$splitters = splitters;
      loop$children = children$1;
    }
  }
}

function parse_bullet_list(
  loop$in,
  loop$refs,
  loop$attrs,
  loop$style,
  loop$layout,
  loop$items,
  loop$splitters
) {
  while (true) {
    let in$ = loop$in;
    let refs = loop$refs;
    let attrs = loop$attrs;
    let style = loop$style;
    let layout = loop$layout;
    let items = loop$items;
    let splitters = loop$splitters;
    let $ = take_list_item_chars(in$, "", style);
    let inline_in = $[0];
    let in$1 = $[1];
    let end = $[2];
    let item = parse_list_item(inline_in, refs, attrs, splitters, toList([]));
    let items$1 = listPrepend(item, items);
    if (end) {
      return [new BulletList(layout, style, $list.reverse(items$1)), in$1];
    } else {
      loop$in = in$1;
      loop$refs = refs;
      loop$attrs = attrs;
      loop$style = style;
      loop$layout = layout;
      loop$items = items$1;
      loop$splitters = splitters;
    }
  }
}

function parse_emphasis(in$, splitters, close) {
  let $ = take_emphasis_chars(in$, close, "");
  if ($ instanceof Some) {
    let inline_in = $[0][0];
    let in$1 = $[0][1];
    let $1 = parse_inline(inline_in, splitters, "", toList([]));
    let inline = $1[0];
    let inline_in_remaining = $1[1];
    return new Some([inline, inline_in_remaining + in$1]);
  } else {
    return new None();
  }
}

function parse_inline(loop$in, loop$splitters, loop$text, loop$acc) {
  while (true) {
    let in$ = loop$in;
    let splitters = loop$splitters;
    let text = loop$text;
    let acc = loop$acc;
    let $ = $splitter.split(splitters.inline, in$);
    let $1 = $[1];
    if ($1 === "") {
      let $2 = $[2];
      if ($2 === "") {
        let text2 = $[0];
        let $3 = text + text2;
        if ($3 === "") {
          return [$list.reverse(acc), ""];
        } else {
          let text$1 = $3;
          return [$list.reverse(listPrepend(new Text(text$1), acc)), ""];
        }
      } else {
        let text2 = $[0];
        let text3 = $1;
        let in$1 = $2;
        let $3 = (text + text2) + text3;
        if ($3 === "") {
          return [$list.reverse(acc), in$1];
        } else {
          let text$1 = $3;
          return [$list.reverse(listPrepend(new Text(text$1), acc)), in$1];
        }
      }
    } else if ($1 === "\\") {
      let a = $[0];
      let in$1 = $[2];
      let text$1 = text + a;
      if (in$1.startsWith("!")) {
        let e = "!";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("\"")) {
        let e = "\"";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("#")) {
        let e = "#";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("$")) {
        let e = "$";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("%")) {
        let e = "%";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("&")) {
        let e = "&";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("'")) {
        let e = "'";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("(")) {
        let e = "(";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith(")")) {
        let e = ")";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("*")) {
        let e = "*";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("+")) {
        let e = "+";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith(",")) {
        let e = ",";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("-")) {
        let e = "-";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith(".")) {
        let e = ".";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("/")) {
        let e = "/";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith(":")) {
        let e = ":";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith(";")) {
        let e = ";";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("<")) {
        let e = "<";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("=")) {
        let e = "=";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith(">")) {
        let e = ">";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("?")) {
        let e = "?";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("@")) {
        let e = "@";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("[")) {
        let e = "[";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("\\")) {
        let e = "\\";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("]")) {
        let e = "]";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("^")) {
        let e = "^";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("_")) {
        let e = "_";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("`")) {
        let e = "`";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("{")) {
        let e = "{";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("|")) {
        let e = "|";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("}")) {
        let e = "}";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("~")) {
        let e = "~";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = text$1 + e;
        loop$acc = acc;
      } else if (in$1.startsWith("\n")) {
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = "";
        loop$acc = listPrepend(
          new Linebreak(),
          listPrepend(new Text(text$1), acc),
        );
      } else if (in$1.startsWith(" ")) {
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = "";
        loop$acc = listPrepend(
          new NonBreakingSpace(),
          listPrepend(new Text(text$1), acc),
        );
      } else {
        loop$in = in$1;
        loop$splitters = splitters;
        loop$text = text$1 + "\\";
        loop$acc = acc;
      }
    } else if ($1 === "_") {
      let a = $[0];
      let start = $1;
      let in$1 = $[2];
      let text$1 = text + a;
      if (in$1.startsWith(" ")) {
        let b = " ";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = (text$1 + start) + b;
        loop$acc = acc;
      } else if (in$1.startsWith("\t")) {
        let b = "\t";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = (text$1 + start) + b;
        loop$acc = acc;
      } else if (in$1.startsWith("\n")) {
        let b = "\n";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = (text$1 + start) + b;
        loop$acc = acc;
      } else {
        let $2 = parse_emphasis(in$1, splitters, start);
        if ($2 instanceof Some) {
          let inner = $2[0][0];
          let in$2 = $2[0][1];
          let _block;
          if (start === "*") {
            _block = new Strong(inner);
          } else {
            _block = new Emphasis(inner);
          }
          let item = _block;
          loop$in = in$2;
          loop$splitters = splitters;
          loop$text = "";
          loop$acc = listPrepend(item, listPrepend(new Text(text$1), acc));
        } else {
          loop$in = in$1;
          loop$splitters = splitters;
          loop$text = text$1 + start;
          loop$acc = acc;
        }
      }
    } else if ($1 === "*") {
      let a = $[0];
      let start = $1;
      let in$1 = $[2];
      let text$1 = text + a;
      if (in$1.startsWith(" ")) {
        let b = " ";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = (text$1 + start) + b;
        loop$acc = acc;
      } else if (in$1.startsWith("\t")) {
        let b = "\t";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = (text$1 + start) + b;
        loop$acc = acc;
      } else if (in$1.startsWith("\n")) {
        let b = "\n";
        let in$2 = in$1.slice(1);
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = (text$1 + start) + b;
        loop$acc = acc;
      } else {
        let $2 = parse_emphasis(in$1, splitters, start);
        if ($2 instanceof Some) {
          let inner = $2[0][0];
          let in$2 = $2[0][1];
          let _block;
          if (start === "*") {
            _block = new Strong(inner);
          } else {
            _block = new Emphasis(inner);
          }
          let item = _block;
          loop$in = in$2;
          loop$splitters = splitters;
          loop$text = "";
          loop$acc = listPrepend(item, listPrepend(new Text(text$1), acc));
        } else {
          loop$in = in$1;
          loop$splitters = splitters;
          loop$text = text$1 + start;
          loop$acc = acc;
        }
      }
    } else if ($1 === "[^") {
      let a = $[0];
      let rest = $[2];
      let text$1 = text + a;
      let $2 = parse_footnote(rest, "^");
      if ($2 instanceof Some) {
        let $3 = $2[0][1];
        if ($3.startsWith(":")) {
          if (text$1 !== "") {
            return [$list.reverse(listPrepend(new Text(text$1), acc)), in$];
          } else {
            return [$list.reverse(acc), in$];
          }
        } else {
          let footnote = $2[0][0];
          let in$1 = $3;
          loop$in = in$1;
          loop$splitters = splitters;
          loop$text = "";
          loop$acc = listPrepend(footnote, listPrepend(new Text(text$1), acc));
        }
      } else {
        loop$in = rest;
        loop$splitters = splitters;
        loop$text = text$1 + "[^";
        loop$acc = acc;
      }
    } else if ($1 === "[") {
      let a = $[0];
      let in$1 = $[2];
      let text$1 = text + a;
      let $2 = parse_link(
        in$1,
        splitters,
        (var0, var1) => { return new Link(var0, var1); },
      );
      if ($2 instanceof Some) {
        let link = $2[0][0];
        let in$2 = $2[0][1];
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = "";
        loop$acc = listPrepend(link, listPrepend(new Text(text$1), acc));
      } else {
        loop$in = in$1;
        loop$splitters = splitters;
        loop$text = text$1 + "[";
        loop$acc = acc;
      }
    } else if ($1 === "![") {
      let a = $[0];
      let in$1 = $[2];
      let text$1 = text + a;
      let $2 = parse_link(
        in$1,
        splitters,
        (var0, var1) => { return new Image(var0, var1); },
      );
      if ($2 instanceof Some) {
        let image = $2[0][0];
        let in$2 = $2[0][1];
        loop$in = in$2;
        loop$splitters = splitters;
        loop$text = "";
        loop$acc = listPrepend(image, listPrepend(new Text(text$1), acc));
      } else {
        loop$in = in$1;
        loop$splitters = splitters;
        loop$text = text$1 + "![";
        loop$acc = acc;
      }
    } else if ($1 === "`") {
      let a = $[0];
      let in$1 = $[2];
      let text$1 = text + a;
      let $2 = parse_code(in$1, 1);
      let code = $2[0];
      let in$2 = $2[1];
      loop$in = in$2;
      loop$splitters = splitters;
      loop$text = "";
      loop$acc = listPrepend(code, listPrepend(new Text(text$1), acc));
    } else if ($1 === "\n") {
      let a = $[0];
      let in$1 = $[2];
      let text$1 = text + a;
      let _pipe = drop_spaces(in$1);
      loop$in = _pipe;
      loop$splitters = splitters;
      loop$text = text$1 + "\n";
      loop$acc = acc;
    } else {
      let text2 = $[0];
      let text3 = $1;
      let in$1 = $[2];
      let $2 = (text + text2) + text3;
      if ($2 === "") {
        return [$list.reverse(acc), in$1];
      } else {
        let text$1 = $2;
        return [$list.reverse(listPrepend(new Text(text$1), acc)), in$1];
      }
    }
  }
}

function parse_link(in$, splitters, to_inline) {
  let $ = take_link_chars(in$, "", splitters);
  if ($ instanceof Some) {
    let inline_in = $[0][0];
    let ref = $[0][1];
    let in$1 = $[0][2];
    let $1 = parse_inline(inline_in, splitters, "", toList([]));
    let inline = $1[0];
    let inline_in_remaining = $1[1];
    let _block;
    if (ref instanceof Reference) {
      let $2 = ref[0];
      if ($2 === "") {
        _block = new Reference(take_inline_text(inline, ""));
      } else {
        let ref$1 = ref;
        _block = ref$1;
      }
    } else {
      let ref$1 = ref;
      _block = ref$1;
    }
    let ref$1 = _block;
    return new Some([to_inline(inline, ref$1), inline_in_remaining + in$1]);
  } else {
    return new None();
  }
}

function parse_paragraph(in$, attrs, splitters) {
  let $ = take_paragraph_chars(in$);
  let inline_in = $[0];
  let in$1 = $[1];
  let $1 = parse_inline(inline_in, splitters, "", toList([]));
  let inline = $1[0];
  let inline_in_remaining = $1[1];
  return [new Paragraph(attrs, inline), inline_in_remaining + in$1];
}

function parse_heading(in$, refs, splitters, attrs) {
  let $ = heading_level(in$, 1);
  if ($ instanceof Some) {
    let level = $[0][0];
    let in$1 = $[0][1];
    let in$2 = drop_spaces(in$1);
    let $1 = take_heading_chars(in$2, level, "");
    let inline_in = $1[0];
    let in$3 = $1[1];
    let $2 = parse_inline(inline_in, splitters, "", toList([]));
    let inline = $2[0];
    let inline_in_remaining = $2[1];
    let text = take_inline_text(inline, "");
    let _block;
    let $4 = id_sanitise(text);
    if ($4 === "") {
      _block = [refs, attrs];
    } else {
      let id = $4;
      let $5 = $dict.get(refs.urls, id);
      if ($5 instanceof Ok) {
        _block = [refs, attrs];
      } else {
        let _block$1;
        let _record = refs;
        _block$1 = new Refs(
          $dict.insert(refs.urls, id, "#" + id),
          _record.footnotes,
        );
        let refs$1 = _block$1;
        let attrs$1 = add_attribute(attrs, "id", id);
        _block = [refs$1, attrs$1];
      }
    }
    let $3 = _block;
    let refs$1 = $3[0];
    let attrs$1 = $3[1];
    let heading = new Heading(attrs$1, level, inline);
    return [heading, refs$1, inline_in_remaining + in$3];
  } else {
    let $1 = parse_paragraph("#" + in$, attrs, splitters);
    let p = $1[0];
    let in$1 = $1[1];
    return [p, refs, in$1];
  }
}
