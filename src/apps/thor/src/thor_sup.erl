
-module(thor_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
	% RestartStrategy = one_for_one,
	% MaxRestarts = 10,
	% MaxSecondsBetweenRestarts = 3600,
    
 % 	SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

 	GameSessionPoolSpec = {game_session_pool, 
 							{game_session_pool, start_link, []}, 
 							permanent, infinity, supervisor, [game_session_pool]},

 %    Restart = permanent,
 %    Shutdown = 2000,
 %    Type = worker,
 %    {ok, MapFile} = application:get_env(world_map),
 %    Map = 
 %        {browserquest_srv_map,
 %         {browserquest_srv_map, start_link, [MapFile]},
 %         Restart, Shutdown, Type, [browserquest_srv_map]},

 %    MobSup = 
 %        {browserquest_srv_mob_sup,
 %         {browserquest_srv_mob_sup, start_link, []},
 %         Restart, Shutdown, Type, [browserquest_srv_mob_sup]},
    
 %    EntityHandler = 
 %        {browserquest_srv_entity_handler,
 %         {browserquest_srv_entity_handler, start_link, []},
 %         Restart, Shutdown, Type, [browserquest_srv_entity_handler]},
    
    
 %    {ok, {SupFlags, [Map, MobSup, EntityHandler]}}.

    {ok, {{one_for_one, 5, 10}, [GameSessionPoolSpec]}}.

