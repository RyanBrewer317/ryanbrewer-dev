-module(gsv).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([to_lists/1, to_lists_or_panic/1, to_lists_or_error/1, from_lists/3]).
-export_type([line_ending/0]).

-type line_ending() :: windows | unix.

-spec to_lists(binary()) -> {ok, list(list(binary()))} | {error, nil}.
to_lists(Input) ->
    _pipe = Input,
    _pipe@1 = gsv@internal@token:scan(_pipe),
    _pipe@2 = gsv@internal@token:with_location(_pipe@1),
    _pipe@3 = gsv@internal@ast:parse(_pipe@2),
    gleam@result:nil_error(_pipe@3).

-spec to_lists_or_panic(binary()) -> list(list(binary())).
to_lists_or_panic(Input) ->
    Res = begin
        _pipe = Input,
        _pipe@1 = gsv@internal@token:scan(_pipe),
        _pipe@2 = gsv@internal@token:with_location(_pipe@1),
        gsv@internal@ast:parse(_pipe@2)
    end,
    case Res of
        {ok, Lol} ->
            Lol;

        {error, {parse_error, {location, Line, Column}, Msg}} ->
            erlang:error(#{gleam_error => panic,
                    message => (<<<<<<<<<<<<"["/utf8, "line "/utf8>>/binary,
                                        (gleam@int:to_string(Line))/binary>>/binary,
                                    " column "/utf8>>/binary,
                                (gleam@int:to_string(Column))/binary>>/binary,
                            "] of csv: "/utf8>>/binary,
                        Msg/binary>>),
                    module => <<"gsv"/utf8>>,
                    function => <<"to_lists_or_panic"/utf8>>,
                    line => 31}),
            [[]]
    end.

-spec to_lists_or_error(binary()) -> {ok, list(list(binary()))} |
    {error, binary()}.
to_lists_or_error(Input) ->
    _pipe = Input,
    _pipe@1 = gsv@internal@token:scan(_pipe),
    _pipe@2 = gsv@internal@token:with_location(_pipe@1),
    _pipe@3 = gsv@internal@ast:parse(_pipe@2),
    gleam@result:map_error(
        _pipe@3,
        fun(E) ->
            {parse_error, {location, Line, Column}, Msg} = E,
            <<<<<<<<<<<<"["/utf8, "line "/utf8>>/binary,
                                (gleam@int:to_string(Line))/binary>>/binary,
                            " column "/utf8>>/binary,
                        (gleam@int:to_string(Column))/binary>>/binary,
                    "] of csv: "/utf8>>/binary,
                Msg/binary>>
        end
    ).

-spec le_to_string(line_ending()) -> binary().
le_to_string(Le) ->
    case Le of
        windows ->
            <<"\r\n"/utf8>>;

        unix ->
            <<"\n"/utf8>>
    end.

-spec from_lists(list(list(binary())), binary(), line_ending()) -> binary().
from_lists(Input, Separator, Line_ending) ->
    _pipe = Input,
    _pipe@1 = gleam@list:map(
        _pipe,
        fun(Row) ->
            gleam@list:map(
                Row,
                fun(Entry) ->
                    Entry@1 = gleam@string:replace(
                        Entry,
                        <<"\""/utf8>>,
                        <<"\"\""/utf8>>
                    ),
                    case (gleam_stdlib:contains_string(Entry@1, Separator)
                    orelse gleam_stdlib:contains_string(Entry@1, <<"\n"/utf8>>))
                    orelse gleam_stdlib:contains_string(Entry@1, <<"\""/utf8>>) of
                        true ->
                            <<<<"\""/utf8, Entry@1/binary>>/binary, "\""/utf8>>;

                        false ->
                            Entry@1
                    end
                end
            )
        end
    ),
    _pipe@2 = gleam@list:map(
        _pipe@1,
        fun(Row@1) -> gleam@string:join(Row@1, Separator) end
    ),
    gleam@string:join(_pipe@2, le_to_string(Line_ending)).
