-module(gleam@otp@supervision).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/gleam/otp/supervision.gleam").
-export([worker/1, supervisor/1, significant/2, timeout/2, restart/2, map_data/2]).
-export_type([restart/0, child_type/0, child_specification/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-type restart() :: permanent | transient | temporary.

-type child_type() :: {worker, integer()} | supervisor.

-type child_specification(EYN) :: {child_specification,
        fun(() -> {ok, gleam@otp@actor:started(EYN)} |
            {error, gleam@otp@actor:start_error()}),
        restart(),
        boolean(),
        child_type()}.

-file("src/gleam/otp/supervision.gleam", 58).
?DOC(
    " A regular child process.\n"
    "\n"
    " You should use this unless your process is also a supervisor.\n"
).
-spec worker(
    fun(() -> {ok, gleam@otp@actor:started(EYO)} |
        {error, gleam@otp@actor:start_error()})
) -> child_specification(EYO).
worker(Start) ->
    {child_specification, Start, permanent, false, {worker, 5000}}.

-file("src/gleam/otp/supervision.gleam", 71).
?DOC(" A special child that is a supervisor itself.\n").
-spec supervisor(
    fun(() -> {ok, gleam@otp@actor:started(EYT)} |
        {error, gleam@otp@actor:start_error()})
) -> child_specification(EYT).
supervisor(Start) ->
    {child_specification, Start, permanent, false, supervisor}.

-file("src/gleam/otp/supervision.gleam", 91).
?DOC(
    " This defines if a child is considered significant for automatic\n"
    " self-shutdown of the supervisor.\n"
    "\n"
    " You most likely do not want to consider any children significant.\n"
    "\n"
    " This will be ignored if the supervisor auto shutdown is set to `Never`,\n"
    " which is the default.\n"
    "\n"
    " The default value for significance is `False`.\n"
).
-spec significant(child_specification(EYY), boolean()) -> child_specification(EYY).
significant(Child, Significant) ->
    {child_specification,
        erlang:element(2, Child),
        erlang:element(3, Child),
        Significant,
        erlang:element(5, Child)}.

-file("src/gleam/otp/supervision.gleam", 105).
?DOC(
    " This defines the amount of milliseconds a child has to shut down before\n"
    " being brutal killed by the supervisor.\n"
    "\n"
    " If not set the default for a child is 5000ms.\n"
    "\n"
    " This will be ignored if the child is a supervisor itself.\n"
).
-spec timeout(child_specification(EZB), integer()) -> child_specification(EZB).
timeout(Child, Ms) ->
    case erlang:element(5, Child) of
        {worker, _} ->
            {child_specification,
                erlang:element(2, Child),
                erlang:element(3, Child),
                erlang:element(4, Child),
                {worker, Ms}};

        _ ->
            Child
    end.

-file("src/gleam/otp/supervision.gleam", 119).
?DOC(
    " When the child is to be restarted. See the `Restart` documentation for\n"
    " more.\n"
    "\n"
    " The default value for restart is `Permanent`.\n"
).
-spec restart(child_specification(EZE), restart()) -> child_specification(EZE).
restart(Child, Restart) ->
    {child_specification,
        erlang:element(2, Child),
        Restart,
        erlang:element(4, Child),
        erlang:element(5, Child)}.

-file("src/gleam/otp/supervision.gleam", 128).
?DOC(" Transform the data of the started child process.\n").
-spec map_data(child_specification(EZH), fun((EZH) -> EZJ)) -> child_specification(EZJ).
map_data(Child, Transform) ->
    {child_specification, fun() -> case (erlang:element(2, Child))() of
                {ok, Started} ->
                    {ok,
                        {started,
                            erlang:element(2, Started),
                            Transform(erlang:element(3, Started))}};

                {error, E} ->
                    {error, E}
            end end, erlang:element(3, Child), erlang:element(4, Child), erlang:element(
            5,
            Child
        )}.
