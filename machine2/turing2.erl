-module(turing2).

-export([step/1]).
-export([step/2]).

-define(MAX_COUNT, 50).

step(Conf) ->
    step(Conf, ?MAX_COUNT).
step(Conf, MaxCount) ->
    step(none, "_", 1, "_", Conf, 0, MaxCount).

step(State, Symbol, Index, Tape, _, Count, Max) when Count >= Max ->
    io:format("Stopping at Max ~p: ~p, ~p, ~p,~n~p~n~p~n",
              [Max, State, Symbol, Index, Tape, Count]);
step(State, Symbol0, Index0, Tape0, Conf, Count, Max) ->
    %io:format("~p, ~p, ~p,~n~p,~n~p~n",
              %[State, Symbol0, Index0, Tape0, Count]),
    {Instructions, Next} = Conf(State, Symbol0),
    {Tape, Index} = calc(Instructions, Tape0, Index0),
    Symbol = [lists:nth(Index, Tape)],
    io:format("~p, ~p, ~p, ~p, ~p~n",
              [State, Symbol, Index, Count, Tape]),
    step(Next, Symbol, Index, Tape, Conf, Count + 1, Max).

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

