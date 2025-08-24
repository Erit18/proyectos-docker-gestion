# 🚀 Inicio Rápido - ZenTao con Docker

## 📋 Resumen de la Instalación

He creado una configuración completa para ZenTao con Docker basada en la documentación que me proporcionaste. Aquí tienes todo lo necesario para comenzar:

## 📁 Archivos Creados

- **`README.md`** - Documentación completa en español
- **`install.sh`** - Script de instalación automatizada (Linux/macOS)
- **`zentao-manager.sh`** - Script de gestión del contenedor (Linux/macOS)
- **`docker-compose.yml`** - Configuración de Docker Compose
- **`versions.md`** - Guía de versiones y configuraciones específicas
- **`windows-setup.md`** - Configuración específica para Windows
- **`QUICK-START.md`** - Esta guía de inicio rápido

## 🎯 Pasos para Comenzar

### 1. Descargar la Imagen de ZenTao
```bash
# Opciones disponibles:
# - ft/zentao:biz3.7
# - dl/zentao_biz3.7.tar
```

### 2. Importar la Imagen
```bash
# Si descargaste el archivo .tar:
sudo docker load -i zentao_biz3.7.tar
```

### 3. Crear Red Docker
```bash
sudo docker network create --subnet=172.172.172.0/24 zentaonet
```

### 4. Crear Directorios de Datos
```bash
# Para versiones que usan /www/zentaopms:
sudo mkdir -p /www/zentaopms
sudo mkdir -p /www/mysqldata

# Para versiones que usan /app/zentaopms (12.3.1, biz3.7, pro8.8):
sudo mkdir -p /app/zentaopms
sudo mkdir -p /app/mysqldata
```

### 5. Ejecutar Contenedor
```bash
# Versión básica:
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

## 🖥️ Para Usuarios de Windows

### Usar Docker Desktop:
1. Instalar [Docker Desktop para Windows](https://www.docker.com/products/docker-desktop)
2. Habilitar WSL2
3. Crear directorios en `C:\zentao-data\`
4. Usar el comando adaptado para Windows (ver `windows-setup.md`)

### Comando para Windows:
```powershell
docker run --name zentao `
  -p 80:80 `
  --network=zentaonet `
  --ip 172.172.172.172 `
  --mac-address 02:42:ac:11:00:00 `
  -v C:\zentao-data\zentaopms:/www/zentaopms `
  -v C:\zentao-data\mysqldata:/var/lib/mysql `
  -e MYSQL_ROOT_PASSWORD=123456 `
  -d easysoft/zentao:12.2.stable
```

## 🐳 Usar Docker Compose

### Opción más simple:
```bash
# Modificar docker-compose.yml si es necesario
docker-compose up -d
```

## 🔧 Gestión del Contenedor

### Comandos básicos:
```bash
# Ver estado
docker ps

# Ver logs
docker logs zentao

# Entrar al contenedor
docker exec -it zentao /bin/bash

# Detener
docker stop zentao

# Iniciar
docker start zentao

# Reiniciar
docker restart zentao
```

### Usar el script de gestión (Linux/macOS):
```bash
./zentao-manager.sh start
./zentao-manager.sh status
./zentao-manager.sh backup
./zentao-manager.sh help
```

## 🌐 Acceso a ZenTao

Una vez que el contenedor esté ejecutándose:
- **URL**: http://localhost:80
- **Usuario por defecto**: admin
- **Contraseña por defecto**: 123456

## ⚠️ Notas Importantes

### Cambio en Directorios de Montaje:
- **Versiones 12.3.1, biz3.7, pro8.8**: Usar `/app/zentaopms`
- **Versiones anteriores**: Usar `/www/zentaopms`

### Verificar la versión:
```bash
docker exec -it zentao cat /www/zentaopms/VERSION
# o
docker exec -it zentao cat /app/zentaopms/VERSION
```

## 🆘 Solución de Problemas

### Si el contenedor no inicia:
```bash
# Ejecutar sin -d para ver errores
docker run --name zentao -p 80:80 --network=zentaonet --ip 172.172.172.172 --mac-address 02:42:ac:11:00:00 -v /www/zentaopms:/www/zentaopms -v /www/mysqldata:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 easysoft/zentao:12.2.stable
```

### Verificar logs:
```bash
docker logs zentao
```

### Verificar red:
```bash
docker network ls
docker network inspect zentaonet
```

## 📚 Recursos Adicionales

- **Documentación oficial**: https://www.zentao.pm/
- **Soporte técnico**: philip@easycorp.ltd
- **Manual de actualización**: https://www.zentao.pm/book/zentaomanual/free-open-source-project-management-software-upgradezentao-18.html

## 🎉 ¡Listo para Usar!

Con esta configuración tienes:
- ✅ Instalación automatizada
- ✅ Gestión simplificada del contenedor
- ✅ Configuración para múltiples versiones
- ✅ Soporte específico para Windows
- ✅ Scripts de backup y mantenimiento
- ✅ Documentación completa en español

¡Disfruta usando ZenTao para la gestión de proyectos!
