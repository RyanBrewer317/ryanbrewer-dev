-module(lustre@ssg).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([new/1, add_static_dir/2, use_index_routes/1, add_static_route/3, add_static_xml/3, add_dynamic_route/4, add_static_asset/3, build/1]).
-export_type([config/3, no_static_routes/0, no_static_dir/0, has_static_routes/0, has_static_dir/0, use_direct_routes/0, use_index_routes/0, route/0, build_error/0]).

-opaque config(PHP, PHQ, PHR) :: {config,
        binary(),
        gleam@option:option(binary()),
        gleam@dict:dict(binary(), binary()),
        list(route()),
        boolean()} |
    {gleam_phantom, PHP, PHQ, PHR}.

-type no_static_routes() :: any().

-type no_static_dir() :: any().

-type has_static_routes() :: any().

-type has_static_dir() :: any().

-type use_direct_routes() :: any().

-type use_index_routes() :: any().

-type route() :: {static, binary(), lustre@internals@vdom:element(nil)} |
    {dynamic,
        binary(),
        gleam@dict:dict(binary(), lustre@internals@vdom:element(nil))} |
    {xml, binary(), lustre@internals@vdom:element(nil)}.

-type build_error() :: {cannot_create_temp_directory, simplifile:file_error()} |
    {cannot_write_static_asset, simplifile:file_error(), binary()} |
    {cannot_generate_route, simplifile:file_error(), binary()} |
    {cannot_write_to_output_dir, simplifile:file_error()} |
    {cannot_cleanup_temp_dir, simplifile:file_error()}.

-spec new(binary()) -> config(no_static_routes(), no_static_dir(), use_direct_routes()).
new(Out_dir) ->
    {config, Out_dir, none, gleam@dict:new(), [], false}.

-spec add_static_dir(config(PJM, no_static_dir(), PJN), binary()) -> config(PJM, has_static_dir(), PJN).
add_static_dir(Config, Path) ->
    {config, Out_dir, _, Static_assets, Routes, Use_index_routes} = Config,
    {config, Out_dir, {some, Path}, Static_assets, Routes, Use_index_routes}.

-spec use_index_routes(config(PKD, PKE, any())) -> config(PKD, PKE, use_index_routes()).
use_index_routes(Config) ->
    {config, Out_dir, Static_dir, Static_assets, Routes, _} = Config,
    {config, Out_dir, Static_dir, Static_assets, Routes, true}.

-spec routify(binary()) -> binary().
routify(Path) ->
    _assert_subject = gleam@regex:from_string(<<"\\s+"/utf8>>),
    {ok, Whitespace} = case _assert_subject of
        {ok, _} -> _assert_subject;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Assertion pattern match failed"/utf8>>,
                        value => _assert_fail,
                        module => <<"lustre/ssg"/utf8>>,
                        function => <<"routify"/utf8>>,
                        line => 455})
    end,
    _pipe = gleam@regex:split(Whitespace, Path),
    _pipe@1 = gleam@string:join(_pipe, <<"-"/utf8>>),
    gleam@string:lowercase(_pipe@1).

-spec add_static_route(
    config(any(), PID, PIE),
    binary(),
    lustre@internals@vdom:element(any())
) -> config(has_static_routes(), PID, PIE).
add_static_route(Config, Path, Page) ->
    {config, Out_dir, Static_dir, Static_assets, Routes, Use_index_routes} = Config,
    Route = {static, routify(Path), lustre@element:map(Page, fun(_) -> nil end)},
    {config,
        Out_dir,
        Static_dir,
        Static_assets,
        [Route | Routes],
        Use_index_routes}.

-spec add_static_xml(
    config(PIN, PIO, PIP),
    binary(),
    lustre@internals@vdom:element(any())
) -> config(PIN, PIO, PIP).
add_static_xml(Config, Path, Page) ->
    {config, Out_dir, Static_dir, Static_assets, Routes, Use_index_routes} = Config,
    Route = {xml, routify(Path), lustre@element:map(Page, fun(_) -> nil end)},
    {config,
        Out_dir,
        Static_dir,
        Static_assets,
        [Route | Routes],
        Use_index_routes}.

-spec add_dynamic_route(
    config(PIY, PIZ, PJA),
    binary(),
    gleam@dict:dict(binary(), PJE),
    fun((PJE) -> lustre@internals@vdom:element(any()))
) -> config(PIY, PIZ, PJA).
add_dynamic_route(Config, Path, Data, Page) ->
    Route = begin
        Path@1 = routify(Path),
        Pages = gleam@dict:map_values(
            Data,
            fun(_, Data@1) ->
                lustre@element:map(Page(Data@1), fun(_) -> nil end)
            end
        ),
        {dynamic, Path@1, Pages}
    end,
    erlang:setelement(5, Config, [Route | erlang:element(5, Config)]).

-spec add_static_asset(config(PJU, PJV, PJW), binary(), binary()) -> config(PJU, PJV, PJW).
add_static_asset(Config, Path, Content) ->
    Static_assets = gleam@dict:insert(
        erlang:element(4, Config),
        routify(Path),
        Content
    ),
    erlang:setelement(4, Config, Static_assets).

-spec trim_slash(binary()) -> binary().
trim_slash(Path) ->
    case gleam@string:ends_with(Path, <<"/"/utf8>>) of
        true ->
            gleam@string:drop_right(Path, 1);

        false ->
            Path
    end.

-spec last_segment(binary()) -> {binary(), binary()}.
last_segment(Path) ->
    _assert_subject = gleam@regex:from_string(<<"(.*/)+?(.+)"/utf8>>),
    {ok, Segments} = case _assert_subject of
        {ok, _} -> _assert_subject;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Assertion pattern match failed"/utf8>>,
                        value => _assert_fail,
                        module => <<"lustre/ssg"/utf8>>,
                        function => <<"last_segment"/utf8>>,
                        line => 470})
    end,
    _assert_subject@1 = gleam@regex:scan(Segments, Path),
    [{match, _, [{some, Leading}, {some, Last}]}] = case _assert_subject@1 of
        [{match, _, [{some, _}, {some, _}]}] -> _assert_subject@1;
        _assert_fail@1 ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Assertion pattern match failed"/utf8>>,
                        value => _assert_fail@1,
                        module => <<"lustre/ssg"/utf8>>,
                        function => <<"last_segment"/utf8>>,
                        line => 471})
    end,
    {Leading, Last}.

-spec build(config(has_static_routes(), any(), any())) -> {ok, nil} |
    {error, build_error()}.
build(Config) ->
    {config, Out_dir, Static_dir, Static_assets, Routes, Use_index_routes} = Config,
    Out_dir@1 = trim_slash(Out_dir),
    _ = simplifile:delete(<<"build/.lustre"/utf8>>),
    gleam@result:'try'(
        begin
            _pipe = case Static_dir of
                {some, Path} ->
                    simplifile:copy_directory(Path, <<"build/.lustre"/utf8>>);

                none ->
                    simplifile:create_directory_all(<<"build/.lustre"/utf8>>)
            end,
            gleam@result:map_error(
                _pipe,
                fun(Field@0) -> {cannot_create_temp_directory, Field@0} end
            )
        end,
        fun(_) ->
            gleam@result:'try'(
                (gleam@list:try_map(
                    maps:to_list(Static_assets),
                    fun(_use0) ->
                        {Path@1, Content} = _use0,
                        _pipe@1 = simplifile:write(
                            <<"build/.lustre"/utf8, Path@1/binary>>,
                            Content
                        ),
                        gleam@result:map_error(
                            _pipe@1,
                            fun(_capture) ->
                                {cannot_write_static_asset, _capture, Path@1}
                            end
                        )
                    end
                )),
                fun(_) ->
                    gleam@result:'try'(
                        begin
                            Routes@1 = gleam@list:sort(
                                Routes,
                                fun(A, B) ->
                                    gleam@string:compare(
                                        erlang:element(2, A),
                                        erlang:element(2, B)
                                    )
                                end
                            ),
                            gleam@list:try_map(
                                Routes@1,
                                fun(Route) -> case Route of
                                        {static, <<"/"/utf8>>, El} ->
                                            Path@2 = <<"build/.lustre"/utf8,
                                                "/index.html"/utf8>>,
                                            _pipe@2 = El,
                                            _pipe@3 = lustre@element:to_document_string(
                                                _pipe@2
                                            ),
                                            _pipe@4 = simplifile:write(
                                                Path@2,
                                                _pipe@3
                                            ),
                                            gleam@result:map_error(
                                                _pipe@4,
                                                fun(_capture@1) ->
                                                    {cannot_generate_route,
                                                        _capture@1,
                                                        Path@2}
                                                end
                                            );

                                        {static, Path@3, El@1} when Use_index_routes ->
                                            _ = simplifile:create_directory_all(
                                                <<"build/.lustre"/utf8,
                                                    Path@3/binary>>
                                            ),
                                            Path@4 = <<<<"build/.lustre"/utf8,
                                                    (trim_slash(Path@3))/binary>>/binary,
                                                "/index.html"/utf8>>,
                                            _pipe@5 = El@1,
                                            _pipe@6 = lustre@element:to_document_string(
                                                _pipe@5
                                            ),
                                            _pipe@7 = simplifile:write(
                                                Path@4,
                                                _pipe@6
                                            ),
                                            gleam@result:map_error(
                                                _pipe@7,
                                                fun(_capture@2) ->
                                                    {cannot_generate_route,
                                                        _capture@2,
                                                        Path@4}
                                                end
                                            );

                                        {static, Path@5, El@2} ->
                                            {Path@6, Name} = last_segment(
                                                Path@5
                                            ),
                                            _ = simplifile:create_directory_all(
                                                <<"build/.lustre"/utf8,
                                                    Path@6/binary>>
                                            ),
                                            Path@7 = <<<<<<<<"build/.lustre"/utf8,
                                                            (trim_slash(Path@6))/binary>>/binary,
                                                        "/"/utf8>>/binary,
                                                    Name/binary>>/binary,
                                                ".html"/utf8>>,
                                            _pipe@8 = El@2,
                                            _pipe@9 = lustre@element:to_document_string(
                                                _pipe@8
                                            ),
                                            _pipe@10 = simplifile:write(
                                                Path@7,
                                                _pipe@9
                                            ),
                                            gleam@result:map_error(
                                                _pipe@10,
                                                fun(_capture@3) ->
                                                    {cannot_generate_route,
                                                        _capture@3,
                                                        Path@7}
                                                end
                                            );

                                        {dynamic, Path@8, Pages} ->
                                            _ = simplifile:create_directory_all(
                                                <<"build/.lustre"/utf8,
                                                    Path@8/binary>>
                                            ),
                                            gleam@list:try_fold(
                                                maps:to_list(Pages),
                                                nil,
                                                fun(_, _use1) ->
                                                    {Page, El@3} = _use1,
                                                    Path@9 = <<<<<<<<"build/.lustre"/utf8,
                                                                    (trim_slash(
                                                                        Path@8
                                                                    ))/binary>>/binary,
                                                                "/"/utf8>>/binary,
                                                            (routify(Page))/binary>>/binary,
                                                        ".html"/utf8>>,
                                                    _pipe@11 = El@3,
                                                    _pipe@12 = lustre@element:to_document_string(
                                                        _pipe@11
                                                    ),
                                                    _pipe@13 = simplifile:write(
                                                        Path@9,
                                                        _pipe@12
                                                    ),
                                                    gleam@result:map_error(
                                                        _pipe@13,
                                                        fun(_capture@4) ->
                                                            {cannot_generate_route,
                                                                _capture@4,
                                                                Path@9}
                                                        end
                                                    )
                                                end
                                            );

                                        {xml, Path@10, El@4} ->
                                            {Path@11, Name@1} = last_segment(
                                                Path@10
                                            ),
                                            _ = simplifile:create_directory_all(
                                                <<"build/.lustre"/utf8,
                                                    Path@11/binary>>
                                            ),
                                            Path@12 = <<<<<<<<"build/.lustre"/utf8,
                                                            (trim_slash(Path@11))/binary>>/binary,
                                                        "/"/utf8>>/binary,
                                                    Name@1/binary>>/binary,
                                                ".xml"/utf8>>,
                                            _pipe@14 = El@4,
                                            _pipe@15 = lustre@element:to_string(
                                                _pipe@14
                                            ),
                                            _pipe@16 = gleam@string:append(
                                                <<"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"/utf8>>,
                                                _pipe@15
                                            ),
                                            _pipe@17 = simplifile:write(
                                                Path@12,
                                                _pipe@16
                                            ),
                                            gleam@result:map_error(
                                                _pipe@17,
                                                fun(_capture@5) ->
                                                    {cannot_generate_route,
                                                        _capture@5,
                                                        Path@12}
                                                end
                                            )
                                    end end
                            )
                        end,
                        fun(_) ->
                            gleam@result:'try'(
                                case begin
                                    _pipe@18 = simplifile:verify_is_directory(
                                        Out_dir@1
                                    ),
                                    gleam@result:unwrap(_pipe@18, false)
                                end of
                                    true ->
                                        _pipe@19 = simplifile:delete(Out_dir@1),
                                        gleam@result:map_error(
                                            _pipe@19,
                                            fun(Field@0) -> {cannot_write_to_output_dir, Field@0} end
                                        );

                                    false ->
                                        {ok, nil}
                                end,
                                fun(_) ->
                                    gleam@result:'try'(
                                        begin
                                            _pipe@20 = simplifile:copy_directory(
                                                <<"build/.lustre"/utf8>>,
                                                Out_dir@1
                                            ),
                                            gleam@result:map_error(
                                                _pipe@20,
                                                fun(Field@0) -> {cannot_write_to_output_dir, Field@0} end
                                            )
                                        end,
                                        fun(_) ->
                                            gleam@result:'try'(
                                                begin
                                                    _pipe@21 = simplifile:delete(
                                                        <<"build/.lustre"/utf8>>
                                                    ),
                                                    gleam@result:map_error(
                                                        _pipe@21,
                                                        fun(Field@0) -> {cannot_cleanup_temp_dir, Field@0} end
                                                    )
                                                end,
                                                fun(_) -> {ok, nil} end
                                            )
                                        end
                                    )
                                end
                            )
                        end
                    )
                end
            )
        end
    ).