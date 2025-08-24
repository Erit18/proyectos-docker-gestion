# Configuración de ZenTao Docker en Windows

## Requisitos Previos para Windows

### 1. Docker Desktop
- Instalar [Docker Desktop para Windows](https://www.docker.com/products/docker-desktop)
- Asegurarse de que WSL2 esté habilitado
- Docker Desktop debe estar ejecutándose

### 2. WSL2 (Windows Subsystem for Linux)
```powershell
# Verificar si WSL2 está instalado
wsl --list --verbose

# Si no está instalado, habilitarlo
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Reiniciar Windows y luego instalar WSL2
wsl --install
```

### 3. Verificar Docker
```powershell
# Verificar que Docker esté funcionando
docker --version
docker-compose --version
docker info
```

## Instalación en Windows

### Opción 1: Usando Docker Desktop (Recomendado)

1. **Crear directorios de datos**:
```powershell
# Crear directorios en C: (evitar espacios en rutas)
New-Item -ItemType Directory -Path "C:\zentao-data" -Force
New-Item -ItemType Directory -Path "C:\zentao-data\zentaopms" -Force
New-Item -ItemType Directory -Path "C:\zentao-data\mysqldata" -Force
```

2. **Crear red Docker**:
```powershell
docker network create --subnet=172.172.172.0/24 zentaonet
```

3. **Ejecutar contenedor**:
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

### Opción 2: Usando Docker Compose

1. **Crear docker-compose.yml** (ya incluido en este directorio)

2. **Modificar rutas para Windows**:
```yaml
version: '3.8'
services:
  zentao:
    image: easysoft/zentao:12.2.stable
    container_name: zentao
    restart: unless-stopped
    ports:
      - "80:80"
      - "3306:3306"
    networks:
      zentaonet:
        ipv4_address: 172.172.172.172
    volumes:
      - C:\zentao-data\zentaopms:/www/zentaopms
      - C:\zentao-data\mysqldata:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=123456
    mac_address: "02:42:ac:11:00:00"
```

3. **Ejecutar**:
```powershell
docker-compose up -d
```

## Configuración Específica para Windows

### Rutas de Volúmenes
En Windows, las rutas deben usar formato Windows:
- **Correcto**: `C:\zentao-data\zentaopms:/www/zentaopms`
- **Incorrecto**: `/c/zentao-data/zentaopms:/www/zentaopms`

### Permisos de Directorios
```powershell
# Dar permisos completos a los directorios de datos
icacls "C:\zentao-data" /grant Everyone:F /T
icacls "C:\zentao-data\zentaopms" /grant Everyone:F /T
icacls "C:\zentao-data\mysqldata" /grant Everyone:F /T
```

### Configuración de Firewall
```powershell
# Permitir puerto 80 en el firewall de Windows
New-NetFirewallRule -DisplayName "ZenTao HTTP" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow

# Permitir puerto 3306 para MySQL (opcional)
New-NetFirewallRule -DisplayName "ZenTao MySQL" -Direction Inbound -Protocol TCP -LocalPort 3306 -Action Allow
```

## Scripts Adaptados para Windows

### Script de Instalación para PowerShell
```powershell
# zentao-install.ps1
Write-Host "Instalando ZenTao en Windows..." -ForegroundColor Green

# Verificar Docker
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker no está instalado. Instala Docker Desktop primero." -ForegroundColor Red
    exit 1
}

# Crear directorios
Write-Host "Creando directorios de datos..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path "C:\zentao-data\zentaopms" -Force
New-Item -ItemType Directory -Path "C:\zentao-data\mysqldata" -Force

# Crear red
Write-Host "Creando red Docker..." -ForegroundColor Yellow
docker network create --subnet=172.172.172.0/24 zentaonet

# Ejecutar contenedor
Write-Host "Iniciando contenedor ZenTao..." -ForegroundColor Yellow
docker run --name zentao `
  -p 80:80 `
  --network=zentaonet `
  --ip 172.172.172.172 `
  --mac-address 02:42:ac:11:00:00 `
  -v C:\zentao-data\zentaopms:/www/zentaopms `
  -v C:\zentao-data\mysqldata:/var/lib/mysql `
  -e MYSQL_ROOT_PASSWORD=123456 `
  -d easysoft/zentao:12.2.stable

Write-Host "Instalación completada!" -ForegroundColor Green
Write-Host "ZenTao está disponible en: http://localhost:80" -ForegroundColor Cyan
```

### Script de Gestión para PowerShell
```powershell
# zentao-manager.ps1
param(
    [Parameter(Position=0)]
    [string]$Command = "help"
)

$ContainerName = "zentao"

switch ($Command.ToLower()) {
    "start" {
        Write-Host "Iniciando ZenTao..." -ForegroundColor Green
        docker start $ContainerName
    }
    "stop" {
        Write-Host "Deteniendo ZenTao..." -ForegroundColor Yellow
        docker stop $ContainerName
    }
    "restart" {
        Write-Host "Reiniciando ZenTao..." -ForegroundColor Blue
        docker restart $ContainerName
    }
    "status" {
        Write-Host "Estado de ZenTao:" -ForegroundColor Cyan
        docker ps -a --filter "name=$ContainerName"
    }
    "logs" {
        Write-Host "Mostrando logs..." -ForegroundColor Magenta
        docker logs -f $ContainerName
    }
    "backup" {
        Write-Host "Creando backup..." -ForegroundColor Yellow
        $Date = Get-Date -Format "yyyyMMdd_HHmmss"
        docker stop $ContainerName
        Compress-Archive -Path "C:\zentao-data\*" -DestinationPath "C:\zentao-backup\zentao_$Date.zip"
        docker start $ContainerName
        Write-Host "Backup creado en: C:\zentao-backup\zentao_$Date.zip" -ForegroundColor Green
    }
    default {
        Write-Host "Comandos disponibles:" -ForegroundColor Cyan
        Write-Host "  start   - Iniciar contenedor" -ForegroundColor White
        Write-Host "  stop    - Detener contenedor" -ForegroundColor White
        Write-Host "  restart - Reiniciar contenedor" -ForegroundColor White
        Write-Host "  status  - Mostrar estado" -ForegroundColor White
        Write-Host "  logs    - Mostrar logs" -ForegroundColor White
        Write-Host "  backup  - Crear backup" -ForegroundColor White
    }
}
```

## Solución de Problemas Comunes en Windows

### Error: "Drive is not shared"
```powershell
# En Docker Desktop, ir a Settings > Resources > File Sharing
# Agregar C:\ a la lista de directorios compartidos
# Reiniciar Docker Desktop
```

### Error: "Permission denied"
```powershell
# Ejecutar PowerShell como Administrador
# Verificar permisos de directorios
icacls "C:\zentao-data"
```

### Error: "Port already in use"
```powershell
# Verificar qué está usando el puerto 80
netstat -ano | findstr :80

# Cambiar puerto en docker run
docker run --name zentao -p 8080:80 ...
```

### Error: "Network not found"
```powershell
# Verificar redes disponibles
docker network ls

# Crear red si no existe
docker network create --subnet=172.172.172.0/24 zentaonet
```

## Acceso y Uso

### URL de Acceso
- **Local**: http://localhost:80
- **Red local**: http://[IP-DE-TU-PC]:80

### Credenciales por Defecto
- **Usuario**: admin
- **Contraseña**: 123456

### Verificar Estado
```powershell
# Ver contenedores
docker ps

# Ver logs
docker logs zentao

# Ver uso de recursos
docker stats zentao
```

## Backup y Restauración en Windows

### Crear Backup
```powershell
# Detener contenedor
docker stop zentao

# Comprimir directorios
$Date = Get-Date -Format "yyyyMMdd_HHmmss"
Compress-Archive -Path "C:\zentao-data\*" -DestinationPath "C:\zentao-backup\zentao_$Date.zip"

# Reiniciar contenedor
docker start zentao
```

### Restaurar Backup
```powershell
# Detener contenedor
docker stop zentao

# Extraer backup
Expand-Archive -Path "C:\zentao-backup\zentao_YYYYMMDD_HHMMSS.zip" -DestinationPath "C:\zentao-data" -Force

# Reiniciar contenedor
docker start zentao
```

## Notas Importantes para Windows

1. **Evitar espacios en rutas**: Usar `C:\zentao-data` en lugar de `C:\Program Files\zentao`
2. **Permisos de administrador**: Algunos comandos requieren PowerShell como administrador
3. **Antivirus**: Puede interferir con Docker, agregar excepciones si es necesario
4. **WSL2**: Asegurarse de que esté habilitado y funcionando correctamente
5. **Docker Desktop**: Mantener actualizado para mejor compatibilidad con Windows
