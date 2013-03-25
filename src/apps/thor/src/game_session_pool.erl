
-module(game_session_pool).

-behaviour(supervisor).

%% API
-export([start_link/0, add_child/2, start_session/2, stop_child/1, ping_session/1]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_session(UUID, ID) ->
	%check whether we've already started this session
	Pid = add_child(UUID, ID),
	Pid.

%% callbacks

ping_session(UserID) ->
	SessionPid = gproc:lookup_local_name(UserID),
	%should we use timout and pid validation?
	gen_server:call(SessionPid, ping).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

add_child(UUID, ID) ->
	{ok, Pid} = supervisor:start_child(?MODULE, [UUID, ID]),
	Pid.

stop_child(Pid) ->
	supervisor:terminate_child(?MODULE, Pid).

init([]) ->
	GameSessionSpec = {erlang:make_ref(), 
						{game_session, start_link, []}, 
						temporary, 2000, worker, [game_session]},

	{ok, {{simple_one_for_one, 0, 1}, [GameSessionSpec]}}.
