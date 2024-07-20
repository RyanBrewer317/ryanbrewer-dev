var ne=(e,t,n)=>{if(!t.has(e))throw TypeError("Cannot "+n)};var a=(e,t,n)=>(ne(e,t,"read from private field"),n?n.call(e):t.get(e)),_=(e,t,n)=>{if(t.has(e))throw TypeError("Cannot add the same private member more than once");t instanceof WeakSet?t.add(e):t.set(e,n)},h=(e,t,n,r)=>(ne(e,t,"write to private field"),r?r.call(e,n):t.set(e,n),n);var W=(e,t,n)=>(ne(e,t,"access private method"),n);class b{withFields(t){let n=Object.keys(this).map(r=>r in t?t[r]:this[r]);return new this.constructor(...n)}}class j{static fromArray(t,n){let r=n||new v;for(let s=t.length-1;s>=0;--s)r=new Ie(t[s],r);return r}[Symbol.iterator](){return new We(this)}toArray(){return[...this]}atLeastLength(t){for(let n of this){if(t<=0)return!0;t--}return t<=0}hasLength(t){for(let n of this){if(t<=0)return!1;t--}return t===0}countLength(){let t=0;for(let n of this)t++;return t}}function oe(e,t){return new Ie(e,t)}function c(e,t){return j.fromArray(e,t)}var q;class We{constructor(t){_(this,q,void 0);h(this,q,t)}next(){if(a(this,q)instanceof v)return{done:!0};{let{head:t,tail:n}=a(this,q);return h(this,q,n),{value:t,done:!1}}}}q=new WeakMap;class v extends j{}class Ie extends j{constructor(t,n){super(),this.head=t,this.tail=n}}class Q{constructor(t){if(!(t instanceof Uint8Array))throw"BitArray can only be constructed from a Uint8Array";this.buffer=t}get length(){return this.buffer.length}byteAt(t){return this.buffer[t]}floatAt(t){return Pe(this.buffer.slice(t,t+8))}intFromSlice(t,n){return Be(this.buffer.slice(t,n))}binaryFromSlice(t,n){return new Q(this.buffer.slice(t,n))}sliceAfter(t){return new Q(this.buffer.slice(t))}}function Be(e){e=e.reverse();let t=0;for(let n=e.length-1;n>=0;n--)t=t*256+e[n];return t}function Pe(e){return new Float64Array(e.reverse().buffer)[0]}class X extends b{static isResult(t){return t instanceof X}}class m extends X{constructor(t){super(),this[0]=t}isOk(){return!0}}class y extends X{constructor(t){super(),this[0]=t}isOk(){return!1}}function L(e,t){let n=[e,t];for(;n.length;){let r=n.pop(),s=n.pop();if(r===s)continue;if(!Ee(r)||!Ee(s)||!Ze(r,s)||Ye(r,s)||Ke(r,s)||Xe(r,s)||Ge(r,s)||Je(r,s)||Qe(r,s))return!1;const i=Object.getPrototypeOf(r);if(i!==null&&typeof i.equals=="function")try{if(r.equals(s))continue;return!1}catch{}let[f,l]=Ve(r);for(let o of f(r))n.push(l(r,o),l(s,o))}return!0}function Ve(e){if(e instanceof Map)return[t=>t.keys(),(t,n)=>t.get(n)];{let t=e instanceof globalThis.Error?["message"]:[];return[n=>[...t,...Object.keys(n)],(n,r)=>n[r]]}}function Ye(e,t){return e instanceof Date&&(e>t||e<t)}function Ke(e,t){return e.buffer instanceof ArrayBuffer&&e.BYTES_PER_ELEMENT&&!(e.byteLength===t.byteLength&&e.every((n,r)=>n===t[r]))}function Xe(e,t){return Array.isArray(e)&&e.length!==t.length}function Ge(e,t){return e instanceof Map&&e.size!==t.size}function Je(e,t){return e instanceof Set&&(e.size!=t.size||[...e].some(n=>!t.has(n)))}function Qe(e,t){return e instanceof RegExp&&(e.source!==t.source||e.flags!==t.flags)}function Ee(e){return typeof e=="object"&&e!==null}function Ze(e,t){return typeof e!="object"&&typeof t!="object"&&(!e||!t)||[Promise,WeakSet,WeakMap,Function].some(r=>e instanceof r)?!1:e.constructor===t.constructor}function vt(e,t,n,r,s,u){let i=new globalThis.Error(s);i.gleam_error=e,i.module=t,i.line=n,i.fn=r;for(let f in u)i[f]=u[f];return i}class P extends b{constructor(t){super(),this[0]=t}}class ie extends b{}function ve(e,t){if(e instanceof P){let n=e[0];return new m(n)}else return new y(t)}function en(e,t){if(e instanceof P){let n=e[0];return new P(t(n))}else return new ie}function tn(e){return zt(e)}function Ce(e){return It(e)}function et(e,t){for(;;){let n=e,r=t;if(n.hasLength(0))return r;{let s=n.head;e=n.tail,t=oe(s,r)}}}function tt(e){return et(e,c([]))}function nt(e){return tt(e)}function rt(e,t,n){for(;;){let r=e,s=t,u=n;if(r.hasLength(0))return nt(u);{let i=r.head;e=r.tail,t=s,n=oe(s(i),u)}}}function st(e,t){return rt(e,t,c([]))}function it(e,t,n){for(;;){let r=e,s=t,u=n;if(r.hasLength(0))return s;{let i=r.head;e=r.tail,t=u(s,i),n=u}}}function Me(e,t){if(e.isOk()){let n=e[0];return new m(t(n))}else{let n=e[0];return new y(n)}}function ut(e,t){if(e.isOk()){let n=e[0];return new m(n)}else{let n=e[0];return new y(t(n))}}function $e(e,t){if(e.isOk()){let n=e[0];return t(n)}else{let n=e[0];return new y(n)}}function nn(e,t){return e.isOk()?e[0]:t()}function rn(e,t){return e.isOk()?e:t}function ft(e,t){if(e.isOk()){let n=e[0];return new m(n)}else return new y(t)}function lt(e){return Ct(e)}function at(e){return e}class he extends b{constructor(t,n,r){super(),this.expected=t,this.found=n,this.path=r}}function de(e){return e}function ct(e){return jt(e)}function Te(e){return Fe(e)}function ot(e){return Lt(e)}function je(e){return t=>{if(e.hasLength(0))return new y(c([new he("another type",Te(t),c([]))]));{let n=e.head,r=e.tail,s=n(t);if(s.isOk()){let u=s[0];return new m(u)}else return je(r)(t)}}}function ht(e,t){let n=de(t),r=je(c([ct,u=>Me(ot(u),Ce)])),s=(()=>{let u=r(n);if(u.isOk())return u[0];{let i=c(["<",Te(n),">"]),f=lt(i);return at(f)}})();return e.withFields({path:oe(s,e.path)})}function dt(e,t){return ut(e,n=>st(n,t))}function sn(e,t){return n=>{let r=new he("field","nothing",c([]));return $e(qt(n,e),s=>{let i=ve(s,c([r])),f=$e(i,t);return dt(f,l=>ht(l,e))})}}const Oe=new WeakMap,re=new DataView(new ArrayBuffer(8));let se=0;function ue(e){const t=Oe.get(e);if(t!==void 0)return t;const n=se++;return se===2147483647&&(se=0),Oe.set(e,n),n}function fe(e,t){return e^t+2654435769+(e<<6)+(e>>2)|0}function pe(e){let t=0;const n=e.length;for(let r=0;r<n;r++)t=Math.imul(31,t)+e.charCodeAt(r)|0;return t}function Le(e){re.setFloat64(0,e);const t=re.getInt32(0),n=re.getInt32(4);return Math.imul(73244475,t>>16^t)^n}function pt(e){return pe(e.toString())}function yt(e){const t=Object.getPrototypeOf(e);if(t!==null&&typeof t.hashCode=="function")try{const r=e.hashCode(e);if(typeof r=="number")return r}catch{}if(e instanceof Promise||e instanceof WeakSet||e instanceof WeakMap)return ue(e);if(e instanceof Date)return Le(e.getTime());let n=0;if(e instanceof ArrayBuffer&&(e=new Uint8Array(e)),Array.isArray(e)||e instanceof Uint8Array)for(let r=0;r<e.length;r++)n=Math.imul(31,n)+x(e[r])|0;else if(e instanceof Set)e.forEach(r=>{n=n+x(r)|0});else if(e instanceof Map)e.forEach((r,s)=>{n=n+fe(x(r),x(s))|0});else{const r=Object.keys(e);for(let s=0;s<r.length;s++){const u=r[s],i=e[u];n=n+fe(x(i),pe(u))|0}}return n}function x(e){if(e===null)return 1108378658;if(e===void 0)return 1108378659;if(e===!0)return 1108378657;if(e===!1)return 1108378656;switch(typeof e){case"number":return Le(e);case"string":return pe(e);case"bigint":return pt(e);case"object":return yt(e);case"symbol":return ue(e);case"function":return ue(e);default:return 0}}const O=5,ye=Math.pow(2,O),mt=ye-1,wt=ye/2,gt=ye/4,p=0,$=1,g=2,R=3,me={type:g,bitmap:0,array:[]};function G(e,t){return e>>>t&mt}function ee(e,t){return 1<<G(e,t)}function bt(e){return e-=e>>1&1431655765,e=(e&858993459)+(e>>2&858993459),e=e+(e>>4)&252645135,e+=e>>8,e+=e>>16,e&127}function we(e,t){return bt(e&t-1)}function A(e,t,n){const r=e.length,s=new Array(r);for(let u=0;u<r;++u)s[u]=e[u];return s[t]=n,s}function _t(e,t,n){const r=e.length,s=new Array(r+1);let u=0,i=0;for(;u<t;)s[i++]=e[u++];for(s[i++]=n;u<r;)s[i++]=e[u++];return s}function le(e,t){const n=e.length,r=new Array(n-1);let s=0,u=0;for(;s<t;)r[u++]=e[s++];for(++s;s<n;)r[u++]=e[s++];return r}function qe(e,t,n,r,s,u){const i=x(t);if(i===r)return{type:R,hash:i,array:[{type:p,k:t,v:n},{type:p,k:s,v:u}]};const f={val:!1};return J(ge(me,e,i,t,n,f),e,r,s,u,f)}function J(e,t,n,r,s,u){switch(e.type){case $:return xt(e,t,n,r,s,u);case g:return ge(e,t,n,r,s,u);case R:return At(e,t,n,r,s,u)}}function xt(e,t,n,r,s,u){const i=G(n,t),f=e.array[i];if(f===void 0)return u.val=!0,{type:$,size:e.size+1,array:A(e.array,i,{type:p,k:r,v:s})};if(f.type===p)return L(r,f.k)?s===f.v?e:{type:$,size:e.size,array:A(e.array,i,{type:p,k:r,v:s})}:(u.val=!0,{type:$,size:e.size,array:A(e.array,i,qe(t+O,f.k,f.v,n,r,s))});const l=J(f,t+O,n,r,s,u);return l===f?e:{type:$,size:e.size,array:A(e.array,i,l)}}function ge(e,t,n,r,s,u){const i=ee(n,t),f=we(e.bitmap,i);if(e.bitmap&i){const l=e.array[f];if(l.type!==p){const N=J(l,t+O,n,r,s,u);return N===l?e:{type:g,bitmap:e.bitmap,array:A(e.array,f,N)}}const o=l.k;return L(r,o)?s===l.v?e:{type:g,bitmap:e.bitmap,array:A(e.array,f,{type:p,k:r,v:s})}:(u.val=!0,{type:g,bitmap:e.bitmap,array:A(e.array,f,qe(t+O,o,l.v,n,r,s))})}else{const l=e.array.length;if(l>=wt){const o=new Array(32),N=G(n,t);o[N]=ge(me,t+O,n,r,s,u);let H=0,k=e.bitmap;for(let te=0;te<32;te++){if(k&1){const He=e.array[H++];o[te]=He}k=k>>>1}return{type:$,size:l+1,array:o}}else{const o=_t(e.array,f,{type:p,k:r,v:s});return u.val=!0,{type:g,bitmap:e.bitmap|i,array:o}}}}function At(e,t,n,r,s,u){if(n===e.hash){const i=be(e,r);if(i!==-1)return e.array[i].v===s?e:{type:R,hash:n,array:A(e.array,i,{type:p,k:r,v:s})};const f=e.array.length;return u.val=!0,{type:R,hash:n,array:A(e.array,f,{type:p,k:r,v:s})}}return J({type:g,bitmap:ee(e.hash,t),array:[e]},t,n,r,s,u)}function be(e,t){const n=e.array.length;for(let r=0;r<n;r++)if(L(t,e.array[r].k))return r;return-1}function Z(e,t,n,r){switch(e.type){case $:return Et(e,t,n,r);case g:return $t(e,t,n,r);case R:return Ot(e,r)}}function Et(e,t,n,r){const s=G(n,t),u=e.array[s];if(u!==void 0){if(u.type!==p)return Z(u,t+O,n,r);if(L(r,u.k))return u}}function $t(e,t,n,r){const s=ee(n,t);if(!(e.bitmap&s))return;const u=we(e.bitmap,s),i=e.array[u];if(i.type!==p)return Z(i,t+O,n,r);if(L(r,i.k))return i}function Ot(e,t){const n=be(e,t);if(!(n<0))return e.array[n]}function _e(e,t,n,r){switch(e.type){case $:return St(e,t,n,r);case g:return Nt(e,t,n,r);case R:return kt(e,r)}}function St(e,t,n,r){const s=G(n,t),u=e.array[s];if(u===void 0)return e;let i;if(u.type===p){if(!L(u.k,r))return e}else if(i=_e(u,t+O,n,r),i===u)return e;if(i===void 0){if(e.size<=gt){const f=e.array,l=new Array(e.size-1);let o=0,N=0,H=0;for(;o<s;){const k=f[o];k!==void 0&&(l[N]=k,H|=1<<o,++N),++o}for(++o;o<f.length;){const k=f[o];k!==void 0&&(l[N]=k,H|=1<<o,++N),++o}return{type:g,bitmap:H,array:l}}return{type:$,size:e.size-1,array:A(e.array,s,i)}}return{type:$,size:e.size,array:A(e.array,s,i)}}function Nt(e,t,n,r){const s=ee(n,t);if(!(e.bitmap&s))return e;const u=we(e.bitmap,s),i=e.array[u];if(i.type!==p){const f=_e(i,t+O,n,r);return f===i?e:f!==void 0?{type:g,bitmap:e.bitmap,array:A(e.array,u,f)}:e.bitmap===s?void 0:{type:g,bitmap:e.bitmap^s,array:le(e.array,u)}}return L(r,i.k)?e.bitmap===s?void 0:{type:g,bitmap:e.bitmap^s,array:le(e.array,u)}:e}function kt(e,t){const n=be(e,t);if(n<0)return e;if(e.array.length!==1)return{type:R,hash:e.hash,array:le(e.array,n)}}function Re(e,t){if(e===void 0)return;const n=e.array,r=n.length;for(let s=0;s<r;s++){const u=n[s];if(u!==void 0){if(u.type===p){t(u.v,u.k);continue}Re(u,t)}}}class E{static fromObject(t){const n=Object.keys(t);let r=E.new();for(let s=0;s<n.length;s++){const u=n[s];r=r.set(u,t[u])}return r}static fromMap(t){let n=E.new();return t.forEach((r,s)=>{n=n.set(s,r)}),n}static new(){return new E(void 0,0)}constructor(t,n){this.root=t,this.size=n}get(t,n){if(this.root===void 0)return n;const r=Z(this.root,0,x(t),t);return r===void 0?n:r.v}set(t,n){const r={val:!1},s=this.root===void 0?me:this.root,u=J(s,0,x(t),t,n,r);return u===this.root?this:new E(u,r.val?this.size+1:this.size)}delete(t){if(this.root===void 0)return this;const n=_e(this.root,0,x(t),t);return n===this.root?this:n===void 0?E.new():new E(n,this.size-1)}has(t){return this.root===void 0?!1:Z(this.root,0,x(t),t)!==void 0}entries(){if(this.root===void 0)return[];const t=[];return this.forEach((n,r)=>t.push([r,n])),t}forEach(t){Re(this.root,t)}hashCode(){let t=0;return this.forEach((n,r)=>{t=t+fe(x(n),x(r))|0}),t}equals(t){if(!(t instanceof E)||this.size!==t.size)return!1;let n=!0;return this.forEach((r,s)=>{n=n&&L(t.get(s,!r),r)}),n}}const xe=void 0,Se={};function zt(e){return/^[-+]?(\d+)$/.test(e)?new m(parseInt(e)):new y(xe)}function It(e){return e.toString()}function un(e){const t=Ue(e);return t?j.fromArray(Array.from(t).map(n=>n.segment)):j.fromArray(e.match(/./gsu))}function Ue(e){if(Intl&&Intl.Segmenter)return new Intl.Segmenter().segment(e)[Symbol.iterator]()}function fn(e){var r,s;let t;const n=Ue(e);return n?t=(r=n.next().value)==null?void 0:r.segment:t=(s=e.match(/./su))==null?void 0:s[0],t?new m([t,e.slice(t.length)]):new y(xe)}function Ct(e){let t="";for(const n of e)t=t+n;return t}function ln(e,t){return e.indexOf(t)>=0}function an(){return E.new()}function Mt(e,t){const n=e.get(t,Se);return n===Se?new y(xe):new m(n)}function cn(e,t,n){return n.set(e,t)}function Fe(e){if(typeof e=="string")return"String";if(e instanceof X)return"Result";if(e instanceof j)return"List";if(e instanceof Q)return"BitArray";if(e instanceof E)return"Dict";if(Number.isInteger(e))return"Int";if(Array.isArray(e))return`Tuple of ${e.length} elements`;if(typeof e=="number")return"Float";if(e===null)return"Null";if(e===void 0)return"Nil";{const t=typeof e;return t.charAt(0).toUpperCase()+t.slice(1)}}function Ae(e,t){return Tt(e,Fe(t))}function Tt(e,t){return new y(j.fromArray([new he(e,t,j.fromArray([]))]))}function jt(e){return typeof e=="string"?new m(e):Ae("String",e)}function Lt(e){return Number.isInteger(e)?new m(e):Ae("Int",e)}function qt(e,t){const n=()=>Ae("Dict",e);if(e instanceof E||e instanceof WeakMap||e instanceof Map){const r=Mt(e,t);return new m(r.isOk()?new P(r[0]):new ie)}else return Object.getPrototypeOf(e)==Object.prototype?Ne(e,t,()=>new m(new ie)):Ne(e,t,n)}function Ne(e,t,n){try{return t in e?new m(new P(e[t])):n()}catch{return n()}}function Rt(e,t){return n=>t(e(n))}class Ut extends b{constructor(t){super(),this.all=t}}function ke(){return new Ut(c([]))}function z(e,t,n,r){if(t!=null&&t.tag&&(e==null?void 0:e.nodeType)===1){const s=t.tag.toUpperCase(),u=t.namespace||"http://www.w3.org/1999/xhtml";return e.nodeName===s&&e.namespaceURI==u?Ft(e,t,n,r):ze(e,t,n,r)}return t!=null&&t.tag?ze(e,t,n,r):typeof(t==null?void 0:t.content)=="string"?(e==null?void 0:e.nodeType)===3?Ht(e,t):Dt(e,t):document.createComment(["[internal lustre error] I couldn't work out how to render this element. This","function should only be called internally by lustre's runtime: if you think","this is an error, please open an issue at","https://github.com/hayleigh-dot-dev/gleam-lustre/issues/new"].join(" "))}function ze(e,t,n,r=null){const s=t.namespace?document.createElementNS(t.namespace,t.tag):document.createElement(t.tag);s.$lustre={__registered_events:new Set};let u="";for(const i of t.attrs)i[0]==="class"?B(s,i[0],`${s.className} ${i[1]}`):i[0]==="style"?B(s,i[0],`${s.style.cssText} ${i[1]}`):i[0]==="dangerous-unescaped-html"?u+=i[1]:i[0]!==""&&B(s,i[0],i[1],n);if(customElements.get(t.tag))s._slot=t.children;else if(t.tag==="slot"){let i=new v,f=r;for(;f;)if(f._slot){i=f._slot;break}else f=f.parentNode;for(const l of i)s.appendChild(z(null,l,n,s))}else if(u)s.innerHTML=u;else for(const i of t.children)s.appendChild(z(null,i,n,s));return e&&e.replaceWith(s),s}function Ft(e,t,n,r){const s=e.attributes,u=new Map;e.$lustre??(e.$lustre={__registered_events:new Set});for(const i of t.attrs)i[0]==="class"&&u.has("class")?u.set(i[0],`${u.get("class")} ${i[1]}`):i[0]==="style"&&u.has("style")?u.set(i[0],`${u.get("style")} ${i[1]}`):i[0]==="dangerous-unescaped-html"&&u.has("dangerous-unescaped-html")?u.set(i[0],`${u.get("dangerous-unescaped-html")} ${i[1]}`):i[0]!==""&&u.set(i[0],i[1]);for(const{name:i,value:f}of s)if(!u.has(i))e.removeAttribute(i);else{const l=u.get(i);l!==f&&(B(e,i,l,n),u.delete(i))}for(const i of e.$lustre.__registered_events)if(!u.has(i)){const f=i.slice(2).toLowerCase();e.removeEventListener(f,e.$lustre[`${i}Handler`]),e.$lustre.__registered_events.delete(i),delete e.$lustre[i],delete e.$lustre[`${i}Handler`]}for(const[i,f]of u)B(e,i,f,n);if(customElements.get(t.tag))e._slot=t.children;else if(t.tag==="slot"){let i=e.firstChild,f=new v,l=r;for(;l;)if(l._slot){f=l._slot;break}else l=l.parentNode;for(;i;)Array.isArray(f)&&f.length?z(i,f.shift(),n,e):f.head&&(z(i,f.head,n,e),f=f.tail),i=i.nextSibling;for(const o of f)e.appendChild(z(null,o,n,e))}else if(u.has("dangerous-unescaped-html"))e.innerHTML=u.get("dangerous-unescaped-html");else{let i=e.firstChild,f=t.children;for(;i;)if(Array.isArray(f)&&f.length){const l=i.nextSibling;z(i,f.shift(),n,e),i=l}else if(f.head){const l=i.nextSibling;z(i,f.head,n,e),f=f.tail,i=l}else{const l=i.nextSibling;i.remove(),i=l}for(const l of f)e.appendChild(z(null,l,n,e))}return e}function B(e,t,n,r){switch(typeof n){case"string":e.getAttribute(t)!==n&&e.setAttribute(t,n),n===""&&e.removeAttribute(t),t==="value"&&e.value!==n&&(e.value=n);break;case(t.startsWith("on")&&"function"):{if(e.$lustre[t]===n)break;const s=t.slice(2).toLowerCase(),u=i=>Me(n(i),r);e.$lustre[`${t}Handler`]&&e.removeEventListener(s,e.$lustre[`${t}Handler`]),e.addEventListener(s,u),e.$lustre[t]=n,e.$lustre[`${t}Handler`]=u,e.$lustre.__registered_events.add(t);break}default:e[t]=n}}function Dt(e,t){const n=document.createTextNode(t.content);return e&&e.replaceWith(n),n}function Ht(e,t){const n=e.nodeValue,r=t.content;return r?(n!==r&&(e.nodeValue=r),e):(e==null||e.remove(),null)}var w,I,C,M,T,V,F,D,Y,ae,K,ce;class Wt{constructor(t,n,r){_(this,Y);_(this,K);_(this,w,null);_(this,I,null);_(this,C,[]);_(this,M,[]);_(this,T,!1);_(this,V,null);_(this,F,null);_(this,D,null);h(this,V,t),h(this,F,n),h(this,D,r)}start(t,n){if(!Pt())return new y(new Qt);if(a(this,w))return new y(new Xt);if(h(this,w,t instanceof HTMLElement?t:document.querySelector(t)),!a(this,w))return new y(new Jt);const[r,s]=a(this,V).call(this,n);return h(this,I,r),h(this,M,s.all.toArray()),h(this,T,!0),window.requestAnimationFrame(()=>W(this,Y,ae).call(this)),new m(u=>this.dispatch(u))}dispatch(t){a(this,C).push(t),W(this,Y,ae).call(this)}emit(t,n=null){a(this,w).dispatchEvent(new CustomEvent(t,{bubbles:!0,detail:n,composed:!0}))}destroy(){if(!a(this,w))return new y(new Gt);a(this,w).remove(),h(this,w,null),h(this,I,null),h(this,C,[]),h(this,M,[]),h(this,T,!1),h(this,F,()=>{}),h(this,D,()=>{})}}w=new WeakMap,I=new WeakMap,C=new WeakMap,M=new WeakMap,T=new WeakMap,V=new WeakMap,F=new WeakMap,D=new WeakMap,Y=new WeakSet,ae=function(){if(W(this,K,ce).call(this),a(this,T)){const t=a(this,D).call(this,a(this,I));h(this,w,z(a(this,w),t,n=>this.dispatch(n))),h(this,T,!1)}},K=new WeakSet,ce=function(t=0){if(a(this,w)){if(a(this,C).length)for(;a(this,C).length;){const[n,r]=a(this,F).call(this,a(this,I),a(this,C).shift());a(this,T)||h(this,T,a(this,I)!==n),h(this,I,n),h(this,M,a(this,M).concat(r.all.toArray()))}for(;a(this,M).length;)a(this,M).shift()(n=>this.dispatch(n),(n,r)=>this.emit(n,r));a(this,C).length&&(t>=5?console.warn(tooManyUpdates):W(this,K,ce).call(this,++t))}};const Bt=(e,t,n)=>new Wt(e,t,n),on=(e,t,n)=>e.start(t,n),Pt=()=>window&&window.document;class De extends b{constructor(t,n,r){super(),this[0]=t,this[1]=n,this.as_property=r}}class Vt extends b{constructor(t,n){super(),this[0]=t,this[1]=n}}function U(e,t){return new De(e,de(t),!1)}function Yt(e,t){return new De(e,de(t),!0)}function hn(e,t){return new Vt("on"+e,Rt(t,n=>ft(n,void 0)))}function dn(e){return U("style",it(e,"",(t,n)=>{let r=n[0],s=n[1];return t+r+":"+s+";"}))}function pn(e){return U("class",e)}function yn(e){return U("id",e)}function mn(e){return U("placeholder",e)}function wn(e){return U("href",e)}function gn(e){return U("src",e)}function bn(e){return Yt("width",Ce(e))}function _n(e){return U("alt",e)}class Kt extends b{constructor(t){super(),this.content=t}}class d extends b{constructor(t,n,r,s,u,i){super(),this.namespace=t,this.tag=n,this.attrs=r,this.children=s,this.self_closing=u,this.void=i}}function S(e,t,n){return e==="area"?new d("",e,t,c([]),!1,!0):e==="base"?new d("",e,t,c([]),!1,!0):e==="br"?new d("",e,t,c([]),!1,!0):e==="col"?new d("",e,t,c([]),!1,!0):e==="embed"?new d("",e,t,c([]),!1,!0):e==="hr"?new d("",e,t,c([]),!1,!0):e==="img"?new d("",e,t,c([]),!1,!0):e==="input"?new d("",e,t,c([]),!1,!0):e==="link"?new d("",e,t,c([]),!1,!0):e==="meta"?new d("",e,t,c([]),!1,!0):e==="param"?new d("",e,t,c([]),!1,!0):e==="source"?new d("",e,t,c([]),!1,!0):e==="track"?new d("",e,t,c([]),!1,!0):e==="wbr"?new d("",e,t,c([]),!1,!0):new d("",e,t,n,!1,!1)}function xn(e){return new Kt(e)}class Xt extends b{}class Gt extends b{}class Jt extends b{}class Qt extends b{}function An(e,t,n){return Bt(u=>[e(u),ke()],(u,i)=>[t(u,i),ke()],n)}function En(e,t){return S("h3",e,t)}function $n(e,t){return S("div",e,t)}function On(e,t){return S("p",e,t)}function Sn(e,t){return S("a",e,t)}function Nn(e){return S("br",e,c([]))}function kn(e,t){return S("code",e,t)}function zn(e,t){return S("span",e,t)}function In(e,t){return S("strong",e,t)}function Cn(e){return S("img",e,c([]))}function Mn(e){return S("textarea",e,c([]))}export{sn as A,ct as B,b as C,un as D,y as E,rn as F,oe as G,ln as H,$e as I,ft as J,Ce as K,it as L,tn as M,nn as N,m as O,ie as P,ut as Q,en as R,P as S,kn as T,Mn as U,mn as V,Nn as W,In as X,An as a,Cn as b,gn as c,$n as d,pn as e,xn as f,Sn as g,En as h,yn as i,wn as j,_n as k,zn as l,vt as m,dn as n,Mt as o,On as p,cn as q,an as r,on as s,c as t,lt as u,at as v,bn as w,fn as x,hn as y,Me as z};
