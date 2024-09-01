-module(arctic@collection).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([with_parser/2, default_parser/0, new/1, with_index/2, with_feed/3, with_ordering/2, with_renderer/2, with_raw_page/3]).

-spec with_parser(
    arctic:collection(),
    fun((binary(), binary()) -> {ok, arctic:page()} | {error, snag:snag()})
) -> arctic:collection().
with_parser(C, Parser) ->
    erlang:setelement(3, C, Parser).

-spec default_parser() -> fun((binary(), binary()) -> {ok, arctic:page()} |
    {error, snag:snag()}).
default_parser() ->
    fun(Src_name, Src) ->
        Parser = begin
            _pipe = arctic@parse:new(nil),
            _pipe@1 = arctic@parse:add_inline_rule(
                _pipe,
                <<"*"/utf8>>,
                <<"*"/utf8>>,
                arctic@parse:wrap_inline(fun lustre@element@html:i/2)
            ),
            _pipe@2 = arctic@parse:add_prefix_rule(
                _pipe@1,
                <<"#"/utf8>>,
                arctic@parse:wrap_prefix(fun lustre@element@html:h1/2)
            ),
            arctic@parse:add_static_component(
                _pipe@2,
                <<"image"/utf8>>,
                fun(Args, Label, Data) -> case Args of
                        [Url] ->
                            {ok,
                                {lustre@element@html:img(
                                        [lustre@attribute:src(Url),
                                            lustre@attribute:alt(Label)]
                                    ),
                                    nil}};

                        _ ->
                            Pos = arctic@parse:get_pos(Data),
                            snag:error(
                                <<<<<<<<<<"bad @image arguments `"/utf8,
                                                    (gleam@string:join(
                                                        Args,
                                                        <<", "/utf8>>
                                                    ))/binary>>/binary,
                                                "` at "/utf8>>/binary,
                                            (gleam@int:to_string(
                                                erlang:element(2, Pos)
                                            ))/binary>>/binary,
                                        ":"/utf8>>/binary,
                                    (gleam@int:to_string(erlang:element(3, Pos)))/binary>>
                            )
                    end end
            )
        end,
        arctic@parse:parse(Parser, Src_name, Src)
    end.

-spec new(binary()) -> arctic:collection().
new(Dir) ->
    {collection,
        Dir,
        default_parser(),
        none,
        none,
        fun(_, _) -> eq end,
        fun(_) ->
            lustre@element@html:html(
                [],
                [lustre@element@html:head([], []),
                    lustre@element@html:body(
                        [],
                        [lustre@element:text(
                                <<<<"No renderer set up for collection \""/utf8,
                                        Dir/binary>>/binary,
                                    "\"."/utf8>>
                            )]
                    )]
            )
        end,
        []}.

-spec with_index(
    arctic:collection(),
    fun((list(arctic:cacheable_page())) -> lustre@internals@vdom:element(nil))
) -> arctic:collection().
with_index(C, Index) ->
    erlang:setelement(4, C, {some, Index}).

-spec with_feed(
    arctic:collection(),
    binary(),
    fun((list(arctic:cacheable_page())) -> binary())
) -> arctic:collection().
with_feed(C, Filename, Render) ->
    erlang:setelement(5, C, {some, {Filename, Render}}).

-spec with_ordering(
    arctic:collection(),
    fun((arctic:page(), arctic:page()) -> gleam@order:order())
) -> arctic:collection().
with_ordering(C, Ordering) ->
    erlang:setelement(6, C, Ordering).

-spec with_renderer(
    arctic:collection(),
    fun((arctic:page()) -> lustre@internals@vdom:element(nil))
) -> arctic:collection().
with_renderer(C, Renderer) ->
    erlang:setelement(7, C, Renderer).

-spec with_raw_page(
    arctic:collection(),
    binary(),
    lustre@internals@vdom:element(nil)
) -> arctic:collection().
with_raw_page(C, Id, Body) ->
    erlang:setelement(8, C, [{raw_page, Id, Body} | erlang:element(8, C)]).
