import * as $list from "../../../gleam_stdlib/gleam/list.mjs";
import * as $order from "../../../gleam_stdlib/gleam/order.mjs";
import * as $string from "../../../gleam_stdlib/gleam/string.mjs";
import {
  Ok,
  Error,
  toList,
  Empty as $Empty,
  prepend as listPrepend,
  CustomType as $CustomType,
  makeError,
} from "../../gleam.mjs";
import * as $attribute from "../../lustre/attribute.mjs";
import * as $element from "../../lustre/element.mjs";
import * as $path from "../../lustre/vdom/path.mjs";
import * as $vattr from "../../lustre/vdom/vattr.mjs";
import { Attribute } from "../../lustre/vdom/vattr.mjs";
import * as $vnode from "../../lustre/vdom/vnode.mjs";
import { Element, Fragment, Text, UnsafeInnerHtml } from "../../lustre/vdom/vnode.mjs";

const FILEPATH = "src/lustre/dev/query.gleam";

class FindElement extends $CustomType {
  constructor(matching) {
    super();
    this.matching = matching;
  }
}

class FindChild extends $CustomType {
  constructor(of, matching) {
    super();
    this.of = of;
    this.matching = matching;
  }
}

class FindDescendant extends $CustomType {
  constructor(of, matching) {
    super();
    this.of = of;
    this.matching = matching;
  }
}

class All extends $CustomType {
  constructor(of) {
    super();
    this.of = of;
  }
}

class Type extends $CustomType {
  constructor(namespace, tag) {
    super();
    this.namespace = namespace;
    this.tag = tag;
  }
}

class HasAttribute extends $CustomType {
  constructor(name, value) {
    super();
    this.name = name;
    this.value = value;
  }
}

class HasClass extends $CustomType {
  constructor(name) {
    super();
    this.name = name;
  }
}

class HasStyle extends $CustomType {
  constructor(name, value) {
    super();
    this.name = name;
    this.value = value;
  }
}

class Contains extends $CustomType {
  constructor(content) {
    super();
    this.content = content;
  }
}

export function element(selector) {
  return new FindElement(selector);
}

export function child(parent, selector) {
  return new FindChild(parent, selector);
}

export function descendant(parent, selector) {
  return new FindDescendant(parent, selector);
}

export function and(first, second) {
  if (first instanceof All) {
    let $ = first.of;
    if ($ instanceof $Empty) {
      return new All(toList([second]));
    } else {
      let others = $;
      return new All(listPrepend(second, others));
    }
  } else {
    return new All(toList([first, second]));
  }
}

export function tag(value) {
  return new Type("", value);
}

export function namespaced(namespace, tag) {
  return new Type(namespace, tag);
}

export function attribute(name, value) {
  return new HasAttribute(name, value);
}

export function class$(name) {
  return new HasClass(name);
}

export function style(name, value) {
  return new HasStyle(name, value);
}

export function id(name) {
  return new HasAttribute("id", name);
}

export function data(name, value) {
  return new HasAttribute("data-" + name, value);
}

export function test_id(value) {
  return data("test-id", value);
}

export function aria(name, value) {
  return new HasAttribute("aria-" + name, value);
}

export function text(content) {
  return new Contains(content);
}

function text_content(element, inline, content) {
  if (element instanceof Fragment) {
    return $list.fold(
      element.children,
      content,
      (content, child) => { return text_content(child, true, content); },
    );
  } else if (element instanceof Element) {
    if (!inline || (element.namespace !== "")) {
      return $list.fold(
        element.children,
        content,
        (content, child) => { return text_content(child, true, content); },
      );
    } else {
      let $ = element.tag;
      if ($ === "a") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "abbr") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "acronym") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "b") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "bdo") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "big") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "br") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "button") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "cite") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "code") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "dfn") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "em") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "i") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "img") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "input") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "kbd") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "label") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "map") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "object") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "output") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "q") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "samp") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "script") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "select") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "small") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "span") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "strong") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "sub") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "sup") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "textarea") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "time") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "tt") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else if ($ === "var") {
        return $list.fold(
          element.children,
          content,
          (content, child) => { return text_content(child, true, content); },
        );
      } else {
        let rule = "display:inline";
        let is_inline = $list.any(
          element.attributes,
          (attribute) => {
            if (attribute instanceof Attribute) {
              let $1 = attribute.name;
              if ($1 === "style") {
                let value = attribute.value;
                return $string.contains(value, rule);
              } else {
                return false;
              }
            } else {
              return false;
            }
          },
        );
        if (is_inline) {
          return $list.fold(
            element.children,
            content,
            (content, child) => { return text_content(child, true, content); },
          );
        } else {
          return content;
        }
      }
    }
  } else if (element instanceof Text) {
    return content + element.content;
  } else {
    return content;
  }
}

export function matches(element, selector) {
  if (selector instanceof All) {
    let selectors = selector.of;
    return $list.all(
      selectors,
      (_capture) => { return matches(element, _capture); },
    );
  } else if (selector instanceof Type) {
    if (element instanceof Element) {
      let namespace = element.namespace;
      let tag$1 = element.tag;
      return (namespace === selector.namespace) && (tag$1 === selector.tag);
    } else if (element instanceof UnsafeInnerHtml) {
      let namespace = element.namespace;
      let tag$1 = element.tag;
      return (namespace === selector.namespace) && (tag$1 === selector.tag);
    } else {
      return false;
    }
  } else if (selector instanceof HasAttribute) {
    if (element instanceof Element) {
      let $ = selector.value;
      if ($ === "") {
        let name = selector.name;
        let attributes = element.attributes;
        return $list.any(
          attributes,
          (attribute) => {
            if (attribute instanceof Attribute) {
              return attribute.name === name;
            } else {
              return false;
            }
          },
        );
      } else {
        let name = selector.name;
        let value = $;
        let attributes = element.attributes;
        return $list.contains(attributes, $attribute.attribute(name, value));
      }
    } else if (element instanceof UnsafeInnerHtml) {
      let $ = selector.value;
      if ($ === "") {
        let name = selector.name;
        let attributes = element.attributes;
        return $list.any(
          attributes,
          (attribute) => {
            if (attribute instanceof Attribute) {
              return attribute.name === name;
            } else {
              return false;
            }
          },
        );
      } else {
        let name = selector.name;
        let value = $;
        let attributes = element.attributes;
        return $list.contains(attributes, $attribute.attribute(name, value));
      }
    } else {
      return false;
    }
  } else if (selector instanceof HasClass) {
    if (element instanceof Element) {
      let name = selector.name;
      let attributes = element.attributes;
      return $list.fold_until(
        $string.split(name, " "),
        true,
        (_, class$) => {
          let name$1 = $string.trim_end(class$);
          let matches$1 = $list.any(
            attributes,
            (attribute) => {
              if (attribute instanceof Attribute) {
                let $ = attribute.name;
                if ($ === "class") {
                  let value = attribute.value;
                  return (((value === name$1) || $string.starts_with(
                    value,
                    name$1 + " ",
                  )) || $string.ends_with(value, " " + name$1)) || $string.contains(
                    value,
                    (" " + name$1) + " ",
                  );
                } else {
                  return false;
                }
              } else {
                return false;
              }
            },
          );
          if (matches$1) {
            return new $list.Continue(true);
          } else {
            return new $list.Stop(false);
          }
        },
      );
    } else if (element instanceof UnsafeInnerHtml) {
      let name = selector.name;
      let attributes = element.attributes;
      return $list.fold_until(
        $string.split(name, " "),
        true,
        (_, class$) => {
          let name$1 = $string.trim_end(class$);
          let matches$1 = $list.any(
            attributes,
            (attribute) => {
              if (attribute instanceof Attribute) {
                let $ = attribute.name;
                if ($ === "class") {
                  let value = attribute.value;
                  return (((value === name$1) || $string.starts_with(
                    value,
                    name$1 + " ",
                  )) || $string.ends_with(value, " " + name$1)) || $string.contains(
                    value,
                    (" " + name$1) + " ",
                  );
                } else {
                  return false;
                }
              } else {
                return false;
              }
            },
          );
          if (matches$1) {
            return new $list.Continue(true);
          } else {
            return new $list.Stop(false);
          }
        },
      );
    } else {
      return false;
    }
  } else if (selector instanceof HasStyle) {
    if (element instanceof Element) {
      let name = selector.name;
      let value = selector.value;
      let attributes = element.attributes;
      let rule = ((name + ":") + value) + ";";
      return $list.any(
        attributes,
        (attribute) => {
          if (attribute instanceof Attribute) {
            let $ = attribute.name;
            if ($ === "style") {
              let value$1 = attribute.value;
              return $string.contains(value$1, rule);
            } else {
              return false;
            }
          } else {
            return false;
          }
        },
      );
    } else if (element instanceof UnsafeInnerHtml) {
      let name = selector.name;
      let value = selector.value;
      let attributes = element.attributes;
      let rule = ((name + ":") + value) + ";";
      return $list.any(
        attributes,
        (attribute) => {
          if (attribute instanceof Attribute) {
            let $ = attribute.name;
            if ($ === "style") {
              let value$1 = attribute.value;
              return $string.contains(value$1, rule);
            } else {
              return false;
            }
          } else {
            return false;
          }
        },
      );
    } else {
      return false;
    }
  } else if (element instanceof Element) {
    let content = selector.content;
    let _pipe = element;
    let _pipe$1 = text_content(_pipe, false, "");
    return $string.contains(_pipe$1, content);
  } else {
    return false;
  }
}

function find_matching_in_list(
  loop$elements,
  loop$selector,
  loop$path,
  loop$index
) {
  while (true) {
    let elements = loop$elements;
    let selector = loop$selector;
    let path = loop$path;
    let index = loop$index;
    if (elements instanceof $Empty) {
      return new Error(undefined);
    } else {
      let $ = elements.head;
      if ($ instanceof Fragment) {
        let first = $;
        let rest = elements.tail;
        loop$elements = $list.append(first.children, rest);
        loop$selector = selector;
        loop$path = path;
        loop$index = index + 1;
      } else {
        let first = $;
        let rest = elements.tail;
        let $1 = matches(first, selector);
        if ($1) {
          return new Ok([first, $path.add(path, index, first.key)]);
        } else {
          loop$elements = rest;
          loop$selector = selector;
          loop$path = path;
          loop$index = index + 1;
        }
      }
    }
  }
}

function find_direct_child(parent, selector, path) {
  if (parent instanceof Fragment) {
    let children = parent.children;
    return find_matching_in_list(children, selector, path, 1);
  } else if (parent instanceof Element) {
    let children = parent.children;
    return find_matching_in_list(children, selector, path, 0);
  } else if (parent instanceof Text) {
    return new Error(undefined);
  } else {
    return new Error(undefined);
  }
}

function find_all_matching_in_list(loop$elements, loop$selector) {
  while (true) {
    let elements = loop$elements;
    let selector = loop$selector;
    if (elements instanceof $Empty) {
      return toList([]);
    } else {
      let first = elements.head;
      let rest = elements.tail;
      let $ = matches(first, selector);
      if ($) {
        return listPrepend(first, find_all_matching_in_list(rest, selector));
      } else {
        loop$elements = rest;
        loop$selector = selector;
      }
    }
  }
}

function find_all_direct_children(parent, selector) {
  if (parent instanceof Fragment) {
    let children = parent.children;
    return find_all_matching_in_list(children, selector);
  } else if (parent instanceof Element) {
    let children = parent.children;
    return find_all_matching_in_list(children, selector);
  } else if (parent instanceof Text) {
    return toList([]);
  } else {
    return toList([]);
  }
}

function sort_selectors(selectors) {
  return $list.sort(
    $list.flat_map(
      selectors,
      (selector) => {
        if (selector instanceof All) {
          let selectors$1 = selector.of;
          return selectors$1;
        } else {
          return toList([selector]);
        }
      },
    ),
    (a, b) => {
      if (a instanceof All) {
        throw makeError(
          "panic",
          FILEPATH,
          "lustre/dev/query",
          764,
          "sort_selectors",
          "`All` selectors should be flattened",
          {}
        )
      } else if (a instanceof Type) {
        if (b instanceof All) {
          throw makeError(
            "panic",
            FILEPATH,
            "lustre/dev/query",
            764,
            "sort_selectors",
            "`All` selectors should be flattened",
            {}
          )
        } else if (b instanceof Type) {
          let $ = $string.compare(a.namespace, b.namespace);
          if ($ instanceof $order.Eq) {
            return $string.compare(a.tag, b.tag);
          } else {
            let order = $;
            return order;
          }
        } else if (b instanceof HasAttribute) {
          return new $order.Lt();
        } else if (b instanceof HasClass) {
          return new $order.Lt();
        } else if (b instanceof HasStyle) {
          return new $order.Lt();
        } else {
          return new $order.Lt();
        }
      } else if (a instanceof HasAttribute) {
        if (b instanceof All) {
          throw makeError(
            "panic",
            FILEPATH,
            "lustre/dev/query",
            764,
            "sort_selectors",
            "`All` selectors should be flattened",
            {}
          )
        } else if (b instanceof Type) {
          return new $order.Gt();
        } else if (b instanceof HasAttribute) {
          let $ = b.name;
          if ($ === "id") {
            let $1 = a.name;
            if ($1 === "id") {
              return $string.compare(a.value, b.value);
            } else {
              return new $order.Gt();
            }
          } else {
            let $1 = a.name;
            if ($1 === "id") {
              return new $order.Lt();
            } else {
              let $2 = $string.compare(a.name, b.name);
              if ($2 instanceof $order.Eq) {
                return $string.compare(a.value, b.value);
              } else {
                let order = $2;
                return order;
              }
            }
          }
        } else if (b instanceof HasClass) {
          let $ = a.name;
          if ($ === "id") {
            return new $order.Lt();
          } else {
            return new $order.Lt();
          }
        } else if (b instanceof HasStyle) {
          let $ = a.name;
          if ($ === "id") {
            return new $order.Lt();
          } else {
            return new $order.Lt();
          }
        } else {
          let $ = a.name;
          if ($ === "id") {
            return new $order.Lt();
          } else {
            return new $order.Lt();
          }
        }
      } else if (a instanceof HasClass) {
        if (b instanceof All) {
          throw makeError(
            "panic",
            FILEPATH,
            "lustre/dev/query",
            764,
            "sort_selectors",
            "`All` selectors should be flattened",
            {}
          )
        } else if (b instanceof Type) {
          return new $order.Gt();
        } else if (b instanceof HasAttribute) {
          let $ = b.name;
          if ($ === "id") {
            return new $order.Gt();
          } else {
            return new $order.Gt();
          }
        } else if (b instanceof HasClass) {
          return $string.compare(a.name, b.name);
        } else if (b instanceof HasStyle) {
          return new $order.Gt();
        } else {
          return new $order.Lt();
        }
      } else if (a instanceof HasStyle) {
        if (b instanceof All) {
          throw makeError(
            "panic",
            FILEPATH,
            "lustre/dev/query",
            764,
            "sort_selectors",
            "`All` selectors should be flattened",
            {}
          )
        } else if (b instanceof Type) {
          return new $order.Gt();
        } else if (b instanceof HasAttribute) {
          let $ = b.name;
          if ($ === "id") {
            return new $order.Gt();
          } else {
            return new $order.Gt();
          }
        } else if (b instanceof HasClass) {
          return new $order.Lt();
        } else if (b instanceof HasStyle) {
          return $string.compare(a.name, b.name);
        } else {
          return new $order.Lt();
        }
      } else if (b instanceof All) {
        throw makeError(
          "panic",
          FILEPATH,
          "lustre/dev/query",
          764,
          "sort_selectors",
          "`All` selectors should be flattened",
          {}
        )
      } else if (b instanceof Type) {
        return new $order.Gt();
      } else if (b instanceof HasAttribute) {
        let $ = b.name;
        if ($ === "id") {
          return new $order.Gt();
        } else {
          return new $order.Gt();
        }
      } else if (b instanceof HasClass) {
        return new $order.Gt();
      } else if (b instanceof HasStyle) {
        return new $order.Gt();
      } else {
        return $string.compare(a.content, b.content);
      }
    },
  );
}

function selector_to_readable_string(selector) {
  if (selector instanceof All) {
    let $ = selector.of;
    if ($ instanceof $Empty) {
      return "";
    } else {
      let selectors = $;
      let _pipe = selectors;
      let _pipe$1 = sort_selectors(_pipe);
      let _pipe$2 = $list.map(_pipe$1, selector_to_readable_string);
      return $string.concat(_pipe$2);
    }
  } else if (selector instanceof Type) {
    let $ = selector.namespace;
    if ($ === "") {
      let $1 = selector.tag;
      if ($1 === "") {
        return "";
      } else {
        let tag$1 = $1;
        return tag$1;
      }
    } else {
      let namespace = $;
      let tag$1 = selector.tag;
      return (namespace + ":") + tag$1;
    }
  } else if (selector instanceof HasAttribute) {
    let $ = selector.name;
    if ($ === "") {
      return "";
    } else if ($ === "id") {
      let value = selector.value;
      return "#" + value;
    } else {
      let $1 = selector.value;
      if ($1 === "") {
        let name = $;
        return ("[" + name) + "]";
      } else {
        let name = $;
        let value = $1;
        return ((("[" + name) + "=\"") + value) + "\"]";
      }
    }
  } else if (selector instanceof HasClass) {
    let $ = selector.name;
    if ($ === "") {
      return "";
    } else {
      let name = $;
      return "." + name;
    }
  } else if (selector instanceof HasStyle) {
    let $ = selector.name;
    if ($ === "") {
      return "";
    } else {
      let $1 = selector.value;
      if ($1 === "") {
        return "";
      } else {
        let name = $;
        let value = $1;
        return ((("[style*=\"" + name) + ":") + value) + "\"]";
      }
    }
  } else {
    let $ = selector.content;
    if ($ === "") {
      return "";
    } else {
      let content = $;
      return (":contains(\"" + content) + "\")";
    }
  }
}

export function to_readable_string(query) {
  if (query instanceof FindElement) {
    let selector = query.matching;
    return selector_to_readable_string(selector);
  } else if (query instanceof FindChild) {
    let parent = query.of;
    let selector = query.matching;
    return (to_readable_string(parent) + " > ") + selector_to_readable_string(
      selector,
    );
  } else {
    let parent = query.of;
    let selector = query.matching;
    return (to_readable_string(parent) + " ") + selector_to_readable_string(
      selector,
    );
  }
}

function find_all_in_list(elements, query) {
  if (elements instanceof $Empty) {
    return toList([]);
  } else {
    let first = elements.head;
    let rest = elements.tail;
    let first_matches = find_all(first, query);
    let rest_matches = find_all_in_list(rest, query);
    return $list.append(first_matches, rest_matches);
  }
}

export function find_all(root, query) {
  if (query instanceof FindElement) {
    let selector = query.matching;
    let $ = matches(root, selector);
    if ($) {
      return listPrepend(root, find_all_in_children(root, query));
    } else {
      return find_all_in_children(root, query);
    }
  } else if (query instanceof FindChild) {
    let parent = query.of;
    let selector = query.matching;
    let _pipe = root;
    let _pipe$1 = find_all(_pipe, parent);
    return $list.flat_map(
      _pipe$1,
      (_capture) => { return find_all_direct_children(_capture, selector); },
    );
  } else {
    let parent = query.of;
    let selector = query.matching;
    let _pipe = root;
    let _pipe$1 = find_all(_pipe, parent);
    return $list.flat_map(
      _pipe$1,
      (_capture) => { return find_all_descendants(_capture, selector); },
    );
  }
}

function find_all_in_children(element, query) {
  if (element instanceof Fragment) {
    let children = element.children;
    return find_all_in_list(children, query);
  } else if (element instanceof Element) {
    let children = element.children;
    return find_all_in_list(children, query);
  } else if (element instanceof Text) {
    return toList([]);
  } else {
    return toList([]);
  }
}

function find_all_descendants_in_list(elements, selector) {
  if (elements instanceof $Empty) {
    return toList([]);
  } else {
    let first = elements.head;
    let rest = elements.tail;
    let first_matches = find_all_descendants(first, selector);
    let rest_matches = find_all_descendants_in_list(rest, selector);
    return $list.append(first_matches, rest_matches);
  }
}

function find_all_descendants(parent, selector) {
  let direct_matches = find_all_direct_children(parent, selector);
  let _block;
  if (parent instanceof Fragment) {
    let children = parent.children;
    _block = find_all_descendants_in_list(children, selector);
  } else if (parent instanceof Element) {
    let children = parent.children;
    _block = find_all_descendants_in_list(children, selector);
  } else if (parent instanceof Text) {
    _block = toList([]);
  } else {
    _block = toList([]);
  }
  let descendant_matches = _block;
  return $list.append(direct_matches, descendant_matches);
}

function find_in_list(loop$elements, loop$query, loop$path, loop$index) {
  while (true) {
    let elements = loop$elements;
    let query = loop$query;
    let path = loop$path;
    let index = loop$index;
    if (elements instanceof $Empty) {
      return new Error(undefined);
    } else {
      let $ = elements.head;
      if ($ instanceof Fragment) {
        let first = $;
        let rest = elements.tail;
        loop$elements = $list.append(first.children, rest);
        loop$query = query;
        loop$path = path;
        loop$index = index + 1;
      } else {
        let first = $;
        let rest = elements.tail;
        let $1 = find_path(first, query, index, path);
        if ($1 instanceof Ok) {
          let element$1 = $1[0];
          return new Ok(element$1);
        } else {
          loop$elements = rest;
          loop$query = query;
          loop$path = path;
          loop$index = index + 1;
        }
      }
    }
  }
}

export function find_path(root, query, index, path) {
  if (query instanceof FindElement) {
    let selector = query.matching;
    let $ = matches(root, selector);
    if ($) {
      return new Ok(
        [
          root,
          (() => {
            let _pipe = path;
            return $path.add(_pipe, index, root.key);
          })(),
        ],
      );
    } else {
      return find_in_children(root, query, index, path);
    }
  } else if (query instanceof FindChild) {
    let parent = query.of;
    let selector = query.matching;
    let $ = find_path(root, parent, index, path);
    if ($ instanceof Ok) {
      let element$1 = $[0][0];
      let path$1 = $[0][1];
      return find_direct_child(element$1, selector, path$1);
    } else {
      return new Error(undefined);
    }
  } else {
    let parent = query.of;
    let selector = query.matching;
    let $ = find_path(root, parent, index, path);
    if ($ instanceof Ok) {
      let element$1 = $[0][0];
      let path$1 = $[0][1];
      return find_descendant(element$1, selector, path$1);
    } else {
      return new Error(undefined);
    }
  }
}

function find_in_children(element, query, index, path) {
  if (element instanceof Fragment) {
    let children = element.children;
    return find_in_list(children, query, path, index + 1);
  } else if (element instanceof Element) {
    let children = element.children;
    return find_in_list(
      children,
      query,
      (() => {
        let _pipe = path;
        return $path.add(_pipe, index, element.key);
      })(),
      0,
    );
  } else if (element instanceof Text) {
    return new Error(undefined);
  } else {
    return new Error(undefined);
  }
}

export function find(root, query) {
  let $ = find_path(root, query, 0, $path.root);
  if ($ instanceof Ok) {
    let element$1 = $[0][0];
    return new Ok(element$1);
  } else {
    return new Error(undefined);
  }
}

export function has(element, selector) {
  let $ = find(element, new FindElement(selector));
  if ($ instanceof Ok) {
    return true;
  } else {
    return false;
  }
}

function find_descendant_in_list(
  loop$elements,
  loop$selector,
  loop$path,
  loop$index
) {
  while (true) {
    let elements = loop$elements;
    let selector = loop$selector;
    let path = loop$path;
    let index = loop$index;
    if (elements instanceof $Empty) {
      return new Error(undefined);
    } else {
      let first = elements.head;
      let rest = elements.tail;
      let $ = matches(first, selector);
      if ($) {
        return new Ok([first, $path.add(path, index, first.key)]);
      } else {
        let child$1 = $path.add(path, index, first.key);
        let $1 = find_descendant(first, selector, child$1);
        if ($1 instanceof Ok) {
          let element$1 = $1[0];
          return new Ok(element$1);
        } else {
          loop$elements = rest;
          loop$selector = selector;
          loop$path = path;
          loop$index = index + 1;
        }
      }
    }
  }
}

function find_descendant(parent, selector, path) {
  let $ = find_direct_child(parent, selector, path);
  if ($ instanceof Ok) {
    let element$1 = $[0];
    return new Ok(element$1);
  } else {
    if (parent instanceof Fragment) {
      let children = parent.children;
      return find_descendant_in_list(children, selector, path, 1);
    } else if (parent instanceof Element) {
      let children = parent.children;
      return find_descendant_in_list(children, selector, path, 0);
    } else if (parent instanceof Text) {
      return new Error(undefined);
    } else {
      return new Error(undefined);
    }
  }
}
