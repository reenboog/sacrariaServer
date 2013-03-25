
-module(default_handler).

-behaviour(cowboy_http_handler).
 
-export([init/3]).
-export([handle/2]).
-export([terminate/3]).
 
init({tcp, http}, Req, _Opts) ->
    {ok, Req, undefined_state}.
 
handle(Req, State) ->
	io:format("in: ~p~n", [self()]),
    {ok, Req2} = cowboy_req:reply(200, [], <<"Hello World!">>, Req),
    {ok, Req2, State}.
 
terminate(_Reason, _Req, _State) ->
	io:format("out:~p~n", [self()]),
    ok.