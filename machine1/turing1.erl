-module(turing1).
-behaviour(gen_statem).
-export([start/0]).
-export([start_link/1]).
-export([callback_mode/0]).
-export([init/1]).
-export([terminate/3]).
-export([code_change/4]).
-export([b/3]).
-export([o/3]).
-export([q/3]).
-export([f/3]).
-export([p/3]).
-define(MAX_STEPS, 150).

callback_mode() ->
    state_functions.

start_link([]) ->
    gen_statem:start_link({local,?MODULE}, ?MODULE, _Args = [], []).

start() ->
    gen_statem:cast(?MODULE, start).

init([]) ->
    Data = #{tape => ""},
    {ok, b, Data}.

b(cast, start, #{} = Data) ->
    io:format("Starting at b ~n", []),
    Tape = "ee0_0",
    Index = 3,
    Current = $0,
    {next_state,
     o,
     Data#{tape => Tape,
           index => Index,
           current => Current,
           count => 0},
     [{next_event, internal, step}]}.
%b(internal, step, #{} = Data) ->
    %Tape = "ee0_0",
    %Index = 3,
    %Current = 0,
    %{keep_state, #{}}.

o(internal, step, #{count := Count} = Data) when Count >= ?MAX_STEPS ->
    io:format("Stopping at o ~p~n", [?MAX_STEPS]),
    {next_state,
     b,
     Data};
o(internal, step, #{current := $0,
                    count := Count} = Data0) ->
    Data = Data0#{count => Count + 1},
    io:format("o, ~p ->~n   ~p~n", [Data0, Data]),
    {next_state,
     q,
     Data,
     [{next_event, internal, step}]};
o(internal, step, #{tape := Tape0,
                    index := Index0,
                    current := $1,
                    count := Count} = Data0) ->
    % Go right, print 'x', go 3 left
    Index = Index0 + 1,
    Tape1 = grow(Tape0, Index),
    Tape2 = print(Tape1, Index, $x),
    Index1 = Index - 3,
    Current = lists:nth(Index1, Tape2),

    Data = Data0#{tape => Tape2,
                  index => Index1,
                  current => Current,
                  count => Count + 1},

    io:format("o, ~p ->~n   ~p~n", [Data0, Data]),
    {next_state,
     o,
     Data,
     [{next_event, internal, step}]}.

q(internal, step, #{count := Count} = Data) when Count >= ?MAX_STEPS ->
    io:format("Stopping q at ~p~n", [?MAX_STEPS]),
    {next_state,
     b,
     Data};
q(internal, step, #{tape := Tape0,
                    index := Index0,
                    current := $_,
                    count := Count} = Data0) ->
    % print 1, left
    Tape = print(Tape0, Index0, $1),
    Index = Index0 - 1,
    Current = lists:nth(Index, Tape),

    Data = Data0#{tape => Tape,
                  index => Index,
                  current => Current,
                  count => Count + 1},

    io:format("q, ~p ->~n   ~p~n", [Data0, Data]),

    {next_state,
     p,
     Data,
     [{next_event, internal, step}]};
q(internal, step, #{tape := Tape0,
                    index := Index0,
                    current := _Any,
                    count := Count} = Data0) ->
    % right x 2
    Index = Index0 + 2,
    Tape = grow(Tape0, Index),
    Current = lists:nth(Index, Tape),

    Data = Data0#{tape => Tape,
                  index => Index,
                  current => Current,
                  count => Count + 1},

    io:format("q, ~p ->~n   ~p~n", [Data0, Data]),

    {next_state,
     q,
     Data,
     [{next_event, internal, step}]}.

p(internal, step, #{count := Count} = Data) when Count >= ?MAX_STEPS ->
    io:format("Stopping at p ~p~n", [?MAX_STEPS]),
    {next_state,
     b,
     Data};
p(internal, step, #{tape := Tape0,
                    index := Index0,
                    current := $_,
                    count := Count} = Data0) ->
    % left x 2
    Index = Index0 - 2,
    Current = lists:nth(Index, Tape0),

    Data = Data0#{index => Index,
                  current => Current,
                  count => Count + 1},

    io:format("p, ~p ->~n   ~p~n", [Data0, Data]),

    {next_state,
     p,
     Data,
     [{next_event, internal, step}]};
p(internal, step, #{tape := Tape0,
                    index := Index0,
                    current := $x,
                    count := Count} = Data0) ->
    % print 1, left
    Tape = print(Tape0, Index0, $_),
    Index = Index0 + 1,
    Tape2 = grow(Tape, Index),
    Current = lists:nth(Index, Tape),

    Data = Data0#{tape => Tape2,
                  index => Index,
                  current => Current,
                  count => Count + 1},

    io:format("p, ~p ->~n   ~p~n", [Data0, Data]),

    {next_state,
     q,
     Data,
     [{next_event, internal, step}]};
p(internal, step, #{tape := Tape0,
                    index := Index0,
                    current := $e,
                    count := Count} = Data0) ->
    % right
    Index = Index0 + 1,
    Tape = grow(Tape0, Index),
    Current = lists:nth(Index, Tape),

    Data = Data0#{tape => Tape,
                  index => Index,
                  current => Current,
                  count => Count + 1},

    io:format("p, ~p ->~n   ~p~n", [Data0, Data]),

    {next_state,
     f,
     Data,
     [{next_event, internal, step}]}.

f(internal, step, #{count := Count} = Data) when Count >= ?MAX_STEPS ->
    io:format("Stopping f at ~p~n", [?MAX_STEPS]),
    {next_state,
     b,
     Data};
f(internal, step, #{tape := Tape0,
                    index := Index0,
                    current := $_,
                    count := Count} = Data0) ->

    % print 0, left x 2
    Tape = print(Tape0, Index0, $0),
    Index = Index0 - 2,
    Current = lists:nth(Index, Tape),

    Data = Data0#{tape => Tape,
                  index => Index,
                  current => Current,
                  count => Count + 1},

    io:format("f, ~p ->~n   ~p~n", [Data0, Data]),

    {next_state,
     o,
     Data,
     [{next_event, internal, step}]};
f(internal, step, #{tape := Tape0,
                    index := Index0,
                    current := _Any,
                    count := Count} = Data0) ->
    % right x 2
    Index = Index0 + 2,
    Tape = grow(Tape0, Index),
    Current = lists:nth(Index, Tape),

    Data = Data0#{tape => Tape,
                  index => Index,
                  current => Current,
                  count => Count + 1},

    io:format("f, ~p ->~n   ~p~n", [Data0, Data]),

    {next_state,
     f,
     Data,
     [{next_event, internal, step}]}.

terminate(_Reason, _State, _Data) ->
    io:format("turing1 statem shutting down.~n", []),
    ok.

code_change(_Vsn, State, Data, _Extra) ->
    {ok, State, Data}.

grow(List, Index) when length(List) >= Index ->
    %io:format("length of List ~p, ~p >= Index ~p~n",
              %[List, length(List), Index]),
    List;
grow(List, Index) ->
    %io:format("length of List ~p, ~p < Index ~p~n",
              %[List, length(List), Index]),
    grow(List ++ "_", Index).

print(List, Index, Char) ->
    {Start, [_ | End]} = lists:split(Index - 1, List),
    Start ++ [Char | End].
