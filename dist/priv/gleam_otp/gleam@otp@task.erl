-module(gleam@otp@task).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([async/1, try_await/2, await/2, try_await_forever/1, await_forever/1]).
-export_type([task/1, await_error/0, message/1]).

-opaque task(HKS) :: {task,
        gleam@erlang@process:pid_(),
        gleam@erlang@process:pid_(),
        gleam@erlang@process:process_monitor(),
        gleam@erlang@process:selector(message(HKS))}.

-type await_error() :: timeout | {exit, gleam@dynamic:dynamic_()}.

-type message(HKT) :: {from_monitor, gleam@erlang@process:process_down()} |
    {from_subject, HKT}.

-spec async(fun(() -> HKU)) -> task(HKU).
async(Work) ->
    Owner = erlang:self(),
    Subject = gleam@erlang@process:new_subject(),
    Pid = gleam@erlang@process:start(
        fun() -> gleam@erlang@process:send(Subject, Work()) end,
        true
    ),
    Monitor = gleam@erlang@process:monitor_process(Pid),
    Selector = begin
        _pipe = gleam_erlang_ffi:new_selector(),
        _pipe@1 = gleam@erlang@process:selecting_process_down(
            _pipe,
            Monitor,
            fun(Field@0) -> {from_monitor, Field@0} end
        ),
        gleam@erlang@process:selecting(
            _pipe@1,
            Subject,
            fun(Field@0) -> {from_subject, Field@0} end
        )
    end,
    {task, Owner, Pid, Monitor, Selector}.

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

-spec try_await(task(HKY), integer()) -> {ok, HKY} | {error, await_error()}.
try_await(Task, Timeout) ->
    assert_owner(Task),
    case gleam_erlang_ffi:select(erlang:element(5, Task), Timeout) of
        {ok, {from_subject, X}} ->
            gleam_erlang_ffi:demonitor(erlang:element(4, Task)),
            {ok, X};

        {ok, {from_monitor, {process_down, _, Reason}}} ->
            {error, {exit, Reason}};

        {error, nil} ->
            {error, timeout}
    end.

-spec await(task(HLC), integer()) -> HLC.
await(Task, Timeout) ->
    _assert_subject = try_await(Task, Timeout),
    {ok, Value} = case _assert_subject of
        {ok, _} -> _assert_subject;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Assertion pattern match failed"/utf8>>,
                        value => _assert_fail,
                        module => <<"gleam/otp/task"/utf8>>,
                        function => <<"await"/utf8>>,
                        line => 119})
    end,
    Value.

-spec try_await_forever(task(HLE)) -> {ok, HLE} | {error, await_error()}.
try_await_forever(Task) ->
    assert_owner(Task),
    case gleam_erlang_ffi:select(erlang:element(5, Task)) of
        {from_subject, X} ->
            gleam_erlang_ffi:demonitor(erlang:element(4, Task)),
            {ok, X};

        {from_monitor, {process_down, _, Reason}} ->
            {error, {exit, Reason}}
    end.

-spec await_forever(task(HLI)) -> HLI.
await_forever(Task) ->
    _assert_subject = try_await_forever(Task),
    {ok, Value} = case _assert_subject of
        {ok, _} -> _assert_subject;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Assertion pattern match failed"/utf8>>,
                        value => _assert_fail,
                        module => <<"gleam/otp/task"/utf8>>,
                        function => <<"await_forever"/utf8>>,
                        line => 151})
    end,
    Value.
