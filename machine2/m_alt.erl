-module(m_alt).
-export([run/0]).

run() ->
    turing2:step(fun alt/2).

alt(none, _) ->
    {["P0", "R", "R"], 1};
alt(1, _) ->
    {["P1", "R", "R"], none}.
