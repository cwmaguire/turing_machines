-module(m_fib).
-export([run/0]).

% Calculate fibonacci numbers in binary

run() ->
    turing2:step(fun fib/2).

% write out all the binary bits between x and y and between y and z
% and then add those together and add them after z
% After I write each bit of each number I can move the start marker
% for that number up one.

% Flip the numbers around, add the farthest bits, store the carry bit
% I could mark the carry with a c
% 1c1 would mean 3 with a carry in the 2's column
%
% If I store all the numbers in reverse order then once I have the sum
% then I don't need to change it, just mark it as the last digit

fib(none, _) ->
    {["P@", "R", "Px", "R", "P0", "R", "Py", "R", "P1", "R", "Pz"],
     reset_find_next_digit_of_1st_num};

fib(reset_find_next_digit_of_1st_num, "@") ->
    {[], find_next_digit_of_1st_num};
fib(reset_find_next_digit_of_1st_num, _) ->
    {[], reset_find_next_digit_of_1st_num};

fib(find_next_digit_of_1st_num, "x") ->
    {["E", "R", "R"], move_x};
fib(find_next_digit_of_1st_num, _) ->
    {[], find_next_digit_of_1st_num};

fib(move_x, "y") ->
    {["L"], write_next_digit_of_1st_num};
% TODO figure this out
fib(move_x, "x") ->
    {["L"], 'FIGURE OUT 2ND DIGIT OF FIRST NUMBER'};

fib(write_next_digit_of_1st_num, 0) ->
    {["R", "R"], write_first_digit_0};
fib(write_next_digit_of_1st_num, 1) ->
    {["R", "R"], write_first_digit_1};

fib(write_first_digit_0, "_") ->
    {["P0", "R", "PC"], reset_find_next_digit_of_2nd_num};
fib(write_first_digit_0, _) ->
    {["R", "R"], write_first_digit_0};

fib(write_first_digit_1, "_") ->
    {["P1", "R", "PC"], reset_find_next_digit_of_2nd_num};
fib(write_first_digit_1, _) ->
    {["R", "R"], write_first_digit_1};

fib(reset_find_next_digit_of_2nd_num, "@") ->
    {[], find_next_digit_of_2nd_num};
fib(reset_find_next_digit_of_2nd_num, "_") ->
    {["L", "L"], reset_find_next_digit_of_2nd_num};

fib(find_next_digit_of_2nd_num, "y") ->
    {["E", "PY", "R", "R"], move_y};

%% @0x0y1z - start
%%       ^ -   flip to "reset to find next digit of first number"
%% @0x0y1z - no @, go left 2
%%       ^
%% @0x0y1z - no @, go left 2
%%     ^
%% @0x0y1z - no @, go left 2
%%   ^
%% @0x0y1z - found @, switch to "find next digit of first number"
%% ^
%% @0x0y1z - no x, go right 2
%% ^
%% @0x0y1z - found x, erase x, move right 2, flip to "move x"
%%   ^
%% @0_0y1z - found y, don't need to do anything, move left,
%%     ^   - flip to "write 1st number next digit"
%% @0_0y1z - found 0, right x 2, flip to "write 1st digit zero"
%%    ^
%% @0_0y1z - No blank, right x 2
%%      ^
%% @0_0y1z  - Found blank, write 0, right, write c,
%%        ^ - flip to "reset to find next digit of 2nd number"
%% @0_0y1z0c - Not @, left 2
%%         ^
%% @0_0y1z0c - Not @, left 2
%%       ^
%% @0_0y1z0c - Not @, left 2
%%     ^
%% @0_0y1z0c - Not @, left 2
%%   ^
%% @0_0y1z0c - Found @, switch to "find next digit of 2nd number"
%% ^
%% @0_0y1z0c - no y, right x 2
%% ^
%% @0_0y1z0c - no y, right x 2
%%   ^
%% @0_0y1z0c - found 'y', erase, write 'Y', right x 2, flip to "move y"
%%     ^
%% @0_0Y1z0c - no y, right x 2
%%     ^
%% @0_0Y1z0c - found 'z', left, flip to "write 2nd number next digit"
%%       ^
%% @0_0Y1z0c - found 1, right, flip to "write last digit one"
%%      ^
%% @0_0Y1z0c - not c, right x 2
%%       ^
%% @0_0Y1z0c - found c, left, flip to "add 1"
%%         ^
%% @0_0Y1z0c - found 0, erase, write 1, right, erase, right x 2, write 'c',
%%        ^  - flip to "reset to find next digit of first number"
%% @0_0Y1z1  c - Not @, left 2
%%           ^
%% @0_0Y1z1  c - Not @, left 2
%%         ^
%% @0_0Y1z1  c - Not @, left 2
%%       ^
%% @0_0Y1z1  c - Not @, left 2
%%     ^
%% @0_0Y1z1  c - Not @, left 2
%%   ^
%% @0_0Y1z1  c - Not @, left 2
%% ^
%% @0_0Y1z1  c - Found @, switch to "find next digit of 1st number"
%% ^
%% @0_0Y1z1  c - no x, right x 2
%% ^
%% @0_0Y1z1  c - no x, right x 2
%%   ^
%% @0_0Y1z1  c - found 'Y' instead of x, change y, right x 2, flip to "move x"
%%     ^
%% @0_0Y1z1  c  - Found blank, write 0, right, write c,
%%     ^        - flip to "reset to find next digit of 2nd number"
%% @0_0Y1z1  c - Not @, left 2
%%     ^
%% @0_0Y1z1  c - Not @, left 2
%%   ^
%% @0_0Y1z1  c - Found @, switch to "find next digit of 2nd number"
%% ^
%% @0_0Y1z1  c - no y, right x 2
%%   ^
%% @0_0Y1z1  c - no y, right x 2
%%     ^
%% @0_0Y1z1  c - Found z, left x 2, flip to "reset x"
%%       ^
%% @0_0x1z1  c - Found Y, write x, right x 2, flip to "reset y"
%%     ^
%% @0_0x1z1  c - Found z, write y, right, flip to "reset z"
%%       ^
%% @0_0x1y1  c - Found digit, right x 2
%%        ^
%% @0_0x1y1  c - Found blank, left, write z, right 2 x, erase, flip to
%%          ^  - flip to "reset to find next digit of first number"
%%
%% At this point I _could_ flip the previous digit
