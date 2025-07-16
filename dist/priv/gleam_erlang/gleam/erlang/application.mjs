import { CustomType as $CustomType } from "../../gleam.mjs";
import * as $node from "../../gleam/erlang/node.mjs";

export class Normal extends $CustomType {}

export class Takeover extends $CustomType {
  constructor(previous) {
    super();
    this.previous = previous;
  }
}

export class Failover extends $CustomType {
  constructor(previous) {
    super();
    this.previous = previous;
  }
}
