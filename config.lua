config = {
    network = {
        ssid         = "MyWiFiRouter",
        password     = "Password",
        tmr_alarm_id = 0,
        tmr_retry_ms = 20000
    },
    collectgarbage = {
        tmr_alarm_id = 1,
        tmr_run_ms   = 60000
    },
    mqtt = {
        broker_ip      = "192.168.182.2",
        port           = 1883,
        user           = "",
        password       = "",
        keep_alive_sec = 60,
        tmr_alarm_id   = 2,
        tmr_retry_ms   = 3000,
        queue_ttl_sec  = 3600,
        queue_max_size = 50,
        topic_online   = "online",
        topic_state_uptime = "state/uptime",
        topic_state_memory = "state/memory",
        topic_rgb      = "rgb",
        topic_w1       = "w1",
        topic_w2       = "w2",
        topic          = "/home/iot",
        dir_in         = "in",
        dir_out        = "out",
        msg_on         = "ON",
        msg_off        = "OFF"
    },
    h801 = {
        pin_red            = 8,
        pin_green          = 7,
        pin_blue           = 6,
        pin_white1         = 5,
        pin_white2         = 4,
        pin_onboard_red    = 10,
        pin_onboard_green  = 1,
        default_rgb        = "000000",
        default_w1         = "80",
        default_w2         = "00"
    }
}
