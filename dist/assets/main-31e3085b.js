var H=(t,e,n)=>{if(!e.has(t))throw TypeError("Cannot "+n)};var u=(t,e,n)=>(H(t,e,"read from private field"),n?n.call(t):e.get(t)),w=(t,e,n)=>{if(e.has(t))throw TypeError("Cannot add the same private member more than once");e instanceof WeakSet?e.add(t):e.set(t,n)},c=(t,e,n,s)=>(H(t,e,"write to private field"),s?s.call(t,n):e.set(t,n),n);var S=(t,e,n)=>(H(t,e,"access private method"),n);import"./style-0071f6cc.js";class y{inspect(){console.warn("Deprecated method UtfCodepoint.inspect");let e=s=>{let f=O(this[s]);return isNaN(parseInt(s))?`${s}: ${f}`:f},n=Object.keys(this).map(e).join(", ");return n?`${this.constructor.name}(${n})`:this.constructor.name}withFields(e){let n=Object.keys(this).map(s=>s in e?e[s]:this[s]);return new this.constructor(...n)}}class J{static fromArray(e,n){let s=n||new M;return e.reduceRight((f,o)=>new it(o,f),s)}[Symbol.iterator](){return new st(this)}inspect(){return console.warn("Deprecated method UtfCodepoint.inspect"),`[${this.toArray().map(O).join(", ")}]`}toArray(){return[...this]}atLeastLength(e){for(let n of this){if(e<=0)return!0;e--}return e<=0}hasLength(e){for(let n of this){if(e<=0)return!1;e--}return e===0}countLength(){let e=0;for(let n of this)e++;return e}}function r(t,e){return J.fromArray(t,e)}var k;class st{constructor(e){w(this,k,void 0);c(this,k,e)}next(){if(u(this,k)instanceof M)return{done:!0};{let{head:e,tail:n}=u(this,k);return c(this,k,n),{value:e,done:!1}}}}k=new WeakMap;class M extends J{}class it extends J{constructor(e,n){super(),this.head=e,this.tail=n}}class R extends y{static isResult(e){return e instanceof R}}class V extends R{constructor(e){super(),this[0]=e}isOk(){return!0}}class E extends R{constructor(e){super(),this[0]=e}isOk(){return!1}}function O(t){let e=typeof t;if(t===!0)return"True";if(t===!1)return"False";if(t===null)return"//js(null)";if(t===void 0)return"Nil";if(e==="string")return JSON.stringify(t);if(e==="bigint"||e==="number")return t.toString();if(Array.isArray(t))return`#(${t.map(O).join(", ")})`;if(t instanceof Set)return`//js(Set(${[...t].map(O).join(", ")}))`;if(t instanceof RegExp)return`//js(${t})`;if(t instanceof Date)return`//js(Date("${t.toISOString()}"))`;if(t instanceof Function){let n=[];for(let s of Array(t.length).keys())n.push(String.fromCharCode(s+97));return`//fn(${n.join(", ")}) { ... }`}try{return t.inspect()}catch{return rt(t)}}function rt(t){var l,a;let[e,n]=ot(t),s=((a=(l=Object.getPrototypeOf(t))==null?void 0:l.constructor)==null?void 0:a.name)||"Object",f=[];for(let h of e(t))f.push(`${O(h)}: ${O(n(t,h))}`);let o=f.length?" "+f.join(", ")+" ":"";return`//js(${s==="Object"?"":s+" "}{${o}})`}function ot(t){if(t instanceof Map)return[e=>e.keys(),(e,n)=>e.get(n)];{let e=t instanceof globalThis.Error?["message"]:[];return[n=>[...e,...Object.keys(n)],(n,s)=>n[s]]}}function W(t,e,n,s,f,o){let i=new globalThis.Error(f);i.gleam_error=t,i.module=e,i.line=n,i.fn=s;for(let l in o)i[l]=o[l];return i}function at(t,e){if(t.isOk()){let n=t[0];return new V(e(n))}else{if(t.isOk())throw W("case_no_match","gleam/result",67,"map","No case clause matched",{values:[t]});{let n=t[0];return new E(n)}}}function lt(t,e){if(t.isOk()){let n=t[0];return new V(n)}else{if(t.isOk())throw W("case_no_match","gleam/result",428,"replace_error","No case clause matched",{values:[t]});return new E(e)}}function ut(t){return t}function ht(t){return t.toString()}function ct(t){return ht(t)}function ft(t,e){return n=>e(t(n))}class dt extends y{constructor(e){super(),this.all=e}}function z(){return new dt(r([]))}function _(t,e,n,s){return e[3]?(t==null?void 0:t.nodeType)===1&&t.nodeName===e[0].toUpperCase()&&t.namespaceURI===e[3]?Q(t,e,e[3],n,s):K(t,e,e[3],n,s):e[2]?(t==null?void 0:t.nodeType)===1&&t.nodeName===e[0].toUpperCase()?Q(t,e,null,n,s):K(t,e,null,n,s):typeof(e==null?void 0:e[0])=="string"?(t==null?void 0:t.nodeType)===3?wt(t,e):mt(t,e):document.createComment(["[internal lustre error] I couldn't work out how to render this element. This","function should only be called internally by lustre's runtime: if you think","this is an error, please open an issue at","https://github.com/hayleigh-dot-dev/gleam-lustre/issues/new"].join(" "))}function K(t,e,n,s,f=null){const o=n?document.createElementNS(n,e[0]):document.createElement(e[0]);o.$lustre={};let i=e[1];for(;i.head;)i.head[0]==="class"?N(o,i.head[0],`${o.className} ${i.head[1]}`):i.head[0]==="style"?N(o,i.head[0],`${o.style.cssText} ${i.head[1]}`):N(o,i.head[0],i.head[1],s),i=i.tail;if(customElements.get(e[0]))o._slot=e[2];else if(e[0]==="slot"){let l=new M,a=f;for(;a;)if(a._slot){l=a._slot;break}else a=a.parentNode;for(;l.head;)o.appendChild(_(null,l.head,s,o)),l=l.tail}else{let l=e[2];for(;l.head;)o.appendChild(_(null,l.head,s,o)),l=l.tail}return t&&t.replaceWith(o),o}function Q(t,e,n,s,f){const o=t.attributes,i=new Map;t.$lustre??(t.$lustre={});let l=e[1];for(;l.head;)l.head[0]==="class"&&i.has("class")?i.set(l.head[0],`${i.get("class")} ${l.head[1]}`):l.head[0]==="style"&&i.has("style")?i.set(l.head[0],`${i.get("style")} ${l.head[1]}`):i.set(l.head[0],l.head[1]),l=l.tail;for(const{name:a,value:h}of o)if(!i.has(a))t.removeAttribute(a);else{const m=i.get(a);m!==h&&(N(t,a,m,s),i.delete(a))}for(const[a,h]of i)N(t,a,h,s);if(customElements.get(e[0]))t._slot=e[2];else if(e[0]==="slot"){let a=t.firstChild,h=new M,m=f;for(;m;)if(m._slot){h=m._slot;break}else m=m.parentNode;for(;a;)h.head&&(_(a,h.head,s,t),h=h.tail),a=a.nextSibling;for(;h.head;)t.appendChild(_(null,h.head,s,t)),h=h.tail}else{let a=t.firstChild,h=e[2];for(;a;)if(h.head){const m=a.nextSibling;_(a,h.head,s,t),h=h.tail,a=m}else{const m=a.nextSibling;a.remove(),a=m}for(;h.head;)t.appendChild(_(null,h.head,s,t)),h=h.tail}return t}function N(t,e,n,s){switch(typeof n){case"string":t.getAttribute(e)!==n&&t.setAttribute(e,n),n===""&&t.removeAttribute(e),e==="value"&&t.value!==n&&(t.value=n);break;case(e.startsWith("on")&&"function"):{if(t.$lustre[e]===n)break;const f=e.slice(2).toLowerCase(),o=i=>at(n(i),s);t.$lustre[`${e}Handler`]&&t.removeEventListener(f,t.$lustre[`${e}Handler`]),t.addEventListener(f,o),t.$lustre[e]=n,t.$lustre[`${e}Handler`]=o;break}default:t[e]=n}}function mt(t,e){const n=document.createTextNode(e[0]);return t&&t.replaceWith(n),n}function wt(t,e){const n=t.nodeValue,s=e[0];return s?(n!==s&&(t.nodeValue=s),t):(t==null||t.remove(),null)}var d,b,g,$,x,T,j,C,L,P,I,G;class yt{constructor(e,n,s){w(this,L);w(this,I);w(this,d,null);w(this,b,null);w(this,g,[]);w(this,$,[]);w(this,x,!1);w(this,T,null);w(this,j,null);w(this,C,null);c(this,T,e),c(this,j,n),c(this,C,s)}start(e,n){if(!gt())return new E(new Ot);if(u(this,d))return new E(new Et);if(c(this,d,e instanceof HTMLElement?e:document.querySelector(e)),!u(this,d))return new E(new Ct);const[s,f]=u(this,T).call(this,n);return c(this,b,s),c(this,$,f.all.toArray()),c(this,x,!0),window.requestAnimationFrame(()=>S(this,L,P).call(this)),new V(o=>this.dispatch(o))}dispatch(e){u(this,g).push(e),S(this,L,P).call(this)}emit(e,n=null){u(this,d).dispatchEvent(new CustomEvent(e,{bubbles:!0,detail:n,composed:!0}))}destroy(){if(!u(this,d))return new E(new jt);u(this,d).remove(),c(this,d,null),c(this,b,null),c(this,g,[]),c(this,$,[]),c(this,x,!1),c(this,j,()=>{}),c(this,C,()=>{})}}d=new WeakMap,b=new WeakMap,g=new WeakMap,$=new WeakMap,x=new WeakMap,T=new WeakMap,j=new WeakMap,C=new WeakMap,L=new WeakSet,P=function(){if(S(this,I,G).call(this),u(this,x)){const e=u(this,C).call(this,u(this,b));c(this,d,_(u(this,d),e,n=>this.dispatch(n))),c(this,x,!1)}},I=new WeakSet,G=function(e=0){if(u(this,d)){if(u(this,g).length)for(;u(this,g).length;){const[n,s]=u(this,j).call(this,u(this,b),u(this,g).shift());u(this,x)||c(this,x,u(this,b)!==n),c(this,b,n),c(this,$,u(this,$).concat(s.all.toArray()))}for(;u(this,$).length;)u(this,$).shift()(n=>this.dispatch(n),(n,s)=>this.emit(n,s));u(this,g).length&&(e>=5?console.warn(tooManyUpdates):S(this,I,G).call(this,++e))}};const pt=(t,e,n)=>new yt(t,e,n),bt=(t,e,n)=>t.start(e,n),gt=()=>window&&window.document;class $t extends y{constructor(e,n,s){super(),this[0]=e,this[1]=n,this.as_property=s}}class xt extends y{constructor(e,n){super(),this[0]=e,this[1]=n}}function Y(t,e){return new $t(t,ut(e),!1)}function _t(t,e){return new xt("on"+t,ft(e,n=>lt(n,void 0)))}function X(t){return Y("id",t)}function U(t){return Y("href",t)}function q(t){return Y("src",t)}class kt extends y{constructor(e){super(),this[0]=e}}class At extends y{constructor(e,n,s){super(),this[0]=e,this[1]=n,this[2]=s}}function A(t,e,n){return new At(t,e,n)}function p(t){return new kt(t)}class Et extends y{}class jt extends y{}class Ct extends y{}class Ot extends y{}function St(t,e,n){return pt(o=>[t(o),z()],(o,i)=>[e(o,i),z()],n)}function Nt(t,e){return A("body",t,e)}function Tt(t,e){return A("nav",t,e)}function Z(t,e){return A("div",t,e)}function D(t,e){return A("p",t,e)}function F(t,e){return A("a",t,e)}function B(t,e){return A("script",t,r([p(e)]))}function v(t,e){return A("button",t,e)}function Lt(t,e){return _t(t,e)}function tt(t){return Lt("click",e=>new V(t))}class et extends y{}class nt extends y{}function It(t){return 0}function Ut(t,e){if(e instanceof et)return t+1;if(e instanceof nt)return t-1;throw W("case_no_match","ryanbrewerdev",28,"update","No case clause matched",{values:[e]})}function Dt(t){let e=ct(t);return Nt(r([]),r([Z(r([]),r([Tt(r([]),r([F(r([U("/")]),r([p("Ryan Brewer")])),F(r([U("/search"),X("nav-search")]),r([p("Search Posts")]))])),Z(r([X("body")]),r([D(r([]),r([p("This is my website. It's hosted by Firebase and written mostly in Gleam, and the code is up on "),F(r([U("https://github.com/RyanBrewer317/ryanbrewer-dev")]),r([p("my github")])),p(".")])),D(r([]),r([p(e)])),D(r([]),r([v(r([tt(new nt)]),r([p("-")])),v(r([tt(new et)]),r([p("+")]))])),D(r([]),r([F(r([U("https://ryanbrewer.dev/posts/logic-in-types.html")]),r([p("My first post!")]))]))]))])),B(r([q("/__/firebase/8.10.1/firebase-app.js")]),""),B(r([q("/__/firebase/8.10.1/firebase-analytics.js")]),""),B(r([q("/__/firebase/init.js")]),"")]))}function Ft(){let t=St(It,Ut,Dt),e=bt(t,"body",void 0);if(!e.isOk())throw W("assignment_no_match","ryanbrewerdev",10,"main","Assignment pattern did not match",{value:e});return e[0]}document.addEventListener("DOMContentLoaded",()=>{Ft()});