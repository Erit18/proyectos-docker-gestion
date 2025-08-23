# 🚀 Instrucciones para Subir a GitHub y Compartir con el Equipo

## **PASO 1: Crear cuenta en GitHub (si no tienes una)**

1. Ve a [github.com](https://github.com)
2. Haz clic en "Sign up" (Registrarse)
3. Completa el formulario con tu email universitario
4. Confirma tu cuenta

## **PASO 2: Crear un nuevo repositorio**

1. En GitHub, haz clic en el botón verde "New" o "+" 
2. Nombre del repositorio: `proyectos-docker-gestion`
3. Descripción: `Aplicaciones de gestión de proyectos con Docker: OpenProject, Taiga y Tuleap`
4. **IMPORTANTE**: Marca como "Public" para que tus compañeros puedan verlo
5. **NO** marques "Add a README file" (ya tienes uno)
6. Haz clic en "Create repository"

## **PASO 3: Subir tu proyecto desde tu PC**

### **Opción A: Usando GitHub Desktop (Recomendado para principiantes)**

1. Descarga [GitHub Desktop](https://desktop.github.com/)
2. Instálalo y conéctalo con tu cuenta de GitHub
3. Haz clic en "Clone a repository from the Internet"
4. Selecciona tu repositorio `proyectos-docker-gestion`
5. Elige dónde guardarlo en tu PC
6. Copia todos tus archivos a esa carpeta
7. En GitHub Desktop, verás los cambios
8. Escribe un mensaje como "Primera versión del proyecto"
9. Haz clic en "Commit to main"
10. Haz clic en "Push origin"

### **Opción B: Usando comandos Git (Para usuarios avanzados)**

1. Abre CMD en tu carpeta del proyecto
2. Ejecuta estos comandos uno por uno:

```bash
git init
git add .
git commit -m "Primera versión del proyecto"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/proyectos-docker-gestion.git
git push -u origin main
```

**Reemplaza `TU_USUARIO` con tu nombre de usuario de GitHub**

## **PASO 4: Compartir con tus compañeros**

### **Método 1: Compartir el enlace del repositorio**
1. Copia la URL de tu repositorio (ejemplo: `https://github.com/tu-usuario/proyectos-docker-gestion`)
2. Envíala por email, Teams, Discord o la plataforma que usen
3. Tus compañeros podrán ver todo el código y descargarlo

### **Método 2: Invitar como colaboradores (Opcional)**
1. En tu repositorio, ve a "Settings" → "Collaborators"
2. Haz clic en "Add people"
3. Escribe el email de tus compañeros
4. Ellos recibirán una invitación por email

## **PASO 5: Instrucciones para tus compañeros**

### **Para descargar el proyecto:**
1. Ve al enlace del repositorio que les compartiste
2. Haz clic en el botón verde "Code"
3. Selecciona "Download ZIP"
4. Extrae el archivo ZIP en tu PC
5. Sigue las instrucciones del README.md

### **Para usar Git (Recomendado):**
1. Instala [Git](https://git-scm.com/downloads)
2. Abre CMD y ejecuta:
```bash
git clone https://github.com/TU_USUARIO/proyectos-docker-gestion.git
cd proyectos-docker-gestion
```

## **PASO 6: Mantener el proyecto actualizado**

### **Cuando hagas cambios:**
1. En GitHub Desktop: haz commit y push
2. Con Git: `git add .`, `git commit -m "mensaje"`, `git push`

### **Para tus compañeros:**
1. Con Git: `git pull` para obtener los cambios más recientes
2. Sin Git: descargar el ZIP nuevamente

## **📋 Checklist para el equipo:**

- [ ] Todos tienen cuenta en GitHub
- [ ] Todos pueden acceder al repositorio
- [ ] Todos han descargado el proyecto
- [ ] Todos tienen Docker Desktop instalado
- [ ] Todos pueden ejecutar al menos una aplicación
- [ ] Todos han leído el README.md

## **🔗 Enlaces útiles:**

- **GitHub**: [github.com](https://github.com)
- **GitHub Desktop**: [desktop.github.com](https://desktop.github.com)
- **Git**: [git-scm.com](https://git-scm.com)
- **Docker Desktop**: [docker.com/products/docker-desktop](https://docker.com/products/docker-desktop)

## **💡 Consejos:**

1. **Usa GitHub Desktop** si es tu primera vez con Git
2. **Marca el repositorio como público** para facilitar el acceso
3. **Comparte el enlace** en lugar de archivos individuales
4. **Actualiza regularmente** el repositorio con mejoras
5. **Usa mensajes claros** en los commits
