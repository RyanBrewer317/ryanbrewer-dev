var it=(e,t,n)=>{if(!t.has(e))throw TypeError("Cannot "+n)};var _=(e,t,n)=>(it(e,t,"read from private field"),n?n.call(e):t.get(e)),S=(e,t,n)=>{if(t.has(e))throw TypeError("Cannot add the same private member more than once");t instanceof WeakSet?t.add(e):t.set(e,n)},b=(e,t,n,r)=>(it(e,t,"write to private field"),r?r.call(e,n):t.set(e,n),n);var be=(e,t,n)=>(it(e,t,"access private method"),n);import"./style-b7ef9c88.js";class h{withFields(t){let n=Object.keys(this).map(r=>r in t?t[r]:this[r]);return new this.constructor(...n)}}class re{static fromArray(t,n){let r=n||new Ke;for(let i=t.length-1;i>=0;--i)r=new Zt(t[i],r);return r}[Symbol.iterator](){return new Sn(this)}toArray(){return[...this]}atLeastLength(t){for(let n of this){if(t<=0)return!0;t--}return t<=0}hasLength(t){for(let n of this){if(t<=0)return!1;t--}return t===0}countLength(){let t=0;for(let n of this)t++;return t}}function Le(e,t){return new Zt(e,t)}function a(e,t){return re.fromArray(e,t)}var le;class Sn{constructor(t){S(this,le,void 0);b(this,le,t)}next(){if(_(this,le)instanceof Ke)return{done:!0};{let{head:t,tail:n}=_(this,le);return b(this,le,n),{value:t,done:!1}}}}le=new WeakMap;class Ke extends re{}class Zt extends re{constructor(t,n){super(),this.head=t,this.tail=n}}class De{constructor(t){if(!(t instanceof Uint8Array))throw"BitArray can only be constructed from a Uint8Array";this.buffer=t}get length(){return this.buffer.length}byteAt(t){return this.buffer[t]}floatAt(t){return Rn(this.buffer.slice(t,t+8))}intFromSlice(t,n){return Cn(this.buffer.slice(t,n))}binaryFromSlice(t,n){return new De(this.buffer.slice(t,n))}sliceAfter(t){return new De(this.buffer.slice(t))}}function Cn(e){e=e.reverse();let t=0;for(let n=e.length-1;n>=0;n--)t=t*256+e[n];return t}function Rn(e){return new Float64Array(e.reverse().buffer)[0]}class ve extends h{static isResult(t){return t instanceof ve}}class o extends ve{constructor(t){super(),this[0]=t}isOk(){return!0}}class y extends ve{constructor(t){super(),this[0]=t}isOk(){return!1}}function ie(e,t){let n=[e,t];for(;n.length;){let r=n.pop(),i=n.pop();if(r===i)continue;if(!Wt(r)||!Wt(i)||!Vn(r,i)||Nn(r,i)||zn(r,i)||jn(r,i)||Wn(r,i)||qn(r,i)||Bn(r,i))return!1;const u=Object.getPrototypeOf(r);if(u!==null&&typeof u.equals=="function")try{if(r.equals(i))continue;return!1}catch{}let[l,c]=Mn(r);for(let d of l(r))n.push(c(r,d),c(i,d))}return!0}function Mn(e){if(e instanceof Map)return[t=>t.keys(),(t,n)=>t.get(n)];{let t=e instanceof globalThis.Error?["message"]:[];return[n=>[...t,...Object.keys(n)],(n,r)=>n[r]]}}function Nn(e,t){return e instanceof Date&&(e>t||e<t)}function zn(e,t){return e.buffer instanceof ArrayBuffer&&e.BYTES_PER_ELEMENT&&!(e.byteLength===t.byteLength&&e.every((n,r)=>n===t[r]))}function jn(e,t){return Array.isArray(e)&&e.length!==t.length}function Wn(e,t){return e instanceof Map&&e.size!==t.size}function qn(e,t){return e instanceof Set&&(e.size!=t.size||[...e].some(n=>!t.has(n)))}function Bn(e,t){return e instanceof RegExp&&(e.source!==t.source||e.flags!==t.flags)}function Wt(e){return typeof e=="object"&&e!==null}function Vn(e,t){return typeof e!="object"&&typeof t!="object"&&(!e||!t)||[Promise,WeakSet,WeakMap,Function].some(r=>e instanceof r)?!1:e.constructor===t.constructor}function Xe(e,t,n,r,i,s){let u=new globalThis.Error(i);u.gleam_error=e,u.module=t,u.line=n,u.fn=r;for(let l in s)u[l]=s[l];return u}class mt extends h{constructor(t){super(),this[0]=t}}class qt extends h{}function Un(e,t){if(e instanceof mt){let n=e[0];return new o(n)}else return new y(t)}function Qt(e){return dr(e)}function Te(e){return pr(e)}function Fn(e,t){for(;;){let n=e,r=t;if(n.hasLength(0))return r;{let i=n.head;e=n.tail,t=Le(i,r)}}}function Dn(e){return Fn(e,a([]))}function Pn(e){return Dn(e)}function Hn(e,t,n){for(;;){let r=e,i=t,s=n;if(r.hasLength(0))return Pn(s);{let u=r.head;e=r.tail,t=i,n=Le(i(u),s)}}}function Gn(e,t){return Hn(e,t,a([]))}function _t(e,t,n){for(;;){let r=e,i=t,s=n;if(r.hasLength(0))return i;{let u=r.head;e=r.tail,t=s(i,u),n=s}}}function Se(e,t){if(e.isOk()){let n=e[0];return new o(t(n))}else{let n=e[0];return new y(n)}}function en(e,t){if(e.isOk()){let n=e[0];return new o(n)}else{let n=e[0];return new y(t(n))}}function g(e,t){if(e.isOk()){let n=e[0];return t(n)}else{let n=e[0];return new y(n)}}function tn(e,t){return e.isOk()?e[0]:t()}function Yn(e,t){return e.isOk()?e:t}function gt(e,t){if(e.isOk()){let n=e[0];return new o(n)}else return new y(t)}function nn(e){return mr(e)}function rn(e){return e}class bt extends h{constructor(t,n,r){super(),this.expected=t,this.found=n,this.path=r}}function xt(e){return e}function sn(e){return xr(e)}function un(e){return dn(e)}function Kn(e){return $r(e)}function ln(e){return t=>{if(e.hasLength(0))return new y(a([new bt("another type",un(t),a([]))]));{let n=e.head,r=e.tail,i=n(t);if(i.isOk()){let s=i[0];return new o(s)}else return ln(r)(t)}}}function Xn(e,t){let n=xt(t),r=ln(a([sn,s=>Se(Kn(s),Te)])),i=(()=>{let s=r(n);if(s.isOk())return s[0];{let u=a(["<",un(n),">"]),l=nn(u);return rn(l)}})();return e.withFields({path:Le(i,e.path)})}function Jn(e,t){return en(e,n=>Gn(n,t))}function Bt(e,t){return n=>{let r=new bt("field","nothing",a([]));return g(Ar(n,e),i=>{let u=Un(i,a([r])),l=g(u,t);return Jn(l,c=>Xn(c,e))})}}const Vt=new WeakMap,st=new DataView(new ArrayBuffer(8));let ut=0;function ot(e){const t=Vt.get(e);if(t!==void 0)return t;const n=ut++;return ut===2147483647&&(ut=0),Vt.set(e,n),n}function ht(e,t){return e^t+2654435769+(e<<6)+(e>>2)|0}function $t(e){let t=0;const n=e.length;for(let r=0;r<n;r++)t=Math.imul(31,t)+e.charCodeAt(r)|0;return t}function an(e){st.setFloat64(0,e);const t=st.getInt32(0),n=st.getInt32(4);return Math.imul(73244475,t>>16^t)^n}function Zn(e){return $t(e.toString())}function Qn(e){const t=Object.getPrototypeOf(e);if(t!==null&&typeof t.hashCode=="function")try{const r=e.hashCode(e);if(typeof r=="number")return r}catch{}if(e instanceof Promise||e instanceof WeakSet||e instanceof WeakMap)return ot(e);if(e instanceof Date)return an(e.getTime());let n=0;if(e instanceof ArrayBuffer&&(e=new Uint8Array(e)),Array.isArray(e)||e instanceof Uint8Array)for(let r=0;r<e.length;r++)n=Math.imul(31,n)+C(e[r])|0;else if(e instanceof Set)e.forEach(r=>{n=n+C(r)|0});else if(e instanceof Map)e.forEach((r,i)=>{n=n+ht(C(r),C(i))|0});else{const r=Object.keys(e);for(let i=0;i<r.length;i++){const s=r[i],u=e[s];n=n+ht(C(u),$t(s))|0}}return n}function C(e){if(e===null)return 1108378658;if(e===void 0)return 1108378659;if(e===!0)return 1108378657;if(e===!1)return 1108378656;switch(typeof e){case"number":return an(e);case"string":return $t(e);case"bigint":return Zn(e);case"object":return Qn(e);case"symbol":return ot(e);case"function":return ot(e);default:return 0}}const D=5,At=Math.pow(2,D),er=At-1,tr=At/2,nr=At/4,E=0,U=1,k=2,ae=3,It={type:k,bitmap:0,array:[]};function Ce(e,t){return e>>>t&er}function Je(e,t){return 1<<Ce(e,t)}function rr(e){return e-=e>>1&1431655765,e=(e&858993459)+(e>>2&858993459),e=e+(e>>4)&252645135,e+=e>>8,e+=e>>16,e&127}function Et(e,t){return rr(e&t-1)}function R(e,t,n){const r=e.length,i=new Array(r);for(let s=0;s<r;++s)i[s]=e[s];return i[t]=n,i}function ir(e,t,n){const r=e.length,i=new Array(r+1);let s=0,u=0;for(;s<t;)i[u++]=e[s++];for(i[u++]=n;s<r;)i[u++]=e[s++];return i}function dt(e,t){const n=e.length,r=new Array(n-1);let i=0,s=0;for(;i<t;)r[s++]=e[i++];for(++i;i<n;)r[s++]=e[i++];return r}function fn(e,t,n,r,i,s){const u=C(t);if(u===r)return{type:ae,hash:u,array:[{type:E,k:t,v:n},{type:E,k:i,v:s}]};const l={val:!1};return Re(Ot(It,e,u,t,n,l),e,r,i,s,l)}function Re(e,t,n,r,i,s){switch(e.type){case U:return sr(e,t,n,r,i,s);case k:return Ot(e,t,n,r,i,s);case ae:return ur(e,t,n,r,i,s)}}function sr(e,t,n,r,i,s){const u=Ce(n,t),l=e.array[u];if(l===void 0)return s.val=!0,{type:U,size:e.size+1,array:R(e.array,u,{type:E,k:r,v:i})};if(l.type===E)return ie(r,l.k)?i===l.v?e:{type:U,size:e.size,array:R(e.array,u,{type:E,k:r,v:i})}:(s.val=!0,{type:U,size:e.size,array:R(e.array,u,fn(t+D,l.k,l.v,n,r,i))});const c=Re(l,t+D,n,r,i,s);return c===l?e:{type:U,size:e.size,array:R(e.array,u,c)}}function Ot(e,t,n,r,i,s){const u=Je(n,t),l=Et(e.bitmap,u);if(e.bitmap&u){const c=e.array[l];if(c.type!==E){const $=Re(c,t+D,n,r,i,s);return $===c?e:{type:k,bitmap:e.bitmap,array:R(e.array,l,$)}}const d=c.k;return ie(r,d)?i===c.v?e:{type:k,bitmap:e.bitmap,array:R(e.array,l,{type:E,k:r,v:i})}:(s.val=!0,{type:k,bitmap:e.bitmap,array:R(e.array,l,fn(t+D,d,c.v,n,r,i))})}else{const c=e.array.length;if(c>=tr){const d=new Array(32),$=Ce(n,t);d[$]=Ot(It,t+D,n,r,i,s);let v=0,T=e.bitmap;for(let ge=0;ge<32;ge++){if(T&1){const rt=e.array[v++];d[ge]=rt}T=T>>>1}return{type:U,size:c+1,array:d}}else{const d=ir(e.array,l,{type:E,k:r,v:i});return s.val=!0,{type:k,bitmap:e.bitmap|u,array:d}}}}function ur(e,t,n,r,i,s){if(n===e.hash){const u=kt(e,r);if(u!==-1)return e.array[u].v===i?e:{type:ae,hash:n,array:R(e.array,u,{type:E,k:r,v:i})};const l=e.array.length;return s.val=!0,{type:ae,hash:n,array:R(e.array,l,{type:E,k:r,v:i})}}return Re({type:k,bitmap:Je(e.hash,t),array:[e]},t,n,r,i,s)}function kt(e,t){const n=e.array.length;for(let r=0;r<n;r++)if(ie(t,e.array[r].k))return r;return-1}function Pe(e,t,n,r){switch(e.type){case U:return lr(e,t,n,r);case k:return ar(e,t,n,r);case ae:return fr(e,r)}}function lr(e,t,n,r){const i=Ce(n,t),s=e.array[i];if(s!==void 0){if(s.type!==E)return Pe(s,t+D,n,r);if(ie(r,s.k))return s}}function ar(e,t,n,r){const i=Je(n,t);if(!(e.bitmap&i))return;const s=Et(e.bitmap,i),u=e.array[s];if(u.type!==E)return Pe(u,t+D,n,r);if(ie(r,u.k))return u}function fr(e,t){const n=kt(e,t);if(!(n<0))return e.array[n]}function Lt(e,t,n,r){switch(e.type){case U:return cr(e,t,n,r);case k:return or(e,t,n,r);case ae:return hr(e,r)}}function cr(e,t,n,r){const i=Ce(n,t),s=e.array[i];if(s===void 0)return e;let u;if(s.type===E){if(!ie(s.k,r))return e}else if(u=Lt(s,t+D,n,r),u===s)return e;if(u===void 0){if(e.size<=nr){const l=e.array,c=new Array(e.size-1);let d=0,$=0,v=0;for(;d<i;){const T=l[d];T!==void 0&&(c[$]=T,v|=1<<d,++$),++d}for(++d;d<l.length;){const T=l[d];T!==void 0&&(c[$]=T,v|=1<<d,++$),++d}return{type:k,bitmap:v,array:c}}return{type:U,size:e.size-1,array:R(e.array,i,u)}}return{type:U,size:e.size,array:R(e.array,i,u)}}function or(e,t,n,r){const i=Je(n,t);if(!(e.bitmap&i))return e;const s=Et(e.bitmap,i),u=e.array[s];if(u.type!==E){const l=Lt(u,t+D,n,r);return l===u?e:l!==void 0?{type:k,bitmap:e.bitmap,array:R(e.array,s,l)}:e.bitmap===i?void 0:{type:k,bitmap:e.bitmap^i,array:dt(e.array,s)}}return ie(r,u.k)?e.bitmap===i?void 0:{type:k,bitmap:e.bitmap^i,array:dt(e.array,s)}:e}function hr(e,t){const n=kt(e,t);if(n<0)return e;if(e.array.length!==1)return{type:ae,hash:e.hash,array:dt(e.array,n)}}function cn(e,t){if(e===void 0)return;const n=e.array,r=n.length;for(let i=0;i<r;i++){const s=n[i];if(s!==void 0){if(s.type===E){t(s.v,s.k);continue}cn(s,t)}}}class z{static fromObject(t){const n=Object.keys(t);let r=z.new();for(let i=0;i<n.length;i++){const s=n[i];r=r.set(s,t[s])}return r}static fromMap(t){let n=z.new();return t.forEach((r,i)=>{n=n.set(i,r)}),n}static new(){return new z(void 0,0)}constructor(t,n){this.root=t,this.size=n}get(t,n){if(this.root===void 0)return n;const r=Pe(this.root,0,C(t),t);return r===void 0?n:r.v}set(t,n){const r={val:!1},i=this.root===void 0?It:this.root,s=Re(i,0,C(t),t,n,r);return s===this.root?this:new z(s,r.val?this.size+1:this.size)}delete(t){if(this.root===void 0)return this;const n=Lt(this.root,0,C(t),t);return n===this.root?this:n===void 0?z.new():new z(n,this.size-1)}has(t){return this.root===void 0?!1:Pe(this.root,0,C(t),t)!==void 0}entries(){if(this.root===void 0)return[];const t=[];return this.forEach((n,r)=>t.push([r,n])),t}forEach(t){cn(this.root,t)}hashCode(){let t=0;return this.forEach((n,r)=>{t=t+ht(C(n),C(r))|0}),t}equals(t){if(!(t instanceof z)||this.size!==t.size)return!1;let n=!0;return this.forEach((r,i)=>{n=n&&ie(t.get(i,!r),r)}),n}}const vt=void 0,Ut={};function dr(e){return/^[-+]?(\d+)$/.test(e)?new o(parseInt(e)):new y(vt)}function pr(e){return e.toString()}function wr(e){const t=on(e);return t?re.fromArray(Array.from(t).map(n=>n.segment)):re.fromArray(e.match(/./gsu))}function on(e){if(Intl&&Intl.Segmenter)return new Intl.Segmenter().segment(e)[Symbol.iterator]()}function yr(e){var r,i;let t;const n=on(e);return n?t=(r=n.next().value)==null?void 0:r.segment:t=(i=e.match(/./su))==null?void 0:i[0],t?new o([t,e.slice(t.length)]):new y(vt)}function mr(e){let t="";for(const n of e)t=t+n;return t}function Tt(e,t){return e.indexOf(t)>=0}function _r(){return z.new()}function hn(e,t){const n=e.get(t,Ut);return n===Ut?new y(vt):new o(n)}function gr(e,t,n){return n.set(e,t)}function dn(e){if(typeof e=="string")return"String";if(e instanceof ve)return"Result";if(e instanceof re)return"List";if(e instanceof De)return"BitArray";if(e instanceof z)return"Dict";if(Number.isInteger(e))return"Int";if(Array.isArray(e))return`Tuple of ${e.length} elements`;if(typeof e=="number")return"Float";if(e===null)return"Null";if(e===void 0)return"Nil";{const t=typeof e;return t.charAt(0).toUpperCase()+t.slice(1)}}function St(e,t){return br(e,dn(t))}function br(e,t){return new y(re.fromArray([new bt(e,t,re.fromArray([]))]))}function xr(e){return typeof e=="string"?new o(e):St("String",e)}function $r(e){return Number.isInteger(e)?new o(e):St("Int",e)}function Ar(e,t){const n=()=>St("Dict",e);if(e instanceof z||e instanceof WeakMap||e instanceof Map){const r=hn(e,t);return new o(r.isOk()?new mt(r[0]):new qt)}else return Object.getPrototypeOf(e)==Object.prototype?Ft(e,t,()=>new o(new qt)):Ft(e,t,n)}function Ft(e,t,n){try{return t in e?new o(new mt(e[t])):n()}catch{return n()}}function Me(){return _r()}function Ne(e,t){return hn(e,t)}function Z(e,t,n){return gr(t,n,e)}function Ir(e,t){return n=>t(e(n))}class Er extends h{constructor(t){super(),this.all=t}}function Dt(){return new Er(a([]))}function Y(e,t,n,r){if(t!=null&&t.tag&&(e==null?void 0:e.nodeType)===1){const i=t.tag.toUpperCase(),s=t.namespace||"http://www.w3.org/1999/xhtml";return e.nodeName===i&&e.namespaceURI==s?Or(e,t,n,r):Pt(e,t,n,r)}return t!=null&&t.tag?Pt(e,t,n,r):typeof(t==null?void 0:t.content)=="string"?(e==null?void 0:e.nodeType)===3?Lr(e,t):kr(e,t):document.createComment(["[internal lustre error] I couldn't work out how to render this element. This","function should only be called internally by lustre's runtime: if you think","this is an error, please open an issue at","https://github.com/hayleigh-dot-dev/gleam-lustre/issues/new"].join(" "))}function Pt(e,t,n,r=null){const i=t.namespace?document.createElementNS(t.namespace,t.tag):document.createElement(t.tag);i.$lustre={__registered_events:new Set};let s="";for(const u of t.attrs)u[0]==="class"?$e(i,u[0],`${i.className} ${u[1]}`):u[0]==="style"?$e(i,u[0],`${i.style.cssText} ${u[1]}`):u[0]==="dangerous-unescaped-html"?s+=u[1]:u[0]!==""&&$e(i,u[0],u[1],n);if(customElements.get(t.tag))i._slot=t.children;else if(t.tag==="slot"){let u=new Ke,l=r;for(;l;)if(l._slot){u=l._slot;break}else l=l.parentNode;for(const c of u)i.appendChild(Y(null,c,n,i))}else if(s)i.innerHTML=s;else for(const u of t.children)i.appendChild(Y(null,u,n,i));return e&&e.replaceWith(i),i}function Or(e,t,n,r){const i=e.attributes,s=new Map;e.$lustre??(e.$lustre={__registered_events:new Set});for(const u of t.attrs)u[0]==="class"&&s.has("class")?s.set(u[0],`${s.get("class")} ${u[1]}`):u[0]==="style"&&s.has("style")?s.set(u[0],`${s.get("style")} ${u[1]}`):u[0]==="dangerous-unescaped-html"&&s.has("dangerous-unescaped-html")?s.set(u[0],`${s.get("dangerous-unescaped-html")} ${u[1]}`):u[0]!==""&&s.set(u[0],u[1]);for(const{name:u,value:l}of i)if(!s.has(u))e.removeAttribute(u);else{const c=s.get(u);c!==l&&($e(e,u,c,n),s.delete(u))}for(const u of e.$lustre.__registered_events)if(!s.has(u)){const l=u.slice(2).toLowerCase();e.removeEventListener(l,e.$lustre[`${u}Handler`]),e.$lustre.__registered_events.delete(u),delete e.$lustre[u],delete e.$lustre[`${u}Handler`]}for(const[u,l]of s)$e(e,u,l,n);if(customElements.get(t.tag))e._slot=t.children;else if(t.tag==="slot"){let u=e.firstChild,l=new Ke,c=r;for(;c;)if(c._slot){l=c._slot;break}else c=c.parentNode;for(;u;)Array.isArray(l)&&l.length?Y(u,l.shift(),n,e):l.head&&(Y(u,l.head,n,e),l=l.tail),u=u.nextSibling;for(const d of l)e.appendChild(Y(null,d,n,e))}else if(s.has("dangerous-unescaped-html"))e.innerHTML=s.get("dangerous-unescaped-html");else{let u=e.firstChild,l=t.children;for(;u;)if(Array.isArray(l)&&l.length){const c=u.nextSibling;Y(u,l.shift(),n,e),u=c}else if(l.head){const c=u.nextSibling;Y(u,l.head,n,e),l=l.tail,u=c}else{const c=u.nextSibling;u.remove(),u=c}for(const c of l)e.appendChild(Y(null,c,n,e))}return e}function $e(e,t,n,r){switch(typeof n){case"string":e.getAttribute(t)!==n&&e.setAttribute(t,n),n===""&&e.removeAttribute(t),t==="value"&&e.value!==n&&(e.value=n);break;case(t.startsWith("on")&&"function"):{if(e.$lustre[t]===n)break;const i=t.slice(2).toLowerCase(),s=u=>Se(n(u),r);e.$lustre[`${t}Handler`]&&e.removeEventListener(i,e.$lustre[`${t}Handler`]),e.addEventListener(i,s),e.$lustre[t]=n,e.$lustre[`${t}Handler`]=s,e.$lustre.__registered_events.add(t);break}default:e[t]=n}}function kr(e,t){const n=document.createTextNode(t.content);return e&&e.replaceWith(n),n}function Lr(e,t){const n=e.nodeValue,r=t.content;return r?(n!==r&&(e.nodeValue=r),e):(e==null||e.remove(),null)}var O,K,X,J,ne,Ee,ye,me,Oe,pt,ke,wt;class vr{constructor(t,n,r){S(this,Oe);S(this,ke);S(this,O,null);S(this,K,null);S(this,X,[]);S(this,J,[]);S(this,ne,!1);S(this,Ee,null);S(this,ye,null);S(this,me,null);b(this,Ee,t),b(this,ye,n),b(this,me,r)}start(t,n){if(!Cr())return new y(new Dr);if(_(this,O))return new y(new Vr);if(b(this,O,t instanceof HTMLElement?t:document.querySelector(t)),!_(this,O))return new y(new Fr);const[r,i]=_(this,Ee).call(this,n);return b(this,K,r),b(this,J,i.all.toArray()),b(this,ne,!0),window.requestAnimationFrame(()=>be(this,Oe,pt).call(this)),new o(s=>this.dispatch(s))}dispatch(t){_(this,X).push(t),be(this,Oe,pt).call(this)}emit(t,n=null){_(this,O).dispatchEvent(new CustomEvent(t,{bubbles:!0,detail:n,composed:!0}))}destroy(){if(!_(this,O))return new y(new Ur);_(this,O).remove(),b(this,O,null),b(this,K,null),b(this,X,[]),b(this,J,[]),b(this,ne,!1),b(this,ye,()=>{}),b(this,me,()=>{})}}O=new WeakMap,K=new WeakMap,X=new WeakMap,J=new WeakMap,ne=new WeakMap,Ee=new WeakMap,ye=new WeakMap,me=new WeakMap,Oe=new WeakSet,pt=function(){if(be(this,ke,wt).call(this),_(this,ne)){const t=_(this,me).call(this,_(this,K));b(this,O,Y(_(this,O),t,n=>this.dispatch(n))),b(this,ne,!1)}},ke=new WeakSet,wt=function(t=0){if(_(this,O)){if(_(this,X).length)for(;_(this,X).length;){const[n,r]=_(this,ye).call(this,_(this,K),_(this,X).shift());_(this,ne)||b(this,ne,_(this,K)!==n),b(this,K,n),b(this,J,_(this,J).concat(r.all.toArray()))}for(;_(this,J).length;)_(this,J).shift()(n=>this.dispatch(n),(n,r)=>this.emit(n,r));_(this,X).length&&(t>=5?console.warn(tooManyUpdates):be(this,ke,wt).call(this,++t))}};const Tr=(e,t,n)=>new vr(e,t,n),Sr=(e,t,n)=>e.start(t,n),Cr=()=>window&&window.document;function Ze(e){let n=nn(e);return rn(n)}function Rr(e){return yr(e)}class pn extends h{constructor(t,n,r){super(),this[0]=t,this[1]=n,this.as_property=r}}class Mr extends h{constructor(t,n){super(),this[0]=t,this[1]=n}}function _e(e,t){return new pn(e,xt(t),!1)}function wn(e,t){return new pn(e,xt(t),!0)}function Nr(e,t){return new Mr("on"+e,Ir(t,n=>gt(n,void 0)))}function zr(e){return _e("style",_t(e,"",(t,n)=>{let r=n[0],i=n[1];return t+r+":"+i+";"}))}function qe(e){return _e("id",e)}function Ht(e){return _e("placeholder",e)}function he(e){return _e("href",e)}function jr(e){return _e("src",e)}function Wr(e){return wn("height",Te(e))}function qr(e){return wn("width",Te(e))}class Br extends h{constructor(t){super(),this.content=t}}class I extends h{constructor(t,n,r,i,s,u){super(),this.namespace=t,this.tag=n,this.attrs=r,this.children=i,this.self_closing=s,this.void=u}}function Q(e,t,n){return e==="area"?new I("",e,t,a([]),!1,!0):e==="base"?new I("",e,t,a([]),!1,!0):e==="br"?new I("",e,t,a([]),!1,!0):e==="col"?new I("",e,t,a([]),!1,!0):e==="embed"?new I("",e,t,a([]),!1,!0):e==="hr"?new I("",e,t,a([]),!1,!0):e==="img"?new I("",e,t,a([]),!1,!0):e==="input"?new I("",e,t,a([]),!1,!0):e==="link"?new I("",e,t,a([]),!1,!0):e==="meta"?new I("",e,t,a([]),!1,!0):e==="param"?new I("",e,t,a([]),!1,!0):e==="source"?new I("",e,t,a([]),!1,!0):e==="track"?new I("",e,t,a([]),!1,!0):e==="wbr"?new I("",e,t,a([]),!1,!0):new I("",e,t,n,!1,!1)}function p(e){return new Br(e)}class Vr extends h{}class Ur extends h{}class Fr extends h{}class Dr extends h{}function Pr(e,t,n){return Tr(s=>[e(s),Dt()],(s,u)=>[t(s,u),Dt()],n)}function lt(e,t){return Q("h3",e,t)}function xe(e,t){return Q("div",e,t)}function at(e,t){return Q("p",e,t)}function de(e,t){return Q("a",e,t)}function Gt(e){return Q("br",e,a([]))}function ft(e,t){return Q("code",e,t)}function Yt(e,t){return Q("strong",e,t)}function Hr(e){return Q("iframe",e,a([]))}function Kt(e){return Q("textarea",e,a([]))}function Gr(e,t){return Nr(e,t)}function Yr(e){let t=e;return Bt("target",Bt("value",sn))(t)}function Xt(e){return Gr("input",t=>{let n=Yr(t);return Se(n,e)})}class He extends h{constructor(t){super(),this.error=t}}class Ve extends h{constructor(t,n){super(),this.row=t,this.col=n}}class V extends h{constructor(t){super(),this.parse=t}}function A(e,t,n){let r=e.parse;return r(t,n)}function Qe(e){return new V((t,n)=>{if(!(n instanceof Ve))throw Xe("assignment_no_match","party",58,"","Assignment pattern did not match",{value:n});let r=n.row,i=n.col;if(t.atLeastLength(1)){let s=t.head,u=t.tail;return e(s)?s===`
`?new o([s,u,new Ve(r+1,0)]):new o([s,u,new Ve(r,i+1)]):new y(new He(s))}else return new y(new He("EOF"))})}function m(e){return Qe(t=>e===t)}function oe(e,t){return new V((n,r)=>Yn(A(e,n,r),A(t,n,r)))}function ze(e){return new V((t,n)=>{if(e.hasLength(0))return new y(new He("choiceless choice"));if(e.hasLength(1)){let r=e.head;return A(r,t,n)}else{let r=e.head,i=e.tail,s=A(r,t,n);if(s.isOk()){let u=s[0][0],l=s[0][1],c=s[0][2];return new o([u,l,c])}else return A(ze(i),t,n)}})}function se(e){return new V((t,n)=>{let r=A(e,t,n);if(r.isOk()){let i=r[0][0],s=r[0][1],u=r[0][2];return Se(A(se(e),s,u),l=>[Le(i,l[0]),l[1],l[2]])}else return new o([a([]),t,n])})}function yn(e){return new V((t,n)=>{let r=A(e,t,n);if(r.isOk()){let i=r[0][0],s=r[0][1],u=r[0][2];return Se(A(se(e),s,u),l=>[Le(i,l[0]),l[1],l[2]])}else{let i=r[0];return new y(i)}})}function F(e,t){return new V((n,r)=>{let i=A(e,n,r);if(i.isOk()){let s=i[0][0],u=i[0][1],l=i[0][2];return new o([t(s),u,l])}else{let s=i[0];return new y(s)}})}function Kr(e){return new V((t,n)=>{let r=A(e,t,n);if(r.isOk()){let i=r[0][0],s=r[0][1],u=r[0][2];return new o([new o(i),s,u])}else return new o([new y(void 0),t,n])})}function Ct(e){return new V((t,n)=>A(e,t,n).isOk()?new y(new He("")):new o([void 0,t,n]))}function M(e){return new V((t,n)=>A(e(),t,n))}function f(e,t){return new V((n,r)=>{let i=A(e,n,r);if(i.isOk()){let s=i[0][0],u=i[0][1],l=i[0][2];return A(t(s),u,l)}else{let s=i[0];return new y(s)}})}function x(e){return new V((t,n)=>new o([e,t,n]))}function fe(e){let t=Rr(e);if(t.isOk()){let n=t[0][0],r=t[0][1];return f(m(n),i=>f(fe(r),s=>x(i+s)))}else return x("")}function mn(e,t){let n=A(e,wr(t),new Ve(1,1));if(n.isOk()){let r=n[0][0];return new o(r)}else{let r=n[0];return new y(r)}}function Xr(){return Qe(e=>Tt("abcdefghijklmnopqrstuvwxyz",e))}function Jr(){return Qe(e=>Tt("ABCDEFGHIJKLMNOPQRSTUVWXYZ",e))}function Rt(){return oe(Xr(),Jr())}function Mt(){return Qe(e=>Tt("0123456789",e))}function je(){return oe(Mt(),Rt())}let _n=class extends h{constructor(t){super(),this[0]=t}},gn=class extends h{constructor(t){super(),this[0]=t}},bn=class extends h{constructor(t,n){super(),this[0]=t,this[1]=n}},Zr=class extends h{constructor(t,n){super(),this[0]=t,this[1]=n}},xn=class extends h{constructor(t){super(),this.int=t}},Be=class extends h{constructor(t,n){super(),this.val=t,this.gen=n}},Nt=class extends h{constructor(t){super(),this[0]=t}},zt=class extends h{constructor(t,n){super(),this[0]=t,this[1]=n}},Ae=class extends h{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}},Ge=class extends h{constructor(t,n){super(),this[0]=t,this[1]=n}};function Qr(){let e=yn(Mt()),t=F(e,Ze),n=F(t,Qt),r=F(n,i=>tn(i,()=>{throw Xe("panic","tinylang",19,"","parsed int isn't an int",{})}));return F(r,i=>new _n(i))}function $n(){return f(Rt(),e=>f(se(oe(je(),m("_"))),t=>x(e+Ze(t))))}function ei(){let e=$n();return F(e,t=>new gn(t))}function we(){return f(se(ze(a([m(" "),m("	"),m(`
`)]))),e=>x(void 0))}function ti(e,t){return t(new xn(e.int+1),e.int)}function Ue(e,t,n){if(t instanceof _n){let r=t[0];return new o(new Be(new Nt(r),e))}else if(t instanceof gn){let r=t[0],i=Ne(n,r);if(i.isOk()){let s=i[0];return new o(new Be(new zt(s,r),e))}else return new y("Wait! "+r+" isn't defined anywhere!")}else if(t instanceof bn){let r=t[0],i=t[1];return ti(e,(s,u)=>g(Ue(s,i,Z(n,r,u)),l=>{let c=new Ae(u,r,l.val),d=new Be(c,s);return new o(d)}))}else{let r=t[0],i=t[1];return g(Ue(e,r,n),s=>g(Ue(s.gen,i,n),u=>{let l=new Ge(s.val,u.val),c=new Be(l,u.gen);return new o(c)}))}}function ni(e,t){return g(Ue(e,t,Me()),n=>new o(n.val))}function Fe(e,t){for(;;){let n=e,r=t;if(n instanceof Nt)return n;if(n instanceof zt){let i=n[0],s=Ne(r,i);return s.isOk()?s[0]:n}else if(n instanceof Ge){let i=n[0],s=n[1],u=Fe(i,r),l=Fe(s,r);if(u instanceof Ae){let c=u[0];e=u[2],t=Z(r,c,l)}else return new Ge(u,l)}else{let i=n[0],s=n[1],u=n[2];return new Ae(i,s,Fe(u,r))}}}function ri(e){return Fe(e,Me())}function pe(e){if(e instanceof Nt){let t=e[0];return Te(t)}else{if(e instanceof zt)return e[1];if(e instanceof Ae){let t=e[1],n=e[2];return"\\"+t+". "+pe(n)}else if(e instanceof Ge&&e[0]instanceof Ae){let t=e[0],n=e[1];return"("+pe(t)+")("+pe(n)+")"}else{let t=e[0],n=e[1];return pe(t)+"("+pe(n)+")"}}}function ii(e){return e.isOk(),e[0]}function et(){return f(we(),e=>f(ze(a([Qr(),ei(),si(),ui()])),t=>f(we(),n=>f(se(f(m("("),r=>f(M(et),i=>f(m(")"),s=>f(we(),u=>x(i)))))),r=>{let i=_t(r,t,(s,u)=>new Zr(s,u));return x(i)}))))}function si(){return f(m("\\"),e=>f(we(),t=>f($n(),n=>f(we(),r=>f(m("."),i=>f(we(),s=>f(M(et),u=>x(new bn(n,u)))))))))}function ui(){return f(m("("),e=>f(M(et),t=>f(m(")"),n=>x(t))))}function li(e){let t=g(gt(mn(et(),e),"there's a mistake in the notation somewhere; I couldn't understand it!"),n=>g(ni(new xn(0),n),r=>{let i=ri(r);return new o(pe(i))}));return ii(t)}class An extends h{constructor(t){super(),this[0]=t}}class In extends h{constructor(t){super(),this[0]=t}}class En extends h{constructor(t,n){super(),this[0]=t,this[1]=n}}class On extends h{constructor(t,n){super(),this[0]=t,this[1]=n}}class kn extends h{}class Ln extends h{}class jt extends h{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}}class ai extends h{constructor(t,n,r,i){super(),this[0]=t,this[1]=n,this[2]=r,this[3]=i}}class vn extends h{constructor(t){super(),this.int=t}}class ee extends h{constructor(t,n){super(),this.val=t,this.gen=n}}class ce extends h{constructor(t){super(),this[0]=t}}class j extends h{constructor(t,n){super(),this[0]=t,this[1]=n}}class W extends h{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}}class P extends h{constructor(t,n){super(),this[0]=t,this[1]=n}}class L extends h{}class B extends h{}class N extends h{constructor(t,n,r,i){super(),this[0]=t,this[1]=n,this[2]=r,this[3]=i}}class We extends h{constructor(t,n,r,i,s){super(),this[0]=t,this[1]=n,this[2]=r,this[3]=i,this[4]=s}}function fi(){let e=yn(Mt()),t=F(e,Ze),n=F(t,Qt),r=F(n,i=>tn(i,()=>{throw Xe("panic","tinytypedlang",23,"","parsed int isn't an int",{})}));return F(r,i=>new An(i))}function tt(){return f(Rt(),e=>f(se(oe(je(),m("_"))),t=>x(e+Ze(t))))}function ci(){let e=tt();return F(e,t=>new In(t))}function oi(){return f(fe("Type"),e=>f(Ct(oe(je(),m("_"))),t=>x(new kn)))}function hi(){return f(fe("Int"),e=>f(Ct(oe(je(),m("_"))),t=>x(new Ln)))}function q(){return f(se(ze(a([m(" "),m("	"),m(`
`)]))),e=>x(void 0))}function ct(e,t){return t(new vn(e.int+1),e.int)}function G(e,t,n){if(t instanceof An){let r=t[0];return new o(new ee(new ce(r),e))}else if(t instanceof In){let r=t[0],i=Ne(n,r);if(i.isOk()){let s=i[0];return new o(new ee(new j(s,r),e))}else return new y("Wait! "+r+" isn't defined anywhere!")}else if(t instanceof En){let r=t[0],i=t[1];return ct(e,(s,u)=>g(G(s,i,Z(n,r,u)),l=>{let c=new W(u,r,l.val),d=new ee(c,s);return new o(d)}))}else if(t instanceof On){let r=t[0],i=t[1];return g(G(e,r,n),s=>g(G(s.gen,i,n),u=>{let l=new P(s.val,u.val),c=new ee(l,u.gen);return new o(c)}))}else{if(t instanceof kn)return new o(new ee(new L,e));if(t instanceof Ln)return new o(new ee(new B,e));if(t instanceof jt){let r=t[0],i=t[1],s=t[2];return ct(e,(u,l)=>g(G(u,i,n),c=>g(G(c.gen,s,Z(n,r,l)),d=>{let $=new N(l,r,c.val,d.val),v=new ee($,d.gen);return new o(v)})))}else{let r=t[0],i=t[1],s=t[2],u=t[3];return ct(e,(l,c)=>g(G(l,i,n),d=>{let $=Z(n,r,c);return g(G(d.gen,s,$),v=>g(G(v.gen,u,$),T=>{let ge=new We(c,r,d.val,v.val,T.val),rt=new ee(ge,T.gen);return new o(rt)}))}))}}}function di(e,t){return g(G(e,t,Me()),n=>new o(n.val))}function nt(e,t,n){let r=i=>nt(i,t,n);if(e instanceof ce){let i=e[0];return new ce(i)}else if(e instanceof j){let i=e[0];return t===i?n:e}else if(e instanceof W){let i=e[0],s=e[1],u=e[2];return new W(i,s,r(u))}else if(e instanceof P){let i=e[0],s=e[1];return new P(r(i),r(s))}else{if(e instanceof L)return new L;if(e instanceof B)return new B;if(e instanceof N){let i=e[0],s=e[1],u=e[2],l=e[3];return new N(i,s,r(u),r(l))}else{let i=e[0],s=e[1],u=e[2],l=e[3],c=e[4];return new We(i,s,r(u),r(l),r(c))}}}function yt(e,t){if(e instanceof j&&t instanceof j){let n=e[0],r=t[0];return n===r}else{if(e instanceof B&&t instanceof B)return!0;if(e instanceof L&&t instanceof L)return!0;if(e instanceof N&&t instanceof N){let n=e[0],r=e[1],i=e[2],s=e[3],u=t[0],l=t[2],c=t[3];return yt(i,l)&&yt(nt(c,u,new j(n,r)),s)}else return!1}}function ue(e,t){for(;;){let n=e,r=t;if(n instanceof ce)return n;if(n instanceof j){let i=n[0],s=Ne(r,i);return s.isOk()?s[0]:n}else if(n instanceof P){let i=n[0],s=n[1],u=ue(i,r),l=ue(s,r);if(u instanceof W){let c=u[0];e=u[2],t=Z(r,c,l)}else return new P(u,l)}else{if(n instanceof L)return new L;if(n instanceof B)return new B;if(n instanceof We){let i=n[0],s=n[3];e=n[4],t=Z(r,i,ue(s,r))}else if(n instanceof W){let i=n[0],s=n[1],u=n[2];return new W(i,s,ue(u,r))}else{let i=n[0],s=n[1],u=n[2],l=n[3];return new N(i,s,ue(u,r),ue(l,r))}}}}function pi(e){return ue(e,Me())}function te(e,t){for(;;){let n=e,r=t;if(r instanceof j)return r[0]===n;if(r instanceof W){let i=r[2];e=n,t=i}else if(r instanceof P){let i=r[0],s=r[1];return te(n,i)||te(n,s)}else if(r instanceof N){let i=r[2],s=r[3];return te(n,i)||te(n,s)}else if(r instanceof We){let i=r[2],s=r[3],u=r[4];return te(n,i)||te(n,s)||te(n,u)}else return!1}}function w(e){if(e instanceof ce){let t=e[0];return Te(t)}else{if(e instanceof j)return e[1];if(e instanceof W){let t=e[1],n=e[2];return"\\"+t+". "+w(n)}else if(e instanceof P&&e[0]instanceof W){let t=e[0],n=e[1];return"("+w(t)+")("+w(n)+")"}else if(e instanceof P){let t=e[0],n=e[1];return w(t)+"("+w(n)+")"}else{if(e instanceof L)return"Type";if(e instanceof B)return"Int";if(e instanceof N){let t=e[0],n=e[1],r=e[2],i=e[3];return te(t,i)?"forall "+n+": "+w(r)+". "+w(i):r instanceof ce||r instanceof j||r instanceof L||r instanceof B?w(r)+"->"+w(i):(r instanceof W||r instanceof P||r instanceof N,"("+w(r)+") -> "+w(i))}else{let t=e[1],n=e[2],r=e[3],i=e[4];return"let "+t+": "+w(n)+" = "+w(r)+`;
`+w(i)}}}}function wi(e){return e.isOk(),e[0]}function Jt(e,t,n){for(;;){let r=e,i=t,s=n;if(r instanceof W){let u=r[0],l=r[1],c=r[2];if(i instanceof N){let d=i[0],$=i[2],v=i[3];e=c,t=nt(v,d,new j(u,l)),n=Z(s,u,$)}else return new y("Type mismatch. Expected "+w(i)+" but found a lambda.")}else return g(Ye(r,s),u=>yt(u,i)?new o(void 0):new y("Type mismatch. Expected "+w(i)+" but found "+w(u)+"."))}}function Ye(e,t){if(e instanceof ce)return new o(new B);if(e instanceof j){let n=e[0],r=e[1];return en(Ne(t,n),i=>"Variable "+r+" is not defined in the current context.")}else if(e instanceof P){let n=e[0],r=e[1];return g(Ye(n,t),i=>{if(i instanceof N){let s=i[0],u=i[2],l=i[3];return g(Jt(r,u,t),c=>new o(nt(l,s,r)))}else return new y("Type error. Expected a function type, but found "+w(i))})}else{if(e instanceof N)return new o(new L);if(e instanceof B)return new o(new L);if(e instanceof L)return new o(new L);if(e instanceof We){let n=e[0],r=e[2],i=e[3],s=e[4];return g(Jt(i,r,t),u=>Ye(s,Z(t,n,r)))}else return new y("Type error. Can't infer the type of this lambda. Try annotating it with a `let` expression.")}}function H(){return f(q(),e=>f(ze(a([fi(),oi(),hi(),yi(),_i(),ci(),mi(),gi()])),t=>f(q(),n=>f(se(f(m("("),r=>f(M(H),i=>f(m(")"),s=>f(q(),u=>x(i)))))),r=>{let i=_t(r,t,(s,u)=>new On(s,u));return f(Kr(fe("->")),s=>f((()=>s.isOk()?f(M(H),u=>x(new jt("_",i,u))):x(i))(),u=>x(u)))}))))}function yi(){return f(fe("forall"),e=>f(Ct(oe(je(),m("_"))),t=>f(q(),n=>f(tt(),r=>f(q(),i=>f(m(":"),s=>f(q(),u=>f(M(H),l=>f(m("."),c=>f(M(H),d=>x(new jt(r,l,d))))))))))))}function mi(){return f(m("\\"),e=>f(q(),t=>f(tt(),n=>f(q(),r=>f(m("."),i=>f(q(),s=>f(M(H),u=>x(new En(n,u)))))))))}function _i(){return f(fe("let "),e=>f(q(),t=>f(tt(),n=>f(q(),r=>f(m(":"),i=>f(M(H),s=>f(fe("="),u=>f(M(H),l=>f(m(";"),c=>f(M(H),d=>x(new ai(n,s,l,d))))))))))))}function gi(){return f(m("("),e=>f(M(H),t=>f(m(")"),n=>x(t))))}function bi(e){let t=g(gt(mn(H(),e),"there's a mistake in the notation somewhere; I couldn't understand it!"),n=>g(di(new vn(0),n),r=>g(Ye(r,Me()),i=>{let s=pi(r);return new o(w(s))})));return wi(t)}class Ie extends h{constructor(t,n){super(),this.untyped=t,this.typed=n}}class Tn extends h{constructor(t){super(),this[0]=t}}class xi extends h{constructor(t){super(),this[0]=t}}function $i(e){return new Ie("","")}function Ai(e,t){if(t instanceof Tn){let n=t[0];return new Ie(n,e.typed)}else{let n=t[0];return new Ie(e.untyped,n)}}function Ii(e){return xe(a([]),a([lt(a([]),a([p("Who I Am")])),at(a([]),a([p("I'm Ryan Brewer, the software developer behind "),de(a([he("https://github.com/RyanBrewer317/SaberVM")]),a([p("SaberVM")])),p(`,
an abstract machine for safe, portable computation that functional languages can compile to. 
With SaberVM, I'm hoping to broaden accessibility to safe computation, both informationally and financially. 
Consider supporting my work!
`)])),Hr(a([jr("https://github.com/sponsors/RyanBrewer317/button"),_e("title","Sponsor RyanBrewer317"),Wr(32),qr(114),zr(a([["border","0"],["border-radius","6px;"]]))])),lt(a([]),a([p("My Website")])),at(a([]),a([p("This is my website. It's hosted by Firebase and written mostly in "),de(a([he("https://gleam.run")]),a([p("Gleam")])),p(", and the code is up on my "),de(a([he("https://github.com/RyanBrewer317/ryanbrewer-dev")]),a([p("github")])),p(". The only framework used is "),de(a([he("https://lustre.build/")]),a([p("Lustre")])),p("; scripting, markup, styles, and layout were all done by hand.")])),lt(a([]),a([p("Lambda Calculus in Gleam")])),at(a([]),a([p(`
I study programming language design, and I'm particularly fond of functional programming.
That's why I made this website in `),de(a([he("https://gleam.run")]),a([p("Gleam")])),p(`,
a statically-typed functional language
that can run anywhere JavaScript can, as well as on Erlang's BEAM VM. 
I've used Gleam to write a lambda calculus evaluator that you can play with below. 
Lambda abstractions are written like 
`),ft(a([]),a([p("\\var. body")])),p(", and are called like "),ft(a([]),a([p("fun(arg)")])),p(". There are also positive integers like 7. Try writing "),ft(a([]),a([p("(\\x.x)(2)")])),p(", which evaluates to 2. The code for this can be found "),de(a([he("https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/tinylang.gleam")]),a([p("here")]))])),Kt(a([qe("code"),Ht("Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)(3)"),Xt(t=>new Tn(t))])),Gt(a([])),(()=>{if(e instanceof Ie&&e.untyped==="")return p("");{let t=e.untyped,n=li(t);return(r=>xe(a([]),a([Yt(a([]),a([p("output ")])),p(" (variables may be renamed): "),xe(a([qe("code-output")]),a([p(r)]))])))(n)}})(),Kt(a([qe("code"),Ht("Play with dependent types! Example: let id: forall x: Type. x->x = \\a.\\x.x; id(Int)(3)"),Xt(t=>new xi(t))])),Gt(a([])),(()=>{if(e instanceof Ie&&e.typed==="")return p("");{let t=e.typed,n=bi(t);return(r=>xe(a([]),a([Yt(a([]),a([p("output ")])),p(" (variables may be renamed): "),xe(a([qe("code-output")]),a([p(r)]))])))(n)}})()]))}function Ei(){let e=Pr($i,Ai,Ii),t=Sr(e,"[data-lustre-app]",void 0);if(!t.isOk())throw Xe("assignment_no_match","ryanbrewerdev",15,"main","Assignment pattern did not match",{value:t});return t[0]}document.addEventListener("DOMContentLoaded",()=>{Ei()});
