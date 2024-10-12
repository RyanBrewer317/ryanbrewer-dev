-module(simplifile).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([describe_error/1, file_info_permissions_octal/1, file_info_type/1, file_info/1, link_info/1, delete/1, delete_all/1, read_bits/1, read/1, write_bits/2, write/2, append_bits/2, append/2, is_directory/1, create_directory/1, create_symlink/2, read_directory/1, is_file/1, is_symlink/1, create_file/1, create_directory_all/1, copy_file/2, rename_file/2, rename/2, copy_directory/2, copy/2, rename_directory/2, clear_directory/1, get_files/1, file_permissions_to_octal/1, file_info_permissions/1, set_permissions_octal/2, set_permissions/2, current_directory/0]).
-export_type([file_error/0, file_info/0, file_type/0, permission/0, file_permissions/0]).

-type file_error() :: eacces |
    eagain |
    ebadf |
    ebadmsg |
    ebusy |
    edeadlk |
    edeadlock |
    edquot |
    eexist |
    efault |
    efbig |
    eftype |
    eintr |
    einval |
    eio |
    eisdir |
    eloop |
    emfile |
    emlink |
    emultihop |
    enametoolong |
    enfile |
    enobufs |
    enodev |
    enolck |
    enolink |
    enoent |
    enomem |
    enospc |
    enosr |
    enostr |
    enosys |
    enotblk |
    enotdir |
    enotsup |
    enxio |
    eopnotsupp |
    eoverflow |
    eperm |
    epipe |
    erange |
    erofs |
    espipe |
    esrch |
    estale |
    etxtbsy |
    exdev |
    not_utf8 |
    {unknown, binary()}.

-type file_info() :: {file_info,
        integer(),
        integer(),
        integer(),
        integer(),
        integer(),
        integer(),
        integer(),
        integer(),
        integer(),
        integer()}.

-type file_type() :: file | directory | symlink | other.

-type permission() :: read | write | execute.

-type file_permissions() :: {file_permissions,
        gleam@set:set(permission()),
        gleam@set:set(permission()),
        gleam@set:set(permission())}.

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 124).
-spec describe_error(file_error()) -> binary().
describe_error(Error) ->
    case Error of
        eperm ->
            <<"Operation not permitted"/utf8>>;

        enoent ->
            <<"No such file or directory"/utf8>>;

        esrch ->
            <<"No such process"/utf8>>;

        eintr ->
            <<"Interrupted system call"/utf8>>;

        eio ->
            <<"Input/output error"/utf8>>;

        enxio ->
            <<"Device not configured"/utf8>>;

        ebadf ->
            <<"Bad file descriptor"/utf8>>;

        edeadlk ->
            <<"Resource deadlock avoided"/utf8>>;

        edeadlock ->
            <<"Resource deadlock avoided"/utf8>>;

        enomem ->
            <<"Cannot allocate memory"/utf8>>;

        eacces ->
            <<"Permission denied"/utf8>>;

        efault ->
            <<"Bad address"/utf8>>;

        enotblk ->
            <<"Block device required"/utf8>>;

        ebusy ->
            <<"Resource busy"/utf8>>;

        eexist ->
            <<"File exists"/utf8>>;

        exdev ->
            <<"Cross-device link"/utf8>>;

        enodev ->
            <<"Operation not supported by device"/utf8>>;

        enotdir ->
            <<"Not a directory"/utf8>>;

        eisdir ->
            <<"Is a directory"/utf8>>;

        einval ->
            <<"Invalid argument"/utf8>>;

        enfile ->
            <<"Too many open files in system"/utf8>>;

        emfile ->
            <<"Too many open files"/utf8>>;

        etxtbsy ->
            <<"Text file busy"/utf8>>;

        efbig ->
            <<"File too large"/utf8>>;

        enospc ->
            <<"No space left on device"/utf8>>;

        espipe ->
            <<"Illegal seek"/utf8>>;

        erofs ->
            <<"Read-only file system"/utf8>>;

        emlink ->
            <<"Too many links"/utf8>>;

        epipe ->
            <<"Broken pipe"/utf8>>;

        erange ->
            <<"Result too large"/utf8>>;

        eagain ->
            <<"Resource temporarily unavailable"/utf8>>;

        enotsup ->
            <<"Operation not supported"/utf8>>;

        enobufs ->
            <<"No buffer space available"/utf8>>;

        eloop ->
            <<"Too many levels of symbolic links"/utf8>>;

        enametoolong ->
            <<"File name too long"/utf8>>;

        edquot ->
            <<"Disc quota exceeded"/utf8>>;

        estale ->
            <<"Stale NFS file handle"/utf8>>;

        enolck ->
            <<"No locks available"/utf8>>;

        enosys ->
            <<"Function not implemented"/utf8>>;

        eftype ->
            <<"Inappropriate file type or format"/utf8>>;

        eoverflow ->
            <<"Value too large to be stored in data type"/utf8>>;

        ebadmsg ->
            <<"Bad message"/utf8>>;

        emultihop ->
            <<"Multihop attempted"/utf8>>;

        enolink ->
            <<"Link has been severed"/utf8>>;

        enosr ->
            <<"No STREAM resources"/utf8>>;

        enostr ->
            <<"Not a STREAM"/utf8>>;

        eopnotsupp ->
            <<"Operation not supported on socket"/utf8>>;

        not_utf8 ->
            <<"File not UTF-8 encoded"/utf8>>;

        {unknown, Inner} ->
            <<"Unknown error: "/utf8, Inner/binary>>
    end.

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 221).
-spec file_info_permissions_octal(file_info()) -> integer().
file_info_permissions_octal(File_info) ->
    erlang:'band'(erlang:element(3, File_info), 8#777).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 250).
-spec file_info_type(file_info()) -> file_type().
file_info_type(File_info) ->
    case erlang:'band'(erlang:element(3, File_info), 8#170000) of
        8#100000 ->
            file;

        8#40000 ->
            directory;

        8#120000 ->
            symlink;

        _ ->
            other
    end.

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 270).
-spec file_info(binary()) -> {ok, file_info()} | {error, file_error()}.
file_info(Filepath) ->
    simplifile_erl:file_info(Filepath).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 280).
-spec link_info(binary()) -> {ok, file_info()} | {error, file_error()}.
link_info(Filepath) ->
    simplifile_erl:link_info(Filepath).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 324).
-spec delete(binary()) -> {ok, nil} | {error, file_error()}.
delete(Path) ->
    simplifile_erl:delete(Path).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 331).
-spec delete_all(list(binary())) -> {ok, nil} | {error, file_error()}.
delete_all(Paths) ->
    case Paths of
        [] ->
            {ok, nil};

        [Path | Rest] ->
            case simplifile_erl:delete(Path) of
                {ok, nil} ->
                    delete_all(Rest);

                {error, enoent} ->
                    delete_all(Rest);

                E ->
                    E
            end
    end.

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 365).
-spec read_bits(binary()) -> {ok, bitstring()} | {error, file_error()}.
read_bits(Filepath) ->
    simplifile_erl:read_bits(Filepath).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 288).
-spec read(binary()) -> {ok, binary()} | {error, file_error()}.
read(Filepath) ->
    case simplifile_erl:read_bits(Filepath) of
        {ok, Bits} ->
            case gleam@bit_array:to_string(Bits) of
                {ok, Str} ->
                    {ok, Str};

                _ ->
                    {error, not_utf8}
            end;

        {error, E} ->
            {error, E}
    end.

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 375).
-spec write_bits(binary(), bitstring()) -> {ok, nil} | {error, file_error()}.
write_bits(Filepath, Bits) ->
    simplifile_erl:write_bits(Filepath, Bits).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 306).
-spec write(binary(), binary()) -> {ok, nil} | {error, file_error()}.
write(Filepath, Contents) ->
    _pipe = Contents,
    _pipe@1 = gleam_stdlib:identity(_pipe),
    simplifile_erl:write_bits(Filepath, _pipe@1).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 388).
-spec append_bits(binary(), bitstring()) -> {ok, nil} | {error, file_error()}.
append_bits(Filepath, Bits) ->
    simplifile_erl:append_bits(Filepath, Bits).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 349).
-spec append(binary(), binary()) -> {ok, nil} | {error, file_error()}.
append(Filepath, Contents) ->
    _pipe = Contents,
    _pipe@1 = gleam_stdlib:identity(_pipe),
    simplifile_erl:append_bits(Filepath, _pipe@1).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 402).
-spec is_directory(binary()) -> {ok, boolean()} | {error, file_error()}.
is_directory(Filepath) ->
    simplifile_erl:is_directory(Filepath).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 413).
-spec create_directory(binary()) -> {ok, nil} | {error, file_error()}.
create_directory(Filepath) ->
    simplifile_erl:create_directory(Filepath).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 428).
-spec create_symlink(binary(), binary()) -> {ok, nil} | {error, file_error()}.
create_symlink(Target, Symlink) ->
    simplifile_erl:create_symlink(Target, Symlink).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 443).
-spec read_directory(binary()) -> {ok, list(binary())} | {error, file_error()}.
read_directory(Path) ->
    simplifile_erl:read_directory(Path).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 455).
-spec is_file(binary()) -> {ok, boolean()} | {error, file_error()}.
is_file(Filepath) ->
    simplifile_erl:is_file(Filepath).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 467).
-spec is_symlink(binary()) -> {ok, boolean()} | {error, file_error()}.
is_symlink(Filepath) ->
    simplifile_erl:is_symlink(Filepath).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 472).
-spec create_file(binary()) -> {ok, nil} | {error, file_error()}.
create_file(Filepath) ->
    case {begin
            _pipe = Filepath,
            simplifile_erl:is_file(_pipe)
        end,
        begin
            _pipe@1 = Filepath,
            simplifile_erl:is_directory(_pipe@1)
        end} of
        {{ok, true}, _} ->
            {error, eexist};

        {_, {ok, true}} ->
            {error, eexist};

        {_, _} ->
            simplifile_erl:write_bits(Filepath, <<>>)
    end.

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 483).
-spec create_directory_all(binary()) -> {ok, nil} | {error, file_error()}.
create_directory_all(Dirpath) ->
    Is_abs = filepath:is_absolute(Dirpath),
    Path = begin
        _pipe = Dirpath,
        _pipe@1 = filepath:split(_pipe),
        gleam@list:fold(_pipe@1, <<""/utf8>>, fun filepath:join/2)
    end,
    Path@1 = case Is_abs of
        true ->
            <<"/"/utf8, Path/binary>>;

        false ->
            Path
    end,
    simplifile_erl:create_dir_all(<<Path@1/binary, "/"/utf8>>).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 522).
-spec copy_file(binary(), binary()) -> {ok, nil} | {error, file_error()}.
copy_file(Src, Dest) ->
    _pipe = file:copy(Src, Dest),
    gleam@result:replace(_pipe, nil).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 536).
-spec rename_file(binary(), binary()) -> {ok, nil} | {error, file_error()}.
rename_file(Src, Dest) ->
    simplifile_erl:rename_file(Src, Dest).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 541).
-spec rename(binary(), binary()) -> {ok, nil} | {error, file_error()}.
rename(Src, Dest) ->
    simplifile_erl:rename_file(Src, Dest).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 552).
-spec do_copy_directory(binary(), binary()) -> {ok, nil} | {error, file_error()}.
do_copy_directory(Src, Dest) ->
    gleam@result:'try'(
        simplifile_erl:read_directory(Src),
        fun(Segments) ->
            _pipe = Segments,
            gleam@list:each(
                _pipe,
                fun(Segment) ->
                    Src_path = filepath:join(Src, Segment),
                    Dest_path = filepath:join(Dest, Segment),
                    gleam@result:'try'(
                        simplifile_erl:file_info(Src_path),
                        fun(Src_info) -> case file_info_type(Src_info) of
                                file ->
                                    gleam@result:'try'(
                                        simplifile_erl:read_bits(Src_path),
                                        fun(Content) -> _pipe@1 = Content,
                                            simplifile_erl:write_bits(
                                                Dest_path,
                                                _pipe@1
                                            ) end
                                    );

                                directory ->
                                    gleam@result:'try'(
                                        simplifile_erl:create_directory(
                                            Dest_path
                                        ),
                                        fun(_) ->
                                            do_copy_directory(
                                                Src_path,
                                                Dest_path
                                            )
                                        end
                                    );

                                symlink ->
                                    {error,
                                        {unknown,
                                            <<"This is an internal bug where the `file_info` is somehow returning info about a simlink. Please file an issue on the simplifile repo."/utf8>>}};

                                other ->
                                    {error,
                                        {unknown,
                                            <<"Unknown file type (not file, directory, or simlink)"/utf8>>}}
                            end end
                    )
                end
            ),
            {ok, nil}
        end
    ).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 544).
-spec copy_directory(binary(), binary()) -> {ok, nil} | {error, file_error()}.
copy_directory(Src, Dest) ->
    gleam@result:'try'(
        create_directory_all(Dest),
        fun(_) -> do_copy_directory(Src, Dest) end
    ).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 506).
-spec copy(binary(), binary()) -> {ok, nil} | {error, file_error()}.
copy(Src, Dest) ->
    gleam@result:'try'(
        simplifile_erl:file_info(Src),
        fun(Src_info) -> case file_info_type(Src_info) of
                file ->
                    copy_file(Src, Dest);

                directory ->
                    copy_directory(Src, Dest);

                symlink ->
                    {error,
                        {unknown,
                            <<"This is an internal bug where the `file_info` is somehow returning info about a simlink. Please file an issue on the simplifile repo."/utf8>>}};

                other ->
                    {error,
                        {unknown,
                            <<"Unknown file type (not file, directory, or simlink)"/utf8>>}}
            end end
    ).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 588).
-spec rename_directory(binary(), binary()) -> {ok, nil} | {error, file_error()}.
rename_directory(Src, Dest) ->
    gleam@result:'try'(
        copy_directory(Src, Dest),
        fun(_) -> simplifile_erl:delete(Src) end
    ).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 598).
-spec clear_directory(binary()) -> {ok, nil} | {error, file_error()}.
clear_directory(Path) ->
    gleam@result:'try'(
        simplifile_erl:read_directory(Path),
        fun(Paths) -> _pipe = Paths,
            _pipe@1 = gleam@list:map(
                _pipe,
                fun(_capture) -> filepath:join(Path, _capture) end
            ),
            delete_all(_pipe@1) end
    ).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 608).
-spec get_files(binary()) -> {ok, list(binary())} | {error, file_error()}.
get_files(Directory) ->
    gleam@result:'try'(
        simplifile_erl:read_directory(Directory),
        fun(Contents) ->
            gleam@list:try_fold(
                Contents,
                [],
                fun(Acc, Content) ->
                    Path = filepath:join(Directory, Content),
                    gleam@result:'try'(
                        simplifile_erl:file_info(Path),
                        fun(Info) -> case file_info_type(Info) of
                                file ->
                                    {ok, [Path | Acc]};

                                directory ->
                                    gleam@result:'try'(
                                        get_files(Path),
                                        fun(Nested_files) ->
                                            {ok,
                                                gleam@list:append(
                                                    Acc,
                                                    Nested_files
                                                )}
                                        end
                                    );

                                _ ->
                                    {ok, Acc}
                            end end
                    )
                end
            )
        end
    ).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 631).
-spec permission_to_integer(permission()) -> integer().
permission_to_integer(Permission) ->
    case Permission of
        read ->
            8#4;

        write ->
            8#2;

        execute ->
            8#1
    end.

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 639).
-spec integer_to_permissions(integer()) -> gleam@set:set(permission()).
integer_to_permissions(Integer) ->
    case erlang:'band'(Integer, 7) of
        7 ->
            gleam@set:from_list([read, write, execute]);

        6 ->
            gleam@set:from_list([read, write]);

        5 ->
            gleam@set:from_list([read, execute]);

        3 ->
            gleam@set:from_list([write, execute]);

        4 ->
            gleam@set:from_list([read]);

        2 ->
            gleam@set:from_list([write]);

        1 ->
            gleam@set:from_list([execute]);

        0 ->
            gleam@set:new();

        _ ->
            erlang:error(#{gleam_error => panic,
                    message => <<"`panic` expression evaluated."/utf8>>,
                    module => <<"simplifile"/utf8>>,
                    function => <<"integer_to_permissions"/utf8>>,
                    line => 650})
    end.

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 663).
-spec file_permissions_to_octal(file_permissions()) -> integer().
file_permissions_to_octal(Permissions) ->
    Make_permission_digit = fun(Permissions@1) -> _pipe = Permissions@1,
        _pipe@1 = gleam@set:to_list(_pipe),
        _pipe@2 = gleam@list:map(_pipe@1, fun permission_to_integer/1),
        gleam@int:sum(_pipe@2) end,
    ((Make_permission_digit(erlang:element(2, Permissions)) * 64) + (Make_permission_digit(
        erlang:element(3, Permissions)
    )
    * 8))
    + Make_permission_digit(erlang:element(4, Permissions)).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 678).
-spec octal_to_file_permissions(integer()) -> file_permissions().
octal_to_file_permissions(Octal) ->
    {file_permissions,
        begin
            _pipe = Octal,
            _pipe@1 = erlang:'bsr'(_pipe, 6),
            integer_to_permissions(_pipe@1)
        end,
        begin
            _pipe@2 = Octal,
            _pipe@3 = erlang:'bsr'(_pipe@2, 3),
            integer_to_permissions(_pipe@3)
        end,
        begin
            _pipe@4 = Octal,
            integer_to_permissions(_pipe@4)
        end}.

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 226).
-spec file_info_permissions(file_info()) -> file_permissions().
file_info_permissions(File_info) ->
    octal_to_file_permissions(file_info_permissions_octal(File_info)).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 714).
-spec set_permissions_octal(binary(), integer()) -> {ok, nil} |
    {error, file_error()}.
set_permissions_octal(Filepath, Permissions) ->
    simplifile_erl:set_permissions_octal(Filepath, Permissions).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 699).
-spec set_permissions(binary(), file_permissions()) -> {ok, nil} |
    {error, file_error()}.
set_permissions(Filepath, Permissions) ->
    simplifile_erl:set_permissions_octal(
        Filepath,
        file_permissions_to_octal(Permissions)
    ).

-file("/home/benjaminpeinhardt/Desktop/simplifile/src/simplifile.gleam", 722).
-spec current_directory() -> {ok, binary()} | {error, file_error()}.
current_directory() ->
    _pipe = file:get_cwd(),
    gleam@result:map(_pipe, fun gleam_stdlib:utf_codepoint_list_to_string/1).
