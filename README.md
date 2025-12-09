#  PROYECTO BD: SISTEMA DE GESTIN GABINETE DE ABOGADOS

## Perodo 2025-3 | Profesor: Sonia Ordoez Salinas

---

##  DESCRIPCIN GENERAL

Sistema completo de gestin de base de datos para un gabinete de abogados que incluye:

 **Base de Datos**: 17 tablas en Oracle con relaciones complejas
 **Backend**: Python + Django con conexin SQL pura a Oracle
 **Frontend**: Interfaz web responsive para registro de clientes
 **Datos**: 5 clientes, 5 abogados y 5 casos hipotticos precargados
 **Funcionalidades**: Bsqueda con lupa, registro, actualizacin de clientes

---



##  INICIO RPIDO

### 1 Crear Base de Datos en Oracle

```sql
sqlplus usuario/contrasea@orcl
SQL> @01_crear_tablas.sql;
SQL> @02_inserciones_datos.sql;
COMMIT;
```

### 2 Configurar Django

```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install django==4.2 cx-Oracle==8.3.0
django-admin startproject proyecto .
python manage.py startapp clientes
```

### 3 Copiar Archivos

- `03_django_settings.py`  `proyecto/settings.py`
- `04_django_views.py`  `clientes/views.py`
- `05_django_urls.py`  `proyecto/urls.py`
- `06_html_template.html`  `templates/clientes/registro_cliente.html`

### 4 Ejecutar Aplicacin

```bash
python manage.py runserver
# Acceder a: http://127.0.0.1:8000/
```

---

##  ESTRUCTURA DE TABLAS

### Tablas Principales

| Tabla | Descripcin | Registros |
|-------|-------------|-----------|
| CLIENTE | Datos de clientes | 5 |
| ABOGADO | Informacin de abogados | 5 |
| CASO | Casos asignados | 5 |
| TIPODOCUMENTO | Catlogo de documentos | 3 |
| LUGAR | Juzgados y tribunales | 6 |
| ETAPAPROCESAL | Estados del proceso | 8 |
| ESPECIALIZACION | Especialidades legal | 5 |

### Relaciones Claves

```
CLIENTE (1)  (N) CASO
ABOGADO (1)  (N) CASO
LUGAR (1)  (N) CASO
TIPODOCUMENTO (1)  (N) CLIENTE
```

---

##  FUNCIONALIDADES WEB

###  Bsqueda de Cliente
- Ingrese cdigo de cliente (ej: C0001)
- Presione botn  Buscar
- Se cargan automticamente los datos

###  Registro/Actualizacin
- Completa el formulario
- Todos los campos obligatorios (*)
- Presiona  Guardar
- Sistema identifica INSERT vs UPDATE

###  Validaciones
-  Campos obligatorios
-  Mximos caracteres por campo
-  Tipo de dato correcto
-  Prevencin de SQL Injection

---

##  CARACTERSTICAS TCNICAS

### Backend Python/Django

**Conexin directa a Oracle** (sin ORM):
```python
import cx_Oracle
dsn = cx_Oracle.makedsn('localhost', 1521, service_name='orcl')
conexion = cx_Oracle.connect(user='usuario', password='pwd', dsn=dsn)
```

**Una consulta por operacin** (segn requisito):
- `obtener_tipos_documento()` = 1 SELECT
- `obtener_cliente()` = 1 SELECT con JOIN
- `buscar_cliente_ajax()` = 1 SELECT
- `guardar_cliente()` = 1 SELECT + 1 INSERT/UPDATE

### Frontend HTML/CSS/JavaScript

**Caractersticas**:
-  Interfaz responsive (mobile-friendly)
-  AJAX para bsqueda sin recargar
-  Validacin client-side rpida
-  Indicadores de carga (spinner)
-  Mensajes dinmicos (xito/error)
-  Combo desplegable de tipos documento

---

##  DATOS DE PRUEBA

### Clientes
```
C0001 | Juan Prez Garca | CC: 1234567890
C0002 | Mara Lpez Rodrguez | CC: 9876543210
C0003 | Carlos Martnez Silva | CE: 5555555555
C0004 | Sandra Hernndez Torres | CC: 1111111111
C0005 | Roberto Daz Ruiz | PA: 9999999999
```

### Abogados
```
1000000001 | Miguel Fernndez | Derecho Laboral
1000000002 | Andrs Snchez | Derecho Penal
1000000003 | Paola Gutirrez | Derecho Civil
1000000004 | Felipe Torres | Derecho Comercial
1000000005 | Catalina Vargas | Derecho Administrativo
```

### Casos Hipotticos
```
10001 | Cliente C0001 | Abogado 1 | Derecho Laboral
10002 | Cliente C0002 | Abogado 2 | Derecho Penal
10003 | Cliente C0003 | Abogado 3 | Derecho Civil (CERRADO)
10004 | Cliente C0004 | Abogado 4 | Derecho Comercial
10005 | Cliente C0005 | Abogado 5 | Derecho Administrativo
```

---

##  VALIDACIONES

### Base de Datos
-  Claves primarias nicas
-  Claves forneas referenciadas
-  Campos NOT NULL obligatorios
-  CHECK constraints en instancias

### Aplicacin Web
-  Validacin de campos obligatorios
-  Longitud mxima de caracteres
-  Prevencin SQL Injection (bind variables)
-  Transacciones con rollback en error
-  CSRF token en formularios

---

##  CONSULTAS IMPORTANTES

### Buscar Cliente
```sql
SELECT c.*, t.descTipoDoc FROM CLIENTE c
JOIN TIPODOCUMENTO t ON c.idTipoDoc = t.idTipoDoc
WHERE c.codCliente = 'C0001';
```

### Obtener Tipos Documento
```sql
SELECT idTipoDoc, descTipoDoc FROM TIPODOCUMENTO ORDER BY idTipoDoc;
```

### Casos de un Cliente
```sql
SELECT ca.noCaso, ca.fechaInicio, ca.valor, ab.nombre
FROM CASO ca
JOIN ABOGADO ab ON ca.cedula = ab.cedula
WHERE ca.codCliente = 'C0001';
```

*Ver archivo `08_consultas_sql.sql` para ms ejemplos*

---

##  REQUISITOS

### Software Instalado
- Python 3.8+
- Django 4.2
- Oracle Database 11g+
- cx_Oracle 8.3.0+

### Instalacin Dependencias
```bash
pip install django==4.2
pip install cx-Oracle==8.3.0
```

---

##  RESTRICCIONES DEL PROYECTO

 **No permitido:**
- Uso de Django ORM (models.py)
- Frameworks que enmascare comandos BD
- Asistentes de IA para desarrollo
- Conexiones remotas en sustentacin

 **Requerido:**
- SQL puro con bind variables
- Una consulta por operacin
- Power Designer para diseo
- Consola de comandos en sustentacin

---

##  TROUBLESHOOTING

| Error | Solucin |
|-------|----------|
| Connection refused | Verificar Oracle corriendo: `lsnrctl status` |
| Oracle Client not loaded | Instalar Oracle Client o configurar tnsnames.ora |
| Template not found | Crear carpeta `templates/clientes/` correctamente |
| ORA-28001 password expired | Cambiar contrasea en SQL*Plus |

---

