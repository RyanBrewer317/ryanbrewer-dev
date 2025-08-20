import * as $dynamic from "../../../gleam_stdlib/gleam/dynamic.mjs";
import * as $decode from "../../../gleam_stdlib/gleam/dynamic/decode.mjs";
import * as $string from "../../../gleam_stdlib/gleam/string.mjs";
import { Ok, Error, CustomType as $CustomType } from "../../gleam.mjs";
import * as $atom from "../../gleam/erlang/atom.mjs";
import * as $port from "../../gleam/erlang/port.mjs";
import * as $reference from "../../gleam/erlang/reference.mjs";

class Subject extends $CustomType {
  constructor(owner, tag) {
    super();
    this.owner = owner;
    this.tag = tag;
  }
}

class NamedSubject extends $CustomType {
  constructor(name) {
    super();
    this.name = name;
  }
}

export class ExitMessage extends $CustomType {
  constructor(pid, reason) {
    super();
    this.pid = pid;
    this.reason = reason;
  }
}

export class Normal extends $CustomType {}

export class Killed extends $CustomType {}

export class Abnormal extends $CustomType {
  constructor(reason) {
    super();
    this.reason = reason;
  }
}

class Anything extends $CustomType {}

class Process extends $CustomType {}

export class ProcessDown extends $CustomType {
  constructor(monitor, pid, reason) {
    super();
    this.monitor = monitor;
    this.pid = pid;
    this.reason = reason;
  }
}

export class PortDown extends $CustomType {
  constructor(monitor, port, reason) {
    super();
    this.monitor = monitor;
    this.port = port;
    this.reason = reason;
  }
}

export class TimerNotFound extends $CustomType {}

export class Cancelled extends $CustomType {
  constructor(time_remaining) {
    super();
    this.time_remaining = time_remaining;
  }
}

class Kill extends $CustomType {}

export function unsafely_create_subject(owner, tag) {
  return new Subject(owner, tag);
}

export function named_subject(name) {
  return new NamedSubject(name);
}

export function subject_name(subject) {
  if (subject instanceof Subject) {
    return new Error(undefined);
  } else {
    let name = subject.name;
    return new Ok(name);
  }
}
