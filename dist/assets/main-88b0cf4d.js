var Ae=(e,t,n)=>{if(!t.has(e))throw TypeError("Cannot "+n)};var p=(e,t,n)=>(Ae(e,t,"read from private field"),n?n.call(e):t.get(e)),A=(e,t,n)=>{if(t.has(e))throw TypeError("Cannot add the same private member more than once");t instanceof WeakSet?t.add(e):t.set(e,n)},y=(e,t,n,r)=>(Ae(e,t,"write to private field"),r?r.call(e,n):t.set(e,n),n);var Z=(e,t,n)=>(Ae(e,t,"access private method"),n);import"./style-886bb2ef.js";class d{inspect(){console.warn("Deprecated method UtfCodepoint.inspect");let t=r=>{let i=K(this[r]);return isNaN(parseInt(r))?`${r}: ${i}`:i},n=Object.keys(this).map(t).join(", ");return n?`${this.constructor.name}(${n})`:this.constructor.name}withFields(t){let n=Object.keys(this).map(r=>r in t?t[r]:this[r]);return new this.constructor(...n)}}class B{static fromArray(t,n){let r=n||new be;return t.reduceRight((i,s)=>new Wt(s,i),r)}[Symbol.iterator](){return new Ft(this)}inspect(){return console.warn("Deprecated method UtfCodepoint.inspect"),`[${this.toArray().map(K).join(", ")}]`}toArray(){return[...this]}atLeastLength(t){for(let n of this){if(t<=0)return!0;t--}return t<=0}hasLength(t){for(let n of this){if(t<=0)return!1;t--}return t===0}countLength(){let t=0;for(let n of this)t++;return t}}function c(e,t){return B.fromArray(e,t)}var W;class Ft{constructor(t){A(this,W,void 0);y(this,W,t)}next(){if(p(this,W)instanceof be)return{done:!0};{let{head:t,tail:n}=p(this,W);return y(this,W,n),{value:t,done:!1}}}}W=new WeakMap;class be extends B{}class Wt extends B{constructor(t,n){super(),this.head=t,this.tail=n}}class pe{constructor(t){if(!(t instanceof Uint8Array))throw"BitArray can only be constructed from a Uint8Array";this.buffer=t}inspect(){return console.warn("Deprecated method UtfCodepoint.inspect"),`<<${Array.from(this.buffer).join(", ")}>>`}get length(){return this.buffer.length}byteAt(t){return this.buffer[t]}floatAt(t){return Vt(this.buffer.slice(t,t+8))}intFromSlice(t,n){return Bt(this.buffer.slice(t,n))}binaryFromSlice(t,n){return new pe(this.buffer.slice(t,n))}sliceAfter(t){return new pe(this.buffer.slice(t))}}function Bt(e){e=e.reverse();let t=0;for(let n=e.length-1;n>=0;n--)t=t*256+e[n];return t}function Vt(e){return new Float64Array(e.reverse().buffer)[0]}class ae extends d{static isResult(t){return t instanceof ae}}class m extends ae{constructor(t){super(),this[0]=t}isOk(){return!0}}class _ extends ae{constructor(t){super(),this[0]=t}isOk(){return!1}}function K(e){let t=typeof e;if(e===!0)return"True";if(e===!1)return"False";if(e===null)return"//js(null)";if(e===void 0)return"Nil";if(t==="string")return JSON.stringify(e);if(t==="bigint"||t==="number")return e.toString();if(Array.isArray(e))return`#(${e.map(K).join(", ")})`;if(e instanceof Set)return`//js(Set(${[...e].map(K).join(", ")}))`;if(e instanceof RegExp)return`//js(${e})`;if(e instanceof Date)return`//js(Date("${e.toISOString()}"))`;if(e instanceof Function){let n=[];for(let r of Array(e.length).keys())n.push(String.fromCharCode(r+97));return`//fn(${n.join(", ")}) { ... }`}try{return e.inspect()}catch{return Ht(e)}}function Ht(e){var u,l;let[t,n]=mt(e),r=((l=(u=Object.getPrototypeOf(e))==null?void 0:u.constructor)==null?void 0:l.name)||"Object",i=[];for(let o of t(e))i.push(`${K(o)}: ${K(n(e,o))}`);let s=i.length?" "+i.join(", ")+" ":"";return`//js(${r==="Object"?"":r+" "}{${s}})`}function q(e,t){let n=[e,t];for(;n.length;){let r=n.pop(),i=n.pop();if(r===i)continue;if(!tt(r)||!tt(i)||!Jt(r,i)||Yt(r,i)||Gt(r,i)||Pt(r,i)||Kt(r,i)||Xt(r,i))return!1;const a=Object.getPrototypeOf(r);if(a!==null&&typeof a.equals=="function")try{if(r.equals(i))continue;return!1}catch{}let[u,l]=mt(r);for(let o of u(r))n.push(l(r,o),l(i,o))}return!0}function mt(e){if(e instanceof Map)return[t=>t.keys(),(t,n)=>t.get(n)];{let t=e instanceof globalThis.Error?["message"]:[];return[n=>[...t,...Object.keys(n)],(n,r)=>n[r]]}}function Yt(e,t){return e instanceof Date&&(e>t||e<t)}function Gt(e,t){return e.buffer instanceof ArrayBuffer&&e.BYTES_PER_ELEMENT&&!(e.byteLength===t.byteLength&&e.every((n,r)=>n===t[r]))}function Pt(e,t){return Array.isArray(e)&&e.length!==t.length}function Kt(e,t){return e instanceof Map&&e.size!==t.size}function Xt(e,t){return e instanceof Set&&(e.size!=t.size||[...e].some(n=>!t.has(n)))}function tt(e){return typeof e=="object"&&e!==null}function Jt(e,t){return typeof e!="object"&&typeof t!="object"&&(!e||!t)||[Promise,WeakSet,WeakMap,Function].some(r=>e instanceof r)?!1:e.constructor===t.constructor}function f(e,t,n,r,i,s){let a=new globalThis.Error(i);a.gleam_error=e,a.module=t,a.line=n,a.fn=r;for(let u in s)a[u]=s[u];return a}class Re extends d{constructor(t){super(),this[0]=t}}class nt extends d{}function Zt(e,t){if(e instanceof Re){let n=e[0];return new m(n)}else return new _(t)}const rt=new WeakMap,Ne=new DataView(new ArrayBuffer(8));let ke=0;function Le(e){const t=rt.get(e);if(t!==void 0)return t;const n=ke++;return ke===2147483647&&(ke=0),rt.set(e,n),n}function Se(e,t){return e^t+2654435769+(e<<6)+(e>>2)|0}function qe(e){let t=0;const n=e.length;for(let r=0;r<n;r++)t=Math.imul(31,t)+e.charCodeAt(r)|0;return t}function wt(e){Ne.setFloat64(0,e);const t=Ne.getInt32(0),n=Ne.getInt32(4);return Math.imul(73244475,t>>16^t)^n}function Qt(e){return qe(e.toString())}function en(e){const t=Object.getPrototypeOf(e);if(t!==null&&typeof t.hashCode=="function")try{const r=e.hashCode(e);if(typeof r=="number")return r}catch{}if(e instanceof Promise||e instanceof WeakSet||e instanceof WeakMap)return Le(e);if(e instanceof Date)return wt(e.getTime());let n=0;if(e instanceof ArrayBuffer&&(e=new Uint8Array(e)),Array.isArray(e)||e instanceof Uint8Array)for(let r=0;r<e.length;r++)n=Math.imul(31,n)+N(e[r])|0;else if(e instanceof Set)e.forEach(r=>{n=n+N(r)|0});else if(e instanceof Map)e.forEach((r,i)=>{n=n+Se(N(r),N(i))|0});else{const r=Object.keys(e);for(let i=0;i<r.length;i++){const s=r[i],a=e[s];n=n+Se(N(a),qe(s))|0}}return n}function N(e){if(e===null)return 1108378658;if(e===void 0)return 1108378659;if(e===!0)return 1108378657;if(e===!1)return 1108378656;switch(typeof e){case"number":return wt(e);case"string":return qe(e);case"bigint":return Qt(e);case"object":return en(e);case"symbol":return Le(e);case"function":return Le(e);default:return 0}}const S=5,Ue=Math.pow(2,S),tn=Ue-1,nn=Ue/2,rn=Ue/4,b=0,L=1,O=2,V=3,Fe={type:O,bitmap:0,array:[]};function ue(e,t){return e>>>t&tn}function xe(e,t){return 1<<ue(e,t)}function sn(e){return e-=e>>1&1431655765,e=(e&858993459)+(e>>2&858993459),e=e+(e>>4)&252645135,e+=e>>8,e+=e>>16,e&127}function We(e,t){return sn(e&t-1)}function k(e,t,n){const r=e.length,i=new Array(r);for(let s=0;s<r;++s)i[s]=e[s];return i[t]=n,i}function an(e,t,n){const r=e.length,i=new Array(r+1);let s=0,a=0;for(;s<t;)i[a++]=e[s++];for(i[a++]=n;s<r;)i[a++]=e[s++];return i}function je(e,t){const n=e.length,r=new Array(n-1);let i=0,s=0;for(;i<t;)r[s++]=e[i++];for(++i;i<n;)r[s++]=e[i++];return r}function yt(e,t,n,r,i,s){const a=N(t);if(a===r)return{type:V,hash:a,array:[{type:b,k:t,v:n},{type:b,k:i,v:s}]};const u={val:!1};return le(Be(Fe,e,a,t,n,u),e,r,i,s,u)}function le(e,t,n,r,i,s){switch(e.type){case L:return un(e,t,n,r,i,s);case O:return Be(e,t,n,r,i,s);case V:return ln(e,t,n,r,i,s)}}function un(e,t,n,r,i,s){const a=ue(n,t),u=e.array[a];if(u===void 0)return s.val=!0,{type:L,size:e.size+1,array:k(e.array,a,{type:b,k:r,v:i})};if(u.type===b)return q(r,u.k)?i===u.v?e:{type:L,size:e.size,array:k(e.array,a,{type:b,k:r,v:i})}:(s.val=!0,{type:L,size:e.size,array:k(e.array,a,yt(t+S,u.k,u.v,n,r,i))});const l=le(u,t+S,n,r,i,s);return l===u?e:{type:L,size:e.size,array:k(e.array,a,l)}}function Be(e,t,n,r,i,s){const a=xe(n,t),u=We(e.bitmap,a);if(e.bitmap&a){const l=e.array[u];if(l.type!==b){const h=le(l,t+S,n,r,i,s);return h===l?e:{type:O,bitmap:e.bitmap,array:k(e.array,u,h)}}const o=l.k;return q(r,o)?i===l.v?e:{type:O,bitmap:e.bitmap,array:k(e.array,u,{type:b,k:r,v:i})}:(s.val=!0,{type:O,bitmap:e.bitmap,array:k(e.array,u,yt(t+S,o,l.v,n,r,i))})}else{const l=e.array.length;if(l>=nn){const o=new Array(32),h=ue(n,t);o[h]=Be(Fe,t+S,n,r,i,s);let z=0,E=e.bitmap;for(let J=0;J<32;J++){if(E&1){const Ut=e.array[z++];o[J]=Ut}E=E>>>1}return{type:L,size:l+1,array:o}}else{const o=an(e.array,u,{type:b,k:r,v:i});return s.val=!0,{type:O,bitmap:e.bitmap|a,array:o}}}}function ln(e,t,n,r,i,s){if(n===e.hash){const a=Ve(e,r);if(a!==-1)return e.array[a].v===i?e:{type:V,hash:n,array:k(e.array,a,{type:b,k:r,v:i})};const u=e.array.length;return s.val=!0,{type:V,hash:n,array:k(e.array,u,{type:b,k:r,v:i})}}return le({type:O,bitmap:xe(e.hash,t),array:[e]},t,n,r,i,s)}function Ve(e,t){const n=e.array.length;for(let r=0;r<n;r++)if(q(t,e.array[r].k))return r;return-1}function me(e,t,n,r){switch(e.type){case L:return cn(e,t,n,r);case O:return on(e,t,n,r);case V:return fn(e,r)}}function cn(e,t,n,r){const i=ue(n,t),s=e.array[i];if(s!==void 0){if(s.type!==b)return me(s,t+S,n,r);if(q(r,s.k))return s}}function on(e,t,n,r){const i=xe(n,t);if(!(e.bitmap&i))return;const s=We(e.bitmap,i),a=e.array[s];if(a.type!==b)return me(a,t+S,n,r);if(q(r,a.k))return a}function fn(e,t){const n=Ve(e,t);if(!(n<0))return e.array[n]}function He(e,t,n,r){switch(e.type){case L:return hn(e,t,n,r);case O:return dn(e,t,n,r);case V:return pn(e,r)}}function hn(e,t,n,r){const i=ue(n,t),s=e.array[i];if(s===void 0)return e;let a;if(s.type===b){if(!q(s.k,r))return e}else if(a=He(s,t+S,n,r),a===s)return e;if(a===void 0){if(e.size<=rn){const u=e.array,l=new Array(e.size-1);let o=0,h=0,z=0;for(;o<i;){const E=u[o];E!==void 0&&(l[h]=E,z|=1<<o,++h),++o}for(++o;o<u.length;){const E=u[o];E!==void 0&&(l[h]=E,z|=1<<o,++h),++o}return{type:O,bitmap:z,array:l}}return{type:L,size:e.size-1,array:k(e.array,i,a)}}return{type:L,size:e.size,array:k(e.array,i,a)}}function dn(e,t,n,r){const i=xe(n,t);if(!(e.bitmap&i))return e;const s=We(e.bitmap,i),a=e.array[s];if(a.type!==b){const u=He(a,t+S,n,r);return u===a?e:u!==void 0?{type:O,bitmap:e.bitmap,array:k(e.array,s,u)}:e.bitmap===i?void 0:{type:O,bitmap:e.bitmap^i,array:je(e.array,s)}}return q(r,a.k)?e.bitmap===i?void 0:{type:O,bitmap:e.bitmap^i,array:je(e.array,s)}:e}function pn(e,t){const n=Ve(e,t);if(n<0)return e;if(e.array.length!==1)return{type:V,hash:e.hash,array:je(e.array,n)}}function gt(e,t){if(e===void 0)return;const n=e.array,r=n.length;for(let i=0;i<r;i++){const s=n[i];if(s!==void 0){if(s.type===b){t(s.v,s.k);continue}gt(s,t)}}}class I{static fromObject(t){const n=Object.keys(t);let r=I.new();for(let i=0;i<n.length;i++){const s=n[i];r=r.set(s,t[s])}return r}static fromMap(t){let n=I.new();return t.forEach((r,i)=>{n=n.set(i,r)}),n}static new(){return new I(void 0,0)}constructor(t,n){this.root=t,this.size=n}get(t,n){if(this.root===void 0)return n;const r=me(this.root,0,N(t),t);return r===void 0?n:r.v}set(t,n){const r={val:!1},i=this.root===void 0?Fe:this.root,s=le(i,0,N(t),t,n,r);return s===this.root?this:new I(s,r.val?this.size+1:this.size)}delete(t){if(this.root===void 0)return this;const n=He(this.root,0,N(t),t);return n===this.root?this:n===void 0?I.new():new I(n,this.size-1)}has(t){return this.root===void 0?!1:me(this.root,0,N(t),t)!==void 0}entries(){if(this.root===void 0)return[];const t=[];return this.forEach((n,r)=>t.push([r,n])),t}forEach(t){gt(this.root,t)}hashCode(){let t=0;return this.forEach((n,r)=>{t=t+Se(N(n),N(r))|0}),t}equals(t){if(!(t instanceof I)||this.size!==t.size)return!1;let n=!0;return this.forEach((r,i)=>{n=n&&q(t.get(i,!r),r)}),n}}const _t=void 0,it={};function mn(e){return/^[-+]?(\d+)$/.test(e)?new m(parseInt(e)):new _(_t)}function wn(e){return e.toString()}function yn(e){return B.fromArray(Array.from(gn(e)).map(t=>t.segment))}function gn(e){if(Intl&&Intl.Segmenter)return new Intl.Segmenter().segment(e)[Symbol.iterator]()}function _n(e){let t="";for(const n of e)t=t+n;return t}function Ye(e,t){return e.indexOf(t)>=0}function bn(){return I.new()}function bt(e,t){const n=e.get(t,it);return n===it?new _(_t):new m(n)}function xn(e,t,n){return n.set(e,t)}function xt(e){if(typeof e=="string")return"String";if(e instanceof ae)return"Result";if(e instanceof B)return"List";if(e instanceof pe)return"BitArray";if(e instanceof I)return"Map";if(Number.isInteger(e))return"Int";if(Array.isArray(e))return`Tuple of ${e.length} elements`;if(typeof e=="number")return"Float";if(e===null)return"Null";if(e===void 0)return"Nil";{const t=typeof e;return t.charAt(0).toUpperCase()+t.slice(1)}}function Ge(e,t){return $n(e,xt(t))}function $n(e,t){return new _(B.fromArray([new Pe(e,t,B.fromArray([]))]))}function On(e){return typeof e=="string"?new m(e):Ge("String",e)}function An(e){return Number.isInteger(e)?new m(e):Ge("Int",e)}function Nn(e,t){const n=()=>Ge("Map",e);if(e instanceof I||e instanceof WeakMap||e instanceof Map){const r=bt(e,t);return new m(r.isOk()?new Re(r[0]):new nt)}else return Object.getPrototypeOf(e)==Object.prototype?st(e,t,()=>new m(new nt)):st(e,t,n)}function st(e,t,n){try{return t in e?new m(new Re(e[t])):n()}catch{return n()}}function kn(e){return mn(e)}function $t(e){return wn(e)}function Ce(){return bn()}function we(e,t){return bt(e,t)}function ze(e,t,n){return xn(t,n,e)}function En(e,t){for(;;){let n=e,r=t;if(n.hasLength(0))return r;if(n.atLeastLength(1)){let i=n.head;e=n.tail,t=c([i],r)}else throw f("case_no_match","gleam/list",124,"do_reverse_acc","No case clause matched",{values:[n]})}}function In(e){return En(e,c([]))}function Ln(e){return In(e)}function Sn(e,t,n){for(;;){let r=e,i=t,s=n;if(r.hasLength(0))return Ln(s);if(r.atLeastLength(1)){let a=r.head;e=r.tail,t=i,n=c([i(a)],s)}else throw f("case_no_match","gleam/list",361,"do_map","No case clause matched",{values:[r]})}}function jn(e,t){return Sn(e,t,c([]))}function Cn(e,t,n){for(;;){let r=e,i=t,s=n;if(r.hasLength(0))return i;if(r.atLeastLength(1)){let a=r.head;e=r.tail,t=s(i,a),n=s}else throw f("case_no_match","gleam/list",726,"fold","No case clause matched",{values:[r]})}}function ce(e,t){if(e.isOk()){let n=e[0];return new m(t(n))}else{if(e.isOk())throw f("case_no_match","gleam/result",67,"map","No case clause matched",{values:[e]});{let n=e[0];return new _(n)}}}function zn(e,t){if(e.isOk()){let n=e[0];return new m(n)}else{if(e.isOk())throw f("case_no_match","gleam/result",95,"map_error","No case clause matched",{values:[e]});{let n=e[0];return new _(t(n))}}}function R(e,t){if(e.isOk()){let n=e[0];return t(n)}else{if(e.isOk())throw f("case_no_match","gleam/result",162,"try","No case clause matched",{values:[e]});{let n=e[0];return new _(n)}}}function ye(e,t){if(e.isOk())return e[0];if(e.isOk())throw f("case_no_match","gleam/result",215,"lazy_unwrap","No case clause matched",{values:[e]});return t()}function Tn(e,t){if(e.isOk())return e;if(e.isOk())throw f("case_no_match","gleam/result",308,"or","No case clause matched",{values:[e]});return t}function Ot(e,t){if(e.isOk()){let n=e[0];return new m(n)}else{if(e.isOk())throw f("case_no_match","gleam/result",428,"replace_error","No case clause matched",{values:[e]});return new _(t)}}function At(e){return _n(e)}function Nt(e){return e}class Pe extends d{constructor(t,n,r){super(),this.expected=t,this.found=n,this.path=r}}function kt(e){return e}function Et(e){return On(e)}function It(e){return xt(e)}function vn(e){return An(e)}function Lt(e){return t=>{if(e.hasLength(0))return new _(c([new Pe("another type",It(t),c([]))]));if(e.atLeastLength(1)){let n=e.head,r=e.tail,i=n(t);if(i.isOk()){let s=i[0];return new m(s)}else{if(i.isOk())throw f("case_no_match","gleam/dynamic",1014,"","No case clause matched",{values:[i]});return Lt(r)(t)}}else throw f("case_no_match","gleam/dynamic",1007,"","No case clause matched",{values:[e]})}}function Mn(e,t){let n=kt(t),r=Lt(c([Et,s=>ce(vn(s),$t)])),i=(()=>{let s=r(n);if(s.isOk())return s[0];if(s.isOk())throw f("case_no_match","gleam/dynamic",598,"push_path","No case clause matched",{values:[s]});{let a=c(["<",It(n),">"]),u=At(a);return Nt(u)}})();return e.withFields({path:c([i],e.path)})}function Dn(e,t){return zn(e,n=>jn(n,t))}function at(e,t){return n=>{let r=new Pe("field","nothing",c([]));return R(Nn(n,e),i=>{let a=Zt(i,c([r])),u=R(a,t);return Dn(u,l=>Mn(l,e))})}}function Rn(e,t){return n=>t(e(n))}class qn extends d{constructor(t){super(),this.all=t}}function ut(){return new qn(c([]))}function F(e,t,n,r){return t[3]?(e==null?void 0:e.nodeType)===1&&e.nodeName===t[0].toUpperCase()&&e.namespaceURI===t[3]?ct(e,t,t[3],n,r):lt(e,t,t[3],n,r):t[2]?(e==null?void 0:e.nodeType)===1&&e.nodeName===t[0].toUpperCase()?ct(e,t,null,n,r):lt(e,t,null,n,r):typeof(t==null?void 0:t[0])=="string"?(e==null?void 0:e.nodeType)===3?Fn(e,t):Un(e,t):document.createComment(["[internal lustre error] I couldn't work out how to render this element. This","function should only be called internally by lustre's runtime: if you think","this is an error, please open an issue at","https://github.com/hayleigh-dot-dev/gleam-lustre/issues/new"].join(" "))}function lt(e,t,n,r,i=null){const s=n?document.createElementNS(n,t[0]):document.createElement(t[0]);s.$lustre={};let a=t[1];for(;a.head;)a.head[0]==="class"?ne(s,a.head[0],`${s.className} ${a.head[1]}`):a.head[0]==="style"?ne(s,a.head[0],`${s.style.cssText} ${a.head[1]}`):ne(s,a.head[0],a.head[1],r),a=a.tail;if(customElements.get(t[0]))s._slot=t[2];else if(t[0]==="slot"){let u=new be,l=i;for(;l;)if(l._slot){u=l._slot;break}else l=l.parentNode;for(;u.head;)s.appendChild(F(null,u.head,r,s)),u=u.tail}else{let u=t[2];for(;u.head;)s.appendChild(F(null,u.head,r,s)),u=u.tail}return e&&e.replaceWith(s),s}function ct(e,t,n,r,i){const s=e.attributes,a=new Map;e.$lustre??(e.$lustre={});let u=t[1];for(;u.head;)u.head[0]==="class"&&a.has("class")?a.set(u.head[0],`${a.get("class")} ${u.head[1]}`):u.head[0]==="style"&&a.has("style")?a.set(u.head[0],`${a.get("style")} ${u.head[1]}`):a.set(u.head[0],u.head[1]),u=u.tail;for(const{name:l,value:o}of s)if(!a.has(l))e.removeAttribute(l);else{const h=a.get(l);h!==o&&(ne(e,l,h,r),a.delete(l))}for(const[l,o]of a)ne(e,l,o,r);if(customElements.get(t[0]))e._slot=t[2];else if(t[0]==="slot"){let l=e.firstChild,o=new be,h=i;for(;h;)if(h._slot){o=h._slot;break}else h=h.parentNode;for(;l;)o.head&&(F(l,o.head,r,e),o=o.tail),l=l.nextSibling;for(;o.head;)e.appendChild(F(null,o.head,r,e)),o=o.tail}else{let l=e.firstChild,o=t[2];for(;l;)if(o.head){const h=l.nextSibling;F(l,o.head,r,e),o=o.tail,l=h}else{const h=l.nextSibling;l.remove(),l=h}for(;o.head;)e.appendChild(F(null,o.head,r,e)),o=o.tail}return e}function ne(e,t,n,r){switch(typeof n){case"string":e.getAttribute(t)!==n&&e.setAttribute(t,n),n===""&&e.removeAttribute(t),t==="value"&&e.value!==n&&(e.value=n);break;case(t.startsWith("on")&&"function"):{if(e.$lustre[t]===n)break;const i=t.slice(2).toLowerCase(),s=a=>ce(n(a),r);e.$lustre[`${t}Handler`]&&e.removeEventListener(i,e.$lustre[`${t}Handler`]),e.addEventListener(i,s),e.$lustre[t]=n,e.$lustre[`${t}Handler`]=s;break}default:e[t]=n}}function Un(e,t){const n=document.createTextNode(t[0]);return e&&e.replaceWith(n),n}function Fn(e,t){const n=e.nodeValue,r=t[0];return r?(n!==r&&(e.nodeValue=r),e):(e==null||e.remove(),null)}var $,T,v,M,D,re,G,P,ie,Te,se,ve;class Wn{constructor(t,n,r){A(this,ie);A(this,se);A(this,$,null);A(this,T,null);A(this,v,[]);A(this,M,[]);A(this,D,!1);A(this,re,null);A(this,G,null);A(this,P,null);y(this,re,t),y(this,G,n),y(this,P,r)}start(t,n){if(!Hn())return new _(new tr);if(p(this,$))return new _(new Zn);if(y(this,$,t instanceof HTMLElement?t:document.querySelector(t)),!p(this,$))return new _(new er);const[r,i]=p(this,re).call(this,n);return y(this,T,r),y(this,M,i.all.toArray()),y(this,D,!0),window.requestAnimationFrame(()=>Z(this,ie,Te).call(this)),new m(s=>this.dispatch(s))}dispatch(t){p(this,v).push(t),Z(this,ie,Te).call(this)}emit(t,n=null){p(this,$).dispatchEvent(new CustomEvent(t,{bubbles:!0,detail:n,composed:!0}))}destroy(){if(!p(this,$))return new _(new Qn);p(this,$).remove(),y(this,$,null),y(this,T,null),y(this,v,[]),y(this,M,[]),y(this,D,!1),y(this,G,()=>{}),y(this,P,()=>{})}}$=new WeakMap,T=new WeakMap,v=new WeakMap,M=new WeakMap,D=new WeakMap,re=new WeakMap,G=new WeakMap,P=new WeakMap,ie=new WeakSet,Te=function(){if(Z(this,se,ve).call(this),p(this,D)){const t=p(this,P).call(this,p(this,T));y(this,$,F(p(this,$),t,n=>this.dispatch(n))),y(this,D,!1)}},se=new WeakSet,ve=function(t=0){if(p(this,$)){if(p(this,v).length)for(;p(this,v).length;){const[n,r]=p(this,G).call(this,p(this,T),p(this,v).shift());p(this,D)||y(this,D,p(this,T)!==n),y(this,T,n),y(this,M,p(this,M).concat(r.all.toArray()))}for(;p(this,M).length;)p(this,M).shift()(n=>this.dispatch(n),(n,r)=>this.emit(n,r));p(this,v).length&&(t>=5?console.warn(tooManyUpdates):Z(this,se,ve).call(this,++t))}};const Bn=(e,t,n)=>new Wn(e,t,n),Vn=(e,t,n)=>e.start(t,n),Hn=()=>window&&window.document;function St(e){let n=At(e);return Nt(n)}class Yn extends d{constructor(t,n,r){super(),this[0]=t,this[1]=n,this.as_property=r}}class Gn extends d{constructor(t,n){super(),this[0]=t,this[1]=n}}function Ke(e,t){return new Yn(e,kt(t),!1)}function Pn(e,t){return new Gn("on"+e,Rn(t,n=>Ot(n,void 0)))}function ot(e){return Ke("id",e)}function Kn(e){return Ke("placeholder",e)}function Q(e){return Ke("href",e)}class Xn extends d{constructor(t){super(),this[0]=t}}class Jn extends d{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}}function U(e,t,n){return new Jn(e,t,n)}function w(e){return new Xn(e)}class Zn extends d{}class Qn extends d{}class er extends d{}class tr extends d{}function nr(e,t,n){return Bn(s=>[e(s),ut()],(s,a)=>[t(s,a),ut()],n)}function ft(e,t){return U("h3",e,t)}function Ee(e,t){return U("div",e,t)}function ht(e,t){return U("p",e,t)}function ee(e,t){return U("a",e,t)}function rr(e){return U("br",e,c([]))}function Ie(e,t){return U("code",e,t)}function ir(e,t){return U("strong",e,t)}function sr(e){return U("textarea",e,c([]))}function ar(e,t){return Pn(e,t)}function ur(e){let t=e;return at("target",at("value",Et))(t)}function lr(e){return ar("input",t=>{let n=ur(t);return ce(n,e)})}class Me extends d{constructor(t){super(),this.error=t}}class fe extends d{constructor(t,n){super(),this.row=t,this.col=n}}class C extends d{constructor(t){super(),this.parse=t}}function x(e,t,n){if(e instanceof C){let r=e.parse;return r(t,n)}else throw f("case_no_match","party",37,"run","No case clause matched",{values:[e]})}function $e(e){return new C((t,n)=>{if(!(n instanceof fe))throw f("assignment_no_match","party",58,"","Assignment pattern did not match",{value:n});let r=n.row,i=n.col;if(t.atLeastLength(1)){let s=t.head,a=t.tail,u=e(s);if(u)return s===`
`?new m([s,a,new fe(r+1,0)]):new m([s,a,new fe(r,i+1)]);if(u)throw f("case_no_match","party",61,"","No case clause matched",{values:[u]});return new _(new Me(s))}else{if(t.hasLength(0))return new _(new Me("EOF"));throw f("case_no_match","party",59,"","No case clause matched",{values:[t]})}})}function j(e){return $e(t=>e===t)}function Xe(e,t){return new C((n,r)=>Tn(x(e,n,r),x(t,n,r)))}function Je(e){return new C((t,n)=>{if(e.hasLength(0))return new _(new Me("choiceless choice"));if(e.hasLength(1)){let r=e.head;return x(r,t,n)}else if(e.atLeastLength(1)){let r=e.head,i=e.tail,s=x(r,t,n);if(s.isOk()){let a=s[0][0],u=s[0][1],l=s[0][2];return new m([a,u,l])}else{if(s.isOk())throw f("case_no_match","party",111,"","No case clause matched",{values:[s]});return x(Je(i),t,n)}}else throw f("case_no_match","party",107,"","No case clause matched",{values:[e]})})}function oe(e){return new C((t,n)=>{let r=x(e,t,n);if(r.isOk())if(r.isOk()){let i=r[0][0],s=r[0][1],a=r[0][2];return ce(x(oe(e),s,a),u=>[c([i],u[0]),u[1],u[2]])}else throw f("case_no_match","party",140,"","No case clause matched",{values:[r]});else return new m([c([]),t,n])})}function cr(e){return new C((t,n)=>{let r=x(e,t,n);if(r.isOk())if(r.isOk()){let i=r[0][0],s=r[0][1],a=r[0][2];return ce(x(oe(e),s,a),u=>[c([i],u[0]),u[1],u[2]])}else throw f("case_no_match","party",155,"","No case clause matched",{values:[r]});else{let i=r[0];return new _(i)}})}function te(e,t){return new C((n,r)=>{let i=x(e,n,r);if(i.isOk()){let s=i[0][0],a=i[0][1],u=i[0][2];return new m([t(s),a,u])}else{if(i.isOk())throw f("case_no_match","party",175,"","No case clause matched",{values:[i]});{let s=i[0];return new _(s)}}})}function Ze(e){return new C((t,n)=>x(e(),t,n))}function g(e,t){return new C((n,r)=>{let i=x(e,n,r);if(i.isOk()){let s=i[0][0],a=i[0][1],u=i[0][2];return x(t(s),a,u)}else{if(i.isOk())throw f("case_no_match","party",287,"","No case clause matched",{values:[i]});{let s=i[0];return new _(s)}}})}function X(e){return new C((t,n)=>new m([e,t,n]))}function or(e,t){let n=x(e,yn(t),new fe(1,1));if(n.isOk()){let r=n[0][0];return new m(r)}else{if(n.isOk())throw f("case_no_match","party",44,"go","No case clause matched",{values:[n]});{let r=n[0];return new _(r)}}}function fr(){return $e(e=>Ye("abcdefghijklmnopqrstuvwxyz",e))}function hr(){return $e(e=>Ye("ABCDEFGHIJKLMNOPQRSTUVWXYZ",e))}function jt(){return Xe(fr(),hr())}function Ct(){return $e(e=>Ye("0123456789",e))}function dr(){return Xe(Ct(),jt())}class zt extends d{constructor(t){super(),this[0]=t}}class Tt extends d{constructor(t){super(),this[0]=t}}class vt extends d{constructor(t,n){super(),this[0]=t,this[1]=n}}class Mt extends d{constructor(t,n){super(),this[0]=t,this[1]=n}}class Dt extends d{constructor(t){super(),this.int=t}}class H extends d{constructor(t,n){super(),this.gen=t,this.val=n}}class Qe extends d{constructor(t){super(),this[0]=t}}class et extends d{constructor(t){super(),this[0]=t}}class ge extends d{constructor(t,n){super(),this[0]=t,this[1]=n}}class _e extends d{constructor(t,n){super(),this[0]=t,this[1]=n}}function pr(){let e=cr(Ct()),t=te(e,St),n=te(t,kn),r=te(n,i=>ye(i,()=>{throw f("todo","tinylang",19,"","parsed int isn't an int",{})}));return te(r,i=>new zt(i))}function Rt(){return g(jt(),e=>g(oe(Xe(dr(),j("_"))),t=>X(e+St(t))))}function mr(){let e=Rt();return te(e,t=>new Tt(t))}function Y(){return g(oe(Je(c([j(" "),j("	"),j(`
`)]))),e=>X(void 0))}function wr(e,t){return t(new Dt(e.int+1),e.int)}function dt(e,t){return new H(t,e)}function pt(e,t){return new m(new H(e,t()))}function he(e,t,n,r){if(t instanceof zt){let i=t[0];return new m((()=>{let s=[new Qe(i),r];return dt(s,e)})())}else if(t instanceof Tt){let i=t[0],s=we(n,i);if(s.isOk()){let a=s[0];return new m((()=>{let u=[new et(a),r];return dt(u,e)})())}else{if(!s.isOk()&&!s[0])return new _("Wait! "+i+" isn't defined anywhere!");throw f("case_no_match","tinylang",130,"translate_helper","No case clause matched",{values:[s]})}}else if(t instanceof vt){let i=t[0],s=t[1];return wr(e,(a,u)=>R(he(a,s,ze(n,i,u),r),l=>{if(!(l instanceof H))throw f("assignment_no_match","tinylang",140,"","Assignment pattern did not match",{value:l});let o=l.gen,h=l.val[0],z=l.val[1];return pt(o,()=>[new ge(u,h),ze(z,u,i)])}))}else if(t instanceof Mt){let i=t[0],s=t[1];return R(he(e,i,n,r),a=>{if(!(a instanceof H))throw f("assignment_no_match","tinylang",150,"","Assignment pattern did not match",{value:a});let u=a.gen,l=a.val[0],o=a.val[1];return R(he(u,s,n,o),h=>{if(!(h instanceof H))throw f("assignment_no_match","tinylang",156,"","Assignment pattern did not match",{value:h});let z=h.gen,E=h.val[0],J=h.val[1];return pt(z,()=>[new _e(l,E),J])})})}else throw f("case_no_match","tinylang",123,"translate_helper","No case clause matched",{values:[t]})}function yr(e,t){return R(he(e,t,Ce(),Ce()),n=>{if(!(n instanceof H))throw f("assignment_no_match","tinylang",108,"","Assignment pattern did not match",{value:n});let r=n.val;return new m(r)})}function De(e,t){for(;;){let n=e,r=t;if(n instanceof Qe)return n;if(n instanceof ge)return n;if(n instanceof et){let i=n[0];return ye(we(r,i),()=>{throw f("todo","tinylang",178,"","undefined after renaming",{})})}else if(n instanceof _e){let i=n[0],s=n[1],a=De(i,r),u=De(s,r);if(a instanceof ge){let l=a[0];e=a[1],t=ze(r,l,u)}else return new _e(a,u)}else throw f("case_no_match","tinylang",173,"eval_helper","No case clause matched",{values:[n]})}}function gr(e){return De(e,Ce())}function de(e,t){if(e instanceof Qe){let n=e[0];return $t(n)}else if(e instanceof et){let n=e[0];return ye(we(t,n),()=>{throw f("todo","tinylang",197,"","identifier with no rename",{})})}else if(e instanceof ge){let n=e[0],r=e[1];return"\\"+ye(we(t,n),()=>{throw f("todo","tinylang",202,"","parameter with no rename",{})})+". "+de(r,t)}else if(e instanceof _e){let n=e[0],r=e[1];return de(n,t)+"("+de(r,t)+")"}else throw f("case_no_match","tinylang",192,"pretty","No case clause matched",{values:[e]})}function _r(e){if(e.isOk())return e[0];if(e.isOk())throw f("case_no_match","tinylang",210,"squash_res","No case clause matched",{values:[e]});return e[0]}function Oe(){return g(Y(),e=>g(Je(c([pr(),mr(),br(),xr()])),t=>g(Y(),n=>g(oe(g(j("("),r=>g(Ze(Oe),i=>g(j(")"),s=>g(Y(),a=>X(i)))))),r=>{let i=Cn(r,t,(s,a)=>new Mt(s,a));return X(i)}))))}function br(){return g(j("\\"),e=>g(Y(),t=>g(Rt(),n=>g(Y(),r=>g(j("."),i=>g(Y(),s=>g(Ze(Oe),a=>X(new vt(n,a)))))))))}function xr(){return g(j("("),e=>g(Ze(Oe),t=>g(j(")"),n=>X(t))))}function $r(e){let t=R(Ot(or(Oe(),e),"there's a mistake in the notation somewhere; I couldn't understand it!"),n=>R(yr(new Dt(0),n),r=>{let i=r[0],s=r[1],a=gr(i);return new m(de(a,s))}));return _r(t)}class qt extends d{constructor(t){super(),this[0]=t}}function Or(e){return""}function Ar(e,t){if(t instanceof qt)return t[0];throw f("case_no_match","ryanbrewerdev",31,"update","No case clause matched",{values:[t]})}function Nr(e){return Ee(c([]),c([ft(c([]),c([w("My Website")])),ht(c([]),c([w("This is my website. It's hosted by Firebase and written mostly in "),ee(c([Q("https://gleam.run")]),c([w("Gleam")])),w(", and the code is up on my "),ee(c([Q("https://github.com/RyanBrewer317/ryanbrewer-dev")]),c([w("github")])),w(". The only framework used is "),ee(c([Q("https://lustre.build/")]),c([w("Lustre")])),w("; Scripting, markup, styles, and layout were all done by hand.")])),ft(c([]),c([w("Lambda Calculus in Gleam")])),ht(c([]),c([w(`
I study programming language design, and I'm particularly fond of functional programming.
That's why I made this website in `),ee(c([Q("https://gleam.run")]),c([w("Gleam")])),w(`
, a statically-typed functional language
that can run anywhere JavaScript can, as well as on Erlang's BEAM VM. 
I've used Gleam to write a lambda calculus evaluator that you can play with below. 
Lambda abstractions are written like 
`),Ie(c([]),c([w("\\var. body")])),w(", and are called like "),Ie(c([]),c([w("fun(arg)")])),w(". There are also positive integers like 7. Try writing "),Ie(c([]),c([w("(\\x.x)(2)")])),w(", which evaluates to 2. The code for this can be found "),ee(c([Q("https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/tinylang.gleam")]),c([w("here")])),w(".")])),sr(c([ot("code"),Kn("Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)(3)"),lr(t=>new qt(t))])),rr(c([])),(()=>{if(e==="")return w("");{let n=$r(e);return(r=>Ee(c([]),c([ir(c([]),c([w("output ")])),w(" (variables may be renamed): "),Ee(c([ot("code-output")]),c([w(r)]))])))(n)}})()]))}function kr(){let e=nr(Or,Ar,Nr),t=Vn(e,"[data-lustre-app]",void 0);if(!t.isOk())throw f("assignment_no_match","ryanbrewerdev",14,"main","Assignment pattern did not match",{value:t});return t[0]}document.addEventListener("DOMContentLoaded",()=>{kr()});