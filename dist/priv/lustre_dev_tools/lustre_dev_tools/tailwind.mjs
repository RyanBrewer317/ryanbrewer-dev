import * as $filepath from "../../filepath/filepath.mjs";
import * as $ansi from "../../gleam_community_ansi/gleam_community/ansi.mjs";
import * as $crypto from "../../gleam_crypto/gleam/crypto.mjs";
import * as $bit_array from "../../gleam_stdlib/gleam/bit_array.mjs";
import * as $dynamic from "../../gleam_stdlib/gleam/dynamic.mjs";
import * as $result from "../../gleam_stdlib/gleam/result.mjs";
import * as $set from "../../gleam_stdlib/gleam/set.mjs";
import * as $string from "../../gleam_stdlib/gleam/string.mjs";
import * as $simplifile from "../../simplifile/simplifile.mjs";
import { Execute, FilePermissions, Read, Write } from "../../simplifile/simplifile.mjs";
import { Ok, Error, toList } from "../gleam.mjs";
import * as $cli from "../lustre_dev_tools/cli.mjs";
import * as $error from "../lustre_dev_tools/error.mjs";
import { CannotSetPermissions, CannotWriteFile, NetworkError, UnknownPlatform } from "../lustre_dev_tools/error.mjs";
import * as $project from "../lustre_dev_tools/project.mjs";
import * as $utils from "../lustre_dev_tools/utils.mjs";

function detect_legacy_config() {
  let root = $project.root();
  return $cli.try$(
    $project.config(),
    (config) => {
      let old_config_path = $filepath.join(root, "tailwind.config.js");
      let $ = $simplifile.is_file(old_config_path);
      if ($ instanceof Ok) {
        let $1 = $[0];
        if ($1) {
          return $cli.notify(
            $ansi.bold("\nLegacy Tailwind config detected:"),
            () => {
              return $cli.notify(
                (() => {
                  let _pipe = "\nLustre Dev Tools now only supports Tailwind CSS v4.0 and above. If you are not\nready to migrate your config to the new format, you can continue using JavaScript\nconfig by including the `@config` directive in your `src/{app_name}.css` file.\n\nSee: https://tailwindcss.com/docs/upgrade-guide#using-a-javascript-config-file\n\nYou can supress this message by removing `tailwind.config.js` from your project.\n";
                  let _pipe$1 = $string.trim(_pipe);
                  return $string.replace(_pipe$1, "{app_name}", config.name);
                })(),
                () => { return $cli.return$(true); },
              );
            },
          );
        } else {
          return $cli.return$(false);
        }
      } else {
        return $cli.return$(false);
      }
    },
  );
}

function display_next_steps() {
  return $cli.try$(
    $project.config(),
    (config) => {
      return $cli.notify(
        $ansi.bold("\nNext Steps:"),
        () => {
          return $cli.notify(
            (() => {
              let _pipe = "\n1. Be sure to update your root `index.html` file to include\n   <link rel=\"stylesheet\" type=\"text/css\" href=\"./priv/static/{app_name}.css\" />";
              let _pipe$1 = $string.trim(_pipe);
              return $string.replace(_pipe$1, "{app_name}", config.name);
            })(),
            () => { return $cli.return$(undefined); },
          );
        },
      );
    },
  );
}

function generate_config() {
  let root = $project.root();
  return $cli.try$(
    $project.config(),
    (config) => {
      let entry_css_path = $filepath.join(root, ("src/" + config.name) + ".css");
      let $ = $simplifile.read(entry_css_path);
      if ($ instanceof Ok) {
        let entry_css = $[0];
        let $1 = $string.contains(entry_css, "@import \"tailwindcss");
        if ($1) {
          return $cli.return$(undefined);
        } else {
          let entry_css$1 = "@import \"tailwindcss\";\n" + entry_css;
          return $cli.log(
            "Adding Tailwind integration to " + entry_css_path,
            () => {
              return $cli.try$(
                (() => {
                  let _pipe = $simplifile.write(entry_css_path, entry_css$1);
                  return $result.map_error(
                    _pipe,
                    (_capture) => {
                      return new CannotWriteFile(_capture, entry_css_path);
                    },
                  );
                })(),
                (_) => {
                  return $cli.success(
                    entry_css_path + " updated!",
                    () => { return $cli.return$(undefined); },
                  );
                },
              );
            },
          );
        }
      } else {
        return $cli.log(
          "Generating Tailwind config",
          () => {
            return $cli.try$(
              (() => {
                let _pipe = $simplifile.write(
                  entry_css_path,
                  "@import \"tailwindcss\";\n",
                );
                return $result.map_error(
                  _pipe,
                  (_capture) => {
                    return new CannotWriteFile(_capture, entry_css_path);
                  },
                );
              })(),
              (_) => {
                return $cli.success(
                  "Tailwind succeessfully configured!",
                  () => {
                    return $cli.do$(
                      display_next_steps(),
                      (_) => { return $cli.return$(undefined); },
                    );
                  },
                );
              },
            );
          },
        );
      }
    },
  );
}

function get_download_url_and_hash(os, cpu) {
  let base = "https://github.com/tailwindlabs/tailwindcss/releases/download/v4.1.10/tailwindcss-";
  if (cpu === "arm64") {
    if (os === "linux") {
      return new Ok(
        [
          base + "linux-arm64",
          "67EB620BB404C2046D3C127DBF2D7F9921595065475E7D2D528E39C1BB33C9B6",
        ],
      );
    } else if (os === "darwin") {
      return new Ok(
        [
          base + "macos-arm64",
          "F34A85A75B1F2DE2C7E4A9FBC4FB976E64A2780980E843DF87D9C13F555F4A4C",
        ],
      );
    } else {
      return new Error(new UnknownPlatform("tailwind", os, cpu));
    }
  } else if (cpu === "aarch64") {
    if (os === "linux") {
      return new Ok(
        [
          base + "linux-arm64",
          "67EB620BB404C2046D3C127DBF2D7F9921595065475E7D2D528E39C1BB33C9B6",
        ],
      );
    } else if (os === "darwin") {
      return new Ok(
        [
          base + "macos-arm64",
          "F34A85A75B1F2DE2C7E4A9FBC4FB976E64A2780980E843DF87D9C13F555F4A4C",
        ],
      );
    } else {
      return new Error(new UnknownPlatform("tailwind", os, cpu));
    }
  } else if (cpu === "x64") {
    if (os === "linux") {
      return new Ok(
        [
          base + "linux-x64",
          "0A85A3E533F2E7983BDB91C08EA44F0EAB3BECC275E60B3BAADDF18F71D390BF",
        ],
      );
    } else if (os === "win32") {
      return new Ok(
        [
          base + "windows-x64.exe",
          "5539346428771D8974AC63B68D1F477866BECECF615B3A14F2F197A36BDAAC33",
        ],
      );
    } else if (os === "darwin") {
      return new Ok(
        [
          base + "macos-x64",
          "47A130C5F639384456E0AC8A0D60B95D74906187314A4DBC37E7C1DDBEB713AE",
        ],
      );
    } else {
      return new Error(new UnknownPlatform("tailwind", os, cpu));
    }
  } else if (cpu === "x86_64") {
    if (os === "linux") {
      return new Ok(
        [
          base + "linux-x64",
          "0A85A3E533F2E7983BDB91C08EA44F0EAB3BECC275E60B3BAADDF18F71D390BF",
        ],
      );
    } else if (os === "win32") {
      return new Ok(
        [
          base + "windows-x64.exe",
          "5539346428771D8974AC63B68D1F477866BECECF615B3A14F2F197A36BDAAC33",
        ],
      );
    } else if (os === "darwin") {
      return new Ok(
        [
          base + "macos-x64",
          "47A130C5F639384456E0AC8A0D60B95D74906187314A4DBC37E7C1DDBEB713AE",
        ],
      );
    } else {
      return new Error(new UnknownPlatform("tailwind", os, cpu));
    }
  } else {
    return new Error(new UnknownPlatform("tailwind", os, cpu));
  }
}

function check_tailwind_integrity(bin, expected_hash) {
  let hash = $crypto.hash(new $crypto.Sha256(), bin);
  let hash_string = $bit_array.base16_encode(hash);
  let $ = hash_string === expected_hash;
  if ($) {
    return new Ok(undefined);
  } else {
    return new Error(new $error.InvalidTailwindBinary());
  }
}

function check_tailwind_exists(path, os, cpu) {
  let $ = $simplifile.is_file(path);
  if ($ instanceof Ok) {
    let $1 = $[0];
    if ($1) {
      return $result.unwrap(
        $result.try$(
          get_download_url_and_hash(os, cpu),
          (_use0) => {
            let hash = _use0[1];
            return $result.try$(
              (() => {
                let _pipe = $simplifile.read_bits(path);
                return $result.replace_error(
                  _pipe,
                  new $error.InvalidTailwindBinary(),
                );
              })(),
              (bin) => {
                return $result.try$(
                  check_tailwind_integrity(bin, hash),
                  (_) => { return new Ok(true); },
                );
              },
            );
          },
        ),
        false,
      );
    } else {
      return false;
    }
  } else {
    return false;
  }
}

function write_tailwind(bin, outdir, outfile) {
  let $ = $simplifile.create_directory_all(outdir);
  
  let _pipe = $simplifile.write_bits(outfile, bin);
  return $result.map_error(
    _pipe,
    (_capture) => {
      return new CannotWriteFile(_capture, $filepath.join(outdir, outfile));
    },
  );
}

function set_file_permissions(file) {
  let permissions = new FilePermissions(
    $set.from_list(toList([new Read(), new Write(), new Execute()])),
    $set.from_list(toList([new Read(), new Execute()])),
    $set.from_list(toList([new Read(), new Execute()])),
  );
  let _pipe = $simplifile.set_permissions(file, permissions);
  return $result.map_error(
    _pipe,
    (_capture) => { return new CannotSetPermissions(_capture, file); },
  );
}
