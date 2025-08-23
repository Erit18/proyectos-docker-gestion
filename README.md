# Aplicaciones de Gestión de Proyectos con Docker

Este proyecto contiene configuraciones Docker Compose para tres herramientas de gestión de proyectos:

## Aplicaciones Incluidas

1. **OpenProject** - Herramienta colaborativa con enfoque en metodologías ágiles
2. **Taiga** - Plataforma ágil con tableros Kanban y gestión Scrum
3. **Tuleap** - ALM con soporte para metodologías ágiles y tradicionales

## Requisitos Previos

- Docker Desktop instalado y ejecutándose
- Al menos 4GB de RAM disponible
- Puertos disponibles: 8080, 9001, 8081, 8082

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
docker-compose -f openproject-docker-compose.yml up -d
```

**Esperar 2-3 minutos** para que se inicialice completamente

**Acceso:** Abrir tu navegador y ir a: http://localhost:8080
- Usuario por defecto: `admin`
- Contraseña por defecto: `admin`

#### **2. Taiga**

```bash
docker-compose -f taiga-docker-compose.yml up -d
```

**Esperar 3-4 minutos** para que se inicialice completamente

**Acceso:** Abrir tu navegador y ir a: http://localhost:9001
- La primera vez que accedas, se te pedirá crear un usuario administrador

#### **3. Tuleap**

```bash
docker-compose -f tuleap-docker-compose.yml up -d
```

**Esperar 5-6 minutos** para que se inicialice completamente

**Acceso:** 
- HTTP: http://localhost:8082
- HTTPS: https://localhost:8081 (puede mostrar advertencia de certificado)

## Comandos Útiles

### **Ver si las aplicaciones están funcionando**
```bash
docker ps
```

### **Ver logs de una aplicación específica**
```bash
# OpenProject
docker-compose -f openproject-docker-compose.yml logs -f

# Taiga
docker-compose -f taiga-docker-compose.yml logs -f

# Tuleap
docker-compose -f tuleap-docker-compose.yml logs -f
```

### **Detener una aplicación**
```bash
# OpenProject
docker-compose -f openproject-docker-compose.yml down

# Taiga
docker-compose -f taiga-docker-compose.yml down

# Tuleap
docker-compose -f tuleap-docker-compose.yml down
```

### **Detener todas las aplicaciones**
```bash
docker-compose -f openproject-docker-compose.yml down
docker-compose -f taiga-docker-compose.yml down
docker-compose -f tuleap-docker-compose.yml down
```

## Solución de Problemas

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
- Los datos se mantienen en volúmenes Docker persistentes
- Para desarrollo universitario, estas configuraciones son suficientes
- **Ejecuta una aplicación a la vez** para evitar problemas de memoria

## URLs de Acceso Resumen

- **OpenProject**: http://localhost:8080
- **Taiga**: http://localhost:9001  
- **Tuleap**: http://localhost:8082 (HTTP) o https://localhost:8081 (HTTPS)

## Consejos para el Equipo

1. **Empieza con OpenProject** - Es la más fácil de configurar
2. **Toma capturas de pantalla** de cada aplicación funcionando
3. **Documenta los pasos** que sigues para tu presentación
4. **Si algo no funciona**, revisa los logs primero
5. **Comparte esta documentación** con todos los miembros del equipo
