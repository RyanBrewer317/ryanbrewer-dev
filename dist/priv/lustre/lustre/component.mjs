import * as $dict from "../../gleam_stdlib/gleam/dict.mjs";
import * as $dynamic from "../../gleam_stdlib/gleam/dynamic.mjs";
import * as $decode from "../../gleam_stdlib/gleam/dynamic/decode.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import { Some } from "../../gleam_stdlib/gleam/option.mjs";
import * as $string from "../../gleam_stdlib/gleam/string.mjs";
import { Empty as $Empty, prepend as listPrepend, CustomType as $CustomType } from "../gleam.mjs";
import * as $attribute from "../lustre/attribute.mjs";
import { attribute } from "../lustre/attribute.mjs";
import * as $effect from "../lustre/effect.mjs";
import * as $element from "../lustre/element.mjs";
import * as $html from "../lustre/element/html.mjs";
import * as $constants from "../lustre/internals/constants.mjs";
import * as $runtime from "../lustre/runtime/server/runtime.mjs";
import {
  set_form_value as do_set_form_value,
  clear_form_value as do_clear_form_value,
  set_pseudo_state as do_set_pseudo_state,
  remove_pseudo_state as do_remove_pseudo_state,
} from "./runtime/client/component.ffi.mjs";

class Config extends $CustomType {
  constructor(open_shadow_root, adopt_styles, delegates_focus, attributes, properties, contexts, is_form_associated, on_form_autofill, on_form_reset, on_form_restore) {
    super();
    this.open_shadow_root = open_shadow_root;
    this.adopt_styles = adopt_styles;
    this.delegates_focus = delegates_focus;
    this.attributes = attributes;
    this.properties = properties;
    this.contexts = contexts;
    this.is_form_associated = is_form_associated;
    this.on_form_autofill = on_form_autofill;
    this.on_form_reset = on_form_reset;
    this.on_form_restore = on_form_restore;
  }
}

class Option extends $CustomType {
  constructor(apply) {
    super();
    this.apply = apply;
  }
}

export function new$(options) {
  let init = new Config(
    true,
    true,
    false,
    $constants.empty_list,
    $constants.empty_list,
    $constants.empty_list,
    false,
    $constants.option_none,
    $constants.option_none,
    $constants.option_none,
  );
  return $list.fold(
    options,
    init,
    (config, option) => { return option.apply(config); },
  );
}

export function on_attribute_change(name, decoder) {
  return new Option(
    (config) => {
      let attributes = listPrepend([name, decoder], config.attributes);
      let _record = config;
      return new Config(
        _record.open_shadow_root,
        _record.adopt_styles,
        _record.delegates_focus,
        attributes,
        _record.properties,
        _record.contexts,
        _record.is_form_associated,
        _record.on_form_autofill,
        _record.on_form_reset,
        _record.on_form_restore,
      );
    },
  );
}

export function on_property_change(name, decoder) {
  return new Option(
    (config) => {
      let properties = listPrepend([name, decoder], config.properties);
      let _record = config;
      return new Config(
        _record.open_shadow_root,
        _record.adopt_styles,
        _record.delegates_focus,
        _record.attributes,
        properties,
        _record.contexts,
        _record.is_form_associated,
        _record.on_form_autofill,
        _record.on_form_reset,
        _record.on_form_restore,
      );
    },
  );
}

export function on_context_change(key, decoder) {
  return new Option(
    (config) => {
      let contexts = listPrepend([key, decoder], config.contexts);
      let _record = config;
      return new Config(
        _record.open_shadow_root,
        _record.adopt_styles,
        _record.delegates_focus,
        _record.attributes,
        _record.properties,
        contexts,
        _record.is_form_associated,
        _record.on_form_autofill,
        _record.on_form_reset,
        _record.on_form_restore,
      );
    },
  );
}

export function form_associated() {
  return new Option(
    (config) => {
      let _record = config;
      return new Config(
        _record.open_shadow_root,
        _record.adopt_styles,
        _record.delegates_focus,
        _record.attributes,
        _record.properties,
        _record.contexts,
        true,
        _record.on_form_autofill,
        _record.on_form_reset,
        _record.on_form_restore,
      );
    },
  );
}

export function on_form_autofill(handler) {
  return new Option(
    (config) => {
      let _record = config;
      return new Config(
        _record.open_shadow_root,
        _record.adopt_styles,
        _record.delegates_focus,
        _record.attributes,
        _record.properties,
        _record.contexts,
        true,
        new Some(handler),
        _record.on_form_reset,
        _record.on_form_restore,
      );
    },
  );
}

export function on_form_reset(msg) {
  return new Option(
    (config) => {
      let _record = config;
      return new Config(
        _record.open_shadow_root,
        _record.adopt_styles,
        _record.delegates_focus,
        _record.attributes,
        _record.properties,
        _record.contexts,
        true,
        _record.on_form_autofill,
        new Some(msg),
        _record.on_form_restore,
      );
    },
  );
}

export function on_form_restore(handler) {
  return new Option(
    (config) => {
      let _record = config;
      return new Config(
        _record.open_shadow_root,
        _record.adopt_styles,
        _record.delegates_focus,
        _record.attributes,
        _record.properties,
        _record.contexts,
        true,
        _record.on_form_autofill,
        _record.on_form_reset,
        new Some(handler),
      );
    },
  );
}

export function open_shadow_root(open) {
  return new Option(
    (config) => {
      let _record = config;
      return new Config(
        open,
        _record.adopt_styles,
        _record.delegates_focus,
        _record.attributes,
        _record.properties,
        _record.contexts,
        _record.is_form_associated,
        _record.on_form_autofill,
        _record.on_form_reset,
        _record.on_form_restore,
      );
    },
  );
}

export function adopt_styles(adopt) {
  return new Option(
    (config) => {
      let _record = config;
      return new Config(
        _record.open_shadow_root,
        adopt,
        _record.delegates_focus,
        _record.attributes,
        _record.properties,
        _record.contexts,
        _record.is_form_associated,
        _record.on_form_autofill,
        _record.on_form_reset,
        _record.on_form_restore,
      );
    },
  );
}

export function delegates_focus(delegates) {
  return new Option(
    (config) => {
      let _record = config;
      return new Config(
        _record.open_shadow_root,
        _record.adopt_styles,
        delegates,
        _record.attributes,
        _record.properties,
        _record.contexts,
        _record.is_form_associated,
        _record.on_form_autofill,
        _record.on_form_reset,
        _record.on_form_restore,
      );
    },
  );
}

export function to_server_component_config(config) {
  return new $runtime.Config(
    config.open_shadow_root,
    config.adopt_styles,
    $dict.from_list($list.reverse(config.attributes)),
    $dict.from_list($list.reverse(config.properties)),
    $dict.from_list($list.reverse(config.contexts)),
  );
}

export function default_slot(attributes, fallback) {
  return $html.slot(attributes, fallback);
}

export function named_slot(name, attributes, fallback) {
  return $html.slot(listPrepend(attribute("name", name), attributes), fallback);
}

export function part(name) {
  return attribute("part", name);
}

function do_parts(loop$names, loop$part) {
  while (true) {
    let names = loop$names;
    let part = loop$part;
    if (names instanceof $Empty) {
      return part;
    } else {
      let $ = names.head[1];
      if ($) {
        let rest = names.tail;
        let name = names.head[0];
        return ((part + name) + " ") + do_parts(rest, part);
      } else {
        let rest = names.tail;
        loop$names = rest;
        loop$part = part;
      }
    }
  }
}

export function parts(names) {
  return part(do_parts(names, ""));
}

export function exportparts(names) {
  return attribute("exportparts", $string.join(names, ", "));
}

export function slot(name) {
  return attribute("slot", name);
}

export function set_form_value(value) {
  return $effect.before_paint(
    (_, root) => { return do_set_form_value(root, value); },
  );
}

export function clear_form_value() {
  return $effect.before_paint(
    (_, root) => { return do_clear_form_value(root); },
  );
}

export function set_pseudo_state(value) {
  return $effect.before_paint(
    (_, root) => { return do_set_pseudo_state(root, value); },
  );
}

export function remove_pseudo_state(value) {
  return $effect.before_paint(
    (_, root) => { return do_remove_pseudo_state(root, value); },
  );
}
