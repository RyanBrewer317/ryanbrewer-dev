-module(gleam@otp@task).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([async/1, try_await/2, await/2, pid/1, try_await_forever/1, await_forever/1, try_await2/3, try_await3/4, try_await4/5]).
-export_type([task/1, await_error/0, message2/2, message3/3, message4/4]).

-opaque task(HMJ) :: {task,
        gleam@erlang@process:pid_(),
        gleam@erlang@process:pid_(),
        gleam@erlang@process:subject(HMJ)}.

-type await_error() :: timeout | {exit, gleam@dynamic:dynamic_()}.

-type message2(HMK, HML) :: {m2_from_subject1, HMK} |
    {m2_from_subject2, HML} |
    m2_timeout.

-type message3(HMM, HMN, HMO) :: {m3_from_subject1, HMM} |
    {m3_from_subject2, HMN} |
    {m3_from_subject3, HMO} |
    m3_timeout.

-type message4(HMP, HMQ, HMR, HMS) :: {m4_from_subject1, HMP} |
    {m4_from_subject2, HMQ} |
    {m4_from_subject3, HMR} |
    {m4_from_subject4, HMS} |
    m4_timeout.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/task.gleam", 50).
-spec async(fun(() -> HMT)) -> task(HMT).
async(Work) ->
    Owner = erlang:self(),
    Subject = gleam@erlang@process:new_subject(),
    Pid = gleam@erlang@process:start(
        fun() -> gleam@erlang@process:send(Subject, Work()) end,
        true
    ),
    {task, Owner, Pid, Subject}.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/task.gleam", 65).
-spec assert_owner(task(any())) -> nil.
assert_owner(Task) ->
    Self = erlang:self(),
    case erlang:element(2, Task) =:= Self of
        true ->
            nil;

        false ->
            gleam@erlang@process:send_abnormal_exit(
                Self,
                <<"awaited on a task that does not belong to this process"/utf8>>
            )
    end.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/task.gleam", 83).
-spec try_await(task(HMX), integer()) -> {ok, HMX} | {error, await_error()}.
try_await(Task, Timeout) ->
    assert_owner(Task),
    Selector = begin
        _pipe = gleam_erlang_ffi:new_selector(),
        gleam@erlang@process:selecting(
            _pipe,
            erlang:element(4, Task),
            fun gleam@function:identity/1
        )
    end,
    case gleam_erlang_ffi:select(Selector, Timeout) of
        {ok, X} ->
            {ok, X};

        {error, nil} ->
            {error, timeout}
    end.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/task.gleam", 102).
-spec await(task(HNB), integer()) -> HNB.
await(Task, Timeout) ->
    _assert_subject = try_await(Task, Timeout),
    {ok, Value} = case _assert_subject of
        {ok, _} -> _assert_subject;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        value => _assert_fail,
                        module => <<"gleam/otp/task"/utf8>>,
                        function => <<"await"/utf8>>,
                        line => 103})
    end,
    Value.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/task.gleam", 109).
-spec pid(task(any())) -> gleam@erlang@process:pid_().
pid(Task) ->
    erlang:element(3, Task).

-file("/Users/louis/src/gleam/otp/src/gleam/otp/task.gleam", 114).
-spec try_await_forever(task(HNF)) -> {ok, HNF} | {error, await_error()}.
try_await_forever(Task) ->
    assert_owner(Task),
    Selector = begin
        _pipe = gleam_erlang_ffi:new_selector(),
        gleam@erlang@process:selecting(
            _pipe,
            erlang:element(4, Task),
            fun gleam@function:identity/1
        )
    end,
    case gleam_erlang_ffi:select(Selector) of
        X ->
            {ok, X}
    end.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/task.gleam", 132).
-spec await_forever(task(HNJ)) -> HNJ.
await_forever(Task) ->
    assert_owner(Task),
    Selector = begin
        _pipe = gleam_erlang_ffi:new_selector(),
        gleam@erlang@process:selecting(
            _pipe,
            erlang:element(4, Task),
            fun gleam@function:identity/1
        )
    end,
    gleam_erlang_ffi:select(Selector).

-file("/Users/louis/src/gleam/otp/src/gleam/otp/task.gleam", 169).
-spec try_await2_loop(
    gleam@erlang@process:selector(message2(HNT, HNU)),
    gleam@option:option({ok, HNT} | {error, await_error()}),
    gleam@option:option({ok, HNU} | {error, await_error()}),
    gleam@erlang@process:timer()
) -> {{ok, HNT} | {error, await_error()}, {ok, HNU} | {error, await_error()}}.
try_await2_loop(Selector, T1, T2, Timeout) ->
    case {T1, T2} of
        {{some, T1@1}, {some, T2@1}} ->
            {T1@1, T2@1};

        {_, _} ->
            case gleam_erlang_ffi:select(Selector) of
                {m2_from_subject1, X} ->
                    T1@2 = {some, {ok, X}},
                    try_await2_loop(Selector, T1@2, T2, Timeout);

                {m2_from_subject2, X@1} ->
                    T2@2 = {some, {ok, X@1}},
                    try_await2_loop(Selector, T1, T2@2, Timeout);

                m2_timeout ->
                    {gleam@option:unwrap(T1, {error, timeout}),
                        gleam@option:unwrap(T2, {error, timeout})}
            end
    end.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/task.gleam", 151).
-spec try_await2(task(HNL), task(HNN), integer()) -> {{ok, HNL} |
        {error, await_error()},
    {ok, HNN} | {error, await_error()}}.
try_await2(Task1, Task2, Timeout) ->
    assert_owner(Task1),
    assert_owner(Task2),
    Timeout_subject = gleam@erlang@process:new_subject(),
    Timer = gleam@erlang@process:send_after(
        Timeout_subject,
        Timeout,
        m2_timeout
    ),
    _pipe = gleam_erlang_ffi:new_selector(),
    _pipe@1 = gleam@erlang@process:selecting(
        _pipe,
        erlang:element(4, Task1),
        fun(Field@0) -> {m2_from_subject1, Field@0} end
    ),
    _pipe@2 = gleam@erlang@process:selecting(
        _pipe@1,
        erlang:element(4, Task2),
        fun(Field@0) -> {m2_from_subject2, Field@0} end
    ),
    _pipe@3 = gleam@erlang@process:selecting(
        _pipe@2,
        Timeout_subject,
        fun gleam@function:identity/1
    ),
    try_await2_loop(_pipe@3, none, none, Timer).

-file("/Users/louis/src/gleam/otp/src/gleam/otp/task.gleam", 234).
-spec try_await3_loop(
    gleam@erlang@process:selector(message3(HOU, HOV, HOW)),
    gleam@option:option({ok, HOU} | {error, await_error()}),
    gleam@option:option({ok, HOV} | {error, await_error()}),
    gleam@option:option({ok, HOW} | {error, await_error()}),
    gleam@erlang@process:timer()
) -> {{ok, HOU} | {error, await_error()},
    {ok, HOV} | {error, await_error()},
    {ok, HOW} | {error, await_error()}}.
try_await3_loop(Selector, T1, T2, T3, Timeout) ->
    case {T1, T2, T3} of
        {{some, T1@1}, {some, T2@1}, {some, T3@1}} ->
            {T1@1, T2@1, T3@1};

        {_, _, _} ->
            case gleam_erlang_ffi:select(Selector) of
                {m3_from_subject1, X} ->
                    T1@2 = {some, {ok, X}},
                    try_await3_loop(Selector, T1@2, T2, T3, Timeout);

                {m3_from_subject2, X@1} ->
                    T2@2 = {some, {ok, X@1}},
                    try_await3_loop(Selector, T1, T2@2, T3, Timeout);

                {m3_from_subject3, X@2} ->
                    T3@2 = {some, {ok, X@2}},
                    try_await3_loop(Selector, T1, T2, T3@2, Timeout);

                m3_timeout ->
                    {gleam@option:unwrap(T1, {error, timeout}),
                        gleam@option:unwrap(T2, {error, timeout}),
                        gleam@option:unwrap(T3, {error, timeout})}
            end
    end.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/task.gleam", 213).
-spec try_await3(task(HOI), task(HOK), task(HOM), integer()) -> {{ok, HOI} |
        {error, await_error()},
    {ok, HOK} | {error, await_error()},
    {ok, HOM} | {error, await_error()}}.
try_await3(Task1, Task2, Task3, Timeout) ->
    assert_owner(Task1),
    assert_owner(Task2),
    assert_owner(Task3),
    Timeout_subject = gleam@erlang@process:new_subject(),
    Timer = gleam@erlang@process:send_after(
        Timeout_subject,
        Timeout,
        m3_timeout
    ),
    _pipe = gleam_erlang_ffi:new_selector(),
    _pipe@1 = gleam@erlang@process:selecting(
        _pipe,
        erlang:element(4, Task1),
        fun(Field@0) -> {m3_from_subject1, Field@0} end
    ),
    _pipe@2 = gleam@erlang@process:selecting(
        _pipe@1,
        erlang:element(4, Task2),
        fun(Field@0) -> {m3_from_subject2, Field@0} end
    ),
    _pipe@3 = gleam@erlang@process:selecting(
        _pipe@2,
        erlang:element(4, Task3),
        fun(Field@0) -> {m3_from_subject3, Field@0} end
    ),
    _pipe@4 = gleam@erlang@process:selecting(
        _pipe@3,
        Timeout_subject,
        fun gleam@function:identity/1
    ),
    try_await3_loop(_pipe@4, none, none, none, Timer).

-file("/Users/louis/src/gleam/otp/src/gleam/otp/task.gleam", 313).
-spec try_await4_loop(
    gleam@erlang@process:selector(message4(HQG, HQH, HQI, HQJ)),
    gleam@option:option({ok, HQG} | {error, await_error()}),
    gleam@option:option({ok, HQH} | {error, await_error()}),
    gleam@option:option({ok, HQI} | {error, await_error()}),
    gleam@option:option({ok, HQJ} | {error, await_error()}),
    gleam@erlang@process:timer()
) -> {{ok, HQG} | {error, await_error()},
    {ok, HQH} | {error, await_error()},
    {ok, HQI} | {error, await_error()},
    {ok, HQJ} | {error, await_error()}}.
try_await4_loop(Selector, T1, T2, T3, T4, Timeout) ->
    case {T1, T2, T3, T4} of
        {{some, T1@1}, {some, T2@1}, {some, T3@1}, {some, T4@1}} ->
            {T1@1, T2@1, T3@1, T4@1};

        {_, _, _, _} ->
            case gleam_erlang_ffi:select(Selector) of
                {m4_from_subject1, X} ->
                    T1@2 = {some, {ok, X}},
                    try_await4_loop(Selector, T1@2, T2, T3, T4, Timeout);

                {m4_from_subject2, X@1} ->
                    T2@2 = {some, {ok, X@1}},
                    try_await4_loop(Selector, T1, T2@2, T3, T4, Timeout);

                {m4_from_subject3, X@2} ->
                    T3@2 = {some, {ok, X@2}},
                    try_await4_loop(Selector, T1, T2, T3@2, T4, Timeout);

                {m4_from_subject4, X@3} ->
                    T4@2 = {some, {ok, X@3}},
                    try_await4_loop(Selector, T1, T2, T3, T4@2, Timeout);

                m4_timeout ->
                    {gleam@option:unwrap(T1, {error, timeout}),
                        gleam@option:unwrap(T2, {error, timeout}),
                        gleam@option:unwrap(T3, {error, timeout}),
                        gleam@option:unwrap(T4, {error, timeout})}
            end
    end.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/task.gleam", 285).
-spec try_await4(task(HPQ), task(HPS), task(HPU), task(HPW), integer()) -> {{ok,
            HPQ} |
        {error, await_error()},
    {ok, HPS} | {error, await_error()},
    {ok, HPU} | {error, await_error()},
    {ok, HPW} | {error, await_error()}}.
try_await4(Task1, Task2, Task3, Task4, Timeout) ->
    assert_owner(Task1),
    assert_owner(Task2),
    assert_owner(Task3),
    Timeout_subject = gleam@erlang@process:new_subject(),
    Timer = gleam@erlang@process:send_after(
        Timeout_subject,
        Timeout,
        m4_timeout
    ),
    _pipe = gleam_erlang_ffi:new_selector(),
    _pipe@1 = gleam@erlang@process:selecting(
        _pipe,
        erlang:element(4, Task1),
        fun(Field@0) -> {m4_from_subject1, Field@0} end
    ),
    _pipe@2 = gleam@erlang@process:selecting(
        _pipe@1,
        erlang:element(4, Task2),
        fun(Field@0) -> {m4_from_subject2, Field@0} end
    ),
    _pipe@3 = gleam@erlang@process:selecting(
        _pipe@2,
        erlang:element(4, Task3),
        fun(Field@0) -> {m4_from_subject3, Field@0} end
    ),
    _pipe@4 = gleam@erlang@process:selecting(
        _pipe@3,
        erlang:element(4, Task4),
        fun(Field@0) -> {m4_from_subject4, Field@0} end
    ),
    _pipe@5 = gleam@erlang@process:selecting(
        _pipe@4,
        Timeout_subject,
        fun gleam@function:identity/1
    ),
    try_await4_loop(_pipe@5, none, none, none, none, Timer).
