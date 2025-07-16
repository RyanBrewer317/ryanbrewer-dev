import * as $int from "../../../gleam_stdlib/gleam/int.mjs";
import { Ok, Error, CustomType as $CustomType } from "../../gleam.mjs";

export class Pos extends $CustomType {
  constructor(src, line, col) {
    super();
    this.src = src;
    this.line = line;
    this.col = col;
  }
}

export class ZeroMode extends $CustomType {}

export class ManyMode extends $CustomType {}

export class TypeMode extends $CustomType {}

export class SetSort extends $CustomType {}

export class KindSort extends $CustomType {}

export class SyntaxParam extends $CustomType {
  constructor(mode, name, ty) {
    super();
    this.mode = mode;
    this.name = name;
    this.ty = ty;
  }
}

export class LambdaSyntax extends $CustomType {
  constructor($0, $1, $2, $3, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
    this.pos = pos;
  }
}

export class IdentSyntax extends $CustomType {
  constructor($0, pos) {
    super();
    this[0] = $0;
    this.pos = pos;
  }
}

export class AppSyntax extends $CustomType {
  constructor($0, $1, $2, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this.pos = pos;
  }
}

export class LetSyntax extends $CustomType {
  constructor($0, $1, $2, $3, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
    this.pos = pos;
  }
}

export class DefSyntax extends $CustomType {
  constructor($0, $1, $2, $3, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
    this.pos = pos;
  }
}

export class NatSyntax extends $CustomType {
  constructor($0, pos) {
    super();
    this[0] = $0;
    this.pos = pos;
  }
}

export class NatTypeSyntax extends $CustomType {
  constructor(pos) {
    super();
    this.pos = pos;
  }
}

export class SortSyntax extends $CustomType {
  constructor($0, pos) {
    super();
    this[0] = $0;
    this.pos = pos;
  }
}

export class PiSyntax extends $CustomType {
  constructor($0, $1, $2, $3, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
    this.pos = pos;
  }
}

export class PsiSyntax extends $CustomType {
  constructor($0, $1, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this.pos = pos;
  }
}

export class IntersectionTypeSyntax extends $CustomType {
  constructor($0, $1, $2, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this.pos = pos;
  }
}

export class IntersectionSyntax extends $CustomType {
  constructor($0, $1, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this.pos = pos;
  }
}

export class FstSyntax extends $CustomType {
  constructor($0, pos) {
    super();
    this[0] = $0;
    this.pos = pos;
  }
}

export class SndSyntax extends $CustomType {
  constructor($0, pos) {
    super();
    this[0] = $0;
    this.pos = pos;
  }
}

export class EqSyntax extends $CustomType {
  constructor($0, $1, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this.pos = pos;
  }
}

export class ReflSyntax extends $CustomType {
  constructor($0, pos) {
    super();
    this[0] = $0;
    this.pos = pos;
  }
}

export class CastSyntax extends $CustomType {
  constructor($0, $1, $2, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this.pos = pos;
  }
}

export class ExFalsoSyntax extends $CustomType {
  constructor($0, pos) {
    super();
    this[0] = $0;
    this.pos = pos;
  }
}

export class Index extends $CustomType {
  constructor(int) {
    super();
    this.int = int;
  }
}

export class Level extends $CustomType {
  constructor(int) {
    super();
    this.int = int;
  }
}

export class Lambda extends $CustomType {
  constructor(mode) {
    super();
    this.mode = mode;
  }
}

export class Pi extends $CustomType {
  constructor(mode, ty) {
    super();
    this.mode = mode;
    this.ty = ty;
  }
}

export class InterT extends $CustomType {
  constructor(ty) {
    super();
    this.ty = ty;
  }
}

export class Let extends $CustomType {
  constructor(mode, val) {
    super();
    this.mode = mode;
    this.val = val;
  }
}

export class Sort extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class NatT extends $CustomType {}

export class Nat extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class Fst extends $CustomType {}

export class Snd extends $CustomType {}

export class ExFalso extends $CustomType {}

export class Refl extends $CustomType {}

export class App extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class Psi extends $CustomType {}

export class Inter extends $CustomType {}

export class Cast extends $CustomType {}

export class Eq extends $CustomType {}

export class Ident extends $CustomType {
  constructor($0, $1, $2, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this.pos = pos;
  }
}

export class Binder extends $CustomType {
  constructor($0, $1, $2, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this.pos = pos;
  }
}

export class Ctor0 extends $CustomType {
  constructor($0, pos) {
    super();
    this[0] = $0;
    this.pos = pos;
  }
}

export class Ctor1 extends $CustomType {
  constructor($0, $1, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this.pos = pos;
  }
}

export class Ctor2 extends $CustomType {
  constructor($0, $1, $2, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this.pos = pos;
  }
}

export class Ctor3 extends $CustomType {
  constructor($0, $1, $2, $3, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
    this.pos = pos;
  }
}

export class VNeutral extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class VSort extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class VNat extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class VNatType extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class VPi extends $CustomType {
  constructor($0, $1, $2, $3, $4) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
    this[4] = $4;
  }
}

export class VLambda extends $CustomType {
  constructor($0, $1, $2, $3) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
  }
}

export class VEq extends $CustomType {
  constructor($0, $1, $2, $3) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
  }
}

export class VRefl extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class VInter extends $CustomType {
  constructor($0, $1, $2) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
  }
}

export class VInterT extends $CustomType {
  constructor($0, $1, $2, $3) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
  }
}

export class VCast extends $CustomType {
  constructor($0, $1, $2, $3) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
  }
}

export class VExFalso extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class VIdent extends $CustomType {
  constructor($0, $1, $2, $3) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
  }
}

export class VApp extends $CustomType {
  constructor($0, $1, $2, $3) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
  }
}

export class VPsi extends $CustomType {
  constructor($0, $1, $2) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
  }
}

export class VFst extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class VSnd extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export function pretty_pos(pos) {
  return ($int.to_string(pos.line) + ":") + $int.to_string(pos.col);
}

export function pretty_mode(m) {
  if (m instanceof ZeroMode) {
    return "erased";
  } else if (m instanceof ManyMode) {
    return "relevant";
  } else {
    return "type-abstraction";
  }
}

export function get_pos(s) {
  if (s instanceof LambdaSyntax) {
    let pos = s.pos;
    return pos;
  } else if (s instanceof IdentSyntax) {
    let pos = s.pos;
    return pos;
  } else if (s instanceof AppSyntax) {
    let pos = s.pos;
    return pos;
  } else if (s instanceof LetSyntax) {
    let pos = s.pos;
    return pos;
  } else if (s instanceof DefSyntax) {
    let pos = s.pos;
    return pos;
  } else if (s instanceof NatSyntax) {
    let pos = s.pos;
    return pos;
  } else if (s instanceof NatTypeSyntax) {
    let pos = s.pos;
    return pos;
  } else if (s instanceof SortSyntax) {
    let pos = s.pos;
    return pos;
  } else if (s instanceof PiSyntax) {
    let pos = s.pos;
    return pos;
  } else if (s instanceof PsiSyntax) {
    let pos = s.pos;
    return pos;
  } else if (s instanceof IntersectionTypeSyntax) {
    let pos = s.pos;
    return pos;
  } else if (s instanceof IntersectionSyntax) {
    let pos = s.pos;
    return pos;
  } else if (s instanceof FstSyntax) {
    let pos = s.pos;
    return pos;
  } else if (s instanceof SndSyntax) {
    let pos = s.pos;
    return pos;
  } else if (s instanceof EqSyntax) {
    let pos = s.pos;
    return pos;
  } else if (s instanceof ReflSyntax) {
    let pos = s.pos;
    return pos;
  } else if (s instanceof CastSyntax) {
    let pos = s.pos;
    return pos;
  } else {
    let pos = s.pos;
    return pos;
  }
}

export function lvl_to_idx(size, lvl) {
  return new Index((size.int - lvl.int) - 1);
}

export function inc(lvl) {
  return new Level(lvl.int + 1);
}

export function neutral_pos(n) {
  if (n instanceof VIdent) {
    let pos = n[3];
    return pos;
  } else if (n instanceof VApp) {
    let pos = n[3];
    return pos;
  } else if (n instanceof VPsi) {
    let pos = n[2];
    return pos;
  } else if (n instanceof VFst) {
    let pos = n[1];
    return pos;
  } else {
    let pos = n[1];
    return pos;
  }
}

export function value_pos(v) {
  if (v instanceof VNeutral) {
    let n = v[0];
    return neutral_pos(n);
  } else if (v instanceof VSort) {
    let pos = v[1];
    return pos;
  } else if (v instanceof VNat) {
    let pos = v[1];
    return pos;
  } else if (v instanceof VNatType) {
    let pos = v[0];
    return pos;
  } else if (v instanceof VPi) {
    let pos = v[4];
    return pos;
  } else if (v instanceof VLambda) {
    let pos = v[3];
    return pos;
  } else if (v instanceof VEq) {
    let pos = v[3];
    return pos;
  } else if (v instanceof VRefl) {
    let pos = v[1];
    return pos;
  } else if (v instanceof VInter) {
    let pos = v[2];
    return pos;
  } else if (v instanceof VInterT) {
    let pos = v[3];
    return pos;
  } else if (v instanceof VCast) {
    let pos = v[3];
    return pos;
  } else {
    let pos = v[1];
    return pos;
  }
}

function quote_neutral(size, n) {
  if (n instanceof VIdent) {
    let x = n[0];
    let mode = n[1];
    let lvl = n[2];
    let pos = n[3];
    return new Ident(mode, lvl_to_idx(size, lvl), x, pos);
  } else if (n instanceof VApp) {
    let mode = n[0];
    let n$1 = n[1];
    let v = n[2];
    let p = n[3];
    return new Ctor2(new App(mode), quote_neutral(size, n$1), quote(size, v), p);
  } else if (n instanceof VPsi) {
    let e = n[0];
    let pred = n[1];
    let pos = n[2];
    return new Ctor2(new Psi(), quote_neutral(size, e), quote(size, pred), pos);
  } else if (n instanceof VFst) {
    let n$1 = n[0];
    let pos = n[1];
    return new Ctor1(new Fst(), quote_neutral(size, n$1), pos);
  } else {
    let a = n[0];
    let pos = n[1];
    return new Ctor1(new Snd(), quote_neutral(size, a), pos);
  }
}

export function quote(size, v) {
  if (v instanceof VNeutral) {
    let n = v[0];
    return quote_neutral(size, n);
  } else if (v instanceof VSort) {
    let s = v[0];
    let p = v[1];
    return new Ctor0(new Sort(s), p);
  } else if (v instanceof VNat) {
    let n = v[0];
    let p = v[1];
    return new Ctor0(new Nat(n), p);
  } else if (v instanceof VNatType) {
    let p = v[0];
    return new Ctor0(new NatT(), p);
  } else if (v instanceof VPi) {
    let x = v[0];
    let mode = v[1];
    let a = v[2];
    let b = v[3];
    let p = v[4];
    let n = new VNeutral(new VIdent(x, mode, size, p));
    return new Binder(
      new Pi(mode, quote(size, a)),
      x,
      quote(inc(size), b(n)),
      p,
    );
  } else if (v instanceof VLambda) {
    let x = v[0];
    let mode = v[1];
    let e = v[2];
    let p = v[3];
    let n = new VNeutral(new VIdent(x, mode, size, p));
    return new Binder(new Lambda(mode), x, quote(inc(size), e(n)), p);
  } else if (v instanceof VEq) {
    let a = v[0];
    let b = v[1];
    let t = v[2];
    let p = v[3];
    return new Ctor3(
      new Eq(),
      quote(size, a),
      quote(size, b),
      quote(size, t),
      p,
    );
  } else if (v instanceof VRefl) {
    let a = v[0];
    let p = v[1];
    return new Ctor1(new Refl(), quote(size, a), p);
  } else if (v instanceof VInter) {
    let a = v[0];
    let b = v[1];
    let pos = v[2];
    return new Ctor2(new Inter(), quote(size, a), quote(size, b), pos);
  } else if (v instanceof VInterT) {
    let x = v[0];
    let a = v[1];
    let b = v[2];
    let pos = v[3];
    let n = new VNeutral(new VIdent(x, new TypeMode(), size, pos));
    return new Binder(
      new InterT(quote(size, a)),
      x,
      quote(inc(size), b(n)),
      pos,
    );
  } else if (v instanceof VCast) {
    let a = v[0];
    let inter = v[1];
    let eq = v[2];
    let pos = v[3];
    return new Ctor3(
      new Cast(),
      quote(size, a),
      quote(size, inter),
      quote(size, eq),
      pos,
    );
  } else {
    let a = v[0];
    let pos = v[1];
    return new Ctor1(new ExFalso(), quote(size, a), pos);
  }
}

export function pretty_value(v) {
  if (v instanceof VNeutral) {
    let n = v[0];
    return pretty_neutral(n);
  } else if (v instanceof VSort) {
    let $ = v[0];
    if ($ instanceof SetSort) {
      return "Set";
    } else {
      return "Kind";
    }
  } else if (v instanceof VNat) {
    let n = v[0];
    return $int.to_string(n);
  } else if (v instanceof VNatType) {
    return "Nat";
  } else if (v instanceof VPi) {
    let $ = v[0];
    if ($ === "_") {
      let mode = v[1];
      let a = v[2];
      let b = v[3];
      let pos = v[4];
      let li = pretty_value(a);
      return ((() => {
        if (mode instanceof ZeroMode) {
          return ("{" + li) + "}";
        } else if (mode instanceof ManyMode) {
          return ("(" + li) + ")";
        } else {
          return ("<" + li) + ">";
        }
      })() + "=> ") + pretty_value(
        b(new VNeutral(new VIdent("_", mode, new Level(0), pos))),
      );
    } else {
      let x = $;
      let mode = v[1];
      let a = v[2];
      let b = v[3];
      let pos = v[4];
      return ((() => {
        if (mode instanceof ZeroMode) {
          return ((("{" + x) + ": ") + pretty_value(a)) + "}";
        } else if (mode instanceof ManyMode) {
          return ((("(" + x) + ": ") + pretty_value(a)) + ")";
        } else {
          return ((("<" + x) + ": ") + pretty_value(a)) + ">";
        }
      })() + "=> ") + pretty_value(
        b(new VNeutral(new VIdent(x, mode, new Level(0), pos))),
      );
    }
  } else if (v instanceof VLambda) {
    let x = v[0];
    let mode = v[1];
    let f = v[2];
    let pos = v[3];
    return ((() => {
      if (mode instanceof ZeroMode) {
        return ("{" + x) + "}";
      } else if (mode instanceof ManyMode) {
        return ("(" + x) + ")";
      } else {
        return ("<" + x) + ">";
      }
    })() + "-> ") + pretty_value(
      f(new VNeutral(new VIdent(x, mode, new Level(0), pos))),
    );
  } else if (v instanceof VEq) {
    let a = v[0];
    let b = v[1];
    let t = v[2];
    return ((((("(" + pretty_value(a)) + ") =[") + pretty_value(t)) + "] (") + pretty_value(
      b,
    )) + ")";
  } else if (v instanceof VRefl) {
    let a = v[0];
    return ("refl(" + pretty_value(a)) + ")";
  } else if (v instanceof VInter) {
    let a = v[0];
    let b = v[1];
    return ((("[" + pretty_value(a)) + ", ") + pretty_value(b)) + "]";
  } else if (v instanceof VInterT) {
    let x = v[0];
    let a = v[1];
    let b = v[2];
    let pos = v[3];
    return (((("(" + x) + ": ") + pretty_value(a)) + ")& ") + pretty_value(
      b(new VNeutral(new VIdent(x, new TypeMode(), new Level(0), pos))),
    );
  } else if (v instanceof VCast) {
    let a = v[0];
    let inter = v[1];
    let eq = v[2];
    return ((((("cast(" + pretty_value(a)) + ", ") + pretty_value(inter)) + ", ") + pretty_value(
      eq,
    )) + ")";
  } else {
    let a = v[0];
    return ("exfalso(" + pretty_value(a)) + ")";
  }
}

function pretty_neutral(n) {
  if (n instanceof VIdent) {
    let x = n[0];
    return x;
  } else if (n instanceof VApp) {
    let $ = n[0];
    if ($ instanceof ZeroMode) {
      let a = n[1];
      let b = n[2];
      return ((("(" + pretty_neutral(a)) + "){") + pretty_value(b)) + "}";
    } else if ($ instanceof ManyMode) {
      let a = n[1];
      let b = n[2];
      return ((("(" + pretty_neutral(a)) + ")(") + pretty_value(b)) + ")";
    } else {
      let a = n[1];
      let b = n[2];
      return ((("(" + pretty_neutral(a)) + ")<") + pretty_value(b)) + ">";
    }
  } else if (n instanceof VPsi) {
    let e = n[0];
    let p = n[1];
    return ((("Psi(" + pretty_neutral(e)) + ", ") + pretty_value(p)) + ")";
  } else if (n instanceof VFst) {
    let a = n[0];
    return ("(" + pretty_neutral(a)) + ").1";
  } else {
    let a = n[0];
    return ("(" + pretty_neutral(a)) + ").2";
  }
}

export function pretty_term(term) {
  if (term instanceof Ident) {
    let s = term[2];
    return s;
  } else if (term instanceof Binder) {
    let $ = term[0];
    if ($ instanceof Lambda) {
      let x = term[1];
      let e = term[2];
      let mode = $.mode;
      return (pretty_param(mode, x, new Error(undefined)) + "-> ") + pretty_term(
        e,
      );
    } else if ($ instanceof Pi) {
      let $1 = $.mode;
      if ($1 instanceof ManyMode) {
        let $2 = term[1];
        if ($2 === "_") {
          let u = term[2];
          let t = $.ty;
          return (("(" + pretty_term(t)) + ")=>") + pretty_term(u);
        } else {
          let x = $2;
          let u = term[2];
          let mode = $1;
          let t = $.ty;
          return (pretty_param(mode, x, new Ok(t)) + "=> ") + pretty_term(u);
        }
      } else {
        let x = term[1];
        let u = term[2];
        let mode = $1;
        let t = $.ty;
        return (pretty_param(mode, x, new Ok(t)) + "=> ") + pretty_term(u);
      }
    } else if ($ instanceof InterT) {
      let x = term[1];
      let u = term[2];
      let t = $.ty;
      return (pretty_param(new ManyMode(), x, new Ok(t)) + "& ") + pretty_term(
        u,
      );
    } else {
      let x = term[1];
      let e = term[2];
      let mode = $.mode;
      let v = $.val;
      return (((("let " + pretty_param(mode, x, new Error(undefined))) + " = ") + pretty_term(
        v,
      )) + " in ") + pretty_term(e);
    }
  } else if (term instanceof Ctor0) {
    let $ = term[0];
    if ($ instanceof Sort) {
      let $1 = $[0];
      if ($1 instanceof SetSort) {
        return "Set";
      } else {
        return "Kind";
      }
    } else if ($ instanceof NatT) {
      return "Nat";
    } else {
      let n = $[0];
      return $int.to_string(n);
    }
  } else if (term instanceof Ctor1) {
    let $ = term[0];
    if ($ instanceof Fst) {
      let a = term[1];
      return (".1(" + pretty_term(a)) + ")";
    } else if ($ instanceof Snd) {
      let a = term[1];
      return (".2(" + pretty_term(a)) + ")";
    } else if ($ instanceof ExFalso) {
      let a = term[1];
      return ("exfalso(" + pretty_term(a)) + ")";
    } else {
      let a = term[1];
      return ("refl(" + pretty_term(a)) + ")";
    }
  } else if (term instanceof Ctor2) {
    let $ = term[0];
    if ($ instanceof App) {
      let foo = term[1];
      let bar = term[2];
      let mode = $[0];
      return (("(" + pretty_term(foo)) + ")") + (() => {
        if (mode instanceof ZeroMode) {
          return ("{" + pretty_term(bar)) + "}";
        } else if (mode instanceof ManyMode) {
          return ("(" + pretty_term(bar)) + ")";
        } else {
          return ("<" + pretty_term(bar)) + ">";
        }
      })();
    } else if ($ instanceof Psi) {
      let eq = term[1];
      let p = term[2];
      return ((("Psi(" + pretty_term(eq)) + ", ") + pretty_term(p)) + ")";
    } else {
      let a = term[1];
      let b = term[2];
      return ((("[" + pretty_term(a)) + ", ") + pretty_term(b)) + "]";
    }
  } else {
    let $ = term[0];
    if ($ instanceof Cast) {
      let a = term[1];
      let b = term[2];
      let eq = term[3];
      return ((((("cast(" + pretty_term(a)) + ", ") + pretty_term(b)) + ", ") + pretty_term(
        eq,
      )) + ")";
    } else {
      let a = term[1];
      let b = term[2];
      return ((("(" + pretty_term(a)) + ") = (") + pretty_term(b)) + ")";
    }
  }
}

export function pretty_param(mode, x, mb_t) {
  let _block;
  if (mb_t instanceof Ok) {
    let t = mb_t[0];
    _block = (x + ": ") + pretty_term(t);
  } else {
    _block = x;
  }
  let inner = _block;
  if (mode instanceof ZeroMode) {
    return ("{" + inner) + "}";
  } else if (mode instanceof ManyMode) {
    return ("(" + inner) + ")";
  } else {
    return ("<" + inner) + ">";
  }
}

export function pretty_syntax(s) {
  if (s instanceof LambdaSyntax) {
    let $ = s[2];
    if ($ instanceof Ok) {
      let mode = s[0];
      let x = s[1];
      let e = s[3];
      let t = $[0];
      return (pretty_syntax_param(new SyntaxParam(mode, x, t)) + "-> ") + pretty_syntax(
        e,
      );
    } else {
      let mode = s[0];
      let x = s[1];
      let e = s[3];
      let outer = "-> " + pretty_syntax(e);
      if (mode instanceof ZeroMode) {
        return (("{" + x) + "}") + outer;
      } else if (mode instanceof ManyMode) {
        return (("(" + x) + ")") + outer;
      } else {
        return (("<" + x) + ">") + outer;
      }
    }
  } else if (s instanceof IdentSyntax) {
    let name = s[0];
    return name;
  } else if (s instanceof AppSyntax) {
    let $ = s[0];
    if ($ instanceof ZeroMode) {
      let foo = s[1];
      let bar = s[2];
      return ((("(" + pretty_syntax(foo)) + "){") + pretty_syntax(bar)) + "}";
    } else if ($ instanceof ManyMode) {
      let foo = s[1];
      let bar = s[2];
      return ((("(" + pretty_syntax(foo)) + ")(") + pretty_syntax(bar)) + ")";
    } else {
      let foo = s[1];
      let bar = s[2];
      return ((("(" + pretty_syntax(foo)) + ")<") + pretty_syntax(bar)) + ">";
    }
  } else if (s instanceof LetSyntax) {
    let x = s[0];
    let t = s[1];
    let v = s[2];
    let scope = s[3];
    return (((((("let " + x) + ": ") + pretty_syntax(t)) + " = ") + pretty_syntax(
      v,
    )) + " in ") + pretty_syntax(scope);
  } else if (s instanceof DefSyntax) {
    let x = s[0];
    let t = s[1];
    let v = s[2];
    let scope = s[3];
    return (((((("def " + x) + ": ") + pretty_syntax(t)) + " = ") + pretty_syntax(
      v,
    )) + " in ") + pretty_syntax(scope);
  } else if (s instanceof NatSyntax) {
    let n = s[0];
    return $int.to_string(n);
  } else if (s instanceof NatTypeSyntax) {
    return "Nat";
  } else if (s instanceof SortSyntax) {
    let $ = s[0];
    if ($ instanceof SetSort) {
      return "Set";
    } else {
      return "Kind";
    }
  } else if (s instanceof PiSyntax) {
    let mode = s[0];
    let x = s[1];
    let t = s[2];
    let u = s[3];
    return (pretty_syntax_param(new SyntaxParam(mode, x, t)) + "=> ") + pretty_syntax(
      u,
    );
  } else if (s instanceof PsiSyntax) {
    let e = s[0];
    let prop = s[1];
    return ((("Psi(" + pretty_syntax(e)) + ", ") + pretty_syntax(prop)) + ")";
  } else if (s instanceof IntersectionTypeSyntax) {
    let x = s[0];
    let t = s[1];
    let u = s[2];
    return (pretty_syntax_param(new SyntaxParam(new ManyMode(), x, t)) + "& ") + pretty_syntax(
      u,
    );
  } else if (s instanceof IntersectionSyntax) {
    let l = s[0];
    let r = s[1];
    return ((("[" + pretty_syntax(l)) + ", ") + pretty_syntax(r)) + "]";
  } else if (s instanceof FstSyntax) {
    let a = s[0];
    return ("(" + pretty_syntax(a)) + ").1";
  } else if (s instanceof SndSyntax) {
    let a = s[0];
    return ("(" + pretty_syntax(a)) + ").2";
  } else if (s instanceof EqSyntax) {
    let a = s[0];
    let b = s[1];
    return ((("(" + pretty_syntax(a)) + ") = (") + pretty_syntax(b)) + ")";
  } else if (s instanceof ReflSyntax) {
    let a = s[0];
    return ("refl(" + pretty_syntax(a)) + ")";
  } else if (s instanceof CastSyntax) {
    let a = s[0];
    let b = s[1];
    let eq = s[2];
    return ((((("cast(" + pretty_syntax(a)) + ", ") + pretty_syntax(b)) + ", ") + pretty_syntax(
      eq,
    )) + ")";
  } else {
    let a = s[0];
    return ("exfalso(" + pretty_syntax(a)) + ")";
  }
}

export function pretty_syntax_param(param) {
  let $ = param.mode;
  if ($ instanceof ZeroMode) {
    return ((("{" + param.name) + ": ") + pretty_syntax(param.ty)) + "}";
  } else if ($ instanceof ManyMode) {
    return ((("(" + param.name) + ": ") + pretty_syntax(param.ty)) + ")";
  } else {
    return ((("<" + param.name) + ": ") + pretty_syntax(param.ty)) + ">";
  }
}
