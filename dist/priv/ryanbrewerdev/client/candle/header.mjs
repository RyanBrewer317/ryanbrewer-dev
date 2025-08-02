import * as $int from "../../../gleam_stdlib/gleam/int.mjs";
import * as $list from "../../../gleam_stdlib/gleam/list.mjs";
import { Ok, Error, toList, Empty as $Empty, CustomType as $CustomType } from "../../gleam.mjs";
import { get, set, make as new$, next_id } from "./ffi.mjs";

export { get, new$, next_id, set };

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

export class Implicit extends $CustomType {}

export class Explicit extends $CustomType {}

export class SyntaxParam extends $CustomType {
  constructor(mode, implicit, name, ty) {
    super();
    this.mode = mode;
    this.implicit = implicit;
    this.name = name;
    this.ty = ty;
  }
}

export class LambdaSyntax extends $CustomType {
  constructor($0, $1, $2, $3, $4, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
    this[4] = $4;
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
  constructor($0, $1, $2, $3, $4, pos) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
    this[4] = $4;
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

export class HoleSyntax extends $CustomType {
  constructor(pos) {
    super();
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

export class Solved extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class Unsolved extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class Lambda extends $CustomType {
  constructor(mode, implicit) {
    super();
    this.mode = mode;
    this.implicit = implicit;
  }
}

export class Pi extends $CustomType {
  constructor(mode, implicit, ty) {
    super();
    this.mode = mode;
    this.implicit = implicit;
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

export class ContextMask extends $CustomType {
  constructor(has_def, mode) {
    super();
    this.has_def = has_def;
    this.mode = mode;
  }
}

export class Meta extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class InsertedMeta extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
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

export class VIdent extends $CustomType {
  constructor($0, $1, $2, $3, $4) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
    this[4] = $4;
  }
}

export class VMeta extends $CustomType {
  constructor($0, $1, $2, $3) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
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
  constructor($0, $1, $2, $3, $4, $5) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
    this[4] = $4;
    this[5] = $5;
  }
}

export class VLambda extends $CustomType {
  constructor($0, $1, $2, $3, $4) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
    this[4] = $4;
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

export class VApp extends $CustomType {
  constructor($0, $1, $2) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
  }
}

export class VPsi extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class VFst extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class VSnd extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
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

function in_mode(inner, mode) {
  if (mode instanceof ZeroMode) {
    return ("<" + inner) + ">";
  } else if (mode instanceof ManyMode) {
    return ("(" + inner) + ")";
  } else {
    return ("<" + inner) + ">";
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
  } else if (s instanceof ExFalsoSyntax) {
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

export function term_pos(t) {
  if (t instanceof Ident) {
    let pos = t.pos;
    return pos;
  } else if (t instanceof Binder) {
    let pos = t.pos;
    return pos;
  } else if (t instanceof Ctor0) {
    let pos = t.pos;
    return pos;
  } else if (t instanceof Ctor1) {
    let pos = t.pos;
    return pos;
  } else if (t instanceof Ctor2) {
    let pos = t.pos;
    return pos;
  } else {
    let pos = t.pos;
    return pos;
  }
}

function pretty_imp(implicit) {
  if (implicit instanceof Implicit) {
    return "? ";
  } else {
    return "";
  }
}

export function inc(lvl) {
  return new Level(lvl.int + 1);
}

export function spine_pos(s) {
  if (s instanceof VApp) {
    let pos = s[2];
    return pos;
  } else if (s instanceof VPsi) {
    let pos = s[1];
    return pos;
  } else if (s instanceof VFst) {
    let pos = s[0];
    return pos;
  } else {
    let pos = s[0];
    return pos;
  }
}

export function value_pos(v) {
  if (v instanceof VIdent) {
    let spine = v[3];
    let pos = v[4];
    let $ = $list.reverse(spine);
    if ($ instanceof $Empty) {
      return pos;
    } else {
      let s = $.head;
      return spine_pos(s);
    }
  } else if (v instanceof VMeta) {
    let pos = v[3];
    return pos;
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
    let pos = v[5];
    return pos;
  } else if (v instanceof VLambda) {
    let pos = v[4];
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

function quote_spine(size) {
  return (base, entry) => {
    if (entry instanceof VApp) {
      let mode = entry[0];
      let v = entry[1];
      let p = entry[2];
      return new Ctor2(new App(mode), base, quote(size, v), p);
    } else if (entry instanceof VPsi) {
      let pred = entry[0];
      let pos = entry[1];
      return new Ctor2(new Psi(), base, quote(size, pred), pos);
    } else if (entry instanceof VFst) {
      let pos = entry[0];
      return new Ctor1(new Fst(), base, pos);
    } else {
      let pos = entry[0];
      return new Ctor1(new Snd(), base, pos);
    }
  };
}

export function quote(size, v) {
  if (v instanceof VIdent) {
    let x = v[0];
    let mode = v[1];
    let lvl = v[2];
    let spine = v[3];
    let pos = v[4];
    return $list.fold(
      spine,
      new Ident(mode, lvl_to_idx(size, lvl), x, pos),
      quote_spine(size),
    );
  } else if (v instanceof VMeta) {
    let ref = v[0];
    let spine = v[2];
    let pos = v[3];
    return $list.fold(spine, new Ctor0(new Meta(ref), pos), quote_spine(size));
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
    let imp = v[2];
    let a = v[3];
    let b = v[4];
    let p = v[5];
    let n = new VIdent(x, mode, size, toList([]), p);
    return new Binder(
      new Pi(mode, imp, quote(size, a)),
      x,
      quote(inc(size), b(n)),
      p,
    );
  } else if (v instanceof VLambda) {
    let x = v[0];
    let mode = v[1];
    let imp = v[2];
    let e = v[3];
    let p = v[4];
    let n = new VIdent(x, mode, size, toList([]), p);
    return new Binder(new Lambda(mode, imp), x, quote(inc(size), e(n)), p);
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
    let n = new VIdent(x, new TypeMode(), size, toList([]), pos);
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

export function pretty_term(loop$term) {
  while (true) {
    let term = loop$term;
    if (term instanceof Ident) {
      let s = term[2];
      return s;
    } else if (term instanceof Binder) {
      let $ = term[0];
      if ($ instanceof Lambda) {
        let x = term[1];
        let e = term[2];
        let mode = $.mode;
        let imp = $.implicit;
        return (pretty_param(mode, imp, x, new Error(undefined)) + "-> ") + pretty_term(
          e,
        );
      } else if ($ instanceof Pi) {
        let $1 = $.mode;
        if ($1 instanceof ManyMode) {
          let $2 = term[1];
          if ($2 === "_") {
            let u = term[2];
            let imp = $.implicit;
            let t = $.ty;
            return ((("(" + pretty_imp(imp)) + pretty_term(t)) + ")=>") + pretty_term(
              u,
            );
          } else {
            let x = $2;
            let u = term[2];
            let mode = $1;
            let imp = $.implicit;
            let t = $.ty;
            return (pretty_param(mode, imp, x, new Ok(t)) + "=> ") + pretty_term(
              u,
            );
          }
        } else {
          let x = term[1];
          let u = term[2];
          let mode = $1;
          let imp = $.implicit;
          let t = $.ty;
          return (pretty_param(mode, imp, x, new Ok(t)) + "=> ") + pretty_term(
            u,
          );
        }
      } else if ($ instanceof InterT) {
        let x = term[1];
        let u = term[2];
        let t = $.ty;
        return (pretty_param(new ManyMode(), new Explicit(), x, new Ok(t)) + "& ") + pretty_term(
          u,
        );
      } else {
        let x = term[1];
        let e = term[2];
        let mode = $.mode;
        let v = $.val;
        return (((("let " + pretty_param(
          mode,
          new Explicit(),
          x,
          new Error(undefined),
        )) + " = ") + pretty_term(v)) + " in ") + pretty_term(e);
      }
    } else if (term instanceof Ctor0) {
      let $ = term[0];
      if ($ instanceof Meta) {
        let ref = $[0];
        let $1 = get(ref);
        if ($1 instanceof Solved) {
          let v = $1[0];
          return pretty_value(v);
        } else {
          let i = $1[0];
          return "?m" + $int.to_string(i);
        }
      } else if ($ instanceof InsertedMeta) {
        let pos = term.pos;
        let ref = $[0];
        loop$term = new Ctor0(new Meta(ref), pos);
      } else if ($ instanceof Sort) {
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
        return (("(" + pretty_term(foo)) + ")") + in_mode(
          pretty_term(bar),
          mode,
        );
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
}

export function pretty_param(mode, implicit, x, mb_t) {
  let _block;
  if (mb_t instanceof Ok) {
    let t = mb_t[0];
    _block = (x + ": ") + pretty_term(t);
  } else {
    _block = x;
  }
  let inner = _block;
  let _block$1;
  if (implicit instanceof Implicit) {
    _block$1 = "? " + inner;
  } else {
    _block$1 = inner;
  }
  let _pipe = _block$1;
  return in_mode(_pipe, mode);
}

export function pretty_value(loop$v) {
  while (true) {
    let v = loop$v;
    if (v instanceof VIdent) {
      let x = v[0];
      let spine = v[3];
      return $list.fold(spine, x, pretty_spine_entry);
    } else if (v instanceof VMeta) {
      let $ = v[2];
      if ($ instanceof $Empty) {
        let ref = v[0];
        let $1 = get(ref);
        if ($1 instanceof Solved) {
          let v$1 = $1[0];
          loop$v = v$1;
        } else {
          let i = $1[0];
          return "?m" + $int.to_string(i);
        }
      } else {
        let ref = v[0];
        let erased = v[1];
        let spine = $;
        let pos = v[3];
        return $list.fold(
          spine,
          pretty_value(new VMeta(ref, erased, toList([]), pos)),
          pretty_spine_entry,
        );
      }
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
        let imp = v[2];
        let a = v[3];
        let b = v[4];
        let pos = v[5];
        let li = pretty_imp(imp) + pretty_value(a);
        return (in_mode(li, mode) + "=> ") + pretty_value(
          b(new VIdent("_", mode, new Level(0), toList([]), pos)),
        );
      } else {
        let x = $;
        let mode = v[1];
        let imp = v[2];
        let a = v[3];
        let b = v[4];
        let pos = v[5];
        return ((() => {
          let inner = ((pretty_imp(imp) + x) + ": ") + pretty_value(a);
          return in_mode(inner, mode);
        })() + "=> ") + pretty_value(
          b(new VIdent(x, mode, new Level(0), toList([]), pos)),
        );
      }
    } else if (v instanceof VLambda) {
      let x = v[0];
      let mode = v[1];
      let imp = v[2];
      let f = v[3];
      let pos = v[4];
      return (in_mode(pretty_imp(imp) + x, mode) + "-> ") + pretty_value(
        f(new VIdent(x, mode, new Level(0), toList([]), pos)),
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
        b(new VIdent(x, new TypeMode(), new Level(0), toList([]), pos)),
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
}

function pretty_spine_entry(base, s) {
  if (s instanceof VApp) {
    let mode = s[0];
    let b = s[1];
    return (("(" + base) + ")") + in_mode(pretty_value(b), mode);
  } else if (s instanceof VPsi) {
    let p = s[0];
    return ((("Psi(" + base) + ", ") + pretty_value(p)) + ")";
  } else if (s instanceof VFst) {
    return ("(" + base) + ").1";
  } else {
    return ("(" + base) + ").2";
  }
}

export function pretty_syntax(s) {
  if (s instanceof LambdaSyntax) {
    let $ = s[3];
    if ($ instanceof Ok) {
      let mode = s[0];
      let imp = s[1];
      let x = s[2];
      let e = s[4];
      let t = $[0];
      return (pretty_syntax_param(new SyntaxParam(mode, imp, x, t)) + "-> ") + pretty_syntax(
        e,
      );
    } else {
      let mode = s[0];
      let imp = s[1];
      let x = s[2];
      let e = s[4];
      let outer = "-> " + pretty_syntax(e);
      return in_mode(pretty_imp(imp) + x, mode) + outer;
    }
  } else if (s instanceof IdentSyntax) {
    let name = s[0];
    return name;
  } else if (s instanceof AppSyntax) {
    let mode = s[0];
    let foo = s[1];
    let bar = s[2];
    return (("(" + pretty_syntax(foo)) + ")") + in_mode(
      pretty_syntax(bar),
      mode,
    );
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
    let imp = s[1];
    let x = s[2];
    let t = s[3];
    let u = s[4];
    return (pretty_syntax_param(new SyntaxParam(mode, imp, x, t)) + "=> ") + pretty_syntax(
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
    return (pretty_syntax_param(
      new SyntaxParam(new ManyMode(), new Explicit(), x, t),
    ) + "& ") + pretty_syntax(u);
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
  } else if (s instanceof ExFalsoSyntax) {
    let a = s[0];
    return ("exfalso(" + pretty_syntax(a)) + ")";
  } else {
    return "_";
  }
}

export function pretty_syntax_param(param) {
  let _block;
  let $ = param.implicit;
  if ($ instanceof Implicit) {
    _block = "? ";
  } else {
    _block = "";
  }
  let imp_s = _block;
  let _pipe = (((imp_s + param.name) + ": ") + pretty_syntax(param.ty));
  return in_mode(_pipe, param.mode);
}
