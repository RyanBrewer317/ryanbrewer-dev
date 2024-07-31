import"./style-f76121df.js";import{q as ft,r as pt,u as dt,v as wt,x as _t,y as ht,z as $t,A as re,B as Be,D as xt,E as yt,O as f,F as y,C as d,G as bt,m as le,t as c,H as Ne,I as ke,J as h,K as ze,L as De,M as Se,N as Je,P as Ye,S as L,Q as F,R as gt,T as Ge,U as vt,s as mt,d as Z,h as It,f as o,o as Lt,p as Pe,g as ee,j as te,V as B,W as Me,i as oe,e as fe,X as Ue,Y as Ie,Z as qe}from"./html-cbea6443.js";function Q(){return dt()}function ue(e,t){return ft(e,t)}function m(e,t,n){return pt(t,n,e)}function ye(e){let n=wt(e);return _t(n)}function kt(e){return ht(e)}function Ot(e,t){return $t(e,t)}function Tt(e){let t=e;return Be("target",Be("value",xt))(t)}function Fe(e){return Ot("input",t=>{let n=Tt(t);return re(n,e)})}class he extends d{constructor(t,n){super(),this.pos=t,this.error=n}}class de extends d{constructor(t,n){super(),this.row=t,this.col=n}}class A extends d{constructor(t){super(),this.parse=t}}function b(e,t,n){let r=e.parse;return r(t,n)}function be(e){return new A((t,n)=>{if(!(n instanceof de))throw le("assignment_no_match","party",62,"","Assignment pattern did not match",{value:n});let r=n.row,s=n.col;if(t.atLeastLength(1)){let i=t.head,l=t.tail;return e(i)?i===`
`?new f([i,l,new de(r+1,0)]):new f([i,l,new de(r,s+1)]):new y(new he(n,i))}else return new y(new he(n,"EOF"))})}function _(e){return be(t=>e===t)}function j(e,t){return new A((n,r)=>bt(b(e,n,r),b(t,n,r)))}function ae(e){return new A((t,n)=>{if(e.hasLength(0))throw le("panic","party",117,"","choice doesn't accept an empty list of parsers",{});if(e.hasLength(1)){let r=e.head;return b(r,t,n)}else{let r=e.head,s=e.tail,i=b(r,t,n);if(i.isOk()){let l=i[0][0],a=i[0][1],w=i[0][2];return new f([l,a,w])}else return b(ae(s),t,n)}})}function z(e){return new A((t,n)=>{let r=b(e,t,n);if(r.isOk()){let s=r[0][0],i=r[0][1],l=r[0][2];return re(b(z(e),i,l),a=>[Ne(s,a[0]),a[1],a[2]])}else return new f([c([]),t,n])})}function je(e){return new A((t,n)=>{let r=b(e,t,n);if(r.isOk()){let s=r[0][0],i=r[0][1],l=r[0][2];return re(b(z(e),i,l),a=>[Ne(s,a[0]),a[1],a[2]])}else{let s=r[0];return new y(s)}})}function R(e,t){return new A((n,r)=>{let s=b(e,n,r);if(s.isOk()){let i=s[0][0],l=s[0][1],a=s[0][2];return new f([t(i),l,a])}else{let i=s[0];return new y(i)}})}function Oe(e){return new A((t,n)=>{let r=b(e,t,n);if(r.isOk()){let s=r[0][0],i=r[0][1],l=r[0][2];return new f([new f(s),i,l])}else return new f([new y(void 0),t,n])})}function Te(e){return new A((t,n)=>{if(b(e,t,n).isOk())if(t.atLeastLength(1)){let s=t.head;return new y(new he(n,s))}else return new y(new he(n,"EOF"));else return new f([void 0,t,n])})}function k(e){return new A((t,n)=>b(e(),t,n))}function u(e,t){return new A((n,r)=>{let s=b(e,n,r);if(s.isOk()){let i=s[0][0],l=s[0][1],a=s[0][2];return b(t(i),l,a)}else{let i=s[0];return new y(i)}})}function x(e){return new A((t,n)=>new f([e,t,n]))}function J(e){let t=kt(e);if(t.isOk()){let n=t[0][0],r=t[0][1];return u(_(n),s=>u(J(r),i=>x(s+i)))}else return x("")}function He(e,t){let n=b(e,yt(t),new de(1,1));if(n.isOk()){let r=n[0][0];return new f(r)}else{let r=n[0];return new y(r)}}function Rt(){return be(e=>ke("abcdefghijklmnopqrstuvwxyz",e))}function Et(){return be(e=>ke("ABCDEFGHIJKLMNOPQRSTUVWXYZ",e))}function Re(){return j(Rt(),Et())}function Ee(){return be(e=>ke("0123456789",e))}function ce(){return j(Ee(),Re())}let Ke=class extends d{constructor(t){super(),this[0]=t}},Qe=class extends d{constructor(t){super(),this[0]=t}},Xe=class extends d{constructor(t,n){super(),this[0]=t,this[1]=n}},Ct=class extends d{constructor(t,n){super(),this[0]=t,this[1]=n}},Ze=class extends d{constructor(t){super(),this.int=t}},pe=class extends d{constructor(t,n){super(),this.val=t,this.gen=n}},Ce=class extends d{constructor(t){super(),this[0]=t}},Ve=class extends d{constructor(t,n){super(),this[0]=t,this[1]=n}},se=class extends d{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}},$e=class extends d{constructor(t,n){super(),this[0]=t,this[1]=n}};function Vt(){let e=je(Ee()),t=R(e,ye),n=R(t,Je),r=R(n,s=>Ye(s,()=>{throw le("panic","tinylang",23,"","parsed int isn't an int",{})}));return R(r,s=>new Ke(s))}function et(){return u(Re(),e=>u(z(j(ce(),_("_"))),t=>x(e+ye(t))))}function Wt(){let e=et();return R(e,t=>new Qe(t))}function K(){return u(z(ae(c([_(" "),_("	"),_(`
`)]))),e=>x(void 0))}function At(e,t){return t(new Ze(e.int+1),e.int)}function we(e,t,n){if(t instanceof Ke){let r=t[0];return new f(new pe(new Ce(r),e))}else if(t instanceof Qe){let r=t[0],s=ue(n,r);if(s.isOk()){let i=s[0];return new f(new pe(new Ve(i,r),e))}else return new y("Wait! "+r+" isn't defined anywhere!")}else if(t instanceof Xe){let r=t[0],s=t[1];return At(e,(i,l)=>h(we(i,s,m(n,r,l)),a=>{let w=new se(l,r,a.val),$=new pe(w,a.gen);return new f($)}))}else{let r=t[0],s=t[1];return h(we(e,r,n),i=>h(we(i.gen,s,n),l=>{let a=new $e(i.val,l.val),w=new pe(a,l.gen);return new f(w)}))}}function Bt(e,t){return h(we(e,t,Q()),n=>new f(n.val))}function _e(e,t){for(;;){let n=e,r=t;if(n instanceof Ce)return n;if(n instanceof Ve){let s=n[0],i=ue(r,s);return i.isOk()?i[0]:n}else if(n instanceof $e){let s=n[0],i=n[1],l=_e(s,r),a=_e(i,r);if(l instanceof se){let w=l[0];e=l[2],t=m(r,w,a)}else return new $e(l,a)}else{let s=n[0],i=n[1],l=n[2];return new se(s,i,_e(l,r))}}}function Gt(e){return _e(e,Q())}function H(e){if(e instanceof Ce){let t=e[0];return De(t)}else{if(e instanceof Ve)return e[1];if(e instanceof se){let t=e[1],n=e[2];return"\\"+t+". "+H(n)}else if(e instanceof $e&&e[0]instanceof se){let t=e[0],n=e[1];return"("+H(t)+")("+H(n)+")"}else{let t=e[0],n=e[1];return H(t)+"("+H(n)+")"}}}function Pt(e){return e.isOk(),e[0]}function ge(){return u(K(),e=>u(ae(c([Vt(),Wt(),Mt(),Ut()])),t=>u(K(),n=>u(z(u(_("("),r=>u(k(ge),s=>u(_(")"),i=>u(K(),l=>x(s)))))),r=>{let s=Se(r,t,(i,l)=>new Ct(i,l));return x(s)}))))}function Mt(){return u(_("\\"),e=>u(K(),t=>u(et(),n=>u(K(),r=>u(_("."),s=>u(K(),i=>u(k(ge),l=>x(new Xe(n,l)))))))))}function Ut(){return u(_("("),e=>u(k(ge),t=>u(_(")"),n=>x(t))))}function qt(e){let t=h(ze(He(ge(),e),"there's a mistake in the notation somewhere; I couldn't understand it!"),n=>h(Bt(new Ze(0),n),r=>{let s=Gt(r);return new f(H(s))}));return Pt(t)}class tt extends d{constructor(t){super(),this[0]=t}}class nt extends d{constructor(t){super(),this[0]=t}}class rt extends d{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}}class st extends d{constructor(t,n){super(),this[0]=t,this[1]=n}}class it extends d{}class lt extends d{}class We extends d{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}}class Ft extends d{constructor(t,n,r,s){super(),this[0]=t,this[1]=n,this[2]=r,this[3]=s}}class ut extends d{constructor(t){super(),this.int=t}}class q extends d{constructor(t,n){super(),this.val=t,this.gen=n}}class Y extends d{constructor(t){super(),this[0]=t}}class E extends d{constructor(t,n){super(),this[0]=t,this[1]=n}}class I extends d{constructor(t,n,r,s){super(),this[0]=t,this[1]=n,this[2]=r,this[3]=s}}class P extends d{constructor(t,n){super(),this[0]=t,this[1]=n}}class v extends d{}class W extends d{}class O extends d{constructor(t,n,r,s){super(),this[0]=t,this[1]=n,this[2]=r,this[3]=s}}class N extends d{constructor(t,n,r,s,i){super(),this[0]=t,this[1]=n,this[2]=r,this[3]=s,this[4]=i}}function Nt(){let e=je(Ee()),t=R(e,ye),n=R(t,Je),r=R(n,s=>Ye(s,()=>{throw le("panic","tinytypedlang",28,"","parsed int isn't an int",{})}));return R(r,s=>new tt(s))}function ve(){return u(Re(),e=>u(z(j(ce(),_("_"))),t=>x(e+ye(t))))}function zt(){let e=ve();return R(e,t=>new nt(t))}function Dt(){return u(J("Type"),e=>u(Te(j(ce(),_("_"))),t=>x(new it)))}function St(){return u(J("Int"),e=>u(Te(j(ce(),_("_"))),t=>x(new lt)))}function C(){return u(z(ae(c([_(" "),_("	"),_(`
`)]))),e=>x(void 0))}function Le(e,t){return t(new ut(e.int+1),e.int)}function G(e,t,n){if(t instanceof tt){let r=t[0];return new f(new q(new Y(r),e))}else if(t instanceof nt){let r=t[0],s=ue(n,r);if(s.isOk()){let i=s[0];return new f(new q(new E(i,r),e))}else return new y("Wait! "+r+" isn't defined anywhere!")}else if(t instanceof rt){let r=t[0],s=t[1],i=t[2];return Le(e,(l,a)=>h(G(l,i,m(n,r,a)),w=>h((()=>{if(s instanceof L){let $=s[0];return re(G(l,$,n),g=>[new L(g.val),g.gen])}else return new f([new F,w.gen])})(),$=>{let g=$[0],U=$[1],D=new I(a,r,g,w.val),X=new q(D,U);return new f(X)})))}else if(t instanceof st){let r=t[0],s=t[1];return h(G(e,r,n),i=>h(G(i.gen,s,n),l=>{let a=new P(i.val,l.val),w=new q(a,l.gen);return new f(w)}))}else{if(t instanceof it)return new f(new q(new v,e));if(t instanceof lt)return new f(new q(new W,e));if(t instanceof We){let r=t[0],s=t[1],i=t[2];return Le(e,(l,a)=>h(G(l,s,n),w=>h(G(w.gen,i,m(n,r,a)),$=>{let g=new O(a,r,w.val,$.val),U=new q(g,$.gen);return new f(U)})))}else{let r=t[0],s=t[1],i=t[2],l=t[3];return Le(e,(a,w)=>h((()=>{if(s instanceof L){let $=s[0];return re(G(a,$,n),g=>[new L(g.val),g.gen])}else return new f([new F,a])})(),$=>{let g=$[0],U=$[1],D=m(n,r,w);return h(G(U,i,D),X=>h(G(X.gen,l,D),Ae=>{let ct=new N(w,r,g,X.val,Ae.val),ot=new q(ct,Ae.gen);return new f(ot)}))}))}}}function Jt(e,t){return h(G(e,t,Q()),n=>new f(n.val))}function me(e,t,n){let r=s=>me(s,t,n);if(e instanceof Y){let s=e[0];return new Y(s)}else if(e instanceof E){let s=e[0];return t===s?n:e}else if(e instanceof I){let s=e[0],i=e[1],l=e[2],a=e[3];return new I(s,i,Ge(l,r),r(a))}else if(e instanceof P){let s=e[0],i=e[1];return new P(r(s),r(i))}else{if(e instanceof v)return new v;if(e instanceof W)return new W;if(e instanceof O){let s=e[0],i=e[1],l=e[2],a=e[3];return new O(s,i,r(l),r(a))}else{let s=e[0],i=e[1],l=e[2],a=e[3],w=e[4];return new N(s,i,Ge(l,r),r(a),r(w))}}}function M(e,t){for(;;){let n=e,r=t;if(n instanceof Y)return n;if(n instanceof E){let s=n[0],i=ue(r,s);return i.isOk()?i[0]:n}else if(n instanceof P){let s=n[0],i=n[1],l=M(s,r),a=M(i,r);if(l instanceof I){let w=l[0];e=l[3],t=m(r,w,a)}else return new P(l,a)}else{if(n instanceof v)return new v;if(n instanceof W)return new W;if(n instanceof N){let s=n[0],i=n[3];e=n[4],t=m(r,s,M(i,r))}else if(n instanceof I){let s=n[0],i=n[1],l=n[2],a=n[3];return new I(s,i,l,M(a,r))}else{let s=n[0],i=n[1],l=n[2],a=n[3];return new O(s,i,M(l,r),M(a,r))}}}}function xe(e,t,n){let r=M(e,n),s=M(t,n);if(r instanceof E&&s instanceof E){let i=r[0],l=s[0];return i===l}else{if(r instanceof W&&s instanceof W)return!0;if(r instanceof v&&s instanceof v)return!0;if(r instanceof O&&s instanceof O){let i=r[0],l=r[1],a=r[2],w=r[3],$=s[0],g=s[2],U=s[3];return xe(a,g,n)&&xe(me(U,$,new E(i,l)),w,n)}else return!1}}function Yt(e){return M(e,Q())}function T(e,t){for(;;){let n=e,r=t;if(r instanceof E)return r[0]===n;if(r instanceof I&&r[2]instanceof L){let s=r[2][0],i=r[3];return T(n,s)||T(n,i)}else if(r instanceof I&&r[2]instanceof F){let s=r[3];e=n,t=s}else if(r instanceof P){let s=r[0],i=r[1];return T(n,s)||T(n,i)}else if(r instanceof O){let s=r[2],i=r[3];return T(n,s)||T(n,i)}else if(r instanceof N&&r[2]instanceof L){let s=r[2][0],i=r[3],l=r[4];return T(n,s)||T(n,i)||T(n,l)}else if(r instanceof N&&r[2]instanceof F){let s=r[3],i=r[4];return T(n,s)||T(n,i)}else return!1}}function p(e){if(e instanceof Y){let t=e[0];return De(t)}else{if(e instanceof E)return e[1];if(e instanceof I&&e[2]instanceof L){let t=e[1],n=e[2][0],r=e[3];return"\\"+t+": "+p(n)+". "+p(r)}else if(e instanceof I&&e[2]instanceof F){let t=e[1],n=e[3];return"\\"+t+". "+p(n)}else if(e instanceof P&&e[0]instanceof I){let t=e[0],n=e[1];return"("+p(t)+")("+p(n)+")"}else if(e instanceof P){let t=e[0],n=e[1];return p(t)+"("+p(n)+")"}else{if(e instanceof v)return"Type";if(e instanceof W)return"Int";if(e instanceof O){let t=e[0],n=e[1],r=e[2],s=e[3];return T(t,s)?"forall "+n+": "+p(r)+". "+p(s):r instanceof Y||r instanceof E||r instanceof v||r instanceof W?p(r)+"->"+p(s):(r instanceof I||r instanceof P||r instanceof O,"("+p(r)+") -> "+p(s))}else if(e instanceof N&&e[2]instanceof L){let t=e[1],n=e[2][0],r=e[3],s=e[4];return"let "+t+": "+p(n)+" = "+p(r)+`;
`+p(s)}else{let t=e[1],n=e[3],r=e[4];return"let "+t+" = "+p(n)+`;
`+p(r)}}}}function jt(e){return e.isOk(),e[0]}function ne(e,t,n,r){if(e instanceof I){let s=e[0],i=e[1],l=e[2],a=e[3];if(t instanceof O){let w=t[0],$=t[2],g=t[3];return h(ne(a,me(g,w,new E(s,i)),m(n,s,$),r),U=>{if(l instanceof L){let D=l[0];return xe(D,$,r)?new f(void 0):new y("Type mismatch in lambda parameter. Expected "+p($)+" but found "+p(D)+".")}else return new f(void 0)})}else return new y("Type mismatch. Expected "+p(t)+" but found a lambda.")}else return h(S(e,n,r),s=>xe(s,t,r)?new f(void 0):new y("Type mismatch. Expected "+p(t)+" but found "+p(s)+"."))}function S(e,t,n){if(e instanceof Y)return new f(new W);if(e instanceof E){let r=e[0],s=e[1];return gt(ue(t,r),i=>"Variable "+s+" is not defined in the current context.")}else if(e instanceof P){let r=e[0],s=e[1];return h(S(r,t,n),i=>{if(i instanceof O){let l=i[0],a=i[2],w=i[3];return h(ne(s,a,t,n),$=>new f(me(w,l,s)))}else return new y("Type error. Expected a function type, but found "+p(i))})}else if(e instanceof O){let r=e[0],s=e[2],i=e[3];return h(ne(s,new v,t,n),l=>h(ne(i,new v,m(t,r,s),n),a=>new f(new v)))}else{if(e instanceof W)return new f(new v);if(e instanceof v)return new f(new v);if(e instanceof N&&e[2]instanceof L){let r=e[0],s=e[2][0],i=e[3],l=e[4];return h(ne(i,s,t,n),a=>S(l,m(t,r,s),m(n,r,i)))}else if(e instanceof N&&e[2]instanceof F){let r=e[0],s=e[3],i=e[4];return h(S(s,t,n),l=>S(i,m(t,r,l),m(n,r,s)))}else if(e instanceof I&&e[2]instanceof L){let r=e[0],s=e[1],i=e[2][0],l=e[3];return h(S(l,m(t,r,i),n),a=>new f(new O(r,s,i,a)))}else return new y("Type error. Can't infer the type of this lambda. Try annotating it with a `let` expression.")}}function V(){return u(C(),e=>u(ae(c([Nt(),Dt(),St(),Ht(),Qt(),zt(),Kt(),Xt()])),t=>u(C(),n=>u(z(u(_("("),r=>u(k(V),s=>u(_(")"),i=>u(C(),l=>x(s)))))),r=>{let s=Se(r,t,(i,l)=>new st(i,l));return u(Oe(J("->")),i=>u((()=>i.isOk()?u(k(V),l=>x(new We("_",s,l))):x(s))(),l=>x(l)))}))))}function Ht(){return u(J("forall"),e=>u(Te(j(ce(),_("_"))),t=>u(C(),n=>u(ve(),r=>u(C(),s=>u(_(":"),i=>u(C(),l=>u(k(V),a=>u(_("."),w=>u(k(V),$=>x(new We(r,a,$))))))))))))}function Kt(){return u(_("\\"),e=>u(C(),t=>u(ve(),n=>u(C(),r=>u(Oe(_(":")),s=>u((()=>s.isOk()?R(k(V),i=>new L(i)):x(new F))(),i=>u(_("."),l=>u(C(),a=>u(k(V),w=>x(new rt(n,i,w)))))))))))}function Qt(){return u(J("let "),e=>u(C(),t=>u(ve(),n=>u(C(),r=>u(Oe(_(":")),s=>u((()=>s.isOk()?R(k(V),i=>new L(i)):x(new F))(),i=>u(J("="),l=>u(k(V),a=>u(_(";"),w=>u(k(V),$=>x(new Ft(n,i,a,$))))))))))))}function Xt(){return u(_("("),e=>u(k(V),t=>u(_(")"),n=>x(t))))}function Zt(e){let t=h(ze(He(V(),e),"there's a mistake in the notation somewhere; I couldn't understand it!"),n=>h(Jt(new ut(0),n),r=>h(S(r,Q(),Q()),s=>{let i=Yt(r);return new f(p(i))})));return jt(t)}class ie extends d{constructor(t,n){super(),this.untyped_code=t,this.deptyped_code=n}}class at extends d{constructor(t){super(),this[0]=t}}class en extends d{constructor(t){super(),this[0]=t}}function tn(e){return new ie("","")}function nn(e,t){if(t instanceof at){let n=t[0];return new ie(n,e.deptyped_code)}else{let n=t[0];return new ie(e.untyped_code,n)}}function rn(e){return Z(c([]),c([It(c([Lt(c([["padding-top","50pt"]]))]),c([o("Lambda Calculus in Gleam")])),Pe(c([]),c([o(`
I study programming language design, and I'm particularly fond of functional programming.
That's why I made this website in `),ee(c([te("https://gleam.run")]),c([o("Gleam")])),o(`,
a statically-typed functional language
that can run anywhere JavaScript can, as well as on Erlang's BEAM VM. 
I've used Gleam to write a lambda calculus evaluator that you can play with below. 
Lambda abstractions are written like 
`),B(c([]),c([o("\\var. body")])),o(", and are called like "),B(c([]),c([o("fun(arg)")])),o(". There are also positive integers like 7. Try writing "),B(c([]),c([o("(\\x.x)(2)")])),o(", which evaluates to 2. The code for this can be found "),ee(c([te("https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/tinylang.gleam")]),c([o("here")])),o(".")])),Me(c([oe("untyped-code"),fe("code"),Ue("Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)(3)"),Fe(t=>new at(t))]),""),Ie(c([])),(()=>{if(e instanceof ie&&e.untyped_code==="")return o("");{let t=e.untyped_code,n=qt(t);return(r=>Z(c([]),c([qe(c([]),c([o("output")])),o(": "),Z(c([oe("untyped-code-output"),fe("code-output")]),c([o(r)]))])))(n)}})(),Pe(c([]),c([o(`Want types in your lambda calculus?
You can check the box below to switch to a version with a fancy dependent type system!
Type annotations are introduced by `),B(c([]),c([o("let")])),o("-bindings, like "),B(c([]),c([o("let x: A = v; e")])),o(", lambdas, like "),B(c([]),c([o("\\x: A. e")])),o(", and Pi types, like "),B(c([]),c([o("forall x: A. B")])),o(". For lambdas and bindings, the types can often be "),ee(c([te("https://ncatlab.org/nlab/show/bidirectional+typechecking")]),c([o("inferred")])),o(". The type of types is "),B(c([]),c([o("Type")])),o(", whose type is "),ee(c([te("https://cs.brown.edu/courses/cs1951x/docs/logic/girard.html")]),c([o("also "),B(c([]),c([o("Type")]))])),o(". The type of numbers is "),B(c([]),c([o("Int")])),o(". The code for this extended evaluator can be found "),ee(c([te("https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/tinytypedlang.gleam")]),c([o("here")])),o(".")])),Ie(c([])),Me(c([oe("deptyped-code"),fe("code"),Ue("Play with dependent types! Example: let id: forall a: Type. a->a = \\a.\\x.x; id(Int)(3)"),Fe(t=>new en(t))]),""),Ie(c([])),(()=>{if(e instanceof ie&&e.deptyped_code==="")return o("");{let t=e.deptyped_code,n=Zt(t);return(r=>Z(c([]),c([qe(c([]),c([o("output")])),o(": "),Z(c([oe("deptyped-code-output"),fe("code-output")]),c([o(r)]))])))(n)}})()]))}function sn(){let e=vt(tn,nn,rn),t=mt(e,"[data-lustre-app]",void 0);if(!t.isOk())throw le("assignment_no_match","demos",66,"main","Assignment pattern did not match",{value:t});return t[0]}document.addEventListener("DOMContentLoaded",()=>{sn()});
