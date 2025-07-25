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
    "var a=class{withFields(e){let n=Object.keys(this).map(t=>t in e?e[t]:this[t]);return new this.constructor(...n)}};var It=5,ne=Math.pow(2,It),zn=ne-1,On=ne/2,Tn=ne/4;var Pe=[\" \",\"	\",`\\n`,\"\\v\",\"\\f\",\"\\r\",\"\\x85\",\"\\u2028\",\"\\u2029\"].join(\"\"),yr=new RegExp(`^[${Pe}]*`),gr=new RegExp(`[${Pe}]*$`);var y=()=>globalThis?.document,oe=\"http://www.w3.org/1999/xhtml\",le=1,ae=3,ce=11,He=!!globalThis.HTMLElement?.prototype?.moveBefore;var rt=0;var it=1;var st=2;var ut=0;var de=2;var S=class extends a{constructor(e,n,t,r,s,u){super(),this.kind=e,this.key=n,this.mapper=t,this.children=r,this.keyed_children=s,this.children_count=u}};function A(i){return i instanceof S?1+i.children_count:1}var ot=0;var lt=1;var at=2;var ct=3;var ft=\"	\";var ht=0;var mt=1;var xt=2;var he=3;var wt=4;var me=5;var xe=6;var we=7;var D=class{offset=0;#r=null;#e=()=>{};#t=!1;#n=!1;constructor(e,n,{useServerEvents:t=!1,exposeKeys:r=!1}={}){this.#r=e,this.#e=n,this.#t=t,this.#n=r}mount(e){X(this.#r,this.#p(this.#r,0,e))}#i=[];push(e){let n=this.offset;n&&(w(e.changes,t=>{switch(t.kind){case xe:case he:t.before=(t.before|0)+n;break;case we:case me:t.from=(t.from|0)+n;break}}),w(e.children,t=>{t.index=(t.index|0)+n})),this.#i.push({node:this.#r,patch:e}),this.#s()}#s(){let e=this;for(;e.#i.length;){let{node:n,patch:t}=e.#i.pop();w(t.changes,u=>{switch(u.kind){case xe:e.#u(n,u.children,u.before);break;case he:e.#a(n,u.key,u.before,u.count);break;case wt:e.#l(n,u.key,u.count);break;case we:e.#o(n,u.from,u.count);break;case me:e.#f(n,u.from,u.count,u.with);break;case ht:e.#d(n,u.content);break;case mt:e.#_(n,u.inner_html);break;case xt:e.#x(n,u.added,u.removed);break}}),t.removed&&e.#o(n,n.childNodes.length-t.removed,t.removed);let r=-1,s=null;w(t.children,u=>{let o=u.index|0,$=s&&r-o===1?s.previousSibling:L(n,o);e.#i.push({node:$,patch:u}),s=$,r=o})}}#u(e,n,t){let r=gt(),s=t|0;w(n,u=>{let o=this.#p(e,s,u);X(r,o),s+=A(u)}),$e(e,r,L(e,t))}#a(e,n,t,r){let s=vt(e,n),u=L(e,t);for(let o=0;o<r&&s!==null;++o){let $=s.nextSibling;He?e.moveBefore(s,u):$e(e,s,u),s=$}}#l(e,n,t){this.#c(e,vt(e,n),t)}#o(e,n,t){this.#c(e,L(e,n),t)}#c(e,n,t){for(;t-- >0&&n!==null;){let r=n.nextSibling,s=n[l].key;s&&e[l].keyedChildren.delete(s);for(let[u,{timeout:o}]of n[l].debouncers??[])clearTimeout(o);e.removeChild(n),n=r}}#f(e,n,t,r){this.#o(e,n,t);let s=this.#p(e,n,r);$e(e,s,L(e,n))}#d(e,n){e.data=n??\"\"}#_(e,n){e.innerHTML=n??\"\"}#x(e,n,t){w(t,r=>{let s=r.name;e[l].handlers.has(s)?(e.removeEventListener(s,be),e[l].handlers.delete(s),e[l].throttles.has(s)&&e[l].throttles.delete(s),e[l].debouncers.has(s)&&(clearTimeout(e[l].debouncers.get(s).timeout),e[l].debouncers.delete(s))):(e.removeAttribute(s),jt[s]?.removed?.(e,s))}),w(n,r=>{this.#m(e,r)})}#p(e,n,t){switch(t.kind){case lt:{let r=bt(e,n,t);return this.#h(r,t),this.#u(r,t.children),r}case at:return yt(e,n,t);case ot:{let r=gt(),s=yt(e,n,t);X(r,s);let u=n+1;return w(t.children,o=>{X(r,this.#p(e,u,o)),u+=A(o)}),r}case ct:{let r=bt(e,n,t);return this.#h(r,t),this.#_(r,t.inner_html),r}}}#h(e,{key:n,attributes:t}){this.#n&&n&&e.setAttribute(\"data-lustre-key\",n),w(t,r=>this.#m(e,r))}#m(e,n){let{debouncers:t,handlers:r,throttles:s}=e[l],{kind:u,name:o,value:$,prevent_default:je,stop_propagation:Tt,immediate:Z,include:Nt,debounce:Ee,throttle:Se}=n;switch(u){case rt:{let c=$??\"\";if(o===\"virtual:defaultValue\"){e.defaultValue=c;return}c!==e.getAttribute(o)&&e.setAttribute(o,c),jt[o]?.added?.(e,$);break}case it:e[o]=$;break;case st:{if(r.has(o)&&e.removeEventListener(o,be),e.addEventListener(o,be,{passive:je.kind===ut}),Se>0){let c=s.get(o)??{};c.delay=Se,s.set(o,c)}else s.delete(o);if(Ee>0){let c=t.get(o)??{};c.delay=Ee,t.set(o,c)}else clearTimeout(t.get(o)?.timeout),t.delete(o);r.set(o,c=>{je.kind===de&&c.preventDefault(),Tt.kind===de&&c.stopPropagation();let g=c.type,ee=c.currentTarget[l].path,te=this.#t?bn(c,Nt??[]):c,v=s.get(g);if(v){let Ae=Date.now(),Mt=v.last||0;Ae>Mt+v.delay&&(v.last=Ae,v.lastEvent=c,this.#e(te,ee,g,Z))}let B=t.get(g);B&&(clearTimeout(B.timeout),B.timeout=setTimeout(()=>{c!==s.get(g)?.lastEvent&&this.#e(te,ee,g,Z)},B.delay)),!v&&!B&&this.#e(te,ee,g,Z)});break}}}},w=(i,e)=>{if(Array.isArray(i))for(let n=0;n<i.length;n++)e(i[n]);else if(i)for(i;i.tail;i=i.tail)e(i.head)},X=(i,e)=>i.appendChild(e),$e=(i,e,n)=>i.insertBefore(e,n??null),bt=(i,e,{key:n,tag:t,namespace:r})=>{let s=y().createElementNS(r||oe,t);return P(i,s,e,n),s},yt=(i,e,{key:n,content:t})=>{let r=y().createTextNode(t??\"\");return P(i,r,e,n),r},gt=()=>y().createDocumentFragment(),L=(i,e)=>i.childNodes[e|0],l=Symbol(\"lustre\"),P=(i,e,n=0,t=\"\")=>{let r=`${t||n}`;switch(e.nodeType){case le:case ce:e[l]={key:t,path:r,keyedChildren:new Map,handlers:new Map,throttles:new Map,debouncers:new Map};break;case ae:e[l]={key:t};break}i&&i[l]&&t&&i[l].keyedChildren.set(t,new WeakRef(e)),i&&i[l]&&i[l].path&&(e[l].path=`${i[l].path}${ft}${r}`)};var vt=(i,e)=>i[l].keyedChildren.get(e).deref(),be=i=>{let n=i.currentTarget[l].handlers.get(i.type);i.type===\"submit\"&&(i.detail??={},i.detail.formData=[...new FormData(i.target).entries()]),n(i)},bn=(i,e=[])=>{let n={};(i.type===\"input\"||i.type===\"change\")&&e.push(\"target.value\"),i.type===\"submit\"&&e.push(\"detail.formData\");for(let t of e){let r=t.split(\".\");for(let s=0,u=i,o=n;s<r.length;s++){if(s===r.length-1){o[r[s]]=u[r[s]];break}o=o[r[s]]??={},u=u[r[s]]}}return n},kt=i=>({added(e){e[i]=!0},removed(e){e[i]=!1}}),yn=i=>({added(e,n){e[i]=n}}),jt={checked:kt(\"checked\"),selected:kt(\"selected\"),value:yn(\"value\"),autofocus:{added(i){queueMicrotask(()=>i.focus?.())}},autoplay:{added(i){try{i.play?.()}catch(e){console.error(e)}}}};var Et=new WeakMap;async function St(i){let e=[];for(let t of y().querySelectorAll(\"link[rel=stylesheet], style\"))t.sheet||e.push(new Promise((r,s)=>{t.addEventListener(\"load\",r),t.addEventListener(\"error\",s)}));if(await Promise.allSettled(e),!i.host.isConnected)return[];i.adoptedStyleSheets=i.host.getRootNode().adoptedStyleSheets;let n=[];for(let t of y().styleSheets)try{i.adoptedStyleSheets.push(t)}catch{try{let r=Et.get(t);if(!r){r=new CSSStyleSheet;for(let s of t.cssRules)r.insertRule(s.cssText,r.cssRules.length);Et.set(t,r)}i.adoptedStyleSheets.push(r)}catch{let r=t.ownerNode.cloneNode();i.prepend(r),n.push(r)}}return n}var At=0;var Bt=1;var Ct=2;var K=0;var zt=1;var Ot=2;var Q=3;var ye=class extends HTMLElement{static get observedAttributes(){return[\"route\",\"method\"]}#r;#e=\"ws\";#t=null;#n=null;#i=[];#s;#u=new Set;#a=new Set;#l=!1;#o=[];#c=new MutationObserver(e=>{let n=[];for(let t of e){if(t.type!==\"attributes\")continue;let r=t.attributeName;(!this.#l||this.#u.has(r))&&n.push([r,this.getAttribute(r)])}if(n.length===1){let[t,r]=n[0];this.#n?.send({kind:K,name:t,value:r})}else n.length?this.#n?.send({kind:Q,messages:n.map(([t,r])=>({kind:K,name:t,value:r}))}):this.#o.push(...n)});constructor(){super(),this.internals=this.attachInternals(),this.#c.observe(this,{attributes:!0})}connectedCallback(){for(let e of this.attributes)this.#o.push([e.name,e.value])}attributeChangedCallback(e,n,t){switch(e){case(n!==t&&\"route\"):{this.#t=new URL(t,location.href),this.#f();return}case\"method\":{let r=t.toLowerCase();if(r==this.#e)return;[\"ws\",\"sse\",\"polling\"].includes(r)&&(this.#e=r,this.#e==\"ws\"&&(this.#t.protocol==\"https:\"&&(this.#t.protocol=\"wss:\"),this.#t.protocol==\"http:\"&&(this.#t.protocol=\"ws:\")),this.#f());return}}}async messageReceivedCallback(e){switch(e.kind){case At:{for(this.#r??=this.attachShadow({mode:e.open_shadow_root?\"open\":\"closed\"}),P(null,this.#r,\"\");this.#r.firstChild;)this.#r.firstChild.remove();this.#s=new D(this.#r,(t,r,s)=>{this.#n?.send({kind:zt,path:r,name:s,event:t})},{useServerEvents:!0}),this.#u=new Set(e.observed_attributes);let n=this.#o.filter(([t])=>this.#u.has(t));n.length&&this.#n.send({kind:Q,messages:n.map(([t,r])=>({kind:K,name:t,value:r}))}),this.#o=[],this.#a=new Set(e.observed_properties);for(let t of this.#a)Object.defineProperty(this,t,{get(){return this[`_${t}`]},set(r){this[`_${t}`]=r,this.#n?.send({kind:Ot,name:t,value:r})}});e.will_adopt_styles&&await this.#d(),this.#s.mount(e.vdom),this.dispatchEvent(new CustomEvent(\"lustre:mount\"));break}case Bt:{this.#s.push(e.patch);break}case Ct:{this.dispatchEvent(new CustomEvent(e.name,{detail:e.data}));break}}}#f(){if(!this.#t||!this.#e)return;this.#n&&this.#n.close();let r={onConnect:()=>{this.#l=!0,this.dispatchEvent(new CustomEvent(\"lustre:connect\"),{detail:{route:this.#t,method:this.#e}})},onMessage:s=>{this.messageReceivedCallback(s)},onClose:()=>{this.#l=!1,this.dispatchEvent(new CustomEvent(\"lustre:close\"),{detail:{route:this.#t,method:this.#e}})}};switch(this.#e){case\"ws\":this.#n=new ge(this.#t,r);break;case\"sse\":this.#n=new ve(this.#t,r);break;case\"polling\":this.#n=new ke(this.#t,r);break}}async#d(){for(;this.#i.length;)this.#i.pop().remove(),this.#r.firstChild.remove();this.#i=await St(this.#r),this.#s.offset=this.#i.length}},ge=class{#r;#e;#t=!1;#n=[];#i;#s;#u;constructor(e,{onConnect:n,onMessage:t,onClose:r}){this.#r=e,this.#e=new WebSocket(this.#r),this.#i=n,this.#s=t,this.#u=r,this.#e.onopen=()=>{this.#i()},this.#e.onmessage=({data:s})=>{try{this.#s(JSON.parse(s))}finally{this.#n.length?this.#e.send(JSON.stringify({kind:Q,messages:this.#n})):this.#t=!1,this.#n=[]}},this.#e.onclose=()=>{this.#u()}}send(e){if(this.#t||this.#e.readyState!==WebSocket.OPEN){this.#n.push(e);return}else this.#e.send(JSON.stringify(e)),this.#t=!0}close(){this.#e.close()}},ve=class{#r;#e;#t;#n;#i;constructor(e,{onConnect:n,onMessage:t,onClose:r}){this.#r=e,this.#e=new EventSource(this.#r),this.#t=n,this.#n=t,this.#i=r,this.#e.onopen=()=>{this.#t()},this.#e.onmessage=({data:s})=>{try{this.#n(JSON.parse(s))}catch{}}}send(e){}close(){this.#e.close(),this.#i()}},ke=class{#r;#e;#t;#n;#i;#s;constructor(e,{onConnect:n,onMessage:t,onClose:r,...s}){this.#r=e,this.#n=n,this.#i=t,this.#s=r,this.#e=s.interval??5e3,this.#u().finally(()=>{this.#n(),this.#t=setInterval(()=>this.#u(),this.#e)})}async send(e){}close(){clearInterval(this.#t),this.#s()}#u(){return fetch(this.#r).then(e=>e.json()).then(this.#i).catch(console.error)}};customElements.define(\"lustre-server-component\",ye);export{ye as ServerComponent};",
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
