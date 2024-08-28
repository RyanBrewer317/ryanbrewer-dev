import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import { None, Some } from "../../gleam_stdlib/gleam/option.mjs";
import * as $result from "../../gleam_stdlib/gleam/result.mjs";
import { map_error } from "../../gleam_stdlib/gleam/result.mjs";
import * as $ssg from "../../lustre_ssg/lustre/ssg.mjs";
import * as $simplifile from "../../simplifile/simplifile.mjs";
import * as $snag from "../../snag/snag.mjs";
import * as $arctic from "../arctic.mjs";
import { ProcessedCollection } from "../arctic.mjs";
import { Ok, toList, prepend as listPrepend } from "../gleam.mjs";

function read_collection(collection) {
  return $result.try$(
    (() => {
      let _pipe = $simplifile.get_files(collection.directory);
      return map_error(
        _pipe,
        (err) => {
          return $snag.new$(
            ((("couldn't get files in `" + collection.directory) + "` (") + $simplifile.describe_error(
              err,
            )) + ")",
          );
        },
      );
    })(),
    (paths) => {
      let _pipe = $list.try_fold(
        paths,
        toList([]),
        (so_far, path) => {
          return $result.try$(
            map_error(
              $simplifile.read(path),
              (err) => {
                return $snag.new$(
                  ((("could not load file `" + path) + "` (") + $simplifile.describe_error(
                    err,
                  )) + ")",
                );
              },
            ),
            (content) => {
              return $result.try$(
                collection.parse(path, content),
                (p) => { return new Ok(listPrepend(p, so_far)); },
              );
            },
          );
        },
      );
      return $result.map(_pipe, $list.reverse);
    },
  );
}

function process(collections) {
  return $list.try_fold(
    collections,
    toList([]),
    (rest, collection) => {
      return $result.try$(
        read_collection(collection),
        (pages_unsorted) => {
          let pages = $list.sort(pages_unsorted, collection.ordering);
          return new Ok(
            listPrepend(new ProcessedCollection(collection, pages), rest),
          );
        },
      );
    },
  );
}

function make_ssg_config(processed_collections, config, k) {
  return $result.try$(
    (() => {
      let _pipe = $ssg.new$("arctic_build");
      let _pipe$1 = $ssg.use_index_routes(_pipe);
      let _pipe$2 = $ssg.add_static_route(
        _pipe$1,
        "/",
        config.render_home(processed_collections),
      );
      let _pipe$3 = $list.fold(
        config.main_pages,
        _pipe$2,
        (ssg_config, page) => {
          return $ssg.add_static_route(ssg_config, "/" + page.id, page.html);
        },
      );
      return $list.try_fold(
        processed_collections,
        _pipe$3,
        (ssg_config, processed) => {
          let ssg_config2 = (() => {
            let $ = processed.collection.index;
            if ($ instanceof Some) {
              let render = $[0];
              return $ssg.add_static_route(
                ssg_config,
                "/" + processed.collection.directory,
                render(processed.pages),
              );
            } else {
              return ssg_config;
            }
          })();
          let ssg_config3 = $list.fold(
            processed.collection.raw_pages,
            ssg_config2,
            (s, rp) => {
              return $ssg.add_static_route(
                s,
                (("/" + processed.collection.directory) + "/") + rp.id,
                rp.html,
              );
            },
          );
          let _pipe$4 = $list.fold(
            processed.pages,
            ssg_config3,
            (s, p) => {
              return $ssg.add_static_route(
                s,
                (("/" + processed.collection.directory) + "/") + p.id,
                processed.collection.render(p),
              );
            },
          );
          return new Ok(_pipe$4);
        },
      );
    })(),
    (ssg_config) => { return k(ssg_config); },
  );
}

function ssg_build(ssg_config, k) {
  return $result.try$(
    (() => {
      let _pipe = $ssg.build(ssg_config);
      return map_error(
        _pipe,
        (err) => {
          if (err instanceof $ssg.CannotCreateTempDirectory) {
            let file_err = err.reason;
            return $snag.new$(
              ("couldn't create temp directory (" + $simplifile.describe_error(
                file_err,
              )) + ")",
            );
          } else if (err instanceof $ssg.CannotWriteStaticAsset) {
            let file_err = err.reason;
            let path = err.path;
            return $snag.new$(
              ((("couldn't put asset at `" + path) + "` (") + $simplifile.describe_error(
                file_err,
              )) + ")",
            );
          } else if (err instanceof $ssg.CannotGenerateRoute) {
            let file_err = err.reason;
            let path = err.path;
            return $snag.new$(
              ((("couldn't generate `" + path) + "` (") + $simplifile.describe_error(
                file_err,
              )) + ")",
            );
          } else if (err instanceof $ssg.CannotWriteToOutputDir) {
            let file_err = err.reason;
            return $snag.new$(
              ("couldn't move from temp directory to output directory (" + $simplifile.describe_error(
                file_err,
              )) + ")",
            );
          } else {
            let file_err = err.reason;
            return $snag.new$(
              ("couldn't remove temp directory (" + $simplifile.describe_error(
                file_err,
              )) + ")",
            );
          }
        },
      );
    })(),
    (_) => { return k(); },
  );
}

function add_public(k) {
  return $result.try$(
    (() => {
      let _pipe = $simplifile.create_directory("arctic_build/public");
      return map_error(
        _pipe,
        (err) => {
          return $snag.new$(
            ("couldn't create directory `arctic_build/public` (" + $simplifile.describe_error(
              err,
            )) + ")",
          );
        },
      );
    })(),
    (_) => {
      return $result.try$(
        (() => {
          let _pipe = $simplifile.copy_directory(
            "public",
            "arctic_build/public",
          );
          return map_error(
            _pipe,
            (err) => {
              return $snag.new$(
                ("couldn't copy `public` to `arctic_build/public` (" + $simplifile.describe_error(
                  err,
                )) + ")",
              );
            },
          );
        })(),
        (_) => { return k(); },
      );
    },
  );
}

function option_to_result_nil(opt, f) {
  if (opt instanceof Some) {
    let a = opt[0];
    return f(a);
  } else {
    return new Ok(undefined);
  }
}

function add_feed(processed_collections, k) {
  return $result.try$(
    (() => {
      let _pipe = $simplifile.create_file("arctic_build/public/feed.rss");
      return map_error(
        _pipe,
        (err) => {
          return $snag.new$(
            ("couldn't create file `arctic_build/public/feed.rss` (" + $simplifile.describe_error(
              err,
            )) + ")",
          );
        },
      );
    })(),
    (_) => {
      return $result.try$(
        $list.try_each(
          processed_collections,
          (processed) => {
            return option_to_result_nil(
              processed.collection.feed,
              (feed) => {
                let _pipe = $simplifile.write(
                  "arctic_build/public/" + feed[0],
                  feed[1](processed.pages),
                );
                return map_error(
                  _pipe,
                  (err) => {
                    return $snag.new$(
                      ("couldn't write to `arctic_build/public/feed.rss` (" + $simplifile.describe_error(
                        err,
                      )) + ")",
                    );
                  },
                );
              },
            );
          },
        ),
        (_) => { return k(); },
      );
    },
  );
}

function add_vite_config(config, processed_collections, k) {
  let home_page = "\"main\": \"arctic_build/index.html\"";
  let main_pages = $list.fold(
    config.main_pages,
    "",
    (js, page) => {
      return ((((js + "\"") + page.id) + "\": \"arctic_build/") + page.id) + "/index.html\", ";
    },
  );
  let collected_pages = $list.fold(
    processed_collections,
    "",
    (js, processed) => {
      return $list.fold(
        processed.pages,
        js,
        (js, page) => {
          return ((((((((js + "\"") + processed.collection.directory) + "/") + page.id) + "\": \"arctic_build/") + processed.collection.directory) + "/") + page.id) + "/index.html\", ";
        },
      );
    },
  );
  return $result.try$(
    (() => {
      let _pipe = $simplifile.write(
        "arctic_vite_config.js",
        ((("\n  // NOTE: AUTO-GENERATED! DO NOT EDIT!\n  export default {" + main_pages) + collected_pages) + home_page) + "};",
      );
      return map_error(
        _pipe,
        (err) => {
          return $snag.new$(
            ("couldn't create `arctic_vite_config.js` (" + $simplifile.describe_error(
              err,
            )) + ")",
          );
        },
      );
    })(),
    (_) => { return k(); },
  );
}

export function build(config) {
  return $result.try$(
    process(config.collections),
    (processed_collections) => {
      return make_ssg_config(
        processed_collections,
        config,
        (ssg_config) => {
          return ssg_build(
            ssg_config,
            () => {
              return add_public(
                () => {
                  return add_feed(
                    processed_collections,
                    () => {
                      return add_vite_config(
                        config,
                        processed_collections,
                        () => { return new Ok(undefined); },
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
