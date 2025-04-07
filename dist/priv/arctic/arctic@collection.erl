-module(arctic@collection).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([with_parser/2, default_parser/0, new/1, with_index/2, with_feed/3, with_ordering/2, with_renderer/2, with_raw_page/3]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-file("src/arctic/collection.gleam", 40).
?DOC(
    " Add a parser to a collection.\n"
    " A parser processed the raw text and \n"
    " either fails with a message or produces a page.\n"
    " See `arctic/parse` for help constructing these.\n"
).
-spec with_parser(
    arctic:collection(),
    fun((binary(), binary()) -> {ok, arctic:page()} | {error, snag:snag()})
) -> arctic:collection().
with_parser(C, Parser) ->
    _record = C,
    {collection,
        erlang:element(2, _record),
        Parser,
        erlang:element(4, _record),
        erlang:element(5, _record),
        erlang:element(6, _record),
        erlang:element(7, _record),
        erlang:element(8, _record)}.

-file("src/arctic/collection.gleam", 49).
?DOC(
    " A simple default parser for the sorts of things you'd expect when writing markup.\n"
    " This also serves as a nice example of how to construct parsers.\n"
).
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
                                            (erlang:integer_to_binary(
                                                erlang:element(2, Pos)
                                            ))/binary>>/binary,
                                        ":"/utf8>>/binary,
                                    (erlang:integer_to_binary(
                                        erlang:element(3, Pos)
                                    ))/binary>>
                            )
                    end end
            )
        end,
        arctic@parse:parse(Parser, Src_name, Src)
    end.

-file("src/arctic/collection.gleam", 17).
?DOC(
    " Produce a new collection, with default-everything and the given directory path.\n"
    " You can use the other functions to modify the collection.\n"
    " Or, collections can be produced manually with the `Collection` constructor from `arctic`.\n"
).
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

-file("src/arctic/collection.gleam", 83).
?DOC(
    " Add an \"index\" to the collection.\n"
    " An index is a page that shows off the pages in the collection, \n"
    " perhaps with a search bar and/or a list of pretty thumbnails.\n"
    " Note that this would need to bring *all* the pages to the client side;\n"
    " Pagination and search-via-server should be done in other ways.\n"
    " Though this doesn't scale well to massive numbers of pages,\n"
    " it's pretty easy to swap it out with something else when the number gets too high.\n"
).
-spec with_index(
    arctic:collection(),
    fun((list(arctic:cacheable_page())) -> lustre@internals@vdom:element(nil))
) -> arctic:collection().
with_index(C, Index) ->
    _record = C,
    {collection,
        erlang:element(2, _record),
        erlang:element(3, _record),
        {some, Index},
        erlang:element(5, _record),
        erlang:element(6, _record),
        erlang:element(7, _record),
        erlang:element(8, _record)}.

-file("src/arctic/collection.gleam", 93).
?DOC(
    " Add a \"feed\" to the collection.\n"
    " A feed is a special text file generated based on the elements of the collection.\n"
    " An RSS feed would be done this way.\n"
).
-spec with_feed(
    arctic:collection(),
    binary(),
    fun((list(arctic:cacheable_page())) -> binary())
) -> arctic:collection().
with_feed(C, Filename, Render) ->
    _record = C,
    {collection,
        erlang:element(2, _record),
        erlang:element(3, _record),
        erlang:element(4, _record),
        {some, {Filename, Render}},
        erlang:element(6, _record),
        erlang:element(7, _record),
        erlang:element(8, _record)}.

-file("src/arctic/collection.gleam", 104).
?DOC(
    " Add an ordering to a collection.\n"
    " This specifies the order in which pages are listed \n"
    " on, say, a collection index.\n"
).
-spec with_ordering(
    arctic:collection(),
    fun((arctic:page(), arctic:page()) -> gleam@order:order())
) -> arctic:collection().
with_ordering(C, Ordering) ->
    _record = C,
    {collection,
        erlang:element(2, _record),
        erlang:element(3, _record),
        erlang:element(4, _record),
        erlang:element(5, _record),
        Ordering,
        erlang:element(7, _record),
        erlang:element(8, _record)}.

-file("src/arctic/collection.gleam", 113).
?DOC(
    " Add a \"renderer\" to a collection.\n"
    " A renderer is any Page->HTML function.\n"
).
-spec with_renderer(
    arctic:collection(),
    fun((arctic:page()) -> lustre@internals@vdom:element(nil))
) -> arctic:collection().
with_renderer(C, Renderer) ->
    _record = C,
    {collection,
        erlang:element(2, _record),
        erlang:element(3, _record),
        erlang:element(4, _record),
        erlang:element(5, _record),
        erlang:element(6, _record),
        Renderer,
        erlang:element(8, _record)}.

-file("src/arctic/collection.gleam", 123).
?DOC(
    " Add a \"raw page\" to a collection.\n"
    " A raw page is just HTML, \n"
    " no parsing or processing will get applied.\n"
).
-spec with_raw_page(
    arctic:collection(),
    binary(),
    lustre@internals@vdom:element(nil)
) -> arctic:collection().
with_raw_page(C, Id, Body) ->
    _record = C,
    {collection,
        erlang:element(2, _record),
        erlang:element(3, _record),
        erlang:element(4, _record),
        erlang:element(5, _record),
        erlang:element(6, _record),
        erlang:element(7, _record),
        [{raw_page, Id, Body} | erlang:element(8, C)]}.
