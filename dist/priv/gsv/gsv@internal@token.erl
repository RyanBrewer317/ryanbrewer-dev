-module(gsv@internal@token).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([to_lexeme/1, scan/1, with_location/1]).
-export_type([csv_token/0, location/0]).

-type csv_token() :: comma | lf | cr | doublequote | {textdata, binary()}.

-type location() :: {location, integer(), integer()}.

-spec to_lexeme(csv_token()) -> binary().
to_lexeme(Token) ->
    case Token of
        comma ->
            <<","/utf8>>;

        lf ->
            <<"\n"/utf8>>;

        cr ->
            <<"\r"/utf8>>;

        doublequote ->
            <<"\""/utf8>>;

        {textdata, Str} ->
            Str
    end.

-spec len(csv_token()) -> integer().
len(Token) ->
    case Token of
        comma ->
            1;

        lf ->
            1;

        cr ->
            1;

        doublequote ->
            1;

        {textdata, Str} ->
            gleam@string:length(Str)
    end.

-spec scan(binary()) -> list(csv_token()).
scan(Input) ->
    _pipe = Input,
    _pipe@1 = gleam@string:to_utf_codepoints(_pipe),
    _pipe@2 = gleam@list:fold(
        _pipe@1,
        [],
        fun(Acc, X) -> case gleam@string:utf_codepoint_to_int(X) of
                16#2c ->
                    [comma | Acc];

                16#22 ->
                    [doublequote | Acc];

                16#0a ->
                    [lf | Acc];

                16#0D ->
                    [cr | Acc];

                _ ->
                    Cp = gleam_stdlib:utf_codepoint_list_to_string([X]),
                    case Acc of
                        [{textdata, Str} | Rest] ->
                            [{textdata, <<Str/binary, Cp/binary>>} | Rest];

                        _ ->
                            [{textdata, Cp} | Acc]
                    end
            end end
    ),
    gleam@list:reverse(_pipe@2).

-spec do_with_location(
    list(csv_token()),
    list({csv_token(), location()}),
    location()
) -> list({csv_token(), location()}).
do_with_location(Input, Acc, Curr_loc) ->
    {location, Line, Column} = Curr_loc,
    case Input of
        [] ->
            Acc;

        [lf | Rest] ->
            do_with_location(
                Rest,
                [{lf, Curr_loc} | Acc],
                {location, Line + 1, 1}
            );

        [cr, lf | Rest@1] ->
            do_with_location(
                Rest@1,
                [{lf, {location, Line, Column + 1}}, {cr, Curr_loc} | Acc],
                {location, Line + 1, 1}
            );

        [Token | Rest@2] ->
            do_with_location(
                Rest@2,
                [{Token, Curr_loc} | Acc],
                {location, Line, Column + len(Token)}
            )
    end.

-spec with_location(list(csv_token())) -> list({csv_token(), location()}).
with_location(Input) ->
    _pipe = do_with_location(Input, [], {location, 1, 1}),
    gleam@list:reverse(_pipe).
