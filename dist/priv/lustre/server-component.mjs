// Note that this path is relative to the built Gleam project, not the source files
// in `src/`. This particular module is not used by the Lustre package itself, but
// is instead bundled and made available to package users in the `priv/` directory.
//
// It makes obvious sense to co-locate the source with the rest of the package
// source code, but if we use relative imports here the bundle will fail because
// `vdom.ffi.mjs` is importing things from the Gleam standard library and expects
// to be placed in the `build/dev/javascript/lustre/` directory.
//
import * as Constants from "../build/dev/javascript/lustre/lustre/internals/constants.mjs";
import { patch, morph } from "../build/dev/javascript/lustre/vdom.ffi.mjs";

export class LustreServerComponent extends HTMLElement {
  static get observedAttributes() {
    return ["route"];
  }

  #observer = null;
  #root = null;
  #socket = null;
  /** @type {ShadowRoot} */
  #shadow;
  /** @type {Array<Node>} */
  #styles = [];

  constructor() {
    super();

    this.#shadow = this.attachShadow({ mode: "closed" });
    this.#root = document.createElement("div");
    this.#observer = new MutationObserver((mutations) => {
      const changed = [];

      for (const mutation of mutations) {
        if (mutation.type === "attributes") {
          const { attributeName: name, oldValue: prev } = mutation;
          const next = this.getAttribute(name);

          if (prev !== next) {
            try {
              changed.push([name, JSON.parse(next)]);
            } catch {
              changed.push([name, next]);
            }
          }
        }
      }

      if (changed.length) {
        this.#socket?.send(JSON.stringify([Constants.attrs, changed]));
      }
    });
  }

  connectedCallback() {
    this.adoptStyleSheets().finally(() => {
      this.#shadow.append(this.#root);
    });
  }

  attributeChangedCallback(name, prev, next) {
    switch (name) {
      case "route": {
        if (!next) {
          this.#socket?.close();
          this.#socket = null;
        } else if (prev !== next) {
          const id = this.getAttribute("id");
          const route = next + (id ? `?id=${id}` : "");
          const protocol = window.location.protocol === "https:" ? "wss" : "ws";

          this.#socket?.close();
          this.#socket = new WebSocket(
            `${protocol}://${window.location.host}${route}`,
          );
          this.#socket.addEventListener("message", (message) =>
            this.messageReceivedCallback(message),
          );
        }
      }
    }
  }

  messageReceivedCallback({ data }) {
    const [kind, ...payload] = JSON.parse(data);

    switch (kind) {
      case Constants.diff:
        return this.diff(payload);

      case Constants.emit:
        return this.emit(payload);

      case Constants.init:
        return this.init(payload);
    }
  }

  init([attrs, vdom]) {
    const initial = [];

    for (const attr of attrs) {
      if (attr in this) {
        initial.push([attr, this[attr]]);
      } else if (this.hasAttribute(attr)) {
        initial.push([attr, this.getAttribute(attr)]);
      }

      Object.defineProperty(this, attr, {
        get() {
          return this[`_${attr}`] ?? this.getAttribute(attr);
        },
        set(value) {
          const prev = this[attr];

          if (typeof value === "string") {
            this.setAttribute(attr, value);
          } else {
            this[`_${attr}`] = value;
          }

          if (prev !== value) {
            this.#socket?.send(
              JSON.stringify([Constants.attrs, [[attr, value]]]),
            );
          }
        },
      });
    }

    this.#observer.observe(this, {
      attributeFilter: attrs,
      attributeOldValue: true,
      attributes: true,
      characterData: false,
      characterDataOldValue: false,
      childList: false,
      subtree: false,
    });

    this.morph(vdom);

    if (initial.length) {
      this.#socket?.send(JSON.stringify([Constants.attrs, initial]));
    }
  }

  morph(vdom) {
    this.#root = morph(this.#root, vdom, (handler) => (event) => {
      const data = JSON.parse(this.getAttribute("data-lustre-data") || "{}");
      const msg = handler(event);

      msg.data = merge(data, msg.data);

      this.#socket?.send(JSON.stringify([Constants.event, msg.tag, msg.data]));
    });
  }

  diff([diff]) {
    this.#root = patch(
      this.#root,
      diff,
      (handler) => (event) => {
        const msg = handler(event);
        this.#socket?.send(
          JSON.stringify([Constants.event, msg.tag, msg.data]),
        );
      },
      this.#styles.length,
    );
  }

  emit([event, data]) {
    this.dispatchEvent(new CustomEvent(event, { detail: data }));
  }

  disconnectedCallback() {
    this.#socket?.close();
  }

  async adoptStyleSheets() {
    // There might be stylesheets in the document that have not loaded by the
    // time our component mounts. If that's the case we'd miss them when trying
    // to adopt all appropriate styles, so we do some work here to detect any
    // stylesheets currently loading and wait for them all before we continue.
    const pendingParentStylesheets = [];
    const documentStyleSheets = [...document.styleSheets];

    for (const link of document.querySelectorAll("link[rel=stylesheet]")) {
      if (documentStyleSheets.includes(link.sheet)) continue;

      pendingParentStylesheets.push(
        new Promise((resolve, reject) => {
          link.addEventListener("load", resolve);
          link.addEventListener("error", reject);
        }),
      );
    }

    await Promise.allSettled(pendingParentStylesheets);

    // Remove any existing style or link nodes that we've added to the shadow
    // root
    while (this.#styles.length) this.#styles.shift().remove();

    const pending = [];

    // Adopt any stylesheets that are present in the parent root
    //
    this.#shadow.adoptedStyleSheets = this.getRootNode().adoptedStyleSheets;

    // Iterate over all the stylesheets in the document and add them to the
    // shadow root. If the stylesheet is cross-origin, we need to clone the
    // node and add it to the shadow root instead.
    //
    for (const sheet of document.styleSheets) {
      try {
        this.#shadow.adoptedStyleSheets.push(sheet);
        continue;
      } catch {}

      try {
        const adoptedSheet = new CSSStyleSheet();

        for (const rule of sheet.cssRules) {
          adoptedSheet.insertRule(rule.cssText);
        }

        this.#shadow.adoptedStyleSheets.push(adoptedSheet);
      } catch {
        const node = sheet.ownerNode.cloneNode();

        this.#shadow.prepend(node);
        this.#styles.push(node);
        pending.push(
          new Promise((resolve, reject) => {
            node.onload = resolve;
            node.onerror = reject;
          }),
        );
      }
    }

    return Promise.allSettled(pending);
  }

  adoptStyleSheet(sheet) {
    this.#shadow.adoptedStyleSheets.push(sheet);
  }

  get adoptedStyleSheets() {
    return this.#shadow.adoptedStyleSheets;
  }
}

window.customElements.define("lustre-server-component", LustreServerComponent);

// UTILS -----------------------------------------------------------------------

function merge(target, source) {
  for (const key in source) {
    if (source[key] instanceof Object)
      Object.assign(source[key], merge(target[key], source[key]));
  }

  Object.assign(target || {}, source);
  return target;
}
