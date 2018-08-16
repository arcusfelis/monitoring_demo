%%%-------------------------------------------------------------------
%% @doc monitoring_demo public API
%% @end
%%%-------------------------------------------------------------------

-module(monitoring_demo_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-export([run_demo/0]).


% Enable lager
-compile([{parse_transform, lager_transform}]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    lager:info("event=starting_monitoring_demo_app", []),
    exometer:new([demo, runs], spiral),
    exometer:new([demo, time], histogram),
    monitoring_demo_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.


run_demo() ->
    SleepTime = round(random:uniform() * 1000), % 0 - 1000 milliseconds
    {Time, _} = timer:tc(fun() -> timer:sleep(SleepTime) end),
    lager:info("event=run_demo sleep_time=~p milliseconds time=~p microseconds",
               [SleepTime, Time]),
    exometer:update([demo, time], Time),
    exometer:update([demo, runs], 1),
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
