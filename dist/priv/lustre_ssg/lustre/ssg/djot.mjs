import * as $bool from "../../../gleam_stdlib/gleam/bool.mjs";
import * as $dict from "../../../gleam_stdlib/gleam/dict.mjs";
import * as $list from "../../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../../gleam_stdlib/gleam/option.mjs";
import * as $regex from "../../../gleam_stdlib/gleam/regex.mjs";
import { Match } from "../../../gleam_stdlib/gleam/regex.mjs";
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
  prepend as listPrepend,
  CustomType as $CustomType,
  makeError,
} from "../../gleam.mjs";

export class Renderer extends $CustomType {
  constructor(codeblock, emphasis, heading, link, paragraph, strong, text, code, image, linebreak) {
    super();
    this.codeblock = codeblock;
    this.emphasis = emphasis;
    this.heading = heading;
    this.link = link;
    this.paragraph = paragraph;
    this.strong = strong;
    this.text = text;
    this.code = code;
    this.image = image;
    this.linebreak = linebreak;
  }
}

export function frontmatter(document) {
  return $bool.guard(
    !$string.starts_with(document, "---"),
    new Error(undefined),
    () => {
      let options = new $regex.Options(false, true);
      let $ = $regex.compile("^---\\n[\\s\\S]*?\\n---", options);
      if (!$.isOk()) {
        throw makeError(
          "assignment_no_match",
          "lustre/ssg/djot",
          135,
          "",
          "Assignment pattern did not match",
          { value: $ }
        )
      }
      let re = $[0];
      let $1 = $regex.scan(re, document);
      if ($1.atLeastLength(1) && $1.head instanceof Match) {
        let frontmatter$1 = $1.head.content;
        return new Ok(
          (() => {
            let _pipe = frontmatter$1;
            let _pipe$1 = $string.drop_left(_pipe, 4);
            return $string.drop_right(_pipe$1, 4);
          })(),
        );
      } else {
        return new Error(undefined);
      }
    },
  );
}

export function metadata(document) {
  let $ = frontmatter(document);
  if ($.isOk()) {
    let frontmatter$1 = $[0];
    return $tom.parse(frontmatter$1);
  } else {
    return new Ok($dict.new$());
  }
}

export function content(document) {
  let toml = frontmatter(document);
  if (toml.isOk()) {
    let toml$1 = toml[0];
    return $string.replace(document, ("---\n" + toml$1) + "\n---", "");
  } else {
    return document;
  }
}

function linkify(text) {
  let $ = $regex.from_string(" +");
  if (!$.isOk()) {
    throw makeError(
      "assignment_no_match",
      "lustre/ssg/djot",
      284,
      "linkify",
      "Assignment pattern did not match",
      { value: $ }
    )
  }
  let re = $[0];
  let _pipe = text;
  let _pipe$1 = ((_capture) => { return $regex.split(re, _capture); })(_pipe);
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
            toList([$element.text(code)]),
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
        if ($.isOk()) {
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
    (content) => { return $html.strong(toList([]), content); },
    (text) => { return $element.text(text); },
    (content) => {
      return $html.code(toList([]), toList([$element.text(content)]));
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
    () => { return $html.br(toList([])); },
  );
}

function text_content(segments) {
  return $list.fold(
    segments,
    "",
    (text, inline) => {
      if (inline instanceof $jot.Text) {
        let content$1 = inline[0];
        return text + content$1;
      } else if (inline instanceof $jot.Link) {
        let content$1 = inline.content;
        return text + text_content(content$1);
      } else if (inline instanceof $jot.Emphasis) {
        let content$1 = inline.content;
        return text + text_content(content$1);
      } else if (inline instanceof $jot.Strong) {
        let content$1 = inline.content;
        return text + text_content(content$1);
      } else if (inline instanceof $jot.Code) {
        let content$1 = inline.content;
        return text + content$1;
      } else if (inline instanceof $jot.Image) {
        return text;
      } else {
        return text;
      }
    },
  );
}

function render_inline(inline, references, renderer) {
  if (inline instanceof $jot.Text) {
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
  } else if (inline instanceof $jot.Code) {
    let content$1 = inline.content;
    return renderer.code(content$1);
  } else if (inline instanceof $jot.Image) {
    let alt = inline.content;
    let destination = inline.destination;
    return renderer.image(destination, text_content(alt));
  } else {
    return renderer.linebreak();
  }
}

function render_block(block, references, renderer) {
  if (block instanceof $jot.Paragraph) {
    let attrs = block.attributes;
    let inline = block[1];
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
  } else {
    let attrs = block.attributes;
    let language = block.language;
    let code = block.content;
    return renderer.codeblock(attrs, language, code);
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
