-module(lustre@ssg@djot).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([frontmatter/1, metadata/1, content/1, default_renderer/0, render/2, render_with_metadata/2]).
-export_type([renderer/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-type renderer(QYC) :: {renderer,
        fun((gleam@dict:dict(binary(), binary()), gleam@option:option(binary()), binary()) -> QYC),
        fun((list(QYC)) -> QYC),
        fun((gleam@dict:dict(binary(), binary()), integer(), list(QYC)) -> QYC),
        fun((jot:destination(), gleam@dict:dict(binary(), binary()), list(QYC)) -> QYC),
        fun((gleam@dict:dict(binary(), binary()), list(QYC)) -> QYC),
        fun((list(QYC)) -> QYC),
        fun((binary()) -> QYC),
        fun((binary()) -> QYC),
        fun((jot:destination(), binary()) -> QYC),
        QYC,
        QYC}.

-file("src/lustre/ssg/djot.gleam", 135).
?DOC(
    " Extract the frontmatter string from a djot document. Frontmatter is anything\n"
    " between two lines of three dashes, like this:\n"
    "\n"
    " ```djot\n"
    " ---\n"
    " title = \"My Document\"\n"
    " ---\n"
    "\n"
    " # My Document\n"
    "\n"
    " ...\n"
    " ```\n"
    "\n"
    " The document **must** start with exactly three dashes and a newline for there\n"
    " to be any frontmatter. If there is no frontmatter, this function returns\n"
    " `Error(Nil)`,\n"
).
-spec frontmatter(binary()) -> {ok, binary()} | {error, nil}.
frontmatter(Document) ->
    gleam@bool:guard(
        not gleam_stdlib:string_starts_with(Document, <<"---"/utf8>>),
        {error, nil},
        fun() ->
            Options = {options, false, true},
            _assert_subject = gleam@regexp:compile(
                <<"^---\\n[\\s\\S]*?\\n---"/utf8>>,
                Options
            ),
            {ok, Re} = case _assert_subject of
                {ok, _} -> _assert_subject;
                _assert_fail ->
                    erlang:error(#{gleam_error => let_assert,
                                message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                value => _assert_fail,
                                module => <<"lustre/ssg/djot"/utf8>>,
                                function => <<"frontmatter"/utf8>>,
                                line => 138})
            end,
            case gleam@regexp:scan(Re, Document) of
                [{match, Frontmatter, _} | _] ->
                    {ok,
                        begin
                            _pipe = Frontmatter,
                            _pipe@1 = gleam@string:drop_start(_pipe, 4),
                            gleam@string:drop_end(_pipe@1, 4)
                        end};

                _ ->
                    {error, nil}
            end
        end
    ).

-file("src/lustre/ssg/djot.gleam", 157).
?DOC(
    " Extract the TOML metadata from a djot document. This takes the [`frontmatter`](#frontmatter)\n"
    " and parses it as TOML. If there is *no* frontmatter, this function returns\n"
    " an empty dictionary.\n"
    "\n"
    " If the frontmatter is invalid TOML, this function returns a TOML parse error.\n"
).
-spec metadata(binary()) -> {ok, gleam@dict:dict(binary(), tom:toml())} |
    {error, tom:parse_error()}.
metadata(Document) ->
    case frontmatter(Document) of
        {ok, Frontmatter} ->
            tom:parse(Frontmatter);

        {error, _} ->
            {ok, maps:new()}
    end.

-file("src/lustre/ssg/djot.gleam", 167).
?DOC(
    " Extract the djot content from a document with optional frontmatter. If the\n"
    " document does not have frontmatter, this acts as an identity function.\n"
).
-spec content(binary()) -> binary().
content(Document) ->
    Toml = frontmatter(Document),
    case Toml of
        {ok, Toml@1} ->
            gleam@string:replace(
                Document,
                <<<<"---\n"/utf8, Toml@1/binary>>/binary, "\n---"/utf8>>,
                <<""/utf8>>
            );

        {error, _} ->
            Document
    end.

-file("src/lustre/ssg/djot.gleam", 292).
-spec linkify(binary()) -> binary().
linkify(Text) ->
    _assert_subject = gleam@regexp:from_string(<<" +"/utf8>>),
    {ok, Re} = case _assert_subject of
        {ok, _} -> _assert_subject;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        value => _assert_fail,
                        module => <<"lustre/ssg/djot"/utf8>>,
                        function => <<"linkify"/utf8>>,
                        line => 293})
    end,
    _pipe = Text,
    _pipe@1 = gleam@regexp:split(Re, _pipe),
    gleam@string:join(_pipe@1, <<"-"/utf8>>).

-file("src/lustre/ssg/djot.gleam", 58).
?DOC(
    " The default renderer generates some sensible Lustre elements from a djot\n"
    " document. You can use this if you need a quick drop-in renderer for some\n"
    " markup in a Lustre project.\n"
).
-spec default_renderer() -> renderer(lustre@internals@vdom:element(any())).
default_renderer() ->
    To_attributes = fun(Attrs) ->
        gleam@dict:fold(
            Attrs,
            [],
            fun(Attrs@1, Key, Val) ->
                [lustre@attribute:attribute(Key, Val) | Attrs@1]
            end
        )
    end,
    {renderer,
        fun(Attrs@2, Lang, Code) ->
            Lang@1 = gleam@option:unwrap(Lang, <<"text"/utf8>>),
            lustre@element@html:pre(
                To_attributes(Attrs@2),
                [lustre@element@html:code(
                        [lustre@attribute:attribute(
                                <<"data-lang"/utf8>>,
                                Lang@1
                            )],
                        [lustre@element@html:text(Code)]
                    )]
            )
        end,
        fun(Content) -> lustre@element@html:em([], Content) end,
        fun(Attrs@3, Level, Content@1) -> case Level of
                1 ->
                    lustre@element@html:h1(To_attributes(Attrs@3), Content@1);

                2 ->
                    lustre@element@html:h2(To_attributes(Attrs@3), Content@1);

                3 ->
                    lustre@element@html:h3(To_attributes(Attrs@3), Content@1);

                4 ->
                    lustre@element@html:h4(To_attributes(Attrs@3), Content@1);

                5 ->
                    lustre@element@html:h5(To_attributes(Attrs@3), Content@1);

                6 ->
                    lustre@element@html:h6(To_attributes(Attrs@3), Content@1);

                _ ->
                    lustre@element@html:p(To_attributes(Attrs@3), Content@1)
            end end,
        fun(Destination, References, Content@2) -> case Destination of
                {reference, Ref} ->
                    case gleam_stdlib:map_get(References, Ref) of
                        {ok, Url} ->
                            lustre@element@html:a(
                                [lustre@attribute:href(Url)],
                                Content@2
                            );

                        {error, _} ->
                            lustre@element@html:a(
                                [lustre@attribute:href(
                                        <<"#"/utf8, (linkify(Ref))/binary>>
                                    ),
                                    lustre@attribute:id(
                                        linkify(<<"back-to-"/utf8, Ref/binary>>)
                                    )],
                                Content@2
                            )
                    end;

                {url, Url@1} ->
                    lustre@element@html:a(
                        [lustre@attribute:attribute(<<"href"/utf8>>, Url@1)],
                        Content@2
                    )
            end end,
        fun(Attrs@4, Content@3) ->
            lustre@element@html:p(To_attributes(Attrs@4), Content@3)
        end,
        fun(Content@4) -> lustre@element@html:strong([], Content@4) end,
        fun(Text) -> lustre@element@html:text(Text) end,
        fun(Content@5) ->
            lustre@element@html:code([], [lustre@element@html:text(Content@5)])
        end,
        fun(Destination@1, Alt) -> case Destination@1 of
                {reference, Ref@1} ->
                    lustre@element@html:img(
                        [lustre@attribute:src(
                                <<"#"/utf8, (linkify(Ref@1))/binary>>
                            ),
                            lustre@attribute:alt(Alt)]
                    );

                {url, Url@2} ->
                    lustre@element@html:img(
                        [lustre@attribute:src(Url@2), lustre@attribute:alt(Alt)]
                    )
            end end,
        lustre@element@html:br([]),
        lustre@element@html:hr([])}.

-file("src/lustre/ssg/djot.gleam", 300).
-spec text_content(list(jot:inline())) -> binary().
text_content(Segments) ->
    gleam@list:fold(Segments, <<""/utf8>>, fun(Text, Inline) -> case Inline of
                {text, Content} ->
                    <<Text/binary, Content/binary>>;

                {link, Content@1, _} ->
                    <<Text/binary, (text_content(Content@1))/binary>>;

                {emphasis, Content@2} ->
                    <<Text/binary, (text_content(Content@2))/binary>>;

                {strong, Content@3} ->
                    <<Text/binary, (text_content(Content@3))/binary>>;

                {code, Content@4} ->
                    <<Text/binary, Content@4/binary>>;

                {image, _, _} ->
                    Text;

                linebreak ->
                    Text;

                {footnote, _} ->
                    Text
            end end).

-file("src/lustre/ssg/djot.gleam", 246).
-spec render_inline(
    jot:inline(),
    gleam@dict:dict(binary(), binary()),
    renderer(QZC)
) -> QZC.
render_inline(Inline, References, Renderer) ->
    case Inline of
        {text, Text} ->
            (erlang:element(8, Renderer))(Text);

        {link, Content, Destination} ->
            (erlang:element(5, Renderer))(
                Destination,
                References,
                gleam@list:map(
                    Content,
                    fun(_capture) ->
                        render_inline(_capture, References, Renderer)
                    end
                )
            );

        {emphasis, Content@1} ->
            (erlang:element(3, Renderer))(
                gleam@list:map(
                    Content@1,
                    fun(_capture@1) ->
                        render_inline(_capture@1, References, Renderer)
                    end
                )
            );

        {strong, Content@2} ->
            (erlang:element(7, Renderer))(
                gleam@list:map(
                    Content@2,
                    fun(_capture@2) ->
                        render_inline(_capture@2, References, Renderer)
                    end
                )
            );

        {code, Content@3} ->
            (erlang:element(9, Renderer))(Content@3);

        {image, Content@4, Destination@1} ->
            (erlang:element(10, Renderer))(
                Destination@1,
                text_content(Content@4)
            );

        linebreak ->
            erlang:element(11, Renderer);

        {footnote, _} ->
            (erlang:element(8, Renderer))(<<""/utf8>>)
    end.

-file("src/lustre/ssg/djot.gleam", 215).
-spec render_block(
    jot:container(),
    gleam@dict:dict(binary(), binary()),
    renderer(QYY)
) -> QYY.
render_block(Block, References, Renderer) ->
    case Block of
        {paragraph, Attrs, Inline} ->
            (erlang:element(6, Renderer))(
                Attrs,
                gleam@list:map(
                    Inline,
                    fun(_capture) ->
                        render_inline(_capture, References, Renderer)
                    end
                )
            );

        {heading, Attrs@1, Level, Inline@1} ->
            (erlang:element(4, Renderer))(
                Attrs@1,
                Level,
                gleam@list:map(
                    Inline@1,
                    fun(_capture@1) ->
                        render_inline(_capture@1, References, Renderer)
                    end
                )
            );

        {codeblock, Attrs@2, Language, Code} ->
            (erlang:element(2, Renderer))(Attrs@2, Language, Code);

        thematic_break ->
            erlang:element(12, Renderer)
    end.

-file("src/lustre/ssg/djot.gleam", 181).
?DOC(
    " Render a djot document using the given renderer. If the document contains\n"
    " [`frontmatter`](#frontmatter) it is stripped out before rendering.\n"
).
-spec render(binary(), renderer(QYM)) -> list(QYM).
render(Document, Renderer) ->
    Content = content(Document),
    {document, Content@1, References, _} = jot:parse(Content),
    _pipe = Content@1,
    gleam@list:map(
        _pipe,
        fun(_capture) -> render_block(_capture, References, Renderer) end
    ).

-file("src/lustre/ssg/djot.gleam", 195).
?DOC(
    " Render a djot document using the given renderer. TOML metadata is extracted\n"
    " from the document's frontmatter and passed to the renderer. If the frontmatter\n"
    " is invalid TOML this function will return the TOML parse error, but if there\n"
    " is no frontmatter to parse this function will succeed and just pass an empty\n"
    " dictionary to the renderer.\n"
).
-spec render_with_metadata(
    binary(),
    fun((gleam@dict:dict(binary(), tom:toml())) -> renderer(QYR))
) -> {ok, list(QYR)} | {error, tom:parse_error()}.
render_with_metadata(Document, Renderer) ->
    Toml = frontmatter(Document),
    gleam@result:'try'(
        begin
            _pipe = Toml,
            _pipe@1 = gleam@result:unwrap(_pipe, <<""/utf8>>),
            tom:parse(_pipe@1)
        end,
        fun(Metadata) ->
            Content = content(Document),
            Renderer@1 = Renderer(Metadata),
            {document, Content@1, References, _} = jot:parse(Content),
            _pipe@2 = Content@1,
            _pipe@3 = gleam@list:map(
                _pipe@2,
                fun(_capture) ->
                    render_block(_capture, References, Renderer@1)
                end
            ),
            {ok, _pipe@3}
        end
    ).
