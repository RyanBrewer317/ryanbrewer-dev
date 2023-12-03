var R=(t,e,n)=>{if(!e.has(t))throw TypeError("Cannot "+n)};var l=(t,e,n)=>(R(t,e,"read from private field"),n?n.call(t):e.get(t)),w=(t,e,n)=>{if(e.has(t))throw TypeError("Cannot add the same private member more than once");e instanceof WeakSet?e.add(t):e.set(t,n)},c=(t,e,n,s)=>(R(t,e,"write to private field"),s?s.call(t,n):e.set(t,n),n);var j=(t,e,n)=>(R(t,e,"access private method"),n);import"./style-4e1c3e3e.js";class p{inspect(){console.warn("Deprecated method UtfCodepoint.inspect");let e=s=>{let f=N(this[s]);return isNaN(parseInt(s))?`${s}: ${f}`:f},n=Object.keys(this).map(e).join(", ");return n?`${this.constructor.name}(${n})`:this.constructor.name}withFields(e){let n=Object.keys(this).map(s=>s in e?e[s]:this[s]);return new this.constructor(...n)}}class q{static fromArray(e,n){let s=n||new I;return e.reduceRight((f,i)=>new et(i,f),s)}[Symbol.iterator](){return new tt(this)}inspect(){return console.warn("Deprecated method UtfCodepoint.inspect"),`[${this.toArray().map(N).join(", ")}]`}toArray(){return[...this]}atLeastLength(e){for(let n of this){if(e<=0)return!0;e--}return e<=0}hasLength(e){for(let n of this){if(e<=0)return!1;e--}return e===0}countLength(){let e=0;for(let n of this)e++;return e}}function h(t,e){return q.fromArray(t,e)}var _;class tt{constructor(e){w(this,_,void 0);c(this,_,e)}next(){if(l(this,_)instanceof I)return{done:!0};{let{head:e,tail:n}=l(this,_);return c(this,_,n),{value:e,done:!1}}}}_=new WeakMap;class I extends q{}class et extends q{constructor(e,n){super(),this.head=e,this.tail=n}}class U extends p{static isResult(e){return e instanceof U}}class D extends U{constructor(e){super(),this[0]=e}isOk(){return!0}}class A extends U{constructor(e){super(),this[0]=e}isOk(){return!1}}function N(t){let e=typeof t;if(t===!0)return"True";if(t===!1)return"False";if(t===null)return"//js(null)";if(t===void 0)return"Nil";if(e==="string")return JSON.stringify(t);if(e==="bigint"||e==="number")return t.toString();if(Array.isArray(t))return`#(${t.map(N).join(", ")})`;if(t instanceof Set)return`//js(Set(${[...t].map(N).join(", ")}))`;if(t instanceof RegExp)return`//js(${t})`;if(t instanceof Date)return`//js(Date("${t.toISOString()}"))`;if(t instanceof Function){let n=[];for(let s of Array(t.length).keys())n.push(String.fromCharCode(s+97));return`//fn(${n.join(", ")}) { ... }`}try{return t.inspect()}catch{return nt(t)}}function nt(t){var u,r;let[e,n]=st(t),s=((r=(u=Object.getPrototypeOf(t))==null?void 0:u.constructor)==null?void 0:r.name)||"Object",f=[];for(let a of e(t))f.push(`${N(a)}: ${N(n(t,a))}`);let i=f.length?" "+f.join(", ")+" ":"";return`//js(${s==="Object"?"":s+" "}{${i}})`}function st(t){if(t instanceof Map)return[e=>e.keys(),(e,n)=>e.get(n)];{let e=t instanceof globalThis.Error?["message"]:[];return[n=>[...e,...Object.keys(n)],(n,s)=>n[s]]}}function F(t,e,n,s,f,i){let o=new globalThis.Error(f);o.gleam_error=t,o.module=e,o.line=n,o.fn=s;for(let u in i)o[u]=i[u];return o}function it(t,e){if(t.isOk()){let n=t[0];return new D(e(n))}else{if(t.isOk())throw F("case_no_match","gleam/result",67,"map","No case clause matched",{values:[t]});{let n=t[0];return new A(n)}}}function rt(t,e){if(t.isOk()){let n=t[0];return new D(n)}else{if(t.isOk())throw F("case_no_match","gleam/result",428,"replace_error","No case clause matched",{values:[t]});return new A(e)}}function ot(t){return t}function lt(t){return t.toString()}function at(t){return lt(t)}class ut extends p{constructor(e){super(),this[0]=e}}function B(){return new ut(h([]))}function k(t,e,n,s){return e[3]?(t==null?void 0:t.nodeType)===1&&t.nodeName===e[0].toUpperCase()&&t.namespaceURI===e[3]?J(t,e,e[3],n,s):G(t,e,e[3],n,s):e[2]?(t==null?void 0:t.nodeType)===1&&t.nodeName===e[0].toUpperCase()?J(t,e,null,n,s):G(t,e,null,n,s):typeof(e==null?void 0:e[0])=="string"?(t==null?void 0:t.nodeType)===3?ct(t,e):ht(t,e):document.createComment(["[internal lustre error] I couldn't work out how to render this element. This","function should only be called internally by lustre's runtime: if you think","this is an error, please open an issue at","https://github.com/hayleigh-dot-dev/gleam-lustre/issues/new"].join(" "))}function G(t,e,n,s,f=null){const i=n?document.createElementNS(n,e[0]):document.createElement(e[0]);i.$lustre={};let o=e[1];for(;o.head;)V(i,o.head[0],o.head[0]==="class"&&i.className?`${i.className} ${o.head[1]}`:o.head[1],s),o=o.tail;if(customElements.get(e[0]))i._slot=e[2];else if(e[0]==="slot"){let u=new I,r=f;for(;r;)if(r._slot){u=r._slot;break}else r=r.parentNode;for(;u.head;)i.appendChild(k(null,u.head,s,i)),u=u.tail}else{let u=e[2];for(;u.head;)i.appendChild(k(null,u.head,s,i)),u=u.tail;t&&t.replaceWith(i)}return i}function J(t,e,n,s,f){const i=t.attributes,o=new Map;let u=e[1];for(;u.head;)o.set(u.head[0],u.head[0]==="class"&&o.has("class")?`${o.get("class")} ${u.head[1]}`:u.head[1]),u=u.tail;for(const{name:r,value:a}of i)if(!o.has(r))t.removeAttribute(r);else{const m=o.get(r);m!==a&&(V(t,r,m,s),o.delete(r))}for(const[r,a]of o)V(t,r,a,s);if(customElements.get(e[0]))t._slot=e[2];else if(e[0]==="slot"){let r=t.firstChild,a=new I,m=f;for(;m;)if(m._slot){a=m._slot;break}else m=m.parentNode;for(;r;)a.head&&(k(r,a.head,s,t),a=a.tail),r=r.nextSibling;for(;a.head;)t.appendChild(k(null,a.head,s,t)),a=a.tail}else{let r=t.firstChild,a=e[2];for(;r;)if(a.head){const m=r.nextSibling;k(r,a.head,s,t),a=a.tail,r=m}else{const m=r.nextSibling;r.remove(),r=m}for(;a.head;)t.appendChild(k(null,a.head,s,t)),a=a.tail}return t}function V(t,e,n,s){switch(typeof n){case"string":t.getAttribute(e)!==n&&t.setAttribute(e,n),n===""&&t.removeAttribute(e),e==="value"&&t.value!==n&&(t.value=n);break;case(e.startsWith("on")&&"function"):{if(t.$lustre[e]===n)break;const f=e.slice(2).toLowerCase(),i=o=>it(n(o),s);t.$lustre[`${e}Handler`]&&t.removeEventListener(f,t.$lustre[`${e}Handler`]),t.addEventListener(f,i),t.$lustre[e]=n,t.$lustre[`${e}Handler`]=i;break}default:t[e]=n}}function ht(t,e){const n=document.createTextNode(e[0]);return t&&t.replaceWith(n),n}function ct(t,e){const n=t.nodeValue,s=e[0];return s?(n!==s&&(t.nodeValue=s),t):(t==null||t.remove(),null)}var d,y,g,b,$,S,E,C,T,W,L,H;class ft{constructor(e,n,s){w(this,T);w(this,L);w(this,d,null);w(this,y,null);w(this,g,[]);w(this,b,[]);w(this,$,!1);w(this,S,null);w(this,E,null);w(this,C,null);c(this,S,e),c(this,E,n),c(this,C,s)}start(e,n){if(!wt())return new A(new Ct);if(l(this,d))return new A(new _t);if(c(this,d,e instanceof HTMLElement?e:document.querySelector(e)),!l(this,d))return new A(new Et);const[s,f]=l(this,S).call(this,n);return c(this,y,s),c(this,b,f[0].toArray()),c(this,$,!0),window.requestAnimationFrame(()=>j(this,T,W).call(this)),new D(i=>this.dispatch(i))}dispatch(e){l(this,g).push(e),j(this,T,W).call(this)}emit(e,n=null){l(this,d).dispatchEvent(new CustomEvent(e,{bubbles:!0,detail:n,composed:!0}))}destroy(){if(!l(this,d))return new A(new At);l(this,d).remove(),c(this,d,null),c(this,y,null),c(this,g,[]),c(this,b,[]),c(this,$,!1),c(this,E,()=>{}),c(this,C,()=>{})}}d=new WeakMap,y=new WeakMap,g=new WeakMap,b=new WeakMap,$=new WeakMap,S=new WeakMap,E=new WeakMap,C=new WeakMap,T=new WeakSet,W=function(){if(j(this,L,H).call(this),l(this,$)){const e=l(this,C).call(this,l(this,y));c(this,d,k(l(this,d),e,n=>this.dispatch(n))),c(this,$,!1)}},L=new WeakSet,H=function(e=0){if(l(this,d)){if(l(this,g).length)for(;l(this,g).length;){const[n,s]=l(this,E).call(this,l(this,y),l(this,g).shift());l(this,$)||c(this,$,l(this,y)!==n),c(this,y,n),c(this,b,l(this,b).concat(s[0].toArray()))}for(;l(this,b).length;)l(this,b).shift()(n=>this.dispatch(n),(n,s)=>this.emit(n,s));l(this,g).length&&(e>=5?console.warn(tooManyUpdates):j(this,L,H).call(this,++e))}};const dt=(t,e,n)=>new ft(t,e,n),mt=(t,e,n)=>t.start(e,n),wt=()=>window&&window.document;function pt(t,e){return n=>e(t(n))}class yt extends p{constructor(e,n,s){super(),this[0]=e,this[1]=n,this.as_property=s}}class gt extends p{constructor(e,n){super(),this[0]=e,this[1]=n}}function X(t,e){return new yt(t,ot(e),!1)}function bt(t,e){return new gt("on"+t,pt(e,n=>rt(n,void 0)))}function $t(t){return X("id",t)}function P(t){return X("href",t)}class xt extends p{constructor(e){super(),this[0]=e}}class kt extends p{constructor(e,n,s){super(),this[0]=e,this[1]=n,this[2]=s}}function O(t,e,n){return new kt(t,e,n)}function x(t){return new xt(t)}class _t extends p{}class At extends p{}class Et extends p{}class Ct extends p{}function Nt(t,e,n){return dt(i=>[t(i),B()],(i,o)=>[e(i,o),B()],n)}function Ot(t,e){return O("body",t,e)}function jt(t,e){return O("nav",t,e)}function Y(t,e){return O("div",t,e)}function M(t,e){return O("p",t,e)}function z(t,e){return O("a",t,e)}function K(t,e){return O("button",t,e)}function St(t,e){return bt(t,e)}function Q(t){return St("click",e=>new D(t))}class Z extends p{}class v extends p{}function Tt(t){return 0}function Lt(t,e){if(e instanceof Z)return t+1;if(e instanceof v)return t-1;throw F("case_no_match","ryanbrewerdev",28,"update","No case clause matched",{values:[e]})}function It(t){let e=at(t);return Ot(h([]),h([Y(h([]),h([jt(h([]),h([z(h([P("https://ryanbrewer.dev")]),h([x("Ryan Brewer")]))])),Y(h([$t("body")]),h([M(h([]),h([x("This is my website. It's hosted by Firebase and written mostly in Gleam, and the code is up on "),z(h([P("https://github.com/RyanBrewer317/ryanbrewer-dev")]),h([x("my github")])),x(".")])),M(h([]),h([x(e)])),M(h([]),h([K(h([Q(new v)]),h([x("-")])),K(h([Q(new Z)]),h([x("+")]))]))]))]))]))}function Ut(){let t=Nt(Tt,Lt,It),e=mt(t,"body",void 0);if(!e.isOk())throw F("assignment_no_match","ryanbrewerdev",10,"main","Assignment pattern did not match",{value:e});return e[0]}document.addEventListener("DOMContentLoaded",()=>{Ut()});