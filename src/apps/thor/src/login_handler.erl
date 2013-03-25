
-module(login_handler).

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
    %log in
    %validate the ids and reply with an error in case of either error
    {UserID, Req1} = cowboy_req:qs_val(<<"user_id">>, Req, <<"Unknown_id">>),
    {UUID, Req2} = cowboy_req:qs_val(<<"user_uuid">>, Req1, <<"Unknown_uuid">>),

    Headers = [
        {<<"content-type">>, <<"application/json">>}
    ],

    HostsList = [<<"http://localhost:8097">>],

    %%check whether we're already started
    SessionPid = 
        case gproc:lookup_local_name(UserID) of
            undefined -> game_session_pool:start_session(UUID, UserID);
            Pid -> Pid
        end,

    Response = mochijson2:encode({struct, 
                                    [{<<"hosts">>, HostsList},
                                    {<<"response">>, <<"ok">>}]}),

    {ok, Req3} = cowboy_req:reply(200, Headers, Response, Req2),
    {ok, Req3, State};

handle(<<"PUT">>, Req, State) ->
    %register
    UserUUID = list_to_binary(uuid:to_string(uuid:uuid4())),
    UserID = <<"_419842">>,

    Headers = [
        {<<"content-type">>, <<"application/json">>}
    ],

    Response = mochijson2:encode({struct, [{<<"uuid">>, UserUUID}, {<<"id">>, UserID}]}),

    {ok, Req1} = cowboy_req:reply(201, Headers, Response, Req),
    {ok, Req1, State};
handle(_Method, _Req, _State) ->
    ok.

terminate(_Reason, _Req, _State) ->
    ok.