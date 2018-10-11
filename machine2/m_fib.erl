-module(m_fib).
-export([run/0]).
-export([run/1]).
-export([fib/2]).

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
    {["E", "PX", "R", "R"], move_x};
% No more x, so no more digits of first number
fib(find_next_digit_of_1st_num, "Y") ->
    {[], reset_find_next_digit_of_2nd_num};
    %{[], reset_find_next_digit_of_2nd_num};
fib(find_next_digit_of_1st_num, _) ->
    {["R", "R"], find_next_digit_of_1st_num};

fib(move_x, "Y") ->
    {["L"], write_next_digit_of_1st_num};
% TODO figure this out
fib(move_x, "_") ->
    {["Px", "L"], write_next_digit_of_1st_num};

%% Adding a zero does nothing
fib(write_next_digit_of_1st_num, "0") ->
    {["R"], reset_find_next_digit_of_2nd_num};
fib(write_next_digit_of_1st_num, "1") ->
    {["R"], add_digit_1_to_last};

fib(add_digit_1_to_last, "c") ->
    {["L"], maybe_carry_1st};
fib(add_digit_1_to_last, _) ->
    {["R", "R"], add_digit_1_to_last};

fib(maybe_carry_2nd, "1") ->
    {["E", "P0", "R", "R"], maybe_carry_2nd};
fib(maybe_carry_2nd, _) ->
    {["E", "P1", "L"], reset_find_next_digit_of_1st_num};

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
    {[], reset_clear_xs};
    %{[], reset_flip_y_to_x};
    %{[], reset_flip_y_to_x};
fib(find_next_digit_of_2nd_num, _) ->
    {["R", "R"], find_next_digit_of_2nd_num};

fib(move_y, "_") ->
    {["Py", "L"], write_next_digit_of_2nd_num};
fib(move_y, "z") ->
    {["L"], write_next_digit_of_2nd_num};
%fib(move_y, "_") ->
    %{["Py", "L"], write_next_digit_of_2nd_num};

fib(write_next_digit_of_2nd_num, "0") ->
    {["R"], find_z_to_write_0};
fib(write_next_digit_of_2nd_num, "1") ->
    {["R"], find_z_to_write_1};

fib(maybe_zero, "_") ->
    {["P0", "L"], reset_find_next_digit_of_1st_num};
fib(maybe_zero, _) ->
    {["L"], reset_find_next_digit_of_1st_num};

fib(find_z_to_write_1, "z") ->
    {["R"], check_blank_1};
    %{["R"], write_2nd_digit_1};
fib(find_z_to_write_1, _) ->
    {["R", "R"], find_z_to_write_1};

fib(find_z_to_write_0, "z") ->
    {["R"], check_blank_0};
    %{[], write_2nd_digit_0};
fib(find_z_to_write_0, _) ->
    {["R", "R"], find_z_to_write_0};

fib(check_blank_0, "_") ->
    {[], start_number_0};
fib(check_blank_0, _) ->
    {["R"], find_c_write_0};

fib(check_blank_1, "_") ->
    {[], start_number_1};
fib(check_blank_1, _) ->
    {["R"], find_c_write_1};

fib(start_number_0, _) ->
    {["P0", "R", "Pc"], reset_find_next_digit_of_1st_num};

fib(start_number_1, _) ->
    {["P1", "R", "Pc"], reset_find_next_digit_of_1st_num};

fib(find_c_write_0, "c") ->
    {["E", "R", "R", "Pc", "L"], maybe_zero};
fib(find_c_write_0, _) ->
    {["R", "R"], find_c_write_0};

fib(find_c_write_1, "c") ->
    {["E", "R", "R", "Pc", "L"], maybe_carry_2nd};
fib(find_c_write_1, _) ->
    {["R", "R"], find_c_write_1};

% No c found, write one
%fib(write_2nd_digit_0, "_") ->
    %{["Pc", "L", "P0", "L"], reset_find_next_digit_of_1st_num};
%fib(write_2nd_digit_0, "c") ->
    %{["E", "R", "R", "Pc", "L"], maybe_zero};
%fib(write_2nd_digit_0, _) ->
    %{["R", "R"], write_2nd_digit_0};

% No c found, write one
%fib(write_2nd_digit_1, "_") ->
    %{["Pc", "L", "P1", "L"], reset_find_next_digit_of_1st_num};
%fib(write_2nd_digit_1, "c") ->
    %{["E", "R", "R", "Pc", "L"], maybe_carry_2nd};
%fib(write_2nd_digit_1, _) ->
    %{["R", "R"], write_2nd_digit_1};

fib(maybe_carry_1st, "1") ->
    {["E", "P0", "R", "R"], maybe_carry_1st};
fib(maybe_carry_1st, _) ->
    {["E", "P1", "L"], reset_find_next_digit_of_2nd_num};

% fib(add_digit_0_to_last, "c") ->
%     {["L"], add_digit_0};
% fib(add_digit_0_to_last, _) ->
%     {["R", "R"], add_digit_0};

% fib(add_digit_1_to_last, "c") ->
%     {["E", "R"], add_digit_1};
% fib(add_digit_1_to_last, _) ->
%     {["R", "R"], add_digit_1_to_last};

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

fib(reset_clear_xs, "@") ->
    {[], clear_xs};
fib(reset_clear_xs, _) ->
    {["L"], reset_clear_xs};

fib(clear_xs, "Y") ->
    {[], flip_y_to_x};
fib(clear_xs, "x") ->
    {["E", "R", "R"], clear_xs};
fib(clear_xs, "X") ->
    {["E", "R", "R"], clear_xs};
%% We shouldn't hit this
fib(clear_xs, _) ->
    {["R", "R"], clear_xs};

%fib(reset_flip_y_to_x, "@") ->
    %{[], flip_y_to_x};
%fib(reset_flip_y_to_x, _) ->
    %{["L"], reset_flip_y_to_x};

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
    {["E", "Py", "R", "R"], find_c};
% FIXME not sure if we can get here: are there
% any spaces between the last Y and the z?
fib(flip_z_to_y, _) ->
    {["R", "R"], flip_z_to_y};
    %{["R", "R"], flip_z_to_y};

fib(find_c, "c") ->
    {["E", "R"], write_z};
fib(find_c, _) ->
    {["R", "R"], find_c};

fib(write_z, "_") ->
    {["L", "Pz"], reset_find_next_digit_of_2nd_num};
fib(write_z, _) ->
    {["R", "R"], write_z}.

%fib(flip_c_to_z, "_") ->
    %{["L", "L", "L", "E", "R", "R", "Pz"], reset_find_next_digit_of_2nd_num};
%fib(flip_c_to_z, _) ->
    %{["R", "R"], flip_c_to_z}.

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
