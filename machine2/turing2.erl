-module(turing2).

-export([growing_ones/0]).
-export([ones/0]).
-export([step/1]).

-define(MAX_COUNT, 50).

growing_ones() ->
    step(fun growing_ones/2).

growing_ones(none, _) ->
    {["Pe","R","Pe","R","P0","R","R","P0","L","L"], o};
growing_ones(o, "1") ->
    {["R","Px","L","L","L"], o};
growing_ones(o, "0") ->
    {[], q};
growing_ones(q, ZeroOrOne) when ZeroOrOne == "0"; ZeroOrOne == "1" ->
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

ones() ->
    step(fun ones/2).

ones(none, _) ->
    {[], ones};
ones(ones, _) ->
    {["P1", "R", "R"], ones}.



step(Conf) ->
    step(none, "_", 1, "_", Conf, 0).

step(State, Symbol, Index, Tape, _, Count) when Count >= ?MAX_COUNT ->
    io:format("Stopping: ~p, ~p, ~p,~n~p~n~p~n",
              [State, Symbol, Index, Tape, Count]);
step(State, Symbol0, Index0, Tape0, Conf, Count) ->
    %io:format("~p, ~p, ~p,~n~p,~n~p~n",
              %[State, Symbol0, Index0, Tape0, Count]),
    {Instructions, Next} = Conf(State, Symbol0),
    {Tape, Index} = calc(Instructions, Tape0, Index0),
    Symbol = [lists:nth(Index, Tape)],
    io:format("~p, ~p, ~p, ~p, ~p~n",
              [State, Symbol, Index, Count, Tape]),
    step(Next, Symbol, Index, Tape, Conf, Count + 1).

calc([], Tape, Index) ->
    {Tape, Index};
calc([[$P, X] | Rest], Tape, Index) ->
    calc(Rest, print(Tape, Index, X), Index);
calc(["R" | Rest], Tape, Index0) ->
    Index = Index0 + 1,
    calc(Rest, grow(Tape, Index, right), Index);
calc(["L" | Rest], Tape, 1) ->
    calc(Rest, grow(Tape, length(Tape) + 1, left), 1);
calc(["L" | Rest], Tape, Index) ->
    calc(Rest, Tape, Index - 1);
calc(["E" | Rest], Tape, Index) ->
    calc(Rest, print(Tape, Index, $_), Index).

grow(List, Index, _) when length(List) >= Index ->
    List;
grow(List, Index, right) ->
    grow(List ++ "_", Index, right);
grow(List, Index, left) ->
    grow([$_ | List], Index, left).

print(List, Index, Char) ->
    {Start, [_ | End]} = lists:split(Index - 1, List),
    Start ++ [Char | End].

