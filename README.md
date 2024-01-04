# EdgeTX Lua Scripts

This repository contains various [Lua](https://luadoc.edgetx.org) knick knacks for EdgeTX.


## tmrvar

This is a run-once function script which configures timer one based on the value of a gvar.

Intended for use in glider competition, it allows quickly switching the timer between preset values using a switch.

Countdown values (gvar > 0) will enable minute calls and a 30 second countdown.

Enabling the count up timer (gvar = 0) will disable all voice callouts, and is intended for general sport flying.


## tmr_vc, tmr_qt

These scripts enable and disable voice callouts for timer one.

* tmr_vc enables voice callouts.
* tmr_qt disables voice callouts.

Intended for use in glider competition, it allows the task timer to be quickly silenced if it is out of sync with the (big, loud) official timer.
