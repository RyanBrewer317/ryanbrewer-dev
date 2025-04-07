-module(party).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([run/3, pos/0, satisfy/1, any_char/0, char/1, either/2, choice/1, many/1, many1/1, map/2, 'try'/2, error_map/2, perhaps/1, 'not'/1, 'end'/0, lazy/1, do/2, seq/2, drop/2, all/1, return/1, between/3, sep1/2, sep/2, string/1, go/2, lowercase_letter/0, uppercase_letter/0, letter/0, digit/0, alphanum/0, many_concat/1, whitespace/0, many1_concat/1, digits/0, whitespace1/0, fail/0, until/2, line/0, line_concat/0, stateful_many/2, stateful_many1/2]).
-export_type([parse_error/1, position/0, parser/2]).

-type parse_error(FKG) :: {unexpected, position(), binary()} |
    {user_error, position(), FKG}.

-type position() :: {position, integer(), integer()}.

-opaque parser(FKH, FKI) :: {parser,
        fun((list(binary()), position()) -> {ok,
                {FKH, list(binary()), position()}} |
            {error, parse_error(FKI)})}.

-spec run(parser(FKJ, FKK), list(binary()), position()) -> {ok,
        {FKJ, list(binary()), position()}} |
    {error, parse_error(FKK)}.
run(P, Src, Pos) ->
    case P of
        {parser, F} ->
            F(Src, Pos)
    end.

-spec pos() -> parser(position(), any()).
pos() ->
    {parser, fun(Source, P) -> {ok, {P, Source, P}} end}.

-spec satisfy(fun((binary()) -> boolean())) -> parser(binary(), any()).
satisfy(Pred) ->
    {parser,
        fun(Source, Pos) ->
            {position, Row, Col} = Pos,
            case Source of
                [H | T] ->
                    case Pred(H) of
                        true ->
                            case H of
                                <<"\n"/utf8>> ->
                                    {ok, {H, T, {position, Row + 1, 0}}};

                                _ ->
                                    {ok, {H, T, {position, Row, Col + 1}}}
                            end;

                        false ->
                            {error, {unexpected, Pos, H}}
                    end;

                [] ->
                    {error, {unexpected, Pos, <<"EOF"/utf8>>}}
            end
        end}.

-spec any_char() -> parser(binary(), any()).
any_char() ->
    satisfy(fun(_) -> true end).

-spec char(binary()) -> parser(binary(), any()).
char(C) ->
    satisfy(fun(C2) -> C =:= C2 end).

-spec either(parser(FMB, FMC), parser(FMB, FMC)) -> parser(FMB, FMC).
either(P, Q) ->
    {parser,
        fun(Source, Pos) ->
            gleam@result:'or'(run(P, Source, Pos), run(Q, Source, Pos))
        end}.

-spec choice(list(parser(FNC, FND))) -> parser(FNC, FND).
choice(Ps) ->
    {parser, fun(Source, Pos) -> case Ps of
                [] ->
                    erlang:error(#{gleam_error => panic,
                            message => <<"choice doesn't accept an empty list of parsers"/utf8>>,
                            module => <<"party"/utf8>>,
                            function => <<"choice"/utf8>>,
                            line => 149});

                [P] ->
                    run(P, Source, Pos);

                [P@1 | T] ->
                    case run(P@1, Source, Pos) of
                        {ok, {X, R, Pos2}} ->
                            {ok, {X, R, Pos2}};

                        {error, _} ->
                            run(choice(T), Source, Pos)
                    end
            end end}.

-spec many(parser(FNS, FNT)) -> parser(list(FNS), FNT).
many(P) ->
    {parser, fun(Source, Pos) -> case run(P, Source, Pos) of
                {error, _} ->
                    {ok, {[], Source, Pos}};

                {ok, {X, R, Pos2}} ->
                    gleam@result:map(
                        run(many(P), R, Pos2),
                        fun(Res) ->
                            {[X | erlang:element(1, Res)],
                                erlang:element(2, Res),
                                erlang:element(3, Res)}
                        end
                    )
            end end}.

-spec many1(parser(FOE, FOF)) -> parser(list(FOE), FOF).
many1(P) ->
    {parser, fun(Source, Pos) -> case run(P, Source, Pos) of
                {error, E} ->
                    {error, E};

                {ok, {X, R, Pos2}} ->
                    gleam@result:map(
                        run(many(P), R, Pos2),
                        fun(Res) ->
                            {[X | erlang:element(1, Res)],
                                erlang:element(2, Res),
                                erlang:element(3, Res)}
                        end
                    )
            end end}.

-spec map(parser(FQC, FQD), fun((FQC) -> FQG)) -> parser(FQG, FQD).
map(P, F) ->
    {parser, fun(Source, Pos) -> case run(P, Source, Pos) of
                {ok, {X, R, Pos2}} ->
                    {ok, {F(X), R, Pos2}};

                {error, E} ->
                    {error, E}
            end end}.

-spec 'try'(parser(FQJ, FQK), fun((FQJ) -> {ok, FQN} | {error, FQK})) -> parser(FQN, FQK).
'try'(P, F) ->
    {parser, fun(Source, Pos) -> case run(P, Source, Pos) of
                {ok, {X, R, Pos2}} ->
                    case F(X) of
                        {ok, A} ->
                            {ok, {A, R, Pos2}};

                        {error, E} ->
                            {error, {user_error, Pos, E}}
                    end;

                {error, E@1} ->
                    {error, E@1}
            end end}.

-spec error_map(parser(FQS, FQT), fun((FQT) -> FQW)) -> parser(FQS, FQW).
error_map(P, F) ->
    {parser, fun(Source, Pos) -> case run(P, Source, Pos) of
                {ok, Res} ->
                    {ok, Res};

                {error, E} ->
                    case E of
                        {user_error, Pos@1, E@1} ->
                            {error, {user_error, Pos@1, F(E@1)}};

                        {unexpected, Pos@2, S} ->
                            {error, {unexpected, Pos@2, S}}
                    end
            end end}.

-spec perhaps(parser(FQZ, FRA)) -> parser({ok, FQZ} | {error, nil}, FRA).
perhaps(P) ->
    {parser, fun(Source, Pos) -> case run(P, Source, Pos) of
                {ok, {X, R, Pos2}} ->
                    {ok, {{ok, X}, R, Pos2}};

                {error, _} ->
                    {ok, {{error, nil}, Source, Pos}}
            end end}.

-spec 'not'(parser(any(), FRS)) -> parser(nil, FRS).
'not'(P) ->
    {parser, fun(Source, Pos) -> case run(P, Source, Pos) of
                {ok, _} ->
                    case Source of
                        [H | _] ->
                            {error, {unexpected, Pos, H}};

                        _ ->
                            {error, {unexpected, Pos, <<"EOF"/utf8>>}}
                    end;

                {error, _} ->
                    {ok, {nil, Source, Pos}}
            end end}.

-spec 'end'() -> parser(nil, any()).
'end'() ->
    {parser, fun(Source, Pos) -> case Source of
                [] ->
                    {ok, {nil, Source, Pos}};

                [H | _] ->
                    {error, {unexpected, Pos, H}}
            end end}.

-spec lazy(fun(() -> parser(FSA, FSB))) -> parser(FSA, FSB).
lazy(P) ->
    {parser, fun(Source, Pos) -> run(P(), Source, Pos) end}.

-spec do(parser(FSG, FSH), fun((FSG) -> parser(FSK, FSH))) -> parser(FSK, FSH).
do(P, F) ->
    {parser, fun(Source, Pos) -> case run(P, Source, Pos) of
                {ok, {X, R, Pos2}} ->
                    run(F(X), R, Pos2);

                {error, E} ->
                    {error, E}
            end end}.

-spec seq(parser(any(), FOR), parser(FOU, FOR)) -> parser(FOU, FOR).
seq(P, Q) ->
    do(P, fun(_) -> Q end).

-spec drop(parser(any(), FPA), fun(() -> parser(FPD, FPA))) -> parser(FPD, FPA).
drop(P, F) ->
    seq(P, lazy(F)).

-spec all(list(parser(FRH, FRI))) -> parser(FRH, FRI).
all(Ps) ->
    case Ps of
        [P] ->
            P;

        [H | T] ->
            do(H, fun(_) -> all(T) end);

        _ ->
            erlang:error(#{gleam_error => panic,
                    message => <<"all(parsers) doesn't accept an empty list of parsers"/utf8>>,
                    module => <<"party"/utf8>>,
                    function => <<"all"/utf8>>,
                    line => 314})
    end.

-spec return(FSP) -> parser(FSP, any()).
return(X) ->
    {parser, fun(Source, Pos) -> {ok, {X, Source, Pos}} end}.

-spec between(parser(any(), FMK), parser(FMN, FMK), parser(any(), FMK)) -> parser(FMN, FMK).
between(Open, P, Close) ->
    do(
        Open,
        fun(_) -> do(P, fun(X) -> do(Close, fun(_) -> return(X) end) end) end
    ).

-spec sep1(parser(FPS, FPT), parser(any(), FPT)) -> parser(list(FPS), FPT).
sep1(Parser, S) ->
    do(
        Parser,
        fun(First) ->
            do(many(seq(S, Parser)), fun(Rest) -> return([First | Rest]) end)
        end
    ).

-spec sep(parser(FPI, FPJ), parser(any(), FPJ)) -> parser(list(FPI), FPJ).
sep(Parser, S) ->
    do(perhaps(sep1(Parser, S)), fun(Res) -> case Res of
                {ok, Sequence} ->
                    return(Sequence);

                {error, nil} ->
                    return([])
            end end).

-spec string(binary()) -> parser(binary(), any()).
string(S) ->
    case gleam@string:pop_grapheme(S) of
        {ok, {H, T}} ->
            do(
                char(H),
                fun(C) ->
                    do(
                        string(T),
                        fun(Rest) -> return(<<C/binary, Rest/binary>>) end
                    )
                end
            );

        {error, _} ->
            return(<<""/utf8>>)
    end.

-spec go(parser(FKS, FKT), binary()) -> {ok, FKS} | {error, parse_error(FKT)}.
go(P, Src) ->
    case run(P, gleam@string:to_graphemes(Src), {position, 1, 1}) of
        {ok, {X, _, _}} ->
            {ok, X};

        {error, E} ->
            {error, E}
    end.

-spec lowercase_letter() -> parser(binary(), any()).
lowercase_letter() ->
    satisfy(
        fun(C) ->
            gleam_stdlib:contains_string(
                <<"abcdefghijklmnopqrstuvwxyz"/utf8>>,
                C
            )
        end
    ).

-spec uppercase_letter() -> parser(binary(), any()).
uppercase_letter() ->
    satisfy(
        fun(C) ->
            gleam_stdlib:contains_string(
                <<"ABCDEFGHIJKLMNOPQRSTUVWXYZ"/utf8>>,
                C
            )
        end
    ).

-spec letter() -> parser(binary(), any()).
letter() ->
    either(lowercase_letter(), uppercase_letter()).

-spec digit() -> parser(binary(), any()).
digit() ->
    satisfy(
        fun(C) -> gleam_stdlib:contains_string(<<"0123456789"/utf8>>, C) end
    ).

-spec alphanum() -> parser(binary(), any()).
alphanum() ->
    either(digit(), letter()).

-spec many_concat(parser(binary(), FNZ)) -> parser(binary(), FNZ).
many_concat(P) ->
    _pipe = many(P),
    map(_pipe, fun gleam@string:concat/1).

-spec whitespace() -> parser(binary(), any()).
whitespace() ->
    many_concat(
        choice([char(<<" "/utf8>>), char(<<"\t"/utf8>>), char(<<"\n"/utf8>>)])
    ).

-spec many1_concat(parser(binary(), FOL)) -> parser(binary(), FOL).
many1_concat(P) ->
    _pipe = many1(P),
    map(_pipe, fun gleam@string:concat/1).

-spec digits() -> parser(binary(), any()).
digits() ->
    many1_concat(digit()).

-spec whitespace1() -> parser(binary(), any()).
whitespace1() ->
    many1_concat(
        choice([char(<<" "/utf8>>), char(<<"\t"/utf8>>), char(<<"\n"/utf8>>)])
    ).

-spec fail() -> parser(any(), any()).
fail() ->
    {parser, fun(Source, Pos) -> case Source of
                [] ->
                    {error, {unexpected, Pos, <<"EOF"/utf8>>}};

                [H | _] ->
                    {error, {unexpected, Pos, H}}
            end end}.

-spec until(parser(FSV, FSW), parser(any(), FSW)) -> parser(list(FSV), FSW).
until(P, Terminator) ->
    either(
        (do(Terminator, fun(_) -> return([]) end)),
        (do(
            P,
            fun(First) ->
                do(
                    until(P, Terminator),
                    fun(Rest) -> return([First | Rest]) end
                )
            end
        ))
    ).

-spec line() -> parser(list(binary()), any()).
line() ->
    until(any_char(), char(<<"\n"/utf8>>)).

-spec line_concat() -> parser(binary(), any()).
line_concat() ->
    _pipe = line(),
    map(_pipe, fun gleam@string:concat/1).

-spec stateful_many(FTF, parser(fun((FTF) -> {FTG, FTF}), FTH)) -> parser({list(FTG),
    FTF}, FTH).
stateful_many(State, P) ->
    {parser, fun(Source, Pos) -> case run(P, Source, Pos) of
                {error, _} ->
                    {ok, {{[], State}, Source, Pos}};

                {ok, {F, R, Pos2}} ->
                    {X, S} = F(State),
                    gleam@result:map(
                        run(stateful_many(S, P), R, Pos2),
                        fun(Res) ->
                            {{Rest, S2}, R2, Pos3} = Res,
                            {{[X | Rest], S2}, R2, Pos3}
                        end
                    )
            end end}.

-spec stateful_many1(FTN, parser(fun((FTN) -> {FTO, FTN}), FTP)) -> parser({list(FTO),
    FTN}, FTP).
stateful_many1(State, P) ->
    {parser, fun(Source, Pos) -> case run(P, Source, Pos) of
                {error, E} ->
                    {error, E};

                {ok, {F, R, Pos2}} ->
                    {X, S} = F(State),
                    gleam@result:map(
                        run(stateful_many(S, P), R, Pos2),
                        fun(Res) ->
                            {{Rest, S@1}, R2, Pos3} = Res,
                            {{[X | Rest], S@1}, R2, Pos3}
                        end
                    )
            end end}.
