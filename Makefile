.PHONY: help install install-script install-config install-service enable start restart stop status uninstall clean

help:
	@echo "Fan Control Service Management:"
	@echo "  make install         - Full installation (script + config + service + enable)"
	@echo "  make start           - Start service"
	@echo "  make restart         - Restart service"
	@echo "  make stop            - Stop service"
	@echo "  make status          - Check service status"
	@echo "  make uninstall       - Remove all components"
	@echo "  make clean           - Remove local Python cache files"
	@echo " -------------------------------------------------------------------------------"
	@echo "  make install-script  - Install only the control script"
	@echo "  make install-config  - Install only the config file"
	@echo "  make install-service - Install only the systemd service"
	@echo "  make enable          - Enable service autostart"

install: install-script install-config install-service enable

install-script:
	@echo "Installing control script to /usr/local/bin/fan_control.py..."
	sudo install -m 755 fan_control.py /usr/local/bin/

install-config:
	@echo "Installing config file to /etc/fan_control/fan_config.ini..."
	sudo mkdir -p /etc/fan_control
	sudo install -m 644 fan_config.ini /etc/fan_control/fan_config.ini

install-service:
	@echo "Installing systemd service to /etc/systemd/system/fan-control.service..."
	sudo install -m 644 fan-control.service /etc/systemd/system/fan-control.service
	sudo systemctl daemon-reexec

enable:
	@echo "Enabling service autostart..."
	sudo systemctl enable fan-control.service

start:
	@echo "Starting service..."
	sudo systemctl start fan-control.service

restart:
	@echo "Restarting service..."
	sudo systemctl restart fan-control.service

stop:
	@echo "Stopping service..."
	sudo systemctl stop fan-control.service

status:
	@echo "Service status:"
	sudo systemctl status fan-control.service

uninstall:
	@echo "Removing all installed components..."
	sudo systemctl stop fan-control.service || true
	sudo systemctl disable fan-control.service || true
	sudo rm -f /usr/local/bin/fan_control.py
	sudo rm -rf /etc/fan_control
	sudo rm -f /etc/systemd/system/fan-control.service
	sudo systemctl daemon-reload
	@echo "Uninstall complete."

clean:
	@echo "Cleaning Python cache files..."
	rm -rf __pycache__ *.pyc