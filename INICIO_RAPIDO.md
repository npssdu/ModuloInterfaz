#  Inicio Rpido - Gabinete de Abogados

Sistema web de gestin de clientes para gabinete de abogados desarrollado con Django + Oracle.

##  Requisitos Previos

- Python 3.10+
- Oracle XE 11g instalado en `C:\oraclexe\`
- Usuario Oracle: `BD85` / Contrasea: `bd85`

##  Instalacin en 5 Pasos

### 1. Clonar o Descargar el Proyecto

```powershell
cd "C:\Users\DELLPHOTO\Documents\Universidad Distrital\S9 _ 2025-III\26140 - BASES DE DATOS\Modulo Interfaz"
```

### 2. Crear y Activar Entorno Virtual

```powershell
python -m venv .venv
.\.venv\Scripts\Activate
```

### 3. Instalar Dependencias

```powershell
pip install django oracledb
```

### 4. Configurar Base de Datos Oracle

#### Opcin A: Script Automtico (Python)
```powershell
python ejecutar_sql.py
```

#### Opcin B: Manual (SQL*Plus)
```sql
-- Conectar como system
sqlplus system/password@localhost:1521/XE

-- Crear usuario
CREATE USER BD85 IDENTIFIED BY bd85;
GRANT CONNECT, RESOURCE, DBA TO BD85;

-- Conectar como BD85 y ejecutar:
@01_crear_tablas.sql
@02_inserciones_datos.sql
```

### 5. Iniciar Servidor

```powershell
python manage.py runserver
```

Abrir navegador en: **http://127.0.0.1:8000/**

##  Uso Bsico

### Registrar Nuevo Cliente
1. Completar todos los campos del formulario
2. Click en botn **Guardar** (azul claro)
3. Mensaje de confirmacin aparecer

### Buscar Cliente Existente
1. Ingresar cdigo (ej: `CL001`)
2. Click en botn **** (naranja)
3. Datos se cargan automticamente

### Actualizar Cliente
1. Buscar cliente con la lupa
2. Modificar campos necesarios
3. Click en **Guardar**

##  Datos de Prueba

El sistema incluye 7 clientes pre-cargados:

| Cdigo | Nombre | Apellido | Documento |
|--------|--------|----------|-----------|
| CL001 | Juan | Perez | 1234567890 |
| CL002 | Maria | Lopez | 9876543210 |
| CL003 | Carlos | Garcia | 5555555555 |
| CL004 | Ana | Martinez | 4444444444 |
| CL005 | Luis | Rodriguez | 3333333333 |
| CL006 | Sofia | Hernandez | 2222222222 |
| CL007 | Pedro | Gonzalez | 1111111111 |

**Tipos de Documento:**
- `CC` - Cedula de Ciudadania
- `CE` - Cedula de Extranjeria
- `PA` - Pasaporte

##  Verificacin Rpida

### Verificar Conexin Oracle
```powershell
python -c "import oracledb; oracledb.init_oracle_client(lib_dir=r'C:\oraclexe\app\oracle\product\11.2.0\server\bin'); conn = oracledb.connect(user='BD85', password='bd85', dsn='localhost:1521/XE'); print(' Conexin exitosa'); conn.close()"
```

### Verificar Datos en BD
```powershell
python -c "import oracledb; oracledb.init_oracle_client(lib_dir=r'C:\oraclexe\app\oracle\product\11.2.0\server\bin'); conn = oracledb.connect(user='BD85', password='bd85', dsn='localhost:1521/XE'); cursor = conn.cursor(); cursor.execute('SELECT COUNT(*) FROM CLIENTE'); print(f'Clientes: {cursor.fetchone()[0]}'); cursor.execute('SELECT COUNT(*) FROM user_tables'); print(f'Tablas: {cursor.fetchone()[0]}'); conn.close()"
```

##  Personalizacin

### Colores del Sistema
- Ttulos: `#0046FF` (Azul oscuro)
- Botn Guardar: `#73C8D2` (Azul claro)
- Botn Buscar: `#FF9013` (Naranja)
- Fondo: `#F5F1DC` (Beige)

Modificar en: `static/css/styles.css`

### Agregar Nuevos Campos
1. Modificar tabla en Oracle: `ALTER TABLE CLIENTE ADD nuevo_campo VARCHAR2(50);`
2. Actualizar formulario: `templates/clientes/registro_cliente.html`
3. Actualizar vista: `clientes/views.py` (funciones `guardar_cliente` y `obtener_cliente`)
4. Actualizar JavaScript: `static/js/cliente.js` (funciones `buscarCliente` y `guardarCliente`)

##  Solucin de Problemas

### Error: "DPI-1047: Cannot locate a 64-bit Oracle Client library"
**Solucin:** Verificar ruta en `clientes/views.py`:
```python
ORACLE_CLIENT_PATH = r"C:\oraclexe\app\oracle\product\11.2.0\server\bin"
```

### Error: "ORA-12514: TNS:listener does not currently know of service"
**Solucin:** Verificar que Oracle est ejecutndose:
```powershell
lsnrctl status
```

### Error: "ORA-01017: invalid username/password"
**Solucin:** Recrear usuario BD85 (ver paso 4)

### Puerto 8000 en uso
**Solucin:** Usar puerto alternativo:
```powershell
python manage.py runserver 8080
```

##  Estructura del Proyecto

```
Modulo Interfaz/
 manage.py                    # Comando principal Django
 proyecto/                    # Configuracin global
    settings.py             # Configuracin Django
    urls.py                 # Rutas principales
 clientes/                    # Aplicacin de clientes
    views.py                # Lgica de negocio + SQL
 templates/clientes/          # Plantillas HTML
    registro_cliente.html   # Formulario principal
 static/                      # Archivos estticos
    css/styles.css          # Estilos personalizados
    js/cliente.js           # JavaScript/AJAX
 01_crear_tablas.sql         # DDL - Estructura BD
 02_inserciones_datos.sql    # DML - Datos iniciales
 GUIA_INSTALACION.md         # Gua completa
```

##  Archivos Importantes

- **Conexin Oracle:** `clientes/views.py` (lneas 16-27)
- **Consultas SQL:** `clientes/views.py` (funciones `obtener_cliente`, `guardar_cliente`)
- **AJAX Requests:** `static/js/cliente.js`
- **Estilos:** `static/css/styles.css`

##  Documentacin Adicional

- **Gua Completa:** Ver `GUIA_INSTALACION.md`
- **Sustentacin:** Ver `GUIA_SUSTENTACION.txt`
- **Modelo Lgico:** Ver `SCRIPT_MODELO_LOGICO.txt`
- **Power Designer:** Ver `SCRIPT_POWER_DESIGNER.sql`

##  Proyecto Acadmico

**Universidad Distrital Francisco Jos de Caldas**  
**Asignatura:** 26140 - Bases de Datos  
**Semestre:** 2025-III  
**Docente:** Sonia Ordoez Salinas  
**Tema:** Sistema de Gestin de Gabinete de Abogados

---

**Necesitas ms ayuda?** Revisa `GUIA_INSTALACION.md` para detalles tcnicos completos.
