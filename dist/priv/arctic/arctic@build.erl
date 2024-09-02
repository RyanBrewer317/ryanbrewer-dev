-module(arctic@build).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([build/1]).

-spec lift_ordering(fun((arctic:page(), arctic:page()) -> gleam@order:order())) -> fun((arctic:cacheable_page(), arctic:cacheable_page()) -> gleam@order:order()).
lift_ordering(Ordering) ->
    fun(A, B) -> Ordering(arctic:to_dummy_page(A), arctic:to_dummy_page(B)) end.

-spec get_id(arctic:cacheable_page()) -> binary().
get_id(P) ->
    case P of
        {cached_page, _, Metadata} ->
            _assert_subject = gleam@dict:get(Metadata, <<"id"/utf8>>),
            {ok, Id} = case _assert_subject of
                {ok, _} -> _assert_subject;
                _assert_fail ->
                    erlang:error(#{gleam_error => let_assert,
                                message => <<"Assertion pattern match failed"/utf8>>,
                                value => _assert_fail,
                                module => <<"arctic/build"/utf8>>,
                                function => <<"get_id"/utf8>>,
                                line => 34})
            end,
            Id;

        {new_page, Page} ->
            erlang:element(2, Page)
    end.

-spec to_metadata(list(binary())) -> {ok, gleam@dict:dict(binary(), binary())} |
    {error, snag:snag()}.
to_metadata(Csv) ->
    case Csv of
        [] ->
            {ok, gleam@dict:new()};

        [Pair_str | Rest] ->
            case gleam@string:split(Pair_str, <<":"/utf8>>) of
                [] ->
                    snag:error(
                        <<"malformed cache (metadata item with no colon)"/utf8>>
                    );

                [Key | Vals] ->
                    gleam@result:'try'(
                        to_metadata(Rest),
                        fun(Rest2) ->
                            {ok,
                                gleam@dict:insert(
                                    Rest2,
                                    Key,
                                    gleam@string:join(Vals, <<":"/utf8>>)
                                )}
                        end
                    )
            end
    end.

-spec to_cache(list(list(binary()))) -> {ok,
        gleam@dict:dict(binary(), {bitstring(),
            gleam@dict:dict(binary(), binary())})} |
    {error, snag:snag()}.
to_cache(Csv) ->
    case Csv of
        [] ->
            {ok, gleam@dict:new()};

        [[Id, Hash | Metadata] | Rest] ->
            gleam@result:'try'(
                to_cache(Rest),
                fun(Rest2) ->
                    gleam@result:'try'(
                        to_metadata(Metadata),
                        fun(Metadata2) ->
                            gleam@result:'try'(
                                begin
                                    _pipe = gleam@bit_array:base64_decode(Hash),
                                    gleam@result:map_error(
                                        _pipe,
                                        fun(_) ->
                                            snag:new(
                                                <<<<"malformed cache (`"/utf8,
                                                        Hash/binary>>/binary,
                                                    "` is not a valid base-64 hash)"/utf8>>
                                            )
                                        end
                                    )
                                end,
                                fun(Hash_str) ->
                                    {ok,
                                        gleam@dict:insert(
                                            Rest2,
                                            Id,
                                            {Hash_str, Metadata2}
                                        )}
                                end
                            )
                        end
                    )
                end
            );

        [Malformed_row | _] ->
            snag:error(
                <<<<"malformed cache (row `"/utf8,
                        (gleam@string:join(Malformed_row, <<", "/utf8>>))/binary>>/binary,
                    "`)"/utf8>>
            )
    end.

-spec parse_csv(binary()) -> {ok, list(list(binary()))} | {error, snag:snag()}.
parse_csv(Csv) ->
    Res = party:go(
        begin
            _pipe = (party:do(
                party:char(<<"\""/utf8>>),
                fun(_) ->
                    party:do(
                        party:many_concat(
                            party:either(
                                party:map(
                                    party:string(<<"\"\""/utf8>>),
                                    fun(_) -> <<"\""/utf8>> end
                                ),
                                party:satisfy(fun(C) -> C /= <<"\""/utf8>> end)
                            )
                        ),
                        fun(Val) ->
                            party:do(
                                party:char(<<"\""/utf8>>),
                                fun(_) -> party:return(Val) end
                            )
                        end
                    )
                end
            )),
            _pipe@1 = party:sep(_pipe, party:char(<<","/utf8>>)),
            _pipe@2 = (fun(P) ->
                party:do(
                    P,
                    fun(Row) ->
                        party:seq(party:char(<<"\n"/utf8>>), party:return(Row))
                    end
                )
            end)(_pipe@1),
            party:many(_pipe@2)
        end,
        Csv
    ),
    gleam@result:map_error(Res, fun(E) -> case E of
                {unexpected, P@1, S} ->
                    snag:new(
                        <<<<<<<<S/binary, " at "/utf8>>/binary,
                                    (gleam@int:to_string(erlang:element(2, P@1)))/binary>>/binary,
                                ":"/utf8>>/binary,
                            (gleam@int:to_string(erlang:element(3, P@1)))/binary>>
                    );

                {user_error, P@2, nil} ->
                    snag:new(
                        <<<<<<"internal Arctic error at "/utf8,
                                    (gleam@int:to_string(erlang:element(2, P@2)))/binary>>/binary,
                                ":"/utf8>>/binary,
                            (gleam@int:to_string(erlang:element(3, P@2)))/binary>>
                    )
            end end).

-spec read_collection(
    arctic:collection(),
    gleam@dict:dict(binary(), {bitstring(), gleam@dict:dict(binary(), binary())})
) -> {ok, list(arctic:cacheable_page())} | {error, snag:snag()}.
read_collection(Collection, Cache) ->
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
            _pipe@2 = gleam@list:try_fold(
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
                            New_hash = gleam_crypto_ffi:hash(
                                sha256,
                                gleam_stdlib:identity(Content)
                            ),
                            gleam@io:debug(Path),
                            gleam@io:debug(New_hash),
                            case gleam@dict:get(Cache, Path) of
                                {ok, {Current_hash, Metadata}} when Current_hash =:= New_hash ->
                                    {ok,
                                        [{cached_page, Path, Metadata} | So_far]};

                                _ ->
                                    gleam@io:debug(<<"new page!"/utf8>>),
                                    _ = gleam@io:debug(
                                        gleam@dict:get(Cache, Path)
                                    ),
                                    gleam@result:'try'(
                                        (erlang:element(3, Collection))(
                                            Path,
                                            Content
                                        ),
                                        fun(P) ->
                                            gleam@result:'try'(
                                                begin
                                                    _pipe@1 = simplifile:append(
                                                        <<".arctic_cache.csv"/utf8>>,
                                                        <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"\""/utf8,
                                                                                                                        (gleam@string:replace(
                                                                                                                            Path,
                                                                                                                            <<"\""/utf8>>,
                                                                                                                            <<"\"\""/utf8>>
                                                                                                                        ))/binary>>/binary,
                                                                                                                    "\",\""/utf8>>/binary,
                                                                                                                (gleam_stdlib:bit_array_base64_encode(
                                                                                                                    New_hash,
                                                                                                                    false
                                                                                                                ))/binary>>/binary,
                                                                                                            "\",\"id:"/utf8>>/binary,
                                                                                                        (gleam@string:replace(
                                                                                                            erlang:element(
                                                                                                                2,
                                                                                                                P
                                                                                                            ),
                                                                                                            <<"\""/utf8>>,
                                                                                                            <<"\"\""/utf8>>
                                                                                                        ))/binary>>/binary,
                                                                                                    "\",\"title:"/utf8>>/binary,
                                                                                                (gleam@string:replace(
                                                                                                    erlang:element(
                                                                                                        5,
                                                                                                        P
                                                                                                    ),
                                                                                                    <<"\""/utf8>>,
                                                                                                    <<"\"\""/utf8>>
                                                                                                ))/binary>>/binary,
                                                                                            "\""/utf8>>/binary,
                                                                                        (gleam@option:unwrap(
                                                                                            gleam@option:map(
                                                                                                erlang:element(
                                                                                                    8,
                                                                                                    P
                                                                                                ),
                                                                                                fun(
                                                                                                    D
                                                                                                ) ->
                                                                                                    <<<<",\"date:"/utf8,
                                                                                                            (birl:to_naive_date_string(
                                                                                                                D
                                                                                                            ))/binary>>/binary,
                                                                                                        "\""/utf8>>
                                                                                                end
                                                                                            ),
                                                                                            <<""/utf8>>
                                                                                        ))/binary>>/binary,
                                                                                    ",\"tags:"/utf8>>/binary,
                                                                                (gleam@string:join(
                                                                                    gleam@list:map(
                                                                                        erlang:element(
                                                                                            7,
                                                                                            P
                                                                                        ),
                                                                                        fun(
                                                                                            _capture
                                                                                        ) ->
                                                                                            gleam@string:replace(
                                                                                                _capture,
                                                                                                <<"\""/utf8>>,
                                                                                                <<"\"\""/utf8>>
                                                                                            )
                                                                                        end
                                                                                    ),
                                                                                    <<","/utf8>>
                                                                                ))/binary>>/binary,
                                                                            "\",\"blerb:"/utf8>>/binary,
                                                                        (gleam@string:replace(
                                                                            erlang:element(
                                                                                6,
                                                                                P
                                                                            ),
                                                                            <<"\""/utf8>>,
                                                                            <<"\"\""/utf8>>
                                                                        ))/binary>>/binary,
                                                                    "\""/utf8>>/binary,
                                                                (gleam@dict:fold(
                                                                    erlang:element(
                                                                        4,
                                                                        P
                                                                    ),
                                                                    <<""/utf8>>,
                                                                    fun(B, K, V) ->
                                                                        <<<<<<<<<<B/binary,
                                                                                            ",\""/utf8>>/binary,
                                                                                        (gleam@string:replace(
                                                                                            K,
                                                                                            <<"\""/utf8>>,
                                                                                            <<"\"\""/utf8>>
                                                                                        ))/binary>>/binary,
                                                                                    ":"/utf8>>/binary,
                                                                                (gleam@string:replace(
                                                                                    V,
                                                                                    <<"\""/utf8>>,
                                                                                    <<"\"\""/utf8>>
                                                                                ))/binary>>/binary,
                                                                            "\""/utf8>>
                                                                    end
                                                                ))/binary>>/binary,
                                                            "\n"/utf8>>
                                                    ),
                                                    gleam@result:map_error(
                                                        _pipe@1,
                                                        fun(Err@2) ->
                                                            snag:new(
                                                                <<<<"couldn't write to cache ("/utf8,
                                                                        (simplifile:describe_error(
                                                                            Err@2
                                                                        ))/binary>>/binary,
                                                                    ")"/utf8>>
                                                            )
                                                        end
                                                    )
                                                end,
                                                fun(_) ->
                                                    {ok,
                                                        [{new_page, P} | So_far]}
                                                end
                                            )
                                        end
                                    )
                            end
                        end
                    )
                end
            ),
            gleam@result:map(_pipe@2, fun lists:reverse/1)
        end
    ).

-spec process(
    list(arctic:collection()),
    gleam@dict:dict(binary(), {bitstring(), gleam@dict:dict(binary(), binary())})
) -> {ok, list(arctic:processed_collection())} | {error, snag:snag()}.
process(Collections, Cache) ->
    gleam@list:try_fold(
        Collections,
        [],
        fun(Rest, Collection) ->
            gleam@result:'try'(
                read_collection(Collection, Cache),
                fun(Pages_unsorted) ->
                    Pages = gleam@list:sort(
                        Pages_unsorted,
                        lift_ordering(erlang:element(6, Collection))
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
                        fun(S@1, P) -> case P of
                                {new_page, New_page} ->
                                    lustre@ssg:add_static_route(
                                        S@1,
                                        <<<<<<"/"/utf8,
                                                    (erlang:element(
                                                        2,
                                                        erlang:element(
                                                            2,
                                                            Processed
                                                        )
                                                    ))/binary>>/binary,
                                                "/"/utf8>>/binary,
                                            (erlang:element(2, New_page))/binary>>,
                                        (erlang:element(
                                            7,
                                            erlang:element(2, Processed)
                                        ))(New_page)
                                    );

                                {cached_page, Path, _} ->
                                    _assert_subject = gleam@string:split(
                                        Path,
                                        <<".txt"/utf8>>
                                    ),
                                    [Start | _] = case _assert_subject of
                                        [_ | _] -> _assert_subject;
                                        _assert_fail ->
                                            erlang:error(
                                                    #{gleam_error => let_assert,
                                                        message => <<"Assertion pattern match failed"/utf8>>,
                                                        value => _assert_fail,
                                                        module => <<"arctic/build"/utf8>>,
                                                        function => <<"make_ssg_config"/utf8>>,
                                                        line => 288}
                                                )
                                    end,
                                    Cached_path = <<<<"arctic_build/"/utf8,
                                            Start/binary>>/binary,
                                        "/index.html"/utf8>>,
                                    Res = simplifile:read(Cached_path),
                                    Content = case Res of
                                        {ok, C} ->
                                            C;

                                        {error, _} ->
                                            erlang:error(#{gleam_error => panic,
                                                    message => Cached_path,
                                                    module => <<"arctic/build"/utf8>>,
                                                    function => <<"make_ssg_config"/utf8>>,
                                                    line => 293})
                                    end,
                                    lustre@ssg:add_static_asset(
                                        S@1,
                                        <<<<"/"/utf8, Start/binary>>/binary,
                                            "/index.html"/utf8>>,
                                        Content
                                    )
                            end end
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
            _pipe = simplifile_erl:create_directory(
                <<"arctic_build/public"/utf8>>
            ),
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
    gleam@option:option(TSP),
    fun((TSP) -> {ok, nil} | {error, snag:snag()})
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
                                            (get_id(Page@1))/binary>>/binary,
                                        "\": \"arctic_build/"/utf8>>/binary,
                                    (erlang:element(
                                        2,
                                        erlang:element(2, Processed)
                                    ))/binary>>/binary,
                                "/"/utf8>>/binary,
                            (get_id(Page@1))/binary>>/binary,
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
    _ = simplifile:create_file(<<".arctic_cache.csv"/utf8>>),
    gleam@result:'try'(
        begin
            _pipe = simplifile:read(<<".arctic_cache.csv"/utf8>>),
            gleam@result:map_error(
                _pipe,
                fun(Err) ->
                    snag:new(
                        <<<<"couldn't read cache ("/utf8,
                                (simplifile:describe_error(Err))/binary>>/binary,
                            ")"/utf8>>
                    )
                end
            )
        end,
        fun(Content) -> gleam@result:'try'(case Content of
                    <<""/utf8>> ->
                        {ok, []};

                    _ ->
                        _pipe@1 = parse_csv(Content),
                        snag:context(_pipe@1, <<"couldn't parse cache"/utf8>>)
                end, fun(Csv) ->
                    gleam@result:'try'(
                        to_cache(Csv),
                        fun(Cache) ->
                            gleam@result:'try'(
                                process(erlang:element(4, Config), Cache),
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
                                                                        fun() ->
                                                                            {ok,
                                                                                nil}
                                                                        end
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
                            )
                        end
                    )
                end) end
    ).
