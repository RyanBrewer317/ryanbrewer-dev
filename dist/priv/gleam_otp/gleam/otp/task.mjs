import * as $process from "../../../gleam_erlang/gleam/erlang/process.mjs";
import * as $dynamic from "../../../gleam_stdlib/gleam/dynamic.mjs";
import * as $function from "../../../gleam_stdlib/gleam/function.mjs";
import * as $option from "../../../gleam_stdlib/gleam/option.mjs";
import { None, Some } from "../../../gleam_stdlib/gleam/option.mjs";
import { CustomType as $CustomType } from "../../gleam.mjs";

class Task extends $CustomType {
  constructor(owner, pid, subject) {
    super();
    this.owner = owner;
    this.pid = pid;
    this.subject = subject;
  }
}

export class Timeout extends $CustomType {}

export class Exit extends $CustomType {
  constructor(reason) {
    super();
    this.reason = reason;
  }
}

class M2FromSubject1 extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

class M2FromSubject2 extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

class M2Timeout extends $CustomType {}

class M3FromSubject1 extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

class M3FromSubject2 extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

class M3FromSubject3 extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

class M3Timeout extends $CustomType {}

class M4FromSubject1 extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

class M4FromSubject2 extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

class M4FromSubject3 extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

class M4FromSubject4 extends $CustomType {
  constructor(x0) {
    super();
    this[0] = x0;
  }
}

class M4Timeout extends $CustomType {}

export function pid(task) {
  return task.pid;
}
