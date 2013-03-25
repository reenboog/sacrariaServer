-module(thor_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    
	ListeningPort = 
	case application:get_env(listening_port) of
	    undefined ->
		8000;
	    {ok, Port} ->
		Port
	end,

    Dispatch = cowboy_router:compile([
		%% {URIHost, list({URIPath, Handler, Opts})}
		{'_', [
				{"/login/", login_handler, []},
				{"/ping/", game_session_ping_handler, []},
				{'_', default_handler, []}]
		}
		%{"test.localhost", [{"/update/", default_handler, []}]}
			
		%{'_', [{"/test/", default_handler, []}]}
	]),

	%% Name, NbAcceptors, TransOpts, ProtoOpts
	cowboy:start_http(http, 100,
		[{port, ListeningPort}],
	    [{env, [{dispatch, Dispatch}]}]
	),

    thor_sup:start_link().

stop(_State) ->
    ok.
