-module(m_ones).

-export([run/0]).

run() ->
    turing2:step(fun ones/2).

ones(none, _) ->
    {[], ones};
ones(ones, _) ->
    {["P1", "R", "R"], ones}.
