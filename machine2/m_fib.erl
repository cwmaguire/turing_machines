-module(m_fib).
-export([run/0]).
-export([run/1]).

% calculate fibonacci numbers in binary

run() ->
    run(100).

run(Count) ->
    turing2:step(fun fib/2, Count).

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
    {["P@", "R", "P0", "R", "Px", "R", "P0", "R", "Py", "R", "P1", "R", "Pz"],
     reset_find_next_digit_of_2nd_num};

fib(reset_find_next_digit_of_1st_num, "@") ->
    {[], find_next_digit_of_1st_num};
fib(reset_find_next_digit_of_1st_num, _) ->
    {["L", "L"], reset_find_next_digit_of_1st_num};

fib(find_next_digit_of_1st_num, "x") ->
    {["E", "R", "R"], move_x};
% No more x, so no more digits of first number
fib(find_next_digit_of_1st_num, "Y") ->
    % We're done!
    {[], reset_flip_y_to_x};
    %{[], reset_find_next_digit_of_2nd_num};
fib(find_next_digit_of_1st_num, _) ->
    {["R", "R"], find_next_digit_of_1st_num};

fib(move_x, "y") ->
    {["L"], write_next_digit_of_1st_num};
% TODO figure this out
fib(move_x, "x") ->
    {["L"], 'FIGURE OUT 2ND DIGIT OF FIRST NUMBER'};

fib(write_next_digit_of_1st_num, "0") ->
    {["R"], write_first_digit_0};
fib(write_next_digit_of_1st_num, "1") ->
    {["R"], write_first_digit_1};

fib(write_1st_digit_0, "c") ->
    {[], reset_find_next_digit_of_2nd_num};
% Look for blank, C or c
fib(write_1st_digit_0, _) ->
    {["R", "R"], write_first_digit_0};

fib(write_first_digit_1, "_") ->
    {["Pc", "L", "P1"], reset_find_next_digit_of_2nd_num};
fib(write_first_digit_1, "c") ->
    {["E", "R", "R", "Pc", "L"], maybe_carry};
fib(write_first_digit_1, _) ->
    {["R", "R"], write_first_digit_1};

fib(maybe_carry, "1") ->
    {["E", "P0", "R", "R"], maybe_carry};
fib(maybe_carry, _) ->
    {["E", "P1"], reset_find_next_digit_of_2nd_num};

fib(reset_find_next_digit_of_2nd_num, "@") ->
    {[], find_next_digit_of_2nd_num};
fib(reset_find_next_digit_of_2nd_num, _) ->
    {["L", "L"], reset_find_next_digit_of_2nd_num};

% TODO this is going to flip every 'y' to 'Y' so I'll have to come
% back and erase all but the first and flip the first to an 'x' once
% I've finished the addition
fib(find_next_digit_of_2nd_num, "y") ->
    {["E", "PY", "R", "R"], move_y};
fib(find_next_digit_of_2nd_num, "z") ->
    {[], find_next_digit_of_1st_num}
    %{[], reset_flip_y_to_x};
fib(find_next_digit_of_2nd_num, _) ->
    {["R", "R"], find_next_digit_of_2nd_num};

fib(move_y, "z") ->
    {["L"], write_next_digit_of_2nd_num};
fib(move_y, "_") ->
    {["Py", "L"], write_next_digit_of_2nd_num};

fib(write_next_digit_of_2nd_num, "0") ->
    {["R"], write_2nd_digit_0};
fib(write_next_digit_of_2nd_num, "1") ->
    {["R"], write_2nd_digit_1};

% No c found, write one
fib(write_2nd_digit_0, "_") ->
    {["Pc", "L", "P0"], reset_find_next_digit_of_1st_num};
fib(write_2nd_digit_0, "c") ->
    {["E", "R", "R", "Pc", "L"], maybe_zero};
fib(write_first_digit_0, _) ->
    {["R", "R"], write_first_digit_0};

fib(maybe_zero, "_") ->
    {["P0"], reset_find_next_digit_of_2nd_num};
fib(maybe_zero, _) ->
    {[], reset_find_next_digit_of_2nd_num};

% No c found, write one
fib(write_2nd_digit_1, "_") ->
    {["Pc", "L", "P1"], reset_find_next_digit_of_1st_num};
fib(write_2nd_digit_1, "c") ->
    {["E", "R", "R", "Pc", "L"], maybe_carry};
fib(write_2nd_digit_1, _) ->
    {["R", "R"], write_first_digit_1};

fib(maybe_carry, "1") ->
    {["E", "P0", "R", "R"], maybe_carry};
fib(maybe_carry, _) ->
    {["E", "P1"], reset_find_next_digit_of_1st_num};

fib(add_digit_0_to_last, "c") ->
    {["L"], add_digit_0};
fib(add_digit_0_to_last, _) ->
    {["R", "R"], add_digit_0};

% C is for carry, add to left (we've already added space for the carried bit)
fib(add_digit_1_to_last, "C") ->
    {["E", "L"], add_digit_1};
% c is for no-carry, add to right
fib(add_digit_1_to_last, "c") ->
    {["E", "R"], add_digit_1};
fib(add_digit_1_to_last, _) ->
    {["R", "R"], add_digit_1_to_last};

% Unless we're filling in a place holder we don't need to do anything
fib(add_digit_0, "_") ->
    {["P0", "R", "Pc"], reset_find_next_digit_of_1st_num};
fib(add_digit_0, _) ->
    {[], reset_find_next_digit_of_1st_num};

fib(add_digit_1, "_") ->
    {["P1", "R", "E", "R", "R", "Pc"],
     reset_find_next_digit_of_1st_num};
fib(add_digit_1, "0") ->
    {["E", "P1", "R", "E", "R", "R", "Pc"],
     reset_find_next_digit_of_1st_num};
fib(add_digit_1, "1") ->
    % 1 + 1 = 10, which is 01 backwards, so erase the current 1,
    % write 0, erase the "carry" flag, write a 1, re-write the carry
    % flag after the new 1
    {["E", "P0", "R", "E", "R", "P1", "R", "Pc"],
     reset_find_next_digit_of_1st_num};

fib(reset_flip_y_to_x, "@") ->
    {[], flip_y_to_x};
fib(reset_flip_y_to_x, _) ->
    {["L"], reset_flip_y_to_x};

fib(flip_y_to_x, "Y") ->
    {["E", "Px"], clear_y};
fib(flip_y_to_x, _) ->
    {["R", "R"], flip_y_to_x};

fib(clear_y, "Y") ->
    {["E", "R", "R"], clear_y};
fib(clear_y, "z") ->
    {[], flip_z_to_y};
fib(clear_y, _) ->
    {["R", "R"], clear_y};

fib(flip_z_to_y, "z") ->
    {["E", "Py"], flip_c_to_z};
% FIXME not sure if we can get here: are there
% any spaces between the last Y and the z?
fib(flip_z_to_y, _) ->
    {["R", "R"], flip_z_to_y};

fib(flip_c_to_z, "c") ->
    % LOOP!
    {["E", "Pz"], reset_find_next_digit_of_1st_num};
fib(flip_c_to_z, _) ->
    {["R", "R"], flip_c_to_z}.

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
