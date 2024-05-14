var Se=(e,t,n)=>{if(!t.has(e))throw TypeError("Cannot "+n)};var d=(e,t,n)=>(Se(e,t,"read from private field"),n?n.call(e):t.get(e)),A=(e,t,n)=>{if(t.has(e))throw TypeError("Cannot add the same private member more than once");t instanceof WeakSet?t.add(e):t.set(e,n)},w=(e,t,n,r)=>(Se(e,t,"write to private field"),r?r.call(e,n):t.set(e,n),n);var ee=(e,t,n)=>(Se(e,t,"access private method"),n);import"./style-27b4b240.js";class f{withFields(t){let n=Object.keys(this).map(r=>r in t?t[r]:this[r]);return new this.constructor(...n)}}class q{static fromArray(t,n){let r=n||new $e;for(let i=t.length-1;i>=0;--i)r=new wt(t[i],r);return r}[Symbol.iterator](){return new Dt(this)}toArray(){return[...this]}atLeastLength(t){for(let n of this){if(t<=0)return!0;t--}return t<=0}hasLength(t){for(let n of this){if(t<=0)return!1;t--}return t===0}countLength(){let t=0;for(let n of this)t++;return t}}function le(e,t){return new wt(e,t)}function a(e,t){return q.fromArray(e,t)}var H;class Dt{constructor(t){A(this,H,void 0);w(this,H,t)}next(){if(d(this,H)instanceof $e)return{done:!0};{let{head:t,tail:n}=d(this,H);return w(this,H,n),{value:t,done:!1}}}}H=new WeakMap;class $e extends q{}class wt extends q{constructor(t,n){super(),this.head=t,this.tail=n}}class ge{constructor(t){if(!(t instanceof Uint8Array))throw"BitArray can only be constructed from a Uint8Array";this.buffer=t}get length(){return this.buffer.length}byteAt(t){return this.buffer[t]}floatAt(t){return Pt(this.buffer.slice(t,t+8))}intFromSlice(t,n){return Ht(this.buffer.slice(t,n))}binaryFromSlice(t,n){return new ge(this.buffer.slice(t,n))}sliceAfter(t){return new ge(this.buffer.slice(t))}}function Ht(e){e=e.reverse();let t=0;for(let n=e.length-1;n>=0;n--)t=t*256+e[n];return t}function Pt(e){return new Float64Array(e.reverse().buffer)[0]}class ae extends f{static isResult(t){return t instanceof ae}}class p extends ae{constructor(t){super(),this[0]=t}isOk(){return!0}}class m extends ae{constructor(t){super(),this[0]=t}isOk(){return!1}}function U(e,t){let n=[e,t];for(;n.length;){let r=n.pop(),i=n.pop();if(r===i)continue;if(!it(r)||!it(i)||!en(r,i)||Gt(r,i)||Kt(r,i)||Xt(r,i)||Jt(r,i)||Zt(r,i)||Qt(r,i))return!1;const u=Object.getPrototypeOf(r);if(u!==null&&typeof u.equals=="function")try{if(r.equals(i))continue;return!1}catch{}let[l,o]=Yt(r);for(let h of l(r))n.push(o(r,h),o(i,h))}return!0}function Yt(e){if(e instanceof Map)return[t=>t.keys(),(t,n)=>t.get(n)];{let t=e instanceof globalThis.Error?["message"]:[];return[n=>[...t,...Object.keys(n)],(n,r)=>n[r]]}}function Gt(e,t){return e instanceof Date&&(e>t||e<t)}function Kt(e,t){return e.buffer instanceof ArrayBuffer&&e.BYTES_PER_ELEMENT&&!(e.byteLength===t.byteLength&&e.every((n,r)=>n===t[r]))}function Xt(e,t){return Array.isArray(e)&&e.length!==t.length}function Jt(e,t){return e instanceof Map&&e.size!==t.size}function Zt(e,t){return e instanceof Set&&(e.size!=t.size||[...e].some(n=>!t.has(n)))}function Qt(e,t){return e instanceof RegExp&&(e.source!==t.source||e.flags!==t.flags)}function it(e){return typeof e=="object"&&e!==null}function en(e,t){return typeof e!="object"&&typeof t!="object"&&(!e||!t)||[Promise,WeakSet,WeakMap,Function].some(r=>e instanceof r)?!1:e.constructor===t.constructor}function qe(e,t,n,r,i,s){let u=new globalThis.Error(i);u.gleam_error=e,u.module=t,u.line=n,u.fn=r;for(let l in s)u[l]=s[l];return u}class Ue extends f{constructor(t){super(),this[0]=t}}class st extends f{}function tn(e,t){if(e instanceof Ue){let n=e[0];return new p(n)}else return new m(t)}function nn(e){return Cn(e)}function Ae(e){return Mn(e)}function rn(e,t){for(;;){let n=e,r=t;if(n.hasLength(0))return r;{let i=n.head;e=n.tail,t=le(i,r)}}}function sn(e){return rn(e,a([]))}function un(e){return sn(e)}function ln(e,t,n){for(;;){let r=e,i=t,s=n;if(r.hasLength(0))return un(s);{let u=r.head;e=r.tail,t=i,n=le(i(u),s)}}}function an(e,t){return ln(e,t,a([]))}function yt(e,t,n){for(;;){let r=e,i=t,s=n;if(r.hasLength(0))return i;{let u=r.head;e=r.tail,t=s(i,u),n=s}}}function oe(e,t){if(e.isOk()){let n=e[0];return new p(t(n))}else{let n=e[0];return new m(n)}}function on(e,t){if(e.isOk()){let n=e[0];return new p(n)}else{let n=e[0];return new m(t(n))}}function W(e,t){if(e.isOk()){let n=e[0];return t(n)}else{let n=e[0];return new m(n)}}function cn(e,t){return e.isOk()?e[0]:t()}function fn(e,t){return e.isOk()?e:t}function mt(e,t){if(e.isOk()){let n=e[0];return new p(n)}else return new m(t)}function gt(e){return zn(e)}function bt(e){return e}class Fe extends f{constructor(t,n,r){super(),this.expected=t,this.found=n,this.path=r}}function Ve(e){return e}function _t(e){return Bn(e)}function xt(e){return St(e)}function hn(e){return Wn(e)}function $t(e){return t=>{if(e.hasLength(0))return new m(a([new Fe("another type",xt(t),a([]))]));{let n=e.head,r=e.tail,i=n(t);if(i.isOk()){let s=i[0];return new p(s)}else return $t(r)(t)}}}function dn(e,t){let n=Ve(t),r=$t(a([_t,s=>oe(hn(s),Ae)])),i=(()=>{let s=r(n);if(s.isOk())return s[0];{let u=a(["<",xt(n),">"]),l=gt(u);return bt(l)}})();return e.withFields({path:le(i,e.path)})}function pn(e,t){return on(e,n=>an(n,t))}function ut(e,t){return n=>{let r=new Fe("field","nothing",a([]));return W(qn(n,e),i=>{let u=tn(i,a([r])),l=W(u,t);return pn(l,o=>dn(o,e))})}}const lt=new WeakMap,Le=new DataView(new ArrayBuffer(8));let Ce=0;function ze(e){const t=lt.get(e);if(t!==void 0)return t;const n=Ce++;return Ce===2147483647&&(Ce=0),lt.set(e,n),n}function Re(e,t){return e^t+2654435769+(e<<6)+(e>>2)|0}function De(e){let t=0;const n=e.length;for(let r=0;r<n;r++)t=Math.imul(31,t)+e.charCodeAt(r)|0;return t}function At(e){Le.setFloat64(0,e);const t=Le.getInt32(0),n=Le.getInt32(4);return Math.imul(73244475,t>>16^t)^n}function wn(e){return De(e.toString())}function yn(e){const t=Object.getPrototypeOf(e);if(t!==null&&typeof t.hashCode=="function")try{const r=e.hashCode(e);if(typeof r=="number")return r}catch{}if(e instanceof Promise||e instanceof WeakSet||e instanceof WeakMap)return ze(e);if(e instanceof Date)return At(e.getTime());let n=0;if(e instanceof ArrayBuffer&&(e=new Uint8Array(e)),Array.isArray(e)||e instanceof Uint8Array)for(let r=0;r<e.length;r++)n=Math.imul(31,n)+E(e[r])|0;else if(e instanceof Set)e.forEach(r=>{n=n+E(r)|0});else if(e instanceof Map)e.forEach((r,i)=>{n=n+Re(E(r),E(i))|0});else{const r=Object.keys(e);for(let i=0;i<r.length;i++){const s=r[i],u=e[s];n=n+Re(E(u),De(s))|0}}return n}function E(e){if(e===null)return 1108378658;if(e===void 0)return 1108378659;if(e===!0)return 1108378657;if(e===!1)return 1108378656;switch(typeof e){case"number":return At(e);case"string":return De(e);case"bigint":return wn(e);case"object":return yn(e);case"symbol":return ze(e);case"function":return ze(e);default:return 0}}const S=5,He=Math.pow(2,S),mn=He-1,gn=He/2,bn=He/4,b=0,I=1,$=2,P=3,Pe={type:$,bitmap:0,array:[]};function ce(e,t){return e>>>t&mn}function Ee(e,t){return 1<<ce(e,t)}function _n(e){return e-=e>>1&1431655765,e=(e&858993459)+(e>>2&858993459),e=e+(e>>4)&252645135,e+=e>>8,e+=e>>16,e&127}function Ye(e,t){return _n(e&t-1)}function O(e,t,n){const r=e.length,i=new Array(r);for(let s=0;s<r;++s)i[s]=e[s];return i[t]=n,i}function xn(e,t,n){const r=e.length,i=new Array(r+1);let s=0,u=0;for(;s<t;)i[u++]=e[s++];for(i[u++]=n;s<r;)i[u++]=e[s++];return i}function ve(e,t){const n=e.length,r=new Array(n-1);let i=0,s=0;for(;i<t;)r[s++]=e[i++];for(++i;i<n;)r[s++]=e[i++];return r}function Et(e,t,n,r,i,s){const u=E(t);if(u===r)return{type:P,hash:u,array:[{type:b,k:t,v:n},{type:b,k:i,v:s}]};const l={val:!1};return fe(Ge(Pe,e,u,t,n,l),e,r,i,s,l)}function fe(e,t,n,r,i,s){switch(e.type){case I:return $n(e,t,n,r,i,s);case $:return Ge(e,t,n,r,i,s);case P:return An(e,t,n,r,i,s)}}function $n(e,t,n,r,i,s){const u=ce(n,t),l=e.array[u];if(l===void 0)return s.val=!0,{type:I,size:e.size+1,array:O(e.array,u,{type:b,k:r,v:i})};if(l.type===b)return U(r,l.k)?i===l.v?e:{type:I,size:e.size,array:O(e.array,u,{type:b,k:r,v:i})}:(s.val=!0,{type:I,size:e.size,array:O(e.array,u,Et(t+S,l.k,l.v,n,r,i))});const o=fe(l,t+S,n,r,i,s);return o===l?e:{type:I,size:e.size,array:O(e.array,u,o)}}function Ge(e,t,n,r,i,s){const u=Ee(n,t),l=Ye(e.bitmap,u);if(e.bitmap&u){const o=e.array[l];if(o.type!==b){const C=fe(o,t+S,n,r,i,s);return C===o?e:{type:$,bitmap:e.bitmap,array:O(e.array,l,C)}}const h=o.k;return U(r,h)?i===o.v?e:{type:$,bitmap:e.bitmap,array:O(e.array,l,{type:b,k:r,v:i})}:(s.val=!0,{type:$,bitmap:e.bitmap,array:O(e.array,l,Et(t+S,h,o.v,n,r,i))})}else{const o=e.array.length;if(o>=gn){const h=new Array(32),C=ce(n,t);h[C]=Ge(Pe,t+S,n,r,i,s);let Q=0,M=e.bitmap;for(let Ie=0;Ie<32;Ie++){if(M&1){const Vt=e.array[Q++];h[Ie]=Vt}M=M>>>1}return{type:I,size:o+1,array:h}}else{const h=xn(e.array,l,{type:b,k:r,v:i});return s.val=!0,{type:$,bitmap:e.bitmap|u,array:h}}}}function An(e,t,n,r,i,s){if(n===e.hash){const u=Ke(e,r);if(u!==-1)return e.array[u].v===i?e:{type:P,hash:n,array:O(e.array,u,{type:b,k:r,v:i})};const l=e.array.length;return s.val=!0,{type:P,hash:n,array:O(e.array,l,{type:b,k:r,v:i})}}return fe({type:$,bitmap:Ee(e.hash,t),array:[e]},t,n,r,i,s)}function Ke(e,t){const n=e.array.length;for(let r=0;r<n;r++)if(U(t,e.array[r].k))return r;return-1}function be(e,t,n,r){switch(e.type){case I:return En(e,t,n,r);case $:return On(e,t,n,r);case P:return kn(e,r)}}function En(e,t,n,r){const i=ce(n,t),s=e.array[i];if(s!==void 0){if(s.type!==b)return be(s,t+S,n,r);if(U(r,s.k))return s}}function On(e,t,n,r){const i=Ee(n,t);if(!(e.bitmap&i))return;const s=Ye(e.bitmap,i),u=e.array[s];if(u.type!==b)return be(u,t+S,n,r);if(U(r,u.k))return u}function kn(e,t){const n=Ke(e,t);if(!(n<0))return e.array[n]}function Xe(e,t,n,r){switch(e.type){case I:return In(e,t,n,r);case $:return Sn(e,t,n,r);case P:return Ln(e,r)}}function In(e,t,n,r){const i=ce(n,t),s=e.array[i];if(s===void 0)return e;let u;if(s.type===b){if(!U(s.k,r))return e}else if(u=Xe(s,t+S,n,r),u===s)return e;if(u===void 0){if(e.size<=bn){const l=e.array,o=new Array(e.size-1);let h=0,C=0,Q=0;for(;h<i;){const M=l[h];M!==void 0&&(o[C]=M,Q|=1<<h,++C),++h}for(++h;h<l.length;){const M=l[h];M!==void 0&&(o[C]=M,Q|=1<<h,++C),++h}return{type:$,bitmap:Q,array:o}}return{type:I,size:e.size-1,array:O(e.array,i,u)}}return{type:I,size:e.size,array:O(e.array,i,u)}}function Sn(e,t,n,r){const i=Ee(n,t);if(!(e.bitmap&i))return e;const s=Ye(e.bitmap,i),u=e.array[s];if(u.type!==b){const l=Xe(u,t+S,n,r);return l===u?e:l!==void 0?{type:$,bitmap:e.bitmap,array:O(e.array,s,l)}:e.bitmap===i?void 0:{type:$,bitmap:e.bitmap^i,array:ve(e.array,s)}}return U(r,u.k)?e.bitmap===i?void 0:{type:$,bitmap:e.bitmap^i,array:ve(e.array,s)}:e}function Ln(e,t){const n=Ke(e,t);if(n<0)return e;if(e.array.length!==1)return{type:P,hash:e.hash,array:ve(e.array,n)}}function Ot(e,t){if(e===void 0)return;const n=e.array,r=n.length;for(let i=0;i<r;i++){const s=n[i];if(s!==void 0){if(s.type===b){t(s.v,s.k);continue}Ot(s,t)}}}class k{static fromObject(t){const n=Object.keys(t);let r=k.new();for(let i=0;i<n.length;i++){const s=n[i];r=r.set(s,t[s])}return r}static fromMap(t){let n=k.new();return t.forEach((r,i)=>{n=n.set(i,r)}),n}static new(){return new k(void 0,0)}constructor(t,n){this.root=t,this.size=n}get(t,n){if(this.root===void 0)return n;const r=be(this.root,0,E(t),t);return r===void 0?n:r.v}set(t,n){const r={val:!1},i=this.root===void 0?Pe:this.root,s=fe(i,0,E(t),t,n,r);return s===this.root?this:new k(s,r.val?this.size+1:this.size)}delete(t){if(this.root===void 0)return this;const n=Xe(this.root,0,E(t),t);return n===this.root?this:n===void 0?k.new():new k(n,this.size-1)}has(t){return this.root===void 0?!1:be(this.root,0,E(t),t)!==void 0}entries(){if(this.root===void 0)return[];const t=[];return this.forEach((n,r)=>t.push([r,n])),t}forEach(t){Ot(this.root,t)}hashCode(){let t=0;return this.forEach((n,r)=>{t=t+Re(E(n),E(r))|0}),t}equals(t){if(!(t instanceof k)||this.size!==t.size)return!1;let n=!0;return this.forEach((r,i)=>{n=n&&U(t.get(i,!r),r)}),n}}const kt=void 0,at={};function Cn(e){return/^[-+]?(\d+)$/.test(e)?new p(parseInt(e)):new m(kt)}function Mn(e){return e.toString()}function Nn(e){const t=Tn(e);return t?q.fromArray(Array.from(t).map(n=>n.segment)):q.fromArray(e.match(/./gsu))}function Tn(e){if(Intl&&Intl.Segmenter)return new Intl.Segmenter().segment(e)[Symbol.iterator]()}function zn(e){let t="";for(const n of e)t=t+n;return t}function Je(e,t){return e.indexOf(t)>=0}function Rn(){return k.new()}function It(e,t){const n=e.get(t,at);return n===at?new m(kt):new p(n)}function vn(e,t,n){return n.set(e,t)}function St(e){if(typeof e=="string")return"String";if(e instanceof ae)return"Result";if(e instanceof q)return"List";if(e instanceof ge)return"BitArray";if(e instanceof k)return"Dict";if(Number.isInteger(e))return"Int";if(Array.isArray(e))return`Tuple of ${e.length} elements`;if(typeof e=="number")return"Float";if(e===null)return"Null";if(e===void 0)return"Nil";{const t=typeof e;return t.charAt(0).toUpperCase()+t.slice(1)}}function Ze(e,t){return jn(e,St(t))}function jn(e,t){return new m(q.fromArray([new Fe(e,t,q.fromArray([]))]))}function Bn(e){return typeof e=="string"?new p(e):Ze("String",e)}function Wn(e){return Number.isInteger(e)?new p(e):Ze("Int",e)}function qn(e,t){const n=()=>Ze("Dict",e);if(e instanceof k||e instanceof WeakMap||e instanceof Map){const r=It(e,t);return new p(r.isOk()?new Ue(r[0]):new st)}else return Object.getPrototypeOf(e)==Object.prototype?ot(e,t,()=>new p(new st)):ot(e,t,n)}function ot(e,t,n){try{return t in e?new p(new Ue(e[t])):n()}catch{return n()}}function Lt(){return Rn()}function Ct(e,t){return It(e,t)}function Mt(e,t,n){return vn(t,n,e)}function Nt(e){let n=gt(e);return bt(n)}function Un(e,t){return n=>t(e(n))}class Fn extends f{constructor(t){super(),this.all=t}}function ct(){return new Fn(a([]))}function N(e,t,n,r){if(t!=null&&t.tag&&(e==null?void 0:e.nodeType)===1){const i=t.tag.toUpperCase(),s=t.namespace||"http://www.w3.org/1999/xhtml";return e.nodeName===i&&e.namespaceURI==s?Vn(e,t,n,r):ft(e,t,n,r)}return t!=null&&t.tag?ft(e,t,n,r):typeof(t==null?void 0:t.content)=="string"?(e==null?void 0:e.nodeType)===3?Hn(e,t):Dn(e,t):document.createComment(["[internal lustre error] I couldn't work out how to render this element. This","function should only be called internally by lustre's runtime: if you think","this is an error, please open an issue at","https://github.com/hayleigh-dot-dev/gleam-lustre/issues/new"].join(" "))}function ft(e,t,n,r=null){const i=t.namespace?document.createElementNS(t.namespace,t.tag):document.createElement(t.tag);i.$lustre={__registered_events:new Set};let s="";for(const u of t.attrs)u[0]==="class"?ne(i,u[0],`${i.className} ${u[1]}`):u[0]==="style"?ne(i,u[0],`${i.style.cssText} ${u[1]}`):u[0]==="dangerous-unescaped-html"?s+=u[1]:u[0]!==""&&ne(i,u[0],u[1],n);if(customElements.get(t.tag))i._slot=t.children;else if(t.tag==="slot"){let u=new $e,l=r;for(;l;)if(l._slot){u=l._slot;break}else l=l.parentNode;for(const o of u)i.appendChild(N(null,o,n,i))}else if(s)i.innerHTML=s;else for(const u of t.children)i.appendChild(N(null,u,n,i));return e&&e.replaceWith(i),i}function Vn(e,t,n,r){const i=e.attributes,s=new Map;e.$lustre??(e.$lustre={__registered_events:new Set});for(const u of t.attrs)u[0]==="class"&&s.has("class")?s.set(u[0],`${s.get("class")} ${u[1]}`):u[0]==="style"&&s.has("style")?s.set(u[0],`${s.get("style")} ${u[1]}`):u[0]==="dangerous-unescaped-html"&&s.has("dangerous-unescaped-html")?s.set(u[0],`${s.get("dangerous-unescaped-html")} ${u[1]}`):u[0]!==""&&s.set(u[0],u[1]);for(const{name:u,value:l}of i)if(!s.has(u))e.removeAttribute(u);else{const o=s.get(u);o!==l&&(ne(e,u,o,n),s.delete(u))}for(const u of e.$lustre.__registered_events)if(!s.has(u)){const l=u.slice(2).toLowerCase();e.removeEventListener(l,e.$lustre[`${u}Handler`]),e.$lustre.__registered_events.delete(u),delete e.$lustre[u],delete e.$lustre[`${u}Handler`]}for(const[u,l]of s)ne(e,u,l,n);if(customElements.get(t.tag))e._slot=t.children;else if(t.tag==="slot"){let u=e.firstChild,l=new $e,o=r;for(;o;)if(o._slot){l=o._slot;break}else o=o.parentNode;for(;u;)Array.isArray(l)&&l.length?N(u,l.shift(),n,e):l.head&&(N(u,l.head,n,e),l=l.tail),u=u.nextSibling;for(const h of l)e.appendChild(N(null,h,n,e))}else if(s.has("dangerous-unescaped-html"))e.innerHTML=s.get("dangerous-unescaped-html");else{let u=e.firstChild,l=t.children;for(;u;)if(Array.isArray(l)&&l.length){const o=u.nextSibling;N(u,l.shift(),n,e),u=o}else if(l.head){const o=u.nextSibling;N(u,l.head,n,e),l=l.tail,u=o}else{const o=u.nextSibling;u.remove(),u=o}for(const o of l)e.appendChild(N(null,o,n,e))}return e}function ne(e,t,n,r){switch(typeof n){case"string":e.getAttribute(t)!==n&&e.setAttribute(t,n),n===""&&e.removeAttribute(t),t==="value"&&e.value!==n&&(e.value=n);break;case(t.startsWith("on")&&"function"):{if(e.$lustre[t]===n)break;const i=t.slice(2).toLowerCase(),s=u=>oe(n(u),r);e.$lustre[`${t}Handler`]&&e.removeEventListener(i,e.$lustre[`${t}Handler`]),e.addEventListener(i,s),e.$lustre[t]=n,e.$lustre[`${t}Handler`]=s,e.$lustre.__registered_events.add(t);break}default:e[t]=n}}function Dn(e,t){const n=document.createTextNode(t.content);return e&&e.replaceWith(n),n}function Hn(e,t){const n=e.nodeValue,r=t.content;return r?(n!==r&&(e.nodeValue=r),e):(e==null||e.remove(),null)}var x,T,z,R,B,ie,K,X,se,je,ue,Be;class Pn{constructor(t,n,r){A(this,se);A(this,ue);A(this,x,null);A(this,T,null);A(this,z,[]);A(this,R,[]);A(this,B,!1);A(this,ie,null);A(this,K,null);A(this,X,null);w(this,ie,t),w(this,K,n),w(this,X,r)}start(t,n){if(!Kn())return new m(new ur);if(d(this,x))return new m(new rr);if(w(this,x,t instanceof HTMLElement?t:document.querySelector(t)),!d(this,x))return new m(new sr);const[r,i]=d(this,ie).call(this,n);return w(this,T,r),w(this,R,i.all.toArray()),w(this,B,!0),window.requestAnimationFrame(()=>ee(this,se,je).call(this)),new p(s=>this.dispatch(s))}dispatch(t){d(this,z).push(t),ee(this,se,je).call(this)}emit(t,n=null){d(this,x).dispatchEvent(new CustomEvent(t,{bubbles:!0,detail:n,composed:!0}))}destroy(){if(!d(this,x))return new m(new ir);d(this,x).remove(),w(this,x,null),w(this,T,null),w(this,z,[]),w(this,R,[]),w(this,B,!1),w(this,K,()=>{}),w(this,X,()=>{})}}x=new WeakMap,T=new WeakMap,z=new WeakMap,R=new WeakMap,B=new WeakMap,ie=new WeakMap,K=new WeakMap,X=new WeakMap,se=new WeakSet,je=function(){if(ee(this,ue,Be).call(this),d(this,B)){const t=d(this,X).call(this,d(this,T));w(this,x,N(d(this,x),t,n=>this.dispatch(n))),w(this,B,!1)}},ue=new WeakSet,Be=function(t=0){if(d(this,x)){if(d(this,z).length)for(;d(this,z).length;){const[n,r]=d(this,K).call(this,d(this,T),d(this,z).shift());d(this,B)||w(this,B,d(this,T)!==n),w(this,T,n),w(this,R,d(this,R).concat(r.all.toArray()))}for(;d(this,R).length;)d(this,R).shift()(n=>this.dispatch(n),(n,r)=>this.emit(n,r));d(this,z).length&&(t>=5?console.warn(tooManyUpdates):ee(this,ue,Be).call(this,++t))}};const Yn=(e,t,n)=>new Pn(e,t,n),Gn=(e,t,n)=>e.start(t,n),Kn=()=>window&&window.document;class Tt extends f{constructor(t,n,r){super(),this[0]=t,this[1]=n,this.as_property=r}}class Xn extends f{constructor(t,n){super(),this[0]=t,this[1]=n}}function Z(e,t){return new Tt(e,Ve(t),!1)}function zt(e,t){return new Tt(e,Ve(t),!0)}function Jn(e,t){return new Xn("on"+e,Un(t,n=>mt(n,void 0)))}function Zn(e){return Z("style",yt(e,"",(t,n)=>{let r=n[0],i=n[1];return t+r+":"+i+";"}))}function Me(e){return Z("id",e)}function ht(e){return Z("placeholder",e)}function F(e){return Z("href",e)}function Qn(e){return Z("src",e)}function er(e){return zt("height",Ae(e))}function tr(e){return zt("width",Ae(e))}class nr extends f{constructor(t){super(),this.content=t}}class g extends f{constructor(t,n,r,i,s,u){super(),this.namespace=t,this.tag=n,this.attrs=r,this.children=i,this.self_closing=s,this.void=u}}function v(e,t,n){return e==="area"?new g("",e,t,a([]),!1,!0):e==="base"?new g("",e,t,a([]),!1,!0):e==="br"?new g("",e,t,a([]),!1,!0):e==="col"?new g("",e,t,a([]),!1,!0):e==="embed"?new g("",e,t,a([]),!1,!0):e==="hr"?new g("",e,t,a([]),!1,!0):e==="img"?new g("",e,t,a([]),!1,!0):e==="input"?new g("",e,t,a([]),!1,!0):e==="link"?new g("",e,t,a([]),!1,!0):e==="meta"?new g("",e,t,a([]),!1,!0):e==="param"?new g("",e,t,a([]),!1,!0):e==="source"?new g("",e,t,a([]),!1,!0):e==="track"?new g("",e,t,a([]),!1,!0):e==="wbr"?new g("",e,t,a([]),!1,!0):new g("",e,t,n,!1,!1)}function c(e){return new nr(e)}class rr extends f{}class ir extends f{}class sr extends f{}class ur extends f{}function lr(e,t,n){return Yn(s=>[e(s),ct()],(s,u)=>[t(s,u),ct()],n)}function Ne(e,t){return v("h3",e,t)}function Te(e,t){return v("div",e,t)}function de(e,t){return v("p",e,t)}function V(e,t){return v("a",e,t)}function ar(e){return v("br",e,a([]))}function D(e,t){return v("code",e,t)}function or(e,t){return v("strong",e,t)}function cr(e){return v("iframe",e,a([]))}function dt(e){return v("textarea",e,a([]))}function fr(e,t){return Jn(e,t)}function hr(e){let t=e;return ut("target",ut("value",_t))(t)}function pt(e){return fr("input",t=>{let n=hr(t);return oe(n,e)})}class We extends f{constructor(t){super(),this.error=t}}class we extends f{constructor(t,n){super(),this.row=t,this.col=n}}class j extends f{constructor(t){super(),this.parse=t}}function _(e,t,n){let r=e.parse;return r(t,n)}function Oe(e){return new j((t,n)=>{if(!(n instanceof we))throw qe("assignment_no_match","party",58,"","Assignment pattern did not match",{value:n});let r=n.row,i=n.col;if(t.atLeastLength(1)){let s=t.head,u=t.tail;return e(s)?s===`
`?new p([s,u,new we(r+1,0)]):new p([s,u,new we(r,i+1)]):new m(new We(s))}else return new m(new We("EOF"))})}function L(e){return Oe(t=>e===t)}function Qe(e,t){return new j((n,r)=>fn(_(e,n,r),_(t,n,r)))}function et(e){return new j((t,n)=>{if(e.hasLength(0))return new m(new We("choiceless choice"));if(e.hasLength(1)){let r=e.head;return _(r,t,n)}else{let r=e.head,i=e.tail,s=_(r,t,n);if(s.isOk()){let u=s[0][0],l=s[0][1],o=s[0][2];return new p([u,l,o])}else return _(et(i),t,n)}})}function he(e){return new j((t,n)=>{let r=_(e,t,n);if(r.isOk()){let i=r[0][0],s=r[0][1],u=r[0][2];return oe(_(he(e),s,u),l=>[le(i,l[0]),l[1],l[2]])}else return new p([a([]),t,n])})}function dr(e){return new j((t,n)=>{let r=_(e,t,n);if(r.isOk()){let i=r[0][0],s=r[0][1],u=r[0][2];return oe(_(he(e),s,u),l=>[le(i,l[0]),l[1],l[2]])}else{let i=r[0];return new m(i)}})}function te(e,t){return new j((n,r)=>{let i=_(e,n,r);if(i.isOk()){let s=i[0][0],u=i[0][1],l=i[0][2];return new p([t(s),u,l])}else{let s=i[0];return new m(s)}})}function tt(e){return new j((t,n)=>_(e(),t,n))}function y(e,t){return new j((n,r)=>{let i=_(e,n,r);if(i.isOk()){let s=i[0][0],u=i[0][1],l=i[0][2];return _(t(s),u,l)}else{let s=i[0];return new m(s)}})}function J(e){return new j((t,n)=>new p([e,t,n]))}function pr(e,t){let n=_(e,Nn(t),new we(1,1));if(n.isOk()){let r=n[0][0];return new p(r)}else{let r=n[0];return new m(r)}}function wr(){return Oe(e=>Je("abcdefghijklmnopqrstuvwxyz",e))}function yr(){return Oe(e=>Je("ABCDEFGHIJKLMNOPQRSTUVWXYZ",e))}function Rt(){return Qe(wr(),yr())}function vt(){return Oe(e=>Je("0123456789",e))}function mr(){return Qe(vt(),Rt())}class jt extends f{constructor(t){super(),this[0]=t}}class Bt extends f{constructor(t){super(),this[0]=t}}class Wt extends f{constructor(t,n){super(),this[0]=t,this[1]=n}}class gr extends f{constructor(t,n){super(),this[0]=t,this[1]=n}}class qt extends f{constructor(t){super(),this.int=t}}class pe extends f{constructor(t,n){super(),this.val=t,this.gen=n}}class nt extends f{constructor(t){super(),this[0]=t}}class rt extends f{constructor(t,n){super(),this[0]=t,this[1]=n}}class re extends f{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}}class _e extends f{constructor(t,n){super(),this[0]=t,this[1]=n}}function br(){let e=dr(vt()),t=te(e,Nt),n=te(t,nn),r=te(n,i=>cn(i,()=>{throw qe("panic","tinylang",19,"","parsed int isn't an int",{})}));return te(r,i=>new jt(i))}function Ut(){return y(Rt(),e=>y(he(Qe(mr(),L("_"))),t=>J(e+Nt(t))))}function _r(){let e=Ut();return te(e,t=>new Bt(t))}function G(){return y(he(et(a([L(" "),L("	"),L(`
`)]))),e=>J(void 0))}function xr(e,t){return t(new qt(e.int+1),e.int)}function ye(e,t,n){if(t instanceof jt){let r=t[0];return new p(new pe(new nt(r),e))}else if(t instanceof Bt){let r=t[0],i=Ct(n,r);if(i.isOk()){let s=i[0];return new p(new pe(new rt(s,r),e))}else return new m("Wait! "+r+" isn't defined anywhere!")}else if(t instanceof Wt){let r=t[0],i=t[1];return xr(e,(s,u)=>W(ye(s,i,Mt(n,r,u)),l=>{let o=new re(u,r,l.val),h=new pe(o,s);return new p(h)}))}else{let r=t[0],i=t[1];return W(ye(e,r,n),s=>W(ye(s.gen,i,n),u=>{let l=new _e(s.val,u.val),o=new pe(l,u.gen);return new p(o)}))}}function $r(e,t){return W(ye(e,t,Lt()),n=>new p(n.val))}function me(e,t){for(;;){let n=e,r=t;if(n instanceof nt)return n;if(n instanceof rt){let i=n[0],s=Ct(r,i);return s.isOk()?s[0]:n}else if(n instanceof _e){let i=n[0],s=n[1],u=me(i,r),l=me(s,r);if(u instanceof re){let o=u[0];e=u[2],t=Mt(r,o,l)}else return new _e(u,l)}else{let i=n[0],s=n[1],u=n[2];return new re(i,s,me(u,r))}}}function Ar(e){return me(e,Lt())}function Y(e){if(e instanceof nt){let t=e[0];return Ae(t)}else{if(e instanceof rt)return e[1];if(e instanceof re){let t=e[1],n=e[2];return"\\"+t+". "+Y(n)}else if(e instanceof _e&&e[0]instanceof re){let t=e[0],n=e[1];return"("+Y(t)+")("+Y(n)+")"}else{let t=e[0],n=e[1];return Y(t)+"("+Y(n)+")"}}}function Er(e){return e.isOk(),e[0]}function ke(){return y(G(),e=>y(et(a([br(),_r(),Or(),kr()])),t=>y(G(),n=>y(he(y(L("("),r=>y(tt(ke),i=>y(L(")"),s=>y(G(),u=>J(i)))))),r=>{let i=yt(r,t,(s,u)=>new gr(s,u));return J(i)}))))}function Or(){return y(L("\\"),e=>y(G(),t=>y(Ut(),n=>y(G(),r=>y(L("."),i=>y(G(),s=>y(tt(ke),u=>J(new Wt(n,u)))))))))}function kr(){return y(L("("),e=>y(tt(ke),t=>y(L(")"),n=>J(t))))}function Ir(e){let t=W(mt(pr(ke(),e),"there's a mistake in the notation somewhere; I couldn't understand it!"),n=>W($r(new qt(0),n),r=>{let i=Ar(r);return new p(Y(i))}));return Er(t)}class xe extends f{constructor(t,n){super(),this.untyped=t,this.typed=n}}class Ft extends f{constructor(t){super(),this[0]=t}}class Sr extends f{constructor(t){super(),this[0]=t}}function Lr(e){return new xe("","")}function Cr(e,t){if(t instanceof Ft){let n=t[0];return new xe(n,e.typed)}else{let n=t[0];return new xe(e.untyped,n)}}function Mr(e){return Te(a([]),a([Ne(a([]),a([c("Who I Am")])),de(a([]),a([c("I'm Ryan Brewer, the software developer behind "),V(a([F("https://github.com/RyanBrewer317/SaberVM")]),a([c("SaberVM")])),c(`,
an abstract machine for safe, portable computation that functional languages can compile to. 
With SaberVM, I'm hoping to broaden accessibility to safe computation, both informationally and financially. 
Consider supporting my work!
`)])),cr(a([Qn("https://github.com/sponsors/RyanBrewer317/button"),Z("title","Sponsor RyanBrewer317"),er(32),tr(114),Zn(a([["border","0"],["border-radius","6px;"]]))])),Ne(a([]),a([c("My Website")])),de(a([]),a([c("This is my website. It's hosted by Firebase and written mostly in "),V(a([F("https://gleam.run")]),a([c("Gleam")])),c(", and the code is up on my "),V(a([F("https://github.com/RyanBrewer317/ryanbrewer-dev")]),a([c("github")])),c(". The only framework used is "),V(a([F("https://lustre.build/")]),a([c("Lustre")])),c("; scripting, markup, styles, and layout were all done by hand.")])),Ne(a([]),a([c("Lambda Calculus in Gleam")])),de(a([]),a([c(`
I study programming language design, and I'm particularly fond of functional programming.
That's why I made this website in `),V(a([F("https://gleam.run")]),a([c("Gleam")])),c(`,
a statically-typed functional language
that can run anywhere JavaScript can, as well as on Erlang's BEAM VM. 
I've used Gleam to write a lambda calculus evaluator that you can play with below. 
Lambda abstractions are written like 
`),D(a([]),a([c("\\var. body")])),c(", and are called like "),D(a([]),a([c("fun(arg)")])),c(". There are also positive integers like 7. Try writing "),D(a([]),a([c("(\\x.x)(2)")])),c(", which evaluates to 2. The code for this can be found "),V(a([F("https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/tinylang.gleam")]),a([c("here")])),c(".")])),dt(a([Me("code"),ht("Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)(3)"),pt(t=>new Ft(t))])),ar(a([])),(()=>{if(e instanceof xe&&e.untyped==="")return c("");{let t=e.untyped,n=Ir(t);return(r=>Te(a([]),a([or(a([]),a([c("output ")])),c(" (variables may be renamed): "),Te(a([Me("code-output")]),a([c(r)]))])))(n)}})(),de(a([]),a([c(`Want types in your lambda calculus?
Below I've extended the evaluator with a simple dependent type system. 
Lambdas need to be annotated using a `),D(a([]),a([c("let")])),c("-binding, like "),D(a([]),a([c("let f: Int->Int = \\x. x; f(3)")])),c(". Pi types are written "),D(a([]),a([c("forall x: A. B")])),c(", and the type of types is "),D(a([]),a([c("Type")])),c(". The code for this extended evaluator can be found "),V(a([F("https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/tinytypedlang.gleam")]),a([c("here")])),c(".")])),dt(a([Me("typed-code"),ht("Write some typed lambda calculus code! Example: let f: Int->Int = \\x. x; f(3)"),pt(t=>new Sr(t))]))]))}function Nr(){let e=lr(Lr,Cr,Mr),t=Gn(e,"[data-lustre-app]",void 0);if(!t.isOk())throw qe("assignment_no_match","ryanbrewerdev",16,"main","Assignment pattern did not match",{value:t});return t[0]}document.addEventListener("DOMContentLoaded",()=>{Nr()});
