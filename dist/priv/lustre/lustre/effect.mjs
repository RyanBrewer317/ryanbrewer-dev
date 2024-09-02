import * as $process from "../../gleam_erlang/gleam/erlang/process.mjs";
import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";

class Effect extends $CustomType {
  constructor(all) {
    super();
    this.all = all;
  }
}

class Actions extends $CustomType {
  constructor(dispatch, emit, select) {
    super();
    this.dispatch = dispatch;
    this.emit = emit;
    this.select = select;
  }
}

export function custom(run) {
  return new Effect(
    toList([
      (actions) => {
        return run(actions.dispatch, actions.emit, actions.select);
      },
    ]),
  );
}

export function from(effect) {
  return custom((dispatch, _, _1) => { return effect(dispatch); });
}

export function event(name, data) {
  return custom((_, emit, _1) => { return emit(name, data); });
}

export function none() {
  return new Effect(toList([]));
}

export function batch(effects) {
  return new Effect(
    $list.fold(
      effects,
      toList([]),
      (b, _use1) => {
        let a = _use1.all;
        return $list.append(b, a);
      },
    ),
  );
}

export function map(effect, f) {
  return new Effect(
    $list.map(
      effect.all,
      (eff) => {
        return (actions) => {
          return eff(
            new Actions(
              (msg) => { return actions.dispatch(f(msg)); },
              actions.emit,
              (_) => { return undefined; },
            ),
          );
        };
      },
    ),
  );
}

export function perform(effect, dispatch, emit, select) {
  let actions = new Actions(dispatch, emit, select);
  return $list.each(effect.all, (eff) => { return eff(actions); });
}
