import * as $birl from "../../birl/birl.mjs";
import * as $crypto from "../../gleam_crypto/gleam/crypto.mjs";
import * as $bit_array from "../../gleam_stdlib/gleam/bit_array.mjs";
import * as $dict from "../../gleam_stdlib/gleam/dict.mjs";
import * as $int from "../../gleam_stdlib/gleam/int.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import { None, Some } from "../../gleam_stdlib/gleam/option.mjs";
import * as $order from "../../gleam_stdlib/gleam/order.mjs";
import * as $result from "../../gleam_stdlib/gleam/result.mjs";
import { map_error } from "../../gleam_stdlib/gleam/result.mjs";
import * as $string from "../../gleam_stdlib/gleam/string.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $ssg from "../../lustre_ssg/lustre/ssg.mjs";
import * as $party from "../../party/party.mjs";
import * as $simplifile from "../../simplifile/simplifile.mjs";
import * as $snag from "../../snag/snag.mjs";
import * as $arctic from "../arctic.mjs";
import { CachedPage, NewPage, ProcessedCollection } from "../arctic.mjs";
import { Ok, toList, prepend as listPrepend, makeError, isEqual } from "../gleam.mjs";

function lift_ordering(ordering) {
  return (a, b) => {
    return ordering($arctic.to_dummy_page(a), $arctic.to_dummy_page(b));
  };
}

function get_id(p) {
  if (p instanceof CachedPage) {
    let metadata = p.metadata;
    let $ = $dict.get(metadata, "id");
    if (!$.isOk()) {
      throw makeError(
        "assignment_no_match",
        "arctic/build",
        36,
        "get_id",
        "Assignment pattern did not match",
        { value: $ }
      )
    }
    let id = $[0];
    return id;
  } else {
    let page = p[0];
    return page.id;
  }
}

function to_metadata(csv) {
  if (csv.hasLength(0)) {
    return new Ok($dict.new$());
  } else {
    let pair_str = csv.head;
    let rest = csv.tail;
    let $ = $string.split(pair_str, ":");
    if ($.hasLength(0)) {
      return $snag.error("malformed cache (metadata item with no colon)");
    } else {
      let key = $.head;
      let vals = $.tail;
      return $result.try$(
        to_metadata(rest),
        (rest2) => {
          return new Ok($dict.insert(rest2, key, $string.join(vals, ":")));
        },
      );
    }
  }
}

function to_cache(csv) {
  if (csv.hasLength(0)) {
    return new Ok($dict.new$());
  } else if (csv.atLeastLength(1) && csv.head.atLeastLength(2)) {
    let id = csv.head.head;
    let hash = csv.head.tail.head;
    let metadata = csv.head.tail.tail;
    let rest = csv.tail;
    return $result.try$(
      to_cache(rest),
      (rest2) => {
        return $result.try$(
          to_metadata(metadata),
          (metadata2) => {
            return $result.try$(
              (() => {
                let _pipe = $bit_array.base64_decode(hash);
                return map_error(
                  _pipe,
                  (_) => {
                    return $snag.new$(
                      ("malformed cache (`" + hash) + "` is not a valid base-64 hash)",
                    );
                  },
                );
              })(),
              (hash_str) => {
                return new Ok($dict.insert(rest2, id, [hash_str, metadata2]));
              },
            );
          },
        );
      },
    );
  } else {
    let malformed_row = csv.head;
    return $snag.error(
      ("malformed cache (row `" + $string.join(malformed_row, ", ")) + "`)",
    );
  }
}

function parse_csv(csv) {
  let res = $party.go(
    (() => {
      let _pipe = $party.do$(
        $party.char("\""),
        (_) => {
          return $party.do$(
            $party.many_concat(
              $party.either(
                $party.map($party.string("\"\""), (_) => { return "\""; }),
                $party.satisfy((c) => { return c !== "\""; }),
              ),
            ),
            (val) => {
              return $party.do$(
                $party.char("\""),
                (_) => { return $party.return$(val); },
              );
            },
          );
        },
      );
      let _pipe$1 = $party.sep(_pipe, $party.char(","));
      let _pipe$2 = ((p) => {
        return $party.do$(
          p,
          (row) => { return $party.seq($party.char("\n"), $party.return$(row)); },
        );
      })(_pipe$1);
      return $party.many(_pipe$2);
    })(),
    csv,
  );
  return map_error(
    res,
    (e) => {
      if (e instanceof $party.Unexpected) {
        let p = e.pos;
        let s = e.error;
        return $snag.new$(
          (((s + " at ") + $int.to_string(p.row)) + ":") + $int.to_string(p.col),
        );
      } else {
        let p = e.pos;
        return $snag.new$(
          (("internal Arctic error at " + $int.to_string(p.row)) + ":") + $int.to_string(
            p.col,
          ),
        );
      }
    },
  );
}

function read_collection(collection, cache) {
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
              let new_hash = $crypto.hash(
                new $crypto.Sha256(),
                $bit_array.from_string(content),
              );
              let $ = $dict.get(cache, path);
              if ($.isOk() && (isEqual($[0][0], new_hash))) {
                let current_hash = $[0][0];
                let metadata = $[0][1];
                return new Ok(
                  listPrepend(new CachedPage(path, metadata), so_far),
                );
              } else {
                return $result.try$(
                  collection.parse(path, content),
                  (p) => {
                    return $result.try$(
                      (() => {
                        let _pipe = $simplifile.append(
                          ".arctic_cache.csv",
                          ((((((((((((((("\"" + $string.replace(
                            path,
                            "\"",
                            "\"\"",
                          )) + "\",\"") + $bit_array.base64_encode(
                            new_hash,
                            false,
                          )) + "\",\"id:") + $string.replace(p.id, "\"", "\"\"")) + "\",\"title:") + $string.replace(
                            p.title,
                            "\"",
                            "\"\"",
                          )) + "\"") + $option.unwrap(
                            $option.map(
                              p.date,
                              (d) => {
                                return (",\"date:" + $birl.to_naive_date_string(
                                  d,
                                )) + "\"";
                              },
                            ),
                            "",
                          )) + ",\"tags:") + $string.join(
                            $list.map(
                              p.tags,
                              (_capture) => {
                                return $string.replace(_capture, "\"", "\"\"");
                              },
                            ),
                            ",",
                          )) + "\",\"blerb:") + $string.replace(
                            p.blerb,
                            "\"",
                            "\"\"",
                          )) + "\"") + $dict.fold(
                            p.metadata,
                            "",
                            (b, k, v) => {
                              return ((((b + ",\"") + $string.replace(
                                k,
                                "\"",
                                "\"\"",
                              )) + ":") + $string.replace(v, "\"", "\"\"")) + "\"";
                            },
                          )) + "\n",
                        );
                        return map_error(
                          _pipe,
                          (err) => {
                            return $snag.new$(
                              ("couldn't write to cache (" + $simplifile.describe_error(
                                err,
                              )) + ")",
                            );
                          },
                        );
                      })(),
                      (_) => {
                        return new Ok(listPrepend(new NewPage(p), so_far));
                      },
                    );
                  },
                );
              }
            },
          );
        },
      );
      return $result.map(_pipe, $list.reverse);
    },
  );
}

function process(collections, cache) {
  return $list.try_fold(
    collections,
    toList([]),
    (rest, collection) => {
      return $result.try$(
        read_collection(collection, cache),
        (pages_unsorted) => {
          let pages = $list.sort(
            pages_unsorted,
            lift_ordering(collection.ordering),
          );
          return new Ok(
            listPrepend(new ProcessedCollection(collection, pages), rest),
          );
        },
      );
    },
  );
}

function spa(frame, html) {
  return frame(
    $html.div(
      toList([]),
      toList([
        $html.script(
          toList([]),
          "\nvar _ARCTIC_C;\nif (typeof HTMLDocument === 'undefined') HTMLDocument = Document;\nlet arctic_dom_content_loaded_listeners = [];\nHTMLDocument.prototype.arctic_addEventListener = HTMLDocument.prototype.addEventListener;\nHTMLDocument.prototype.addEventListener = function(type, listener, options) {\n  if (type === 'DOMContentLoaded') {\n    arctic_dom_content_loaded_listeners.push(listener);\n    document.arctic_addEventListener(type, listener, options);\n  } else document.arctic_addEventListener(type, listener, options);\n}\n       ",
        ),
        $html.div(toList([$attribute.id("arctic-app")]), toList([html])),
        $html.script(
          toList([]),
          "\n// SPA algorithm partially inspired by Hayleigh Thompson's wonderful Modem library\nasync function go_to(url, loader, back) {\n  if (!back && url.pathname === window.location.pathname) {\n    if (url.hash) document.getElementById(url.hash.slice(1))?.scrollIntoView();\n    else window.scrollTo(0, 0);\n    return;\n  }\n  document.dispatchEvent(new Event('beforeunload'));\n  document.dispatchEvent(new Event('unload'));\n  for (let i = 0; i < arctic_dom_content_loaded_listeners.length; i++)\n    document.removeEventListener('DOMContentLoaded', arctic_dom_content_loaded_listeners[i]);\n  arctic_dom_content_loaded_listeners = [];\n  const $app = document.getElementById('arctic-app');\n  if (loader) $app.innerHTML = '<div id=\"arctic-loader\"></div>';\n  if (!back) window.history.pushState({}, '', url.href);\n  // handle new path\n  const response = await fetch('/__pages/' + url.pathname + '/index.html');\n  if (!response.ok) response = await fetch('/__pages/404.html');\n  if (!response.ok) return;\n  const html = await response.text();\n  $app.innerHTML = '<script>_ARCTIC_C=0;</'+'script>'+html;\n  // re-create script elements, so their javascript runs\n  const scripts = $app.querySelectorAll('script');\n  const num_scripts = scripts.length;\n  for (let i = 0; i < num_scripts; i++) {\n    const script = scripts[i];\n    const n = document.createElement('script');\n    // scripts load nondeterministically, so we figure out when they've all finished via the _ARCTIC_C barrier\n    if (script.innerHTML === '') {\n      // external scripts don't run their inline js, so they need an onload listener\n      n.onload = () => {\n        if (++_ARCTIC_C >= num_scripts)\n          document.dispatchEvent(new Event('DOMContentLoaded'));\n      };\n    } else {\n      // inline scripts might not trigger onload, so they get js appended to the end instead\n      const t = document.createTextNode(\n        script.innerHTML +\n        ';if(++_ARCTIC_C>=' + num_scripts +\n        ')document.dispatchEvent(new Event(\\'DOMContentLoaded\\'));'\n      );\n      n.appendChild(t);\n    }\n    // attributes at the end because 'src' needs to load after onload is listening\n    for (let j = 0; j < script.attributes.length; j++) {\n      const attr = script.attributes[j];\n      n.setAttribute(attr.name, attr.value);\n    }\n    script.parentNode.replaceChild(n, script);\n  }\n  window.requestAnimationFrame(() => {\n    if (url.hash)\n      document.getElementById(url.hash.slice(1))?.scrollIntoView();\n    else\n      window.scrollTo(0, 0);\n  });\n}\ndocument.addEventListener('click', async function(e) {\n  const a = find_a(e.target);\n  if (!a) return;\n  try {\n    const url = new URL(a.href);\n    const is_external = url.host !== window.location.host;\n    if (is_external) return;\n    event.preventDefault();\n    go_to(url, false, false);\n  } catch {\n    return;\n  }\n});\nwindow.addEventListener('popstate', (e) => {\n  e.preventDefault();\n  const url = new URL(window.location.href);\n  go_to(url, false, true);\n});\nfunction find_a(target) {\n  if (!target || target.tagName === 'BODY') return null;\n  if (target.tagName === 'A') return target;\n  return find_a(target.parentElement);\n}",
        ),
      ]),
    ),
  );
}

function add_route(ssg_config, config, path, content) {
  let $ = config.render_spa;
  if ($ instanceof Some) {
    let frame = $[0];
    let _pipe = ssg_config;
    let _pipe$1 = $ssg.add_static_route(_pipe, "/__pages/" + path, content);
    return $ssg.add_static_route(_pipe$1, "/" + path, spa(frame, content));
  } else {
    let _pipe = ssg_config;
    return $ssg.add_static_route(_pipe, "/" + path, content);
  }
}

function make_ssg_config(processed_collections, config, k) {
  let home = config.render_home(processed_collections);
  return $result.try$(
    (() => {
      let _pipe = $ssg.new$("arctic_build");
      let _pipe$1 = $ssg.use_index_routes(_pipe);
      let _pipe$2 = add_route(_pipe$1, config, "", home);
      let _pipe$3 = $list.fold(
        config.main_pages,
        _pipe$2,
        (ssg_config, page) => {
          let _pipe$3 = ssg_config;
          return add_route(_pipe$3, config, page.id, page.html);
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
              return add_route(
                ssg_config,
                config,
                processed.collection.directory,
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
              return add_route(
                s,
                config,
                (processed.collection.directory + "/") + rp.id,
                rp.html,
              );
            },
          );
          let _pipe$4 = $list.fold(
            processed.pages,
            ssg_config3,
            (s, p) => {
              if (p instanceof NewPage) {
                let new_page = p[0];
                return add_route(
                  s,
                  config,
                  (processed.collection.directory + "/") + new_page.id,
                  processed.collection.render(new_page),
                );
              } else {
                let path = p.path;
                let $ = $string.split(path, ".txt");
                if (!$.atLeastLength(1)) {
                  throw makeError(
                    "assignment_no_match",
                    "arctic/build",
                    403,
                    "",
                    "Assignment pattern did not match",
                    { value: $ }
                  )
                }
                let start = $.head;
                let cached_path = ("arctic_build/" + start) + "/index.html";
                let res = $simplifile.read(cached_path);
                let content = (() => {
                  if (res.isOk()) {
                    let c = res[0];
                    return c;
                  } else {
                    throw makeError(
                      "panic",
                      "arctic/build",
                      408,
                      "",
                      cached_path,
                      {}
                    )
                  }
                })();
                let $1 = config.render_spa;
                if ($1 instanceof Some) {
                  let spa_content_path = ("arctic_build/__pages/" + start) + "/index.html";
                  let res$1 = $simplifile.read(spa_content_path);
                  let spa_content = (() => {
                    if (res$1.isOk()) {
                      let c = res$1[0];
                      return c;
                    } else {
                      throw makeError(
                        "panic",
                        "arctic/build",
                        420,
                        "",
                        cached_path,
                        {}
                      )
                    }
                  })();
                  let _pipe$4 = s;
                  let _pipe$5 = $ssg.add_static_asset(
                    _pipe$4,
                    ("/__pages/" + start) + "/index.html",
                    spa_content,
                  );
                  return $ssg.add_static_asset(
                    _pipe$5,
                    ("/" + start) + "/index.html",
                    content,
                  );
                } else {
                  return $ssg.add_static_asset(
                    s,
                    ("/" + start) + "/index.html",
                    content,
                  );
                }
              }
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
          return ((((((((js + "\"") + processed.collection.directory) + "/") + get_id(
            page,
          )) + "\": \"arctic_build/") + processed.collection.directory) + "/") + get_id(
            page,
          )) + "/index.html\", ";
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
  let $ = $simplifile.create_file(".arctic_cache.csv");
  
  return $result.try$(
    (() => {
      let _pipe = $simplifile.read(".arctic_cache.csv");
      return map_error(
        _pipe,
        (err) => {
          return $snag.new$(
            ("couldn't read cache (" + $simplifile.describe_error(err)) + ")",
          );
        },
      );
    })(),
    (content) => {
      return $result.try$(
        (() => {
          if (content === "") {
            return new Ok(toList([]));
          } else {
            let _pipe = parse_csv(content);
            return $snag.context(_pipe, "couldn't parse cache");
          }
        })(),
        (csv) => {
          return $result.try$(
            to_cache($list.reverse(csv)),
            (cache) => {
              return $result.try$(
                process(config.collections, cache),
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
            },
          );
        },
      );
    },
  );
}
