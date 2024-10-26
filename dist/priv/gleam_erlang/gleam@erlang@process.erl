-module(gleam@erlang@process).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([self/0, start/2, new_subject/0, subject_owner/1, send/2, new_selector/0, select/2, select_forever/1, map_selector/2, merge_selector/2, flush_messages/0, selecting_trapped_exits/2, selecting/3, 'receive'/2, selecting_record2/3, selecting_record3/3, selecting_record4/3, selecting_record5/3, selecting_record6/3, selecting_record7/3, selecting_record8/3, selecting_anything/2, sleep/1, sleep_forever/0, is_alive/1, monitor_process/1, selecting_process_down/3, demonitor_process/1, deselecting_process_down/2, try_call/3, call/3, link/1, unlink/1, send_after/3, cancel_timer/1, kill/1, send_exit/1, send_abnormal_exit/2, trap_exits/1, register/2, unregister/1, named/1, pid_from_dynamic/1]).
-export_type([pid_/0, subject/1, do_not_leak/0, selector/1, exit_message/0, exit_reason/0, anything_selector_tag/0, process_monitor_flag/0, process_monitor/0, process_down/0, call_error/1, timer/0, cancelled/0, kill_flag/0]).

-type pid_() :: any().

-opaque subject(FOG) :: {subject, pid_(), gleam@erlang:reference_()} |
    {gleam_phantom, FOG}.

-type do_not_leak() :: any().

-type selector(FOH) :: any() | {gleam_phantom, FOH}.

-type exit_message() :: {exit_message, pid_(), exit_reason()}.

-type exit_reason() :: normal | killed | {abnormal, binary()}.

-type anything_selector_tag() :: anything.

-type process_monitor_flag() :: process.

-opaque process_monitor() :: {process_monitor, gleam@erlang:reference_()}.

-type process_down() :: {process_down, pid_(), gleam@dynamic:dynamic_()}.

-type call_error(FOI) :: {callee_down, gleam@dynamic:dynamic_()} |
    call_timeout |
    {gleam_phantom, FOI}.

-type timer() :: any().

-type cancelled() :: timer_not_found | {cancelled, integer()}.

-type kill_flag() :: kill.

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 14).
-spec self() -> pid_().
self() ->
    erlang:self().

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 28).
-spec start(fun(() -> any()), boolean()) -> pid_().
start(Implementation, Link) ->
    case Link of
        true ->
            erlang:spawn_link(Implementation);

        false ->
            erlang:spawn(Implementation)
    end.

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 70).
-spec new_subject() -> subject(any()).
new_subject() ->
    {subject, erlang:self(), erlang:make_ref()}.

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 77).
-spec subject_owner(subject(any())) -> pid_().
subject_owner(Subject) ->
    erlang:element(2, Subject).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 110).
-spec send(subject(FOR), FOR) -> nil.
send(Subject, Message) ->
    erlang:send(
        erlang:element(2, Subject),
        {erlang:element(3, Subject), Message}
    ),
    nil.

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 166).
-spec new_selector() -> selector(any()).
new_selector() ->
    gleam_erlang_ffi:new_selector().

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 186).
-spec select(selector(FOZ), integer()) -> {ok, FOZ} | {error, nil}.
select(From, Within) ->
    gleam_erlang_ffi:select(From, Within).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 195).
-spec select_forever(selector(FPD)) -> FPD.
select_forever(From) ->
    gleam_erlang_ffi:select(From).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 204).
-spec map_selector(selector(FPF), fun((FPF) -> FPH)) -> selector(FPH).
map_selector(A, B) ->
    gleam_erlang_ffi:map_selector(A, B).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 213).
-spec merge_selector(selector(FPJ), selector(FPJ)) -> selector(FPJ).
merge_selector(A, B) ->
    gleam_erlang_ffi:merge_selector(A, B).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 257).
-spec flush_messages() -> nil.
flush_messages() ->
    gleam_erlang_ffi:flush_messages().

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 229).
-spec selecting_trapped_exits(selector(FPN), fun((exit_message()) -> FPN)) -> selector(FPN).
selecting_trapped_exits(Selector, Handler) ->
    Tag = erlang:binary_to_atom(<<"EXIT"/utf8>>),
    Handler@1 = fun(Message) ->
        Reason = erlang:element(3, Message),
        Normal = gleam@dynamic:from(normal),
        Killed = gleam@dynamic:from(killed),
        Reason@2 = case gleam@dynamic:string(Reason) of
            _ when Reason =:= Normal ->
                normal;

            _ when Reason =:= Killed ->
                killed;

            {ok, Reason@1} ->
                {abnormal, Reason@1};

            {error, _} ->
                {abnormal, gleam@string:inspect(Reason)}
        end,
        Handler({exit_message, erlang:element(2, Message), Reason@2})
    end,
    gleam_erlang_ffi:insert_selector_handler(Selector, {Tag, 3}, Handler@1).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 267).
-spec selecting(selector(FPQ), subject(FPS), fun((FPS) -> FPQ)) -> selector(FPQ).
selecting(Selector, Subject, Transform) ->
    Handler = fun(Message) -> Transform(erlang:element(2, Message)) end,
    gleam_erlang_ffi:insert_selector_handler(
        Selector,
        {erlang:element(3, Subject), 2},
        Handler
    ).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 130).
-spec 'receive'(subject(FOT), integer()) -> {ok, FOT} | {error, nil}.
'receive'(Subject, Timeout) ->
    _pipe = gleam_erlang_ffi:new_selector(),
    _pipe@1 = selecting(_pipe, Subject, fun(X) -> X end),
    gleam_erlang_ffi:select(_pipe@1, Timeout).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 283).
-spec selecting_record2(
    selector(FPV),
    any(),
    fun((gleam@dynamic:dynamic_()) -> FPV)
) -> selector(FPV).
selecting_record2(Selector, Tag, Transform) ->
    Handler = fun(Message) -> Transform(erlang:element(2, Message)) end,
    gleam_erlang_ffi:insert_selector_handler(Selector, {Tag, 2}, Handler).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 299).
-spec selecting_record3(
    selector(FPZ),
    any(),
    fun((gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_()) -> FPZ)
) -> selector(FPZ).
selecting_record3(Selector, Tag, Transform) ->
    Handler = fun(Message) ->
        Transform(erlang:element(2, Message), erlang:element(3, Message))
    end,
    gleam_erlang_ffi:insert_selector_handler(Selector, {Tag, 3}, Handler).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 317).
-spec selecting_record4(
    selector(FQD),
    any(),
    fun((gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_()) -> FQD)
) -> selector(FQD).
selecting_record4(Selector, Tag, Transform) ->
    Handler = fun(Message) ->
        Transform(
            erlang:element(2, Message),
            erlang:element(3, Message),
            erlang:element(4, Message)
        )
    end,
    gleam_erlang_ffi:insert_selector_handler(Selector, {Tag, 4}, Handler).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 335).
-spec selecting_record5(
    selector(FQH),
    any(),
    fun((gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_()) -> FQH)
) -> selector(FQH).
selecting_record5(Selector, Tag, Transform) ->
    Handler = fun(Message) ->
        Transform(
            erlang:element(2, Message),
            erlang:element(3, Message),
            erlang:element(4, Message),
            erlang:element(5, Message)
        )
    end,
    gleam_erlang_ffi:insert_selector_handler(Selector, {Tag, 5}, Handler).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 353).
-spec selecting_record6(
    selector(FQL),
    any(),
    fun((gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_()) -> FQL)
) -> selector(FQL).
selecting_record6(Selector, Tag, Transform) ->
    Handler = fun(Message) ->
        Transform(
            erlang:element(2, Message),
            erlang:element(3, Message),
            erlang:element(4, Message),
            erlang:element(5, Message),
            erlang:element(6, Message)
        )
    end,
    gleam_erlang_ffi:insert_selector_handler(Selector, {Tag, 6}, Handler).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 371).
-spec selecting_record7(
    selector(FQP),
    any(),
    fun((gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_()) -> FQP)
) -> selector(FQP).
selecting_record7(Selector, Tag, Transform) ->
    Handler = fun(Message) ->
        Transform(
            erlang:element(2, Message),
            erlang:element(3, Message),
            erlang:element(4, Message),
            erlang:element(5, Message),
            erlang:element(6, Message),
            erlang:element(7, Message)
        )
    end,
    gleam_erlang_ffi:insert_selector_handler(Selector, {Tag, 7}, Handler).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 392).
-spec selecting_record8(
    selector(FQT),
    any(),
    fun((gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_(), gleam@dynamic:dynamic_()) -> FQT)
) -> selector(FQT).
selecting_record8(Selector, Tag, Transform) ->
    Handler = fun(Message) ->
        Transform(
            erlang:element(2, Message),
            erlang:element(3, Message),
            erlang:element(4, Message),
            erlang:element(5, Message),
            erlang:element(6, Message),
            erlang:element(7, Message),
            erlang:element(8, Message)
        )
    end,
    gleam_erlang_ffi:insert_selector_handler(Selector, {Tag, 8}, Handler).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 442).
-spec selecting_anything(selector(FQX), fun((gleam@dynamic:dynamic_()) -> FQX)) -> selector(FQX).
selecting_anything(Selector, Handler) ->
    gleam_erlang_ffi:insert_selector_handler(Selector, anything, Handler).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 466).
-spec sleep(integer()) -> nil.
sleep(A) ->
    gleam_erlang_ffi:sleep(A).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 473).
-spec sleep_forever() -> nil.
sleep_forever() ->
    gleam_erlang_ffi:sleep_forever().

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 482).
-spec is_alive(pid_()) -> boolean().
is_alive(A) ->
    erlang:is_process_alive(A).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 513).
-spec monitor_process(pid_()) -> process_monitor().
monitor_process(Pid) ->
    _pipe = process,
    _pipe@1 = erlang:monitor(_pipe, Pid),
    {process_monitor, _pipe@1}.

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 524).
-spec selecting_process_down(
    selector(FRJ),
    process_monitor(),
    fun((process_down()) -> FRJ)
) -> selector(FRJ).
selecting_process_down(Selector, Monitor, Mapping) ->
    gleam_erlang_ffi:insert_selector_handler(
        Selector,
        erlang:element(2, Monitor),
        Mapping
    ).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 539).
-spec demonitor_process(process_monitor()) -> nil.
demonitor_process(Monitor) ->
    gleam_erlang_ffi:demonitor(Monitor).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 558).
-spec deselecting_process_down(selector(FRM), process_monitor()) -> selector(FRM).
deselecting_process_down(Selector, Monitor) ->
    gleam_erlang_ffi:remove_selector_handler(
        Selector,
        erlang:element(2, Monitor)
    ).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 573).
-spec try_call(subject(FRP), fun((subject(FRR)) -> FRP), integer()) -> {ok, FRR} |
    {error, call_error(FRR)}.
try_call(Subject, Make_request, Timeout) ->
    Reply_subject = new_subject(),
    Monitor = monitor_process(subject_owner(Subject)),
    send(Subject, Make_request(Reply_subject)),
    Result = begin
        _pipe = gleam_erlang_ffi:new_selector(),
        _pipe@1 = selecting(
            _pipe,
            Reply_subject,
            fun(Field@0) -> {ok, Field@0} end
        ),
        _pipe@2 = selecting_process_down(
            _pipe@1,
            Monitor,
            fun(Down) -> {error, {callee_down, erlang:element(3, Down)}} end
        ),
        gleam_erlang_ffi:select(_pipe@2, Timeout)
    end,
    gleam_erlang_ffi:demonitor(Monitor),
    case Result of
        {error, nil} ->
            {error, call_timeout};

        {ok, Res} ->
            Res
    end.

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 614).
-spec call(subject(FRW), fun((subject(FRY)) -> FRW), integer()) -> FRY.
call(Subject, Make_request, Timeout) ->
    _assert_subject = try_call(Subject, Make_request, Timeout),
    {ok, Resp} = case _assert_subject of
        {ok, _} -> _assert_subject;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        value => _assert_fail,
                        module => <<"gleam/erlang/process"/utf8>>,
                        function => <<"call"/utf8>>,
                        line => 619})
    end,
    Resp.

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 633).
-spec link(pid_()) -> boolean().
link(Pid) ->
    gleam_erlang_ffi:link(Pid).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 640).
-spec unlink(pid_()) -> nil.
unlink(Pid) ->
    erlang:unlink(Pid),
    nil.

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 652).
-spec send_after(subject(FSB), integer(), FSB) -> timer().
send_after(Subject, Delay, Message) ->
    erlang:send_after(
        Delay,
        erlang:element(2, Subject),
        {erlang:element(3, Subject), Message}
    ).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 676).
-spec cancel_timer(timer()) -> cancelled().
cancel_timer(Timer) ->
    case gleam@dynamic:int(erlang:cancel_timer(Timer)) of
        {ok, I} ->
            {cancelled, I};

        {error, _} ->
            timer_not_found
    end.

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 700).
-spec kill(pid_()) -> nil.
kill(Pid) ->
    erlang:exit(Pid, kill),
    nil.

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 716).
-spec send_exit(pid_()) -> nil.
send_exit(Pid) ->
    erlang:exit(Pid, normal),
    nil.

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 728).
-spec send_abnormal_exit(pid_(), binary()) -> nil.
send_abnormal_exit(Pid, Reason) ->
    erlang:exit(Pid, {abnormal, Reason}),
    nil.

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 744).
-spec trap_exits(boolean()) -> nil.
trap_exits(A) ->
    gleam_erlang_ffi:trap_exits(A).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 756).
-spec register(pid_(), gleam@erlang@atom:atom_()) -> {ok, nil} | {error, nil}.
register(Pid, Name) ->
    gleam_erlang_ffi:register_process(Pid, Name).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 767).
-spec unregister(gleam@erlang@atom:atom_()) -> {ok, nil} | {error, nil}.
unregister(Name) ->
    gleam_erlang_ffi:unregister_process(Name).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 772).
-spec named(gleam@erlang@atom:atom_()) -> {ok, pid_()} | {error, nil}.
named(Name) ->
    gleam_erlang_ffi:process_named(Name).

-file("/Users/louis/src/gleam/erlang/src/gleam/erlang/process.gleam", 790).
-spec pid_from_dynamic(gleam@dynamic:dynamic_()) -> {ok, pid_()} |
    {error, list(gleam@dynamic:decode_error())}.
pid_from_dynamic(From) ->
    gleam_erlang_ffi:pid_from_dynamic(From).
