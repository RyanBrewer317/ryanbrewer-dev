-module(shellout).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([display/1, color/1, background/1, arguments/0, command/4, exit/1, which/1, style/3]).
-export_type([style/0, style_acc/0, command_opt/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-type style() :: {name, binary()} | {rgb, list(binary())}.

-type style_acc() :: {style_acc, list(style()), integer()}.

-type command_opt() :: let_be_stderr |
    let_be_stdout |
    overlapped_stdio |
    {set_environment, list({binary(), binary()})}.

-file("src/shellout.gleam", 118).
?DOC(
    " Converts a list of `\"display\"` style labels into a\n"
    " [`StyleFlags`](#StyleFlags).\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " style(\n"
    "   \"radical\",\n"
    "   with: display([\"bold\", \"italic\", \"tubular\"]),\n"
    "   custom: [],\n"
    " )\n"
    " // -> \"\\u{1b}[1;3mradical\\u{1b}[0m\\u{1b}[K\"\n"
    " ```\n"
).
-spec display(list(binary())) -> gleam@dict:dict(binary(), list(binary())).
display(Values) ->
    maps:from_list([{<<"display"/utf8>>, Values}]).

-file("src/shellout.gleam", 136).
?DOC(
    " Converts a list of `\"color\"` style labels into a\n"
    " [`StyleFlags`](#StyleFlags).\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " style(\n"
    "   \"uh...\",\n"
    "   with: color([\"yellow\", \"brightgreen\", \"gnarly\"]),\n"
    "   custom: [],\n"
    " )\n"
    " // -> \"\\u{1b}[33;92muh...\\u{1b}[0m\\u{1b}[K\"\n"
    " ```\n"
).
-spec color(list(binary())) -> gleam@dict:dict(binary(), list(binary())).
color(Values) ->
    maps:from_list([{<<"color"/utf8>>, Values}]).

-file("src/shellout.gleam", 154).
?DOC(
    " Converts a list of `\"background\"` style labels into a\n"
    " [`StyleFlags`](#StyleFlags).\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " style(\n"
    "   \"awesome\",\n"
    "   with: background([\"yellow\", \"brightgreen\", \"bodacious\"]),\n"
    "   custom: [],\n"
    " )\n"
    " // -> \"\\u{1b}[43;102mawesome\\u{1b}[0m\\u{1b}[K\"\n"
    " ```\n"
).
-spec background(list(binary())) -> gleam@dict:dict(binary(), list(binary())).
background(Values) ->
    maps:from_list([{<<"background"/utf8>>, Values}]).

-file("src/shellout.gleam", 213).
-spec escape(binary(), binary()) -> binary().
escape(Code, String) ->
    <<<<<<<<"\x{1b}["/utf8, Code/binary>>/binary, "m"/utf8>>/binary,
            String/binary>>/binary,
        "\x{1b}[0m\x{1b}[K"/utf8>>.

-file("src/shellout.gleam", 323).
?DOC(
    " Retrieves a list of strings corresponding to any extra arguments passed when\n"
    " invoking a runtime—via `gleam run`, for example.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " // $ gleam run -- pizza --order=5 --anchovies=false\n"
    " arguments()\n"
    " // -> [\"pizza\", \"--order=5\", \"--anchovies=false\"]\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " // $ gleam run --target=javascript\n"
    " arguments()\n"
    " // -> []\n"
    " ```\n"
).
-spec arguments() -> list(binary()).
arguments() ->
    shellout_ffi:start_arguments().

-file("src/shellout.gleam", 415).
?DOC(
    " Results in any output captured from the given `executable` on success, or an\n"
    " `Error` on failure.\n"
    "\n"
    " An `Error` result wraps a tuple in which the first element is an OS error\n"
    " status code and the second is a message about what went wrong (or an empty\n"
    " string).\n"
    "\n"
    " The `executable` is given `arguments` and run from within the given\n"
    " `directory`.\n"
    "\n"
    " Any number of [`CommandOpt`](#CommandOpt) options can be given to alter the\n"
    " behavior of this function.\n"
    "\n"
    " The standard error stream is by default redirected to the standard output\n"
    " stream, and both are captured. When targeting JavaScript, anything captured\n"
    " from the standard error stream is appended to anything captured from the\n"
    " standard output stream.\n"
    "\n"
    " The standard input stream is by default handled in\n"
    " [raw mode](https://www.wikiwand.com/en/Terminal_mode) when targeting\n"
    " JavaScript, allowing full interaction with the spawned process. When\n"
    " targeting Erlang, however, it's always handled in\n"
    " [cooked mode](https://www.wikiwand.com/en/Terminal_mode).\n"
    "\n"
    " Note that while `shellout` aims for near feature parity between runtimes,\n"
    " some discrepancies exist and are documented herein.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " command(run: \"echo\", with: [\"-n\", \"Cool!\"], in: \".\", opt: [])\n"
    " // -> Ok(\"Cool!\")\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " command(run: \"echo\", with: [\"Cool!\"], in: \".\", opt: [LetBeStdout])\n"
    " // Cool!\n"
    " // -> Ok(\"\")\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " // $ stat -c '%a %U %n' /tmp/dimension_x\n"
    " // 700 root /tmp/dimension_x\n"
    " command(run: \"ls\", with: [\"dimension_x\"], in: \"/tmp\", opt: [])\n"
    " // -> Error(#(2, \"ls: cannot open directory 'dimension_x': Permission denied\\n\"))\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " command(run: \"dimension_x\", with: [], in: \".\", opt: [])\n"
    " // -> Error(#(1, \"command `dimension_x` not found\\n\"))\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " // $ ls -p\n"
    " // gleam.toml  manifest.toml  src/  test/\n"
    " command(run: \"echo\", with: [], in: \"dimension_x\", opt: [])\n"
    " // -> Error(#(2, \"The directory \\\"dimension_x\\\" does not exist\\n\"))\n"
    " ```\n"
).
-spec command(binary(), list(binary()), binary(), list(command_opt())) -> {ok,
        binary()} |
    {error, {integer(), binary()}}.
command(Executable, Arguments, Directory, Options) ->
    Environment = gleam@list:flat_map(Options, fun(Option) -> case Option of
                {set_environment, Env} ->
                    Env;

                _ ->
                    []
            end end),
    _pipe = Options,
    _pipe@1 = gleam@list:map(_pipe, fun(Opt) -> {Opt, true} end),
    _pipe@2 = maps:from_list(_pipe@1),
    shellout_ffi:os_command(
        Executable,
        Arguments,
        Directory,
        _pipe@2,
        Environment
    ).

-file("src/shellout.gleam", 466).
?DOC(
    " Halts the runtime and passes the given `status` code to the operating\n"
    " system.\n"
    "\n"
    " A `status` code of `0` typically indicates success, while any other integer\n"
    " represents an error.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " // $ gleam run && echo \"Pizza time!\"\n"
    " exit(0)\n"
    " // Pizza time!\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " // $ gleam run || echo \"Ugh, shell shock ...\"\n"
    " exit(1)\n"
    " // Ugh, shell shock ...\n"
    " ```\n"
).
-spec exit(integer()) -> nil.
exit(Status) ->
    shellout_ffi:os_exit(Status).

-file("src/shellout.gleam", 490).
?DOC(
    " Results in a path to the given `executable` on success, or an `Error` when\n"
    " no such path is found.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " which(\"echo\")\n"
    " // -> Ok(\"/sbin/echo\")\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " which(\"./priv/party\")\n"
    " // -> Ok(\"./priv/party\")\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " which(\"dimension_x\")\n"
    " // -> Error(\"command `dimension_x` not found\")\n"
    " ```\n"
).
-spec which(binary()) -> {ok, binary()} | {error, binary()}.
which(Executable) ->
    shellout_ffi:os_which(Executable).

-file("src/shellout.gleam", 226).
-spec do_style(list({binary(), list(binary())}), list(binary()), binary()) -> list(binary()).
do_style(Lookup, Strings, Flag) ->
    Lookup@1 = begin
        _pipe@2 = case Flag of
            <<"display"/utf8>> ->
                maps:from_list(
                    [{<<"reset"/utf8>>, [<<"0"/utf8>>]},
                        {<<"bold"/utf8>>, [<<"1"/utf8>>]},
                        {<<"dim"/utf8>>, [<<"2"/utf8>>]},
                        {<<"italic"/utf8>>, [<<"3"/utf8>>]},
                        {<<"underline"/utf8>>, [<<"4"/utf8>>]},
                        {<<"blink"/utf8>>, [<<"5"/utf8>>]},
                        {<<"fastblink"/utf8>>, [<<"6"/utf8>>]},
                        {<<"reverse"/utf8>>, [<<"7"/utf8>>]},
                        {<<"hide"/utf8>>, [<<"8"/utf8>>]},
                        {<<"strike"/utf8>>, [<<"9"/utf8>>]},
                        {<<"normal"/utf8>>, [<<"22"/utf8>>]},
                        {<<"noitalic"/utf8>>, [<<"23"/utf8>>]},
                        {<<"nounderline"/utf8>>, [<<"24"/utf8>>]},
                        {<<"noblink"/utf8>>, [<<"25"/utf8>>]},
                        {<<"noreverse"/utf8>>, [<<"27"/utf8>>]},
                        {<<"nohide"/utf8>>, [<<"28"/utf8>>]},
                        {<<"nostrike"/utf8>>, [<<"29"/utf8>>]}]
                );

            <<"color"/utf8>> ->
                maps:from_list(
                    [{<<"black"/utf8>>, [<<"30"/utf8>>]},
                        {<<"red"/utf8>>, [<<"31"/utf8>>]},
                        {<<"green"/utf8>>, [<<"32"/utf8>>]},
                        {<<"yellow"/utf8>>, [<<"33"/utf8>>]},
                        {<<"blue"/utf8>>, [<<"34"/utf8>>]},
                        {<<"magenta"/utf8>>, [<<"35"/utf8>>]},
                        {<<"cyan"/utf8>>, [<<"36"/utf8>>]},
                        {<<"white"/utf8>>, [<<"37"/utf8>>]},
                        {<<"default"/utf8>>, [<<"39"/utf8>>]},
                        {<<"brightblack"/utf8>>, [<<"90"/utf8>>]},
                        {<<"brightred"/utf8>>, [<<"91"/utf8>>]},
                        {<<"brightgreen"/utf8>>, [<<"92"/utf8>>]},
                        {<<"brightyellow"/utf8>>, [<<"93"/utf8>>]},
                        {<<"brightblue"/utf8>>, [<<"94"/utf8>>]},
                        {<<"brightmagenta"/utf8>>, [<<"95"/utf8>>]},
                        {<<"brightcyan"/utf8>>, [<<"96"/utf8>>]},
                        {<<"brightwhite"/utf8>>, [<<"97"/utf8>>]}]
                );

            <<"background"/utf8>> ->
                _pipe = [{<<"black"/utf8>>, [<<"30"/utf8>>]},
                    {<<"red"/utf8>>, [<<"31"/utf8>>]},
                    {<<"green"/utf8>>, [<<"32"/utf8>>]},
                    {<<"yellow"/utf8>>, [<<"33"/utf8>>]},
                    {<<"blue"/utf8>>, [<<"34"/utf8>>]},
                    {<<"magenta"/utf8>>, [<<"35"/utf8>>]},
                    {<<"cyan"/utf8>>, [<<"36"/utf8>>]},
                    {<<"white"/utf8>>, [<<"37"/utf8>>]},
                    {<<"default"/utf8>>, [<<"39"/utf8>>]},
                    {<<"brightblack"/utf8>>, [<<"90"/utf8>>]},
                    {<<"brightred"/utf8>>, [<<"91"/utf8>>]},
                    {<<"brightgreen"/utf8>>, [<<"92"/utf8>>]},
                    {<<"brightyellow"/utf8>>, [<<"93"/utf8>>]},
                    {<<"brightblue"/utf8>>, [<<"94"/utf8>>]},
                    {<<"brightmagenta"/utf8>>, [<<"95"/utf8>>]},
                    {<<"brightcyan"/utf8>>, [<<"96"/utf8>>]},
                    {<<"brightwhite"/utf8>>, [<<"97"/utf8>>]}],
                _pipe@1 = maps:from_list(_pipe),
                gleam@dict:map_values(
                    _pipe@1,
                    fun(_, Code) ->
                        [Code@1] = case Code of
                            [_] -> Code;
                            _assert_fail ->
                                erlang:error(#{gleam_error => let_assert,
                                            message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                            value => _assert_fail,
                                            module => <<"shellout"/utf8>>,
                                            function => <<"do_style"/utf8>>,
                                            line => 235})
                        end,
                        _assert_subject = gleam_stdlib:parse_int(Code@1),
                        {ok, Code@2} = case _assert_subject of
                            {ok, _} -> _assert_subject;
                            _assert_fail@1 ->
                                erlang:error(#{gleam_error => let_assert,
                                            message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                            value => _assert_fail@1,
                                            module => <<"shellout"/utf8>>,
                                            function => <<"do_style"/utf8>>,
                                            line => 236})
                        end,
                        [erlang:integer_to_binary(Code@2 + 10)]
                    end
                );

            _ ->
                erlang:error(#{gleam_error => panic,
                        message => <<"invalid lookup flag"/utf8>>,
                        module => <<"shellout"/utf8>>,
                        function => <<"do_style"/utf8>>,
                        line => 239})
        end,
        maps:merge(_pipe@2, maps:from_list(Lookup))
    end,
    Acc = {style_acc, [], 0},
    Acc@2 = begin
        _pipe@3 = Strings,
        gleam@list:fold(
            _pipe@3,
            Acc,
            fun(Acc@1, Item) -> case gleam_stdlib:parse_int(Item) of
                    {ok, Int} ->
                        Item@1 = begin
                            _pipe@4 = Int,
                            _pipe@5 = gleam@int:clamp(_pipe@4, 0, 255),
                            erlang:integer_to_binary(_pipe@5)
                        end,
                        Rgb_counter = erlang:element(3, Acc@1),
                        case Rgb_counter < 3 of
                            true when Rgb_counter > 0 ->
                                _assert_subject@1 = erlang:element(2, Acc@1),
                                [{rgb, Values} | Styles] = case _assert_subject@1 of
                                    [{rgb, _} | _] -> _assert_subject@1;
                                    _assert_fail@2 ->
                                        erlang:error(
                                                #{gleam_error => let_assert,
                                                    message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                                    value => _assert_fail@2,
                                                    module => <<"shellout"/utf8>>,
                                                    function => <<"do_style"/utf8>>,
                                                    line => 256}
                                            )
                                end,
                                {style_acc,
                                    [{rgb, [Item@1 | Values]} | Styles],
                                    Rgb_counter + 1};

                            _ ->
                                {style_acc,
                                    [{rgb, [Item@1]} | erlang:element(2, Acc@1)],
                                    1}
                        end;

                    _ ->
                        {style_acc,
                            [{name, Item} | erlang:element(2, Acc@1)],
                            0}
                end end
        )
    end,
    Prepare_rgb = fun(Strings@1) ->
        New_strings = begin
            _pipe@6 = <<"0"/utf8>>,
            _pipe@7 = gleam@list:repeat(_pipe@6, 3 - erlang:length(Strings@1)),
            lists:append(Strings@1, _pipe@7)
        end,
        Code@3 = case Flag of
            <<"color"/utf8>> ->
                <<"38"/utf8>>;

            _ ->
                <<"48"/utf8>>
        end,
        [Code@3, <<"2"/utf8>> | New_strings]
    end,
    _pipe@8 = erlang:element(2, Acc@2),
    _pipe@9 = lists:reverse(_pipe@8),
    _pipe@15 = gleam@list:filter_map(_pipe@9, fun(Style) -> case Style of
                {name, String} ->
                    _pipe@10 = Lookup@1,
                    _pipe@11 = gleam_stdlib:map_get(_pipe@10, String),
                    gleam@result:map(
                        _pipe@11,
                        fun(Strings@2) -> case erlang:length(Strings@2) > 1 of
                                false ->
                                    Strings@2;

                                true ->
                                    Prepare_rgb(Strings@2)
                            end end
                    );

                {rgb, Strings@3} ->
                    _pipe@12 = Strings@3,
                    _pipe@13 = lists:reverse(_pipe@12),
                    _pipe@14 = Prepare_rgb(_pipe@13),
                    {ok, _pipe@14}
            end end),
    gleam@list:flatten(_pipe@15).

-file("src/shellout.gleam", 188).
?DOC(
    " Applies ANSI styles to a string, resetting styling at the end.\n"
    "\n"
    " If a style label isn't found within a [`Lookup`](#Lookup) associated with\n"
    " the corresponding [`StyleFlags`](#StyleFlags) key's category, that label is\n"
    " silently ignored.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " import gleam/dict\n"
    " pub const lookups: Lookups = [\n"
    "   #(\n"
    "     [\"color\", \"background\"],\n"
    "     [\n"
    "       #(\"buttercup\", [\"252\", \"226\", \"174\"]),\n"
    "       #(\"mint\", [\"182\", \"255\", \"234\"]),\n"
    "       #(\"pink\", [\"255\", \"175\", \"243\"]),\n"
    "     ],\n"
    "   ),\n"
    " ]\n"
    " style(\n"
    "   \"cowabunga\",\n"
    "   with: display([\"bold\", \"italic\", \"awesome\"])\n"
    "   |> dict.merge(color([\"pink\", \"righteous\"]))\n"
    "   |> dict.merge(background([\"brightblack\", \"excellent\"])),\n"
    "   custom: lookups,\n"
    " )\n"
    " // -> \"\\u{1b}[1;3;38;2;255;175;243;100mcowabunga\\u{1b}[0m\\u{1b}[K\"\n"
    " ```\n"
).
-spec style(
    binary(),
    gleam@dict:dict(binary(), list(binary())),
    list({list(binary()), list({binary(), list(binary())})})
) -> binary().
style(String, Flags, Lookups) ->
    _pipe = [<<"display"/utf8>>, <<"color"/utf8>>, <<"background"/utf8>>],
    _pipe@7 = gleam@list:map(
        _pipe,
        fun(Flag) ->
            gleam@result:'try'(
                gleam_stdlib:map_get(Flags, Flag),
                fun(Strings) -> _pipe@1 = Lookups,
                    _pipe@4 = gleam@list:filter_map(
                        _pipe@1,
                        fun(Item) ->
                            {Keys, Lookup} = Item,
                            _pipe@2 = Keys,
                            _pipe@3 = gleam@list:find(
                                _pipe@2,
                                fun(Key) -> Key =:= Flag end
                            ),
                            gleam@result:map(_pipe@3, fun(_) -> Lookup end)
                        end
                    ),
                    _pipe@5 = gleam@list:flatten(_pipe@4),
                    _pipe@6 = do_style(_pipe@5, Strings, Flag),
                    {ok, _pipe@6} end
            )
        end
    ),
    _pipe@8 = gleam@result:values(_pipe@7),
    _pipe@9 = gleam@list:flatten(_pipe@8),
    _pipe@10 = gleam@string:join(_pipe@9, <<";"/utf8>>),
    escape(_pipe@10, String).
