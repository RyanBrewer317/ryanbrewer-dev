-module(lustre_dev_tools@server).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).
-define(FILEPATH, "src/lustre_dev_tools/server.gleam").
-export([start/3]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-file("src/lustre_dev_tools/server.gleam", 80).
?DOC(false).
-spec inject_live_reload(
    gleam@http@request:request(wisp@internal:connection()),
    binary(),
    fun(() -> gleam@http@response:response(wisp:body()))
) -> gleam@http@response:response(wisp:body()).
inject_live_reload(Req, Root, K) ->
    Is_interesting@1 = case gleam@regexp:from_string(<<".*\\.html$"/utf8>>) of
        {ok, Is_interesting} -> Is_interesting;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"lustre_dev_tools/server"/utf8>>,
                        function => <<"inject_live_reload"/utf8>>,
                        line => 85,
                        value => _assert_fail,
                        start => 2609,
                        'end' => 2673,
                        pattern_start => 2620,
                        pattern_end => 2638})
    end,
    gleam@bool:lazy_guard(
        not gleam@regexp:check(Is_interesting@1, erlang:element(8, Req)),
        K,
        fun() ->
            Path = filepath:join(Root, erlang:element(8, Req)),
            case simplifile_erl:is_file(Path) of
                {ok, false} ->
                    K();

                {error, _} ->
                    K();

                {ok, true} ->
                    Html@1 = case simplifile:read(Path) of
                        {ok, Html} -> Html;
                        _assert_fail@1 ->
                            erlang:error(#{gleam_error => let_assert,
                                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                        file => <<?FILEPATH/utf8>>,
                                        module => <<"lustre_dev_tools/server"/utf8>>,
                                        function => <<"inject_live_reload"/utf8>>,
                                        line => 92,
                                        value => _assert_fail@1,
                                        start => 2877,
                                        'end' => 2920,
                                        pattern_start => 2888,
                                        pattern_end => 2896})
                    end,
                    _pipe = Html@1,
                    _pipe@1 = lustre_dev_tools@server@live_reload:inject(_pipe),
                    _pipe@2 = gleam_stdlib:identity(_pipe@1),
                    wisp:html_response(_pipe@2, 200)
            end
        end
    ).

-file("src/lustre_dev_tools/server.gleam", 73).
?DOC(false).
-spec handler(gleam@http@request:request(wisp@internal:connection()), binary()) -> gleam@http@response:response(wisp:body()).
handler(Req, Root) ->
    inject_live_reload(
        Req,
        Root,
        fun() ->
            wisp:serve_static(
                Req,
                <<"/"/utf8>>,
                Root,
                fun() ->
                    handler(
                        begin
                            _record = Req,
                            {request,
                                erlang:element(2, _record),
                                erlang:element(3, _record),
                                erlang:element(4, _record),
                                erlang:element(5, _record),
                                erlang:element(6, _record),
                                erlang:element(7, _record),
                                <<"/index.html"/utf8>>,
                                erlang:element(9, _record)}
                        end,
                        Root
                    )
                end
            )
        end
    ).

-file("src/lustre_dev_tools/server.gleam", 24).
?DOC(false).
-spec start(binary(), integer(), binary()) -> lustre_dev_tools@cli:cli(nil).
start(Entry, Port, Bind) ->
    Cwd@1 = case lustre_dev_tools_ffi:get_cwd() of
        {ok, Cwd} -> Cwd;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"lustre_dev_tools/server"/utf8>>,
                        function => <<"start"/utf8>>,
                        line => 25,
                        value => _assert_fail,
                        start => 726,
                        'end' => 756,
                        pattern_start => 737,
                        pattern_end => 744})
    end,
    Root@1 = case filepath:expand(
        filepath:join(Cwd@1, lustre_dev_tools@project:root())
    ) of
        {ok, Root} -> Root;
        _assert_fail@1 ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"lustre_dev_tools/server"/utf8>>,
                        function => <<"start"/utf8>>,
                        line => 26,
                        value => _assert_fail@1,
                        start => 759,
                        'end' => 832,
                        pattern_start => 770,
                        pattern_end => 778})
    end,
    lustre_dev_tools@cli:do(
        lustre_dev_tools@server@proxy:get(),
        fun(Proxy) ->
            case Proxy of
                {some, _} ->
                    gleam_stdlib:println(
                        <<"
[WARNING] Support for proxying requests to another server is currently still
**experimental**. It's functionality or api may change is breaking ways even
between minor versions. If you run into any problems please open an issue over
at https://github.com/lustre-labs/dev-tools/issues/new
      "/utf8>>
                    );

                none ->
                    nil
            end,
            lustre_dev_tools@cli:do(
                lustre_dev_tools@cli:get_flags(),
                fun(Flags) ->
                    lustre_dev_tools@cli:'try'(
                        lustre_dev_tools@server@live_reload:start(
                            Entry,
                            Root@1,
                            Flags
                        ),
                        fun(Make_socket) ->
                            lustre_dev_tools@cli:'try'(
                                begin
                                    _pipe@1 = fun(Req) ->
                                        lustre_dev_tools@server@proxy:middleware(
                                            Req,
                                            Proxy,
                                            fun() ->
                                                case gleam@http@request:path_segments(
                                                    Req
                                                ) of
                                                    [<<"lustre-dev-tools"/utf8>>] ->
                                                        Make_socket(Req);

                                                    [] ->
                                                        _pipe = begin
                                                            _record = Req,
                                                            {request,
                                                                erlang:element(
                                                                    2,
                                                                    _record
                                                                ),
                                                                erlang:element(
                                                                    3,
                                                                    _record
                                                                ),
                                                                erlang:element(
                                                                    4,
                                                                    _record
                                                                ),
                                                                erlang:element(
                                                                    5,
                                                                    _record
                                                                ),
                                                                erlang:element(
                                                                    6,
                                                                    _record
                                                                ),
                                                                erlang:element(
                                                                    7,
                                                                    _record
                                                                ),
                                                                <<"/index.html"/utf8>>,
                                                                erlang:element(
                                                                    9,
                                                                    _record
                                                                )}
                                                        end,
                                                        (wisp@wisp_mist:handler(
                                                            fun(_capture) ->
                                                                handler(
                                                                    _capture,
                                                                    Root@1
                                                                )
                                                            end,
                                                            <<""/utf8>>
                                                        ))(_pipe);

                                                    _ ->
                                                        (wisp@wisp_mist:handler(
                                                            fun(_capture@1) ->
                                                                handler(
                                                                    _capture@1,
                                                                    Root@1
                                                                )
                                                            end,
                                                            <<""/utf8>>
                                                        ))(Req)
                                                end
                                            end
                                        )
                                    end,
                                    _pipe@2 = mist:new(_pipe@1),
                                    _pipe@3 = mist:port(_pipe@2, Port),
                                    _pipe@4 = mist:bind(_pipe@3, Bind),
                                    _pipe@5 = mist:start(_pipe@4),
                                    gleam@result:map_error(
                                        _pipe@5,
                                        fun(_capture@2) ->
                                            {cannot_start_dev_server,
                                                _capture@2,
                                                Port}
                                        end
                                    )
                                end,
                                fun(_) ->
                                    lustre_dev_tools@cli:return(
                                        gleam_erlang_ffi:sleep_forever()
                                    )
                                end
                            )
                        end
                    )
                end
            )
        end
    ).
