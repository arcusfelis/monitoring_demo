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
    % spiral counter counts:
    % - total nuber of calls
    % - number of calls in one minute sliding window
    exometer:new([demo, runs], spiral), % creates a spiral counter
    exometer:new([demo, time], histogram),
    monitoring_demo_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.


%% This function sleeps random time and reports it
%% In a real world example, replace timer:sleep/1 with:
%% - database query function
%% - a request handler function
%% ...
%%
%% [demo, runs] and [demo, time] are metric names.
run_demo() ->
    SleepTime = round(random:uniform() * 1000), % 0 - 1000 milliseconds
    {Time, _} = timer:tc(fun() -> timer:sleep(SleepTime) end),
    lager:info("event=run_demo sleep_time=~p milliseconds time=~p microseconds",
               [SleepTime, Time]),
    exometer:update([demo, time], Time), % updates histogram
    exometer:update([demo, runs], 1),
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
