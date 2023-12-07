var Ae=(e,t,n)=>{if(!t.has(e))throw TypeError("Cannot "+n)};var m=(e,t,n)=>(Ae(e,t,"read from private field"),n?n.call(e):t.get(e)),O=(e,t,n)=>{if(t.has(e))throw TypeError("Cannot add the same private member more than once");t instanceof WeakSet?t.add(e):t.set(e,n)},w=(e,t,n,r)=>(Ae(e,t,"write to private field"),r?r.call(e,n):t.set(e,n),n);var ee=(e,t,n)=>(Ae(e,t,"access private method"),n);import"./style-7fc569a8.js";class p{inspect(){console.warn("Deprecated method UtfCodepoint.inspect");let t=r=>{let i=G(this[r]);return isNaN(parseInt(r))?`${r}: ${i}`:i},n=Object.keys(this).map(t).join(", ");return n?`${this.constructor.name}(${n})`:this.constructor.name}withFields(t){let n=Object.keys(this).map(r=>r in t?t[r]:this[r]);return new this.constructor(...n)}}class V{static fromArray(t,n){let r=n||new ge;return t.reduceRight((i,s)=>new Rt(s,i),r)}[Symbol.iterator](){return new Dt(this)}inspect(){return console.warn("Deprecated method UtfCodepoint.inspect"),`[${this.toArray().map(G).join(", ")}]`}toArray(){return[...this]}atLeastLength(t){for(let n of this){if(t<=0)return!0;t--}return t<=0}hasLength(t){for(let n of this){if(t<=0)return!1;t--}return t===0}countLength(){let t=0;for(let n of this)t++;return t}}function f(e,t){return V.fromArray(e,t)}var U;class Dt{constructor(t){O(this,U,void 0);w(this,U,t)}next(){if(m(this,U)instanceof ge)return{done:!0};{let{head:t,tail:n}=m(this,U);return w(this,U,n),{value:t,done:!1}}}}U=new WeakMap;class ge extends V{}class Rt extends V{constructor(t,n){super(),this.head=t,this.tail=n}}class pe{constructor(t){if(!(t instanceof Uint8Array))throw"BitArray can only be constructed from a Uint8Array";this.buffer=t}inspect(){return console.warn("Deprecated method UtfCodepoint.inspect"),`<<${Array.from(this.buffer).join(", ")}>>`}get length(){return this.buffer.length}byteAt(t){return this.buffer[t]}floatAt(t){return Ft(this.buffer.slice(t,t+8))}intFromSlice(t,n){return qt(this.buffer.slice(t,n))}binaryFromSlice(t,n){return new pe(this.buffer.slice(t,n))}sliceAfter(t){return new pe(this.buffer.slice(t))}}function qt(e){e=e.reverse();let t=0;for(let n=e.length-1;n>=0;n--)t=t*256+e[n];return t}function Ft(e){return new Float64Array(e.reverse().buffer)[0]}class ue extends p{static isResult(t){return t instanceof ue}}class d extends ue{constructor(t){super(),this[0]=t}isOk(){return!0}}class y extends ue{constructor(t){super(),this[0]=t}isOk(){return!1}}function G(e){let t=typeof e;if(e===!0)return"True";if(e===!1)return"False";if(e===null)return"//js(null)";if(e===void 0)return"Nil";if(t==="string")return JSON.stringify(e);if(t==="bigint"||t==="number")return e.toString();if(Array.isArray(e))return`#(${e.map(G).join(", ")})`;if(e instanceof Set)return`//js(Set(${[...e].map(G).join(", ")}))`;if(e instanceof RegExp)return`//js(${e})`;if(e instanceof Date)return`//js(Date("${e.toISOString()}"))`;if(e instanceof Function){let n=[];for(let r of Array(e.length).keys())n.push(String.fromCharCode(r+97));return`//fn(${n.join(", ")}) { ... }`}try{return e.inspect()}catch{return Ut(e)}}function Ut(e){var u,c;let[t,n]=lt(e),r=((c=(u=Object.getPrototypeOf(e))==null?void 0:u.constructor)==null?void 0:c.name)||"Object",i=[];for(let l of t(e))i.push(`${G(l)}: ${G(n(e,l))}`);let s=i.length?" "+i.join(", ")+" ":"";return`//js(${r==="Object"?"":r+" "}{${s}})`}function R(e,t){let n=[e,t];for(;n.length;){let r=n.pop(),i=n.pop();if(r===i)continue;if(!Je(r)||!Je(i)||!Pt(r,i)||Wt(r,i)||Bt(r,i)||Vt(r,i)||Ht(r,i)||Yt(r,i))return!1;const a=Object.getPrototypeOf(r);if(a!==null&&typeof a.equals=="function")try{if(r.equals(i))continue;return!1}catch{}let[u,c]=lt(r);for(let l of u(r))n.push(c(r,l),c(i,l))}return!0}function lt(e){if(e instanceof Map)return[t=>t.keys(),(t,n)=>t.get(n)];{let t=e instanceof globalThis.Error?["message"]:[];return[n=>[...t,...Object.keys(n)],(n,r)=>n[r]]}}function Wt(e,t){return e instanceof Date&&(e>t||e<t)}function Bt(e,t){return e.buffer instanceof ArrayBuffer&&e.BYTES_PER_ELEMENT&&!(e.byteLength===t.byteLength&&e.every((n,r)=>n===t[r]))}function Vt(e,t){return Array.isArray(e)&&e.length!==t.length}function Ht(e,t){return e instanceof Map&&e.size!==t.size}function Yt(e,t){return e instanceof Set&&(e.size!=t.size||[...e].some(n=>!t.has(n)))}function Je(e){return typeof e=="object"&&e!==null}function Pt(e,t){return typeof e!="object"&&typeof t!="object"&&(!e||!t)||[Promise,WeakSet,WeakMap,Function].some(r=>e instanceof r)?!1:e.constructor===t.constructor}function o(e,t,n,r,i,s){let a=new globalThis.Error(i);a.gleam_error=e,a.module=t,a.line=n,a.fn=r;for(let u in s)a[u]=s[u];return a}class Me extends p{constructor(t){super(),this[0]=t}}class Ze extends p{}function Kt(e,t){if(e instanceof Me){let n=e[0];return new d(n)}else return new y(t)}const Qe=new WeakMap,Ne=new DataView(new ArrayBuffer(8));let ke=0;function Se(e){const t=Qe.get(e);if(t!==void 0)return t;const n=ke++;return ke===2147483647&&(ke=0),Qe.set(e,n),n}function Ie(e,t){return e^t+2654435769+(e<<6)+(e>>2)|0}function De(e){let t=0;const n=e.length;for(let r=0;r<n;r++)t=Math.imul(31,t)+e.charCodeAt(r)|0;return t}function ot(e){Ne.setFloat64(0,e);const t=Ne.getInt32(0),n=Ne.getInt32(4);return Math.imul(73244475,t>>16^t)^n}function Xt(e){return De(e.toString())}function Gt(e){const t=Object.getPrototypeOf(e);if(t!==null&&typeof t.hashCode=="function")try{const r=e.hashCode(e);if(typeof r=="number")return r}catch{}if(e instanceof Promise||e instanceof WeakSet||e instanceof WeakMap)return Se(e);if(e instanceof Date)return ot(e.getTime());let n=0;if(e instanceof ArrayBuffer&&(e=new Uint8Array(e)),Array.isArray(e)||e instanceof Uint8Array)for(let r=0;r<e.length;r++)n=Math.imul(31,n)+A(e[r])|0;else if(e instanceof Set)e.forEach(r=>{n=n+A(r)|0});else if(e instanceof Map)e.forEach((r,i)=>{n=n+Ie(A(r),A(i))|0});else{const r=Object.keys(e);for(let i=0;i<r.length;i++){const s=r[i],a=e[s];n=n+Ie(A(a),De(s))|0}}return n}function A(e){if(e===null)return 1108378658;if(e===void 0)return 1108378659;if(e===!0)return 1108378657;if(e===!1)return 1108378656;switch(typeof e){case"number":return ot(e);case"string":return De(e);case"bigint":return Xt(e);case"object":return Gt(e);case"symbol":return Se(e);case"function":return Se(e);default:return 0}}const L=5,Re=Math.pow(2,L),Jt=Re-1,Zt=Re/2,Qt=Re/4,_=0,I=1,$=2,H=3,qe={type:$,bitmap:0,array:[]};function ce(e,t){return e>>>t&Jt}function _e(e,t){return 1<<ce(e,t)}function en(e){return e-=e>>1&1431655765,e=(e&858993459)+(e>>2&858993459),e=e+(e>>4)&252645135,e+=e>>8,e+=e>>16,e&127}function Fe(e,t){return en(e&t-1)}function N(e,t,n){const r=e.length,i=new Array(r);for(let s=0;s<r;++s)i[s]=e[s];return i[t]=n,i}function tn(e,t,n){const r=e.length,i=new Array(r+1);let s=0,a=0;for(;s<t;)i[a++]=e[s++];for(i[a++]=n;s<r;)i[a++]=e[s++];return i}function Le(e,t){const n=e.length,r=new Array(n-1);let i=0,s=0;for(;i<t;)r[s++]=e[i++];for(++i;i<n;)r[s++]=e[i++];return r}function ft(e,t,n,r,i,s){const a=A(t);if(a===r)return{type:H,hash:a,array:[{type:_,k:t,v:n},{type:_,k:i,v:s}]};const u={val:!1};return le(Ue(qe,e,a,t,n,u),e,r,i,s,u)}function le(e,t,n,r,i,s){switch(e.type){case I:return nn(e,t,n,r,i,s);case $:return Ue(e,t,n,r,i,s);case H:return rn(e,t,n,r,i,s)}}function nn(e,t,n,r,i,s){const a=ce(n,t),u=e.array[a];if(u===void 0)return s.val=!0,{type:I,size:e.size+1,array:N(e.array,a,{type:_,k:r,v:i})};if(u.type===_)return R(r,u.k)?i===u.v?e:{type:I,size:e.size,array:N(e.array,a,{type:_,k:r,v:i})}:(s.val=!0,{type:I,size:e.size,array:N(e.array,a,ft(t+L,u.k,u.v,n,r,i))});const c=le(u,t+L,n,r,i,s);return c===u?e:{type:I,size:e.size,array:N(e.array,a,c)}}function Ue(e,t,n,r,i,s){const a=_e(n,t),u=Fe(e.bitmap,a);if(e.bitmap&a){const c=e.array[u];if(c.type!==_){const h=le(c,t+L,n,r,i,s);return h===c?e:{type:$,bitmap:e.bitmap,array:N(e.array,u,h)}}const l=c.k;return R(r,l)?i===c.v?e:{type:$,bitmap:e.bitmap,array:N(e.array,u,{type:_,k:r,v:i})}:(s.val=!0,{type:$,bitmap:e.bitmap,array:N(e.array,u,ft(t+L,l,c.v,n,r,i))})}else{const c=e.array.length;if(c>=Zt){const l=new Array(32),h=ce(n,t);l[h]=Ue(qe,t+L,n,r,i,s);let C=0,k=e.bitmap;for(let Q=0;Q<32;Q++){if(k&1){const Mt=e.array[C++];l[Q]=Mt}k=k>>>1}return{type:I,size:c+1,array:l}}else{const l=tn(e.array,u,{type:_,k:r,v:i});return s.val=!0,{type:$,bitmap:e.bitmap|a,array:l}}}}function rn(e,t,n,r,i,s){if(n===e.hash){const a=We(e,r);if(a!==-1)return e.array[a].v===i?e:{type:H,hash:n,array:N(e.array,a,{type:_,k:r,v:i})};const u=e.array.length;return s.val=!0,{type:H,hash:n,array:N(e.array,u,{type:_,k:r,v:i})}}return le({type:$,bitmap:_e(e.hash,t),array:[e]},t,n,r,i,s)}function We(e,t){const n=e.array.length;for(let r=0;r<n;r++)if(R(t,e.array[r].k))return r;return-1}function me(e,t,n,r){switch(e.type){case I:return sn(e,t,n,r);case $:return an(e,t,n,r);case H:return un(e,r)}}function sn(e,t,n,r){const i=ce(n,t),s=e.array[i];if(s!==void 0){if(s.type!==_)return me(s,t+L,n,r);if(R(r,s.k))return s}}function an(e,t,n,r){const i=_e(n,t);if(!(e.bitmap&i))return;const s=Fe(e.bitmap,i),a=e.array[s];if(a.type!==_)return me(a,t+L,n,r);if(R(r,a.k))return a}function un(e,t){const n=We(e,t);if(!(n<0))return e.array[n]}function Be(e,t,n,r){switch(e.type){case I:return cn(e,t,n,r);case $:return ln(e,t,n,r);case H:return on(e,r)}}function cn(e,t,n,r){const i=ce(n,t),s=e.array[i];if(s===void 0)return e;let a;if(s.type===_){if(!R(s.k,r))return e}else if(a=Be(s,t+L,n,r),a===s)return e;if(a===void 0){if(e.size<=Qt){const u=e.array,c=new Array(e.size-1);let l=0,h=0,C=0;for(;l<i;){const k=u[l];k!==void 0&&(c[h]=k,C|=1<<l,++h),++l}for(++l;l<u.length;){const k=u[l];k!==void 0&&(c[h]=k,C|=1<<l,++h),++l}return{type:$,bitmap:C,array:c}}return{type:I,size:e.size-1,array:N(e.array,i,a)}}return{type:I,size:e.size,array:N(e.array,i,a)}}function ln(e,t,n,r){const i=_e(n,t);if(!(e.bitmap&i))return e;const s=Fe(e.bitmap,i),a=e.array[s];if(a.type!==_){const u=Be(a,t+L,n,r);return u===a?e:u!==void 0?{type:$,bitmap:e.bitmap,array:N(e.array,s,u)}:e.bitmap===i?void 0:{type:$,bitmap:e.bitmap^i,array:Le(e.array,s)}}return R(r,a.k)?e.bitmap===i?void 0:{type:$,bitmap:e.bitmap^i,array:Le(e.array,s)}:e}function on(e,t){const n=We(e,t);if(n<0)return e;if(e.array.length!==1)return{type:H,hash:e.hash,array:Le(e.array,n)}}function ht(e,t){if(e===void 0)return;const n=e.array,r=n.length;for(let i=0;i<r;i++){const s=n[i];if(s!==void 0){if(s.type===_){t(s.v,s.k);continue}ht(s,t)}}}class E{static fromObject(t){const n=Object.keys(t);let r=E.new();for(let i=0;i<n.length;i++){const s=n[i];r=r.set(s,t[s])}return r}static fromMap(t){let n=E.new();return t.forEach((r,i)=>{n=n.set(i,r)}),n}static new(){return new E(void 0,0)}constructor(t,n){this.root=t,this.size=n}get(t,n){if(this.root===void 0)return n;const r=me(this.root,0,A(t),t);return r===void 0?n:r.v}set(t,n){const r={val:!1},i=this.root===void 0?qe:this.root,s=le(i,0,A(t),t,n,r);return s===this.root?this:new E(s,r.val?this.size+1:this.size)}delete(t){if(this.root===void 0)return this;const n=Be(this.root,0,A(t),t);return n===this.root?this:n===void 0?E.new():new E(n,this.size-1)}has(t){return this.root===void 0?!1:me(this.root,0,A(t),t)!==void 0}entries(){if(this.root===void 0)return[];const t=[];return this.forEach((n,r)=>t.push([r,n])),t}forEach(t){ht(this.root,t)}hashCode(){let t=0;return this.forEach((n,r)=>{t=t+Ie(A(n),A(r))|0}),t}equals(t){if(!(t instanceof E)||this.size!==t.size)return!1;let n=!0;return this.forEach((r,i)=>{n=n&&R(t.get(i,!r),r)}),n}}const dt=void 0,et={};function fn(e){return/^[-+]?(\d+)$/.test(e)?new d(parseInt(e)):new y(dt)}function hn(e){return e.toString()}function dn(e){return V.fromArray(Array.from(pn(e)).map(t=>t.segment))}function pn(e){if(Intl&&Intl.Segmenter)return new Intl.Segmenter().segment(e)[Symbol.iterator]()}function mn(e){let t="";for(const n of e)t=t+n;return t}function Ve(e,t){return e.indexOf(t)>=0}function wn(){return E.new()}function pt(e,t){const n=e.get(t,et);return n===et?new y(dt):new d(n)}function yn(e,t,n){return n.set(e,t)}function mt(e){if(typeof e=="string")return"String";if(e instanceof ue)return"Result";if(e instanceof V)return"List";if(e instanceof pe)return"BitArray";if(e instanceof E)return"Map";if(Number.isInteger(e))return"Int";if(Array.isArray(e))return`Tuple of ${e.length} elements`;if(typeof e=="number")return"Float";if(e===null)return"Null";if(e===void 0)return"Nil";{const t=typeof e;return t.charAt(0).toUpperCase()+t.slice(1)}}function He(e,t){return gn(e,mt(t))}function gn(e,t){return new y(V.fromArray([new Ye(e,t,V.fromArray([]))]))}function _n(e){return typeof e=="string"?new d(e):He("String",e)}function bn(e){return Number.isInteger(e)?new d(e):He("Int",e)}function xn(e,t){const n=()=>He("Map",e);if(e instanceof E||e instanceof WeakMap||e instanceof Map){const r=pt(e,t);return new d(r.isOk()?new Me(r[0]):new Ze)}else return Object.getPrototypeOf(e)==Object.prototype?tt(e,t,()=>new d(new Ze)):tt(e,t,n)}function tt(e,t,n){try{return t in e?new d(new Me(e[t])):n()}catch{return n()}}function $n(e){return fn(e)}function wt(e){return hn(e)}function je(){return wn()}function we(e,t){return pt(e,t)}function nt(e,t,n){return yn(t,n,e)}function On(e,t){for(;;){let n=e,r=t;if(n.hasLength(0))return r;if(n.atLeastLength(1)){let i=n.head;e=n.tail,t=f([i],r)}else throw o("case_no_match","gleam/list",124,"do_reverse_acc","No case clause matched",{values:[n]})}}function An(e){return On(e,f([]))}function Nn(e){return An(e)}function kn(e,t,n){for(;;){let r=e,i=t,s=n;if(r.hasLength(0))return Nn(s);if(r.atLeastLength(1)){let a=r.head;e=r.tail,t=i,n=f([i(a)],s)}else throw o("case_no_match","gleam/list",361,"do_map","No case clause matched",{values:[r]})}}function En(e,t){return kn(e,t,f([]))}function Sn(e,t,n){for(;;){let r=e,i=t,s=n;if(r.hasLength(0))return i;if(r.atLeastLength(1)){let a=r.head;e=r.tail,t=s(i,a),n=s}else throw o("case_no_match","gleam/list",726,"fold","No case clause matched",{values:[r]})}}function oe(e,t){if(e.isOk()){let n=e[0];return new d(t(n))}else{if(e.isOk())throw o("case_no_match","gleam/result",67,"map","No case clause matched",{values:[e]});{let n=e[0];return new y(n)}}}function In(e,t){if(e.isOk()){let n=e[0];return new d(n)}else{if(e.isOk())throw o("case_no_match","gleam/result",95,"map_error","No case clause matched",{values:[e]});{let n=e[0];return new y(t(n))}}}function D(e,t){if(e.isOk()){let n=e[0];return t(n)}else{if(e.isOk())throw o("case_no_match","gleam/result",162,"try","No case clause matched",{values:[e]});{let n=e[0];return new y(n)}}}function ye(e,t){if(e.isOk())return e[0];if(e.isOk())throw o("case_no_match","gleam/result",215,"lazy_unwrap","No case clause matched",{values:[e]});return t()}function Ln(e,t){if(e.isOk())return e;if(e.isOk())throw o("case_no_match","gleam/result",308,"or","No case clause matched",{values:[e]});return t}function yt(e,t){if(e.isOk()){let n=e[0];return new d(n)}else{if(e.isOk())throw o("case_no_match","gleam/result",428,"replace_error","No case clause matched",{values:[e]});return new y(t)}}function gt(e){return mn(e)}function _t(e){return e}class Ye extends p{constructor(t,n,r){super(),this.expected=t,this.found=n,this.path=r}}function bt(e){return e}function xt(e){return _n(e)}function $t(e){return mt(e)}function jn(e){return bn(e)}function Ot(e){return t=>{if(e.hasLength(0))return new y(f([new Ye("another type",$t(t),f([]))]));if(e.atLeastLength(1)){let n=e.head,r=e.tail,i=n(t);if(i.isOk()){let s=i[0];return new d(s)}else{if(i.isOk())throw o("case_no_match","gleam/dynamic",1014,"","No case clause matched",{values:[i]});return Ot(r)(t)}}else throw o("case_no_match","gleam/dynamic",1007,"","No case clause matched",{values:[e]})}}function Cn(e,t){let n=bt(t),r=Ot(f([xt,s=>oe(jn(s),wt)])),i=(()=>{let s=r(n);if(s.isOk())return s[0];if(s.isOk())throw o("case_no_match","gleam/dynamic",598,"push_path","No case clause matched",{values:[s]});{let a=f(["<",$t(n),">"]),u=gt(a);return _t(u)}})();return e.withFields({path:f([i],e.path)})}function zn(e,t){return In(e,n=>En(n,t))}function rt(e,t){return n=>{let r=new Ye("field","nothing",f([]));return D(xn(n,e),i=>{let a=Kt(i,f([r])),u=D(a,t);return zn(u,c=>Cn(c,e))})}}function Tn(e,t){return n=>t(e(n))}class vn extends p{constructor(t){super(),this.all=t}}function it(){return new vn(f([]))}function F(e,t,n,r){return t[3]?(e==null?void 0:e.nodeType)===1&&e.nodeName===t[0].toUpperCase()&&e.namespaceURI===t[3]?at(e,t,t[3],n,r):st(e,t,t[3],n,r):t[2]?(e==null?void 0:e.nodeType)===1&&e.nodeName===t[0].toUpperCase()?at(e,t,null,n,r):st(e,t,null,n,r):typeof(t==null?void 0:t[0])=="string"?(e==null?void 0:e.nodeType)===3?Dn(e,t):Mn(e,t):document.createComment(["[internal lustre error] I couldn't work out how to render this element. This","function should only be called internally by lustre's runtime: if you think","this is an error, please open an issue at","https://github.com/hayleigh-dot-dev/gleam-lustre/issues/new"].join(" "))}function st(e,t,n,r,i=null){const s=n?document.createElementNS(n,t[0]):document.createElement(t[0]);s.$lustre={};let a=t[1];for(;a.head;)a.head[0]==="class"?ne(s,a.head[0],`${s.className} ${a.head[1]}`):a.head[0]==="style"?ne(s,a.head[0],`${s.style.cssText} ${a.head[1]}`):ne(s,a.head[0],a.head[1],r),a=a.tail;if(customElements.get(t[0]))s._slot=t[2];else if(t[0]==="slot"){let u=new ge,c=i;for(;c;)if(c._slot){u=c._slot;break}else c=c.parentNode;for(;u.head;)s.appendChild(F(null,u.head,r,s)),u=u.tail}else{let u=t[2];for(;u.head;)s.appendChild(F(null,u.head,r,s)),u=u.tail}return e&&e.replaceWith(s),s}function at(e,t,n,r,i){const s=e.attributes,a=new Map;e.$lustre??(e.$lustre={});let u=t[1];for(;u.head;)u.head[0]==="class"&&a.has("class")?a.set(u.head[0],`${a.get("class")} ${u.head[1]}`):u.head[0]==="style"&&a.has("style")?a.set(u.head[0],`${a.get("style")} ${u.head[1]}`):a.set(u.head[0],u.head[1]),u=u.tail;for(const{name:c,value:l}of s)if(!a.has(c))e.removeAttribute(c);else{const h=a.get(c);h!==l&&(ne(e,c,h,r),a.delete(c))}for(const[c,l]of a)ne(e,c,l,r);if(customElements.get(t[0]))e._slot=t[2];else if(t[0]==="slot"){let c=e.firstChild,l=new ge,h=i;for(;h;)if(h._slot){l=h._slot;break}else h=h.parentNode;for(;c;)l.head&&(F(c,l.head,r,e),l=l.tail),c=c.nextSibling;for(;l.head;)e.appendChild(F(null,l.head,r,e)),l=l.tail}else{let c=e.firstChild,l=t[2];for(;c;)if(l.head){const h=c.nextSibling;F(c,l.head,r,e),l=l.tail,c=h}else{const h=c.nextSibling;c.remove(),c=h}for(;l.head;)e.appendChild(F(null,l.head,r,e)),l=l.tail}return e}function ne(e,t,n,r){switch(typeof n){case"string":e.getAttribute(t)!==n&&e.setAttribute(t,n),n===""&&e.removeAttribute(t),t==="value"&&e.value!==n&&(e.value=n);break;case(t.startsWith("on")&&"function"):{if(e.$lustre[t]===n)break;const i=t.slice(2).toLowerCase(),s=a=>oe(n(a),r);e.$lustre[`${t}Handler`]&&e.removeEventListener(i,e.$lustre[`${t}Handler`]),e.addEventListener(i,s),e.$lustre[t]=n,e.$lustre[`${t}Handler`]=s;break}default:e[t]=n}}function Mn(e,t){const n=document.createTextNode(t[0]);return e&&e.replaceWith(n),n}function Dn(e,t){const n=e.nodeValue,r=t[0];return r?(n!==r&&(e.nodeValue=r),e):(e==null||e.remove(),null)}var x,z,T,v,M,ie,K,X,se,Ce,ae,ze;class Rn{constructor(t,n,r){O(this,se);O(this,ae);O(this,x,null);O(this,z,null);O(this,T,[]);O(this,v,[]);O(this,M,!1);O(this,ie,null);O(this,K,null);O(this,X,null);w(this,ie,t),w(this,K,n),w(this,X,r)}start(t,n){if(!Un())return new y(new er);if(m(this,x))return new y(new Jn);if(w(this,x,t instanceof HTMLElement?t:document.querySelector(t)),!m(this,x))return new y(new Qn);const[r,i]=m(this,ie).call(this,n);return w(this,z,r),w(this,v,i.all.toArray()),w(this,M,!0),window.requestAnimationFrame(()=>ee(this,se,Ce).call(this)),new d(s=>this.dispatch(s))}dispatch(t){m(this,T).push(t),ee(this,se,Ce).call(this)}emit(t,n=null){m(this,x).dispatchEvent(new CustomEvent(t,{bubbles:!0,detail:n,composed:!0}))}destroy(){if(!m(this,x))return new y(new Zn);m(this,x).remove(),w(this,x,null),w(this,z,null),w(this,T,[]),w(this,v,[]),w(this,M,!1),w(this,K,()=>{}),w(this,X,()=>{})}}x=new WeakMap,z=new WeakMap,T=new WeakMap,v=new WeakMap,M=new WeakMap,ie=new WeakMap,K=new WeakMap,X=new WeakMap,se=new WeakSet,Ce=function(){if(ee(this,ae,ze).call(this),m(this,M)){const t=m(this,X).call(this,m(this,z));w(this,x,F(m(this,x),t,n=>this.dispatch(n))),w(this,M,!1)}},ae=new WeakSet,ze=function(t=0){if(m(this,x)){if(m(this,T).length)for(;m(this,T).length;){const[n,r]=m(this,K).call(this,m(this,z),m(this,T).shift());m(this,M)||w(this,M,m(this,z)!==n),w(this,z,n),w(this,v,m(this,v).concat(r.all.toArray()))}for(;m(this,v).length;)m(this,v).shift()(n=>this.dispatch(n),(n,r)=>this.emit(n,r));m(this,T).length&&(t>=5?console.warn(tooManyUpdates):ee(this,ae,ze).call(this,++t))}};const qn=(e,t,n)=>new Rn(e,t,n),Fn=(e,t,n)=>e.start(t,n),Un=()=>window&&window.document;function At(e){let n=gt(e);return _t(n)}class Wn extends p{constructor(t,n,r){super(),this[0]=t,this[1]=n,this.as_property=r}}class Bn extends p{constructor(t,n){super(),this[0]=t,this[1]=n}}function be(e,t){return new Wn(e,bt(t),!1)}function Vn(e,t){return new Bn("on"+e,Tn(t,n=>yt(n,void 0)))}function Hn(e){return be("style",Sn(e,"",(t,n)=>{let r=n[0],i=n[1];return t+r+":"+i+";"}))}function Yn(e){return be("id",e)}function Pn(e){return be("placeholder",e)}function Kn(e){return be("href",e)}class Xn extends p{constructor(t){super(),this[0]=t}}class Gn extends p{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}}function Z(e,t,n){return new Gn(e,t,n)}function q(e){return new Xn(e)}class Jn extends p{}class Zn extends p{}class Qn extends p{}class er extends p{}function tr(e,t,n){return qn(s=>[e(s),it()],(s,a)=>[t(s,a),it()],n)}function Ee(e,t){return Z("div",e,t)}function nr(e,t){return Z("p",e,t)}function rr(e,t){return Z("a",e,t)}function ir(e){return Z("br",e,f([]))}function sr(e,t){return Z("strong",e,t)}function ar(e){return Z("textarea",e,f([]))}function ur(e,t){return Vn(e,t)}function cr(e){let t=e;return rt("target",rt("value",xt))(t)}function lr(e){return ur("input",t=>{let n=cr(t);return oe(n,e)})}class Te extends p{constructor(t){super(),this.error=t}}class fe extends p{constructor(t,n){super(),this.row=t,this.col=n}}class S extends p{constructor(t){super(),this.parse=t}}function b(e,t,n){if(e instanceof S){let r=e.parse;return r(t,n)}else throw o("case_no_match","party",37,"run","No case clause matched",{values:[e]})}function xe(e){return new S((t,n)=>{if(!(n instanceof fe))throw o("assignment_no_match","party",58,"","Assignment pattern did not match",{value:n});let r=n.row,i=n.col;if(t.atLeastLength(1)){let s=t.head,a=t.tail,u=e(s);if(u)return s===`
`?new d([s,a,new fe(r+1,0)]):new d([s,a,new fe(r,i+1)]);if(u)throw o("case_no_match","party",61,"","No case clause matched",{values:[u]});return new y(new Te(s))}else{if(t.hasLength(0))return new y(new Te("EOF"));throw o("case_no_match","party",59,"","No case clause matched",{values:[t]})}})}function j(e){return xe(t=>e===t)}function Pe(e,t){return new S((n,r)=>Ln(b(e,n,r),b(t,n,r)))}function Ke(e){return new S((t,n)=>{if(e.hasLength(0))return new y(new Te("choiceless choice"));if(e.hasLength(1)){let r=e.head;return b(r,t,n)}else if(e.atLeastLength(1)){let r=e.head,i=e.tail,s=b(r,t,n);if(s.isOk()){let a=s[0][0],u=s[0][1],c=s[0][2];return new d([a,u,c])}else{if(s.isOk())throw o("case_no_match","party",111,"","No case clause matched",{values:[s]});return b(Ke(i),t,n)}}else throw o("case_no_match","party",107,"","No case clause matched",{values:[e]})})}function Xe(e){return new S((t,n)=>{let r=b(e,t,n);if(r.isOk())if(r.isOk()){let i=r[0][0],s=r[0][1],a=r[0][2];return oe(b(Xe(e),s,a),u=>[f([i],u[0]),u[1],u[2]])}else throw o("case_no_match","party",140,"","No case clause matched",{values:[r]});else return new d([f([]),t,n])})}function Nt(e){return new S((t,n)=>{let r=b(e,t,n);if(r.isOk())if(r.isOk()){let i=r[0][0],s=r[0][1],a=r[0][2];return oe(b(Xe(e),s,a),u=>[f([i],u[0]),u[1],u[2]])}else throw o("case_no_match","party",155,"","No case clause matched",{values:[r]});else{let i=r[0];return new y(i)}})}function te(e,t){return new S((n,r)=>{let i=b(e,n,r);if(i.isOk()){let s=i[0][0],a=i[0][1],u=i[0][2];return new d([t(s),a,u])}else{if(i.isOk())throw o("case_no_match","party",175,"","No case clause matched",{values:[i]});{let s=i[0];return new y(s)}}})}function or(e){return new S((t,n)=>{let r=b(e,t,n);if(r.isOk()){let i=r[0][0],s=r[0][1],a=r[0][2];return new d([new d(i),s,a])}else{if(r.isOk())throw o("case_no_match","party",216,"","No case clause matched",{values:[r]});return new d([new y(void 0),t,n])}})}function Ge(e){return new S((t,n)=>b(e(),t,n))}function g(e,t){return new S((n,r)=>{let i=b(e,n,r);if(i.isOk()){let s=i[0][0],a=i[0][1],u=i[0][2];return b(t(s),a,u)}else{if(i.isOk())throw o("case_no_match","party",287,"","No case clause matched",{values:[i]});{let s=i[0];return new y(s)}}})}function W(e){return new S((t,n)=>new d([e,t,n]))}function fr(e,t){let n=b(e,dn(t),new fe(1,1));if(n.isOk()){let r=n[0][0];return new d(r)}else{if(n.isOk())throw o("case_no_match","party",44,"go","No case clause matched",{values:[n]});{let r=n[0];return new y(r)}}}function hr(){return xe(e=>Ve("abcdefghijklmnopqrstuvwxyz",e))}function dr(){return xe(e=>Ve("ABCDEFGHIJKLMNOPQRSTUVWXYZ",e))}function kt(){return Pe(hr(),dr())}function Et(){return xe(e=>Ve("0123456789",e))}function pr(){return Pe(Et(),kt())}class St extends p{constructor(t){super(),this[0]=t}}class It extends p{constructor(t){super(),this[0]=t}}class Lt extends p{constructor(t,n){super(),this[0]=t,this[1]=n}}class jt extends p{constructor(t,n){super(),this[0]=t,this[1]=n}}class Ct extends p{constructor(t){super(),this.int=t}}class Y extends p{constructor(t,n){super(),this.gen=t,this.val=n}}class $e extends p{constructor(t){super(),this[0]=t}}class re extends p{constructor(t){super(),this[0]=t}}class B extends p{constructor(t,n){super(),this[0]=t,this[1]=n}}class J extends p{constructor(t,n){super(),this[0]=t,this[1]=n}}function mr(){let e=Nt(Et()),t=te(e,At),n=te(t,$n),r=te(n,i=>ye(i,()=>{throw o("todo","tinylang",18,"","parsed int isn't an int",{})}));return te(r,i=>new St(i))}function zt(){return g(kt(),e=>g(Nt(Pe(pr(),j("_"))),t=>W(e+At(t))))}function wr(){let e=zt();return te(e,t=>new It(t))}function P(){return g(Xe(Ke(f([j(" "),j("	"),j(`
`)]))),e=>W(void 0))}function yr(e,t){return t(new Ct(e.int+1),e.int)}function ut(e,t){return new Y(t,e)}function ct(e,t){return new d(new Y(e,t()))}function he(e,t,n,r){if(t instanceof St){let i=t[0];return new d((()=>{let s=[new $e(i),r];return ut(s,e)})())}else if(t instanceof It){let i=t[0],s=we(n,i);if(s.isOk()){let a=s[0];return new d((()=>{let u=[new re(a),r];return ut(u,e)})())}else{if(!s.isOk()&&!s[0])return new y("Wait! "+i+" isn't defined anywhere!");throw o("case_no_match","tinylang",131,"translate_helper","No case clause matched",{values:[s]})}}else if(t instanceof Lt){let i=t[0],s=t[1];return yr(e,(a,u)=>D(he(a,s,nt(n,i,u),r),c=>{if(!(c instanceof Y))throw o("assignment_no_match","tinylang",141,"","Assignment pattern did not match",{value:c});let l=c.gen,h=c.val[0],C=c.val[1];return ct(l,()=>[new B(u,h),nt(C,u,i)])}))}else if(t instanceof jt){let i=t[0],s=t[1];return D(he(e,i,n,r),a=>{if(!(a instanceof Y))throw o("assignment_no_match","tinylang",151,"","Assignment pattern did not match",{value:a});let u=a.gen,c=a.val[0],l=a.val[1];return D(he(u,s,n,l),h=>{if(!(h instanceof Y))throw o("assignment_no_match","tinylang",157,"","Assignment pattern did not match",{value:h});let C=h.gen,k=h.val[0],Q=h.val[1];return ct(C,()=>[new J(c,k),Q])})})}else throw o("case_no_match","tinylang",124,"translate_helper","No case clause matched",{values:[t]})}function gr(e,t){return D(he(e,t,je(),je()),n=>{if(!(n instanceof Y))throw o("assignment_no_match","tinylang",109,"","Assignment pattern did not match",{value:n});let r=n.val;return new d(r)})}function Tt(e,t,n){let r=i=>Tt(e,t,i);if(n instanceof re&&n[0]===e)return n[0],t;if(n instanceof B&&n[0]===e)return n[0],n;if(n instanceof B){let i=n[0],s=n[1];return new B(i,r(s))}else if(n instanceof J){let i=n[0],s=n[1];return new J(r(i),r(s))}else{if(n instanceof re)return n;if(n instanceof $e)return n;throw o("case_no_match","tinylang",194,"substitute","No case clause matched",{values:[n]})}}function ve(e,t){if(e instanceof $e)return e;if(e instanceof B)return e;if(e instanceof re){let n=e[0];return ye(we(t,n),()=>{throw o("todo","tinylang",179,"","undefined after renaming",{})})}else if(e instanceof J){let n=e[0],r=e[1],i=ve(n,t),s=ve(r,t);if(i instanceof B){let a=i[0],u=i[1];return Tt(a,s,u)}else return new J(i,s)}else throw o("case_no_match","tinylang",174,"eval_helper","No case clause matched",{values:[e]})}function _r(e){return ve(e,je())}function de(e,t){if(e instanceof $e){let n=e[0];return wt(n)}else if(e instanceof re){let n=e[0];return ye(we(t,n),()=>{throw o("todo","tinylang",209,"","identifier with no rename",{})})}else if(e instanceof B){let n=e[0],r=e[1];return"\\"+ye(we(t,n),()=>{throw o("todo","tinylang",214,"","parameter with no rename",{})})+". "+de(r,t)}else if(e instanceof J){let n=e[0],r=e[1];return de(n,t)+"("+de(r,t)+")"}else throw o("case_no_match","tinylang",204,"pretty","No case clause matched",{values:[e]})}function br(e){if(e.isOk())return e[0];if(e.isOk())throw o("case_no_match","tinylang",222,"squash_res","No case clause matched",{values:[e]});return e[0]}function Oe(){return g(P(),e=>g(Ke(f([mr(),wr(),xr(),$r()])),t=>g(P(),n=>g(or(j("(")),r=>g((()=>{if(r.isOk())return g(Ge(Oe),i=>g(j(")"),s=>W(new jt(t,i))));if(!r.isOk()&&!r[0])return W(t);throw o("case_no_match","tinylang",54,"","No case clause matched",{values:[r]})})(),i=>g(P(),s=>W(i)))))))}function xr(){return g(j("\\"),e=>g(P(),t=>g(zt(),n=>g(P(),r=>g(j("."),i=>g(P(),s=>g(Ge(Oe),a=>W(new Lt(n,a)))))))))}function $r(){return g(j("("),e=>g(Ge(Oe),t=>g(j(")"),n=>W(t))))}function Or(e){let t=D(yt(fr(Oe(),e),"there's a mistake in the notation somewhere; I couldn't understand it!"),n=>D(gr(new Ct(0),n),r=>{let i=r[0],s=r[1],a=_r(i);return new d(de(a,s))}));return br(t)}class vt extends p{constructor(t){super(),this[0]=t}}function Ar(e){return""}function Nr(e,t){if(t instanceof vt)return t[0];throw o("case_no_match","ryanbrewerdev",31,"update","No case clause matched",{values:[t]})}function kr(e){return Ee(f([]),f([nr(f([]),f([q("This is my website. It's hosted by Firebase and written mostly in Gleam, and the code is up on "),rr(f([Kn("https://github.com/RyanBrewer317/ryanbrewer-dev")]),f([q("my github")])),q(".")])),ar(f([Yn("code"),Pn("Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)(3)"),lr(t=>new vt(t))])),ir(f([])),(()=>{if(e==="")return q("");{let n=Or(e);return(r=>Ee(f([]),f([sr(f([]),f([q("output ")])),q(" (variables may be renamed): "),Ee(f([Hn(f([["margin","4pt 2pt"],["font-size","15pt"],["font-family","FreeMono, monospace"]]))]),f([q(r)]))])))(n)}})()]))}function Er(){let e=tr(Ar,Nr,kr),t=Fn(e,"[data-lustre-app]",void 0);if(!t.isOk())throw o("assignment_no_match","ryanbrewerdev",14,"main","Assignment pattern did not match",{value:t});return t[0]}document.addEventListener("DOMContentLoaded",()=>{Er()});