-module(arctic@config).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([new/0, home_renderer/2, add_main_page/3, add_collection/2]).

-spec new() -> arctic:config().
new() ->
    {config,
        fun(_) ->
            lustre@element@html:html(
                [],
                [lustre@element@html:head([], []),
                    lustre@element@html:body(
                        [],
                        [lustre@element:text(
                                <<"No renderer set up for home page"/utf8>>
                            )]
                    )]
            )
        end,
        [],
        []}.

-spec home_renderer(
    arctic:config(),
    fun((list(arctic:processed_collection())) -> lustre@internals@vdom:element(nil))
) -> arctic:config().
home_renderer(Config, Renderer) ->
    {config, Renderer, erlang:element(3, Config), erlang:element(4, Config)}.

-spec add_main_page(
    arctic:config(),
    binary(),
    lustre@internals@vdom:element(nil)
) -> arctic:config().
add_main_page(Config, Id, Body) ->
    {config,
        erlang:element(2, Config),
        [{raw_page, Id, Body} | erlang:element(3, Config)],
        erlang:element(4, Config)}.

-spec add_collection(arctic:config(), arctic:collection()) -> arctic:config().
add_collection(Config, Collection) ->
    {config,
        erlang:element(2, Config),
        erlang:element(3, Config),
        [Collection | erlang:element(4, Config)]}.
