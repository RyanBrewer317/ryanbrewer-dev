-module(gsv).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).
-define(FILEPATH, "src/gsv.gleam").
-export([from_lists/3, from_dicts/3, to_lists/2, to_dicts/2]).
-export_type([parse_error/0, line_ending/0, parse_status/0, sep_status/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-type parse_error() :: {unescaped_quote, integer()} |
    {unclosed_escaped_field, integer()}.

-type line_ending() :: windows | unix.

-type parse_status() :: parsing_escaped_field |
    parsing_unescaped_field |
    separator_found |
    newline_found.

-type sep_status() :: quot_sep | sep | no_sep.

-file("src/gsv.gleam", 46).
-spec line_ending_to_string(line_ending()) -> binary().
line_ending_to_string(Le) ->
    case Le of
        windows ->
            <<"\r\n"/utf8>>;

        unix ->
            <<"\n"/utf8>>
    end.

-file("src/gsv.gleam", 558).
-spec escape_field(binary(), binary()) -> binary().
escape_field(Field, Separator) ->
    case gleam_stdlib:contains_string(Field, <<"\""/utf8>>) of
        true ->
            <<<<"\""/utf8,
                    (gleam@string:replace(Field, <<"\""/utf8>>, <<"\"\""/utf8>>))/binary>>/binary,
                "\""/utf8>>;

        false ->
            case gleam_stdlib:contains_string(Field, Separator) orelse gleam_stdlib:contains_string(
                Field,
                <<"\n"/utf8>>
            ) of
                true ->
                    <<<<"\""/utf8, Field/binary>>/binary, "\""/utf8>>;

                false ->
                    Field
            end
    end.

-file("src/gsv.gleam", 543).
?DOC(
    " Takes a list of lists of strings and turns it to a csv string, automatically\n"
    " escaping all fields that contain double quotes or line endings.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " let rows = [[\"hello\", \"world\"], [\"goodbye\", \"mars\"]]\n"
    " from_lists(rows, separator: \",\", line_ending: Unix)\n"
    " // \"hello,world\n"
    " // goodbye,mars\"\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " let rows = [[]]\n"
    " ```\n"
).
-spec from_lists(list(list(binary())), binary(), line_ending()) -> binary().
from_lists(Rows, Separator, Line_ending) ->
    Line_ending@1 = line_ending_to_string(Line_ending),
    _pipe@1 = gleam@list:map(
        Rows,
        fun(Row) ->
            _pipe = gleam@list:map(
                Row,
                fun(_capture) -> escape_field(_capture, Separator) end
            ),
            gleam@string:join(_pipe, Separator)
        end
    ),
    _pipe@2 = gleam@string:join(_pipe@1, Line_ending@1),
    gleam@string:append(_pipe@2, Line_ending@1).

-file("src/gsv.gleam", 595).
-spec row_dict_to_list(gleam@dict:dict(binary(), binary()), list(binary())) -> list(binary()).
row_dict_to_list(Row, Headers) ->
    gleam@list:map(
        Headers,
        fun(Header) -> case gleam_stdlib:map_get(Row, Header) of
                {ok, Field} ->
                    Field;

                {error, nil} ->
                    <<""/utf8>>
            end end
    ).

-file("src/gsv.gleam", 575).
?DOC(
    " Takes a list of dicts and writes it to a csv string.\n"
    " Will automatically escape strings that contain double quotes or\n"
    " line endings with double quotes (in csv, double quotes get escaped by doing\n"
    " a double doublequote)\n"
    " The string `he\"llo\\n` becomes `\"he\"\"llo\\n\"`\n"
).
-spec from_dicts(
    list(gleam@dict:dict(binary(), binary())),
    binary(),
    line_ending()
) -> binary().
from_dicts(Rows, Separator, Line_ending) ->
    case Rows of
        [] ->
            <<""/utf8>>;

        _ ->
            Headers = begin
                _pipe = Rows,
                _pipe@1 = gleam@list:flat_map(_pipe, fun maps:keys/1),
                _pipe@2 = gleam@list:unique(_pipe@1),
                gleam@list:sort(_pipe@2, fun gleam@string:compare/2)
            end,
            Rows@1 = gleam@list:map(
                Rows,
                fun(_capture) -> row_dict_to_list(_capture, Headers) end
            ),
            from_lists([Headers | Rows@1], Separator, Line_ending)
    end.

-file("src/gsv.gleam", 455).
-spec extract_field(binary(), integer(), integer(), parse_status()) -> binary().
extract_field(String, From, Length, Status) ->
    Field = gsv_ffi:slice(String, From, Length),
    case Status of
        separator_found ->
            Field;

        parsing_unescaped_field ->
            Field;

        newline_found ->
            Field;

        parsing_escaped_field ->
            gleam@string:replace(Field, <<"\"\""/utf8>>, <<"\""/utf8>>)
    end.

-file("src/gsv.gleam", 182).
?DOC(
    " ## What does this scary looking function do?\n"
    "\n"
    " At a high level, it goes over the csv `string` byte-by-byte and parses rows\n"
    " accumulating those into `rows` as it goes.\n"
    "\n"
    "\n"
    " ## Why does it have all these parameters? What does each one do?\n"
    "\n"
    " In order to be extra efficient this function parses the csv file in a single\n"
    " pass and uses string slicing to avoid copying data.\n"
    " Each time we see a new field we keep track of the byte where it starts with\n"
    " `field_start` and then count the bytes (that's the `field_length` variable)\n"
    " until we fiend its end (either a newline, the end of the file, or a `,`).\n"
    "\n"
    " After reaching the end of a field we extract it from the original string\n"
    " taking a slice that goes from `field_start` and has `field_length` bytes.\n"
    " This is where the magic happens: slicing a string this way is a constant\n"
    " time operation and doesn't copy the string so it's crazy fast!\n"
    "\n"
    " `row` is an accumulator with all the fields of the current row as\n"
    " they are parsed. Once we run into a newline `current_row` is added to all\n"
    " the other `rows`.\n"
    "\n"
    " We also keep track of _what_ we're parsing with the `status` to make\n"
    " sure that we're correctly dealing with escaped fields and double quotes.\n"
).
-spec do_parse(
    binary(),
    binary(),
    integer(),
    integer(),
    list(binary()),
    list(list(binary())),
    parse_status(),
    binary()
) -> {ok, list(list(binary()))} | {error, parse_error()}.
do_parse(
    String,
    Original,
    Field_start,
    Field_length,
    Row,
    Rows,
    Status,
    Field_separator
) ->
    Sep_len = string:length(Field_separator),
    {Remaining, Skip, Sep} = case gleam_stdlib:string_starts_with(
        String,
        Field_separator
    ) of
        true ->
            {gleam@string:drop_start(String, Sep_len), Sep_len, sep};

        false ->
            case gleam_stdlib:string_starts_with(
                String,
                <<"\""/utf8, Field_separator/binary>>
            ) of
                true ->
                    {gleam@string:drop_start(String, Sep_len + 1),
                        Sep_len + 1,
                        quot_sep};

                false ->
                    {String, 0, no_sep}
            end
    end,
    case {Remaining, Status, Sep} of
        {Rest, separator_found, sep} ->
            Field = extract_field(Original, Field_start, Field_length, Status),
            Row@1 = [Field | Row],
            Start = (Field_start + Field_length) + Skip,
            do_parse(
                Rest,
                Original,
                Start,
                0,
                Row@1,
                Rows,
                separator_found,
                Field_separator
            );

        {Rest, newline_found, sep} ->
            Field = extract_field(Original, Field_start, Field_length, Status),
            Row@1 = [Field | Row],
            Start = (Field_start + Field_length) + Skip,
            do_parse(
                Rest,
                Original,
                Start,
                0,
                Row@1,
                Rows,
                separator_found,
                Field_separator
            );

        {Rest, parsing_unescaped_field, sep} ->
            Field = extract_field(Original, Field_start, Field_length, Status),
            Row@1 = [Field | Row],
            Start = (Field_start + Field_length) + Skip,
            do_parse(
                Rest,
                Original,
                Start,
                0,
                Row@1,
                Rows,
                separator_found,
                Field_separator
            );

        {Rest, parsing_escaped_field, quot_sep} ->
            Field = extract_field(Original, Field_start, Field_length, Status),
            Row@1 = [Field | Row],
            Start = (Field_start + Field_length) + Skip,
            do_parse(
                Rest,
                Original,
                Start,
                0,
                Row@1,
                Rows,
                separator_found,
                Field_separator
            );

        {<<""/utf8>>, parsing_unescaped_field, no_sep} ->
            Field@1 = extract_field(Original, Field_start, Field_length, Status),
            Row@2 = lists:reverse([Field@1 | Row]),
            {ok, lists:reverse([Row@2 | Rows])};

        {<<"\""/utf8>>, parsing_escaped_field, no_sep} ->
            Field@1 = extract_field(Original, Field_start, Field_length, Status),
            Row@2 = lists:reverse([Field@1 | Row]),
            {ok, lists:reverse([Row@2 | Rows])};

        {<<""/utf8>>, separator_found, no_sep} ->
            Row@3 = lists:reverse([<<""/utf8>> | Row]),
            {ok, lists:reverse([Row@3 | Rows])};

        {<<""/utf8>>, newline_found, no_sep} ->
            {ok, lists:reverse(Rows)};

        {<<""/utf8>>, parsing_escaped_field, no_sep} ->
            {error, {unclosed_escaped_field, Field_start}};

        {<<"\n"/utf8, Rest@1/binary>>, parsing_unescaped_field, no_sep} ->
            Field@2 = extract_field(Original, Field_start, Field_length, Status),
            Row@4 = lists:reverse([Field@2 | Row]),
            Rows@1 = [Row@4 | Rows],
            Field_start@1 = (Field_start + Field_length) + 1,
            do_parse(
                Rest@1,
                Original,
                Field_start@1,
                0,
                [],
                Rows@1,
                newline_found,
                Field_separator
            );

        {<<"\r\n"/utf8, Rest@2/binary>>, parsing_unescaped_field, no_sep} ->
            Field@3 = extract_field(Original, Field_start, Field_length, Status),
            Row@5 = lists:reverse([Field@3 | Row]),
            Rows@2 = [Row@5 | Rows],
            Field_start@2 = (Field_start + Field_length) + 2,
            do_parse(
                Rest@2,
                Original,
                Field_start@2,
                0,
                [],
                Rows@2,
                newline_found,
                Field_separator
            );

        {<<"\"\n"/utf8, Rest@2/binary>>, parsing_escaped_field, no_sep} ->
            Field@3 = extract_field(Original, Field_start, Field_length, Status),
            Row@5 = lists:reverse([Field@3 | Row]),
            Rows@2 = [Row@5 | Rows],
            Field_start@2 = (Field_start + Field_length) + 2,
            do_parse(
                Rest@2,
                Original,
                Field_start@2,
                0,
                [],
                Rows@2,
                newline_found,
                Field_separator
            );

        {<<"\"\r\n"/utf8, Rest@3/binary>>, parsing_escaped_field, no_sep} ->
            Field@4 = extract_field(Original, Field_start, Field_length, Status),
            Row@6 = lists:reverse([Field@4 | Row]),
            Rows@3 = [Row@6 | Rows],
            Field_start@3 = (Field_start + Field_length) + 3,
            do_parse(
                Rest@3,
                Original,
                Field_start@3,
                0,
                [],
                Rows@3,
                newline_found,
                Field_separator
            );

        {<<"\n"/utf8, Rest@4/binary>>, separator_found, no_sep} ->
            Row@7 = lists:reverse([<<""/utf8>> | Row]),
            Rows@4 = [Row@7 | Rows],
            do_parse(
                Rest@4,
                Original,
                Field_start + 1,
                0,
                [],
                Rows@4,
                newline_found,
                Field_separator
            );

        {<<"\r\n"/utf8, Rest@5/binary>>, separator_found, no_sep} ->
            Row@8 = lists:reverse([<<""/utf8>> | Row]),
            Rows@5 = [Row@8 | Rows],
            do_parse(
                Rest@5,
                Original,
                Field_start + 2,
                0,
                [],
                Rows@5,
                newline_found,
                Field_separator
            );

        {<<"\n"/utf8, Rest@6/binary>>, newline_found, no_sep} ->
            do_parse(
                Rest@6,
                Original,
                Field_start + 1,
                0,
                Row,
                Rows,
                Status,
                Field_separator
            );

        {<<"\r\n"/utf8, Rest@7/binary>>, newline_found, no_sep} ->
            do_parse(
                Rest@7,
                Original,
                Field_start + 2,
                0,
                Row,
                Rows,
                Status,
                Field_separator
            );

        {<<"\"\""/utf8, Rest@8/binary>>, parsing_escaped_field, no_sep} ->
            do_parse(
                Rest@8,
                Original,
                Field_start,
                Field_length + 2,
                Row,
                Rows,
                Status,
                Field_separator
            );

        {<<"\""/utf8, _/binary>>, parsing_unescaped_field, no_sep} ->
            {error, {unescaped_quote, Field_start + Field_length}};

        {<<"\""/utf8, _/binary>>, parsing_escaped_field, no_sep} ->
            {error, {unescaped_quote, Field_start + Field_length}};

        {<<"\""/utf8, Rest@9/binary>>, separator_found, no_sep} ->
            do_parse(
                Rest@9,
                Original,
                Field_start + 1,
                0,
                Row,
                Rows,
                parsing_escaped_field,
                Field_separator
            );

        {<<"\""/utf8, Rest@9/binary>>, newline_found, no_sep} ->
            do_parse(
                Rest@9,
                Original,
                Field_start + 1,
                0,
                Row,
                Rows,
                parsing_escaped_field,
                Field_separator
            );

        {_, separator_found, _} ->
            Status@1 = case Status of
                parsing_escaped_field ->
                    parsing_escaped_field;

                separator_found ->
                    parsing_unescaped_field;

                newline_found ->
                    parsing_unescaped_field;

                parsing_unescaped_field ->
                    parsing_unescaped_field
            end,
            Rest@10 = gsv_ffi:drop_bytes(String, 1),
            do_parse(
                Rest@10,
                Original,
                Field_start,
                Field_length + 1,
                Row,
                Rows,
                Status@1,
                Field_separator
            );

        {_, newline_found, _} ->
            Status@1 = case Status of
                parsing_escaped_field ->
                    parsing_escaped_field;

                separator_found ->
                    parsing_unescaped_field;

                newline_found ->
                    parsing_unescaped_field;

                parsing_unescaped_field ->
                    parsing_unescaped_field
            end,
            Rest@10 = gsv_ffi:drop_bytes(String, 1),
            do_parse(
                Rest@10,
                Original,
                Field_start,
                Field_length + 1,
                Row,
                Rows,
                Status@1,
                Field_separator
            );

        {_, parsing_unescaped_field, _} ->
            Status@1 = case Status of
                parsing_escaped_field ->
                    parsing_escaped_field;

                separator_found ->
                    parsing_unescaped_field;

                newline_found ->
                    parsing_unescaped_field;

                parsing_unescaped_field ->
                    parsing_unescaped_field
            end,
            Rest@10 = gsv_ffi:drop_bytes(String, 1),
            do_parse(
                Rest@10,
                Original,
                Field_start,
                Field_length + 1,
                Row,
                Rows,
                Status@1,
                Field_separator
            );

        {_, parsing_escaped_field, _} ->
            Status@1 = case Status of
                parsing_escaped_field ->
                    parsing_escaped_field;

                separator_found ->
                    parsing_unescaped_field;

                newline_found ->
                    parsing_unescaped_field;

                parsing_unescaped_field ->
                    parsing_unescaped_field
            end,
            Rest@10 = gsv_ffi:drop_bytes(String, 1),
            do_parse(
                Rest@10,
                Original,
                Field_start,
                Field_length + 1,
                Row,
                Rows,
                Status@1,
                Field_separator
            )
    end.

-file("src/gsv.gleam", 80).
?DOC(
    " Parses a csv string into a list of lists of strings: each line of the csv\n"
    " will be turned into a list with an item for each field.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " \"hello, world\n"
    " goodbye, mars\"\n"
    " |> gsv.to_lists(seperator: \",\")\n"
    " // Ok([\n"
    " //    [\"hello\", \" world\"],\n"
    " //    [\"goodbye\", \" mars\"],\n"
    " // ])\n"
    " ```\n"
    "\n"
    " > This implementation tries to stick as closely as possible to\n"
    " > [RFC4180](https://www.ietf.org/rfc/rfc4180.txt), with a couple notable\n"
    " > convenience differences:\n"
    " > - both `\\n` and `\\r\\n` line endings are accepted.\n"
    " > - a line can start with an empty field `,two,three`.\n"
    " > - empty lines are allowed and just ignored.\n"
    " > - lines are not forced to all have the same number of fields.\n"
    " > - the field seperator doesn't have to be a comma but any string (even multiple characters).\n"
    " > - a line can end with a field seperator (meaning its last field is empty).\n"
).
-spec to_lists(binary(), binary()) -> {ok, list(list(binary()))} |
    {error, parse_error()}.
to_lists(Input, Field_separator) ->
    case {Input, gleam_stdlib:string_starts_with(Input, Field_separator)} of
        {<<"\n"/utf8, Rest/binary>>, _} ->
            to_lists(Rest, Field_separator);

        {<<"\r\n"/utf8, Rest/binary>>, _} ->
            to_lists(Rest, Field_separator);

        {<<"\""/utf8, Rest@1/binary>>, _} ->
            do_parse(
                Rest@1,
                Input,
                1,
                0,
                [],
                [],
                parsing_escaped_field,
                Field_separator
            );

        {Rest@2, true} ->
            do_parse(
                gleam@string:drop_start(Rest@2, string:length(Field_separator)),
                Input,
                1,
                0,
                [<<""/utf8>>],
                [],
                separator_found,
                Field_separator
            );

        {_, false} ->
            do_parse(
                Input,
                Input,
                0,
                0,
                [],
                [],
                parsing_unescaped_field,
                Field_separator
            )
    end.

-file("src/gsv.gleam", 499).
?DOC(
    " Parses a csv string into a list of dicts: the first line of the csv is\n"
    " interpreted as the headers' row and each of the following lines is turned\n"
    " into a dict with a value for each of the headers.\n"
    "\n"
    " If a field is empty then it won't be added to the dict.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " \"pet,name,cuteness\n"
    " dog,Fido,100\n"
    " cat,,1000\n"
    " \"\n"
    " |> gsv.to_dicts(separator: \",\")\n"
    " // Ok([\n"
    " //    dict.from_list([\n"
    " //      #(\"pet\", \"dog\"), #(\"name\", \"Fido\"), #(\"cuteness\", \"100\")\n"
    " //    ]),\n"
    " //    dict.from_list([\n"
    " //      #(\"pet\", \"cat\"), #(\"cuteness\", \"1000\")\n"
    " //    ]),\n"
    " // ])\n"
    " ```\n"
    "\n"
    " > Just list `to_lists` this implementation tries to stick as closely as\n"
    " > possible to [RFC4180](https://www.ietf.org/rfc/rfc4180.txt).\n"
    " > You can look at `to_lists`' documentation to see how it differs from the\n"
    " > RFC.\n"
).
-spec to_dicts(binary(), binary()) -> {ok,
        list(gleam@dict:dict(binary(), binary()))} |
    {error, parse_error()}.
to_dicts(Input, Field_separator) ->
    gleam@result:map(to_lists(Input, Field_separator), fun(Rows) -> case Rows of
                [] ->
                    [];

                [Headers | Rows@1] ->
                    Headers@1 = erlang:list_to_tuple(Headers),
                    gleam@list:map(
                        Rows@1,
                        fun(Row) ->
                            gleam@list:index_fold(
                                Row,
                                maps:new(),
                                fun(Row@1, Field, Index) -> case Field of
                                        <<""/utf8>> ->
                                            Row@1;

                                        _ ->
                                            case glearray:get(Headers@1, Index) of
                                                {ok, Header} ->
                                                    gleam@dict:insert(
                                                        Row@1,
                                                        Header,
                                                        Field
                                                    );

                                                {error, _} ->
                                                    Row@1
                                            end
                                    end end
                            )
                        end
                    )
            end end).
