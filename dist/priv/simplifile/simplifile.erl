-module(simplifile).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([describe_error/1, file_permissions_to_octal/1, file_info/1, read/1, write/2, delete/1, delete_all/1, append/2, read_bits/1, write_bits/2, append_bits/2, verify_is_directory/1, verify_is_file/1, verify_is_symlink/1, create_file/1, set_permissions_octal/2, set_permissions/2, current_directory/0, is_directory/1, create_directory/1, create_symlink/2, read_directory/1, clear_directory/1, get_files/1, is_file/1, create_directory_all/1, copy_directory/2, rename_directory/2, copy_file/2, rename_file/2]).
-export_type([file_error/0, file_info/0, permission/0, file_permissions/0]).

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
    unknown.

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

-type permission() :: read | write | execute.

-type file_permissions() :: {file_permissions,
        gleam@set:set(permission()),
        gleam@set:set(permission()),
        gleam@set:set(permission())}.

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

        unknown ->
            <<"Unknown error"/utf8>>
    end.

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

-spec do_current_directory() -> {ok, binary()} | {error, file_error()}.
do_current_directory() ->
    _pipe = file:get_cwd(),
    gleam@result:map(_pipe, fun gleam_stdlib:utf_codepoint_list_to_string/1).

-spec do_append(binary(), binary()) -> {ok, nil} | {error, file_error()}.
do_append(Content, Filepath) ->
    _pipe = Content,
    _pipe@1 = gleam_stdlib:identity(_pipe),
    simplifile_erl:append_file(_pipe@1, Filepath).

-spec do_write(binary(), binary()) -> {ok, nil} | {error, file_error()}.
do_write(Content, Filepath) ->
    _pipe = Content,
    _pipe@1 = gleam_stdlib:identity(_pipe),
    simplifile_erl:write_file(_pipe@1, Filepath).

-spec do_read(binary()) -> {ok, binary()} | {error, file_error()}.
do_read(Filepath) ->
    case simplifile_erl:read_file(Filepath) of
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

-spec cast_error({ok, FUY} | {error, file_error()}) -> {ok, FUY} |
    {error, file_error()}.
cast_error(Input) ->
    Input.

-spec file_info(binary()) -> {ok, file_info()} | {error, file_error()}.
file_info(A) ->
    _pipe = simplifile_erl:file_info(A),
    cast_error(_pipe).

-spec read(binary()) -> {ok, binary()} | {error, file_error()}.
read(Filepath) ->
    _pipe = do_read(Filepath),
    cast_error(_pipe).

-spec write(binary(), binary()) -> {ok, nil} | {error, file_error()}.
write(Filepath, Contents) ->
    _pipe = do_write(Contents, Filepath),
    cast_error(_pipe).

-spec delete(binary()) -> {ok, nil} | {error, file_error()}.
delete(Path) ->
    _pipe = simplifile_erl:recursive_delete(Path),
    cast_error(_pipe).

-spec delete_all(list(binary())) -> {ok, nil} | {error, file_error()}.
delete_all(Paths) ->
    case Paths of
        [] ->
            {ok, nil};

        [Path | Rest] ->
            case delete(Path) of
                {ok, nil} ->
                    delete_all(Rest);

                {error, enoent} ->
                    delete_all(Rest);

                E ->
                    E
            end
    end.

-spec append(binary(), binary()) -> {ok, nil} | {error, file_error()}.
append(Filepath, Contents) ->
    _pipe = do_append(Contents, Filepath),
    cast_error(_pipe).

-spec read_bits(binary()) -> {ok, bitstring()} | {error, file_error()}.
read_bits(Filepath) ->
    _pipe = simplifile_erl:read_file(Filepath),
    cast_error(_pipe).

-spec write_bits(binary(), bitstring()) -> {ok, nil} | {error, file_error()}.
write_bits(Filepath, Bits) ->
    _pipe = simplifile_erl:write_file(Bits, Filepath),
    cast_error(_pipe).

-spec append_bits(binary(), bitstring()) -> {ok, nil} | {error, file_error()}.
append_bits(Filepath, Bits) ->
    _pipe = simplifile_erl:append_file(Bits, Filepath),
    cast_error(_pipe).

-spec verify_is_directory(binary()) -> {ok, boolean()} | {error, file_error()}.
verify_is_directory(Filepath) ->
    _pipe = simplifile_erl:is_valid_directory(Filepath),
    cast_error(_pipe).

-spec verify_is_file(binary()) -> {ok, boolean()} | {error, file_error()}.
verify_is_file(Filepath) ->
    _pipe = simplifile_erl:is_valid_file(Filepath),
    cast_error(_pipe).

-spec verify_is_symlink(binary()) -> {ok, boolean()} | {error, file_error()}.
verify_is_symlink(Filepath) ->
    _pipe = simplifile_erl:is_valid_symlink(Filepath),
    cast_error(_pipe).

-spec create_file(binary()) -> {ok, nil} | {error, file_error()}.
create_file(Filepath) ->
    case {begin
            _pipe = Filepath,
            verify_is_file(_pipe)
        end,
        begin
            _pipe@1 = Filepath,
            verify_is_directory(_pipe@1)
        end} of
        {{ok, true}, _} ->
            {error, eexist};

        {_, {ok, true}} ->
            {error, eexist};

        {_, _} ->
            write_bits(Filepath, <<>>)
    end.

-spec set_permissions_octal(binary(), integer()) -> {ok, nil} |
    {error, file_error()}.
set_permissions_octal(Filepath, Permissions) ->
    _pipe = simplifile_erl:set_permissions(Filepath, Permissions),
    cast_error(_pipe).

-spec set_permissions(binary(), file_permissions()) -> {ok, nil} |
    {error, file_error()}.
set_permissions(Filepath, Permissions) ->
    set_permissions_octal(Filepath, file_permissions_to_octal(Permissions)).

-spec current_directory() -> {ok, binary()} | {error, file_error()}.
current_directory() ->
    _pipe = do_current_directory(),
    cast_error(_pipe).

-spec is_directory(binary()) -> boolean().
is_directory(Filepath) ->
    filelib:is_dir(Filepath).

-spec create_directory(binary()) -> {ok, nil} | {error, file_error()}.
create_directory(Filepath) ->
    _pipe = simplifile_erl:make_directory(Filepath),
    cast_error(_pipe).

-spec create_symlink(binary(), binary()) -> {ok, nil} | {error, file_error()}.
create_symlink(Target, Symlink) ->
    _pipe = simplifile_erl:make_symlink(Target, Symlink),
    cast_error(_pipe).

-spec read_directory(binary()) -> {ok, list(binary())} | {error, file_error()}.
read_directory(Path) ->
    _pipe = simplifile_erl:list_directory(Path),
    cast_error(_pipe).

-spec do_copy_directory(binary(), binary()) -> {ok, nil} | {error, file_error()}.
do_copy_directory(Src, Dest) ->
    gleam@result:'try'(
        read_directory(Src),
        fun(Segments) ->
            _pipe = Segments,
            gleam@list:each(
                _pipe,
                fun(Segment) ->
                    Src_path = filepath:join(Src, Segment),
                    Dest_path = filepath:join(Dest, Segment),
                    case {verify_is_file(Src_path),
                        verify_is_directory(Src_path)} of
                        {{ok, true}, {ok, false}} ->
                            gleam@result:'try'(
                                read_bits(Src_path),
                                fun(Content) -> _pipe@1 = Content,
                                    write_bits(Dest_path, _pipe@1) end
                            );

                        {{ok, false}, {ok, true}} ->
                            gleam@result:'try'(
                                create_directory(Dest_path),
                                fun(_) ->
                                    do_copy_directory(Src_path, Dest_path)
                                end
                            );

                        {{error, E}, _} ->
                            {error, E};

                        {_, {error, E}} ->
                            {error, E};

                        {{ok, false}, {ok, false}} ->
                            {error, unknown};

                        {{ok, true}, {ok, true}} ->
                            {error, unknown}
                    end
                end
            ),
            {ok, nil}
        end
    ).

-spec clear_directory(binary()) -> {ok, nil} | {error, file_error()}.
clear_directory(Path) ->
    gleam@result:'try'(read_directory(Path), fun(Paths) -> _pipe = Paths,
            _pipe@1 = gleam@list:map(
                _pipe,
                fun(_capture) -> filepath:join(Path, _capture) end
            ),
            delete_all(_pipe@1) end).

-spec get_files(binary()) -> {ok, list(binary())} | {error, file_error()}.
get_files(Directory) ->
    gleam@result:'try'(
        read_directory(Directory),
        fun(Contents) ->
            Paths = begin
                _pipe = Contents,
                gleam@list:map(
                    _pipe,
                    fun(_capture) -> filepath:join(Directory, _capture) end
                )
            end,
            Files = gleam@list:filter(
                Paths,
                fun(Path) -> verify_is_file(Path) =:= {ok, true} end
            ),
            case gleam@list:filter(
                Paths,
                fun(Path@1) -> verify_is_directory(Path@1) =:= {ok, true} end
            ) of
                [] ->
                    {ok, Files};

                Directories ->
                    gleam@result:'try'(
                        gleam@list:try_map(Directories, fun get_files/1),
                        fun(Nested_files) ->
                            {ok,
                                gleam@list:append(
                                    Files,
                                    gleam@list:flatten(Nested_files)
                                )}
                        end
                    )
            end
        end
    ).

-spec is_file(binary()) -> boolean().
is_file(Filepath) ->
    simplifile_erl:is_file(Filepath).

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
    _pipe@2 = simplifile_erl:create_dir_all(<<Path@1/binary, "/"/utf8>>),
    cast_error(_pipe@2).

-spec copy_directory(binary(), binary()) -> {ok, nil} | {error, file_error()}.
copy_directory(Src, Dest) ->
    gleam@result:'try'(
        create_directory_all(Dest),
        fun(_) -> do_copy_directory(Src, Dest) end
    ).

-spec rename_directory(binary(), binary()) -> {ok, nil} | {error, file_error()}.
rename_directory(Src, Dest) ->
    gleam@result:'try'(copy_directory(Src, Dest), fun(_) -> delete(Src) end).

-spec copy_file(binary(), binary()) -> {ok, nil} | {error, file_error()}.
copy_file(Src, Dest) ->
    _pipe = file:copy(Src, Dest),
    _pipe@1 = gleam@result:replace(_pipe, nil),
    cast_error(_pipe@1).

-spec rename_file(binary(), binary()) -> {ok, nil} | {error, file_error()}.
rename_file(Src, Dest) ->
    _pipe = simplifile_erl:rename_file(Src, Dest),
    cast_error(_pipe).
