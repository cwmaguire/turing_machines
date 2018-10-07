-module(turing).
-export([start/0]).

start() ->
    supervisor:start_link(turing_sup, []).
