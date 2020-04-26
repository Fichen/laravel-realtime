# Intalación

## Requiere
Instalación de:
* Vagrant
* Virtual Box

## VM
Aprovisionamiento de la máquina virtual en Windows
```sh
vagrant up --provision
```

Docker image
```sh
cd /var/www/html
sudo docker-compose up -d --build
```
Post instalación
```sh
sudo docker exec laravel-realtime composer update
sudo docker exec laravel-realtime php artisan key:generate
sudo docker exec laravel-realtime php artisan config:clear
```
Verificar si funciona en un browser
```sh
http://10.0.0.100:8081
```
