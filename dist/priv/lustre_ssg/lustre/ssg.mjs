import * as $filepath from "../../filepath/filepath.mjs";
import * as $dict from "../../gleam_stdlib/gleam/dict.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import { None, Some } from "../../gleam_stdlib/gleam/option.mjs";
import * as $regex from "../../gleam_stdlib/gleam/regex.mjs";
import * as $result from "../../gleam_stdlib/gleam/result.mjs";
import * as $string from "../../gleam_stdlib/gleam/string.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $simplifile from "../../simplifile/simplifile.mjs";
import * as $temporary from "../../temporary/temporary.mjs";
import {
  Ok,
  Error,
  toList,
  prepend as listPrepend,
  CustomType as $CustomType,
  makeError,
} from "../gleam.mjs";

class Config extends $CustomType {
  constructor(out_dir, static_dir, static_assets, routes, use_index_routes) {
    super();
    this.out_dir = out_dir;
    this.static_dir = static_dir;
    this.static_assets = static_assets;
    this.routes = routes;
    this.use_index_routes = use_index_routes;
  }
}

class Static extends $CustomType {
  constructor(path, page) {
    super();
    this.path = path;
    this.page = page;
  }
}

class Dynamic extends $CustomType {
  constructor(path, pages) {
    super();
    this.path = path;
    this.pages = pages;
  }
}

class Xml extends $CustomType {
  constructor(path, page) {
    super();
    this.path = path;
    this.page = page;
  }
}

export class CannotCreateTempDirectory extends $CustomType {
  constructor(reason) {
    super();
    this.reason = reason;
  }
}

export class CannotWriteStaticAsset extends $CustomType {
  constructor(reason, path) {
    super();
    this.reason = reason;
    this.path = path;
  }
}

export class CannotGenerateRoute extends $CustomType {
  constructor(reason, path) {
    super();
    this.reason = reason;
    this.path = path;
  }
}

export class CannotWriteToOutputDir extends $CustomType {
  constructor(reason) {
    super();
    this.reason = reason;
  }
}

export class CannotCleanupTempDir extends $CustomType {
  constructor(reason) {
    super();
    this.reason = reason;
  }
}

export function new$(out_dir) {
  return new Config(out_dir, new None(), $dict.new$(), toList([]), false);
}

export function add_static_dir(config, path) {
  let out_dir = config.out_dir;
  let static_assets = config.static_assets;
  let routes = config.routes;
  let use_index_routes$1 = config.use_index_routes;
  return new Config(
    out_dir,
    new Some(path),
    static_assets,
    routes,
    use_index_routes$1,
  );
}

export function use_index_routes(config) {
  let out_dir = config.out_dir;
  let static_dir = config.static_dir;
  let static_assets = config.static_assets;
  let routes = config.routes;
  return new Config(out_dir, static_dir, static_assets, routes, true);
}

function routify(path) {
  let $ = $regex.from_string("\\s+");
  if (!$.isOk()) {
    throw makeError(
      "assignment_no_match",
      "lustre/ssg",
      459,
      "routify",
      "Assignment pattern did not match",
      { value: $ }
    )
  }
  let whitespace = $[0];
  let _pipe = $regex.split(whitespace, path);
  let _pipe$1 = $string.join(_pipe, "-");
  return $string.lowercase(_pipe$1);
}

export function add_static_route(config, path, page) {
  let out_dir = config.out_dir;
  let static_dir = config.static_dir;
  let static_assets = config.static_assets;
  let routes = config.routes;
  let use_index_routes$1 = config.use_index_routes;
  let route = new Static(
    routify(path),
    $element.map(page, (_) => { return undefined; }),
  );
  return new Config(
    out_dir,
    static_dir,
    static_assets,
    listPrepend(route, routes),
    use_index_routes$1,
  );
}

export function add_static_xml(config, path, page) {
  let out_dir = config.out_dir;
  let static_dir = config.static_dir;
  let static_assets = config.static_assets;
  let routes = config.routes;
  let use_index_routes$1 = config.use_index_routes;
  let route = new Xml(
    routify(path),
    $element.map(page, (_) => { return undefined; }),
  );
  return new Config(
    out_dir,
    static_dir,
    static_assets,
    listPrepend(route, routes),
    use_index_routes$1,
  );
}

export function add_dynamic_route(config, path, data, page) {
  let route = (() => {
    let path$1 = routify(path);
    let pages = $dict.map_values(
      data,
      (_, data) => {
        return $element.map(page(data), (_) => { return undefined; });
      },
    );
    return new Dynamic(path$1, pages);
  })();
  return config.withFields({ routes: listPrepend(route, config.routes) });
}

export function add_static_asset(config, path, content) {
  let static_assets = $dict.insert(config.static_assets, routify(path), content);
  return config.withFields({ static_assets: static_assets });
}

function trim_slash(path) {
  let $ = $string.ends_with(path, "/");
  if ($) {
    return $string.drop_right(path, 1);
  } else {
    return path;
  }
}

function last_segment(path) {
  let $ = $regex.from_string("(.*/)+?(.+)");
  if (!$.isOk()) {
    throw makeError(
      "assignment_no_match",
      "lustre/ssg",
      474,
      "last_segment",
      "Assignment pattern did not match",
      { value: $ }
    )
  }
  let segments = $[0];
  let $1 = $regex.scan(segments, path);
  if (
    !$1.hasLength(1) ||
    !($1.head instanceof $regex.Match) ||
    !$1.head.submatches.hasLength(2) ||
    !($1.head.submatches.head instanceof Some) ||
    !($1.head.submatches.tail.head instanceof Some)
  ) {
    throw makeError(
      "assignment_no_match",
      "lustre/ssg",
      475,
      "last_segment",
      "Assignment pattern did not match",
      { value: $1 }
    )
  }
  let leading = $1.head.submatches.head[0];
  let last = $1.head.submatches.tail.head[0];
  return [leading, last];
}

function do_build(config) {
  let out_dir = config.out_dir;
  let static_dir = config.static_dir;
  let static_assets = config.static_assets;
  let routes = config.routes;
  let use_index_routes$1 = config.use_index_routes;
  let out_dir$1 = trim_slash(out_dir);
  return $temporary.create(
    $temporary.directory(),
    (temp) => {
      return $result.try$(
        (() => {
          let _pipe = (() => {
            if (static_dir instanceof Some) {
              let path = static_dir[0];
              return $simplifile.copy_directory(path, temp);
            } else {
              return $simplifile.create_directory_all(temp);
            }
          })();
          return $result.map_error(
            _pipe,
            (var0) => { return new CannotCreateTempDirectory(var0); },
          );
        })(),
        (_) => {
          return $result.try$(
            $list.try_map(
              $dict.to_list(static_assets),
              (_use0) => {
                let path = _use0[0];
                let content = _use0[1];
                let dir = $filepath.directory_name(path);
                let _pipe = $filepath.join(temp, dir);
                let _pipe$1 = $simplifile.create_directory_all(_pipe);
                let _pipe$2 = $result.then$(
                  _pipe$1,
                  (_) => { return $simplifile.write(temp + path, content); },
                );
                return $result.map_error(
                  _pipe$2,
                  (_capture) => {
                    return new CannotWriteStaticAsset(_capture, path);
                  },
                );
              },
            ),
            (_) => {
              return $result.try$(
                (() => {
                  let routes$1 = $list.sort(
                    routes,
                    (a, b) => { return $string.compare(a.path, b.path); },
                  );
                  return $list.try_map(
                    routes$1,
                    (route) => {
                      if (route instanceof Static && route.path === "/") {
                        let el = route.page;
                        let path = temp + "/index.html";
                        let _pipe = el;
                        let _pipe$1 = $element.to_document_string(_pipe);
                        let _pipe$2 = ((_capture) => {
                          return $simplifile.write(path, _capture);
                        })(_pipe$1);
                        return $result.map_error(
                          _pipe$2,
                          (_capture) => {
                            return new CannotGenerateRoute(_capture, path);
                          },
                        );
                      } else if (route instanceof Static && (use_index_routes$1)) {
                        let path = route.path;
                        let el = route.page;
                        let $ = $simplifile.create_directory_all(temp + path);
                        
                        let path$1 = (temp + trim_slash(path)) + "/index.html";
                        let _pipe = el;
                        let _pipe$1 = $element.to_document_string(_pipe);
                        let _pipe$2 = ((_capture) => {
                          return $simplifile.write(path$1, _capture);
                        })(_pipe$1);
                        return $result.map_error(
                          _pipe$2,
                          (_capture) => {
                            return new CannotGenerateRoute(_capture, path$1);
                          },
                        );
                      } else if (route instanceof Static) {
                        let path = route.path;
                        let el = route.page;
                        let $ = last_segment(path);
                        let path$1 = $[0];
                        let name = $[1];
                        let $1 = $simplifile.create_directory_all(temp + path$1);
                        
                        let path$2 = (((temp + trim_slash(path$1)) + "/") + name) + ".html";
                        let _pipe = el;
                        let _pipe$1 = $element.to_document_string(_pipe);
                        let _pipe$2 = ((_capture) => {
                          return $simplifile.write(path$2, _capture);
                        })(_pipe$1);
                        return $result.map_error(
                          _pipe$2,
                          (_capture) => {
                            return new CannotGenerateRoute(_capture, path$2);
                          },
                        );
                      } else if (route instanceof Dynamic) {
                        let path = route.path;
                        let pages = route.pages;
                        let $ = $simplifile.create_directory_all(temp + path);
                        
                        return $list.try_fold(
                          $dict.to_list(pages),
                          undefined,
                          (_, _use1) => {
                            let page = _use1[0];
                            let el = _use1[1];
                            let path$1 = (((temp + trim_slash(path)) + "/") + routify(
                              page,
                            )) + ".html";
                            let _pipe = el;
                            let _pipe$1 = $element.to_document_string(_pipe);
                            let _pipe$2 = ((_capture) => {
                              return $simplifile.write(path$1, _capture);
                            })(_pipe$1);
                            return $result.map_error(
                              _pipe$2,
                              (_capture) => {
                                return new CannotGenerateRoute(_capture, path$1);
                              },
                            );
                          },
                        );
                      } else {
                        let path = route.path;
                        let el = route.page;
                        let $ = last_segment(path);
                        let path$1 = $[0];
                        let name = $[1];
                        let $1 = $simplifile.create_directory_all(temp + path$1);
                        
                        let path$2 = (((temp + trim_slash(path$1)) + "/") + name) + ".xml";
                        let _pipe = el;
                        let _pipe$1 = $element.to_string(_pipe);
                        let _pipe$2 = ((_capture) => {
                          return $string.append(
                            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n",
                            _capture,
                          );
                        })(_pipe$1);
                        let _pipe$3 = ((_capture) => {
                          return $simplifile.write(path$2, _capture);
                        })(_pipe$2);
                        return $result.map_error(
                          _pipe$3,
                          (_capture) => {
                            return new CannotGenerateRoute(_capture, path$2);
                          },
                        );
                      }
                    },
                  );
                })(),
                (_) => {
                  return $result.try$(
                    (() => {
                      let $ = (() => {
                        let _pipe = $simplifile.is_directory(out_dir$1);
                        return $result.unwrap(_pipe, false);
                      })();
                      if ($) {
                        let _pipe = $simplifile.delete$(out_dir$1);
                        return $result.map_error(
                          _pipe,
                          (var0) => { return new CannotWriteToOutputDir(var0); },
                        );
                      } else {
                        return new Ok(undefined);
                      }
                    })(),
                    (_) => {
                      return $result.try$(
                        (() => {
                          let _pipe = $simplifile.copy_directory(
                            temp,
                            out_dir$1,
                          );
                          return $result.map_error(
                            _pipe,
                            (var0) => {
                              return new CannotWriteToOutputDir(var0);
                            },
                          );
                        })(),
                        (_) => { return new Ok(undefined); },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}

export function build(config) {
  let $ = do_build(config);
  if ($.isOk()) {
    let result = $[0];
    return result;
  } else {
    let error = $[0];
    return new Error(new CannotCreateTempDirectory(error));
  }
}
