# EdgeTX Lua Scripts

This repository contains various [Lua](https://luadoc.edgetx.org) knick knacks for EdgeTX.


## tmrvar

This is a run-once function script which configures a timer based on the value of a gvar.

Intended for use in glider contests, it allows quickly switching the timer between preset values using a switch.

Countdown values (gvar > 0) will enable minute calls and a 30 second countdown.

Enabling the count up timer (gvar = 0) will disable all voice callouts, and is intended for general sport flying.
