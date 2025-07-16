import * as $dynamic from "../gleam_stdlib/gleam/dynamic.mjs";
import { rescue, defer, on_crash } from "./exception_ffi.mjs";
import { CustomType as $CustomType } from "./gleam.mjs";

export { defer, on_crash, rescue };

export class Errored extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class Thrown extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class Exited extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
