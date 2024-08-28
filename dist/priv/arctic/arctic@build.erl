-module(arctic@build).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([build/1]).

-spec read_collection(arctic:collection()) -> {ok, list(arctic:page())} |
    {error, snag:snag()}.
read_collection(Collection) ->
    gleam@result:'try'(
        begin
            _pipe = simplifile:get_files(erlang:element(2, Collection)),
            gleam@result:map_error(
                _pipe,
                fun(Err) ->
                    snag:new(
                        <<<<<<<<"couldn't get files in `"/utf8,
                                        (erlang:element(2, Collection))/binary>>/binary,
                                    "` ("/utf8>>/binary,
                                (simplifile:describe_error(Err))/binary>>/binary,
                            ")"/utf8>>
                    )
                end
            )
        end,
        fun(Paths) ->
            _pipe@1 = gleam@list:try_fold(
                Paths,
                [],
                fun(So_far, Path) ->
                    gleam@result:'try'(
                        gleam@result:map_error(
                            simplifile:read(Path),
                            fun(Err@1) ->
                                snag:new(
                                    <<<<<<<<"could not load file `"/utf8,
                                                    Path/binary>>/binary,
                                                "` ("/utf8>>/binary,
                                            (simplifile:describe_error(Err@1))/binary>>/binary,
                                        ")"/utf8>>
                                )
                            end
                        ),
                        fun(Content) ->
                            gleam@result:'try'(
                                (erlang:element(3, Collection))(Path, Content),
                                fun(P) -> {ok, [P | So_far]} end
                            )
                        end
                    )
                end
            ),
            gleam@result:map(_pipe@1, fun lists:reverse/1)
        end
    ).

-spec process(list(arctic:collection())) -> {ok,
        list(arctic:processed_collection())} |
    {error, snag:snag()}.
process(Collections) ->
    gleam@list:try_fold(
        Collections,
        [],
        fun(Rest, Collection) ->
            gleam@result:'try'(
                read_collection(Collection),
                fun(Pages_unsorted) ->
                    Pages = gleam@list:sort(
                        Pages_unsorted,
                        erlang:element(6, Collection)
                    ),
                    {ok, [{processed_collection, Collection, Pages} | Rest]}
                end
            )
        end
    ).

-spec make_ssg_config(
    list(arctic:processed_collection()),
    arctic:config(),
    fun((lustre@ssg:config(lustre@ssg:has_static_routes(), lustre@ssg:no_static_dir(), lustre@ssg:use_index_routes())) -> {ok,
            nil} |
        {error, snag:snag()})
) -> {ok, nil} | {error, snag:snag()}.
make_ssg_config(Processed_collections, Config, K) ->
    gleam@result:'try'(
        begin
            _pipe = lustre@ssg:new(<<"arctic_build"/utf8>>),
            _pipe@1 = lustre@ssg:use_index_routes(_pipe),
            _pipe@2 = lustre@ssg:add_static_route(
                _pipe@1,
                <<"/"/utf8>>,
                (erlang:element(2, Config))(Processed_collections)
            ),
            _pipe@3 = gleam@list:fold(
                erlang:element(3, Config),
                _pipe@2,
                fun(Ssg_config, Page) ->
                    lustre@ssg:add_static_route(
                        Ssg_config,
                        <<"/"/utf8, (erlang:element(2, Page))/binary>>,
                        erlang:element(3, Page)
                    )
                end
            ),
            gleam@list:try_fold(
                Processed_collections,
                _pipe@3,
                fun(Ssg_config@1, Processed) ->
                    Ssg_config2 = case erlang:element(
                        4,
                        erlang:element(2, Processed)
                    ) of
                        {some, Render} ->
                            lustre@ssg:add_static_route(
                                Ssg_config@1,
                                <<"/"/utf8,
                                    (erlang:element(
                                        2,
                                        erlang:element(2, Processed)
                                    ))/binary>>,
                                Render(erlang:element(3, Processed))
                            );

                        none ->
                            Ssg_config@1
                    end,
                    Ssg_config3 = gleam@list:fold(
                        erlang:element(8, erlang:element(2, Processed)),
                        Ssg_config2,
                        fun(S, Rp) ->
                            lustre@ssg:add_static_route(
                                S,
                                <<<<<<"/"/utf8,
                                            (erlang:element(
                                                2,
                                                erlang:element(2, Processed)
                                            ))/binary>>/binary,
                                        "/"/utf8>>/binary,
                                    (erlang:element(2, Rp))/binary>>,
                                erlang:element(3, Rp)
                            )
                        end
                    ),
                    _pipe@4 = gleam@list:fold(
                        erlang:element(3, Processed),
                        Ssg_config3,
                        fun(S@1, P) ->
                            lustre@ssg:add_static_route(
                                S@1,
                                <<<<<<"/"/utf8,
                                            (erlang:element(
                                                2,
                                                erlang:element(2, Processed)
                                            ))/binary>>/binary,
                                        "/"/utf8>>/binary,
                                    (erlang:element(2, P))/binary>>,
                                (erlang:element(7, erlang:element(2, Processed)))(
                                    P
                                )
                            )
                        end
                    ),
                    {ok, _pipe@4}
                end
            )
        end,
        fun(Ssg_config@2) -> K(Ssg_config@2) end
    ).

-spec ssg_build(
    lustre@ssg:config(lustre@ssg:has_static_routes(), any(), any()),
    fun(() -> {ok, nil} | {error, snag:snag()})
) -> {ok, nil} | {error, snag:snag()}.
ssg_build(Ssg_config, K) ->
    gleam@result:'try'(
        begin
            _pipe = lustre@ssg:build(Ssg_config),
            gleam@result:map_error(_pipe, fun(Err) -> case Err of
                        {cannot_create_temp_directory, File_err} ->
                            snag:new(
                                <<<<"couldn't create temp directory ("/utf8,
                                        (simplifile:describe_error(File_err))/binary>>/binary,
                                    ")"/utf8>>
                            );

                        {cannot_write_static_asset, File_err@1, Path} ->
                            snag:new(
                                <<<<<<<<"couldn't put asset at `"/utf8,
                                                Path/binary>>/binary,
                                            "` ("/utf8>>/binary,
                                        (simplifile:describe_error(File_err@1))/binary>>/binary,
                                    ")"/utf8>>
                            );

                        {cannot_generate_route, File_err@2, Path@1} ->
                            snag:new(
                                <<<<<<<<"couldn't generate `"/utf8,
                                                Path@1/binary>>/binary,
                                            "` ("/utf8>>/binary,
                                        (simplifile:describe_error(File_err@2))/binary>>/binary,
                                    ")"/utf8>>
                            );

                        {cannot_write_to_output_dir, File_err@3} ->
                            snag:new(
                                <<<<"couldn't move from temp directory to output directory ("/utf8,
                                        (simplifile:describe_error(File_err@3))/binary>>/binary,
                                    ")"/utf8>>
                            );

                        {cannot_cleanup_temp_dir, File_err@4} ->
                            snag:new(
                                <<<<"couldn't remove temp directory ("/utf8,
                                        (simplifile:describe_error(File_err@4))/binary>>/binary,
                                    ")"/utf8>>
                            )
                    end end)
        end,
        fun(_) -> K() end
    ).

-spec add_public(fun(() -> {ok, nil} | {error, snag:snag()})) -> {ok, nil} |
    {error, snag:snag()}.
add_public(K) ->
    gleam@result:'try'(
        begin
            _pipe = simplifile:create_directory(<<"arctic_build/public"/utf8>>),
            gleam@result:map_error(
                _pipe,
                fun(Err) ->
                    snag:new(
                        <<<<"couldn't create directory `arctic_build/public` ("/utf8,
                                (simplifile:describe_error(Err))/binary>>/binary,
                            ")"/utf8>>
                    )
                end
            )
        end,
        fun(_) ->
            gleam@result:'try'(
                begin
                    _pipe@1 = simplifile:copy_directory(
                        <<"public"/utf8>>,
                        <<"arctic_build/public"/utf8>>
                    ),
                    gleam@result:map_error(
                        _pipe@1,
                        fun(Err@1) ->
                            snag:new(
                                <<<<"couldn't copy `public` to `arctic_build/public` ("/utf8,
                                        (simplifile:describe_error(Err@1))/binary>>/binary,
                                    ")"/utf8>>
                            )
                        end
                    )
                end,
                fun(_) -> K() end
            )
        end
    ).

-spec option_to_result_nil(
    gleam@option:option(TAU),
    fun((TAU) -> {ok, nil} | {error, snag:snag()})
) -> {ok, nil} | {error, snag:snag()}.
option_to_result_nil(Opt, F) ->
    case Opt of
        {some, A} ->
            F(A);

        none ->
            {ok, nil}
    end.

-spec add_feed(
    list(arctic:processed_collection()),
    fun(() -> {ok, nil} | {error, snag:snag()})
) -> {ok, nil} | {error, snag:snag()}.
add_feed(Processed_collections, K) ->
    gleam@result:'try'(
        begin
            _pipe = simplifile:create_file(
                <<"arctic_build/public/feed.rss"/utf8>>
            ),
            gleam@result:map_error(
                _pipe,
                fun(Err) ->
                    snag:new(
                        <<<<"couldn't create file `arctic_build/public/feed.rss` ("/utf8,
                                (simplifile:describe_error(Err))/binary>>/binary,
                            ")"/utf8>>
                    )
                end
            )
        end,
        fun(_) ->
            gleam@result:'try'(
                (gleam@list:try_each(
                    Processed_collections,
                    fun(Processed) ->
                        option_to_result_nil(
                            erlang:element(5, erlang:element(2, Processed)),
                            fun(Feed) ->
                                _pipe@1 = simplifile:write(
                                    <<"arctic_build/public/"/utf8,
                                        (erlang:element(1, Feed))/binary>>,
                                    (erlang:element(2, Feed))(
                                        erlang:element(3, Processed)
                                    )
                                ),
                                gleam@result:map_error(
                                    _pipe@1,
                                    fun(Err@1) ->
                                        snag:new(
                                            <<<<"couldn't write to `arctic_build/public/feed.rss` ("/utf8,
                                                    (simplifile:describe_error(
                                                        Err@1
                                                    ))/binary>>/binary,
                                                ")"/utf8>>
                                        )
                                    end
                                )
                            end
                        )
                    end
                )),
                fun(_) -> K() end
            )
        end
    ).

-spec add_vite_config(
    arctic:config(),
    list(arctic:processed_collection()),
    fun(() -> {ok, nil} | {error, snag:snag()})
) -> {ok, nil} | {error, snag:snag()}.
add_vite_config(Config, Processed_collections, K) ->
    Home_page = <<"\"main\": \"arctic_build/index.html\""/utf8>>,
    Main_pages = gleam@list:fold(
        erlang:element(3, Config),
        <<""/utf8>>,
        fun(Js, Page) ->
            <<<<<<<<<<Js/binary, "\""/utf8>>/binary,
                            (erlang:element(2, Page))/binary>>/binary,
                        "\": \"arctic_build/"/utf8>>/binary,
                    (erlang:element(2, Page))/binary>>/binary,
                "/index.html\", "/utf8>>
        end
    ),
    Collected_pages = gleam@list:fold(
        Processed_collections,
        <<""/utf8>>,
        fun(Js@1, Processed) ->
            gleam@list:fold(
                erlang:element(3, Processed),
                Js@1,
                fun(Js@2, Page@1) ->
                    <<<<<<<<<<<<<<<<<<Js@2/binary, "\""/utf8>>/binary,
                                                    (erlang:element(
                                                        2,
                                                        erlang:element(
                                                            2,
                                                            Processed
                                                        )
                                                    ))/binary>>/binary,
                                                "/"/utf8>>/binary,
                                            (erlang:element(2, Page@1))/binary>>/binary,
                                        "\": \"arctic_build/"/utf8>>/binary,
                                    (erlang:element(
                                        2,
                                        erlang:element(2, Processed)
                                    ))/binary>>/binary,
                                "/"/utf8>>/binary,
                            (erlang:element(2, Page@1))/binary>>/binary,
                        "/index.html\", "/utf8>>
                end
            )
        end
    ),
    gleam@result:'try'(
        begin
            _pipe = simplifile:write(
                <<"arctic_vite_config.js"/utf8>>,
                <<<<<<<<"
  // NOTE: AUTO-GENERATED! DO NOT EDIT!
  export default {"/utf8,
                                Main_pages/binary>>/binary,
                            Collected_pages/binary>>/binary,
                        Home_page/binary>>/binary,
                    "};"/utf8>>
            ),
            gleam@result:map_error(
                _pipe,
                fun(Err) ->
                    snag:new(
                        <<<<"couldn't create `arctic_vite_config.js` ("/utf8,
                                (simplifile:describe_error(Err))/binary>>/binary,
                            ")"/utf8>>
                    )
                end
            )
        end,
        fun(_) -> K() end
    ).

-spec build(arctic:config()) -> {ok, nil} | {error, snag:snag()}.
build(Config) ->
    gleam@result:'try'(
        process(erlang:element(4, Config)),
        fun(Processed_collections) ->
            make_ssg_config(
                Processed_collections,
                Config,
                fun(Ssg_config) ->
                    ssg_build(
                        Ssg_config,
                        fun() ->
                            add_public(
                                fun() ->
                                    add_feed(
                                        Processed_collections,
                                        fun() ->
                                            add_vite_config(
                                                Config,
                                                Processed_collections,
                                                fun() -> {ok, nil} end
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
