-module(arctic@parse).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([get_pos/1, get_metadata/1, get_state/1, with_state/2, new/1, add_inline_rule/4, add_prefix_rule/3, add_static_component/3, add_dynamic_component/2, wrap_inline/1, wrap_inline_with_attributes/2, wrap_prefix/1, wrap_prefix_with_attributes/2, parse/3]).
-export_type([parsed_page/0, parse_result/1, parse_error/0, arctic_parser/1, parse_data/1, position/0, inline_rule/1, prefix_rule/1, component/1, parser_builder/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-type parsed_page() :: {parsed_page,
        gleam@dict:dict(binary(), binary()),
        list(gleam@option:option(lustre@internals@vdom:element(nil)))}.

-type parse_result(WXP) :: {parse_result, WXP, list(parse_error())}.

-type parse_error() :: {parse_error, position(), binary()}.

-type arctic_parser(WXQ) :: {arctic_parser,
        fun((binary(), parse_data(WXQ)) -> parse_result(gleam@option:option({lustre@internals@vdom:element(nil),
            WXQ})))}.

-opaque parse_data(WXR) :: {parse_data,
        position(),
        gleam@dict:dict(binary(), binary()),
        WXR}.

-type position() :: {position, integer(), integer()}.

-type inline_rule(WXS) :: {inline_rule,
        binary(),
        binary(),
        fun((lustre@internals@vdom:element(nil), list(binary()), parse_data(WXS)) -> {ok,
                {lustre@internals@vdom:element(nil), WXS}} |
            {error, snag:snag()})}.

-type prefix_rule(WXT) :: {prefix_rule,
        binary(),
        fun((lustre@internals@vdom:element(nil), parse_data(WXT)) -> {ok,
                {lustre@internals@vdom:element(nil), WXT}} |
            {error, snag:snag()})}.

-type component(WXU) :: {static_component,
        binary(),
        fun((list(binary()), binary(), parse_data(WXU)) -> {ok,
                {lustre@internals@vdom:element(nil), WXU}} |
            {error, snag:snag()})} |
    {dynamic_component, binary()}.

-opaque parser_builder(WXV) :: {parser_builder,
        list(inline_rule(WXV)),
        list(prefix_rule(WXV)),
        list(component(WXV)),
        WXV}.

-file("src/arctic/parse.gleam", 49).
-spec get_pos(parse_data(any())) -> position().
get_pos(Data) ->
    erlang:element(2, Data).

-file("src/arctic/parse.gleam", 53).
-spec get_metadata(parse_data(any())) -> gleam@dict:dict(binary(), binary()).
get_metadata(Data) ->
    erlang:element(3, Data).

-file("src/arctic/parse.gleam", 57).
-spec get_state(parse_data(WYC)) -> WYC.
get_state(Data) ->
    erlang:element(4, Data).

-file("src/arctic/parse.gleam", 61).
-spec with_pos(parse_data(WYE), position()) -> parse_data(WYE).
with_pos(Data, Pos) ->
    {parse_data, Pos, erlang:element(3, Data), erlang:element(4, Data)}.

-file("src/arctic/parse.gleam", 65).
-spec with_state(parse_data(WYH), WYH) -> parse_data(WYH).
with_state(Data, State) ->
    {parse_data, erlang:element(2, Data), erlang:element(3, Data), State}.

-file("src/arctic/parse.gleam", 115).
?DOC(
    " Create a new parser builder, with no rules or components.\n"
    " It only has an initial state.\n"
).
-spec new(WYK) -> parser_builder(WYK).
new(Start_state) ->
    {parser_builder, [], [], [], Start_state}.

-file("src/arctic/parse.gleam", 132).
?DOC(
    " Add an \"inline rule\" to a parser.\n"
    " An inline rule rewrites parts of text paragraphs.\n"
    " For example, `add_inline_rule(\"**\", \"**\", wrap_inline(html.strong))` \n"
    " replaces anything wrapped in double-asterisks with a bolded version of the same text.\n"
    " Note that the rule may fail with a `snag` error, halting the parsing of that paragraph,\n"
    " and that the position in the file is given, so you can produce better `snag` error messages.\n"
    " The rewrite might also be given parameters, allowing for something like\n"
    " `[here](https://example.com) is a link`\n"
).
-spec add_inline_rule(
    parser_builder(WYM),
    binary(),
    binary(),
    fun((lustre@internals@vdom:element(nil), list(binary()), parse_data(WYM)) -> {ok,
            {lustre@internals@vdom:element(nil), WYM}} |
        {error, snag:snag()})
) -> parser_builder(WYM).
add_inline_rule(P, Left, Right, Action) ->
    {parser_builder,
        [{inline_rule, Left, Right, Action} | erlang:element(2, P)],
        erlang:element(3, P),
        erlang:element(4, P),
        erlang:element(5, P)}.

-file("src/arctic/parse.gleam", 153).
?DOC(
    " Add a \"prefix rule\" to a parser.\n"
    " A prefix rule rewrites a whole paragraph based on symbols at the beginning.\n"
    " For example, `add_prefix_rule(\"#\", wrap_prefix(html.h1))` \n"
    " replaces anything that starts with a hashtag with a header of the same text.\n"
    " Note that the rule may fail with a `snag` error, halting the parsing of that paragraph,\n"
    " and that the position in the file is given, so you can produce better `snag` error messages.\n"
).
-spec add_prefix_rule(
    parser_builder(WYU),
    binary(),
    fun((lustre@internals@vdom:element(nil), parse_data(WYU)) -> {ok,
            {lustre@internals@vdom:element(nil), WYU}} |
        {error, snag:snag()})
) -> parser_builder(WYU).
add_prefix_rule(P, Prefix, Action) ->
    {parser_builder,
        erlang:element(2, P),
        [{prefix_rule, Prefix, Action} | erlang:element(3, P)],
        erlang:element(4, P),
        erlang:element(5, P)}.

-file("src/arctic/parse.gleam", 180).
?DOC(
    " Add a \"static component\" to a parser.\n"
    " A static component is a component (imagine a DSL) that doesn't need MVC interactivity.\n"
    " You just specify how it gets turned into HTML,\n"
    " and Arctic turns it into HTML.\n"
    " In your Arctic markup file, you write \n"
    " ```\n"
    " @component_name(an arg, another arg)\n"
    " A bunch\n"
    " of content\n"
    " ```\n"
    " Arctic will parse the body until the first blank line, then apply your given action to the parameters and body.\n"
    " This allows you to embed languages in Arctic markup files, like latex or HTML.\n"
    " Note that the component may fail with a `snag` error, halting the parsing of that paragraph,\n"
    " and that the position in the file is given, so you can produce better `snag` error messages.\n"
).
-spec add_static_component(
    parser_builder(WZB),
    binary(),
    fun((list(binary()), binary(), parse_data(WZB)) -> {ok,
            {lustre@internals@vdom:element(nil), WZB}} |
        {error, snag:snag()})
) -> parser_builder(WZB).
add_static_component(P, Name, Action) ->
    {parser_builder,
        erlang:element(2, P),
        erlang:element(3, P),
        [{static_component, Name, Action} | erlang:element(4, P)],
        erlang:element(5, P)}.

-file("src/arctic/parse.gleam", 209).
?DOC(
    " Add a \"dynamic component\" to a parser.\n"
    " A dynamic component is a component (imagine a DSL) that needs MVC interactivity.\n"
    " You will need to separately register a Lustre component of the same name;\n"
    " this is just the way that you put it into your site from an Arctic markup file.\n"
    " In your Arctic markup file, you would write\n"
    " ```\n"
    " @component_name(an arg, another arg)\n"
    " A bunch\n"
    " of content\n"
    " ```\n"
    " Arctic will parse the body until the first blank line.\n"
    " Then the produced HTML is\n"
    " ```\n"
    " <component_name data-parameters=\"an arg,another arg\" data-body=\"A bunch\\nof content\">\n"
    " </component_name>\n"
    " ```\n"
).
-spec add_dynamic_component(parser_builder(WZI), binary()) -> parser_builder(WZI).
add_dynamic_component(P, Name) ->
    {parser_builder,
        erlang:element(2, P),
        erlang:element(3, P),
        [{dynamic_component, Name} | erlang:element(4, P)],
        erlang:element(5, P)}.

-file("src/arctic/parse.gleam", 303).
?DOC(
    " A convenience function for inline rules that just put content in an element.\n"
    " For example, `wrap_inline(html.i)` italicizes.\n"
).
-spec wrap_inline(
    fun((list(lustre@internals@vdom:attribute(any())), list(lustre@internals@vdom:element(nil))) -> lustre@internals@vdom:element(nil))
) -> fun((lustre@internals@vdom:element(nil), any(), parse_data(XHX)) -> {ok,
        {lustre@internals@vdom:element(nil), XHX}} |
    {error, any()}).
wrap_inline(W) ->
    fun(El, _, Data) -> {ok, {W([], [El]), get_state(Data)}} end.

-file("src/arctic/parse.gleam", 313).
?DOC(
    " A convenience function for inline rules that just put content in an element \n"
    " and give the element some parameters.\n"
    " For example, `wrap_inline(html.a, [attribute.src(\"https://arctic-framework.org\")])`\n"
    " makes something a link to arctic-framework.org.\n"
).
-spec wrap_inline_with_attributes(
    fun((list(lustre@internals@vdom:attribute(WZV)), list(lustre@internals@vdom:element(nil))) -> lustre@internals@vdom:element(nil)),
    list(lustre@internals@vdom:attribute(WZV))
) -> fun((lustre@internals@vdom:element(nil), any(), parse_data(XIE)) -> {ok,
        {lustre@internals@vdom:element(nil), XIE}} |
    {error, any()}).
wrap_inline_with_attributes(W, Attrs) ->
    fun(El, _, Data) -> {ok, {W(Attrs, [El]), get_state(Data)}} end.

-file("src/arctic/parse.gleam", 322).
?DOC(
    " A convenience function for prefix rules that just put content in an element\n"
    " For example, `wrap_prefix(html.h1)` makes a paragraph a header.\n"
).
-spec wrap_prefix(
    fun((list(lustre@internals@vdom:attribute(any())), list(lustre@internals@vdom:element(nil))) -> lustre@internals@vdom:element(nil))
) -> fun((lustre@internals@vdom:element(nil), parse_data(XIL)) -> {ok,
        {lustre@internals@vdom:element(nil), XIL}} |
    {error, any()}).
wrap_prefix(W) ->
    fun(El, Data) -> {ok, {W([], [El]), get_state(Data)}} end.

-file("src/arctic/parse.gleam", 332).
?DOC(
    " A convenience function for prefix rules that just put content in an element \n"
    " and give the element some parameters.\n"
    " For example, `wrap_prefix(html.a, [attribute.src(\"https://arctic-framework.org\")])`\n"
    " makes a paragraph a link to arctic-framework.org.\n"
).
-spec wrap_prefix_with_attributes(
    fun((list(lustre@internals@vdom:attribute(XAL)), list(lustre@internals@vdom:element(nil))) -> lustre@internals@vdom:element(nil)),
    list(lustre@internals@vdom:attribute(XAL))
) -> fun((lustre@internals@vdom:element(nil), parse_data(XIR)) -> {ok,
        {lustre@internals@vdom:element(nil), XIR}} |
    {error, any()}).
wrap_prefix_with_attributes(W, Attrs) ->
    fun(El, Data) -> {ok, {W(Attrs, [El]), get_state(Data)}} end.

-file("src/arctic/parse.gleam", 339).
-spec parse_metadata(gleam@dict:dict(binary(), binary())) -> party:parser(gleam@dict:dict(binary(), binary()), snag:snag()).
parse_metadata(Start_dict) ->
    party:do(
        party:perhaps(party:satisfy(fun(C) -> C /= <<"\n"/utf8>> end)),
        fun(Res) -> case Res of
                {ok, Key_first} ->
                    party:do(
                        party:until(
                            party:satisfy(fun(_) -> true end),
                            party:seq(
                                party:whitespace(),
                                party:char(<<":"/utf8>>)
                            )
                        ),
                        fun(Key_rest) ->
                            party:do(
                                party:whitespace(),
                                fun(_) ->
                                    party:do(
                                        party:until(
                                            party:satisfy(fun(_) -> true end),
                                            party:char(<<"\n"/utf8>>)
                                        ),
                                        fun(Val) ->
                                            Key_str = gleam@string:concat(
                                                [Key_first | Key_rest]
                                            ),
                                            Val_str = gleam@string:concat(Val),
                                            D = gleam@dict:insert(
                                                Start_dict,
                                                Key_str,
                                                Val_str
                                            ),
                                            parse_metadata(D)
                                        end
                                    )
                                end
                            )
                        end
                    );

                {error, nil} ->
                    party:return(Start_dict)
            end end
    ).

-file("src/arctic/parse.gleam", 365).
-spec parse_prefix() -> party:parser(binary(), snag:snag()).
parse_prefix() ->
    party:many_concat(
        party:satisfy(
            fun(_capture) ->
                gleam_stdlib:contains_string(
                    <<"~`!#$%^&*-_=+{[|;:<>,./?]}"/utf8>>,
                    _capture
                )
            end
        )
    ).

-file("src/arctic/parse.gleam", 374).
-spec escaped_char() -> party:parser(binary(), snag:snag()).
escaped_char() ->
    party:do(
        party:char(<<"\\"/utf8>>),
        fun(_) ->
            party:do(party:satisfy(fun(_) -> true end), fun(C) -> case C of
                        <<"n"/utf8>> ->
                            party:return(<<"\n"/utf8>>);

                        <<"t"/utf8>> ->
                            party:return(<<"\t"/utf8>>);

                        <<"f"/utf8>> ->
                            party:return(<<"\f"/utf8>>);

                        <<"r"/utf8>> ->
                            party:return(<<"\r"/utf8>>);

                        <<"u"/utf8>> ->
                            party:do(
                                party:char(<<"{"/utf8>>),
                                fun(_) ->
                                    party:do(
                                        party:whitespace(),
                                        fun(_) ->
                                            party:do(
                                                party:many1_concat(
                                                    party:satisfy(
                                                        fun(_capture) ->
                                                            gleam_stdlib:contains_string(
                                                                <<"1234567890abcdefABCDEF"/utf8>>,
                                                                _capture
                                                            )
                                                        end
                                                    )
                                                ),
                                                fun(Code_str) ->
                                                    party:do(
                                                        party:whitespace(),
                                                        fun(_) ->
                                                            party:do(
                                                                party:char(
                                                                    <<"}"/utf8>>
                                                                ),
                                                                fun(_) ->
                                                                    _assert_subject = gleam@int:base_parse(
                                                                        Code_str,
                                                                        16
                                                                    ),
                                                                    {ok, Code} = case _assert_subject of
                                                                        {ok, _} -> _assert_subject;
                                                                        _assert_fail ->
                                                                            erlang:error(
                                                                                    #{gleam_error => let_assert,
                                                                                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                                                                        value => _assert_fail,
                                                                                        module => <<"arctic/parse"/utf8>>,
                                                                                        function => <<"escaped_char"/utf8>>,
                                                                                        line => 396}
                                                                                )
                                                                    end,
                                                                    party:do(
                                                                        party:'try'(
                                                                            party:return(
                                                                                nil
                                                                            ),
                                                                            fun(
                                                                                _
                                                                            ) ->
                                                                                _pipe = gleam@string:utf_codepoint(
                                                                                    Code
                                                                                ),
                                                                                gleam@result:map_error(
                                                                                    _pipe,
                                                                                    fun(
                                                                                        _
                                                                                    ) ->
                                                                                        snag:new(
                                                                                            <<<<"unknown unicode codepoint `\\u{"/utf8,
                                                                                                    Code_str/binary>>/binary,
                                                                                                "}"/utf8>>
                                                                                        )
                                                                                    end
                                                                                )
                                                                            end
                                                                        ),
                                                                        fun(
                                                                            Codepoint
                                                                        ) ->
                                                                            party:return(
                                                                                gleam_stdlib:utf_codepoint_list_to_string(
                                                                                    [Codepoint]
                                                                                )
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
                                    )
                                end
                            );

                        _ ->
                            party:return(C)
                    end end)
        end
    ).

-file("src/arctic/parse.gleam", 467).
-spec invert_res({ok, {XNR, XNK}} | {error, XNO}, parse_data(XNK)) -> {{ok, XNR} |
        {error, XNO},
    parse_data(XNK)}.
invert_res(Res, D) ->
    case Res of
        {ok, {El, State}} ->
            {{ok, El},
                begin
                    _pipe = D,
                    with_state(_pipe, State)
                end};

        {error, S} ->
            {{error, S}, D}
    end.

-file("src/arctic/parse.gleam", 580).
-spec parse_component(list(component(XCI))) -> arctic_parser(XCI).
parse_component(Components) ->
    {arctic_parser,
        fun(Src, Data) ->
            Pos = get_pos(Data),
            Res@1 = party:go(
                begin
                    party:do(
                        party:char(<<"@"/utf8>>),
                        fun(_) ->
                            party:choice(
                                gleam@list:map(
                                    Components,
                                    fun(Component) ->
                                        party:do(
                                            party:string(
                                                erlang:element(2, Component)
                                            ),
                                            fun(_) ->
                                                party:do(
                                                    party:many(
                                                        party:either(
                                                            party:char(
                                                                <<" "/utf8>>
                                                            ),
                                                            party:char(
                                                                <<"\t"/utf8>>
                                                            )
                                                        )
                                                    ),
                                                    fun(_) ->
                                                        party:do(
                                                            party:perhaps(
                                                                party:char(
                                                                    <<"("/utf8>>
                                                                )
                                                            ),
                                                            fun(Res) ->
                                                                party:do(
                                                                    case Res of
                                                                        {ok, _} ->
                                                                            party:do(
                                                                                party:whitespace(
                                                                                    
                                                                                ),
                                                                                fun(
                                                                                    _
                                                                                ) ->
                                                                                    party:do(
                                                                                        party:sep(
                                                                                            party:many1_concat(
                                                                                                party:satisfy(
                                                                                                    fun(
                                                                                                        C
                                                                                                    ) ->
                                                                                                        (C
                                                                                                        /= <<","/utf8>>)
                                                                                                        andalso (C
                                                                                                        /= <<")"/utf8>>)
                                                                                                    end
                                                                                                )
                                                                                            ),
                                                                                            party:all(
                                                                                                [party:whitespace(
                                                                                                        
                                                                                                    ),
                                                                                                    party:char(
                                                                                                        <<","/utf8>>
                                                                                                    ),
                                                                                                    party:whitespace(
                                                                                                        
                                                                                                    )]
                                                                                            )
                                                                                        ),
                                                                                        fun(
                                                                                            A
                                                                                        ) ->
                                                                                            party:do(
                                                                                                party:whitespace(
                                                                                                    
                                                                                                ),
                                                                                                fun(
                                                                                                    _
                                                                                                ) ->
                                                                                                    party:do(
                                                                                                        party:char(
                                                                                                            <<")"/utf8>>
                                                                                                        ),
                                                                                                        fun(
                                                                                                            _
                                                                                                        ) ->
                                                                                                            party:return(
                                                                                                                A
                                                                                                            )
                                                                                                        end
                                                                                                    )
                                                                                                end
                                                                                            )
                                                                                        end
                                                                                    )
                                                                                end
                                                                            );

                                                                        {error,
                                                                            nil} ->
                                                                            party:return(
                                                                                []
                                                                            )
                                                                    end,
                                                                    fun(Args) ->
                                                                        party:do(
                                                                            party:many(
                                                                                party:either(
                                                                                    party:char(
                                                                                        <<" "/utf8>>
                                                                                    ),
                                                                                    party:char(
                                                                                        <<"\t"/utf8>>
                                                                                    )
                                                                                )
                                                                            ),
                                                                            fun(
                                                                                _
                                                                            ) ->
                                                                                party:do(
                                                                                    party:char(
                                                                                        <<"\n"/utf8>>
                                                                                    ),
                                                                                    fun(
                                                                                        _
                                                                                    ) ->
                                                                                        party:do(
                                                                                            party:until(
                                                                                                party:satisfy(
                                                                                                    fun(
                                                                                                        _
                                                                                                    ) ->
                                                                                                        true
                                                                                                    end
                                                                                                ),
                                                                                                party:'end'(
                                                                                                    
                                                                                                )
                                                                                            ),
                                                                                            fun(
                                                                                                Body
                                                                                            ) ->
                                                                                                case Component of
                                                                                                    {static_component,
                                                                                                        _,
                                                                                                        Action} ->
                                                                                                        party:do(
                                                                                                            party:pos(
                                                                                                                
                                                                                                            ),
                                                                                                            fun(
                                                                                                                Party_pos
                                                                                                            ) ->
                                                                                                                Data2 = begin
                                                                                                                    _pipe = Data,
                                                                                                                    with_pos(
                                                                                                                        _pipe,
                                                                                                                        {position,
                                                                                                                            erlang:element(
                                                                                                                                2,
                                                                                                                                Pos
                                                                                                                            )
                                                                                                                            + erlang:element(
                                                                                                                                2,
                                                                                                                                Party_pos
                                                                                                                            ),
                                                                                                                            erlang:element(
                                                                                                                                3,
                                                                                                                                Pos
                                                                                                                            )
                                                                                                                            + erlang:element(
                                                                                                                                3,
                                                                                                                                Party_pos
                                                                                                                            )}
                                                                                                                    )
                                                                                                                end,
                                                                                                                party:do(
                                                                                                                    party:'try'(
                                                                                                                        party:return(
                                                                                                                            nil
                                                                                                                        ),
                                                                                                                        fun(
                                                                                                                            _
                                                                                                                        ) ->
                                                                                                                            Action(
                                                                                                                                Args,
                                                                                                                                gleam@string:concat(
                                                                                                                                    Body
                                                                                                                                ),
                                                                                                                                Data2
                                                                                                                            )
                                                                                                                        end
                                                                                                                    ),
                                                                                                                    fun(
                                                                                                                        El
                                                                                                                    ) ->
                                                                                                                        party:return(
                                                                                                                            {some,
                                                                                                                                El}
                                                                                                                        )
                                                                                                                    end
                                                                                                                )
                                                                                                            end
                                                                                                        );

                                                                                                    {dynamic_component,
                                                                                                        _} ->
                                                                                                        party:return(
                                                                                                            {some,
                                                                                                                {lustre@element:element(
                                                                                                                        erlang:element(
                                                                                                                            2,
                                                                                                                            Component
                                                                                                                        ),
                                                                                                                        [lustre@attribute:attribute(
                                                                                                                                <<"data-parameters"/utf8>>,
                                                                                                                                gleam@string:join(
                                                                                                                                    Args,
                                                                                                                                    <<","/utf8>>
                                                                                                                                )
                                                                                                                            ),
                                                                                                                            lustre@attribute:attribute(
                                                                                                                                <<"data-body"/utf8>>,
                                                                                                                                gleam@string:concat(
                                                                                                                                    Body
                                                                                                                                )
                                                                                                                            )],
                                                                                                                        []
                                                                                                                    ),
                                                                                                                    get_state(
                                                                                                                        Data
                                                                                                                    )}}
                                                                                                        )
                                                                                                end
                                                                                            end
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
                                                )
                                            end
                                        )
                                    end
                                )
                            )
                        end
                    )
                end,
                Src
            ),
            case Res@1 of
                {ok, T} ->
                    {parse_result, T, []};

                {error, Err} ->
                    case Err of
                        {unexpected, Party_pos@1, S} ->
                            {parse_result,
                                none,
                                [{parse_error,
                                        {position,
                                            erlang:element(2, Pos) + erlang:element(
                                                2,
                                                Party_pos@1
                                            ),
                                            erlang:element(3, Pos) + erlang:element(
                                                3,
                                                Party_pos@1
                                            )},
                                        S}]};

                        {user_error, Party_pos@2, Err@1} ->
                            {parse_result,
                                none,
                                [{parse_error,
                                        {position,
                                            erlang:element(2, Pos) + erlang:element(
                                                2,
                                                Party_pos@2
                                            ),
                                            erlang:element(3, Pos) + erlang:element(
                                                3,
                                                Party_pos@2
                                            )},
                                        erlang:element(2, Err@1)}]}
                    end
            end
        end}.

-file("src/arctic/parse.gleam", 411).
-spec parse_inline_rule(list(inline_rule(XBE)), parse_data(XBE)) -> party:parser(fun((parse_data(XBE)) -> {{ok,
            lustre@internals@vdom:element(nil)} |
        {error, snag:snag()},
    parse_data(XBE)}), snag:snag()).
parse_inline_rule(Inline_rules, Data) ->
    party:choice(
        gleam@list:map(
            Inline_rules,
            fun(Rule) ->
                party:do(
                    party:string(erlang:element(2, Rule)),
                    fun(_) ->
                        party:do(
                            party:pos(),
                            fun(Party_pos) ->
                                Pos = get_pos(Data),
                                Data2 = begin
                                    _pipe = Data,
                                    with_pos(
                                        _pipe,
                                        {position,
                                            erlang:element(2, Pos) + erlang:element(
                                                2,
                                                Party_pos
                                            ),
                                            erlang:element(3, Pos) + erlang:element(
                                                3,
                                                Party_pos
                                            )}
                                    )
                                end,
                                party:do(
                                    party:'try'(
                                        party:lazy(
                                            fun() ->
                                                parse_markup(
                                                    Inline_rules,
                                                    party:map(
                                                        party:string(
                                                            erlang:element(
                                                                3,
                                                                Rule
                                                            )
                                                        ),
                                                        fun(_) -> nil end
                                                    ),
                                                    Data2
                                                )
                                            end
                                        ),
                                        fun(A) -> A end
                                    ),
                                    fun(_use0) ->
                                        {Middle, Data3} = _use0,
                                        party:do(
                                            party:string(
                                                erlang:element(3, Rule)
                                            ),
                                            fun(_) ->
                                                party:do(
                                                    party:perhaps(
                                                        party:char(<<"("/utf8>>)
                                                    ),
                                                    fun(Res) ->
                                                        party:do(case Res of
                                                                {ok, _} ->
                                                                    party:do(
                                                                        party:sep(
                                                                            party:many_concat(
                                                                                party:either(
                                                                                    escaped_char(
                                                                                        
                                                                                    ),
                                                                                    party:satisfy(
                                                                                        fun(
                                                                                            C
                                                                                        ) ->
                                                                                            (C
                                                                                            /= <<","/utf8>>)
                                                                                            andalso (C
                                                                                            /= <<")"/utf8>>)
                                                                                        end
                                                                                    )
                                                                                )
                                                                            ),
                                                                            party:char(
                                                                                <<","/utf8>>
                                                                            )
                                                                        ),
                                                                        fun(
                                                                            Args
                                                                        ) ->
                                                                            party:do(
                                                                                party:char(
                                                                                    <<")"/utf8>>
                                                                                ),
                                                                                fun(
                                                                                    _
                                                                                ) ->
                                                                                    party:return(
                                                                                        Args
                                                                                    )
                                                                                end
                                                                            )
                                                                        end
                                                                    );

                                                                {error, nil} ->
                                                                    party:return(
                                                                        []
                                                                    )
                                                            end, fun(Args@1) ->
                                                                party:return(
                                                                    fun(D) ->
                                                                        D2 = with_pos(
                                                                            D,
                                                                            get_pos(
                                                                                Data3
                                                                            )
                                                                        ),
                                                                        invert_res(
                                                                            (erlang:element(
                                                                                4,
                                                                                Rule
                                                                            ))(
                                                                                Middle,
                                                                                Args@1,
                                                                                D2
                                                                            ),
                                                                            D2
                                                                        )
                                                                    end
                                                                )
                                                            end)
                                                    end
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
        )
    ).

-file("src/arctic/parse.gleam", 474).
-spec parse_markup(
    list(inline_rule(XBR)),
    party:parser(nil, snag:snag()),
    parse_data(XBR)
) -> party:parser({ok, {lustre@internals@vdom:element(nil), parse_data(XBR)}} |
    {error, snag:snag()}, snag:snag()).
parse_markup(Inline_rules, Terminator, Data) ->
    _pipe = party:choice(
        [parse_inline_rule(Inline_rules, Data),
            party:map(
                escaped_char(),
                fun(C) -> fun(D) -> {{ok, lustre@element:text(C)}, D} end end
            ),
            begin
                party:do(
                    party:'not'(Terminator),
                    fun(_) ->
                        party:do(
                            party:satisfy(fun(_) -> true end),
                            fun(C@1) ->
                                party:return(
                                    fun(D@1) ->
                                        {{ok, lustre@element:text(C@1)}, D@1}
                                    end
                                )
                            end
                        )
                    end
                )
            end]
    ),
    _pipe@1 = party:stateful_many(Data, _pipe),
    party:map(
        _pipe@1,
        fun(Pair) ->
            {Results, Last_data} = Pair,
            gleam@result:'try'(
                gleam@result:all(Results),
                fun(Parts) ->
                    {ok, {lustre@element@html:span([], Parts), Last_data}}
                end
            )
        end
    ).

-file("src/arctic/parse.gleam", 496).
-spec parse_text(list(inline_rule(XCC)), list(prefix_rule(XCC))) -> arctic_parser(XCC).
parse_text(Inline_rules, Prefix_rules) ->
    {arctic_parser,
        fun(Src, Data) ->
            Pos = get_pos(Data),
            Res@1 = party:go(
                begin
                    party:do(
                        parse_prefix(),
                        fun(Prefix) ->
                            party:do(
                                party:many(
                                    party:either(
                                        party:char(<<" "/utf8>>),
                                        party:char(<<"\t"/utf8>>)
                                    )
                                ),
                                fun(_) ->
                                    party:do(
                                        party:pos(),
                                        fun(Party_pos) ->
                                            Data2 = begin
                                                _pipe = Data,
                                                with_pos(
                                                    _pipe,
                                                    {position,
                                                        erlang:element(2, Pos) + erlang:element(
                                                            2,
                                                            Party_pos
                                                        ),
                                                        erlang:element(3, Pos) + erlang:element(
                                                            3,
                                                            Party_pos
                                                        )}
                                                )
                                            end,
                                            party:do(
                                                parse_markup(
                                                    Inline_rules,
                                                    party:'end'(),
                                                    Data2
                                                ),
                                                fun(Res) ->
                                                    party:do(
                                                        party:'try'(
                                                            party:return(nil),
                                                            fun(_) -> Res end
                                                        ),
                                                        fun(_use0) ->
                                                            {Rest, Data3} = _use0,
                                                            party:do(
                                                                case gleam@list:find(
                                                                    Prefix_rules,
                                                                    fun(Rule) ->
                                                                        erlang:element(
                                                                            2,
                                                                            Rule
                                                                        )
                                                                        =:= Prefix
                                                                    end
                                                                ) of
                                                                    {ok, Rule@1} ->
                                                                        party:do(
                                                                            party:pos(
                                                                                
                                                                            ),
                                                                            fun(
                                                                                Party_pos@1
                                                                            ) ->
                                                                                Data4 = begin
                                                                                    _pipe@1 = Data3,
                                                                                    with_pos(
                                                                                        _pipe@1,
                                                                                        {position,
                                                                                            erlang:element(
                                                                                                2,
                                                                                                Pos
                                                                                            )
                                                                                            + erlang:element(
                                                                                                2,
                                                                                                Party_pos@1
                                                                                            ),
                                                                                            erlang:element(
                                                                                                3,
                                                                                                Pos
                                                                                            )
                                                                                            + erlang:element(
                                                                                                3,
                                                                                                Party_pos@1
                                                                                            )}
                                                                                    )
                                                                                end,
                                                                                party:do(
                                                                                    party:'try'(
                                                                                        party:return(
                                                                                            nil
                                                                                        ),
                                                                                        fun(
                                                                                            _
                                                                                        ) ->
                                                                                            (erlang:element(
                                                                                                3,
                                                                                                Rule@1
                                                                                            ))(
                                                                                                Rest,
                                                                                                Data4
                                                                                            )
                                                                                        end
                                                                                    ),
                                                                                    fun(
                                                                                        El
                                                                                    ) ->
                                                                                        party:return(
                                                                                            El
                                                                                        )
                                                                                    end
                                                                                )
                                                                            end
                                                                        );

                                                                    {error, nil} ->
                                                                        party:return(
                                                                            {lustre@element@html:p(
                                                                                    [],
                                                                                    [lustre@element:text(
                                                                                            Prefix
                                                                                        ),
                                                                                        Rest]
                                                                                ),
                                                                                get_state(
                                                                                    Data3
                                                                                )}
                                                                        )
                                                                end,
                                                                fun(El@1) ->
                                                                    party:return(
                                                                        {some,
                                                                            El@1}
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
                            )
                        end
                    )
                end,
                Src
            ),
            case Res@1 of
                {ok, T} ->
                    {parse_result, T, []};

                {error, Err} ->
                    case Err of
                        {unexpected, Party_pos@2, S} ->
                            {parse_result,
                                none,
                                [{parse_error,
                                        {position,
                                            erlang:element(2, Party_pos@2) + erlang:element(
                                                2,
                                                Pos
                                            ),
                                            erlang:element(3, Party_pos@2) + erlang:element(
                                                3,
                                                Pos
                                            )},
                                        S}]};

                        {user_error, Party_pos@3, Err@1} ->
                            {parse_result,
                                none,
                                [{parse_error,
                                        {position,
                                            erlang:element(2, Party_pos@3) + erlang:element(
                                                2,
                                                Pos
                                            ),
                                            erlang:element(3, Party_pos@3) + erlang:element(
                                                3,
                                                Pos
                                            )},
                                        erlang:element(2, Err@1)}]}
                    end
            end
        end}.

-file("src/arctic/parse.gleam", 691).
-spec parse_page(parser_builder(any()), binary()) -> {ok,
        parse_result(parsed_page())} |
    {error, snag:snag()}.
parse_page(Builder, Src) ->
    Graphemes = gleam@string:to_graphemes(Src),
    {Last_sec, Sections_rev, Last_sec_line, _, _} = gleam@list:fold(
        Graphemes,
        {<<""/utf8>>, [], 0, 0, false},
        fun(So_far, C) ->
            {Sec, Secs, Sec_line, Curr_line, Was_newline} = So_far,
            case C of
                <<"\n"/utf8>> when Was_newline ->
                    {<<""/utf8>>,
                        [{Sec_line, Sec} | Secs],
                        Curr_line + 1,
                        Curr_line + 1,
                        true};

                <<"\n"/utf8>> ->
                    {<<Sec/binary, "\n"/utf8>>,
                        Secs,
                        Sec_line,
                        Curr_line + 1,
                        true};

                _ ->
                    {<<Sec/binary, C/binary>>, Secs, Sec_line, Curr_line, false}
            end
        end
    ),
    Sections = case Last_sec of
        <<""/utf8>> ->
            lists:reverse(Sections_rev);

        _ ->
            lists:reverse([{Last_sec_line, Last_sec} | Sections_rev])
    end,
    gleam@result:'try'(case Sections of
            [] ->
                snag:error(<<"empty page"/utf8>>);

            [H | T] ->
                {ok, {H, T}}
        end, fun(_use0) ->
            {{_, Meta_sec}, Body} = _use0,
            Meta_res = party:go(parse_metadata(maps:new()), Meta_sec),
            Metadata = case Meta_res of
                {ok, Sec@1} ->
                    {parse_result, Sec@1, []};

                {error, Err} ->
                    case Err of
                        {unexpected, Pos, S} ->
                            {parse_result,
                                maps:new(),
                                [{parse_error,
                                        {position,
                                            erlang:element(2, Pos),
                                            erlang:element(3, Pos)},
                                        S}]};

                        {user_error, Pos@1, Err@1} ->
                            {parse_result,
                                maps:new(),
                                [{parse_error,
                                        {position,
                                            erlang:element(2, Pos@1),
                                            erlang:element(3, Pos@1)},
                                        erlang:element(2, Err@1)}]}
                    end
            end,
            Id = begin
                _pipe = erlang:element(2, Metadata),
                _pipe@1 = gleam_stdlib:map_get(_pipe, <<"id"/utf8>>),
                gleam@result:unwrap(_pipe@1, <<"[no id]"/utf8>>)
            end,
            gleam_stdlib:print(
                <<<<"Starting `"/utf8, Id/binary>>/binary, "`. "/utf8>>
            ),
            {_, Body_rev_res} = gleam@list:fold(
                Body,
                {erlang:element(5, Builder), []},
                fun(So_far@1, Sec@2) ->
                    {State, Body_rev} = So_far@1,
                    {Line, Str} = Sec@2,
                    Res = case gleam_stdlib:string_starts_with(
                        Str,
                        <<"@"/utf8>>
                    ) of
                        true ->
                            (erlang:element(
                                2,
                                parse_component(erlang:element(4, Builder))
                            ))(
                                Str,
                                {parse_data,
                                    {position, Line, 0},
                                    erlang:element(2, Metadata),
                                    State}
                            );

                        false ->
                            (erlang:element(
                                2,
                                parse_text(
                                    erlang:element(2, Builder),
                                    erlang:element(3, Builder)
                                )
                            ))(
                                Str,
                                {parse_data,
                                    {position, Line, 0},
                                    erlang:element(2, Metadata),
                                    State}
                            )
                    end,
                    New_state = case erlang:element(2, Res) of
                        {some, {_, S@1}} ->
                            S@1;

                        none ->
                            State
                    end,
                    {New_state, [Res | Body_rev]}
                end
            ),
            {Body_ast, Body_errors} = gleam@list:fold(
                Body_rev_res,
                {[], []},
                fun(So_far@2, Res@1) ->
                    {Ast_so_far, Errors_so_far} = So_far@2,
                    Val = gleam@option:map(
                        erlang:element(2, Res@1),
                        fun(Pair) -> erlang:element(1, Pair) end
                    ),
                    {[Val | Ast_so_far],
                        lists:append(erlang:element(3, Res@1), Errors_so_far)}
                end
            ),
            gleam_stdlib:println(
                <<<<"Finished `"/utf8, Id/binary>>/binary, "`."/utf8>>
            ),
            {ok,
                {parse_result,
                    {parsed_page, erlang:element(2, Metadata), Body_ast},
                    lists:append(erlang:element(3, Metadata), Body_errors)}}
        end).

-file("src/arctic/parse.gleam", 222).
?DOC(" Apply a given parser to a given string.\n").
-spec parse(parser_builder(any()), binary(), binary()) -> {ok, arctic:page()} |
    {error, snag:snag()}.
parse(P, Src_name, Src) ->
    gleam@result:'try'(
        parse_page(P, Src),
        fun(Parsed) -> case erlang:element(3, Parsed) of
                [First_e | Rest] ->
                    snag:error(
                        <<<<<<<<"parse errors in `"/utf8, Src_name/binary>>/binary,
                                    "` ("/utf8>>/binary,
                                (gleam@list:fold(
                                    Rest,
                                    <<<<<<<<<<"unexpected "/utf8,
                                                        (erlang:element(
                                                            3,
                                                            First_e
                                                        ))/binary>>/binary,
                                                    " at "/utf8>>/binary,
                                                (erlang:integer_to_binary(
                                                    erlang:element(
                                                        2,
                                                        erlang:element(
                                                            2,
                                                            First_e
                                                        )
                                                    )
                                                ))/binary>>/binary,
                                            ":"/utf8>>/binary,
                                        (erlang:integer_to_binary(
                                            erlang:element(
                                                3,
                                                erlang:element(2, First_e)
                                            )
                                        ))/binary>>,
                                    fun(S, E) ->
                                        <<<<<<<<<<<<S/binary,
                                                                ", unexpected "/utf8>>/binary,
                                                            (erlang:element(
                                                                3,
                                                                E
                                                            ))/binary>>/binary,
                                                        " at "/utf8>>/binary,
                                                    (erlang:integer_to_binary(
                                                        erlang:element(
                                                            2,
                                                            erlang:element(2, E)
                                                        )
                                                    ))/binary>>/binary,
                                                ":"/utf8>>/binary,
                                            (erlang:integer_to_binary(
                                                erlang:element(
                                                    3,
                                                    erlang:element(2, E)
                                                )
                                            ))/binary>>
                                    end
                                ))/binary>>/binary,
                            ")"/utf8>>
                    );

                [] ->
                    gleam@result:'try'(
                        begin
                            _pipe = gleam_stdlib:map_get(
                                erlang:element(2, erlang:element(2, Parsed)),
                                <<"id"/utf8>>
                            ),
                            gleam@result:map_error(
                                _pipe,
                                fun(_) ->
                                    snag:new(<<"no `id` field present"/utf8>>)
                                end
                            )
                        end,
                        fun(Id) ->
                            gleam@result:'try'(
                                case gleam_stdlib:map_get(
                                    erlang:element(2, erlang:element(2, Parsed)),
                                    <<"date"/utf8>>
                                ) of
                                    {ok, S@1} ->
                                        gleam@result:'try'(
                                            arctic:parse_date(S@1),
                                            fun(D) -> {ok, {some, D}} end
                                        );

                                    {error, nil} ->
                                        {ok, none}
                                end,
                                fun(Date) -> _pipe@1 = arctic@page:new(Id),
                                    _pipe@2 = arctic@page:with_blerb(
                                        _pipe@1,
                                        gleam@result:unwrap(
                                            gleam_stdlib:map_get(
                                                erlang:element(
                                                    2,
                                                    erlang:element(2, Parsed)
                                                ),
                                                <<"blerb"/utf8>>
                                            ),
                                            <<""/utf8>>
                                        )
                                    ),
                                    _pipe@3 = arctic@page:with_tags(
                                        _pipe@2,
                                        gleam@result:unwrap(
                                            gleam@result:map(
                                                gleam_stdlib:map_get(
                                                    erlang:element(
                                                        2,
                                                        erlang:element(
                                                            2,
                                                            Parsed
                                                        )
                                                    ),
                                                    <<"tags"/utf8>>
                                                ),
                                                fun(_capture) ->
                                                    gleam@string:split(
                                                        _capture,
                                                        <<","/utf8>>
                                                    )
                                                end
                                            ),
                                            []
                                        )
                                    ),
                                    _pipe@4 = (fun(P@1) -> case Date of
                                            {some, D@1} ->
                                                arctic@page:with_date(P@1, D@1);

                                            none ->
                                                P@1
                                        end end)(_pipe@3),
                                    _pipe@5 = arctic@page:with_title(
                                        _pipe@4,
                                        gleam@result:unwrap(
                                            gleam_stdlib:map_get(
                                                erlang:element(
                                                    2,
                                                    erlang:element(2, Parsed)
                                                ),
                                                <<"title"/utf8>>
                                            ),
                                            <<""/utf8>>
                                        )
                                    ),
                                    _pipe@6 = arctic@page:with_body(
                                        _pipe@5,
                                        gleam@list:map(
                                            erlang:element(
                                                3,
                                                erlang:element(2, Parsed)
                                            ),
                                            fun(Section) -> case Section of
                                                    {some, El} ->
                                                        El;

                                                    none ->
                                                        lustre@element@html:'div'(
                                                            [lustre@attribute:class(
                                                                    <<"arctic-failed-parse"/utf8>>
                                                                )],
                                                            []
                                                        )
                                                end end
                                        )
                                    ),
                                    {ok, _pipe@6} end
                            )
                        end
                    )
            end end
    ).
