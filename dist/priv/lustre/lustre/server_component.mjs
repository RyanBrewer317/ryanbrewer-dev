import * as $process from "../../gleam_erlang/gleam/erlang/process.mjs";
import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $bool from "../../gleam_stdlib/gleam/bool.mjs";
import * as $dynamic from "../../gleam_stdlib/gleam/dynamic.mjs";
import { DecodeError, dynamic } from "../../gleam_stdlib/gleam/dynamic.mjs";
import * as $int from "../../gleam_stdlib/gleam/int.mjs";
import * as $io from "../../gleam_stdlib/gleam/io.mjs";
import * as $result from "../../gleam_stdlib/gleam/result.mjs";
import * as $string from "../../gleam_stdlib/gleam/string.mjs";
import { Ok, Error, toList } from "../gleam.mjs";
import * as $lustre from "../lustre.mjs";
import * as $attribute from "../lustre/attribute.mjs";
import { attribute } from "../lustre/attribute.mjs";
import * as $effect from "../lustre/effect.mjs";
import * as $element from "../lustre/element.mjs";
import { element } from "../lustre/element.mjs";
import * as $constants from "../lustre/internals/constants.mjs";
import * as $patch from "../lustre/internals/patch.mjs";
import * as $runtime from "../lustre/internals/runtime.mjs";
import { Attrs, Event } from "../lustre/internals/runtime.mjs";

export function component(attrs) {
  return element("lustre-server-component", attrs, toList([]));
}

export function script() {
  return element(
    "script",
    toList([attribute("type", "module")]),
    toList([
      $element.text(
        "function k(t,e,s){let r,i=[{prev:t,next:e,parent:t.parentNode}];for(;i.length;){let{prev:o,next:n,parent:a}=i.pop();for(;n.subtree!==void 0;)n=n.subtree();if(n.content!==void 0)if(o)if(o.nodeType===Node.TEXT_NODE)o.textContent!==n.content&&(o.textContent=n.content),r??=o;else{let l=document.createTextNode(n.content);a.replaceChild(l,o),r??=l}else{let l=document.createTextNode(n.content);a.appendChild(l),r??=l}else if(n.tag!==void 0){let l=D({prev:o,next:n,dispatch:s,stack:i});o?o!==l&&a.replaceChild(l,o):a.appendChild(l),r??=l}else if(n.elements!==void 0)for(let l of S(n))i.unshift({prev:o,next:l,parent:a}),o=o?.nextSibling}return r}function R(t,e,s,r=0){let i=t.parentNode;for(let o of e[0]){let n=o[0].split(\"-\"),a=o[1],l=A(i,n,r),c;if(l!==null&&l!==i)c=k(l,a,s);else{let f=A(i,n.slice(0,-1),r),d=document.createTextNode(\"\");f.appendChild(d),c=k(d,a,s)}n===\"0\"&&(t=c)}for(let o of e[1]){let n=o[0].split(\"-\");A(i,n,r).remove()}for(let o of e[2]){let n=o[0].split(\"-\"),a=o[1],l=A(i,n,r),c=w.get(l);for(let f of a[0]){let d=f[0],b=f[1];if(d.startsWith(\"data-lustre-on-\")){let p=d.slice(15),x=s(F);c.has(p)||el.addEventListener(p,m),c.set(p,x),el.setAttribute(d,b)}else l.setAttribute(d,b),l[d]=b}for(let f of a[1])if(f[0].startsWith(\"data-lustre-on-\")){let d=f[0].slice(15);l.removeEventListener(d,m),c.delete(d)}else l.removeAttribute(f[0])}return t}function D({prev:t,next:e,dispatch:s,stack:r}){let i=e.namespace||\"http://www.w3.org/1999/xhtml\",o=t&&t.nodeType===Node.ELEMENT_NODE&&t.localName===e.tag&&t.namespaceURI===(e.namespace||\"http://www.w3.org/1999/xhtml\"),n=o?t:i?document.createElementNS(i,e.tag):document.createElement(e.tag),a;if(w.has(n))a=w.get(n);else{let u=new Map;w.set(n,u),a=u}let l=o?new Set(a.keys()):null,c=o?new Set(Array.from(t.attributes,u=>u.name)):null,f=null,d=null,b=null;if(o&&e.tag===\"textarea\"){let u=e.children[Symbol.iterator]().next().value?.content;u!==void 0&&(n.value=u)}for(let u of e.attrs){let h=u[0],y=u[1];if(u.as_property)n[h]!==y&&(n[h]=y),o&&c.delete(h);else if(h.startsWith(\"on\")){let g=h.slice(2),N=s(y,g===\"input\");a.has(g)||n.addEventListener(g,m),a.set(g,N),o&&l.delete(g)}else if(h.startsWith(\"data-lustre-on-\")){let g=h.slice(15),N=s(F);a.has(g)||n.addEventListener(g,m),a.set(g,N),n.setAttribute(h,y)}else h===\"class\"?f=f===null?y:f+\" \"+y:h===\"style\"?d=d===null?y:d+y:h===\"dangerous-unescaped-html\"?b=y:(n.getAttribute(h)!==y&&n.setAttribute(h,y),(h===\"value\"||h===\"selected\")&&(n[h]=y),o&&c.delete(h))}if(f!==null&&(n.setAttribute(\"class\",f),o&&c.delete(\"class\")),d!==null&&(n.setAttribute(\"style\",d),o&&c.delete(\"style\")),o){for(let u of c)n.removeAttribute(u);for(let u of l)a.delete(u),n.removeEventListener(u,m)}if(e.key!==void 0&&e.key!==\"\")n.setAttribute(\"data-lustre-key\",e.key);else if(b!==null)return n.innerHTML=b,n;let p=n.firstChild,x=null,O=null,_=null,E=S(e).next().value;if(o&&E!==void 0&&E.key!==void 0&&E.key!==\"\"){x=new Set,O=C(t),_=C(e);for(let u of S(e))p=B(p,u,n,r,_,O,x)}else for(let u of S(e))r.unshift({prev:p,next:u,parent:n}),p=p?.nextSibling;for(;p;){let u=p.nextSibling;n.removeChild(p),p=u}return n}var w=new WeakMap;function m(t){let e=t.currentTarget;if(!w.has(e)){e.removeEventListener(t.type,m);return}let s=w.get(e);if(!s.has(t.type)){e.removeEventListener(t.type,m);return}s.get(t.type)(t)}function F(t){let e=t.currentTarget,s=e.getAttribute(`data-lustre-on-${t.type}`),r=JSON.parse(e.getAttribute(\"data-lustre-data\")||\"{}\"),i=JSON.parse(e.getAttribute(\"data-lustre-include\")||\"[]\");switch(t.type){case\"input\":case\"change\":i.push(\"target.value\");break}return{tag:s,data:i.reduce((o,n)=>{let a=n.split(\".\");for(let l=0,c=o,f=t;l<a.length;l++)l===a.length-1?c[a[l]]=f[a[l]]:(c[a[l]]??={},f=f[a[l]],c=c[a[l]]);return o},{data:r})}}function C(t){let e=new Map;if(t)for(let s of S(t)){let r=s?.key||s?.getAttribute?.(\"data-lustre-key\");r&&e.set(r,s)}return e}function A(t,e,s){let r,i,o=t,n=!0;for(;[r,...i]=e,r!==void 0;)o=o.childNodes.item(n?r+s:r),n=!1,e=i;return o}function B(t,e,s,r,i,o,n){for(;t&&!i.has(t.getAttribute(\"data-lustre-key\"));){let l=t.nextSibling;s.removeChild(t),t=l}if(o.size===0){for(let l of S(e))r.unshift({prev:t,next:l,parent:s}),t=t?.nextSibling;return t}if(n.has(e.key))return console.warn(`Duplicate key found in Lustre vnode: ${e.key}`),r.unshift({prev:null,next:e,parent:s}),t;n.add(e.key);let a=o.get(e.key);if(!a&&!t)return r.unshift({prev:null,next:e,parent:s}),t;if(!a&&t!==null){let l=document.createTextNode(\"\");return s.insertBefore(l,t),r.unshift({prev:l,next:e,parent:s}),t}return!a||a===t?(r.unshift({prev:t,next:e,parent:s}),t=t?.nextSibling,t):(s.insertBefore(a,t),r.unshift({prev:a,next:e,parent:s}),t)}function*S(t){for(let e of t.children)yield*v(e)}function*v(t){if(t.elements!==void 0)for(let e of t.elements)yield*v(e);else t.subtree!==void 0?yield*v(t.subtree()):yield t}function q(t,e){let s=[t,e];for(;s.length;){let r=s.pop(),i=s.pop();if(r===i)continue;if(!M(r)||!M(i)||!G(r,i)||H(r,i)||W(r,i)||z(r,i)||I(r,i)||V(r,i)||K(r,i))return!1;let n=Object.getPrototypeOf(r);if(n!==null&&typeof n.equals==\"function\")try{if(r.equals(i))continue;return!1}catch{}let[a,l]=U(r);for(let c of a(r))s.push(l(r,c),l(i,c))}return!0}function U(t){if(t instanceof Map)return[e=>e.keys(),(e,s)=>e.get(s)];{let e=t instanceof globalThis.Error?[\"message\"]:[];return[s=>[...e,...Object.keys(s)],(s,r)=>s[r]]}}function H(t,e){return t instanceof Date&&(t>e||t<e)}function W(t,e){return t.buffer instanceof ArrayBuffer&&t.BYTES_PER_ELEMENT&&!(t.byteLength===e.byteLength&&t.every((s,r)=>s===e[r]))}function z(t,e){return Array.isArray(t)&&t.length!==e.length}function I(t,e){return t instanceof Map&&t.size!==e.size}function V(t,e){return t instanceof Set&&(t.size!=e.size||[...t].some(s=>!e.has(s)))}function K(t,e){return t instanceof RegExp&&(t.source!==e.source||t.flags!==e.flags)}function M(t){return typeof t==\"object\"&&t!==null}function G(t,e){return typeof t!=\"object\"&&typeof e!=\"object\"&&(!t||!e)||[Promise,WeakSet,WeakMap,Function].some(r=>t instanceof r)?!1:t.constructor===e.constructor}var L=class extends HTMLElement{static get observedAttributes(){return[\"route\"]}constructor(){super(),this.attachShadow({mode:\"open\"}),this.#n=new MutationObserver(e=>{let s=[];for(let r of e)if(r.type===\"attributes\"){let{attributeName:i}=r,o=this.getAttribute(i);this[i]=o}s.length&&this.#t?.send(JSON.stringify([5,s]))})}connectedCallback(){this.#n.observe(this,{attributes:!0,attributeOldValue:!0}),this.#a().finally(()=>this.#r=!0)}attributeChangedCallback(e,s,r){switch(e){case\"route\":if(!r)this.#t?.close(),this.#t=null;else if(s!==r){let i=this.getAttribute(\"id\"),o=r+(i?`?id=${i}`:\"\"),n=window.location.protocol===\"https:\"?\"wss\":\"ws\";this.#t?.close(),this.#t=new WebSocket(`${n}://${window.location.host}${o}`),this.#t.addEventListener(\"message\",a=>this.messageReceivedCallback(a))}}}messageReceivedCallback({data:e}){let[s,...r]=JSON.parse(e);switch(s){case 0:return this.#o(r);case 1:return this.#i(r);case 2:return this.#s(r)}}disconnectedCallback(){this.#t?.close()}#n;#t;#r=!1;#e=[];#s([e,s]){let r=[];for(let n of e)n in this?r.push([n,this[n]]):this.hasAttribute(n)&&r.push([n,this.getAttribute(n)]),Object.defineProperty(this,n,{get(){return this[`__mirrored__${n}`]},set(a){let l=this[`__mirrored__${n}`];q(l,a)||(this[`__mirrored__${n}`]=a,this.#t?.send(JSON.stringify([5,[[n,a]]])))}});this.#n.observe(this,{attributeFilter:e,attributeOldValue:!0,attributes:!0,characterData:!1,characterDataOldValue:!1,childList:!1,subtree:!1});let i=P(this.shadowRoot,this.#e.length)??this.shadowRoot.appendChild(document.createTextNode(\"\"));k(i,s,n=>a=>{let l=JSON.parse(this.getAttribute(\"data-lustre-data\")||\"{}\"),c=n(a);c.data=$(l,c.data),this.#t?.send(JSON.stringify([4,c.tag,c.data]))}),r.length&&this.#t?.send(JSON.stringify([5,r]))}#o([e]){let s=P(this.shadowRoot,this.#e.length)??this.shadowRoot.appendChild(document.createTextNode(\"\"));R(s,e,i=>o=>{let n=i(o);this.#t?.send(JSON.stringify([4,n.tag,n.data]))},this.#e.length)}#i([e,s]){this.dispatchEvent(new CustomEvent(e,{detail:s}))}async#a(){let e=[],s=Array.from(document.styleSheets);for(let i of document.querySelectorAll(\"link[rel=stylesheet]\"))s.includes(i.sheet)||e.push(new Promise((o,n)=>{i.addEventListener(\"load\",o),i.addEventListener(\"error\",n)}));for(await Promise.allSettled(e);this.#e.length;)this.#e.shift().remove();this.shadowRoot.adoptedStyleSheets=this.getRootNode().adoptedStyleSheets;let r=[];for(let i of document.styleSheets){try{this.shadowRoot.adoptedStyleSheets.push(i)}catch{}try{let o=new CSSStyleSheet;for(let n of i.cssRules)o.insertRule(n.cssText,o.cssRules.length);this.shadowRoot.adoptedStyleSheets.push(o)}catch{let o=i.ownerNode.cloneNode();this.shadowRoot.prepend(o),this.#e.push(o),r.push(new Promise((n,a)=>{o.onload=n,o.onerror=a}))}}return Promise.allSettled(r)}};window.customElements.define(\"lustre-server-component\",L);var P=(t,e)=>{let s=t.firstChild;for(;s&&e>0;)s=s.nextSibling;return s},$=(t,e)=>{for(let s in e)e[s]instanceof Object&&Object.assign(e[s],$(t[s],e[s]));return Object.assign(t||{},e),t};export{L as LustreServerComponent};",
      ),
    ]),
  );
}

export function route(path) {
  return attribute("route", path);
}

export function data(json) {
  let _pipe = json;
  let _pipe$1 = $json.to_string(_pipe);
  return ((_capture) => { return attribute("data-lustre-data", _capture); })(
    _pipe$1,
  );
}

export function include(properties) {
  let _pipe = properties;
  let _pipe$1 = $json.array(_pipe, $json.string);
  let _pipe$2 = $json.to_string(_pipe$1);
  return ((_capture) => { return attribute("data-lustre-include", _capture); })(
    _pipe$2,
  );
}

export function subscribe(id, renderer) {
  return new $runtime.Subscribe(id, renderer);
}

export function unsubscribe(id) {
  return new $runtime.Unsubscribe(id);
}

export function emit(event, data) {
  return $effect.event(event, data);
}

function do_select(_) {
  return $effect.none();
}

export function select(sel) {
  return do_select(sel);
}

export function set_selector(_) {
  return $effect.from(
    (_) => {
      let _pipe = "\nIt looks like you're trying to use `set_selector` in a server component. The\nimplementation of this effect is broken in ways that cannot be fixed without\nchanging the API. Please take a look at `select` instead!\n  ";
      let _pipe$1 = $string.trim(_pipe);
      $io.println_error(_pipe$1)
      return undefined;
    },
  );
}

function decode_event(dyn) {
  return $result.try$(
    $dynamic.tuple3($dynamic.int, dynamic, dynamic)(dyn),
    (_use0) => {
      let kind = _use0[0];
      let name = _use0[1];
      let data$1 = _use0[2];
      return $bool.guard(
        kind !== $constants.event,
        new Error(
          toList([
            new DecodeError(
              $int.to_string($constants.event),
              $int.to_string(kind),
              toList(["0"]),
            ),
          ]),
        ),
        () => {
          return $result.try$(
            $dynamic.string(name),
            (name) => { return new Ok(new Event(name, data$1)); },
          );
        },
      );
    },
  );
}

function decode_attr(dyn) {
  return $dynamic.tuple2($dynamic.string, dynamic)(dyn);
}

function decode_attrs(dyn) {
  return $result.try$(
    $dynamic.tuple2($dynamic.int, dynamic)(dyn),
    (_use0) => {
      let kind = _use0[0];
      let attrs = _use0[1];
      return $bool.guard(
        kind !== $constants.attrs,
        new Error(
          toList([
            new DecodeError(
              $int.to_string($constants.attrs),
              $int.to_string(kind),
              toList(["0"]),
            ),
          ]),
        ),
        () => {
          return $result.try$(
            $dynamic.list(decode_attr)(attrs),
            (attrs) => { return new Ok(new Attrs(attrs)); },
          );
        },
      );
    },
  );
}

export function decode_action(dyn) {
  return $dynamic.any(toList([decode_event, decode_attrs]))(dyn);
}

export function encode_patch(patch) {
  return $patch.patch_to_json(patch);
}
