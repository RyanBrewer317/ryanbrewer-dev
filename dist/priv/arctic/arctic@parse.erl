-module(arctic@parse).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([get_pos/1, get_metadata/1, get_state/1, with_state/2, new/1, add_inline_rule/4, add_prefix_rule/3, add_static_component/3, add_dynamic_component/2, wrap_inline/1, wrap_inline_with_attributes/2, wrap_prefix/1, wrap_prefix_with_attributes/2, parse/3]).
-export_type([parsed_page/0, parse_result/1, parse_error/0, arctic_parser/1, parse_data/1, position/0, inline_rule/1, prefix_rule/1, component/1, parser_builder/1]).

-type parsed_page() :: {parsed_page,
        gleam@dict:dict(binary(), binary()),
        list(gleam@option:option(lustre@internals@vdom:element(nil)))}.

-type parse_result(UOO) :: {parse_result, UOO, list(parse_error())}.

-type parse_error() :: {parse_error, position(), binary()}.

-type arctic_parser(UOP) :: {arctic_parser,
        fun((binary(), parse_data(UOP)) -> parse_result(gleam@option:option({lustre@internals@vdom:element(nil),
            UOP})))}.

-opaque parse_data(UOQ) :: {parse_data,
        position(),
        gleam@dict:dict(binary(), binary()),
        UOQ}.

-type position() :: {position, integer(), integer()}.

-type inline_rule(UOR) :: {inline_rule,
        binary(),
        binary(),
        fun((lustre@internals@vdom:element(nil), list(binary()), parse_data(UOR)) -> {ok,
                {lustre@internals@vdom:element(nil), UOR}} |
            {error, snag:snag()})}.

-type prefix_rule(UOS) :: {prefix_rule,
        binary(),
        fun((lustre@internals@vdom:element(nil), parse_data(UOS)) -> {ok,
                {lustre@internals@vdom:element(nil), UOS}} |
            {error, snag:snag()})}.

-type component(UOT) :: {static_component,
        binary(),
        fun((list(binary()), binary(), parse_data(UOT)) -> {ok,
                {lustre@internals@vdom:element(nil), UOT}} |
            {error, snag:snag()})} |
    {dynamic_component, binary()}.

-opaque parser_builder(UOU) :: {parser_builder,
        list(inline_rule(UOU)),
        list(prefix_rule(UOU)),
        list(component(UOU)),
        UOU}.

-spec get_pos(parse_data(any())) -> position().
get_pos(Data) ->
    erlang:element(2, Data).

-spec get_metadata(parse_data(any())) -> gleam@dict:dict(binary(), binary()).
get_metadata(Data) ->
    erlang:element(3, Data).

-spec get_state(parse_data(UPB)) -> UPB.
get_state(Data) ->
    erlang:element(4, Data).

-spec with_pos(parse_data(UPD), position()) -> parse_data(UPD).
with_pos(Data, Pos) ->
    {parse_data, Pos, erlang:element(3, Data), erlang:element(4, Data)}.

-spec with_state(parse_data(UPG), UPG) -> parse_data(UPG).
with_state(Data, State) ->
    {parse_data, erlang:element(2, Data), erlang:element(3, Data), State}.

-spec new(UPJ) -> parser_builder(UPJ).
new(Start_state) ->
    {parser_builder, [], [], [], Start_state}.

-spec add_inline_rule(
    parser_builder(UPL),
    binary(),
    binary(),
    fun((lustre@internals@vdom:element(nil), list(binary()), parse_data(UPL)) -> {ok,
            {lustre@internals@vdom:element(nil), UPL}} |
        {error, snag:snag()})
) -> parser_builder(UPL).
add_inline_rule(P, Left, Right, Action) ->
    {parser_builder,
        [{inline_rule, Left, Right, Action} | erlang:element(2, P)],
        erlang:element(3, P),
        erlang:element(4, P),
        erlang:element(5, P)}.

-spec add_prefix_rule(
    parser_builder(UPT),
    binary(),
    fun((lustre@internals@vdom:element(nil), parse_data(UPT)) -> {ok,
            {lustre@internals@vdom:element(nil), UPT}} |
        {error, snag:snag()})
) -> parser_builder(UPT).
add_prefix_rule(P, Prefix, Action) ->
    {parser_builder,
        erlang:element(2, P),
        [{prefix_rule, Prefix, Action} | erlang:element(3, P)],
        erlang:element(4, P),
        erlang:element(5, P)}.

-spec add_static_component(
    parser_builder(UQA),
    binary(),
    fun((list(binary()), binary(), parse_data(UQA)) -> {ok,
            {lustre@internals@vdom:element(nil), UQA}} |
        {error, snag:snag()})
) -> parser_builder(UQA).
add_static_component(P, Name, Action) ->
    {parser_builder,
        erlang:element(2, P),
        erlang:element(3, P),
        [{static_component, Name, Action} | erlang:element(4, P)],
        erlang:element(5, P)}.

-spec add_dynamic_component(parser_builder(UQH), binary()) -> parser_builder(UQH).
add_dynamic_component(P, Name) ->
    {parser_builder,
        erlang:element(2, P),
        erlang:element(3, P),
        [{dynamic_component, Name} | erlang:element(4, P)],
        erlang:element(5, P)}.

-spec wrap_inline(
    fun((list(lustre@internals@vdom:attribute(any())), list(lustre@internals@vdom:element(nil))) -> lustre@internals@vdom:element(nil))
) -> fun((lustre@internals@vdom:element(nil), any(), parse_data(UXR)) -> {ok,
        {lustre@internals@vdom:element(nil), UXR}} |
    {error, any()}).
wrap_inline(W) ->
    fun(El, _, Data) -> {ok, {W([], [El]), get_state(Data)}} end.

-spec wrap_inline_with_attributes(
    fun((list(lustre@internals@vdom:attribute(UQU)), list(lustre@internals@vdom:element(nil))) -> lustre@internals@vdom:element(nil)),
    list(lustre@internals@vdom:attribute(UQU))
) -> fun((lustre@internals@vdom:element(nil), any(), parse_data(UXY)) -> {ok,
        {lustre@internals@vdom:element(nil), UXY}} |
    {error, any()}).
wrap_inline_with_attributes(W, Attrs) ->
    fun(El, _, Data) -> {ok, {W(Attrs, [El]), get_state(Data)}} end.

-spec wrap_prefix(
    fun((list(lustre@internals@vdom:attribute(any())), list(lustre@internals@vdom:element(nil))) -> lustre@internals@vdom:element(nil))
) -> fun((lustre@internals@vdom:element(nil), parse_data(UYF)) -> {ok,
        {lustre@internals@vdom:element(nil), UYF}} |
    {error, any()}).
wrap_prefix(W) ->
    fun(El, Data) -> {ok, {W([], [El]), get_state(Data)}} end.

-spec wrap_prefix_with_attributes(
    fun((list(lustre@internals@vdom:attribute(URK)), list(lustre@internals@vdom:element(nil))) -> lustre@internals@vdom:element(nil)),
    list(lustre@internals@vdom:attribute(URK))
) -> fun((lustre@internals@vdom:element(nil), parse_data(UYL)) -> {ok,
        {lustre@internals@vdom:element(nil), UYL}} |
    {error, any()}).
wrap_prefix_with_attributes(W, Attrs) ->
    fun(El, Data) -> {ok, {W(Attrs, [El]), get_state(Data)}} end.

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
                                                                                        message => <<"Assertion pattern match failed"/utf8>>,
                                                                                        value => _assert_fail,
                                                                                        module => <<"arctic/parse"/utf8>>,
                                                                                        function => <<"escaped_char"/utf8>>,
                                                                                        line => 402}
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

-spec invert_res({ok, {VDL, VDE}} | {error, VDI}, parse_data(VDE)) -> {{ok, VDL} |
        {error, VDI},
    parse_data(VDE)}.
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

-spec parse_component(list(component(UTH))) -> arctic_parser(UTH).
parse_component(Components) ->
    {arctic_parser,
        fun(Src, Data) ->
            Pos = get_pos(Data),
            Res@1 = party:go(
                (party:do(
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
                                                        party:char(<<" "/utf8>>),
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
                                                            party:do(case Res of
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

                                                                    {error, nil} ->
                                                                        party:return(
                                                                            []
                                                                        )
                                                                end, fun(Args) ->
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
                                                                end)
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
                )),
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

-spec parse_inline_rule(list(inline_rule(USD)), parse_data(USD)) -> party:parser(fun((parse_data(USD)) -> {{ok,
            lustre@internals@vdom:element(nil)} |
        {error, snag:snag()},
    parse_data(USD)}), snag:snag()).
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

-spec parse_markup(
    list(inline_rule(USQ)),
    party:parser(nil, snag:snag()),
    parse_data(USQ)
) -> party:parser({ok, {lustre@internals@vdom:element(nil), parse_data(USQ)}} |
    {error, snag:snag()}, snag:snag()).
parse_markup(Inline_rules, Terminator, Data) ->
    _pipe = party:choice(
        [parse_inline_rule(Inline_rules, Data),
            party:map(
                escaped_char(),
                fun(C) -> fun(D) -> {{ok, lustre@element:text(C)}, D} end end
            ),
            (party:do(
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
            ))]
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

-spec parse_text(list(inline_rule(UTB)), list(prefix_rule(UTB))) -> arctic_parser(UTB).
parse_text(Inline_rules, Prefix_rules) ->
    {arctic_parser,
        fun(Src, Data) ->
            Pos = get_pos(Data),
            Res@1 = party:go(
                (party:do(
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
                                                                    {some, El@1}
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
                )),
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
            Meta_res = party:go(parse_metadata(gleam@dict:new()), Meta_sec),
            Metadata = case Meta_res of
                {ok, Sec@1} ->
                    {parse_result, Sec@1, []};

                {error, Err} ->
                    case Err of
                        {unexpected, Pos, S} ->
                            {parse_result,
                                gleam@dict:new(),
                                [{parse_error,
                                        {position,
                                            erlang:element(2, Pos),
                                            erlang:element(3, Pos)},
                                        S}]};

                        {user_error, Pos@1, Err@1} ->
                            {parse_result,
                                gleam@dict:new(),
                                [{parse_error,
                                        {position,
                                            erlang:element(2, Pos@1),
                                            erlang:element(3, Pos@1)},
                                        erlang:element(2, Err@1)}]}
                    end
            end,
            Id = begin
                _pipe = erlang:element(2, Metadata),
                _pipe@1 = gleam@dict:get(_pipe, <<"id"/utf8>>),
                gleam@result:unwrap(_pipe@1, <<"[no id]"/utf8>>)
            end,
            gleam@io:print(
                <<<<"Starting `"/utf8, Id/binary>>/binary, "`. "/utf8>>
            ),
            {_, Body_rev_res} = gleam@list:fold(
                Body,
                {erlang:element(5, Builder), []},
                fun(So_far@1, Sec@2) ->
                    {State, Body_rev} = So_far@1,
                    {Line, Str} = Sec@2,
                    Res = case gleam@string:starts_with(Str, <<"@"/utf8>>) of
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
            gleam@io:println(
                <<<<"Finished `"/utf8, Id/binary>>/binary, "`."/utf8>>
            ),
            {ok,
                {parse_result,
                    {parsed_page, erlang:element(2, Metadata), Body_ast},
                    lists:append(erlang:element(3, Metadata), Body_errors)}}
        end).

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
                                                (gleam@int:to_string(
                                                    erlang:element(
                                                        2,
                                                        erlang:element(
                                                            2,
                                                            First_e
                                                        )
                                                    )
                                                ))/binary>>/binary,
                                            ":"/utf8>>/binary,
                                        (gleam@int:to_string(
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
                                                    (gleam@int:to_string(
                                                        erlang:element(
                                                            2,
                                                            erlang:element(2, E)
                                                        )
                                                    ))/binary>>/binary,
                                                ":"/utf8>>/binary,
                                            (gleam@int:to_string(
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
                            _pipe = gleam@dict:get(
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
                                case gleam@dict:get(
                                    erlang:element(2, erlang:element(2, Parsed)),
                                    <<"date"/utf8>>
                                ) of
                                    {ok, S@1} ->
                                        gleam@result:'try'(
                                            begin
                                                _pipe@1 = birl:parse(S@1),
                                                gleam@result:map_error(
                                                    _pipe@1,
                                                    fun(_) ->
                                                        snag:new(
                                                            <<<<"couldn't parse date `"/utf8,
                                                                    S@1/binary>>/binary,
                                                                "`"/utf8>>
                                                        )
                                                    end
                                                )
                                            end,
                                            fun(D) -> {ok, {some, D}} end
                                        );

                                    {error, nil} ->
                                        {ok, none}
                                end,
                                fun(Date) -> _pipe@2 = arctic@page:new(Id),
                                    _pipe@3 = arctic@page:with_blerb(
                                        _pipe@2,
                                        gleam@result:unwrap(
                                            gleam@dict:get(
                                                erlang:element(
                                                    2,
                                                    erlang:element(2, Parsed)
                                                ),
                                                <<"blerb"/utf8>>
                                            ),
                                            <<""/utf8>>
                                        )
                                    ),
                                    _pipe@4 = arctic@page:with_tags(
                                        _pipe@3,
                                        gleam@result:unwrap(
                                            gleam@result:map(
                                                gleam@dict:get(
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
                                    _pipe@5 = (fun(P@1) -> case Date of
                                            {some, D@1} ->
                                                arctic@page:with_date(P@1, D@1);

                                            none ->
                                                P@1
                                        end end)(_pipe@4),
                                    _pipe@6 = arctic@page:with_title(
                                        _pipe@5,
                                        gleam@result:unwrap(
                                            gleam@dict:get(
                                                erlang:element(
                                                    2,
                                                    erlang:element(2, Parsed)
                                                ),
                                                <<"title"/utf8>>
                                            ),
                                            <<""/utf8>>
                                        )
                                    ),
                                    _pipe@7 = arctic@page:with_body(
                                        _pipe@6,
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
                                    {ok, _pipe@7} end
                            )
                        end
                    )
            end end
    ).
