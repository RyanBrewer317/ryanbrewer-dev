import * as $dict from "../gleam_stdlib/gleam/dict.mjs";
import * as $int from "../gleam_stdlib/gleam/int.mjs";
import * as $list from "../gleam_stdlib/gleam/list.mjs";
import * as $result from "../gleam_stdlib/gleam/result.mjs";
import * as $string from "../gleam_stdlib/gleam/string.mjs";
import {
  Ok,
  toList,
  Empty as $Empty,
  NonEmpty as $NonEmpty,
  prepend as listPrepend,
  CustomType as $CustomType,
  makeError,
} from "./gleam.mjs";
import {
  start_arguments as arguments$,
  os_command as do_command,
  os_exit as exit,
  os_which as which,
} from "./shellout_ffi.mjs";

export { arguments$, exit, which };

const FILEPATH = "src/shellout.gleam";

class Name extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Rgb extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class StyleAcc extends $CustomType {
  constructor(styles, rgb_counter) {
    super();
    this.styles = styles;
    this.rgb_counter = rgb_counter;
  }
}

export class LetBeStderr extends $CustomType {}

export class LetBeStdout extends $CustomType {}

export class OverlappedStdio extends $CustomType {}

export class SetEnvironment extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export function display(values) {
  return $dict.from_list(toList([["display", values]]));
}

export function color(values) {
  return $dict.from_list(toList([["color", values]]));
}

export function background(values) {
  return $dict.from_list(toList([["background", values]]));
}

function escape(code, string) {
  return ((("\u{1b}[" + code) + "m") + string) + "\u{1b}[0m\u{1b}[K";
}

export function command(executable, arguments$, directory, options) {
  let environment = $list.flat_map(
    options,
    (option) => {
      if (option instanceof SetEnvironment) {
        let env = option[0];
        return env;
      } else {
        return toList([]);
      }
    },
  );
  let _pipe = options;
  let _pipe$1 = $list.map(_pipe, (opt) => { return [opt, true]; });
  let _pipe$2 = $dict.from_list(_pipe$1);
  return ((_capture) => {
    return do_command(executable, arguments$, directory, _capture, environment);
  })(_pipe$2);
}

export const displays = /* @__PURE__ */ toList([
  ["reset", /* @__PURE__ */ toList(["0"])],
  ["bold", /* @__PURE__ */ toList(["1"])],
  ["dim", /* @__PURE__ */ toList(["2"])],
  ["italic", /* @__PURE__ */ toList(["3"])],
  ["underline", /* @__PURE__ */ toList(["4"])],
  ["blink", /* @__PURE__ */ toList(["5"])],
  ["fastblink", /* @__PURE__ */ toList(["6"])],
  ["reverse", /* @__PURE__ */ toList(["7"])],
  ["hide", /* @__PURE__ */ toList(["8"])],
  ["strike", /* @__PURE__ */ toList(["9"])],
  ["normal", /* @__PURE__ */ toList(["22"])],
  ["noitalic", /* @__PURE__ */ toList(["23"])],
  ["nounderline", /* @__PURE__ */ toList(["24"])],
  ["noblink", /* @__PURE__ */ toList(["25"])],
  ["noreverse", /* @__PURE__ */ toList(["27"])],
  ["nohide", /* @__PURE__ */ toList(["28"])],
  ["nostrike", /* @__PURE__ */ toList(["29"])],
]);

export const colors = /* @__PURE__ */ toList([
  ["black", /* @__PURE__ */ toList(["30"])],
  ["red", /* @__PURE__ */ toList(["31"])],
  ["green", /* @__PURE__ */ toList(["32"])],
  ["yellow", /* @__PURE__ */ toList(["33"])],
  ["blue", /* @__PURE__ */ toList(["34"])],
  ["magenta", /* @__PURE__ */ toList(["35"])],
  ["cyan", /* @__PURE__ */ toList(["36"])],
  ["white", /* @__PURE__ */ toList(["37"])],
  ["default", /* @__PURE__ */ toList(["39"])],
  ["brightblack", /* @__PURE__ */ toList(["90"])],
  ["brightred", /* @__PURE__ */ toList(["91"])],
  ["brightgreen", /* @__PURE__ */ toList(["92"])],
  ["brightyellow", /* @__PURE__ */ toList(["93"])],
  ["brightblue", /* @__PURE__ */ toList(["94"])],
  ["brightmagenta", /* @__PURE__ */ toList(["95"])],
  ["brightcyan", /* @__PURE__ */ toList(["96"])],
  ["brightwhite", /* @__PURE__ */ toList(["97"])],
]);

function do_style(lookup, strings, flag) {
  let _block;
  let _block$1;
  if (flag === "display") {
    _block$1 = $dict.from_list(displays);
  } else if (flag === "color") {
    _block$1 = $dict.from_list(colors);
  } else if (flag === "background") {
    let _pipe = colors;
    let _pipe$1 = $dict.from_list(_pipe);
    _block$1 = $dict.map_values(
      _pipe$1,
      (_, code) => {
        if (code instanceof $Empty || code.tail instanceof $NonEmpty) {
          throw makeError(
            "let_assert",
            FILEPATH,
            "shellout",
            235,
            "do_style",
            "Pattern match failed, no pattern matched the value.",
            {
              value: code,
              start: 5878,
              end: 5902,
              pattern_start: 5889,
              pattern_end: 5895
            }
          )
        }
        let code$1 = code.head;
        let $ = $int.parse(code$1);
        if (!($ instanceof Ok)) {
          throw makeError(
            "let_assert",
            FILEPATH,
            "shellout",
            236,
            "do_style",
            "Pattern match failed, no pattern matched the value.",
            {
              value: $,
              start: 5913,
              end: 5950,
              pattern_start: 5924,
              pattern_end: 5932
            }
          )
        }
        let code$2 = $[0];
        return toList([$int.to_string(code$2 + 10)]);
      },
    );
  } else {
    throw makeError(
      "panic",
      FILEPATH,
      "shellout",
      239,
      "do_style",
      "invalid lookup flag",
      {}
    )
  }
  let _pipe = _block$1;
  _block = $dict.merge(_pipe, $dict.from_list(lookup));
  let lookup$1 = _block;
  let acc = new StyleAcc(toList([]), 0);
  let _block$2;
  let _pipe$1 = strings;
  _block$2 = $list.fold(
    _pipe$1,
    acc,
    (acc, item) => {
      let $ = $int.parse(item);
      if ($ instanceof Ok) {
        let int = $[0];
        let _block$3;
        let _pipe$2 = int;
        let _pipe$3 = $int.clamp(_pipe$2, 0, 255);
        _block$3 = $int.to_string(_pipe$3);
        let item$1 = _block$3;
        let rgb_counter = acc.rgb_counter;
        let $1 = rgb_counter < 3;
        if ($1) {
          if (rgb_counter > 0) {
            let $2 = acc.styles;
            if ($2 instanceof $Empty || !($2.head instanceof Rgb)) {
              throw makeError(
                "let_assert",
                FILEPATH,
                "shellout",
                256,
                "do_style",
                "Pattern match failed, no pattern matched the value.",
                {
                  value: $2,
                  start: 6514,
                  end: 6561,
                  pattern_start: 6525,
                  pattern_end: 6548
                }
              )
            }
            let styles = $2.tail;
            let values = $2.head[0];
            return new StyleAcc(
              listPrepend(new Rgb(listPrepend(item$1, values)), styles),
              rgb_counter + 1,
            );
          } else {
            return new StyleAcc(
              listPrepend(new Rgb(toList([item$1])), acc.styles),
              1,
            );
          }
        } else {
          return new StyleAcc(
            listPrepend(new Rgb(toList([item$1])), acc.styles),
            1,
          );
        }
      } else {
        return new StyleAcc(listPrepend(new Name(item), acc.styles), 0);
      }
    },
  );
  let acc$1 = _block$2;
  let prepare_rgb = (strings) => {
    let _block$3;
    let _pipe$2 = "0";
    let _pipe$3 = $list.repeat(_pipe$2, 3 - $list.length(strings));
    _block$3 = ((_capture) => { return $list.append(strings, _capture); })(
      _pipe$3,
    );
    let new_strings = _block$3;
    let _block$4;
    if (flag === "color") {
      _block$4 = "38";
    } else {
      _block$4 = "48";
    }
    let code = _block$4;
    return listPrepend(code, listPrepend("2", new_strings));
  };
  let _pipe$2 = acc$1.styles;
  let _pipe$3 = $list.reverse(_pipe$2);
  let _pipe$4 = $list.filter_map(
    _pipe$3,
    (style) => {
      if (style instanceof Name) {
        let string = style[0];
        let _pipe$4 = lookup$1;
        let _pipe$5 = $dict.get(_pipe$4, string);
        return $result.map(
          _pipe$5,
          (strings) => {
            let $ = $list.length(strings) > 1;
            if ($) {
              return prepare_rgb(strings);
            } else {
              return strings;
            }
          },
        );
      } else {
        let strings$1 = style[0];
        let _pipe$4 = strings$1;
        let _pipe$5 = $list.reverse(_pipe$4);
        let _pipe$6 = prepare_rgb(_pipe$5);
        return new Ok(_pipe$6);
      }
    },
  );
  return $list.flatten(_pipe$4);
}

export function style(string, flags, lookups) {
  let _pipe = toList(["display", "color", "background"]);
  let _pipe$1 = $list.map(
    _pipe,
    (flag) => {
      return $result.try$(
        $dict.get(flags, flag),
        (strings) => {
          let _pipe$1 = lookups;
          let _pipe$2 = $list.filter_map(
            _pipe$1,
            (item) => {
              let keys = item[0];
              let lookup = item[1];
              let _pipe$2 = keys;
              let _pipe$3 = $list.find(
                _pipe$2,
                (key) => { return key === flag; },
              );
              return $result.map(_pipe$3, (_) => { return lookup; });
            },
          );
          let _pipe$3 = $list.flatten(_pipe$2);
          let _pipe$4 = do_style(_pipe$3, strings, flag);
          return new Ok(_pipe$4);
        },
      );
    },
  );
  let _pipe$2 = $result.values(_pipe$1);
  let _pipe$3 = $list.flatten(_pipe$2);
  let _pipe$4 = $string.join(_pipe$3, ";");
  return escape(_pipe$4, string);
}
