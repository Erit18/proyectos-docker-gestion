#!/bin/bash

# Script de instalación automatizada para ZenTao con Docker
# Basado en la documentación oficial de ZenTao

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar si Docker está instalado
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker no está instalado. Por favor, instala Docker primero."
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        print_error "Docker no está ejecutándose. Por favor, inicia el servicio de Docker."
        exit 1
    fi
    
    print_message "Docker está instalado y ejecutándose."
}

# Crear directorios necesarios
create_directories() {
    print_message "Creando directorios para datos persistentes..."
    
    sudo mkdir -p /www/zentaopms
    sudo mkdir -p /www/mysqldata
    
    # Establecer permisos
    sudo chown -R 1000:1000 /www/zentaopms
    sudo chown -R 999:999 /www/mysqldata
    
    print_message "Directorios creados exitosamente."
}

# Crear red Docker
create_network() {
    print_message "Creando red Docker para ZenTao..."
    
    if ! docker network ls | grep -q "zentaonet"; then
        docker network create --subnet=172.172.172.0/24 zentaonet
        print_message "Red 'zentaonet' creada exitosamente."
    else
        print_message "La red 'zentaonet' ya existe."
    fi
}

# Verificar si la imagen existe
check_image() {
    local image_name=$1
    if docker images | grep -q "$image_name"; then
        print_message "Imagen $image_name encontrada."
        return 0
    else
        print_warning "Imagen $image_name no encontrada."
        return 1
    fi
}

# Ejecutar contenedor ZenTao
run_zentao() {
    local container_name=${1:-"zentao"}
    local host_port=${2:-80}
    local container_ip=${3:-"172.172.172.172"}
    local mac_address=${4:-"02:42:ac:11:00:00"}
    local image_tag=${5:-"12.2.stable"}
    
    print_message "Iniciando contenedor ZenTao..."
    
    # Verificar si el contenedor ya existe
    if docker ps -a | grep -q "$container_name"; then
        print_warning "El contenedor $container_name ya existe."
        read -p "¿Deseas eliminarlo y crear uno nuevo? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker stop "$container_name" 2>/dev/null || true
            docker rm "$container_name" 2>/dev/null || true
        else
            print_message "Usando contenedor existente."
            docker start "$container_name"
            return 0
        fi
    fi
    
    # Comando para ejecutar el contenedor
    local docker_cmd="docker run --name $container_name \
        -p $host_port:80 \
        --network=zentaonet \
        --ip $container_ip \
        --mac-address $mac_address \
        -v /www/zentaopms:/www/zentaopms \
        -v /www/mysqldata:/var/lib/mysql \
        -e MYSQL_ROOT_PASSWORD=123456 \
        -d easysoft/zentao:$image_tag"
    
    print_message "Ejecutando: $docker_cmd"
    
    if eval "$docker_cmd"; then
        print_message "Contenedor ZenTao iniciado exitosamente."
        print_message "Nombre del contenedor: $container_name"
        print_message "Puerto del host: $host_port"
        print_message "IP del contenedor: $container_ip"
    else
        print_error "Error al iniciar el contenedor ZenTao."
        exit 1
    fi
}

# Función principal
main() {
    print_message "Iniciando instalación de ZenTao con Docker..."
    
    # Verificar Docker
    check_docker
    
    # Crear directorios
    create_directories
    
    # Crear red
    create_network
    
    # Verificar imágenes disponibles
    print_message "Verificando imágenes disponibles..."
    
    local available_images=("easysoft/zentao:12.2.stable" "easysoft/zentao:12.3.1" "easysoft/zentao:biz3.7")
    local selected_image=""
    
    for img in "${available_images[@]}"; do
        if check_image "$img"; then
            selected_image="$img"
            break
        fi
    done
    
    if [ -z "$selected_image" ]; then
        print_warning "No se encontraron imágenes de ZenTao."
        print_message "Por favor, descarga e importa una imagen primero:"
        print_message "1. Descarga desde: ft/zentao:biz3.7 o dl/zentao_biz3.7.tar"
        print_message "2. Importa con: docker load -i <archivo>.tar"
        exit 1
    fi
    
    # Extraer tag de la imagen
    local image_tag=$(echo "$selected_image" | cut -d':' -f2)
    
    # Ejecutar contenedor
    run_zentao "zentao" 80 "172.172.172.172" "02:42:ac:11:00:00" "$image_tag"
    
    # Mostrar información final
    print_message "=========================================="
    print_message "Instalación completada exitosamente!"
    print_message "=========================================="
    print_message "ZenTao está disponible en: http://localhost:80"
    print_message "Credenciales por defecto:"
    print_message "  - Usuario: admin"
    print_message "  - Contraseña: 123456"
    print_message ""
    print_message "Para ver el estado del contenedor: docker ps"
    print_message "Para ver logs: docker logs zentao"
    print_message "Para entrar al contenedor: docker exec -it zentao /bin/bash"
    print_message ""
    print_message "¡Disfruta usando ZenTao!"
}

# Ejecutar función principal
main "$@"
