# 🐉 Kali Linux Pentesting Environment with Docker

Entorno de pentesting basado en Docker y Kali Linux, diseñado para disponer de un entorno de trabajo aislado y configurable, integrado con el escritorio del sistema anfitrión.

El proyecto combina una imagen personalizada de Kali Linux con un contenedor preparado para ejecutar herramientas de seguridad, utilizar una terminal gráfica Kitty y acceder a determinados recursos del host cuando sea necesario.

Mediante funciones de Bash, permite iniciar el entorno, desplegar la terminal gráfica y detener el contenedor sin tener que repetir manualmente todos los comandos de Docker.

## ✨ Características

- 🐉 **Kali Linux Rolling:** utiliza la imagen oficial de Kali como base del entorno.
- 🐳 **Imagen personalizada:** instala herramientas de red, utilidades de administración y componentes gráficos.
- 👤 **Usuario configurable:** permite establecer el nombre de usuario y la shell durante la construcción de la imagen.
- 🖥️ **Terminal gráfica:** ejecuta Kitty desde el contenedor y la integra con el servidor gráfico del host.
- 🌐 **Integración de red:** utiliza el modo de red del host y permite acceder a determinadas capacidades de red.
- 🔧 **Automatización mediante Bash:** simplifica el inicio, la configuración y la detención del contenedor.
- 🎮 **Compatibilidad gráfica:** incluye bibliotecas de Mesa y acceso a recursos gráficos del host.
- 🔌 **Acceso a dispositivos:** permite exponer determinados dispositivos USB y recursos del sistema anfitrión.
- ⚙️ **Configuración del entorno de ejecución:** ajusta el hostname y determinadas opciones de resolución DNS durante el arranque.

## 🧰 Arquitectura

El proyecto está compuesto por tres elementos principales:

| Componente          | Responsabilidad                                                                          |
| ------------------- | ---------------------------------------------------------------------------------------- |
| Dockerfile          | Construye la imagen personalizada de Kali Linux e instala las dependencias.              |
| Script de ejecución | Crea el contenedor y configura los recursos necesarios para su funcionamiento.           |
| Funciones Bash      | Automatizan el inicio del contenedor, el despliegue de Kitty y la detención del entorno. |

El contenedor utiliza el nombre `kali-box`, el usuario predeterminado `stark` y el hostname `kali` en los ejemplos de configuración.

## 📋 Requisitos

Antes de utilizar el proyecto, necesitas:

- Un sistema Linux con Docker instalado y operativo.
- Permisos para ejecutar comandos de Docker.
- Bash y las utilidades empleadas por los scripts.
- Un entorno gráfico compatible con la integración X11 utilizada por la configuración.
- Conexión a Internet para descargar la imagen base e instalar los paquetes.
- Recursos suficientes para ejecutar la imagen y las herramientas de seguridad instaladas.

El acceso a Wayland, dispositivos USB, interfaces de red y aceleración gráfica depende de la configuración del host y de los permisos disponibles.

## 🚀 Instalación y configuración

### 1. Construir la imagen

Desde el directorio que contiene el `Dockerfile`, ejecuta:

```bash
docker build \
  --build-arg USERNAME=stark \
  --build-arg USER_SHELL=/bin/zsh \
  -t kali-pentest .
```

Los argumentos permiten personalizar el usuario y su shell predeterminada.

El Dockerfile instala Kali Linux Large, Zsh, Kitty, `sudo`, herramientas de red y dependencias gráficas.

**Nota:** el argumento `PASSWORD` del Dockerfile toma como valor predeterminado el nombre del usuario. Si no lo sobrescribes, la contraseña inicial será la misma que el nombre de usuario.

### 2. Crear el contenedor

El contenedor debe crearse una sola vez utilizando el comando `docker run` del proyecto.

Esta configuración incluye el modo de red del host, variables de entorno gráficas, volúmenes y permisos adicionales para determinados dispositivos y operaciones de sistema.

Revisa cuidadosamente estos parámetros antes de ejecutarlo, especialmente las opciones relacionadas con privilegios, red y acceso al host.

Una vez creado, podrás administrarlo mediante las funciones de Bash descritas a continuación.

### 3. Configurar las funciones de Bash

Añade las funciones del proyecto a un archivo de configuración de tu shell, como `~/.zshrc` o `~/.bashrc`, según la shell que utilices en el host.

Las variables principales son:

```bash
export PENTEST_CONTAINER="kali-box"
export PENTEST_USER="stark"
export PENTEST_HOSTNAME="kali"
```

Ajusta sus valores si utilizas un nombre de contenedor o usuario diferente.

Después, recarga el archivo de configuración correspondiente o abre una terminal nueva.

## 🎮 Uso

### Iniciar el entorno

```bash
pentest
```

La función realiza las siguientes acciones:

1. Prepara el acceso al servidor gráfico X11.
2. Comprueba si el contenedor está en ejecución.
3. Inicia el contenedor si se encuentra detenido.
4. Ejecuta Kitty dentro del entorno.
5. Aplica los ajustes de hostname y resolución DNS definidos en el script.

Si todo funciona correctamente, tendrás una terminal gráfica para trabajar con el entorno de Kali Linux.

### Detener el entorno

```bash
pentest-stop
```

Esta función detiene el contenedor `kali-box` y libera los recursos que Docker pueda liberar al detenerlo.

Los archivos que formen parte de la capa escribible del contenedor no deben considerarse almacenamiento persistente garantizado. Para conservar herramientas, configuraciones y resultados, utiliza volúmenes o mecanismos de almacenamiento apropiados.

## ⚙️ Tecnologías utilizadas

- **Kali Linux:** distribución orientada a pruebas de seguridad y auditoría.
- **Docker:** construcción y ejecución del entorno contenerizado.
- **Bash:** automatización de las tareas de administración.
- **Kitty:** emulador de terminal gráfica.
- **Zsh:** shell interactiva del usuario.
- **X11:** integración gráfica con el host.
- **Mesa:** bibliotecas para renderizado gráfico.
- **iproute2 y net-tools:** utilidades de diagnóstico y administración de red.

## 🔐 Seguridad y aislamiento

Aunque el entorno utiliza Docker, **la configuración actual no debe considerarse un aislamiento estricto**.

El modo de red del host, las capacidades adicionales, los permisos de `SYS_ADMIN`, las opciones de seguridad desactivadas y el acceso a dispositivos amplían considerablemente los privilegios del contenedor.

Antes de utilizarlo, ten en cuenta lo siguiente:

- Utiliza el entorno únicamente en sistemas y redes donde tengas autorización.
- Evita ejecutar herramientas de seguridad contra objetivos sin permiso.
- No almacenes credenciales sensibles innecesariamente en la imagen.
- Revisa los dispositivos, directorios y sockets que expones al contenedor.
- No desactives AppArmor o seccomp sin evaluar las consecuencias.
- Considera eliminar capacidades y montajes que no sean imprescindibles.
- Ten presente que el acceso al socket de Docker, si se incorpora en el futuro, puede permitir un control muy amplio sobre el host.

El usuario creado por el Dockerfile también recibe permisos `sudo` sin contraseña dentro del contenedor. Esto facilita la administración, pero aumenta las consecuencias de comprometer esa cuenta.

## ⚠️ Limitaciones conocidas

- La integración gráfica depende de que el servidor X11 del host permita las conexiones.
- Las rutas de `/run/user/1000` y otras rutas montadas están vinculadas a la configuración concreta del host.
- El acceso a `/dev/dri` no garantiza aceleración gráfica funcional.
- El comportamiento de DNS depende de los servicios y archivos de resolución disponibles.
- El script de ejecución debe comprobar correctamente el estado del contenedor y los errores de los comandos antes de informar que el entorno está listo.
- La imagen `kali-rolling` y los paquetes instalados pueden cambiar con el tiempo; reconstruir la imagen en fechas distintas puede producir resultados diferentes.

## 🎯 Objetivo

Disponer de un entorno de trabajo basado en Kali Linux que combine herramientas de seguridad, terminal gráfica e integración con el escritorio anfitrión, reduciendo la intervención manual necesaria para utilizarlo en actividades de aprendizaje, laboratorios y pruebas de penetración autorizadas.
