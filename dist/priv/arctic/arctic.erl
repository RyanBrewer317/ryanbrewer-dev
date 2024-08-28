-module(arctic).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export_type([collection/0, page/0, processed_collection/0, raw_page/0, config/0]).

-type collection() :: {collection,
        binary(),
        fun((binary(), binary()) -> {ok, page()} | {error, snag:snag()}),
        gleam@option:option(fun((list(page())) -> lustre@internals@vdom:element(nil))),
        gleam@option:option({binary(), fun((list(page())) -> binary())}),
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

-type processed_collection() :: {processed_collection,
        collection(),
        list(page())}.

-type raw_page() :: {raw_page, binary(), lustre@internals@vdom:element(nil)}.

-type config() :: {config,
        fun((list(processed_collection())) -> lustre@internals@vdom:element(nil)),
        list(raw_page()),
        list(collection())}.


