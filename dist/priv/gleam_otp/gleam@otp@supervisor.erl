-module(gleam@otp@supervisor).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([add/2, supervisor/1, worker/1, returning/2, start_spec/1, start/1, application_stopped/0, to_erlang_start_result/1]).
-export_type([spec/2, children/1, child_spec/3, child_start_error/0, message/0, instruction/0, state/1, starter/1, child/1, handle_exit_error/0, application_start_mode/0, application_stop/0]).

-type spec(GZA, GZB) :: {spec,
        GZA,
        integer(),
        integer(),
        fun((children(GZA)) -> children(GZB))}.

-opaque children(GZC) :: {ready, starter(GZC)} | {failed, child_start_error()}.

-opaque child_spec(GZD, GZE, GZF) :: {child_spec,
        fun((GZE) -> {ok, gleam@erlang@process:subject(GZD)} |
            {error, gleam@otp@actor:start_error()}),
        fun((GZE, gleam@erlang@process:subject(GZD)) -> GZF)}.

-type child_start_error() :: {child_start_error,
        gleam@option:option(gleam@erlang@process:pid_()),
        gleam@otp@actor:start_error()}.

-opaque message() :: {exit, gleam@erlang@process:exit_message()} |
    {retry_restart, gleam@erlang@process:pid_()}.

-type instruction() :: start_all | {start_from, gleam@erlang@process:pid_()}.

-type state(GZG) :: {state,
        gleam@otp@intensity_tracker:intensity_tracker(),
        starter(GZG),
        gleam@erlang@process:subject(gleam@erlang@process:pid_())}.

-type starter(GZH) :: {starter,
        GZH,
        gleam@option:option(fun((instruction()) -> {ok,
                {starter(GZH), instruction()}} |
            {error, child_start_error()}))}.

-type child(GZI) :: {child, gleam@erlang@process:pid_(), GZI}.

-type handle_exit_error() :: {restart_failed,
        gleam@erlang@process:pid_(),
        gleam@otp@intensity_tracker:intensity_tracker()} |
    too_many_restarts.

-type application_start_mode() :: normal |
    {takeover, gleam@erlang@node:node_()} |
    {failover, gleam@erlang@node:node_()}.

-type application_stop() :: any().

-file("/Users/louis/src/gleam/otp/src/gleam/otp/supervisor.gleam", 87).
-spec start_child(child_spec(any(), GZM, GZN), GZM) -> {ok, child(GZN)} |
    {error, child_start_error()}.
start_child(Child_spec, Argument) ->
    gleam@result:then(
        begin
            _pipe = (erlang:element(2, Child_spec))(Argument),
            gleam@result:map_error(
                _pipe,
                fun(_capture) -> {child_start_error, none, _capture} end
            )
        end,
        fun(Subject) ->
            {ok,
                {child,
                    gleam@erlang@process:subject_owner(Subject),
                    (erlang:element(3, Child_spec))(Argument, Subject)}}
        end
    ).

-file("/Users/louis/src/gleam/otp/src/gleam/otp/supervisor.gleam", 106).
-spec shutdown_child(
    gleam@erlang@process:pid_(),
    child_spec(any(), any(), any())
) -> nil.
shutdown_child(Pid, _) ->
    gleam@erlang@process:send_exit(Pid).

-file("/Users/louis/src/gleam/otp/src/gleam/otp/supervisor.gleam", 110).
-spec perform_instruction_for_child(
    HAA,
    instruction(),
    child_spec(any(), HAA, HAC),
    child(HAC)
) -> {ok, {child(HAC), instruction()}} | {error, child_start_error()}.
perform_instruction_for_child(Argument, Instruction, Child_spec, Child) ->
    Current = erlang:element(2, Child),
    case Instruction of
        {start_from, Target} when Target =/= Current ->
            {ok, {Child, Instruction}};

        _ ->
            shutdown_child(Current, Child_spec),
            gleam@result:then(
                start_child(Child_spec, Argument),
                fun(Child@1) -> {ok, {Child@1, start_all}} end
            )
    end.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/supervisor.gleam", 132).
-spec add_child_to_starter(
    starter(HAK),
    child_spec(any(), HAK, HAN),
    child(HAN)
) -> starter(HAN).
add_child_to_starter(Starter, Child_spec, Child) ->
    Starter@3 = fun(Instruction) ->
        gleam@result:then(case erlang:element(3, Starter) of
                {some, Start} ->
                    Start(Instruction);

                none ->
                    {ok, {Starter, Instruction}}
            end, fun(_use0) ->
                {Starter@1, Instruction@1} = _use0,
                gleam@result:then(
                    perform_instruction_for_child(
                        erlang:element(2, Starter@1),
                        Instruction@1,
                        Child_spec,
                        Child
                    ),
                    fun(_use0@1) ->
                        {Child@1, Instruction@2} = _use0@1,
                        Starter@2 = add_child_to_starter(
                            Starter@1,
                            Child_spec,
                            Child@1
                        ),
                        {ok, {Starter@2, Instruction@2}}
                    end
                )
            end)
    end,
    {starter, erlang:element(3, Child), {some, Starter@3}}.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/supervisor.gleam", 164).
-spec start_and_add_child(starter(HAT), child_spec(any(), HAT, HAW)) -> children(HAW).
start_and_add_child(State, Child_spec) ->
    case start_child(Child_spec, erlang:element(2, State)) of
        {ok, Child} ->
            {ready, add_child_to_starter(State, Child_spec, Child)};

        {error, Reason} ->
            {failed, Reason}
    end.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/supervisor.gleam", 178).
-spec add(children(HBB), child_spec(any(), HBB, HBE)) -> children(HBE).
add(Children, Child_spec) ->
    case Children of
        {failed, Fail} ->
            {failed, Fail};

        {ready, State} ->
            start_and_add_child(State, Child_spec)
    end.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/supervisor.gleam", 206).
-spec supervisor(
    fun((HBJ) -> {ok, gleam@erlang@process:subject(HBK)} |
        {error, gleam@otp@actor:start_error()})
) -> child_spec(HBK, HBJ, HBJ).
supervisor(Start) ->
    {child_spec, Start, fun(Argument, _) -> Argument end}.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/supervisor.gleam", 228).
-spec worker(
    fun((HBR) -> {ok, gleam@erlang@process:subject(HBS)} |
        {error, gleam@otp@actor:start_error()})
) -> child_spec(HBS, HBR, HBR).
worker(Start) ->
    {child_spec, Start, fun(Argument, _) -> Argument end}.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/supervisor.gleam", 241).
-spec returning(
    child_spec(HBZ, HCA, any()),
    fun((HCA, gleam@erlang@process:subject(HBZ)) -> HCG)
) -> child_spec(HBZ, HCA, HCG).
returning(Child, Updater) ->
    {child_spec, erlang:element(2, Child), Updater}.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/supervisor.gleam", 248).
-spec init(spec(any(), HCL)) -> gleam@otp@actor:init_result(state(HCL), message()).
init(Spec) ->
    Retry = gleam@erlang@process:new_subject(),
    gleam_erlang_ffi:trap_exits(true),
    Selector = begin
        _pipe = gleam_erlang_ffi:new_selector(),
        _pipe@1 = gleam@erlang@process:selecting(
            _pipe,
            Retry,
            fun(Field@0) -> {retry_restart, Field@0} end
        ),
        gleam@erlang@process:selecting_trapped_exits(
            _pipe@1,
            fun(Field@0) -> {exit, Field@0} end
        )
    end,
    Result = begin
        _pipe@2 = {starter, erlang:element(2, Spec), none},
        _pipe@3 = {ready, _pipe@2},
        (erlang:element(5, Spec))(_pipe@3)
    end,
    case Result of
        {ready, Starter} ->
            Restarts = gleam@otp@intensity_tracker:new(
                erlang:element(3, Spec),
                erlang:element(4, Spec)
            ),
            State = {state, Restarts, Starter, Retry},
            {ready, State, Selector};

        {failed, Error} ->
            {failed, case erlang:element(3, Error) of
                    init_timeout ->
                        <<"Child initialisation timed out"/utf8>>;

                    {init_crashed, Reason} ->
                        gleam@string:append(
                            <<"Child crashed during initialisation: "/utf8>>,
                            gleam@string:inspect(Reason)
                        );

                    {init_failed, Reason@1} ->
                        gleam@string:append(
                            <<"Child failed to start during initialisation: "/utf8>>,
                            gleam@string:inspect(Reason@1)
                        )
                end}
    end.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/supervisor.gleam", 305).
-spec handle_exit(gleam@erlang@process:pid_(), state(HCR)) -> gleam@otp@actor:next(message(), state(HCR)).
handle_exit(Pid, State) ->
    Outcome = begin
        _assert_subject = erlang:element(3, erlang:element(3, State)),
        {some, Start} = case _assert_subject of
            {some, _} -> _assert_subject;
            _assert_fail ->
                erlang:error(#{gleam_error => let_assert,
                            message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                            value => _assert_fail,
                            module => <<"gleam/otp/supervisor"/utf8>>,
                            function => <<"handle_exit"/utf8>>,
                            line => 308})
        end,
        gleam@result:then(
            begin
                _pipe = erlang:element(2, State),
                _pipe@1 = gleam@otp@intensity_tracker:add_event(_pipe),
                gleam@result:map_error(_pipe@1, fun(_) -> too_many_restarts end)
            end,
            fun(Restarts) ->
                gleam@result:then(
                    begin
                        _pipe@2 = Start({start_from, Pid}),
                        gleam@result:map_error(
                            _pipe@2,
                            fun(E) ->
                                {restart_failed,
                                    gleam@option:unwrap(
                                        erlang:element(2, E),
                                        Pid
                                    ),
                                    Restarts}
                            end
                        )
                    end,
                    fun(_use0) ->
                        {Starter, _} = _use0,
                        {ok,
                            erlang:setelement(
                                2,
                                erlang:setelement(3, State, Starter),
                                Restarts
                            )}
                    end
                )
            end
        )
    end,
    case Outcome of
        {ok, State@1} ->
            gleam@otp@actor:continue(State@1);

        {error, {restart_failed, Failed_child, Restarts@1}} ->
            gleam@erlang@process:send(erlang:element(4, State), Failed_child),
            State@2 = erlang:setelement(2, State, Restarts@1),
            gleam@otp@actor:continue(State@2);

        {error, too_many_restarts} ->
            {stop,
                {abnormal,
                    <<"Child processes restarted too many times within allowed period"/utf8>>}}
    end.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/supervisor.gleam", 345).
-spec loop(message(), state(HCW)) -> gleam@otp@actor:next(message(), state(HCW)).
loop(Message, State) ->
    case Message of
        {exit, Exit_message} ->
            handle_exit(erlang:element(2, Exit_message), State);

        {retry_restart, Pid} ->
            handle_exit(Pid, State)
    end.

-file("/Users/louis/src/gleam/otp/src/gleam/otp/supervisor.gleam", 377).
-spec start_spec(spec(any(), any())) -> {ok,
        gleam@erlang@process:subject(message())} |
    {error, gleam@otp@actor:start_error()}.
start_spec(Spec) ->
    gleam@otp@actor:start_spec(
        {spec, fun() -> init(Spec) end, 60000, fun loop/2}
    ).

-file("/Users/louis/src/gleam/otp/src/gleam/otp/supervisor.gleam", 408).
-spec start(fun((children(nil)) -> children(any()))) -> {ok,
        gleam@erlang@process:subject(message())} |
    {error, gleam@otp@actor:start_error()}.
start(Init) ->
    start_spec({spec, nil, 1, 5, Init}).

-file("/Users/louis/src/gleam/otp/src/gleam/otp/supervisor.gleam", 438).
-spec application_stopped() -> application_stop().
application_stopped() ->
    gleam_otp_external:application_stopped().

-file("/Users/louis/src/gleam/otp/src/gleam/otp/supervisor.gleam", 457).
-spec to_erlang_start_result(
    {ok, gleam@erlang@process:subject(any())} |
        {error, gleam@otp@actor:start_error()}
) -> {ok, gleam@erlang@process:pid_()} | {error, gleam@dynamic:dynamic_()}.
to_erlang_start_result(Res) ->
    gleam@otp@actor:to_erlang_start_result(Res).
