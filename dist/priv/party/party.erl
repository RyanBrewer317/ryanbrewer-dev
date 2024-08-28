-module(party).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([run/3, pos/0, satisfy/1, char/1, either/2, choice/1, many/1, many1/1, map/2, 'try'/2, error_map/2, perhaps/1, 'not'/1, 'end'/0, lazy/1, do/2, seq/2, all/1, return/1, sep1/2, sep/2, string/1, go/2, lowercase_letter/0, uppercase_letter/0, letter/0, digit/0, alphanum/0, many_concat/1, whitespace/0, many1_concat/1, digits/0, whitespace1/0, fail/0, until/2, stateful_many/2, stateful_many1/2]).
-export_type([parse_error/1, position/0, parser/2]).

-type parse_error(FJA) :: {unexpected, position(), binary()} |
    {user_error, position(), FJA}.

-type position() :: {position, integer(), integer()}.

-opaque parser(FJB, FJC) :: {parser,
        fun((list(binary()), position()) -> {ok,
                {FJB, list(binary()), position()}} |
            {error, parse_error(FJC)})}.

-spec run(parser(FJD, FJE), list(binary()), position()) -> {ok,
        {FJD, list(binary()), position()}} |
    {error, parse_error(FJE)}.
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

-spec char(binary()) -> parser(binary(), any()).
char(C) ->
    satisfy(fun(C2) -> C =:= C2 end).

-spec either(parser(FKS, FKT), parser(FKS, FKT)) -> parser(FKS, FKT).
either(P, Q) ->
    {parser,
        fun(Source, Pos) ->
            gleam@result:'or'(run(P, Source, Pos), run(Q, Source, Pos))
        end}.

-spec choice(list(parser(FLA, FLB))) -> parser(FLA, FLB).
choice(Ps) ->
    {parser, fun(Source, Pos) -> case Ps of
                [] ->
                    erlang:error(#{gleam_error => panic,
                            message => <<"choice doesn't accept an empty list of parsers"/utf8>>,
                            module => <<"party"/utf8>>,
                            function => <<"choice"/utf8>>,
                            line => 118});

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

-spec many(parser(FLQ, FLR)) -> parser(list(FLQ), FLR).
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

-spec many1(parser(FMC, FMD)) -> parser(list(FMC), FMD).
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

-spec map(parser(FNR, FNS), fun((FNR) -> FNV)) -> parser(FNV, FNS).
map(P, F) ->
    {parser, fun(Source, Pos) -> case run(P, Source, Pos) of
                {ok, {X, R, Pos2}} ->
                    {ok, {F(X), R, Pos2}};

                {error, E} ->
                    {error, E}
            end end}.

-spec 'try'(parser(FNY, FNZ), fun((FNY) -> {ok, FOC} | {error, FNZ})) -> parser(FOC, FNZ).
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

-spec error_map(parser(FOH, FOI), fun((FOI) -> FOL)) -> parser(FOH, FOL).
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

-spec perhaps(parser(FOO, FOP)) -> parser({ok, FOO} | {error, nil}, FOP).
perhaps(P) ->
    {parser, fun(Source, Pos) -> case run(P, Source, Pos) of
                {ok, {X, R, Pos2}} ->
                    {ok, {{ok, X}, R, Pos2}};

                {error, _} ->
                    {ok, {{error, nil}, Source, Pos}}
            end end}.

-spec 'not'(parser(any(), FPH)) -> parser(nil, FPH).
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

-spec lazy(fun(() -> parser(FPP, FPQ))) -> parser(FPP, FPQ).
lazy(P) ->
    {parser, fun(Source, Pos) -> run(P(), Source, Pos) end}.

-spec do(parser(FPV, FPW), fun((FPV) -> parser(FPZ, FPW))) -> parser(FPZ, FPW).
do(P, F) ->
    {parser, fun(Source, Pos) -> case run(P, Source, Pos) of
                {ok, {X, R, Pos2}} ->
                    run(F(X), R, Pos2);

                {error, E} ->
                    {error, E}
            end end}.

-spec seq(parser(any(), FMP), parser(FMS, FMP)) -> parser(FMS, FMP).
seq(P, Q) ->
    do(P, fun(_) -> Q end).

-spec all(list(parser(FOW, FOX))) -> parser(FOW, FOX).
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
                    line => 269})
    end.

-spec return(FQE) -> parser(FQE, any()).
return(X) ->
    {parser, fun(Source, Pos) -> {ok, {X, Source, Pos}} end}.

-spec sep1(parser(FNH, FNI), parser(any(), FNI)) -> parser(list(FNH), FNI).
sep1(Parser, S) ->
    do(
        Parser,
        fun(First) ->
            do(many(seq(S, Parser)), fun(Rest) -> return([First | Rest]) end)
        end
    ).

-spec sep(parser(FMX, FMY), parser(any(), FMY)) -> parser(list(FMX), FMY).
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

-spec go(parser(FJM, FJN), binary()) -> {ok, FJM} | {error, parse_error(FJN)}.
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

-spec many_concat(parser(binary(), FLX)) -> parser(binary(), FLX).
many_concat(P) ->
    _pipe = many(P),
    map(_pipe, fun gleam@string:concat/1).

-spec whitespace() -> parser(binary(), any()).
whitespace() ->
    many_concat(
        choice([char(<<" "/utf8>>), char(<<"\t"/utf8>>), char(<<"\n"/utf8>>)])
    ).

-spec many1_concat(parser(binary(), FMJ)) -> parser(binary(), FMJ).
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

-spec until(parser(FQK, FQL), parser(any(), FQL)) -> parser(list(FQK), FQL).
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

-spec stateful_many(FQU, parser(fun((FQU) -> {FQV, FQU}), FQW)) -> parser({list(FQV),
    FQU}, FQW).
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

-spec stateful_many1(FRC, parser(fun((FRC) -> {FRD, FRC}), FRE)) -> parser({list(FRD),
    FRC}, FRE).
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
