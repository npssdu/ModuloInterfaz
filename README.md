# 📋 PROYECTO BD: SISTEMA DE GESTIÓN GABINETE DE ABOGADOS

## Período 2025-3 | Profesor: Sonia Ordoñez Salinas

---

## 🎯 DESCRIPCIÓN GENERAL

Sistema completo de gestión de base de datos para un gabinete de abogados que incluye:

✅ **Base de Datos**: 17 tablas en Oracle con relaciones complejas
✅ **Backend**: Python + Django con conexión SQL pura a Oracle
✅ **Frontend**: Interfaz web responsive para registro de clientes
✅ **Datos**: 5 clientes, 5 abogados y 5 casos hipotéticos precargados
✅ **Funcionalidades**: Búsqueda con lupa, registro, actualización de clientes

---

## 📁 ARCHIVOS ENTREGADOS

```
ProyectoGabinete/
│
├── 01_crear_tablas.sql              ← Creación de 17 tablas Oracle
├── 02_inserciones_datos.sql         ← Datos de prueba (5 clientes, 5 abogados)
│
├── 03_django_settings.py            ← Configuración de Django
├── 04_django_views.py               ← Vistas y conexión a BD Oracle
├── 05_django_urls.py                ← Rutas URL de la aplicación
├── 06_html_template.html            ← Interfaz web HTML/CSS/JS
│
├── 07_guia_implementacion.txt       ← Paso a paso de instalación
├── 08_consultas_sql.sql             ← Ejemplos de consultas útiles
└── README.md                        ← Este archivo
```

---

## 🚀 INICIO RÁPIDO

### 1️⃣ Crear Base de Datos en Oracle

```sql
sqlplus usuario/contraseña@orcl
SQL> @01_crear_tablas.sql;
SQL> @02_inserciones_datos.sql;
COMMIT;
```

### 2️⃣ Configurar Django

```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install django==4.2 cx-Oracle==8.3.0
django-admin startproject proyecto .
python manage.py startapp clientes
```

### 3️⃣ Copiar Archivos

- `03_django_settings.py` → `proyecto/settings.py`
- `04_django_views.py` → `clientes/views.py`
- `05_django_urls.py` → `proyecto/urls.py`
- `06_html_template.html` → `templates/clientes/registro_cliente.html`

### 4️⃣ Ejecutar Aplicación

```bash
python manage.py runserver
# Acceder a: http://127.0.0.1:8000/
```

---

## 📊 ESTRUCTURA DE TABLAS

### Tablas Principales

| Tabla | Descripción | Registros |
|-------|-------------|-----------|
| CLIENTE | Datos de clientes | 5 |
| ABOGADO | Información de abogados | 5 |
| CASO | Casos asignados | 5 |
| TIPODOCUMENTO | Catálogo de documentos | 3 |
| LUGAR | Juzgados y tribunales | 6 |
| ETAPAPROCESAL | Estados del proceso | 8 |
| ESPECIALIZACION | Especialidades legal | 5 |

### Relaciones Claves

```
CLIENTE (1) ──────→ (N) CASO
ABOGADO (1) ──────→ (N) CASO
LUGAR (1) ────────→ (N) CASO
TIPODOCUMENTO (1) → (N) CLIENTE
```

---

## 💻 FUNCIONALIDADES WEB

### 🔍 Búsqueda de Cliente
- Ingrese código de cliente (ej: C0001)
- Presione botón 🔎 Buscar
- Se cargan automáticamente los datos

### 💾 Registro/Actualización
- Completa el formulario
- Todos los campos obligatorios (*)
- Presiona 💾 Guardar
- Sistema identifica INSERT vs UPDATE

### 📋 Validaciones
- ✓ Campos obligatorios
- ✓ Máximos caracteres por campo
- ✓ Tipo de dato correcto
- ✓ Prevención de SQL Injection

---

## 🔐 CARACTERÍSTICAS TÉCNICAS

### Backend Python/Django

**Conexión directa a Oracle** (sin ORM):
```python
import cx_Oracle
dsn = cx_Oracle.makedsn('localhost', 1521, service_name='orcl')
conexion = cx_Oracle.connect(user='usuario', password='pwd', dsn=dsn)
```

**Una consulta por operación** (según requisito):
- `obtener_tipos_documento()` = 1 SELECT
- `obtener_cliente()` = 1 SELECT con JOIN
- `buscar_cliente_ajax()` = 1 SELECT
- `guardar_cliente()` = 1 SELECT + 1 INSERT/UPDATE

### Frontend HTML/CSS/JavaScript

**Características**:
- ✓ Interfaz responsive (mobile-friendly)
- ✓ AJAX para búsqueda sin recargar
- ✓ Validación client-side rápida
- ✓ Indicadores de carga (spinner)
- ✓ Mensajes dinámicos (éxito/error)
- ✓ Combo desplegable de tipos documento

---

## 🧪 DATOS DE PRUEBA

### Clientes
```
C0001 | Juan Pérez García | CC: 1234567890
C0002 | María López Rodríguez | CC: 9876543210
C0003 | Carlos Martínez Silva | CE: 5555555555
C0004 | Sandra Hernández Torres | CC: 1111111111
C0005 | Roberto Díaz Ruiz | PA: 9999999999
```

### Abogados
```
1000000001 | Miguel Fernández | Derecho Laboral
1000000002 | Andrés Sánchez | Derecho Penal
1000000003 | Paola Gutiérrez | Derecho Civil
1000000004 | Felipe Torres | Derecho Comercial
1000000005 | Catalina Vargas | Derecho Administrativo
```

### Casos Hipotéticos
```
10001 | Cliente C0001 | Abogado 1 | Derecho Laboral
10002 | Cliente C0002 | Abogado 2 | Derecho Penal
10003 | Cliente C0003 | Abogado 3 | Derecho Civil (CERRADO)
10004 | Cliente C0004 | Abogado 4 | Derecho Comercial
10005 | Cliente C0005 | Abogado 5 | Derecho Administrativo
```

---

## ✅ VALIDACIONES

### Base de Datos
- ✓ Claves primarias únicas
- ✓ Claves foráneas referenciadas
- ✓ Campos NOT NULL obligatorios
- ✓ CHECK constraints en instancias

### Aplicación Web
- ✓ Validación de campos obligatorios
- ✓ Longitud máxima de caracteres
- ✓ Prevención SQL Injection (bind variables)
- ✓ Transacciones con rollback en error
- ✓ CSRF token en formularios

---

## 🔍 CONSULTAS IMPORTANTES

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

*Ver archivo `08_consultas_sql.sql` para más ejemplos*

---

## 🛠️ REQUISITOS

### Software Instalado
- Python 3.8+
- Django 4.2
- Oracle Database 11g+
- cx_Oracle 8.3.0+

### Instalación Dependencias
```bash
pip install django==4.2
pip install cx-Oracle==8.3.0
```

---

## ⚠️ RESTRICCIONES DEL PROYECTO

❌ **No permitido:**
- Uso de Django ORM (models.py)
- Frameworks que enmascare comandos BD
- Asistentes de IA para desarrollo
- Conexiones remotas en sustentación

✅ **Requerido:**
- SQL puro con bind variables
- Una consulta por operación
- Power Designer para diseño
- Consola de comandos en sustentación

---

## 🐛 TROUBLESHOOTING

| Error | Solución |
|-------|----------|
| Connection refused | Verificar Oracle corriendo: `lsnrctl status` |
| Oracle Client not loaded | Instalar Oracle Client o configurar tnsnames.ora |
| Template not found | Crear carpeta `templates/clientes/` correctamente |
| ORA-28001 password expired | Cambiar contraseña en SQL*Plus |

---

## 📝 PARA LA SUSTENTACIÓN

### Elementos a Entregar (ZIP)
✓ `01_crear_tablas.sql`
✓ `02_inserciones_datos.sql`
✓ `03_django_settings.py`
✓ `04_django_views.py`
✓ `05_django_urls.py`
✓ `06_html_template.html`
✓ Power Designer (archivo .pdm)
✓ PDF del modelo ER

### Demostración Esperada
1. Mostrar BD en SQL Developer con tablas y datos
2. Ejecutar queries de validación
3. Iniciar servidor Django
4. Usar interfaz web (búsqueda y registro)
5. Verificar datos guardados en BD

### Restricciones en Sustentación
- ⚠️ Base de datos LOCAL (no remota)
- ⚠️ Comandos de BD via consola
- ⚠️ Máximo 3 integrantes en grupo
- ⚠️ Sustentación individual
- ⚠️ Sin asistentes de IA

---

## 📞 CONTACTO Y SOPORTE

**Profesor**: Sonia Ordoñez Salinas
**Período**: 2025-3
**Universidad**: Universidad Distrital Francisco José de Caldas

*Para dudas, revisar guía de implementación (07_guia_implementacion.txt)*

---

## 📜 VERSIÓN

**Versión**: 1.0
**Última actualización**: 2025-11-29
**Estado**: ✅ Completo y listo para sustentación

---

**¡Éxito en la sustentación! 🎉**
