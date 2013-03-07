
-module(login_handler).

-behaviour(cowboy_http_handler).
 
-export([init/3]).
-export([handle/2]).
-export([terminate/3]).
 
init({tcp, http}, Req, Opts) ->
    {ok, Req, undefined_state}.
 
handle(Req, State) ->
	io:format("in login: ~p~n", [self()]),
	Name = case cowboy_req:binding(name, Req) of
		{SomeName, _} -> 
			if is_binary(SomeName) -> 
		 	  SomeName;
		 	true ->
		 		<<"unknown">>
		 	end
		end,

  Body = mochijson2:encode({struct, [{<<"data">>, Name}]}),
  Headers = [
    {<<"content-type">>, <<"application/json">>}
  ],
  {ok, Req2} = cowboy_req:reply(200, Headers, Body, Req),
  {ok, Req2, State}.

 
terminate(Reason, Req, State) ->
	io:format("out of login:~p~n", [self()]),
    ok.