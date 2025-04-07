-module(lustre@ssg).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([new/1, add_static_dir/2, use_index_routes/1, add_static_route/3, add_static_xml/3, add_dynamic_route/4, add_static_asset/3, build/1]).
-export_type([config/3, no_static_routes/0, no_static_dir/0, has_static_routes/0, has_static_dir/0, use_direct_routes/0, use_index_routes/0, route/0, build_error/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-opaque config(QEX, QEY, QEZ) :: {config,
        binary(),
        gleam@option:option(binary()),
        gleam@dict:dict(binary(), binary()),
        list(route()),
        boolean()} |
    {gleam_phantom, QEX, QEY, QEZ}.

-type no_static_routes() :: any().

-type no_static_dir() :: any().

-type has_static_routes() :: any().

-type has_static_dir() :: any().

-type use_direct_routes() :: any().

-type use_index_routes() :: any().

-type route() :: {static, binary(), lustre@internals@vdom:element(nil)} |
    {dynamic,
        binary(),
        gleam@dict:dict(binary(), lustre@internals@vdom:element(nil))} |
    {xml, binary(), lustre@internals@vdom:element(nil)}.

-type build_error() :: {cannot_create_temp_directory, simplifile:file_error()} |
    {cannot_write_static_asset, simplifile:file_error(), binary()} |
    {cannot_generate_route, simplifile:file_error(), binary()} |
    {cannot_write_to_output_dir, simplifile:file_error()} |
    {cannot_cleanup_temp_dir, simplifile:file_error()}.

-file("src/lustre/ssg.gleam", 20).
?DOC(
    " Initialise a new configuration for the static site generator. If you pass a\n"
    " relative path it will be resolved relative to the current working directory,\n"
    " _not_ the directory of the Gleam file.\n"
).
-spec new(binary()) -> config(no_static_routes(), no_static_dir(), use_direct_routes()).
new(Out_dir) ->
    {config, Out_dir, none, maps:new(), [], false}.

-file("src/lustre/ssg.gleam", 405).
?DOC(
    " Include a static directory from which all files will be copied over into\n"
    " the temporary build directory before building the site.\n"
).
-spec add_static_dir(config(QHD, no_static_dir(), QHE), binary()) -> config(QHD, has_static_dir(), QHE).
add_static_dir(Config, Path) ->
    {config, Out_dir, _, Static_assets, Routes, Use_index_routes} = Config,
    {config, Out_dir, {some, Path}, Static_assets, Routes, Use_index_routes}.

-file("src/lustre/ssg.gleam", 445).
?DOC(
    " Configure the static site generator to generate an `index.html` file at any\n"
    " static route provided. For example, the route \"/blog\" will generate a file\n"
    " at \"/blog/index.html\".\n"
).
-spec use_index_routes(config(QHU, QHV, any())) -> config(QHU, QHV, use_index_routes()).
use_index_routes(Config) ->
    {config, Out_dir, Static_dir, Static_assets, Routes, _} = Config,
    {config, Out_dir, Static_dir, Static_assets, Routes, true}.

-file("src/lustre/ssg.gleam", 458).
-spec routify(binary()) -> binary().
routify(Path) ->
    _assert_subject = gleam@regexp:from_string(<<"\\s+"/utf8>>),
    {ok, Whitespace} = case _assert_subject of
        {ok, _} -> _assert_subject;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        value => _assert_fail,
                        module => <<"lustre/ssg"/utf8>>,
                        function => <<"routify"/utf8>>,
                        line => 459})
    end,
    _pipe = gleam@regexp:split(Whitespace, Path),
    _pipe@1 = gleam@string:join(_pipe, <<"-"/utf8>>),
    string:lowercase(_pipe@1).

-file("src/lustre/ssg.gleam", 313).
?DOC(
    " Configure a static route to be generated. The path should be the route that\n"
    " the page will be available at when served by a HTTP server. For example the\n"
    " path \"/blog\" would be available at \"https://your_site.com/blog\".\n"
    "\n"
    " You need to add at least one static route before you can build your site. This\n"
    " is to prevent you from providing empty dynamic routes and accidentally building\n"
    " nothing.\n"
    "\n"
    " Paths are converted to kebab-case and lowercased. This means that the path\n"
    " \"/Blog\" will be available at \"/blog\" and and \"/About me\" will be available at\n"
    " \"/about-me\".\n"
).
-spec add_static_route(
    config(any(), QFU, QFV),
    binary(),
    lustre@internals@vdom:element(any())
) -> config(has_static_routes(), QFU, QFV).
add_static_route(Config, Path, Page) ->
    {config, Out_dir, Static_dir, Static_assets, Routes, Use_index_routes} = Config,
    Route = {static, routify(Path), lustre@element:map(Page, fun(_) -> nil end)},
    {config,
        Out_dir,
        Static_dir,
        Static_assets,
        [Route | Routes],
        Use_index_routes}.

-file("src/lustre/ssg.gleam", 336).
?DOC("\n").
-spec add_static_xml(
    config(QGE, QGF, QGG),
    binary(),
    lustre@internals@vdom:element(any())
) -> config(QGE, QGF, QGG).
add_static_xml(Config, Path, Page) ->
    {config, Out_dir, Static_dir, Static_assets, Routes, Use_index_routes} = Config,
    Route = {xml, routify(Path), lustre@element:map(Page, fun(_) -> nil end)},
    {config,
        Out_dir,
        Static_dir,
        Static_assets,
        [Route | Routes],
        Use_index_routes}.

-file("src/lustre/ssg.gleam", 383).
?DOC(
    " Configure a map of dynamic routes to be generated. As with `add_static_route`\n"
    " the base path should be the route that each page will be available at when\n"
    " served by a HTTP server.\n"
    "\n"
    " The initial path is the base for all dynamic routes to be generated. The\n"
    " keys of the `data` map will be used to generate the dynamic routes. For\n"
    " example, to generate dynamic routes for a blog where each page is a post\n"
    " with the route \"/blog/:post\" you might do:\n"
    "\n"
    " ```gleam\n"
    " let posts = [\n"
    "   #(\"hello-world\", Post(...)),\n"
    "   #(\"why-lustre-is-great\", Post(...)),\n"
    " ]\n"
    "\n"
    " ...\n"
    "\n"
    " ssg.config(\"./dist\")\n"
    " |> ...\n"
    " |> ssg.add_dynamic_route(\"/blog\", posts, render_post)\n"
    " ```\n"
    "\n"
    " Paths are converted to kebab-case and lowercased. This means that the path\n"
    " \"/Blog\" will be available at \"/blog\" and and \"/About me\" will be available at\n"
    " \"/about-me\".\n"
).
-spec add_dynamic_route(
    config(QGP, QGQ, QGR),
    binary(),
    gleam@dict:dict(binary(), QGV),
    fun((QGV) -> lustre@internals@vdom:element(any()))
) -> config(QGP, QGQ, QGR).
add_dynamic_route(Config, Path, Data, Page) ->
    Route = begin
        Path@1 = routify(Path),
        Pages = gleam@dict:map_values(
            Data,
            fun(_, Data@1) ->
                lustre@element:map(Page(Data@1), fun(_) -> nil end)
            end
        ),
        {dynamic, Path@1, Pages}
    end,
    _record = Config,
    {config,
        erlang:element(2, _record),
        erlang:element(3, _record),
        erlang:element(4, _record),
        [Route | erlang:element(5, Config)],
        erlang:element(6, _record)}.

-file("src/lustre/ssg.gleam", 429).
?DOC(
    " Include a static asset in the generated site. This might be something you\n"
    " want to be generated at build time, like a robots.txt, a sitemap.xml, or\n"
    " an RSS feed.\n"
    "\n"
    " The path should be the path that the asset will be available at when served\n"
    " by an HTTP server. For example, the path \"/robots.txt\" would be available at\n"
    " \"https://your_site.com/robots.txt\". The path will be converted to kebab-case\n"
    " and lowercased.\n"
    "\n"
    " If you have configured a static assets directory to be copied over, any static\n"
    " asset added here will overwrite any file with the same path.\n"
).
-spec add_static_asset(config(QHL, QHM, QHN), binary(), binary()) -> config(QHL, QHM, QHN).
add_static_asset(Config, Path, Content) ->
    Static_assets = gleam@dict:insert(
        erlang:element(4, Config),
        routify(Path),
        Content
    ),
    _record = Config,
    {config,
        erlang:element(2, _record),
        erlang:element(3, _record),
        Static_assets,
        erlang:element(5, _record),
        erlang:element(6, _record)}.

-file("src/lustre/ssg.gleam", 466).
-spec trim_slash(binary()) -> binary().
trim_slash(Path) ->
    case gleam_stdlib:string_ends_with(Path, <<"/"/utf8>>) of
        true ->
            gleam@string:drop_end(Path, 1);

        false ->
            Path
    end.

-file("src/lustre/ssg.gleam", 473).
-spec last_segment(binary()) -> {binary(), binary()}.
last_segment(Path) ->
    _assert_subject = gleam@regexp:from_string(<<"(.*/)+?(.+)"/utf8>>),
    {ok, Segments} = case _assert_subject of
        {ok, _} -> _assert_subject;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        value => _assert_fail,
                        module => <<"lustre/ssg"/utf8>>,
                        function => <<"last_segment"/utf8>>,
                        line => 474})
    end,
    _assert_subject@1 = gleam@regexp:scan(Segments, Path),
    [{match, _, [{some, Leading}, {some, Last}]}] = case _assert_subject@1 of
        [{match, _, [{some, _}, {some, _}]}] -> _assert_subject@1;
        _assert_fail@1 ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        value => _assert_fail@1,
                        module => <<"lustre/ssg"/utf8>>,
                        function => <<"last_segment"/utf8>>,
                        line => 475})
    end,
    {Leading, Last}.

-file("src/lustre/ssg.gleam", 51).
?DOC(
    " Generate the static site. This will delete the output directory if it already\n"
    " exists and then generate all of the routes configured. If a static assets\n"
    " directory has been configured, its contents will be recursively copied into\n"
    " the output directory **before** any routes are generated.\n"
).
-spec do_build(config(has_static_routes(), any(), any())) -> {ok,
        {ok, nil} | {error, build_error()}} |
    {error, simplifile:file_error()}.
do_build(Config) ->
    {config, Out_dir, Static_dir, Static_assets, Routes, Use_index_routes} = Config,
    Out_dir@1 = trim_slash(Out_dir),
    temporary:create(
        temporary:directory(),
        fun(Temp) ->
            gleam@result:'try'(
                begin
                    _pipe = case Static_dir of
                        {some, Path} ->
                            simplifile:copy_directory(Path, Temp);

                        none ->
                            simplifile:create_directory_all(Temp)
                    end,
                    gleam@result:map_error(
                        _pipe,
                        fun(Field@0) -> {cannot_create_temp_directory, Field@0} end
                    )
                end,
                fun(_) ->
                    gleam@result:'try'(
                        begin
                            gleam@list:try_map(
                                maps:to_list(Static_assets),
                                fun(_use0) ->
                                    {Path@1, Content} = _use0,
                                    Dir = filepath:directory_name(Path@1),
                                    _pipe@1 = filepath:join(Temp, Dir),
                                    _pipe@2 = simplifile:create_directory_all(
                                        _pipe@1
                                    ),
                                    _pipe@3 = gleam@result:then(
                                        _pipe@2,
                                        fun(_) ->
                                            simplifile:write(
                                                <<Temp/binary, Path@1/binary>>,
                                                Content
                                            )
                                        end
                                    ),
                                    gleam@result:map_error(
                                        _pipe@3,
                                        fun(_capture) ->
                                            {cannot_write_static_asset,
                                                _capture,
                                                Path@1}
                                        end
                                    )
                                end
                            )
                        end,
                        fun(_) ->
                            gleam@result:'try'(
                                begin
                                    Routes@1 = gleam@list:sort(
                                        Routes,
                                        fun(A, B) ->
                                            gleam@string:compare(
                                                erlang:element(2, A),
                                                erlang:element(2, B)
                                            )
                                        end
                                    ),
                                    gleam@list:try_map(
                                        Routes@1,
                                        fun(Route) -> case Route of
                                                {static, <<"/"/utf8>>, El} ->
                                                    Path@2 = <<Temp/binary,
                                                        "/index.html"/utf8>>,
                                                    _pipe@4 = El,
                                                    _pipe@5 = lustre@element:to_document_string(
                                                        _pipe@4
                                                    ),
                                                    _pipe@6 = simplifile:write(
                                                        Path@2,
                                                        _pipe@5
                                                    ),
                                                    gleam@result:map_error(
                                                        _pipe@6,
                                                        fun(_capture@1) ->
                                                            {cannot_generate_route,
                                                                _capture@1,
                                                                Path@2}
                                                        end
                                                    );

                                                {static, Path@3, El@1} when Use_index_routes ->
                                                    _ = simplifile:create_directory_all(
                                                        <<Temp/binary,
                                                            Path@3/binary>>
                                                    ),
                                                    Path@4 = <<<<Temp/binary,
                                                            (trim_slash(Path@3))/binary>>/binary,
                                                        "/index.html"/utf8>>,
                                                    _pipe@7 = El@1,
                                                    _pipe@8 = lustre@element:to_document_string(
                                                        _pipe@7
                                                    ),
                                                    _pipe@9 = simplifile:write(
                                                        Path@4,
                                                        _pipe@8
                                                    ),
                                                    gleam@result:map_error(
                                                        _pipe@9,
                                                        fun(_capture@2) ->
                                                            {cannot_generate_route,
                                                                _capture@2,
                                                                Path@4}
                                                        end
                                                    );

                                                {static, Path@5, El@2} ->
                                                    {Path@6, Name} = last_segment(
                                                        Path@5
                                                    ),
                                                    _ = simplifile:create_directory_all(
                                                        <<Temp/binary,
                                                            Path@6/binary>>
                                                    ),
                                                    Path@7 = <<<<<<<<Temp/binary,
                                                                    (trim_slash(
                                                                        Path@6
                                                                    ))/binary>>/binary,
                                                                "/"/utf8>>/binary,
                                                            Name/binary>>/binary,
                                                        ".html"/utf8>>,
                                                    _pipe@10 = El@2,
                                                    _pipe@11 = lustre@element:to_document_string(
                                                        _pipe@10
                                                    ),
                                                    _pipe@12 = simplifile:write(
                                                        Path@7,
                                                        _pipe@11
                                                    ),
                                                    gleam@result:map_error(
                                                        _pipe@12,
                                                        fun(_capture@3) ->
                                                            {cannot_generate_route,
                                                                _capture@3,
                                                                Path@7}
                                                        end
                                                    );

                                                {dynamic, Path@8, Pages} ->
                                                    _ = simplifile:create_directory_all(
                                                        <<Temp/binary,
                                                            Path@8/binary>>
                                                    ),
                                                    gleam@list:try_fold(
                                                        maps:to_list(Pages),
                                                        nil,
                                                        fun(_, _use1) ->
                                                            {Page, El@3} = _use1,
                                                            Path@9 = <<<<<<<<Temp/binary,
                                                                            (trim_slash(
                                                                                Path@8
                                                                            ))/binary>>/binary,
                                                                        "/"/utf8>>/binary,
                                                                    (routify(
                                                                        Page
                                                                    ))/binary>>/binary,
                                                                ".html"/utf8>>,
                                                            _pipe@13 = El@3,
                                                            _pipe@14 = lustre@element:to_document_string(
                                                                _pipe@13
                                                            ),
                                                            _pipe@15 = simplifile:write(
                                                                Path@9,
                                                                _pipe@14
                                                            ),
                                                            gleam@result:map_error(
                                                                _pipe@15,
                                                                fun(_capture@4) ->
                                                                    {cannot_generate_route,
                                                                        _capture@4,
                                                                        Path@9}
                                                                end
                                                            )
                                                        end
                                                    );

                                                {xml, Path@10, El@4} ->
                                                    {Path@11, Name@1} = last_segment(
                                                        Path@10
                                                    ),
                                                    _ = simplifile:create_directory_all(
                                                        <<Temp/binary,
                                                            Path@11/binary>>
                                                    ),
                                                    Path@12 = <<<<<<<<Temp/binary,
                                                                    (trim_slash(
                                                                        Path@11
                                                                    ))/binary>>/binary,
                                                                "/"/utf8>>/binary,
                                                            Name@1/binary>>/binary,
                                                        ".xml"/utf8>>,
                                                    _pipe@16 = El@4,
                                                    _pipe@17 = lustre@element:to_string(
                                                        _pipe@16
                                                    ),
                                                    _pipe@18 = gleam@string:append(
                                                        <<"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"/utf8>>,
                                                        _pipe@17
                                                    ),
                                                    _pipe@19 = simplifile:write(
                                                        Path@12,
                                                        _pipe@18
                                                    ),
                                                    gleam@result:map_error(
                                                        _pipe@19,
                                                        fun(_capture@5) ->
                                                            {cannot_generate_route,
                                                                _capture@5,
                                                                Path@12}
                                                        end
                                                    )
                                            end end
                                    )
                                end,
                                fun(_) ->
                                    gleam@result:'try'(
                                        case begin
                                            _pipe@20 = simplifile_erl:is_directory(
                                                Out_dir@1
                                            ),
                                            gleam@result:unwrap(_pipe@20, false)
                                        end of
                                            true ->
                                                _pipe@21 = simplifile_erl:delete(
                                                    Out_dir@1
                                                ),
                                                gleam@result:map_error(
                                                    _pipe@21,
                                                    fun(Field@0) -> {cannot_write_to_output_dir, Field@0} end
                                                );

                                            false ->
                                                {ok, nil}
                                        end,
                                        fun(_) ->
                                            gleam@result:'try'(
                                                begin
                                                    _pipe@22 = simplifile:copy_directory(
                                                        Temp,
                                                        Out_dir@1
                                                    ),
                                                    gleam@result:map_error(
                                                        _pipe@22,
                                                        fun(Field@0) -> {cannot_write_to_output_dir, Field@0} end
                                                    )
                                                end,
                                                fun(_) -> {ok, nil} end
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
    ).

-file("src/lustre/ssg.gleam", 37).
?DOC(
    " Generate the static site. This will delete the output directory if it already\n"
    " exists and then generate all of the routes configured. If a static assets\n"
    " directory has been configured, its contents will be recursively copied into\n"
    " the output directory **before** any routes are generated.\n"
).
-spec build(config(has_static_routes(), any(), any())) -> {ok, nil} |
    {error, build_error()}.
build(Config) ->
    case do_build(Config) of
        {ok, Result} ->
            Result;

        {error, Error} ->
            {error, {cannot_create_temp_directory, Error}}
    end.
