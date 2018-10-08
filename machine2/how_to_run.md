# Instructions

```erlang
$erl
Erlang/OTP 20 [erts-9.2] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Eshell V9.2  (abort with ^G)
1> c(turing2).
{ok,turing2}
2> c(m_growing_ones).
{ok,m_growing_ones}
3> m_growing_ones:run().
none, "0", 3, 0, "ee0_0"
o, "0", 3, 1, "ee0_0"
q, "0", 5, 2, "ee0_0"
q, "_", 7, 3, "ee0_0__"
q, "_", 6, 4, "ee0_0_1"
p, "_", 4, 5, "ee0_0_1"
p, "e", 2, 6, "ee0_0_1"
p, "0", 3, 7, "ee0_0_1"
f, "0", 5, 8, "ee0_0_1"
f, "1", 7, 9, "ee0_0_1"
...

4> c(m_ones).
{ok,m_ones}
5> m_ones:run().
none, "0", 3, 0, "ee0_0"
none, "_", 1, 0, "_"
ones, "_", 3, 1, "1__"
ones, "_", 5, 2, "1_1__"
ones, "_", 7, 3, "1_1_1__"
...
```
