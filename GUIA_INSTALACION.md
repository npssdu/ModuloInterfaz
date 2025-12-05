# Guía de Instalación y Funcionamiento - Gabinete de Abogados

Este proyecto es una interfaz web desarrollada en **Python/Django** que se conecta a una base de datos **Oracle 11g XE** para la gestión de clientes de un gabinete de abogados.

## 1. Requisitos del Sistema

*   **Sistema Operativo:** Windows (Recomendado para Oracle XE 11g)
*   **Python:** Versión 3.10 o superior (Probado con 3.13.5)
*   **Base de Datos:** Oracle Database 11g Express Edition (XE)
*   **Navegador Web:** Chrome, Firefox, Edge

## 2. Configuración de Base de Datos Oracle

### Paso 1: Instalación de Oracle XE 11g
Asegúrese de tener instalado Oracle Database 11g Express Edition.
*   Directorio de instalación típico: `C:\oraclexe\`

### Paso 2: Creación del Usuario
Abra `SQL*Plus` o `SQL Developer` con permisos de administrador (`system`) y ejecute:

```sql
-- Crear usuario
CREATE USER BD85 IDENTIFIED BY bd85;

-- Asignar permisos
GRANT CONNECT, RESOURCE, DBA TO BD85;
```

### Paso 3: Creación de Tablas y Datos
Ejecute los scripts SQL proporcionados en el orden siguiente usando el usuario `BD85`:

1.  `01_crear_tablas.sql`: Crea la estructura de las 17 tablas.
2.  `02_inserciones_datos.sql`: Puebla las tablas con datos iniciales (catalogos y clientes de prueba).

## 3. Instalación del Proyecto Python

### Paso 1: Ubicación
Sitúese en la carpeta raíz del proyecto:
`C:\Users\DELLPHOTO\Documents\Universidad Distrital\S9 _ 2025-III\26140 - BASES DE DATOS\Modulo Interfaz`

### Paso 2: Entorno Virtual
Es recomendable usar un entorno virtual para aislar las dependencias.

```powershell
# Crear entorno virtual (si no existe)
python -m venv .venv

# Activar entorno virtual (Windows PowerShell)
.\.venv\Scripts\Activate
```

### Paso 3: Instalar Dependencias
Instale las librerías necesarias. El proyecto requiere `django` y `oracledb`.

```powershell
pip install django oracledb
```

*Nota: El proyecto usa `oracledb` en modo "Thick" para compatibilidad con Oracle 11g.*

## 4. Configuración del Proyecto

### Verificación de Credenciales
El archivo `clientes/views.py` contiene la configuración de conexión. Asegúrese de que coincida con su BD local:

```python
# clientes/views.py

ORACLE_USER = 'BD85'
ORACLE_PASSWORD = 'bd85'
ORACLE_HOST = 'localhost'
ORACLE_PORT = 1521
ORACLE_SERVICE = 'XE'

# Ruta crítica para Oracle 11g
ORACLE_CLIENT_PATH = r"C:\oraclexe\app\oracle\product\11.2.0\server\bin"
```

**IMPORTANTE:** La variable `ORACLE_CLIENT_PATH` debe apuntar exactamente a la carpeta `bin` de su instalación de Oracle. Si su instalación es diferente, modifique esta línea en `clientes/views.py`.

## 5. Ejecución de la Aplicación

1.  Asegúrese de que el entorno virtual esté activado (verá `(.venv)` al inicio de la línea de comandos).
2.  Ejecute el servidor de desarrollo de Django:

```powershell
python manage.py runserver
```

3.  Si todo es correcto, verá un mensaje indicando que el servidor corre en `http://127.0.0.1:8000/`.
4.  Abra su navegador y vaya a esa dirección.

## 6. Uso de la Aplicación

*   **Registro:** Complete el formulario con los datos del cliente (Código, Nombre, Apellido, Documento, Tipo).
*   **Búsqueda:** Ingrese un código existente (ej. `CL001`) y presione el botón de la **Lupa** para cargar los datos automáticamente.
*   **Guardar/Actualizar:** El botón **Guardar** sirve tanto para crear nuevos registros como para actualizar existentes. El sistema detecta si el código ya existe en la base de datos.

## 7. Estructura de Archivos Clave

*   `manage.py`: Script de gestión de Django.
*   `proyecto/`: Configuración global (`settings.py`, `urls.py`).
*   `clientes/`: Aplicación principal.
    *   `views.py`: Lógica de negocio, conexión a Oracle y consultas SQL directas.
*   `templates/clientes/`: Archivos HTML (`registro_cliente.html`).
*   `static/`: Archivos estáticos.
    *   `css/styles.css`: Estilos personalizados.
    *   `js/cliente.js`: Lógica del frontend (AJAX).
*   `*.sql`: Scripts de definición de datos (DDL) y manipulación (DML).
