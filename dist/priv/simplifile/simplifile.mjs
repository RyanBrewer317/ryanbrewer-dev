import * as $filepath from "../filepath/filepath.mjs";
import * as $bit_array from "../gleam_stdlib/gleam/bit_array.mjs";
import * as $int from "../gleam_stdlib/gleam/int.mjs";
import * as $list from "../gleam_stdlib/gleam/list.mjs";
import * as $result from "../gleam_stdlib/gleam/result.mjs";
import * as $set from "../gleam_stdlib/gleam/set.mjs";
import { Ok, Error, CustomType as $CustomType, isEqual, toBitArray } from "./gleam.mjs";
import {
  fileInfo as do_file_info,
  isValidDirectory as do_verify_is_directory,
  isValidFile as do_verify_is_file,
  isValidSymlink as do_verify_is_symlink,
  currentDirectory as do_current_directory,
  setPermissions as do_set_permissions,
  deleteFileOrDirRecursive as do_delete,
  readBits as do_read_bits,
  writeBits as do_write_bits,
  appendBits as do_append_bits,
  isDirectory as do_is_directory,
  makeDirectory as do_make_directory,
  makeSymlink as do_make_symlink,
  createDirAll as do_create_dir_all,
  listContents as do_read_directory,
  copyFile as do_copy_file,
  renameFile as do_rename_file,
  isFile as do_is_file,
} from "./simplifile_js.mjs";

export class Eacces extends $CustomType {}

export class Eagain extends $CustomType {}

export class Ebadf extends $CustomType {}

export class Ebadmsg extends $CustomType {}

export class Ebusy extends $CustomType {}

export class Edeadlk extends $CustomType {}

export class Edeadlock extends $CustomType {}

export class Edquot extends $CustomType {}

export class Eexist extends $CustomType {}

export class Efault extends $CustomType {}

export class Efbig extends $CustomType {}

export class Eftype extends $CustomType {}

export class Eintr extends $CustomType {}

export class Einval extends $CustomType {}

export class Eio extends $CustomType {}

export class Eisdir extends $CustomType {}

export class Eloop extends $CustomType {}

export class Emfile extends $CustomType {}

export class Emlink extends $CustomType {}

export class Emultihop extends $CustomType {}

export class Enametoolong extends $CustomType {}

export class Enfile extends $CustomType {}

export class Enobufs extends $CustomType {}

export class Enodev extends $CustomType {}

export class Enolck extends $CustomType {}

export class Enolink extends $CustomType {}

export class Enoent extends $CustomType {}

export class Enomem extends $CustomType {}

export class Enospc extends $CustomType {}

export class Enosr extends $CustomType {}

export class Enostr extends $CustomType {}

export class Enosys extends $CustomType {}

export class Enotblk extends $CustomType {}

export class Enotdir extends $CustomType {}

export class Enotsup extends $CustomType {}

export class Enxio extends $CustomType {}

export class Eopnotsupp extends $CustomType {}

export class Eoverflow extends $CustomType {}

export class Eperm extends $CustomType {}

export class Epipe extends $CustomType {}

export class Erange extends $CustomType {}

export class Erofs extends $CustomType {}

export class Espipe extends $CustomType {}

export class Esrch extends $CustomType {}

export class Estale extends $CustomType {}

export class Etxtbsy extends $CustomType {}

export class Exdev extends $CustomType {}

export class NotUtf8 extends $CustomType {}

export class Unknown extends $CustomType {}

export class FileInfo extends $CustomType {
  constructor(size, mode, nlinks, inode, user_id, group_id, dev, atime_seconds, mtime_seconds, ctime_seconds) {
    super();
    this.size = size;
    this.mode = mode;
    this.nlinks = nlinks;
    this.inode = inode;
    this.user_id = user_id;
    this.group_id = group_id;
    this.dev = dev;
    this.atime_seconds = atime_seconds;
    this.mtime_seconds = mtime_seconds;
    this.ctime_seconds = ctime_seconds;
  }
}

export class Read extends $CustomType {}

export class Write extends $CustomType {}

export class Execute extends $CustomType {}

export class FilePermissions extends $CustomType {
  constructor(user, group, other) {
    super();
    this.user = user;
    this.group = group;
    this.other = other;
  }
}

export function describe_error(error) {
  if (error instanceof Eperm) {
    return "Operation not permitted";
  } else if (error instanceof Enoent) {
    return "No such file or directory";
  } else if (error instanceof Esrch) {
    return "No such process";
  } else if (error instanceof Eintr) {
    return "Interrupted system call";
  } else if (error instanceof Eio) {
    return "Input/output error";
  } else if (error instanceof Enxio) {
    return "Device not configured";
  } else if (error instanceof Ebadf) {
    return "Bad file descriptor";
  } else if (error instanceof Edeadlk) {
    return "Resource deadlock avoided";
  } else if (error instanceof Edeadlock) {
    return "Resource deadlock avoided";
  } else if (error instanceof Enomem) {
    return "Cannot allocate memory";
  } else if (error instanceof Eacces) {
    return "Permission denied";
  } else if (error instanceof Efault) {
    return "Bad address";
  } else if (error instanceof Enotblk) {
    return "Block device required";
  } else if (error instanceof Ebusy) {
    return "Resource busy";
  } else if (error instanceof Eexist) {
    return "File exists";
  } else if (error instanceof Exdev) {
    return "Cross-device link";
  } else if (error instanceof Enodev) {
    return "Operation not supported by device";
  } else if (error instanceof Enotdir) {
    return "Not a directory";
  } else if (error instanceof Eisdir) {
    return "Is a directory";
  } else if (error instanceof Einval) {
    return "Invalid argument";
  } else if (error instanceof Enfile) {
    return "Too many open files in system";
  } else if (error instanceof Emfile) {
    return "Too many open files";
  } else if (error instanceof Etxtbsy) {
    return "Text file busy";
  } else if (error instanceof Efbig) {
    return "File too large";
  } else if (error instanceof Enospc) {
    return "No space left on device";
  } else if (error instanceof Espipe) {
    return "Illegal seek";
  } else if (error instanceof Erofs) {
    return "Read-only file system";
  } else if (error instanceof Emlink) {
    return "Too many links";
  } else if (error instanceof Epipe) {
    return "Broken pipe";
  } else if (error instanceof Erange) {
    return "Result too large";
  } else if (error instanceof Eagain) {
    return "Resource temporarily unavailable";
  } else if (error instanceof Enotsup) {
    return "Operation not supported";
  } else if (error instanceof Enobufs) {
    return "No buffer space available";
  } else if (error instanceof Eloop) {
    return "Too many levels of symbolic links";
  } else if (error instanceof Enametoolong) {
    return "File name too long";
  } else if (error instanceof Edquot) {
    return "Disc quota exceeded";
  } else if (error instanceof Estale) {
    return "Stale NFS file handle";
  } else if (error instanceof Enolck) {
    return "No locks available";
  } else if (error instanceof Enosys) {
    return "Function not implemented";
  } else if (error instanceof Eftype) {
    return "Inappropriate file type or format";
  } else if (error instanceof Eoverflow) {
    return "Value too large to be stored in data type";
  } else if (error instanceof Ebadmsg) {
    return "Bad message";
  } else if (error instanceof Emultihop) {
    return "Multihop attempted";
  } else if (error instanceof Enolink) {
    return "Link has been severed";
  } else if (error instanceof Enosr) {
    return "No STREAM resources";
  } else if (error instanceof Enostr) {
    return "Not a STREAM";
  } else if (error instanceof Eopnotsupp) {
    return "Operation not supported on socket";
  } else if (error instanceof NotUtf8) {
    return "File not UTF-8 encoded";
  } else {
    return "Unknown error";
  }
}

function permission_to_integer(permission) {
  if (permission instanceof Read) {
    return 0o4;
  } else if (permission instanceof Write) {
    return 0o2;
  } else {
    return 0o1;
  }
}

export function file_permissions_to_octal(permissions) {
  let make_permission_digit = (permissions) => {
    let _pipe = permissions;
    let _pipe$1 = $set.to_list(_pipe);
    let _pipe$2 = $list.map(_pipe$1, permission_to_integer);
    return $int.sum(_pipe$2);
  };
  return (make_permission_digit(permissions.user) * 64 + make_permission_digit(
    permissions.group,
  ) * 8) + make_permission_digit(permissions.other);
}

function do_read(filepath) {
  let $ = do_read_bits(filepath);
  if ($.isOk()) {
    let bits = $[0];
    let $1 = $bit_array.to_string(bits);
    if ($1.isOk()) {
      let str = $1[0];
      return new Ok(str);
    } else {
      return new Error("NOTUTF8");
    }
  } else {
    let e = $[0];
    return new Error(e);
  }
}

function do_write(content, filepath) {
  let _pipe = content;
  let _pipe$1 = $bit_array.from_string(_pipe);
  return do_write_bits(_pipe$1, filepath);
}

function do_append(content, filepath) {
  let _pipe = content;
  let _pipe$1 = $bit_array.from_string(_pipe);
  return do_append_bits(_pipe$1, filepath);
}

export function is_directory(filepath) {
  return do_is_directory(filepath);
}

function cast_error(input) {
  return $result.map_error(
    input,
    (e) => {
      if (e === "EACCES") {
        return new Eacces();
      } else if (e === "EAGAIN") {
        return new Eagain();
      } else if (e === "EBADF") {
        return new Ebadf();
      } else if (e === "EBADMSG") {
        return new Ebadmsg();
      } else if (e === "EBUSY") {
        return new Ebusy();
      } else if (e === "EDEADLK") {
        return new Edeadlk();
      } else if (e === "EDEADLOCK") {
        return new Edeadlock();
      } else if (e === "EDQUOT") {
        return new Edquot();
      } else if (e === "EEXIST") {
        return new Eexist();
      } else if (e === "EFAULT") {
        return new Efault();
      } else if (e === "EFBIG") {
        return new Efbig();
      } else if (e === "EFTYPE") {
        return new Eftype();
      } else if (e === "EINTR") {
        return new Eintr();
      } else if (e === "EINVAL") {
        return new Einval();
      } else if (e === "EIO") {
        return new Eio();
      } else if (e === "EISDIR") {
        return new Eisdir();
      } else if (e === "ELOOP") {
        return new Eloop();
      } else if (e === "EMFILE") {
        return new Emfile();
      } else if (e === "EMLINK") {
        return new Emlink();
      } else if (e === "EMULTIHOP") {
        return new Emultihop();
      } else if (e === "ENAMETOOLONG") {
        return new Enametoolong();
      } else if (e === "ENFILE") {
        return new Enfile();
      } else if (e === "ENOBUFS") {
        return new Enobufs();
      } else if (e === "ENODEV") {
        return new Enodev();
      } else if (e === "ENOLCK") {
        return new Enolck();
      } else if (e === "ENOLINK") {
        return new Enolink();
      } else if (e === "ENOENT") {
        return new Enoent();
      } else if (e === "ENOMEM") {
        return new Enomem();
      } else if (e === "ENOSPC") {
        return new Enospc();
      } else if (e === "ENOSR") {
        return new Enosr();
      } else if (e === "ENOSTR") {
        return new Enostr();
      } else if (e === "ENOSYS") {
        return new Enosys();
      } else if (e === "ENOBLK") {
        return new Enotblk();
      } else if (e === "ENODIR") {
        return new Enotdir();
      } else if (e === "ENOTSUP") {
        return new Enotsup();
      } else if (e === "ENXIO") {
        return new Enxio();
      } else if (e === "EOPNOTSUPP") {
        return new Eopnotsupp();
      } else if (e === "EOVERFLOW") {
        return new Eoverflow();
      } else if (e === "EPERM") {
        return new Eperm();
      } else if (e === "EPIPE") {
        return new Epipe();
      } else if (e === "ERANGE") {
        return new Erange();
      } else if (e === "EROFS") {
        return new Erofs();
      } else if (e === "ESPIPE") {
        return new Espipe();
      } else if (e === "ESRCH") {
        return new Esrch();
      } else if (e === "ESTALE") {
        return new Estale();
      } else if (e === "ETXTBSY") {
        return new Etxtbsy();
      } else if (e === "EXDEV") {
        return new Exdev();
      } else if (e === "NOTUTF8") {
        return new NotUtf8();
      } else {
        return new Unknown();
      }
    },
  );
}

export function file_info(a) {
  let _pipe = do_file_info(a);
  return cast_error(_pipe);
}

export function read(filepath) {
  let _pipe = do_read(filepath);
  return cast_error(_pipe);
}

export function write(filepath, contents) {
  let _pipe = do_write(contents, filepath);
  return cast_error(_pipe);
}

export function delete$(path) {
  let _pipe = do_delete(path);
  return cast_error(_pipe);
}

export function delete_all(loop$paths) {
  while (true) {
    let paths = loop$paths;
    if (paths.hasLength(0)) {
      return new Ok(undefined);
    } else {
      let path = paths.head;
      let rest = paths.tail;
      let $ = delete$(path);
      if ($.isOk() && !$[0]) {
        loop$paths = rest;
      } else if (!$.isOk() && $[0] instanceof Enoent) {
        loop$paths = rest;
      } else {
        let e = $;
        return e;
      }
    }
  }
}

export function append(filepath, contents) {
  let _pipe = do_append(contents, filepath);
  return cast_error(_pipe);
}

export function read_bits(filepath) {
  let _pipe = do_read_bits(filepath);
  return cast_error(_pipe);
}

export function write_bits(filepath, bits) {
  let _pipe = do_write_bits(bits, filepath);
  return cast_error(_pipe);
}

export function append_bits(filepath, bits) {
  let _pipe = do_append_bits(bits, filepath);
  return cast_error(_pipe);
}

export function verify_is_directory(filepath) {
  let _pipe = do_verify_is_directory(filepath);
  return cast_error(_pipe);
}

export function create_directory(filepath) {
  let _pipe = do_make_directory(filepath);
  return cast_error(_pipe);
}

export function create_symlink(target, symlink) {
  let _pipe = do_make_symlink(target, symlink);
  return cast_error(_pipe);
}

export function read_directory(path) {
  let _pipe = do_read_directory(path);
  return cast_error(_pipe);
}

export function verify_is_file(filepath) {
  let _pipe = do_verify_is_file(filepath);
  return cast_error(_pipe);
}

export function verify_is_symlink(filepath) {
  let _pipe = do_verify_is_symlink(filepath);
  return cast_error(_pipe);
}

export function create_file(filepath) {
  let $ = (() => {
    let _pipe = filepath;
    return verify_is_file(_pipe);
  })();
  let $1 = (() => {
    let _pipe = filepath;
    return verify_is_directory(_pipe);
  })();
  if ($.isOk() && $[0]) {
    return new Error(new Eexist());
  } else if ($1.isOk() && $1[0]) {
    return new Error(new Eexist());
  } else {
    return write_bits(filepath, toBitArray([]));
  }
}

export function create_directory_all(dirpath) {
  let is_abs = $filepath.is_absolute(dirpath);
  let path = (() => {
    let _pipe = dirpath;
    let _pipe$1 = $filepath.split(_pipe);
    return $list.fold(_pipe$1, "", $filepath.join);
  })();
  let path$1 = (() => {
    if (is_abs) {
      return "/" + path;
    } else {
      return path;
    }
  })();
  let _pipe = do_create_dir_all(path$1 + "/");
  return cast_error(_pipe);
}

export function copy_file(src, dest) {
  let _pipe = do_copy_file(src, dest);
  let _pipe$1 = $result.replace(_pipe, undefined);
  return cast_error(_pipe$1);
}

export function rename_file(src, dest) {
  let _pipe = do_rename_file(src, dest);
  return cast_error(_pipe);
}

function do_copy_directory(src, dest) {
  return $result.try$(
    read_directory(src),
    (segments) => {
      let _pipe = segments;
      $list.each(
        _pipe,
        (segment) => {
          let src_path = $filepath.join(src, segment);
          let dest_path = $filepath.join(dest, segment);
          let $ = verify_is_file(src_path);
          let $1 = verify_is_directory(src_path);
          if ($.isOk() && $[0] && $1.isOk() && !$1[0]) {
            return $result.try$(
              read_bits(src_path),
              (content) => {
                let _pipe$1 = content;
                return write_bits(dest_path, _pipe$1);
              },
            );
          } else if ($.isOk() && !$[0] && $1.isOk() && $1[0]) {
            return $result.try$(
              create_directory(dest_path),
              (_) => { return do_copy_directory(src_path, dest_path); },
            );
          } else if (!$.isOk()) {
            let e = $[0];
            return new Error(e);
          } else if (!$1.isOk()) {
            let e = $1[0];
            return new Error(e);
          } else if ($.isOk() && !$[0] && $1.isOk() && !$1[0]) {
            return new Error(new Unknown());
          } else {
            return new Error(new Unknown());
          }
        },
      )
      return new Ok(undefined);
    },
  );
}

export function copy_directory(src, dest) {
  return $result.try$(
    create_directory_all(dest),
    (_) => { return do_copy_directory(src, dest); },
  );
}

export function rename_directory(src, dest) {
  return $result.try$(
    copy_directory(src, dest),
    (_) => { return delete$(src); },
  );
}

export function clear_directory(path) {
  return $result.try$(
    read_directory(path),
    (paths) => {
      let _pipe = paths;
      let _pipe$1 = $list.map(
        _pipe,
        (_capture) => { return $filepath.join(path, _capture); },
      );
      return delete_all(_pipe$1);
    },
  );
}

export function get_files(directory) {
  return $result.try$(
    read_directory(directory),
    (contents) => {
      let paths = (() => {
        let _pipe = contents;
        return $list.map(
          _pipe,
          (_capture) => { return $filepath.join(directory, _capture); },
        );
      })();
      let files = $list.filter(
        paths,
        (path) => { return isEqual(verify_is_file(path), new Ok(true)); },
      );
      let $ = $list.filter(
        paths,
        (path) => { return isEqual(verify_is_directory(path), new Ok(true)); },
      );
      if ($.hasLength(0)) {
        return new Ok(files);
      } else {
        let directories = $;
        return $result.try$(
          $list.try_map(directories, get_files),
          (nested_files) => {
            return new Ok($list.append(files, $list.flatten(nested_files)));
          },
        );
      }
    },
  );
}

export function set_permissions_octal(filepath, permissions) {
  let _pipe = do_set_permissions(filepath, permissions);
  return cast_error(_pipe);
}

export function set_permissions(filepath, permissions) {
  return set_permissions_octal(filepath, file_permissions_to_octal(permissions));
}

export function current_directory() {
  let _pipe = do_current_directory();
  return cast_error(_pipe);
}

export function is_file(filepath) {
  return do_is_file(filepath);
}
