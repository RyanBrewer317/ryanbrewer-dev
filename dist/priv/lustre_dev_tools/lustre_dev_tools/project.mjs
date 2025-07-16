import * as $filepath from "../../filepath/filepath.mjs";
import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $package_interface from "../../gleam_package_interface/gleam/package_interface.mjs";
import { Fn, Named, Tuple, Variable } from "../../gleam_package_interface/gleam/package_interface.mjs";
import * as $dict from "../../gleam_stdlib/gleam/dict.mjs";
import * as $decode from "../../gleam_stdlib/gleam/dynamic/decode.mjs";
import * as $int from "../../gleam_stdlib/gleam/int.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $pair from "../../gleam_stdlib/gleam/pair.mjs";
import * as $result from "../../gleam_stdlib/gleam/result.mjs";
import * as $string from "../../gleam_stdlib/gleam/string.mjs";
import * as $simplifile from "../../simplifile/simplifile.mjs";
import * as $tom from "../../tom/tom.mjs";
import { Ok, toList, Empty as $Empty, CustomType as $CustomType, makeError } from "../gleam.mjs";
import * as $cmd from "../lustre_dev_tools/cmd.mjs";
import * as $error from "../lustre_dev_tools/error.mjs";
import { BuildError } from "../lustre_dev_tools/error.mjs";

const FILEPATH = "src/lustre_dev_tools/project.gleam";

export class Config extends $CustomType {
  constructor(name, toml) {
    super();
    this.name = name;
    this.toml = toml;
  }
}

export class Interface extends $CustomType {
  constructor(name, version, modules) {
    super();
    this.name = name;
    this.version = version;
    this.modules = modules;
  }
}

export class Module extends $CustomType {
  constructor(constants, functions) {
    super();
    this.constants = constants;
    this.functions = functions;
  }
}

export class Function extends $CustomType {
  constructor(parameters, return$) {
    super();
    this.parameters = parameters;
    this.return = return$;
  }
}

function find_root(loop$path) {
  while (true) {
    let path = loop$path;
    let toml = $filepath.join(path, "gleam.toml");
    let $ = $simplifile.is_file(toml);
    if ($ instanceof Ok) {
      let $1 = $[0];
      if ($1) {
        return path;
      } else {
        loop$path = $filepath.join("..", path);
      }
    } else {
      loop$path = $filepath.join("..", path);
    }
  }
}

export function root() {
  return find_root(".");
}

export function config() {
  let configuration_path = $filepath.join(root(), "gleam.toml");
  let $ = $simplifile.read(configuration_path);
  if (!($ instanceof Ok)) {
    throw makeError(
      "let_assert",
      FILEPATH,
      "lustre_dev_tools/project",
      86,
      "config",
      "Pattern match failed, no pattern matched the value.",
      {
        value: $,
        start: 2625,
        end: 2691,
        pattern_start: 2636,
        pattern_end: 2653
      }
    )
  }
  let configuration = $[0];
  let $1 = $tom.parse(configuration);
  if (!($1 instanceof Ok)) {
    throw makeError(
      "let_assert",
      FILEPATH,
      "lustre_dev_tools/project",
      87,
      "config",
      "Pattern match failed, no pattern matched the value.",
      {
        value: $1,
        start: 2694,
        end: 2740,
        pattern_start: 2705,
        pattern_end: 2713
      }
    )
  }
  let toml = $1[0];
  let $2 = $tom.get_string(toml, toList(["name"]));
  if (!($2 instanceof Ok)) {
    throw makeError(
      "let_assert",
      FILEPATH,
      "lustre_dev_tools/project",
      88,
      "config",
      "Pattern match failed, no pattern matched the value.",
      {
        value: $2,
        start: 2743,
        end: 2795,
        pattern_start: 2754,
        pattern_end: 2762
      }
    )
  }
  let name = $2[0];
  return new Ok(new Config(name, toml));
}

export function type_to_string(type_) {
  if (type_ instanceof Tuple) {
    let elements = type_.elements;
    let elements$1 = $list.map(elements, type_to_string);
    return ("#(" + $string.join(elements$1, ", ")) + ")";
  } else if (type_ instanceof Fn) {
    let params = type_.parameters;
    let return$ = type_.return;
    let params$1 = $list.map(params, type_to_string);
    let return$1 = type_to_string(return$);
    return (("fn(" + $string.join(params$1, ", ")) + ") -> ") + return$1;
  } else if (type_ instanceof Variable) {
    let id = type_.id;
    return "a_" + $int.to_string(id);
  } else {
    let $ = type_.parameters;
    if ($ instanceof $Empty) {
      let name = type_.name;
      return name;
    } else {
      let name = type_.name;
      let params = $;
      let params$1 = $list.map(params, type_to_string);
      return ((name + "(") + $string.join(params$1, ", ")) + ")";
    }
  }
}

function labelled_argument_decoder() {
  return $decode.at(toList(["type"]), $package_interface.type_decoder());
}

function function_decoder() {
  return $decode.field(
    "parameters",
    $decode.list(labelled_argument_decoder()),
    (parameters) => {
      return $decode.field(
        "return",
        $package_interface.type_decoder(),
        (return$) => {
          return $decode.success(new Function(parameters, return$));
        },
      );
    },
  );
}

function string_dict(values) {
  return $decode.dict($decode.string, values);
}

function module_decoder() {
  return $decode.field(
    "constants",
    string_dict($decode.at(toList(["type"]), $package_interface.type_decoder())),
    (constants) => {
      return $decode.field(
        "functions",
        string_dict(function_decoder()),
        (functions) => {
          return $decode.success(new Module(constants, functions));
        },
      );
    },
  );
}

function interface_decoder() {
  return $decode.field(
    "name",
    $decode.string,
    (name) => {
      return $decode.field(
        "version",
        $decode.string,
        (version) => {
          return $decode.field(
            "modules",
            string_dict(module_decoder()),
            (modules) => {
              return $decode.success(new Interface(name, version, modules));
            },
          );
        },
      );
    },
  );
}
