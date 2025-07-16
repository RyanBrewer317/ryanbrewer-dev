import * as $filepath from "../../../filepath/filepath.mjs";
import * as $ansi from "../../../gleam_community_ansi/gleam_community/ansi.mjs";
import * as $application from "../../../gleam_erlang/gleam/erlang/application.mjs";
import * as $atom from "../../../gleam_erlang/gleam/erlang/atom.mjs";
import * as $process from "../../../gleam_erlang/gleam/erlang/process.mjs";
import * as $request from "../../../gleam_http/gleam/http/request.mjs";
import * as $response from "../../../gleam_http/gleam/http/response.mjs";
import * as $json from "../../../gleam_json/gleam/json.mjs";
import * as $actor from "../../../gleam_otp/gleam/otp/actor.mjs";
import * as $dynamic from "../../../gleam_stdlib/gleam/dynamic.mjs";
import * as $decode from "../../../gleam_stdlib/gleam/dynamic/decode.mjs";
import * as $io from "../../../gleam_stdlib/gleam/io.mjs";
import * as $list from "../../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../../gleam_stdlib/gleam/option.mjs";
import * as $result from "../../../gleam_stdlib/gleam/result.mjs";
import * as $set from "../../../gleam_stdlib/gleam/set.mjs";
import * as $string from "../../../gleam_stdlib/gleam/string.mjs";
import * as $glint from "../../../glint/glint.mjs";
import * as $mist from "../../../mist/mist.mjs";
import * as $simplifile from "../../../simplifile/simplifile.mjs";
import { CustomType as $CustomType } from "../../gleam.mjs";
import * as $cli from "../../lustre_dev_tools/cli.mjs";
import * as $build from "../../lustre_dev_tools/cli/build.mjs";
import * as $flag from "../../lustre_dev_tools/cli/flag.mjs";
import * as $error from "../../lustre_dev_tools/error.mjs";
import { CannotStartFileWatcher } from "../../lustre_dev_tools/error.mjs";

export class Add extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class Remove extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class Broadcast extends $CustomType {}

export class Unknown extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class Reload extends $CustomType {}

export class ShowError extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class NoFileWatcherSupportedForOs extends $CustomType {}

class NoFileWatcherInstalled extends $CustomType {
  constructor(watcher) {
    super();
    this.watcher = watcher;
  }
}

class Created extends $CustomType {}

class Modified extends $CustomType {}

class Deleted extends $CustomType {}
