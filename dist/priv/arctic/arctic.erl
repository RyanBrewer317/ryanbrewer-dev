-module(arctic).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([get_id/1, to_dummy_page/1, output_path/1]).
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
        gleam@option:option(birl:time())}.

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

-spec get_id(cacheable_page()) -> binary().
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
                                module => <<"arctic"/utf8>>,
                                function => <<"get_id"/utf8>>,
                                line => 80})
            end,
            Id;

        {new_page, Page} ->
            erlang:element(2, Page)
    end.

-spec to_dummy_page(cacheable_page()) -> page().
to_dummy_page(C) ->
    case C of
        {cached_page, _, Metadata} ->
            Title = begin
                _pipe = Metadata,
                _pipe@1 = gleam@dict:get(_pipe, <<"title"/utf8>>),
                gleam@result:unwrap(_pipe@1, <<""/utf8>>)
            end,
            Blerb = begin
                _pipe@2 = Metadata,
                _pipe@3 = gleam@dict:get(_pipe@2, <<"blerb"/utf8>>),
                gleam@result:unwrap(_pipe@3, <<""/utf8>>)
            end,
            Tags = begin
                _pipe@4 = Metadata,
                _pipe@5 = gleam@dict:get(_pipe@4, <<"tags"/utf8>>),
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
                _pipe@8 = gleam@dict:get(_pipe@7, <<"date"/utf8>>),
                _pipe@9 = gleam@result:'try'(_pipe@8, fun birl:parse/1),
                gleam@option:from_result(_pipe@9)
            end,
            {page, get_id(C), [], Metadata, Title, Blerb, Tags, Date};

        {new_page, P} ->
            P
    end.

-spec output_path(binary()) -> binary().
output_path(Input_path) ->
    _assert_subject = gleam@string:split(Input_path, <<".txt"/utf8>>),
    [Start, <<""/utf8>>] = case _assert_subject of
        [_, <<""/utf8>>] -> _assert_subject;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Assertion pattern match failed"/utf8>>,
                        value => _assert_fail,
                        module => <<"arctic"/utf8>>,
                        function => <<"output_path"/utf8>>,
                        line => 88})
    end,
    <<<<"arctic_build/"/utf8, Start/binary>>/binary, "/index.html"/utf8>>.
