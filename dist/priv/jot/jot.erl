-module(jot).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([document_to_html/1, parse/1, to_html/1]).
-export_type([document/0, container/0, inline/0, destination/0]).

-type document() :: {document,
        list(container()),
        gleam@dict:dict(binary(), binary())}.

-type container() :: {paragraph,
        gleam@dict:dict(binary(), binary()),
        list(inline())} |
    {heading, gleam@dict:dict(binary(), binary()), integer(), list(inline())} |
    {codeblock,
        gleam@dict:dict(binary(), binary()),
        gleam@option:option(binary()),
        binary()}.

-type inline() :: {text, binary()} |
    {link, list(inline()), destination()} |
    {image, list(inline()), destination()} |
    {emphasis, list(inline())} |
    {strong, list(inline())} |
    {code, binary()}.

-type destination() :: {reference, binary()} | {url, binary()}.

-spec add_attribute(gleam@dict:dict(binary(), binary()), binary(), binary()) -> gleam@dict:dict(binary(), binary()).
add_attribute(Attributes, Key, Value) ->
    case Key of
        <<"class"/utf8>> ->
            gleam@dict:update(Attributes, Key, fun(Previous) -> case Previous of
                        none ->
                            Value;

                        {some, Previous@1} ->
                            <<<<Previous@1/binary, " "/utf8>>/binary,
                                Value/binary>>
                    end end);

        _ ->
            gleam@dict:insert(Attributes, Key, Value)
    end.

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

-spec slurp_verbatim_line(list(binary()), binary()) -> {binary(),
    list(binary())}.
slurp_verbatim_line(In, Acc) ->
    case In of
        [] ->
            {Acc, []};

        [<<"\n"/utf8>> | In@1] ->
            {<<Acc/binary, "\n"/utf8>>, In@1};

        [C | In@2] ->
            slurp_verbatim_line(In@2, <<Acc/binary, C/binary>>)
    end.

-spec parse_codeblock_end(list(binary()), binary(), integer()) -> gleam@option:option({list(binary())}).
parse_codeblock_end(In, Delim, Count) ->
    case In of
        [<<"\n"/utf8>> | In@1] when Count =:= 0 ->
            {some, {In@1}};

        _ when Count =:= 0 ->
            {some, {In}};

        [C | In@2] when C =:= Delim ->
            parse_codeblock_end(In@2, Delim, Count - 1);

        [] ->
            {some, {In}};

        _ ->
            none
    end.

-spec parse_codeblock_content(list(binary()), binary(), integer(), binary()) -> {binary(),
    list(binary())}.
parse_codeblock_content(In, Delim, Count, Acc) ->
    case parse_codeblock_end(In, Delim, Count) of
        none ->
            {Acc@1, In@1} = slurp_verbatim_line(In, Acc),
            parse_codeblock_content(In@1, Delim, Count, Acc@1);

        {some, {In@2}} ->
            {Acc, In@2}
    end.

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

-spec parse_codeblock(
    list(binary()),
    gleam@dict:dict(binary(), binary()),
    binary()
) -> gleam@option:option({container(), list(binary())}).
parse_codeblock(In, Attrs, Delim) ->
    gleam@option:then(
        parse_codeblock_start(In, Delim, 1),
        fun(_use0) ->
            {Language, Count, In@1} = _use0,
            {Content, In@2} = parse_codeblock_content(
                In@1,
                Delim,
                Count,
                <<""/utf8>>
            ),
            {some, {{codeblock, Attrs, Language, Content}, In@2}}
        end
    ).

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

-spec id_sanitise(binary()) -> binary().
id_sanitise(Content) ->
    _pipe = Content,
    _pipe@1 = gleam@string:to_graphemes(_pipe),
    _pipe@2 = gleam@list:filter(_pipe@1, fun id_char/1),
    id_escape(_pipe@2, <<""/utf8>>).

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

-spec parse_code(list(binary()), integer()) -> {inline(), list(binary())}.
parse_code(In, Count) ->
    case In of
        [<<"`"/utf8>> | In@1] ->
            parse_code(In@1, Count + 1);

        _ ->
            {Content, In@2} = parse_code_content(In, Count, <<""/utf8>>),
            Content@1 = case gleam@string:starts_with(Content, <<" `"/utf8>>) of
                true ->
                    gleam@string:trim_left(Content);

                false ->
                    Content
            end,
            Content@2 = case gleam@string:ends_with(Content@1, <<"` "/utf8>>) of
                true ->
                    gleam@string:trim_right(Content@1);

                false ->
                    Content@1
            end,
            {{code, Content@2}, In@2}
    end.

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
                    take_inline_text(Rest, Acc@1)
            end
    end.

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

-spec close_tag(binary(), binary()) -> binary().
close_tag(Html, Tag) ->
    <<<<<<Html/binary, "</"/utf8>>/binary, Tag/binary>>/binary, ">"/utf8>>.

-spec destination_attribute(
    binary(),
    destination(),
    gleam@dict:dict(binary(), binary())
) -> gleam@dict:dict(binary(), binary()).
destination_attribute(Key, Destination, Refs) ->
    Dict = gleam@dict:new(),
    case Destination of
        {url, Url} ->
            gleam@dict:insert(Dict, Key, Url);

        {reference, Id} ->
            case gleam@dict:get(Refs, Id) of
                {ok, Url@1} ->
                    gleam@dict:insert(Dict, Key, Url@1);

                {error, nil} ->
                    Dict
            end
    end.

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
    gleam@list:fold(
        _pipe@2,
        Html,
        fun(Html@1, Pair) ->
            <<<<<<<<<<Html@1/binary, " "/utf8>>/binary,
                            (erlang:element(1, Pair))/binary>>/binary,
                        "=\""/utf8>>/binary,
                    (erlang:element(2, Pair))/binary>>/binary,
                "\""/utf8>>
        end
    ).

-spec open_tag(binary(), binary(), gleam@dict:dict(binary(), binary())) -> binary().
open_tag(Html, Tag, Attributes) ->
    Html@1 = <<<<Html/binary, "<"/utf8>>/binary, Tag/binary>>,
    <<(attributes_to_html(Html@1, Attributes))/binary, ">"/utf8>>.

-spec inline_to_html(binary(), inline(), gleam@dict:dict(binary(), binary())) -> binary().
inline_to_html(Html, Inline, Refs) ->
    case Inline of
        {text, Text} ->
            <<Html/binary, Text/binary>>;

        {strong, Inlines} ->
            _pipe = Html,
            _pipe@1 = open_tag(_pipe, <<"strong"/utf8>>, gleam@dict:new()),
            _pipe@2 = inlines_to_html(_pipe@1, Inlines, Refs),
            close_tag(_pipe@2, <<"strong"/utf8>>);

        {emphasis, Inlines@1} ->
            _pipe@3 = Html,
            _pipe@4 = open_tag(_pipe@3, <<"em"/utf8>>, gleam@dict:new()),
            _pipe@5 = inlines_to_html(_pipe@4, Inlines@1, Refs),
            close_tag(_pipe@5, <<"em"/utf8>>);

        {link, Text@1, Destination} ->
            _pipe@6 = Html,
            _pipe@7 = open_tag(
                _pipe@6,
                <<"a"/utf8>>,
                destination_attribute(<<"href"/utf8>>, Destination, Refs)
            ),
            _pipe@8 = inlines_to_html(_pipe@7, Text@1, Refs),
            close_tag(_pipe@8, <<"a"/utf8>>);

        {image, Text@2, Destination@1} ->
            _pipe@9 = Html,
            open_tag(
                _pipe@9,
                <<"img"/utf8>>,
                begin
                    _pipe@10 = destination_attribute(
                        <<"src"/utf8>>,
                        Destination@1,
                        Refs
                    ),
                    gleam@dict:insert(
                        _pipe@10,
                        <<"alt"/utf8>>,
                        take_inline_text(Text@2, <<""/utf8>>)
                    )
                end
            );

        {code, Content} ->
            _pipe@11 = Html,
            _pipe@12 = open_tag(_pipe@11, <<"code"/utf8>>, gleam@dict:new()),
            _pipe@13 = gleam@string:append(_pipe@12, Content),
            close_tag(_pipe@13, <<"code"/utf8>>)
    end.

-spec inlines_to_html(
    binary(),
    list(inline()),
    gleam@dict:dict(binary(), binary())
) -> binary().
inlines_to_html(Html, Inlines, Refs) ->
    case Inlines of
        [] ->
            Html;

        [Inline | Rest] ->
            _pipe = Html,
            _pipe@1 = inline_to_html(_pipe, Inline, Refs),
            _pipe@2 = inlines_to_html(_pipe@1, Rest, Refs),
            gleam@string:trim_right(_pipe@2)
    end.

-spec container_to_html(
    binary(),
    container(),
    gleam@dict:dict(binary(), binary())
) -> binary().
container_to_html(Html, Container, Refs) ->
    <<(case Container of
            {paragraph, Attrs, Inlines} ->
                _pipe = Html,
                _pipe@1 = open_tag(_pipe, <<"p"/utf8>>, Attrs),
                _pipe@2 = inlines_to_html(_pipe@1, Inlines, Refs),
                close_tag(_pipe@2, <<"p"/utf8>>);

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
                _pipe@3 = Html,
                _pipe@4 = open_tag(_pipe@3, <<"pre"/utf8>>, gleam@dict:new()),
                _pipe@5 = open_tag(_pipe@4, <<"code"/utf8>>, Code_attrs),
                _pipe@6 = gleam@string:append(_pipe@5, Content),
                _pipe@7 = close_tag(_pipe@6, <<"code"/utf8>>),
                close_tag(_pipe@7, <<"pre"/utf8>>);

            {heading, Attrs@2, Level, Inlines@1} ->
                Tag = <<"h"/utf8, (gleam@int:to_string(Level))/binary>>,
                _pipe@8 = Html,
                _pipe@9 = open_tag(_pipe@8, Tag, Attrs@2),
                _pipe@10 = inlines_to_html(_pipe@9, Inlines@1, Refs),
                close_tag(_pipe@10, Tag)
        end)/binary, "\n"/utf8>>.

-spec containers_to_html(
    list(container()),
    gleam@dict:dict(binary(), binary()),
    binary()
) -> binary().
containers_to_html(Containers, Refs, Html) ->
    case Containers of
        [] ->
            Html;

        [Container | Rest] ->
            Html@1 = container_to_html(Html, Container, Refs),
            containers_to_html(Rest, Refs, Html@1)
    end.

-spec document_to_html(document()) -> binary().
document_to_html(Document) ->
    containers_to_html(
        erlang:element(2, Document),
        erlang:element(3, Document),
        <<""/utf8>>
    ).

-spec parse_emphasis(list(binary()), binary()) -> gleam@option:option({list(inline()),
    list(binary())}).
parse_emphasis(In, Close) ->
    case take_emphasis_chars(In, Close, []) of
        none ->
            none;

        {some, {Inline_in, In@1}} ->
            Inline = parse_inline(Inline_in, <<""/utf8>>, []),
            {some, {Inline, In@1}}
    end.

-spec parse_inline(list(binary()), binary(), list(inline())) -> list(inline()).
parse_inline(In, Text, Acc) ->
    case In of
        [] when Text =:= <<""/utf8>> ->
            lists:reverse(Acc);

        [] ->
            parse_inline([], <<""/utf8>>, [{text, Text} | Acc]);

        [<<"_"/utf8>>, C | Rest] when ((C =/= <<" "/utf8>>) andalso (C =/= <<"\t"/utf8>>)) andalso (C =/= <<"\n"/utf8>>) ->
            Rest@1 = [C | Rest],
            case parse_emphasis(Rest@1, <<"_"/utf8>>) of
                none ->
                    parse_inline(Rest@1, <<Text/binary, "_"/utf8>>, Acc);

                {some, {Inner, In@1}} ->
                    parse_inline(
                        In@1,
                        <<""/utf8>>,
                        [{emphasis, Inner}, {text, Text} | Acc]
                    )
            end;

        [<<"*"/utf8>>, C@1 | Rest@2] when ((C@1 =/= <<" "/utf8>>) andalso (C@1 =/= <<"\t"/utf8>>)) andalso (C@1 =/= <<"\n"/utf8>>) ->
            Rest@3 = [C@1 | Rest@2],
            case parse_emphasis(Rest@3, <<"*"/utf8>>) of
                none ->
                    parse_inline(Rest@3, <<Text/binary, "*"/utf8>>, Acc);

                {some, {Inner@1, In@2}} ->
                    parse_inline(
                        In@2,
                        <<""/utf8>>,
                        [{strong, Inner@1}, {text, Text} | Acc]
                    )
            end;

        [<<"["/utf8>> | Rest@4] ->
            case parse_link(
                Rest@4,
                fun(Field@0, Field@1) -> {link, Field@0, Field@1} end
            ) of
                none ->
                    parse_inline(Rest@4, <<Text/binary, "["/utf8>>, Acc);

                {some, {Link, In@3}} ->
                    parse_inline(In@3, <<""/utf8>>, [Link, {text, Text} | Acc])
            end;

        [<<"!"/utf8>>, <<"["/utf8>> | Rest@5] ->
            case parse_link(
                Rest@5,
                fun(Field@0, Field@1) -> {image, Field@0, Field@1} end
            ) of
                none ->
                    parse_inline(Rest@5, <<Text/binary, "!["/utf8>>, Acc);

                {some, {Image, In@4}} ->
                    parse_inline(In@4, <<""/utf8>>, [Image, {text, Text} | Acc])
            end;

        [<<"`"/utf8>> | Rest@6] ->
            {Code, In@5} = parse_code(Rest@6, 1),
            parse_inline(In@5, <<""/utf8>>, [Code, {text, Text} | Acc]);

        [C@2 | Rest@7] ->
            parse_inline(Rest@7, <<Text/binary, C@2/binary>>, Acc)
    end.

-spec parse_link(
    list(binary()),
    fun((list(inline()), destination()) -> inline())
) -> gleam@option:option({inline(), list(binary())}).
parse_link(In, To_inline) ->
    case take_link_chars(In, []) of
        none ->
            none;

        {some, {Inline_in, Ref, In@1}} ->
            Inline = parse_inline(Inline_in, <<""/utf8>>, []),
            Ref@2 = case Ref of
                {reference, <<""/utf8>>} ->
                    {reference, take_inline_text(Inline, <<""/utf8>>)};

                Ref@1 ->
                    Ref@1
            end,
            {some, {To_inline(Inline, Ref@2), In@1}}
    end.

-spec parse_paragraph(list(binary()), gleam@dict:dict(binary(), binary())) -> {container(),
    list(binary())}.
parse_paragraph(In, Attrs) ->
    {Inline_in, In@1} = take_paragraph_chars(In, []),
    Inline = parse_inline(Inline_in, <<""/utf8>>, []),
    {{paragraph, Attrs, Inline}, In@1}.

-spec parse_heading(
    list(binary()),
    gleam@dict:dict(binary(), binary()),
    gleam@dict:dict(binary(), binary())
) -> {container(), gleam@dict:dict(binary(), binary()), list(binary())}.
parse_heading(In, Refs, Attrs) ->
    case heading_level(In, 1) of
        {some, {Level, In@1}} ->
            In@2 = drop_spaces(In@1),
            {Inline_in, In@3} = take_heading_chars(In@2, Level, []),
            Inline = parse_inline(Inline_in, <<""/utf8>>, []),
            Text = take_inline_text(Inline, <<""/utf8>>),
            {Refs@2, Attrs@2} = case id_sanitise(Text) of
                <<""/utf8>> ->
                    {Refs, Attrs};

                Id ->
                    case gleam@dict:get(Refs, Id) of
                        {ok, _} ->
                            {Refs, Attrs};

                        {error, _} ->
                            Refs@1 = gleam@dict:insert(
                                Refs,
                                Id,
                                <<"#"/utf8, Id/binary>>
                            ),
                            Attrs@1 = add_attribute(Attrs, <<"id"/utf8>>, Id),
                            {Refs@1, Attrs@1}
                    end
            end,
            Heading = {heading, Attrs@2, Level, Inline},
            {Heading, Refs@2, In@3};

        none ->
            {P, In@4} = parse_paragraph([<<"#"/utf8>> | In], Attrs),
            {P, Refs, In@4}
    end.

-spec parse_document(
    list(binary()),
    gleam@dict:dict(binary(), binary()),
    list(container()),
    gleam@dict:dict(binary(), binary())
) -> document().
parse_document(In, Refs, Ast, Attrs) ->
    In@1 = drop_lines(In),
    In@2 = drop_spaces(In@1),
    case In@2 of
        [] ->
            {document, lists:reverse(Ast), Refs};

        [<<"{"/utf8>> | In2] ->
            case parse_attributes(In2, Attrs) of
                none ->
                    {Paragraph, In@3} = parse_paragraph(In@2, Attrs),
                    parse_document(
                        In@3,
                        Refs,
                        [Paragraph | Ast],
                        gleam@dict:new()
                    );

                {some, {Attrs@1, In@4}} ->
                    parse_document(In@4, Refs, Ast, Attrs@1)
            end;

        [<<"#"/utf8>> | In@5] ->
            {Heading, Refs@1, In@6} = parse_heading(In@5, Refs, Attrs),
            parse_document(In@6, Refs@1, [Heading | Ast], gleam@dict:new());

        [<<"~"/utf8>> = Delim | In2@1] ->
            case parse_codeblock(In2@1, Attrs, Delim) of
                none ->
                    {Paragraph@1, In@7} = parse_paragraph(In@2, Attrs),
                    parse_document(
                        In@7,
                        Refs,
                        [Paragraph@1 | Ast],
                        gleam@dict:new()
                    );

                {some, {Codeblock, In@8}} ->
                    parse_document(
                        In@8,
                        Refs,
                        [Codeblock | Ast],
                        gleam@dict:new()
                    )
            end;

        [<<"`"/utf8>> = Delim | In2@1] ->
            case parse_codeblock(In2@1, Attrs, Delim) of
                none ->
                    {Paragraph@1, In@7} = parse_paragraph(In@2, Attrs),
                    parse_document(
                        In@7,
                        Refs,
                        [Paragraph@1 | Ast],
                        gleam@dict:new()
                    );

                {some, {Codeblock, In@8}} ->
                    parse_document(
                        In@8,
                        Refs,
                        [Codeblock | Ast],
                        gleam@dict:new()
                    )
            end;

        [<<"["/utf8>> | In2@2] ->
            case parse_ref_def(In2@2, <<""/utf8>>) of
                none ->
                    {Paragraph@2, In@9} = parse_paragraph(In@2, Attrs),
                    parse_document(
                        In@9,
                        Refs,
                        [Paragraph@2 | Ast],
                        gleam@dict:new()
                    );

                {some, {Id, Url, In@10}} ->
                    Refs@2 = gleam@dict:insert(Refs, Id, Url),
                    parse_document(In@10, Refs@2, Ast, gleam@dict:new())
            end;

        _ ->
            {Paragraph@3, In@11} = parse_paragraph(In@2, Attrs),
            parse_document(In@11, Refs, [Paragraph@3 | Ast], gleam@dict:new())
    end.

-spec parse(binary()) -> document().
parse(Djot) ->
    _pipe = Djot,
    _pipe@1 = gleam@string:replace(_pipe, <<"\r\n"/utf8>>, <<"\n"/utf8>>),
    _pipe@2 = gleam@string:to_graphemes(_pipe@1),
    parse_document(_pipe@2, gleam@dict:new(), [], gleam@dict:new()).

-spec to_html(binary()) -> binary().
to_html(Djot) ->
    _pipe = Djot,
    _pipe@1 = parse(_pipe),
    document_to_html(_pipe@1).
