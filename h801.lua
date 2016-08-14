function h801SetRGB(hexRgb, init)
    if #hexRgb == 6 then
        h801SetPin(config.h801.pin_red, string.sub(hexRgb, 1, 2), init)
        h801SetPin(config.h801.pin_green, string.sub(hexRgb, 3, 4), init)
        h801SetPin(config.h801.pin_blue, string.sub(hexRgb, 5, 6), init)
        mqttMessage(config.mqtt.topic_rgb, hexRgb)
    end
end

function h801SetW1(hex, init)
    if #hex == 2 then
        h801SetPin(config.h801.pin_white1, hex, init)
        mqttMessage(config.mqtt.topic_w1, hex)
    end
end

function h801SetW2(hex, init)
    if #hex == 2 then
        h801SetPin(config.h801.pin_white2, hex, init)
        mqttMessage(config.mqtt.topic_w2, hex)
    end
end

function h801ConvertHexToPWM(hex)
    return tonumber(hex, 16) * 4
end

function h801SetPin(pin, hex, init)
    local val = h801ConvertHexToPWM(hex)
    if init then
        pwm.setup(pin, 1000, 0)
    end
    pwm.setduty(pin, val)
end

h801SetRGB(config.h801.default_rgb, true)
h801SetW1(config.h801.default_w1, true)
h801SetW2(config.h801.default_w2, true)