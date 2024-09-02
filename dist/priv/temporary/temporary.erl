-module(temporary).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([file/0, directory/0, in_directory/2, with_prefix/2, with_suffix/2, create/2]).
-export_type([temp_file/0, kind/0]).

-opaque temp_file() :: {temp_file,
        kind(),
        gleam@option:option(binary()),
        gleam@option:option(binary()),
        gleam@option:option(binary())}.

-type kind() :: file | directory.

-spec file() -> temp_file().
file() ->
    {temp_file, file, none, none, none}.

-spec directory() -> temp_file().
directory() ->
    {temp_file, directory, none, none, none}.

-spec in_directory(temp_file(), binary()) -> temp_file().
in_directory(Temp_file, Directory) ->
    erlang:setelement(3, Temp_file, {some, Directory}).

-spec with_prefix(temp_file(), binary()) -> temp_file().
with_prefix(Temp_file, Name_prefix) ->
    erlang:setelement(4, Temp_file, {some, Name_prefix}).

-spec with_suffix(temp_file(), binary()) -> temp_file().
with_suffix(Temp_file, Name_suffix) ->
    erlang:setelement(5, Temp_file, {some, Name_suffix}).

-spec get_random_name() -> binary().
get_random_name() ->
    _pipe = crypto:strong_rand_bytes(16),
    binary:encode_hex(_pipe).

-spec get_temp_directory() -> binary().
get_temp_directory() ->
    Temp = (gleam@result:lazy_or(
        envoy_ffi:get(<<"TMPDIR"/utf8>>),
        fun() ->
            gleam@result:lazy_or(
                envoy_ffi:get(<<"TEMP"/utf8>>),
                fun() -> envoy_ffi:get(<<"TMP"/utf8>>) end
            )
        end
    )),
    case Temp of
        {ok, Temp@1} ->
            Temp@1;

        {error, _} ->
            case temporary_ffi:is_windows() of
                true ->
                    <<"C:\\TMP"/utf8>>;

                false ->
                    <<"/tmp"/utf8>>
            end
    end.

-spec create(temp_file(), fun((binary()) -> GKF)) -> {ok, GKF} |
    {error, simplifile:file_error()}.
create(Temp_file, Fun) ->
    {temp_file, Kind, Temp_directory, Name_prefix, Name_suffix} = Temp_file,
    Temp = gleam@option:unwrap(Temp_directory, get_temp_directory()),
    Name = <<<<(gleam@option:unwrap(Name_prefix, <<""/utf8>>))/binary,
            (get_random_name())/binary>>/binary,
        (gleam@option:unwrap(Name_suffix, <<""/utf8>>))/binary>>,
    Path = filepath:join(Temp, Name),
    Result = case Kind of
        file ->
            simplifile:create_file(Path);

        directory ->
            simplifile:create_directory(Path)
    end,
    case Result of
        {error, Error} ->
            {error, Error};

        {ok, _} ->
            exception_ffi:defer(
                fun() -> simplifile:delete(Path) end,
                fun() -> {ok, Fun(Path)} end
            )
    end.
