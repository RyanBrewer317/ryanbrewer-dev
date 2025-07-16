-module(glearray).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([new/0, from_list/1, to_list/1, length/1, get/2, get_or_default/3, copy_set/3, copy_push/2, copy_insert/3]).
-export_type([array/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-type array(EWW) :: any() | {gleam_phantom, EWW}.

-file("src/glearray.gleam", 32).
?DOC(
    " Returns an empty array.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " > new()\n"
    " from_list([])\n"
    " ```\n"
).
-spec new() -> array(any()).
new() ->
    glearray_ffi:new().

-file("src/glearray.gleam", 38).
?DOC(" Converts a list to an array.\n").
-spec from_list(list(EWZ)) -> array(EWZ).
from_list(List) ->
    erlang:list_to_tuple(List).

-file("src/glearray.gleam", 44).
?DOC(" Converts an array to a list.\n").
-spec to_list(array(EXC)) -> list(EXC).
to_list(Array) ->
    erlang:tuple_to_list(Array).

-file("src/glearray.gleam", 66).
?DOC(
    " Returns the number of elements in the array.\n"
    "\n"
    " ## Performance\n"
    "\n"
    " This function is very efficient and runs in constant time.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " > length(new())\n"
    " 0\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " > from_list([8, 0, 0]) |> length\n"
    " 3\n"
    " ```\n"
).
-spec length(array(any())) -> integer().
length(Array) ->
    erlang:tuple_size(Array).

-file("src/glearray.gleam", 167).
-spec is_valid_index(array(any()), integer()) -> boolean().
is_valid_index(Array, Index) ->
    (Index >= 0) andalso (Index < erlang:tuple_size(Array)).

-file("src/glearray.gleam", 90).
?DOC(
    " Returns the element at the specified index, starting from 0.\n"
    "\n"
    " `Error(Nil)` is returned if `index` is less than 0 or greater than\n"
    " or equal to `length(array)`.\n"
    "\n"
    " ## Performance\n"
    "\n"
    " This function is very efficient and runs in constant time.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " > from_list([5, 6, 7]) |> get(1)\n"
    " Ok(6)\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " > from_list([5, 6, 7]) |> get(3)\n"
    " Error(Nil)\n"
    " ```\n"
).
-spec get(array(EXH), integer()) -> {ok, EXH} | {error, nil}.
get(Array, Index) ->
    glearray_ffi:get(Array, Index).

-file("src/glearray.gleam", 119).
?DOC(
    " Returns the element at the specified index, starting from 0.\n"
    "\n"
    " The specified default is returned if `index` is less than 0 or\n"
    " greater than / or equal to `length(array)`.\n"
    "\n"
    " ## Performance\n"
    "\n"
    " This function is very efficient and runs in constant time.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " > from_list([5, 6, 7]) |> get_or_default(1, -1)\n"
    " 6\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " > from_list([5, 6, 7]) |> get_or_default(3, -1)\n"
    " -1\n"
    " ```\n"
).
-spec get_or_default(array(EXL), integer(), EXL) -> EXL.
get_or_default(Array, Index, Default) ->
    glearray_ffi:get_or_default(Array, Index, Default).

-file("src/glearray.gleam", 153).
?DOC(
    " Replaces the element at the given index with `value`.\n"
    "\n"
    " This function cannot extend an array and returns `Error(Nil)` if `index` is\n"
    " not valid.\n"
    " See also [`copy_insert`](#copy_insert) and [`copy_push`](#copy_push).\n"
    "\n"
    " ## Performance\n"
    "\n"
    " This function has to copy the entire array, making it very inefficient\n"
    " especially for larger arrays.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " > from_list([\"a\", \"b\", \"c\"]) |> copy_set(1, \"x\")\n"
    " Ok(from_list([\"a\", \"x\", \"c\"]))\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " > from_list([\"a\", \"b\", \"c\"]) |> copy_set(3, \"x\")\n"
    " Error(Nil)\n"
    " ```\n"
).
-spec copy_set(array(EXP), integer(), EXP) -> {ok, array(EXP)} | {error, nil}.
copy_set(Array, Index, Value) ->
    glearray_ffi:set(Array, Index, Value).

-file("src/glearray.gleam", 187).
?DOC(
    " Adds a single element to the back of the given array.\n"
    "\n"
    " ## Performance\n"
    "\n"
    " This function has to copy the entire array, making it very inefficient\n"
    " especially for larger arrays.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " > new() |> copy_push(1) |> copy_push(2) |> to_list\n"
    " [1, 2]\n"
    " ```\n"
).
-spec copy_push(array(EXZ), EXZ) -> array(EXZ).
copy_push(Array, Value) ->
    erlang:append_element(Array, Value).

-file("src/glearray.gleam", 227).
?DOC(
    " Inserts an element into the array at the given index.\n"
    "\n"
    " All following elements are shifted to the right, having their index\n"
    " incremented by one.\n"
    "\n"
    " `Error(Nil)` is returned if the index is less than 0 or greater than\n"
    " `length(array)`.\n"
    " If the index is equal to `length(array)`, this function behaves like\n"
    " [`copy_push`](#copy_push).\n"
    "\n"
    " ## Performance\n"
    "\n"
    " This function has to copy the entire array, making it very inefficient\n"
    " especially for larger arrays.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " > from_list([\"a\", \"b\"]) |> copy_insert(0, \"c\")\n"
    " Ok(from_list([\"c\", \"a\", \"b\"]))\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " > from_list([\"a\", \"b\"]) |> copy_insert(1, \"c\")\n"
    " Ok(from_list([\"a\", \"c\", \"b\"]))\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " > from_list([\"a\", \"b\"]) |> copy_insert(2, \"c\")\n"
    " Ok(from_list([\"a\", \"b\", \"c\"]))\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " > from_list([\"a\", \"b\"]) |> copy_insert(3, \"c\")\n"
    " Error(Nil)\n"
    " ```\n"
).
-spec copy_insert(array(EYC), integer(), EYC) -> {ok, array(EYC)} | {error, nil}.
copy_insert(Array, Index, Value) ->
    glearray_ffi:insert(Array, Index, Value).
