var ke=(e,t,n)=>{if(!t.has(e))throw TypeError("Cannot "+n)};var p=(e,t,n)=>(ke(e,t,"read from private field"),n?n.call(e):t.get(e)),O=(e,t,n)=>{if(t.has(e))throw TypeError("Cannot add the same private member more than once");t instanceof WeakSet?t.add(e):t.set(e,n)},w=(e,t,n,r)=>(ke(e,t,"write to private field"),r?r.call(e,n):t.set(e,n),n);var te=(e,t,n)=>(ke(e,t,"access private method"),n);import"./style-b7ef9c88.js";class h{withFields(t){let n=Object.keys(this).map(r=>r in t?t[r]:this[r]);return new this.constructor(...n)}}class F{static fromArray(t,n){let r=n||new ge;return t.reduceRight((s,i)=>new Wt(i,s),r)}[Symbol.iterator](){return new Bt(this)}toArray(){return[...this]}atLeastLength(t){for(let n of this){if(t<=0)return!0;t--}return t<=0}hasLength(t){for(let n of this){if(t<=0)return!1;t--}return t===0}countLength(){let t=0;for(let n of this)t++;return t}}function l(e,t){return F.fromArray(e,t)}var V;class Bt{constructor(t){O(this,V,void 0);w(this,V,t)}next(){if(p(this,V)instanceof ge)return{done:!0};{let{head:t,tail:n}=p(this,V);return w(this,V,n),{value:t,done:!1}}}}V=new WeakMap;class ge extends F{}class Wt extends F{constructor(t,n){super(),this.head=t,this.tail=n}}class ye{constructor(t){if(!(t instanceof Uint8Array))throw"BitArray can only be constructed from a Uint8Array";this.buffer=t}get length(){return this.buffer.length}byteAt(t){return this.buffer[t]}floatAt(t){return Ut(this.buffer.slice(t,t+8))}intFromSlice(t,n){return Ft(this.buffer.slice(t,n))}binaryFromSlice(t,n){return new ye(this.buffer.slice(t,n))}sliceAfter(t){return new ye(this.buffer.slice(t))}}function Ft(e){e=e.reverse();let t=0;for(let n=e.length-1;n>=0;n--)t=t*256+e[n];return t}function Ut(e){return new Float64Array(e.reverse().buffer)[0]}class le extends h{static isResult(t){return t instanceof le}}class m extends le{constructor(t){super(),this[0]=t}isOk(){return!0}}class _ extends le{constructor(t){super(),this[0]=t}isOk(){return!1}}function U(e,t){let n=[e,t];for(;n.length;){let r=n.pop(),s=n.pop();if(r===s)continue;if(!tt(r)||!tt(s)||!Xt(r,s)||Ht(r,s)||Dt(r,s)||Pt(r,s)||Yt(r,s)||Gt(r,s)||Kt(r,s))return!1;const u=Object.getPrototypeOf(r);if(u!==null&&typeof u.equals=="function")try{if(r.equals(s))continue;return!1}catch{}let[a,c]=Vt(r);for(let d of a(r))n.push(c(r,d),c(s,d))}return!0}function Vt(e){if(e instanceof Map)return[t=>t.keys(),(t,n)=>t.get(n)];{let t=e instanceof globalThis.Error?["message"]:[];return[n=>[...t,...Object.keys(n)],(n,r)=>n[r]]}}function Ht(e,t){return e instanceof Date&&(e>t||e<t)}function Dt(e,t){return e.buffer instanceof ArrayBuffer&&e.BYTES_PER_ELEMENT&&!(e.byteLength===t.byteLength&&e.every((n,r)=>n===t[r]))}function Pt(e,t){return Array.isArray(e)&&e.length!==t.length}function Yt(e,t){return e instanceof Map&&e.size!==t.size}function Gt(e,t){return e instanceof Set&&(e.size!=t.size||[...e].some(n=>!t.has(n)))}function Kt(e,t){return e instanceof RegExp&&(e.source!==t.source||e.flags!==t.flags)}function tt(e){return typeof e=="object"&&e!==null}function Xt(e,t){return typeof e!="object"&&typeof t!="object"&&(!e||!t)||[Promise,WeakSet,WeakMap,Function].some(r=>e instanceof r)?!1:e.constructor===t.constructor}function o(e,t,n,r,s,i){let u=new globalThis.Error(s);u.gleam_error=e,u.module=t,u.line=n,u.fn=r;for(let a in i)u[a]=i[a];return u}class qe extends h{constructor(t){super(),this[0]=t}}class nt extends h{}function Jt(e,t){if(e instanceof qe){let n=e[0];return new m(n)}else return new _(t)}function Zt(e){return Nn(e)}function be(e){return En(e)}function Qt(e,t){for(;;){let n=e,r=t;if(n.hasLength(0))return r;if(n.atLeastLength(1)){let s=n.head;e=n.tail,t=l([s],r)}else throw o("case_no_match","gleam/list",124,"do_reverse_acc","No case clause matched",{values:[n]})}}function en(e){return Qt(e,l([]))}function tn(e){return en(e)}function nn(e,t,n){for(;;){let r=e,s=t,i=n;if(r.hasLength(0))return tn(i);if(r.atLeastLength(1)){let u=r.head;e=r.tail,t=s,n=l([s(u)],i)}else throw o("case_no_match","gleam/list",361,"do_map","No case clause matched",{values:[r]})}}function rn(e,t){return nn(e,t,l([]))}function ot(e,t,n){for(;;){let r=e,s=t,i=n;if(r.hasLength(0))return s;if(r.atLeastLength(1)){let u=r.head;e=r.tail,t=i(s,u),n=i}else throw o("case_no_match","gleam/list",722,"fold","No case clause matched",{values:[r]})}}function ce(e,t){if(e.isOk()){let n=e[0];return new m(t(n))}else{if(e.isOk())throw o("case_no_match","gleam/result",67,"map","No case clause matched",{values:[e]});{let n=e[0];return new _(n)}}}function sn(e,t){if(e.isOk()){let n=e[0];return new m(n)}else{if(e.isOk())throw o("case_no_match","gleam/result",95,"map_error","No case clause matched",{values:[e]});{let n=e[0];return new _(t(n))}}}function W(e,t){if(e.isOk()){let n=e[0];return t(n)}else{if(e.isOk())throw o("case_no_match","gleam/result",162,"try","No case clause matched",{values:[e]});{let n=e[0];return new _(n)}}}function un(e,t){if(e.isOk())return e[0];if(e.isOk())throw o("case_no_match","gleam/result",215,"lazy_unwrap","No case clause matched",{values:[e]});return t()}function an(e,t){if(e.isOk())return e;if(e.isOk())throw o("case_no_match","gleam/result",308,"or","No case clause matched",{values:[e]});return t}function ft(e,t){if(e.isOk()){let n=e[0];return new m(n)}else{if(e.isOk())throw o("case_no_match","gleam/result",428,"replace_error","No case clause matched",{values:[e]});return new _(t)}}function ht(e){return In(e)}function dt(e){return e}class Be extends h{constructor(t,n,r){super(),this.expected=t,this.found=n,this.path=r}}function We(e){return e}function pt(e){return zn(e)}function mt(e){return $t(e)}function ln(e){return Tn(e)}function wt(e){return t=>{if(e.hasLength(0))return new _(l([new Be("another type",mt(t),l([]))]));if(e.atLeastLength(1)){let n=e.head,r=e.tail,s=n(t);if(s.isOk()){let i=s[0];return new m(i)}else{if(s.isOk())throw o("case_no_match","gleam/dynamic",1026,"","No case clause matched",{values:[s]});return wt(r)(t)}}else throw o("case_no_match","gleam/dynamic",1019,"","No case clause matched",{values:[e]})}}function cn(e,t){let n=We(t),r=wt(l([pt,i=>ce(ln(i),be)])),s=(()=>{let i=r(n);if(i.isOk())return i[0];if(i.isOk())throw o("case_no_match","gleam/dynamic",598,"push_path","No case clause matched",{values:[i]});{let u=l(["<",mt(n),">"]),a=ht(u);return dt(a)}})();return e.withFields({path:l([s],e.path)})}function on(e,t){return sn(e,n=>rn(n,t))}function rt(e,t){return n=>{let r=new Be("field","nothing",l([]));return W(Rn(n,e),s=>{let u=Jt(s,l([r])),a=W(u,t);return on(a,c=>cn(c,e))})}}const st=new WeakMap,Ne=new DataView(new ArrayBuffer(8));let Ee=0;function Me(e){const t=st.get(e);if(t!==void 0)return t;const n=Ee++;return Ee===2147483647&&(Ee=0),st.set(e,n),n}function Ce(e,t){return e^t+2654435769+(e<<6)+(e>>2)|0}function Fe(e){let t=0;const n=e.length;for(let r=0;r<n;r++)t=Math.imul(31,t)+e.charCodeAt(r)|0;return t}function yt(e){Ne.setFloat64(0,e);const t=Ne.getInt32(0),n=Ne.getInt32(4);return Math.imul(73244475,t>>16^t)^n}function fn(e){return Fe(e.toString())}function hn(e){const t=Object.getPrototypeOf(e);if(t!==null&&typeof t.hashCode=="function")try{const r=e.hashCode(e);if(typeof r=="number")return r}catch{}if(e instanceof Promise||e instanceof WeakSet||e instanceof WeakMap)return Me(e);if(e instanceof Date)return yt(e.getTime());let n=0;if(e instanceof ArrayBuffer&&(e=new Uint8Array(e)),Array.isArray(e)||e instanceof Uint8Array)for(let r=0;r<e.length;r++)n=Math.imul(31,n)+k(e[r])|0;else if(e instanceof Set)e.forEach(r=>{n=n+k(r)|0});else if(e instanceof Map)e.forEach((r,s)=>{n=n+Ce(k(r),k(s))|0});else{const r=Object.keys(e);for(let s=0;s<r.length;s++){const i=r[s],u=e[i];n=n+Ce(k(u),Fe(i))|0}}return n}function k(e){if(e===null)return 1108378658;if(e===void 0)return 1108378659;if(e===!0)return 1108378657;if(e===!1)return 1108378656;switch(typeof e){case"number":return yt(e);case"string":return Fe(e);case"bigint":return fn(e);case"object":return hn(e);case"symbol":return Me(e);case"function":return Me(e);default:return 0}}const L=5,Ue=Math.pow(2,L),dn=Ue-1,pn=Ue/2,mn=Ue/4,b=0,v=1,A=2,H=3,Ve={type:A,bitmap:0,array:[]};function oe(e,t){return e>>>t&dn}function xe(e,t){return 1<<oe(e,t)}function wn(e){return e-=e>>1&1431655765,e=(e&858993459)+(e>>2&858993459),e=e+(e>>4)&252645135,e+=e>>8,e+=e>>16,e&127}function He(e,t){return wn(e&t-1)}function N(e,t,n){const r=e.length,s=new Array(r);for(let i=0;i<r;++i)s[i]=e[i];return s[t]=n,s}function yn(e,t,n){const r=e.length,s=new Array(r+1);let i=0,u=0;for(;i<t;)s[u++]=e[i++];for(s[u++]=n;i<r;)s[u++]=e[i++];return s}function ze(e,t){const n=e.length,r=new Array(n-1);let s=0,i=0;for(;s<t;)r[i++]=e[s++];for(++s;s<n;)r[i++]=e[s++];return r}function _t(e,t,n,r,s,i){const u=k(t);if(u===r)return{type:H,hash:u,array:[{type:b,k:t,v:n},{type:b,k:s,v:i}]};const a={val:!1};return fe(De(Ve,e,u,t,n,a),e,r,s,i,a)}function fe(e,t,n,r,s,i){switch(e.type){case v:return _n(e,t,n,r,s,i);case A:return De(e,t,n,r,s,i);case H:return gn(e,t,n,r,s,i)}}function _n(e,t,n,r,s,i){const u=oe(n,t),a=e.array[u];if(a===void 0)return i.val=!0,{type:v,size:e.size+1,array:N(e.array,u,{type:b,k:r,v:s})};if(a.type===b)return U(r,a.k)?s===a.v?e:{type:v,size:e.size,array:N(e.array,u,{type:b,k:r,v:s})}:(i.val=!0,{type:v,size:e.size,array:N(e.array,u,_t(t+L,a.k,a.v,n,r,s))});const c=fe(a,t+L,n,r,s,i);return c===a?e:{type:v,size:e.size,array:N(e.array,u,c)}}function De(e,t,n,r,s,i){const u=xe(n,t),a=He(e.bitmap,u);if(e.bitmap&u){const c=e.array[a];if(c.type!==b){const M=fe(c,t+L,n,r,s,i);return M===c?e:{type:A,bitmap:e.bitmap,array:N(e.array,a,M)}}const d=c.k;return U(r,d)?s===c.v?e:{type:A,bitmap:e.bitmap,array:N(e.array,a,{type:b,k:r,v:s})}:(i.val=!0,{type:A,bitmap:e.bitmap,array:N(e.array,a,_t(t+L,d,c.v,n,r,s))})}else{const c=e.array.length;if(c>=pn){const d=new Array(32),M=oe(n,t);d[M]=De(Ve,t+L,n,r,s,i);let ee=0,C=e.bitmap;for(let Oe=0;Oe<32;Oe++){if(C&1){const qt=e.array[ee++];d[Oe]=qt}C=C>>>1}return{type:v,size:c+1,array:d}}else{const d=yn(e.array,a,{type:b,k:r,v:s});return i.val=!0,{type:A,bitmap:e.bitmap|u,array:d}}}}function gn(e,t,n,r,s,i){if(n===e.hash){const u=Pe(e,r);if(u!==-1)return e.array[u].v===s?e:{type:H,hash:n,array:N(e.array,u,{type:b,k:r,v:s})};const a=e.array.length;return i.val=!0,{type:H,hash:n,array:N(e.array,a,{type:b,k:r,v:s})}}return fe({type:A,bitmap:xe(e.hash,t),array:[e]},t,n,r,s,i)}function Pe(e,t){const n=e.array.length;for(let r=0;r<n;r++)if(U(t,e.array[r].k))return r;return-1}function _e(e,t,n,r){switch(e.type){case v:return bn(e,t,n,r);case A:return xn(e,t,n,r);case H:return $n(e,r)}}function bn(e,t,n,r){const s=oe(n,t),i=e.array[s];if(i!==void 0){if(i.type!==b)return _e(i,t+L,n,r);if(U(r,i.k))return i}}function xn(e,t,n,r){const s=xe(n,t);if(!(e.bitmap&s))return;const i=He(e.bitmap,s),u=e.array[i];if(u.type!==b)return _e(u,t+L,n,r);if(U(r,u.k))return u}function $n(e,t){const n=Pe(e,t);if(!(n<0))return e.array[n]}function Ye(e,t,n,r){switch(e.type){case v:return An(e,t,n,r);case A:return On(e,t,n,r);case H:return kn(e,r)}}function An(e,t,n,r){const s=oe(n,t),i=e.array[s];if(i===void 0)return e;let u;if(i.type===b){if(!U(i.k,r))return e}else if(u=Ye(i,t+L,n,r),u===i)return e;if(u===void 0){if(e.size<=mn){const a=e.array,c=new Array(e.size-1);let d=0,M=0,ee=0;for(;d<s;){const C=a[d];C!==void 0&&(c[M]=C,ee|=1<<d,++M),++d}for(++d;d<a.length;){const C=a[d];C!==void 0&&(c[M]=C,ee|=1<<d,++M),++d}return{type:A,bitmap:ee,array:c}}return{type:v,size:e.size-1,array:N(e.array,s,u)}}return{type:v,size:e.size,array:N(e.array,s,u)}}function On(e,t,n,r){const s=xe(n,t);if(!(e.bitmap&s))return e;const i=He(e.bitmap,s),u=e.array[i];if(u.type!==b){const a=Ye(u,t+L,n,r);return a===u?e:a!==void 0?{type:A,bitmap:e.bitmap,array:N(e.array,i,a)}:e.bitmap===s?void 0:{type:A,bitmap:e.bitmap^s,array:ze(e.array,i)}}return U(r,u.k)?e.bitmap===s?void 0:{type:A,bitmap:e.bitmap^s,array:ze(e.array,i)}:e}function kn(e,t){const n=Pe(e,t);if(n<0)return e;if(e.array.length!==1)return{type:H,hash:e.hash,array:ze(e.array,n)}}function gt(e,t){if(e===void 0)return;const n=e.array,r=n.length;for(let s=0;s<r;s++){const i=n[s];if(i!==void 0){if(i.type===b){t(i.v,i.k);continue}gt(i,t)}}}class E{static fromObject(t){const n=Object.keys(t);let r=E.new();for(let s=0;s<n.length;s++){const i=n[s];r=r.set(i,t[i])}return r}static fromMap(t){let n=E.new();return t.forEach((r,s)=>{n=n.set(s,r)}),n}static new(){return new E(void 0,0)}constructor(t,n){this.root=t,this.size=n}get(t,n){if(this.root===void 0)return n;const r=_e(this.root,0,k(t),t);return r===void 0?n:r.v}set(t,n){const r={val:!1},s=this.root===void 0?Ve:this.root,i=fe(s,0,k(t),t,n,r);return i===this.root?this:new E(i,r.val?this.size+1:this.size)}delete(t){if(this.root===void 0)return this;const n=Ye(this.root,0,k(t),t);return n===this.root?this:n===void 0?E.new():new E(n,this.size-1)}has(t){return this.root===void 0?!1:_e(this.root,0,k(t),t)!==void 0}entries(){if(this.root===void 0)return[];const t=[];return this.forEach((n,r)=>t.push([r,n])),t}forEach(t){gt(this.root,t)}hashCode(){let t=0;return this.forEach((n,r)=>{t=t+Ce(k(n),k(r))|0}),t}equals(t){if(!(t instanceof E)||this.size!==t.size)return!1;let n=!0;return this.forEach((r,s)=>{n=n&&U(t.get(s,!r),r)}),n}}const bt=void 0,it={};function Nn(e){return/^[-+]?(\d+)$/.test(e)?new m(parseInt(e)):new _(bt)}function En(e){return e.toString()}function vn(e){const t=Ln(e);return t?F.fromArray(Array.from(t).map(n=>n.segment)):F.fromArray(e.match(/./gsu))}function Ln(e){if(Intl&&Intl.Segmenter)return new Intl.Segmenter().segment(e)[Symbol.iterator]()}function In(e){let t="";for(const n of e)t=t+n;return t}function Ge(e,t){return e.indexOf(t)>=0}function Sn(){return E.new()}function xt(e,t){const n=e.get(t,it);return n===it?new _(bt):new m(n)}function Mn(e,t,n){return n.set(e,t)}function $t(e){if(typeof e=="string")return"String";if(e instanceof le)return"Result";if(e instanceof F)return"List";if(e instanceof ye)return"BitArray";if(e instanceof E)return"Map";if(Number.isInteger(e))return"Int";if(Array.isArray(e))return`Tuple of ${e.length} elements`;if(typeof e=="number")return"Float";if(e===null)return"Null";if(e===void 0)return"Nil";{const t=typeof e;return t.charAt(0).toUpperCase()+t.slice(1)}}function Ke(e,t){return Cn(e,$t(t))}function Cn(e,t){return new _(F.fromArray([new Be(e,t,F.fromArray([]))]))}function zn(e){return typeof e=="string"?new m(e):Ke("String",e)}function Tn(e){return Number.isInteger(e)?new m(e):Ke("Int",e)}function Rn(e,t){const n=()=>Ke("Map",e);if(e instanceof E||e instanceof WeakMap||e instanceof Map){const r=xt(e,t);return new m(r.isOk()?new qe(r[0]):new nt)}else return Object.getPrototypeOf(e)==Object.prototype?ut(e,t,()=>new m(new nt)):ut(e,t,n)}function ut(e,t,n){try{return t in e?new m(new qe(e[t])):n()}catch{return n()}}function At(){return Sn()}function Ot(e,t){return xt(e,t)}function kt(e,t,n){return Mn(t,n,e)}function jn(e,t){return n=>t(e(n))}class qn extends h{constructor(t){super(),this.all=t}}function at(){return new qn(l([]))}function z(e,t,n,r){if(t!=null&&t.tag&&(e==null?void 0:e.nodeType)===1){const s=t.tag.toUpperCase(),i=t.namespace||"http://www.w3.org/1999/xhtml";return e.nodeName===s&&e.namespaceURI==i?Bn(e,t,n,r):lt(e,t,n,r)}return t!=null&&t.tag?lt(e,t,n,r):typeof(t==null?void 0:t.content)=="string"?(e==null?void 0:e.nodeType)===3?Fn(e,t):Wn(e,t):document.createComment(["[internal lustre error] I couldn't work out how to render this element. This","function should only be called internally by lustre's runtime: if you think","this is an error, please open an issue at","https://github.com/hayleigh-dot-dev/gleam-lustre/issues/new"].join(" "))}function lt(e,t,n,r=null){const s=t.namespace?document.createElementNS(t.namespace,t.tag):document.createElement(t.tag);s.$lustre={__registered_events:new Set};let i="";for(const u of t.attrs)u[0]==="class"?re(s,u[0],`${s.className} ${u[1]}`):u[0]==="style"?re(s,u[0],`${s.style.cssText} ${u[1]}`):u[0]==="dangerous-unescaped-html"?i+=u[1]:u[0]!==""&&re(s,u[0],u[1],n);if(customElements.get(t.tag))s._slot=t.children;else if(t.tag==="slot"){let u=new ge,a=r;for(;a;)if(a._slot){u=a._slot;break}else a=a.parentNode;for(const c of u)s.appendChild(z(null,c,n,s))}else if(i)s.innerHTML=i;else for(const u of t.children)s.appendChild(z(null,u,n,s));return e&&e.replaceWith(s),s}function Bn(e,t,n,r){const s=e.attributes,i=new Map;e.$lustre??(e.$lustre={__registered_events:new Set});for(const u of t.attrs)u[0]==="class"&&i.has("class")?i.set(u[0],`${i.get("class")} ${u[1]}`):u[0]==="style"&&i.has("style")?i.set(u[0],`${i.get("style")} ${u[1]}`):u[0]==="dangerous-unescaped-html"&&i.has("dangerous-unescaped-html")?i.set(u[0],`${i.get("dangerous-unescaped-html")} ${u[1]}`):u[0]!==""&&i.set(u[0],u[1]);for(const{name:u,value:a}of s)if(!i.has(u))e.removeAttribute(u);else{const c=i.get(u);c!==a&&(re(e,u,c,n),i.delete(u))}for(const u of e.$lustre.__registered_events)if(!i.has(u)){const a=u.slice(2).toLowerCase();e.removeEventListener(a,e.$lustre[`${u}Handler`]),e.$lustre.__registered_events.delete(u),delete e.$lustre[u],delete e.$lustre[`${u}Handler`]}for(const[u,a]of i)re(e,u,a,n);if(customElements.get(t.tag))e._slot=t.children;else if(t.tag==="slot"){let u=e.firstChild,a=new ge,c=r;for(;c;)if(c._slot){a=c._slot;break}else c=c.parentNode;for(;u;)Array.isArray(a)&&a.length?z(u,a.shift(),n,e):a.head&&(z(u,a.head,n,e),a=a.tail),u=u.nextSibling;for(const d of a)e.appendChild(z(null,d,n,e))}else if(i.has("dangerous-unescaped-html"))e.innerHTML=i.get("dangerous-unescaped-html");else{let u=e.firstChild,a=t.children;for(;u;)if(Array.isArray(a)&&a.length){const c=u.nextSibling;z(u,a.shift(),n,e),u=c}else if(a.head){const c=u.nextSibling;z(u,a.head,n,e),a=a.tail,u=c}else{const c=u.nextSibling;u.remove(),u=c}for(const c of a)e.appendChild(z(null,c,n,e))}return e}function re(e,t,n,r){switch(typeof n){case"string":e.getAttribute(t)!==n&&e.setAttribute(t,n),n===""&&e.removeAttribute(t),t==="value"&&e.value!==n&&(e.value=n);break;case(t.startsWith("on")&&"function"):{if(e.$lustre[t]===n)break;const s=t.slice(2).toLowerCase(),i=u=>ce(n(u),r);e.$lustre[`${t}Handler`]&&e.removeEventListener(s,e.$lustre[`${t}Handler`]),e.addEventListener(s,i),e.$lustre[t]=n,e.$lustre[`${t}Handler`]=i,e.$lustre.__registered_events.add(t);break}default:e[t]=n}}function Wn(e,t){const n=document.createTextNode(t.content);return e&&e.replaceWith(n),n}function Fn(e,t){const n=e.nodeValue,r=t.content;return r?(n!==r&&(e.nodeValue=r),e):(e==null||e.remove(),null)}var $,T,R,j,B,ie,X,J,ue,Te,ae,Re;class Un{constructor(t,n,r){O(this,ue);O(this,ae);O(this,$,null);O(this,T,null);O(this,R,[]);O(this,j,[]);O(this,B,!1);O(this,ie,null);O(this,X,null);O(this,J,null);w(this,ie,t),w(this,X,n),w(this,J,r)}start(t,n){if(!Dn())return new _(new rr);if(p(this,$))return new _(new er);if(w(this,$,t instanceof HTMLElement?t:document.querySelector(t)),!p(this,$))return new _(new nr);const[r,s]=p(this,ie).call(this,n);return w(this,T,r),w(this,j,s.all.toArray()),w(this,B,!0),window.requestAnimationFrame(()=>te(this,ue,Te).call(this)),new m(i=>this.dispatch(i))}dispatch(t){p(this,R).push(t),te(this,ue,Te).call(this)}emit(t,n=null){p(this,$).dispatchEvent(new CustomEvent(t,{bubbles:!0,detail:n,composed:!0}))}destroy(){if(!p(this,$))return new _(new tr);p(this,$).remove(),w(this,$,null),w(this,T,null),w(this,R,[]),w(this,j,[]),w(this,B,!1),w(this,X,()=>{}),w(this,J,()=>{})}}$=new WeakMap,T=new WeakMap,R=new WeakMap,j=new WeakMap,B=new WeakMap,ie=new WeakMap,X=new WeakMap,J=new WeakMap,ue=new WeakSet,Te=function(){if(te(this,ae,Re).call(this),p(this,B)){const t=p(this,J).call(this,p(this,T));w(this,$,z(p(this,$),t,n=>this.dispatch(n))),w(this,B,!1)}},ae=new WeakSet,Re=function(t=0){if(p(this,$)){if(p(this,R).length)for(;p(this,R).length;){const[n,r]=p(this,X).call(this,p(this,T),p(this,R).shift());p(this,B)||w(this,B,p(this,T)!==n),w(this,T,n),w(this,j,p(this,j).concat(r.all.toArray()))}for(;p(this,j).length;)p(this,j).shift()(n=>this.dispatch(n),(n,r)=>this.emit(n,r));p(this,R).length&&(t>=5?console.warn(tooManyUpdates):te(this,ae,Re).call(this,++t))}};const Vn=(e,t,n)=>new Un(e,t,n),Hn=(e,t,n)=>e.start(t,n),Dn=()=>window&&window.document;function Nt(e){let n=ht(e);return dt(n)}class Et extends h{constructor(t,n,r){super(),this[0]=t,this[1]=n,this.as_property=r}}class Pn extends h{constructor(t,n){super(),this[0]=t,this[1]=n}}function Q(e,t){return new Et(e,We(t),!1)}function vt(e,t){return new Et(e,We(t),!0)}function Yn(e,t){return new Pn("on"+e,jn(t,n=>ft(n,void 0)))}function Gn(e){return Q("style",ot(e,"",(t,n)=>{let r=n[0],s=n[1];return t+r+":"+s+";"}))}function ct(e){return Q("id",e)}function Kn(e){return Q("placeholder",e)}function D(e){return Q("href",e)}function Xn(e){return Q("src",e)}function Jn(e){return vt("height",be(e))}function Zn(e){return vt("width",be(e))}class Qn extends h{constructor(t){super(),this.content=t}}class g extends h{constructor(t,n,r,s,i,u){super(),this.namespace=t,this.tag=n,this.attrs=r,this.children=s,this.self_closing=i,this.void=u}}function q(e,t,n){return e==="area"?new g("",e,t,l([]),!1,!0):e==="base"?new g("",e,t,l([]),!1,!0):e==="br"?new g("",e,t,l([]),!1,!0):e==="col"?new g("",e,t,l([]),!1,!0):e==="embed"?new g("",e,t,l([]),!1,!0):e==="hr"?new g("",e,t,l([]),!1,!0):e==="img"?new g("",e,t,l([]),!1,!0):e==="input"?new g("",e,t,l([]),!1,!0):e==="link"?new g("",e,t,l([]),!1,!0):e==="meta"?new g("",e,t,l([]),!1,!0):e==="param"?new g("",e,t,l([]),!1,!0):e==="source"?new g("",e,t,l([]),!1,!0):e==="track"?new g("",e,t,l([]),!1,!0):e==="wbr"?new g("",e,t,l([]),!1,!0):new g("",e,t,n,!1,!1)}function f(e){return new Qn(e)}class er extends h{}class tr extends h{}class nr extends h{}class rr extends h{}function sr(e,t,n){return Vn(i=>[e(i),at()],(i,u)=>[t(i,u),at()],n)}function ve(e,t){return q("h3",e,t)}function Le(e,t){return q("div",e,t)}function Ie(e,t){return q("p",e,t)}function P(e,t){return q("a",e,t)}function ir(e){return q("br",e,l([]))}function Se(e,t){return q("code",e,t)}function ur(e,t){return q("strong",e,t)}function ar(e){return q("iframe",e,l([]))}function lr(e){return q("textarea",e,l([]))}function cr(e,t){return Yn(e,t)}function or(e){let t=e;return rt("target",rt("value",pt))(t)}function fr(e){return cr("input",t=>{let n=or(t);return ce(n,e)})}class je extends h{constructor(t){super(),this.error=t}}class pe extends h{constructor(t,n){super(),this.row=t,this.col=n}}class S extends h{constructor(t){super(),this.parse=t}}function x(e,t,n){if(e instanceof S){let r=e.parse;return r(t,n)}else throw o("case_no_match","party",37,"run","No case clause matched",{values:[e]})}function $e(e){return new S((t,n)=>{if(!(n instanceof pe))throw o("assignment_no_match","party",58,"","Assignment pattern did not match",{value:n});let r=n.row,s=n.col;if(t.atLeastLength(1)){let i=t.head,u=t.tail,a=e(i);if(a)return i===`
`?new m([i,u,new pe(r+1,0)]):new m([i,u,new pe(r,s+1)]);if(a)throw o("case_no_match","party",61,"","No case clause matched",{values:[a]});return new _(new je(i))}else{if(t.hasLength(0))return new _(new je("EOF"));throw o("case_no_match","party",59,"","No case clause matched",{values:[t]})}})}function I(e){return $e(t=>e===t)}function Xe(e,t){return new S((n,r)=>an(x(e,n,r),x(t,n,r)))}function Je(e){return new S((t,n)=>{if(e.hasLength(0))return new _(new je("choiceless choice"));if(e.hasLength(1)){let r=e.head;return x(r,t,n)}else if(e.atLeastLength(1)){let r=e.head,s=e.tail,i=x(r,t,n);if(i.isOk()){let u=i[0][0],a=i[0][1],c=i[0][2];return new m([u,a,c])}else{if(i.isOk())throw o("case_no_match","party",111,"","No case clause matched",{values:[i]});return x(Je(s),t,n)}}else throw o("case_no_match","party",107,"","No case clause matched",{values:[e]})})}function he(e){return new S((t,n)=>{let r=x(e,t,n);if(r.isOk())if(r.isOk()){let s=r[0][0],i=r[0][1],u=r[0][2];return ce(x(he(e),i,u),a=>[l([s],a[0]),a[1],a[2]])}else throw o("case_no_match","party",140,"","No case clause matched",{values:[r]});else return new m([l([]),t,n])})}function hr(e){return new S((t,n)=>{let r=x(e,t,n);if(r.isOk())if(r.isOk()){let s=r[0][0],i=r[0][1],u=r[0][2];return ce(x(he(e),i,u),a=>[l([s],a[0]),a[1],a[2]])}else throw o("case_no_match","party",155,"","No case clause matched",{values:[r]});else{let s=r[0];return new _(s)}})}function ne(e,t){return new S((n,r)=>{let s=x(e,n,r);if(s.isOk()){let i=s[0][0],u=s[0][1],a=s[0][2];return new m([t(i),u,a])}else{if(s.isOk())throw o("case_no_match","party",175,"","No case clause matched",{values:[s]});{let i=s[0];return new _(i)}}})}function Ze(e){return new S((t,n)=>x(e(),t,n))}function y(e,t){return new S((n,r)=>{let s=x(e,n,r);if(s.isOk()){let i=s[0][0],u=s[0][1],a=s[0][2];return x(t(i),u,a)}else{if(s.isOk())throw o("case_no_match","party",287,"","No case clause matched",{values:[s]});{let i=s[0];return new _(i)}}})}function Z(e){return new S((t,n)=>new m([e,t,n]))}function dr(e,t){let n=x(e,vn(t),new pe(1,1));if(n.isOk()){let r=n[0][0];return new m(r)}else{if(n.isOk())throw o("case_no_match","party",44,"go","No case clause matched",{values:[n]});{let r=n[0];return new _(r)}}}function pr(){return $e(e=>Ge("abcdefghijklmnopqrstuvwxyz",e))}function mr(){return $e(e=>Ge("ABCDEFGHIJKLMNOPQRSTUVWXYZ",e))}function Lt(){return Xe(pr(),mr())}function It(){return $e(e=>Ge("0123456789",e))}function wr(){return Xe(It(),Lt())}class St extends h{constructor(t){super(),this[0]=t}}class Mt extends h{constructor(t){super(),this[0]=t}}class Ct extends h{constructor(t,n){super(),this[0]=t,this[1]=n}}class zt extends h{constructor(t,n){super(),this[0]=t,this[1]=n}}class Tt extends h{constructor(t){super(),this.int=t}}class de extends h{constructor(t,n){super(),this.val=t,this.gen=n}}class Qe extends h{constructor(t){super(),this[0]=t}}class et extends h{constructor(t,n){super(),this[0]=t,this[1]=n}}class G extends h{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}}class se extends h{constructor(t,n){super(),this[0]=t,this[1]=n}}function yr(){let e=hr(It()),t=ne(e,Nt),n=ne(t,Zt),r=ne(n,s=>un(s,()=>{throw o("todo","tinylang",19,"","parsed int isn't an int",{})}));return ne(r,s=>new St(s))}function Rt(){return y(Lt(),e=>y(he(Xe(wr(),I("_"))),t=>Z(e+Nt(t))))}function _r(){let e=Rt();return ne(e,t=>new Mt(t))}function K(){return y(he(Je(l([I(" "),I("	"),I(`
`)]))),e=>Z(void 0))}function gr(e,t){return t(new Tt(e.int+1),e.int)}function me(e,t,n){if(t instanceof St){let r=t[0];return new m(new de(new Qe(r),e))}else if(t instanceof Mt){let r=t[0],s=Ot(n,r);if(s.isOk()){let i=s[0];return new m(new de(new et(i,r),e))}else{if(!s.isOk()&&!s[0])return new _("Wait! "+r+" isn't defined anywhere!");throw o("case_no_match","tinylang",111,"translate_helper","No case clause matched",{values:[s]})}}else if(t instanceof Ct){let r=t[0],s=t[1];return gr(e,(i,u)=>W(me(i,s,kt(n,r,u)),a=>{let c=new G(u,r,a.val),d=new de(c,i);return new m(d)}))}else if(t instanceof zt){let r=t[0],s=t[1];return W(me(e,r,n),i=>W(me(i.gen,s,n),u=>{let a=new se(i.val,u.val),c=new de(a,u.gen);return new m(c)}))}else throw o("case_no_match","tinylang",108,"translate_helper","No case clause matched",{values:[t]})}function br(e,t){return W(me(e,t,At()),n=>new m(n.val))}function we(e,t){for(;;){let n=e,r=t;if(n instanceof Qe)return n;if(n instanceof et){let s=n[0],i=Ot(r,s);if(i.isOk())return i[0];if(!i.isOk()&&!i[0])return n;throw o("case_no_match","tinylang",140,"eval_helper","No case clause matched",{values:[i]})}else if(n instanceof se){let s=n[0],i=n[1],u=we(s,r),a=we(i,r);if(u instanceof G){let c=u[0];e=u[2],t=kt(r,c,a)}else return new se(u,a)}else if(n instanceof G){let s=n[0],i=n[1],u=n[2];return new G(s,i,we(u,r))}else throw o("case_no_match","tinylang",137,"eval_helper","No case clause matched",{values:[n]})}}function xr(e){return we(e,At())}function Y(e){if(e instanceof Qe){let t=e[0];return be(t)}else{if(e instanceof et)return e[1];if(e instanceof G){let t=e[1],n=e[2];return"\\"+t+". "+Y(n)}else if(e instanceof se&&e[0]instanceof G){let t=e[0],n=e[1];return"("+Y(t)+")("+Y(n)+")"}else if(e instanceof se){let t=e[0],n=e[1];return Y(t)+"("+Y(n)+")"}else throw o("case_no_match","tinylang",160,"pretty","No case clause matched",{values:[e]})}}function $r(e){if(e.isOk())return e[0];if(e.isOk())throw o("case_no_match","tinylang",171,"squash_res","No case clause matched",{values:[e]});return e[0]}function Ae(){return y(K(),e=>y(Je(l([yr(),_r(),Ar(),Or()])),t=>y(K(),n=>y(he(y(I("("),r=>y(Ze(Ae),s=>y(I(")"),i=>y(K(),u=>Z(s)))))),r=>{let s=ot(r,t,(i,u)=>new zt(i,u));return Z(s)}))))}function Ar(){return y(I("\\"),e=>y(K(),t=>y(Rt(),n=>y(K(),r=>y(I("."),s=>y(K(),i=>y(Ze(Ae),u=>Z(new Ct(n,u)))))))))}function Or(){return y(I("("),e=>y(Ze(Ae),t=>y(I(")"),n=>Z(t))))}function kr(e){let t=W(ft(dr(Ae(),e),"there's a mistake in the notation somewhere; I couldn't understand it!"),n=>W(br(new Tt(0),n),r=>{let s=xr(r);return new m(Y(s))}));return $r(t)}class jt extends h{constructor(t){super(),this[0]=t}}function Nr(e){return""}function Er(e,t){if(t instanceof jt)return t[0];throw o("case_no_match","ryanbrewerdev",31,"update","No case clause matched",{values:[t]})}function vr(e){return Le(l([]),l([ve(l([]),l([f("Who I Am")])),Ie(l([]),l([f("I'm Ryan Brewer, the software developer behind "),P(l([D("https://github.com/RyanBrewer317/SVM")]),l([f("SVM")])),f(", an abstract machine for safe, portable computation that functional languages can compile to."),f("With SVM, I'm hoping to broaden accessibility to safe computation, both informationally and financially."),f("Consider supporting my work!")])),ar(l([Xn("https://github.com/sponsors/RyanBrewer317/button"),Q("title","Sponsor RyanBrewer317"),Jn(32),Zn(114),Gn(l([["border","0"],["border-radius","6px;"]]))])),ve(l([]),l([f("My Website")])),Ie(l([]),l([f("This is my website. It's hosted by Firebase and written mostly in "),P(l([D("https://gleam.run")]),l([f("Gleam")])),f(", and the code is up on my "),P(l([D("https://github.com/RyanBrewer317/ryanbrewer-dev")]),l([f("github")])),f(". The only framework used is "),P(l([D("https://lustre.build/")]),l([f("Lustre")])),f("; scripting, markup, styles, and layout were all done by hand.")])),ve(l([]),l([f("Lambda Calculus in Gleam")])),Ie(l([]),l([f(`
I study programming language design, and I'm particularly fond of functional programming.
That's why I made this website in `),P(l([D("https://gleam.run")]),l([f("Gleam")])),f(`,
a statically-typed functional language
that can run anywhere JavaScript can, as well as on Erlang's BEAM VM. 
I've used Gleam to write a lambda calculus evaluator that you can play with below. 
Lambda abstractions are written like 
`),Se(l([]),l([f("\\var. body")])),f(", and are called like "),Se(l([]),l([f("fun(arg)")])),f(". There are also positive integers like 7. Try writing "),Se(l([]),l([f("(\\x.x)(2)")])),f(", which evaluates to 2. The code for this can be found "),P(l([D("https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/tinylang.gleam")]),l([f("here")])),f(". (It's currently broken on firefox, but definitely works on chrome.)")])),lr(l([ct("code"),Kn("Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)(3)"),fr(t=>new jt(t))])),ir(l([])),(()=>{if(e==="")return f("");{let n=kr(e);return(r=>Le(l([]),l([ur(l([]),l([f("output ")])),f(" (variables may be renamed): "),Le(l([ct("code-output")]),l([f(r)]))])))(n)}})()]))}function Lr(){let e=sr(Nr,Er,vr),t=Hn(e,"[data-lustre-app]",void 0);if(!t.isOk())throw o("assignment_no_match","ryanbrewerdev",14,"main","Assignment pattern did not match",{value:t});return t[0]}document.addEventListener("DOMContentLoaded",()=>{Lr()});
