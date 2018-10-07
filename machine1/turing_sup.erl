-module(turing_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link(turing_sup, []).

init(_Args) ->
    SupFlags = #{strategy => one_for_one, intensity => 1, period => 5},
    ChildSpecs = [#{id => turing,
                    start => {turing1, start_link, [[]]},
                    restart => permanent,
                    shutdown => brutal_kill,
                    type => worker,
                    modules => [turing1]}],
    {ok, {SupFlags, ChildSpecs}}.
