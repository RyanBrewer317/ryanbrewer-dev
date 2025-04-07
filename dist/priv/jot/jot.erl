-module(jot).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([document_to_html/1, parse/1, to_html/1]).
-export_type([document/0, container/0, inline/0, destination/0, refs/0, generated_html/0]).

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
        binary()}.

-type inline() :: linebreak |
    {text, binary()} |
    {link, list(inline()), destination()} |
    {image, list(inline()), destination()} |
    {emphasis, list(inline())} |
    {strong, list(inline())} |
    {footnote, binary()} |
    {code, binary()}.

-type destination() :: {reference, binary()} | {url, binary()}.

-type refs() :: {refs,
        gleam@dict:dict(binary(), binary()),
        gleam@dict:dict(binary(), list(container()))}.

-type generated_html() :: {generated_html,
        binary(),
        list({integer(), binary()})}.

-file("src/jot.gleam", 19).
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

-file("src/jot.gleam", 97).
-spec drop_lines(list(binary())) -> list(binary()).
drop_lines(In) ->
    case In of
        [] ->
            [];

        [<<"\n"/utf8>> | Rest] ->
            drop_lines(Rest);

        [C | Rest@1] ->
            [C | Rest@1]
    end.

-file("src/jot.gleam", 105).
-spec drop_spaces(list(binary())) -> list(binary()).
drop_spaces(In) ->
    case In of
        [] ->
            [];

        [<<" "/utf8>> | Rest] ->
            drop_spaces(Rest);

        [C | Rest@1] ->
            [C | Rest@1]
    end.

-file("src/jot.gleam", 113).
-spec count_drop_spaces(list(binary()), integer()) -> {list(binary()),
    integer()}.
count_drop_spaces(In, Count) ->
    case In of
        [] ->
            {[], Count};

        [<<" "/utf8>> | Rest] ->
            count_drop_spaces(Rest, Count + 1);

        [C | Rest@1] ->
            {[C | Rest@1], Count}
    end.

-file("src/jot.gleam", 275).
-spec parse_thematic_break(integer(), list(binary())) -> gleam@option:option({container(),
    list(binary())}).
parse_thematic_break(Count, In) ->
    case In of
        [] ->
            case Count >= 3 of
                true ->
                    {some, {thematic_break, In}};

                false ->
                    none
            end;

        [<<"\n"/utf8>> | _] ->
            case Count >= 3 of
                true ->
                    {some, {thematic_break, In}};

                false ->
                    none
            end;

        [<<" "/utf8>> | Rest] ->
            parse_thematic_break(Count, Rest);

        [<<"\t"/utf8>> | Rest] ->
            parse_thematic_break(Count, Rest);

        [<<"-"/utf8>> | Rest@1] ->
            parse_thematic_break(Count + 1, Rest@1);

        [<<"*"/utf8>> | Rest@1] ->
            parse_thematic_break(Count + 1, Rest@1);

        _ ->
            none
    end.

-file("src/jot.gleam", 333).
-spec slurp_verbatim_line(list(binary()), integer(), binary()) -> {binary(),
    list(binary())}.
slurp_verbatim_line(In, Indentation, Acc) ->
    case In of
        [] ->
            {Acc, []};

        [<<" "/utf8>> | In@1] when Indentation > 0 ->
            slurp_verbatim_line(In@1, Indentation - 1, Acc);

        [<<"\n"/utf8>> | In@2] ->
            {<<Acc/binary, "\n"/utf8>>, In@2};

        [C | In@3] ->
            slurp_verbatim_line(In@3, 0, <<Acc/binary, C/binary>>)
    end.

-file("src/jot.gleam", 348).
-spec parse_codeblock_end(list(binary()), binary(), integer()) -> gleam@option:option({list(binary())}).
parse_codeblock_end(In, Delim, Count) ->
    case In of
        [<<"\n"/utf8>> | In@1] when Count =:= 0 ->
            {some, {In@1}};

        _ when Count =:= 0 ->
            {some, {In}};

        [<<" "/utf8>> | In@2] ->
            parse_codeblock_end(In@2, Delim, Count);

        [C | In@3] when C =:= Delim ->
            parse_codeblock_end(In@3, Delim, Count - 1);

        [] ->
            {some, {In}};

        _ ->
            none
    end.

-file("src/jot.gleam", 317).
-spec parse_codeblock_content(
    list(binary()),
    binary(),
    integer(),
    integer(),
    binary()
) -> {binary(), list(binary())}.
parse_codeblock_content(In, Delim, Count, Indentation, Acc) ->
    case parse_codeblock_end(In, Delim, Count) of
        none ->
            {Acc@1, In@1} = slurp_verbatim_line(In, Indentation, Acc),
            parse_codeblock_content(In@1, Delim, Count, Indentation, Acc@1);

        {some, {In@2}} ->
            {Acc, In@2}
    end.

-file("src/jot.gleam", 362).
-spec parse_codeblock_language(list(binary()), binary()) -> gleam@option:option({gleam@option:option(binary()),
    list(binary())}).
parse_codeblock_language(In, Language) ->
    case In of
        [<<"`"/utf8>> | _] ->
            none;

        [] ->
            {some, {none, In}};

        [<<"\n"/utf8>> | In@1] when Language =:= <<""/utf8>> ->
            {some, {none, In@1}};

        [<<"\n"/utf8>> | In@2] ->
            {some, {{some, Language}, In@2}};

        [C | In@3] ->
            parse_codeblock_language(In@3, <<Language/binary, C/binary>>)
    end.

-file("src/jot.gleam", 300).
-spec parse_codeblock_start(list(binary()), binary(), integer()) -> gleam@option:option({gleam@option:option(binary()),
    integer(),
    list(binary())}).
parse_codeblock_start(In, Delim, Count) ->
    case In of
        [C | In@1] when C =:= Delim ->
            parse_codeblock_start(In@1, Delim, Count + 1);

        [<<"\n"/utf8>> | In@2] when Count >= 3 ->
            {some, {none, Count, In@2}};

        [_ | _] when Count >= 3 ->
            In@3 = drop_spaces(In),
            gleam@option:map(
                parse_codeblock_language(In@3, <<""/utf8>>),
                fun(_use0) ->
                    {Language, In@4} = _use0,
                    {Language, Count, In@4}
                end
            );

        _ ->
            none
    end.

-file("src/jot.gleam", 288).
-spec parse_codeblock(
    list(binary()),
    gleam@dict:dict(binary(), binary()),
    binary(),
    integer()
) -> gleam@option:option({container(), list(binary())}).
parse_codeblock(In, Attrs, Delim, Indentation) ->
    gleam@option:then(
        parse_codeblock_start(In, Delim, 1),
        fun(_use0) ->
            {Language, Count, In@1} = _use0,
            {Content, In@2} = parse_codeblock_content(
                In@1,
                Delim,
                Count,
                Indentation,
                <<""/utf8>>
            ),
            {some, {{codeblock, Attrs, Language, Content}, In@2}}
        end
    ).

-file("src/jot.gleam", 385).
-spec parse_ref_value(list(binary()), binary(), binary()) -> gleam@option:option({binary(),
    binary(),
    list(binary())}).
parse_ref_value(In, Id, Url) ->
    case In of
        [] ->
            {some, {Id, gleam@string:trim(Url), []}};

        [<<"\n"/utf8>>, <<" "/utf8>> | In@1] ->
            parse_ref_value(drop_spaces(In@1), Id, Url);

        [<<"\n"/utf8>> | In@2] ->
            {some, {Id, gleam@string:trim(Url), In@2}};

        [C | In@3] ->
            parse_ref_value(In@3, Id, <<Url/binary, C/binary>>)
    end.

-file("src/jot.gleam", 377).
-spec parse_ref_def(list(binary()), binary()) -> gleam@option:option({binary(),
    binary(),
    list(binary())}).
parse_ref_def(In, Id) ->
    case In of
        [<<"]"/utf8>>, <<":"/utf8>> | In@1] ->
            parse_ref_value(In@1, Id, <<""/utf8>>);

        [] ->
            none;

        [<<"]"/utf8>> | _] ->
            none;

        [<<"\n"/utf8>> | _] ->
            none;

        [C | In@2] ->
            parse_ref_def(In@2, <<Id/binary, C/binary>>)
    end.

-file("src/jot.gleam", 469).
-spec parse_attribute_value(list(binary()), binary(), binary()) -> gleam@option:option({binary(),
    binary(),
    list(binary())}).
parse_attribute_value(In, Key, Value) ->
    case In of
        [] ->
            none;

        [<<" "/utf8>> | In@1] ->
            {some, {Key, Value, In@1}};

        [<<"}"/utf8>> | _] ->
            {some, {Key, Value, In}};

        [C | In@2] ->
            parse_attribute_value(In@2, Key, <<Value/binary, C/binary>>)
    end.

-file("src/jot.gleam", 482).
-spec parse_attribute_quoted_value(list(binary()), binary(), binary()) -> gleam@option:option({binary(),
    binary(),
    list(binary())}).
parse_attribute_quoted_value(In, Key, Value) ->
    case In of
        [] ->
            none;

        [<<"\""/utf8>> | In@1] ->
            {some, {Key, Value, In@1}};

        [C | In@2] ->
            parse_attribute_quoted_value(In@2, Key, <<Value/binary, C/binary>>)
    end.

-file("src/jot.gleam", 460).
-spec parse_attribute(list(binary()), binary()) -> gleam@option:option({binary(),
    binary(),
    list(binary())}).
parse_attribute(In, Key) ->
    case In of
        [] ->
            none;

        [<<" "/utf8>> | _] ->
            none;

        [<<"="/utf8>>, <<"\""/utf8>> | In@1] ->
            parse_attribute_quoted_value(In@1, Key, <<""/utf8>>);

        [<<"="/utf8>> | In@2] ->
            parse_attribute_value(In@2, Key, <<""/utf8>>);

        [C | In@3] ->
            parse_attribute(In@3, <<Key/binary, C/binary>>)
    end.

-file("src/jot.gleam", 494).
-spec parse_attributes_id_or_class(list(binary()), binary()) -> gleam@option:option({binary(),
    list(binary())}).
parse_attributes_id_or_class(In, Id) ->
    case In of
        [] ->
            {some, {Id, In}};

        [<<"}"/utf8>> | _] ->
            {some, {Id, In}};

        [<<" "/utf8>> | _] ->
            {some, {Id, In}};

        [<<"#"/utf8>> | _] ->
            none;

        [<<"."/utf8>> | _] ->
            none;

        [<<"="/utf8>> | _] ->
            none;

        [<<"\n"/utf8>> | _] ->
            none;

        [C | In@1] ->
            parse_attributes_id_or_class(In@1, <<Id/binary, C/binary>>)
    end.

-file("src/jot.gleam", 507).
-spec parse_attributes_end(list(binary()), gleam@dict:dict(binary(), binary())) -> gleam@option:option({gleam@dict:dict(binary(), binary()),
    list(binary())}).
parse_attributes_end(In, Attrs) ->
    case In of
        [] ->
            {some, {Attrs, []}};

        [<<"\n"/utf8>> | In@1] ->
            {some, {Attrs, In@1}};

        [<<" "/utf8>> | In@2] ->
            parse_attributes_end(In@2, Attrs);

        [_ | _] ->
            none
    end.

-file("src/jot.gleam", 431).
-spec parse_attributes(list(binary()), gleam@dict:dict(binary(), binary())) -> gleam@option:option({gleam@dict:dict(binary(), binary()),
    list(binary())}).
parse_attributes(In, Attrs) ->
    In@1 = drop_spaces(In),
    case In@1 of
        [] ->
            none;

        [<<"}"/utf8>> | In@2] ->
            parse_attributes_end(In@2, Attrs);

        [<<"#"/utf8>> | In@3] ->
            case parse_attributes_id_or_class(In@3, <<""/utf8>>) of
                {some, {Id, In@4}} ->
                    parse_attributes(
                        In@4,
                        add_attribute(Attrs, <<"id"/utf8>>, Id)
                    );

                none ->
                    none
            end;

        [<<"."/utf8>> | In@5] ->
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

-file("src/jot.gleam", 562).
-spec id_char(binary()) -> boolean().
id_char(Char) ->
    case Char of
        <<"#"/utf8>> ->
            false;

        <<"?"/utf8>> ->
            false;

        <<"!"/utf8>> ->
            false;

        <<","/utf8>> ->
            false;

        _ ->
            true
    end.

-file("src/jot.gleam", 569).
-spec id_escape(list(binary()), binary()) -> binary().
id_escape(Content, Acc) ->
    case Content of
        [] ->
            Acc;

        [<<" "/utf8>> | Rest] when Rest =:= [] ->
            Acc;

        [<<"\n"/utf8>> | Rest] when Rest =:= [] ->
            Acc;

        [<<" "/utf8>> | Rest@1] when Acc =:= <<""/utf8>> ->
            id_escape(Rest@1, Acc);

        [<<"\n"/utf8>> | Rest@1] when Acc =:= <<""/utf8>> ->
            id_escape(Rest@1, Acc);

        [<<" "/utf8>> | Rest@2] ->
            id_escape(Rest@2, <<Acc/binary, "-"/utf8>>);

        [<<"\n"/utf8>> | Rest@2] ->
            id_escape(Rest@2, <<Acc/binary, "-"/utf8>>);

        [C | Rest@3] ->
            id_escape(Rest@3, <<Acc/binary, C/binary>>)
    end.

-file("src/jot.gleam", 555).
-spec id_sanitise(binary()) -> binary().
id_sanitise(Content) ->
    _pipe = Content,
    _pipe@1 = gleam@string:to_graphemes(_pipe),
    _pipe@2 = gleam@list:filter(_pipe@1, fun id_char/1),
    id_escape(_pipe@2, <<""/utf8>>).

-file("src/jot.gleam", 596).
-spec take_heading_chars_newline_hash(list(binary()), integer(), list(binary())) -> gleam@option:option({list(binary()),
    list(binary())}).
take_heading_chars_newline_hash(In, Level, Acc) ->
    case In of
        _ when Level < 0 ->
            none;

        [] when Level > 0 ->
            none;

        [] when Level =:= 0 ->
            {some, {Acc, []}};

        [<<" "/utf8>> | In@1] when Level =:= 0 ->
            {some, {Acc, In@1}};

        [<<"#"/utf8>> | Rest] ->
            take_heading_chars_newline_hash(Rest, Level - 1, Acc);

        _ ->
            none
    end.

-file("src/jot.gleam", 582).
-spec take_heading_chars(list(binary()), integer(), list(binary())) -> {list(binary()),
    list(binary())}.
take_heading_chars(In, Level, Acc) ->
    case In of
        [] ->
            {lists:reverse(Acc), []};

        [<<"\n"/utf8>>] ->
            {lists:reverse(Acc), []};

        [<<"\n"/utf8>>, <<"\n"/utf8>> | In@1] ->
            {lists:reverse(Acc), In@1};

        [<<"\n"/utf8>>, <<"#"/utf8>> | Rest] ->
            case take_heading_chars_newline_hash(
                Rest,
                Level - 1,
                [<<"\n"/utf8>> | Acc]
            ) of
                {some, {Acc@1, In@2}} ->
                    take_heading_chars(In@2, Level, Acc@1);

                none ->
                    {lists:reverse(Acc), In}
            end;

        [C | In@3] ->
            take_heading_chars(In@3, Level, [C | Acc])
    end.

-file("src/jot.gleam", 774).
-spec parse_code_end(list(binary()), integer(), integer(), binary()) -> {boolean(),
    binary(),
    list(binary())}.
parse_code_end(In, Limit, Count, Content) ->
    case In of
        [] ->
            {true, Content, In};

        [<<"`"/utf8>> | In@1] ->
            parse_code_end(In@1, Limit, Count + 1, Content);

        [_ | _] when Limit =:= Count ->
            {true, Content, In};

        [_ | _] ->
            {false,
                <<Content/binary,
                    (gleam@string:repeat(<<"`"/utf8>>, Count))/binary>>,
                In}
    end.

-file("src/jot.gleam", 756).
-spec parse_code_content(list(binary()), integer(), binary()) -> {binary(),
    list(binary())}.
parse_code_content(In, Count, Content) ->
    case In of
        [] ->
            {Content, In};

        [<<"`"/utf8>> | In@1] ->
            {Done, Content@1, In@2} = parse_code_end(In@1, Count, 1, Content),
            case Done of
                true ->
                    {Content@1, In@2};

                false ->
                    parse_code_content(In@2, Count, Content@1)
            end;

        [C | In@3] ->
            parse_code_content(In@3, Count, <<Content/binary, C/binary>>)
    end.

-file("src/jot.gleam", 734).
-spec parse_code(list(binary()), integer()) -> {inline(), list(binary())}.
parse_code(In, Count) ->
    case In of
        [<<"`"/utf8>> | In@1] ->
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

-file("src/jot.gleam", 799).
-spec take_emphasis_chars(list(binary()), binary(), list(binary())) -> gleam@option:option({list(binary()),
    list(binary())}).
take_emphasis_chars(In, Close, Acc) ->
    case In of
        [] ->
            none;

        [<<"`"/utf8>> | _] ->
            none;

        [<<"\t"/utf8>>, C | In@1] when C =:= Close ->
            take_emphasis_chars(In@1, Close, [<<" "/utf8>>, C | Acc]);

        [<<"\n"/utf8>>, C@1 | In@2] when C@1 =:= Close ->
            take_emphasis_chars(In@2, Close, [<<" "/utf8>>, C@1 | Acc]);

        [<<" "/utf8>>, C@2 | In@3] when C@2 =:= Close ->
            take_emphasis_chars(In@3, Close, [<<" "/utf8>>, C@2 | Acc]);

        [C@3 | In@4] when C@3 =:= Close ->
            case lists:reverse(Acc) of
                [] ->
                    none;

                Acc@1 ->
                    {some, {Acc@1, In@4}}
            end;

        [C@4 | Rest] ->
            take_emphasis_chars(Rest, Close, [C@4 | Acc])
    end.

-file("src/jot.gleam", 867).
-spec take_link_chars_destination(
    list(binary()),
    boolean(),
    list(binary()),
    binary()
) -> gleam@option:option({list(binary()), destination(), list(binary())}).
take_link_chars_destination(In, Is_url, Inline_in, Acc) ->
    case In of
        [] ->
            none;

        [<<")"/utf8>> | In@1] when Is_url ->
            {some, {Inline_in, {url, Acc}, In@1}};

        [<<"]"/utf8>> | In@2] when not Is_url ->
            {some, {Inline_in, {reference, Acc}, In@2}};

        [<<"\n"/utf8>> | Rest] when Is_url ->
            take_link_chars_destination(Rest, Is_url, Inline_in, Acc);

        [<<"\n"/utf8>> | Rest@1] when not Is_url ->
            take_link_chars_destination(
                Rest@1,
                Is_url,
                Inline_in,
                <<Acc/binary, " "/utf8>>
            );

        [C | Rest@2] ->
            take_link_chars_destination(
                Rest@2,
                Is_url,
                Inline_in,
                <<Acc/binary, C/binary>>
            )
    end.

-file("src/jot.gleam", 847).
-spec take_link_chars(list(binary()), list(binary())) -> gleam@option:option({list(binary()),
    destination(),
    list(binary())}).
take_link_chars(In, Inline_in) ->
    case In of
        [] ->
            none;

        [<<"]"/utf8>>, <<"["/utf8>> | In@1] ->
            Inline_in@1 = lists:reverse(Inline_in),
            take_link_chars_destination(In@1, false, Inline_in@1, <<""/utf8>>);

        [<<"]"/utf8>>, <<"("/utf8>> | In@2] ->
            Inline_in@2 = lists:reverse(Inline_in),
            take_link_chars_destination(In@2, true, Inline_in@2, <<""/utf8>>);

        [C | Rest] ->
            take_link_chars(Rest, [C | Inline_in])
    end.

-file("src/jot.gleam", 888).
-spec parse_footnote(list(binary()), binary()) -> gleam@option:option({inline(),
    list(binary())}).
parse_footnote(In, Acc) ->
    case In of
        [] ->
            none;

        [<<"]"/utf8>> | Rest] ->
            {some, {{footnote, Acc}, Rest}};

        [C | Rest@1] ->
            parse_footnote(Rest@1, <<Acc/binary, C/binary>>)
    end.

-file("src/jot.gleam", 902).
-spec heading_level(list(binary()), integer()) -> gleam@option:option({integer(),
    list(binary())}).
heading_level(In, Level) ->
    case In of
        [<<"#"/utf8>> | Rest] ->
            heading_level(Rest, Level + 1);

        [] when Level > 0 ->
            {some, {Level, []}};

        [<<" "/utf8>> | Rest@1] when Level =/= 0 ->
            {some, {Level, Rest@1}};

        [<<"\n"/utf8>> | Rest@1] when Level =/= 0 ->
            {some, {Level, Rest@1}};

        _ ->
            none
    end.

-file("src/jot.gleam", 913).
-spec take_inline_text(list(inline()), binary()) -> binary().
take_inline_text(Inlines, Acc) ->
    case Inlines of
        [] ->
            Acc;

        [First | Rest] ->
            case First of
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

-file("src/jot.gleam", 941).
-spec take_paragraph_chars(list(binary()), list(binary())) -> {list(binary()),
    list(binary())}.
take_paragraph_chars(In, Acc) ->
    case In of
        [] ->
            {lists:reverse(Acc), []};

        [<<"\n"/utf8>>] ->
            {lists:reverse(Acc), []};

        [<<"\n"/utf8>>, <<"\n"/utf8>> | Rest] ->
            {lists:reverse(Acc), Rest};

        [C | Rest@1] ->
            take_paragraph_chars(Rest@1, [C | Acc])
    end.

-file("src/jot.gleam", 1145).
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

-file("src/jot.gleam", 1162).
-spec append_to_html(generated_html(), binary()) -> generated_html().
append_to_html(Original_html, Str) ->
    _record = Original_html,
    {generated_html,
        <<(erlang:element(2, Original_html))/binary, Str/binary>>,
        erlang:element(3, _record)}.

-file("src/jot.gleam", 1192).
-spec close_tag(generated_html(), binary()) -> generated_html().
close_tag(Initial_html, Tag) ->
    _record = Initial_html,
    {generated_html,
        <<<<<<(erlang:element(2, Initial_html))/binary, "</"/utf8>>/binary,
                Tag/binary>>/binary,
            ">"/utf8>>,
        erlang:element(3, _record)}.

-file("src/jot.gleam", 1284).
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

-file("src/jot.gleam", 1312).
-spec destination_attribute(binary(), destination(), refs()) -> gleam@dict:dict(binary(), binary()).
destination_attribute(Key, Destination, Refs) ->
    Dict = maps:new(),
    case Destination of
        {url, Url} ->
            gleam@dict:insert(Dict, Key, Url);

        {reference, Id} ->
            case gleam_stdlib:map_get(erlang:element(2, Refs), Id) of
                {ok, Url@1} ->
                    gleam@dict:insert(Dict, Key, Url@1);

                _ ->
                    Dict
            end
    end.

-file("src/jot.gleam", 1335).
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

-file("src/jot.gleam", 1180).
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

-file("src/jot.gleam", 1135).
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

-file("src/jot.gleam", 1328).
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

-file("src/jot.gleam", 1166).
-spec open_tag(generated_html(), binary(), gleam@dict:dict(binary(), binary())) -> generated_html().
open_tag(Initial_html, Tag, Attributes) ->
    Html = <<<<(erlang:element(2, Initial_html))/binary, "<"/utf8>>/binary,
        Tag/binary>>,
    _record = Initial_html,
    {generated_html,
        <<(attributes_to_html(Html, Attributes))/binary, ">"/utf8>>,
        erlang:element(3, _record)}.

-file("src/jot.gleam", 1214).
-spec inline_to_html(generated_html(), inline(), refs()) -> generated_html().
inline_to_html(Html, Inline, Refs) ->
    case Inline of
        linebreak ->
            _pipe = Html,
            _pipe@1 = open_tag(_pipe, <<"br"/utf8>>, maps:new()),
            append_to_html(_pipe@1, <<"\n"/utf8>>);

        {text, Text} ->
            append_to_html(Html, Text);

        {strong, Inlines} ->
            _pipe@2 = Html,
            _pipe@3 = open_tag(_pipe@2, <<"strong"/utf8>>, maps:new()),
            _pipe@4 = inlines_to_html(_pipe@3, Inlines, Refs),
            close_tag(_pipe@4, <<"strong"/utf8>>);

        {emphasis, Inlines@1} ->
            _pipe@5 = Html,
            _pipe@6 = open_tag(_pipe@5, <<"em"/utf8>>, maps:new()),
            _pipe@7 = inlines_to_html(_pipe@6, Inlines@1, Refs),
            close_tag(_pipe@7, <<"em"/utf8>>);

        {link, Text@1, Destination} ->
            _pipe@8 = Html,
            _pipe@9 = open_tag(
                _pipe@8,
                <<"a"/utf8>>,
                destination_attribute(<<"href"/utf8>>, Destination, Refs)
            ),
            _pipe@10 = inlines_to_html(_pipe@9, Text@1, Refs),
            close_tag(_pipe@10, <<"a"/utf8>>);

        {image, Text@2, Destination@1} ->
            _pipe@11 = Html,
            open_tag(
                _pipe@11,
                <<"img"/utf8>>,
                begin
                    _pipe@12 = destination_attribute(
                        <<"src"/utf8>>,
                        Destination@1,
                        Refs
                    ),
                    gleam@dict:insert(
                        _pipe@12,
                        <<"alt"/utf8>>,
                        take_inline_text(Text@2, <<""/utf8>>)
                    )
                end
            );

        {code, Content} ->
            _pipe@13 = Html,
            _pipe@14 = open_tag(_pipe@13, <<"code"/utf8>>, maps:new()),
            _pipe@15 = append_to_html(_pipe@14, Content),
            close_tag(_pipe@15, <<"code"/utf8>>);

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
                _pipe@16 = Html,
                _pipe@17 = open_tag_ordered_attributes(
                    _pipe@16,
                    <<"a"/utf8>>,
                    Footnote_attrs
                ),
                _pipe@18 = append_to_html(
                    _pipe@17,
                    <<<<"<sup>"/utf8, Footnote_number/binary>>/binary,
                        "</sup>"/utf8>>
                ),
                close_tag(_pipe@18, <<"a"/utf8>>)
            end,
            _record = Updated_html,
            {generated_html, erlang:element(2, _record), New_used_footnotes}
    end.

-file("src/jot.gleam", 1196).
-spec inlines_to_html(generated_html(), list(inline()), refs()) -> generated_html().
inlines_to_html(Html, Inlines, Refs) ->
    case Inlines of
        [] ->
            Html;

        [Inline | Rest] ->
            Html@1 = begin
                _pipe = Html,
                _pipe@1 = inline_to_html(_pipe, Inline, Refs),
                inlines_to_html(_pipe@1, Rest, Refs)
            end,
            _record = Html@1,
            {generated_html,
                gleam@string:trim_end(erlang:element(2, Html@1)),
                erlang:element(3, _record)}
    end.

-file("src/jot.gleam", 1041).
-spec container_to_html(generated_html(), container(), refs()) -> generated_html().
container_to_html(Html, Container, Refs) ->
    New_html = case Container of
        thematic_break ->
            _pipe = Html,
            open_tag(_pipe, <<"hr"/utf8>>, maps:new());

        {paragraph, Attrs, Inlines} ->
            _pipe@1 = Html,
            _pipe@2 = open_tag(_pipe@1, <<"p"/utf8>>, Attrs),
            _pipe@3 = inlines_to_html(_pipe@2, Inlines, Refs),
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
            _pipe@7 = append_to_html(_pipe@6, Content),
            _pipe@8 = close_tag(_pipe@7, <<"code"/utf8>>),
            close_tag(_pipe@8, <<"pre"/utf8>>);

        {heading, Attrs@2, Level, Inlines@1} ->
            Tag = <<"h"/utf8, (erlang:integer_to_binary(Level))/binary>>,
            _pipe@9 = Html,
            _pipe@10 = open_tag(_pipe@9, Tag, Attrs@2),
            _pipe@11 = inlines_to_html(_pipe@10, Inlines@1, Refs),
            close_tag(_pipe@11, Tag)
    end,
    append_to_html(New_html, <<"\n"/utf8>>).

-file("src/jot.gleam", 997).
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
                    _pipe@2 = inlines_to_html(_pipe@1, Inlines, Refs),
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

-file("src/jot.gleam", 1027).
-spec containers_to_html(list(container()), refs(), generated_html()) -> generated_html().
containers_to_html(Containers, Refs, Html) ->
    case Containers of
        [] ->
            Html;

        [Container | Rest] ->
            Html@1 = container_to_html(Html, Container, Refs),
            containers_to_html(Rest, Refs, Html@1)
    end.

-file("src/jot.gleam", 1080).
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

-file("src/jot.gleam", 951).
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

-file("src/jot.gleam", 174).
?DOC(
    " This function allows us to parse the contents of a block after we know\n"
    " that the *first* container meets indentation requirements, but we want to\n"
    " ensure that once this container is parsed, future containers meet the\n"
    " indentation requirements\n"
).
-spec parse_block_after_indent_checked(
    list(binary()),
    refs(),
    list(container()),
    gleam@dict:dict(binary(), binary()),
    integer(),
    integer()
) -> {list(container()), refs(), list(binary())}.
parse_block_after_indent_checked(
    In,
    Refs,
    Ast,
    Attrs,
    Required_spaces,
    Indentation
) ->
    parse_containers(
        In,
        Refs,
        Ast,
        Attrs,
        Indentation,
        fun(In@1, Refs@1, Ast@1, Attrs@1) ->
            parse_block(In@1, Refs@1, Ast@1, Attrs@1, Required_spaces)
        end
    ).

-file("src/jot.gleam", 146).
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
    list(binary()),
    refs(),
    list(container()),
    gleam@dict:dict(binary(), binary()),
    integer()
) -> {list(container()), refs(), list(binary())}.
parse_block(In, Refs, Ast, Attrs, Required_spaces) ->
    In@1 = drop_lines(In),
    {In@2, Spaces_count} = count_drop_spaces(In@1, 0),
    gleam@bool:lazy_guard(
        Spaces_count < Required_spaces,
        fun() -> {lists:reverse(Ast), Refs, In@2} end,
        fun() ->
            parse_block_after_indent_checked(
                In@2,
                Refs,
                Ast,
                Attrs,
                Required_spaces,
                Spaces_count
            )
        end
    ).

-file("src/jot.gleam", 398).
-spec parse_footnote_def(list(binary()), refs(), binary()) -> gleam@option:option({binary(),
    list(container()),
    refs(),
    list(binary())}).
parse_footnote_def(In, Refs, Id) ->
    case In of
        [<<"]"/utf8>>, <<":"/utf8>> | In@1] ->
            {In@2, Spaces_count} = count_drop_spaces(In@1, 0),
            Block_parser = case In@2 of
                [<<"\n"/utf8>> | _] ->
                    fun parse_block/5;

                _ ->
                    fun(In@3, Refs@1, Ast, Attrs, Required_spaces) ->
                        parse_block_after_indent_checked(
                            In@3,
                            Refs@1,
                            Ast,
                            Attrs,
                            Required_spaces,
                            (4 + string:length(Id)) + Spaces_count
                        )
                    end
            end,
            {Block, Refs@2, Rest} = Block_parser(In@2, Refs, [], maps:new(), 1),
            {some, {Id, Block, Refs@2, Rest}};

        [] ->
            none;

        [<<"]"/utf8>> | _] ->
            none;

        [<<"\n"/utf8>> | _] ->
            none;

        [C | In@4] ->
            parse_footnote_def(In@4, Refs, <<Id/binary, C/binary>>)
    end.

-file("src/jot.gleam", 788).
-spec parse_emphasis(list(binary()), binary()) -> gleam@option:option({list(inline()),
    list(binary())}).
parse_emphasis(In, Close) ->
    case take_emphasis_chars(In, Close, []) of
        none ->
            none;

        {some, {Inline_in, In@1}} ->
            {Inline, Inline_in_remaining} = parse_inline(
                Inline_in,
                <<""/utf8>>,
                []
            ),
            {some, {Inline, lists:append(Inline_in_remaining, In@1)}}
    end.

-file("src/jot.gleam", 614).
-spec parse_inline(list(binary()), binary(), list(inline())) -> {list(inline()),
    list(binary())}.
parse_inline(In, Text, Acc) ->
    case In of
        [] when Text =:= <<""/utf8>> ->
            {lists:reverse(Acc), []};

        [] ->
            parse_inline([], <<""/utf8>>, [{text, Text} | Acc]);

        [<<"\\"/utf8>>, C | Rest] ->
            case C of
                <<"\n"/utf8>> ->
                    parse_inline(
                        Rest,
                        <<""/utf8>>,
                        [linebreak, {text, Text} | Acc]
                    );

                <<" "/utf8>> ->
                    parse_inline(Rest, <<Text/binary, "&nbsp;"/utf8>>, Acc);

                <<"!"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"\""/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"#"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"$"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"%"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"&"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"'"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"("/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<")"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"*"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"+"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<","/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"-"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"."/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"/"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<":"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<";"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"<"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"="/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<">"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"?"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"@"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"["/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"\\"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"]"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"^"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"_"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"`"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"{"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"|"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"}"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                <<"~"/utf8>> ->
                    parse_inline(Rest, <<Text/binary, C/binary>>, Acc);

                _ ->
                    parse_inline(
                        lists:append([C], Rest),
                        <<Text/binary, "\\"/utf8>>,
                        Acc
                    )
            end;

        [<<"_"/utf8>>, C@1 | Rest@1] when ((C@1 =/= <<" "/utf8>>) andalso (C@1 =/= <<"\t"/utf8>>)) andalso (C@1 =/= <<"\n"/utf8>>) ->
            Rest@2 = [C@1 | Rest@1],
            case parse_emphasis(Rest@2, <<"_"/utf8>>) of
                none ->
                    parse_inline(Rest@2, <<Text/binary, "_"/utf8>>, Acc);

                {some, {Inner, In@1}} ->
                    parse_inline(
                        In@1,
                        <<""/utf8>>,
                        [{emphasis, Inner}, {text, Text} | Acc]
                    )
            end;

        [<<"*"/utf8>>, C@2 | Rest@3] when ((C@2 =/= <<" "/utf8>>) andalso (C@2 =/= <<"\t"/utf8>>)) andalso (C@2 =/= <<"\n"/utf8>>) ->
            Rest@4 = [C@2 | Rest@3],
            case parse_emphasis(Rest@4, <<"*"/utf8>>) of
                none ->
                    parse_inline(Rest@4, <<Text/binary, "*"/utf8>>, Acc);

                {some, {Inner@1, In@2}} ->
                    parse_inline(
                        In@2,
                        <<""/utf8>>,
                        [{strong, Inner@1}, {text, Text} | Acc]
                    )
            end;

        [<<"["/utf8>>, <<"^"/utf8>> | Rest@5] ->
            case parse_footnote(Rest@5, <<"^"/utf8>>) of
                none ->
                    parse_inline(Rest@5, <<Text/binary, "[^"/utf8>>, Acc);

                {some, {_, [<<":"/utf8>> | _]}} when Text =/= <<""/utf8>> ->
                    {lists:reverse([{text, Text} | Acc]), In};

                {some, {_, [<<":"/utf8>> | _]}} ->
                    {lists:reverse(Acc), In};

                {some, {Footnote, In@3}} ->
                    parse_inline(
                        In@3,
                        <<""/utf8>>,
                        [Footnote, {text, Text} | Acc]
                    )
            end;

        [<<"["/utf8>> | Rest@6] ->
            case parse_link(
                Rest@6,
                fun(Field@0, Field@1) -> {link, Field@0, Field@1} end
            ) of
                none ->
                    parse_inline(Rest@6, <<Text/binary, "["/utf8>>, Acc);

                {some, {Link, In@4}} ->
                    parse_inline(In@4, <<""/utf8>>, [Link, {text, Text} | Acc])
            end;

        [<<"!"/utf8>>, <<"["/utf8>> | Rest@7] ->
            case parse_link(
                Rest@7,
                fun(Field@0, Field@1) -> {image, Field@0, Field@1} end
            ) of
                none ->
                    parse_inline(Rest@7, <<Text/binary, "!["/utf8>>, Acc);

                {some, {Image, In@5}} ->
                    parse_inline(In@5, <<""/utf8>>, [Image, {text, Text} | Acc])
            end;

        [<<"`"/utf8>> | Rest@8] ->
            {Code, In@6} = parse_code(Rest@8, 1),
            parse_inline(In@6, <<""/utf8>>, [Code, {text, Text} | Acc]);

        [<<"\n"/utf8>> | Rest@9] ->
            _pipe = drop_spaces(Rest@9),
            parse_inline(_pipe, <<Text/binary, "\n"/utf8>>, Acc);

        [C@3 | Rest@10] ->
            parse_inline(Rest@10, <<Text/binary, C@3/binary>>, Acc)
    end.

-file("src/jot.gleam", 828).
-spec parse_link(
    list(binary()),
    fun((list(inline()), destination()) -> inline())
) -> gleam@option:option({inline(), list(binary())}).
parse_link(In, To_inline) ->
    case take_link_chars(In, []) of
        none ->
            none;

        {some, {Inline_in, Ref, In@1}} ->
            {Inline, Inline_in_remaining} = parse_inline(
                Inline_in,
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
                    lists:append(Inline_in_remaining, In@1)}}
    end.

-file("src/jot.gleam", 932).
-spec parse_paragraph(list(binary()), gleam@dict:dict(binary(), binary())) -> {container(),
    list(binary())}.
parse_paragraph(In, Attrs) ->
    {Inline_in, In@1} = take_paragraph_chars(In, []),
    {Inline, Inline_in_remaining} = parse_inline(Inline_in, <<""/utf8>>, []),
    {{paragraph, Attrs, Inline}, lists:append(Inline_in_remaining, In@1)}.

-file("src/jot.gleam", 519).
-spec parse_heading(list(binary()), refs(), gleam@dict:dict(binary(), binary())) -> {container(),
    refs(),
    list(binary())}.
parse_heading(In, Refs, Attrs) ->
    case heading_level(In, 1) of
        {some, {Level, In@1}} ->
            In@2 = drop_spaces(In@1),
            {Inline_in, In@3} = take_heading_chars(In@2, Level, []),
            {Inline, Inline_in_remaining} = parse_inline(
                Inline_in,
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
            {Heading, Refs@2, lists:append(Inline_in_remaining, In@3)};

        none ->
            {P, In@4} = parse_paragraph([<<"#"/utf8>> | In], Attrs),
            {P, Refs, In@4}
    end.

-file("src/jot.gleam", 187).
-spec parse_containers(
    list(binary()),
    refs(),
    list(container()),
    gleam@dict:dict(binary(), binary()),
    integer(),
    fun((list(binary()), refs(), list(container()), gleam@dict:dict(binary(), binary())) -> {list(container()),
        refs(),
        list(binary())})
) -> {list(container()), refs(), list(binary())}.
parse_containers(In, Refs, Ast, Attrs, Indentation, Parser) ->
    case In of
        [] ->
            {lists:reverse(Ast), Refs, []};

        [<<"{"/utf8>> | In2] ->
            case parse_attributes(In2, Attrs) of
                none ->
                    {Paragraph, In@1} = parse_paragraph(In, Attrs),
                    Parser(In@1, Refs, [Paragraph | Ast], maps:new());

                {some, {Attrs@1, In@2}} ->
                    Parser(In@2, Refs, Ast, Attrs@1)
            end;

        [<<"#"/utf8>> | In@3] ->
            {Heading, Refs@1, In@4} = parse_heading(In@3, Refs, Attrs),
            Parser(In@4, Refs@1, [Heading | Ast], maps:new());

        [<<"~"/utf8>> = Delim | In2@1] ->
            case parse_codeblock(In2@1, Attrs, Delim, Indentation) of
                none ->
                    {Paragraph@1, In@5} = parse_paragraph(In, Attrs),
                    Parser(In@5, Refs, [Paragraph@1 | Ast], maps:new());

                {some, {Codeblock, In@6}} ->
                    Parser(In@6, Refs, [Codeblock | Ast], maps:new())
            end;

        [<<"`"/utf8>> = Delim | In2@1] ->
            case parse_codeblock(In2@1, Attrs, Delim, Indentation) of
                none ->
                    {Paragraph@1, In@5} = parse_paragraph(In, Attrs),
                    Parser(In@5, Refs, [Paragraph@1 | Ast], maps:new());

                {some, {Codeblock, In@6}} ->
                    Parser(In@6, Refs, [Codeblock | Ast], maps:new())
            end;

        [<<"-"/utf8>> | In2@2] ->
            case parse_thematic_break(1, In2@2) of
                none ->
                    {Paragraph@2, In@7} = parse_paragraph(In, Attrs),
                    Parser(In@7, Refs, [Paragraph@2 | Ast], maps:new());

                {some, {Thematic_break, In@8}} ->
                    Parser(In@8, Refs, [Thematic_break | Ast], maps:new())
            end;

        [<<"*"/utf8>> | In2@2] ->
            case parse_thematic_break(1, In2@2) of
                none ->
                    {Paragraph@2, In@7} = parse_paragraph(In, Attrs),
                    Parser(In@7, Refs, [Paragraph@2 | Ast], maps:new());

                {some, {Thematic_break, In@8}} ->
                    Parser(In@8, Refs, [Thematic_break | Ast], maps:new())
            end;

        [<<"["/utf8>>, <<"^"/utf8>> | In2@3] ->
            case parse_footnote_def(In2@3, Refs, <<"^"/utf8>>) of
                none ->
                    {Paragraph@3, In@9} = parse_paragraph(In, Attrs),
                    Parser(In@9, Refs, [Paragraph@3 | Ast], maps:new());

                {some, {Id, Footnote, Refs@2, In@10}} ->
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
                    Parser(In@10, Refs@3, Ast, maps:new())
            end;

        [<<"["/utf8>> | In2@4] ->
            case parse_ref_def(In2@4, <<""/utf8>>) of
                none ->
                    {Paragraph@4, In@11} = parse_paragraph(In, Attrs),
                    Parser(In@11, Refs, [Paragraph@4 | Ast], maps:new());

                {some, {Id@1, Url, In@12}} ->
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
                    Parser(In@12, Refs@4, Ast, maps:new())
            end;

        _ ->
            {Paragraph@5, In@13} = parse_paragraph(In, Attrs),
            Parser(In@13, Refs, [Paragraph@5 | Ast], maps:new())
    end.

-file("src/jot.gleam", 121).
-spec parse_document_content(
    list(binary()),
    refs(),
    list(container()),
    gleam@dict:dict(binary(), binary())
) -> {list(container()), refs(), list(binary())}.
parse_document_content(In, Refs, Ast, Attrs) ->
    In@1 = drop_lines(In),
    {In@2, Spaces_count} = count_drop_spaces(In@1, 0),
    parse_containers(
        In@2,
        Refs,
        Ast,
        Attrs,
        Spaces_count,
        fun parse_document_content/4
    ).

-file("src/jot.gleam", 87).
?DOC(
    " Convert a string of Djot into a tree of records.\n"
    "\n"
    " This may be useful when you want more control over the HTML to be converted\n"
    " to, or you wish to convert Djot to some other format.\n"
).
-spec parse(binary()) -> document().
parse(Djot) ->
    {Ast, {refs, Urls, Footnotes}, _} = begin
        _pipe = Djot,
        _pipe@1 = gleam@string:replace(_pipe, <<"\r\n"/utf8>>, <<"\n"/utf8>>),
        _pipe@2 = gleam@string:to_graphemes(_pipe@1),
        parse_document_content(
            _pipe@2,
            {refs, maps:new(), maps:new()},
            [],
            maps:new()
        )
    end,
    {document, Ast, Urls, Footnotes}.

-file("src/jot.gleam", 76).
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
