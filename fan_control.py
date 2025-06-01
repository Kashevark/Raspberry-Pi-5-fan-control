#!/usr/bin/env python3

import time
import configparser
import os

CONFIG_PATH = "/etc/fan_config.ini"
FAN_PATH = "/proc/device-tree/cooling_device/fan0/cur_state"
TEMP_PATH = "/sys/class/thermal/thermal_zone0/temp"

def write_fan_state(state):
    try:
        with open("/sys/class/thermal/cooling_device0/cur_state", "w") as f:
            f.write(str(state))
    except PermissionError:
        print("Permission denied: run as root.")
    except FileNotFoundError:
        print("Fan control interface not found.")

def get_temp():
    with open(TEMP_PATH, "r") as f:
        return int(f.read()) / 1000

def main():
    config = configparser.ConfigParser()
    config.read(CONFIG_PATH)
    step1 = config.getint("FAN", "STEP1")
    step2 = config.getint("FAN", "STEP2")
    step3 = config.getint("FAN", "STEP3")

    try:
        while True:
            temp = get_temp()
            if temp >= step3:
                write_fan_state(3)
            elif temp >= step2:
                write_fan_state(2)
            elif temp >= step1:
                write_fan_state(1)
            else:
                write_fan_state(0)
            time.sleep(5)
    except KeyboardInterrupt:
        write_fan_state(0)

if __name__ == "__main__":
    main()
