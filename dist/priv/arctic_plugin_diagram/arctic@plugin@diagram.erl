-module(arctic@plugin@diagram).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([parse/3]).

-file("src/arctic/plugin/diagram.gleam", 12).
-spec parse(binary(), fun((YWK) -> integer()), fun((integer()) -> YWK)) -> fun((list(binary()), binary(), arctic@parse:parse_data(YWK)) -> {ok,
        {lustre@internals@vdom:element(any()), YWK}} |
    {error, snag:snag()}).
parse(Dir, Get_id, To_state) ->
    fun(_, Body, Data) ->
        Counter = Get_id(arctic@parse:get_state(Data)),
        _assert_subject = gleam_stdlib:map_get(
            arctic@parse:get_metadata(Data),
            <<"id"/utf8>>
        ),
        {ok, Id} = case _assert_subject of
            {ok, _} -> _assert_subject;
            _assert_fail ->
                erlang:error(#{gleam_error => let_assert,
                            message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                            value => _assert_fail,
                            module => <<"arctic/plugin/diagram"/utf8>>,
                            function => <<"parse"/utf8>>,
                            line => 16})
        end,
        Img_filename = <<<<<<<<"image-"/utf8,
                        (erlang:integer_to_binary(Counter))/binary>>/binary,
                    "-"/utf8>>/binary,
                Id/binary>>/binary,
            ".svg"/utf8>>,
        Out = {lustre@element@html:'div'(
                [lustre@attribute:class(<<"diagram"/utf8>>)],
                [lustre@element@html:img(
                        [lustre@attribute:src(<<"/"/utf8, Img_filename/binary>>),
                            lustre@attribute:attribute(
                                <<"onload"/utf8>>,
                                <<"this.width *= 2.25;"/utf8>>
                            )]
                    )]
            ),
            To_state(Counter + 1)},
        gleam@result:'try'(
            begin
                _pipe = simplifile_erl:is_file(
                    <<<<Dir/binary, "/"/utf8>>/binary, Img_filename/binary>>
                ),
                gleam@result:map_error(
                    _pipe,
                    fun(Err) ->
                        snag:new(
                            <<<<<<<<<<<<"couldn't check `"/utf8, Dir/binary>>/binary,
                                                "/"/utf8>>/binary,
                                            Img_filename/binary>>/binary,
                                        "` ("/utf8>>/binary,
                                    (simplifile:describe_error(Err))/binary>>/binary,
                                ")"/utf8>>
                        )
                    end
                )
            end,
            fun(Exists) ->
                gleam@bool:guard(
                    Exists,
                    {ok, Out},
                    fun() ->
                        Latex_code = <<<<"
\\documentclass[margin=0pt]{standalone}
\\usepackage{tikz-cd}
\\begin{document}
\\begin{tikzcd}\n"/utf8,
                                Body/binary>>/binary,
                            "\\end{tikzcd}
\\end{document}"/utf8>>,
                        gleam@result:'try'(
                            begin
                                _pipe@1 = simplifile:write(
                                    <<"./diagram-work/diagram.tex"/utf8>>,
                                    Latex_code
                                ),
                                gleam@result:map_error(
                                    _pipe@1,
                                    fun(Err@1) ->
                                        snag:new(
                                            <<<<"couldn't write to `diagram-work/diagram.tex` ("/utf8,
                                                    (simplifile:describe_error(
                                                        Err@1
                                                    ))/binary>>/binary,
                                                ")"/utf8>>
                                        )
                                    end
                                )
                            end,
                            fun(_) ->
                                gleam@result:'try'(
                                    begin
                                        _pipe@2 = shellout:command(
                                            <<"pdflatex"/utf8>>,
                                            [<<"-interaction"/utf8>>,
                                                <<"nonstopmode"/utf8>>,
                                                <<"diagram.tex"/utf8>>],
                                            <<"diagram-work"/utf8>>,
                                            []
                                        ),
                                        gleam@result:map_error(
                                            _pipe@2,
                                            fun(Err@2) ->
                                                snag:new(
                                                    <<<<<<"couldn't execute `pdflatex -interaction nonstopmode diagram.tex` in `diagram-work` (Code "/utf8,
                                                                (erlang:integer_to_binary(
                                                                    erlang:element(
                                                                        1,
                                                                        Err@2
                                                                    )
                                                                ))/binary>>/binary,
                                                            ": "/utf8>>/binary,
                                                        (erlang:element(
                                                            2,
                                                            Err@2
                                                        ))/binary>>
                                                )
                                            end
                                        )
                                    end,
                                    fun(_) ->
                                        gleam@result:'try'(
                                            begin
                                                _pipe@3 = shellout:command(
                                                    <<"inkscape"/utf8>>,
                                                    [<<"-l"/utf8>>,
                                                        <<"--export-filename"/utf8>>,
                                                        <<<<<<"../"/utf8,
                                                                    Dir/binary>>/binary,
                                                                "/"/utf8>>/binary,
                                                            Img_filename/binary>>,
                                                        <<"diagram.pdf"/utf8>>],
                                                    <<"diagram-work"/utf8>>,
                                                    [let_be_stdout]
                                                ),
                                                gleam@result:map_error(
                                                    _pipe@3,
                                                    fun(Err@3) ->
                                                        snag:new(
                                                            <<<<<<<<<<<<<<<<"couldn't execute `inkscape -l --export-filename ../"/utf8,
                                                                                            Dir/binary>>/binary,
                                                                                        "/"/utf8>>/binary,
                                                                                    Img_filename/binary>>/binary,
                                                                                " diagram.pdf` in `diagram-work` (Code "/utf8>>/binary,
                                                                            (erlang:integer_to_binary(
                                                                                erlang:element(
                                                                                    1,
                                                                                    Err@3
                                                                                )
                                                                            ))/binary>>/binary,
                                                                        ": "/utf8>>/binary,
                                                                    (erlang:element(
                                                                        2,
                                                                        Err@3
                                                                    ))/binary>>/binary,
                                                                ")"/utf8>>
                                                        )
                                                    end
                                                )
                                            end,
                                            fun(_) -> {ok, Out} end
                                        )
                                    end
                                )
                            end
                        )
                    end
                )
            end
        )
    end.
