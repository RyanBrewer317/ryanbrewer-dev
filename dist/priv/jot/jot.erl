-module(jot).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([document_to_html/1, parse/1, to_html/1]).
-export_type([document/0, container/0, inline/0, list_layout/0, destination/0, refs/0, splitters/0, generated_html/0, trim/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-type document() :: {document,
        list(container()),
        gleam@dict:dict(binary(), binary()),
        gleam@dict:dict(binary(), list(container()))}.

-type container() :: thematic_break |
    {paragraph, gleam@dict:dict(binary(), binary()), list(inline())} |
    {heading, gleam@dict:dict(binary(), binary()), integer(), list(inline())} |
    {codeblock,
        gleam@dict:dict(binary(), binary()),
        gleam@option:option(binary()),
        binary()} |
    {raw_block, binary()} |
    {bullet_list, list_layout(), binary(), list(list(container()))}.

-type inline() :: linebreak |
    non_breaking_space |
    {text, binary()} |
    {link, list(inline()), destination()} |
    {image, list(inline()), destination()} |
    {emphasis, list(inline())} |
    {strong, list(inline())} |
    {footnote, binary()} |
    {code, binary()}.

-type list_layout() :: tight | loose.

-type destination() :: {reference, binary()} | {url, binary()}.

-type refs() :: {refs,
        gleam@dict:dict(binary(), binary()),
        gleam@dict:dict(binary(), list(container()))}.

-type splitters() :: {splitters,
        splitter:splitter(),
        splitter:splitter(),
        splitter:splitter(),
        splitter:splitter()}.

-type generated_html() :: {generated_html,
        binary(),
        list({integer(), binary()})}.

-type trim() :: no_trim | trim_last.

-file("src/jot.gleam", 21).
-spec add_attribute(gleam@dict:dict(binary(), binary()), binary(), binary()) -> gleam@dict:dict(binary(), binary()).
add_attribute(Attributes, Key, Value) ->
    case Key of
        <<"class"/utf8>> ->
            gleam@dict:upsert(Attributes, Key, fun(Previous) -> case Previous of
                        none ->
                            Value;

                        {some, Previous@1} ->
                            <<<<Previous@1/binary, " "/utf8>>/binary,
                                Value/binary>>
                    end end);

        _ ->
            gleam@dict:insert(Attributes, Key, Value)
    end.

-file("src/jot.gleam", 121).
-spec drop_lines(binary()) -> binary().
drop_lines(In) ->
    case In of
        <<""/utf8>> ->
            <<""/utf8>>;

        <<"\n"/utf8, Rest/binary>> ->
            drop_lines(Rest);

        Other ->
            Other
    end.

-file("src/jot.gleam", 129).
-spec drop_spaces(binary()) -> binary().
drop_spaces(In) ->
    case In of
        <<""/utf8>> ->
            <<""/utf8>>;

        <<" "/utf8, Rest/binary>> ->
            drop_spaces(Rest);

        Other ->
            Other
    end.

-file("src/jot.gleam", 137).
-spec count_drop_spaces(binary(), integer()) -> {binary(), integer()}.
count_drop_spaces(In, Count) ->
    case In of
        <<""/utf8>> ->
            {<<""/utf8>>, Count};

        <<" "/utf8, Rest/binary>> ->
            count_drop_spaces(Rest, Count + 1);

        Other ->
            {Other, Count}
    end.

-file("src/jot.gleam", 318).
-spec parse_thematic_break(integer(), binary()) -> gleam@option:option({container(),
    binary()}).
parse_thematic_break(Count, In) ->
    case In of
        <<""/utf8>> when Count >= 3 ->
            {some, {thematic_break, In}};

        <<"\n"/utf8, _/binary>> when Count >= 3 ->
            {some, {thematic_break, In}};

        <<" "/utf8, Rest/binary>> ->
            parse_thematic_break(Count, Rest);

        <<"\t"/utf8, Rest/binary>> ->
            parse_thematic_break(Count, Rest);

        <<"-"/utf8, Rest@1/binary>> ->
            parse_thematic_break(Count + 1, Rest@1);

        <<"*"/utf8, Rest@1/binary>> ->
            parse_thematic_break(Count + 1, Rest@1);

        _ ->
            none
    end.

-file("src/jot.gleam", 388).
-spec slurp_verbatim_line(binary(), integer(), binary(), splitters()) -> {binary(),
    binary()}.
slurp_verbatim_line(In, Indentation, Acc, Splitters) ->
    case splitter_ffi:split(erlang:element(2, Splitters), In) of
        {Before, <<"\n"/utf8>>, In@1} ->
            {<<<<Acc/binary, Before/binary>>/binary, "\n"/utf8>>, In@1};

        {<<""/utf8>>, <<" "/utf8>>, In@2} when Indentation > 0 ->
            slurp_verbatim_line(In@2, Indentation - 1, Acc, Splitters);

        {Before@1, Split, In@3} ->
            slurp_verbatim_line(
                In@3,
                Indentation,
                <<<<Acc/binary, Before@1/binary>>/binary, Split/binary>>,
                Splitters
            )
    end.

-file("src/jot.gleam", 403).
-spec parse_codeblock_end(binary(), binary(), integer()) -> gleam@option:option(binary()).
parse_codeblock_end(In, Delim, Count) ->
    case In of
        <<"\n"/utf8, In@1/binary>> when Count =:= 0 ->
            {some, In@1};

        _ when Count =:= 0 ->
            {some, In};

        <<" "/utf8, In@2/binary>> ->
            parse_codeblock_end(In@2, Delim, Count);

        _ ->
            case gleam_stdlib:string_pop_grapheme(In) of
                {ok, {C, In@3}} when C =:= Delim ->
                    parse_codeblock_end(In@3, Delim, Count - 1);

                {ok, _} ->
                    none;

                {error, _} ->
                    {some, In}
            end
    end.

-file("src/jot.gleam", 371).
-spec parse_codeblock_content(
    binary(),
    binary(),
    integer(),
    integer(),
    binary(),
    splitters()
) -> {binary(), binary()}.
parse_codeblock_content(In, Delim, Count, Indentation, Acc, Splitters) ->
    case parse_codeblock_end(In, Delim, Count) of
        none ->
            {Acc@1, In@1} = slurp_verbatim_line(In, Indentation, Acc, Splitters),
            parse_codeblock_content(
                In@1,
                Delim,
                Count,
                Indentation,
                Acc@1,
                Splitters
            );

        {some, In@2} ->
            {Acc, In@2}
    end.

-file("src/jot.gleam", 420).
-spec parse_codeblock_language(binary(), splitters(), binary()) -> gleam@option:option({gleam@option:option(binary()),
    binary()}).
parse_codeblock_language(In, Splitters, Language) ->
    case splitter_ffi:split(erlang:element(3, Splitters), In) of
        {_, <<"`"/utf8>>, _} ->
            none;

        {A, <<"\n"/utf8>>, _} when (A =:= <<""/utf8>>) andalso (Language =:= <<""/utf8>>) ->
            {some, {none, In}};

        {A@1, <<"\n"/utf8>>, In@1} ->
            {some, {{some, <<Language/binary, A@1/binary>>}, In@1}};

        _ ->
            {some, {none, In}}
    end.

-file("src/jot.gleam", 344).
-spec parse_codeblock_start(binary(), splitters(), binary(), integer()) -> gleam@option:option({gleam@option:option(binary()),
    integer(),
    binary()}).
parse_codeblock_start(In, Splitters, Delim, Count) ->
    case In of
        <<C:1/binary, In@1/binary>> when (C =:= <<"`"/utf8>>) andalso (C =:= Delim) ->
            parse_codeblock_start(In@1, Splitters, Delim, Count + 1);

        <<C:1/binary, In@1/binary>> when (C =:= <<"~"/utf8>>) andalso (C =:= Delim) ->
            parse_codeblock_start(In@1, Splitters, Delim, Count + 1);

        <<"\n"/utf8, In@2/binary>> when Count >= 3 ->
            {some, {none, Count, In@2}};

        <<""/utf8>> ->
            none;

        _ when Count >= 3 ->
            In@3 = drop_spaces(In),
            gleam@option:map(
                parse_codeblock_language(In@3, Splitters, <<""/utf8>>),
                fun(_use0) ->
                    {Language, In@4} = _use0,
                    {Language, Count, In@4}
                end
            );

        _ ->
            none
    end.

-file("src/jot.gleam", 327).
-spec parse_codeblock(
    binary(),
    gleam@dict:dict(binary(), binary()),
    binary(),
    integer(),
    splitters()
) -> gleam@option:option({container(), binary()}).
parse_codeblock(In, Attrs, Delim, Indentation, Splitters) ->
    Out = parse_codeblock_start(In, Splitters, Delim, 1),
    gleam@option:then(
        Out,
        fun(_use0) ->
            {Language, Count, In@1} = _use0,
            {Content, In@2} = parse_codeblock_content(
                In@1,
                Delim,
                Count,
                Indentation,
                <<""/utf8>>,
                Splitters
            ),
            case Language of
                {some, <<"=html"/utf8>>} ->
                    {some, {{raw_block, gleam@string:trim_end(Content)}, In@2}};

                _ ->
                    {some, {{codeblock, Attrs, Language, Content}, In@2}}
            end
        end
    ).

-file("src/jot.gleam", 446).
-spec parse_ref_value(binary(), binary(), binary()) -> gleam@option:option({binary(),
    binary(),
    binary()}).
parse_ref_value(In, Id, Url) ->
    case In of
        <<"\n "/utf8, In@1/binary>> ->
            parse_ref_value(drop_spaces(In@1), Id, Url);

        <<"\n"/utf8, In@2/binary>> ->
            {some, {Id, gleam@string:trim(Url), In@2}};

        _ ->
            case gleam_stdlib:string_pop_grapheme(In) of
                {ok, {C, In@3}} ->
                    parse_ref_value(In@3, Id, <<Url/binary, C/binary>>);

                {error, _} ->
                    {some, {Id, gleam@string:trim(Url), <<""/utf8>>}}
            end
    end.

-file("src/jot.gleam", 434).
-spec parse_ref_def(binary(), binary()) -> gleam@option:option({binary(),
    binary(),
    binary()}).
parse_ref_def(In, Id) ->
    case In of
        <<"]:"/utf8, In@1/binary>> ->
            parse_ref_value(In@1, Id, <<""/utf8>>);

        <<""/utf8>> ->
            none;

        <<"]"/utf8, _/binary>> ->
            none;

        <<"\n"/utf8, _/binary>> ->
            none;

        _ ->
            case gleam_stdlib:string_pop_grapheme(In) of
                {ok, {C, In@2}} ->
                    parse_ref_def(In@2, <<Id/binary, C/binary>>);

                {error, _} ->
                    none
            end
    end.

-file("src/jot.gleam", 544).
-spec parse_attribute_value(binary(), binary(), binary()) -> gleam@option:option({binary(),
    binary(),
    binary()}).
parse_attribute_value(In, Key, Value) ->
    case In of
        <<""/utf8>> ->
            none;

        <<" "/utf8, In@1/binary>> ->
            {some, {Key, Value, In@1}};

        <<"}"/utf8, _/binary>> ->
            {some, {Key, Value, In}};

        _ ->
            case gleam_stdlib:string_pop_grapheme(In) of
                {ok, {C, In@2}} ->
                    parse_attribute_value(In@2, Key, <<Value/binary, C/binary>>);

                {error, _} ->
                    none
            end
    end.

-file("src/jot.gleam", 561).
-spec parse_attribute_quoted_value(binary(), binary(), binary()) -> gleam@option:option({binary(),
    binary(),
    binary()}).
parse_attribute_quoted_value(In, Key, Value) ->
    case In of
        <<""/utf8>> ->
            none;

        <<"\""/utf8, In@1/binary>> ->
            {some, {Key, Value, In@1}};

        _ ->
            case gleam_stdlib:string_pop_grapheme(In) of
                {ok, {C, In@2}} ->
                    parse_attribute_quoted_value(
                        In@2,
                        Key,
                        <<Value/binary, C/binary>>
                    );

                {error, _} ->
                    none
            end
    end.

-file("src/jot.gleam", 531).
-spec parse_attribute(binary(), binary()) -> gleam@option:option({binary(),
    binary(),
    binary()}).
parse_attribute(In, Key) ->
    case In of
        <<""/utf8>> ->
            none;

        <<" "/utf8, _/binary>> ->
            none;

        <<"=\""/utf8, In@1/binary>> ->
            parse_attribute_quoted_value(In@1, Key, <<""/utf8>>);

        <<"="/utf8, In@2/binary>> ->
            parse_attribute_value(In@2, Key, <<""/utf8>>);

        _ ->
            case gleam_stdlib:string_pop_grapheme(In) of
                {ok, {C, In@3}} ->
                    parse_attribute(In@3, <<Key/binary, C/binary>>);

                {error, _} ->
                    none
            end
    end.

-file("src/jot.gleam", 577).
-spec parse_attributes_id_or_class(binary(), binary()) -> gleam@option:option({binary(),
    binary()}).
parse_attributes_id_or_class(In, Id) ->
    case In of
        <<""/utf8>> ->
            {some, {Id, In}};

        <<"}"/utf8, _/binary>> ->
            {some, {Id, In}};

        <<" "/utf8, _/binary>> ->
            {some, {Id, In}};

        <<"#"/utf8, _/binary>> ->
            none;

        <<"."/utf8, _/binary>> ->
            none;

        <<"="/utf8, _/binary>> ->
            none;

        <<"\n"/utf8, _/binary>> ->
            none;

        _ ->
            case gleam_stdlib:string_pop_grapheme(In) of
                {ok, {C, In@1}} ->
                    parse_attributes_id_or_class(In@1, <<Id/binary, C/binary>>);

                {error, _} ->
                    {some, {Id, In}}
            end
    end.

-file("src/jot.gleam", 594).
-spec parse_attributes_end(binary(), gleam@dict:dict(binary(), binary())) -> gleam@option:option({gleam@dict:dict(binary(), binary()),
    binary()}).
parse_attributes_end(In, Attrs) ->
    case In of
        <<""/utf8>> ->
            {some, {Attrs, <<""/utf8>>}};

        <<"\n"/utf8, In@1/binary>> ->
            {some, {Attrs, In@1}};

        <<" "/utf8, In@2/binary>> ->
            parse_attributes_end(In@2, Attrs);

        _ ->
            none
    end.

-file("src/jot.gleam", 502).
-spec parse_attributes(binary(), gleam@dict:dict(binary(), binary())) -> gleam@option:option({gleam@dict:dict(binary(), binary()),
    binary()}).
parse_attributes(In, Attrs) ->
    In@1 = drop_spaces(In),
    case In@1 of
        <<""/utf8>> ->
            none;

        <<"}"/utf8, In@2/binary>> ->
            parse_attributes_end(In@2, Attrs);

        <<"#"/utf8, In@3/binary>> ->
            case parse_attributes_id_or_class(In@3, <<""/utf8>>) of
                {some, {Id, In@4}} ->
                    parse_attributes(
                        In@4,
                        add_attribute(Attrs, <<"id"/utf8>>, Id)
                    );

                none ->
                    none
            end;

        <<"."/utf8, In@5/binary>> ->
            case parse_attributes_id_or_class(In@5, <<""/utf8>>) of
                {some, {C, In@6}} ->
                    parse_attributes(
                        In@6,
                        add_attribute(Attrs, <<"class"/utf8>>, C)
                    );

                none ->
                    none
            end;

        _ ->
            case parse_attribute(In@1, <<""/utf8>>) of
                {some, {K, V, In@7}} ->
                    parse_attributes(In@7, add_attribute(Attrs, K, V));

                none ->
                    none
            end
    end.

-file("src/jot.gleam", 644).
-spec id_sanitise(binary()) -> binary().
id_sanitise(Content) ->
    _pipe = Content,
    _pipe@1 = gleam@string:replace(_pipe, <<"#"/utf8>>, <<""/utf8>>),
    _pipe@2 = gleam@string:replace(_pipe@1, <<"?"/utf8>>, <<""/utf8>>),
    _pipe@3 = gleam@string:replace(_pipe@2, <<"!"/utf8>>, <<""/utf8>>),
    _pipe@4 = gleam@string:replace(_pipe@3, <<","/utf8>>, <<""/utf8>>),
    _pipe@5 = gleam@string:trim(_pipe@4),
    _pipe@6 = gleam@string:replace(_pipe@5, <<" "/utf8>>, <<"-"/utf8>>),
    gleam@string:replace(_pipe@6, <<"\n"/utf8>>, <<"-"/utf8>>).

-file("src/jot.gleam", 673).
-spec take_heading_chars_newline_hash(binary(), integer(), binary()) -> gleam@option:option({binary(),
    binary()}).
take_heading_chars_newline_hash(In, Level, Acc) ->
    case In of
        _ when Level < 0 ->
            none;

        <<""/utf8>> when Level > 0 ->
            none;

        <<""/utf8>> when Level =:= 0 ->
            {some, {Acc, <<""/utf8>>}};

        <<" "/utf8, In@1/binary>> when Level =:= 0 ->
            {some, {Acc, In@1}};

        <<"#"/utf8, Rest/binary>> ->
            take_heading_chars_newline_hash(Rest, Level - 1, Acc);

        _ ->
            none
    end.

-file("src/jot.gleam", 655).
-spec take_heading_chars(binary(), integer(), binary()) -> {binary(), binary()}.
take_heading_chars(In, Level, Acc) ->
    case In of
        <<""/utf8>> ->
            {Acc, <<""/utf8>>};

        <<"\n"/utf8>> ->
            {Acc, <<""/utf8>>};

        <<"\n\n"/utf8, In@1/binary>> ->
            {Acc, In@1};

        <<"\n#"/utf8, Rest/binary>> ->
            case take_heading_chars_newline_hash(
                Rest,
                Level - 1,
                <<Acc/binary, "\n"/utf8>>
            ) of
                {some, {Acc@1, In@2}} ->
                    take_heading_chars(In@2, Level, Acc@1);

                none ->
                    {Acc, In}
            end;

        _ ->
            case gleam_stdlib:string_pop_grapheme(In) of
                {ok, {C, In@3}} ->
                    take_heading_chars(In@3, Level, <<Acc/binary, C/binary>>);

                {error, _} ->
                    {Acc, <<""/utf8>>}
            end
    end.

-file("src/jot.gleam", 876).
-spec parse_code_end(binary(), integer(), integer(), binary()) -> {boolean(),
    binary(),
    binary()}.
parse_code_end(In, Limit, Count, Content) ->
    case In of
        <<""/utf8>> ->
            {true, Content, In};

        <<"`"/utf8, In@1/binary>> ->
            parse_code_end(In@1, Limit, Count + 1, Content);

        _ when Limit =:= Count ->
            {true, Content, In};

        _ ->
            {false,
                <<Content/binary,
                    (gleam@string:repeat(<<"`"/utf8>>, Count))/binary>>,
                In}
    end.

-file("src/jot.gleam", 853).
-spec parse_code_content(binary(), integer(), binary()) -> {binary(), binary()}.
parse_code_content(In, Count, Content) ->
    case In of
        <<""/utf8>> ->
            {Content, In};

        <<"`"/utf8, In@1/binary>> ->
            {Done, Content@1, In@2} = parse_code_end(In@1, Count, 1, Content),
            case Done of
                true ->
                    {Content@1, In@2};

                false ->
                    parse_code_content(In@2, Count, Content@1)
            end;

        _ ->
            case gleam_stdlib:string_pop_grapheme(In) of
                {ok, {C, In@3}} ->
                    parse_code_content(
                        In@3,
                        Count,
                        <<Content/binary, C/binary>>
                    );

                {error, _} ->
                    {Content, In}
            end
    end.

-file("src/jot.gleam", 831).
-spec parse_code(binary(), integer()) -> {inline(), binary()}.
parse_code(In, Count) ->
    case In of
        <<"`"/utf8, In@1/binary>> ->
            parse_code(In@1, Count + 1);

        _ ->
            {Content, In@2} = parse_code_content(In, Count, <<""/utf8>>),
            Content@1 = case gleam_stdlib:string_starts_with(
                Content,
                <<" `"/utf8>>
            ) of
                true ->
                    gleam@string:trim_start(Content);

                false ->
                    Content
            end,
            Content@2 = case gleam_stdlib:string_ends_with(
                Content@1,
                <<"` "/utf8>>
            ) of
                true ->
                    gleam@string:trim_end(Content@1);

                false ->
                    Content@1
            end,
            {{code, Content@2}, In@2}
    end.

-file("src/jot.gleam", 906).
-spec take_emphasis_chars(binary(), binary(), binary()) -> gleam@option:option({binary(),
    binary()}).
take_emphasis_chars(In, Close, Acc) ->
    case In of
        <<""/utf8>> ->
            none;

        <<"`"/utf8, _/binary>> ->
            none;

        <<Ws:1/binary, In@1/binary>> when Ws =:= <<"\t"/utf8>> ->
            case gleam_stdlib:string_pop_grapheme(In@1) of
                {ok, {C, In@2}} when C =:= Close ->
                    take_emphasis_chars(
                        In@2,
                        Close,
                        <<<<Acc/binary, Ws/binary>>/binary, C/binary>>
                    );

                _ ->
                    take_emphasis_chars(In@1, Close, <<Acc/binary, Ws/binary>>)
            end;

        <<Ws:1/binary, In@1/binary>> when Ws =:= <<"\n"/utf8>> ->
            case gleam_stdlib:string_pop_grapheme(In@1) of
                {ok, {C, In@2}} when C =:= Close ->
                    take_emphasis_chars(
                        In@2,
                        Close,
                        <<<<Acc/binary, Ws/binary>>/binary, C/binary>>
                    );

                _ ->
                    take_emphasis_chars(In@1, Close, <<Acc/binary, Ws/binary>>)
            end;

        <<Ws:1/binary, In@1/binary>> when Ws =:= <<" "/utf8>> ->
            case gleam_stdlib:string_pop_grapheme(In@1) of
                {ok, {C, In@2}} when C =:= Close ->
                    take_emphasis_chars(
                        In@2,
                        Close,
                        <<<<Acc/binary, Ws/binary>>/binary, C/binary>>
                    );

                _ ->
                    take_emphasis_chars(In@1, Close, <<Acc/binary, Ws/binary>>)
            end;

        _ ->
            case gleam_stdlib:string_pop_grapheme(In) of
                {ok, {C@1, _}} when (C@1 =:= Close) andalso (Acc =:= <<""/utf8>>) ->
                    none;

                {ok, {C@2, In@3}} when C@2 =:= Close ->
                    {some, {Acc, In@3}};

                {ok, {C@3, In@4}} ->
                    take_emphasis_chars(In@4, Close, <<Acc/binary, C@3/binary>>);

                {error, _} ->
                    none
            end
    end.

-file("src/jot.gleam", 975).
-spec take_link_chars_destination(
    binary(),
    boolean(),
    binary(),
    splitters(),
    binary()
) -> gleam@option:option({binary(), destination(), binary()}).
take_link_chars_destination(In, Is_url, Inline_in, Splitters, Acc) ->
    case splitter_ffi:split(erlang:element(5, Splitters), In) of
        {A, <<")"/utf8>>, In@1} when Is_url ->
            {some, {Inline_in, {url, <<Acc/binary, A/binary>>}, In@1}};

        {A@1, <<"]"/utf8>>, In@2} when not Is_url ->
            {some, {Inline_in, {reference, <<Acc/binary, A@1/binary>>}, In@2}};

        {A@2, <<"\n"/utf8>>, Rest} when Is_url ->
            take_link_chars_destination(
                Rest,
                Is_url,
                Inline_in,
                Splitters,
                <<Acc/binary, A@2/binary>>
            );

        {A@3, <<"\n"/utf8>>, Rest@1} when not Is_url ->
            take_link_chars_destination(
                Rest@1,
                Is_url,
                Inline_in,
                Splitters,
                <<<<Acc/binary, A@3/binary>>/binary, " "/utf8>>
            );

        _ ->
            none
    end.

-file("src/jot.gleam", 956).
-spec take_link_chars(binary(), binary(), splitters()) -> gleam@option:option({binary(),
    destination(),
    binary()}).
take_link_chars(In, Inline_in, Splitters) ->
    case gleam@string:split_once(In, <<"]"/utf8>>) of
        {ok, {Before, <<"["/utf8, In@1/binary>>}} ->
            take_link_chars_destination(
                In@1,
                false,
                <<Inline_in/binary, Before/binary>>,
                Splitters,
                <<""/utf8>>
            );

        {ok, {Before@1, <<"("/utf8, In@2/binary>>}} ->
            take_link_chars_destination(
                In@2,
                true,
                <<Inline_in/binary, Before@1/binary>>,
                Splitters,
                <<""/utf8>>
            );

        {ok, {Before@2, In@3}} ->
            take_link_chars(
                In@3,
                <<Inline_in/binary, Before@2/binary>>,
                Splitters
            );

        {error, _} ->
            none
    end.

-file("src/jot.gleam", 1001).
-spec parse_footnote(binary(), binary()) -> gleam@option:option({inline(),
    binary()}).
parse_footnote(In, Acc) ->
    case In of
        <<""/utf8>> ->
            none;

        <<"]"/utf8, Rest/binary>> ->
            {some, {{footnote, Acc}, Rest}};

        _ ->
            case gleam_stdlib:string_pop_grapheme(In) of
                {ok, {C, Rest@1}} ->
                    parse_footnote(Rest@1, <<Acc/binary, C/binary>>);

                {error, _} ->
                    none
            end
    end.

-file("src/jot.gleam", 1018).
-spec heading_level(binary(), integer()) -> gleam@option:option({integer(),
    binary()}).
heading_level(In, Level) ->
    case In of
        <<"#"/utf8, Rest/binary>> ->
            heading_level(Rest, Level + 1);

        <<""/utf8>> when Level > 0 ->
            {some, {Level, <<""/utf8>>}};

        <<" "/utf8, Rest@1/binary>> when Level =/= 0 ->
            {some, {Level, Rest@1}};

        <<"\n"/utf8, Rest@1/binary>> when Level =/= 0 ->
            {some, {Level, Rest@1}};

        _ ->
            none
    end.

-file("src/jot.gleam", 1029).
-spec take_inline_text(list(inline()), binary()) -> binary().
take_inline_text(Inlines, Acc) ->
    case Inlines of
        [] ->
            Acc;

        [First | Rest] ->
            case First of
                non_breaking_space ->
                    take_inline_text(Rest, <<Acc/binary, " "/utf8>>);

                {text, Text} ->
                    take_inline_text(Rest, <<Acc/binary, Text/binary>>);

                {code, Text} ->
                    take_inline_text(Rest, <<Acc/binary, Text/binary>>);

                {strong, Inlines@1} ->
                    take_inline_text(lists:append(Inlines@1, Rest), Acc);

                {emphasis, Inlines@1} ->
                    take_inline_text(lists:append(Inlines@1, Rest), Acc);

                {link, Nested, _} ->
                    Acc@1 = take_inline_text(Nested, Acc),
                    take_inline_text(Rest, Acc@1);

                {image, Nested, _} ->
                    Acc@1 = take_inline_text(Nested, Acc),
                    take_inline_text(Rest, Acc@1);

                linebreak ->
                    take_inline_text(Rest, Acc);

                {footnote, _} ->
                    take_inline_text(Rest, Acc)
            end
    end.

-file("src/jot.gleam", 1097).
-spec take_list_item_chars(binary(), binary(), binary()) -> {binary(),
    binary(),
    boolean()}.
take_list_item_chars(In, Acc, Style) ->
    {In@2, Acc@1} = case gleam@string:split_once(In, <<"\n"/utf8>>) of
        {ok, {Content, In@1}} ->
            {In@1, <<Acc/binary, Content/binary>>};

        {error, _} ->
            {<<""/utf8>>, <<Acc/binary, In/binary>>}
    end,
    case In@2 of
        <<" "/utf8, In@3/binary>> ->
            take_list_item_chars(In@3, <<Acc@1/binary, "\n "/utf8>>, Style);

        <<"- "/utf8, In@4/binary>> when Style =:= <<"-"/utf8>> ->
            {Acc@1, In@4, false};

        <<"\n- "/utf8, In@5/binary>> when Style =:= <<"-"/utf8>> ->
            {Acc@1, In@5, false};

        <<"* "/utf8, In@6/binary>> when Style =:= <<"*"/utf8>> ->
            {Acc@1, In@6, false};

        <<"\n* "/utf8, In@7/binary>> when Style =:= <<"*"/utf8>> ->
            {Acc@1, In@7, false};

        _ ->
            {Acc@1, In@2, true}
    end.

-file("src/jot.gleam", 1117).
-spec take_paragraph_chars(binary()) -> {binary(), binary()}.
take_paragraph_chars(In) ->
    case gleam@string:split_once(In, <<"\n\n"/utf8>>) of
        {ok, {Content, In@1}} ->
            {Content, In@1};

        {error, _} ->
            case gleam_stdlib:string_ends_with(In, <<"\n"/utf8>>) of
                true ->
                    {gleam@string:drop_end(In, 1), <<""/utf8>>};

                false ->
                    {In, <<""/utf8>>}
            end
    end.

-file("src/jot.gleam", 1334).
-spec get_new_footnotes(
    generated_html(),
    generated_html(),
    list({integer(), binary()})
) -> list({integer(), binary()}).
get_new_footnotes(Original_html, New_html, Acc) ->
    case {erlang:element(3, Original_html), erlang:element(3, New_html)} of
        {[Original | _], [New | _]} when Original =:= New ->
            Acc;

        {_, [New@1 | Rest]} ->
            get_new_footnotes(
                Original_html,
                begin
                    _record = New_html,
                    {generated_html, erlang:element(2, _record), Rest}
                end,
                [New@1 | Acc]
            );

        {_, _} ->
            Acc
    end.

-file("src/jot.gleam", 1351).
-spec append_to_html(generated_html(), binary()) -> generated_html().
append_to_html(Original_html, Str) ->
    _record = Original_html,
    {generated_html,
        <<(erlang:element(2, Original_html))/binary, Str/binary>>,
        erlang:element(3, _record)}.

-file("src/jot.gleam", 1381).
-spec close_tag(generated_html(), binary()) -> generated_html().
close_tag(Initial_html, Tag) ->
    _record = Initial_html,
    {generated_html,
        <<<<<<(erlang:element(2, Initial_html))/binary, "</"/utf8>>/binary,
                Tag/binary>>/binary,
            ">"/utf8>>,
        erlang:element(3, _record)}.

-file("src/jot.gleam", 1524).
-spec find_footnote_number(
    list({integer(), binary()}),
    binary(),
    list({integer(), binary()})
) -> {binary(), list({integer(), binary()})}.
find_footnote_number(Footnotes_to_check, Reference, Used_footnotes) ->
    case Footnotes_to_check of
        [] ->
            Next_number = begin
                _pipe = Used_footnotes,
                _pipe@1 = gleam@list:first(_pipe),
                _pipe@2 = gleam@result:map(
                    _pipe@1,
                    fun(F) -> erlang:element(1, F) end
                ),
                gleam@result:unwrap(_pipe@2, 0)
            end
            + 1,
            {erlang:integer_to_binary(Next_number),
                [{Next_number, Reference} | Used_footnotes]};

        [{Index, Ref} | _] when Reference =:= Ref ->
            {erlang:integer_to_binary(Index), Used_footnotes};

        [_ | Rest] ->
            find_footnote_number(Rest, Reference, Used_footnotes)
    end.

-file("src/jot.gleam", 1552).
-spec destination_attribute(binary(), destination(), refs()) -> gleam@dict:dict(binary(), binary()).
destination_attribute(Key, Destination, Refs) ->
    Dict = maps:new(),
    case Destination of
        {url, Url} ->
            gleam@dict:insert(Dict, Key, houdini:escape(Url));

        {reference, Id} ->
            case gleam_stdlib:map_get(erlang:element(2, Refs), Id) of
                {ok, Url@1} ->
                    gleam@dict:insert(Dict, Key, houdini:escape(Url@1));

                _ ->
                    Dict
            end
    end.

-file("src/jot.gleam", 1575).
-spec ordered_attributes_to_html(list({binary(), binary()}), binary()) -> binary().
ordered_attributes_to_html(Attributes, Html) ->
    gleam@list:fold(
        Attributes,
        Html,
        fun(Html@1, Pair) ->
            <<<<<<<<<<Html@1/binary, " "/utf8>>/binary,
                            (erlang:element(1, Pair))/binary>>/binary,
                        "=\""/utf8>>/binary,
                    (erlang:element(2, Pair))/binary>>/binary,
                "\""/utf8>>
        end
    ).

-file("src/jot.gleam", 1369).
-spec open_tag_ordered_attributes(
    generated_html(),
    binary(),
    list({binary(), binary()})
) -> generated_html().
open_tag_ordered_attributes(Initial_html, Tag, Attributes) ->
    Html = <<<<(erlang:element(2, Initial_html))/binary, "<"/utf8>>/binary,
        Tag/binary>>,
    _record = Initial_html,
    {generated_html,
        <<(ordered_attributes_to_html(Attributes, Html))/binary, ">"/utf8>>,
        erlang:element(3, _record)}.

-file("src/jot.gleam", 1324).
-spec add_footnote_link(generated_html(), binary()) -> generated_html().
add_footnote_link(Html, Footnote_number) ->
    _pipe = Html,
    _pipe@1 = open_tag_ordered_attributes(
        _pipe,
        <<"a"/utf8>>,
        [{<<"href"/utf8>>, <<"#fnref"/utf8, Footnote_number/binary>>},
            {<<"role"/utf8>>, <<"doc-backlink"/utf8>>}]
    ),
    _pipe@2 = append_to_html(_pipe@1, <<"↩︎"/utf8>>),
    close_tag(_pipe@2, <<"a"/utf8>>).

-file("src/jot.gleam", 1568).
-spec attributes_to_html(binary(), gleam@dict:dict(binary(), binary())) -> binary().
attributes_to_html(Html, Attributes) ->
    _pipe = Attributes,
    _pipe@1 = maps:to_list(_pipe),
    _pipe@2 = gleam@list:sort(
        _pipe@1,
        fun(A, B) ->
            gleam@string:compare(erlang:element(1, A), erlang:element(1, B))
        end
    ),
    ordered_attributes_to_html(_pipe@2, Html).

-file("src/jot.gleam", 1355).
-spec open_tag(generated_html(), binary(), gleam@dict:dict(binary(), binary())) -> generated_html().
open_tag(Initial_html, Tag, Attributes) ->
    Html = <<<<(erlang:element(2, Initial_html))/binary, "<"/utf8>>/binary,
        Tag/binary>>,
    _record = Initial_html,
    {generated_html,
        <<(attributes_to_html(Html, Attributes))/binary, ">"/utf8>>,
        erlang:element(3, _record)}.

-file("src/jot.gleam", 1390).
-spec list_items_to_html(
    generated_html(),
    list_layout(),
    list(list(container())),
    refs()
) -> generated_html().
list_items_to_html(Html, Layout, Items, Refs) ->
    case Items of
        [] ->
            Html;

        [[{paragraph, _, Inlines}] | Rest] when Layout =:= tight ->
            _pipe = Html,
            _pipe@1 = open_tag(_pipe, <<"li"/utf8>>, maps:new()),
            _pipe@2 = append_to_html(_pipe@1, <<"\n"/utf8>>),
            _pipe@3 = inlines_to_html(_pipe@2, Inlines, Refs, trim_last),
            _pipe@4 = append_to_html(_pipe@3, <<"\n"/utf8>>),
            _pipe@5 = close_tag(_pipe@4, <<"li"/utf8>>),
            _pipe@6 = append_to_html(_pipe@5, <<"\n"/utf8>>),
            list_items_to_html(_pipe@6, Layout, Rest, Refs);

        [Item | Rest@1] ->
            _pipe@7 = Html,
            _pipe@8 = open_tag(_pipe@7, <<"li"/utf8>>, maps:new()),
            _pipe@9 = append_to_html(_pipe@8, <<"\n"/utf8>>),
            _pipe@10 = containers_to_html(Item, Refs, _pipe@9),
            _pipe@11 = append_to_html(_pipe@10, <<"\n"/utf8>>),
            _pipe@12 = close_tag(_pipe@11, <<"li"/utf8>>),
            _pipe@13 = append_to_html(_pipe@12, <<"\n"/utf8>>),
            list_items_to_html(_pipe@13, Layout, Rest@1, Refs)
    end.

-file("src/jot.gleam", 1206).
-spec containers_to_html(list(container()), refs(), generated_html()) -> generated_html().
containers_to_html(Containers, Refs, Html) ->
    case Containers of
        [] ->
            Html;

        [Container | Rest] ->
            Html@1 = container_to_html(Html, Container, Refs),
            containers_to_html(Rest, Refs, Html@1)
    end.

-file("src/jot.gleam", 1220).
-spec container_to_html(generated_html(), container(), refs()) -> generated_html().
container_to_html(Html, Container, Refs) ->
    New_html = case Container of
        thematic_break ->
            _pipe = Html,
            open_tag(_pipe, <<"hr"/utf8>>, maps:new());

        {paragraph, Attrs, Inlines} ->
            _pipe@1 = Html,
            _pipe@2 = open_tag(_pipe@1, <<"p"/utf8>>, Attrs),
            _pipe@3 = inlines_to_html(_pipe@2, Inlines, Refs, trim_last),
            close_tag(_pipe@3, <<"p"/utf8>>);

        {codeblock, Attrs@1, Language, Content} ->
            Code_attrs = case Language of
                {some, Lang} ->
                    add_attribute(
                        Attrs@1,
                        <<"class"/utf8>>,
                        <<"language-"/utf8, Lang/binary>>
                    );

                none ->
                    Attrs@1
            end,
            _pipe@4 = Html,
            _pipe@5 = open_tag(_pipe@4, <<"pre"/utf8>>, maps:new()),
            _pipe@6 = open_tag(_pipe@5, <<"code"/utf8>>, Code_attrs),
            _pipe@7 = append_to_html(_pipe@6, houdini:escape(Content)),
            _pipe@8 = close_tag(_pipe@7, <<"code"/utf8>>),
            close_tag(_pipe@8, <<"pre"/utf8>>);

        {heading, Attrs@2, Level, Inlines@1} ->
            Tag = <<"h"/utf8, (erlang:integer_to_binary(Level))/binary>>,
            _pipe@9 = Html,
            _pipe@10 = open_tag(_pipe@9, Tag, Attrs@2),
            _pipe@11 = inlines_to_html(_pipe@10, Inlines@1, Refs, trim_last),
            close_tag(_pipe@11, Tag);

        {raw_block, Content@1} ->
            _record = Html,
            {generated_html,
                <<(erlang:element(2, Html))/binary, Content@1/binary>>,
                erlang:element(3, _record)};

        {bullet_list, Layout, _, Items} ->
            _pipe@12 = Html,
            _pipe@13 = open_tag(_pipe@12, <<"ul"/utf8>>, maps:new()),
            _pipe@14 = append_to_html(_pipe@13, <<"\n"/utf8>>),
            _pipe@15 = list_items_to_html(_pipe@14, Layout, Items, Refs),
            close_tag(_pipe@15, <<"ul"/utf8>>)
    end,
    append_to_html(New_html, <<"\n"/utf8>>).

-file("src/jot.gleam", 1445).
-spec inline_to_html(generated_html(), inline(), refs(), trim()) -> generated_html().
inline_to_html(Html, Inline, Refs, Trim) ->
    case Inline of
        non_breaking_space ->
            _pipe = Html,
            append_to_html(_pipe, <<"&nbsp;"/utf8>>);

        linebreak ->
            _pipe@1 = Html,
            _pipe@2 = open_tag(_pipe@1, <<"br"/utf8>>, maps:new()),
            append_to_html(_pipe@2, <<"\n"/utf8>>);

        {text, Text} ->
            Text@1 = houdini:escape(Text),
            case Trim of
                no_trim ->
                    append_to_html(Html, Text@1);

                trim_last ->
                    append_to_html(Html, gleam@string:trim_end(Text@1))
            end;

        {strong, Inlines} ->
            _pipe@3 = Html,
            _pipe@4 = open_tag(_pipe@3, <<"strong"/utf8>>, maps:new()),
            _pipe@5 = inlines_to_html(_pipe@4, Inlines, Refs, Trim),
            close_tag(_pipe@5, <<"strong"/utf8>>);

        {emphasis, Inlines@1} ->
            _pipe@6 = Html,
            _pipe@7 = open_tag(_pipe@6, <<"em"/utf8>>, maps:new()),
            _pipe@8 = inlines_to_html(_pipe@7, Inlines@1, Refs, Trim),
            close_tag(_pipe@8, <<"em"/utf8>>);

        {link, Text@2, Destination} ->
            _pipe@9 = Html,
            _pipe@10 = open_tag(
                _pipe@9,
                <<"a"/utf8>>,
                destination_attribute(<<"href"/utf8>>, Destination, Refs)
            ),
            _pipe@11 = inlines_to_html(_pipe@10, Text@2, Refs, Trim),
            close_tag(_pipe@11, <<"a"/utf8>>);

        {image, Text@3, Destination@1} ->
            _pipe@12 = Html,
            open_tag(
                _pipe@12,
                <<"img"/utf8>>,
                begin
                    _pipe@13 = destination_attribute(
                        <<"src"/utf8>>,
                        Destination@1,
                        Refs
                    ),
                    gleam@dict:insert(
                        _pipe@13,
                        <<"alt"/utf8>>,
                        houdini:escape(take_inline_text(Text@3, <<""/utf8>>))
                    )
                end
            );

        {code, Content} ->
            Content@1 = houdini:escape(Content),
            _pipe@14 = Html,
            _pipe@15 = open_tag(_pipe@14, <<"code"/utf8>>, maps:new()),
            _pipe@16 = append_to_html(_pipe@15, Content@1),
            close_tag(_pipe@16, <<"code"/utf8>>);

        {footnote, Reference} ->
            {Footnote_number, New_used_footnotes} = find_footnote_number(
                erlang:element(3, Html),
                Reference,
                erlang:element(3, Html)
            ),
            Footnote_attrs = [{<<"id"/utf8>>,
                    <<"fnref"/utf8, Footnote_number/binary>>},
                {<<"href"/utf8>>, <<"#fn"/utf8, Footnote_number/binary>>},
                {<<"role"/utf8>>, <<"doc-noteref"/utf8>>}],
            Updated_html = begin
                _pipe@17 = Html,
                _pipe@18 = open_tag_ordered_attributes(
                    _pipe@17,
                    <<"a"/utf8>>,
                    Footnote_attrs
                ),
                _pipe@19 = append_to_html(
                    _pipe@18,
                    <<<<"<sup>"/utf8, Footnote_number/binary>>/binary,
                        "</sup>"/utf8>>
                ),
                close_tag(_pipe@19, <<"a"/utf8>>)
            end,
            _record = Updated_html,
            {generated_html, erlang:element(2, _record), New_used_footnotes}
    end.

-file("src/jot.gleam", 1423).
-spec inlines_to_html(generated_html(), list(inline()), refs(), trim()) -> generated_html().
inlines_to_html(Html, Inlines, Refs, Trim) ->
    case Inlines of
        [] ->
            Html;

        [Inline] when Trim =:= trim_last ->
            _pipe = Html,
            inline_to_html(_pipe, Inline, Refs, Trim);

        [Inline@1 | Rest] ->
            _pipe@1 = Html,
            _pipe@2 = inline_to_html(_pipe@1, Inline@1, Refs, no_trim),
            inlines_to_html(_pipe@2, Rest, Refs, Trim)
    end.

-file("src/jot.gleam", 1176).
-spec containers_to_html_with_last_paragraph(
    list(container()),
    refs(),
    generated_html(),
    fun((generated_html()) -> generated_html())
) -> generated_html().
containers_to_html_with_last_paragraph(Containers, Refs, Html, Apply) ->
    case Containers of
        [] ->
            Html;

        [Container] ->
            case Container of
                {paragraph, Attrs, Inlines} ->
                    _pipe = Html,
                    _pipe@1 = open_tag(_pipe, <<"p"/utf8>>, Attrs),
                    _pipe@2 = inlines_to_html(_pipe@1, Inlines, Refs, trim_last),
                    _pipe@3 = Apply(_pipe@2),
                    close_tag(_pipe@3, <<"p"/utf8>>);

                _ ->
                    _pipe@4 = container_to_html(Html, Container, Refs),
                    _pipe@5 = open_tag(_pipe@4, <<"p"/utf8>>, maps:new()),
                    _pipe@6 = Apply(_pipe@5),
                    close_tag(_pipe@6, <<"p"/utf8>>)
            end;

        [Container@1 | Rest] ->
            Html@1 = container_to_html(Html, Container@1, Refs),
            containers_to_html_with_last_paragraph(Rest, Refs, Html@1, Apply)
    end.

-file("src/jot.gleam", 1269).
-spec create_footnotes(
    document(),
    list({integer(), binary()}),
    generated_html()
) -> generated_html().
create_footnotes(Document, Used_footnotes, Html_acc) ->
    Footnote_to_html = fun(Html, Footnote, Footnote_number) ->
        _pipe = gleam_stdlib:map_get(erlang:element(4, Document), Footnote),
        _pipe@1 = gleam@result:then(
            _pipe,
            fun(Footnote@1) -> case gleam@list:is_empty(Footnote@1) of
                    true ->
                        {error, nil};

                    false ->
                        {ok, Footnote@1}
                end end
        ),
        _pipe@2 = gleam@result:map(
            _pipe@1,
            fun(Footnote@2) ->
                containers_to_html_with_last_paragraph(
                    Footnote@2,
                    {refs,
                        erlang:element(3, Document),
                        erlang:element(4, Document)},
                    Html,
                    fun(_capture) ->
                        add_footnote_link(_capture, Footnote_number)
                    end
                )
            end
        ),
        gleam@result:lazy_unwrap(_pipe@2, fun() -> _pipe@3 = Html,
                _pipe@4 = open_tag_ordered_attributes(_pipe@3, <<"p"/utf8>>, []),
                _pipe@5 = add_footnote_link(_pipe@4, Footnote_number),
                close_tag(_pipe@5, <<"p"/utf8>>) end)
    end,
    case Used_footnotes of
        [] ->
            Html_acc;

        [{Footnote_number@1, Footnote@3} | Other_footnotes] ->
            Footnote_number@2 = erlang:integer_to_binary(Footnote_number@1),
            Html@1 = begin
                _pipe@6 = Html_acc,
                _pipe@7 = open_tag(
                    _pipe@6,
                    <<"li"/utf8>>,
                    maps:from_list(
                        [{<<"id"/utf8>>,
                                <<"fn"/utf8, Footnote_number@2/binary>>}]
                    )
                ),
                _pipe@8 = append_to_html(_pipe@7, <<"\n"/utf8>>),
                _pipe@9 = Footnote_to_html(
                    _pipe@8,
                    Footnote@3,
                    Footnote_number@2
                ),
                _pipe@10 = append_to_html(_pipe@9, <<"\n"/utf8>>),
                _pipe@11 = close_tag(_pipe@10, <<"li"/utf8>>),
                append_to_html(_pipe@11, <<"\n"/utf8>>)
            end,
            New_used_footnotes = lists:append(
                get_new_footnotes(Html_acc, Html@1, []),
                Other_footnotes
            ),
            create_footnotes(Document, New_used_footnotes, Html@1)
    end.

-file("src/jot.gleam", 1130).
?DOC(" Convert a document tree into a string of HTML.\n").
-spec document_to_html(document()) -> binary().
document_to_html(Document) ->
    Generated_html = containers_to_html(
        erlang:element(2, Document),
        {refs, erlang:element(3, Document), erlang:element(4, Document)},
        {generated_html, <<""/utf8>>, []}
    ),
    gleam@bool:guard(
        gleam@list:is_empty(erlang:element(3, Generated_html)),
        erlang:element(2, Generated_html),
        fun() ->
            Footnotes_section_html = begin
                _pipe = Generated_html,
                _pipe@1 = open_tag(
                    _pipe,
                    <<"section"/utf8>>,
                    maps:from_list([{<<"role"/utf8>>, <<"doc-endnotes"/utf8>>}])
                ),
                _pipe@2 = append_to_html(_pipe@1, <<"\n"/utf8>>),
                _pipe@3 = open_tag(_pipe@2, <<"hr"/utf8>>, maps:new()),
                _pipe@4 = append_to_html(_pipe@3, <<"\n"/utf8>>),
                _pipe@5 = open_tag(_pipe@4, <<"ol"/utf8>>, maps:new()),
                append_to_html(_pipe@5, <<"\n"/utf8>>)
            end,
            Html_with_footnotes = create_footnotes(
                Document,
                lists:reverse(erlang:element(3, Footnotes_section_html)),
                Footnotes_section_html
            ),
            erlang:element(
                2,
                begin
                    _pipe@6 = Html_with_footnotes,
                    _pipe@7 = close_tag(_pipe@6, <<"ol"/utf8>>),
                    _pipe@8 = append_to_html(_pipe@7, <<"\n"/utf8>>),
                    _pipe@9 = close_tag(_pipe@8, <<"section"/utf8>>),
                    append_to_html(_pipe@9, <<"\n"/utf8>>)
                end
            )
        end
    ).

-file("src/jot.gleam", 180).
?DOC(
    " Parse a block of Djot that ends once the content is no longer indented\n"
    " to a certain level.\n"
    " For example:\n"
    "\n"
    " ```djot\n"
    " Here's the reference.[^ref]\n"
    "\n"
    " [^ref]: This footnote is a block with two paragraphs.\n"
    "\n"
    "   This is part of the block because it is indented past the start of `[^ref]`\n"
    "\n"
    " But this would not be parsed as part of the block because it has no indentation\n"
    " ```\n"
).
-spec parse_block(
    binary(),
    refs(),
    splitters(),
    list(container()),
    gleam@dict:dict(binary(), binary()),
    integer()
) -> {list(container()), refs(), binary()}.
parse_block(In, Refs, Splitters, Ast, Attrs, Required_spaces) ->
    In@1 = drop_lines(In),
    {In@2, Indentation} = count_drop_spaces(In@1, 0),
    case Indentation < Required_spaces of
        true ->
            {lists:reverse(Ast), Refs, In@2};

        false ->
            {In@3, Refs@1, Container, Attrs@1} = parse_container(
                In@2,
                Refs,
                Splitters,
                Attrs,
                Indentation
            ),
            Ast@1 = case Container of
                none ->
                    Ast;

                {some, Container@1} ->
                    [Container@1 | Ast]
            end,
            case In@3 of
                <<""/utf8>> ->
                    {lists:reverse(Ast@1), Refs@1, In@3};

                _ ->
                    parse_block(
                        In@3,
                        Refs@1,
                        Splitters,
                        Ast@1,
                        Attrs@1,
                        Required_spaces
                    )
            end
    end.

-file("src/jot.gleam", 233).
-spec parse_container(
    binary(),
    refs(),
    splitters(),
    gleam@dict:dict(binary(), binary()),
    integer()
) -> {binary(),
    refs(),
    gleam@option:option(container()),
    gleam@dict:dict(binary(), binary())}.
parse_container(In, Refs, Splitters, Attrs, Indentation) ->
    case In of
        <<""/utf8>> ->
            {In, Refs, none, maps:new()};

        <<"{"/utf8, In2/binary>> ->
            case parse_attributes(In2, Attrs) of
                none ->
                    {Paragraph, In@1} = parse_paragraph(In, Attrs, Splitters),
                    {In@1, Refs, {some, Paragraph}, maps:new()};

                {some, {Attrs@1, In@2}} ->
                    {In@2, Refs, none, Attrs@1}
            end;

        <<"#"/utf8, In@3/binary>> ->
            {Heading, Refs@1, In@4} = parse_heading(
                In@3,
                Refs,
                Splitters,
                Attrs
            ),
            {In@4, Refs@1, {some, Heading}, maps:new()};

        <<Delim:1/binary, In2@1/binary>> when Delim =:= <<"~"/utf8>> ->
            case parse_codeblock(In2@1, Attrs, Delim, Indentation, Splitters) of
                none ->
                    {Paragraph@1, In@5} = parse_paragraph(In, Attrs, Splitters),
                    {In@5, Refs, {some, Paragraph@1}, maps:new()};

                {some, {Codeblock, In@6}} ->
                    {In@6, Refs, {some, Codeblock}, maps:new()}
            end;

        <<Delim:1/binary, In2@1/binary>> when Delim =:= <<"`"/utf8>> ->
            case parse_codeblock(In2@1, Attrs, Delim, Indentation, Splitters) of
                none ->
                    {Paragraph@1, In@5} = parse_paragraph(In, Attrs, Splitters),
                    {In@5, Refs, {some, Paragraph@1}, maps:new()};

                {some, {Codeblock, In@6}} ->
                    {In@6, Refs, {some, Codeblock}, maps:new()}
            end;

        <<Style:1/binary, In2@2/binary>> when Style =:= <<"-"/utf8>> ->
            case {parse_thematic_break(1, In2@2), In2@2} of
                {none, <<" "/utf8, In2@3/binary>>} ->
                    {List, In@7} = parse_bullet_list(
                        In2@3,
                        Refs,
                        Attrs,
                        Style,
                        tight,
                        [],
                        Splitters
                    ),
                    {In@7, Refs, {some, List}, maps:new()};

                {none, <<"\n"/utf8, In2@3/binary>>} ->
                    {List, In@7} = parse_bullet_list(
                        In2@3,
                        Refs,
                        Attrs,
                        Style,
                        tight,
                        [],
                        Splitters
                    ),
                    {In@7, Refs, {some, List}, maps:new()};

                {none, _} ->
                    {Paragraph@2, In@8} = parse_paragraph(In, Attrs, Splitters),
                    {In@8, Refs, {some, Paragraph@2}, maps:new()};

                {{some, {Thematic_break, In@9}}, _} ->
                    {In@9, Refs, {some, Thematic_break}, maps:new()}
            end;

        <<Style:1/binary, In2@2/binary>> when Style =:= <<"*"/utf8>> ->
            case {parse_thematic_break(1, In2@2), In2@2} of
                {none, <<" "/utf8, In2@3/binary>>} ->
                    {List, In@7} = parse_bullet_list(
                        In2@3,
                        Refs,
                        Attrs,
                        Style,
                        tight,
                        [],
                        Splitters
                    ),
                    {In@7, Refs, {some, List}, maps:new()};

                {none, <<"\n"/utf8, In2@3/binary>>} ->
                    {List, In@7} = parse_bullet_list(
                        In2@3,
                        Refs,
                        Attrs,
                        Style,
                        tight,
                        [],
                        Splitters
                    ),
                    {In@7, Refs, {some, List}, maps:new()};

                {none, _} ->
                    {Paragraph@2, In@8} = parse_paragraph(In, Attrs, Splitters),
                    {In@8, Refs, {some, Paragraph@2}, maps:new()};

                {{some, {Thematic_break, In@9}}, _} ->
                    {In@9, Refs, {some, Thematic_break}, maps:new()}
            end;

        <<"[^"/utf8, In2@4/binary>> ->
            case parse_footnote_def(In2@4, Refs, Splitters, <<"^"/utf8>>) of
                none ->
                    {Paragraph@3, In@10} = parse_paragraph(In, Attrs, Splitters),
                    {In@10, Refs, {some, Paragraph@3}, maps:new()};

                {some, {Id, Footnote, Refs@2, In@11}} ->
                    Refs@3 = begin
                        _record = Refs@2,
                        {refs,
                            erlang:element(2, _record),
                            gleam@dict:insert(
                                erlang:element(3, Refs@2),
                                Id,
                                Footnote
                            )}
                    end,
                    {In@11, Refs@3, none, maps:new()}
            end;

        <<"["/utf8, In2@5/binary>> ->
            case parse_ref_def(In2@5, <<""/utf8>>) of
                none ->
                    {Paragraph@4, In@12} = parse_paragraph(In, Attrs, Splitters),
                    {In@12, Refs, {some, Paragraph@4}, maps:new()};

                {some, {Id@1, Url, In@13}} ->
                    Refs@4 = begin
                        _record@1 = Refs,
                        {refs,
                            gleam@dict:insert(
                                erlang:element(2, Refs),
                                Id@1,
                                Url
                            ),
                            erlang:element(3, _record@1)}
                    end,
                    {In@13, Refs@4, none, maps:new()}
            end;

        _ ->
            {Paragraph@5, In@14} = parse_paragraph(In, Attrs, Splitters),
            {In@14, Refs, {some, Paragraph@5}, maps:new()}
    end.

-file("src/jot.gleam", 462).
-spec parse_footnote_def(binary(), refs(), splitters(), binary()) -> gleam@option:option({binary(),
    list(container()),
    refs(),
    binary()}).
parse_footnote_def(In, Refs, Splitters, Id) ->
    case In of
        <<"]:"/utf8, In@1/binary>> ->
            {In@2, Spaces_count} = count_drop_spaces(In@1, 0),
            Block_parser = case In@2 of
                <<"\n"/utf8, _/binary>> ->
                    fun parse_block/6;

                _ ->
                    fun(In@3, Refs@1, Splitters@1, Ast, Attrs, Required_spaces) ->
                        parse_block_after_indent_checked(
                            In@3,
                            Refs@1,
                            Splitters@1,
                            Ast,
                            Attrs,
                            Required_spaces,
                            (4 + string:length(Id)) + Spaces_count
                        )
                    end
            end,
            {Block, Refs@2, Rest} = Block_parser(
                In@2,
                Refs,
                Splitters,
                [],
                maps:new(),
                1
            ),
            {some, {Id, Block, Refs@2, Rest}};

        <<""/utf8>> ->
            none;

        <<"]"/utf8, _/binary>> ->
            none;

        <<"\n"/utf8, _/binary>> ->
            none;

        _ ->
            case gleam_stdlib:string_pop_grapheme(In) of
                {ok, {C, In@4}} ->
                    parse_footnote_def(
                        In@4,
                        Refs,
                        Splitters,
                        <<Id/binary, C/binary>>
                    );

                {error, _} ->
                    none
            end
    end.

-file("src/jot.gleam", 145).
-spec parse_document_content(
    binary(),
    refs(),
    splitters(),
    list(container()),
    gleam@dict:dict(binary(), binary())
) -> {list(container()), refs(), binary()}.
parse_document_content(In, Refs, Splitters, Ast, Attrs) ->
    In@1 = drop_lines(In),
    {In@2, Spaces_count} = count_drop_spaces(In@1, 0),
    {In@3, Refs@1, Container, Attrs@1} = parse_container(
        In@2,
        Refs,
        Splitters,
        Attrs,
        Spaces_count
    ),
    Ast@1 = case Container of
        none ->
            Ast;

        {some, Container@1} ->
            [Container@1 | Ast]
    end,
    case In@3 of
        <<""/utf8>> ->
            {lists:reverse(Ast@1), Refs@1, In@3};

        _ ->
            parse_document_content(In@3, Refs@1, Splitters, Ast@1, Attrs@1)
    end.

-file("src/jot.gleam", 103).
?DOC(
    " Convert a string of Djot into a tree of records.\n"
    "\n"
    " This may be useful when you want more control over the HTML to be converted\n"
    " to, or you wish to convert Djot to some other format.\n"
).
-spec parse(binary()) -> document().
parse(Djot) ->
    Splitters = {splitters,
        splitter:new([<<" "/utf8>>, <<"\n"/utf8>>]),
        splitter:new([<<"`"/utf8>>, <<"\n"/utf8>>]),
        splitter:new(
            [<<"\\"/utf8>>,
                <<"_"/utf8>>,
                <<"*"/utf8>>,
                <<"[^"/utf8>>,
                <<"["/utf8>>,
                <<"!["/utf8>>,
                <<"`"/utf8>>,
                <<"\n"/utf8>>]
        ),
        splitter:new([<<")"/utf8>>, <<"]"/utf8>>, <<"\n"/utf8>>])},
    Refs = {refs, maps:new(), maps:new()},
    {Ast, {refs, Urls, Footnotes}, _} = begin
        _pipe = Djot,
        _pipe@1 = gleam@string:replace(_pipe, <<"\r\n"/utf8>>, <<"\n"/utf8>>),
        parse_document_content(_pipe@1, Refs, Splitters, [], maps:new())
    end,
    {document, Ast, Urls, Footnotes}.

-file("src/jot.gleam", 83).
?DOC(
    " Convert a string of Djot into a string of HTML.\n"
    "\n"
    " If you want to have more control over the HTML generated you can use the\n"
    " `parse` function to convert Djot to a tree of records instead. You can then\n"
    " traverse this tree and turn it into HTML yourself.\n"
).
-spec to_html(binary()) -> binary().
to_html(Djot) ->
    _pipe = Djot,
    _pipe@1 = parse(_pipe),
    document_to_html(_pipe@1).

-file("src/jot.gleam", 212).
?DOC(
    " This function allows us to parse the contents of a block after we know\n"
    " that the *first* container meets indentation requirements, but we want to\n"
    " ensure that once this container is parsed, future containers meet the\n"
    " indentation requirements\n"
).
-spec parse_block_after_indent_checked(
    binary(),
    refs(),
    splitters(),
    list(container()),
    gleam@dict:dict(binary(), binary()),
    integer(),
    integer()
) -> {list(container()), refs(), binary()}.
parse_block_after_indent_checked(
    In,
    Refs,
    Splitters,
    Ast,
    Attrs,
    Required_spaces,
    Indentation
) ->
    {In@1, Refs@1, Container, Attrs@1} = parse_container(
        In,
        Refs,
        Splitters,
        Attrs,
        Indentation
    ),
    Ast@1 = case Container of
        none ->
            Ast;

        {some, Container@1} ->
            [Container@1 | Ast]
    end,
    case In@1 of
        <<""/utf8>> ->
            {lists:reverse(Ast@1), Refs@1, In@1};

        _ ->
            parse_block(
                In@1,
                Refs@1,
                Splitters,
                Ast@1,
                Attrs@1,
                Required_spaces
            )
    end.

-file("src/jot.gleam", 1078).
-spec parse_list_item(
    binary(),
    refs(),
    gleam@dict:dict(binary(), binary()),
    splitters(),
    list(container())
) -> list(container()).
parse_list_item(In, Refs, Attrs, Splitters, Children) ->
    {In@1, Refs@1, Container, Attrs@1} = parse_container(
        In,
        Refs,
        Splitters,
        Attrs,
        0
    ),
    Children@1 = case Container of
        none ->
            Children;

        {some, Container@1} ->
            [Container@1 | Children]
    end,
    case In@1 of
        <<""/utf8>> ->
            lists:reverse(Children@1);

        _ ->
            parse_list_item(In@1, Refs@1, Attrs@1, Splitters, Children@1)
    end.

-file("src/jot.gleam", 1060).
-spec parse_bullet_list(
    binary(),
    refs(),
    gleam@dict:dict(binary(), binary()),
    binary(),
    list_layout(),
    list(list(container())),
    splitters()
) -> {container(), binary()}.
parse_bullet_list(In, Refs, Attrs, Style, Layout, Items, Splitters) ->
    {Inline_in, In@1, End} = take_list_item_chars(In, <<""/utf8>>, Style),
    Item = parse_list_item(Inline_in, Refs, Attrs, Splitters, []),
    Items@1 = [Item | Items],
    case End of
        true ->
            {{bullet_list, Layout, Style, lists:reverse(Items@1)}, In@1};

        false ->
            parse_bullet_list(
                In@1,
                Refs,
                Attrs,
                Style,
                Layout,
                Items@1,
                Splitters
            )
    end.

-file("src/jot.gleam", 890).
-spec parse_emphasis(binary(), splitters(), binary()) -> gleam@option:option({list(inline()),
    binary()}).
parse_emphasis(In, Splitters, Close) ->
    case take_emphasis_chars(In, Close, <<""/utf8>>) of
        none ->
            none;

        {some, {Inline_in, In@1}} ->
            {Inline, Inline_in_remaining} = parse_inline(
                Inline_in,
                Splitters,
                <<""/utf8>>,
                []
            ),
            {some, {Inline, <<Inline_in_remaining/binary, In@1/binary>>}}
    end.

-file("src/jot.gleam", 691).
-spec parse_inline(binary(), splitters(), binary(), list(inline())) -> {list(inline()),
    binary()}.
parse_inline(In, Splitters, Text, Acc) ->
    case splitter_ffi:split(erlang:element(4, Splitters), In) of
        {Text2, <<""/utf8>>, <<""/utf8>>} ->
            case <<Text/binary, Text2/binary>> of
                <<""/utf8>> ->
                    {lists:reverse(Acc), <<""/utf8>>};

                Text@1 ->
                    {lists:reverse([{text, Text@1} | Acc]), <<""/utf8>>}
            end;

        {A, <<"\\"/utf8>>, In@1} ->
            Text@2 = <<Text/binary, A/binary>>,
            case In@1 of
                <<E:1/binary, In@2/binary>> when E =:= <<"!"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"\""/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"#"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"$"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"%"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"&"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"'"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"("/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<")"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"*"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"+"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<","/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"-"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"."/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"/"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<":"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<";"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"<"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"="/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<">"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"?"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"@"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"["/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"\\"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"]"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"^"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"_"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"`"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"{"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"|"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"}"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<E:1/binary, In@2/binary>> when E =:= <<"~"/utf8>> ->
                    parse_inline(
                        In@2,
                        Splitters,
                        <<Text@2/binary, E/binary>>,
                        Acc
                    );

                <<"\n"/utf8, In@3/binary>> ->
                    parse_inline(
                        In@3,
                        Splitters,
                        <<""/utf8>>,
                        [linebreak, {text, Text@2} | Acc]
                    );

                <<" "/utf8, In@4/binary>> ->
                    parse_inline(
                        In@4,
                        Splitters,
                        <<""/utf8>>,
                        [non_breaking_space, {text, Text@2} | Acc]
                    );

                _ ->
                    parse_inline(
                        In@1,
                        Splitters,
                        <<Text@2/binary, "\\"/utf8>>,
                        Acc
                    )
            end;

        {A@1, <<"_"/utf8>> = Start, In@5} ->
            Text@3 = <<Text/binary, A@1/binary>>,
            case In@5 of
                <<B:1/binary, In@6/binary>> when B =:= <<" "/utf8>> ->
                    parse_inline(
                        In@6,
                        Splitters,
                        <<<<Text@3/binary, Start/binary>>/binary, B/binary>>,
                        Acc
                    );

                <<B:1/binary, In@6/binary>> when B =:= <<"\t"/utf8>> ->
                    parse_inline(
                        In@6,
                        Splitters,
                        <<<<Text@3/binary, Start/binary>>/binary, B/binary>>,
                        Acc
                    );

                <<B:1/binary, In@6/binary>> when B =:= <<"\n"/utf8>> ->
                    parse_inline(
                        In@6,
                        Splitters,
                        <<<<Text@3/binary, Start/binary>>/binary, B/binary>>,
                        Acc
                    );

                _ ->
                    case parse_emphasis(In@5, Splitters, Start) of
                        none ->
                            parse_inline(
                                In@5,
                                Splitters,
                                <<Text@3/binary, Start/binary>>,
                                Acc
                            );

                        {some, {Inner, In@7}} ->
                            Item = case Start of
                                <<"*"/utf8>> ->
                                    {strong, Inner};

                                _ ->
                                    {emphasis, Inner}
                            end,
                            parse_inline(
                                In@7,
                                Splitters,
                                <<""/utf8>>,
                                [Item, {text, Text@3} | Acc]
                            )
                    end
            end;

        {A@1, <<"*"/utf8>> = Start, In@5} ->
            Text@3 = <<Text/binary, A@1/binary>>,
            case In@5 of
                <<B:1/binary, In@6/binary>> when B =:= <<" "/utf8>> ->
                    parse_inline(
                        In@6,
                        Splitters,
                        <<<<Text@3/binary, Start/binary>>/binary, B/binary>>,
                        Acc
                    );

                <<B:1/binary, In@6/binary>> when B =:= <<"\t"/utf8>> ->
                    parse_inline(
                        In@6,
                        Splitters,
                        <<<<Text@3/binary, Start/binary>>/binary, B/binary>>,
                        Acc
                    );

                <<B:1/binary, In@6/binary>> when B =:= <<"\n"/utf8>> ->
                    parse_inline(
                        In@6,
                        Splitters,
                        <<<<Text@3/binary, Start/binary>>/binary, B/binary>>,
                        Acc
                    );

                _ ->
                    case parse_emphasis(In@5, Splitters, Start) of
                        none ->
                            parse_inline(
                                In@5,
                                Splitters,
                                <<Text@3/binary, Start/binary>>,
                                Acc
                            );

                        {some, {Inner, In@7}} ->
                            Item = case Start of
                                <<"*"/utf8>> ->
                                    {strong, Inner};

                                _ ->
                                    {emphasis, Inner}
                            end,
                            parse_inline(
                                In@7,
                                Splitters,
                                <<""/utf8>>,
                                [Item, {text, Text@3} | Acc]
                            )
                    end
            end;

        {A@2, <<"[^"/utf8>>, Rest} ->
            Text@4 = <<Text/binary, A@2/binary>>,
            case parse_footnote(Rest, <<"^"/utf8>>) of
                none ->
                    parse_inline(
                        Rest,
                        Splitters,
                        <<Text@4/binary, "[^"/utf8>>,
                        Acc
                    );

                {some, {_, <<":"/utf8, _/binary>>}} when Text@4 =/= <<""/utf8>> ->
                    {lists:reverse([{text, Text@4} | Acc]), In};

                {some, {_, <<":"/utf8, _/binary>>}} ->
                    {lists:reverse(Acc), In};

                {some, {Footnote, In@8}} ->
                    parse_inline(
                        In@8,
                        Splitters,
                        <<""/utf8>>,
                        [Footnote, {text, Text@4} | Acc]
                    )
            end;

        {A@3, <<"["/utf8>>, In@9} ->
            Text@5 = <<Text/binary, A@3/binary>>,
            case parse_link(
                In@9,
                Splitters,
                fun(Field@0, Field@1) -> {link, Field@0, Field@1} end
            ) of
                none ->
                    parse_inline(
                        In@9,
                        Splitters,
                        <<Text@5/binary, "["/utf8>>,
                        Acc
                    );

                {some, {Link, In@10}} ->
                    parse_inline(
                        In@10,
                        Splitters,
                        <<""/utf8>>,
                        [Link, {text, Text@5} | Acc]
                    )
            end;

        {A@4, <<"!["/utf8>>, In@11} ->
            Text@6 = <<Text/binary, A@4/binary>>,
            case parse_link(
                In@11,
                Splitters,
                fun(Field@0, Field@1) -> {image, Field@0, Field@1} end
            ) of
                none ->
                    parse_inline(
                        In@11,
                        Splitters,
                        <<Text@6/binary, "!["/utf8>>,
                        Acc
                    );

                {some, {Image, In@12}} ->
                    parse_inline(
                        In@12,
                        Splitters,
                        <<""/utf8>>,
                        [Image, {text, Text@6} | Acc]
                    )
            end;

        {A@5, <<"`"/utf8>>, In@13} ->
            Text@7 = <<Text/binary, A@5/binary>>,
            {Code, In@14} = parse_code(In@13, 1),
            parse_inline(
                In@14,
                Splitters,
                <<""/utf8>>,
                [Code, {text, Text@7} | Acc]
            );

        {A@6, <<"\n"/utf8>>, In@15} ->
            Text@8 = <<Text/binary, A@6/binary>>,
            _pipe = drop_spaces(In@15),
            parse_inline(_pipe, Splitters, <<Text@8/binary, "\n"/utf8>>, Acc);

        {Text2@1, Text3, In@16} ->
            case <<<<Text/binary, Text2@1/binary>>/binary, Text3/binary>> of
                <<""/utf8>> ->
                    {lists:reverse(Acc), In@16};

                Text@9 ->
                    {lists:reverse([{text, Text@9} | Acc]), In@16}
            end
    end.

-file("src/jot.gleam", 935).
-spec parse_link(
    binary(),
    splitters(),
    fun((list(inline()), destination()) -> inline())
) -> gleam@option:option({inline(), binary()}).
parse_link(In, Splitters, To_inline) ->
    case take_link_chars(In, <<""/utf8>>, Splitters) of
        none ->
            none;

        {some, {Inline_in, Ref, In@1}} ->
            {Inline, Inline_in_remaining} = parse_inline(
                Inline_in,
                Splitters,
                <<""/utf8>>,
                []
            ),
            Ref@2 = case Ref of
                {reference, <<""/utf8>>} ->
                    {reference, take_inline_text(Inline, <<""/utf8>>)};

                Ref@1 ->
                    Ref@1
            end,
            {some,
                {To_inline(Inline, Ref@2),
                    <<Inline_in_remaining/binary, In@1/binary>>}}
    end.

-file("src/jot.gleam", 1049).
-spec parse_paragraph(
    binary(),
    gleam@dict:dict(binary(), binary()),
    splitters()
) -> {container(), binary()}.
parse_paragraph(In, Attrs, Splitters) ->
    {Inline_in, In@1} = take_paragraph_chars(In),
    {Inline, Inline_in_remaining} = parse_inline(
        Inline_in,
        Splitters,
        <<""/utf8>>,
        []
    ),
    {{paragraph, Attrs, Inline}, <<Inline_in_remaining/binary, In@1/binary>>}.

-file("src/jot.gleam", 606).
-spec parse_heading(
    binary(),
    refs(),
    splitters(),
    gleam@dict:dict(binary(), binary())
) -> {container(), refs(), binary()}.
parse_heading(In, Refs, Splitters, Attrs) ->
    case heading_level(In, 1) of
        {some, {Level, In@1}} ->
            In@2 = drop_spaces(In@1),
            {Inline_in, In@3} = take_heading_chars(In@2, Level, <<""/utf8>>),
            {Inline, Inline_in_remaining} = parse_inline(
                Inline_in,
                Splitters,
                <<""/utf8>>,
                []
            ),
            Text = take_inline_text(Inline, <<""/utf8>>),
            {Refs@2, Attrs@2} = case id_sanitise(Text) of
                <<""/utf8>> ->
                    {Refs, Attrs};

                Id ->
                    case gleam_stdlib:map_get(erlang:element(2, Refs), Id) of
                        {ok, _} ->
                            {Refs, Attrs};

                        {error, _} ->
                            Refs@1 = begin
                                _record = Refs,
                                {refs,
                                    gleam@dict:insert(
                                        erlang:element(2, Refs),
                                        Id,
                                        <<"#"/utf8, Id/binary>>
                                    ),
                                    erlang:element(3, _record)}
                            end,
                            Attrs@1 = add_attribute(Attrs, <<"id"/utf8>>, Id),
                            {Refs@1, Attrs@1}
                    end
            end,
            Heading = {heading, Attrs@2, Level, Inline},
            {Heading, Refs@2, <<Inline_in_remaining/binary, In@3/binary>>};

        none ->
            {P, In@4} = parse_paragraph(
                <<"#"/utf8, In/binary>>,
                Attrs,
                Splitters
            ),
            {P, Refs, In@4}
    end.
