-module(lustre_dev_tools@tailwind).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).
-define(FILEPATH, "src/lustre_dev_tools/tailwind.gleam").
-export([setup/2]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-file("src/lustre_dev_tools/tailwind.gleam", 62).
?DOC(false).
-spec detect_legacy_config() -> lustre_dev_tools@cli:cli(boolean()).
detect_legacy_config() ->
    Root = lustre_dev_tools@project:root(),
    lustre_dev_tools@cli:'try'(
        lustre_dev_tools@project:config(),
        fun(Config) ->
            Old_config_path = filepath:join(Root, <<"tailwind.config.js"/utf8>>),
            case simplifile_erl:is_file(Old_config_path) of
                {ok, true} ->
                    lustre_dev_tools@cli:notify(
                        gleam_community@ansi:bold(
                            <<"\nLegacy Tailwind config detected:"/utf8>>
                        ),
                        fun() ->
                            lustre_dev_tools@cli:notify(
                                begin
                                    _pipe = <<"
Lustre Dev Tools now only supports Tailwind CSS v4.0 and above. If you are not
ready to migrate your config to the new format, you can continue using JavaScript
config by including the `@config` directive in your `src/{app_name}.css` file.

See: https://tailwindcss.com/docs/upgrade-guide#using-a-javascript-config-file

You can supress this message by removing `tailwind.config.js` from your project.
"/utf8>>,
                                    _pipe@1 = gleam@string:trim(_pipe),
                                    gleam@string:replace(
                                        _pipe@1,
                                        <<"{app_name}"/utf8>>,
                                        erlang:element(2, Config)
                                    )
                                end,
                                fun() -> lustre_dev_tools@cli:return(true) end
                            )
                        end
                    );

                {ok, false} ->
                    lustre_dev_tools@cli:return(false);

                {error, _} ->
                    lustre_dev_tools@cli:return(false)
            end
        end
    ).

-file("src/lustre_dev_tools/tailwind.gleam", 127).
?DOC(false).
-spec display_next_steps() -> lustre_dev_tools@cli:cli(nil).
display_next_steps() ->
    lustre_dev_tools@cli:'try'(
        lustre_dev_tools@project:config(),
        fun(Config) ->
            lustre_dev_tools@cli:notify(
                gleam_community@ansi:bold(<<"\nNext Steps:"/utf8>>),
                fun() ->
                    lustre_dev_tools@cli:notify(
                        begin
                            _pipe = <<"
1. Be sure to update your root `index.html` file to include
   <link rel=\"stylesheet\" type=\"text/css\" href=\"./priv/static/{app_name}.css\" />"/utf8>>,
                            _pipe@1 = gleam@string:trim(_pipe),
                            gleam@string:replace(
                                _pipe@1,
                                <<"{app_name}"/utf8>>,
                                erlang:element(2, Config)
                            )
                        end,
                        fun() -> lustre_dev_tools@cli:return(nil) end
                    )
                end
            )
        end
    ).

-file("src/lustre_dev_tools/tailwind.gleam", 90).
?DOC(false).
-spec generate_config() -> lustre_dev_tools@cli:cli(nil).
generate_config() ->
    Root = lustre_dev_tools@project:root(),
    lustre_dev_tools@cli:'try'(
        lustre_dev_tools@project:config(),
        fun(Config) ->
            Entry_css_path = filepath:join(
                Root,
                <<<<"src/"/utf8, (erlang:element(2, Config))/binary>>/binary,
                    ".css"/utf8>>
            ),
            case simplifile:read(Entry_css_path) of
                {ok, Entry_css} ->
                    case gleam_stdlib:contains_string(
                        Entry_css,
                        <<"@import \"tailwindcss"/utf8>>
                    ) of
                        true ->
                            lustre_dev_tools@cli:return(nil);

                        false ->
                            Entry_css@1 = <<"@import \"tailwindcss\"\n"/utf8,
                                Entry_css/binary>>,
                            lustre_dev_tools@cli:log(
                                <<"Adding Tailwind integration to "/utf8,
                                    Entry_css_path/binary>>,
                                fun() ->
                                    lustre_dev_tools@cli:'try'(
                                        begin
                                            _pipe = simplifile:write(
                                                Entry_css_path,
                                                Entry_css@1
                                            ),
                                            gleam@result:map_error(
                                                _pipe,
                                                fun(_capture) ->
                                                    {cannot_write_file,
                                                        _capture,
                                                        Entry_css_path}
                                                end
                                            )
                                        end,
                                        fun(_) ->
                                            lustre_dev_tools@cli:success(
                                                <<Entry_css_path/binary,
                                                    " updated!"/utf8>>,
                                                fun() ->
                                                    lustre_dev_tools@cli:return(
                                                        nil
                                                    )
                                                end
                                            )
                                        end
                                    )
                                end
                            )
                    end;

                {error, _} ->
                    lustre_dev_tools@cli:log(
                        <<"Generating Tailwind config"/utf8>>,
                        fun() ->
                            lustre_dev_tools@cli:'try'(
                                begin
                                    _pipe@1 = simplifile:write(
                                        Entry_css_path,
                                        <<"@import \"tailwindcss\"\n"/utf8>>
                                    ),
                                    gleam@result:map_error(
                                        _pipe@1,
                                        fun(_capture@1) ->
                                            {cannot_write_file,
                                                _capture@1,
                                                Entry_css_path}
                                        end
                                    )
                                end,
                                fun(_) ->
                                    lustre_dev_tools@cli:success(
                                        <<"Tailwind succeessfully configured!"/utf8>>,
                                        fun() ->
                                            lustre_dev_tools@cli:do(
                                                display_next_steps(),
                                                fun(_) ->
                                                    lustre_dev_tools@cli:return(
                                                        nil
                                                    )
                                                end
                                            )
                                        end
                                    )
                                end
                            )
                        end
                    )
            end
        end
    ).

-file("src/lustre_dev_tools/tailwind.gleam", 167).
?DOC(false).
-spec get_download_url_and_hash(binary(), binary()) -> {ok,
        {binary(), binary()}} |
    {error, lustre_dev_tools@error:error()}.
get_download_url_and_hash(Os, Cpu) ->
    Base = <<"https://github.com/tailwindlabs/tailwindcss/releases/download/v4.1.10/tailwindcss-"/utf8>>,
    case {Os, Cpu} of
        {<<"linux"/utf8>>, <<"arm64"/utf8>>} ->
            {ok,
                {<<Base/binary, "linux-arm64"/utf8>>,
                    <<"67EB620BB404C2046D3C127DBF2D7F9921595065475E7D2D528E39C1BB33C9B6"/utf8>>}};

        {<<"linux"/utf8>>, <<"aarch64"/utf8>>} ->
            {ok,
                {<<Base/binary, "linux-arm64"/utf8>>,
                    <<"67EB620BB404C2046D3C127DBF2D7F9921595065475E7D2D528E39C1BB33C9B6"/utf8>>}};

        {<<"linux"/utf8>>, <<"x64"/utf8>>} ->
            {ok,
                {<<Base/binary, "linux-x64"/utf8>>,
                    <<"0A85A3E533F2E7983BDB91C08EA44F0EAB3BECC275E60B3BAADDF18F71D390BF"/utf8>>}};

        {<<"linux"/utf8>>, <<"x86_64"/utf8>>} ->
            {ok,
                {<<Base/binary, "linux-x64"/utf8>>,
                    <<"0A85A3E533F2E7983BDB91C08EA44F0EAB3BECC275E60B3BAADDF18F71D390BF"/utf8>>}};

        {<<"win32"/utf8>>, <<"x64"/utf8>>} ->
            {ok,
                {<<Base/binary, "windows-x64.exe"/utf8>>,
                    <<"5539346428771D8974AC63B68D1F477866BECECF615B3A14F2F197A36BDAAC33"/utf8>>}};

        {<<"win32"/utf8>>, <<"x86_64"/utf8>>} ->
            {ok,
                {<<Base/binary, "windows-x64.exe"/utf8>>,
                    <<"5539346428771D8974AC63B68D1F477866BECECF615B3A14F2F197A36BDAAC33"/utf8>>}};

        {<<"darwin"/utf8>>, <<"arm64"/utf8>>} ->
            {ok,
                {<<Base/binary, "macos-arm64"/utf8>>,
                    <<"F34A85A75B1F2DE2C7E4A9FBC4FB976E64A2780980E843DF87D9C13F555F4A4C"/utf8>>}};

        {<<"darwin"/utf8>>, <<"aarch64"/utf8>>} ->
            {ok,
                {<<Base/binary, "macos-arm64"/utf8>>,
                    <<"F34A85A75B1F2DE2C7E4A9FBC4FB976E64A2780980E843DF87D9C13F555F4A4C"/utf8>>}};

        {<<"darwin"/utf8>>, <<"x64"/utf8>>} ->
            {ok,
                {<<Base/binary, "macos-x64"/utf8>>,
                    <<"47A130C5F639384456E0AC8A0D60B95D74906187314A4DBC37E7C1DDBEB713AE"/utf8>>}};

        {<<"darwin"/utf8>>, <<"x86_64"/utf8>>} ->
            {ok,
                {<<Base/binary, "macos-x64"/utf8>>,
                    <<"47A130C5F639384456E0AC8A0D60B95D74906187314A4DBC37E7C1DDBEB713AE"/utf8>>}};

        {_, _} ->
            {error, {unknown_platform, <<"tailwind"/utf8>>, Os, Cpu}}
    end.

-file("src/lustre_dev_tools/tailwind.gleam", 209).
?DOC(false).
-spec check_tailwind_integrity(bitstring(), binary()) -> {ok, nil} |
    {error, lustre_dev_tools@error:error()}.
check_tailwind_integrity(Bin, Expected_hash) ->
    Hash = gleam@crypto:hash(sha256, Bin),
    Hash_string = gleam_stdlib:base16_encode(Hash),
    case Hash_string =:= Expected_hash of
        true ->
            {ok, nil};

        false ->
            {error, invalid_tailwind_binary}
    end.

-file("src/lustre_dev_tools/tailwind.gleam", 143).
?DOC(false).
-spec check_tailwind_exists(binary(), binary(), binary()) -> boolean().
check_tailwind_exists(Path, Os, Cpu) ->
    case simplifile_erl:is_file(Path) of
        {ok, true} ->
            gleam@result:unwrap(
                begin
                    gleam@result:'try'(
                        get_download_url_and_hash(Os, Cpu),
                        fun(_use0) ->
                            {_, Hash} = _use0,
                            gleam@result:'try'(
                                begin
                                    _pipe = simplifile_erl:read_bits(Path),
                                    gleam@result:replace_error(
                                        _pipe,
                                        invalid_tailwind_binary
                                    )
                                end,
                                fun(Bin) ->
                                    gleam@result:'try'(
                                        check_tailwind_integrity(Bin, Hash),
                                        fun(_) -> {ok, true} end
                                    )
                                end
                            )
                        end
                    )
                end,
                false
            );

        {ok, false} ->
            false;

        {error, _} ->
            false
    end.

-file("src/lustre_dev_tools/tailwind.gleam", 218).
?DOC(false).
-spec write_tailwind(bitstring(), binary(), binary()) -> {ok, nil} |
    {error, lustre_dev_tools@error:error()}.
write_tailwind(Bin, Outdir, Outfile) ->
    _ = simplifile:create_directory_all(Outdir),
    _pipe = simplifile_erl:write_bits(Outfile, Bin),
    gleam@result:map_error(
        _pipe,
        fun(_capture) ->
            {cannot_write_file, _capture, filepath:join(Outdir, Outfile)}
        end
    ).

-file("src/lustre_dev_tools/tailwind.gleam", 229).
?DOC(false).
-spec set_file_permissions(binary()) -> {ok, nil} |
    {error, lustre_dev_tools@error:error()}.
set_file_permissions(File) ->
    Permissions = {file_permissions,
        gleam@set:from_list([read, write, execute]),
        gleam@set:from_list([read, execute]),
        gleam@set:from_list([read, execute])},
    _pipe = simplifile:set_permissions(File, Permissions),
    gleam@result:map_error(
        _pipe,
        fun(_capture) -> {cannot_set_permissions, _capture, File} end
    ).

-file("src/lustre_dev_tools/tailwind.gleam", 204).
?DOC(false).
-spec get_tailwind(binary()) -> {ok, bitstring()} |
    {error, lustre_dev_tools@error:error()}.
get_tailwind(Url) ->
    _pipe = lustre_dev_tools_ffi:get_esbuild(Url),
    gleam@result:map_error(_pipe, fun(Field@0) -> {network_error, Field@0} end).

-file("src/lustre_dev_tools/tailwind.gleam", 30).
?DOC(false).
-spec download(binary(), binary()) -> lustre_dev_tools@cli:cli(nil).
download(Os, Cpu) ->
    lustre_dev_tools@cli:log(
        <<"Downloading Tailwind"/utf8>>,
        fun() ->
            Root = lustre_dev_tools@project:root(),
            Outdir = filepath:join(Root, <<"build/.lustre/bin"/utf8>>),
            Outfile = filepath:join(Outdir, <<"tailwind"/utf8>>),
            case check_tailwind_exists(Outfile, Os, Cpu) of
                true ->
                    lustre_dev_tools@cli:success(
                        <<"Tailwind already installed!"/utf8>>,
                        fun() -> lustre_dev_tools@cli:return(nil) end
                    );

                false ->
                    lustre_dev_tools@cli:log(
                        <<"Detecting platform"/utf8>>,
                        fun() ->
                            lustre_dev_tools@cli:'try'(
                                get_download_url_and_hash(Os, Cpu),
                                fun(_use0) ->
                                    {Url, Hash} = _use0,
                                    Max_url_size = lustre_dev_tools@utils:term_width(
                                        
                                    )
                                    - 19,
                                    Shortened_url = lustre_dev_tools@utils:shorten_url(
                                        Url,
                                        Max_url_size
                                    ),
                                    lustre_dev_tools@cli:log(
                                        <<"Downloading from "/utf8,
                                            Shortened_url/binary>>,
                                        fun() ->
                                            lustre_dev_tools@cli:'try'(
                                                get_tailwind(Url),
                                                fun(Bin) ->
                                                    lustre_dev_tools@cli:log(
                                                        <<"Checking the downloaded Tailwind binary"/utf8>>,
                                                        fun() ->
                                                            lustre_dev_tools@cli:'try'(
                                                                check_tailwind_integrity(
                                                                    Bin,
                                                                    Hash
                                                                ),
                                                                fun(_) ->
                                                                    lustre_dev_tools@cli:'try'(
                                                                        write_tailwind(
                                                                            Bin,
                                                                            Outdir,
                                                                            Outfile
                                                                        ),
                                                                        fun(_) ->
                                                                            lustre_dev_tools@cli:'try'(
                                                                                set_file_permissions(
                                                                                    Outfile
                                                                                ),
                                                                                fun(
                                                                                    _
                                                                                ) ->
                                                                                    lustre_dev_tools@cli:success(
                                                                                        <<"Tailwind installed!"/utf8>>,
                                                                                        fun(
                                                                                            
                                                                                        ) ->
                                                                                            lustre_dev_tools@cli:return(
                                                                                                nil
                                                                                            )
                                                                                        end
                                                                                    )
                                                                                end
                                                                            )
                                                                        end
                                                                    )
                                                                end
                                                            )
                                                        end
                                                    )
                                                end
                                            )
                                        end
                                    )
                                end
                            )
                        end
                    )
            end
        end
    ).

-file("src/lustre_dev_tools/tailwind.gleam", 22).
?DOC(false).
-spec setup(binary(), binary()) -> lustre_dev_tools@cli:cli(nil).
setup(Os, Cpu) ->
    lustre_dev_tools@cli:do(
        download(Os, Cpu),
        fun(_) ->
            lustre_dev_tools@cli:do(
                generate_config(),
                fun(_) ->
                    lustre_dev_tools@cli:do(
                        detect_legacy_config(),
                        fun(_) -> lustre_dev_tools@cli:return(nil) end
                    )
                end
            )
        end
    ).
