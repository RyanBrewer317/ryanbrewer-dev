import * as $atom from "../../../gleam_erlang/gleam/erlang/atom.mjs";
import * as $charlist from "../../../gleam_erlang/gleam/erlang/charlist.mjs";
import * as $process from "../../../gleam_erlang/gleam/erlang/process.mjs";
import { Abnormal, Killed } from "../../../gleam_erlang/gleam/erlang/process.mjs";
import * as $dynamic from "../../../gleam_stdlib/gleam/dynamic.mjs";
import * as $option from "../../../gleam_stdlib/gleam/option.mjs";
import { None, Some } from "../../../gleam_stdlib/gleam/option.mjs";
import * as $result from "../../../gleam_stdlib/gleam/result.mjs";
import * as $string from "../../../gleam_stdlib/gleam/string.mjs";
import { Ok, CustomType as $CustomType } from "../../gleam.mjs";
import * as $system from "../../gleam/otp/system.mjs";
import { GetState, GetStatus, Resume, Running, StatusInfo, Suspend, Suspended } from "../../gleam/otp/system.mjs";

class Message extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class System extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Unexpected extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Continue extends $CustomType {
  constructor(state, selector) {
    super();
    this.state = state;
    this.selector = selector;
  }
}

class Stop extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Self extends $CustomType {
  constructor(mode, parent, state, selector, debug_state, message_handler) {
    super();
    this.mode = mode;
    this.parent = parent;
    this.state = state;
    this.selector = selector;
    this.debug_state = debug_state;
    this.message_handler = message_handler;
  }
}

export class Started extends $CustomType {
  constructor(pid, data) {
    super();
    this.pid = pid;
    this.data = data;
  }
}

class Initialised extends $CustomType {
  constructor(state, selector, return$) {
    super();
    this.state = state;
    this.selector = selector;
    this.return = return$;
  }
}

class Builder extends $CustomType {
  constructor(initialise, initialisation_timeout, on_message, name) {
    super();
    this.initialise = initialise;
    this.initialisation_timeout = initialisation_timeout;
    this.on_message = on_message;
    this.name = name;
  }
}

export class InitTimeout extends $CustomType {}

export class InitFailed extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class InitExited extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Ack extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Mon extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export function continue$(state) {
  return new Continue(state, new None());
}

export function stop() {
  return new Stop(new $process.Normal());
}

export function stop_abnormal(reason) {
  return new Stop(new $process.Abnormal($dynamic.string(reason)));
}

export function with_selector(value, selector) {
  if (value instanceof Continue) {
    let state = value.state;
    return new Continue(state, new Some(selector));
  } else {
    return value;
  }
}

export function initialised(state) {
  return new Initialised(state, new None(), undefined);
}

export function selecting(initialised, selector) {
  let _record = initialised;
  return new Initialised(_record.state, new Some(selector), _record.return);
}

export function returning(initialised, return$) {
  let _record = initialised;
  return new Initialised(_record.state, _record.selector, return$);
}

export function new$(state) {
  let initialise = (subject) => {
    let _pipe = initialised(state);
    let _pipe$1 = returning(_pipe, subject);
    return new Ok(_pipe$1);
  };
  return new Builder(
    initialise,
    1000,
    (state, _) => { return continue$(state); },
    new $option.None(),
  );
}

export function new_with_initialiser(timeout, initialise) {
  return new Builder(
    initialise,
    timeout,
    (state, _) => { return continue$(state); },
    new $option.None(),
  );
}

export function on_message(builder, handler) {
  let _record = builder;
  return new Builder(
    _record.initialise,
    _record.initialisation_timeout,
    handler,
    _record.name,
  );
}

export function named(builder, name) {
  let _record = builder;
  return new Builder(
    _record.initialise,
    _record.initialisation_timeout,
    _record.on_message,
    new $option.Some(name),
  );
}
