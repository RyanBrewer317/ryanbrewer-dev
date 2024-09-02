-module(lustre@effect).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([custom/1, from/1, event/2, none/0, batch/1, map/2, perform/4]).
-export_type([effect/1, actions/1]).

-opaque effect(NQE) :: {effect, list(fun((actions(NQE)) -> nil))}.

-type actions(NQF) :: {actions,
        fun((NQF) -> nil),
        fun((binary(), gleam@json:json()) -> nil),
        fun((gleam@erlang@process:selector(NQF)) -> nil)}.

-spec custom(
    fun((fun((NQK) -> nil), fun((binary(), gleam@json:json()) -> nil), fun((gleam@erlang@process:selector(NQK)) -> nil)) -> nil)
) -> effect(NQK).
custom(Run) ->
    {effect,
        [fun(Actions) ->
                Run(
                    erlang:element(2, Actions),
                    erlang:element(3, Actions),
                    erlang:element(4, Actions)
                )
            end]}.

-spec from(fun((fun((NQG) -> nil)) -> nil)) -> effect(NQG).
from(Effect) ->
    custom(fun(Dispatch, _, _) -> Effect(Dispatch) end).

-spec event(binary(), gleam@json:json()) -> effect(any()).
event(Name, Data) ->
    custom(fun(_, Emit, _) -> Emit(Name, Data) end).

-spec none() -> effect(any()).
none() ->
    {effect, []}.

-spec batch(list(effect(NQP))) -> effect(NQP).
batch(Effects) ->
    {effect,
        (gleam@list:fold(
            Effects,
            [],
            fun(B, _use1) ->
                {effect, A} = _use1,
                lists:append(B, A)
            end
        ))}.

-spec map(effect(NQT), fun((NQT) -> NQV)) -> effect(NQV).
map(Effect, F) ->
    {effect,
        (gleam@list:map(
            erlang:element(2, Effect),
            fun(Eff) ->
                fun(Actions) ->
                    Eff(
                        {actions,
                            fun(Msg) -> (erlang:element(2, Actions))(F(Msg)) end,
                            erlang:element(3, Actions),
                            fun(Selector) ->
                                (erlang:element(4, Actions))(
                                    gleam_erlang_ffi:map_selector(Selector, F)
                                )
                            end}
                    )
                end
            end
        ))}.

-spec perform(
    effect(NQX),
    fun((NQX) -> nil),
    fun((binary(), gleam@json:json()) -> nil),
    fun((gleam@erlang@process:selector(NQX)) -> nil)
) -> nil.
perform(Effect, Dispatch, Emit, Select) ->
    Actions = {actions, Dispatch, Emit, Select},
    gleam@list:each(erlang:element(2, Effect), fun(Eff) -> Eff(Actions) end).
