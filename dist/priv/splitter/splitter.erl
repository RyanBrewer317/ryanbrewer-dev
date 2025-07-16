-module(splitter).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([split/2, new/1]).
-export_type([splitter/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-type splitter() :: any().

-file("src/splitter.gleam", 49).
?DOC(
    " Use the splitter to find the first substring in the input string, splitting\n"
    " the input string at that point.\n"
    "\n"
    " A tuple of three strings is returned:\n"
    " 1. The string prefix before the split.\n"
    " 2. The substring the string was split with.\n"
    " 3. The string suffix after the split.\n"
    "\n"
    " If no substring was found then strings 1 and 2 will be empty, and string 3\n"
    " will be the whole input string.\n"
    "\n"
    " # Examples\n"
    "\n"
    " ```gleam\n"
    " let line_ends = splitter.new([\"\\n\", \"\\r\\n\"])\n"
    "\n"
    " splitter.split(line_ends, \"1. Bread\\n2. Milk\\n\")\n"
    " // -> #(\"1. Bread\", \"\\n\", \"2. Milk\")\n"
    "\n"
    " splitter.split(line_ends, \"No end of line here!\")\n"
    " // -> #(\"\", \"\", \"No end of line here!\")\n"
    " ```\n"
).
-spec split(splitter(), binary()) -> {binary(), binary(), binary()}.
split(Splitter, String) ->
    splitter_ffi:split(Splitter, String).

-file("src/splitter.gleam", 18).
?DOC(
    " Create a new splitter for a given list of substrings.\n"
    "\n"
    " Substrings are matched for in the order the appear in the list, if one\n"
    " substring is the substring of another place it later in the list than the\n"
    " superstring.\n"
    "\n"
    " Empty strings are discarded, and an empty list will not split off any\n"
    " prefix.\n"
    "\n"
    " There is a small cost to creating a splitter, so if you are going to split\n"
    " a string multiple times, and you want as much performance as possible, then\n"
    " it is better to reuse the same splitter than to create a new one each time.\n"
).
-spec new(list(binary())) -> splitter().
new(Substrings) ->
    _pipe = Substrings,
    _pipe@1 = gleam@list:filter(_pipe, fun(X) -> X /= <<""/utf8>> end),
    splitter_ffi:new(_pipe@1).
