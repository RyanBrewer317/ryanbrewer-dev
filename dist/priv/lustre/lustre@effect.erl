-module(lustre@effect).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).
-define(FILEPATH, "src/lustre/effect.gleam").
-export([map/2, perform/6, none/0, from/1, before_paint/1, after_paint/1, event/2, select/1, provide/2, batch/1]).
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
    " ## Related packages\n"
    "\n"
    " While Lustre doesn't include many built-in effects, there are a number of\n"
    " community packages define useful common effects for your applications.\n"
    "\n"
    " - [`rsvp`](https://hexdocs.pm/rsvp) – Send HTTP requests from Lustre\n"
    "   applications and server components.\n"
    "\n"
    " - [`modem`](https://hexdocs.pm/modem) – A friendly Lustre package to help\n"
    "   you build a router, handle links, and manage URLs.\n"
    "\n"
    "  - [`plinth`](https://hexdocs.pm/plinth) – Bindings to Node.js and browser\n"
    "    platform APIs. (This package does not include any effects directly, but\n"
    "    it does provide bindings to many APIs that you can use to create your\n"
    "    own.)\n"
    "\n"
    " ## Examples\n"
    "\n"
    " For folks coming from other languages (or other Gleam code!) where side\n"
    " effects are often performed in-place, this can feel a bit strange. We have\n"
    " a category of example apps dedicated to showing various effects in action:\n"
    "\n"
    " - [HTTP requests](https://github.com/lustre-labs/lustre/tree/main/examples/03-effects/01-http-requests)\n"
    "\n"
    " - [Generating random values](https://github.com/lustre-labs/lustre/tree/main/examples/03-effects/02-random)\n"
    "\n"
    " - [Setting up timers](https://github.com/lustre-labs/lustre/tree/main/examples/03-effects/03-timers)\n"
    "\n"
    " - [Working with LocalStorage](https://github.com/lustre-labs/lustre/tree/main/examples/03-effects/04-local-storage)\n"
    "\n"
    " - [Reading from the DOM](https://github.com/lustre-labs/lustre/tree/main/examples/03-effects/05-dom-effects)\n"
    "\n"
    " - [Optimistic state updates](https://github.com/lustre-labs/lustre/tree/main/examples/03-effects/06-optimistic-requests)\n"
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
).

-opaque effect(NQB) :: {effect,
        list(fun((actions(NQB)) -> nil)),
        list(fun((actions(NQB)) -> nil)),
        list(fun((actions(NQB)) -> nil))}.

-type actions(NQC) :: {actions,
        fun((NQC) -> nil),
        fun((binary(), gleam@json:json()) -> nil),
        fun((gleam@erlang@process:selector(NQC)) -> nil),
        fun(() -> gleam@dynamic:dynamic_()),
        fun((binary(), gleam@json:json()) -> nil)}.

-file("src/lustre/effect.gleam", 307).
-spec do_comap_select(
    actions(NRM),
    gleam@erlang@process:selector(NRO),
    fun((NRO) -> NRM)
) -> nil.
do_comap_select(Actions, Selector, F) ->
    (erlang:element(4, Actions))(gleam_erlang_ffi:map_selector(Selector, F)).

-file("src/lustre/effect.gleam", 296).
-spec do_comap_actions(actions(NRI), fun((NRK) -> NRI)) -> actions(NRK).
do_comap_actions(Actions, F) ->
    {actions,
        fun(Msg) -> (erlang:element(2, Actions))(F(Msg)) end,
        erlang:element(3, Actions),
        fun(Selector) -> do_comap_select(Actions, Selector, F) end,
        erlang:element(5, Actions),
        erlang:element(6, Actions)}.

-file("src/lustre/effect.gleam", 287).
-spec do_map(list(fun((actions(NRC)) -> nil)), fun((NRC) -> NRF)) -> list(fun((actions(NRF)) -> nil)).
do_map(Effects, F) ->
    gleam@list:map(
        Effects,
        fun(Effect) ->
            fun(Actions) -> Effect(do_comap_actions(Actions, F)) end
        end
    ).

-file("src/lustre/effect.gleam", 279).
?DOC(
    " Transform the result of an effect. This is useful for mapping over effects\n"
    " produced by other libraries or modules.\n"
    "\n"
    " > **Note**: Remember that effects are not _required_ to dispatch any messages.\n"
    " > Your mapping function may never be called!\n"
).
-spec map(effect(NQY), fun((NQY) -> NRA)) -> effect(NRA).
map(Effect, F) ->
    {effect,
        do_map(erlang:element(2, Effect), F),
        do_map(erlang:element(3, Effect), F),
        do_map(erlang:element(4, Effect), F)}.

-file("src/lustre/effect.gleam", 335).
?DOC(false).
-spec perform(
    effect(NRQ),
    fun((NRQ) -> nil),
    fun((binary(), gleam@json:json()) -> nil),
    fun((gleam@erlang@process:selector(NRQ)) -> nil),
    fun(() -> gleam@dynamic:dynamic_()),
    fun((binary(), gleam@json:json()) -> nil)
) -> nil.
perform(Effect, Dispatch, Emit, Select, Root, Provide) ->
    Actions = {actions, Dispatch, Emit, Select, Root, Provide},
    gleam@list:each(erlang:element(2, Effect), fun(Run) -> Run(Actions) end).

-file("src/lustre/effect.gleam", 114).
?DOC(
    " Most Lustre applications need to return a tuple of `#(model, Effect(msg))`\n"
    " from their `init` and `update` functions. If you don't want to perform any\n"
    " side effects, you can use `none` to tell the runtime there's no work to do.\n"
).
-spec none() -> effect(any()).
none() ->
    {effect, [], [], []}.

-file("src/lustre/effect.gleam", 149).
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
-spec from(fun((fun((NQF) -> nil)) -> nil)) -> effect(NQF).
from(Effect) ->
    Task = fun(Actions) ->
        Dispatch = erlang:element(2, Actions),
        Effect(Dispatch)
    end,
    _record = {effect, [], [], []},
    {effect, [Task], erlang:element(3, _record), erlang:element(4, _record)}.

-file("src/lustre/effect.gleam", 180).
?DOC(
    " Schedule a side effect that is guaranteed to run after your `view` function\n"
    " is called and the DOM has been updated, but **before** the browser has\n"
    " painted the screen. This effect is useful when you need to read from the DOM\n"
    " or perform other operations that might affect the layout of your application.\n"
    "\n"
    " In addition to the `dispatch` function, your callback will also be provided\n"
    " with root element of your app or component. This is especially useful inside\n"
    " of components, giving you a reference to the [Shadow Root](https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot).\n"
    "\n"
    " Messages dispatched immediately in this effect will trigger a second re-render\n"
    " of your application before the browser paints the screen. This let's you read\n"
    " the state of the DOM, update your model, and then render a second time with\n"
    " the additional information.\n"
    "\n"
    " > **Note**: dispatching messages synchronously in this effect can lead to\n"
    " > degraded performance if not used correctly. In the worst case you can lock\n"
    " > up the browser and prevent it from painting the screen _at all_.\n"
    "\n"
    " > **Note**: There is no concept of a \"paint\" for server components. These\n"
    " > effects will be ignored in those contexts and never run.\n"
).
-spec before_paint(fun((fun((NQH) -> nil), gleam@dynamic:dynamic_()) -> nil)) -> effect(NQH).
before_paint(Effect) ->
    Task = fun(Actions) ->
        Root = (erlang:element(5, Actions))(),
        Dispatch = erlang:element(2, Actions),
        Effect(Dispatch, Root)
    end,
    _record = {effect, [], [], []},
    {effect, erlang:element(2, _record), [Task], erlang:element(4, _record)}.

-file("src/lustre/effect.gleam", 201).
?DOC(
    " Schedule a side effect that is guaranteed to run after the browser has painted\n"
    " the screen.\n"
    "\n"
    " In addition to the `dispatch` function, your callback will also be provided\n"
    " with root element of your app or component. This is especially useful inside\n"
    " of components, giving you a reference to the [Shadow Root](https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot).\n"
    "\n"
    " > **Note**: There is no concept of a \"paint\" for server components. These\n"
    " > effects will be ignored in those contexts and never run.\n"
).
-spec after_paint(fun((fun((NQJ) -> nil), gleam@dynamic:dynamic_()) -> nil)) -> effect(NQJ).
after_paint(Effect) ->
    Task = fun(Actions) ->
        Root = (erlang:element(5, Actions))(),
        Dispatch = erlang:element(2, Actions),
        Effect(Dispatch, Root)
    end,
    _record = {effect, [], [], []},
    {effect, erlang:element(2, _record), erlang:element(3, _record), [Task]}.

-file("src/lustre/effect.gleam", 218).
?DOC(false).
-spec event(binary(), gleam@json:json()) -> effect(any()).
event(Name, Data) ->
    Task = fun(Actions) -> (erlang:element(3, Actions))(Name, Data) end,
    _record = {effect, [], [], []},
    {effect, [Task], erlang:element(3, _record), erlang:element(4, _record)}.

-file("src/lustre/effect.gleam", 226).
?DOC(false).
-spec select(
    fun((fun((NQN) -> nil), gleam@erlang@process:subject(any())) -> gleam@erlang@process:selector(NQN))
) -> effect(NQN).
select(Sel) ->
    Task = fun(Actions) ->
        Self = gleam@erlang@process:new_subject(),
        Selector = Sel(erlang:element(2, Actions), Self),
        (erlang:element(4, Actions))(Selector)
    end,
    _record = {effect, [], [], []},
    {effect, [Task], erlang:element(3, _record), erlang:element(4, _record)}.

-file("src/lustre/effect.gleam", 244).
-spec provide(binary(), gleam@json:json()) -> effect(any()).
provide(Key, Value) ->
    Task = fun(Actions) -> (erlang:element(6, Actions))(Key, Value) end,
    _record = {effect, [], [], []},
    {effect, [Task], erlang:element(3, _record), erlang:element(4, _record)}.

-file("src/lustre/effect.gleam", 264).
?DOC(
    " Batch multiple effects to be performed at the same time.\n"
    "\n"
    " > **Note**: The runtime makes no guarantees about the order on which effects\n"
    " > are performed! If you need to chain or sequence effects together, you have\n"
    " > two broad options:\n"
    " >\n"
    " > 1. Create variants of your `msg` type to represent each step in the sequence\n"
    " >    and fire off the next effect in response to the previous one.\n"
    " >\n"
    " > 2. If you're defining effects yourself, consider whether or not you can handle\n"
    " >    the sequencing inside the effect itself.\n"
).
-spec batch(list(effect(NQU))) -> effect(NQU).
batch(Effects) ->
    gleam@list:fold(
        Effects,
        {effect, [], [], []},
        fun(Acc, Eff) ->
            {effect,
                gleam@list:fold(
                    erlang:element(2, Eff),
                    erlang:element(2, Acc),
                    fun gleam@list:prepend/2
                ),
                gleam@list:fold(
                    erlang:element(3, Eff),
                    erlang:element(3, Acc),
                    fun gleam@list:prepend/2
                ),
                gleam@list:fold(
                    erlang:element(4, Eff),
                    erlang:element(4, Acc),
                    fun gleam@list:prepend/2
                )}
        end
    ).
