#!/bin/bash

# Script de gestión para ZenTao Docker
# Permite realizar operaciones comunes como start, stop, backup, update, etc.

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración
CONTAINER_NAME="zentao"
BACKUP_DIR="/backup/zentao"
DATE=$(date +%Y%m%d_%H%M%S)

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

print_header() {
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}==========================================${NC}"
}

# Función para mostrar ayuda
show_help() {
    print_header "Gestor de ZenTao Docker"
    echo "Uso: $0 [COMANDO] [OPCIONES]"
    echo ""
    echo "Comandos disponibles:"
    echo "  start       - Iniciar contenedor ZenTao"
    echo "  stop        - Detener contenedor ZenTao"
    echo "  restart     - Reiniciar contenedor ZenTao"
    echo "  status      - Mostrar estado del contenedor"
    echo "  logs        - Mostrar logs del contenedor"
    echo "  backup      - Crear backup de datos"
    echo "  restore     - Restaurar backup"
    echo "  update      - Actualizar ZenTao"
    echo "  shell       - Entrar al contenedor"
    echo "  info        - Mostrar información del sistema"
    echo "  clean       - Limpiar contenedores y redes no utilizadas"
    echo "  help        - Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 start"
    echo "  $0 backup"
    echo "  $0 logs"
}

# Verificar si Docker está ejecutándose
check_docker() {
    if ! docker info &> /dev/null; then
        print_error "Docker no está ejecutándose."
        exit 1
    fi
}

# Verificar si el contenedor existe
check_container() {
    if ! docker ps -a | grep -q "$CONTAINER_NAME"; then
        print_error "El contenedor $CONTAINER_NAME no existe."
        exit 1
    fi
}

# Función para iniciar ZenTao
start_zentao() {
    print_message "Iniciando ZenTao..."
    check_docker
    
    if docker ps | grep -q "$CONTAINER_NAME"; then
        print_warning "ZenTao ya está ejecutándose."
        return 0
    fi
    
    if docker ps -a | grep -q "$CONTAINER_NAME"; then
        docker start "$CONTAINER_NAME"
        print_message "ZenTao iniciado exitosamente."
    else
        print_error "El contenedor $CONTAINER_NAME no existe. Ejecuta el script de instalación primero."
        exit 1
    fi
}

# Función para detener ZenTao
stop_zentao() {
    print_message "Deteniendo ZenTao..."
    check_docker
    check_container
    
    if docker ps | grep -q "$CONTAINER_NAME"; then
        docker stop "$CONTAINER_NAME"
        print_message "ZenTao detenido exitosamente."
    else
        print_warning "ZenTao ya está detenido."
    fi
}

# Función para reiniciar ZenTao
restart_zentao() {
    print_message "Reiniciando ZenTao..."
    stop_zentao
    sleep 2
    start_zentao
}

# Función para mostrar estado
show_status() {
    print_header "Estado de ZenTao"
    check_docker
    
    echo "Contenedores Docker:"
    docker ps -a --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    
    echo ""
    echo "Redes Docker:"
    docker network ls --filter "name=zentaonet"
    
    echo ""
    echo "Volúmenes:"
    docker volume ls --filter "name=zentao"
    
    echo ""
    echo "Uso de recursos:"
    if docker ps | grep -q "$CONTAINER_NAME"; then
        docker stats "$CONTAINER_NAME" --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
    fi
}

# Función para mostrar logs
show_logs() {
    print_message "Mostrando logs de ZenTao..."
    check_docker
    check_container
    
    docker logs -f "$CONTAINER_NAME"
}

# Función para crear backup
create_backup() {
    print_header "Creando Backup de ZenTao"
    check_docker
    check_container
    
    # Crear directorio de backup si no existe
    sudo mkdir -p "$BACKUP_DIR"
    
    # Detener contenedor para backup consistente
    print_message "Deteniendo contenedor para backup consistente..."
    docker stop "$CONTAINER_NAME"
    
    # Crear backup
    print_message "Creando backup de datos..."
    sudo tar -czf "$BACKUP_DIR/zentao_data_$DATE.tar.gz" -C /www zentaopms
    sudo tar -czf "$BACKUP_DIR/zentao_mysql_$DATE.tar.gz" -C /www mysqldata
    
    # Reiniciar contenedor
    print_message "Reiniciando contenedor..."
    docker start "$CONTAINER_NAME"
    
    print_message "Backup completado exitosamente:"
    echo "  - Datos: $BACKUP_DIR/zentao_data_$DATE.tar.gz"
    echo "  - MySQL: $BACKUP_DIR/zentao_mysql_$DATE.tar.gz"
}

# Función para restaurar backup
restore_backup() {
    print_header "Restaurando Backup de ZenTao"
    
    if [ $# -eq 0 ]; then
        print_error "Debes especificar la fecha del backup (YYYYMMDD_HHMMSS)"
        echo "Backups disponibles:"
        ls -la "$BACKUP_DIR" 2>/dev/null || echo "No hay backups disponibles"
        exit 1
    fi
    
    local backup_date=$1
    local data_backup="$BACKUP_DIR/zentao_data_$backup_date.tar.gz"
    local mysql_backup="$BACKUP_DIR/zentao_mysql_$backup_date.tar.gz"
    
    if [ ! -f "$data_backup" ] || [ ! -f "$mysql_backup" ]; then
        print_error "Backup no encontrado para la fecha $backup_date"
        exit 1
    fi
    
    read -p "¿Estás seguro de que quieres restaurar el backup? Esto sobrescribirá los datos actuales. (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_message "Restauración cancelada."
        exit 0
    fi
    
    check_docker
    check_container
    
    # Detener contenedor
    print_message "Deteniendo contenedor..."
    docker stop "$CONTAINER_NAME"
    
    # Restaurar datos
    print_message "Restaurando datos..."
    sudo rm -rf /www/zentaopms/*
    sudo tar -xzf "$data_backup" -C /www
    
    print_message "Restaurando MySQL..."
    sudo rm -rf /www/mysqldata/*
    sudo tar -xzf "$mysql_backup" -C /www
    
    # Reiniciar contenedor
    print_message "Reiniciando contenedor..."
    docker start "$CONTAINER_NAME"
    
    print_message "Restauración completada exitosamente."
}

# Función para actualizar ZenTao
update_zentao() {
    print_header "Actualizando ZenTao"
    print_warning "Esta operación requiere descarga manual de la nueva versión."
    print_message "Pasos para actualizar:"
    echo "1. Descarga la nueva versión desde: https://www.zentao.pm/download.html"
    echo "2. Extrae los archivos"
    echo "3. Ejecuta: $0 backup"
    echo "4. Sobrescribe los archivos en /www/zentaopms"
    echo "5. Ejecuta: $0 restart"
    echo "6. Visita http://localhost/upgrade.php"
}

# Función para entrar al contenedor
enter_shell() {
    print_message "Entrando al contenedor ZenTao..."
    check_docker
    check_container
    
    if docker ps | grep -q "$CONTAINER_NAME"; then
        docker exec -it "$CONTAINER_NAME" /bin/bash
    else
        print_error "El contenedor no está ejecutándose. Inícialo primero."
        exit 1
    fi
}

# Función para mostrar información del sistema
show_info() {
    print_header "Información del Sistema ZenTao"
    
    echo "Versión de Docker:"
    docker --version
    
    echo ""
    echo "Versión de Docker Compose:"
    docker-compose --version 2>/dev/null || echo "Docker Compose no está instalado"
    
    echo ""
    echo "Imágenes disponibles:"
    docker images | grep zentao || echo "No hay imágenes de ZenTao"
    
    echo ""
    echo "Contenedores:"
    docker ps -a --filter "name=zentao" --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
    
    echo ""
    echo "Redes:"
    docker network ls --filter "name=zentaonet"
    
    echo ""
    echo "Volúmenes:"
    docker volume ls --filter "name=zentao"
    
    echo ""
    echo "Uso de disco:"
    df -h /www 2>/dev/null || echo "Directorio /www no encontrado"
}

# Función para limpiar recursos no utilizados
clean_resources() {
    print_header "Limpiando Recursos Docker"
    check_docker
    
    print_warning "Esta operación eliminará contenedores, redes e imágenes no utilizadas."
    read -p "¿Continuar? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_message "Operación cancelada."
        exit 0
    fi
    
    print_message "Eliminando contenedores detenidos..."
    docker container prune -f
    
    print_message "Eliminando redes no utilizadas..."
    docker network prune -f
    
    print_message "Eliminando imágenes no utilizadas..."
    docker image prune -f
    
    print_message "Limpieza completada."
}

# Función principal
main() {
    case "${1:-help}" in
        start)
            start_zentao
            ;;
        stop)
            stop_zentao
            ;;
        restart)
            restart_zentao
            ;;
        status)
            show_status
            ;;
        logs)
            show_logs
            ;;
        backup)
            create_backup
            ;;
        restore)
            restore_backup "$2"
            ;;
        update)
            update_zentao
            ;;
        shell)
            enter_shell
            ;;
        info)
            show_info
            ;;
        clean)
            clean_resources
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Comando desconocido: $1"
            show_help
            exit 1
            ;;
    esac
}

# Ejecutar función principal
main "$@"
