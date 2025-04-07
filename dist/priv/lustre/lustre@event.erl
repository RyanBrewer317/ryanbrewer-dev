-module(lustre@event).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([emit/2, on/2, on_click/1, on_mouse_down/1, on_mouse_up/1, on_mouse_enter/1, on_mouse_leave/1, on_mouse_over/1, on_mouse_out/1, on_keypress/1, on_keydown/1, on_keyup/1, on_focus/1, on_blur/1, value/1, on_input/1, checked/1, on_check/1, mouse_position/1, prevent_default/1, on_submit/1, stop_propagation/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-file("src/lustre/event.gleam", 22).
?DOC(
    " Dispatches a custom message from a Lustre component. This lets components\n"
    " communicate with their parents the same way native DOM elements do.\n"
    "\n"
    " Any JSON-serialisable payload can be attached as additional data for any\n"
    " event listeners to decode. This data will be on the event's `detail` property.\n"
).
-spec emit(binary(), gleam@json:json()) -> lustre@effect:effect(any()).
emit(Event, Data) ->
    lustre@effect:event(Event, Data).

-file("src/lustre/event.gleam", 36).
?DOC(
    " Listens for the given event and applies the handler to the event object. If\n"
    " the handler returns an `Ok` the resulting message will be dispatched, otherwise\n"
    " the event (and any decoding error) will be ignored.\n"
    "\n"
    " The event name is typically an all-lowercase string such as \"click\" or \"mousemove\".\n"
    " If you're listening for non-standard events (like those emitted by a custom\n"
    " element) their event names might be slightly different.\n"
).
-spec on(
    binary(),
    fun((gleam@dynamic:dynamic_()) -> {ok, SVW} |
        {error, list(gleam@dynamic:decode_error())})
) -> lustre@internals@vdom:attribute(SVW).
on(Name, Handler) ->
    lustre@attribute:on(Name, Handler).

-file("src/lustre/event.gleam", 43).
?DOC("\n").
-spec on_click(SVZ) -> lustre@internals@vdom:attribute(SVZ).
on_click(Msg) ->
    on(<<"click"/utf8>>, fun(_) -> {ok, Msg} end).

-file("src/lustre/event.gleam", 49).
?DOC("\n").
-spec on_mouse_down(SWB) -> lustre@internals@vdom:attribute(SWB).
on_mouse_down(Msg) ->
    on(<<"mousedown"/utf8>>, fun(_) -> {ok, Msg} end).

-file("src/lustre/event.gleam", 55).
?DOC("\n").
-spec on_mouse_up(SWD) -> lustre@internals@vdom:attribute(SWD).
on_mouse_up(Msg) ->
    on(<<"mouseup"/utf8>>, fun(_) -> {ok, Msg} end).

-file("src/lustre/event.gleam", 61).
?DOC("\n").
-spec on_mouse_enter(SWF) -> lustre@internals@vdom:attribute(SWF).
on_mouse_enter(Msg) ->
    on(<<"mouseenter"/utf8>>, fun(_) -> {ok, Msg} end).

-file("src/lustre/event.gleam", 67).
?DOC("\n").
-spec on_mouse_leave(SWH) -> lustre@internals@vdom:attribute(SWH).
on_mouse_leave(Msg) ->
    on(<<"mouseleave"/utf8>>, fun(_) -> {ok, Msg} end).

-file("src/lustre/event.gleam", 73).
?DOC("\n").
-spec on_mouse_over(SWJ) -> lustre@internals@vdom:attribute(SWJ).
on_mouse_over(Msg) ->
    on(<<"mouseover"/utf8>>, fun(_) -> {ok, Msg} end).

-file("src/lustre/event.gleam", 79).
?DOC("\n").
-spec on_mouse_out(SWL) -> lustre@internals@vdom:attribute(SWL).
on_mouse_out(Msg) ->
    on(<<"mouseout"/utf8>>, fun(_) -> {ok, Msg} end).

-file("src/lustre/event.gleam", 89).
?DOC(
    " Listens for key presses on an element, and dispatches a message with the\n"
    " current key being pressed.\n"
).
-spec on_keypress(fun((binary()) -> SWN)) -> lustre@internals@vdom:attribute(SWN).
on_keypress(Msg) ->
    on(<<"keypress"/utf8>>, fun(Event) -> _pipe = Event,
            _pipe@1 = (gleam@dynamic:field(
                <<"key"/utf8>>,
                fun gleam@dynamic:string/1
            ))(_pipe),
            gleam@result:map(_pipe@1, Msg) end).

-file("src/lustre/event.gleam", 100).
?DOC(
    " Listens for key down events on an element, and dispatches a message with the\n"
    " current key being pressed.\n"
).
-spec on_keydown(fun((binary()) -> SWP)) -> lustre@internals@vdom:attribute(SWP).
on_keydown(Msg) ->
    on(<<"keydown"/utf8>>, fun(Event) -> _pipe = Event,
            _pipe@1 = (gleam@dynamic:field(
                <<"key"/utf8>>,
                fun gleam@dynamic:string/1
            ))(_pipe),
            gleam@result:map(_pipe@1, Msg) end).

-file("src/lustre/event.gleam", 111).
?DOC(
    " Listens for key up events on an element, and dispatches a message with the\n"
    " current key being released.\n"
).
-spec on_keyup(fun((binary()) -> SWR)) -> lustre@internals@vdom:attribute(SWR).
on_keyup(Msg) ->
    on(<<"keyup"/utf8>>, fun(Event) -> _pipe = Event,
            _pipe@1 = (gleam@dynamic:field(
                <<"key"/utf8>>,
                fun gleam@dynamic:string/1
            ))(_pipe),
            gleam@result:map(_pipe@1, Msg) end).

-file("src/lustre/event.gleam", 149).
-spec on_focus(SWZ) -> lustre@internals@vdom:attribute(SWZ).
on_focus(Msg) ->
    on(<<"focus"/utf8>>, fun(_) -> {ok, Msg} end).

-file("src/lustre/event.gleam", 154).
-spec on_blur(SXB) -> lustre@internals@vdom:attribute(SXB).
on_blur(Msg) ->
    on(<<"blur"/utf8>>, fun(_) -> {ok, Msg} end).

-file("src/lustre/event.gleam", 165).
?DOC(
    " Decoding an input element's `value` is such a common operation that we have\n"
    " a dedicated decoder for it. This attempts to decoder `event.target.value` as\n"
    " a string.\n"
).
-spec value(gleam@dynamic:dynamic_()) -> {ok, binary()} |
    {error, list(gleam@dynamic:decode_error())}.
value(Event) ->
    _pipe = Event,
    (gleam@dynamic:field(
        <<"target"/utf8>>,
        gleam@dynamic:field(<<"value"/utf8>>, fun gleam@dynamic:string/1)
    ))(_pipe).

-file("src/lustre/event.gleam", 122).
?DOC("\n").
-spec on_input(fun((binary()) -> SWT)) -> lustre@internals@vdom:attribute(SWT).
on_input(Msg) ->
    on(<<"input"/utf8>>, fun(Event) -> _pipe = value(Event),
            gleam@result:map(_pipe, Msg) end).

-file("src/lustre/event.gleam", 174).
?DOC(
    " Similar to [`value`](#value), decoding a checkbox's `checked` state is common\n"
    " enough to warrant a dedicated decoder. This attempts to decode\n"
    " `event.target.checked` as a boolean.\n"
).
-spec checked(gleam@dynamic:dynamic_()) -> {ok, boolean()} |
    {error, list(gleam@dynamic:decode_error())}.
checked(Event) ->
    _pipe = Event,
    (gleam@dynamic:field(
        <<"target"/utf8>>,
        gleam@dynamic:field(<<"checked"/utf8>>, fun gleam@dynamic:bool/1)
    ))(_pipe).

-file("src/lustre/event.gleam", 129).
-spec on_check(fun((boolean()) -> SWV)) -> lustre@internals@vdom:attribute(SWV).
on_check(Msg) ->
    on(<<"change"/utf8>>, fun(Event) -> _pipe = checked(Event),
            gleam@result:map(_pipe, Msg) end).

-file("src/lustre/event.gleam", 182).
?DOC(
    " Decodes the mouse position from any event that has a `clientX` and `clientY`\n"
    " property.\n"
).
-spec mouse_position(gleam@dynamic:dynamic_()) -> {ok, {float(), float()}} |
    {error, list(gleam@dynamic:decode_error())}.
mouse_position(Event) ->
    gleam@result:then(
        (gleam@dynamic:field(<<"clientX"/utf8>>, fun gleam@dynamic:float/1))(
            Event
        ),
        fun(X) ->
            gleam@result:then(
                (gleam@dynamic:field(
                    <<"clientY"/utf8>>,
                    fun gleam@dynamic:float/1
                ))(Event),
                fun(Y) -> {ok, {X, Y}} end
            )
        end
    ).

-file("src/lustre/event.gleam", 201).
?DOC(
    " Calls an event's `preventDefault` method. If the `Dynamic` does not have a\n"
    " `preventDefault` method, this function does nothing.\n"
    "\n"
    " As the name implies, `preventDefault` will prevent any default action associated\n"
    " with an event from occuring. For example, if you call `preventDefault` on a\n"
    " `submit` event, the form will not be submitted.\n"
    "\n"
    " See: https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault\n"
).
-spec prevent_default(gleam@dynamic:dynamic_()) -> nil.
prevent_default(_) ->
    nil.

-file("src/lustre/event.gleam", 140).
?DOC(
    " Listens for the form's `submit` event, and dispatches the given message. This\n"
    " will automatically call [`prevent_default`](#prevent_default) to stop the form\n"
    " from submitting.\n"
).
-spec on_submit(SWX) -> lustre@internals@vdom:attribute(SWX).
on_submit(Msg) ->
    on(
        <<"submit"/utf8>>,
        fun(Event) ->
            _ = prevent_default(Event),
            {ok, Msg}
        end
    ).

-file("src/lustre/event.gleam", 215).
?DOC(
    " Calls an event's `stopPropagation` method. If the `Dynamic` does not have a\n"
    " `stopPropagation` method, this function does nothing.\n"
    "\n"
    " Stopping event propagation means the event will not \"bubble\" up to parent\n"
    " elements. If any elements higher up in the DOM have event listeners for the\n"
    " same event, they will not be called.\n"
    "\n"
    " See: https://developer.mozilla.org/en-US/docs/Web/API/Event/stopPropagation\n"
).
-spec stop_propagation(gleam@dynamic:dynamic_()) -> nil.
stop_propagation(_) ->
    nil.
