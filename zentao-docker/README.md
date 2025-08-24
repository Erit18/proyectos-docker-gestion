# ZenTao Docker Setup

Este directorio contiene la configuración para ejecutar ZenTao con Docker.

## Requisitos Previos

- Docker instalado en tu sistema
- Acceso a la imagen de ZenTao (descargar desde los enlaces proporcionados)

## Pasos de Instalación

### 1. Descargar la Imagen

Descarga la imagen de ZenTao desde uno de estos enlaces:
- `ft/zentao:biz3.7`
- `dl/zentao_biz3.7.tar`

### 2. Importar la Imagen

```bash
# Navega al directorio donde descargaste el archivo
cd /ruta/a/tu/descarga

# Importa la imagen (ejemplo para zentao_12.3.1.tar)
sudo docker load -i zentao_12.3.1.tar
```

### 3. Crear Red Docker

```bash
# Crea una red con rango IP específico
sudo docker network create --subnet=172.172.172.0/24 zentaonet
```

### 4. Crear Directorios de Datos

```bash
# Crea directorios para persistir datos
sudo mkdir -p /www/zentaopms
sudo mkdir -p /www/mysqldata
```

### 5. Ejecutar Contenedor

```bash
sudo docker run --name zentao \
  -p 80:80 \
  --network=zentaonet \
  --ip 172.172.172.172 \
  --mac-address 02:42:ac:11:00:00 \
  -v /www/zentaopms:/www/zentaopms \
  -v /www/mysqldata:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -d easysoft/zentao:12.2.stable
```

### 6. Verificar Estado

```bash
# Verifica que el contenedor esté ejecutándose
docker ps

# Si hay problemas, ejecuta sin -d para debug
docker run --name zentao -p 80:80 --network=zentaonet --ip 172.172.172.172 --mac-address 02:42:ac:11:00:00 -v /www/zentaopms:/www/zentaopms -v /www/mysqldata:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 easysoft/zentao:12.2.stable
```

## Acceso

Una vez que el contenedor esté ejecutándose, accede a:
- **URL**: http://localhost:80
- **Usuario por defecto**: admin
- **Contraseña por defecto**: 123456

## Configuración Múltiple

Para ejecutar múltiples instancias de ZenTao:

```bash
# Segunda instancia
sudo docker run --name zentao2 \
  -p 8080:80 \
  --network=zentaonet \
  --ip 172.172.172.173 \
  --mac-address 02:42:ac:11:00:01 \
  -v /www/zentaopms2:/www/zentaopms \
  -v /www/mysqldata2:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -d easysoft/zentao:12.2.stable
```

## Conexión Remota a MySQL

Para conectar remotamente a MySQL, agrega el mapeo de puerto:

```bash
sudo docker run --name zentao \
  -p 80:80 \
  -p 3306:3306 \
  --network=zentaonet \
  --ip 172.172.172.172 \
  --mac-address 02:42:ac:11:00:00 \
  -v /www/zentaopms:/www/zentaopms \
  -v /www/mysqldata:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -d easysoft/zentao:12.2.stable
```

## Instalación de Herramientas Adicionales

```bash
# Entrar al contenedor
docker exec -it zentao /bin/bash

# Instalar Git
apt-get install git -y

# Instalar SVN
apt-get install subversion -y
```

## Actualización

1. Detener contenedor: `docker stop zentao`
2. Hacer backup de `/www/zentaopms` y `/www/mysqldata`
3. Descargar nueva versión desde https://www.zentao.pm/download.html
4. Sobrescribir archivos en `/www/zentaopms`
5. Iniciar contenedor: `docker start zentao`
6. Visitar `upgrade.php` para completar la actualización

## Notas Importantes

- **Directorio de montaje**: Para versiones 12.3.1, 12.2.stable, biz3.7 y pro8.8, usa `/app/zentaopms` en lugar de `/www/zentaopms`
- **Credenciales por defecto**: root/123456 para MySQL
- **Soporte**: philip@easycorp.ltd
