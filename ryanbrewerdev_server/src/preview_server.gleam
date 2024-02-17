import wisp.{type Request, type Response}
import mist
import gleam/erlang/process
import gleam/io
import simplifile

pub fn path() -> String {
  let assert Ok(path) = simplifile.current_directory()
  path <> "/.."
}

pub fn main() {
  let secret_key_base = wisp.random_string(64)
  let res =
    wisp.mist_handler(handle_request, secret_key_base)
    |> mist.new
    |> mist.port(8085)
    |> mist.start_http
  io.debug(res)
  let assert Ok(_) = res
  process.sleep_forever()
}

pub fn handle_request(request: Request) -> Response {
  case wisp.path_segments(request) {
    ["search"] -> {
      wisp.ok()
      |> wisp.set_body(wisp.File(path() <> "/dist/search.html"))
    }
    [] -> {
      wisp.ok()
      |> wisp.set_body(wisp.File(path() <> "/dist/index.html"))
    }
    _ -> {
      use <- wisp.serve_static(request, under: "/", from: path() <> "/dist")
      wisp.ok()
    }
  }
}
