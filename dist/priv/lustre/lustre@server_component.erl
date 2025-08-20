-module(lustre@server_component).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).
-define(FILEPATH, "src/lustre/server_component.gleam").
-export([element/2, script/0, route/1, method/1, include/2, subject/1, pid/1, register_subject/1, deregister_subject/1, register_callback/1, deregister_callback/1, emit/2, select/1, runtime_message_decoder/0, client_message_to_json/1]).
-export_type([transport_method/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " Server components are an advanced feature that allows you to run components\n"
    " or full Lustre applications on the server. Updates are broadcast to a small\n"
    " (10kb!) client runtime that patches the DOM and events are sent back to the\n"
    " server component in real-time.\n"
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
    " > **Note**: Lustre's server component runtime is separate from your application's\n"
    " > WebSocket server. You're free to bring your own stack, connect multiple\n"
    " > clients to the same Lustre instance, or keep the application alive even when\n"
    " > no clients are connected.\n"
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
    " best ways to use them and show them off. Here are a few examples we've\n"
    " developed so far:\n"
    "\n"
    " - [Basic setup](https://github.com/lustre-labs/lustre/tree/main/examples/06-server-components/01-basic-setup)\n"
    "\n"
    " - [Custom attributes and events](https://github.com/lustre-labs/lustre/tree/main/examples/06-server-components/02-attributes-and-events)\n"
    "\n"
    " - [Decoding DOM events](https://github.com/lustre-labs/lustre/tree/main/examples/06-server-components/03-event-include)\n"
    "\n"
    " - [Connecting more than one client](https://github.com/lustre-labs/lustre/tree/main/examples/06-server-components/04-multiple-clients)\n"
    "\n"
    " ## Getting help\n"
    "\n"
    " If you're having trouble with Lustre or not sure what the right way to do\n"
    " something is, the best place to get help is the [Gleam Discord server](https://discord.gg/Fm8Pwmy).\n"
    " You could also open an issue on the [Lustre GitHub repository](https://github.com/lustre-labs/lustre/issues).\n"
    "\n"
).

-type transport_method() :: web_socket | server_sent_events | polling.

-file("src/lustre/server_component.gleam", 141).
?DOC(
    " Render the server component custom element. This element acts as the thin\n"
    " client runtime for a server component running remotely. There are a handful\n"
    " of attributes you should provide to configure the client runtime:\n"
    "\n"
    " - [`route`](#route) is the URL your server component should connect to. This\n"
    "   **must** be provided before the client runtime will do anything. The route\n"
    "   can be a relative URL, in which case it will be resolved against the current\n"
    "   page URL.\n"
    "\n"
    " - [`method`](#method) is the transport method the client runtime should use.\n"
    "   This defaults to `WebSocket` enabling duplex communication between the client\n"
    "   and server runtime. Other options include `ServerSentEvents` and `Polling`\n"
    "   which are unidirectional transports.\n"
    "\n"
    " > **Note**: the server component runtime bundle must be included and sent to\n"
    " > the client for this to work correctly. You can do this by including the\n"
    " > JavaScript bundle found in Lustre's `priv/static` directory or by inlining\n"
    " > the script source directly with the [`script`](#script) element below.\n"
).
-spec element(
    list(lustre@vdom@vattr:attribute(UUS)),
    list(lustre@vdom@vnode:element(UUS))
) -> lustre@vdom@vnode:element(UUS).
element(Attributes, Children) ->
    lustre@element:element(
        <<"lustre-server-component"/utf8>>,
        Attributes,
        Children
    ).

-file("src/lustre/server_component.gleam", 153).
?DOC(
    " Inline the server component client runtime as a `<script>` tag. Where possible\n"
    " you should prefer serving the pre-built client runtime from Lustre's `priv/static`\n"
    " directory, but this inline script can be useful for development or scenarios\n"
    " where you don't control the HTML document.\n"
).
-spec script() -> lustre@vdom@vnode:element(any()).
script() ->
    lustre@element@html:script(
        [lustre@attribute:type_(<<"module"/utf8>>)],
        <<"var yt=5,te=Math.pow(2,yt),Nn=te-1,In=te/2,Mn=te/4;var Te=[\" \",\"	\",`\\n`,\"\\v\",\"\\f\",\"\\r\",\"\\x85\",\"\\u2028\",\"\\u2029\"].join(\"\"),Er=new RegExp(`^[${Te}]*`),Sr=new RegExp(`[${Te}]*$`);var k=()=>globalThis?.document,ue=\"http://www.w3.org/1999/xhtml\";var qe=!!globalThis.HTMLElement?.prototype?.moveBefore;var Ve=0;var He=1;var We=2;var Ge=0;var ce=2;var w=0;var Y=1;var ae=2;var Je=3;var fe=\"	\";var Ze=0;var et=1;var tt=2;var nt=3;var rt=4;var it=5;var st=6;var an=globalThis.setTimeout,de=globalThis.clearTimeout,fn=(s,e)=>k().createElementNS(s,e),pn=s=>k().createTextNode(s),dn=()=>k().createDocumentFragment(),O=(s,e,n)=>s.insertBefore(e,n),ot=qe?(s,e,n)=>s.moveBefore(e,n):O,_n=(s,e)=>s.removeChild(e),hn=(s,e)=>s.getAttribute(e),lt=(s,e,n)=>s.setAttribute(e,n),mn=(s,e)=>s.removeAttribute(e),xn=(s,e,n,r)=>s.addEventListener(e,n,r),ct=(s,e,n)=>s.removeEventListener(e,n),bn=(s,e)=>s.innerHTML=e,$n=(s,e)=>s.data=e,g=Symbol(\"lustre\"),he=class{constructor(e,n,r,t){this.kind=e,this.key=t,this.parent=n,this.children=[],this.node=r,this.handlers=new Map,this.throttles=new Map,this.debouncers=new Map}get parentNode(){return this.kind===w?this.node.parentNode:this.node}};var X=(s,e,n,r,t)=>{let i=new he(s,e,n,t);return n[g]=i,e?.children.splice(r,0,i),i},wn=s=>{let e=\"\";for(let n=s[g];n.parent;n=n.parent)if(n.key)e=`${fe}${n.key}${e}`;else{let r=n.parent.children.indexOf(n);e=`${fe}${r}${e}`}return e.slice(1)},D=class{#r=null;#e=()=>{};#n=!1;#t=!1;constructor(e,n,{useServerEvents:r=!1,exposeKeys:t=!1}={}){this.#r=e,this.#e=n,this.#n=r,this.#t=t}mount(e){console.log(\"mount\",e),X(Y,null,this.#r,0,null),this.#x(this.#r,null,this.#r[g],0,e)}push(e){this.#i.push({node:this.#r[g],patch:e}),this.#s()}#i=[];#s(){let e=this.#i;for(;e.length;){let{node:n,patch:r}=e.pop(),{children:t}=n,{changes:i,removed:u,children:o}=r;S(i,l=>this.#u(n,l)),u&&this.#a(n,t.length-u,u),S(o,l=>{let x=t[l.index|0];this.#i.push({node:x,patch:l})})}}#u(e,n){switch(n.kind){case Ze:this.#k(e,n);break;case et:this.#b(e,n);break;case tt:this.#y(e,n);break;case nt:this.#l(e,n);break;case rt:this.#h(e,n);break;case it:this.#f(e,n);break;case st:this.#p(e,n);break}}#p(e,{children:n,before:r}){let t=dn(),i=this.#o(e,r);this.#m(t,null,e,r|0,n),O(e.parentNode,t,i)}#f(e,{index:n,with:r}){this.#a(e,n|0,1);let t=this.#o(e,n);this.#x(e.parentNode,t,e,n|0,r)}#o(e,n){n=n|0;let{children:r}=e,t=r.length;if(n<t)return r[n].node;let i=r[t-1];if(!i&&e.kind!==w)return null;for(i||(i=e);i.kind===w&&i.children.length;)i=i.children[i.children.length-1];return i.node.nextSibling}#l(e,{key:n,before:r}){r=r|0;let{children:t,parentNode:i}=e,u=t[r].node,o=t[r];for(let $=r+1;$<t.length;++$){let _=t[$];if(t[$]=o,o=_,_.key===n){t[r]=_;break}}let{kind:l,node:x,children:v}=o;ot(i,x,u),l===w&&this.#c(i,v,u)}#c(e,n,r){for(let t=0;t<n.length;++t){let{kind:i,node:u,children:o}=n[t];ot(e,u,r),i===w&&this.#c(e,o,r)}}#h(e,{index:n}){this.#a(e,n,1)}#a(e,n,r){let{children:t,parentNode:i}=e,u=t.splice(n,r);for(let o=0;o<u.length;++o){let{kind:l,node:x,children:v}=u[o];_n(i,x),this.#d(u[o]),l===w&&u.push(...v)}}#d(e){let{debouncers:n,children:r}=e;for(let{timeout:t}of n.values())t&&de(t);n.clear(),S(r,t=>this.#d(t))}#y({node:e,handlers:n,throttles:r,debouncers:t},{added:i,removed:u}){S(u,({name:o})=>{n.delete(o)?(ct(e,o,_e),this.#_(r,o,0),this.#_(t,o,0)):(mn(e,o),ft[o]?.removed?.(e,o))}),S(i,o=>this.#g(e,o))}#k({node:e},{content:n}){$n(e,n??\"\")}#b({node:e},{inner_html:n}){bn(e,n??\"\")}#m(e,n,r,t,i){S(i,u=>this.#x(e,n,r,t++,u))}#x(e,n,r,t,i){switch(i.kind){case Y:{let u=this.#$(r,t,i);this.#m(u,null,u[g],0,i.children),O(e,u,n);break}case ae:{let u=this.#w(r,t,i);O(e,u,n);break}case w:{let u=this.#w(r,t,i);O(e,u,n),this.#m(e,n,u[g],0,i.children);break}case Je:{let u=this.#$(r,t,i);this.#b({node:u},i),O(e,u,n);break}}}#$(e,n,{kind:r,key:t,tag:i,namespace:u,attributes:o}){let l=fn(u||ue,i);return X(r,e,l,n,t),this.#t&&t&&lt(l,\"data-lustre-key\",t),S(o,x=>this.#g(l,x)),l}#w(e,n,{kind:r,key:t,content:i}){let u=pn(i??\"\");return X(r,e,u,n,t),u}#g(e,n){let{debouncers:r,handlers:t,throttles:i}=e[g],{kind:u,name:o,value:l,prevent_default:x,debounce:v,throttle:$}=n;switch(u){case Ve:{let _=l??\"\";if(o===\"virtual:defaultValue\"){e.defaultValue=_;return}_!==hn(e,o)&&lt(e,o,_),ft[o]?.added?.(e,_);break}case He:e[o]=l;break;case We:{t.has(o)&&ct(e,o,_e);let _=x.kind===Ge;xn(e,o,_e,{passive:_}),this.#_(i,o,$),this.#_(r,o,v),t.set(o,y=>this.#v(n,y));break}}}#_(e,n,r){let t=e.get(n);if(r>0)t?t.delay=r:e.set(n,{delay:r});else if(t){let{timeout:i}=t;i&&de(i),e.delete(n)}}#v(e,n){let{currentTarget:r,type:t}=n,{debouncers:i,throttles:u}=r[g],o=wn(r),{prevent_default:l,stop_propagation:x,include:v,immediate:$}=e;l.kind===ce&&n.preventDefault(),x.kind===ce&&n.stopPropagation(),t===\"submit\"&&(n.detail??={},n.detail.formData=[...new FormData(n.target).entries()]);let _=this.#n?gn(n,v??[]):n,y=u.get(t);if(y){let we=Date.now(),gt=y.last||0;we>gt+y.delay&&(y.last=we,y.lastEvent=n,this.#e(_,o,t,$))}let T=i.get(t);T&&(de(T.timeout),T.timeout=an(()=>{n!==u.get(t)?.lastEvent&&this.#e(_,o,t,$)},T.delay)),!y&&!T&&this.#e(_,o,t,$)}},S=(s,e)=>{if(Array.isArray(s))for(let n=0;n<s.length;n++)e(s[n]);else if(s)for(s;s.head;s=s.tail)e(s.head)},_e=s=>{let{currentTarget:e,type:n}=s;e[g].handlers.get(n)(s)},gn=(s,e=[])=>{let n={};(s.type===\"input\"||s.type===\"change\")&&e.push(\"target.value\"),s.type===\"submit\"&&e.push(\"detail.formData\");for(let r of e){let t=r.split(\".\");for(let i=0,u=s,o=n;i<t.length;i++){if(i===t.length-1){o[t[i]]=u[t[i]];break}o=o[t[i]]??={},u=u[t[i]]}}return n},at=s=>({added(e){e[s]=!0},removed(e){e[s]=!1}}),yn=s=>({added(e,n){e[s]=n}}),ft={checked:at(\"checked\"),selected:at(\"selected\"),value:yn(\"value\"),autofocus:{added(s){queueMicrotask(()=>{s.focus?.()})}},autoplay:{added(s){try{s.play?.()}catch(e){console.error(e)}}}};var pt=new WeakMap;async function dt(s){let e=[];for(let r of k().querySelectorAll(\"link[rel=stylesheet], style\"))r.sheet||e.push(new Promise((t,i)=>{r.addEventListener(\"load\",t),r.addEventListener(\"error\",i)}));if(await Promise.allSettled(e),!s.host.isConnected)return[];s.adoptedStyleSheets=s.host.getRootNode().adoptedStyleSheets;let n=[];for(let r of k().styleSheets)try{s.adoptedStyleSheets.push(r)}catch{try{let t=pt.get(r);if(!t){t=new CSSStyleSheet;for(let i of r.cssRules)t.insertRule(i.cssText,t.cssRules.length);pt.set(r,t)}s.adoptedStyleSheets.push(t)}catch{let t=r.ownerNode.cloneNode();s.prepend(t),n.push(t)}}return n}var K=class extends Event{constructor(e,n,r){super(\"context-request\",{bubbles:!0,composed:!0}),this.context=e,this.callback=n,this.subscribe=r}};var _t=0;var ht=1;var mt=2;var xt=3;var Z=0;var bt=1;var $t=2;var ee=3;var wt=4;var me=class extends HTMLElement{static get observedAttributes(){return[\"route\",\"method\"]}#r;#e=\"ws\";#n=null;#t=null;#i=[];#s;#u=new Set;#p=new Set;#f=!1;#o=[];#l=new Map;#c=new Set;#h=new MutationObserver(e=>{let n=[];for(let r of e){if(r.type!==\"attributes\")continue;let t=r.attributeName;(!this.#f||this.#u.has(t))&&n.push([t,this.getAttribute(t)])}if(n.length===1){let[r,t]=n[0];this.#t?.send({kind:Z,name:r,value:t})}else n.length?this.#t?.send({kind:ee,messages:n.map(([r,t])=>({kind:Z,name:r,value:t}))}):this.#o.push(...n)});constructor(){super(),this.internals=this.attachInternals(),this.#h.observe(this,{attributes:!0})}connectedCallback(){for(let e of this.attributes)this.#o.push([e.name,e.value])}attributeChangedCallback(e,n,r){switch(e){case(n!==r&&\"route\"):{this.#n=new URL(r,location.href),this.#a();return}case\"method\":{let t=r.toLowerCase();if(t==this.#e)return;[\"ws\",\"sse\",\"polling\"].includes(t)&&(this.#e=t,this.#e==\"ws\"&&(this.#n.protocol==\"https:\"&&(this.#n.protocol=\"wss:\"),this.#n.protocol==\"http:\"&&(this.#n.protocol=\"ws:\")),this.#a());return}}}async messageReceivedCallback(e){switch(e.kind){case _t:{for(this.#r??=this.attachShadow({mode:e.open_shadow_root?\"open\":\"closed\"});this.#r.firstChild;)this.#r.firstChild.remove();this.#s=new D(this.#r,(t,i,u)=>{this.#t?.send({kind:bt,path:i,name:u,event:t})},{useServerEvents:!0}),this.#u=new Set(e.observed_attributes);let r=this.#o.filter(([t])=>this.#u.has(t)).map(([t,i])=>({kind:Z,name:t,value:i}));this.#o=[],this.#p=new Set(e.observed_properties);for(let t of this.#p)Object.defineProperty(this,t,{get(){return this[`_${t}`]},set(i){this[`_${t}`]=i,this.#t?.send({kind:$t,name:t,value:i})}});for(let[t,i]of Object.entries(e.provided_contexts))this.provide(t,i);for(let t of[...new Set(e.requested_contexts)])this.dispatchEvent(new K(t,(i,u)=>{this.#t?.send({kind:wt,key:t,value:i}),this.#c.add(u)}));r.length&&this.#t.send({kind:ee,messages:r}),e.will_adopt_styles&&await this.#d(),this.#r.addEventListener(\"context-request\",t=>{if(!t.context||!t.callback||!this.#l.has(t.context))return;t.stopImmediatePropagation();let i=this.#l.get(t.context);if(t.subscribe){let u=new WeakRef(t.callback),o=()=>{i.subscribers=i.subscribers.filter(l=>l!==u)};i.subscribers.push([u,o]),t.callback(i.value,o)}else t.callback(i.value)}),this.#s.mount(e.vdom),this.dispatchEvent(new CustomEvent(\"lustre:mount\"));break}case ht:{this.#s.push(e.patch);break}case mt:{this.dispatchEvent(new CustomEvent(e.name,{detail:e.data}));break}case xt:{this.provide(e.key,e.value);break}}}disconnectedCallback(){for(let e of this.#c)e();this.#c.clear()}provide(e,n){if(!this.#l.has(e))this.#l.set(e,{value:n,subscribers:[]});else{let r=this.#l.get(e);r.value=n;for(let t=r.subscribers.length-1;t>=0;t--){let[i,u]=r.subscribers[t],o=i.deref();if(!o){r.subscribers.splice(t,1);continue}o(n,u)}}}#a(){if(!this.#n||!this.#e)return;this.#t&&this.#t.close();let t={onConnect:()=>{this.#f=!0,this.dispatchEvent(new CustomEvent(\"lustre:connect\"),{detail:{route:this.#n,method:this.#e}})},onMessage:i=>{this.messageReceivedCallback(i)},onClose:()=>{this.#f=!1,this.dispatchEvent(new CustomEvent(\"lustre:close\",{detail:{route:this.#n,method:this.#e}}))}};switch(this.#e){case\"ws\":this.#t=new xe(this.#n,t);break;case\"sse\":this.#t=new be(this.#n,t);break;case\"polling\":this.#t=new $e(this.#n,t);break}}async#d(){for(;this.#i.length;)this.#i.pop().remove(),this.#r.firstChild.remove();this.#i=await dt(this.#r)}},xe=class{#r;#e;#n=!1;#t=[];#i;#s;#u;constructor(e,{onConnect:n,onMessage:r,onClose:t}){this.#r=e,this.#e=new WebSocket(this.#r),this.#i=n,this.#s=r,this.#u=t,this.#e.onopen=()=>{this.#i()},this.#e.onmessage=({data:i})=>{try{this.#s(JSON.parse(i))}finally{this.#t.length?this.#e.send(JSON.stringify({kind:ee,messages:this.#t})):this.#n=!1,this.#t=[]}},this.#e.onclose=()=>{this.#u()}}send(e){if(this.#n||this.#e.readyState!==WebSocket.OPEN){this.#t.push(e);return}else this.#e.send(JSON.stringify(e)),this.#n=!0}close(){this.#e.close()}},be=class{#r;#e;#n;#t;#i;constructor(e,{onConnect:n,onMessage:r,onClose:t}){this.#r=e,this.#e=new EventSource(this.#r),this.#n=n,this.#t=r,this.#i=t,this.#e.onopen=()=>{this.#n()},this.#e.onmessage=({data:i})=>{try{this.#t(JSON.parse(i))}catch{}}}send(e){}close(){this.#e.close(),this.#i()}},$e=class{#r;#e;#n;#t;#i;#s;constructor(e,{onConnect:n,onMessage:r,onClose:t,...i}){this.#r=e,this.#t=n,this.#i=r,this.#s=t,this.#e=i.interval??5e3,this.#u().finally(()=>{this.#t(),this.#n=setInterval(()=>this.#u(),this.#e)})}async send(e){}close(){clearInterval(this.#n),this.#s()}#u(){return fetch(this.#r).then(e=>e.json()).then(this.#i).catch(console.error)}};customElements.define(\"lustre-server-component\",me);export{me as ServerComponent};"/utf8>>
    ).

-file("src/lustre/server_component.gleam", 168).
?DOC(
    " The `route` attribute tells the client runtime what route it should use to\n"
    " set up the WebSocket connection to the server. Whenever this attribute is\n"
    " changed (by a clientside Lustre app, for example), the client runtime will\n"
    " destroy the current connection and set up a new one.\n"
).
-spec route(binary()) -> lustre@vdom@vattr:attribute(any()).
route(Path) ->
    lustre@attribute:attribute(<<"route"/utf8>>, Path).

-file("src/lustre/server_component.gleam", 174).
?DOC("\n").
-spec method(transport_method()) -> lustre@vdom@vattr:attribute(any()).
method(Value) ->
    lustre@attribute:attribute(<<"method"/utf8>>, case Value of
            web_socket ->
                <<"ws"/utf8>>;

            server_sent_events ->
                <<"sse"/utf8>>;

            polling ->
                <<"polling"/utf8>>
        end).

-file("src/lustre/server_component.gleam", 211).
?DOC(
    " Properties of a JavaScript event object are typically not serialisable. This\n"
    " means if we want to send them to the server we need to make a copy of any\n"
    " fields we want to decode first.\n"
    "\n"
    " This attribute tells Lustre what properties to include from an event. Properties\n"
    " can come from nested fields by using dot notation. For example, you could include\n"
    " the\n"
    " `id` of the target `element` by passing `[\"target.id\"]`.\n"
    "\n"
    " ```gleam\n"
    " import gleam/dynamic/decode\n"
    " import lustre/element.{type Element}\n"
    " import lustre/element/html\n"
    " import lustre/event\n"
    " import lustre/server_component\n"
    "\n"
    " pub fn custom_button(on_click: fn(String) -> msg) -> Element(msg) {\n"
    "   let handler = fn(event) {\n"
    "     use id <- decode.at([\"target\", \"id\"], decode.string)\n"
    "     decode.success(on_click(id))\n"
    "   }\n"
    "\n"
    "   html.button(\n"
    "     [server_component.include([\"target.id\"]), event.on(\"click\", handler)],\n"
    "     [html.text(\"Click me!\")],\n"
    "   )\n"
    " }\n"
    " ```\n"
).
-spec include(lustre@vdom@vattr:attribute(UVE), list(binary())) -> lustre@vdom@vattr:attribute(UVE).
include(Event, Properties) ->
    case Event of
        {event, _, _, _, _, _, _, _, _, _} ->
            _record = Event,
            {event,
                erlang:element(2, _record),
                erlang:element(3, _record),
                erlang:element(4, _record),
                Properties,
                erlang:element(6, _record),
                erlang:element(7, _record),
                erlang:element(8, _record),
                erlang:element(9, _record),
                erlang:element(10, _record)};

        _ ->
            Event
    end.

-file("src/lustre/server_component.gleam", 231).
?DOC(
    " Recover the `Subject` of the server component runtime so that it can be used\n"
    " in supervision trees or passed to other processes. If you want to hand out\n"
    " different `Subject`s to send messages to your application, take a look at the\n"
    " [`select`](#select) effect.\n"
    "\n"
    " > **Note**: this function is not available on the JavaScript target.\n"
).
-spec subject(lustre:runtime(UVI)) -> gleam@erlang@process:subject(lustre@runtime@server@runtime:message(UVI)).
subject(Runtime) ->
    gleam@function:identity(Runtime).

-file("src/lustre/server_component.gleam", 243).
?DOC(
    " Recover the `Pid` of the server component runtime so that it can be used in\n"
    " supervision trees or passed to other processes. If you want to hand out\n"
    " different `Subject`s to send messages to your application, take a look at the\n"
    " [`select`](#select) effect.\n"
    "\n"
    " > **Note**: this function is not available on the JavaScript target.\n"
).
-spec pid(lustre:runtime(any())) -> gleam@erlang@process:pid_().
pid(Runtime) ->
    Pid@1 = case gleam@erlang@process:subject_owner(subject(Runtime)) of
        {ok, Pid} -> Pid;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"lustre/server_component"/utf8>>,
                        function => <<"pid"/utf8>>,
                        line => 246,
                        value => _assert_fail,
                        start => 21626,
                        'end' => 21686,
                        pattern_start => 21637,
                        pattern_end => 21644})
    end,
    Pid@1.

-file("src/lustre/server_component.gleam", 262).
?DOC(
    " Register a `Subject` to receive messages and updates from Lustre's server\n"
    " component runtime. The process that owns this will be monitored and the\n"
    " subject will be gracefully removed if the process dies.\n"
    "\n"
    " > **Note**: if you are developing a server component for the JavaScript runtime,\n"
    " > you should use [`register_callback`](#register_callback) instead.\n"
).
-spec register_subject(
    gleam@erlang@process:subject(lustre@runtime@transport:client_message(UVQ))
) -> lustre@runtime@server@runtime:message(UVQ).
register_subject(Client) ->
    {client_registered_subject, Client}.

-file("src/lustre/server_component.gleam", 272).
?DOC(
    " Deregister a `Subject` to stop receiving messages and updates from Lustre's\n"
    " server component runtime. The subject should first have been registered with\n"
    " [`register_subject`](#register_subject) otherwise this will do nothing.\n"
).
-spec deregister_subject(
    gleam@erlang@process:subject(lustre@runtime@transport:client_message(UVU))
) -> lustre@runtime@server@runtime:message(UVU).
deregister_subject(Client) ->
    {client_deregistered_subject, Client}.

-file("src/lustre/server_component.gleam", 286).
?DOC(
    " Register a callback to be called whenever the server component runtime\n"
    " produces a message. Avoid using anonymous functions with this function, as\n"
    " they cannot later be removed using [`deregister_callback`](#deregister_callback).\n"
    "\n"
    " > **Note**: server components running on the Erlang target are **strongly**\n"
    " > encouraged to use [`register_subject`](#register_subject) instead of this\n"
    " > function.\n"
).
-spec register_callback(
    fun((lustre@runtime@transport:client_message(UVY)) -> nil)
) -> lustre@runtime@server@runtime:message(UVY).
register_callback(Callback) ->
    {client_registered_callback, Callback}.

-file("src/lustre/server_component.gleam", 300).
?DOC(
    " Deregister a callback to be called whenever the server component runtime\n"
    " produces a message. The callback to remove is determined by function equality\n"
    " and must be the same function that was passed to [`register_callback`](#register_callback).\n"
    "\n"
    " > **Note**: server components running on the Erlang target are **strongly**\n"
    " > encouraged to use [`register_subject`](#register_subject) instead of this\n"
    " > function.\n"
).
-spec deregister_callback(
    fun((lustre@runtime@transport:client_message(UWB)) -> nil)
) -> lustre@runtime@server@runtime:message(UWB).
deregister_callback(Callback) ->
    {client_deregistered_callback, Callback}.

-file("src/lustre/server_component.gleam", 316).
?DOC(
    " Instruct any connected clients to emit a DOM event with the given name and\n"
    " data. This lets your server component communicate to the frontend the same way\n"
    " any other HTML elements do: you might emit a `\"change\"` event when some part\n"
    " of the server component's state changes, for example.\n"
    "\n"
    " This is a real DOM event and any JavaScript on the page can attach an event\n"
    " listener to the server component element and listen for these events.\n"
).
-spec emit(binary(), gleam@json:json()) -> lustre@effect:effect(any()).
emit(Event, Data) ->
    lustre@effect:event(Event, Data).

-file("src/lustre/server_component.gleam", 339).
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
    " > **Note**: This effect does nothing on the JavaScript runtime, where `Subject`s\n"
    " > and `Selector`s don't exist, and is the equivalent of returning `effect.none()`.\n"
).
-spec select(
    fun((fun((UWG) -> nil), gleam@erlang@process:subject(any())) -> gleam@erlang@process:selector(UWG))
) -> lustre@effect:effect(UWG).
select(Sel) ->
    lustre@effect:select(Sel).

-file("src/lustre/server_component.gleam", 352).
?DOC(
    " The server component client runtime sends JSON-encoded messages for the server\n"
    " runtime to execute. Because your own WebSocket server sits between the two\n"
    " parts of the runtime, you need to decode these actions and pass them to the\n"
    " server runtime yourself.\n"
).
-spec runtime_message_decoder() -> gleam@dynamic@decode:decoder(lustre@runtime@server@runtime:message(any())).
runtime_message_decoder() ->
    gleam@dynamic@decode:map(
        lustre@runtime@transport:server_message_decoder(),
        fun(Field@0) -> {client_dispatched_message, Field@0} end
    ).

-file("src/lustre/server_component.gleam", 368).
?DOC(
    " Encode a message you can send to the client runtime to respond to. The server\n"
    " component runtime will send messages to any registered clients to instruct\n"
    " them to update their DOM or emit events, for example.\n"
    "\n"
    " Because your WebSocket server sits between the two parts of the runtime, you\n"
    " need to encode these actions and send them to the client runtime yourself.\n"
).
-spec client_message_to_json(lustre@runtime@transport:client_message(any())) -> gleam@json:json().
client_message_to_json(Message) ->
    lustre@runtime@transport:client_message_to_json(Message).
