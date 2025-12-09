# Gua de Instalacin y Funcionamiento - Gabinete de Abogados

Este proyecto es una interfaz web desarrollada en **Python/Django** que se conecta a una base de datos **Oracle 11g XE** para la gestin de clientes de un gabinete de abogados.

## 1. Requisitos del Sistema

*   **Sistema Operativo:** Windows (Recomendado para Oracle XE 11g)
*   **Python:** Versin 3.10 o superior (Probado con 3.13.5)
*   **Base de Datos:** Oracle Database 11g Express Edition (XE)
*   **Navegador Web:** Chrome, Firefox, Edge

## 2. Configuracin de Base de Datos Oracle

### Paso 1: Instalacin de Oracle XE 11g
Asegrese de tener instalado Oracle Database 11g Express Edition.
*   Directorio de instalacin tpico: `C:\oraclexe\`

### Paso 2: Creacin del Usuario
Abra `SQL*Plus` o `SQL Developer` con permisos de administrador (`system`) y ejecute:

```sql
-- Crear usuario
CREATE USER BD85 IDENTIFIED BY bd85;

-- Asignar permisos
GRANT CONNECT, RESOURCE, DBA TO BD85;
```

### Paso 3: Creacin de Tablas y Datos
Ejecute los scripts SQL proporcionados en el orden siguiente usando el usuario `BD85`:

1.  `01_crear_tablas.sql`: Crea la estructura de las 17 tablas.
2.  `02_inserciones_datos.sql`: Puebla las tablas con datos iniciales (catalogos y clientes de prueba).

## 3. Instalacin del Proyecto Python

### Paso 1: Ubicacin
Sitese en la carpeta raz del proyecto:
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
Instale las libreras necesarias. El proyecto requiere `django` y `oracledb`.

```powershell
pip install django oracledb
```

*Nota: El proyecto usa `oracledb` en modo "Thick" para compatibilidad con Oracle 11g.*

## 4. Configuracin del Proyecto

### Verificacin de Credenciales
El archivo `clientes/views.py` contiene la configuracin de conexin. Asegrese de que coincida con su BD local:

```python
# clientes/views.py

ORACLE_USER = 'BD85'
ORACLE_PASSWORD = 'bd85'
ORACLE_HOST = 'localhost'
ORACLE_PORT = 1521
ORACLE_SERVICE = 'XE'

# Ruta crtica para Oracle 11g
ORACLE_CLIENT_PATH = r"C:\oraclexe\app\oracle\product\11.2.0\server\bin"
```

**IMPORTANTE:** La variable `ORACLE_CLIENT_PATH` debe apuntar exactamente a la carpeta `bin` de su instalacin de Oracle. Si su instalacin es diferente, modifique esta lnea en `clientes/views.py`.

## 5. Ejecucin de la Aplicacin

1.  Asegrese de que el entorno virtual est activado (ver `(.venv)` al inicio de la lnea de comandos).
2.  Ejecute el servidor de desarrollo de Django:

```powershell
python manage.py runserver
```

3.  Si todo es correcto, ver un mensaje indicando que el servidor corre en `http://127.0.0.1:8000/`.
4.  Abra su navegador y vaya a esa direccin.

## 6. Uso de la Aplicacin

*   **Registro:** Complete el formulario con los datos del cliente (Cdigo, Nombre, Apellido, Documento, Tipo).
*   **Bsqueda:** Ingrese un cdigo existente (ej. `CL001`) y presione el botn de la **Lupa** para cargar los datos automticamente.
*   **Guardar/Actualizar:** El botn **Guardar** sirve tanto para crear nuevos registros como para actualizar existentes. El sistema detecta si el cdigo ya existe en la base de datos.

## 7. Estructura de Archivos Clave

*   `manage.py`: Script de gestin de Django.
*   `proyecto/`: Configuracin global (`settings.py`, `urls.py`).
*   `clientes/`: Aplicacin principal.
    *   `views.py`: Lgica de negocio, conexin a Oracle y consultas SQL directas.
*   `templates/clientes/`: Archivos HTML (`registro_cliente.html`).
*   `static/`: Archivos estticos.
    *   `css/styles.css`: Estilos personalizados.
    *   `js/cliente.js`: Lgica del frontend (AJAX).
*   `*.sql`: Scripts de definicin de datos (DDL) y manipulacin (DML).
