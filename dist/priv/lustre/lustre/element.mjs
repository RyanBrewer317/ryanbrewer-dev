import * as $dynamic from "../../gleam_stdlib/gleam/dynamic.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $string from "../../gleam_stdlib/gleam/string.mjs";
import * as $string_tree from "../../gleam_stdlib/gleam/string_tree.mjs";
import { toList } from "../gleam.mjs";
import * as $attribute from "../lustre/attribute.mjs";
import { attribute } from "../lustre/attribute.mjs";
import * as $effect from "../lustre/effect.mjs";
import * as $vdom from "../lustre/internals/vdom.mjs";
import { Element, Map, Text } from "../lustre/internals/vdom.mjs";

export function element(tag, attrs, children) {
  if (tag === "area") {
    return new Element("", "", tag, attrs, toList([]), false, true);
  } else if (tag === "base") {
    return new Element("", "", tag, attrs, toList([]), false, true);
  } else if (tag === "br") {
    return new Element("", "", tag, attrs, toList([]), false, true);
  } else if (tag === "col") {
    return new Element("", "", tag, attrs, toList([]), false, true);
  } else if (tag === "embed") {
    return new Element("", "", tag, attrs, toList([]), false, true);
  } else if (tag === "hr") {
    return new Element("", "", tag, attrs, toList([]), false, true);
  } else if (tag === "img") {
    return new Element("", "", tag, attrs, toList([]), false, true);
  } else if (tag === "input") {
    return new Element("", "", tag, attrs, toList([]), false, true);
  } else if (tag === "link") {
    return new Element("", "", tag, attrs, toList([]), false, true);
  } else if (tag === "meta") {
    return new Element("", "", tag, attrs, toList([]), false, true);
  } else if (tag === "param") {
    return new Element("", "", tag, attrs, toList([]), false, true);
  } else if (tag === "source") {
    return new Element("", "", tag, attrs, toList([]), false, true);
  } else if (tag === "track") {
    return new Element("", "", tag, attrs, toList([]), false, true);
  } else if (tag === "wbr") {
    return new Element("", "", tag, attrs, toList([]), false, true);
  } else {
    return new Element("", "", tag, attrs, children, false, false);
  }
}

function do_keyed(el, key) {
  if (el instanceof Element) {
    let namespace = el.namespace;
    let tag = el.tag;
    let attrs = el.attrs;
    let children = el.children;
    let self_closing = el.self_closing;
    let void$ = el.void;
    return new Element(
      key,
      namespace,
      tag,
      attrs,
      children,
      self_closing,
      void$,
    );
  } else if (el instanceof Map) {
    let subtree = el.subtree;
    return new Map(() => { return do_keyed(subtree(), key); });
  } else {
    return el;
  }
}

export function keyed(el, children) {
  return el(
    $list.map(
      children,
      (_use0) => {
        let key = _use0[0];
        let child = _use0[1];
        return do_keyed(child, key);
      },
    ),
  );
}

export function namespaced(namespace, tag, attrs, children) {
  return new Element("", namespace, tag, attrs, children, false, false);
}

export function advanced(namespace, tag, attrs, children, self_closing, void$) {
  return new Element("", namespace, tag, attrs, children, self_closing, void$);
}

export function text(content) {
  return new Text(content);
}

export function none() {
  return new Text("");
}

export function fragment(elements) {
  return element(
    "lustre-fragment",
    toList([$attribute.style(toList([["display", "contents"]]))]),
    elements,
  );
}

export function map(element, f) {
  if (element instanceof Text) {
    let content = element.content;
    return new Text(content);
  } else if (element instanceof Map) {
    let subtree = element.subtree;
    return new Map(() => { return map(subtree(), f); });
  } else {
    let key = element.key;
    let namespace = element.namespace;
    let tag = element.tag;
    let attrs = element.attrs;
    let children = element.children;
    let self_closing = element.self_closing;
    let void$ = element.void;
    return new Map(
      () => {
        return new Element(
          key,
          namespace,
          tag,
          $list.map(
            attrs,
            (_capture) => { return $attribute.map(_capture, f); },
          ),
          $list.map(children, (_capture) => { return map(_capture, f); }),
          self_closing,
          void$,
        );
      },
    );
  }
}

export function get_root(effect) {
  return $effect.custom(
    (dispatch, _, _1, root) => { return effect(dispatch, root); },
  );
}

export function to_string(element) {
  return $vdom.element_to_string(element);
}

export function to_document_string(el) {
  let _pipe = $vdom.element_to_string(
    (() => {
      if (el instanceof Element && el.tag === "html") {
        return el;
      } else if (el instanceof Element && el.tag === "head") {
        return element("html", toList([]), toList([el]));
      } else if (el instanceof Element && el.tag === "body") {
        return element("html", toList([]), toList([el]));
      } else if (el instanceof Map) {
        let subtree = el.subtree;
        return subtree();
      } else {
        return element(
          "html",
          toList([]),
          toList([element("body", toList([]), toList([el]))]),
        );
      }
    })(),
  );
  return ((_capture) => { return $string.append("<!doctype html>\n", _capture); })(
    _pipe,
  );
}

export function to_string_builder(element) {
  return $vdom.element_to_string_builder(element);
}

export function to_document_string_builder(el) {
  let _pipe = $vdom.element_to_string_builder(
    (() => {
      if (el instanceof Element && el.tag === "html") {
        return el;
      } else if (el instanceof Element && el.tag === "head") {
        return element("html", toList([]), toList([el]));
      } else if (el instanceof Element && el.tag === "body") {
        return element("html", toList([]), toList([el]));
      } else if (el instanceof Map) {
        let subtree = el.subtree;
        return subtree();
      } else {
        return element(
          "html",
          toList([]),
          toList([element("body", toList([]), toList([el]))]),
        );
      }
    })(),
  );
  return $string_tree.prepend(_pipe, "<!doctype html>\n");
}

export function to_readable_string(el) {
  return $vdom.element_to_snapshot(el);
}
