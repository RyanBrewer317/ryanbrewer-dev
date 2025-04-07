-module(lustre@effect).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([custom/1, from/1, event/2, none/0, batch/1, map/2, perform/5]).
-export_type([effect/1, actions/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " In other frameworks it's common for components to perform side effects\n"
    " whenever the need them. An event handler might make an HTTP request, or a\n"
    " component might reach into the DOM to focus an input.\n"
    "\n"
    " In Lustre we try to keep side effects separate from our main program loop.\n"
    " This comes with a whole bunch of benefits like making it easier to test and\n"
    " reason about our code, making it possible to implement time-travel debugging,\n"
    " or even to run our app on the server using Lustre's server components. This\n"
    " is great but we still need to perform side effects at some point, so how do\n"
    " we do that?\n"
    "\n"
    " The answer is through the `Effect` type that treats side effects as *data*.\n"
    " This approach is known as having **managed effects**: you pass data that\n"
    " describes a side effect to Lustre's runtime and it takes care of performing\n"
    " that effect and potentially sending messages back to your program for you.\n"
    " By going through this abstraction we discourage side effects from being\n"
    " performed in the middle of our program.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " For folks coming from other languages (or other Gleam code!) where side\n"
    " effects are often performed in-place, this can feel a bit strange. A couple\n"
    " of the examples in the repo tackle effects:\n"
    "\n"
    " - [`05-http-requests`](https://github.com/lustre-labs/lustre/tree/main/examples/05-http-requests)\n"
    " - [`06-custom-effects`](https://github.com/lustre-labs/lustre/tree/main/examples/06-custom-effects)\n"
    "\n"
    " This list of examples is likely to grow over time, so be sure to check back\n"
    " every now and then to see what's new!\n"
    "\n"
    " ## Getting help\n"
    "\n"
    " If you're having trouble with Lustre or not sure what the right way to do\n"
    " something is, the best place to get help is the [Gleam Discord server](https://discord.gg/Fm8Pwmy).\n"
    " You could also open an issue on the [Lustre GitHub repository](https://github.com/lustre-labs/lustre/issues).\n"
    "\n"
    " While our docs are still a work in progress, the official [Elm guide](https://guide.elm-lang.org)\n"
    " is also a great resource for learning about the Model-View-Update architecture\n"
    " and the kinds of patterns that Lustre is built around.\n"
    "\n"
).

-opaque effect(NXX) :: {effect, list(fun((actions(NXX)) -> nil))}.

-type actions(NXY) :: {actions,
        fun((NXY) -> nil),
        fun((binary(), gleam@json:json()) -> nil),
        fun((gleam@erlang@process:selector(NXY)) -> nil),
        gleam@dynamic:dynamic_()}.

-file("src/lustre/effect.gleam", 126).
?DOC(false).
-spec custom(
    fun((fun((NYD) -> nil), fun((binary(), gleam@json:json()) -> nil), fun((gleam@erlang@process:selector(NYD)) -> nil), gleam@dynamic:dynamic_()) -> nil)
) -> effect(NYD).
custom(Run) ->
    {effect,
        [fun(Actions) ->
                Run(
                    erlang:element(2, Actions),
                    erlang:element(3, Actions),
                    erlang:element(4, Actions),
                    erlang:element(5, Actions)
                )
            end]}.

-file("src/lustre/effect.gleam", 105).
?DOC(
    " Construct your own reusable effect from a custom callback. This callback is\n"
    " called with a `dispatch` function you can use to send messages back to your\n"
    " application's `update` function.\n"
    "\n"
    " Example using the `window` module from the `plinth` library to dispatch a\n"
    " message on the browser window object's `\"visibilitychange\"` event.\n"
    "\n"
    " ```gleam\n"
    " import lustre/effect.{type Effect}\n"
    " import plinth/browser/window\n"
    "\n"
    " type Model {\n"
    "   Model(Int)\n"
    " }\n"
    "\n"
    " type Msg {\n"
    "   FetchState\n"
    " }\n"
    "\n"
    " fn init(_flags) -> #(Model, Effect(Msg)) {\n"
    "   #(\n"
    "     Model(0),\n"
    "     effect.from(fn(dispatch) {\n"
    "       window.add_event_listener(\"visibilitychange\", fn(_event) {\n"
    "         dispatch(FetchState)\n"
    "       })\n"
    "     }),\n"
    "   )\n"
    " }\n"
    " ```\n"
).
-spec from(fun((fun((NXZ) -> nil)) -> nil)) -> effect(NXZ).
from(Effect) ->
    custom(fun(Dispatch, _, _, _) -> Effect(Dispatch) end).

-file("src/lustre/effect.gleam", 117).
?DOC(false).
-spec event(binary(), gleam@json:json()) -> effect(any()).
event(Name, Data) ->
    custom(fun(_, Emit, _, _) -> Emit(Name, Data) end).

-file("src/lustre/effect.gleam", 146).
?DOC(
    " Most Lustre applications need to return a tuple of `#(model, Effect(msg))`\n"
    " from their `init` and `update` functions. If you don't want to perform any\n"
    " side effects, you can use `none` to tell the runtime there's no work to do.\n"
).
-spec none() -> effect(any()).
none() ->
    {effect, []}.

-file("src/lustre/effect.gleam", 164).
?DOC(
    " Batch multiple effects to be performed at the same time.\n"
    "\n"
    " **Note**: The runtime makes no guarantees about the order on which effects\n"
    " are performed! If you need to chain or sequence effects together, you have\n"
    " two broad options:\n"
    "\n"
    " 1. Create variants of your `msg` type to represent each step in the sequence\n"
    "    and fire off the next effect in response to the previous one.\n"
    "\n"
    " 2. If you're defining effects yourself, consider whether or not you can handle\n"
    "    the sequencing inside the effect itself.\n"
).
-spec batch(list(effect(NYI))) -> effect(NYI).
batch(Effects) ->
    {effect,
        begin
            gleam@list:fold(
                Effects,
                [],
                fun(B, _use1) ->
                    {effect, A} = _use1,
                    lists:append(B, A)
                end
            )
        end}.

-file("src/lustre/effect.gleam", 178).
?DOC(
    " Transform the result of an effect. This is useful for mapping over effects\n"
    " produced by other libraries or modules.\n"
    "\n"
    " **Note**: Remember that effects are not _required_ to dispatch any messages.\n"
    " Your mapping function may never be called!\n"
).
-spec map(effect(NYM), fun((NYM) -> NYO)) -> effect(NYO).
map(Effect, F) ->
    {effect,
        begin
            gleam@list:map(
                erlang:element(2, Effect),
                fun(Eff) ->
                    fun(Actions) ->
                        Eff(
                            {actions,
                                fun(Msg) ->
                                    (erlang:element(2, Actions))(F(Msg))
                                end,
                                erlang:element(3, Actions),
                                fun(Selector) ->
                                    (erlang:element(4, Actions))(
                                        gleam_erlang_ffi:map_selector(
                                            Selector,
                                            F
                                        )
                                    )
                                end,
                                erlang:element(5, Actions)}
                        )
                    end
                end
            )
        end}.

-file("src/lustre/effect.gleam", 230).
?DOC(false).
-spec perform(
    effect(NYQ),
    fun((NYQ) -> nil),
    fun((binary(), gleam@json:json()) -> nil),
    fun((gleam@erlang@process:selector(NYQ)) -> nil),
    gleam@dynamic:dynamic_()
) -> nil.
perform(Effect, Dispatch, Emit, Select, Root) ->
    Actions = {actions, Dispatch, Emit, Select, Root},
    gleam@list:each(erlang:element(2, Effect), fun(Eff) -> Eff(Actions) end).
