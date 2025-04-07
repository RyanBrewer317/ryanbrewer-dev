-module(lustre).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([application/3, element/1, simple/3, component/4, start_actor/2, start_server_component/2, register/2, dispatch/1, shutdown/0, is_browser/0, start/3, is_registered/1]).
-export_type([app/3, client_spa/0, server_component/0, error/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " Lustre is a framework for rendering Web applications and components using\n"
    " Gleam. This module contains the core API for constructing and communicating\n"
    " with Lustre applications. If you're new to Lustre or frontend development in\n"
    " general, make sure you check out the [examples](https://github.com/lustre-labs/lustre/tree/main/examples)\n"
    " or the [quickstart guide](./guide/01-quickstart.html) to get up to speed!\n"
    "\n"
    " Lustre currently has three kinds of application:\n"
    "\n"
    " 1. A client-side single-page application: think Elm or React or Vue. These\n"
    "    are applications that run in the client's browser and are responsible for\n"
    "    rendering the entire page.\n"
    "\n"
    " 2. A client-side component: an encapsulated Lustre application that can be\n"
    "    rendered inside another Lustre application as a Web Component. Communication\n"
    "    happens via attributes and event listeners, like any other encapsulated\n"
    "    HTML element.\n"
    "\n"
    " 3. A server component. These are applications that run anywhere Gleam runs\n"
    "    and communicate with any number of connected clients by sending them\n"
    "    patches to apply to their DOM.\n"
    "\n"
    "    There are two pieces to a server component: the main server component\n"
    "    runtime that contains your application logic, and a client-side runtime\n"
    "    that listens for patches over a WebSocket and applies them to the DOM.\n"
    "\n"
    "    The server component runtime can run anywhere Gleam does, but the\n"
    "    client-side runtime must be run in a browser. To use it either render the\n"
    "    [provided script element](./lustre/server_component.html#script) or use the script files\n"
    "    from Lustre's `priv/` directory directly.\n"
    "\n"
    " No matter where a Lustre application runs, it will always follow the same\n"
    " Model-View-Update architecture. Popularised by Elm (where it is known as The\n"
    " Elm Architecture), this pattern has since made its way into many other\n"
    " languages and frameworks and has proven to be a robust and reliable way to\n"
    " build complex user interfaces.\n"
    "\n"
    " There are three main building blocks to the Model-View-Update architecture:\n"
    "\n"
    " - A `Model` that represents your application's state and an `init` function\n"
    "   to create it.\n"
    "\n"
    " - A `Msg` type that represents all the different ways the outside world can\n"
    "   communicate with your application and an `update` function that modifies\n"
    "   your model in response to those messages.\n"
    "\n"
    " - A `view` function that renders your model to HTML, represented as an\n"
    "   `Element`.\n"
    "\n"
    " To see how those pieces fit together, here's a little diagram:\n"
    "\n"
    " ```text\n"
    "                                          +--------+\n"
    "                                          |        |\n"
    "                                          | update |\n"
    "                                          |        |\n"
    "                                          +--------+\n"
    "                                            ^    |\n"
    "                                            |    |\n"
    "                                        Msg |    | #(Model, Effect(Msg))\n"
    "                                            |    |\n"
    "                                            |    v\n"
    " +------+                         +------------------------+\n"
    " |      |  #(Model, Effect(Msg))  |                        |\n"
    " | init |------------------------>|     Lustre Runtime     |\n"
    " |      |                         |                        |\n"
    " +------+                         +------------------------+\n"
    "                                            ^    |\n"
    "                                            |    |\n"
    "                                        Msg |    | Model\n"
    "                                            |    |\n"
    "                                            |    v\n"
    "                                          +--------+\n"
    "                                          |        |\n"
    "                                          |  view  |\n"
    "                                          |        |\n"
    "                                          +--------+\n"
    " ```\n"
    "\n"
    " The `Effect` type here encompasses things like HTTP requests and other kinds\n"
    " of communication with the \"outside world\". You can read more about effects\n"
    " and their purpose in the [`effect`](./effect.html) module.\n"
    "\n"
    " For many kinds of apps, you can take these three building blocks and put\n"
    " together a Lustre application capable of running *anywhere*. Because of that,\n"
    " we like to describe Lustre as a **universal framework**.\n"
    "\n"
    " ## Guides\n"
    "\n"
    " A number of guides have been written to teach you how to use Lustre to build\n"
    " different kinds of applications. If you're just getting started with Lustre\n"
    " or frontend development, we recommend reading through them in order:\n"
    "\n"
    " - [`01-quickstart`](/guide/01-quickstart.html)\n"
    "\n"
    " This list of guides is likely to grow over time, so be sure to check back\n"
    " every now and then to see what's new!\n"
    "\n"
    " ## Examples\n"
    "\n"
    " If you prefer to learn by seeing and adapting existing code, there are also\n"
    " a number of examples in the [Lustre GitHub repository](https://github.com/lustre-labs/lustre)\n"
    " that each demonstrate a different concept or idea:\n"
    "\n"
    " - [`01-hello-world`](https://github.com/lustre-labs/lustre/tree/main/examples/01-hello-world)\n"
    " - [`02-interactivity`](https://github.com/lustre-labs/lustre/tree/main/examples/02-interactivity)\n"
    " - [`03-controlled-inputs`](https://github.com/lustre-labs/lustre/tree/main/examples/03-controlled-inputs)\n"
    " - [`04-custom-event-handlers`](https://github.com/lustre-labs/lustre/tree/main/examples/04-custom-event-handlers)\n"
    " - [`05-http-requests`](https://github.com/lustre-labs/lustre/tree/main/examples/05-http-requests)\n"
    " - [`06-custom-effects`](https://github.com/lustre-labs/lustre/tree/main/examples/06-custom-effects)\n"
    "\n"
    " This list of examples is likely to grow over time, so be sure to check back\n"
    " every now and then to see what's new!\n"
    "\n"
    " ## Companion libraries\n"
    "\n"
    " While this package contains the runtime and API necessary for building and\n"
    " rendering applications, there is also a small collection of companion libraries\n"
    " built to make building Lustre applications easier:\n"
    "\n"
    " - [lustre/ui](https://github.com/lustre-labs/ui) is a collection of pre-designed\n"
    "   elements and design tokens for building user interfaces with Lustre.\n"
    "\n"
    " - [lustre/ssg](https://github.com/lustre-labs/ssg) is a simple static site\n"
    "   generator that you can use to produce static HTML documents from your Lustre\n"
    "   applications.\n"
    "\n"
    " Both of these packages are heavy works in progress: any feedback or contributions\n"
    " are very welcome!\n"
    "\n"
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
    " ## Contributing\n"
    "\n"
    " The best way to contribute to Lustre is by building things! If you've built\n"
    " something cool with Lustre you want to share then please share it on the\n"
    " `#sharing` channel in the  [Gleam Discord server](https://discord.gg/Fm8Pwmy).\n"
    " You can also tag Hayleigh on Twitter [@hayleigh-dot-dev](https://twitter.com/hayleighdotdev)\n"
    " or on BlueSky [@hayleigh.dev](https://bsky.app/profile/hayleigh.dev).\n"
    "\n"
    " If you run into any issues or have ideas for how to improve Lustre, please\n"
    " open an issue on the [Lustre GitHub repository](https://github.com/lustre-labs/lustre/issues).\n"
    " Fixes and improvements to the documentation are also very welcome!\n"
    "\n"
    " Finally, if you'd like, you can support the project through\n"
    " [GitHub Sponsors](https://github.com/sponsors/hayleigh-dot-dev). Sponsorship\n"
    " helps fund the copious amounts of coffee that goes into building and maintaining\n"
    " Lustre, and is very much appreciated!\n"
    "\n"
).

-opaque app(QST, QSU, QSV) :: {app,
        fun((QST) -> {QSU, lustre@effect:effect(QSV)}),
        fun((QSU, QSV) -> {QSU, lustre@effect:effect(QSV)}),
        fun((QSU) -> lustre@internals@vdom:element(QSV)),
        gleam@option:option(gleam@dict:dict(binary(), fun((gleam@dynamic:dynamic_()) -> {ok,
                QSV} |
            {error, list(gleam@dynamic:decode_error())})))}.

-type client_spa() :: any().

-type server_component() :: any().

-type error() :: {actor_error, gleam@otp@actor:start_error()} |
    {bad_component_name, binary()} |
    {component_already_registered, binary()} |
    {element_not_found, binary()} |
    not_a_browser |
    not_erlang.

-file("src/lustre.gleam", 328).
?DOC(
    " A complete Lustre application that follows the Model-View-Update architecture\n"
    " and can handle side effects like HTTP requests or querying the DOM. Most real\n"
    " Lustre applications will use this constructor.\n"
    "\n"
    " To learn more about effects and their purpose, take a look at the\n"
    " [`effect`](./lustre/effect.html) module or the\n"
    " [HTTP requests example](https://github.com/lustre-labs/lustre/tree/main/examples/05-http-requests).\n"
).
-spec application(
    fun((QTO) -> {QTP, lustre@effect:effect(QTQ)}),
    fun((QTP, QTQ) -> {QTP, lustre@effect:effect(QTQ)}),
    fun((QTP) -> lustre@internals@vdom:element(QTQ))
) -> app(QTO, QTP, QTQ).
application(Init, Update, View) ->
    {app, Init, Update, View, none}.

-file("src/lustre.gleam", 293).
?DOC(
    " An element is the simplest type of Lustre application. It renders its contents\n"
    " once and does not handle any messages or effects. Often this type of application\n"
    " is used for folks just getting started with Lustre on the frontend and want a\n"
    " quick way to get something on the screen.\n"
    "\n"
    " Take a look at the [`simple`](#simple) application constructor if you want to\n"
    " build something interactive.\n"
    "\n"
    " > **Note**: Just because an element doesn't have its own update loop, doesn't\n"
    " > mean its content is always static! An element application may render a client\n"
    " > or server component that has its own encapsulated update loop!\n"
).
-spec element(lustre@internals@vdom:element(QTC)) -> app(nil, nil, QTC).
element(Html) ->
    Init = fun(_) -> {nil, lustre@effect:none()} end,
    Update = fun(_, _) -> {nil, lustre@effect:none()} end,
    View = fun(_) -> Html end,
    application(Init, Update, View).

-file("src/lustre.gleam", 309).
?DOC(
    " A `simple` application has the basic Model-View-Update building blocks present\n"
    " in all Lustre applications, but it cannot handle effects. This is a great way\n"
    " to learn the basics of Lustre and its architecture.\n"
    "\n"
    " Once you're comfortable with the Model-View-Update loop and want to start\n"
    " building more complex applications that can communicate with the outside world,\n"
    " you'll want to use the [`application`](#application) constructor instead.\n"
).
-spec simple(
    fun((QTH) -> QTI),
    fun((QTI, QTJ) -> QTI),
    fun((QTI) -> lustre@internals@vdom:element(QTJ))
) -> app(QTH, QTI, QTJ).
simple(Init, Update, View) ->
    Init@1 = fun(Flags) -> {Init(Flags), lustre@effect:none()} end,
    Update@1 = fun(Model, Msg) -> {Update(Model, Msg), lustre@effect:none()} end,
    application(Init@1, Update@1, View).

-file("src/lustre.gleam", 354).
?DOC(
    " A `component` is a type of Lustre application designed to be embedded within\n"
    " another application and has its own encapsulated update loop. This constructor\n"
    " is almost identical to the [`application`](#application) constructor, but it\n"
    " also allows you to specify a dictionary of attribute names and decoders.\n"
    "\n"
    " When a component is rendered in a parent application, it can receive data from\n"
    " the parent application through HTML attributes and properties just like any\n"
    " other HTML element. This dictionary of decoders allows you to specify how to\n"
    " decode those attributes into messages your component's update loop can handle.\n"
    "\n"
    " **Note**: Lustre components are conceptually a lot \"heavier\" than components\n"
    " in frameworks like React. They should be used for more complex UI widgets\n"
    " like a combobox with complex keyboard interactions rather than simple things\n"
    " like buttons or text inputs. Where possible try to think about how to build\n"
    " your UI with simple view functions (functions that return [Elements](./lustre/element.html#Element))\n"
    " and only reach for components when you really need to encapsulate that update\n"
    " loop.\n"
).
-spec component(
    fun((QTX) -> {QTY, lustre@effect:effect(QTZ)}),
    fun((QTY, QTZ) -> {QTY, lustre@effect:effect(QTZ)}),
    fun((QTY) -> lustre@internals@vdom:element(QTZ)),
    gleam@dict:dict(binary(), fun((gleam@dynamic:dynamic_()) -> {ok, QTZ} |
        {error, list(gleam@dynamic:decode_error())}))
) -> app(QTX, QTY, QTZ).
component(Init, Update, View, On_attribute_change) ->
    {app, Init, Update, View, {some, On_attribute_change}}.

-file("src/lustre.gleam", 387).
-spec do_start(app(QUT, any(), QUV), binary(), QUT) -> {ok,
        fun((lustre@internals@runtime:action(QUV, client_spa())) -> nil)} |
    {error, error()}.
do_start(_, _, _) ->
    {error, not_a_browser}.

-file("src/lustre.gleam", 444).
-spec do_start_actor(app(QVY, any(), QWA), QVY) -> {ok,
        gleam@erlang@process:subject(lustre@internals@runtime:action(QWA, server_component()))} |
    {error, error()}.
do_start_actor(App, Flags) ->
    On_attribute_change = gleam@option:unwrap(
        erlang:element(5, App),
        maps:new()
    ),
    _pipe = (erlang:element(2, App))(Flags),
    _pipe@1 = lustre@internals@runtime:start(
        _pipe,
        erlang:element(3, App),
        erlang:element(4, App),
        On_attribute_change
    ),
    gleam@result:map_error(_pipe@1, fun(Field@0) -> {actor_error, Field@0} end).

-file("src/lustre.gleam", 431).
?DOC(
    " Start an application as a server component specifically for the Erlang target.\n"
    " Instead of receiving a callback on successful start, this function returns\n"
    " a [`Subject`](https://hexdocs.pm/gleam_erlang/gleam/erlang/process.html#Subject)\n"
    "\n"
    "\n"
    " **Note**: This function is only meaningful on the Erlang target. Attempts to\n"
    " call it on the JavaScript will result in the `NotErlang` error. If you're running\n"
    " a Lustre server component on Node or Deno, use [`start_server_component`](#start_server_component)\n"
    " instead.\n"
).
-spec start_actor(app(QVN, any(), QVP), QVN) -> {ok,
        gleam@erlang@process:subject(lustre@internals@runtime:action(QVP, server_component()))} |
    {error, error()}.
start_actor(App, Flags) ->
    do_start_actor(App, Flags).

-file("src/lustre.gleam", 413).
?DOC(
    " Start an application as a server component. This runs in a headless mode and\n"
    " doesn't render anything to the DOM. Instead, multiple clients can be attached\n"
    " using the [`add_renderer`](#add_renderer) action.\n"
    "\n"
    " If a server component starts successfully, this function will return a callback\n"
    " that can be used to send actions to the component runtime.\n"
    "\n"
    " A server component will keep running until the program is terminated or the\n"
    " [`shutdown`](#shutdown) action is sent to it.\n"
    "\n"
    " **Note**: Users running their application on the BEAM should use [`start_actor`](#start_actor)\n"
    " instead to make use of Gleam's OTP abstractions.\n"
).
-spec start_server_component(app(QVD, any(), QVF), QVD) -> {ok,
        fun((lustre@internals@runtime:action(QVF, server_component())) -> nil)} |
    {error, error()}.
start_server_component(App, Flags) ->
    gleam@result:map(
        start_actor(App, Flags),
        fun(Runtime) ->
            fun(_capture) -> gleam@otp@actor:send(Runtime, _capture) end
        end
    ).

-file("src/lustre.gleam", 477).
?DOC(
    " Register a Lustre application as a Web Component. This lets you render that\n"
    " application in another Lustre application's view or use it as a Custom Element\n"
    " outside of Lustre entirely.The provided application can only have `Nil` flags\n"
    " because there is no way to provide an initial value for flags when using a\n"
    " Custom Element!\n"
    "\n"
    " The second argument is the name of the Custom Element. This is the name you'd\n"
    " use in HTML to render the component. For example, if you register a component\n"
    " with the name `my-component`, you'd use it in HTML by writing `<my-component>`\n"
    " or in Lustre by rendering `element(\"my-component\", [], [])`.\n"
    "\n"
    " **Note**: There are [some rules](https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/define#valid_custom_element_names)\n"
    " for what names are valid for a Custom Element. The most important one is that\n"
    " the name *must* contain a hypen so that it can be distinguished from standard\n"
    " HTML elements.\n"
    "\n"
    " **Note**: This function is only meaningful when running in the browser and will\n"
    " produce a `NotABrowser` error if called anywhere else. For server contexts,\n"
    " you can render a Lustre server component using [`start_server_component`](#start_server_component)\n"
    " or [`start_actor`](#start_actor) instead.\n"
).
-spec register(app(nil, any(), any()), binary()) -> {ok, nil} | {error, error()}.
register(_, _) ->
    {error, not_a_browser}.

-file("src/lustre.gleam", 490).
?DOC(
    " Dispatch a message to a running application's `update` function. This can be\n"
    " used as a way for the outside world to communicate with a Lustre app without\n"
    " the app needing to initiate things with an effect.\n"
    "\n"
    " Both client SPAs and server components can have messages sent to them using\n"
    " the `dispatch` action.\n"
).
-spec dispatch(QWQ) -> lustre@internals@runtime:action(QWQ, any()).
dispatch(Msg) ->
    {dispatch, Msg}.

-file("src/lustre.gleam", 499).
?DOC(
    " Instruct a running application to shut down. For client SPAs this will stop\n"
    " the runtime and unmount the app from the DOM. For server components, this will\n"
    " stop the runtime and prevent any further patches from being sent to connected\n"
    " clients.\n"
).
-spec shutdown() -> lustre@internals@runtime:action(any(), any()).
shutdown() ->
    shutdown.

-file("src/lustre.gleam", 514).
?DOC(
    " Gleam's conditional compilation makes it possible to have different implementations\n"
    " of a function for different targets, but it's not possible to know what runtime\n"
    " you're targeting at compile-time.\n"
    "\n"
    " This is problematic if you're using server components with a JavaScript\n"
    " backend because you'll want to know whether you're currently running on your\n"
    " server or in the browser: this function tells you that!\n"
).
-spec is_browser() -> boolean().
is_browser() ->
    false.

-file("src/lustre.gleam", 377).
?DOC(
    " Start a constructed application as a client-side single-page application (SPA).\n"
    " This is the most typical way to start a Lustre application and will *only* work\n"
    " in the browser\n"
    "\n"
    " The second argument is a [CSS selector](https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelector)\n"
    " used to locate the DOM element where the application will be mounted on to.\n"
    " The most common selectors are `\"#app\"` to target an element with an id of `app`\n"
    " or `[data-lustre-app]` to target an element with a `data-lustre-app` attribute.\n"
    "\n"
    " The third argument is the starting data for the application. This is passed\n"
    " to the application's `init` function.\n"
).
-spec start(app(QUJ, any(), QUL), binary(), QUJ) -> {ok,
        fun((lustre@internals@runtime:action(QUL, client_spa())) -> nil)} |
    {error, error()}.
start(App, Selector, Flags) ->
    gleam@bool:guard(
        not is_browser(),
        {error, not_a_browser},
        fun() -> do_start(App, Selector, Flags) end
    ).

-file("src/lustre.gleam", 523).
?DOC(
    " Check if the given component name has already been registered as a Custom\n"
    " Element. This is particularly useful in contexts where _other web components_\n"
    " may have been registered and you must avoid collisions.\n"
).
-spec is_registered(binary()) -> boolean().
is_registered(_) ->
    false.
