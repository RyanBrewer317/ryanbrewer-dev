-module(lustre@element).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([element/3, keyed/2, namespaced/4, advanced/6, text/1, none/0, fragment/1, map/2, get_root/1, to_string/1, to_document_string/1, to_string_builder/1, to_document_string_builder/1, to_readable_string/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " Lustre wouldn't be much use as a frontend framework if it didn't provide a\n"
    " way to create HTML elements. This module contains the basic functions\n"
    " necessary to construct and manipulate different HTML elements.\n"
    "\n"
    " It is also possible to use Lustre as a HTML templating library, without\n"
    " using its runtime or framework features.\n"
    "\n"
).

-file("src/lustre/element.gleam", 90).
?DOC(
    " A general function for constructing any kind of element. In most cases you\n"
    " will want to use the [`lustre/element/html`](./element/html.html) instead but this\n"
    " function is particularly handy when constructing custom elements, either\n"
    " from your own Lustre components or from external JavaScript libraries.\n"
    "\n"
    " **Note**: Because Lustre is primarily used to create HTML, this function\n"
    " special-cases the following tags which render as\n"
    " [void elements](https://developer.mozilla.org/en-US/docs/Glossary/Void_element):\n"
    "\n"
    "   - area\n"
    "   - base\n"
    "   - br\n"
    "   - col\n"
    "   - embed\n"
    "   - hr\n"
    "   - img\n"
    "   - input\n"
    "   - link\n"
    "   - meta\n"
    "   - param\n"
    "   - source\n"
    "   - track\n"
    "   - wbr\n"
    "\n"
    "  This will only affect the output of `to_string` and `to_string_builder`!\n"
    "  If you need to render any of these tags with children, *or* you want to\n"
    "  render some other tag as self-closing or void, use [`advanced`](#advanced)\n"
    "  to construct the element instead.\n"
).
-spec element(
    binary(),
    list(lustre@internals@vdom:attribute(OXC)),
    list(lustre@internals@vdom:element(OXC))
) -> lustre@internals@vdom:element(OXC).
element(Tag, Attrs, Children) ->
    case Tag of
        <<"area"/utf8>> ->
            {element, <<""/utf8>>, <<""/utf8>>, Tag, Attrs, [], false, true};

        <<"base"/utf8>> ->
            {element, <<""/utf8>>, <<""/utf8>>, Tag, Attrs, [], false, true};

        <<"br"/utf8>> ->
            {element, <<""/utf8>>, <<""/utf8>>, Tag, Attrs, [], false, true};

        <<"col"/utf8>> ->
            {element, <<""/utf8>>, <<""/utf8>>, Tag, Attrs, [], false, true};

        <<"embed"/utf8>> ->
            {element, <<""/utf8>>, <<""/utf8>>, Tag, Attrs, [], false, true};

        <<"hr"/utf8>> ->
            {element, <<""/utf8>>, <<""/utf8>>, Tag, Attrs, [], false, true};

        <<"img"/utf8>> ->
            {element, <<""/utf8>>, <<""/utf8>>, Tag, Attrs, [], false, true};

        <<"input"/utf8>> ->
            {element, <<""/utf8>>, <<""/utf8>>, Tag, Attrs, [], false, true};

        <<"link"/utf8>> ->
            {element, <<""/utf8>>, <<""/utf8>>, Tag, Attrs, [], false, true};

        <<"meta"/utf8>> ->
            {element, <<""/utf8>>, <<""/utf8>>, Tag, Attrs, [], false, true};

        <<"param"/utf8>> ->
            {element, <<""/utf8>>, <<""/utf8>>, Tag, Attrs, [], false, true};

        <<"source"/utf8>> ->
            {element, <<""/utf8>>, <<""/utf8>>, Tag, Attrs, [], false, true};

        <<"track"/utf8>> ->
            {element, <<""/utf8>>, <<""/utf8>>, Tag, Attrs, [], false, true};

        <<"wbr"/utf8>> ->
            {element, <<""/utf8>>, <<""/utf8>>, Tag, Attrs, [], false, true};

        _ ->
            {element,
                <<""/utf8>>,
                <<""/utf8>>,
                Tag,
                Attrs,
                Children,
                false,
                false}
    end.

-file("src/lustre/element.gleam", 174).
-spec do_keyed(lustre@internals@vdom:element(OXP), binary()) -> lustre@internals@vdom:element(OXP).
do_keyed(El, Key) ->
    case El of
        {element, _, Namespace, Tag, Attrs, Children, Self_closing, Void} ->
            {element, Key, Namespace, Tag, Attrs, Children, Self_closing, Void};

        {map, Subtree} ->
            {map, fun() -> do_keyed(Subtree(), Key) end};

        _ ->
            El
    end.

-file("src/lustre/element.gleam", 164).
?DOC(
    " Keying elements is an optimisation that helps the runtime reuse existing DOM\n"
    " nodes in cases where children are reordered or removed from a list. Maybe you\n"
    " have a list of elements that can be filtered or sorted in some way, or additions\n"
    " to the front are common. In these cases, keying elements can help Lustre avoid\n"
    " unecessary DOM manipulations by pairing the DOM nodes with the elements in the\n"
    " list that share the same key.\n"
    "\n"
    " You can easily take an element from `lustre/element/html` and key its children\n"
    " by making use of Gleam's [function capturing syntax](https://tour.gleam.run/functions/function-captures/):\n"
    "\n"
    " ```gleam\n"
    " import gleam/list\n"
    " import lustre/element\n"
    " import lustre/element/html\n"
    "\n"
    " fn example() {\n"
    "   element.keyed(html.ul([], _), {\n"
    "     use item <- list.map(todo_list)\n"
    "     let child = html.li([], [view_item(item)])\n"
    "\n"
    "     #(item.id, child)\n"
    "   })\n"
    " }\n"
    " ```\n"
    "\n"
    " **Note**: The key must be unique within the list of children, but it doesn't\n"
    " have to be unique across the whole application. It's fine to use the same key\n"
    " in different lists. Lustre will display a warning in the browser console when\n"
    " it detects duplicate keys in a list.\n"
).
-spec keyed(
    fun((list(lustre@internals@vdom:element(OXI))) -> lustre@internals@vdom:element(OXI)),
    list({binary(), lustre@internals@vdom:element(OXI)})
) -> lustre@internals@vdom:element(OXI).
keyed(El, Children) ->
    El(
        begin
            gleam@list:map(
                Children,
                fun(_use0) ->
                    {Key, Child} = _use0,
                    do_keyed(Child, Key)
                end
            )
        end
    ).

-file("src/lustre/element.gleam", 195).
?DOC(
    " A function for constructing elements in a specific XML namespace. This can\n"
    " be used to construct SVG or MathML elements, for example.\n"
).
-spec namespaced(
    binary(),
    binary(),
    list(lustre@internals@vdom:attribute(OXS)),
    list(lustre@internals@vdom:element(OXS))
) -> lustre@internals@vdom:element(OXS).
namespaced(Namespace, Tag, Attrs, Children) ->
    {element, <<""/utf8>>, Namespace, Tag, Attrs, Children, false, false}.

-file("src/lustre/element.gleam", 217).
?DOC(
    " A function for constructing elements with more control over how the element\n"
    " is rendered when converted to a string. This is necessary because some HTML,\n"
    " SVG, and MathML elements are self-closing or void elements, and Lustre needs\n"
    " to know how to render them correctly!\n"
).
-spec advanced(
    binary(),
    binary(),
    list(lustre@internals@vdom:attribute(OXY)),
    list(lustre@internals@vdom:element(OXY)),
    boolean(),
    boolean()
) -> lustre@internals@vdom:element(OXY).
advanced(Namespace, Tag, Attrs, Children, Self_closing, Void) ->
    {element, <<""/utf8>>, Namespace, Tag, Attrs, Children, Self_closing, Void}.

-file("src/lustre/element.gleam", 241).
?DOC(
    " A function for turning a Gleam string into a text node. Gleam doesn't have\n"
    " union types like some other languages you may be familiar with, like TypeScript.\n"
    " Instead, we need a way to take a `String` and turn it into an `Element` somehow:\n"
    " this function is exactly that!\n"
).
-spec text(binary()) -> lustre@internals@vdom:element(any()).
text(Content) ->
    {text, Content}.

-file("src/lustre/element.gleam", 249).
?DOC(
    " A function for rendering nothing. This is mostly useful for conditional\n"
    " rendering, where you might want to render something only if a certain\n"
    " condition is met.\n"
).
-spec none() -> lustre@internals@vdom:element(any()).
none() ->
    {text, <<""/utf8>>}.

-file("src/lustre/element.gleam", 258).
?DOC(
    " A function for wrapping elements to be rendered within a parent container without\n"
    " specififying the container on definition. Allows the treatment of List(Element(msg))\n"
    " as if it were Element(msg). Useful when generating a list of elements from data but\n"
    " used downstream.\n"
).
-spec fragment(list(lustre@internals@vdom:element(OYI))) -> lustre@internals@vdom:element(OYI).
fragment(Elements) ->
    element(
        <<"lustre-fragment"/utf8>>,
        [lustre@attribute:style([{<<"display"/utf8>>, <<"contents"/utf8>>}])],
        Elements
    ).

-file("src/lustre/element.gleam", 275).
?DOC(
    " The `Element` type is parameterised by the type of messages it can produce\n"
    " from events. Sometimes you might end up with a fragment of HTML from another\n"
    " library or module that produces a different type of message: this function lets\n"
    " you map the messages produced from one type to another.\n"
    "\n"
    " Think of it like `list.map` or `result.map` but for HTML events!\n"
).
-spec map(lustre@internals@vdom:element(OYM), fun((OYM) -> OYO)) -> lustre@internals@vdom:element(OYO).
map(Element, F) ->
    case Element of
        {text, Content} ->
            {text, Content};

        {map, Subtree} ->
            {map, fun() -> map(Subtree(), F) end};

        {element, Key, Namespace, Tag, Attrs, Children, Self_closing, Void} ->
            {map,
                fun() ->
                    {element,
                        Key,
                        Namespace,
                        Tag,
                        gleam@list:map(
                            Attrs,
                            fun(_capture) ->
                                lustre@attribute:map(_capture, F)
                            end
                        ),
                        gleam@list:map(
                            Children,
                            fun(_capture@1) -> map(_capture@1, F) end
                        ),
                        Self_closing,
                        Void}
                end}
    end.

-file("src/lustre/element.gleam", 297).
?DOC(false).
-spec get_root(fun((fun((OYQ) -> nil), gleam@dynamic:dynamic_()) -> nil)) -> lustre@effect:effect(OYQ).
get_root(Effect) ->
    lustre@effect:custom(
        fun(Dispatch, _, _, Root) -> Effect(Dispatch, Root) end
    ).

-file("src/lustre/element.gleam", 311).
?DOC(
    " Convert a Lustre `Element` to a string. This is _not_ pretty-printed, so\n"
    " there are no newlines or indentation. If you need to pretty-print an element,\n"
    " reach out on the [Gleam Discord](https://discord.gg/Fm8Pwmy) or\n"
    " [open an issue](https://github.com/lustre-labs/lustre/issues/new) with your\n"
    " use case and we'll see what we can do!\n"
).
-spec to_string(lustre@internals@vdom:element(any())) -> binary().
to_string(Element) ->
    lustre@internals@vdom:element_to_string(Element).

-file("src/lustre/element.gleam", 322).
?DOC(
    " Converts an element to a string like [`to_string`](#to_string), but prepends\n"
    " a `<!doctype html>` declaration to the string. This is useful for rendering\n"
    " complete HTML documents.\n"
    "\n"
    " If the provided element is not an `html` element, it will be wrapped in both\n"
    " a `html` and `body` element.\n"
).
-spec to_document_string(lustre@internals@vdom:element(any())) -> binary().
to_document_string(El) ->
    _pipe = lustre@internals@vdom:element_to_string(case El of
            {element, _, _, <<"html"/utf8>>, _, _, _, _} ->
                El;

            {element, _, _, <<"head"/utf8>>, _, _, _, _} ->
                element(<<"html"/utf8>>, [], [El]);

            {element, _, _, <<"body"/utf8>>, _, _, _, _} ->
                element(<<"html"/utf8>>, [], [El]);

            {map, Subtree} ->
                Subtree();

            _ ->
                element(
                    <<"html"/utf8>>,
                    [],
                    [element(<<"body"/utf8>>, [], [El])]
                )
        end),
    gleam@string:append(<<"<!doctype html>\n"/utf8>>, _pipe).

-file("src/lustre/element.gleam", 340).
?DOC(
    " Convert a Lustre `Element` to a `StringTree`. This is _not_ pretty-printed,\n"
    " so there are no newlines or indentation. If you need to pretty-print an element,\n"
    " reach out on the [Gleam Discord](https://discord.gg/Fm8Pwmy) or\n"
    " [open an issue](https://github.com/lustre-labs/lustre/issues/new) with your\n"
    " use case and we'll see what we can do!\n"
).
-spec to_string_builder(lustre@internals@vdom:element(any())) -> gleam@string_tree:string_tree().
to_string_builder(Element) ->
    lustre@internals@vdom:element_to_string_builder(Element).

-file("src/lustre/element.gleam", 351).
?DOC(
    " Converts an element to a `StringTree` like [`to_string_builder`](#to_string_builder),\n"
    " but prepends a `<!doctype html>` declaration. This is useful for rendering\n"
    " complete HTML documents.\n"
    "\n"
    " If the provided element is not an `html` element, it will be wrapped in both\n"
    " a `html` and `body` element.\n"
).
-spec to_document_string_builder(lustre@internals@vdom:element(any())) -> gleam@string_tree:string_tree().
to_document_string_builder(El) ->
    _pipe = lustre@internals@vdom:element_to_string_builder(case El of
            {element, _, _, <<"html"/utf8>>, _, _, _, _} ->
                El;

            {element, _, _, <<"head"/utf8>>, _, _, _, _} ->
                element(<<"html"/utf8>>, [], [El]);

            {element, _, _, <<"body"/utf8>>, _, _, _, _} ->
                element(<<"html"/utf8>>, [], [El]);

            {map, Subtree} ->
                Subtree();

            _ ->
                element(
                    <<"html"/utf8>>,
                    [],
                    [element(<<"body"/utf8>>, [], [El])]
                )
        end),
    gleam@string_tree:prepend(_pipe, <<"<!doctype html>\n"/utf8>>).

-file("src/lustre/element.gleam", 387).
?DOC(
    " Converts a Lustre `Element` to a human-readable string by inserting new lines\n"
    " and indentation where appropriate. This is useful for debugging and testing,\n"
    " but for production code you should use [`to_string`](#to_string) or\n"
    " [`to_document_string`](#to_document_string) instead.\n"
    "\n"
    " 💡 This function works great with the snapshot testing library\n"
    "    [birdie](https://hexdocs.pm/birdie)!\n"
    "\n"
    " ## Using `to_string`:\n"
    "\n"
    " ```html\n"
    " <header><h1>Hello, world!</h1></header>\n"
    " ```\n"
    "\n"
    " ## Using `to_readable_string`\n"
    "\n"
    " ```html\n"
    " <header>\n"
    "   <h1>\n"
    "     Hello, world!\n"
    "   </h1>\n"
    " </header>\n"
    " ```\n"
).
-spec to_readable_string(lustre@internals@vdom:element(any())) -> binary().
to_readable_string(El) ->
    lustre@internals@vdom:element_to_snapshot(El).
