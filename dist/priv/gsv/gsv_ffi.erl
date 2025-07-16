-module(gsv_ffi).
-export([slice/3, drop_bytes/2]).

slice(String, Index, Length) ->
    binary:part(String, Index, Length).

drop_bytes(String, Bytes) ->
    case String of
        <<_:Bytes/bytes, Rest/binary>> -> Rest;
        _ -> String
    end.
