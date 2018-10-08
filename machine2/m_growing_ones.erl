-module(m_growing_ones).

-export([run/0]).

run() ->
    turing2:step(fun growing_ones/2).

growing_ones(none, _) ->
    {["Pe","R","Pe","R","P0","R","R","P0","L","L"], o};
growing_ones(o, "1") ->
    {["R","Px","L","L","L"], o};
growing_ones(o, "0") ->
    {[], q};
growing_ones(q, Bit) when Bit == "0"; Bit == "1" ->
    {["R","R"], q};
growing_ones(q, "_") ->
    {["P1","L"], p};
growing_ones(p, "x") ->
    {["E","R"], q};
growing_ones(p, "e") ->
    {["R"], f};
growing_ones(p, "_") ->
    {["L","L"], p};
growing_ones(f, "_") ->
    {["P0","L","L"], o};
growing_ones(f, _) ->
    {["R","R"], f}.
