# Instructions

```erlang
$erl
Erlang/OTP 20 [erts-9.2] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Eshell V9.2  (abort with ^G)
1> l(turing).
{module,turing}
2> l(turing1).
{module,turing1}
3> l(turing_sup).
{module,turing_sup}
4> f(Pid), {ok, Pid} = turing:start(), turing1:start().
```
