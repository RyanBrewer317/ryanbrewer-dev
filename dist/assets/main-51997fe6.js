var Ge=(e,t,n)=>{if(!t.has(e))throw TypeError("Cannot "+n)};var w=(e,t,n)=>(Ge(e,t,"read from private field"),n?n.call(e):t.get(e)),L=(e,t,n)=>{if(t.has(e))throw TypeError("Cannot add the same private member more than once");t instanceof WeakSet?t.add(e):t.set(e,n)},_=(e,t,n,r)=>(Ge(e,t,"write to private field"),r?r.call(e,n):t.set(e,n),n);var fe=(e,t,n)=>(Ge(e,t,"access private method"),n);import"./style-b7ef9c88.js";class f{withFields(t){let n=Object.keys(this).map(r=>r in t?t[r]:this[r]);return new this.constructor(...n)}}class P{static fromArray(t,n){let r=n||new je;for(let i=t.length-1;i>=0;--i)r=new jt(t[i],r);return r}[Symbol.iterator](){return new wn(this)}toArray(){return[...this]}atLeastLength(t){for(let n of this){if(t<=0)return!0;t--}return t<=0}hasLength(t){for(let n of this){if(t<=0)return!1;t--}return t===0}countLength(){let t=0;for(let n of this)t++;return t}}function be(e,t){return new jt(e,t)}function a(e,t){return P.fromArray(e,t)}var J;class wn{constructor(t){L(this,J,void 0);_(this,J,t)}next(){if(w(this,J)instanceof je)return{done:!0};{let{head:t,tail:n}=w(this,J);return _(this,J,n),{value:t,done:!1}}}}J=new WeakMap;class je extends P{}class jt extends P{constructor(t,n){super(),this.head=t,this.tail=n}}class Ce{constructor(t){if(!(t instanceof Uint8Array))throw"BitArray can only be constructed from a Uint8Array";this.buffer=t}get length(){return this.buffer.length}byteAt(t){return this.buffer[t]}floatAt(t){return mn(this.buffer.slice(t,t+8))}intFromSlice(t,n){return yn(this.buffer.slice(t,n))}binaryFromSlice(t,n){return new Ce(this.buffer.slice(t,n))}sliceAfter(t){return new Ce(this.buffer.slice(t))}}function yn(e){e=e.reverse();let t=0;for(let n=e.length-1;n>=0;n--)t=t*256+e[n];return t}function mn(e){return new Float64Array(e.reverse().buffer)[0]}class xe extends f{static isResult(t){return t instanceof xe}}class h extends xe{constructor(t){super(),this[0]=t}isOk(){return!0}}class m extends xe{constructor(t){super(),this[0]=t}isOk(){return!1}}function G(e,t){let n=[e,t];for(;n.length;){let r=n.pop(),i=n.pop();if(r===i)continue;if(!Et(r)||!Et(i)||!kn(r,i)||gn(r,i)||bn(r,i)||xn(r,i)||$n(r,i)||An(r,i)||In(r,i))return!1;const u=Object.getPrototypeOf(r);if(u!==null&&typeof u.equals=="function")try{if(r.equals(i))continue;return!1}catch{}let[l,c]=_n(r);for(let d of l(r))n.push(c(r,d),c(i,d))}return!0}function _n(e){if(e instanceof Map)return[t=>t.keys(),(t,n)=>t.get(n)];{let t=e instanceof globalThis.Error?["message"]:[];return[n=>[...t,...Object.keys(n)],(n,r)=>n[r]]}}function gn(e,t){return e instanceof Date&&(e>t||e<t)}function bn(e,t){return e.buffer instanceof ArrayBuffer&&e.BYTES_PER_ELEMENT&&!(e.byteLength===t.byteLength&&e.every((n,r)=>n===t[r]))}function xn(e,t){return Array.isArray(e)&&e.length!==t.length}function $n(e,t){return e instanceof Map&&e.size!==t.size}function An(e,t){return e instanceof Set&&(e.size!=t.size||[...e].some(n=>!t.has(n)))}function In(e,t){return e instanceof RegExp&&(e.source!==t.source||e.flags!==t.flags)}function Et(e){return typeof e=="object"&&e!==null}function kn(e,t){return typeof e!="object"&&typeof t!="object"&&(!e||!t)||[Promise,WeakSet,WeakMap,Function].some(r=>e instanceof r)?!1:e.constructor===t.constructor}function We(e,t,n,r,i,s){let u=new globalThis.Error(i);u.gleam_error=e,u.module=t,u.line=n,u.fn=r;for(let l in s)u[l]=s[l];return u}class st extends f{constructor(t){super(),this[0]=t}}class Lt extends f{}function On(e,t){if(e instanceof st){let n=e[0];return new h(n)}else return new m(t)}function Wt(e){return Zn(e)}function $e(e){return Qn(e)}function En(e,t){for(;;){let n=e,r=t;if(n.hasLength(0))return r;{let i=n.head;e=n.tail,t=be(i,r)}}}function Ln(e){return En(e,a([]))}function vn(e){return Ln(e)}function Sn(e,t,n){for(;;){let r=e,i=t,s=n;if(r.hasLength(0))return vn(s);{let u=r.head;e=r.tail,t=i,n=be(i(u),s)}}}function Cn(e,t){return Sn(e,t,a([]))}function ut(e,t,n){for(;;){let r=e,i=t,s=n;if(r.hasLength(0))return i;{let u=r.head;e=r.tail,t=s(i,u),n=s}}}function Ae(e,t){if(e.isOk()){let n=e[0];return new h(t(n))}else{let n=e[0];return new m(n)}}function Rn(e,t){if(e.isOk()){let n=e[0];return new h(n)}else{let n=e[0];return new m(t(n))}}function g(e,t){if(e.isOk()){let n=e[0];return t(n)}else{let n=e[0];return new m(n)}}function Bt(e,t){return e.isOk()?e[0]:t()}function Tn(e,t){return e.isOk()?e:t}function lt(e,t){if(e.isOk()){let n=e[0];return new h(n)}else return new m(t)}function qt(e){return nr(e)}function Vt(e){return e}class at extends f{constructor(t,n,r){super(),this.expected=t,this.found=n,this.path=r}}function ct(e){return e}function Ut(e){return ur(e)}function Ft(e){return Xt(e)}function Mn(e){return lr(e)}function Dt(e){return t=>{if(e.hasLength(0))return new m(a([new at("another type",Ft(t),a([]))]));{let n=e.head,r=e.tail,i=n(t);if(i.isOk()){let s=i[0];return new h(s)}else return Dt(r)(t)}}}function Nn(e,t){let n=ct(t),r=Dt(a([Ut,s=>Ae(Mn(s),$e)])),i=(()=>{let s=r(n);if(s.isOk())return s[0];{let u=a(["<",Ft(n),">"]),l=qt(u);return Vt(l)}})();return e.withFields({path:be(i,e.path)})}function zn(e,t){return Rn(e,n=>Cn(n,t))}function vt(e,t){return n=>{let r=new at("field","nothing",a([]));return g(ar(n,e),i=>{let u=On(i,a([r])),l=g(u,t);return zn(l,c=>Nn(c,e))})}}const St=new WeakMap,Ye=new DataView(new ArrayBuffer(8));let Ke=0;function et(e){const t=St.get(e);if(t!==void 0)return t;const n=Ke++;return Ke===2147483647&&(Ke=0),St.set(e,n),n}function tt(e,t){return e^t+2654435769+(e<<6)+(e>>2)|0}function ot(e){let t=0;const n=e.length;for(let r=0;r<n;r++)t=Math.imul(31,t)+e.charCodeAt(r)|0;return t}function Ht(e){Ye.setFloat64(0,e);const t=Ye.getInt32(0),n=Ye.getInt32(4);return Math.imul(73244475,t>>16^t)^n}function jn(e){return ot(e.toString())}function Wn(e){const t=Object.getPrototypeOf(e);if(t!==null&&typeof t.hashCode=="function")try{const r=e.hashCode(e);if(typeof r=="number")return r}catch{}if(e instanceof Promise||e instanceof WeakSet||e instanceof WeakMap)return et(e);if(e instanceof Date)return Ht(e.getTime());let n=0;if(e instanceof ArrayBuffer&&(e=new Uint8Array(e)),Array.isArray(e)||e instanceof Uint8Array)for(let r=0;r<e.length;r++)n=Math.imul(31,n)+v(e[r])|0;else if(e instanceof Set)e.forEach(r=>{n=n+v(r)|0});else if(e instanceof Map)e.forEach((r,i)=>{n=n+tt(v(r),v(i))|0});else{const r=Object.keys(e);for(let i=0;i<r.length;i++){const s=r[i],u=e[s];n=n+tt(v(u),ot(s))|0}}return n}function v(e){if(e===null)return 1108378658;if(e===void 0)return 1108378659;if(e===!0)return 1108378657;if(e===!1)return 1108378656;switch(typeof e){case"number":return Ht(e);case"string":return ot(e);case"bigint":return jn(e);case"object":return Wn(e);case"symbol":return et(e);case"function":return et(e);default:return 0}}const M=5,ft=Math.pow(2,M),Bn=ft-1,qn=ft/2,Vn=ft/4,$=0,R=1,k=2,Q=3,ht={type:k,bitmap:0,array:[]};function Ie(e,t){return e>>>t&Bn}function Be(e,t){return 1<<Ie(e,t)}function Un(e){return e-=e>>1&1431655765,e=(e&858993459)+(e>>2&858993459),e=e+(e>>4)&252645135,e+=e>>8,e+=e>>16,e&127}function dt(e,t){return Un(e&t-1)}function S(e,t,n){const r=e.length,i=new Array(r);for(let s=0;s<r;++s)i[s]=e[s];return i[t]=n,i}function Fn(e,t,n){const r=e.length,i=new Array(r+1);let s=0,u=0;for(;s<t;)i[u++]=e[s++];for(i[u++]=n;s<r;)i[u++]=e[s++];return i}function nt(e,t){const n=e.length,r=new Array(n-1);let i=0,s=0;for(;i<t;)r[s++]=e[i++];for(++i;i<n;)r[s++]=e[i++];return r}function Pt(e,t,n,r,i,s){const u=v(t);if(u===r)return{type:Q,hash:u,array:[{type:$,k:t,v:n},{type:$,k:i,v:s}]};const l={val:!1};return ke(pt(ht,e,u,t,n,l),e,r,i,s,l)}function ke(e,t,n,r,i,s){switch(e.type){case R:return Dn(e,t,n,r,i,s);case k:return pt(e,t,n,r,i,s);case Q:return Hn(e,t,n,r,i,s)}}function Dn(e,t,n,r,i,s){const u=Ie(n,t),l=e.array[u];if(l===void 0)return s.val=!0,{type:R,size:e.size+1,array:S(e.array,u,{type:$,k:r,v:i})};if(l.type===$)return G(r,l.k)?i===l.v?e:{type:R,size:e.size,array:S(e.array,u,{type:$,k:r,v:i})}:(s.val=!0,{type:R,size:e.size,array:S(e.array,u,Pt(t+M,l.k,l.v,n,r,i))});const c=ke(l,t+M,n,r,i,s);return c===l?e:{type:R,size:e.size,array:S(e.array,u,c)}}function pt(e,t,n,r,i,s){const u=Be(n,t),l=dt(e.bitmap,u);if(e.bitmap&u){const c=e.array[l];if(c.type!==$){const O=ke(c,t+M,n,r,i,s);return O===c?e:{type:k,bitmap:e.bitmap,array:S(e.array,l,O)}}const d=c.k;return G(r,d)?i===c.v?e:{type:k,bitmap:e.bitmap,array:S(e.array,l,{type:$,k:r,v:i})}:(s.val=!0,{type:k,bitmap:e.bitmap,array:S(e.array,l,Pt(t+M,d,c.v,n,r,i))})}else{const c=e.array.length;if(c>=qn){const d=new Array(32),O=Ie(n,t);d[O]=pt(ht,t+M,n,r,i,s);let F=0,E=e.bitmap;for(let oe=0;oe<32;oe++){if(E&1){const Pe=e.array[F++];d[oe]=Pe}E=E>>>1}return{type:R,size:c+1,array:d}}else{const d=Fn(e.array,l,{type:$,k:r,v:i});return s.val=!0,{type:k,bitmap:e.bitmap|u,array:d}}}}function Hn(e,t,n,r,i,s){if(n===e.hash){const u=wt(e,r);if(u!==-1)return e.array[u].v===i?e:{type:Q,hash:n,array:S(e.array,u,{type:$,k:r,v:i})};const l=e.array.length;return s.val=!0,{type:Q,hash:n,array:S(e.array,l,{type:$,k:r,v:i})}}return ke({type:k,bitmap:Be(e.hash,t),array:[e]},t,n,r,i,s)}function wt(e,t){const n=e.array.length;for(let r=0;r<n;r++)if(G(t,e.array[r].k))return r;return-1}function Re(e,t,n,r){switch(e.type){case R:return Pn(e,t,n,r);case k:return Gn(e,t,n,r);case Q:return Yn(e,r)}}function Pn(e,t,n,r){const i=Ie(n,t),s=e.array[i];if(s!==void 0){if(s.type!==$)return Re(s,t+M,n,r);if(G(r,s.k))return s}}function Gn(e,t,n,r){const i=Be(n,t);if(!(e.bitmap&i))return;const s=dt(e.bitmap,i),u=e.array[s];if(u.type!==$)return Re(u,t+M,n,r);if(G(r,u.k))return u}function Yn(e,t){const n=wt(e,t);if(!(n<0))return e.array[n]}function yt(e,t,n,r){switch(e.type){case R:return Kn(e,t,n,r);case k:return Xn(e,t,n,r);case Q:return Jn(e,r)}}function Kn(e,t,n,r){const i=Ie(n,t),s=e.array[i];if(s===void 0)return e;let u;if(s.type===$){if(!G(s.k,r))return e}else if(u=yt(s,t+M,n,r),u===s)return e;if(u===void 0){if(e.size<=Vn){const l=e.array,c=new Array(e.size-1);let d=0,O=0,F=0;for(;d<i;){const E=l[d];E!==void 0&&(c[O]=E,F|=1<<d,++O),++d}for(++d;d<l.length;){const E=l[d];E!==void 0&&(c[O]=E,F|=1<<d,++O),++d}return{type:k,bitmap:F,array:c}}return{type:R,size:e.size-1,array:S(e.array,i,u)}}return{type:R,size:e.size,array:S(e.array,i,u)}}function Xn(e,t,n,r){const i=Be(n,t);if(!(e.bitmap&i))return e;const s=dt(e.bitmap,i),u=e.array[s];if(u.type!==$){const l=yt(u,t+M,n,r);return l===u?e:l!==void 0?{type:k,bitmap:e.bitmap,array:S(e.array,s,l)}:e.bitmap===i?void 0:{type:k,bitmap:e.bitmap^i,array:nt(e.array,s)}}return G(r,u.k)?e.bitmap===i?void 0:{type:k,bitmap:e.bitmap^i,array:nt(e.array,s)}:e}function Jn(e,t){const n=wt(e,t);if(n<0)return e;if(e.array.length!==1)return{type:Q,hash:e.hash,array:nt(e.array,n)}}function Gt(e,t){if(e===void 0)return;const n=e.array,r=n.length;for(let i=0;i<r;i++){const s=n[i];if(s!==void 0){if(s.type===$){t(s.v,s.k);continue}Gt(s,t)}}}class C{static fromObject(t){const n=Object.keys(t);let r=C.new();for(let i=0;i<n.length;i++){const s=n[i];r=r.set(s,t[s])}return r}static fromMap(t){let n=C.new();return t.forEach((r,i)=>{n=n.set(i,r)}),n}static new(){return new C(void 0,0)}constructor(t,n){this.root=t,this.size=n}get(t,n){if(this.root===void 0)return n;const r=Re(this.root,0,v(t),t);return r===void 0?n:r.v}set(t,n){const r={val:!1},i=this.root===void 0?ht:this.root,s=ke(i,0,v(t),t,n,r);return s===this.root?this:new C(s,r.val?this.size+1:this.size)}delete(t){if(this.root===void 0)return this;const n=yt(this.root,0,v(t),t);return n===this.root?this:n===void 0?C.new():new C(n,this.size-1)}has(t){return this.root===void 0?!1:Re(this.root,0,v(t),t)!==void 0}entries(){if(this.root===void 0)return[];const t=[];return this.forEach((n,r)=>t.push([r,n])),t}forEach(t){Gt(this.root,t)}hashCode(){let t=0;return this.forEach((n,r)=>{t=t+tt(v(n),v(r))|0}),t}equals(t){if(!(t instanceof C)||this.size!==t.size)return!1;let n=!0;return this.forEach((r,i)=>{n=n&&G(t.get(i,!r),r)}),n}}const mt=void 0,Ct={};function Zn(e){return/^[-+]?(\d+)$/.test(e)?new h(parseInt(e)):new m(mt)}function Qn(e){return e.toString()}function er(e){const t=Yt(e);return t?P.fromArray(Array.from(t).map(n=>n.segment)):P.fromArray(e.match(/./gsu))}function Yt(e){if(Intl&&Intl.Segmenter)return new Intl.Segmenter().segment(e)[Symbol.iterator]()}function tr(e){var r,i;let t;const n=Yt(e);return n?t=(r=n.next().value)==null?void 0:r.segment:t=(i=e.match(/./su))==null?void 0:i[0],t?new h([t,e.slice(t.length)]):new m(mt)}function nr(e){let t="";for(const n of e)t=t+n;return t}function _t(e,t){return e.indexOf(t)>=0}function rr(){return C.new()}function Kt(e,t){const n=e.get(t,Ct);return n===Ct?new m(mt):new h(n)}function ir(e,t,n){return n.set(e,t)}function Xt(e){if(typeof e=="string")return"String";if(e instanceof xe)return"Result";if(e instanceof P)return"List";if(e instanceof Ce)return"BitArray";if(e instanceof C)return"Dict";if(Number.isInteger(e))return"Int";if(Array.isArray(e))return`Tuple of ${e.length} elements`;if(typeof e=="number")return"Float";if(e===null)return"Null";if(e===void 0)return"Nil";{const t=typeof e;return t.charAt(0).toUpperCase()+t.slice(1)}}function gt(e,t){return sr(e,Xt(t))}function sr(e,t){return new m(P.fromArray([new at(e,t,P.fromArray([]))]))}function ur(e){return typeof e=="string"?new h(e):gt("String",e)}function lr(e){return Number.isInteger(e)?new h(e):gt("Int",e)}function ar(e,t){const n=()=>gt("Dict",e);if(e instanceof C||e instanceof WeakMap||e instanceof Map){const r=Kt(e,t);return new h(r.isOk()?new st(r[0]):new Lt)}else return Object.getPrototypeOf(e)==Object.prototype?Rt(e,t,()=>new h(new Lt)):Rt(e,t,n)}function Rt(e,t,n){try{return t in e?new h(new st(e[t])):n()}catch{return n()}}function qe(){return rr()}function Ve(e,t){return Kt(e,t)}function le(e,t,n){return ir(t,n,e)}function cr(e,t){return n=>t(e(n))}class or extends f{constructor(t){super(),this.all=t}}function Tt(){return new or(a([]))}function j(e,t,n,r){if(t!=null&&t.tag&&(e==null?void 0:e.nodeType)===1){const i=t.tag.toUpperCase(),s=t.namespace||"http://www.w3.org/1999/xhtml";return e.nodeName===i&&e.namespaceURI==s?fr(e,t,n,r):Mt(e,t,n,r)}return t!=null&&t.tag?Mt(e,t,n,r):typeof(t==null?void 0:t.content)=="string"?(e==null?void 0:e.nodeType)===3?dr(e,t):hr(e,t):document.createComment(["[internal lustre error] I couldn't work out how to render this element. This","function should only be called internally by lustre's runtime: if you think","this is an error, please open an issue at","https://github.com/hayleigh-dot-dev/gleam-lustre/issues/new"].join(" "))}function Mt(e,t,n,r=null){const i=t.namespace?document.createElementNS(t.namespace,t.tag):document.createElement(t.tag);i.$lustre={__registered_events:new Set};let s="";for(const u of t.attrs)u[0]==="class"?de(i,u[0],`${i.className} ${u[1]}`):u[0]==="style"?de(i,u[0],`${i.style.cssText} ${u[1]}`):u[0]==="dangerous-unescaped-html"?s+=u[1]:u[0]!==""&&de(i,u[0],u[1],n);if(customElements.get(t.tag))i._slot=t.children;else if(t.tag==="slot"){let u=new je,l=r;for(;l;)if(l._slot){u=l._slot;break}else l=l.parentNode;for(const c of u)i.appendChild(j(null,c,n,i))}else if(s)i.innerHTML=s;else for(const u of t.children)i.appendChild(j(null,u,n,i));return e&&e.replaceWith(i),i}function fr(e,t,n,r){const i=e.attributes,s=new Map;e.$lustre??(e.$lustre={__registered_events:new Set});for(const u of t.attrs)u[0]==="class"&&s.has("class")?s.set(u[0],`${s.get("class")} ${u[1]}`):u[0]==="style"&&s.has("style")?s.set(u[0],`${s.get("style")} ${u[1]}`):u[0]==="dangerous-unescaped-html"&&s.has("dangerous-unescaped-html")?s.set(u[0],`${s.get("dangerous-unescaped-html")} ${u[1]}`):u[0]!==""&&s.set(u[0],u[1]);for(const{name:u,value:l}of i)if(!s.has(u))e.removeAttribute(u);else{const c=s.get(u);c!==l&&(de(e,u,c,n),s.delete(u))}for(const u of e.$lustre.__registered_events)if(!s.has(u)){const l=u.slice(2).toLowerCase();e.removeEventListener(l,e.$lustre[`${u}Handler`]),e.$lustre.__registered_events.delete(u),delete e.$lustre[u],delete e.$lustre[`${u}Handler`]}for(const[u,l]of s)de(e,u,l,n);if(customElements.get(t.tag))e._slot=t.children;else if(t.tag==="slot"){let u=e.firstChild,l=new je,c=r;for(;c;)if(c._slot){l=c._slot;break}else c=c.parentNode;for(;u;)Array.isArray(l)&&l.length?j(u,l.shift(),n,e):l.head&&(j(u,l.head,n,e),l=l.tail),u=u.nextSibling;for(const d of l)e.appendChild(j(null,d,n,e))}else if(s.has("dangerous-unescaped-html"))e.innerHTML=s.get("dangerous-unescaped-html");else{let u=e.firstChild,l=t.children;for(;u;)if(Array.isArray(l)&&l.length){const c=u.nextSibling;j(u,l.shift(),n,e),u=c}else if(l.head){const c=u.nextSibling;j(u,l.head,n,e),l=l.tail,u=c}else{const c=u.nextSibling;u.remove(),u=c}for(const c of l)e.appendChild(j(null,c,n,e))}return e}function de(e,t,n,r){switch(typeof n){case"string":e.getAttribute(t)!==n&&e.setAttribute(t,n),n===""&&e.removeAttribute(t),t==="value"&&e.value!==n&&(e.value=n);break;case(t.startsWith("on")&&"function"):{if(e.$lustre[t]===n)break;const i=t.slice(2).toLowerCase(),s=u=>Ae(n(u),r);e.$lustre[`${t}Handler`]&&e.removeEventListener(i,e.$lustre[`${t}Handler`]),e.addEventListener(i,s),e.$lustre[t]=n,e.$lustre[`${t}Handler`]=s,e.$lustre.__registered_events.add(t);break}default:e[t]=n}}function hr(e,t){const n=document.createTextNode(t.content);return e&&e.replaceWith(n),n}function dr(e,t){const n=e.nodeValue,r=t.content;return r?(n!==r&&(e.nodeValue=r),e):(e==null||e.remove(),null)}var I,W,B,q,D,me,se,ue,_e,rt,ge,it;class pr{constructor(t,n,r){L(this,_e);L(this,ge);L(this,I,null);L(this,W,null);L(this,B,[]);L(this,q,[]);L(this,D,!1);L(this,me,null);L(this,se,null);L(this,ue,null);_(this,me,t),_(this,se,n),_(this,ue,r)}start(t,n){if(!mr())return new m(new Sr);if(w(this,I))return new m(new Er);if(_(this,I,t instanceof HTMLElement?t:document.querySelector(t)),!w(this,I))return new m(new vr);const[r,i]=w(this,me).call(this,n);return _(this,W,r),_(this,q,i.all.toArray()),_(this,D,!0),window.requestAnimationFrame(()=>fe(this,_e,rt).call(this)),new h(s=>this.dispatch(s))}dispatch(t){w(this,B).push(t),fe(this,_e,rt).call(this)}emit(t,n=null){w(this,I).dispatchEvent(new CustomEvent(t,{bubbles:!0,detail:n,composed:!0}))}destroy(){if(!w(this,I))return new m(new Lr);w(this,I).remove(),_(this,I,null),_(this,W,null),_(this,B,[]),_(this,q,[]),_(this,D,!1),_(this,se,()=>{}),_(this,ue,()=>{})}}I=new WeakMap,W=new WeakMap,B=new WeakMap,q=new WeakMap,D=new WeakMap,me=new WeakMap,se=new WeakMap,ue=new WeakMap,_e=new WeakSet,rt=function(){if(fe(this,ge,it).call(this),w(this,D)){const t=w(this,ue).call(this,w(this,W));_(this,I,j(w(this,I),t,n=>this.dispatch(n))),_(this,D,!1)}},ge=new WeakSet,it=function(t=0){if(w(this,I)){if(w(this,B).length)for(;w(this,B).length;){const[n,r]=w(this,se).call(this,w(this,W),w(this,B).shift());w(this,D)||_(this,D,w(this,W)!==n),_(this,W,n),_(this,q,w(this,q).concat(r.all.toArray()))}for(;w(this,q).length;)w(this,q).shift()(n=>this.dispatch(n),(n,r)=>this.emit(n,r));w(this,B).length&&(t>=5?console.warn(tooManyUpdates):fe(this,ge,it).call(this,++t))}};const wr=(e,t,n)=>new pr(e,t,n),yr=(e,t,n)=>e.start(t,n),mr=()=>window&&window.document;function Ue(e){let n=qt(e);return Vt(n)}function _r(e){return tr(e)}class Jt extends f{constructor(t,n,r){super(),this[0]=t,this[1]=n,this.as_property=r}}class gr extends f{constructor(t,n){super(),this[0]=t,this[1]=n}}function ae(e,t){return new Jt(e,ct(t),!1)}function Zt(e,t){return new Jt(e,ct(t),!0)}function br(e,t){return new gr("on"+e,cr(t,n=>lt(n,void 0)))}function xr(e){return ae("style",ut(e,"",(t,n)=>{let r=n[0],i=n[1];return t+r+":"+i+";"}))}function Nt(e){return ae("id",e)}function $r(e){return ae("placeholder",e)}function ee(e){return ae("href",e)}function Ar(e){return ae("src",e)}function Ir(e){return Zt("height",$e(e))}function kr(e){return Zt("width",$e(e))}class Or extends f{constructor(t){super(),this.content=t}}class x extends f{constructor(t,n,r,i,s,u){super(),this.namespace=t,this.tag=n,this.attrs=r,this.children=i,this.self_closing=s,this.void=u}}function U(e,t,n){return e==="area"?new x("",e,t,a([]),!1,!0):e==="base"?new x("",e,t,a([]),!1,!0):e==="br"?new x("",e,t,a([]),!1,!0):e==="col"?new x("",e,t,a([]),!1,!0):e==="embed"?new x("",e,t,a([]),!1,!0):e==="hr"?new x("",e,t,a([]),!1,!0):e==="img"?new x("",e,t,a([]),!1,!0):e==="input"?new x("",e,t,a([]),!1,!0):e==="link"?new x("",e,t,a([]),!1,!0):e==="meta"?new x("",e,t,a([]),!1,!0):e==="param"?new x("",e,t,a([]),!1,!0):e==="source"?new x("",e,t,a([]),!1,!0):e==="track"?new x("",e,t,a([]),!1,!0):e==="wbr"?new x("",e,t,a([]),!1,!0):new x("",e,t,n,!1,!1)}function p(e){return new Or(e)}class Er extends f{}class Lr extends f{}class vr extends f{}class Sr extends f{}function Cr(e,t,n){return wr(s=>[e(s),Tt()],(s,u)=>[t(s,u),Tt()],n)}function Xe(e,t){return U("h3",e,t)}function Je(e,t){return U("div",e,t)}function Ze(e,t){return U("p",e,t)}function te(e,t){return U("a",e,t)}function Rr(e){return U("br",e,a([]))}function Qe(e,t){return U("code",e,t)}function Tr(e,t){return U("strong",e,t)}function Mr(e){return U("iframe",e,a([]))}function Nr(e){return U("textarea",e,a([]))}function zr(e,t){return br(e,t)}function jr(e){let t=e;return vt("target",vt("value",Ut))(t)}function Wr(e){return zr("input",t=>{let n=jr(t);return Ae(n,e)})}class Te extends f{constructor(t){super(),this.error=t}}class Le extends f{constructor(t,n){super(),this.row=t,this.col=n}}class N extends f{constructor(t){super(),this.parse=t}}function A(e,t,n){let r=e.parse;return r(t,n)}function Fe(e){return new N((t,n)=>{if(!(n instanceof Le))throw We("assignment_no_match","party",58,"","Assignment pattern did not match",{value:n});let r=n.row,i=n.col;if(t.atLeastLength(1)){let s=t.head,u=t.tail;return e(s)?s===`
`?new h([s,u,new Le(r+1,0)]):new h([s,u,new Le(r,i+1)]):new m(new Te(s))}else return new m(new Te("EOF"))})}function y(e){return Fe(t=>e===t)}function ce(e,t){return new N((n,r)=>Tn(A(e,n,r),A(t,n,r)))}function Oe(e){return new N((t,n)=>{if(e.hasLength(0))return new m(new Te("choiceless choice"));if(e.hasLength(1)){let r=e.head;return A(r,t,n)}else{let r=e.head,i=e.tail,s=A(r,t,n);if(s.isOk()){let u=s[0][0],l=s[0][1],c=s[0][2];return new h([u,l,c])}else return A(Oe(i),t,n)}})}function Y(e){return new N((t,n)=>{let r=A(e,t,n);if(r.isOk()){let i=r[0][0],s=r[0][1],u=r[0][2];return Ae(A(Y(e),s,u),l=>[be(i,l[0]),l[1],l[2]])}else return new h([a([]),t,n])})}function Qt(e){return new N((t,n)=>{let r=A(e,t,n);if(r.isOk()){let i=r[0][0],s=r[0][1],u=r[0][2];return Ae(A(Y(e),s,u),l=>[be(i,l[0]),l[1],l[2]])}else{let i=r[0];return new m(i)}})}function T(e,t){return new N((n,r)=>{let i=A(e,n,r);if(i.isOk()){let s=i[0][0],u=i[0][1],l=i[0][2];return new h([t(s),u,l])}else{let s=i[0];return new m(s)}})}function en(e){return new N((t,n)=>A(e,t,n).isOk()?new m(new Te("")):new h([void 0,t,n]))}function V(e){return new N((t,n)=>A(e(),t,n))}function o(e,t){return new N((n,r)=>{let i=A(e,n,r);if(i.isOk()){let s=i[0][0],u=i[0][1],l=i[0][2];return A(t(s),u,l)}else{let s=i[0];return new m(s)}})}function b(e){return new N((t,n)=>new h([e,t,n]))}function pe(e){let t=_r(e);if(t.isOk()){let n=t[0][0],r=t[0][1];return o(y(n),i=>o(pe(r),s=>b(i+s)))}else return b("")}function tn(e,t){let n=A(e,er(t),new Le(1,1));if(n.isOk()){let r=n[0][0];return new h(r)}else{let r=n[0];return new m(r)}}function Br(){return Fe(e=>_t("abcdefghijklmnopqrstuvwxyz",e))}function qr(){return Fe(e=>_t("ABCDEFGHIJKLMNOPQRSTUVWXYZ",e))}function bt(){return ce(Br(),qr())}function xt(){return Fe(e=>_t("0123456789",e))}function De(){return ce(xt(),bt())}let nn=class extends f{constructor(t){super(),this[0]=t}},rn=class extends f{constructor(t){super(),this[0]=t}},sn=class extends f{constructor(t,n){super(),this[0]=t,this[1]=n}},Vr=class extends f{constructor(t,n){super(),this[0]=t,this[1]=n}},un=class extends f{constructor(t){super(),this.int=t}},Ee=class extends f{constructor(t,n){super(),this.val=t,this.gen=n}},$t=class extends f{constructor(t){super(),this[0]=t}},At=class extends f{constructor(t,n){super(),this[0]=t,this[1]=n}},we=class extends f{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}},Me=class extends f{constructor(t,n){super(),this[0]=t,this[1]=n}};function Ur(){let e=Qt(xt()),t=T(e,Ue),n=T(t,Wt),r=T(n,i=>Bt(i,()=>{throw We("panic","tinylang",19,"","parsed int isn't an int",{})}));return T(r,i=>new nn(i))}function ln(){return o(bt(),e=>o(Y(ce(De(),y("_"))),t=>b(e+Ue(t))))}function Fr(){let e=ln();return T(e,t=>new rn(t))}function re(){return o(Y(Oe(a([y(" "),y("	"),y(`
`)]))),e=>b(void 0))}function Dr(e,t){return t(new un(e.int+1),e.int)}function ve(e,t,n){if(t instanceof nn){let r=t[0];return new h(new Ee(new $t(r),e))}else if(t instanceof rn){let r=t[0],i=Ve(n,r);if(i.isOk()){let s=i[0];return new h(new Ee(new At(s,r),e))}else return new m("Wait! "+r+" isn't defined anywhere!")}else if(t instanceof sn){let r=t[0],i=t[1];return Dr(e,(s,u)=>g(ve(s,i,le(n,r,u)),l=>{let c=new we(u,r,l.val),d=new Ee(c,s);return new h(d)}))}else{let r=t[0],i=t[1];return g(ve(e,r,n),s=>g(ve(s.gen,i,n),u=>{let l=new Me(s.val,u.val),c=new Ee(l,u.gen);return new h(c)}))}}function Hr(e,t){return g(ve(e,t,qe()),n=>new h(n.val))}function Se(e,t){for(;;){let n=e,r=t;if(n instanceof $t)return n;if(n instanceof At){let i=n[0],s=Ve(r,i);return s.isOk()?s[0]:n}else if(n instanceof Me){let i=n[0],s=n[1],u=Se(i,r),l=Se(s,r);if(u instanceof we){let c=u[0];e=u[2],t=le(r,c,l)}else return new Me(u,l)}else{let i=n[0],s=n[1],u=n[2];return new we(i,s,Se(u,r))}}}function Pr(e){return Se(e,qe())}function ne(e){if(e instanceof $t){let t=e[0];return $e(t)}else{if(e instanceof At)return e[1];if(e instanceof we){let t=e[1],n=e[2];return"\\"+t+". "+ne(n)}else if(e instanceof Me&&e[0]instanceof we){let t=e[0],n=e[1];return"("+ne(t)+")("+ne(n)+")"}else{let t=e[0],n=e[1];return ne(t)+"("+ne(n)+")"}}}function Gr(e){return e.isOk(),e[0]}function He(){return o(re(),e=>o(Oe(a([Ur(),Fr(),Yr(),Kr()])),t=>o(re(),n=>o(Y(o(y("("),r=>o(V(He),i=>o(y(")"),s=>o(re(),u=>b(i)))))),r=>{let i=ut(r,t,(s,u)=>new Vr(s,u));return b(i)}))))}function Yr(){return o(y("\\"),e=>o(re(),t=>o(ln(),n=>o(re(),r=>o(y("."),i=>o(re(),s=>o(V(He),u=>b(new sn(n,u)))))))))}function Kr(){return o(y("("),e=>o(V(He),t=>o(y(")"),n=>b(t))))}function Xr(e){let t=g(lt(tn(He(),e),"there's a mistake in the notation somewhere; I couldn't understand it!"),n=>g(Hr(new un(0),n),r=>{let i=Pr(r);return new h(ne(i))}));return Gr(t)}class an extends f{constructor(t){super(),this[0]=t}}class cn extends f{constructor(t){super(),this[0]=t}}class on extends f{constructor(t,n){super(),this[0]=t,this[1]=n}}class fn extends f{constructor(t,n){super(),this[0]=t,this[1]=n}}class hn extends f{}class dn extends f{}class Jr extends f{constructor(t,n,r,i){super(),this[0]=t,this[1]=n,this[2]=r,this[3]=i}}class pn extends f{constructor(t){super(),this.int=t}}class K extends f{constructor(t,n){super(),this.val=t,this.gen=n}}class It extends f{constructor(t){super(),this[0]=t}}class kt extends f{constructor(t,n){super(),this[0]=t,this[1]=n}}class ie extends f{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}}class ye extends f{constructor(t,n){super(),this[0]=t,this[1]=n}}class Ne extends f{}class ze extends f{}class Zr extends f{constructor(t,n,r,i,s){super(),this[0]=t,this[1]=n,this[2]=r,this[3]=i,this[4]=s}}function Qr(){let e=Qt(xt()),t=T(e,Ue),n=T(t,Wt),r=T(n,i=>Bt(i,()=>{throw We("panic","tinytypedlang",22,"","parsed int isn't an int",{})}));return T(r,i=>new an(i))}function Ot(){return o(bt(),e=>o(Y(ce(De(),y("_"))),t=>b(e+Ue(t))))}function ei(){let e=Ot();return T(e,t=>new cn(t))}function ti(){return o(pe("Type"),e=>o(en(ce(De(),y("_"))),t=>b(new hn)))}function ni(){return o(pe("Int"),e=>o(en(ce(De(),y("_"))),t=>b(new dn)))}function H(){return o(Y(Oe(a([y(" "),y("	"),y(`
`)]))),e=>b(void 0))}function zt(e,t){return t(new pn(e.int+1),e.int)}function X(e,t,n){if(t instanceof an){let r=t[0];return new h(new K(new It(r),e))}else if(t instanceof cn){let r=t[0],i=Ve(n,r);if(i.isOk()){let s=i[0];return new h(new K(new kt(s,r),e))}else return new m("Wait! "+r+" isn't defined anywhere!")}else if(t instanceof on){let r=t[0],i=t[1];return zt(e,(s,u)=>g(X(s,i,le(n,r,u)),l=>{let c=new ie(u,r,l.val),d=new K(c,s);return new h(d)}))}else if(t instanceof fn){let r=t[0],i=t[1];return g(X(e,r,n),s=>g(X(s.gen,i,n),u=>{let l=new ye(s.val,u.val),c=new K(l,u.gen);return new h(c)}))}else{if(t instanceof hn)return new h(new K(new Ne,e));if(t instanceof dn)return new h(new K(new ze,e));{let r=t[0],i=t[1],s=t[2],u=t[3];return zt(e,(l,c)=>g(X(l,i,n),d=>{let O=le(n,r,c);return g(X(d.gen,s,O),F=>g(X(F.gen,u,O),E=>{let oe=new Zr(c,r,d.val,F.val,E.val),Pe=new K(oe,E.gen);return new h(Pe)}))}))}}}function ri(e,t){return g(X(e,t,qe()),n=>new h(n.val))}function he(e,t){for(;;){let n=e,r=t;if(n instanceof It)return n;if(n instanceof kt){let i=n[0],s=Ve(r,i);return s.isOk()?s[0]:n}else if(n instanceof ye){let i=n[0],s=n[1],u=he(i,r),l=he(s,r);if(u instanceof ie){let c=u[0];e=u[2],t=le(r,c,l)}else return new ye(u,l)}else if(n instanceof ie){let i=n[0],s=n[1],u=n[2];return new ie(i,s,he(u,r))}else{if(n instanceof Ne)return new Ne;if(n instanceof ze)return new ze;{let i=n[0],s=n[3];e=n[4],t=le(r,i,he(s,r))}}}}function ii(e){return he(e,qe())}function z(e){if(e instanceof It){let t=e[0];return $e(t)}else{if(e instanceof kt)return e[1];if(e instanceof ie){let t=e[1],n=e[2];return"\\"+t+". "+z(n)}else if(e instanceof ye&&e[0]instanceof ie){let t=e[0],n=e[1];return"("+z(t)+")("+z(n)+")"}else if(e instanceof ye){let t=e[0],n=e[1];return z(t)+"("+z(n)+")"}else{if(e instanceof Ne)return"Type";if(e instanceof ze)return"Int";{let t=e[1],n=e[2],r=e[3],i=e[4];return"let "+t+": "+z(n)+" = "+z(r)+`;
`+z(i)}}}}function si(e){return e.isOk(),e[0]}function Z(){return o(H(),e=>o(Oe(a([Qr(),ti(),ni(),ui(),ei(),li(),ai()])),t=>o(H(),n=>o(Y(o(y("("),r=>o(V(Z),i=>o(y(")"),s=>o(H(),u=>b(i)))))),r=>{let i=ut(r,t,(s,u)=>new fn(s,u));return b(i)}))))}function ui(){return o(pe("let "),e=>o(H(),t=>o(Ot(),n=>o(H(),r=>o(y(":"),i=>o(V(Z),s=>o(pe("="),u=>o(V(Z),l=>o(y(";"),c=>o(V(Z),d=>b(new Jr(n,s,l,d))))))))))))}function li(){return o(y("\\"),e=>o(H(),t=>o(Ot(),n=>o(H(),r=>o(y("."),i=>o(H(),s=>o(V(Z),u=>b(new on(n,u)))))))))}function ai(){return o(y("("),e=>o(V(Z),t=>o(y(")"),n=>b(t))))}function ci(e){let t=g(lt(tn(Z(),e),"there's a mistake in the notation somewhere; I couldn't understand it!"),n=>g(ri(new pn(0),n),r=>{let i=ii(r);return new h(z(i))}));return si(t)}class oi extends f{constructor(t){super(),this[0]=t}}function fi(e){return["",!0]}function hi(e,t){return[t[0],e[1]]}function di(e){return Je(a([]),a([Xe(a([]),a([p("Who I Am")])),Ze(a([]),a([p("I'm Ryan Brewer, the software developer behind "),te(a([ee("https://github.com/RyanBrewer317/SaberVM")]),a([p("SaberVM")])),p(`,
an abstract machine for safe, portable computation that functional languages can compile to. 
With SaberVM, I'm hoping to broaden accessibility to safe computation, both informationally and financially. 
Consider supporting my work!
`)])),Mr(a([Ar("https://github.com/sponsors/RyanBrewer317/button"),ae("title","Sponsor RyanBrewer317"),Ir(32),kr(114),xr(a([["border","0"],["border-radius","6px;"]]))])),Xe(a([]),a([p("My Website")])),Ze(a([]),a([p("This is my website. It's hosted by Firebase and written mostly in "),te(a([ee("https://gleam.run")]),a([p("Gleam")])),p(", and the code is up on my "),te(a([ee("https://github.com/RyanBrewer317/ryanbrewer-dev")]),a([p("github")])),p(". The only framework used is "),te(a([ee("https://lustre.build/")]),a([p("Lustre")])),p("; scripting, markup, styles, and layout were all done by hand.")])),Xe(a([]),a([p("Lambda Calculus in Gleam")])),Ze(a([]),a([p(`
I study programming language design, and I'm particularly fond of functional programming.
That's why I made this website in `),te(a([ee("https://gleam.run")]),a([p("Gleam")])),p(`,
a statically-typed functional language
that can run anywhere JavaScript can, as well as on Erlang's BEAM VM. 
I've used Gleam to write a lambda calculus evaluator that you can play with below. 
Lambda abstractions are written like 
`),Qe(a([]),a([p("\\var. body")])),p(", and are called like "),Qe(a([]),a([p("fun(arg)")])),p(". There are also positive integers like 7. Try writing "),Qe(a([]),a([p("(\\x.x)(2)")])),p(", which evaluates to 2. The code for this can be found "),te(a([ee("https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/tinylang.gleam")]),a([p("here")])),p(". (It's currently broken on firefox, but definitely works on chrome.)")])),Nr(a([Nt("code"),$r("Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)(3)"),Wr(t=>new oi(t))])),Rr(a([])),(()=>{if(e[0]==="")return p("");{let t=e[0],n=e[1],r=(()=>n?ci(t):Xr(t))();return(i=>Je(a([]),a([Tr(a([]),a([p("output ")])),p(" (variables may be renamed): "),Je(a([Nt("code-output")]),a([p(i)]))])))(r)}})()]))}function pi(){let e=Cr(fi,hi,di),t=yr(e,"[data-lustre-app]",void 0);if(!t.isOk())throw We("assignment_no_match","ryanbrewerdev",15,"main","Assignment pattern did not match",{value:t});return t[0]}document.addEventListener("DOMContentLoaded",()=>{pi()});
