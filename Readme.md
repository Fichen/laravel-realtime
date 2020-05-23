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

----------
## vagrant symlink problem
https://superuser.com/questions/124679/how-do-i-create-a-link-in-windows-7-home-premium-as-a-regular-user?answertab=votes#125981

https://github.com/hashicorp/vagrant/issues/4815#issuecomment-82826916
ver este: https://blog.entrostat.com/vagrant-ubuntu-docker-windows/

## local php for fresh laravel install
apt-get install composer php-curl php-zip php-mbstring

# node modules
cd /var/www
mkdir node_modules
cd html
ln -s ../node_modules .
cd /root
composer create-project laravel/laravel --prefer-dist laravel
cd laravel
rm -f package.json
ln -s /var/www/html/package.json .
npm install --no-bin-link
cp -parf node_modules/* /var/www/node_modules
cd /var/www/html
npm rebuild
npm run dev

# Docker-compose start
cd /var/www/html
sudo docker-compose up -d

# Comandos del curso
docker exec -ti laravel-realtime composer require laravel/ui
docker exec -ti laravel-realtime php artisan ui bootstrap --auth
- Video 13
  - sudo docker exec -ti laravel-realtime php artisan make:event UserSessionChanged

