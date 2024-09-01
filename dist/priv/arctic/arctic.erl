-module(arctic).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([to_dummy_page/1]).
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
        list(collection())}.

-spec to_dummy_page(cacheable_page()) -> page().
to_dummy_page(C) ->
    case C of
        {cached_page, Path, Metadata} ->
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
            {page, Path, [], Metadata, Title, Blerb, Tags, Date};

        {new_page, P} ->
            P
    end.
