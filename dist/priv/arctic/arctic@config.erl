-module(arctic@config).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([new/0, home_renderer/2, add_main_page/3, add_collection/2, add_spa_frame/2, turn_off_spa/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-file("src/arctic/config.gleam", 10).
?DOC(
    " Produce a new Arctic configuration, with default settings.\n"
    " An Arctic configuration holds all the collections, pages, parsing rules, etc.\n"
).
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

-file("src/arctic/config.gleam", 26).
?DOC(
    " Set the renderer for the home page of a site (`/index.html`).\n"
    " Note that a list of all collections, with all of their pages, is provided if you'd like to use it.\n"
).
-spec home_renderer(
    arctic:config(),
    fun((list(arctic:processed_collection())) -> lustre@internals@vdom:element(nil))
) -> arctic:config().
home_renderer(Config, Renderer) ->
    _record = Config,
    {config,
        Renderer,
        erlang:element(3, _record),
        erlang:element(4, _record),
        erlang:element(5, _record)}.

-file("src/arctic/config.gleam", 36).
?DOC(
    " Add a \"main page\" to an Arctic configuration.\n"
    " Main pages are pages that aren't a part of any collection, like \"Contact\" or \"About.\"\n"
    " Note that the home page (`/index.html`) is handled via `home_renderer` instead.\n"
).
-spec add_main_page(
    arctic:config(),
    binary(),
    lustre@internals@vdom:element(nil)
) -> arctic:config().
add_main_page(Config, Id, Body) ->
    _record = Config,
    {config,
        erlang:element(2, _record),
        [{raw_page, Id, Body} | erlang:element(3, Config)],
        erlang:element(4, _record),
        erlang:element(5, _record)}.

-file("src/arctic/config.gleam", 44).
?DOC(
    " Add a \"collection\" to an Arctic configuration.\n"
    " A collection holds a bunch of pages and their processing rules,\n"
    " like a set of products, blog posts, wiki entries, etc.\n"
    " See `arctic/collection` for more.\n"
).
-spec add_collection(arctic:config(), arctic:collection()) -> arctic:config().
add_collection(Config, Collection) ->
    _record = Config,
    {config,
        erlang:element(2, _record),
        erlang:element(3, _record),
        [Collection | erlang:element(4, Config)],
        erlang:element(5, _record)}.

-file("src/arctic/config.gleam", 51).
?DOC(
    " Specify code that is on the outside of a page, \n"
    " and doesn't get re-rendered on page navigation.\n"
    " This can be nav bars, a `head` element, side panels, footer, etc.\n"
).
-spec add_spa_frame(
    arctic:config(),
    fun((lustre@internals@vdom:element(nil)) -> lustre@internals@vdom:element(nil))
) -> arctic:config().
add_spa_frame(Config, Frame) ->
    _record = Config,
    {config,
        erlang:element(2, _record),
        erlang:element(3, _record),
        erlang:element(4, _record),
        {some, Frame}}.

-file("src/arctic/config.gleam", 57).
?DOC(
    " Generate the site as a directory of files,\n"
    " instead of as a single-page app with clever routing.\n"
).
-spec turn_off_spa(arctic:config()) -> arctic:config().
turn_off_spa(Config) ->
    _record = Config,
    {config,
        erlang:element(2, _record),
        erlang:element(3, _record),
        erlang:element(4, _record),
        none}.
