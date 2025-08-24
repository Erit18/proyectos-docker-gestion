# Versiones de ZenTao y Configuraciones

## Versiones Disponibles

### ZenTao 12.2.stable
- **Imagen**: `easysoft/zentao:12.2.stable`
- **Directorio de montaje**: `/www/zentaopms`
- **Características**: Versión estable, recomendada para producción
- **Comando de instalación**:
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

### ZenTao 12.3.1
- **Imagen**: `easysoft/zentao:12.3.1`
- **Directorio de montaje**: `/app/zentaopms` ⚠️ **IMPORTANTE**
- **Características**: Versión más reciente, requiere configuración especial
- **Comando de instalación**:
```bash
# Crear directorios con la ruta correcta
sudo mkdir -p /app/zentaopms
sudo mkdir -p /app/mysqldata

sudo docker run --name zentao \
  -p 80:80 \
  --network=zentaonet \
  --ip 172.172.172.172 \
  --mac-address 02:42:ac:11:00:00 \
  -v /app/zentaopms:/app/zentaopms \
  -v /app/mysqldata:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -d easysoft/zentao:12.3.1
```

### ZenTao Biz 3.7
- **Imagen**: `easysoft/zentao:biz3.7`
- **Directorio de montaje**: `/app/zentaopms` ⚠️ **IMPORTANTE**
- **Características**: Versión de negocio con funcionalidades avanzadas
- **Comando de instalación**:
```bash
# Crear directorios con la ruta correcta
sudo mkdir -p /app/zentaopms
sudo mkdir -p /app/mysqldata

sudo docker run --name zentao \
  -p 80:80 \
  --network=zentaonet \
  --ip 172.172.172.172 \
  --mac-address 02:42:ac:11:00:00 \
  -v /app/zentaopms:/app/zentaopms \
  -v /app/mysqldata:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -d easysoft/zentao:biz3.7
```

### ZenTao Pro 8.8
- **Imagen**: `easysoft/zentao:pro8.8`
- **Directorio de montaje**: `/app/zentaopms` ⚠️ **IMPORTANTE**
- **Características**: Versión profesional con todas las funcionalidades
- **Comando de instalación**:
```bash
# Crear directorios con la ruta correcta
sudo mkdir -p /app/zentaopms
sudo mkdir -p /app/mysqldata

sudo docker run --name zentao \
  -p 80:80 \
  --network=zentaonet \
  --ip 172.172.172.172 \
  --mac-address 02:42:ac:11:00:00 \
  -v /app/zentaopms:/app/zentaopms \
  -v /app/mysqldata:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -d easysoft/zentao:pro8.8
```

## Notas Importantes

### ⚠️ Cambio en Directorios de Montaje

**Versiones 12.3.1, 12.2.stable, biz3.7 y pro8.8**:
- **Directorio correcto**: `/app/zentaopms`
- **Directorio incorrecto**: `/www/zentaopms`

**Versiones anteriores**:
- **Directorio correcto**: `/www/zentaopms`

### Verificación de Directorios

Para verificar qué directorio usa tu versión:

```bash
# Entrar al contenedor
docker exec -it zentao /bin/bash

# Verificar directorios
ls -la /app/
ls -la /www/

# Verificar configuración de Apache
cat /etc/apache2/sites-available/000-default.conf
```

### Migración entre Versiones

Si cambias de una versión que usa `/www/zentaopms` a una que usa `/app/zentaopms`:

```bash
# 1. Hacer backup
sudo tar -czf backup_zentao.tar.gz -C /www zentaopms mysqldata

# 2. Crear nuevos directorios
sudo mkdir -p /app/zentaopms
sudo mkdir -p /app/mysqldata

# 3. Mover datos
sudo mv /www/zentaopms/* /app/zentaopms/
sudo mv /www/mysqldata/* /app/mysqldata/

# 4. Ajustar permisos
sudo chown -R 1000:1000 /app/zentaopms
sudo chown -R 999:999 /app/mysqldata

# 5. Actualizar docker-compose.yml o comando docker run
```

## Configuración de Docker Compose

### Para versiones que usan `/www/zentaopms`:
```yaml
volumes:
  - /www/zentaopms:/www/zentaopms
  - /www/mysqldata:/var/lib/mysql
```

### Para versiones que usan `/app/zentaopms`:
```yaml
volumes:
  - /app/zentaopms:/app/zentaopms
  - /app/mysqldata:/var/lib/mysql
```

## Enlaces de Descarga

- **ZenTao Biz 3.7**: `ft/zentao:biz3.7`
- **Archivo de imagen**: `dl/zentao_biz3.7.tar`

## Comandos Útiles

### Verificar versión instalada:
```bash
docker exec -it zentao cat /www/zentaopms/VERSION
# o
docker exec -it zentao cat /app/zentaopms/VERSION
```

### Ver logs de instalación:
```bash
docker logs zentao | grep -i "zentao\|version\|install"
```

### Verificar directorios de montaje:
```bash
docker inspect zentao | grep -A 10 "Mounts"
```
