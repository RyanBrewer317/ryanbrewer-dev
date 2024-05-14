var st=(e,t,n)=>{if(!t.has(e))throw TypeError("Cannot "+n)};var _=(e,t,n)=>(st(e,t,"read from private field"),n?n.call(e):t.get(e)),S=(e,t,n)=>{if(t.has(e))throw TypeError("Cannot add the same private member more than once");t instanceof WeakSet?t.add(e):t.set(e,n)},g=(e,t,n,r)=>(st(e,t,"write to private field"),r?r.call(e,n):t.set(e,n),n);var $e=(e,t,n)=>(st(e,t,"access private method"),n);import"./style-b7ef9c88.js";class h{withFields(t){let n=Object.keys(this).map(r=>r in t?t[r]:this[r]);return new this.constructor(...n)}}class ie{static fromArray(t,n){let r=n||new Xe;for(let i=t.length-1;i>=0;--i)r=new Gt(t[i],r);return r}[Symbol.iterator](){return new kn(this)}toArray(){return[...this]}atLeastLength(t){for(let n of this){if(t<=0)return!0;t--}return t<=0}hasLength(t){for(let n of this){if(t<=0)return!1;t--}return t===0}countLength(){let t=0;for(let n of this)t++;return t}}function Le(e,t){return new Gt(e,t)}function a(e,t){return ie.fromArray(e,t)}var oe;class kn{constructor(t){S(this,oe,void 0);g(this,oe,t)}next(){if(_(this,oe)instanceof Xe)return{done:!0};{let{head:t,tail:n}=_(this,oe);return g(this,oe,n),{value:t,done:!1}}}}oe=new WeakMap;class Xe extends ie{}class Gt extends ie{constructor(t,n){super(),this.head=t,this.tail=n}}class Pe{constructor(t){if(!(t instanceof Uint8Array))throw"BitArray can only be constructed from a Uint8Array";this.buffer=t}get length(){return this.buffer.length}byteAt(t){return this.buffer[t]}floatAt(t){return Ln(this.buffer.slice(t,t+8))}intFromSlice(t,n){return On(this.buffer.slice(t,n))}binaryFromSlice(t,n){return new Pe(this.buffer.slice(t,n))}sliceAfter(t){return new Pe(this.buffer.slice(t))}}function On(e){e=e.reverse();let t=0;for(let n=e.length-1;n>=0;n--)t=t*256+e[n];return t}function Ln(e){return new Float64Array(e.reverse().buffer)[0]}class ve extends h{static isResult(t){return t instanceof ve}}class o extends ve{constructor(t){super(),this[0]=t}isOk(){return!0}}class y extends ve{constructor(t){super(),this[0]=t}isOk(){return!1}}function se(e,t){let n=[e,t];for(;n.length;){let r=n.pop(),i=n.pop();if(r===i)continue;if(!Wt(r)||!Wt(i)||!zn(r,i)||Tn(r,i)||Sn(r,i)||Cn(r,i)||Rn(r,i)||Mn(r,i)||Nn(r,i))return!1;const u=Object.getPrototypeOf(r);if(u!==null&&typeof u.equals=="function")try{if(r.equals(i))continue;return!1}catch{}let[l,f]=vn(r);for(let d of l(r))n.push(f(r,d),f(i,d))}return!0}function vn(e){if(e instanceof Map)return[t=>t.keys(),(t,n)=>t.get(n)];{let t=e instanceof globalThis.Error?["message"]:[];return[n=>[...t,...Object.keys(n)],(n,r)=>n[r]]}}function Tn(e,t){return e instanceof Date&&(e>t||e<t)}function Sn(e,t){return e.buffer instanceof ArrayBuffer&&e.BYTES_PER_ELEMENT&&!(e.byteLength===t.byteLength&&e.every((n,r)=>n===t[r]))}function Cn(e,t){return Array.isArray(e)&&e.length!==t.length}function Rn(e,t){return e instanceof Map&&e.size!==t.size}function Mn(e,t){return e instanceof Set&&(e.size!=t.size||[...e].some(n=>!t.has(n)))}function Nn(e,t){return e instanceof RegExp&&(e.source!==t.source||e.flags!==t.flags)}function Wt(e){return typeof e=="object"&&e!==null}function zn(e,t){return typeof e!="object"&&typeof t!="object"&&(!e||!t)||[Promise,WeakSet,WeakMap,Function].some(r=>e instanceof r)?!1:e.constructor===t.constructor}function Je(e,t,n,r,i,s){let u=new globalThis.Error(i);u.gleam_error=e,u.module=t,u.line=n,u.fn=r;for(let l in s)u[l]=s[l];return u}class mt extends h{constructor(t){super(),this[0]=t}}class jt extends h{}function Bn(e,t){if(e instanceof mt){let n=e[0];return new o(n)}else return new y(t)}function Yt(e){return ar(e)}function Te(e){return fr(e)}function Wn(e,t){for(;;){let n=e,r=t;if(n.hasLength(0))return r;{let i=n.head;e=n.tail,t=Le(i,r)}}}function jn(e){return Wn(e,a([]))}function qn(e){return jn(e)}function Vn(e,t,n){for(;;){let r=e,i=t,s=n;if(r.hasLength(0))return qn(s);{let u=r.head;e=r.tail,t=i,n=Le(i(u),s)}}}function Un(e,t){return Vn(e,t,a([]))}function _t(e,t,n){for(;;){let r=e,i=t,s=n;if(r.hasLength(0))return i;{let u=r.head;e=r.tail,t=s(i,u),n=s}}}function Se(e,t){if(e.isOk()){let n=e[0];return new o(t(n))}else{let n=e[0];return new y(n)}}function Kt(e,t){if(e.isOk()){let n=e[0];return new o(n)}else{let n=e[0];return new y(t(n))}}function b(e,t){if(e.isOk()){let n=e[0];return t(n)}else{let n=e[0];return new y(n)}}function Xt(e,t){return e.isOk()?e[0]:t()}function Fn(e,t){return e.isOk()?e:t}function bt(e,t){if(e.isOk()){let n=e[0];return new o(n)}else return new y(t)}function Jt(e){return hr(e)}function Zt(e){return e}class gt extends h{constructor(t,n,r){super(),this.expected=t,this.found=n,this.path=r}}function xt(e){return e}function Qt(e){return yr(e)}function en(e){return an(e)}function Pn(e){return mr(e)}function tn(e){return t=>{if(e.hasLength(0))return new y(a([new gt("another type",en(t),a([]))]));{let n=e.head,r=e.tail,i=n(t);if(i.isOk()){let s=i[0];return new o(s)}else return tn(r)(t)}}}function Dn(e,t){let n=xt(t),r=tn(a([Qt,s=>Se(Pn(s),Te)])),i=(()=>{let s=r(n);if(s.isOk())return s[0];{let u=a(["<",en(n),">"]),l=Jt(u);return Zt(l)}})();return e.withFields({path:Le(i,e.path)})}function Hn(e,t){return Kt(e,n=>Un(n,t))}function qt(e,t){return n=>{let r=new gt("field","nothing",a([]));return b(_r(n,e),i=>{let u=Bn(i,a([r])),l=b(u,t);return Hn(l,f=>Dn(f,e))})}}const Vt=new WeakMap,ut=new DataView(new ArrayBuffer(8));let lt=0;function ot(e){const t=Vt.get(e);if(t!==void 0)return t;const n=lt++;return lt===2147483647&&(lt=0),Vt.set(e,n),n}function ht(e,t){return e^t+2654435769+(e<<6)+(e>>2)|0}function $t(e){let t=0;const n=e.length;for(let r=0;r<n;r++)t=Math.imul(31,t)+e.charCodeAt(r)|0;return t}function nn(e){ut.setFloat64(0,e);const t=ut.getInt32(0),n=ut.getInt32(4);return Math.imul(73244475,t>>16^t)^n}function Gn(e){return $t(e.toString())}function Yn(e){const t=Object.getPrototypeOf(e);if(t!==null&&typeof t.hashCode=="function")try{const r=e.hashCode(e);if(typeof r=="number")return r}catch{}if(e instanceof Promise||e instanceof WeakSet||e instanceof WeakMap)return ot(e);if(e instanceof Date)return nn(e.getTime());let n=0;if(e instanceof ArrayBuffer&&(e=new Uint8Array(e)),Array.isArray(e)||e instanceof Uint8Array)for(let r=0;r<e.length;r++)n=Math.imul(31,n)+C(e[r])|0;else if(e instanceof Set)e.forEach(r=>{n=n+C(r)|0});else if(e instanceof Map)e.forEach((r,i)=>{n=n+ht(C(r),C(i))|0});else{const r=Object.keys(e);for(let i=0;i<r.length;i++){const s=r[i],u=e[s];n=n+ht(C(u),$t(s))|0}}return n}function C(e){if(e===null)return 1108378658;if(e===void 0)return 1108378659;if(e===!0)return 1108378657;if(e===!1)return 1108378656;switch(typeof e){case"number":return nn(e);case"string":return $t(e);case"bigint":return Gn(e);case"object":return Yn(e);case"symbol":return ot(e);case"function":return ot(e);default:return 0}}const D=5,At=Math.pow(2,D),Kn=At-1,Xn=At/2,Jn=At/4,k=0,F=1,T=2,he=3,It={type:T,bitmap:0,array:[]};function Ce(e,t){return e>>>t&Kn}function Ze(e,t){return 1<<Ce(e,t)}function Zn(e){return e-=e>>1&1431655765,e=(e&858993459)+(e>>2&858993459),e=e+(e>>4)&252645135,e+=e>>8,e+=e>>16,e&127}function Et(e,t){return Zn(e&t-1)}function R(e,t,n){const r=e.length,i=new Array(r);for(let s=0;s<r;++s)i[s]=e[s];return i[t]=n,i}function Qn(e,t,n){const r=e.length,i=new Array(r+1);let s=0,u=0;for(;s<t;)i[u++]=e[s++];for(i[u++]=n;s<r;)i[u++]=e[s++];return i}function dt(e,t){const n=e.length,r=new Array(n-1);let i=0,s=0;for(;i<t;)r[s++]=e[i++];for(++i;i<n;)r[s++]=e[i++];return r}function rn(e,t,n,r,i,s){const u=C(t);if(u===r)return{type:he,hash:u,array:[{type:k,k:t,v:n},{type:k,k:i,v:s}]};const l={val:!1};return Re(kt(It,e,u,t,n,l),e,r,i,s,l)}function Re(e,t,n,r,i,s){switch(e.type){case F:return er(e,t,n,r,i,s);case T:return kt(e,t,n,r,i,s);case he:return tr(e,t,n,r,i,s)}}function er(e,t,n,r,i,s){const u=Ce(n,t),l=e.array[u];if(l===void 0)return s.val=!0,{type:F,size:e.size+1,array:R(e.array,u,{type:k,k:r,v:i})};if(l.type===k)return se(r,l.k)?i===l.v?e:{type:F,size:e.size,array:R(e.array,u,{type:k,k:r,v:i})}:(s.val=!0,{type:F,size:e.size,array:R(e.array,u,rn(t+D,l.k,l.v,n,r,i))});const f=Re(l,t+D,n,r,i,s);return f===l?e:{type:F,size:e.size,array:R(e.array,u,f)}}function kt(e,t,n,r,i,s){const u=Ze(n,t),l=Et(e.bitmap,u);if(e.bitmap&u){const f=e.array[l];if(f.type!==k){const $=Re(f,t+D,n,r,i,s);return $===f?e:{type:T,bitmap:e.bitmap,array:R(e.array,l,$)}}const d=f.k;return se(r,d)?i===f.v?e:{type:T,bitmap:e.bitmap,array:R(e.array,l,{type:k,k:r,v:i})}:(s.val=!0,{type:T,bitmap:e.bitmap,array:R(e.array,l,rn(t+D,d,f.v,n,r,i))})}else{const f=e.array.length;if(f>=Xn){const d=new Array(32),$=Ce(n,t);d[$]=kt(It,t+D,n,r,i,s);let O=0,L=e.bitmap;for(let le=0;le<32;le++){if(L&1){const it=e.array[O++];d[le]=it}L=L>>>1}return{type:F,size:f+1,array:d}}else{const d=Qn(e.array,l,{type:k,k:r,v:i});return s.val=!0,{type:T,bitmap:e.bitmap|u,array:d}}}}function tr(e,t,n,r,i,s){if(n===e.hash){const u=Ot(e,r);if(u!==-1)return e.array[u].v===i?e:{type:he,hash:n,array:R(e.array,u,{type:k,k:r,v:i})};const l=e.array.length;return s.val=!0,{type:he,hash:n,array:R(e.array,l,{type:k,k:r,v:i})}}return Re({type:T,bitmap:Ze(e.hash,t),array:[e]},t,n,r,i,s)}function Ot(e,t){const n=e.array.length;for(let r=0;r<n;r++)if(se(t,e.array[r].k))return r;return-1}function De(e,t,n,r){switch(e.type){case F:return nr(e,t,n,r);case T:return rr(e,t,n,r);case he:return ir(e,r)}}function nr(e,t,n,r){const i=Ce(n,t),s=e.array[i];if(s!==void 0){if(s.type!==k)return De(s,t+D,n,r);if(se(r,s.k))return s}}function rr(e,t,n,r){const i=Ze(n,t);if(!(e.bitmap&i))return;const s=Et(e.bitmap,i),u=e.array[s];if(u.type!==k)return De(u,t+D,n,r);if(se(r,u.k))return u}function ir(e,t){const n=Ot(e,t);if(!(n<0))return e.array[n]}function Lt(e,t,n,r){switch(e.type){case F:return sr(e,t,n,r);case T:return ur(e,t,n,r);case he:return lr(e,r)}}function sr(e,t,n,r){const i=Ce(n,t),s=e.array[i];if(s===void 0)return e;let u;if(s.type===k){if(!se(s.k,r))return e}else if(u=Lt(s,t+D,n,r),u===s)return e;if(u===void 0){if(e.size<=Jn){const l=e.array,f=new Array(e.size-1);let d=0,$=0,O=0;for(;d<i;){const L=l[d];L!==void 0&&(f[$]=L,O|=1<<d,++$),++d}for(++d;d<l.length;){const L=l[d];L!==void 0&&(f[$]=L,O|=1<<d,++$),++d}return{type:T,bitmap:O,array:f}}return{type:F,size:e.size-1,array:R(e.array,i,u)}}return{type:F,size:e.size,array:R(e.array,i,u)}}function ur(e,t,n,r){const i=Ze(n,t);if(!(e.bitmap&i))return e;const s=Et(e.bitmap,i),u=e.array[s];if(u.type!==k){const l=Lt(u,t+D,n,r);return l===u?e:l!==void 0?{type:T,bitmap:e.bitmap,array:R(e.array,s,l)}:e.bitmap===i?void 0:{type:T,bitmap:e.bitmap^i,array:dt(e.array,s)}}return se(r,u.k)?e.bitmap===i?void 0:{type:T,bitmap:e.bitmap^i,array:dt(e.array,s)}:e}function lr(e,t){const n=Ot(e,t);if(n<0)return e;if(e.array.length!==1)return{type:he,hash:e.hash,array:dt(e.array,n)}}function sn(e,t){if(e===void 0)return;const n=e.array,r=n.length;for(let i=0;i<r;i++){const s=n[i];if(s!==void 0){if(s.type===k){t(s.v,s.k);continue}sn(s,t)}}}class z{static fromObject(t){const n=Object.keys(t);let r=z.new();for(let i=0;i<n.length;i++){const s=n[i];r=r.set(s,t[s])}return r}static fromMap(t){let n=z.new();return t.forEach((r,i)=>{n=n.set(i,r)}),n}static new(){return new z(void 0,0)}constructor(t,n){this.root=t,this.size=n}get(t,n){if(this.root===void 0)return n;const r=De(this.root,0,C(t),t);return r===void 0?n:r.v}set(t,n){const r={val:!1},i=this.root===void 0?It:this.root,s=Re(i,0,C(t),t,n,r);return s===this.root?this:new z(s,r.val?this.size+1:this.size)}delete(t){if(this.root===void 0)return this;const n=Lt(this.root,0,C(t),t);return n===this.root?this:n===void 0?z.new():new z(n,this.size-1)}has(t){return this.root===void 0?!1:De(this.root,0,C(t),t)!==void 0}entries(){if(this.root===void 0)return[];const t=[];return this.forEach((n,r)=>t.push([r,n])),t}forEach(t){sn(this.root,t)}hashCode(){let t=0;return this.forEach((n,r)=>{t=t+ht(C(n),C(r))|0}),t}equals(t){if(!(t instanceof z)||this.size!==t.size)return!1;let n=!0;return this.forEach((r,i)=>{n=n&&se(t.get(i,!r),r)}),n}}const vt=void 0,Ut={};function ar(e){return/^[-+]?(\d+)$/.test(e)?new o(parseInt(e)):new y(vt)}function fr(e){return e.toString()}function cr(e){const t=un(e);return t?ie.fromArray(Array.from(t).map(n=>n.segment)):ie.fromArray(e.match(/./gsu))}function un(e){if(Intl&&Intl.Segmenter)return new Intl.Segmenter().segment(e)[Symbol.iterator]()}function or(e){var r,i;let t;const n=un(e);return n?t=(r=n.next().value)==null?void 0:r.segment:t=(i=e.match(/./su))==null?void 0:i[0],t?new o([t,e.slice(t.length)]):new y(vt)}function hr(e){let t="";for(const n of e)t=t+n;return t}function Tt(e,t){return e.indexOf(t)>=0}function dr(){return z.new()}function ln(e,t){const n=e.get(t,Ut);return n===Ut?new y(vt):new o(n)}function pr(e,t,n){return n.set(e,t)}function an(e){if(typeof e=="string")return"String";if(e instanceof ve)return"Result";if(e instanceof ie)return"List";if(e instanceof Pe)return"BitArray";if(e instanceof z)return"Dict";if(Number.isInteger(e))return"Int";if(Array.isArray(e))return`Tuple of ${e.length} elements`;if(typeof e=="number")return"Float";if(e===null)return"Null";if(e===void 0)return"Nil";{const t=typeof e;return t.charAt(0).toUpperCase()+t.slice(1)}}function St(e,t){return wr(e,an(t))}function wr(e,t){return new y(ie.fromArray([new gt(e,t,ie.fromArray([]))]))}function yr(e){return typeof e=="string"?new o(e):St("String",e)}function mr(e){return Number.isInteger(e)?new o(e):St("Int",e)}function _r(e,t){const n=()=>St("Dict",e);if(e instanceof z||e instanceof WeakMap||e instanceof Map){const r=ln(e,t);return new o(r.isOk()?new mt(r[0]):new jt)}else return Object.getPrototypeOf(e)==Object.prototype?Ft(e,t,()=>new o(new jt)):Ft(e,t,n)}function Ft(e,t,n){try{return t in e?new o(new mt(e[t])):n()}catch{return n()}}function ge(){return dr()}function Me(e,t){return ln(e,t)}function B(e,t,n){return pr(t,n,e)}function br(e,t){return n=>t(e(n))}class gr extends h{constructor(t){super(),this.all=t}}function Pt(){return new gr(a([]))}function K(e,t,n,r){if(t!=null&&t.tag&&(e==null?void 0:e.nodeType)===1){const i=t.tag.toUpperCase(),s=t.namespace||"http://www.w3.org/1999/xhtml";return e.nodeName===i&&e.namespaceURI==s?xr(e,t,n,r):Dt(e,t,n,r)}return t!=null&&t.tag?Dt(e,t,n,r):typeof(t==null?void 0:t.content)=="string"?(e==null?void 0:e.nodeType)===3?Ar(e,t):$r(e,t):document.createComment(["[internal lustre error] I couldn't work out how to render this element. This","function should only be called internally by lustre's runtime: if you think","this is an error, please open an issue at","https://github.com/hayleigh-dot-dev/gleam-lustre/issues/new"].join(" "))}function Dt(e,t,n,r=null){const i=t.namespace?document.createElementNS(t.namespace,t.tag):document.createElement(t.tag);i.$lustre={__registered_events:new Set};let s="";for(const u of t.attrs)u[0]==="class"?Ae(i,u[0],`${i.className} ${u[1]}`):u[0]==="style"?Ae(i,u[0],`${i.style.cssText} ${u[1]}`):u[0]==="dangerous-unescaped-html"?s+=u[1]:u[0]!==""&&Ae(i,u[0],u[1],n);if(customElements.get(t.tag))i._slot=t.children;else if(t.tag==="slot"){let u=new Xe,l=r;for(;l;)if(l._slot){u=l._slot;break}else l=l.parentNode;for(const f of u)i.appendChild(K(null,f,n,i))}else if(s)i.innerHTML=s;else for(const u of t.children)i.appendChild(K(null,u,n,i));return e&&e.replaceWith(i),i}function xr(e,t,n,r){const i=e.attributes,s=new Map;e.$lustre??(e.$lustre={__registered_events:new Set});for(const u of t.attrs)u[0]==="class"&&s.has("class")?s.set(u[0],`${s.get("class")} ${u[1]}`):u[0]==="style"&&s.has("style")?s.set(u[0],`${s.get("style")} ${u[1]}`):u[0]==="dangerous-unescaped-html"&&s.has("dangerous-unescaped-html")?s.set(u[0],`${s.get("dangerous-unescaped-html")} ${u[1]}`):u[0]!==""&&s.set(u[0],u[1]);for(const{name:u,value:l}of i)if(!s.has(u))e.removeAttribute(u);else{const f=s.get(u);f!==l&&(Ae(e,u,f,n),s.delete(u))}for(const u of e.$lustre.__registered_events)if(!s.has(u)){const l=u.slice(2).toLowerCase();e.removeEventListener(l,e.$lustre[`${u}Handler`]),e.$lustre.__registered_events.delete(u),delete e.$lustre[u],delete e.$lustre[`${u}Handler`]}for(const[u,l]of s)Ae(e,u,l,n);if(customElements.get(t.tag))e._slot=t.children;else if(t.tag==="slot"){let u=e.firstChild,l=new Xe,f=r;for(;f;)if(f._slot){l=f._slot;break}else f=f.parentNode;for(;u;)Array.isArray(l)&&l.length?K(u,l.shift(),n,e):l.head&&(K(u,l.head,n,e),l=l.tail),u=u.nextSibling;for(const d of l)e.appendChild(K(null,d,n,e))}else if(s.has("dangerous-unescaped-html"))e.innerHTML=s.get("dangerous-unescaped-html");else{let u=e.firstChild,l=t.children;for(;u;)if(Array.isArray(l)&&l.length){const f=u.nextSibling;K(u,l.shift(),n,e),u=f}else if(l.head){const f=u.nextSibling;K(u,l.head,n,e),l=l.tail,u=f}else{const f=u.nextSibling;u.remove(),u=f}for(const f of l)e.appendChild(K(null,f,n,e))}return e}function Ae(e,t,n,r){switch(typeof n){case"string":e.getAttribute(t)!==n&&e.setAttribute(t,n),n===""&&e.removeAttribute(t),t==="value"&&e.value!==n&&(e.value=n);break;case(t.startsWith("on")&&"function"):{if(e.$lustre[t]===n)break;const i=t.slice(2).toLowerCase(),s=u=>Se(n(u),r);e.$lustre[`${t}Handler`]&&e.removeEventListener(i,e.$lustre[`${t}Handler`]),e.addEventListener(i,s),e.$lustre[t]=n,e.$lustre[`${t}Handler`]=s,e.$lustre.__registered_events.add(t);break}default:e[t]=n}}function $r(e,t){const n=document.createTextNode(t.content);return e&&e.replaceWith(n),n}function Ar(e,t){const n=e.nodeValue,r=t.content;return r?(n!==r&&(e.nodeValue=r),e):(e==null||e.remove(),null)}var v,J,Z,Q,re,Ee,_e,be,ke,pt,Oe,wt;class Ir{constructor(t,n,r){S(this,ke);S(this,Oe);S(this,v,null);S(this,J,null);S(this,Z,[]);S(this,Q,[]);S(this,re,!1);S(this,Ee,null);S(this,_e,null);S(this,be,null);g(this,Ee,t),g(this,_e,n),g(this,be,r)}start(t,n){if(!Or())return new y(new qr);if(_(this,v))return new y(new Br);if(g(this,v,t instanceof HTMLElement?t:document.querySelector(t)),!_(this,v))return new y(new jr);const[r,i]=_(this,Ee).call(this,n);return g(this,J,r),g(this,Q,i.all.toArray()),g(this,re,!0),window.requestAnimationFrame(()=>$e(this,ke,pt).call(this)),new o(s=>this.dispatch(s))}dispatch(t){_(this,Z).push(t),$e(this,ke,pt).call(this)}emit(t,n=null){_(this,v).dispatchEvent(new CustomEvent(t,{bubbles:!0,detail:n,composed:!0}))}destroy(){if(!_(this,v))return new y(new Wr);_(this,v).remove(),g(this,v,null),g(this,J,null),g(this,Z,[]),g(this,Q,[]),g(this,re,!1),g(this,_e,()=>{}),g(this,be,()=>{})}}v=new WeakMap,J=new WeakMap,Z=new WeakMap,Q=new WeakMap,re=new WeakMap,Ee=new WeakMap,_e=new WeakMap,be=new WeakMap,ke=new WeakSet,pt=function(){if($e(this,Oe,wt).call(this),_(this,re)){const t=_(this,be).call(this,_(this,J));g(this,v,K(_(this,v),t,n=>this.dispatch(n))),g(this,re,!1)}},Oe=new WeakSet,wt=function(t=0){if(_(this,v)){if(_(this,Z).length)for(;_(this,Z).length;){const[n,r]=_(this,_e).call(this,_(this,J),_(this,Z).shift());_(this,re)||g(this,re,_(this,J)!==n),g(this,J,n),g(this,Q,_(this,Q).concat(r.all.toArray()))}for(;_(this,Q).length;)_(this,Q).shift()(n=>this.dispatch(n),(n,r)=>this.emit(n,r));_(this,Z).length&&(t>=5?console.warn(tooManyUpdates):$e(this,Oe,wt).call(this,++t))}};const Er=(e,t,n)=>new Ir(e,t,n),kr=(e,t,n)=>e.start(t,n),Or=()=>window&&window.document;function Qe(e){let n=Jt(e);return Zt(n)}function Lr(e){return or(e)}class fn extends h{constructor(t,n,r){super(),this[0]=t,this[1]=n,this.as_property=r}}class vr extends h{constructor(t,n){super(),this[0]=t,this[1]=n}}function xe(e,t){return new fn(e,xt(t),!1)}function cn(e,t){return new fn(e,xt(t),!0)}function Tr(e,t){return new vr("on"+e,br(t,n=>bt(n,void 0)))}function Sr(e){return xe("style",_t(e,"",(t,n)=>{let r=n[0],i=n[1];return t+r+":"+i+";"}))}function Ht(e){return xe("id",e)}function Cr(e){return xe("placeholder",e)}function ae(e){return xe("href",e)}function Rr(e){return xe("src",e)}function Mr(e){return cn("height",Te(e))}function Nr(e){return cn("width",Te(e))}class zr extends h{constructor(t){super(),this.content=t}}class I extends h{constructor(t,n,r,i,s,u){super(),this.namespace=t,this.tag=n,this.attrs=r,this.children=i,this.self_closing=s,this.void=u}}function ee(e,t,n){return e==="area"?new I("",e,t,a([]),!1,!0):e==="base"?new I("",e,t,a([]),!1,!0):e==="br"?new I("",e,t,a([]),!1,!0):e==="col"?new I("",e,t,a([]),!1,!0):e==="embed"?new I("",e,t,a([]),!1,!0):e==="hr"?new I("",e,t,a([]),!1,!0):e==="img"?new I("",e,t,a([]),!1,!0):e==="input"?new I("",e,t,a([]),!1,!0):e==="link"?new I("",e,t,a([]),!1,!0):e==="meta"?new I("",e,t,a([]),!1,!0):e==="param"?new I("",e,t,a([]),!1,!0):e==="source"?new I("",e,t,a([]),!1,!0):e==="track"?new I("",e,t,a([]),!1,!0):e==="wbr"?new I("",e,t,a([]),!1,!0):new I("",e,t,n,!1,!1)}function p(e){return new zr(e)}class Br extends h{}class Wr extends h{}class jr extends h{}class qr extends h{}function Vr(e,t,n){return Er(s=>[e(s),Pt()],(s,u)=>[t(s,u),Pt()],n)}function at(e,t){return ee("h3",e,t)}function ft(e,t){return ee("div",e,t)}function We(e,t){return ee("p",e,t)}function fe(e,t){return ee("a",e,t)}function Ur(e){return ee("br",e,a([]))}function ce(e,t){return ee("code",e,t)}function Fr(e,t){return ee("strong",e,t)}function Pr(e){return ee("iframe",e,a([]))}function Dr(e){return ee("textarea",e,a([]))}function Hr(e,t){return Tr(e,t)}function Gr(e){let t=e;return qt("target",qt("value",Qt))(t)}function Yr(e){return Hr("input",t=>{let n=Gr(t);return Se(n,e)})}class He extends h{constructor(t){super(),this.error=t}}class Ve extends h{constructor(t,n){super(),this.row=t,this.col=n}}class U extends h{constructor(t){super(),this.parse=t}}function A(e,t,n){let r=e.parse;return r(t,n)}function et(e){return new U((t,n)=>{if(!(n instanceof Ve))throw Je("assignment_no_match","party",58,"","Assignment pattern did not match",{value:n});let r=n.row,i=n.col;if(t.atLeastLength(1)){let s=t.head,u=t.tail;return e(s)?s===`
`?new o([s,u,new Ve(r+1,0)]):new o([s,u,new Ve(r,i+1)]):new y(new He(s))}else return new y(new He("EOF"))})}function m(e){return et(t=>e===t)}function we(e,t){return new U((n,r)=>Fn(A(e,n,r),A(t,n,r)))}function Ne(e){return new U((t,n)=>{if(e.hasLength(0))return new y(new He("choiceless choice"));if(e.hasLength(1)){let r=e.head;return A(r,t,n)}else{let r=e.head,i=e.tail,s=A(r,t,n);if(s.isOk()){let u=s[0][0],l=s[0][1],f=s[0][2];return new o([u,l,f])}else return A(Ne(i),t,n)}})}function ue(e){return new U((t,n)=>{let r=A(e,t,n);if(r.isOk()){let i=r[0][0],s=r[0][1],u=r[0][2];return Se(A(ue(e),s,u),l=>[Le(i,l[0]),l[1],l[2]])}else return new o([a([]),t,n])})}function on(e){return new U((t,n)=>{let r=A(e,t,n);if(r.isOk()){let i=r[0][0],s=r[0][1],u=r[0][2];return Se(A(ue(e),s,u),l=>[Le(i,l[0]),l[1],l[2]])}else{let i=r[0];return new y(i)}})}function P(e,t){return new U((n,r)=>{let i=A(e,n,r);if(i.isOk()){let s=i[0][0],u=i[0][1],l=i[0][2];return new o([t(s),u,l])}else{let s=i[0];return new y(s)}})}function Kr(e){return new U((t,n)=>{let r=A(e,t,n);if(r.isOk()){let i=r[0][0],s=r[0][1],u=r[0][2];return new o([new o(i),s,u])}else return new o([new y(void 0),t,n])})}function Ct(e){return new U((t,n)=>A(e,t,n).isOk()?new y(new He("")):new o([void 0,t,n]))}function M(e){return new U((t,n)=>A(e(),t,n))}function c(e,t){return new U((n,r)=>{let i=A(e,n,r);if(i.isOk()){let s=i[0][0],u=i[0][1],l=i[0][2];return A(t(s),u,l)}else{let s=i[0];return new y(s)}})}function x(e){return new U((t,n)=>new o([e,t,n]))}function de(e){let t=Lr(e);if(t.isOk()){let n=t[0][0],r=t[0][1];return c(m(n),i=>c(de(r),s=>x(i+s)))}else return x("")}function hn(e,t){let n=A(e,cr(t),new Ve(1,1));if(n.isOk()){let r=n[0][0];return new o(r)}else{let r=n[0];return new y(r)}}function Xr(){return et(e=>Tt("abcdefghijklmnopqrstuvwxyz",e))}function Jr(){return et(e=>Tt("ABCDEFGHIJKLMNOPQRSTUVWXYZ",e))}function Rt(){return we(Xr(),Jr())}function Mt(){return et(e=>Tt("0123456789",e))}function ze(){return we(Mt(),Rt())}let dn=class extends h{constructor(t){super(),this[0]=t}},pn=class extends h{constructor(t){super(),this[0]=t}},wn=class extends h{constructor(t,n){super(),this[0]=t,this[1]=n}},Zr=class extends h{constructor(t,n){super(),this[0]=t,this[1]=n}},yn=class extends h{constructor(t){super(),this.int=t}},je=class extends h{constructor(t,n){super(),this.val=t,this.gen=n}},Nt=class extends h{constructor(t){super(),this[0]=t}},zt=class extends h{constructor(t,n){super(),this[0]=t,this[1]=n}},Ie=class extends h{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}},Ge=class extends h{constructor(t,n){super(),this[0]=t,this[1]=n}};function Qr(){let e=on(Mt()),t=P(e,Qe),n=P(t,Yt),r=P(n,i=>Xt(i,()=>{throw Je("panic","tinylang",19,"","parsed int isn't an int",{})}));return P(r,i=>new dn(i))}function mn(){return c(Rt(),e=>c(ue(we(ze(),m("_"))),t=>x(e+Qe(t))))}function ei(){let e=mn();return P(e,t=>new pn(t))}function me(){return c(ue(Ne(a([m(" "),m("	"),m(`
`)]))),e=>x(void 0))}function ti(e,t){return t(new yn(e.int+1),e.int)}function Ue(e,t,n){if(t instanceof dn){let r=t[0];return new o(new je(new Nt(r),e))}else if(t instanceof pn){let r=t[0],i=Me(n,r);if(i.isOk()){let s=i[0];return new o(new je(new zt(s,r),e))}else return new y("Wait! "+r+" isn't defined anywhere!")}else if(t instanceof wn){let r=t[0],i=t[1];return ti(e,(s,u)=>b(Ue(s,i,B(n,r,u)),l=>{let f=new Ie(u,r,l.val),d=new je(f,s);return new o(d)}))}else{let r=t[0],i=t[1];return b(Ue(e,r,n),s=>b(Ue(s.gen,i,n),u=>{let l=new Ge(s.val,u.val),f=new je(l,u.gen);return new o(f)}))}}function ni(e,t){return b(Ue(e,t,ge()),n=>new o(n.val))}function Fe(e,t){for(;;){let n=e,r=t;if(n instanceof Nt)return n;if(n instanceof zt){let i=n[0],s=Me(r,i);return s.isOk()?s[0]:n}else if(n instanceof Ge){let i=n[0],s=n[1],u=Fe(i,r),l=Fe(s,r);if(u instanceof Ie){let f=u[0];e=u[2],t=B(r,f,l)}else return new Ge(u,l)}else{let i=n[0],s=n[1],u=n[2];return new Ie(i,s,Fe(u,r))}}}function ri(e){return Fe(e,ge())}function ye(e){if(e instanceof Nt){let t=e[0];return Te(t)}else{if(e instanceof zt)return e[1];if(e instanceof Ie){let t=e[1],n=e[2];return"\\"+t+". "+ye(n)}else if(e instanceof Ge&&e[0]instanceof Ie){let t=e[0],n=e[1];return"("+ye(t)+")("+ye(n)+")"}else{let t=e[0],n=e[1];return ye(t)+"("+ye(n)+")"}}}function ii(e){return e.isOk(),e[0]}function tt(){return c(me(),e=>c(Ne(a([Qr(),ei(),si(),ui()])),t=>c(me(),n=>c(ue(c(m("("),r=>c(M(tt),i=>c(m(")"),s=>c(me(),u=>x(i)))))),r=>{let i=_t(r,t,(s,u)=>new Zr(s,u));return x(i)}))))}function si(){return c(m("\\"),e=>c(me(),t=>c(mn(),n=>c(me(),r=>c(m("."),i=>c(me(),s=>c(M(tt),u=>x(new wn(n,u)))))))))}function ui(){return c(m("("),e=>c(M(tt),t=>c(m(")"),n=>x(t))))}function li(e){let t=b(bt(hn(tt(),e),"there's a mistake in the notation somewhere; I couldn't understand it!"),n=>b(ni(new yn(0),n),r=>{let i=ri(r);return new o(ye(i))}));return ii(t)}class _n extends h{constructor(t){super(),this[0]=t}}class bn extends h{constructor(t){super(),this[0]=t}}class gn extends h{constructor(t,n){super(),this[0]=t,this[1]=n}}class xn extends h{constructor(t,n){super(),this[0]=t,this[1]=n}}class $n extends h{}class An extends h{}class Bt extends h{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}}class ai extends h{constructor(t,n,r,i){super(),this[0]=t,this[1]=n,this[2]=r,this[3]=i}}class In extends h{constructor(t){super(),this.int=t}}class te extends h{constructor(t,n){super(),this.val=t,this.gen=n}}class pe extends h{constructor(t){super(),this[0]=t}}class W extends h{constructor(t,n){super(),this[0]=t,this[1]=n}}class j extends h{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}}class H extends h{constructor(t,n){super(),this[0]=t,this[1]=n}}class E extends h{}class V extends h{}class N extends h{constructor(t,n,r,i){super(),this[0]=t,this[1]=n,this[2]=r,this[3]=i}}class Be extends h{constructor(t,n,r,i,s){super(),this[0]=t,this[1]=n,this[2]=r,this[3]=i,this[4]=s}}function fi(){let e=on(Mt()),t=P(e,Qe),n=P(t,Yt),r=P(n,i=>Xt(i,()=>{throw Je("panic","tinytypedlang",23,"","parsed int isn't an int",{})}));return P(r,i=>new _n(i))}function nt(){return c(Rt(),e=>c(ue(we(ze(),m("_"))),t=>x(e+Qe(t))))}function ci(){let e=nt();return P(e,t=>new bn(t))}function oi(){return c(de("Type"),e=>c(Ct(we(ze(),m("_"))),t=>x(new $n)))}function hi(){return c(de("Int"),e=>c(Ct(we(ze(),m("_"))),t=>x(new An)))}function q(){return c(ue(Ne(a([m(" "),m("	"),m(`
`)]))),e=>x(void 0))}function ct(e,t){return t(new In(e.int+1),e.int)}function Y(e,t,n){if(t instanceof _n){let r=t[0];return new o(new te(new pe(r),e))}else if(t instanceof bn){let r=t[0],i=Me(n,r);if(i.isOk()){let s=i[0];return new o(new te(new W(s,r),e))}else return new y("Wait! "+r+" isn't defined anywhere!")}else if(t instanceof gn){let r=t[0],i=t[1];return ct(e,(s,u)=>b(Y(s,i,B(n,r,u)),l=>{let f=new j(u,r,l.val),d=new te(f,s);return new o(d)}))}else if(t instanceof xn){let r=t[0],i=t[1];return b(Y(e,r,n),s=>b(Y(s.gen,i,n),u=>{let l=new H(s.val,u.val),f=new te(l,u.gen);return new o(f)}))}else{if(t instanceof $n)return new o(new te(new E,e));if(t instanceof An)return new o(new te(new V,e));if(t instanceof Bt){let r=t[0],i=t[1],s=t[2];return ct(e,(u,l)=>b(Y(u,i,n),f=>b(Y(f.gen,s,B(n,r,l)),d=>{let $=new N(l,r,f.val,d.val),O=new te($,d.gen);return new o(O)})))}else{let r=t[0],i=t[1],s=t[2],u=t[3];return ct(e,(l,f)=>b(Y(l,i,n),d=>{let $=B(n,r,f);return b(Y(d.gen,s,$),O=>b(Y(O.gen,u,$),L=>{let le=new Be(f,r,d.val,O.val,L.val),it=new te(le,L.gen);return new o(it)}))}))}}}function di(e,t){return b(Y(e,t,ge()),n=>new o(n.val))}function rt(e,t,n){let r=i=>rt(i,t,n);if(e instanceof pe){let i=e[0];return new pe(i)}else if(e instanceof W){let i=e[0];return t===i?n:e}else if(e instanceof j){let i=e[0],s=e[1],u=e[2];return new j(i,s,r(u))}else if(e instanceof H){let i=e[0],s=e[1];return new H(r(i),r(s))}else{if(e instanceof E)return new E;if(e instanceof V)return new V;if(e instanceof N){let i=e[0],s=e[1],u=e[2],l=e[3];return new N(i,s,r(u),r(l))}else{let i=e[0],s=e[1],u=e[2],l=e[3],f=e[4];return new Be(i,s,r(u),r(l),r(f))}}}function X(e,t){for(;;){let n=e,r=t;if(n instanceof pe)return n;if(n instanceof W){let i=n[0],s=Me(r,i);return s.isOk()?s[0]:n}else if(n instanceof H){let i=n[0],s=n[1],u=X(i,r),l=X(s,r);if(u instanceof j){let f=u[0];e=u[2],t=B(r,f,l)}else return new H(u,l)}else{if(n instanceof E)return new E;if(n instanceof V)return new V;if(n instanceof Be){let i=n[0],s=n[3];e=n[4],t=B(r,i,X(s,r))}else if(n instanceof j){let i=n[0],s=n[1],u=n[2];return new j(i,s,X(u,r))}else{let i=n[0],s=n[1],u=n[2],l=n[3];return new N(i,s,X(u,r),X(l,r))}}}}function yt(e,t,n){let r=X(e,n),i=X(t,n);if(r instanceof W&&i instanceof W){let s=r[0],u=i[0];return s===u}else{if(r instanceof V&&i instanceof V)return!0;if(r instanceof E&&i instanceof E)return!0;if(r instanceof N&&i instanceof N){let s=r[0],u=r[1],l=r[2],f=r[3],d=i[0],$=i[2],O=i[3];return yt(l,$,n)&&yt(rt(O,d,new W(s,u)),f,n)}else return!1}}function pi(e){return X(e,ge())}function ne(e,t){for(;;){let n=e,r=t;if(r instanceof W)return r[0]===n;if(r instanceof j){let i=r[2];e=n,t=i}else if(r instanceof H){let i=r[0],s=r[1];return ne(n,i)||ne(n,s)}else if(r instanceof N){let i=r[2],s=r[3];return ne(n,i)||ne(n,s)}else if(r instanceof Be){let i=r[2],s=r[3],u=r[4];return ne(n,i)||ne(n,s)||ne(n,u)}else return!1}}function w(e){if(e instanceof pe){let t=e[0];return Te(t)}else{if(e instanceof W)return e[1];if(e instanceof j){let t=e[1],n=e[2];return"\\"+t+". "+w(n)}else if(e instanceof H&&e[0]instanceof j){let t=e[0],n=e[1];return"("+w(t)+")("+w(n)+")"}else if(e instanceof H){let t=e[0],n=e[1];return w(t)+"("+w(n)+")"}else{if(e instanceof E)return"Type";if(e instanceof V)return"Int";if(e instanceof N){let t=e[0],n=e[1],r=e[2],i=e[3];return ne(t,i)?"forall "+n+": "+w(r)+". "+w(i):r instanceof pe||r instanceof W||r instanceof E||r instanceof V?w(r)+"->"+w(i):(r instanceof j||r instanceof H||r instanceof N,"("+w(r)+") -> "+w(i))}else{let t=e[1],n=e[2],r=e[3],i=e[4];return"let "+t+": "+w(n)+" = "+w(r)+`;
`+w(i)}}}}function wi(e){return e.isOk(),e[0]}function qe(e,t,n,r){for(;;){let i=e,s=t,u=n,l=r;if(i instanceof j){let f=i[0],d=i[1],$=i[2];if(s instanceof N){let O=s[0],L=s[2],le=s[3];e=$,t=rt(le,O,new W(f,d)),n=B(u,f,L),r=l}else return new y("Type mismatch. Expected "+w(s)+" but found a lambda.")}else return b(Ye(i,u,l),f=>yt(f,s,l)?new o(void 0):new y("Type mismatch. Expected "+w(s)+" but found "+w(f)+"."))}}function Ye(e,t,n){if(e instanceof pe)return new o(new V);if(e instanceof W){let r=e[0],i=e[1];return Kt(Me(t,r),s=>"Variable "+i+" is not defined in the current context.")}else if(e instanceof H){let r=e[0],i=e[1];return b(Ye(r,t,n),s=>{if(s instanceof N){let u=s[0],l=s[2],f=s[3];return b(qe(i,l,t,n),d=>new o(rt(f,u,i)))}else return new y("Type error. Expected a function type, but found "+w(s))})}else if(e instanceof N){let r=e[0],i=e[2],s=e[3];return b(qe(i,new E,t,n),u=>b(qe(s,new E,B(t,r,i),n),l=>new o(new E)))}else{if(e instanceof V)return new o(new E);if(e instanceof E)return new o(new E);if(e instanceof Be){let r=e[0],i=e[2],s=e[3],u=e[4];return b(qe(s,i,t,n),l=>Ye(u,B(t,r,i),B(n,r,s)))}else return new y("Type error. Can't infer the type of this lambda. Try annotating it with a `let` expression.")}}function G(){return c(q(),e=>c(Ne(a([fi(),oi(),hi(),yi(),_i(),ci(),mi(),bi()])),t=>c(q(),n=>c(ue(c(m("("),r=>c(M(G),i=>c(m(")"),s=>c(q(),u=>x(i)))))),r=>{let i=_t(r,t,(s,u)=>new xn(s,u));return c(Kr(de("->")),s=>c((()=>s.isOk()?c(M(G),u=>x(new Bt("_",i,u))):x(i))(),u=>x(u)))}))))}function yi(){return c(de("forall"),e=>c(Ct(we(ze(),m("_"))),t=>c(q(),n=>c(nt(),r=>c(q(),i=>c(m(":"),s=>c(q(),u=>c(M(G),l=>c(m("."),f=>c(M(G),d=>x(new Bt(r,l,d))))))))))))}function mi(){return c(m("\\"),e=>c(q(),t=>c(nt(),n=>c(q(),r=>c(m("."),i=>c(q(),s=>c(M(G),u=>x(new gn(n,u)))))))))}function _i(){return c(de("let "),e=>c(q(),t=>c(nt(),n=>c(q(),r=>c(m(":"),i=>c(M(G),s=>c(de("="),u=>c(M(G),l=>c(m(";"),f=>c(M(G),d=>x(new ai(n,s,l,d))))))))))))}function bi(){return c(m("("),e=>c(M(G),t=>c(m(")"),n=>x(t))))}function gi(e){let t=b(bt(hn(G(),e),"there's a mistake in the notation somewhere; I couldn't understand it!"),n=>b(di(new In(0),n),r=>b(Ye(r,ge(),ge()),i=>{let s=pi(r);return new o(w(s))})));return wi(t)}class Ke extends h{constructor(t,n){super(),this.code=t,this.is_typed=n}}class En extends h{constructor(t){super(),this[0]=t}}function xi(e){return new Ke("",!1)}function $i(e,t){if(t instanceof En){let n=t[0];return new Ke(n,e.is_typed)}else{let n=t[0];return new Ke(e.code,n)}}function Ai(e){return ft(a([]),a([at(a([]),a([p("Who I Am")])),We(a([]),a([p("I'm Ryan Brewer, the software developer behind "),fe(a([ae("https://github.com/RyanBrewer317/SaberVM")]),a([p("SaberVM")])),p(`,
an abstract machine for safe, portable computation that functional languages can compile to. 
With SaberVM, I'm hoping to broaden accessibility to safe computation, both informationally and financially. 
Consider supporting my work!
`)])),Pr(a([Rr("https://github.com/sponsors/RyanBrewer317/button"),xe("title","Sponsor RyanBrewer317"),Mr(32),Nr(114),Sr(a([["border","0"],["border-radius","6px;"]]))])),at(a([]),a([p("My Website")])),We(a([]),a([p("This is my website. It's hosted by Firebase and written mostly in "),fe(a([ae("https://gleam.run")]),a([p("Gleam")])),p(", and the code is up on my "),fe(a([ae("https://github.com/RyanBrewer317/ryanbrewer-dev")]),a([p("github")])),p(". The only framework used is "),fe(a([ae("https://lustre.build/")]),a([p("Lustre")])),p("; scripting, markup, styles, and layout were all done by hand.")])),at(a([]),a([p("Lambda Calculus in Gleam")])),We(a([]),a([p(`
I study programming language design, and I'm particularly fond of functional programming.
That's why I made this website in `),fe(a([ae("https://gleam.run")]),a([p("Gleam")])),p(`,
a statically-typed functional language
that can run anywhere JavaScript can, as well as on Erlang's BEAM VM. 
I've used Gleam to write a lambda calculus evaluator that you can play with below. 
Lambda abstractions are written like 
`),ce(a([]),a([p("\\var. body")])),p(", and are called like "),ce(a([]),a([p("fun(arg)")])),p(". There are also positive integers like 7. Try writing "),ce(a([]),a([p("(\\x.x)(2)")])),p(", which evaluates to 2. The code for this can be found "),fe(a([ae("https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/tinylang.gleam")]),a([p("here")])),p(".")])),We(a([]),a([p(`Want types in your lambda calculus?
Below I've extended the evaluator with a simple dependent type system. 
Lambdas need to be annotated using a `),ce(a([]),a([p("let")])),p("-binding, like "),ce(a([]),a([p("let f: Int->Int = \\x. x; f(3)")])),p(". Pi types are written "),ce(a([]),a([p("forall x: A. B")])),p(", and the type of types is "),ce(a([]),a([p("Type")])),p(". The code for this extended evaluator can be found "),fe(a([ae("https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/tinytypedlang.gleam")]),a([p("here")])),p(".")])),Dr(a([Ht("code"),Cr((()=>e.is_typed?"Play with dependent types! Example: let id: forall a: Type. a->a = \\a.\\x.x; id(Int)(3)":"Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)(3)")()),Yr(t=>new En(t))])),Ur(a([])),(()=>{if(e instanceof Ke&&e.code==="")return p("");{let t=e.code,n=(()=>e.is_typed?gi(t):li(t))();return(r=>ft(a([]),a([Fr(a([]),a([p("output ")])),p(" (variables may be renamed): "),ft(a([Ht("code-output")]),a([p(r)]))])))(n)}})()]))}function Ii(){let e=Vr(xi,$i,Ai),t=kr(e,"[data-lustre-app]",void 0);if(!t.isOk())throw Je("assignment_no_match","ryanbrewerdev",15,"main","Assignment pattern did not match",{value:t});return t[0]}document.addEventListener("DOMContentLoaded",()=>{Ii()});
