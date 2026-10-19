@echo off
echo ========================================================
echo Starting local Mosquitto MQTT Broker on port 1883
echo Ensure your PC's IP address is set in wifi_mqtt.c
echo (Run 'ipconfig' in another terminal to find your IPv4)
echo ========================================================
mosquitto -v -c mosquitto.conf
pause

