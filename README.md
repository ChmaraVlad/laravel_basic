## Setup

<p>
    Replace $PROJECT_DIR variable with project directory path 
    in your filesystem
</p>

```
cd $PROJECT_DIR
git clone git@github.com:OnBoardIT/laravel.git
```

### Prepare configuration files

1. [Copy config files](#copy-config-files)
2. [Build docker](#build-docker)
3. [Configure app](#configure-app)

#### Copy config files

<small>
    <i>WINDOWS</i>
</small>

```
cd $PROJECT_DIR/laravel
copy ./docker/.env.example ./docker/.env
copy ./docker/php/00-php.ini.example ./docker/php/00-php.ini
copy ./docker/webserver/default.conf.example ./docker/webserver/default.conf
copy ./docker/fpm/fpm.conf.example ./docker/fpm/fpm.conf
copy ./docker/mysql/conf/my.conf.example ./docker/mysql/conf/my.conf
copy ./project/.env.example ./project/.env
```

<small>
    <i>Linux</i>
</small>

```
cd $PROJECT_DIR/laravel
cp ./docker/.env.example ./docker/.env
cp ./docker/php/00-php.ini.example ./docker/php/00-php.ini
cp ./docker/webserver/default.conf.example ./docker/webserver/default.conf
cp ./docker/fpm/fpm.conf.example ./docker/fpm/fpm.conf
cp ./docker/mysql/conf/my.conf.example ./docker/mysql/conf/my.conf
cp ./project/.env.example ./project/.env
```

#### Build docker

```
cd $PROJECT_DIR/laravel/docker
docker compose up --build -d
```

#### Configure app

##### Configure secure certs

<small>
    <i>Linux</i>
</small>

```
cd $PROJECT_DIR/laravel/docker/server/ssl
sudo apt install libnss3-tools golang-go

git clone https://github.com/FiloSottile/mkcert && cd mkcert
go build -ldflags "-X main.Version=$(git describe --tags)"

mkcert -install
mkcert laravel.loc
sudo sh -c 'echo "127.0.0.1 laravel.loc" >> /etc/hosts'
mv laravel.loc+5.pem cert.pem
mv laravel.loc+5-key.pem key.pem
```

<small>
    <i>WINDOWS</i>
</small>

```
cd $PROJECT_DIR/laravel/docker/server/ssl

iwr -useb chocolatey.org/install.ps1 | iex
choco install mkcert

mkcert -install
mkcert laravel.loc
Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "127.0.0.1 laravel.loc"
ren laravel.loc+5.pem cert.pem
ren laravel.loc+5-key.pem key.pem
```

##### PHP app

```
cd $PROJECT_DIR/laravel/docker
docker exec -ti app /bin/bash
composer i
php artisan key:generate
php artisan migrate
```

##### Node app

```
cd $PROJECT_DIR/laravel/docker
docker exec -ti node /bin/sh
npm run start
```