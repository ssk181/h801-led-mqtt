# H801 RGBW Led Controller Lua (NodeMCU) software
Openhab settings:
https://github.com/ssk181/home-switch-openhab

## Hardware
- H801 controller

## MQTT-messages
Out:

- /home/iot/{Device-IP}/out/rgb          *- HEX value, for example: FF00FF
- /home/iot/{Device-IP}/out/w1           *- HEX value, for example: FF
- /home/iot/{Device-IP}/out/w2           *- HEX value, for example: FF
- /home/iot/{Device-IP}/out/online       *- ON - connected to MQTT, OFF - desconected (LWT)*
- /home/iot/{Device-IP}/out/state/uptime *- Uptime in seconds*
- /home/iot/{Device-IP}/out/state/memory *- Free bytes memory*


In:

- /home/iot/{Device-IP}/out/rgb          *- HEX value, for example: FF00FF
- /home/iot/{Device-IP}/out/w1           *- HEX value, for example: FF
- /home/iot/{Device-IP}/out/w2           *- HEX value, for example: FF
- /home/iot/{Device-IP}/in/state/uptime  *- Empty message*
- /home/iot/{Device-IP}/in/state/memory  *- Empty message*

## Mac OS Installation
1. Install nodemcu-tool:
   *npm install nodemcu-tool -g*
2. Use *./upload.sh* to upload