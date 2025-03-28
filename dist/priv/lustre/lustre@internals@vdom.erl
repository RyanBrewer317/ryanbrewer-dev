-module(lustre@internals@vdom).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([attribute_to_event_handler/1, attribute_to_json/2, element_to_snapshot/1, element_to_string/1, element_to_string_builder/1, element_to_json/2, handlers/1]).
-export_type([element/1, attribute/1]).

-type element(NUU) :: {text, binary()} |
    {element,
        binary(),
        binary(),
        binary(),
        list(attribute(NUU)),
        list(element(NUU)),
        boolean(),
        boolean()} |
    {map, fun(() -> element(NUU))}.

-type attribute(NUV) :: {attribute,
        binary(),
        gleam@dynamic:dynamic_(),
        boolean()} |
    {event,
        binary(),
        fun((gleam@dynamic:dynamic_()) -> {ok, NUV} |
            {error, list(gleam@dynamic:decode_error())})}.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/internals/vdom.gleam", 508).
-spec attribute_to_event_handler(attribute(NWX)) -> {ok,
        {binary(),
            fun((gleam@dynamic:dynamic_()) -> {ok, NWX} |
                {error, list(gleam@dynamic:decode_error())})}} |
    {error, nil}.
attribute_to_event_handler(Attribute) ->
    case Attribute of
        {attribute, _, _, _} ->
            {error, nil};

        {event, Name, Handler} ->
            Name@1 = gleam@string:drop_left(Name, 2),
            {ok, {Name@1, Handler}}
    end.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/internals/vdom.gleam", 108).
-spec attribute_to_json(attribute(any()), binary()) -> {ok, gleam@json:json()} |
    {error, nil}.
attribute_to_json(Attribute, Key) ->
    True_atom = gleam_stdlib:identity(true),
    False_atom = gleam_stdlib:identity(false),
    case Attribute of
        {attribute, _, _, true} ->
            {error, nil};

        {attribute, Name, Value, false} ->
            case gleam@dynamic:classify(Value) of
                <<"String"/utf8>> ->
                    {ok,
                        gleam@json:object(
                            [{<<"0"/utf8>>, gleam@json:string(Name)},
                                {<<"1"/utf8>>,
                                    gleam@json:string(
                                        lustre_escape_ffi:coerce(Value)
                                    )}]
                        )};

                <<"Atom"/utf8>> when (Value =:= True_atom) orelse (Value =:= False_atom) ->
                    {ok,
                        gleam@json:object(
                            [{<<"0"/utf8>>, gleam@json:string(Name)},
                                {<<"1"/utf8>>,
                                    gleam@json:bool(
                                        lustre_escape_ffi:coerce(Value)
                                    )}]
                        )};

                <<"Bool"/utf8>> ->
                    {ok,
                        gleam@json:object(
                            [{<<"0"/utf8>>, gleam@json:string(Name)},
                                {<<"1"/utf8>>,
                                    gleam@json:bool(
                                        lustre_escape_ffi:coerce(Value)
                                    )}]
                        )};

                <<"Boolean"/utf8>> ->
                    {ok,
                        gleam@json:object(
                            [{<<"0"/utf8>>, gleam@json:string(Name)},
                                {<<"1"/utf8>>,
                                    gleam@json:bool(
                                        lustre_escape_ffi:coerce(Value)
                                    )}]
                        )};

                <<"Int"/utf8>> ->
                    {ok,
                        gleam@json:object(
                            [{<<"0"/utf8>>, gleam@json:string(Name)},
                                {<<"1"/utf8>>,
                                    gleam@json:int(
                                        lustre_escape_ffi:coerce(Value)
                                    )}]
                        )};

                <<"Float"/utf8>> ->
                    {ok,
                        gleam@json:object(
                            [{<<"0"/utf8>>, gleam@json:string(Name)},
                                {<<"1"/utf8>>,
                                    gleam@json:float(
                                        lustre_escape_ffi:coerce(Value)
                                    )}]
                        )};

                _ ->
                    {error, nil}
            end;

        {event, Name@1, _} ->
            Name@2 = gleam@string:drop_left(Name@1, 2),
            {ok,
                gleam@json:object(
                    [{<<"0"/utf8>>,
                            gleam@json:string(
                                <<"data-lustre-on-"/utf8, Name@2/binary>>
                            )},
                        {<<"1"/utf8>>,
                            gleam@json:string(
                                <<<<Key/binary, "-"/utf8>>/binary,
                                    Name@2/binary>>
                            )}]
                )}
    end.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/internals/vdom.gleam", 471).
-spec attribute_to_string_parts(attribute(any())) -> {ok, {binary(), binary()}} |
    {error, nil}.
attribute_to_string_parts(Attr) ->
    case Attr of
        {attribute, <<""/utf8>>, _, _} ->
            {error, nil};

        {attribute, Name, Value, As_property} ->
            True_atom = gleam_stdlib:identity(true),
            case gleam@dynamic:classify(Value) of
                <<"String"/utf8>> ->
                    {ok, {Name, lustre_escape_ffi:coerce(Value)}};

                <<"Atom"/utf8>> when Value =:= True_atom ->
                    {ok, {Name, <<""/utf8>>}};

                <<"Bool"/utf8>> when Value =:= True_atom ->
                    {ok, {Name, <<""/utf8>>}};

                <<"Boolean"/utf8>> when Value =:= True_atom ->
                    {ok, {Name, <<""/utf8>>}};

                <<"Atom"/utf8>> ->
                    {error, nil};

                <<"Bool"/utf8>> ->
                    {error, nil};

                <<"Boolean"/utf8>> ->
                    {error, nil};

                <<"Int"/utf8>> ->
                    {ok,
                        {Name,
                            gleam@int:to_string(lustre_escape_ffi:coerce(Value))}};

                <<"Float"/utf8>> ->
                    {ok,
                        {Name,
                            gleam@float:to_string(
                                lustre_escape_ffi:coerce(Value)
                            )}};

                _ when As_property ->
                    {error, nil};

                _ ->
                    {ok, {Name, gleam@string:inspect(Value)}}
            end;

        _ ->
            {error, nil}
    end.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/internals/vdom.gleam", 400).
-spec attributes_to_string_builder(list(attribute(any()))) -> {gleam@string_builder:string_builder(),
    binary()}.
attributes_to_string_builder(Attrs) ->
    {Html@1, Class@1, Style@1, Inner_html@1} = begin
        Init = {gleam@string_builder:new(),
            <<""/utf8>>,
            <<""/utf8>>,
            <<""/utf8>>},
        gleam@list:fold(
            Attrs,
            Init,
            fun(_use0, Attr) ->
                {Html, Class, Style, Inner_html} = _use0,
                case attribute_to_string_parts(Attr) of
                    {ok, {<<"dangerous-unescaped-html"/utf8>>, Val}} ->
                        {Html, Class, Style, <<Inner_html/binary, Val/binary>>};

                    {ok, {<<"class"/utf8>>, Val@1}} when Class =:= <<""/utf8>> ->
                        {Html,
                            lustre@internals@escape:escape(Val@1),
                            Style,
                            Inner_html};

                    {ok, {<<"class"/utf8>>, Val@2}} ->
                        {Html,
                            <<<<Class/binary, " "/utf8>>/binary,
                                (lustre@internals@escape:escape(Val@2))/binary>>,
                            Style,
                            Inner_html};

                    {ok, {<<"style"/utf8>>, Val@3}} when Style =:= <<""/utf8>> ->
                        {Html,
                            Class,
                            lustre@internals@escape:escape(Val@3),
                            Inner_html};

                    {ok, {<<"style"/utf8>>, Val@4}} ->
                        {Html,
                            Class,
                            <<<<Style/binary, " "/utf8>>/binary,
                                (lustre@internals@escape:escape(Val@4))/binary>>,
                            Inner_html};

                    {ok, {Key, <<""/utf8>>}} ->
                        {gleam@string_builder:append(
                                Html,
                                <<" "/utf8, Key/binary>>
                            ),
                            Class,
                            Style,
                            Inner_html};

                    {ok, {Key@1, Val@5}} ->
                        {gleam@string_builder:append(
                                Html,
                                <<<<<<<<" "/utf8, Key@1/binary>>/binary,
                                            "=\""/utf8>>/binary,
                                        (lustre@internals@escape:escape(Val@5))/binary>>/binary,
                                    "\""/utf8>>
                            ),
                            Class,
                            Style,
                            Inner_html};

                    {error, _} ->
                        {Html, Class, Style, Inner_html}
                end
            end
        )
    end,
    {case {Class@1, Style@1} of
            {<<""/utf8>>, <<""/utf8>>} ->
                Html@1;

            {_, <<""/utf8>>} ->
                gleam@string_builder:append(
                    Html@1,
                    <<<<" class=\""/utf8, Class@1/binary>>/binary, "\""/utf8>>
                );

            {<<""/utf8>>, _} ->
                gleam@string_builder:append(
                    Html@1,
                    <<<<" style=\""/utf8, Style@1/binary>>/binary, "\""/utf8>>
                );

            {_, _} ->
                gleam@string_builder:append(
                    Html@1,
                    <<<<<<<<" class=\""/utf8, Class@1/binary>>/binary,
                                "\" style=\""/utf8>>/binary,
                            Style@1/binary>>/binary,
                        "\""/utf8>>
                )
        end, Inner_html@1}.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/internals/vdom.gleam", 376).
-spec children_to_snapshot_builder(
    gleam@string_builder:string_builder(),
    list(element(any())),
    boolean(),
    integer()
) -> gleam@string_builder:string_builder().
children_to_snapshot_builder(Html, Children, Raw_text, Indent) ->
    case Children of
        [{text, A}, {text, B} | Rest] ->
            children_to_snapshot_builder(
                Html,
                [{text, <<A/binary, B/binary>>} | Rest],
                Raw_text,
                Indent
            );

        [Child | Rest@1] ->
            _pipe = Child,
            _pipe@1 = do_element_to_snapshot_builder(_pipe, Raw_text, Indent),
            _pipe@2 = gleam@string_builder:append(_pipe@1, <<"\n"/utf8>>),
            _pipe@3 = gleam@string_builder:append_builder(Html, _pipe@2),
            children_to_snapshot_builder(_pipe@3, Rest@1, Raw_text, Indent);

        [] ->
            Html
    end.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/internals/vdom.gleam", 281).
-spec do_element_to_snapshot_builder(element(any()), boolean(), integer()) -> gleam@string_builder:string_builder().
do_element_to_snapshot_builder(Element, Raw_text, Indent) ->
    Spaces = gleam@string:repeat(<<"  "/utf8>>, Indent),
    case Element of
        {text, <<""/utf8>>} ->
            gleam@string_builder:new();

        {text, Content} when Raw_text ->
            gleam@string_builder:from_strings([Spaces, Content]);

        {text, Content@1} ->
            gleam@string_builder:from_strings(
                [Spaces, lustre@internals@escape:escape(Content@1)]
            );

        {map, Subtree} ->
            do_element_to_snapshot_builder(Subtree(), Raw_text, Indent);

        {element, _, Namespace, Tag, Attrs, _, Self_closing, _} when Self_closing ->
            Html = gleam@string_builder:from_string(<<"<"/utf8, Tag/binary>>),
            {Attrs@1, _} = attributes_to_string_builder(case Namespace of
                    <<""/utf8>> ->
                        Attrs;

                    _ ->
                        [{attribute,
                                <<"xmlns"/utf8>>,
                                gleam_stdlib:identity(Namespace),
                                false} |
                            Attrs]
                end),
            _pipe = Html,
            _pipe@1 = gleam@string_builder:prepend(_pipe, Spaces),
            _pipe@2 = gleam@string_builder:append_builder(_pipe@1, Attrs@1),
            gleam@string_builder:append(_pipe@2, <<"/>"/utf8>>);

        {element, _, Namespace@1, Tag@1, Attrs@2, _, _, Void} when Void ->
            Html@1 = gleam@string_builder:from_string(
                <<"<"/utf8, Tag@1/binary>>
            ),
            {Attrs@3, _} = attributes_to_string_builder(case Namespace@1 of
                    <<""/utf8>> ->
                        Attrs@2;

                    _ ->
                        [{attribute,
                                <<"xmlns"/utf8>>,
                                gleam_stdlib:identity(Namespace@1),
                                false} |
                            Attrs@2]
                end),
            _pipe@3 = Html@1,
            _pipe@4 = gleam@string_builder:prepend(_pipe@3, Spaces),
            _pipe@5 = gleam@string_builder:append_builder(_pipe@4, Attrs@3),
            gleam@string_builder:append(_pipe@5, <<">"/utf8>>);

        {element, _, <<""/utf8>>, Tag@2, Attrs@4, [], _, _} ->
            Html@2 = gleam@string_builder:from_string(
                <<"<"/utf8, Tag@2/binary>>
            ),
            {Attrs@5, _} = attributes_to_string_builder(Attrs@4),
            _pipe@6 = Html@2,
            _pipe@7 = gleam@string_builder:prepend(_pipe@6, Spaces),
            _pipe@8 = gleam@string_builder:append_builder(_pipe@7, Attrs@5),
            _pipe@9 = gleam@string_builder:append(_pipe@8, <<">"/utf8>>),
            gleam@string_builder:append(
                _pipe@9,
                <<<<"</"/utf8, Tag@2/binary>>/binary, ">"/utf8>>
            );

        {element,
            _,
            <<""/utf8>>,
            <<"style"/utf8>> = Tag@3,
            Attrs@6,
            Children,
            false,
            false} ->
            Html@3 = gleam@string_builder:from_string(
                <<"<"/utf8, Tag@3/binary>>
            ),
            {Attrs@7, _} = attributes_to_string_builder(Attrs@6),
            _pipe@10 = Html@3,
            _pipe@11 = gleam@string_builder:prepend(_pipe@10, Spaces),
            _pipe@12 = gleam@string_builder:append_builder(_pipe@11, Attrs@7),
            _pipe@13 = gleam@string_builder:append(_pipe@12, <<">"/utf8>>),
            _pipe@14 = children_to_snapshot_builder(
                _pipe@13,
                Children,
                true,
                Indent + 1
            ),
            _pipe@15 = gleam@string_builder:append(_pipe@14, Spaces),
            gleam@string_builder:append(
                _pipe@15,
                <<<<"</"/utf8, Tag@3/binary>>/binary, ">"/utf8>>
            );

        {element,
            _,
            <<""/utf8>>,
            <<"script"/utf8>> = Tag@3,
            Attrs@6,
            Children,
            false,
            false} ->
            Html@3 = gleam@string_builder:from_string(
                <<"<"/utf8, Tag@3/binary>>
            ),
            {Attrs@7, _} = attributes_to_string_builder(Attrs@6),
            _pipe@10 = Html@3,
            _pipe@11 = gleam@string_builder:prepend(_pipe@10, Spaces),
            _pipe@12 = gleam@string_builder:append_builder(_pipe@11, Attrs@7),
            _pipe@13 = gleam@string_builder:append(_pipe@12, <<">"/utf8>>),
            _pipe@14 = children_to_snapshot_builder(
                _pipe@13,
                Children,
                true,
                Indent + 1
            ),
            _pipe@15 = gleam@string_builder:append(_pipe@14, Spaces),
            gleam@string_builder:append(
                _pipe@15,
                <<<<"</"/utf8, Tag@3/binary>>/binary, ">"/utf8>>
            );

        {element, _, Namespace@2, Tag@4, Attrs@8, Children@1, _, _} ->
            Html@4 = gleam@string_builder:from_string(
                <<"<"/utf8, Tag@4/binary>>
            ),
            {Attrs@9, Inner_html} = attributes_to_string_builder(
                case Namespace@2 of
                    <<""/utf8>> ->
                        Attrs@8;

                    _ ->
                        [{attribute,
                                <<"xmlns"/utf8>>,
                                gleam_stdlib:identity(Namespace@2),
                                false} |
                            Attrs@8]
                end
            ),
            case Inner_html of
                <<""/utf8>> ->
                    _pipe@16 = Html@4,
                    _pipe@17 = gleam@string_builder:prepend(_pipe@16, Spaces),
                    _pipe@18 = gleam@string_builder:append_builder(
                        _pipe@17,
                        Attrs@9
                    ),
                    _pipe@19 = gleam@string_builder:append(
                        _pipe@18,
                        <<">\n"/utf8>>
                    ),
                    _pipe@20 = children_to_snapshot_builder(
                        _pipe@19,
                        Children@1,
                        Raw_text,
                        Indent + 1
                    ),
                    _pipe@21 = gleam@string_builder:append(_pipe@20, Spaces),
                    gleam@string_builder:append(
                        _pipe@21,
                        <<<<"</"/utf8, Tag@4/binary>>/binary, ">"/utf8>>
                    );

                _ ->
                    _pipe@22 = Html@4,
                    _pipe@23 = gleam@string_builder:append_builder(
                        _pipe@22,
                        Attrs@9
                    ),
                    gleam@string_builder:append(
                        _pipe@23,
                        <<<<<<<<">"/utf8, Inner_html/binary>>/binary,
                                    "</"/utf8>>/binary,
                                Tag@4/binary>>/binary,
                            ">"/utf8>>
                    )
            end
    end.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/internals/vdom.gleam", 275).
-spec element_to_snapshot(element(any())) -> binary().
element_to_snapshot(Element) ->
    _pipe = Element,
    _pipe@1 = do_element_to_snapshot_builder(_pipe, false, 0),
    gleam@string_builder:to_string(_pipe@1).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/internals/vdom.gleam", 263).
-spec children_to_string_builder(
    gleam@string_builder:string_builder(),
    list(element(any())),
    boolean()
) -> gleam@string_builder:string_builder().
children_to_string_builder(Html, Children, Raw_text) ->
    gleam@list:fold(Children, Html, fun(Html@1, Child) -> _pipe = Child,
            _pipe@1 = do_element_to_string_builder(_pipe, Raw_text),
            gleam@string_builder:append_builder(Html@1, _pipe@1) end).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/internals/vdom.gleam", 188).
-spec do_element_to_string_builder(element(any()), boolean()) -> gleam@string_builder:string_builder().
do_element_to_string_builder(Element, Raw_text) ->
    case Element of
        {text, <<""/utf8>>} ->
            gleam@string_builder:new();

        {text, Content} when Raw_text ->
            gleam@string_builder:from_string(Content);

        {text, Content@1} ->
            gleam@string_builder:from_string(
                lustre@internals@escape:escape(Content@1)
            );

        {map, Subtree} ->
            do_element_to_string_builder(Subtree(), Raw_text);

        {element, _, Namespace, Tag, Attrs, _, Self_closing, _} when Self_closing ->
            Html = gleam@string_builder:from_string(<<"<"/utf8, Tag/binary>>),
            {Attrs@1, _} = attributes_to_string_builder(case Namespace of
                    <<""/utf8>> ->
                        Attrs;

                    _ ->
                        [{attribute,
                                <<"xmlns"/utf8>>,
                                gleam_stdlib:identity(Namespace),
                                false} |
                            Attrs]
                end),
            _pipe = Html,
            _pipe@1 = gleam@string_builder:append_builder(_pipe, Attrs@1),
            gleam@string_builder:append(_pipe@1, <<"/>"/utf8>>);

        {element, _, Namespace@1, Tag@1, Attrs@2, _, _, Void} when Void ->
            Html@1 = gleam@string_builder:from_string(
                <<"<"/utf8, Tag@1/binary>>
            ),
            {Attrs@3, _} = attributes_to_string_builder(case Namespace@1 of
                    <<""/utf8>> ->
                        Attrs@2;

                    _ ->
                        [{attribute,
                                <<"xmlns"/utf8>>,
                                gleam_stdlib:identity(Namespace@1),
                                false} |
                            Attrs@2]
                end),
            _pipe@2 = Html@1,
            _pipe@3 = gleam@string_builder:append_builder(_pipe@2, Attrs@3),
            gleam@string_builder:append(_pipe@3, <<">"/utf8>>);

        {element,
            _,
            <<""/utf8>>,
            <<"style"/utf8>> = Tag@2,
            Attrs@4,
            Children,
            false,
            false} ->
            Html@2 = gleam@string_builder:from_string(
                <<"<"/utf8, Tag@2/binary>>
            ),
            {Attrs@5, _} = attributes_to_string_builder(Attrs@4),
            _pipe@4 = Html@2,
            _pipe@5 = gleam@string_builder:append_builder(_pipe@4, Attrs@5),
            _pipe@6 = gleam@string_builder:append(_pipe@5, <<">"/utf8>>),
            _pipe@7 = children_to_string_builder(_pipe@6, Children, true),
            gleam@string_builder:append(
                _pipe@7,
                <<<<"</"/utf8, Tag@2/binary>>/binary, ">"/utf8>>
            );

        {element,
            _,
            <<""/utf8>>,
            <<"script"/utf8>> = Tag@2,
            Attrs@4,
            Children,
            false,
            false} ->
            Html@2 = gleam@string_builder:from_string(
                <<"<"/utf8, Tag@2/binary>>
            ),
            {Attrs@5, _} = attributes_to_string_builder(Attrs@4),
            _pipe@4 = Html@2,
            _pipe@5 = gleam@string_builder:append_builder(_pipe@4, Attrs@5),
            _pipe@6 = gleam@string_builder:append(_pipe@5, <<">"/utf8>>),
            _pipe@7 = children_to_string_builder(_pipe@6, Children, true),
            gleam@string_builder:append(
                _pipe@7,
                <<<<"</"/utf8, Tag@2/binary>>/binary, ">"/utf8>>
            );

        {element, _, Namespace@2, Tag@3, Attrs@6, Children@1, _, _} ->
            Html@3 = gleam@string_builder:from_string(
                <<"<"/utf8, Tag@3/binary>>
            ),
            {Attrs@7, Inner_html} = attributes_to_string_builder(
                case Namespace@2 of
                    <<""/utf8>> ->
                        Attrs@6;

                    _ ->
                        [{attribute,
                                <<"xmlns"/utf8>>,
                                gleam_stdlib:identity(Namespace@2),
                                false} |
                            Attrs@6]
                end
            ),
            case Inner_html of
                <<""/utf8>> ->
                    _pipe@8 = Html@3,
                    _pipe@9 = gleam@string_builder:append_builder(
                        _pipe@8,
                        Attrs@7
                    ),
                    _pipe@10 = gleam@string_builder:append(
                        _pipe@9,
                        <<">"/utf8>>
                    ),
                    _pipe@11 = children_to_string_builder(
                        _pipe@10,
                        Children@1,
                        Raw_text
                    ),
                    gleam@string_builder:append(
                        _pipe@11,
                        <<<<"</"/utf8, Tag@3/binary>>/binary, ">"/utf8>>
                    );

                _ ->
                    _pipe@12 = Html@3,
                    _pipe@13 = gleam@string_builder:append_builder(
                        _pipe@12,
                        Attrs@7
                    ),
                    gleam@string_builder:append(
                        _pipe@13,
                        <<<<<<<<">"/utf8, Inner_html/binary>>/binary,
                                    "</"/utf8>>/binary,
                                Tag@3/binary>>/binary,
                            ">"/utf8>>
                    )
            end
    end.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/internals/vdom.gleam", 178).
-spec element_to_string(element(any())) -> binary().
element_to_string(Element) ->
    _pipe = Element,
    _pipe@1 = do_element_to_string_builder(_pipe, false),
    gleam@string_builder:to_string(_pipe@1).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/internals/vdom.gleam", 184).
-spec element_to_string_builder(element(any())) -> gleam@string_builder:string_builder().
element_to_string_builder(Element) ->
    do_element_to_string_builder(Element, false).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/internals/vdom.gleam", 100).
-spec do_element_list_to_json(list(element(any())), binary()) -> gleam@json:json().
do_element_list_to_json(Elements, Key) ->
    gleam@json:preprocessed_array(
        (gleam@list:index_map(
            Elements,
            fun(Element, Index) ->
                Key@1 = <<<<Key/binary, "-"/utf8>>/binary,
                    (gleam@int:to_string(Index))/binary>>,
                element_to_json(Element, Key@1)
            end
        ))
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/internals/vdom.gleam", 77).
-spec element_to_json(element(any()), binary()) -> gleam@json:json().
element_to_json(Element, Key) ->
    case Element of
        {text, Content} ->
            gleam@json:object(
                [{<<"content"/utf8>>, gleam@json:string(Content)}]
            );

        {map, Subtree} ->
            element_to_json(Subtree(), Key);

        {element, _, Namespace, Tag, Attrs, Children, Self_closing, Void} ->
            Attrs@1 = gleam@json:preprocessed_array(
                (gleam@list:filter_map(
                    Attrs,
                    fun(_capture) -> attribute_to_json(_capture, Key) end
                ))
            ),
            Children@1 = do_element_list_to_json(Children, Key),
            gleam@json:object(
                [{<<"namespace"/utf8>>, gleam@json:string(Namespace)},
                    {<<"tag"/utf8>>, gleam@json:string(Tag)},
                    {<<"attrs"/utf8>>, Attrs@1},
                    {<<"children"/utf8>>, Children@1},
                    {<<"self_closing"/utf8>>, gleam@json:bool(Self_closing)},
                    {<<"void"/utf8>>, gleam@json:bool(Void)}]
            )
    end.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/internals/vdom.gleam", 65).
-spec do_element_list_handlers(
    list(element(NVJ)),
    gleam@dict:dict(binary(), fun((gleam@dynamic:dynamic_()) -> {ok, NVJ} |
        {error, list(gleam@dynamic:decode_error())})),
    binary()
) -> gleam@dict:dict(binary(), fun((gleam@dynamic:dynamic_()) -> {ok, NVJ} |
    {error, list(gleam@dynamic:decode_error())})).
do_element_list_handlers(Elements, Handlers, Key) ->
    gleam@list:index_fold(
        Elements,
        Handlers,
        fun(Handlers@1, Element, Index) ->
            Key@1 = <<<<Key/binary, "-"/utf8>>/binary,
                (gleam@int:to_string(Index))/binary>>,
            do_handlers(Element, Handlers@1, Key@1)
        end
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/internals/vdom.gleam", 42).
-spec do_handlers(
    element(NVB),
    gleam@dict:dict(binary(), fun((gleam@dynamic:dynamic_()) -> {ok, NVB} |
        {error, list(gleam@dynamic:decode_error())})),
    binary()
) -> gleam@dict:dict(binary(), fun((gleam@dynamic:dynamic_()) -> {ok, NVB} |
    {error, list(gleam@dynamic:decode_error())})).
do_handlers(Element, Handlers, Key) ->
    case Element of
        {text, _} ->
            Handlers;

        {map, Subtree} ->
            do_handlers(Subtree(), Handlers, Key);

        {element, _, _, _, Attrs, Children, _, _} ->
            Handlers@2 = gleam@list:fold(
                Attrs,
                Handlers,
                fun(Handlers@1, Attr) ->
                    case attribute_to_event_handler(Attr) of
                        {ok, {Name, Handler}} ->
                            gleam@dict:insert(
                                Handlers@1,
                                <<<<Key/binary, "-"/utf8>>/binary, Name/binary>>,
                                Handler
                            );

                        {error, _} ->
                            Handlers@1
                    end
                end
            ),
            do_element_list_handlers(Children, Handlers@2, Key)
    end.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/internals/vdom.gleam", 38).
-spec handlers(element(NUW)) -> gleam@dict:dict(binary(), fun((gleam@dynamic:dynamic_()) -> {ok,
        NUW} |
    {error, list(gleam@dynamic:decode_error())})).
handlers(Element) ->
    do_handlers(Element, gleam@dict:new(), <<"0"/utf8>>).
