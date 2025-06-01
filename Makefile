.PHONY: help install install-script install-config install-service enable start restart stop status uninstall clean

help:
	@echo "Fan Control Service Management:"
	@echo "  make install         - Полная установка (script + config + service + enable)"
	@echo "  make start           - Запуск сервиса"
	@echo "  make restart         - Перезапуск сервиса"
	@echo "  make stop            - Остановка сервиса"
	@echo "  make status          - Проверить статус сервиса"
	@echo "  make uninstall       - Remove all components"
	@echo "  make clean           - Remove local Python cache files"

	@echo "  make install-script  - Install only the control script"
	@echo "  make install-config  - Install only the config file"
	@echo "  make install-service - Install only the systemd service"
	@echo "  make enable          - Enable service autostart"

install: install-script install-config install-service enable


install-script:
	@echo "Копирование скрипта fan_control.py..."
	sudo cp fan_control.py /usr/local/bin/
	@echo "Добавление прав на запуск fan_control.py..."
	sudo chmod +x /usr/local/bin/fan_control.py

install-config:
	@echo "Копирование конфигурации fan_config.ini..."
	sudo mkdir -p /etc/fan_control
	sudo cp fan_config.ini /etc/fan_config.ini

install-service:
	@echo "Копирование сервиса fan-control.service..."
	sudo cp fan-control.service /etc/systemd/system/
	sudo systemctl daemon-reexec

enable:
	@echo "Включение автозапуска..."
	sudo systemctl enable fan-control.service

start:
	@echo "Включение сервиса..."
	sudo systemctl start fan-control.service

restart:
	@echo "Перезагрузка сервиса..."
	sudo systemctl restart fan-control.service

stop:
	@echo "Остановка сервиса..."
	sudo systemctl stop fan-control.service

status:
	@echo "Статус сервиса:"
	sudo systemctl status fan-control.service

uninstall:
	@echo "Удаление всех установленных компонентов..."
	sudo systemctl stop fan-control.service || true
	sudo systemctl disable fan-control.service || true
	sudo rm -f /usr/local/bin/fan_control.py
	sudo rm -rf /etc/fan_control
	sudo rm -f /etc/systemd/system/fan-control.service
	sudo systemctl daemon-reload
	@echo "Удалено."

clean:
	@echo "Отчистка Python cache files..."
	rm -rf __pycache__ *.pyc