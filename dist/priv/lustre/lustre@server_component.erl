-module(lustre@server_component).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([component/1, script/0, route/1, data/1, include/1, subscribe/2, unsubscribe/1, emit/2, set_selector/1, decode_action/1, encode_patch/1]).

-spec component(list(lustre@internals@vdom:attribute(RWJ))) -> lustre@internals@vdom:element(RWJ).
component(Attrs) ->
    lustre@element:element(<<"lustre-server-component"/utf8>>, Attrs, []).

-spec script() -> lustre@internals@vdom:element(any()).
script() ->
    lustre@element:element(
        <<"script"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"module"/utf8>>)],
        [lustre@element:text(
                <<"function A(n,e,o,r=!1){let s,i=[{prev:n,next:e,parent:n.parentNode}];for(;i.length;){let{prev:t,next:a,parent:l}=i.pop();if(a.subtree!==void 0&&(a=a.subtree()),a.content!==void 0)if(t)if(t.nodeType===Node.TEXT_NODE)t.textContent!==a.content&&(t.textContent=a.content),s??=t;else{let c=document.createTextNode(a.content);l.replaceChild(c,t),s??=c}else{let c=document.createTextNode(a.content);l.appendChild(c),s??=c}else if(a.tag!==void 0){let c=D({prev:t,next:a,dispatch:o,stack:i,isComponent:r});t?t!==c&&l.replaceChild(c,t):l.appendChild(c),s??=c}else a.elements!==void 0?w(a,c=>{i.unshift({prev:t,next:c,parent:l}),t=t?.nextSibling}):a.subtree!==void 0&&i.push({prev:t,next:a,parent:l})}return s}function J(n,e,o,r=0){let s=n.parentNode;for(let i of e[0]){let t=i[0].split(\"-\"),a=i[1],l=k(s,t,r),c;if(l!==null&&l!==s)c=A(l,a,o);else{let u=k(s,t.slice(0,-1),r),f=document.createTextNode(\"\");u.appendChild(f),c=A(f,a,o)}t===\"0\"&&(n=c)}for(let i of e[1]){let t=i[0].split(\"-\");k(s,t,r).remove()}for(let i of e[2]){let t=i[0].split(\"-\"),a=i[1],l=k(s,t,r),c=S.get(l);for(let u of a[0]){let f=u[0],g=u[1];if(f.startsWith(\"data-lustre-on-\")){let p=f.slice(15),N=o(M);c.has(p)||el.addEventListener(p,b),c.set(p,N),el.setAttribute(f,g)}else l.setAttribute(f,g),l[f]=g}for(let u of a[1])if(u[0].startsWith(\"data-lustre-on-\")){let f=u[0].slice(15);l.removeEventListener(f,b),c.delete(f)}else l.removeAttribute(u[0])}return n}function D({prev:n,next:e,dispatch:o,stack:r}){let s=e.namespace||\"http://www.w3.org/1999/xhtml\",i=n&&n.nodeType===Node.ELEMENT_NODE&&n.localName===e.tag&&n.namespaceURI===(e.namespace||\"http://www.w3.org/1999/xhtml\"),t=i?n:s?document.createElementNS(s,e.tag):document.createElement(e.tag),a;if(S.has(t))a=S.get(t);else{let h=new Map;S.set(t,h),a=h}let l=i?new Set(a.keys()):null,c=i?new Set(Array.from(n.attributes,h=>h.name)):null,u=null,f=null,g=null;for(let h of e.attrs){let d=h[0],m=h[1];if(h.as_property)t[d]!==m&&(t[d]=m),i&&c.delete(d);else if(d.startsWith(\"on\")){let y=d.slice(2),E=o(m);a.has(y)||t.addEventListener(y,b),a.set(y,E),i&&l.delete(y)}else if(d.startsWith(\"data-lustre-on-\")){let y=d.slice(15),E=o(M);a.has(y)||t.addEventListener(y,b),a.set(y,E),t.setAttribute(d,m)}else d===\"class\"?u=u===null?m:u+\" \"+m:d===\"style\"?f=f===null?m:f+m:d===\"dangerous-unescaped-html\"?g=m:(t.getAttribute(d)!==m&&t.setAttribute(d,m),(d===\"value\"||d===\"selected\")&&(t[d]=m),i&&c.delete(d))}if(u!==null&&(t.setAttribute(\"class\",u),i&&c.delete(\"class\")),f!==null&&(t.setAttribute(\"style\",f),i&&c.delete(\"style\")),i){for(let h of c)t.removeAttribute(h);for(let h of l)a.delete(h),t.removeEventListener(h,b)}if(e.key!==void 0&&e.key!==\"\")t.setAttribute(\"data-lustre-key\",e.key);else if(g!==null)return t.innerHTML=g,t;let p=t.firstChild,N=null,T=null,L=null,x=e.children[Symbol.iterator]().next().value;i&&x!==void 0&&x.key!==void 0&&x.key!==\"\"&&(N=new Set,T=C(n),L=C(e));for(let h of e.children)w(h,d=>{d.key!==void 0&&N!==null?p=R(p,d,t,r,L,T,N):(r.unshift({prev:p,next:d,parent:t}),p=p?.nextSibling)});for(;p;){let h=p.nextSibling;t.removeChild(p),p=h}return t}var S=new WeakMap;function b(n){let e=n.currentTarget;if(!S.has(e)){e.removeEventListener(n.type,b);return}let o=S.get(e);if(!o.has(n.type)){e.removeEventListener(n.type,b);return}o.get(n.type)(n)}function M(n){let e=n.currentTarget,o=e.getAttribute(`data-lustre-on-${n.type}`),r=JSON.parse(e.getAttribute(\"data-lustre-data\")||\"{}\"),s=JSON.parse(e.getAttribute(\"data-lustre-include\")||\"[]\");switch(n.type){case\"input\":case\"change\":s.push(\"target.value\");break}return{tag:o,data:s.reduce((i,t)=>{let a=t.split(\".\");for(let l=0,c=i,u=n;l<a.length;l++)l===a.length-1?c[a[l]]=u[a[l]]:(c[a[l]]??={},u=u[a[l]],c=c[a[l]]);return i},{data:r})}}function C(n){let e=new Map;if(n)for(let o of n.children)w(o,r=>{let s=r?.key||r?.getAttribute?.(\"data-lustre-key\");s&&e.set(s,r)});return e}function k(n,e,o){let r,s,i=n,t=!0;for(;[r,...s]=e,r!==void 0;)i=i.childNodes.item(t?r+o:r),t=!1,e=s;return i}function R(n,e,o,r,s,i,t){for(;n&&!s.has(n.getAttribute(\"data-lustre-key\"));){let l=n.nextSibling;o.removeChild(n),n=l}if(i.size===0)return w(e,l=>{r.unshift({prev:n,next:l,parent:o}),n=n?.nextSibling}),n;if(t.has(e.key))return console.warn(`Duplicate key found in Lustre vnode: ${e.key}`),r.unshift({prev:null,next:e,parent:o}),n;t.add(e.key);let a=i.get(e.key);if(!a&&!n)return r.unshift({prev:null,next:e,parent:o}),n;if(!a&&n!==null){let l=document.createTextNode(\"\");return o.insertBefore(l,n),r.unshift({prev:l,next:e,parent:o}),n}return!a||a===n?(r.unshift({prev:n,next:e,parent:o}),n=n?.nextSibling,n):(o.insertBefore(a,n),r.unshift({prev:a,next:e,parent:o}),n)}function w(n,e){if(n.elements!==void 0)for(let o of n.elements)w(o,e);else n.subtree!==void 0?w(n.subtree(),e):e(n)}var O=class extends HTMLElement{static get observedAttributes(){return[\"route\"]}#i=null;#n=null;#e=null;#t;#s=[];constructor(){super(),this.#t=this.attachShadow({mode:\"closed\"}),this.#n=document.createElement(\"div\"),this.#i=new MutationObserver(e=>{let o=[];for(let r of e)if(r.type===\"attributes\"){let{attributeName:s,oldValue:i}=r,t=this.getAttribute(s);if(i!==t)try{o.push([s,JSON.parse(t)])}catch{o.push([s,t])}}o.length&&this.#e?.send(JSON.stringify([5,o]))})}connectedCallback(){this.adoptStyleSheets().finally(()=>{this.#t.append(this.#n)})}attributeChangedCallback(e,o,r){switch(e){case\"route\":if(!r)this.#e?.close(),this.#e=null;else if(o!==r){let s=this.getAttribute(\"id\"),i=r+(s?`?id=${s}`:\"\"),t=window.location.protocol===\"https:\"?\"wss\":\"ws\";this.#e?.close(),this.#e=new WebSocket(`${t}://${window.location.host}${i}`),this.#e.addEventListener(\"message\",a=>this.messageReceivedCallback(a))}}}messageReceivedCallback({data:e}){let[o,...r]=JSON.parse(e);switch(o){case 0:return this.diff(r);case 1:return this.emit(r);case 2:return this.init(r)}}init([e,o]){let r=[];for(let s of e)s in this?r.push([s,this[s]]):this.hasAttribute(s)&&r.push([s,this.getAttribute(s)]),Object.defineProperty(this,s,{get(){return this[`_${s}`]??this.getAttribute(s)},set(i){let t=this[s];typeof i==\"string\"?this.setAttribute(s,i):this[`_${s}`]=i,t!==i&&this.#e?.send(JSON.stringify([5,[[s,i]]]))}});this.#i.observe(this,{attributeFilter:e,attributeOldValue:!0,attributes:!0,characterData:!1,characterDataOldValue:!1,childList:!1,subtree:!1}),this.morph(o),r.length&&this.#e?.send(JSON.stringify([5,r]))}morph(e){this.#n=A(this.#n,e,o=>r=>{let s=JSON.parse(this.getAttribute(\"data-lustre-data\")||\"{}\"),i=o(r);i.data=P(s,i.data),this.#e?.send(JSON.stringify([4,i.tag,i.data]))})}diff([e]){this.#n=J(this.#n,e,o=>r=>{let s=o(r);this.#e?.send(JSON.stringify([4,s.tag,s.data]))},this.#s.length)}emit([e,o]){this.dispatchEvent(new CustomEvent(e,{detail:o}))}disconnectedCallback(){this.#e?.close()}async adoptStyleSheets(){let e=[],o=[...document.styleSheets];for(let s of document.querySelectorAll(\"link[rel=stylesheet]\"))o.includes(s.sheet)||e.push(new Promise((i,t)=>{s.addEventListener(\"load\",i),s.addEventListener(\"error\",t)}));for(await Promise.allSettled(e);this.#s.length;)this.#s.shift().remove();let r=[];this.#t.adoptedStyleSheets=this.getRootNode().adoptedStyleSheets;for(let s of document.styleSheets){try{this.#t.adoptedStyleSheets.push(s);continue}catch{}try{let i=new CSSStyleSheet;for(let t of s.cssRules)i.insertRule(t.cssText);this.#t.adoptedStyleSheets.push(i)}catch{let i=s.ownerNode.cloneNode();this.#t.prepend(i),this.#s.push(i),r.push(new Promise((t,a)=>{i.onload=t,i.onerror=a}))}}return Promise.allSettled(r)}adoptStyleSheet(e){this.#t.adoptedStyleSheets.push(e)}get adoptedStyleSheets(){return this.#t.adoptedStyleSheets}};window.customElements.define(\"lustre-server-component\",O);function P(n,e){for(let o in e)e[o]instanceof Object&&Object.assign(e[o],P(n[o],e[o]));return Object.assign(n||{},e),n}export{O as LustreServerComponent};"/utf8>>
            )]
    ).

-spec route(binary()) -> lustre@internals@vdom:attribute(any()).
route(Path) ->
    lustre@attribute:attribute(<<"route"/utf8>>, Path).

-spec data(gleam@json:json()) -> lustre@internals@vdom:attribute(any()).
data(Json) ->
    _pipe = Json,
    _pipe@1 = gleam@json:to_string(_pipe),
    lustre@attribute:attribute(<<"data-lustre-data"/utf8>>, _pipe@1).

-spec include(list(binary())) -> lustre@internals@vdom:attribute(any()).
include(Properties) ->
    _pipe = Properties,
    _pipe@1 = gleam@json:array(_pipe, fun gleam@json:string/1),
    _pipe@2 = gleam@json:to_string(_pipe@1),
    lustre@attribute:attribute(<<"data-lustre-include"/utf8>>, _pipe@2).

-spec subscribe(binary(), fun((lustre@internals@patch:patch(RWW)) -> nil)) -> lustre@internals@runtime:action(RWW, lustre:server_component()).
subscribe(Id, Renderer) ->
    {subscribe, Id, Renderer}.

-spec unsubscribe(binary()) -> lustre@internals@runtime:action(any(), lustre:server_component()).
unsubscribe(Id) ->
    {unsubscribe, Id}.

-spec emit(binary(), gleam@json:json()) -> lustre@effect:effect(any()).
emit(Event, Data) ->
    lustre@effect:event(Event, Data).

-spec do_set_selector(
    gleam@erlang@process:selector(lustre@internals@runtime:action(any(), RXM))
) -> lustre@effect:effect(RXM).
do_set_selector(Sel) ->
    lustre@effect:from(
        fun(_) ->
            Self = gleam@erlang@process:new_subject(),
            gleam@erlang@process:send(Self, {set_selector, Sel})
        end
    ).

-spec set_selector(
    gleam@erlang@process:selector(lustre@internals@runtime:action(any(), RXG))
) -> lustre@effect:effect(RXG).
set_selector(Sel) ->
    do_set_selector(Sel).

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
                            gleam@int:to_string(4),
                            gleam@int:to_string(Kind),
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

-spec decode_attr(gleam@dynamic:dynamic_()) -> {ok,
        {binary(), gleam@dynamic:dynamic_()}} |
    {error, list(gleam@dynamic:decode_error())}.
decode_attr(Dyn) ->
    (gleam@dynamic:tuple2(
        fun gleam@dynamic:string/1,
        fun gleam@dynamic:dynamic/1
    ))(Dyn).

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
                            gleam@int:to_string(5),
                            gleam@int:to_string(Kind),
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

-spec decode_action(gleam@dynamic:dynamic_()) -> {ok,
        lustre@internals@runtime:action(any(), lustre:server_component())} |
    {error, list(gleam@dynamic:decode_error())}.
decode_action(Dyn) ->
    (gleam@dynamic:any([fun decode_event/1, fun decode_attrs/1]))(Dyn).

-spec encode_patch(lustre@internals@patch:patch(any())) -> gleam@json:json().
encode_patch(Patch) ->
    lustre@internals@patch:patch_to_json(Patch).
