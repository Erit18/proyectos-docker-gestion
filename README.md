# Aplicaciones de Gestión de Proyectos con Docker

Este proyecto contiene configuraciones Docker Compose para tres herramientas de gestión de proyectos:

## Aplicaciones Incluidas

1. **OpenProject** - Herramienta colaborativa con enfoque en metodologías ágiles
2. **Taiga** - Plataforma ágil con tableros Kanban y gestión Scrum
3. **ZenTao** - Sistema de gestión de proyectos y defectos con metodologías ágiles

## Requisitos Previos

### **⚠️ OBLIGATORIO - Instalar primero:**
- **Docker Desktop** - Descargar desde [docker.com](https://docker.com/products/docker-desktop)
- **Windows 10/11** (64-bit) o **macOS** (10.15+) o **Ubuntu** (18.04+)

### **Requisitos del sistema:**
- Al menos **4GB de RAM** disponible
- **Puertos disponibles**: 8080, 9000, 80
- **Conexión a internet** para descargar las imágenes Docker

### **⚠️ NOTA IMPORTANTE - Puerto 80 en Windows:**
- **El puerto 80 puede estar ocupado** por IIS, Apache u otros servicios web
- **Si tienes problemas**, puedes cambiar el puerto de ZenTao a 8080 o 8081
- **Para verificar**: `netstat -ano | findstr :80`

## 📥 **Cómo obtener este proyecto**

### **Opción 1: Desde GitHub (Recomendado)**
1. Ve al repositorio: `https://github.com/Erit18/proyectos-docker-gestion.git`
2. Haz clic en el botón verde "Code"
3. Selecciona "Download ZIP"
4. Extrae el archivo en tu PC

### **Opción 2: Con Git**
```bash
git clone https://github.com/Erit18/proyectos-docker-gestion.git
```

## Instrucciones de Instalación

### **PASO 1: Abrir el Símbolo del Sistema (CMD)**

1. Presiona `Windows + R` en tu teclado
2. Escribe `cmd` y presiona Enter
3. Se abrirá una ventana negra (CMD)

### **PASO 2: Navegar a tu carpeta del proyecto**

En el CMD, escribe:
```bash
cd "ruta\a\tu\carpeta\proyectos_docker"
```

**Ejemplos de rutas comunes:**
- Si está en el escritorio: `cd Desktop\proyectos_docker`
- Si está en documentos: `cd Documents\proyectos_docker`
- Si está en otra ubicación: `cd "C:\Users\TuUsuario\Desktop\proyectos_docker"`

### **PASO 3: Ejecutar las aplicaciones**

#### **1. OpenProject (Recomendado empezar con esta)**

```bash
docker-compose -f openproject-docker/openproject-docker-compose.yml up -d
```

**Esperar 5-10 minutos** para que se inicialice completamente (la primera vez tarda más)

**Acceso:** Abrir tu navegador y ir a: http://localhost:8080
- Usuario por defecto: `admin`
- Contraseña por defecto: `admin`
- **Nota:** La primera vez que accedas, OpenProject puede tardar en cargar mientras termina la configuración inicial

#### **2. Taiga**

```bash
docker-compose -f taiga-docker/docker-compose.yml up -d
```

**Esperar 5-8 minutos** para que se inicialice completamente (la primera vez tarda más)

**IMPORTANTE - Primera vez:**
1. **Aplicar migraciones de base de datos:**
```bash
docker-compose -f taiga-docker/docker-compose.yml -f taiga-docker/docker-compose-inits.yml run --rm taiga-manage migrate
```

2. **Crear superusuario:**
```bash
docker-compose -f taiga-docker/docker-compose.yml -f taiga-docker/docker-compose-inits.yml run --rm taiga-manage createsuperuser
```

**Acceso:** Abrir tu navegador y ir a: http://localhost:9000
- **IMPORTANTE**: La primera vez que accedas, Taiga puede tardar en cargar mientras termina la configuración inicial
- **Nota**: Taiga usa backend y frontend integrados en el puerto 9000 con PostgreSQL

#### **3. ZenTao**

```bash
docker-compose -f zentao-docker/docker-compose.yml up -d
```

**Esperar 2-4 minutos** para que se inicialice completamente (la primera vez tarda más)

**Acceso:** Abrir tu navegador y ir a: http://localhost:80
- Usuario por defecto: `admin`
- Contraseña por defecto: `123456`
- **Nota**: ZenTao incluye MySQL integrado internamente y se configura automáticamente
- **Base de datos**: Se crea automáticamente, no requiere configuración manual

## 🔄 **Ciclo de Vida de las Aplicaciones**

### **📊 Persistencia de Datos**
- **✅ Los datos se mantienen** entre reinicios del sistema
- **✅ Los usuarios y proyectos creados** permanecen guardados
- **✅ Las configuraciones** se conservan automáticamente
- **❌ Solo se pierden los datos** si eliminas explícitamente los volúmenes

### **🔄 Encendido y Apagado Diario**

#### **Para APAGAR las aplicaciones:**
```bash
# Detener OpenProject
docker-compose -f openproject-docker/openproject-docker-compose.yml down

# Detener Taiga
docker-compose -f taiga-docker/docker-compose.yml down

# Detener ZenTao
docker-compose -f zentao-docker/docker-compose.yml down
```

#### **Para ENCENDER las aplicaciones:**
```bash
# Levantar OpenProject
docker-compose -f openproject-docker/openproject-docker-compose.yml up -d

# Levantar Taiga
docker-compose -f taiga-docker/docker-compose.yml up -d

# Levantar ZenTao
docker-compose -f zentao-docker/docker-compose.yml up -d
```

#### **Después de encender:**
- **Accede con las mismas credenciales** que creaste anteriormente
- **No necesitas crear usuarios de nuevo**
- **Todos tus proyectos y datos estarán disponibles**

### **🗑️ Eliminación Completa (CUIDADO: Elimina TODOS los datos)**

#### **⚠️ ADVERTENCIA: Esto eliminará PERMANENTEMENTE todos los datos**

```bash
# Eliminar OpenProject y TODOS sus datos
docker-compose -f openproject-docker/openproject-docker-compose.yml down -v

# Eliminar Taiga y TODOS sus datos
docker-compose -f taiga-docker/docker-compose.yml down -v

# Eliminar ZenTao y TODOS sus datos
docker-compose -f zentao-docker/docker-compose.yml down -v
```

#### **¿Cuándo usar eliminación completa?**
- **Cambio de versión** de la aplicación
- **Problemas graves** que no se resuelven con reinicio
- **Limpieza completa** del sistema
- **Pruebas** que requieren empezar desde cero

#### **Después de eliminación completa:**
- **Necesitarás crear usuarios de nuevo**
- **Todos los proyectos se perderán**
- **Configuraciones volverán a valores por defecto**
- **Para Taiga**: Necesitarás ejecutar las migraciones y crear superusuario nuevamente

## Comandos Útiles

### **Ver si las aplicaciones están funcionando**
```bash
docker ps
```

### **Ver logs de una aplicación específica**
```bash
# OpenProject
docker-compose -f openproject-docker/openproject-docker-compose.yml logs -f

# Taiga
docker-compose -f taiga-docker/docker-compose.yml logs -f

# ZenTao
docker-compose -f zentao-docker/docker-compose.yml logs -f
```

### **Reiniciar servicios (mantiene datos)**
```bash
# OpenProject
docker-compose -f openproject-docker/openproject-docker-compose.yml restart

# Taiga
docker-compose -f taiga-docker/docker-compose.yml restart

# ZenTao
docker-compose -f zentao-docker/docker-compose.yml restart
```

### **Ver estado detallado**
```bash
# OpenProject
docker-compose -f openproject-docker/openproject-docker-compose.yml ps

# Taiga
docker-compose -f taiga-docker/docker-compose.yml ps

# ZenTao
docker-compose -f zentao-docker/docker-compose.yml ps
```

## Solución de Problemas

### **Si OpenProject no carga:**
1. **Primera vez**: Espera al menos 10-15 minutos para la inicialización completa
2. Verifica que Docker Desktop esté ejecutándose (ícono de ballena en la barra de tareas)
3. Revisa los logs: `docker-compose -f openproject-docker/openproject-docker-compose.yml logs -f`
4. Si ves errores de base de datos, espera más tiempo - OpenProject está configurando PostgreSQL internamente
5. Asegúrate de que el puerto 8080 no esté ocupado

### **Si Taiga no carga:**
1. **Primera vez**: Espera al menos 8-10 minutos para la inicialización completa
2. Verifica que Docker Desktop esté ejecutándose (ícono de ballena en la barra de tareas)
3. Revisa los logs: `docker-compose -f taiga-docker/docker-compose.yml logs -f`
4. Si ves errores de base de datos, espera más tiempo - Taiga está configurando PostgreSQL
5. Asegúrate de que el puerto 9000 no esté ocupado
6. **Nota**: Taiga usa backend y frontend integrados en el puerto 9000 con PostgreSQL
7. **Si es la primera vez**: Asegúrate de haber ejecutado las migraciones y creado el superusuario

### **Si ZenTao no carga:**
1. **Primera vez**: Espera al menos 2-4 minutos para la inicialización completa
2. Verifica que Docker Desktop esté ejecutándose (ícono de ballena en la barra de tareas)
3. Revisa los logs: `docker-compose -f zentao-docker/docker-compose.yml logs -f`
4. Si ves errores de base de datos, espera más tiempo - ZenTao está configurando MySQL internamente
5. **IMPORTANTE**: Verifica que el puerto 80 no esté ocupado por IIS, Apache u otros servicios
6. **Si el puerto 80 está ocupado**: Cambia el puerto en docker-compose.yml a 8080 o 8081
7. **Nota**: ZenTao incluye MySQL integrado y se configura automáticamente

### **Si una aplicación no carga:**
1. Verifica que Docker Desktop esté ejecutándose (ícono de ballena en la barra de tareas)
2. Revisa los logs con `docker-compose logs`
3. Asegúrate de que los puertos no estén ocupados
4. Espera más tiempo para la inicialización completa

### **Si hay problemas de memoria:**
1. Cierra otras aplicaciones
2. Aumenta la memoria asignada a Docker Desktop
3. Ejecuta solo una aplicación a la vez

### **Si el comando no se reconoce:**
1. Asegúrate de que Docker Desktop esté instalado y ejecutándose
2. Reinicia el CMD después de instalar Docker Desktop
3. Verifica que estés en la carpeta correcta del proyecto

## Notas Importantes

- **La primera ejecución puede tardar más tiempo** debido a la descarga de imágenes
- Las aplicaciones se reiniciarán automáticamente si se detienen
- **Los datos se mantienen en volúmenes Docker persistentes** entre reinicios
- Para desarrollo universitario, estas configuraciones son suficientes
- **Ejecuta una aplicación a la vez** para evitar problemas de memoria
- **Los usuarios y proyectos creados se mantienen** hasta que elimines explícitamente los volúmenes
- **ZenTao es la aplicación más rápida** de instalar (2-4 minutos vs 5-15 minutos de las otras)

## URLs de Acceso Resumen

- **OpenProject**: http://localhost:8080
- **Taiga**: http://localhost:9000
- **ZenTao**: http://localhost:80