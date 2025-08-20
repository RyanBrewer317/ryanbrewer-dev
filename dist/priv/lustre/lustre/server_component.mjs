import * as $process from "../../gleam_erlang/gleam/erlang/process.mjs";
import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $decode from "../../gleam_stdlib/gleam/dynamic/decode.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";
import * as $lustre from "../lustre.mjs";
import * as $attribute from "../lustre/attribute.mjs";
import { attribute } from "../lustre/attribute.mjs";
import * as $effect from "../lustre/effect.mjs";
import * as $element from "../lustre/element.mjs";
import * as $html from "../lustre/element/html.mjs";
import * as $runtime from "../lustre/runtime/server/runtime.mjs";
import * as $transport from "../lustre/runtime/transport.mjs";
import * as $vattr from "../lustre/vdom/vattr.mjs";
import { Event } from "../lustre/vdom/vattr.mjs";

export class WebSocket extends $CustomType {}

export class ServerSentEvents extends $CustomType {}

export class Polling extends $CustomType {}

export function element(attributes, children) {
  return $element.element("lustre-server-component", attributes, children);
}

export function script() {
  return $html.script(
    toList([$attribute.type_("module")]),
    "var yt=5,te=Math.pow(2,yt),Nn=te-1,In=te/2,Mn=te/4;var Te=[\" \",\"	\",`\\n`,\"\\v\",\"\\f\",\"\\r\",\"\\x85\",\"\\u2028\",\"\\u2029\"].join(\"\"),Er=new RegExp(`^[${Te}]*`),Sr=new RegExp(`[${Te}]*$`);var k=()=>globalThis?.document,ue=\"http://www.w3.org/1999/xhtml\";var qe=!!globalThis.HTMLElement?.prototype?.moveBefore;var Ve=0;var He=1;var We=2;var Ge=0;var ce=2;var w=0;var Y=1;var ae=2;var Je=3;var fe=\"	\";var Ze=0;var et=1;var tt=2;var nt=3;var rt=4;var it=5;var st=6;var an=globalThis.setTimeout,de=globalThis.clearTimeout,fn=(s,e)=>k().createElementNS(s,e),pn=s=>k().createTextNode(s),dn=()=>k().createDocumentFragment(),O=(s,e,n)=>s.insertBefore(e,n),ot=qe?(s,e,n)=>s.moveBefore(e,n):O,_n=(s,e)=>s.removeChild(e),hn=(s,e)=>s.getAttribute(e),lt=(s,e,n)=>s.setAttribute(e,n),mn=(s,e)=>s.removeAttribute(e),xn=(s,e,n,r)=>s.addEventListener(e,n,r),ct=(s,e,n)=>s.removeEventListener(e,n),bn=(s,e)=>s.innerHTML=e,$n=(s,e)=>s.data=e,g=Symbol(\"lustre\"),he=class{constructor(e,n,r,t){this.kind=e,this.key=t,this.parent=n,this.children=[],this.node=r,this.handlers=new Map,this.throttles=new Map,this.debouncers=new Map}get parentNode(){return this.kind===w?this.node.parentNode:this.node}};var X=(s,e,n,r,t)=>{let i=new he(s,e,n,t);return n[g]=i,e?.children.splice(r,0,i),i},wn=s=>{let e=\"\";for(let n=s[g];n.parent;n=n.parent)if(n.key)e=`${fe}${n.key}${e}`;else{let r=n.parent.children.indexOf(n);e=`${fe}${r}${e}`}return e.slice(1)},D=class{#r=null;#e=()=>{};#n=!1;#t=!1;constructor(e,n,{useServerEvents:r=!1,exposeKeys:t=!1}={}){this.#r=e,this.#e=n,this.#n=r,this.#t=t}mount(e){console.log(\"mount\",e),X(Y,null,this.#r,0,null),this.#x(this.#r,null,this.#r[g],0,e)}push(e){this.#i.push({node:this.#r[g],patch:e}),this.#s()}#i=[];#s(){let e=this.#i;for(;e.length;){let{node:n,patch:r}=e.pop(),{children:t}=n,{changes:i,removed:u,children:o}=r;S(i,l=>this.#u(n,l)),u&&this.#a(n,t.length-u,u),S(o,l=>{let x=t[l.index|0];this.#i.push({node:x,patch:l})})}}#u(e,n){switch(n.kind){case Ze:this.#k(e,n);break;case et:this.#b(e,n);break;case tt:this.#y(e,n);break;case nt:this.#l(e,n);break;case rt:this.#h(e,n);break;case it:this.#f(e,n);break;case st:this.#p(e,n);break}}#p(e,{children:n,before:r}){let t=dn(),i=this.#o(e,r);this.#m(t,null,e,r|0,n),O(e.parentNode,t,i)}#f(e,{index:n,with:r}){this.#a(e,n|0,1);let t=this.#o(e,n);this.#x(e.parentNode,t,e,n|0,r)}#o(e,n){n=n|0;let{children:r}=e,t=r.length;if(n<t)return r[n].node;let i=r[t-1];if(!i&&e.kind!==w)return null;for(i||(i=e);i.kind===w&&i.children.length;)i=i.children[i.children.length-1];return i.node.nextSibling}#l(e,{key:n,before:r}){r=r|0;let{children:t,parentNode:i}=e,u=t[r].node,o=t[r];for(let $=r+1;$<t.length;++$){let _=t[$];if(t[$]=o,o=_,_.key===n){t[r]=_;break}}let{kind:l,node:x,children:v}=o;ot(i,x,u),l===w&&this.#c(i,v,u)}#c(e,n,r){for(let t=0;t<n.length;++t){let{kind:i,node:u,children:o}=n[t];ot(e,u,r),i===w&&this.#c(e,o,r)}}#h(e,{index:n}){this.#a(e,n,1)}#a(e,n,r){let{children:t,parentNode:i}=e,u=t.splice(n,r);for(let o=0;o<u.length;++o){let{kind:l,node:x,children:v}=u[o];_n(i,x),this.#d(u[o]),l===w&&u.push(...v)}}#d(e){let{debouncers:n,children:r}=e;for(let{timeout:t}of n.values())t&&de(t);n.clear(),S(r,t=>this.#d(t))}#y({node:e,handlers:n,throttles:r,debouncers:t},{added:i,removed:u}){S(u,({name:o})=>{n.delete(o)?(ct(e,o,_e),this.#_(r,o,0),this.#_(t,o,0)):(mn(e,o),ft[o]?.removed?.(e,o))}),S(i,o=>this.#g(e,o))}#k({node:e},{content:n}){$n(e,n??\"\")}#b({node:e},{inner_html:n}){bn(e,n??\"\")}#m(e,n,r,t,i){S(i,u=>this.#x(e,n,r,t++,u))}#x(e,n,r,t,i){switch(i.kind){case Y:{let u=this.#$(r,t,i);this.#m(u,null,u[g],0,i.children),O(e,u,n);break}case ae:{let u=this.#w(r,t,i);O(e,u,n);break}case w:{let u=this.#w(r,t,i);O(e,u,n),this.#m(e,n,u[g],0,i.children);break}case Je:{let u=this.#$(r,t,i);this.#b({node:u},i),O(e,u,n);break}}}#$(e,n,{kind:r,key:t,tag:i,namespace:u,attributes:o}){let l=fn(u||ue,i);return X(r,e,l,n,t),this.#t&&t&&lt(l,\"data-lustre-key\",t),S(o,x=>this.#g(l,x)),l}#w(e,n,{kind:r,key:t,content:i}){let u=pn(i??\"\");return X(r,e,u,n,t),u}#g(e,n){let{debouncers:r,handlers:t,throttles:i}=e[g],{kind:u,name:o,value:l,prevent_default:x,debounce:v,throttle:$}=n;switch(u){case Ve:{let _=l??\"\";if(o===\"virtual:defaultValue\"){e.defaultValue=_;return}_!==hn(e,o)&&lt(e,o,_),ft[o]?.added?.(e,_);break}case He:e[o]=l;break;case We:{t.has(o)&&ct(e,o,_e);let _=x.kind===Ge;xn(e,o,_e,{passive:_}),this.#_(i,o,$),this.#_(r,o,v),t.set(o,y=>this.#v(n,y));break}}}#_(e,n,r){let t=e.get(n);if(r>0)t?t.delay=r:e.set(n,{delay:r});else if(t){let{timeout:i}=t;i&&de(i),e.delete(n)}}#v(e,n){let{currentTarget:r,type:t}=n,{debouncers:i,throttles:u}=r[g],o=wn(r),{prevent_default:l,stop_propagation:x,include:v,immediate:$}=e;l.kind===ce&&n.preventDefault(),x.kind===ce&&n.stopPropagation(),t===\"submit\"&&(n.detail??={},n.detail.formData=[...new FormData(n.target).entries()]);let _=this.#n?gn(n,v??[]):n,y=u.get(t);if(y){let we=Date.now(),gt=y.last||0;we>gt+y.delay&&(y.last=we,y.lastEvent=n,this.#e(_,o,t,$))}let T=i.get(t);T&&(de(T.timeout),T.timeout=an(()=>{n!==u.get(t)?.lastEvent&&this.#e(_,o,t,$)},T.delay)),!y&&!T&&this.#e(_,o,t,$)}},S=(s,e)=>{if(Array.isArray(s))for(let n=0;n<s.length;n++)e(s[n]);else if(s)for(s;s.head;s=s.tail)e(s.head)},_e=s=>{let{currentTarget:e,type:n}=s;e[g].handlers.get(n)(s)},gn=(s,e=[])=>{let n={};(s.type===\"input\"||s.type===\"change\")&&e.push(\"target.value\"),s.type===\"submit\"&&e.push(\"detail.formData\");for(let r of e){let t=r.split(\".\");for(let i=0,u=s,o=n;i<t.length;i++){if(i===t.length-1){o[t[i]]=u[t[i]];break}o=o[t[i]]??={},u=u[t[i]]}}return n},at=s=>({added(e){e[s]=!0},removed(e){e[s]=!1}}),yn=s=>({added(e,n){e[s]=n}}),ft={checked:at(\"checked\"),selected:at(\"selected\"),value:yn(\"value\"),autofocus:{added(s){queueMicrotask(()=>{s.focus?.()})}},autoplay:{added(s){try{s.play?.()}catch(e){console.error(e)}}}};var pt=new WeakMap;async function dt(s){let e=[];for(let r of k().querySelectorAll(\"link[rel=stylesheet], style\"))r.sheet||e.push(new Promise((t,i)=>{r.addEventListener(\"load\",t),r.addEventListener(\"error\",i)}));if(await Promise.allSettled(e),!s.host.isConnected)return[];s.adoptedStyleSheets=s.host.getRootNode().adoptedStyleSheets;let n=[];for(let r of k().styleSheets)try{s.adoptedStyleSheets.push(r)}catch{try{let t=pt.get(r);if(!t){t=new CSSStyleSheet;for(let i of r.cssRules)t.insertRule(i.cssText,t.cssRules.length);pt.set(r,t)}s.adoptedStyleSheets.push(t)}catch{let t=r.ownerNode.cloneNode();s.prepend(t),n.push(t)}}return n}var K=class extends Event{constructor(e,n,r){super(\"context-request\",{bubbles:!0,composed:!0}),this.context=e,this.callback=n,this.subscribe=r}};var _t=0;var ht=1;var mt=2;var xt=3;var Z=0;var bt=1;var $t=2;var ee=3;var wt=4;var me=class extends HTMLElement{static get observedAttributes(){return[\"route\",\"method\"]}#r;#e=\"ws\";#n=null;#t=null;#i=[];#s;#u=new Set;#p=new Set;#f=!1;#o=[];#l=new Map;#c=new Set;#h=new MutationObserver(e=>{let n=[];for(let r of e){if(r.type!==\"attributes\")continue;let t=r.attributeName;(!this.#f||this.#u.has(t))&&n.push([t,this.getAttribute(t)])}if(n.length===1){let[r,t]=n[0];this.#t?.send({kind:Z,name:r,value:t})}else n.length?this.#t?.send({kind:ee,messages:n.map(([r,t])=>({kind:Z,name:r,value:t}))}):this.#o.push(...n)});constructor(){super(),this.internals=this.attachInternals(),this.#h.observe(this,{attributes:!0})}connectedCallback(){for(let e of this.attributes)this.#o.push([e.name,e.value])}attributeChangedCallback(e,n,r){switch(e){case(n!==r&&\"route\"):{this.#n=new URL(r,location.href),this.#a();return}case\"method\":{let t=r.toLowerCase();if(t==this.#e)return;[\"ws\",\"sse\",\"polling\"].includes(t)&&(this.#e=t,this.#e==\"ws\"&&(this.#n.protocol==\"https:\"&&(this.#n.protocol=\"wss:\"),this.#n.protocol==\"http:\"&&(this.#n.protocol=\"ws:\")),this.#a());return}}}async messageReceivedCallback(e){switch(e.kind){case _t:{for(this.#r??=this.attachShadow({mode:e.open_shadow_root?\"open\":\"closed\"});this.#r.firstChild;)this.#r.firstChild.remove();this.#s=new D(this.#r,(t,i,u)=>{this.#t?.send({kind:bt,path:i,name:u,event:t})},{useServerEvents:!0}),this.#u=new Set(e.observed_attributes);let r=this.#o.filter(([t])=>this.#u.has(t)).map(([t,i])=>({kind:Z,name:t,value:i}));this.#o=[],this.#p=new Set(e.observed_properties);for(let t of this.#p)Object.defineProperty(this,t,{get(){return this[`_${t}`]},set(i){this[`_${t}`]=i,this.#t?.send({kind:$t,name:t,value:i})}});for(let[t,i]of Object.entries(e.provided_contexts))this.provide(t,i);for(let t of[...new Set(e.requested_contexts)])this.dispatchEvent(new K(t,(i,u)=>{this.#t?.send({kind:wt,key:t,value:i}),this.#c.add(u)}));r.length&&this.#t.send({kind:ee,messages:r}),e.will_adopt_styles&&await this.#d(),this.#r.addEventListener(\"context-request\",t=>{if(!t.context||!t.callback||!this.#l.has(t.context))return;t.stopImmediatePropagation();let i=this.#l.get(t.context);if(t.subscribe){let u=new WeakRef(t.callback),o=()=>{i.subscribers=i.subscribers.filter(l=>l!==u)};i.subscribers.push([u,o]),t.callback(i.value,o)}else t.callback(i.value)}),this.#s.mount(e.vdom),this.dispatchEvent(new CustomEvent(\"lustre:mount\"));break}case ht:{this.#s.push(e.patch);break}case mt:{this.dispatchEvent(new CustomEvent(e.name,{detail:e.data}));break}case xt:{this.provide(e.key,e.value);break}}}disconnectedCallback(){for(let e of this.#c)e();this.#c.clear()}provide(e,n){if(!this.#l.has(e))this.#l.set(e,{value:n,subscribers:[]});else{let r=this.#l.get(e);r.value=n;for(let t=r.subscribers.length-1;t>=0;t--){let[i,u]=r.subscribers[t],o=i.deref();if(!o){r.subscribers.splice(t,1);continue}o(n,u)}}}#a(){if(!this.#n||!this.#e)return;this.#t&&this.#t.close();let t={onConnect:()=>{this.#f=!0,this.dispatchEvent(new CustomEvent(\"lustre:connect\"),{detail:{route:this.#n,method:this.#e}})},onMessage:i=>{this.messageReceivedCallback(i)},onClose:()=>{this.#f=!1,this.dispatchEvent(new CustomEvent(\"lustre:close\",{detail:{route:this.#n,method:this.#e}}))}};switch(this.#e){case\"ws\":this.#t=new xe(this.#n,t);break;case\"sse\":this.#t=new be(this.#n,t);break;case\"polling\":this.#t=new $e(this.#n,t);break}}async#d(){for(;this.#i.length;)this.#i.pop().remove(),this.#r.firstChild.remove();this.#i=await dt(this.#r)}},xe=class{#r;#e;#n=!1;#t=[];#i;#s;#u;constructor(e,{onConnect:n,onMessage:r,onClose:t}){this.#r=e,this.#e=new WebSocket(this.#r),this.#i=n,this.#s=r,this.#u=t,this.#e.onopen=()=>{this.#i()},this.#e.onmessage=({data:i})=>{try{this.#s(JSON.parse(i))}finally{this.#t.length?this.#e.send(JSON.stringify({kind:ee,messages:this.#t})):this.#n=!1,this.#t=[]}},this.#e.onclose=()=>{this.#u()}}send(e){if(this.#n||this.#e.readyState!==WebSocket.OPEN){this.#t.push(e);return}else this.#e.send(JSON.stringify(e)),this.#n=!0}close(){this.#e.close()}},be=class{#r;#e;#n;#t;#i;constructor(e,{onConnect:n,onMessage:r,onClose:t}){this.#r=e,this.#e=new EventSource(this.#r),this.#n=n,this.#t=r,this.#i=t,this.#e.onopen=()=>{this.#n()},this.#e.onmessage=({data:i})=>{try{this.#t(JSON.parse(i))}catch{}}}send(e){}close(){this.#e.close(),this.#i()}},$e=class{#r;#e;#n;#t;#i;#s;constructor(e,{onConnect:n,onMessage:r,onClose:t,...i}){this.#r=e,this.#t=n,this.#i=r,this.#s=t,this.#e=i.interval??5e3,this.#u().finally(()=>{this.#t(),this.#n=setInterval(()=>this.#u(),this.#e)})}async send(e){}close(){clearInterval(this.#n),this.#s()}#u(){return fetch(this.#r).then(e=>e.json()).then(this.#i).catch(console.error)}};customElements.define(\"lustre-server-component\",me);export{me as ServerComponent};",
  );
}

export function route(path) {
  return attribute("route", path);
}

export function method(value) {
  return attribute(
    "method",
    (() => {
      if (value instanceof WebSocket) {
        return "ws";
      } else if (value instanceof ServerSentEvents) {
        return "sse";
      } else {
        return "polling";
      }
    })(),
  );
}

export function include(event, properties) {
  if (event instanceof Event) {
    let _record = event;
    return new Event(
      _record.kind,
      _record.name,
      _record.handler,
      properties,
      _record.prevent_default,
      _record.stop_propagation,
      _record.immediate,
      _record.debounce,
      _record.throttle,
    );
  } else {
    return event;
  }
}

export function register_subject(client) {
  return new $runtime.ClientRegisteredSubject(client);
}

export function deregister_subject(client) {
  return new $runtime.ClientDeregisteredSubject(client);
}

export function register_callback(callback) {
  return new $runtime.ClientRegisteredCallback(callback);
}

export function deregister_callback(callback) {
  return new $runtime.ClientDeregisteredCallback(callback);
}

export function emit(event, data) {
  return $effect.event(event, data);
}

export function select(sel) {
  return $effect.select(sel);
}

export function runtime_message_decoder() {
  return $decode.map(
    $transport.server_message_decoder(),
    (var0) => { return new $runtime.ClientDispatchedMessage(var0); },
  );
}

export function client_message_to_json(message) {
  return $transport.client_message_to_json(message);
}
