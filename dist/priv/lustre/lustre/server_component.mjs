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
        "window&&window.customElements&&window.customElements.define(\"lustre-fragment\",class extends HTMLElement{constructor(){super()}});function N(t,e,r){let s,i=[{prev:t,next:e,parent:t.parentNode}];for(;i.length;){let{prev:o,next:n,parent:l}=i.pop();for(;n.subtree!==void 0;)n=n.subtree();if(n.content!==void 0)if(o)if(o.nodeType===Node.TEXT_NODE)o.textContent!==n.content&&(o.textContent=n.content),s??=o;else{let a=document.createTextNode(n.content);l.replaceChild(a,o),s??=a}else{let a=document.createTextNode(n.content);l.appendChild(a),s??=a}else if(n.tag!==void 0){let a=j({prev:o,next:n,dispatch:r,stack:i});o?o!==a&&l.replaceChild(a,o):l.appendChild(a),s??=a}}return s}function C(t,e,r,s=0){let i=t.parentNode;for(let o of e[0]){let n=o[0].split(\"-\"),l=o[1],a=E(i,n,s),c;if(a!==null&&a!==i)c=N(a,l,r);else{let p=E(i,n.slice(0,-1),s),g=document.createTextNode(\"\");p.appendChild(g),c=N(g,l,r)}n===\"0\"&&(t=c)}for(let o of e[1]){let n=o[0].split(\"-\");E(i,n,s).remove()}for(let o of e[2]){let n=o[0].split(\"-\"),l=o[1],a=E(i,n,s),c=x.get(a),p=[];for(let g of l[0]){let d=g[0],b=g[1];if(d.startsWith(\"data-lustre-on-\")){let m=d.slice(15),S=r(F);c.has(m)||a.addEventListener(m,w),c.set(m,S),a.setAttribute(d,b)}else(d.startsWith(\"delegate:data-\")||d.startsWith(\"delegate:aria-\"))&&a instanceof HTMLSlotElement?p.push([d.slice(10),b]):(a.setAttribute(d,b),(d===\"value\"||d===\"selected\")&&(a[d]=b));if(p.length>0)for(let m of a.assignedElements())for(let[S,A]of p)m[S]=A}for(let g of l[1])if(g.startsWith(\"data-lustre-on-\")){let d=g.slice(15);a.removeEventListener(d,w),c.delete(d)}else a.removeAttribute(g)}return t}function j({prev:t,next:e,dispatch:r,stack:s}){let i=e.namespace||\"http://www.w3.org/1999/xhtml\",o=t&&t.nodeType===Node.ELEMENT_NODE&&t.localName===e.tag&&t.namespaceURI===(e.namespace||\"http://www.w3.org/1999/xhtml\"),n=o?t:i?document.createElementNS(i,e.tag):document.createElement(e.tag),l;if(x.has(n))l=x.get(n);else{let u=new Map;x.set(n,u),l=u}let a=o?new Set(l.keys()):null,c=o?new Set(Array.from(t.attributes,u=>u.name)):null,p=null,g=null,d=null;if(o&&e.tag===\"textarea\"){let u=e.children[Symbol.iterator]().next().value?.content;u!==void 0&&(n.value=u)}let b=[];for(let u of e.attrs){let f=u[0],h=u[1];if(u.as_property)n[f]!==h&&(n[f]=h),o&&c.delete(f);else if(f.startsWith(\"on\")){let y=f.slice(2),T=r(h,y===\"input\");l.has(y)||n.addEventListener(y,w),l.set(y,T),o&&a.delete(y)}else if(f.startsWith(\"data-lustre-on-\")){let y=f.slice(15),T=r(F);l.has(y)||n.addEventListener(y,w),l.set(y,T),n.setAttribute(f,h)}else f.startsWith(\"delegate:data-\")||f.startsWith(\"delegate:aria-\")?(n.setAttribute(f,h),b.push([f.slice(10),h])):f===\"class\"?p=p===null?h:p+\" \"+h:f===\"style\"?g=g===null?h:g+h:f===\"dangerous-unescaped-html\"?d=h:(n.getAttribute(f)!==h&&n.setAttribute(f,h),(f===\"value\"||f===\"selected\")&&(n[f]=h),o&&c.delete(f))}if(p!==null&&(n.setAttribute(\"class\",p),o&&c.delete(\"class\")),g!==null&&(n.setAttribute(\"style\",g),o&&c.delete(\"style\")),o){for(let u of c)n.removeAttribute(u);for(let u of a)l.delete(u),n.removeEventListener(u,w)}if(e.tag===\"slot\"&&window.queueMicrotask(()=>{for(let u of n.assignedElements())for(let[f,h]of b)u.hasAttribute(f)||u.setAttribute(f,h)}),e.key!==void 0&&e.key!==\"\")n.setAttribute(\"data-lustre-key\",e.key);else if(d!==null)return n.innerHTML=d,n;let m=n.firstChild,S=null,A=null,R=null,v=k(e).next().value;if(o&&v!==void 0&&v.key!==void 0&&v.key!==\"\"){S=new Set,A=_(t),R=_(e);for(let u of k(e))m=D(m,u,n,s,R,A,S)}else for(let u of k(e))s.unshift({prev:m,next:u,parent:n}),m=m?.nextSibling;for(;m;){let u=m.nextSibling;n.removeChild(m),m=u}return n}var x=new WeakMap;function w(t){let e=t.currentTarget;if(!x.has(e)){e.removeEventListener(t.type,w);return}let r=x.get(e);if(!r.has(t.type)){e.removeEventListener(t.type,w);return}r.get(t.type)(t)}function F(t){let e=t.currentTarget,r=e.getAttribute(`data-lustre-on-${t.type}`),s=JSON.parse(e.getAttribute(\"data-lustre-data\")||\"{}\"),i=JSON.parse(e.getAttribute(\"data-lustre-include\")||\"[]\");switch(t.type){case\"input\":case\"change\":i.push(\"target.value\");break}return{tag:r,data:i.reduce((o,n)=>{let l=n.split(\".\");for(let a=0,c=o,p=t;a<l.length;a++)a===l.length-1?c[l[a]]=p[l[a]]:(c[l[a]]??={},p=p[l[a]],c=c[l[a]]);return o},{data:s})}}function _(t){let e=new Map;if(t)for(let r of k(t)){let s=r?.key||r?.getAttribute?.(\"data-lustre-key\");s&&e.set(s,r)}return e}function E(t,e,r){let s,i,o=t,n=!0;for(;[s,...i]=e,s!==void 0;)o=o.childNodes.item(n?s+r:s),n=!1,e=i;return o}function D(t,e,r,s,i,o,n){for(;t&&!i.has(t.getAttribute(\"data-lustre-key\"));){let a=t.nextSibling;r.removeChild(t),t=a}if(o.size===0)return s.unshift({prev:t,next:e,parent:r}),t=t?.nextSibling,t;if(n.has(e.key))return console.warn(`Duplicate key found in Lustre vnode: ${e.key}`),s.unshift({prev:null,next:e,parent:r}),t;n.add(e.key);let l=o.get(e.key);if(!l&&!t)return s.unshift({prev:null,next:e,parent:r}),t;if(!l&&t!==null){let a=document.createTextNode(\"\");return r.insertBefore(a,t),s.unshift({prev:a,next:e,parent:r}),t}return!l||l===t?(s.unshift({prev:t,next:e,parent:r}),t=t?.nextSibling,t):(r.insertBefore(l,t),s.unshift({prev:l,next:e,parent:r}),t)}function*k(t){for(let e of t.children)yield*M(e)}function*M(t){t.subtree!==void 0?yield*M(t.subtree()):yield t}function J(t,e){let r=[t,e];for(;r.length;){let s=r.pop(),i=r.pop();if(s===i)continue;if(!q(s)||!q(i)||!G(s,i)||B(s,i)||U(s,i)||z(s,i)||I(s,i)||V(s,i)||K(s,i))return!1;let n=Object.getPrototypeOf(s);if(n!==null&&typeof n.equals==\"function\")try{if(s.equals(i))continue;return!1}catch{}let[l,a]=H(s);for(let c of l(s))r.push(a(s,c),a(i,c))}return!0}function H(t){if(t instanceof Map)return[e=>e.keys(),(e,r)=>e.get(r)];{let e=t instanceof globalThis.Error?[\"message\"]:[];return[r=>[...e,...Object.keys(r)],(r,s)=>r[s]]}}function B(t,e){return t instanceof Date&&(t>e||t<e)}function U(t,e){return t.buffer instanceof ArrayBuffer&&t.BYTES_PER_ELEMENT&&!(t.byteLength===e.byteLength&&t.every((r,s)=>r===e[s]))}function z(t,e){return Array.isArray(t)&&t.length!==e.length}function I(t,e){return t instanceof Map&&t.size!==e.size}function V(t,e){return t instanceof Set&&(t.size!=e.size||[...t].some(r=>!e.has(r)))}function K(t,e){return t instanceof RegExp&&(t.source!==e.source||t.flags!==e.flags)}function q(t){return typeof t==\"object\"&&t!==null}function G(t,e){return typeof t!=\"object\"&&typeof e!=\"object\"&&(!t||!e)||[Promise,WeakSet,WeakMap,Function].some(s=>t instanceof s)?!1:t.constructor===e.constructor}var O=class extends HTMLElement{static get observedAttributes(){return[\"route\"]}constructor(){super(),this.attachShadow({mode:\"open\"}),this.#n=new MutationObserver(e=>{let r=[];for(let s of e)if(s.type===\"attributes\"){let{attributeName:i}=s,o=this.getAttribute(i);this[i]=o}r.length&&this.#t?.send(JSON.stringify([5,r]))})}connectedCallback(){this.#n.observe(this,{attributes:!0,attributeOldValue:!0}),this.#a().finally(()=>this.#s=!0)}attributeChangedCallback(e,r,s){switch(e){case\"route\":if(!s)this.#t?.close(),this.#t=null;else if(r!==s){let i=this.getAttribute(\"id\"),o=s+(i?`?id=${i}`:\"\"),n=window.location.protocol===\"https:\"?\"wss\":\"ws\";this.#t?.close(),this.#t=new WebSocket(`${n}://${window.location.host}${o}`),this.#t.addEventListener(\"message\",l=>this.messageReceivedCallback(l))}}}messageReceivedCallback({data:e}){let[r,...s]=JSON.parse(e);switch(r){case 0:return this.#o(s);case 1:return this.#i(s);case 2:return this.#r(s)}}disconnectedCallback(){this.#t?.close()}#n;#t;#s=!1;#e=[];#r([e,r]){let s=[];for(let n of e)n in this?s.push([n,this[n]]):this.hasAttribute(n)&&s.push([n,this.getAttribute(n)]),Object.defineProperty(this,n,{get(){return this[`__mirrored__${n}`]},set(l){let a=this[`__mirrored__${n}`];J(a,l)||(this[`__mirrored__${n}`]=l,this.#t?.send(JSON.stringify([5,[[n,l]]])))}});this.#n.observe(this,{attributeFilter:e,attributeOldValue:!0,attributes:!0,characterData:!1,characterDataOldValue:!1,childList:!1,subtree:!1});let i=this.shadowRoot.childNodes[this.#e.lemgth]??this.shadowRoot.appendChild(document.createTextNode(\"\"));N(i,r,n=>l=>{let a=JSON.parse(this.getAttribute(\"data-lustre-data\")||\"{}\"),c=n(l);c.data=W(a,c.data),this.#t?.send(JSON.stringify([4,c.tag,c.data]))}),s.length&&this.#t?.send(JSON.stringify([5,s]))}#o([e]){let r=this.shadowRoot.childNodes[this.#e.length-1]??this.shadowRoot.appendChild(document.createTextNode(\"\"));C(r,e,i=>o=>{let n=i(o);this.#t?.send(JSON.stringify([4,n.tag,n.data]))},this.#e.length)}#i([e,r]){this.dispatchEvent(new CustomEvent(e,{detail:r}))}async#a(){let e=[];for(let s of document.querySelectorAll(\"link[rel=stylesheet]\"))s.sheet||e.push(new Promise((i,o)=>{s.addEventListener(\"load\",i),s.addEventListener(\"error\",o)}));for(await Promise.allSettled(e);this.#e.length;)this.#e.shift().remove(),this.shadowRoot.firstChild.remove();this.shadowRoot.adoptedStyleSheets=this.getRootNode().adoptedStyleSheets;let r=[];for(let s of document.styleSheets)try{this.shadowRoot.adoptedStyleSheets.push(s)}catch{try{let i=new CSSStyleSheet;for(let o of s.cssRules)i.insertRule(o.cssText,i.cssRules.length);this.shadowRoot.adoptedStyleSheets.push(i)}catch{let i=s.ownerNode.cloneNode();this.shadowRoot.prepend(i),this.#e.push(i),r.push(new Promise((o,n)=>{i.onload=o,i.onerror=n}))}}return Promise.allSettled(r)}};window.customElements.define(\"lustre-server-component\",O);var W=(t,e)=>{for(let r in e)e[r]instanceof Object&&Object.assign(e[r],W(t[r],e[r]));return Object.assign(t||{},e),t};export{O as LustreServerComponent};",
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
