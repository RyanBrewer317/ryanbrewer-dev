-module(lustre_dev_tools@cmd).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).
-define(FILEPATH, "src/lustre_dev_tools/cmd.gleam").
-export([exec/4, cwd/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-file("src/lustre_dev_tools/cmd.gleam", 10).
?DOC(false).
-spec exec(binary(), list({binary(), binary()}), list(binary()), binary()) -> {ok,
        binary()} |
    {error, {integer(), binary()}}.
exec(Command, Env, Args, In) ->
    lustre_dev_tools_ffi:exec(Command, Env, Args, In).

-file("src/lustre_dev_tools/cmd.gleam", 20).
?DOC(false).
-spec cwd() -> {ok, binary()} | {error, gleam@dynamic:dynamic_()}.
cwd() ->
    lustre_dev_tools_ffi:get_cwd().
