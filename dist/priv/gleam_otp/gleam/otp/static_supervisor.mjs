import * as $atom from "../../../gleam_erlang/gleam/erlang/atom.mjs";
import * as $process from "../../../gleam_erlang/gleam/erlang/process.mjs";
import * as $dynamic from "../../../gleam_stdlib/gleam/dynamic.mjs";
import * as $list from "../../../gleam_stdlib/gleam/list.mjs";
import { Ok, Error, toList, prepend as listPrepend, CustomType as $CustomType } from "../../gleam.mjs";
import * as $actor from "../../gleam/otp/actor.mjs";
import * as $supervision from "../../gleam/otp/supervision.mjs";

class Supervisor extends $CustomType {
  constructor(pid) {
    super();
    this.pid = pid;
  }
}

export class OneForOne extends $CustomType {}

export class OneForAll extends $CustomType {}

export class RestForOne extends $CustomType {}

export class Never extends $CustomType {}

export class AnySignificant extends $CustomType {}

export class AllSignificant extends $CustomType {}

class Builder extends $CustomType {
  constructor(strategy, intensity, period, auto_shutdown, children) {
    super();
    this.strategy = strategy;
    this.intensity = intensity;
    this.period = period;
    this.auto_shutdown = auto_shutdown;
    this.children = children;
  }
}

class Strategy extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Intensity extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Period extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class AutoShutdown extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Id extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Start extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Restart extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Significant extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Type extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Shutdown extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export function new$(strategy) {
  return new Builder(strategy, 2, 5, new Never(), toList([]));
}

export function restart_tolerance(builder, intensity, period) {
  let _record = builder;
  return new Builder(
    _record.strategy,
    intensity,
    period,
    _record.auto_shutdown,
    _record.children,
  );
}

export function auto_shutdown(builder, value) {
  let _record = builder;
  return new Builder(
    _record.strategy,
    _record.intensity,
    _record.period,
    value,
    _record.children,
  );
}

export function add(builder, child) {
  let _record = builder;
  return new Builder(
    _record.strategy,
    _record.intensity,
    _record.period,
    _record.auto_shutdown,
    listPrepend(
      $supervision.map_data(child, (_) => { return undefined; }),
      builder.children,
    ),
  );
}

export function init(start_data) {
  return new Ok(start_data);
}

export function start_child_callback(start) {
  let $ = start();
  if ($ instanceof Ok) {
    let started = $[0];
    return new Ok(started.pid);
  } else {
    let error = $[0];
    return new Error(error);
  }
}
