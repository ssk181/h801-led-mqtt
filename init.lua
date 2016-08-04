dofile("config.lc")
dofile("network.lc")
dofile("mqtt.lc")
dofile("h801.lc")

tmr.alarm(config.collectgarbage.tmr_alarm_id, config.collectgarbage.tmr_run_ms, tmr.ALARM_AUTO, function()
    collectgarbage()
end)