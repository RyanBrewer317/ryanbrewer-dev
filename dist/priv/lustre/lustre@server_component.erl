-module(lustre@server_component).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([component/1, script/0, route/1, data/1, include/1, subscribe/2, unsubscribe/1, emit/2, select/1, set_selector/1, decode_action/1, encode_patch/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " > **Note**: server components are currently only supported on the **erlang**\n"
    " > target. If it's important to you that they work on the javascript target,\n"
    " > [open an issue](https://github.com/lustre-labs/lustre/issues/new) and tell\n"
    " > us why it's important to you!\n"
    "\n"
    " Server components are an advanced feature that allows you to run entire\n"
    " Lustre applications on the server. DOM changes are broadcasted to a small\n"
    " client runtime and browser events are sent back to the server.\n"
    "\n"
    " ```text\n"
    " -- SERVER -----------------------------------------------------------------\n"
    "\n"
    "                  Msg                            Element(Msg)\n"
    " +--------+        v        +----------------+        v        +------+\n"
    " |        | <-------------- |                | <-------------- |      |\n"
    " | update |                 | Lustre runtime |                 | view |\n"
    " |        | --------------> |                | --------------> |      |\n"
    " +--------+        ^        +----------------+        ^        +------+\n"
    "         #(model, Effect(msg))  |        ^          Model\n"
    "                                |        |\n"
    "                                |        |\n"
    "                    DOM patches |        | DOM events\n"
    "                                |        |\n"
    "                                v        |\n"
    "                        +-----------------------+\n"
    "                        |                       |\n"
    "                        | Your WebSocket server |\n"
    "                        |                       |\n"
    "                        +-----------------------+\n"
    "                                |        ^\n"
    "                                |        |\n"
    "                    DOM patches |        | DOM events\n"
    "                                |        |\n"
    "                                v        |\n"
    " -- BROWSER ----------------------------------------------------------------\n"
    "                                |        ^\n"
    "                                |        |\n"
    "                    DOM patches |        | DOM events\n"
    "                                |        |\n"
    "                                v        |\n"
    "                            +----------------+\n"
    "                            |                |\n"
    "                            | Client runtime |\n"
    "                            |                |\n"
    "                            +----------------+\n"
    " ```\n"
    "\n"
    " **Note**: Lustre's server component runtime is separate from your application's\n"
    " WebSocket server. You're free to bring your own stack, connect multiple\n"
    " clients to the same Lustre instance, or keep the application alive even when\n"
    " no clients are connected.\n"
    "\n"
    " Lustre server components run next to the rest of your backend code, your\n"
    " services, your database, etc. Real-time applications like chat services, games,\n"
    " or components that can benefit from direct access to your backend services\n"
    " like an admin dashboard or data table are excellent candidates for server\n"
    " components.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " Server components are a new feature in Lustre and we're still working on the\n"
    " best ways to use them and show them off. For now, you can find a simple\n"
    " undocumented example in the `examples/` directory:\n"
    "\n"
    " - [`99-server-components`](https://github.com/lustre-labs/lustre/tree/main/examples/99-server-components)\n"
    "\n"
    " ## Getting help\n"
    "\n"
    " If you're having trouble with Lustre or not sure what the right way to do\n"
    " something is, the best place to get help is the [Gleam Discord server](https://discord.gg/Fm8Pwmy).\n"
    " You could also open an issue on the [Lustre GitHub repository](https://github.com/lustre-labs/lustre/issues).\n"
    "\n"
).

-file("src/lustre/server_component.gleam", 101).
?DOC(
    " Render the Lustre Server Component client runtime. The content of your server\n"
    " component will be rendered inside this element.\n"
    "\n"
    " **Note**: you must include the `lustre-server-component.mjs` script found in\n"
    " the `priv/` directory of the Lustre package in your project's HTML or using\n"
    " the [`script`](#script) function.\n"
).
-spec component(list(lustre@internals@vdom:attribute(TAY))) -> lustre@internals@vdom:element(TAY).
component(Attrs) ->
    lustre@element:element(<<"lustre-server-component"/utf8>>, Attrs, []).

-file("src/lustre/server_component.gleam", 107).
?DOC(" Inline the Lustre Server Component client runtime as a script tag.\n").
-spec script() -> lustre@internals@vdom:element(any()).
script() ->
    lustre@element:element(
        <<"script"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"module"/utf8>>)],
        [lustre@element:text(
                <<"globalThis.customElements&&!globalThis.customElements.get(\"lustre-fragment\")&&globalThis.customElements.define(\"lustre-fragment\",class extends HTMLElement{constructor(){super()}});function k(t,e,r){let s,i=[{prev:t,next:e,parent:t.parentNode}];for(;i.length;){let{prev:o,next:n,parent:l}=i.pop();for(;n.subtree!==void 0;)n=n.subtree();if(n.content!==void 0)if(o)if(o.nodeType===Node.TEXT_NODE)o.textContent!==n.content&&(o.textContent=n.content),s??=o;else{let a=document.createTextNode(n.content);l.replaceChild(a,o),s??=a}else{let a=document.createTextNode(n.content);l.appendChild(a),s??=a}else if(n.tag!==void 0){let a=P({prev:o,next:n,dispatch:r,stack:i});o?o!==a&&l.replaceChild(a,o):l.appendChild(a),s??=a}}return s}function R(t,e,r,s=0){let i=t.parentNode;for(let o of e[0]){let n=o[0].split(\"-\"),l=o[1],a=E(i,n,s),c;if(a!==null&&a!==i)c=k(a,l,r);else{let p=E(i,n.slice(0,-1),s),g=document.createTextNode(\"\");p.appendChild(g),c=k(g,l,r)}n===\"0\"&&(t=c)}for(let o of e[1]){let n=o[0].split(\"-\");E(i,n,s).remove()}for(let o of e[2]){let n=o[0].split(\"-\"),l=o[1],a=E(i,n,s),c=x.get(a),p=[];for(let g of l[0]){let h=g[0],y=g[1];if(h.startsWith(\"data-lustre-on-\")){let m=h.slice(15),S=r(_);c.has(m)||a.addEventListener(m,w),c.set(m,S),a.setAttribute(h,y)}else(h.startsWith(\"delegate:data-\")||h.startsWith(\"delegate:aria-\"))&&a instanceof HTMLSlotElement?p.push([h.slice(10),y]):(a.setAttribute(h,y),(h===\"value\"||h===\"selected\")&&(a[h]=y));if(p.length>0)for(let m of a.assignedElements())for(let[S,A]of p)m[S]=A}for(let g of l[1])if(g.startsWith(\"data-lustre-on-\")){let h=g.slice(15);a.removeEventListener(h,w),c.delete(h)}else a.removeAttribute(g)}return t}function P({prev:t,next:e,dispatch:r,stack:s}){let i=e.namespace||\"http://www.w3.org/1999/xhtml\",o=t&&t.nodeType===Node.ELEMENT_NODE&&t.localName===e.tag&&t.namespaceURI===(e.namespace||\"http://www.w3.org/1999/xhtml\"),n=o?t:i?document.createElementNS(i,e.tag):document.createElement(e.tag),l;if(x.has(n))l=x.get(n);else{let u=new Map;x.set(n,u),l=u}let a=o?new Set(l.keys()):null,c=o?new Set(Array.from(t.attributes,u=>u.name)):null,p=null,g=null,h=null;if(o&&e.tag===\"textarea\"){let u=e.children[Symbol.iterator]().next().value?.content;u!==void 0&&(n.value=u)}let y=[];for(let u of e.attrs){let f=u[0],d=u[1];if(u.as_property)n[f]!==d&&(n[f]=d),o&&c.delete(f);else if(f.startsWith(\"on\")){let b=f.slice(2),T=r(d,b===\"input\");l.has(b)||n.addEventListener(b,w),l.set(b,T),o&&a.delete(b)}else if(f.startsWith(\"data-lustre-on-\")){let b=f.slice(15),T=r(_);l.has(b)||n.addEventListener(b,w),l.set(b,T),n.setAttribute(f,d),o&&(a.delete(b),c.delete(f))}else f.startsWith(\"delegate:data-\")||f.startsWith(\"delegate:aria-\")?(n.setAttribute(f,d),y.push([f.slice(10),d])):f===\"class\"?p=p===null?d:p+\" \"+d:f===\"style\"?g=g===null?d:g+d:f===\"dangerous-unescaped-html\"?h=d:(n.getAttribute(f)!==d&&n.setAttribute(f,d),(f===\"value\"||f===\"selected\")&&(n[f]=d),o&&c.delete(f))}if(p!==null&&(n.setAttribute(\"class\",p),o&&c.delete(\"class\")),g!==null&&(n.setAttribute(\"style\",g),o&&c.delete(\"style\")),o){for(let u of c)n.removeAttribute(u);for(let u of a)l.delete(u),n.removeEventListener(u,w)}if(e.tag===\"slot\"&&window.queueMicrotask(()=>{for(let u of n.assignedElements())for(let[f,d]of y)u.hasAttribute(f)||u.setAttribute(f,d)}),e.key!==void 0&&e.key!==\"\")n.setAttribute(\"data-lustre-key\",e.key);else if(h!==null)return n.innerHTML=h,n;let m=n.firstChild,S=null,A=null,C=null,N=v(e).next().value;if(o&&N!==void 0&&N.key!==void 0&&N.key!==\"\"){S=new Set,A=M(t),C=M(e);for(let u of v(e))m=$(m,u,n,s,C,A,S)}else for(let u of v(e))s.unshift({prev:m,next:u,parent:n}),m=m?.nextSibling;for(;m;){let u=m.nextSibling;n.removeChild(m),m=u}return n}var x=new WeakMap;function w(t){let e=t.currentTarget;if(!x.has(e)){e.removeEventListener(t.type,w);return}let r=x.get(e);if(!r.has(t.type)){e.removeEventListener(t.type,w);return}r.get(t.type)(t)}function _(t){let e=t.currentTarget,r=e.getAttribute(`data-lustre-on-${t.type}`),s=JSON.parse(e.getAttribute(\"data-lustre-data\")||\"{}\"),i=JSON.parse(e.getAttribute(\"data-lustre-include\")||\"[]\");switch(t.type){case\"input\":case\"change\":i.push(\"target.value\");break}return{tag:r,data:i.reduce((o,n)=>{let l=n.split(\".\");for(let a=0,c=o,p=t;a<l.length;a++)a===l.length-1?c[l[a]]=p[l[a]]:(c[l[a]]??={},p=p[l[a]],c=c[l[a]]);return o},{data:s})}}function M(t){let e=new Map;if(t)for(let r of v(t)){let s=r?.key||r?.getAttribute?.(\"data-lustre-key\");s&&e.set(s,r)}return e}function E(t,e,r){let s,i,o=t,n=!0;for(;[s,...i]=e,s!==void 0;)o=o.childNodes.item(n?s+r:s),n=!1,e=i;return o}function $(t,e,r,s,i,o,n){for(;t&&!i.has(t.getAttribute(\"data-lustre-key\"));){let a=t.nextSibling;r.removeChild(t),t=a}if(o.size===0)return s.unshift({prev:t,next:e,parent:r}),t=t?.nextSibling,t;if(n.has(e.key))return console.warn(`Duplicate key found in Lustre vnode: ${e.key}`),s.unshift({prev:null,next:e,parent:r}),t;n.add(e.key);let l=o.get(e.key);if(!l&&!t)return s.unshift({prev:null,next:e,parent:r}),t;if(!l&&t!==null){let a=document.createTextNode(\"\");return r.insertBefore(a,t),s.unshift({prev:a,next:e,parent:r}),t}return!l||l===t?(s.unshift({prev:t,next:e,parent:r}),t=t?.nextSibling,t):(r.insertBefore(l,t),s.unshift({prev:l,next:e,parent:r}),t)}function*v(t){for(let e of t.children)yield*F(e)}function*F(t){t.subtree!==void 0?yield*F(t.subtree()):yield t}function q(t,e){let r=[t,e];for(;r.length;){let s=r.pop(),i=r.pop();if(s===i)continue;if(!U(s)||!U(i)||!G(s,i)||D(s,i)||I(s,i)||H(s,i)||V(s,i)||z(s,i)||K(s,i))return!1;let n=Object.getPrototypeOf(s);if(n!==null&&typeof n.equals==\"function\")try{if(s.equals(i))continue;return!1}catch{}let[l,a]=j(s);for(let c of l(s))r.push(a(s,c),a(i,c))}return!0}function j(t){if(t instanceof Map)return[e=>e.keys(),(e,r)=>e.get(r)];{let e=t instanceof globalThis.Error?[\"message\"]:[];return[r=>[...e,...Object.keys(r)],(r,s)=>r[s]]}}function D(t,e){return t instanceof Date&&(t>e||t<e)}function I(t,e){return t.buffer instanceof ArrayBuffer&&t.BYTES_PER_ELEMENT&&!(t.byteLength===e.byteLength&&t.every((r,s)=>r===e[s]))}function H(t,e){return Array.isArray(t)&&t.length!==e.length}function V(t,e){return t instanceof Map&&t.size!==e.size}function z(t,e){return t instanceof Set&&(t.size!=e.size||[...t].some(r=>!e.has(r)))}function K(t,e){return t instanceof RegExp&&(t.source!==e.source||t.flags!==e.flags)}function U(t){return typeof t==\"object\"&&t!==null}function G(t,e){return typeof t!=\"object\"&&typeof e!=\"object\"&&(!t||!e)||[Promise,WeakSet,WeakMap,Function].some(s=>t instanceof s)?!1:t.constructor===e.constructor}var O=class extends HTMLElement{static get observedAttributes(){return[\"route\"]}constructor(){super(),this.attachShadow({mode:\"open\"}),this.#n=new MutationObserver(e=>{let r=[];for(let s of e)if(s.type===\"attributes\"){let{attributeName:i}=s,o=this.getAttribute(i);this[i]=o}r.length&&this.#t?.send(JSON.stringify([5,r]))})}connectedCallback(){this.#n.observe(this,{attributes:!0,attributeOldValue:!0}),this.#u().finally(()=>this.#i=!0)}attributeChangedCallback(e,r,s){switch(e){case\"route\":if(!s)this.#t?.close(),this.#t=null;else if(r!==s){let i=this.getAttribute(\"id\"),o=s+(i?`?id=${i}`:\"\"),n=window.location.protocol===\"https:\"?\"wss\":\"ws\";this.#r(`${n}://${window.location.host}${o}`)}}}messageReceivedCallback({data:e}){let[r,...s]=JSON.parse(e);switch(r){case 0:return this.#l(s);case 1:return this.#c(s);case 2:return this.#a(s)}}disconnectedCallback(){clearTimeout(this.#s),this.#t?.removeEventListener(\"close\",this.#o),this.#t?.close()}#n;#t;#s=null;#i=!1;#e=[];#a([e,r]){let s=[];for(let n of e)n in this?s.push([n,this[n]]):this.hasAttribute(n)&&s.push([n,this.getAttribute(n)]),Object.defineProperty(this,n,{get(){return this[`__mirrored__${n}`]},set(l){let a=this[`__mirrored__${n}`];q(a,l)||(this[`__mirrored__${n}`]=l,this.#t?.send(JSON.stringify([5,[[n,l]]])))}});this.#n.observe(this,{attributeFilter:e,attributeOldValue:!0,attributes:!0,characterData:!1,characterDataOldValue:!1,childList:!1,subtree:!1});let i=this.shadowRoot.childNodes[this.#e.length]??this.shadowRoot.appendChild(document.createTextNode(\"\"));k(i,r,n=>l=>{let a=JSON.parse(this.getAttribute(\"data-lustre-data\")||\"{}\"),c=n(l);c.data=W(a,c.data),this.#t?.send(JSON.stringify([4,c.tag,c.data]))}),s.length&&this.#t?.send(JSON.stringify([5,s]))}#r(e=this.#t.url){this.#t?.close(),this.#t=new WebSocket(e),this.#t.addEventListener(\"message\",r=>this.messageReceivedCallback(r)),this.#t.addEventListener(\"open\",()=>{this.dispatchEvent(new CustomEvent(\"connect\"))}),this.#t.addEventListener(\"close\",()=>{this.dispatchEvent(new CustomEvent(\"disconnect\")),this.#o()})}#o=()=>{this.#s=setTimeout(()=>{this.#t.readyState===WebSocket.CLOSED&&this.#r()},1e3)};#l([e]){let r=this.shadowRoot.childNodes[this.#e.length-1]??this.shadowRoot.appendChild(document.createTextNode(\"\"));R(r,e,i=>o=>{let n=i(o);this.#t?.send(JSON.stringify([4,n.tag,n.data]))},this.#e.length)}#c([e,r]){this.dispatchEvent(new CustomEvent(e,{detail:r}))}async#u(){let e=[];for(let s of document.querySelectorAll(\"link[rel=stylesheet]\"))s.sheet||e.push(new Promise((i,o)=>{s.addEventListener(\"load\",i),s.addEventListener(\"error\",o)}));for(await Promise.allSettled(e);this.#e.length;)this.#e.shift().remove(),this.shadowRoot.firstChild.remove();this.shadowRoot.adoptedStyleSheets=this.getRootNode().adoptedStyleSheets;let r=[];for(let s of document.styleSheets)try{this.shadowRoot.adoptedStyleSheets.push(s)}catch{try{let i=new CSSStyleSheet;for(let o of s.cssRules)i.insertRule(o.cssText,i.cssRules.length);this.shadowRoot.adoptedStyleSheets.push(i)}catch{let i=s.ownerNode.cloneNode();this.shadowRoot.prepend(i),this.#e.push(i),r.push(new Promise((o,n)=>{i.onload=o,i.onerror=n}))}}return Promise.allSettled(r)}};window.customElements.define(\"lustre-server-component\",O);var W=(t,e)=>{for(let r in e)e[r]instanceof Object&&Object.assign(e[r],W(t[r],e[r]));return Object.assign(t||{},e),t};export{O as LustreServerComponent};"/utf8>>
            )]
    ).

-file("src/lustre/server_component.gleam", 123).
?DOC(
    " The `route` attribute tells the client runtime what route it should use to\n"
    " set up the WebSocket connection to the server. Whenever this attribute is\n"
    " changed (by a clientside Lustre app, for example), the client runtime will\n"
    " destroy the current connection and set up a new one.\n"
).
-spec route(binary()) -> lustre@internals@vdom:attribute(any()).
route(Path) ->
    lustre@attribute:attribute(<<"route"/utf8>>, Path).

-file("src/lustre/server_component.gleam", 134).
?DOC(
    " Ocassionally you may want to attach custom data to an event sent to the server.\n"
    " This could be used to include a hash of the current build to detect if the\n"
    " event was sent from a stale client.\n"
    "\n"
    " Your event decoders can access this data by decoding `data` property of the\n"
    " event object.\n"
).
-spec data(gleam@json:json()) -> lustre@internals@vdom:attribute(any()).
data(Json) ->
    _pipe = Json,
    _pipe@1 = gleam@json:to_string(_pipe),
    lustre@attribute:attribute(<<"data-lustre-data"/utf8>>, _pipe@1).

-file("src/lustre/server_component.gleam", 170).
?DOC(
    " Properties of a JavaScript event object are typically not serialisable. This\n"
    " means if we want to pass them to the server we need to copy them into a new\n"
    " object first.\n"
    "\n"
    " This attribute tells Lustre what properties to include. Properties can come\n"
    " from nested objects by using dot notation. For example, you could include the\n"
    " `id` of the target `element` by passing `[\"target.id\"]`.\n"
    "\n"
    " ```gleam\n"
    " import gleam/dynamic\n"
    " import gleam/result.{try}\n"
    " import lustre/element.{type Element}\n"
    " import lustre/element/html\n"
    " import lustre/event\n"
    " import lustre/server\n"
    "\n"
    " pub fn custom_button(on_click: fn(String) -> msg) -> Element(msg) {\n"
    "   let handler = fn(event) {\n"
    "     use target <- try(dynamic.field(\"target\", dynamic.dynamic)(event))\n"
    "     use id <- try(dynamic.field(\"id\", dynamic.string)(target))\n"
    "\n"
    "     Ok(on_click(id))\n"
    "   }\n"
    "\n"
    "   html.button([event.on_click(handler), server.include([\"target.id\"])], [\n"
    "     element.text(\"Click me!\")\n"
    "   ])\n"
    " }\n"
    " ```\n"
).
-spec include(list(binary())) -> lustre@internals@vdom:attribute(any()).
include(Properties) ->
    _pipe = Properties,
    _pipe@1 = gleam@json:array(_pipe, fun gleam@json:string/1),
    _pipe@2 = gleam@json:to_string(_pipe@1),
    lustre@attribute:attribute(<<"data-lustre-include"/utf8>>, _pipe@2).

-file("src/lustre/server_component.gleam", 182).
?DOC(
    " A server component broadcasts patches to be applied to the DOM to any connected\n"
    " clients. This action is used to add a new client to a running server component.\n"
).
-spec subscribe(binary(), fun((lustre@internals@patch:patch(TBL)) -> nil)) -> lustre@internals@runtime:action(TBL, lustre:server_component()).
subscribe(Id, Renderer) ->
    {subscribe, Id, Renderer}.

-file("src/lustre/server_component.gleam", 192).
?DOC(
    " Remove a registered renderer from a server component. If no renderer with the\n"
    " given id is found, this action has no effect.\n"
).
-spec unsubscribe(binary()) -> lustre@internals@runtime:action(any(), lustre:server_component()).
unsubscribe(Id) ->
    {unsubscribe, Id}.

-file("src/lustre/server_component.gleam", 206).
?DOC(
    " Instruct any connected clients to emit a DOM event with the given name and\n"
    " data. This lets your server component communicate to frontend the same way\n"
    " any other HTML elements do: you might emit a `\"change\"` event when some part\n"
    " of the server component's state changes, for example.\n"
    "\n"
    " This is a real DOM event and any JavaScript on the page can attach an event\n"
    " listener to the server component element and listen for these events.\n"
).
-spec emit(binary(), gleam@json:json()) -> lustre@effect:effect(any()).
emit(Event, Data) ->
    lustre@effect:event(Event, Data).

-file("src/lustre/server_component.gleam", 236).
-spec do_select(
    fun((fun((TBZ) -> nil), gleam@erlang@process:subject(any())) -> gleam@erlang@process:selector(TBZ))
) -> lustre@effect:effect(TBZ).
do_select(Sel) ->
    lustre@effect:custom(
        fun(Dispatch, _, Select, _) ->
            Self = gleam@erlang@process:new_subject(),
            Selector = Sel(Dispatch, Self),
            Select(Selector)
        end
    ).

-file("src/lustre/server_component.gleam", 229).
?DOC(
    " On the Erlang target, Lustre's server component runtime is an OTP\n"
    " [actor](https://hexdocs.pm/gleam_otp/gleam/otp/actor.html) that can be\n"
    " communicated with using the standard process API and the `Subject` returned\n"
    " when starting the server component.\n"
    "\n"
    " Sometimes, you might want to hand a different `Subject` to a process to restrict\n"
    " the type of messages it can send or to distinguish messages from different\n"
    " sources from one another. The `select` effect creates a fresh `Subject` each\n"
    " time it is run. By returning a `Selector` you can teach the Lustre server\n"
    " component runtime how to listen to messages from this `Subject`.\n"
    "\n"
    " The `select` effect also gives you the dispatch function passed to `effect.from`.\n"
    " This is useful in case you want to store the provided `Subject` in your model\n"
    " for later use. For example you may subscribe to a pubsub service and later use\n"
    " that same `Subject` to unsubscribe.\n"
    "\n"
    " **Note**: This effect does nothing on the JavaScript runtime, where `Subjects`\n"
    " and `Selectors` don't exist, and is the equivalent of returning `effect.none()`.\n"
).
-spec select(
    fun((fun((TBU) -> nil), gleam@erlang@process:subject(any())) -> gleam@erlang@process:selector(TBU))
) -> lustre@effect:effect(TBU).
select(Sel) ->
    do_select(Sel).

-file("src/lustre/server_component.gleam", 257).
?DOC("\n").
-spec set_selector(
    gleam@erlang@process:selector(lustre@internals@runtime:action(any(), TCF))
) -> lustre@effect:effect(TCF).
set_selector(_) ->
    lustre@effect:from(
        fun(_) ->
            _pipe = <<"
It looks like you're trying to use `set_selector` in a server component. The
implementation of this effect is broken in ways that cannot be fixed without
changing the API. Please take a look at `select` instead!
  "/utf8>>,
            _pipe@1 = gleam@string:trim(_pipe),
            gleam_stdlib:println_error(_pipe@1),
            nil
        end
    ).

-file("src/lustre/server_component.gleam", 283).
-spec decode_event(gleam@dynamic:dynamic_()) -> {ok,
        lustre@internals@runtime:action(any(), any())} |
    {error, list(gleam@dynamic:decode_error())}.
decode_event(Dyn) ->
    gleam@result:'try'(
        (gleam@dynamic:tuple3(
            fun gleam@dynamic:int/1,
            fun gleam@dynamic:dynamic/1,
            fun gleam@dynamic:dynamic/1
        ))(Dyn),
        fun(_use0) ->
            {Kind, Name, Data} = _use0,
            gleam@bool:guard(
                Kind /= 4,
                {error,
                    [{decode_error,
                            erlang:integer_to_binary(4),
                            erlang:integer_to_binary(Kind),
                            [<<"0"/utf8>>]}]},
                fun() ->
                    gleam@result:'try'(
                        gleam@dynamic:string(Name),
                        fun(Name@1) -> {ok, {event, Name@1, Data}} end
                    )
                end
            )
        end
    ).

-file("src/lustre/server_component.gleam", 321).
-spec decode_attr(gleam@dynamic:dynamic_()) -> {ok,
        {binary(), gleam@dynamic:dynamic_()}} |
    {error, list(gleam@dynamic:decode_error())}.
decode_attr(Dyn) ->
    (gleam@dynamic:tuple2(
        fun gleam@dynamic:string/1,
        fun gleam@dynamic:dynamic/1
    ))(Dyn).

-file("src/lustre/server_component.gleam", 304).
-spec decode_attrs(gleam@dynamic:dynamic_()) -> {ok,
        lustre@internals@runtime:action(any(), any())} |
    {error, list(gleam@dynamic:decode_error())}.
decode_attrs(Dyn) ->
    gleam@result:'try'(
        (gleam@dynamic:tuple2(
            fun gleam@dynamic:int/1,
            fun gleam@dynamic:dynamic/1
        ))(Dyn),
        fun(_use0) ->
            {Kind, Attrs} = _use0,
            gleam@bool:guard(
                Kind /= 5,
                {error,
                    [{decode_error,
                            erlang:integer_to_binary(5),
                            erlang:integer_to_binary(Kind),
                            [<<"0"/utf8>>]}]},
                fun() ->
                    gleam@result:'try'(
                        (gleam@dynamic:list(fun decode_attr/1))(Attrs),
                        fun(Attrs@1) -> {ok, {attrs, Attrs@1}} end
                    )
                end
            )
        end
    ).

-file("src/lustre/server_component.gleam", 277).
?DOC(
    " The server component client runtime sends JSON encoded actions for the server\n"
    " runtime to execute. Because your own WebSocket server sits between the two\n"
    " parts of the runtime, you need to decode these actions and pass them to the\n"
    " server runtime yourself.\n"
).
-spec decode_action(gleam@dynamic:dynamic_()) -> {ok,
        lustre@internals@runtime:action(any(), lustre:server_component())} |
    {error, list(gleam@dynamic:decode_error())}.
decode_action(Dyn) ->
    (gleam@dynamic:any([fun decode_event/1, fun decode_attrs/1]))(Dyn).

-file("src/lustre/server_component.gleam", 331).
?DOC(
    " Encode a DOM patch as JSON you can send to the client runtime to apply. Whenever\n"
    " the server runtime re-renders, all subscribed clients will receive a patch\n"
    " message they must forward to the client runtime.\n"
).
-spec encode_patch(lustre@internals@patch:patch(any())) -> gleam@json:json().
encode_patch(Patch) ->
    lustre@internals@patch:patch_to_json(Patch).
