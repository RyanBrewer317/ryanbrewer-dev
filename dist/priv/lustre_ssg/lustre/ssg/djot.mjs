import * as $regexp from "../../../gleam_regexp/gleam/regexp.mjs";
import { Match } from "../../../gleam_regexp/gleam/regexp.mjs";
import * as $bool from "../../../gleam_stdlib/gleam/bool.mjs";
import * as $dict from "../../../gleam_stdlib/gleam/dict.mjs";
import * as $list from "../../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../../gleam_stdlib/gleam/option.mjs";
import * as $result from "../../../gleam_stdlib/gleam/result.mjs";
import * as $string from "../../../gleam_stdlib/gleam/string.mjs";
import * as $jot from "../../../jot/jot.mjs";
import { Document } from "../../../jot/jot.mjs";
import * as $attribute from "../../../lustre/lustre/attribute.mjs";
import { attribute } from "../../../lustre/lustre/attribute.mjs";
import * as $element from "../../../lustre/lustre/element.mjs";
import * as $html from "../../../lustre/lustre/element/html.mjs";
import * as $tom from "../../../tom/tom.mjs";
import {
  Ok,
  Error,
  toList,
  Empty as $Empty,
  prepend as listPrepend,
  CustomType as $CustomType,
  makeError,
} from "../../gleam.mjs";

const FILEPATH = "src/lustre/ssg/djot.gleam";

export class Renderer extends $CustomType {
  constructor(codeblock, emphasis, heading, link, paragraph, bullet_list, raw_html, strong, text, code, image, linebreak, thematicbreak) {
    super();
    this.codeblock = codeblock;
    this.emphasis = emphasis;
    this.heading = heading;
    this.link = link;
    this.paragraph = paragraph;
    this.bullet_list = bullet_list;
    this.raw_html = raw_html;
    this.strong = strong;
    this.text = text;
    this.code = code;
    this.image = image;
    this.linebreak = linebreak;
    this.thematicbreak = thematicbreak;
  }
}

export function frontmatter(document) {
  return $bool.guard(
    !$string.starts_with(document, "---"),
    new Error(undefined),
    () => {
      let options = new $regexp.Options(false, true);
      let $ = $regexp.compile("^---\\n[\\s\\S]*?\\n---", options);
      if (!($ instanceof Ok)) {
        throw makeError(
          "let_assert",
          FILEPATH,
          "lustre/ssg/djot",
          158,
          "frontmatter",
          "Pattern match failed, no pattern matched the value.",
          {
            value: $,
            start: 5434,
            end: 5504,
            pattern_start: 5445,
            pattern_end: 5451
          }
        )
      }
      let re = $[0];
      let $1 = $regexp.scan(re, document);
      if ($1 instanceof $Empty) {
        return new Error(undefined);
      } else {
        let frontmatter$1 = $1.head.content;
        return new Ok(
          (() => {
            let _pipe = frontmatter$1;
            let _pipe$1 = $string.drop_start(_pipe, 4);
            return $string.drop_end(_pipe$1, 4);
          })(),
        );
      }
    },
  );
}

export function metadata(document) {
  let $ = frontmatter(document);
  if ($ instanceof Ok) {
    let frontmatter$1 = $[0];
    return $tom.parse(frontmatter$1);
  } else {
    return new Ok($dict.new$());
  }
}

export function content(document) {
  let toml = frontmatter(document);
  if (toml instanceof Ok) {
    let toml$1 = toml[0];
    return $string.replace(document, ("---\n" + toml$1) + "\n---", "");
  } else {
    return document;
  }
}

function linkify(text) {
  let $ = $regexp.from_string(" +");
  if (!($ instanceof Ok)) {
    throw makeError(
      "let_assert",
      FILEPATH,
      "lustre/ssg/djot",
      329,
      "linkify",
      "Pattern match failed, no pattern matched the value.",
      {
        value: $,
        start: 9886,
        end: 9930,
        pattern_start: 9897,
        pattern_end: 9903
      }
    )
  }
  let re = $[0];
  let _pipe = text;
  let _pipe$1 = ((_capture) => { return $regexp.split(re, _capture); })(_pipe);
  return $string.join(_pipe$1, "-");
}

export function default_renderer() {
  let to_attributes = (attrs) => {
    return $dict.fold(
      attrs,
      toList([]),
      (attrs, key, val) => { return listPrepend(attribute(key, val), attrs); },
    );
  };
  return new Renderer(
    (attrs, lang, code) => {
      let lang$1 = $option.unwrap(lang, "text");
      return $html.pre(
        to_attributes(attrs),
        toList([
          $html.code(
            toList([attribute("data-lang", lang$1)]),
            toList([$html.text(code)]),
          ),
        ]),
      );
    },
    (content) => { return $html.em(toList([]), content); },
    (attrs, level, content) => {
      if (level === 1) {
        return $html.h1(to_attributes(attrs), content);
      } else if (level === 2) {
        return $html.h2(to_attributes(attrs), content);
      } else if (level === 3) {
        return $html.h3(to_attributes(attrs), content);
      } else if (level === 4) {
        return $html.h4(to_attributes(attrs), content);
      } else if (level === 5) {
        return $html.h5(to_attributes(attrs), content);
      } else if (level === 6) {
        return $html.h6(to_attributes(attrs), content);
      } else {
        return $html.p(to_attributes(attrs), content);
      }
    },
    (destination, references, content) => {
      if (destination instanceof $jot.Reference) {
        let ref = destination[0];
        let $ = $dict.get(references, ref);
        if ($ instanceof Ok) {
          let url = $[0];
          return $html.a(toList([$attribute.href(url)]), content);
        } else {
          return $html.a(
            toList([
              $attribute.href("#" + linkify(ref)),
              $attribute.id(linkify("back-to-" + ref)),
            ]),
            content,
          );
        }
      } else {
        let url = destination[0];
        return $html.a(toList([attribute("href", url)]), content);
      }
    },
    (attrs, content) => { return $html.p(to_attributes(attrs), content); },
    (layout, style, items) => {
      let list_style_type = $attribute.style(
        "list-style-type",
        (() => {
          if (style === "-") {
            return "'-'";
          } else if (style === "*") {
            return "disc";
          } else {
            return "circle";
          }
        })(),
      );
      return $html.ul(
        toList([list_style_type]),
        $list.map(
          items,
          (item) => {
            if (layout instanceof $jot.Tight) {
              return $html.li(toList([]), item);
            } else {
              return $html.li(toList([]), toList([$html.p(toList([]), item)]));
            }
          },
        ),
      );
    },
    (content) => {
      return $element.unsafe_raw_html("", "div", toList([]), content);
    },
    (content) => { return $html.strong(toList([]), content); },
    (text) => { return $html.text(text); },
    (content) => {
      return $html.code(toList([]), toList([$html.text(content)]));
    },
    (destination, alt) => {
      if (destination instanceof $jot.Reference) {
        let ref = destination[0];
        return $html.img(
          toList([$attribute.src("#" + linkify(ref)), $attribute.alt(alt)]),
        );
      } else {
        let url = destination[0];
        return $html.img(toList([$attribute.src(url), $attribute.alt(alt)]));
      }
    },
    $html.br(toList([])),
    $html.hr(toList([])),
  );
}

function text_content(segments) {
  return $list.fold(
    segments,
    "",
    (text, inline) => {
      if (inline instanceof $jot.Linebreak) {
        return text;
      } else if (inline instanceof $jot.NonBreakingSpace) {
        return text + " ";
      } else if (inline instanceof $jot.Text) {
        let content$1 = inline[0];
        return text + content$1;
      } else if (inline instanceof $jot.Link) {
        let content$1 = inline.content;
        return text + text_content(content$1);
      } else if (inline instanceof $jot.Image) {
        return text;
      } else if (inline instanceof $jot.Emphasis) {
        let content$1 = inline.content;
        return text + text_content(content$1);
      } else if (inline instanceof $jot.Strong) {
        let content$1 = inline.content;
        return text + text_content(content$1);
      } else if (inline instanceof $jot.Footnote) {
        return text;
      } else {
        let content$1 = inline.content;
        return text + content$1;
      }
    },
  );
}

function render_inline(inline, references, renderer) {
  if (inline instanceof $jot.Linebreak) {
    return renderer.linebreak;
  } else if (inline instanceof $jot.NonBreakingSpace) {
    return renderer.text(" ");
  } else if (inline instanceof $jot.Text) {
    let text = inline[0];
    return renderer.text(text);
  } else if (inline instanceof $jot.Link) {
    let content$1 = inline.content;
    let destination = inline.destination;
    return renderer.link(
      destination,
      references,
      $list.map(
        content$1,
        (_capture) => { return render_inline(_capture, references, renderer); },
      ),
    );
  } else if (inline instanceof $jot.Image) {
    let content$1 = inline.content;
    let destination = inline.destination;
    return renderer.image(destination, text_content(content$1));
  } else if (inline instanceof $jot.Emphasis) {
    let content$1 = inline.content;
    return renderer.emphasis(
      $list.map(
        content$1,
        (_capture) => { return render_inline(_capture, references, renderer); },
      ),
    );
  } else if (inline instanceof $jot.Strong) {
    let content$1 = inline.content;
    return renderer.strong(
      $list.map(
        content$1,
        (_capture) => { return render_inline(_capture, references, renderer); },
      ),
    );
  } else if (inline instanceof $jot.Footnote) {
    return renderer.text("");
  } else {
    let content$1 = inline.content;
    return renderer.code(content$1);
  }
}

function render_block(block, references, renderer) {
  if (block instanceof $jot.ThematicBreak) {
    return renderer.thematicbreak;
  } else if (block instanceof $jot.Paragraph) {
    let attrs = block.attributes;
    let inline = block.content;
    return renderer.paragraph(
      attrs,
      $list.map(
        inline,
        (_capture) => { return render_inline(_capture, references, renderer); },
      ),
    );
  } else if (block instanceof $jot.Heading) {
    let attrs = block.attributes;
    let level = block.level;
    let inline = block.content;
    return renderer.heading(
      attrs,
      level,
      $list.map(
        inline,
        (_capture) => { return render_inline(_capture, references, renderer); },
      ),
    );
  } else if (block instanceof $jot.Codeblock) {
    let attrs = block.attributes;
    let language = block.language;
    let code = block.content;
    return renderer.codeblock(attrs, language, code);
  } else if (block instanceof $jot.RawBlock) {
    let content$1 = block.content;
    return renderer.raw_html(content$1);
  } else {
    let layout = block.layout;
    let style = block.style;
    let items = block.items;
    return renderer.bullet_list(
      layout,
      style,
      $list.map(
        items,
        (_capture) => {
          return $list.map(
            _capture,
            (_capture) => {
              return render_block(_capture, references, renderer);
            },
          );
        },
      ),
    );
  }
}

export function render(document, renderer) {
  let content$1 = content(document);
  let $ = $jot.parse(content$1);
  let content$2 = $.content;
  let references = $.references;
  let _pipe = content$2;
  return $list.map(
    _pipe,
    (_capture) => { return render_block(_capture, references, renderer); },
  );
}

export function render_with_metadata(document, renderer) {
  let toml = frontmatter(document);
  return $result.try$(
    (() => {
      let _pipe = toml;
      let _pipe$1 = $result.unwrap(_pipe, "");
      return $tom.parse(_pipe$1);
    })(),
    (metadata) => {
      let content$1 = content(document);
      let renderer$1 = renderer(metadata);
      let $ = $jot.parse(content$1);
      let content$2 = $.content;
      let references = $.references;
      let _pipe = content$2;
      let _pipe$1 = $list.map(
        _pipe,
        (_capture) => { return render_block(_capture, references, renderer$1); },
      );
      return new Ok(_pipe$1);
    },
  );
}
