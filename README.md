monitoring_demo
=====

An OTP application

Build
-----

    $ rebar3 compile


Example
-------

```erlang
./rebar3 shell

application:ensure_all_started(monitoring_demo).
ok

3> monitoring_demo_app:run_demo().
14:41:16.204 [info] event=run_demo sleep_time=444 milliseconds time=444654
microseconds
ok
4> monitoring_demo_app:run_demo().
ok
14:41:18.449 [info] event=run_demo sleep_time=723 milliseconds time=724187
microseconds
5> monitoring_demo_app:run_demo().
ok
14:41:20.686 [info] event=run_demo sleep_time=946 milliseconds time=947505
microseconds

7> exometer:get_values([]).
[{[demo,runs],[{count,3},{one,3}]},
 {[demo,time],
  [{n,5},
   {mean,705448},
   {min,444654},
   {max,947505},
   {median,724187},
   {50,724187},
   {75,947505},
   {90,947505},
   {95,947505},
   {99,947505},
   {999,947505}]}]
```
