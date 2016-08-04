mqttConnected = false
mqttQueue = {}
mqttClimate = {time = tmr.time(), temp = nil, humidity = nil}

function mqttMessage(topic, message)
    if mqttConnected then
        local ip = wifi.sta.getip() or "none"
        mqttClient:publish(config.mqtt.topic .. "/" .. ip .. "/" .. config.mqtt.dir_out ..  "/" .. topic, message, 0, 0, function(client)
            print("MQTT message sended") 
        end)
        print("MQTT message send: " .. config.mqtt.topic .. "/" .. ip .. "/" .. config.mqtt.dir_out ..  "/" .. topic .. " - " .. message)
    else
        mqttQueueAdd(topic, message)
    end
end

function mqttConnect(firstReconnect)
    if firstReconnect then
        mqttConnected = false
        mqttClean()
    end
    tmr.alarm(config.mqtt.tmr_alarm_id, config.mqtt.tmr_retry_ms, tmr.ALARM_AUTO, function()
        print("MQTT Waiting for a network")
        if wifi.sta.status() == wifi.STA_GOTIP then
            print("MQTT Got a network")           
            mqttClient = mqtt.Client(wifi.sta.getip(), config.mqtt.keep_alive_sec)
            local ip = wifi.sta.getip() or "none"
            mqttClient:lwt(config.mqtt.topic .. "/" .. ip .. "/" .. config.mqtt.dir_out ..  "/" .. config.mqtt.topic_online , config.mqtt.msg_off, 0, 0)
            mqttClient:on("offline", function(client) mqttConnect(true) end)
            mqttClient:on("connect", function(client)
                tmr.stop(config.mqtt.tmr_alarm_id)
                local ip = wifi.sta.getip() or "none"
                mqttClient:subscribe(config.mqtt.topic .. "/" .. ip .. "/" .. config.mqtt.dir_in .. "/#", 0, function(client)
                    print("MQTT subscribe")
                end)
                mqttMessage(config.mqtt.topic_online, config.mqtt.msg_on)
                mqttConnected = true
                print("MQTT connected success")
                mqttQueueSend()
            end)
            mqttClient:on("message", function(client, topic, message)
                message = message or ""
                print("MQTT message in: " .. topic .. " - " .. message)
                local ip = wifi.sta.getip() or "none"
                local topic_prefix = config.mqtt.topic .. "/" .. ip .. "/" .. config.mqtt.dir_in .. "/"
                local topic_main = string.sub(topic, #topic_prefix + 1)
                -- h801 rgb
                if (topic_main == config.mqtt.topic_rgb) then
                    pcall(h801SetRGB, message)
                -- h801 w1
                elseif (topic_main == config.mqtt.topic_w1) then
                    pcall(h801SetW1, message)
                -- h801 w2
                elseif (topic_main == config.mqtt.topic_w2) then
                    pcall(h801SetW2, message)
                -- state uptime
                elseif (topic_main == config.mqtt.topic_state_uptime) then
                    mqttMessage(config.mqtt.topic_state_uptime, tmr.time())
                -- state memory
                elseif (topic_main == config.mqtt.topic_state_memory) then
                    mqttMessage(config.mqtt.topic_state_memory, node.heap())
                end
            end)
            mqttClient:connect(config.mqtt.broker_ip, config.mqtt.port, false, false,
                function(client, reason)
                    print("MQTT can\'t connect. Error: " .. reason)
                end
            )
        end
    end)
end

function mqttClean()
    if mqttClient ~= nil then
        mqttClient:close()
        mqttClient = nil
        collectgarbage("collect")
        print("MQTT cleaned")
    end
end

function mqttQueueAdd(topic, message)
    local timeLine = tmr.time() - config.mqtt.queue_ttl_sec
    local i = 1
    while i <= #mqttQueue do
        if mqttQueue[i]["time"] < timeLine or i > config.mqtt.queue_max_size then
            table.remove(mqttQueue, i)
        else
            i = i + 1
        end
    end
    table.insert(mqttQueue, {time = tmr.time(), topic = topic, message = message})
end

function mqttQueueSend()
    local msg = nil
    local i = 1    
    while i <= #mqttQueue do
        if mqttConnected then
            msg = mqttQueue[i]
            table.remove(mqttQueue, i)
            mqttMessage(msg["topic"], msg["message"])
        else
            i = i + 1
        end
    end
end

mqttConnect()