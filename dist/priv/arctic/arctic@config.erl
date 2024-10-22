-module(arctic@config).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([new/0, home_renderer/2, add_main_page/3, add_collection/2, add_spa_frame/2, turn_off_spa/1]).

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
        [],
        {some, fun(Body) -> Body end}}.

-spec home_renderer(
    arctic:config(),
    fun((list(arctic:processed_collection())) -> lustre@internals@vdom:element(nil))
) -> arctic:config().
home_renderer(Config, Renderer) ->
    erlang:setelement(2, Config, Renderer).

-spec add_main_page(
    arctic:config(),
    binary(),
    lustre@internals@vdom:element(nil)
) -> arctic:config().
add_main_page(Config, Id, Body) ->
    erlang:setelement(
        3,
        Config,
        [{raw_page, Id, Body} | erlang:element(3, Config)]
    ).

-spec add_collection(arctic:config(), arctic:collection()) -> arctic:config().
add_collection(Config, Collection) ->
    erlang:setelement(4, Config, [Collection | erlang:element(4, Config)]).

-spec add_spa_frame(
    arctic:config(),
    fun((lustre@internals@vdom:element(nil)) -> lustre@internals@vdom:element(nil))
) -> arctic:config().
add_spa_frame(Config, Frame) ->
    erlang:setelement(5, Config, {some, Frame}).

-spec turn_off_spa(arctic:config()) -> arctic:config().
turn_off_spa(Config) ->
    erlang:setelement(5, Config, none).
