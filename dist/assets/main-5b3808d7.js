var V=(t,e,n)=>{if(!e.has(t))throw TypeError("Cannot "+n)};var u=(t,e,n)=>(V(t,e,"read from private field"),n?n.call(t):e.get(t)),w=(t,e,n)=>{if(e.has(t))throw TypeError("Cannot add the same private member more than once");e instanceof WeakSet?e.add(t):e.set(t,n)},c=(t,e,n,s)=>(V(t,e,"write to private field"),s?s.call(t,n):e.set(t,n),n);var N=(t,e,n)=>(V(t,e,"access private method"),n);import"./style-de04a900.js";class y{inspect(){console.warn("Deprecated method UtfCodepoint.inspect");let e=s=>{let f=O(this[s]);return isNaN(parseInt(s))?`${s}: ${f}`:f},n=Object.keys(this).map(e).join(", ");return n?`${this.constructor.name}(${n})`:this.constructor.name}withFields(e){let n=Object.keys(this).map(s=>s in e?e[s]:this[s]);return new this.constructor(...n)}}class P{static fromArray(e,n){let s=n||new D;return e.reduceRight((f,r)=>new st(r,f),s)}[Symbol.iterator](){return new nt(this)}inspect(){return console.warn("Deprecated method UtfCodepoint.inspect"),`[${this.toArray().map(O).join(", ")}]`}toArray(){return[...this]}atLeastLength(e){for(let n of this){if(e<=0)return!0;e--}return e<=0}hasLength(e){for(let n of this){if(e<=0)return!1;e--}return e===0}countLength(){let e=0;for(let n of this)e++;return e}}function o(t,e){return P.fromArray(t,e)}var k;class nt{constructor(e){w(this,k,void 0);c(this,k,e)}next(){if(u(this,k)instanceof D)return{done:!0};{let{head:e,tail:n}=u(this,k);return c(this,k,n),{value:e,done:!1}}}}k=new WeakMap;class D extends P{}class st extends P{constructor(e,n){super(),this.head=e,this.tail=n}}class F extends y{static isResult(e){return e instanceof F}}class M extends F{constructor(e){super(),this[0]=e}isOk(){return!0}}class E extends F{constructor(e){super(),this[0]=e}isOk(){return!1}}function O(t){let e=typeof t;if(t===!0)return"True";if(t===!1)return"False";if(t===null)return"//js(null)";if(t===void 0)return"Nil";if(e==="string")return JSON.stringify(t);if(e==="bigint"||e==="number")return t.toString();if(Array.isArray(t))return`#(${t.map(O).join(", ")})`;if(t instanceof Set)return`//js(Set(${[...t].map(O).join(", ")}))`;if(t instanceof RegExp)return`//js(${t})`;if(t instanceof Date)return`//js(Date("${t.toISOString()}"))`;if(t instanceof Function){let n=[];for(let s of Array(t.length).keys())n.push(String.fromCharCode(s+97));return`//fn(${n.join(", ")}) { ... }`}try{return t.inspect()}catch{return it(t)}}function it(t){var a,l;let[e,n]=rt(t),s=((l=(a=Object.getPrototypeOf(t))==null?void 0:a.constructor)==null?void 0:l.name)||"Object",f=[];for(let h of e(t))f.push(`${O(h)}: ${O(n(t,h))}`);let r=f.length?" "+f.join(", ")+" ":"";return`//js(${s==="Object"?"":s+" "}{${r}})`}function rt(t){if(t instanceof Map)return[e=>e.keys(),(e,n)=>e.get(n)];{let e=t instanceof globalThis.Error?["message"]:[];return[n=>[...e,...Object.keys(n)],(n,s)=>n[s]]}}function R(t,e,n,s,f,r){let i=new globalThis.Error(f);i.gleam_error=t,i.module=e,i.line=n,i.fn=s;for(let a in r)i[a]=r[a];return i}function ot(t,e){if(t.isOk()){let n=t[0];return new M(e(n))}else{if(t.isOk())throw R("case_no_match","gleam/result",67,"map","No case clause matched",{values:[t]});{let n=t[0];return new E(n)}}}function lt(t,e){if(t.isOk()){let n=t[0];return new M(n)}else{if(t.isOk())throw R("case_no_match","gleam/result",428,"replace_error","No case clause matched",{values:[t]});return new E(e)}}function at(t){return t}function ut(t){return t.toString()}function ht(t){return ut(t)}function ct(t,e){return n=>e(t(n))}class ft extends y{constructor(e){super(),this.all=e}}function z(){return new ft(o([]))}function _(t,e,n,s){return e[3]?(t==null?void 0:t.nodeType)===1&&t.nodeName===e[0].toUpperCase()&&t.namespaceURI===e[3]?Q(t,e,e[3],n,s):K(t,e,e[3],n,s):e[2]?(t==null?void 0:t.nodeType)===1&&t.nodeName===e[0].toUpperCase()?Q(t,e,null,n,s):K(t,e,null,n,s):typeof(e==null?void 0:e[0])=="string"?(t==null?void 0:t.nodeType)===3?mt(t,e):dt(t,e):document.createComment(["[internal lustre error] I couldn't work out how to render this element. This","function should only be called internally by lustre's runtime: if you think","this is an error, please open an issue at","https://github.com/hayleigh-dot-dev/gleam-lustre/issues/new"].join(" "))}function K(t,e,n,s,f=null){const r=n?document.createElementNS(n,e[0]):document.createElement(e[0]);r.$lustre={};let i=e[1];for(;i.head;)i.head[0]==="class"?S(r,i.head[0],`${r.className} ${i.head[1]}`):i.head[0]==="style"?S(r,i.head[0],`${r.style.cssText} ${i.head[1]}`):S(r,i.head[0],i.head[1],s),i=i.tail;if(customElements.get(e[0]))r._slot=e[2];else if(e[0]==="slot"){let a=new D,l=f;for(;l;)if(l._slot){a=l._slot;break}else l=l.parentNode;for(;a.head;)r.appendChild(_(null,a.head,s,r)),a=a.tail}else{let a=e[2];for(;a.head;)r.appendChild(_(null,a.head,s,r)),a=a.tail}return t&&t.replaceWith(r),r}function Q(t,e,n,s,f){const r=t.attributes,i=new Map;t.$lustre??(t.$lustre={});let a=e[1];for(;a.head;)a.head[0]==="class"&&i.has("class")?i.set(a.head[0],`${i.get("class")} ${a.head[1]}`):a.head[0]==="style"&&i.has("style")?i.set(a.head[0],`${i.get("style")} ${a.head[1]}`):i.set(a.head[0],a.head[1]),a=a.tail;for(const{name:l,value:h}of r)if(!i.has(l))t.removeAttribute(l);else{const m=i.get(l);m!==h&&(S(t,l,m,s),i.delete(l))}for(const[l,h]of i)S(t,l,h,s);if(customElements.get(e[0]))t._slot=e[2];else if(e[0]==="slot"){let l=t.firstChild,h=new D,m=f;for(;m;)if(m._slot){h=m._slot;break}else m=m.parentNode;for(;l;)h.head&&(_(l,h.head,s,t),h=h.tail),l=l.nextSibling;for(;h.head;)t.appendChild(_(null,h.head,s,t)),h=h.tail}else{let l=t.firstChild,h=e[2];for(;l;)if(h.head){const m=l.nextSibling;_(l,h.head,s,t),h=h.tail,l=m}else{const m=l.nextSibling;l.remove(),l=m}for(;h.head;)t.appendChild(_(null,h.head,s,t)),h=h.tail}return t}function S(t,e,n,s){switch(typeof n){case"string":t.getAttribute(e)!==n&&t.setAttribute(e,n),n===""&&t.removeAttribute(e),e==="value"&&t.value!==n&&(t.value=n);break;case(e.startsWith("on")&&"function"):{if(t.$lustre[e]===n)break;const f=e.slice(2).toLowerCase(),r=i=>ot(n(i),s);t.$lustre[`${e}Handler`]&&t.removeEventListener(f,t.$lustre[`${e}Handler`]),t.addEventListener(f,r),t.$lustre[e]=n,t.$lustre[`${e}Handler`]=r;break}default:t[e]=n}}function dt(t,e){const n=document.createTextNode(e[0]);return t&&t.replaceWith(n),n}function mt(t,e){const n=t.nodeValue,s=e[0];return s?(n!==s&&(t.nodeValue=s),t):(t==null||t.remove(),null)}var d,b,g,$,x,T,j,C,L,G,I,J;class wt{constructor(e,n,s){w(this,L);w(this,I);w(this,d,null);w(this,b,null);w(this,g,[]);w(this,$,[]);w(this,x,!1);w(this,T,null);w(this,j,null);w(this,C,null);c(this,T,e),c(this,j,n),c(this,C,s)}start(e,n){if(!bt())return new E(new Ot);if(u(this,d))return new E(new Et);if(c(this,d,e instanceof HTMLElement?e:document.querySelector(e)),!u(this,d))return new E(new Ct);const[s,f]=u(this,T).call(this,n);return c(this,b,s),c(this,$,f.all.toArray()),c(this,x,!0),window.requestAnimationFrame(()=>N(this,L,G).call(this)),new M(r=>this.dispatch(r))}dispatch(e){u(this,g).push(e),N(this,L,G).call(this)}emit(e,n=null){u(this,d).dispatchEvent(new CustomEvent(e,{bubbles:!0,detail:n,composed:!0}))}destroy(){if(!u(this,d))return new E(new jt);u(this,d).remove(),c(this,d,null),c(this,b,null),c(this,g,[]),c(this,$,[]),c(this,x,!1),c(this,j,()=>{}),c(this,C,()=>{})}}d=new WeakMap,b=new WeakMap,g=new WeakMap,$=new WeakMap,x=new WeakMap,T=new WeakMap,j=new WeakMap,C=new WeakMap,L=new WeakSet,G=function(){if(N(this,I,J).call(this),u(this,x)){const e=u(this,C).call(this,u(this,b));c(this,d,_(u(this,d),e,n=>this.dispatch(n))),c(this,x,!1)}},I=new WeakSet,J=function(e=0){if(u(this,d)){if(u(this,g).length)for(;u(this,g).length;){const[n,s]=u(this,j).call(this,u(this,b),u(this,g).shift());u(this,x)||c(this,x,u(this,b)!==n),c(this,b,n),c(this,$,u(this,$).concat(s.all.toArray()))}for(;u(this,$).length;)u(this,$).shift()(n=>this.dispatch(n),(n,s)=>this.emit(n,s));u(this,g).length&&(e>=5?console.warn(tooManyUpdates):N(this,I,J).call(this,++e))}};const yt=(t,e,n)=>new wt(t,e,n),pt=(t,e,n)=>t.start(e,n),bt=()=>window&&window.document;class gt extends y{constructor(e,n,s){super(),this[0]=e,this[1]=n,this.as_property=s}}class $t extends y{constructor(e,n){super(),this[0]=e,this[1]=n}}function Y(t,e){return new gt(t,at(e),!1)}function xt(t,e){return new $t("on"+t,ct(e,n=>lt(n,void 0)))}function _t(t){return Y("id",t)}function W(t){return Y("href",t)}function H(t){return Y("src",t)}class kt extends y{constructor(e){super(),this[0]=e}}class At extends y{constructor(e,n,s){super(),this[0]=e,this[1]=n,this[2]=s}}function A(t,e,n){return new At(t,e,n)}function p(t){return new kt(t)}class Et extends y{}class jt extends y{}class Ct extends y{}class Ot extends y{}function Nt(t,e,n){return yt(r=>[t(r),z()],(r,i)=>[e(r,i),z()],n)}function St(t,e){return A("body",t,e)}function Tt(t,e){return A("nav",t,e)}function X(t,e){return A("div",t,e)}function U(t,e){return A("p",t,e)}function q(t,e){return A("a",t,e)}function B(t,e){return A("script",t,o([p(e)]))}function Z(t,e){return A("button",t,e)}function Lt(t,e){return xt(t,e)}function v(t){return Lt("click",e=>new M(t))}class tt extends y{}class et extends y{}function It(t){return 0}function Ut(t,e){if(e instanceof tt)return t+1;if(e instanceof et)return t-1;throw R("case_no_match","ryanbrewerdev",28,"update","No case clause matched",{values:[e]})}function Dt(t){let e=ht(t);return St(o([]),o([X(o([]),o([Tt(o([]),o([q(o([W("https://ryanbrewer.dev")]),o([p("Ryan Brewer")]))])),X(o([_t("body")]),o([U(o([]),o([p("This is my website. It's hosted by Firebase and written mostly in Gleam, and the code is up on "),q(o([W("https://github.com/RyanBrewer317/ryanbrewer-dev")]),o([p("my github")])),p(".")])),U(o([]),o([p(e)])),U(o([]),o([Z(o([v(new et)]),o([p("-")])),Z(o([v(new tt)]),o([p("+")]))])),U(o([]),o([q(o([W("https://ryanbrewer.dev/posts/logic-in-types.html")]),o([p("My first post!")]))]))]))])),B(o([H("/__/firebase/8.10.1/firebase-app.js")]),""),B(o([H("/__/firebase/8.10.1/firebase-analytics.js")]),""),B(o([H("/__/firebase/init.js")]),"")]))}function Ft(){let t=Nt(It,Ut,Dt),e=pt(t,"body",void 0);if(!e.isOk())throw R("assignment_no_match","ryanbrewerdev",10,"main","Assignment pattern did not match",{value:e});return e[0]}document.addEventListener("DOMContentLoaded",()=>{Ft()});