-module(lustre).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([application/3, element/1, simple/3, component/4, start_actor/2, start_server_component/2, register/2, dispatch/1, shutdown/0, is_browser/0, start/3, is_registered/1]).
-export_type([app/3, client_spa/0, server_component/0, error/0]).

-opaque app(QFC, QFD, QFE) :: {app,
        fun((QFC) -> {QFD, lustre@effect:effect(QFE)}),
        fun((QFD, QFE) -> {QFD, lustre@effect:effect(QFE)}),
        fun((QFD) -> lustre@internals@vdom:element(QFE)),
        gleam@option:option(gleam@dict:dict(binary(), fun((gleam@dynamic:dynamic_()) -> {ok,
                QFE} |
            {error, list(gleam@dynamic:decode_error())})))}.

-type client_spa() :: any().

-type server_component() :: any().

-type error() :: {actor_error, gleam@otp@actor:start_error()} |
    {bad_component_name, binary()} |
    {component_already_registered, binary()} |
    {element_not_found, binary()} |
    not_a_browser |
    not_erlang.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre.gleam", 328).
-spec application(
    fun((QFX) -> {QFY, lustre@effect:effect(QFZ)}),
    fun((QFY, QFZ) -> {QFY, lustre@effect:effect(QFZ)}),
    fun((QFY) -> lustre@internals@vdom:element(QFZ))
) -> app(QFX, QFY, QFZ).
application(Init, Update, View) ->
    {app, Init, Update, View, none}.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre.gleam", 293).
-spec element(lustre@internals@vdom:element(QFL)) -> app(nil, nil, QFL).
element(Html) ->
    Init = fun(_) -> {nil, lustre@effect:none()} end,
    Update = fun(_, _) -> {nil, lustre@effect:none()} end,
    View = fun(_) -> Html end,
    application(Init, Update, View).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre.gleam", 309).
-spec simple(
    fun((QFQ) -> QFR),
    fun((QFR, QFS) -> QFR),
    fun((QFR) -> lustre@internals@vdom:element(QFS))
) -> app(QFQ, QFR, QFS).
simple(Init, Update, View) ->
    Init@1 = fun(Flags) -> {Init(Flags), lustre@effect:none()} end,
    Update@1 = fun(Model, Msg) -> {Update(Model, Msg), lustre@effect:none()} end,
    application(Init@1, Update@1, View).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre.gleam", 354).
-spec component(
    fun((QGG) -> {QGH, lustre@effect:effect(QGI)}),
    fun((QGH, QGI) -> {QGH, lustre@effect:effect(QGI)}),
    fun((QGH) -> lustre@internals@vdom:element(QGI)),
    gleam@dict:dict(binary(), fun((gleam@dynamic:dynamic_()) -> {ok, QGI} |
        {error, list(gleam@dynamic:decode_error())}))
) -> app(QGG, QGH, QGI).
component(Init, Update, View, On_attribute_change) ->
    {app, Init, Update, View, {some, On_attribute_change}}.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre.gleam", 387).
-spec do_start(app(QHC, any(), QHE), binary(), QHC) -> {ok,
        fun((lustre@internals@runtime:action(QHE, client_spa())) -> nil)} |
    {error, error()}.
do_start(_, _, _) ->
    {error, not_a_browser}.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre.gleam", 444).
-spec do_start_actor(app(QIH, any(), QIJ), QIH) -> {ok,
        gleam@erlang@process:subject(lustre@internals@runtime:action(QIJ, server_component()))} |
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

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre.gleam", 431).
-spec start_actor(app(QHW, any(), QHY), QHW) -> {ok,
        gleam@erlang@process:subject(lustre@internals@runtime:action(QHY, server_component()))} |
    {error, error()}.
start_actor(App, Flags) ->
    do_start_actor(App, Flags).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre.gleam", 413).
-spec start_server_component(app(QHM, any(), QHO), QHM) -> {ok,
        fun((lustre@internals@runtime:action(QHO, server_component())) -> nil)} |
    {error, error()}.
start_server_component(App, Flags) ->
    gleam@result:map(
        start_actor(App, Flags),
        fun(Runtime) ->
            fun(_capture) -> gleam@otp@actor:send(Runtime, _capture) end
        end
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre.gleam", 477).
-spec register(app(nil, any(), any()), binary()) -> {ok, nil} | {error, error()}.
register(_, _) ->
    {error, not_a_browser}.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre.gleam", 490).
-spec dispatch(QIZ) -> lustre@internals@runtime:action(QIZ, any()).
dispatch(Msg) ->
    {dispatch, Msg}.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre.gleam", 499).
-spec shutdown() -> lustre@internals@runtime:action(any(), any()).
shutdown() ->
    shutdown.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre.gleam", 514).
-spec is_browser() -> boolean().
is_browser() ->
    false.

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre.gleam", 377).
-spec start(app(QGS, any(), QGU), binary(), QGS) -> {ok,
        fun((lustre@internals@runtime:action(QGU, client_spa())) -> nil)} |
    {error, error()}.
start(App, Selector, Flags) ->
    gleam@bool:guard(
        not is_browser(),
        {error, not_a_browser},
        fun() -> do_start(App, Selector, Flags) end
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre.gleam", 523).
-spec is_registered(binary()) -> boolean().
is_registered(_) ->
    false.
