-module(lustre).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([application/3, element/1, simple/3, component/4, start_actor/2, start_server_component/2, register/2, dispatch/1, shutdown/0, is_browser/0, start/3, is_registered/1]).
-export_type([app/3, client_spa/0, server_component/0, error/0]).

-opaque app(QEK, QEL, QEM) :: {app,
        fun((QEK) -> {QEL, lustre@effect:effect(QEM)}),
        fun((QEL, QEM) -> {QEL, lustre@effect:effect(QEM)}),
        fun((QEL) -> lustre@internals@vdom:element(QEM)),
        gleam@option:option(gleam@dict:dict(binary(), fun((gleam@dynamic:dynamic_()) -> {ok,
                QEM} |
            {error, list(gleam@dynamic:decode_error())})))}.

-type client_spa() :: any().

-type server_component() :: any().

-type error() :: {actor_error, gleam@otp@actor:start_error()} |
    {bad_component_name, binary()} |
    {component_already_registered, binary()} |
    {element_not_found, binary()} |
    not_a_browser |
    not_erlang.

-file("/home/runner/work/lustre/lustre/src/lustre.gleam", 328).
-spec application(
    fun((QFF) -> {QFG, lustre@effect:effect(QFH)}),
    fun((QFG, QFH) -> {QFG, lustre@effect:effect(QFH)}),
    fun((QFG) -> lustre@internals@vdom:element(QFH))
) -> app(QFF, QFG, QFH).
application(Init, Update, View) ->
    {app, Init, Update, View, none}.

-file("/home/runner/work/lustre/lustre/src/lustre.gleam", 293).
-spec element(lustre@internals@vdom:element(QET)) -> app(nil, nil, QET).
element(Html) ->
    Init = fun(_) -> {nil, lustre@effect:none()} end,
    Update = fun(_, _) -> {nil, lustre@effect:none()} end,
    View = fun(_) -> Html end,
    application(Init, Update, View).

-file("/home/runner/work/lustre/lustre/src/lustre.gleam", 309).
-spec simple(
    fun((QEY) -> QEZ),
    fun((QEZ, QFA) -> QEZ),
    fun((QEZ) -> lustre@internals@vdom:element(QFA))
) -> app(QEY, QEZ, QFA).
simple(Init, Update, View) ->
    Init@1 = fun(Flags) -> {Init(Flags), lustre@effect:none()} end,
    Update@1 = fun(Model, Msg) -> {Update(Model, Msg), lustre@effect:none()} end,
    application(Init@1, Update@1, View).

-file("/home/runner/work/lustre/lustre/src/lustre.gleam", 354).
-spec component(
    fun((QFO) -> {QFP, lustre@effect:effect(QFQ)}),
    fun((QFP, QFQ) -> {QFP, lustre@effect:effect(QFQ)}),
    fun((QFP) -> lustre@internals@vdom:element(QFQ)),
    gleam@dict:dict(binary(), fun((gleam@dynamic:dynamic_()) -> {ok, QFQ} |
        {error, list(gleam@dynamic:decode_error())}))
) -> app(QFO, QFP, QFQ).
component(Init, Update, View, On_attribute_change) ->
    {app, Init, Update, View, {some, On_attribute_change}}.

-file("/home/runner/work/lustre/lustre/src/lustre.gleam", 387).
-spec do_start(app(QGK, any(), QGM), binary(), QGK) -> {ok,
        fun((lustre@internals@runtime:action(QGM, client_spa())) -> nil)} |
    {error, error()}.
do_start(_, _, _) ->
    {error, not_a_browser}.

-file("/home/runner/work/lustre/lustre/src/lustre.gleam", 444).
-spec do_start_actor(app(QHP, any(), QHR), QHP) -> {ok,
        gleam@erlang@process:subject(lustre@internals@runtime:action(QHR, server_component()))} |
    {error, error()}.
do_start_actor(App, Flags) ->
    On_attribute_change = gleam@option:unwrap(
        erlang:element(5, App),
        gleam@dict:new()
    ),
    _pipe = (erlang:element(2, App))(Flags),
    _pipe@1 = lustre@internals@runtime:start(
        _pipe,
        erlang:element(3, App),
        erlang:element(4, App),
        On_attribute_change
    ),
    gleam@result:map_error(_pipe@1, fun(Field@0) -> {actor_error, Field@0} end).

-file("/home/runner/work/lustre/lustre/src/lustre.gleam", 431).
-spec start_actor(app(QHE, any(), QHG), QHE) -> {ok,
        gleam@erlang@process:subject(lustre@internals@runtime:action(QHG, server_component()))} |
    {error, error()}.
start_actor(App, Flags) ->
    do_start_actor(App, Flags).

-file("/home/runner/work/lustre/lustre/src/lustre.gleam", 413).
-spec start_server_component(app(QGU, any(), QGW), QGU) -> {ok,
        fun((lustre@internals@runtime:action(QGW, server_component())) -> nil)} |
    {error, error()}.
start_server_component(App, Flags) ->
    gleam@result:map(
        start_actor(App, Flags),
        fun(Runtime) ->
            fun(_capture) -> gleam@otp@actor:send(Runtime, _capture) end
        end
    ).

-file("/home/runner/work/lustre/lustre/src/lustre.gleam", 477).
-spec register(app(nil, any(), any()), binary()) -> {ok, nil} | {error, error()}.
register(_, _) ->
    {error, not_a_browser}.

-file("/home/runner/work/lustre/lustre/src/lustre.gleam", 490).
-spec dispatch(QIH) -> lustre@internals@runtime:action(QIH, any()).
dispatch(Msg) ->
    {dispatch, Msg}.

-file("/home/runner/work/lustre/lustre/src/lustre.gleam", 499).
-spec shutdown() -> lustre@internals@runtime:action(any(), any()).
shutdown() ->
    shutdown.

-file("/home/runner/work/lustre/lustre/src/lustre.gleam", 514).
-spec is_browser() -> boolean().
is_browser() ->
    false.

-file("/home/runner/work/lustre/lustre/src/lustre.gleam", 377).
-spec start(app(QGA, any(), QGC), binary(), QGA) -> {ok,
        fun((lustre@internals@runtime:action(QGC, client_spa())) -> nil)} |
    {error, error()}.
start(App, Selector, Flags) ->
    gleam@bool:guard(
        not is_browser(),
        {error, not_a_browser},
        fun() -> do_start(App, Selector, Flags) end
    ).

-file("/home/runner/work/lustre/lustre/src/lustre.gleam", 523).
-spec is_registered(binary()) -> boolean().
is_registered(_) ->
    false.
