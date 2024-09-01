-module(gsv@internal@ast).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([parse/1]).
-export_type([parse_state/0, parse_error/0]).

-type parse_state() :: beginning |
    just_parsed_field |
    just_parsed_comma |
    just_parsed_newline |
    just_parsed_cr |
    inside_escaped_string.

-type parse_error() :: {parse_error, gsv@internal@token:location(), binary()}.

-spec parse_p(
    list({gsv@internal@token:csv_token(), gsv@internal@token:location()}),
    parse_state(),
    list(list(binary()))
) -> {ok, list(list(binary()))} | {error, parse_error()}.
parse_p(Input, Parse_state, Llf) ->
    case {Input, Parse_state, Llf} of
        {[], beginning, _} ->
            {error, {parse_error, {location, 0, 0}, <<"Empty input"/utf8>>}};

        {[], _, Llf@1} ->
            {ok, Llf@1};

        {[{{textdata, Str}, _} | Remaining_tokens], beginning, []} ->
            parse_p(Remaining_tokens, just_parsed_field, [[Str]]);

        {[{doublequote, _} | Remaining_tokens@1], beginning, []} ->
            parse_p(Remaining_tokens@1, inside_escaped_string, [[<<""/utf8>>]]);

        {[{Tok, Loc} | _], beginning, _} ->
            {error,
                {parse_error,
                    Loc,
                    <<"Unexpected start to csv content: "/utf8,
                        (gsv@internal@token:to_lexeme(Tok))/binary>>}};

        {[{comma, _} | Remaining_tokens@2], just_parsed_field, Llf@2} ->
            parse_p(Remaining_tokens@2, just_parsed_comma, Llf@2);

        {[{lf, _} | Remaining_tokens@3], just_parsed_field, Llf@3} ->
            parse_p(Remaining_tokens@3, just_parsed_newline, Llf@3);

        {[{cr, _} | Remaining_tokens@4], just_parsed_field, Llf@4} ->
            parse_p(Remaining_tokens@4, just_parsed_cr, Llf@4);

        {[{Tok@1, Loc@1} | _], just_parsed_field, _} ->
            {error,
                {parse_error,
                    Loc@1,
                    <<"Expected comma or newline after field, found: "/utf8,
                        (gsv@internal@token:to_lexeme(Tok@1))/binary>>}};

        {[{lf, _} | Remaining_tokens@5], just_parsed_cr, Llf@5} ->
            parse_p(Remaining_tokens@5, just_parsed_newline, Llf@5);

        {[{Tok@2, Loc@2} | _], just_parsed_cr, _} ->
            {error,
                {parse_error,
                    Loc@2,
                    <<"Expected \"\\n\" after \"\\r\", found: "/utf8,
                        (gsv@internal@token:to_lexeme(Tok@2))/binary>>}};

        {[{{textdata, Str@1}, _} | Remaining_tokens@6],
            just_parsed_comma,
            [Curr_line | Previously_parsed_lines]} ->
            parse_p(
                Remaining_tokens@6,
                just_parsed_field,
                [[Str@1 | Curr_line] | Previously_parsed_lines]
            );

        {[{doublequote, _} | Remaining_tokens@7],
            just_parsed_comma,
            [Curr_line@1 | Previously_parsed_lines@1]} ->
            parse_p(
                Remaining_tokens@7,
                inside_escaped_string,
                [[<<""/utf8>> | Curr_line@1] | Previously_parsed_lines@1]
            );

        {[{comma, _} | Remaining_tokens@8],
            just_parsed_comma,
            [Curr_line@2 | Previously_parsed_lines@2]} ->
            parse_p(
                Remaining_tokens@8,
                just_parsed_comma,
                [[<<""/utf8>> | Curr_line@2] | Previously_parsed_lines@2]
            );

        {[{cr, _} | Remaining_tokens@9],
            just_parsed_comma,
            [Curr_line@3 | Previously_parsed_lines@3]} ->
            parse_p(
                Remaining_tokens@9,
                just_parsed_cr,
                [[<<""/utf8>> | Curr_line@3] | Previously_parsed_lines@3]
            );

        {[{lf, _} | Remaining_tokens@10],
            just_parsed_comma,
            [Curr_line@4 | Previously_parsed_lines@4]} ->
            parse_p(
                Remaining_tokens@10,
                just_parsed_newline,
                [[<<""/utf8>> | Curr_line@4] | Previously_parsed_lines@4]
            );

        {[{Tok@3, Loc@3} | _], just_parsed_comma, _} ->
            {error,
                {parse_error,
                    Loc@3,
                    <<"Expected escaped or non-escaped string after comma, found: "/utf8,
                        (gsv@internal@token:to_lexeme(Tok@3))/binary>>}};

        {[{{textdata, Str@2}, _} | Remaining_tokens@11],
            just_parsed_newline,
            Llf@6} ->
            parse_p(Remaining_tokens@11, just_parsed_field, [[Str@2] | Llf@6]);

        {[{doublequote, _} | Remaining_tokens@12],
            just_parsed_newline,
            [Curr_line@5 | Previously_parsed_lines@5]} ->
            parse_p(
                Remaining_tokens@12,
                inside_escaped_string,
                [[<<""/utf8>> | Curr_line@5] | Previously_parsed_lines@5]
            );

        {[{Tok@4, Loc@4} | _], just_parsed_newline, _} ->
            {error,
                {parse_error,
                    Loc@4,
                    <<"Expected escaped or non-escaped string after newline, found: "/utf8,
                        (gsv@internal@token:to_lexeme(Tok@4))/binary>>}};

        {[{doublequote, _}, {doublequote, _} | Remaining_tokens@13],
            inside_escaped_string,
            [[Str@3 | Rest_curr_line] | Previously_parsed_lines@6]} ->
            parse_p(
                Remaining_tokens@13,
                inside_escaped_string,
                [[<<Str@3/binary, "\""/utf8>> | Rest_curr_line] |
                    Previously_parsed_lines@6]
            );

        {[{doublequote, _} | Remaining_tokens@14], inside_escaped_string, Llf@7} ->
            parse_p(Remaining_tokens@14, just_parsed_field, Llf@7);

        {[{Other_token, _} | Remaining_tokens@15],
            inside_escaped_string,
            [[Str@4 | Rest_curr_line@1] | Previously_parsed_lines@7]} ->
            parse_p(
                Remaining_tokens@15,
                inside_escaped_string,
                [[<<Str@4/binary,
                            (gsv@internal@token:to_lexeme(Other_token))/binary>> |
                        Rest_curr_line@1] |
                    Previously_parsed_lines@7]
            );

        {[{Tok@5, Loc@5} | _], _, _} ->
            {error,
                {parse_error,
                    Loc@5,
                    <<"Unexpected token: "/utf8,
                        (gsv@internal@token:to_lexeme(Tok@5))/binary>>}}
    end.

-spec parse(
    list({gsv@internal@token:csv_token(), gsv@internal@token:location()})
) -> {ok, list(list(binary()))} | {error, parse_error()}.
parse(Input) ->
    Inner_rev = (gleam@result:'try'(
        parse_p(Input, beginning, []),
        fun(Llf) ->
            gleam@list:try_map(Llf, fun(Lf) -> {ok, gleam@list:reverse(Lf)} end)
        end
    )),
    gleam@result:'try'(Inner_rev, fun(Ir) -> {ok, gleam@list:reverse(Ir)} end).
