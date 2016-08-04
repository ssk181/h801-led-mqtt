#!/bin/bash
nodemcu-tool upload --compile --optimize *.lua
nodemcu-tool upload init.lua
