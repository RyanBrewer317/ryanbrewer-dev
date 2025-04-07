-module(lustre@attribute).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([attribute/2, property/2, on/2, map/2, style/1, class/1, none/0, classes/1, data/2, id/1, role/1, title/1, type_/1, value/1, checked/1, placeholder/1, selected/1, accept/1, accept_charset/1, msg/1, autocomplete/1, autofocus/1, disabled/1, name/1, pattern/1, readonly/1, required/1, for/1, max/1, min/1, step/1, cols/1, rows/1, wrap/1, href/1, target/1, download/1, rel/1, src/1, height/1, width/1, alt/1, content/1, autoplay/1, controls/1, loop/1, action/1, enctype/1, method/1, novalidate/1, form_action/1, form_enctype/1, form_method/1, form_novalidate/1, form_target/1, open/1, charset/1, http_equiv/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-file("src/lustre/attribute.gleam", 27).
?DOC(
    " Create an HTML attribute. This is like saying `element.setAttribute(\"class\", \"wibble\")`\n"
    " in JavaScript. Attributes will be rendered when calling [`element.to_string`](./element.html#to_string).\n"
    "\n"
    " **Note**: there is a subtle difference between attributes and properties. You\n"
    " can read more about the implications of this\n"
    " [here](https://github.com/lustre-labs/lustre/blob/main/pages/hints/attributes-vs-properties.md).\n"
).
-spec attribute(binary(), binary()) -> lustre@internals@vdom:attribute(any()).
attribute(Name, Value) ->
    {attribute, Name, gleam_stdlib:identity(Value), false}.

-file("src/lustre/attribute.gleam", 39).
?DOC(
    " Create a DOM property. This is like saying `element.className = \"wibble\"` in\n"
    " JavaScript. Properties will be **not** be rendered when calling\n"
    " [`element.to_string`](./element.html#to_string).\n"
    "\n"
    " **Note**: there is a subtle difference between attributes and properties. You\n"
    " can read more about the implications of this\n"
    " [here](https://github.com/lustre-labs/lustre/blob/main/pages/hints/attributes-vs-properties.md).\n"
).
-spec property(binary(), any()) -> lustre@internals@vdom:attribute(any()).
property(Name, Value) ->
    {attribute, Name, gleam_stdlib:identity(Value), true}.

-file("src/lustre/attribute.gleam", 44).
?DOC("\n").
-spec on(
    binary(),
    fun((gleam@dynamic:dynamic_()) -> {ok, OOT} |
        {error, list(gleam@dynamic:decode_error())})
) -> lustre@internals@vdom:attribute(OOT).
on(Name, Handler) ->
    {event, <<"on"/utf8, Name/binary>>, Handler}.

-file("src/lustre/attribute.gleam", 63).
?DOC(
    " The `Attribute` type is parameterised by the type of messages it can produce\n"
    " from events handlers. Sometimes you might end up with an attribute from a\n"
    " library or module that produces a different type of message: this function lets\n"
    " you map the messages produced from one type to another.\n"
).
-spec map(lustre@internals@vdom:attribute(OOY), fun((OOY) -> OPA)) -> lustre@internals@vdom:attribute(OPA).
map(Attr, F) ->
    case Attr of
        {attribute, Name, Value, As_property} ->
            {attribute, Name, Value, As_property};

        {event, On, Handler} ->
            {event, On, fun(E) -> gleam@result:map(Handler(E), F) end}
    end.

-file("src/lustre/attribute.gleam", 78).
?DOC(
    "\n"
    "\n"
    " > **Note**: unlike most attributes, multiple `style` attributes are merged\n"
    " > with any existing other styles on an element. Styles added _later_ in the\n"
    " > list will override styles added earlier.\n"
).
-spec style(list({binary(), binary()})) -> lustre@internals@vdom:attribute(any()).
style(Properties) ->
    attribute(
        <<"style"/utf8>>,
        begin
            gleam@list:fold(
                Properties,
                <<""/utf8>>,
                fun(Styles, _use1) ->
                    {Name, Value} = _use1,
                    <<<<<<<<Styles/binary, Name/binary>>/binary, ":"/utf8>>/binary,
                            Value/binary>>/binary,
                        ";"/utf8>>
                end
            )
        end
    ).

-file("src/lustre/attribute.gleam", 90).
?DOC(
    "\n"
    "\n"
    " > **Note**: unlike most attributes, multiple `class` attributes are merged\n"
    " > with any existing other classes on an element.\n"
).
-spec class(binary()) -> lustre@internals@vdom:attribute(any()).
class(Name) ->
    attribute(<<"class"/utf8>>, Name).

-file("src/lustre/attribute.gleam", 52).
?DOC(
    " Create an empty attribute. This is not added to the DOM and not rendered when\n"
    " calling [`element.to_string`](./element.html#to_string), but it is useful for\n"
    " _conditionally_ adding attributes to an element.\n"
).
-spec none() -> lustre@internals@vdom:attribute(any()).
none() ->
    class(<<""/utf8>>).

-file("src/lustre/attribute.gleam", 95).
?DOC("\n").
-spec classes(list({binary(), boolean()})) -> lustre@internals@vdom:attribute(any()).
classes(Names) ->
    attribute(
        <<"class"/utf8>>,
        begin
            _pipe = Names,
            _pipe@1 = gleam@list:filter_map(
                _pipe,
                fun(Class) -> case erlang:element(2, Class) of
                        true ->
                            {ok, erlang:element(1, Class)};

                        false ->
                            {error, nil}
                    end end
            ),
            gleam@string:join(_pipe@1, <<" "/utf8>>)
        end
    ).

-file("src/lustre/attribute.gleam", 113).
?DOC(
    "\n"
    "\n"
    " Add a `data-*` attribute to an HTML element. The key will be prefixed by `data-`.\n"
).
-spec data(binary(), binary()) -> lustre@internals@vdom:attribute(any()).
data(Key, Value) ->
    attribute(<<"data-"/utf8, Key/binary>>, Value).

-file("src/lustre/attribute.gleam", 118).
?DOC("\n").
-spec id(binary()) -> lustre@internals@vdom:attribute(any()).
id(Name) ->
    attribute(<<"id"/utf8>>, Name).

-file("src/lustre/attribute.gleam", 123).
?DOC("\n").
-spec role(binary()) -> lustre@internals@vdom:attribute(any()).
role(Name) ->
    attribute(<<"role"/utf8>>, Name).

-file("src/lustre/attribute.gleam", 128).
?DOC("\n").
-spec title(binary()) -> lustre@internals@vdom:attribute(any()).
title(Name) ->
    attribute(<<"title"/utf8>>, Name).

-file("src/lustre/attribute.gleam", 135).
?DOC("\n").
-spec type_(binary()) -> lustre@internals@vdom:attribute(any()).
type_(Name) ->
    attribute(<<"type"/utf8>>, Name).

-file("src/lustre/attribute.gleam", 140).
?DOC("\n").
-spec value(binary()) -> lustre@internals@vdom:attribute(any()).
value(Val) ->
    attribute(<<"value"/utf8>>, Val).

-file("src/lustre/attribute.gleam", 145).
?DOC("\n").
-spec checked(boolean()) -> lustre@internals@vdom:attribute(any()).
checked(Is_checked) ->
    property(<<"checked"/utf8>>, Is_checked).

-file("src/lustre/attribute.gleam", 150).
?DOC("\n").
-spec placeholder(binary()) -> lustre@internals@vdom:attribute(any()).
placeholder(Text) ->
    attribute(<<"placeholder"/utf8>>, Text).

-file("src/lustre/attribute.gleam", 155).
?DOC("\n").
-spec selected(boolean()) -> lustre@internals@vdom:attribute(any()).
selected(Is_selected) ->
    property(<<"selected"/utf8>>, Is_selected).

-file("src/lustre/attribute.gleam", 162).
?DOC("\n").
-spec accept(list(binary())) -> lustre@internals@vdom:attribute(any()).
accept(Types) ->
    attribute(<<"accept"/utf8>>, gleam@string:join(Types, <<","/utf8>>)).

-file("src/lustre/attribute.gleam", 167).
?DOC("\n").
-spec accept_charset(list(binary())) -> lustre@internals@vdom:attribute(any()).
accept_charset(Types) ->
    attribute(<<"acceptCharset"/utf8>>, gleam@string:join(Types, <<" "/utf8>>)).

-file("src/lustre/attribute.gleam", 172).
?DOC("\n").
-spec msg(binary()) -> lustre@internals@vdom:attribute(any()).
msg(Uri) ->
    attribute(<<"msg"/utf8>>, Uri).

-file("src/lustre/attribute.gleam", 177).
?DOC("\n").
-spec autocomplete(binary()) -> lustre@internals@vdom:attribute(any()).
autocomplete(Name) ->
    attribute(<<"autocomplete"/utf8>>, Name).

-file("src/lustre/attribute.gleam", 182).
?DOC("\n").
-spec autofocus(boolean()) -> lustre@internals@vdom:attribute(any()).
autofocus(Should_autofocus) ->
    property(<<"autofocus"/utf8>>, Should_autofocus).

-file("src/lustre/attribute.gleam", 187).
?DOC("\n").
-spec disabled(boolean()) -> lustre@internals@vdom:attribute(any()).
disabled(Is_disabled) ->
    property(<<"disabled"/utf8>>, Is_disabled).

-file("src/lustre/attribute.gleam", 192).
?DOC("\n").
-spec name(binary()) -> lustre@internals@vdom:attribute(any()).
name(Name) ->
    attribute(<<"name"/utf8>>, Name).

-file("src/lustre/attribute.gleam", 197).
?DOC("\n").
-spec pattern(binary()) -> lustre@internals@vdom:attribute(any()).
pattern(Regex) ->
    attribute(<<"pattern"/utf8>>, Regex).

-file("src/lustre/attribute.gleam", 202).
?DOC("\n").
-spec readonly(boolean()) -> lustre@internals@vdom:attribute(any()).
readonly(Is_readonly) ->
    property(<<"readOnly"/utf8>>, Is_readonly).

-file("src/lustre/attribute.gleam", 207).
?DOC("\n").
-spec required(boolean()) -> lustre@internals@vdom:attribute(any()).
required(Is_required) ->
    property(<<"required"/utf8>>, Is_required).

-file("src/lustre/attribute.gleam", 212).
?DOC("\n").
-spec for(binary()) -> lustre@internals@vdom:attribute(any()).
for(Id) ->
    attribute(<<"for"/utf8>>, Id).

-file("src/lustre/attribute.gleam", 219).
?DOC("\n").
-spec max(binary()) -> lustre@internals@vdom:attribute(any()).
max(Val) ->
    attribute(<<"max"/utf8>>, Val).

-file("src/lustre/attribute.gleam", 224).
?DOC("\n").
-spec min(binary()) -> lustre@internals@vdom:attribute(any()).
min(Val) ->
    attribute(<<"min"/utf8>>, Val).

-file("src/lustre/attribute.gleam", 229).
?DOC("\n").
-spec step(binary()) -> lustre@internals@vdom:attribute(any()).
step(Val) ->
    attribute(<<"step"/utf8>>, Val).

-file("src/lustre/attribute.gleam", 236).
?DOC("\n").
-spec cols(integer()) -> lustre@internals@vdom:attribute(any()).
cols(Val) ->
    attribute(<<"cols"/utf8>>, erlang:integer_to_binary(Val)).

-file("src/lustre/attribute.gleam", 241).
?DOC("\n").
-spec rows(integer()) -> lustre@internals@vdom:attribute(any()).
rows(Val) ->
    attribute(<<"rows"/utf8>>, erlang:integer_to_binary(Val)).

-file("src/lustre/attribute.gleam", 246).
?DOC("\n").
-spec wrap(binary()) -> lustre@internals@vdom:attribute(any()).
wrap(Mode) ->
    attribute(<<"wrap"/utf8>>, Mode).

-file("src/lustre/attribute.gleam", 253).
?DOC("\n").
-spec href(binary()) -> lustre@internals@vdom:attribute(any()).
href(Uri) ->
    attribute(<<"href"/utf8>>, Uri).

-file("src/lustre/attribute.gleam", 258).
?DOC("\n").
-spec target(binary()) -> lustre@internals@vdom:attribute(any()).
target(Target) ->
    attribute(<<"target"/utf8>>, Target).

-file("src/lustre/attribute.gleam", 263).
?DOC("\n").
-spec download(binary()) -> lustre@internals@vdom:attribute(any()).
download(Filename) ->
    attribute(<<"download"/utf8>>, Filename).

-file("src/lustre/attribute.gleam", 268).
?DOC("\n").
-spec rel(binary()) -> lustre@internals@vdom:attribute(any()).
rel(Relationship) ->
    attribute(<<"rel"/utf8>>, Relationship).

-file("src/lustre/attribute.gleam", 275).
?DOC("\n").
-spec src(binary()) -> lustre@internals@vdom:attribute(any()).
src(Uri) ->
    attribute(<<"src"/utf8>>, Uri).

-file("src/lustre/attribute.gleam", 286).
?DOC(
    " **Note**: this uses [`property`](#property) to set the value directly on the\n"
    " DOM node, making it **incompatible** with SVG elements. To set the height of\n"
    " an `<svg>` element, use the [`attribute`](#attribute) function directly.\n"
    "\n"
    " You can read more about the difference between attributes and properties\n"
    " [here](https://github.com/lustre-labs/lustre/blob/main/pages/hints/attributes-vs-properties.md).\n"
).
-spec height(integer()) -> lustre@internals@vdom:attribute(any()).
height(Val) ->
    property(<<"height"/utf8>>, Val).

-file("src/lustre/attribute.gleam", 297).
?DOC(
    " **Note**: this uses [`property`](#property) to set the value directly on the\n"
    " DOM node, making it **incompatible** with SVG elements. To set the width of\n"
    " an `<svg>` element, use the [`attribute`](#attribute) function directly.\n"
    "\n"
    " You can read more about the difference between attributes and properties\n"
    " [here](https://github.com/lustre-labs/lustre/blob/main/pages/hints/attributes-vs-properties.md).\n"
).
-spec width(integer()) -> lustre@internals@vdom:attribute(any()).
width(Val) ->
    property(<<"width"/utf8>>, Val).

-file("src/lustre/attribute.gleam", 302).
?DOC("\n").
-spec alt(binary()) -> lustre@internals@vdom:attribute(any()).
alt(Text) ->
    attribute(<<"alt"/utf8>>, Text).

-file("src/lustre/attribute.gleam", 307).
?DOC("\n").
-spec content(binary()) -> lustre@internals@vdom:attribute(any()).
content(Text) ->
    attribute(<<"content"/utf8>>, Text).

-file("src/lustre/attribute.gleam", 314).
?DOC("\n").
-spec autoplay(boolean()) -> lustre@internals@vdom:attribute(any()).
autoplay(Should_autoplay) ->
    property(<<"autoplay"/utf8>>, Should_autoplay).

-file("src/lustre/attribute.gleam", 319).
?DOC("\n").
-spec controls(boolean()) -> lustre@internals@vdom:attribute(any()).
controls(Visible) ->
    property(<<"controls"/utf8>>, Visible).

-file("src/lustre/attribute.gleam", 324).
?DOC("\n").
-spec loop(boolean()) -> lustre@internals@vdom:attribute(any()).
loop(Should_loop) ->
    property(<<"loop"/utf8>>, Should_loop).

-file("src/lustre/attribute.gleam", 331).
?DOC("\n").
-spec action(binary()) -> lustre@internals@vdom:attribute(any()).
action(Url) ->
    attribute(<<"action"/utf8>>, Url).

-file("src/lustre/attribute.gleam", 336).
?DOC("\n").
-spec enctype(binary()) -> lustre@internals@vdom:attribute(any()).
enctype(Value) ->
    attribute(<<"enctype"/utf8>>, Value).

-file("src/lustre/attribute.gleam", 341).
?DOC("\n").
-spec method(binary()) -> lustre@internals@vdom:attribute(any()).
method(Method) ->
    attribute(<<"method"/utf8>>, Method).

-file("src/lustre/attribute.gleam", 346).
?DOC("\n").
-spec novalidate(boolean()) -> lustre@internals@vdom:attribute(any()).
novalidate(Value) ->
    property(<<"novalidate"/utf8>>, Value).

-file("src/lustre/attribute.gleam", 351).
?DOC("\n").
-spec form_action(binary()) -> lustre@internals@vdom:attribute(any()).
form_action(Action) ->
    attribute(<<"formaction"/utf8>>, Action).

-file("src/lustre/attribute.gleam", 356).
?DOC("\n").
-spec form_enctype(binary()) -> lustre@internals@vdom:attribute(any()).
form_enctype(Value) ->
    attribute(<<"formenctype"/utf8>>, Value).

-file("src/lustre/attribute.gleam", 361).
?DOC("\n").
-spec form_method(binary()) -> lustre@internals@vdom:attribute(any()).
form_method(Method) ->
    attribute(<<"formmethod"/utf8>>, Method).

-file("src/lustre/attribute.gleam", 366).
?DOC("\n").
-spec form_novalidate(boolean()) -> lustre@internals@vdom:attribute(any()).
form_novalidate(Value) ->
    property(<<"formnovalidate"/utf8>>, Value).

-file("src/lustre/attribute.gleam", 371).
?DOC("\n").
-spec form_target(binary()) -> lustre@internals@vdom:attribute(any()).
form_target(Target) ->
    attribute(<<"formtarget"/utf8>>, Target).

-file("src/lustre/attribute.gleam", 378).
?DOC("\n").
-spec open(boolean()) -> lustre@internals@vdom:attribute(any()).
open(Is_open) ->
    property(<<"open"/utf8>>, Is_open).

-file("src/lustre/attribute.gleam", 385).
?DOC("\n").
-spec charset(binary()) -> lustre@internals@vdom:attribute(any()).
charset(Name) ->
    attribute(<<"charset"/utf8>>, Name).

-file("src/lustre/attribute.gleam", 390).
?DOC("\n").
-spec http_equiv(binary()) -> lustre@internals@vdom:attribute(any()).
http_equiv(Name) ->
    attribute(<<"http-equiv"/utf8>>, Name).
