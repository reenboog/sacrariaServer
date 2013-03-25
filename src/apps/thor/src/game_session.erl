
-module(game_session).

-behaviour(gen_server).

%% API
-export([start_link/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).


-record(state, {id, uuid}).

%% API
start_link(UUID, ID) ->
    gen_server:start_link(?MODULE, [UUID, ID], []).

init([UUID, ID]) ->
	io:format("Launched session [~p;~p].~n", [UUID, ID]),

    %register under the gproc
    gproc:add_local_name(ID),

	{ok, #state{uuid = UUID, id = ID}}.

handle_call(ping, _From, State = #state{uuid = UUID, id = ID}) ->
    io:format("Received ping for session [~p;~p].~n", [UUID, ID]),
    {reply, <<"ok">>, State};

handle_call(_Req, _From, State) ->  
    {reply, ok, State}.

handle_cast(_Req, State) ->
    {stop, normal, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State = #state{uuid = UUID, id = ID}) ->
	io:format("Finished session [~p;~p].~n", [UUID, ID]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
