-module(lustre@internals@runtime).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([start/4]).
-export_type([state/3, action/2, debug_action/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-type state(PWM, PWN, PWO) :: {state,
        gleam@erlang@process:subject(action(PWN, PWO)),
        gleam@erlang@process:selector(action(PWN, PWO)),
        PWM,
        fun((PWM, PWN) -> {PWM, lustre@effect:effect(PWN)}),
        fun((PWM) -> lustre@internals@vdom:element(PWN)),
        lustre@internals@vdom:element(PWN),
        gleam@dict:dict(binary(), fun((lustre@internals@patch:patch(PWN)) -> nil)),
        gleam@dict:dict(binary(), fun((gleam@dynamic:dynamic_()) -> {ok, PWN} |
            {error, list(gleam@dynamic:decode_error())})),
        gleam@dict:dict(binary(), fun((gleam@dynamic:dynamic_()) -> {ok, PWN} |
            {error, list(gleam@dynamic:decode_error())}))}.

-type action(PWP, PWQ) :: {attrs, list({binary(), gleam@dynamic:dynamic_()})} |
    {batch, list(PWP), lustre@effect:effect(PWP)} |
    {debug, debug_action()} |
    {dispatch, PWP} |
    {emit, binary(), gleam@json:json()} |
    {event, binary(), gleam@dynamic:dynamic_()} |
    {set_selector, gleam@erlang@process:selector(PWP)} |
    shutdown |
    {subscribe, binary(), fun((lustre@internals@patch:patch(PWP)) -> nil)} |
    {unsubscribe, binary()} |
    {gleam_phantom, PWQ}.

-type debug_action() :: {force_model, gleam@dynamic:dynamic_()} |
    {model, fun((gleam@dynamic:dynamic_()) -> nil)} |
    {view,
        fun((lustre@internals@vdom:element(gleam@dynamic:dynamic_())) -> nil)}.

-file("src/lustre/internals/runtime.gleam", 234).
?DOC(false).
-spec run_renderers(
    gleam@dict:dict(any(), fun((lustre@internals@patch:patch(PXV)) -> nil)),
    lustre@internals@patch:patch(PXV)
) -> nil.
run_renderers(Renderers, Patch) ->
    gleam@dict:fold(Renderers, nil, fun(_, _, Renderer) -> Renderer(Patch) end).

-file("src/lustre/internals/runtime.gleam", 243).
?DOC(false).
-spec run_effects(
    lustre@effect:effect(PYA),
    gleam@erlang@process:subject(action(PYA, any()))
) -> nil.
run_effects(Effects, Self) ->
    Dispatch = fun(Msg) -> gleam@otp@actor:send(Self, {dispatch, Msg}) end,
    Emit = fun(Name, Event) ->
        gleam@otp@actor:send(Self, {emit, Name, Event})
    end,
    Select = fun(Selector) ->
        gleam@otp@actor:send(Self, {set_selector, Selector})
    end,
    Root = lustre_escape_ffi:coerce(nil),
    lustre@effect:perform(Effects, Dispatch, Emit, Select, Root).

-file("src/lustre/internals/runtime.gleam", 94).
?DOC(false).
-spec loop(action(PXF, PXG), state(PXJ, PXF, PXG)) -> gleam@otp@actor:next(action(PXF, PXG), state(PXJ, PXF, PXG)).
loop(Message, State) ->
    case Message of
        {attrs, Attrs} ->
            _pipe@1 = gleam@list:filter_map(
                Attrs,
                fun(Attr) ->
                    case gleam_stdlib:map_get(
                        erlang:element(10, State),
                        erlang:element(1, Attr)
                    ) of
                        {error, _} ->
                            {error, nil};

                        {ok, Decoder} ->
                            _pipe = Decoder(erlang:element(2, Attr)),
                            gleam@result:replace_error(_pipe, nil)
                    end
                end
            ),
            _pipe@2 = {batch, _pipe@1, lustre@effect:none()},
            loop(_pipe@2, State);

        {batch, [], _} ->
            gleam@otp@actor:continue(State);

        {batch, [Msg], Other_effects} ->
            {Model, Effects} = (erlang:element(5, State))(
                erlang:element(4, State),
                Msg
            ),
            Html = (erlang:element(6, State))(Model),
            Diff = lustre@internals@patch:elements(
                erlang:element(7, State),
                Html
            ),
            Next = begin
                _record = State,
                {state,
                    erlang:element(2, _record),
                    erlang:element(3, _record),
                    Model,
                    erlang:element(5, _record),
                    erlang:element(6, _record),
                    Html,
                    erlang:element(8, _record),
                    erlang:element(5, Diff),
                    erlang:element(10, _record)}
            end,
            run_effects(
                lustre@effect:batch([Effects, Other_effects]),
                erlang:element(2, State)
            ),
            case lustre@internals@patch:is_empty_element_diff(Diff) of
                true ->
                    nil;

                false ->
                    run_renderers(erlang:element(8, State), {diff, Diff})
            end,
            gleam@otp@actor:continue(Next);

        {batch, [Msg@1 | Rest], Other_effects@1} ->
            {Model@1, Effects@1} = (erlang:element(5, State))(
                erlang:element(4, State),
                Msg@1
            ),
            Html@1 = (erlang:element(6, State))(Model@1),
            Diff@1 = lustre@internals@patch:elements(
                erlang:element(7, State),
                Html@1
            ),
            Next@1 = begin
                _record@1 = State,
                {state,
                    erlang:element(2, _record@1),
                    erlang:element(3, _record@1),
                    Model@1,
                    erlang:element(5, _record@1),
                    erlang:element(6, _record@1),
                    Html@1,
                    erlang:element(8, _record@1),
                    erlang:element(5, Diff@1),
                    erlang:element(10, _record@1)}
            end,
            loop(
                {batch, Rest, lustre@effect:batch([Effects@1, Other_effects@1])},
                Next@1
            );

        {debug, {force_model, Model@2}} ->
            Model@3 = lustre_escape_ffi:coerce(Model@2),
            Html@2 = (erlang:element(6, State))(Model@3),
            Diff@2 = lustre@internals@patch:elements(
                erlang:element(7, State),
                Html@2
            ),
            Next@2 = begin
                _record@2 = State,
                {state,
                    erlang:element(2, _record@2),
                    erlang:element(3, _record@2),
                    Model@3,
                    erlang:element(5, _record@2),
                    erlang:element(6, _record@2),
                    Html@2,
                    erlang:element(8, _record@2),
                    erlang:element(5, Diff@2),
                    erlang:element(10, _record@2)}
            end,
            case lustre@internals@patch:is_empty_element_diff(Diff@2) of
                true ->
                    nil;

                false ->
                    run_renderers(erlang:element(8, State), {diff, Diff@2})
            end,
            gleam@otp@actor:continue(Next@2);

        {debug, {model, Reply}} ->
            Reply(gleam_stdlib:identity(erlang:element(4, State))),
            gleam@otp@actor:continue(State);

        {debug, {view, Reply@1}} ->
            Reply@1(
                lustre@element:map(
                    erlang:element(7, State),
                    fun gleam_stdlib:identity/1
                )
            ),
            gleam@otp@actor:continue(State);

        {dispatch, Msg@2} ->
            {Model@4, Effects@2} = (erlang:element(5, State))(
                erlang:element(4, State),
                Msg@2
            ),
            Html@3 = (erlang:element(6, State))(Model@4),
            Diff@3 = lustre@internals@patch:elements(
                erlang:element(7, State),
                Html@3
            ),
            Next@3 = begin
                _record@3 = State,
                {state,
                    erlang:element(2, _record@3),
                    erlang:element(3, _record@3),
                    Model@4,
                    erlang:element(5, _record@3),
                    erlang:element(6, _record@3),
                    Html@3,
                    erlang:element(8, _record@3),
                    erlang:element(5, Diff@3),
                    erlang:element(10, _record@3)}
            end,
            run_effects(Effects@2, erlang:element(2, State)),
            case lustre@internals@patch:is_empty_element_diff(Diff@3) of
                true ->
                    nil;

                false ->
                    run_renderers(erlang:element(8, State), {diff, Diff@3})
            end,
            gleam@otp@actor:continue(Next@3);

        {emit, Name, Event} ->
            Patch = {emit, Name, Event},
            run_renderers(erlang:element(8, State), Patch),
            gleam@otp@actor:continue(State);

        {event, Name@1, Event@1} ->
            case gleam_stdlib:map_get(erlang:element(9, State), Name@1) of
                {error, _} ->
                    gleam@otp@actor:continue(State);

                {ok, Handler} ->
                    _pipe@3 = Handler(Event@1),
                    _pipe@4 = gleam@result:map(
                        _pipe@3,
                        fun(Field@0) -> {dispatch, Field@0} end
                    ),
                    _pipe@5 = gleam@result:map(
                        _pipe@4,
                        fun(_capture) ->
                            gleam@otp@actor:send(
                                erlang:element(2, State),
                                _capture
                            )
                        end
                    ),
                    gleam@result:unwrap(_pipe@5, nil),
                    gleam@otp@actor:continue(State)
            end;

        {subscribe, Id, Renderer} ->
            Renderers = gleam@dict:insert(
                erlang:element(8, State),
                Id,
                Renderer
            ),
            Next@4 = begin
                _record@4 = State,
                {state,
                    erlang:element(2, _record@4),
                    erlang:element(3, _record@4),
                    erlang:element(4, _record@4),
                    erlang:element(5, _record@4),
                    erlang:element(6, _record@4),
                    erlang:element(7, _record@4),
                    Renderers,
                    erlang:element(9, _record@4),
                    erlang:element(10, _record@4)}
            end,
            Renderer(
                {init,
                    maps:keys(erlang:element(10, State)),
                    erlang:element(7, State)}
            ),
            gleam@otp@actor:continue(Next@4);

        {unsubscribe, Id@1} ->
            Renderers@1 = gleam@dict:delete(erlang:element(8, State), Id@1),
            Next@5 = begin
                _record@5 = State,
                {state,
                    erlang:element(2, _record@5),
                    erlang:element(3, _record@5),
                    erlang:element(4, _record@5),
                    erlang:element(5, _record@5),
                    erlang:element(6, _record@5),
                    erlang:element(7, _record@5),
                    Renderers@1,
                    erlang:element(9, _record@5),
                    erlang:element(10, _record@5)}
            end,
            gleam@otp@actor:continue(Next@5);

        {set_selector, Selector} ->
            New_selector = gleam_erlang_ffi:merge_selector(
                erlang:element(3, State),
                gleam_erlang_ffi:map_selector(
                    Selector,
                    fun(Field@0) -> {dispatch, Field@0} end
                )
            ),
            {continue,
                begin
                    _record@6 = State,
                    {state,
                        erlang:element(2, _record@6),
                        New_selector,
                        erlang:element(4, _record@6),
                        erlang:element(5, _record@6),
                        erlang:element(6, _record@6),
                        erlang:element(7, _record@6),
                        erlang:element(8, _record@6),
                        erlang:element(9, _record@6),
                        erlang:element(10, _record@6)}
                end,
                {some, New_selector}};

        shutdown ->
            {stop, killed}
    end.

-file("src/lustre/internals/runtime.gleam", 60).
?DOC(false).
-spec start(
    {PWR, lustre@effect:effect(PWS)},
    fun((PWR, PWS) -> {PWR, lustre@effect:effect(PWS)}),
    fun((PWR) -> lustre@internals@vdom:element(PWS)),
    gleam@dict:dict(binary(), fun((gleam@dynamic:dynamic_()) -> {ok, PWS} |
        {error, list(gleam@dynamic:decode_error())}))
) -> {ok, gleam@erlang@process:subject(action(PWS, any()))} |
    {error, gleam@otp@actor:start_error()}.
start(Init, Update, View, On_attribute_change) ->
    Timeout = 1000,
    Init@1 = fun() ->
        Self = gleam@erlang@process:new_subject(),
        Html = View(erlang:element(1, Init)),
        Handlers = lustre@internals@vdom:handlers(Html),
        Selector = gleam@erlang@process:selecting(
            gleam_erlang_ffi:new_selector(),
            Self,
            fun(Msg) -> Msg end
        ),
        State = {state,
            Self,
            Selector,
            erlang:element(1, Init),
            Update,
            View,
            Html,
            maps:new(),
            Handlers,
            On_attribute_change},
        run_effects(erlang:element(2, Init), Self),
        {ready, State, Selector}
    end,
    gleam@otp@actor:start_spec({spec, Init@1, Timeout, fun loop/2}).
