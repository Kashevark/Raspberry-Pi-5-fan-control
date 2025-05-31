from subprocess import run as srun, PIPE
from time import sleep
from datetime import timedelta as td, datetime as dt
from configparser import ConfigParser
import os

config = ConfigParser()
config.read('fan_config.ini')

STEP1 = config.getint('FAN', 'STEP1')
STEP2 = config.getint('FAN', 'STEP2')
STEP3 = config.getint('FAN', 'STEP3')
STEP4 = config.getint('FAN', 'STEP4')
SLEEP_TIMER = config.getint('FAN', 'SLEEP_TIMER')
TICKS = config.getint('FAN', 'TICKS')
DELTA_TEMP = config.getint('FAN', 'DELTA_TEMP')
fanControlFile = config.get('FAN', 'FAN_CONTROL_FILE')

DATETIME_FORMAT = '%Y-%m-%d %H:%M:%S'

def main():
    print("Running FAN control for RPI5 Ubuntu")
    t0 = dt.now()

    command = f'tee -a {fanControlFile} > /dev/null'
    oldSpeed = 0
    ticks = 0

    speed = 1
    lastTemp = 0

    while True:
        sleep(SLEEP_TIMER)
        t1 = dt.now()
        if(t1 + td(seconds=TICKS) > t0):
            t0 = t1
            
            tempOut = getOutput('vcgencmd measure_temp')
            try:
                cels = int(tempOut.split('temp=')[1][:2])
            except:
                cels = 40

            if STEP1 < cels < STEP2:
                speed = 1
            elif STEP2 < cels < STEP3:
                speed = 2
            elif STEP3 < cels < STEP4:
                speed = 3
            elif cels >= STEP4:
                speed = 4

            deltaTempNeg = lastTemp - DELTA_TEMP
            deltaTempPos = lastTemp + DELTA_TEMP

            if oldSpeed != speed and not(deltaTempNeg <= cels <= deltaTempPos):
                print(f'oldSpeed: {oldSpeed} | newSpeed: {speed}')
                print(f'{deltaTempNeg}ºC <= {cels}ºC <= {deltaTempPos}ºC')
                print(f'{"#"*30}\n' +
                    f'Updating fan speed!\t{t0.strftime(DATETIME_FORMAT)}\n' +
                    f'CPU TEMP: {cels}ºC\n' +
                    f'FAN speed will be set to: {speed}\n' +
                    f'{"#"*30}\n')
                
                _command = f'echo {speed} | sudo {command}'
                callShell(_command, debug=True)
                checkVal = getOutput(f'cat {fanControlFile}')
                print(f'Confirm FAN set to speed: {checkVal}')
                
                oldSpeed = speed
                lastTemp = cels
                ticks = 0
            
            if(ticks > TICKS * 3):
                ticks = 0
                print(f'Current Temp is: {cels}ºC\t{t0.strftime(DATETIME_FORMAT)}')
            ticks += 1
    
def callShell(cmd, shell=True, debug=False):
    if debug:
        print(f'Calling: [{cmd}]')
    return srun(f'''{cmd}''', stdout=PIPE, shell=shell)
 
def getOutput(cmd, shell=True):
    stdout = callShell(cmd, shell=shell).stdout
    try:
        stdout = stdout.decode('utf-8')
    except:
        pass
    return stdout

if __name__ == "__main__":
    main()