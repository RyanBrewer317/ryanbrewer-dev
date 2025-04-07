-module(arctic).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([get_id/1, output_path/1, parse_date/1, to_dummy_page/1, date_to_string/1]).
-export_type([collection/0, page/0, cacheable_page/0, processed_collection/0, raw_page/0, config/0]).

-type collection() :: {collection,
        binary(),
        fun((binary(), binary()) -> {ok, page()} | {error, snag:snag()}),
        gleam@option:option(fun((list(cacheable_page())) -> lustre@internals@vdom:element(nil))),
        gleam@option:option({binary(),
            fun((list(cacheable_page())) -> binary())}),
        fun((page(), page()) -> gleam@order:order()),
        fun((page()) -> lustre@internals@vdom:element(nil)),
        list(raw_page())}.

-type page() :: {page,
        binary(),
        list(lustre@internals@vdom:element(nil)),
        gleam@dict:dict(binary(), binary()),
        binary(),
        binary(),
        list(binary()),
        gleam@option:option(gleam@time@timestamp:timestamp())}.

-type cacheable_page() :: {cached_page,
        binary(),
        gleam@dict:dict(binary(), binary())} |
    {new_page, page()}.

-type processed_collection() :: {processed_collection,
        collection(),
        list(cacheable_page())}.

-type raw_page() :: {raw_page, binary(), lustre@internals@vdom:element(nil)}.

-type config() :: {config,
        fun((list(processed_collection())) -> lustre@internals@vdom:element(nil)),
        list(raw_page()),
        list(collection()),
        gleam@option:option(fun((lustre@internals@vdom:element(nil)) -> lustre@internals@vdom:element(nil)))}.

-file("src/arctic.gleam", 79).
-spec get_id(cacheable_page()) -> binary().
get_id(P) ->
    case P of
        {cached_page, _, Metadata} ->
            _assert_subject = gleam_stdlib:map_get(Metadata, <<"id"/utf8>>),
            {ok, Id} = case _assert_subject of
                {ok, _} -> _assert_subject;
                _assert_fail ->
                    erlang:error(#{gleam_error => let_assert,
                                message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                value => _assert_fail,
                                module => <<"arctic"/utf8>>,
                                function => <<"get_id"/utf8>>,
                                line => 82})
            end,
            Id;

        {new_page, Page} ->
            erlang:element(2, Page)
    end.

-file("src/arctic.gleam", 89).
-spec output_path(binary()) -> binary().
output_path(Input_path) ->
    _assert_subject = gleam@string:split(Input_path, <<".txt"/utf8>>),
    [Start, <<""/utf8>>] = case _assert_subject of
        [_, <<""/utf8>>] -> _assert_subject;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        value => _assert_fail,
                        module => <<"arctic"/utf8>>,
                        function => <<"output_path"/utf8>>,
                        line => 90})
    end,
    <<<<"arctic_build/"/utf8, Start/binary>>/binary, "/index.html"/utf8>>.

-file("src/arctic.gleam", 115).
-spec parse_date(binary()) -> {ok, gleam@time@timestamp:timestamp()} |
    {error, snag:snag()}.
parse_date(Date) ->
    _pipe = case gleam@string:split(Date, <<"-"/utf8>>) of
        [Year_str, Month_str, Day_str] ->
            gleam@result:'try'(
                gleam_stdlib:parse_int(Year_str),
                fun(Year) ->
                    gleam@result:'try'(
                        gleam_stdlib:parse_int(Month_str),
                        fun(Month_int) ->
                            gleam@result:'try'(
                                gleam_stdlib:parse_int(Day_str),
                                fun(Day) -> gleam@result:'try'(case Month_int of
                                            1 ->
                                                {ok, january};

                                            2 ->
                                                {ok, february};

                                            3 ->
                                                {ok, march};

                                            4 ->
                                                {ok, april};

                                            5 ->
                                                {ok, may};

                                            6 ->
                                                {ok, june};

                                            7 ->
                                                {ok, july};

                                            8 ->
                                                {ok, august};

                                            9 ->
                                                {ok, september};

                                            10 ->
                                                {ok, october};

                                            11 ->
                                                {ok, november};

                                            12 ->
                                                {ok, december};

                                            _ ->
                                                {error, nil}
                                        end, fun(Month) ->
                                            {ok,
                                                gleam@time@timestamp:from_calendar(
                                                    {date, Year, Month, Day},
                                                    {time_of_day, 0, 0, 0, 0},
                                                    {duration, 0, 0}
                                                )}
                                        end) end
                            )
                        end
                    )
                end
            );

        _ ->
            {error, nil}
    end,
    gleam@result:map_error(
        _pipe,
        fun(_) ->
            snag:new(
                <<<<"couldn't parse date `"/utf8, Date/binary>>/binary,
                    "`"/utf8>>
            )
        end
    ).

-file("src/arctic.gleam", 58).
-spec to_dummy_page(cacheable_page()) -> page().
to_dummy_page(C) ->
    case C of
        {cached_page, _, Metadata} ->
            Title = begin
                _pipe = Metadata,
                _pipe@1 = gleam_stdlib:map_get(_pipe, <<"title"/utf8>>),
                gleam@result:unwrap(_pipe@1, <<""/utf8>>)
            end,
            Blerb = begin
                _pipe@2 = Metadata,
                _pipe@3 = gleam_stdlib:map_get(_pipe@2, <<"blerb"/utf8>>),
                gleam@result:unwrap(_pipe@3, <<""/utf8>>)
            end,
            Tags = begin
                _pipe@4 = Metadata,
                _pipe@5 = gleam_stdlib:map_get(_pipe@4, <<"tags"/utf8>>),
                _pipe@6 = gleam@result:map(
                    _pipe@5,
                    fun(_capture) ->
                        gleam@string:split(_capture, <<","/utf8>>)
                    end
                ),
                gleam@result:unwrap(_pipe@6, [])
            end,
            Date = begin
                _pipe@7 = Metadata,
                _pipe@8 = gleam_stdlib:map_get(_pipe@7, <<"date"/utf8>>),
                _pipe@11 = gleam@result:'try'(_pipe@8, fun(S) -> _pipe@9 = S,
                        _pipe@10 = parse_date(_pipe@9),
                        gleam@result:map_error(_pipe@10, fun(_) -> nil end) end),
                gleam@option:from_result(_pipe@11)
            end,
            {page, get_id(C), [], Metadata, Title, Blerb, Tags, Date};

        {new_page, P} ->
            P
    end.

-file("src/arctic.gleam", 143).
-spec date_to_string(gleam@time@timestamp:timestamp()) -> binary().
date_to_string(Ts) ->
    D = erlang:element(
        1,
        gleam@time@timestamp:to_calendar(Ts, {duration, 0, 0})
    ),
    Month_str = case erlang:element(3, D) of
        january ->
            <<"01"/utf8>>;

        february ->
            <<"02"/utf8>>;

        march ->
            <<"03"/utf8>>;

        april ->
            <<"04"/utf8>>;

        may ->
            <<"05"/utf8>>;

        june ->
            <<"06"/utf8>>;

        july ->
            <<"07"/utf8>>;

        august ->
            <<"08"/utf8>>;

        september ->
            <<"09"/utf8>>;

        october ->
            <<"10"/utf8>>;

        november ->
            <<"11"/utf8>>;

        december ->
            <<"12"/utf8>>
    end,
    Day_str = case erlang:element(4, D) < 10 of
        true ->
            <<"0"/utf8,
                (erlang:integer_to_binary(erlang:element(4, D)))/binary>>;

        false ->
            erlang:integer_to_binary(erlang:element(4, D))
    end,
    <<<<<<<<(erlang:integer_to_binary(erlang:element(2, D)))/binary, "-"/utf8>>/binary,
                Month_str/binary>>/binary,
            "-"/utf8>>/binary,
        Day_str/binary>>.
