#  Instructivo: Carga de Base de Datos Oracle

Este documento explica cmo cargar correctamente la base de datos Oracle para el proyecto Gabinete de Abogados.

##  Requisitos Previos

- Oracle XE 11g instalado en `C:\oraclexe\`
- Servicio Oracle ejecutndose
- Python 3.10+ con `oracledb` instalado
- Acceso como usuario `system` (para crear el usuario BD85)

##  Mtodo 1: Carga Automtica con Python (Recomendado)

### Paso 1: Verificar entorno virtual

```powershell
# Activar entorno virtual
.\.venv\Scripts\Activate.ps1

# Verificar que oracledb est instalado
pip list | findstr oracledb
```

### Paso 2: Ejecutar script de carga

```powershell
.\.venv\Scripts\python.exe recargar_base_datos.py
```

### Paso 3: Responder prompt

El script preguntar:
```
Deseas eliminar las tablas existentes? (s/n):
```

- **`s`** - Elimina y recrea todas las tablas (recomendado para instalacin limpia)
- **`n`** - Solo intenta crear las tablas si no existen

### Paso 4: Verificar resultado

El script mostrar:
```
============================================================
VERIFICACIN FINAL
============================================================
 Total de tablas: 17
 Total de clientes: 8
 Total de tipos de documento: 3

 Base de datos cargada exitosamente!
```

##  Mtodo 2: Carga Manual con SQL*Plus

### Paso 1: Abrir SQL*Plus como SYSTEM

```powershell
sqlplus system/tu_password@localhost:1521/XE
```

### Paso 2: Crear usuario BD85

```sql
-- Crear usuario
CREATE USER BD85 IDENTIFIED BY bd85;

-- Asignar permisos
GRANT CONNECT, RESOURCE, DBA TO BD85;

-- Confirmar cambios
COMMIT;

-- Desconectar
EXIT;
```

### Paso 3: Conectar como BD85

```powershell
sqlplus BD85/bd85@localhost:1521/XE
```

### Paso 4: Ejecutar script de tablas

```sql
-- Ejecutar desde SQL*Plus
@C:\Users\DELLPHOTO\Documents\Universidad Distrital\S9 _ 2025-III\26140 - BASES DE DATOS\Modulo Interfaz\01_crear_tablas.sql
```

**Resultado esperado:**
```
Table created. (17 veces)
```

### Paso 5: Ejecutar script de datos

```sql
-- Ejecutar desde SQL*Plus
@C:\Users\DELLPHOTO\Documents\Universidad Distrital\S9 _ 2025-III\26140 - BASES DE DATOS\Modulo Interfaz\02_inserciones_datos.sql
```

**Resultado esperado:**
```
1 row created. (mltiples veces)
Commit complete.
```

### Paso 6: Verificar carga

```sql
-- Contar tablas
SELECT COUNT(*) FROM user_tables;
-- Resultado esperado: 17

-- Ver clientes
SELECT codCliente, nomCliente, apellCliente FROM CLIENTE ORDER BY codCliente;
-- Resultado esperado: 8 registros

-- Ver tipos de documento
SELECT * FROM TIPODOCUMENTO;
-- Resultado esperado: 3 registros (CC, CE, PA)
```

##  Mtodo 3: Carga Manual con SQL Developer

### Paso 1: Abrir SQL Developer

1. Iniciar Oracle SQL Developer
2. Crear nueva conexin:
   - **Name:** BD85
   - **Username:** BD85
   - **Password:** bd85
   - **Hostname:** localhost
   - **Port:** 1521
   - **SID:** XE
3. Click en **Test** y luego **Connect**

### Paso 2: Ejecutar script de tablas

1. Menu: **File  Open**
2. Seleccionar `01_crear_tablas.sql`
3. Click en botn **Run Script** (F5)
4. Verificar en el panel inferior que no haya errores

### Paso 3: Ejecutar script de datos

1. Menu: **File  Open**
2. Seleccionar `02_inserciones_datos.sql`
3. Click en botn **Run Script** (F5)
4. Verificar mensajes de confirmacin

### Paso 4: Verificar tablas

1. En el panel izquierdo, expandir **Tables**
2. Deberas ver 17 tablas:
   - TIPODOCUMENTO
   - TIPOCONTACTO
   - TIPOLUGAR
   - FORMAPAGO
   - FRANQUICIA
   - ESPECIALIZACION
   - ETAPAPROCESAL
   - INSTANCIA
   - IMPUGNACION
   - CLIENTE
   - CONTACTO
   - LUGAR
   - ABOGADO
   - ESPECIA_ETAPA
   - CASO
   - SUCESO
   - DOCUMENTO
   - RESULTADO
   - EXPEDIENTE
   - PAGO

##  Verificacin Rpida desde PowerShell

### Verificar conexin y datos

```powershell
.\.venv\Scripts\python.exe -c "
import oracledb
oracledb.init_oracle_client(lib_dir=r'C:\oraclexe\app\oracle\product\11.2.0\server\bin')
conn = oracledb.connect(user='BD85', password='bd85', dsn='localhost:1521/XE')
cursor = conn.cursor()

# Contar tablas
cursor.execute('SELECT COUNT(*) FROM user_tables')
print(f'Tablas: {cursor.fetchone()[0]}')

# Listar clientes
cursor.execute('SELECT codCliente, nomCliente, apellCliente FROM CLIENTE ORDER BY codCliente')
print('\nCLIENTES:')
for row in cursor.fetchall():
    print(f'  {row[0]} - {row[1]} {row[2]}')

# Tipos de documento
cursor.execute('SELECT idTipoDoc, descTipoDoc FROM TIPODOCUMENTO')
print('\nTIPOS DOCUMENTO:')
for row in cursor.fetchall():
    print(f'  {row[0]} - {row[1]}')

conn.close()
"
```

**Resultado esperado:**
```
Tablas: 17

CLIENTES:
  C0001 - Juan Perez Garcia
  C0002 - Maria Lopez Rodriguez
  C0003 - Carlos Martinez Silva
  C0004 - Sandra Hernandez Torres
  C0005 - Roberto Diaz Ruiz
  C0006 - David Posso
  C0007 - Hanet Ballesteros
  C0008 - Nelson Posso

TIPOS DOCUMENTO:
  CC - Cdula de Ciudadana
  CE - Cdula de Extranjera
  PA - Pasaporte
```

##  Recargar Base de Datos (Limpiar y Volver a Crear)

Si necesitas empezar desde cero:

### Opcin A: Con script Python

```powershell
.\.venv\Scripts\python.exe recargar_base_datos.py
# Responder 's' cuando pregunte si desea eliminar tablas
```

### Opcin B: Con SQL*Plus

```sql
-- Conectar como BD85
sqlplus BD85/bd85@localhost:1521/XE

-- Eliminar tablas en orden inverso (respetando foreign keys)
DROP TABLE PAGO CASCADE CONSTRAINTS;
DROP TABLE EXPEDIENTE CASCADE CONSTRAINTS;
DROP TABLE RESULTADO CASCADE CONSTRAINTS;
DROP TABLE DOCUMENTO CASCADE CONSTRAINTS;
DROP TABLE SUCESO CASCADE CONSTRAINTS;
DROP TABLE CASO CASCADE CONSTRAINTS;
DROP TABLE ESPECIA_ETAPA CASCADE CONSTRAINTS;
DROP TABLE ABOGADO CASCADE CONSTRAINTS;
DROP TABLE LUGAR CASCADE CONSTRAINTS;
DROP TABLE CONTACTO CASCADE CONSTRAINTS;
DROP TABLE CLIENTE CASCADE CONSTRAINTS;
DROP TABLE IMPUGNACION CASCADE CONSTRAINTS;
DROP TABLE INSTANCIA CASCADE CONSTRAINTS;
DROP TABLE ETAPAPROCESAL CASCADE CONSTRAINTS;
DROP TABLE ESPECIALIZACION CASCADE CONSTRAINTS;
DROP TABLE FRANQUICIA CASCADE CONSTRAINTS;
DROP TABLE FORMAPAGO CASCADE CONSTRAINTS;
DROP TABLE TIPOLUGAR CASCADE CONSTRAINTS;
DROP TABLE TIPOCONTACTO CASCADE CONSTRAINTS;
DROP TABLE TIPODOCUMENTO CASCADE CONSTRAINTS;

-- Volver a ejecutar scripts
@01_crear_tablas.sql
@02_inserciones_datos.sql
```

##  Solucin de Problemas

### Error: "ORA-01017: invalid username/password"

**Causa:** Usuario BD85 no existe o contrasea incorrecta

**Solucin:**
```sql
-- Conectar como SYSTEM
sqlplus system/password@localhost:1521/XE

-- Verificar si existe el usuario
SELECT username FROM all_users WHERE username = 'BD85';

-- Si no existe, crearlo
CREATE USER BD85 IDENTIFIED BY bd85;
GRANT CONNECT, RESOURCE, DBA TO BD85;
```

### Error: "ORA-00955: name is already used by an existing object"

**Causa:** Las tablas ya existen

**Solucin:** Ejecutar `DROP TABLE` antes de crear (ver seccin "Recargar Base de Datos")

### Error: "ORA-02291: integrity constraint violated - parent key not found"

**Causa:** Intentas insertar datos sin respetar el orden de las foreign keys

**Solucin:** Ejecutar `02_inserciones_datos.sql` completo en orden

### Error: "DPI-1047: Cannot locate a 64-bit Oracle Client library"

**Causa:** Ruta incorrecta al Oracle Client en Python

**Solucin:** Verificar en `clientes/views.py`:
```python
ORACLE_CLIENT_PATH = r"C:\oraclexe\app\oracle\product\11.2.0\server\bin"
```

### Error: "ORA-12514: TNS:listener does not currently know of service"

**Causa:** Servicio Oracle no est ejecutndose

**Solucin:**
```powershell
# Verificar listener
lsnrctl status

# Si no est corriendo, iniciarlo
lsnrctl start
```

##  Estructura de Datos Cargados

### Tablas de Catlogo (9)
- **TIPODOCUMENTO** - 3 registros (CC, CE, PA)
- **TIPOCONTACTO** - 3 registros (TEL, EML, DOM)
- **TIPOLUGAR** - 3 registros (JZD1, TRB1, CSJ1)
- **FORMAPAGO** - 3 registros (EFE, TRF, TJT)
- **FRANQUICIA** - 3 registros (VIS, MAC, AMX)
- **ESPECIALIZACION** - 5 registros
- **ETAPAPROCESAL** - 10 registros
- **INSTANCIA** - 5 registros (1-5)
- **IMPUGNACION** - 5 registros

### Tablas Principales (8)
- **CLIENTE** - 8 registros (C0001 a C0008)
- **CONTACTO** - Datos de contacto de clientes
- **LUGAR** - Juzgados y tribunales
- **ABOGADO** - Abogados del gabinete
- **ESPECIA_ETAPA** - Relacin especializacin-etapa
- **CASO** - Casos jurdicos
- **SUCESO, DOCUMENTO, RESULTADO, EXPEDIENTE, PAGO** - Informacin de casos

### Total
- **17 tablas**
- **8 clientes de prueba**
- **3 tipos de documento**

##  Cdigos de Cliente para Pruebas

Usa estos cdigos en la aplicacin web:

| Cdigo | Nombre Completo | Documento |
|--------|-----------------|-----------|
| `C0001` | Juan Perez Garcia | 1234567890 |
| `C0002` | Maria Lopez Rodriguez | 9876543210 |
| `C0003` | Carlos Martinez Silva | 5555555555 |
| `C0004` | Sandra Hernandez Torres | 4444444444 |
| `C0005` | Roberto Diaz Ruiz | 3333333333 |
| `C0006` | David Posso | 2222222222 |
| `C0007` | Hanet Ballesteros | 1111111111 |
| `C0008` | Nelson Posso | 8888888888 |

---

**Nota:** Si usas el script `recargar_base_datos.py`, todo este proceso se automatiza y verifica correctamente.
