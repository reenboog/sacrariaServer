
-module(game_session_ping_handler).

-behaviour(cowboy_http_handler).
 
-export([init/3]).
-export([handle/2]).
-export([terminate/3]).
 
init({tcp, http}, Req, _Opts) ->
    {ok, Req, undefined_state}.
 
handle(Req, State) ->
	{Method, _} = cowboy_req:method(Req),
	handle(Method, Req, State).

handle(<<"GET">>, Req, State) ->
    %validate the session data: id and uuid
	{UserID, Req1} = cowboy_req:qs_val(<<"user_id">>, Req, <<"undefined">>),
	
    %should we use synchronous call instead fo casting?
    %should we check the session's state?
    PingResponse = game_session_pool:ping_session(UserID),
    
	Headers = [
        {<<"content-type">>, <<"application/json">>}
    ],

    Response = mochijson2:encode({struct, 
                                    [{<<"response">>, PingResponse}]}),

    {ok, Req2} = cowboy_req:reply(200, Headers, Response, Req1),
	{ok, Req2, State};

handle(_Method, _Req, _State) ->
    ok.
 
terminate(_Reason, _Req, _State) ->
    ok.