%% Copyright
-module(mochijson2_helper).
-author("reenboog").

%% API
-export([get_field/2]).

get_field(Path, Struct) when is_tuple(Path) ->
  get_val(tuple_to_list(Path), Struct);
get_field(Key, {struct, List}) ->
  proplists:get_value(Key, List).

get_val(_, undefined) ->
  undefined;
get_val([Key], Struct) ->
  get_field(Key, Struct);
get_val([Key | Tail], Struct) ->
  get_val(Tail, get_field(Key, Struct)).