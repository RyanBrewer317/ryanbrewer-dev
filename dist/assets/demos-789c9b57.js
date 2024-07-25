import"./style-a98dc50f.js";import{o as ft,q as pt,r as dt,u as wt,v as _t,x as ht,y as $t,z as re,A as Be,B as xt,D as yt,O as f,E as y,C as d,F as bt,t as c,G as ze,m as xe,H as Le,I as h,J as De,K as Fe,L as Se,M as Je,N as je,S as k,P as N,Q as gt,R as Ge,s as vt,a as mt,d as Z,h as It,f as o,n as kt,p as Pe,g as ee,j as te,T as B,U as Me,i as ce,e as oe,V as Ue,W as Ie,X as qe}from"./html-d8b23ff7.js";function X(){return dt()}function le(e,t){return ft(e,t)}function m(e,t,n){return pt(t,n,e)}function ye(e){let n=wt(e);return _t(n)}function Lt(e){return ht(e)}function Tt(e,t){return $t(e,t)}function Ot(e){let t=e;return Be("target",Be("value",xt))(t)}function Ne(e){return Tt("input",t=>{let n=Ot(t);return re(n,e)})}class _e extends d{constructor(t){super(),this.error=t}}class pe extends d{constructor(t,n){super(),this.row=t,this.col=n}}class A extends d{constructor(t){super(),this.parse=t}}function b(e,t,n){let r=e.parse;return r(t,n)}function be(e){return new A((t,n)=>{if(!(n instanceof pe))throw xe("assignment_no_match","party",58,"","Assignment pattern did not match",{value:n});let r=n.row,s=n.col;if(t.atLeastLength(1)){let i=t.head,l=t.tail;return e(i)?i===`
`?new f([i,l,new pe(r+1,0)]):new f([i,l,new pe(r,s+1)]):new y(new _e(i))}else return new y(new _e("EOF"))})}function _(e){return be(t=>e===t)}function H(e,t){return new A((n,r)=>bt(b(e,n,r),b(t,n,r)))}function ue(e){return new A((t,n)=>{if(e.hasLength(0))return new y(new _e("choiceless choice"));if(e.hasLength(1)){let r=e.head;return b(r,t,n)}else{let r=e.head,s=e.tail,i=b(r,t,n);if(i.isOk()){let l=i[0][0],a=i[0][1],w=i[0][2];return new f([l,a,w])}else return b(ue(s),t,n)}})}function D(e){return new A((t,n)=>{let r=b(e,t,n);if(r.isOk()){let s=r[0][0],i=r[0][1],l=r[0][2];return re(b(D(e),i,l),a=>[ze(s,a[0]),a[1],a[2]])}else return new f([c([]),t,n])})}function He(e){return new A((t,n)=>{let r=b(e,t,n);if(r.isOk()){let s=r[0][0],i=r[0][1],l=r[0][2];return re(b(D(e),i,l),a=>[ze(s,a[0]),a[1],a[2]])}else{let s=r[0];return new y(s)}})}function R(e,t){return new A((n,r)=>{let s=b(e,n,r);if(s.isOk()){let i=s[0][0],l=s[0][1],a=s[0][2];return new f([t(i),l,a])}else{let i=s[0];return new y(i)}})}function Te(e){return new A((t,n)=>{let r=b(e,t,n);if(r.isOk()){let s=r[0][0],i=r[0][1],l=r[0][2];return new f([new f(s),i,l])}else return new f([new y(void 0),t,n])})}function Oe(e){return new A((t,n)=>b(e,t,n).isOk()?new y(new _e("")):new f([void 0,t,n]))}function L(e){return new A((t,n)=>b(e(),t,n))}function u(e,t){return new A((n,r)=>{let s=b(e,n,r);if(s.isOk()){let i=s[0][0],l=s[0][1],a=s[0][2];return b(t(i),l,a)}else{let i=s[0];return new y(i)}})}function x(e){return new A((t,n)=>new f([e,t,n]))}function J(e){let t=Lt(e);if(t.isOk()){let n=t[0][0],r=t[0][1];return u(_(n),s=>u(J(r),i=>x(s+i)))}else return x("")}function Ke(e,t){let n=b(e,yt(t),new pe(1,1));if(n.isOk()){let r=n[0][0];return new f(r)}else{let r=n[0];return new y(r)}}function Rt(){return be(e=>Le("abcdefghijklmnopqrstuvwxyz",e))}function Ct(){return be(e=>Le("ABCDEFGHIJKLMNOPQRSTUVWXYZ",e))}function Re(){return H(Rt(),Ct())}function Ce(){return be(e=>Le("0123456789",e))}function ae(){return H(Ce(),Re())}let Qe=class extends d{constructor(t){super(),this[0]=t}},Xe=class extends d{constructor(t){super(),this[0]=t}},Ye=class extends d{constructor(t,n){super(),this[0]=t,this[1]=n}},Et=class extends d{constructor(t,n){super(),this[0]=t,this[1]=n}},Ze=class extends d{constructor(t){super(),this.int=t}},fe=class extends d{constructor(t,n){super(),this.val=t,this.gen=n}},Ee=class extends d{constructor(t){super(),this[0]=t}},Ve=class extends d{constructor(t,n){super(),this[0]=t,this[1]=n}},se=class extends d{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}},he=class extends d{constructor(t,n){super(),this[0]=t,this[1]=n}};function Vt(){let e=He(Ce()),t=R(e,ye),n=R(t,Je),r=R(n,s=>je(s,()=>{throw xe("panic","tinylang",19,"","parsed int isn't an int",{})}));return R(r,s=>new Qe(s))}function et(){return u(Re(),e=>u(D(H(ae(),_("_"))),t=>x(e+ye(t))))}function Wt(){let e=et();return R(e,t=>new Xe(t))}function Q(){return u(D(ue(c([_(" "),_("	"),_(`
`)]))),e=>x(void 0))}function At(e,t){return t(new Ze(e.int+1),e.int)}function de(e,t,n){if(t instanceof Qe){let r=t[0];return new f(new fe(new Ee(r),e))}else if(t instanceof Xe){let r=t[0],s=le(n,r);if(s.isOk()){let i=s[0];return new f(new fe(new Ve(i,r),e))}else return new y("Wait! "+r+" isn't defined anywhere!")}else if(t instanceof Ye){let r=t[0],s=t[1];return At(e,(i,l)=>h(de(i,s,m(n,r,l)),a=>{let w=new se(l,r,a.val),$=new fe(w,a.gen);return new f($)}))}else{let r=t[0],s=t[1];return h(de(e,r,n),i=>h(de(i.gen,s,n),l=>{let a=new he(i.val,l.val),w=new fe(a,l.gen);return new f(w)}))}}function Bt(e,t){return h(de(e,t,X()),n=>new f(n.val))}function we(e,t){for(;;){let n=e,r=t;if(n instanceof Ee)return n;if(n instanceof Ve){let s=n[0],i=le(r,s);return i.isOk()?i[0]:n}else if(n instanceof he){let s=n[0],i=n[1],l=we(s,r),a=we(i,r);if(l instanceof se){let w=l[0];e=l[2],t=m(r,w,a)}else return new he(l,a)}else{let s=n[0],i=n[1],l=n[2];return new se(s,i,we(l,r))}}}function Gt(e){return we(e,X())}function K(e){if(e instanceof Ee){let t=e[0];return Fe(t)}else{if(e instanceof Ve)return e[1];if(e instanceof se){let t=e[1],n=e[2];return"\\"+t+". "+K(n)}else if(e instanceof he&&e[0]instanceof se){let t=e[0],n=e[1];return"("+K(t)+")("+K(n)+")"}else{let t=e[0],n=e[1];return K(t)+"("+K(n)+")"}}}function Pt(e){return e.isOk(),e[0]}function ge(){return u(Q(),e=>u(ue(c([Vt(),Wt(),Mt(),Ut()])),t=>u(Q(),n=>u(D(u(_("("),r=>u(L(ge),s=>u(_(")"),i=>u(Q(),l=>x(s)))))),r=>{let s=Se(r,t,(i,l)=>new Et(i,l));return x(s)}))))}function Mt(){return u(_("\\"),e=>u(Q(),t=>u(et(),n=>u(Q(),r=>u(_("."),s=>u(Q(),i=>u(L(ge),l=>x(new Ye(n,l)))))))))}function Ut(){return u(_("("),e=>u(L(ge),t=>u(_(")"),n=>x(t))))}function qt(e){let t=h(De(Ke(ge(),e),"there's a mistake in the notation somewhere; I couldn't understand it!"),n=>h(Bt(new Ze(0),n),r=>{let s=Gt(r);return new f(K(s))}));return Pt(t)}class tt extends d{constructor(t){super(),this[0]=t}}class nt extends d{constructor(t){super(),this[0]=t}}class rt extends d{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}}class st extends d{constructor(t,n){super(),this[0]=t,this[1]=n}}class it extends d{}class lt extends d{}class We extends d{constructor(t,n,r){super(),this[0]=t,this[1]=n,this[2]=r}}class Nt extends d{constructor(t,n,r,s){super(),this[0]=t,this[1]=n,this[2]=r,this[3]=s}}class ut extends d{constructor(t){super(),this.int=t}}class q extends d{constructor(t,n){super(),this.val=t,this.gen=n}}class j extends d{constructor(t){super(),this[0]=t}}class C extends d{constructor(t,n){super(),this[0]=t,this[1]=n}}class I extends d{constructor(t,n,r,s){super(),this[0]=t,this[1]=n,this[2]=r,this[3]=s}}class P extends d{constructor(t,n){super(),this[0]=t,this[1]=n}}class v extends d{}class W extends d{}class T extends d{constructor(t,n,r,s){super(),this[0]=t,this[1]=n,this[2]=r,this[3]=s}}class z extends d{constructor(t,n,r,s,i){super(),this[0]=t,this[1]=n,this[2]=r,this[3]=s,this[4]=i}}function zt(){let e=He(Ce()),t=R(e,ye),n=R(t,Je),r=R(n,s=>je(s,()=>{throw xe("panic","tinytypedlang",24,"","parsed int isn't an int",{})}));return R(r,s=>new tt(s))}function ve(){return u(Re(),e=>u(D(H(ae(),_("_"))),t=>x(e+ye(t))))}function Dt(){let e=ve();return R(e,t=>new nt(t))}function Ft(){return u(J("Type"),e=>u(Oe(H(ae(),_("_"))),t=>x(new it)))}function St(){return u(J("Int"),e=>u(Oe(H(ae(),_("_"))),t=>x(new lt)))}function E(){return u(D(ue(c([_(" "),_("	"),_(`
`)]))),e=>x(void 0))}function ke(e,t){return t(new ut(e.int+1),e.int)}function G(e,t,n){if(t instanceof tt){let r=t[0];return new f(new q(new j(r),e))}else if(t instanceof nt){let r=t[0],s=le(n,r);if(s.isOk()){let i=s[0];return new f(new q(new C(i,r),e))}else return new y("Wait! "+r+" isn't defined anywhere!")}else if(t instanceof rt){let r=t[0],s=t[1],i=t[2];return ke(e,(l,a)=>h(G(l,i,m(n,r,a)),w=>h((()=>{if(s instanceof k){let $=s[0];return re(G(l,$,n),g=>[new k(g.val),g.gen])}else return new f([new N,w.gen])})(),$=>{let g=$[0],U=$[1],F=new I(a,r,g,w.val),Y=new q(F,U);return new f(Y)})))}else if(t instanceof st){let r=t[0],s=t[1];return h(G(e,r,n),i=>h(G(i.gen,s,n),l=>{let a=new P(i.val,l.val),w=new q(a,l.gen);return new f(w)}))}else{if(t instanceof it)return new f(new q(new v,e));if(t instanceof lt)return new f(new q(new W,e));if(t instanceof We){let r=t[0],s=t[1],i=t[2];return ke(e,(l,a)=>h(G(l,s,n),w=>h(G(w.gen,i,m(n,r,a)),$=>{let g=new T(a,r,w.val,$.val),U=new q(g,$.gen);return new f(U)})))}else{let r=t[0],s=t[1],i=t[2],l=t[3];return ke(e,(a,w)=>h((()=>{if(s instanceof k){let $=s[0];return re(G(a,$,n),g=>[new k(g.val),g.gen])}else return new f([new N,a])})(),$=>{let g=$[0],U=$[1],F=m(n,r,w);return h(G(U,i,F),Y=>h(G(Y.gen,l,F),Ae=>{let ct=new z(w,r,g,Y.val,Ae.val),ot=new q(ct,Ae.gen);return new f(ot)}))}))}}}function Jt(e,t){return h(G(e,t,X()),n=>new f(n.val))}function me(e,t,n){let r=s=>me(s,t,n);if(e instanceof j){let s=e[0];return new j(s)}else if(e instanceof C){let s=e[0];return t===s?n:e}else if(e instanceof I){let s=e[0],i=e[1],l=e[2],a=e[3];return new I(s,i,Ge(l,r),r(a))}else if(e instanceof P){let s=e[0],i=e[1];return new P(r(s),r(i))}else{if(e instanceof v)return new v;if(e instanceof W)return new W;if(e instanceof T){let s=e[0],i=e[1],l=e[2],a=e[3];return new T(s,i,r(l),r(a))}else{let s=e[0],i=e[1],l=e[2],a=e[3],w=e[4];return new z(s,i,Ge(l,r),r(a),r(w))}}}function M(e,t){for(;;){let n=e,r=t;if(n instanceof j)return n;if(n instanceof C){let s=n[0],i=le(r,s);return i.isOk()?i[0]:n}else if(n instanceof P){let s=n[0],i=n[1],l=M(s,r),a=M(i,r);if(l instanceof I){let w=l[0];e=l[3],t=m(r,w,a)}else return new P(l,a)}else{if(n instanceof v)return new v;if(n instanceof W)return new W;if(n instanceof z){let s=n[0],i=n[3];e=n[4],t=m(r,s,M(i,r))}else if(n instanceof I){let s=n[0],i=n[1],l=n[2],a=n[3];return new I(s,i,l,M(a,r))}else{let s=n[0],i=n[1],l=n[2],a=n[3];return new T(s,i,M(l,r),M(a,r))}}}}function $e(e,t,n){let r=M(e,n),s=M(t,n);if(r instanceof C&&s instanceof C){let i=r[0],l=s[0];return i===l}else{if(r instanceof W&&s instanceof W)return!0;if(r instanceof v&&s instanceof v)return!0;if(r instanceof T&&s instanceof T){let i=r[0],l=r[1],a=r[2],w=r[3],$=s[0],g=s[2],U=s[3];return $e(a,g,n)&&$e(me(U,$,new C(i,l)),w,n)}else return!1}}function jt(e){return M(e,X())}function O(e,t){for(;;){let n=e,r=t;if(r instanceof C)return r[0]===n;if(r instanceof I&&r[2]instanceof k){let s=r[2][0],i=r[3];return O(n,s)||O(n,i)}else if(r instanceof I&&r[2]instanceof N){let s=r[3];e=n,t=s}else if(r instanceof P){let s=r[0],i=r[1];return O(n,s)||O(n,i)}else if(r instanceof T){let s=r[2],i=r[3];return O(n,s)||O(n,i)}else if(r instanceof z&&r[2]instanceof k){let s=r[2][0],i=r[3],l=r[4];return O(n,s)||O(n,i)||O(n,l)}else if(r instanceof z&&r[2]instanceof N){let s=r[3],i=r[4];return O(n,s)||O(n,i)}else return!1}}function p(e){if(e instanceof j){let t=e[0];return Fe(t)}else{if(e instanceof C)return e[1];if(e instanceof I&&e[2]instanceof k){let t=e[1],n=e[2][0],r=e[3];return"\\"+t+": "+p(n)+". "+p(r)}else if(e instanceof I&&e[2]instanceof N){let t=e[1],n=e[3];return"\\"+t+". "+p(n)}else if(e instanceof P&&e[0]instanceof I){let t=e[0],n=e[1];return"("+p(t)+")("+p(n)+")"}else if(e instanceof P){let t=e[0],n=e[1];return p(t)+"("+p(n)+")"}else{if(e instanceof v)return"Type";if(e instanceof W)return"Int";if(e instanceof T){let t=e[0],n=e[1],r=e[2],s=e[3];return O(t,s)?"forall "+n+": "+p(r)+". "+p(s):r instanceof j||r instanceof C||r instanceof v||r instanceof W?p(r)+"->"+p(s):(r instanceof I||r instanceof P||r instanceof T,"("+p(r)+") -> "+p(s))}else if(e instanceof z&&e[2]instanceof k){let t=e[1],n=e[2][0],r=e[3],s=e[4];return"let "+t+": "+p(n)+" = "+p(r)+`;
`+p(s)}else{let t=e[1],n=e[3],r=e[4];return"let "+t+" = "+p(n)+`;
`+p(r)}}}}function Ht(e){return e.isOk(),e[0]}function ne(e,t,n,r){if(e instanceof I){let s=e[0],i=e[1],l=e[2],a=e[3];if(t instanceof T){let w=t[0],$=t[2],g=t[3];return h(ne(a,me(g,w,new C(s,i)),m(n,s,$),r),U=>{if(l instanceof k){let F=l[0];return $e(F,$,r)?new f(void 0):new y("Type mismatch in lambda parameter. Expected "+p($)+" but found "+p(F)+".")}else return new f(void 0)})}else return new y("Type mismatch. Expected "+p(t)+" but found a lambda.")}else return h(S(e,n,r),s=>$e(s,t,r)?new f(void 0):new y("Type mismatch. Expected "+p(t)+" but found "+p(s)+"."))}function S(e,t,n){if(e instanceof j)return new f(new W);if(e instanceof C){let r=e[0],s=e[1];return gt(le(t,r),i=>"Variable "+s+" is not defined in the current context.")}else if(e instanceof P){let r=e[0],s=e[1];return h(S(r,t,n),i=>{if(i instanceof T){let l=i[0],a=i[2],w=i[3];return h(ne(s,a,t,n),$=>new f(me(w,l,s)))}else return new y("Type error. Expected a function type, but found "+p(i))})}else if(e instanceof T){let r=e[0],s=e[2],i=e[3];return h(ne(s,new v,t,n),l=>h(ne(i,new v,m(t,r,s),n),a=>new f(new v)))}else{if(e instanceof W)return new f(new v);if(e instanceof v)return new f(new v);if(e instanceof z&&e[2]instanceof k){let r=e[0],s=e[2][0],i=e[3],l=e[4];return h(ne(i,s,t,n),a=>S(l,m(t,r,s),m(n,r,i)))}else if(e instanceof z&&e[2]instanceof N){let r=e[0],s=e[3],i=e[4];return h(S(s,t,n),l=>S(i,m(t,r,l),m(n,r,s)))}else if(e instanceof I&&e[2]instanceof k){let r=e[0],s=e[1],i=e[2][0],l=e[3];return h(S(l,m(t,r,i),n),a=>new f(new T(r,s,i,a)))}else return new y("Type error. Can't infer the type of this lambda. Try annotating it with a `let` expression.")}}function V(){return u(E(),e=>u(ue(c([zt(),Ft(),St(),Kt(),Xt(),Dt(),Qt(),Yt()])),t=>u(E(),n=>u(D(u(_("("),r=>u(L(V),s=>u(_(")"),i=>u(E(),l=>x(s)))))),r=>{let s=Se(r,t,(i,l)=>new st(i,l));return u(Te(J("->")),i=>u((()=>i.isOk()?u(L(V),l=>x(new We("_",s,l))):x(s))(),l=>x(l)))}))))}function Kt(){return u(J("forall"),e=>u(Oe(H(ae(),_("_"))),t=>u(E(),n=>u(ve(),r=>u(E(),s=>u(_(":"),i=>u(E(),l=>u(L(V),a=>u(_("."),w=>u(L(V),$=>x(new We(r,a,$))))))))))))}function Qt(){return u(_("\\"),e=>u(E(),t=>u(ve(),n=>u(E(),r=>u(Te(_(":")),s=>u((()=>s.isOk()?R(L(V),i=>new k(i)):x(new N))(),i=>u(_("."),l=>u(E(),a=>u(L(V),w=>x(new rt(n,i,w)))))))))))}function Xt(){return u(J("let "),e=>u(E(),t=>u(ve(),n=>u(E(),r=>u(Te(_(":")),s=>u((()=>s.isOk()?R(L(V),i=>new k(i)):x(new N))(),i=>u(J("="),l=>u(L(V),a=>u(_(";"),w=>u(L(V),$=>x(new Nt(n,i,a,$))))))))))))}function Yt(){return u(_("("),e=>u(L(V),t=>u(_(")"),n=>x(t))))}function Zt(e){let t=h(De(Ke(V(),e),"there's a mistake in the notation somewhere; I couldn't understand it!"),n=>h(Jt(new ut(0),n),r=>h(S(r,X(),X()),s=>{let i=jt(r);return new f(p(i))})));return Ht(t)}class ie extends d{constructor(t,n){super(),this.untyped_code=t,this.deptyped_code=n}}class at extends d{constructor(t){super(),this[0]=t}}class en extends d{constructor(t){super(),this[0]=t}}function tn(e){return new ie("","")}function nn(e,t){if(t instanceof at){let n=t[0];return new ie(n,e.deptyped_code)}else{let n=t[0];return new ie(e.untyped_code,n)}}function rn(e){return Z(c([]),c([It(c([kt(c([["padding-top","50pt"]]))]),c([o("Lambda Calculus in Gleam")])),Pe(c([]),c([o(`
I study programming language design, and I'm particularly fond of functional programming.
That's why I made this website in `),ee(c([te("https://gleam.run")]),c([o("Gleam")])),o(`,
a statically-typed functional language
that can run anywhere JavaScript can, as well as on Erlang's BEAM VM. 
I've used Gleam to write a lambda calculus evaluator that you can play with below. 
Lambda abstractions are written like 
`),B(c([]),c([o("\\var. body")])),o(", and are called like "),B(c([]),c([o("fun(arg)")])),o(". There are also positive integers like 7. Try writing "),B(c([]),c([o("(\\x.x)(2)")])),o(", which evaluates to 2. The code for this can be found "),ee(c([te("https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/tinylang.gleam")]),c([o("here")])),o(".")])),Me(c([ce("untyped-code"),oe("code"),Ue("Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)(3)"),Ne(t=>new at(t))])),Ie(c([])),(()=>{if(e instanceof ie&&e.untyped_code==="")return o("");{let t=e.untyped_code,n=qt(t);return(r=>Z(c([]),c([qe(c([]),c([o("output")])),o(": "),Z(c([ce("untyped-code-output"),oe("code-output")]),c([o(r)]))])))(n)}})(),Pe(c([]),c([o(`Want types in your lambda calculus?
You can check the box below to switch to a version with a fancy dependent type system!
Type annotations are introduced by `),B(c([]),c([o("let")])),o("-bindings, like "),B(c([]),c([o("let x: A = v; e")])),o(", lambdas, like "),B(c([]),c([o("\\x: A. e")])),o(", and Pi types, like "),B(c([]),c([o("forall x: A. B")])),o(". For lambdas and bindings, the types can often be "),ee(c([te("https://ncatlab.org/nlab/show/bidirectional+typechecking")]),c([o("inferred")])),o(". The type of types is "),B(c([]),c([o("Type")])),o(", whose type is "),ee(c([te("https://cs.brown.edu/courses/cs1951x/docs/logic/girard.html")]),c([o("also "),B(c([]),c([o("Type")]))])),o(". The type of numbers is "),B(c([]),c([o("Int")])),o(". The code for this extended evaluator can be found "),ee(c([te("https://github.com/RyanBrewer317/ryanbrewer-dev/blob/main/src/tinytypedlang.gleam")]),c([o("here")])),o(".")])),Ie(c([])),Me(c([ce("deptyped-code"),oe("code"),Ue("Play with dependent types! Example: let id: forall a: Type. a->a = \\a.\\x.x; id(Int)(3)"),Ne(t=>new en(t))])),Ie(c([])),(()=>{if(e instanceof ie&&e.deptyped_code==="")return o("");{let t=e.deptyped_code,n=Zt(t);return(r=>Z(c([]),c([qe(c([]),c([o("output")])),o(": "),Z(c([ce("deptyped-code-output"),oe("code-output")]),c([o(r)]))])))(n)}})()]))}function sn(){let e=mt(tn,nn,rn),t=vt(e,"[data-lustre-app]",void 0);if(!t.isOk())throw xe("assignment_no_match","demos",62,"main","Assignment pattern did not match",{value:t});return t[0]}document.addEventListener("DOMContentLoaded",()=>{sn()});
