# **🌬️ 3-Pin PWM Fan Control**  
**Automatic CPU temperature-based fan speed regulation**  

## **Project Structure**

```
/                          # Project root  
├── Makefile               # Build/install management  
├── fan_config.ini         # Configuration (speed, pins, logging)  
├── fan_control.py         # Main PWM control script  
├── fan-control.service    # Systemd service for autostart  
├── assets/                # (Optional) For icons/images  
│   └── fan-icon.png       # Project icon  
└── README.md              # Project documentation  
```

---

## **📌 Project Description**  
This script automatically adjusts **3-pin/4-pin PWM fan** speed based on CPU temperature using:  
- **Gradual speed control** (4 temperature thresholds)  
- **Hysteresis** (prevents rapid speed switching)  
- **Systemd service** for background operation  

Ideal for:  
- 🖥️ **Raspberry Pi** (GPIO PWM)  
- 🖥️ **Linux PCs** (via `/sys/class/hwmon`)  
- 🔧 **Microcontroller projects** (Arduino, ESP32)  

---

## **⚙️ Installation**  
### **1. Clone Repository**  
```bash
git clone https://github.com/Kashevark/Raspberry-Pi-5-fan-control.git
cd fan-control
```

### **2. Configuration (Optional)**  
Edit `fan_config.ini`:  
```ini
[FAN]
STEP1 = 48    # Enable speed 1 at 48°C  
STEP2 = 60    # Switch to speed 2  
STEP3 = 65    # Switch to speed 3  
STEP4 = 72    # Maximum cooling speed  
DELTA_TEMP = 3 # Hysteresis threshold (°C)  
```

### **3. Service Installation**  
```bash
make install   # Copies files to system and activates service
```

---

## **🚀 Usage**  
| Command               | Action                          |
|-----------------------|----------------------------------|
| `make install`        | Full installation               |
| `make install-script` | Install script only             |
| `make install-config` | Install config only             |
| `make install-service`| Install service only            |
| `make enable`         | Enable autostart                |
| `make start`          | Start service                   |
| `make stop`           | Stop service                    |
| `make restart`        | Restart service                 |
| `make status`         | Check service status            |
| `make uninstall`      | Remove all components           |

---

## **📜 Logging**  
View service logs:  
```bash
journalctl -u fan-control.service -f
```

---

## **⚠️ Important Notes**  
1. Requires **root** privileges (service runs as `root`)  
2. For Raspberry Pi PWM, enable in:  
   ```bash
   sudo raspi-config → Interface Options → PWM
   ```

---

## **📜 License**  
MIT License.  
**Author**: [Kashevark]  

---

Enjoy automatic fan control - quiet when idle, powerful under load! 🚀  

*(Note: Add actual icon file in `assets/` folder and update the icon path in README)*