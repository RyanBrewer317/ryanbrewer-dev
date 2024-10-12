-module(lustre@event).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([emit/2, on/2, on_click/1, on_mouse_down/1, on_mouse_up/1, on_mouse_enter/1, on_mouse_leave/1, on_mouse_over/1, on_mouse_out/1, on_keypress/1, on_keydown/1, on_keyup/1, on_focus/1, on_blur/1, value/1, on_input/1, checked/1, on_check/1, mouse_position/1, prevent_default/1, on_submit/1, stop_propagation/1]).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 22).
-spec emit(binary(), gleam@json:json()) -> lustre@effect:effect(any()).
emit(Event, Data) ->
    lustre@effect:event(Event, Data).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 36).
-spec on(
    binary(),
    fun((gleam@dynamic:dynamic_()) -> {ok, SHG} |
        {error, list(gleam@dynamic:decode_error())})
) -> lustre@internals@vdom:attribute(SHG).
on(Name, Handler) ->
    lustre@attribute:on(Name, Handler).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 43).
-spec on_click(SHJ) -> lustre@internals@vdom:attribute(SHJ).
on_click(Msg) ->
    on(<<"click"/utf8>>, fun(_) -> {ok, Msg} end).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 49).
-spec on_mouse_down(SHL) -> lustre@internals@vdom:attribute(SHL).
on_mouse_down(Msg) ->
    on(<<"mousedown"/utf8>>, fun(_) -> {ok, Msg} end).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 55).
-spec on_mouse_up(SHN) -> lustre@internals@vdom:attribute(SHN).
on_mouse_up(Msg) ->
    on(<<"mouseup"/utf8>>, fun(_) -> {ok, Msg} end).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 61).
-spec on_mouse_enter(SHP) -> lustre@internals@vdom:attribute(SHP).
on_mouse_enter(Msg) ->
    on(<<"mouseenter"/utf8>>, fun(_) -> {ok, Msg} end).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 67).
-spec on_mouse_leave(SHR) -> lustre@internals@vdom:attribute(SHR).
on_mouse_leave(Msg) ->
    on(<<"mouseleave"/utf8>>, fun(_) -> {ok, Msg} end).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 73).
-spec on_mouse_over(SHT) -> lustre@internals@vdom:attribute(SHT).
on_mouse_over(Msg) ->
    on(<<"mouseover"/utf8>>, fun(_) -> {ok, Msg} end).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 79).
-spec on_mouse_out(SHV) -> lustre@internals@vdom:attribute(SHV).
on_mouse_out(Msg) ->
    on(<<"mouseout"/utf8>>, fun(_) -> {ok, Msg} end).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 89).
-spec on_keypress(fun((binary()) -> SHX)) -> lustre@internals@vdom:attribute(SHX).
on_keypress(Msg) ->
    on(<<"keypress"/utf8>>, fun(Event) -> _pipe = Event,
            _pipe@1 = (gleam@dynamic:field(
                <<"key"/utf8>>,
                fun gleam@dynamic:string/1
            ))(_pipe),
            gleam@result:map(_pipe@1, Msg) end).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 100).
-spec on_keydown(fun((binary()) -> SHZ)) -> lustre@internals@vdom:attribute(SHZ).
on_keydown(Msg) ->
    on(<<"keydown"/utf8>>, fun(Event) -> _pipe = Event,
            _pipe@1 = (gleam@dynamic:field(
                <<"key"/utf8>>,
                fun gleam@dynamic:string/1
            ))(_pipe),
            gleam@result:map(_pipe@1, Msg) end).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 111).
-spec on_keyup(fun((binary()) -> SIB)) -> lustre@internals@vdom:attribute(SIB).
on_keyup(Msg) ->
    on(<<"keyup"/utf8>>, fun(Event) -> _pipe = Event,
            _pipe@1 = (gleam@dynamic:field(
                <<"key"/utf8>>,
                fun gleam@dynamic:string/1
            ))(_pipe),
            gleam@result:map(_pipe@1, Msg) end).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 149).
-spec on_focus(SIJ) -> lustre@internals@vdom:attribute(SIJ).
on_focus(Msg) ->
    on(<<"focus"/utf8>>, fun(_) -> {ok, Msg} end).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 154).
-spec on_blur(SIL) -> lustre@internals@vdom:attribute(SIL).
on_blur(Msg) ->
    on(<<"blur"/utf8>>, fun(_) -> {ok, Msg} end).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 165).
-spec value(gleam@dynamic:dynamic_()) -> {ok, binary()} |
    {error, list(gleam@dynamic:decode_error())}.
value(Event) ->
    _pipe = Event,
    (gleam@dynamic:field(
        <<"target"/utf8>>,
        gleam@dynamic:field(<<"value"/utf8>>, fun gleam@dynamic:string/1)
    ))(_pipe).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 122).
-spec on_input(fun((binary()) -> SID)) -> lustre@internals@vdom:attribute(SID).
on_input(Msg) ->
    on(<<"input"/utf8>>, fun(Event) -> _pipe = value(Event),
            gleam@result:map(_pipe, Msg) end).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 174).
-spec checked(gleam@dynamic:dynamic_()) -> {ok, boolean()} |
    {error, list(gleam@dynamic:decode_error())}.
checked(Event) ->
    _pipe = Event,
    (gleam@dynamic:field(
        <<"target"/utf8>>,
        gleam@dynamic:field(<<"checked"/utf8>>, fun gleam@dynamic:bool/1)
    ))(_pipe).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 129).
-spec on_check(fun((boolean()) -> SIF)) -> lustre@internals@vdom:attribute(SIF).
on_check(Msg) ->
    on(<<"change"/utf8>>, fun(Event) -> _pipe = checked(Event),
            gleam@result:map(_pipe, Msg) end).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 182).
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

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 201).
-spec prevent_default(gleam@dynamic:dynamic_()) -> nil.
prevent_default(_) ->
    nil.

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 140).
-spec on_submit(SIH) -> lustre@internals@vdom:attribute(SIH).
on_submit(Msg) ->
    on(
        <<"submit"/utf8>>,
        fun(Event) ->
            _ = prevent_default(Event),
            {ok, Msg}
        end
    ).

-file("/home/runner/work/lustre/lustre/src/lustre/event.gleam", 215).
-spec stop_propagation(gleam@dynamic:dynamic_()) -> nil.
stop_propagation(_) ->
    nil.
