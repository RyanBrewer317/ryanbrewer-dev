import * as $charlist from "../gleam_erlang/gleam/erlang/charlist.mjs";
import * as $process from "../gleam_erlang/gleam/erlang/process.mjs";
import * as $actor from "../gleam_otp/gleam/otp/actor.mjs";
import * as $supervisor from "../gleam_otp/gleam/otp/static_supervisor.mjs";
import * as $supervision from "../gleam_otp/gleam/otp/supervision.mjs";
import * as $bytes_tree from "../gleam_stdlib/gleam/bytes_tree.mjs";
import * as $int from "../gleam_stdlib/gleam/int.mjs";
import * as $list from "../gleam_stdlib/gleam/list.mjs";
import * as $option from "../gleam_stdlib/gleam/option.mjs";
import { None, Some } from "../gleam_stdlib/gleam/option.mjs";
import * as $result from "../gleam_stdlib/gleam/result.mjs";
import * as $string from "../gleam_stdlib/gleam/string.mjs";
import { Ok, Error, toList, Empty as $Empty, CustomType as $CustomType } from "./gleam.mjs";
import * as $acceptor from "./glisten/internal/acceptor.mjs";
import { Pool } from "./glisten/internal/acceptor.mjs";
import * as $handler from "./glisten/internal/handler.mjs";
import * as $listener from "./glisten/internal/listener.mjs";
import * as $socket from "./glisten/socket.mjs";
import * as $options from "./glisten/socket/options.mjs";
import * as $transport from "./glisten/transport.mjs";

export class Packet extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class User extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class IpV4 extends $CustomType {
  constructor($0, $1, $2, $3) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
  }
}

export class IpV6 extends $CustomType {
  constructor($0, $1, $2, $3, $4, $5, $6, $7) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
    this[3] = $3;
    this[4] = $4;
    this[5] = $5;
    this[6] = $6;
    this[7] = $7;
  }
}

export class ConnectionInfo extends $CustomType {
  constructor(port, ip_address) {
    super();
    this.port = port;
    this.ip_address = ip_address;
  }
}

export class Connection extends $CustomType {
  constructor(socket, transport, subject) {
    super();
    this.socket = socket;
    this.transport = transport;
    this.subject = subject;
  }
}

class Continue extends $CustomType {
  constructor(state, selector) {
    super();
    this.state = state;
    this.selector = selector;
  }
}

class NormalStop extends $CustomType {}

class AbnormalStop extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Builder extends $CustomType {
  constructor(interface$, on_init, loop, on_close, pool_size, http2_support, ipv6_support, tls_options) {
    super();
    this.interface = interface$;
    this.on_init = on_init;
    this.loop = loop;
    this.on_close = on_close;
    this.pool_size = pool_size;
    this.http2_support = http2_support;
    this.ipv6_support = ipv6_support;
    this.tls_options = tls_options;
  }
}

export function convert_ip_address(ip) {
  if (ip instanceof $options.IpV4) {
    let a = ip[0];
    let b = ip[1];
    let c = ip[2];
    let d = ip[3];
    return new IpV4(a, b, c, d);
  } else {
    let a = ip[0];
    let b = ip[1];
    let c = ip[2];
    let d = ip[3];
    let e = ip[4];
    let f = ip[5];
    let g = ip[6];
    let h = ip[7];
    return new IpV6(a, b, c, d, e, f, g, h);
  }
}

function join_ipv6_fields(fields) {
  let _pipe = $list.map(fields, $int.to_base16);
  return $string.join(_pipe, ":");
}

function ipv6_zeros(
  loop$fields,
  loop$pos,
  loop$len,
  loop$max_start,
  loop$max_len
) {
  while (true) {
    let fields = loop$fields;
    let pos = loop$pos;
    let len = loop$len;
    let max_start = loop$max_start;
    let max_len = loop$max_len;
    if (fields instanceof $Empty) {
      if (max_len > 1) {
        return new Ok([max_start, max_start + max_len]);
      } else {
        return new Error(undefined);
      }
    } else {
      let x = fields.head;
      if (x === 0) {
        let xs = fields.tail;
        let len$1 = len + 1;
        let $ = len$1 > max_len;
        if ($) {
          loop$fields = xs;
          loop$pos = pos + 1;
          loop$len = len$1;
          loop$max_start = (pos + 1) - len$1;
          loop$max_len = len$1;
        } else {
          loop$fields = xs;
          loop$pos = pos + 1;
          loop$len = len$1;
          loop$max_start = max_start;
          loop$max_len = max_len;
        }
      } else {
        let xs = fields.tail;
        loop$fields = xs;
        loop$pos = pos + 1;
        loop$len = 0;
        loop$max_start = max_start;
        loop$max_len = max_len;
      }
    }
  }
}

export function ip_address_to_string(address) {
  if (address instanceof IpV4) {
    let a = address[0];
    let b = address[1];
    let c = address[2];
    let d = address[3];
    let _pipe = toList([a, b, c, d]);
    let _pipe$1 = $list.map(_pipe, $int.to_string);
    return $string.join(_pipe$1, ".");
  } else {
    let a = address[0];
    let b = address[1];
    let c = address[2];
    let d = address[3];
    let e = address[4];
    let f = address[5];
    let g = address[6];
    let h = address[7];
    let fields = toList([a, b, c, d, e, f, g, h]);
    let _block;
    let $ = ipv6_zeros(fields, 0, 0, 0, 0);
    if ($ instanceof Ok) {
      let start$1 = $[0][0];
      let end = $[0][1];
      _block = (join_ipv6_fields($list.take(fields, start$1)) + "::") + join_ipv6_fields(
        $list.drop(fields, end),
      );
    } else {
      _block = join_ipv6_fields(fields);
    }
    let _pipe = _block;
    return $string.lowercase(_pipe);
  }
}

export function continue$(state) {
  return new Continue(state, new None());
}

export function with_selector(next, selector) {
  if (next instanceof Continue) {
    let state = next.state;
    return new Continue(state, new Some(selector));
  } else {
    let stop$1 = next;
    return stop$1;
  }
}

export function stop() {
  return new NormalStop();
}

export function stop_abnormal(reason) {
  return new AbnormalStop(reason);
}

export function convert_next(next) {
  if (next instanceof Continue) {
    let state = next.state;
    let selector = next.selector;
    return new $handler.Continue(state, selector);
  } else if (next instanceof NormalStop) {
    return new $handler.NormalStop();
  } else {
    let reason = next[0];
    return new $handler.AbnormalStop(reason);
  }
}

function convert_on_init(on_init) {
  return (conn) => {
    let connection = new Connection(conn.socket, conn.transport, conn.sender);
    return on_init(connection);
  };
}

export function new$(on_init, loop) {
  return new Builder(
    new $options.Loopback(),
    on_init,
    loop,
    new None(),
    10,
    false,
    false,
    new None(),
  );
}

export function with_close(builder, on_close) {
  let _record = builder;
  return new Builder(
    _record.interface,
    _record.on_init,
    _record.loop,
    new Some(on_close),
    _record.pool_size,
    _record.http2_support,
    _record.ipv6_support,
    _record.tls_options,
  );
}

export function with_pool_size(builder, size) {
  let _record = builder;
  return new Builder(
    _record.interface,
    _record.on_init,
    _record.loop,
    _record.on_close,
    size,
    _record.http2_support,
    _record.ipv6_support,
    _record.tls_options,
  );
}

export function with_http2(builder) {
  let _record = builder;
  return new Builder(
    _record.interface,
    _record.on_init,
    _record.loop,
    _record.on_close,
    _record.pool_size,
    true,
    _record.ipv6_support,
    _record.tls_options,
  );
}

export function with_ipv6(builder) {
  let _record = builder;
  return new Builder(
    _record.interface,
    _record.on_init,
    _record.loop,
    _record.on_close,
    _record.pool_size,
    _record.http2_support,
    true,
    _record.tls_options,
  );
}

export function with_tls(builder, cert, key) {
  let _record = builder;
  return new Builder(
    _record.interface,
    _record.on_init,
    _record.loop,
    _record.on_close,
    _record.pool_size,
    _record.http2_support,
    _record.ipv6_support,
    new Some(new $options.CertKeyFiles(cert, key)),
  );
}
