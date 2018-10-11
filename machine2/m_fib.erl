-module(m_fib).
-export([run/0]).
-export([run/1]).
-export([fib/2]).

% calculate fibonacci numbers in binary

run() ->
    run(100).

run(Count) ->
    turing2:step(fun fib/2, Count).

% Write out all the binary bits between x and y and between y and z
% and then add those together and add them after z.
% After I write each bit of each number I move the start marker
% for that number up one.

% Mark the current target unit place (e.g. 1's column, 2's, 4's, etc.)
% with a 'c'; new digits are place or added just before the c and then
% carries can extend past the 'c'. Once a new digit is added the 'c' is
% advanced.

% After two numbers are added together the markers are all reset.

% Kick everything off with 2 numbers
fib(none, _) ->
    {["P@", "R", "P-", "R", "Px", "R", "P0", "R", "Py", "R", "P1", "R", "Pz"],
     reset_find_next_digit_of_2nd_num};

% Back to the start to start looking for the next digit
fib(reset_find_next_digit_of_1st_num, "@") ->
    {[], find_next_digit_of_1st_num};
fib(reset_find_next_digit_of_1st_num, _) ->
    {["L", "L"], reset_find_next_digit_of_1st_num};

% Change each x to X as we find and use it
fib(find_next_digit_of_1st_num, "x") ->
    {["E", "PX", "R", "R"], move_x};
% No more x, so no more digits of first number
fib(find_next_digit_of_1st_num, "Y") ->
    {[], reset_find_next_digit_of_2nd_num};
fib(find_next_digit_of_1st_num, _) ->
    {["R", "R"], find_next_digit_of_1st_num};

% Advance the x to mark next digit
fib(move_x, "Y") ->
    {["L"], write_next_digit_of_1st_num};
fib(move_x, "_") ->
    {["Px", "L"], write_next_digit_of_1st_num};

%% Adding a zero does nothing so skip it
fib(write_next_digit_of_1st_num, "0") ->
    {["R"], reset_find_next_digit_of_2nd_num};
fib(write_next_digit_of_1st_num, "1") ->
    {["R"], add_digit_1_to_last};

% 2nd number ensures we have a 'c' so we can just find it
fib(add_digit_1_to_last, "c") ->
    {["L"], maybe_carry_1st};
fib(add_digit_1_to_last, _) ->
    {["R", "R"], add_digit_1_to_last};

% If we're adding a digit from the 1st number to the 2nd
% we need to check if we have to carry, and then carry
% until we've run out of consecutive 1's
fib(maybe_carry_1st, "1") ->
    {["E", "P0", "R", "R"], maybe_carry_1st};
fib(maybe_carry_1st, _) ->
    {["E", "P1", "L"], reset_find_next_digit_of_2nd_num};

% If we're adding 1 to one we'll need to carry, and keep
% carrying until we stop running into 1's
fib(maybe_carry_2nd, "1") ->
    {["E", "P0", "R", "R"], maybe_carry_2nd};
fib(maybe_carry_2nd, _) ->
    {["E", "P1", "L"], reset_find_next_digit_of_1st_num};

% Back to start to look for next digit
fib(reset_find_next_digit_of_2nd_num, "@") ->
    {[], find_next_digit_of_2nd_num};
fib(reset_find_next_digit_of_2nd_num, _) ->
    {["L", "L"], reset_find_next_digit_of_2nd_num};

% if we hit an unused y then we can flip it
% and advance the y marker. We have to keep
% the first y to mark where the current 2nd number
% starts
fib(find_next_digit_of_2nd_num, "y") ->
    {["E", "PY", "R", "R"], move_y};
% No more digits in the 2nd number, we're finished
% with these two numbers.
fib(find_next_digit_of_2nd_num, "z") ->
    {[], reset_clear_xs};
fib(find_next_digit_of_2nd_num, _) ->
    {["R", "R"], find_next_digit_of_2nd_num};

% We've found an unused digit in the 2nd number.
% We'll mark it and add it to the new number
fib(move_y, "_") ->
    {["Py", "L"], write_next_digit_of_2nd_num};
fib(move_y, "z") ->
    {["L"], write_next_digit_of_2nd_num};

% We need to find where we can start or find the
% next number if we're writing the 1st digit
fib(write_next_digit_of_2nd_num, "0") ->
    {["R"], find_z_to_write_0};
fib(write_next_digit_of_2nd_num, "1") ->
    {["R"], find_z_to_write_1};

% If we have 0 as the next digit of 2nd number then
% we only need to add it if we haven't already carried
% over into the appropriate space.
fib(maybe_zero, "_") ->
    {["P0", "L"], reset_find_next_digit_of_1st_num};
fib(maybe_zero, _) ->
    {["L"], reset_find_next_digit_of_1st_num};

% Find where the new number can start
fib(find_z_to_write_1, "z") ->
    {["R"], check_blank_1};
fib(find_z_to_write_1, _) ->
    {["R", "R"], find_z_to_write_1};

% Find where the new number can start
fib(find_z_to_write_0, "z") ->
    {["R"], check_blank_0};
fib(find_z_to_write_0, _) ->
    {["R", "R"], find_z_to_write_0};

% If the space right after the z is empty
% then we haven't started the new number yet
fib(check_blank_0, "_") ->
    {[], start_number_0};
fib(check_blank_0, _) ->
    {["R"], find_c_write_0};

% If the space right after the z is empty
% then we haven't started the new number yet
fib(check_blank_1, "_") ->
    {[], start_number_1};
fib(check_blank_1, _) ->
    {["R"], find_c_write_1};

% start the new number in the blank spot
fib(start_number_0, _) ->
    {["P0", "R", "Pc"], reset_find_next_digit_of_1st_num};

% start the new number in the blank spot
fib(start_number_1, _) ->
    {["P1", "R", "Pc"], reset_find_next_digit_of_1st_num};

% If we've already started the new number then we need
% to find the current unit place to write
fib(find_c_write_0, "c") ->
    {["E", "R", "R", "Pc", "L"], maybe_zero};
fib(find_c_write_0, _) ->
    {["R", "R"], find_c_write_0};

% If we've already started the new number then we need
% to find the current unit place to write
fib(find_c_write_1, "c") ->
    {["E", "R", "R", "Pc", "L"], maybe_carry_2nd};
fib(find_c_write_1, _) ->
    {["R", "R"], find_c_write_1};

% Unless we're filling in a place holder we don't need to do anything
fib(add_digit_0, "_") ->
    {["P0", "R", "Pc"], reset_find_next_digit_of_1st_num};
fib(add_digit_0, _) ->
    {[], reset_find_next_digit_of_1st_num};

% Back to @ to start resetting markers
fib(reset_clear_xs, "@") ->
    {[], clear_xs};
fib(reset_clear_xs, _) ->
    {["L"], reset_clear_xs};

% Clear out x's until we hit a Y.
% We don't need the 1st number anymore since
% we'll add the 2nd number to the new number
fib(clear_xs, "Y") ->
    {[], flip_y_to_x};
fib(clear_xs, "x") ->
    {["E", "R", "R"], clear_xs};
fib(clear_xs, "X") ->
    {["E", "R", "R"], clear_xs};
fib(clear_xs, _) ->
    {["R", "R"], clear_xs};

% Flip the first Y to y so we can
% track the start of the 2nd number,
% which we still need
fib(flip_y_to_x, "Y") ->
    {["E", "Px"], clear_y};
fib(flip_y_to_x, _) ->
    {["R", "R"], flip_y_to_x};

% Clear out successive Ys
fib(clear_y, "Y") ->
    {["E", "R", "R"], clear_y};
fib(clear_y, "z") ->
    {[], flip_z_to_y};
fib(clear_y, _) ->
    {["R", "R"], clear_y};

fib(flip_z_to_y, "z") ->
    {["E", "Py", "R", "R"], find_c};

% Find the c so we can flip it to a z
fib(find_c, "c") ->
    {["E", "R"], write_z};
fib(find_c, _) ->
    {["R", "R"], find_c};

% Find the next empty spot after the new number
% (i.e. we might have carried past the c)
fib(write_z, "_") ->
    {["L", "Pz"], reset_find_next_digit_of_2nd_num};
fib(write_z, _) ->
    {["R", "R"], write_z}.
