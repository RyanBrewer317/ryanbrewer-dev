var R=(e,t,n)=>{if(!t.has(e))throw TypeError("Cannot "+n)};var c=(e,t,n)=>(R(e,t,"read from private field"),n?n.call(e):t.get(e)),h=(e,t,n)=>{if(t.has(e))throw TypeError("Cannot add the same private member more than once");t instanceof WeakSet?t.add(e):t.set(e,n)},f=(e,t,n,r)=>(R(e,t,"write to private field"),r?r.call(e,n):t.set(e,n),n);var N=(e,t,n)=>(R(e,t,"access private method"),n);(function(){const t=document.createElement("link").relList;if(t&&t.supports&&t.supports("modulepreload"))return;for(const s of document.querySelectorAll('link[rel="modulepreload"]'))r(s);new MutationObserver(s=>{for(const i of s)if(i.type==="childList")for(const o of i.addedNodes)o.tagName==="LINK"&&o.rel==="modulepreload"&&r(o)}).observe(document,{childList:!0,subtree:!0});function n(s){const i={};return s.integrity&&(i.integrity=s.integrity),s.referrerPolicy&&(i.referrerPolicy=s.referrerPolicy),s.crossOrigin==="use-credentials"?i.credentials="include":s.crossOrigin==="anonymous"?i.credentials="omit":i.credentials="same-origin",i}function r(s){if(s.ep)return;s.ep=!0;const i=n(s);fetch(s.href,i)}})();let ot=class{inspect(){let t=r=>{let s=A(this[r]);return isNaN(parseInt(r))?`${r}: ${s}`:s},n=Object.keys(this).map(t).join(", ");return n?`${this.constructor.name}(${n})`:this.constructor.name}withFields(t){let n=Object.keys(this).map(r=>r in t?t[r]:this[r]);return new this.constructor(...n)}},Q=class extends ot{static isResult(t){let n=t==null?void 0:t.__gleam_prelude_variant__;return n==="Ok"||n==="Error"}},X=class extends Q{constructor(t){super(),this[0]=t}get __gleam_prelude_variant__(){return"Ok"}isOk(){return!0}},Z=class extends Q{constructor(t){super(),this[0]=t}get __gleam_prelude_variant__(){return"Error"}isOk(){return!1}};function A(e){let t=typeof e;if(e===!0)return"True";if(e===!1)return"False";if(e===null)return"//js(null)";if(e===void 0)return"Nil";if(t==="string")return JSON.stringify(e);if(t==="bigint"||t==="number")return e.toString();if(Array.isArray(e))return`#(${e.map(A).join(", ")})`;if(e instanceof Set)return`//js(Set(${[...e].map(A).join(", ")}))`;if(e instanceof RegExp)return`//js(${e})`;if(e instanceof Date)return`//js(Date("${e.toISOString()}"))`;if(e instanceof Function){let n=[];for(let r of Array(e.length).keys())n.push(String.fromCharCode(r+97));return`//fn(${n.join(", ")}) { ... }`}try{return e.inspect()}catch{return ut(e)}}function ut(e){var l,u;let[t,n]=lt(e),r=((u=(l=Object.getPrototypeOf(e))==null?void 0:l.constructor)==null?void 0:u.name)||"Object",s=[];for(let a of t(e))s.push(`${A(a)}: ${A(n(e,a))}`);let i=s.length?" "+s.join(", ")+" ":"";return`//js(${r==="Object"?"":r+" "}{${i}})`}function lt(e){if(e instanceof Map)return[t=>t.keys(),(t,n)=>t.get(n)];{let t=e instanceof globalThis.Error?["message"]:[];return[n=>[...t,...Object.keys(n)],(n,r)=>n[r]]}}function v(e,t,n,r,s,i){let o=new globalThis.Error(s);o.gleam_error=e,o.module=t,o.line=n,o.fn=r;for(let l in i)o[l]=i[l];return o}function at(e,t){if(e.isOk()){let n=e[0];return new X(t(n))}else{if(e.isOk())throw v("case_no_match","gleam/result",67,"map","No case clause matched",{values:[e]});{let n=e[0];return new Z(n)}}}function ct(e,t){if(e.isOk()){let n=e[0];return new X(n)}else{if(e.isOk())throw v("case_no_match","gleam/result",429,"replace_error","No case clause matched",{values:[e]});return new Z(t)}}function ft(e){return e.toString()}function ht(e){return ft(e)}let $=class{inspect(){let t=r=>{let s=x(this[r]);return isNaN(parseInt(r))?`${r}: ${s}`:s},n=Object.keys(this).map(t).join(", ");return n?`${this.constructor.name}(${n})`:this.constructor.name}withFields(t){let n=Object.keys(this).map(r=>r in t?t[r]:this[r]);return new this.constructor(...n)}},V=class{static fromArray(t,n){let r=n||new W;return t.reduceRight((s,i)=>new pt(i,s),r)}static isList(t){let n=t==null?void 0:t.__gleam_prelude_variant__;return n==="EmptyList"||n==="NonEmptyList"}[Symbol.iterator](){return new mt(this)}inspect(){return`[${this.toArray().map(x).join(", ")}]`}toArray(){return[...this]}atLeastLength(t){for(let n of this){if(t<=0)return!0;t--}return t<=0}hasLength(t){for(let n of this){if(t<=0)return!1;t--}return t===0}countLength(){let t=0;for(let n of this)t++;return t}};function dt(e,t){return V.fromArray(e,t)}var O,G;let mt=(G=class{constructor(t){h(this,O,void 0);f(this,O,t)}next(){if(c(this,O).isEmpty())return{done:!0};{let{head:t,tail:n}=c(this,O);return f(this,O,n),{value:t,done:!1}}}},O=new WeakMap,G),W=class extends V{get __gleam_prelude_variant__(){return"EmptyList"}isEmpty(){return!0}},pt=class extends V{constructor(t,n){super(),this.head=t,this.tail=n}get __gleam_prelude_variant__(){return"NonEmptyList"}isEmpty(){return!1}};class tt extends ${static isResult(t){let n=t==null?void 0:t.__gleam_prelude_variant__;return n==="Ok"||n==="Error"}}class et extends tt{constructor(t){super(),this[0]=t}get __gleam_prelude_variant__(){return"Ok"}isOk(){return!0}}class I extends tt{constructor(t){super(),this[0]=t}get __gleam_prelude_variant__(){return"Error"}isOk(){return!1}}function x(e){let t=typeof e;if(e===!0)return"True";if(e===!1)return"False";if(e===null)return"//js(null)";if(e===void 0)return"Nil";if(t==="string")return JSON.stringify(e);if(t==="bigint"||t==="number")return e.toString();if(Array.isArray(e))return`#(${e.map(x).join(", ")})`;if(e instanceof Set)return`//js(Set(${[...e].map(x).join(", ")}))`;if(e instanceof RegExp)return`//js(${e})`;if(e instanceof Date)return`//js(Date("${e.toISOString()}"))`;if(e instanceof Function){let n=[];for(let r of Array(e.length).keys())n.push(String.fromCharCode(r+97));return`//fn(${n.join(", ")}) { ... }`}try{return e.inspect()}catch{return gt(e)}}function gt(e){var l,u;let[t,n]=yt(e),r=((u=(l=Object.getPrototypeOf(e))==null?void 0:l.constructor)==null?void 0:u.name)||"Object",s=[];for(let a of t(e))s.push(`${x(a)}: ${x(n(e,a))}`);let i=s.length?" "+s.join(", ")+" ":"";return`//js(${r==="Object"?"":r+" "}{${i}})`}function yt(e){if(e instanceof Map)return[t=>t.keys(),(t,n)=>t.get(n)];{let t=e instanceof globalThis.Error?["message"]:[];return[n=>[...t,...Object.keys(n)],(n,r)=>n[r]]}}class _t extends ${constructor(t){super(),this[0]=t}}function H(){return new _t(dt([]))}function E(e,t,n,r){return t[3]?(e==null?void 0:e.nodeType)===1&&e.nodeName===t[0].toUpperCase()&&e.namespaceURI===t[3]?B(e,t,t[3],n,r):J(e,t,t[3],n,r):t[2]?(e==null?void 0:e.nodeType)===1&&e.nodeName===t[0].toUpperCase()?B(e,t,null,n,r):J(e,t,null,n,r):typeof(t==null?void 0:t[0])=="string"?(e==null?void 0:e.nodeType)===3?wt(e,t):$t(e,t):document.createComment(["[internal lustre error] I couldn't work out how to render this element. This","function should only be called internally by lustre's runtime: if you think","this is an error, please open an issue at","https://github.com/hayleigh-dot-dev/gleam-lustre/issues/new"].join(" "))}function J(e,t,n,r,s=null){const i=n?document.createElementNS(n,t[0]):document.createElement(t[0]);i.$lustre={};let o=t[1];for(;o.head;)M(i,o.head[0],o.head[0]==="class"&&i.className?`${i.className} ${o.head[1]}`:o.head[1],r),o=o.tail;if(customElements.get(t[0]))i._slot=t[2];else if(t[0]==="slot"){let l=new W,u=s;for(;u;)if(u._slot){l=u._slot;break}else u=u.parentNode;for(;l.head;)i.appendChild(E(null,l.head,r,i)),l=l.tail}else{let l=t[2];for(;l.head;)i.appendChild(E(null,l.head,r,i)),l=l.tail;e&&e.replaceWith(i)}return i}function B(e,t,n,r,s){const i=e.attributes,o=new Map;let l=t[1];for(;l.head;)o.set(l.head[0],l.head[0]==="class"&&o.has("class")?`${o.get("class")} ${l.head[1]}`:l.head[1]),l=l.tail;for(const{name:u,value:a}of i)if(!o.has(u))e.removeAttribute(u);else{const m=o.get(u);m!==a&&(M(e,u,m,r),o.delete(u))}for(const[u,a]of o)M(e,u,a,r);if(customElements.get(t[0]))e._slot=t[2];else if(t[0]==="slot"){let u=e.firstChild,a=new W,m=s;for(;m;)if(m._slot){a=m._slot;break}else m=m.parentNode;for(;u;)a.head&&(E(u,a.head,r,e),a=a.tail),u=u.nextSibling;for(;a.head;)e.appendChild(E(null,a.head,r,e)),a=a.tail}else{let u=e.firstChild,a=t[2];for(;u;)if(a.head){const m=u.nextSibling;E(u,a.head,r,e),a=a.tail,u=m}else{const m=u.nextSibling;u.remove(),u=m}for(;a.head;)e.appendChild(E(null,a.head,r,e)),a=a.tail}return e}function M(e,t,n,r){switch(typeof n){case"string":e.getAttribute(t)!==n&&e.setAttribute(t,n),n===""&&e.removeAttribute(t),t==="value"&&e.value!==n&&(e.value=n);break;case(t.startsWith("on")&&"function"):{if(e.$lustre[t]===n)break;const s=t.slice(2).toLowerCase(),i=o=>at(n(o),r);e.$lustre[`${t}Handler`]&&e.removeEventListener(s,e.$lustre[`${t}Handler`]),e.addEventListener(s,i),e.$lustre[t]=n,e.$lustre[`${t}Handler`]=i;break}default:e[t]=n}}function $t(e,t){const n=document.createTextNode(t[0]);return e&&e.replaceWith(n),n}function wt(e,t){const n=e.nodeValue,r=t[0];return r?(n!==r&&(e.nodeValue=r),e):(e==null||e.remove(),null)}var d,g,y,_,w,S,j,k,C,P,T,U;class Et{constructor(t,n,r){h(this,C);h(this,T);h(this,d,null);h(this,g,null);h(this,y,[]);h(this,_,[]);h(this,w,!1);h(this,S,null);h(this,j,null);h(this,k,null);f(this,S,t),f(this,j,n),f(this,k,r)}start(t,n){if(!jt())return new I(new It);if(c(this,d))return new I(new St);if(f(this,d,t instanceof HTMLElement?t:document.querySelector(t)),!c(this,d))return new I(new Tt);const[r,s]=c(this,S).call(this,n);return f(this,g,r),f(this,_,s[0].toArray()),f(this,w,!0),window.requestAnimationFrame(()=>N(this,C,P).call(this)),new et(i=>this.dispatch(i))}dispatch(t){c(this,y).push(t),N(this,C,P).call(this)}emit(t,n=null){c(this,d).dispatchEvent(new CustomEvent(t,{bubbles:!0,detail:n,composed:!0}))}destroy(){if(!c(this,d))return new I(new Ct);c(this,d).remove(),f(this,d,null),f(this,g,null),f(this,y,[]),f(this,_,[]),f(this,w,!1),f(this,j,()=>{}),f(this,k,()=>{})}}d=new WeakMap,g=new WeakMap,y=new WeakMap,_=new WeakMap,w=new WeakMap,S=new WeakMap,j=new WeakMap,k=new WeakMap,C=new WeakSet,P=function(){if(N(this,T,U).call(this),c(this,w)){const t=c(this,k).call(this,c(this,g));f(this,d,E(c(this,d),t,n=>this.dispatch(n))),f(this,w,!1)}},T=new WeakSet,U=function(t=0){if(c(this,d)){if(c(this,y).length)for(;c(this,y).length;){const[n,r]=c(this,j).call(this,c(this,g),c(this,y).shift());c(this,w)||f(this,w,c(this,g)!==n),f(this,g,n),f(this,_,c(this,_).concat(r[0].toArray()))}for(;c(this,_).length;)c(this,_).shift()(n=>this.dispatch(n),(n,r)=>this.emit(n,r));c(this,y).length&&(t>=5?console.warn(tooManyUpdates):N(this,T,U).call(this,++t))}};const Ot=(e,t,n)=>new Et(e,t,n),bt=(e,t,n)=>e.start(t,n),jt=()=>window&&window.document;function kt(e,t){return n=>t(e(n))}class xt extends ${constructor(t,n){super(),this[0]=t,this[1]=n}}function Lt(e,t){return new xt("on"+e,kt(t,n=>ct(n,void 0)))}class Nt extends ${constructor(t){super(),this[0]=t}}class At extends ${constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}}function F(e,t,n){return new At(e,t,n)}function D(e){return new Nt(e)}class St extends ${}class Ct extends ${}class Tt extends ${}class It extends ${}function Ft(e,t,n){return Ot(i=>[e(i),H()],(i,o)=>[t(i,o),H()],n)}function Rt(e,t){return F("body",e,t)}function Dt(e,t){return F("div",e,t)}function K(e,t){return F("p",e,t)}function Y(e,t){return F("button",e,t)}function Mt(e,t){return Lt(e,t)}function z(e){return Mt("click",t=>new et(e))}class nt{inspect(){let t=r=>{let s=L(this[r]);return isNaN(parseInt(r))?`${r}: ${s}`:s},n=Object.keys(this).map(t).join(", ");return n?`${this.constructor.name}(${n})`:this.constructor.name}withFields(t){let n=Object.keys(this).map(r=>r in t?t[r]:this[r]);return new this.constructor(...n)}}class q{static fromArray(t,n){let r=n||new Ut;return t.reduceRight((s,i)=>new Vt(i,s),r)}static isList(t){let n=t==null?void 0:t.__gleam_prelude_variant__;return n==="EmptyList"||n==="NonEmptyList"}[Symbol.iterator](){return new Pt(this)}inspect(){return`[${this.toArray().map(L).join(", ")}]`}toArray(){return[...this]}atLeastLength(t){for(let n of this){if(t<=0)return!0;t--}return t<=0}hasLength(t){for(let n of this){if(t<=0)return!1;t--}return t===0}countLength(){let t=0;for(let n of this)t++;return t}}function p(e,t){return q.fromArray(e,t)}var b;class Pt{constructor(t){h(this,b,void 0);f(this,b,t)}next(){if(c(this,b).isEmpty())return{done:!0};{let{head:t,tail:n}=c(this,b);return f(this,b,n),{value:t,done:!1}}}}b=new WeakMap;class Ut extends q{get __gleam_prelude_variant__(){return"EmptyList"}isEmpty(){return!0}}class Vt extends q{constructor(t,n){super(),this.head=t,this.tail=n}get __gleam_prelude_variant__(){return"NonEmptyList"}isEmpty(){return!1}}function L(e){let t=typeof e;if(e===!0)return"True";if(e===!1)return"False";if(e===null)return"//js(null)";if(e===void 0)return"Nil";if(t==="string")return JSON.stringify(e);if(t==="bigint"||t==="number")return e.toString();if(Array.isArray(e))return`#(${e.map(L).join(", ")})`;if(e instanceof Set)return`//js(Set(${[...e].map(L).join(", ")}))`;if(e instanceof RegExp)return`//js(${e})`;if(e instanceof Date)return`//js(Date("${e.toISOString()}"))`;if(e instanceof Function){let n=[];for(let r of Array(e.length).keys())n.push(String.fromCharCode(r+97));return`//fn(${n.join(", ")}) { ... }`}try{return e.inspect()}catch{return Wt(e)}}function Wt(e){var l,u;let[t,n]=qt(e),r=((u=(l=Object.getPrototypeOf(e))==null?void 0:l.constructor)==null?void 0:u.name)||"Object",s=[];for(let a of t(e))s.push(`${L(a)}: ${L(n(e,a))}`);let i=s.length?" "+s.join(", ")+" ":"";return`//js(${r==="Object"?"":r+" "}{${i}})`}function qt(e){if(e instanceof Map)return[t=>t.keys(),(t,n)=>t.get(n)];{let t=e instanceof globalThis.Error?["message"]:[];return[n=>[...t,...Object.keys(n)],(n,r)=>n[r]]}}function rt(e,t,n,r,s,i){let o=new globalThis.Error(s);o.gleam_error=e,o.module=t,o.line=n,o.fn=r;for(let l in i)o[l]=i[l];return o}class st extends nt{}class it extends nt{}function Ht(e){return 0}function Jt(e,t){if(t instanceof st)return e+1;if(t instanceof it)return e-1;throw rt("case_no_match","ryanbrewerdev",26,"update","No case clause matched",{values:[t]})}function Bt(e){let t=ht(e);return Rt(p([]),p([Dt(p([]),p([K(p([]),p([D(t)])),K(p([]),p([Y(p([z(new it)]),p([D("-")])),Y(p([z(new st)]),p([D("+")]))]))]))]))}function Kt(){let e=Ft(Ht,Jt,Bt),t=bt(e,"body",void 0);if(!t.isOk())throw rt("assignment_no_match","ryanbrewerdev",9,"main","Assignment pattern did not match",{value:t});return t[0]}document.addEventListener("DOMContentLoaded",()=>{Kt()});
