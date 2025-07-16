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
    list(lustre@vdom@vattr:attribute(UMR)),
    list(lustre@vdom@vnode:element(UMR))
) -> lustre@vdom@vnode:element(UMR).
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
        <<"var a=class{withFields(e){let n=Object.keys(this).map(t=>t in e?e[t]:this[t]);return new this.constructor(...n)}};var It=5,ne=Math.pow(2,It),zn=ne-1,On=ne/2,Tn=ne/4;var Pe=[\" \",\"	\",`\\n`,\"\\v\",\"\\f\",\"\\r\",\"\\x85\",\"\\u2028\",\"\\u2029\"].join(\"\"),yr=new RegExp(`^[${Pe}]*`),gr=new RegExp(`[${Pe}]*$`);var y=()=>globalThis?.document,oe=\"http://www.w3.org/1999/xhtml\",le=1,ae=3,ce=11,He=!!globalThis.HTMLElement?.prototype?.moveBefore;var rt=0;var it=1;var st=2;var ut=0;var de=2;var S=class extends a{constructor(e,n,t,r,s,u){super(),this.kind=e,this.key=n,this.mapper=t,this.children=r,this.keyed_children=s,this.children_count=u}};function A(i){return i instanceof S?1+i.children_count:1}var ot=0;var lt=1;var at=2;var ct=3;var ft=\"	\";var ht=0;var mt=1;var xt=2;var he=3;var wt=4;var me=5;var xe=6;var we=7;var D=class{offset=0;#r=null;#e=()=>{};#t=!1;#n=!1;constructor(e,n,{useServerEvents:t=!1,exposeKeys:r=!1}={}){this.#r=e,this.#e=n,this.#t=t,this.#n=r}mount(e){X(this.#r,this.#p(this.#r,0,e))}#i=[];push(e){let n=this.offset;n&&(w(e.changes,t=>{switch(t.kind){case xe:case he:t.before=(t.before|0)+n;break;case we:case me:t.from=(t.from|0)+n;break}}),w(e.children,t=>{t.index=(t.index|0)+n})),this.#i.push({node:this.#r,patch:e}),this.#s()}#s(){let e=this;for(;e.#i.length;){let{node:n,patch:t}=e.#i.pop();w(t.changes,u=>{switch(u.kind){case xe:e.#u(n,u.children,u.before);break;case he:e.#a(n,u.key,u.before,u.count);break;case wt:e.#l(n,u.key,u.count);break;case we:e.#o(n,u.from,u.count);break;case me:e.#f(n,u.from,u.count,u.with);break;case ht:e.#d(n,u.content);break;case mt:e.#_(n,u.inner_html);break;case xt:e.#x(n,u.added,u.removed);break}}),t.removed&&e.#o(n,n.childNodes.length-t.removed,t.removed);let r=-1,s=null;w(t.children,u=>{let o=u.index|0,$=s&&r-o===1?s.previousSibling:L(n,o);e.#i.push({node:$,patch:u}),s=$,r=o})}}#u(e,n,t){let r=gt(),s=t|0;w(n,u=>{let o=this.#p(e,s,u);X(r,o),s+=A(u)}),$e(e,r,L(e,t))}#a(e,n,t,r){let s=vt(e,n),u=L(e,t);for(let o=0;o<r&&s!==null;++o){let $=s.nextSibling;He?e.moveBefore(s,u):$e(e,s,u),s=$}}#l(e,n,t){this.#c(e,vt(e,n),t)}#o(e,n,t){this.#c(e,L(e,n),t)}#c(e,n,t){for(;t-- >0&&n!==null;){let r=n.nextSibling,s=n[l].key;s&&e[l].keyedChildren.delete(s);for(let[u,{timeout:o}]of n[l].debouncers??[])clearTimeout(o);e.removeChild(n),n=r}}#f(e,n,t,r){this.#o(e,n,t);let s=this.#p(e,n,r);$e(e,s,L(e,n))}#d(e,n){e.data=n??\"\"}#_(e,n){e.innerHTML=n??\"\"}#x(e,n,t){w(t,r=>{let s=r.name;e[l].handlers.has(s)?(e.removeEventListener(s,be),e[l].handlers.delete(s),e[l].throttles.has(s)&&e[l].throttles.delete(s),e[l].debouncers.has(s)&&(clearTimeout(e[l].debouncers.get(s).timeout),e[l].debouncers.delete(s))):(e.removeAttribute(s),jt[s]?.removed?.(e,s))}),w(n,r=>{this.#m(e,r)})}#p(e,n,t){switch(t.kind){case lt:{let r=bt(e,n,t);return this.#h(r,t),this.#u(r,t.children),r}case at:return yt(e,n,t);case ot:{let r=gt(),s=yt(e,n,t);X(r,s);let u=n+1;return w(t.children,o=>{X(r,this.#p(e,u,o)),u+=A(o)}),r}case ct:{let r=bt(e,n,t);return this.#h(r,t),this.#_(r,t.inner_html),r}}}#h(e,{key:n,attributes:t}){this.#n&&n&&e.setAttribute(\"data-lustre-key\",n),w(t,r=>this.#m(e,r))}#m(e,n){let{debouncers:t,handlers:r,throttles:s}=e[l],{kind:u,name:o,value:$,prevent_default:je,stop_propagation:Tt,immediate:Z,include:Nt,debounce:Ee,throttle:Se}=n;switch(u){case rt:{let c=$??\"\";if(o===\"virtual:defaultValue\"){e.defaultValue=c;return}c!==e.getAttribute(o)&&e.setAttribute(o,c),jt[o]?.added?.(e,$);break}case it:e[o]=$;break;case st:{if(r.has(o)&&e.removeEventListener(o,be),e.addEventListener(o,be,{passive:je.kind===ut}),Se>0){let c=s.get(o)??{};c.delay=Se,s.set(o,c)}else s.delete(o);if(Ee>0){let c=t.get(o)??{};c.delay=Ee,t.set(o,c)}else clearTimeout(t.get(o)?.timeout),t.delete(o);r.set(o,c=>{je.kind===de&&c.preventDefault(),Tt.kind===de&&c.stopPropagation();let g=c.type,ee=c.currentTarget[l].path,te=this.#t?bn(c,Nt??[]):c,v=s.get(g);if(v){let Ae=Date.now(),Mt=v.last||0;Ae>Mt+v.delay&&(v.last=Ae,v.lastEvent=c,this.#e(te,ee,g,Z))}let B=t.get(g);B&&(clearTimeout(B.timeout),B.timeout=setTimeout(()=>{c!==s.get(g)?.lastEvent&&this.#e(te,ee,g,Z)},B.delay)),!v&&!B&&this.#e(te,ee,g,Z)});break}}}},w=(i,e)=>{if(Array.isArray(i))for(let n=0;n<i.length;n++)e(i[n]);else if(i)for(i;i.tail;i=i.tail)e(i.head)},X=(i,e)=>i.appendChild(e),$e=(i,e,n)=>i.insertBefore(e,n??null),bt=(i,e,{key:n,tag:t,namespace:r})=>{let s=y().createElementNS(r||oe,t);return P(i,s,e,n),s},yt=(i,e,{key:n,content:t})=>{let r=y().createTextNode(t??\"\");return P(i,r,e,n),r},gt=()=>y().createDocumentFragment(),L=(i,e)=>i.childNodes[e|0],l=Symbol(\"lustre\"),P=(i,e,n=0,t=\"\")=>{let r=`${t||n}`;switch(e.nodeType){case le:case ce:e[l]={key:t,path:r,keyedChildren:new Map,handlers:new Map,throttles:new Map,debouncers:new Map};break;case ae:e[l]={key:t};break}i&&i[l]&&t&&i[l].keyedChildren.set(t,new WeakRef(e)),i&&i[l]&&i[l].path&&(e[l].path=`${i[l].path}${ft}${r}`)};var vt=(i,e)=>i[l].keyedChildren.get(e).deref(),be=i=>{let n=i.currentTarget[l].handlers.get(i.type);i.type===\"submit\"&&(i.detail??={},i.detail.formData=[...new FormData(i.target).entries()]),n(i)},bn=(i,e=[])=>{let n={};(i.type===\"input\"||i.type===\"change\")&&e.push(\"target.value\"),i.type===\"submit\"&&e.push(\"detail.formData\");for(let t of e){let r=t.split(\".\");for(let s=0,u=i,o=n;s<r.length;s++){if(s===r.length-1){o[r[s]]=u[r[s]];break}o=o[r[s]]??={},u=u[r[s]]}}return n},kt=i=>({added(e){e[i]=!0},removed(e){e[i]=!1}}),yn=i=>({added(e,n){e[i]=n}}),jt={checked:kt(\"checked\"),selected:kt(\"selected\"),value:yn(\"value\"),autofocus:{added(i){queueMicrotask(()=>i.focus?.())}},autoplay:{added(i){try{i.play?.()}catch(e){console.error(e)}}}};var Et=new WeakMap;async function St(i){let e=[];for(let t of y().querySelectorAll(\"link[rel=stylesheet], style\"))t.sheet||e.push(new Promise((r,s)=>{t.addEventListener(\"load\",r),t.addEventListener(\"error\",s)}));if(await Promise.allSettled(e),!i.host.isConnected)return[];i.adoptedStyleSheets=i.host.getRootNode().adoptedStyleSheets;let n=[];for(let t of y().styleSheets)try{i.adoptedStyleSheets.push(t)}catch{try{let r=Et.get(t);if(!r){r=new CSSStyleSheet;for(let s of t.cssRules)r.insertRule(s.cssText,r.cssRules.length);Et.set(t,r)}i.adoptedStyleSheets.push(r)}catch{let r=t.ownerNode.cloneNode();i.prepend(r),n.push(r)}}return n}var At=0;var Bt=1;var Ct=2;var K=0;var zt=1;var Ot=2;var Q=3;var ye=class extends HTMLElement{static get observedAttributes(){return[\"route\",\"method\"]}#r;#e=\"ws\";#t=null;#n=null;#i=[];#s;#u=new Set;#a=new Set;#l=!1;#o=[];#c=new MutationObserver(e=>{let n=[];for(let t of e){if(t.type!==\"attributes\")continue;let r=t.attributeName;(!this.#l||this.#u.has(r))&&n.push([r,this.getAttribute(r)])}if(n.length===1){let[t,r]=n[0];this.#n?.send({kind:K,name:t,value:r})}else n.length?this.#n?.send({kind:Q,messages:n.map(([t,r])=>({kind:K,name:t,value:r}))}):this.#o.push(...n)});constructor(){super(),this.internals=this.attachInternals(),this.#c.observe(this,{attributes:!0})}connectedCallback(){for(let e of this.attributes)this.#o.push([e.name,e.value])}attributeChangedCallback(e,n,t){switch(e){case(n!==t&&\"route\"):{this.#t=new URL(t,location.href),this.#f();return}case\"method\":{let r=t.toLowerCase();if(r==this.#e)return;[\"ws\",\"sse\",\"polling\"].includes(r)&&(this.#e=r,this.#e==\"ws\"&&(this.#t.protocol==\"https:\"&&(this.#t.protocol=\"wss:\"),this.#t.protocol==\"http:\"&&(this.#t.protocol=\"ws:\")),this.#f());return}}}async messageReceivedCallback(e){switch(e.kind){case At:{for(this.#r??=this.attachShadow({mode:e.open_shadow_root?\"open\":\"closed\"}),P(null,this.#r,\"\");this.#r.firstChild;)this.#r.firstChild.remove();this.#s=new D(this.#r,(t,r,s)=>{this.#n?.send({kind:zt,path:r,name:s,event:t})},{useServerEvents:!0}),this.#u=new Set(e.observed_attributes);let n=this.#o.filter(([t])=>this.#u.has(t));n.length&&this.#n.send({kind:Q,messages:n.map(([t,r])=>({kind:K,name:t,value:r}))}),this.#o=[],this.#a=new Set(e.observed_properties);for(let t of this.#a)Object.defineProperty(this,t,{get(){return this[`_${t}`]},set(r){this[`_${t}`]=r,this.#n?.send({kind:Ot,name:t,value:r})}});e.will_adopt_styles&&await this.#d(),this.#s.mount(e.vdom),this.dispatchEvent(new CustomEvent(\"lustre:mount\"));break}case Bt:{this.#s.push(e.patch);break}case Ct:{this.dispatchEvent(new CustomEvent(e.name,{detail:e.data}));break}}}#f(){if(!this.#t||!this.#e)return;this.#n&&this.#n.close();let r={onConnect:()=>{this.#l=!0,this.dispatchEvent(new CustomEvent(\"lustre:connect\"),{detail:{route:this.#t,method:this.#e}})},onMessage:s=>{this.messageReceivedCallback(s)},onClose:()=>{this.#l=!1,this.dispatchEvent(new CustomEvent(\"lustre:close\"),{detail:{route:this.#t,method:this.#e}})}};switch(this.#e){case\"ws\":this.#n=new ge(this.#t,r);break;case\"sse\":this.#n=new ve(this.#t,r);break;case\"polling\":this.#n=new ke(this.#t,r);break}}async#d(){for(;this.#i.length;)this.#i.pop().remove(),this.#r.firstChild.remove();this.#i=await St(this.#r),this.#s.offset=this.#i.length}},ge=class{#r;#e;#t=!1;#n=[];#i;#s;#u;constructor(e,{onConnect:n,onMessage:t,onClose:r}){this.#r=e,this.#e=new WebSocket(this.#r),this.#i=n,this.#s=t,this.#u=r,this.#e.onopen=()=>{this.#i()},this.#e.onmessage=({data:s})=>{try{this.#s(JSON.parse(s))}finally{this.#n.length?this.#e.send(JSON.stringify({kind:Q,messages:this.#n})):this.#t=!1,this.#n=[]}},this.#e.onclose=()=>{this.#u()}}send(e){if(this.#t||this.#e.readyState!==WebSocket.OPEN){this.#n.push(e);return}else this.#e.send(JSON.stringify(e)),this.#t=!0}close(){this.#e.close()}},ve=class{#r;#e;#t;#n;#i;constructor(e,{onConnect:n,onMessage:t,onClose:r}){this.#r=e,this.#e=new EventSource(this.#r),this.#t=n,this.#n=t,this.#i=r,this.#e.onopen=()=>{this.#t()},this.#e.onmessage=({data:s})=>{try{this.#n(JSON.parse(s))}catch{}}}send(e){}close(){this.#e.close(),this.#i()}},ke=class{#r;#e;#t;#n;#i;#s;constructor(e,{onConnect:n,onMessage:t,onClose:r,...s}){this.#r=e,this.#n=n,this.#i=t,this.#s=r,this.#e=s.interval??5e3,this.#u().finally(()=>{this.#n(),this.#t=setInterval(()=>this.#u(),this.#e)})}async send(e){}close(){clearInterval(this.#t),this.#s()}#u(){return fetch(this.#r).then(e=>e.json()).then(this.#i).catch(console.error)}};customElements.define(\"lustre-server-component\",ye);export{ye as ServerComponent};"/utf8>>
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
-spec include(lustre@vdom@vattr:attribute(UND), list(binary())) -> lustre@vdom@vattr:attribute(UND).
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
-spec subject(lustre:runtime(UNH)) -> gleam@erlang@process:subject(lustre@runtime@server@runtime:message(UNH)).
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
                        start => 20392,
                        'end' => 20452,
                        pattern_start => 20403,
                        pattern_end => 20410})
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
    gleam@erlang@process:subject(lustre@runtime@transport:client_message(UNP))
) -> lustre@runtime@server@runtime:message(UNP).
register_subject(Client) ->
    {client_registered_subject, Client}.

-file("src/lustre/server_component.gleam", 272).
?DOC(
    " Deregister a `Subject` to stop receiving messages and updates from Lustre's\n"
    " server component runtime. The subject should first have been registered with\n"
    " [`register_subject`](#register_subject) otherwise this will do nothing.\n"
).
-spec deregister_subject(
    gleam@erlang@process:subject(lustre@runtime@transport:client_message(UNT))
) -> lustre@runtime@server@runtime:message(UNT).
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
    fun((lustre@runtime@transport:client_message(UNX)) -> nil)
) -> lustre@runtime@server@runtime:message(UNX).
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
    fun((lustre@runtime@transport:client_message(UOA)) -> nil)
) -> lustre@runtime@server@runtime:message(UOA).
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
    fun((fun((UOF) -> nil), gleam@erlang@process:subject(any())) -> gleam@erlang@process:selector(UOF))
) -> lustre@effect:effect(UOF).
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
