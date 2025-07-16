import { Ok, Error, CustomType as $CustomType } from "../../gleam.mjs";
import * as $actor from "../../gleam/otp/actor.mjs";

export class Permanent extends $CustomType {}

export class Transient extends $CustomType {}

export class Temporary extends $CustomType {}

export class Worker extends $CustomType {
  constructor(shutdown_ms) {
    super();
    this.shutdown_ms = shutdown_ms;
  }
}

export class Supervisor extends $CustomType {}

export class ChildSpecification extends $CustomType {
  constructor(start, restart, significant, child_type) {
    super();
    this.start = start;
    this.restart = restart;
    this.significant = significant;
    this.child_type = child_type;
  }
}

export function worker(start) {
  return new ChildSpecification(start, new Permanent(), false, new Worker(5000));
}

export function supervisor(start) {
  return new ChildSpecification(start, new Permanent(), false, new Supervisor());
}

export function significant(child, significant) {
  let _record = child;
  return new ChildSpecification(
    _record.start,
    _record.restart,
    significant,
    _record.child_type,
  );
}

export function timeout(child, ms) {
  let $ = child.child_type;
  if ($ instanceof Worker) {
    let _record = child;
    return new ChildSpecification(
      _record.start,
      _record.restart,
      _record.significant,
      new Worker(ms),
    );
  } else {
    return child;
  }
}

export function restart(child, restart) {
  let _record = child;
  return new ChildSpecification(
    _record.start,
    restart,
    _record.significant,
    _record.child_type,
  );
}

export function map_data(child, transform) {
  let _record = child;
  return new ChildSpecification(
    () => {
      let $ = child.start();
      if ($ instanceof Ok) {
        let started = $[0];
        return new Ok(
          (() => {
            let _record$1 = started;
            return new $actor.Started(_record$1.pid, transform(started.data));
          })(),
        );
      } else {
        let e = $[0];
        return new Error(e);
      }
    },
    _record.restart,
    _record.significant,
    _record.child_type,
  );
}
