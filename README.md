# NXP_Experiments (FRDM-RW612)

IoT Lab Experiments (EC2601-21) on the **NXP FRDM-RW612** development board.

## Repository Structure

```
NXP_Experiments/
├── frdmrw612_wireless_uart/             # Experiment A: BLE Wireless UART
│   ├── armgcc/                          # CMake presets, toolchain flags & build
│   ├── commands_script                  # J-Link flashing command script
│   ├── flash_jlink.bat                  # Automated J-Link flashing script
│   └── ...
├── wifi_mqtt/                           # Experiment B: MQTT Publish/Subscribe
│   ├── mosquitto.conf                   # Local broker configuration (port 1883)
│   ├── start_mosquitto.bat              # Script to launch local Mosquitto
│   ├── commands_script                  # J-Link flashing script
│   ├── flash_jlink.bat                  # Automated J-Link flashing script
│   ├── wifi_mqtt.c                      # Application source with Wi-Fi & MQTT setup
│   └── ...
├── frdm_rw612_light_switch_otbr_combo/  # Experiment C: Matter over Wi-Fi / Thread
│   ├── commands_script                  # J-Link flashing command script
│   ├── flash_jlink.bat                  # Automated J-Link flashing script
│   ├── build_matter_linux.sh            # Automated Linux/WSL Matter build script
│   └── ...
├── FRDM_RW612_Execution_Procedure_Guide.pdf  # Comprehensive Lab Execution PDF Guide
├── execution_guide.html                 # HTML source of the execution guide
└── README.md
```

## Quick Start & Experiments Overview

### 1. BLE Communication (`frdmrw612_wireless_uart`)
* Implements a custom GATT "Wireless UART" service.
* Flash with `flash_jlink.bat`.
* Connect via **NXP IoT Toolbox** or **nRF Connect** (`NXP_WU`).

### 2. MQTT Publish / Subscribe (`wifi_mqtt`)
* Runs lwIP MQTT client over FreeRTOS.
* Start local broker via `start_mosquitto.bat`.
* Configure `AP_SSID`, `AP_PASSWORD`, and `EXAMPLE_MQTT_SERVER_HOST` in `wifi_mqtt.c`.
* Monitor topic `lwip_topic/#` in **MQTT Explorer**.

### 3. Matter over Wi-Fi / Thread (`frdm_rw612_light_switch_otbr_combo`)
* Dual endpoint Matter accessory (Bulb + Switch) with integrated OpenThread Border Router (OTBR).
* Flash with `flash_jlink.bat`.
* Commission via **NXP Matter Chip-tool** Android app (Discriminator: `3840`, PIN: `20202021`).

---
For detailed step-by-step instructions and expected terminal outputs, see [FRDM_RW612_Execution_Procedure_Guide.pdf](FRDM_RW612_Execution_Procedure_Guide.pdf).

