"""
views.py - Vistas para la gestión de Clientes
Interfaz web de registro y búsqueda de clientes
"""

from django.shortcuts import render, redirect
from django.http import JsonResponse
from django.views.decorators.http import require_http_methods
import cx_Oracle
import json

# Configuración de conexión directa a Oracle
def conectar_bd():
    """
    Establece conexión directa con la base de datos Oracle
    Retorna: conexión a la BD
    """
    try:
        dsn = cx_Oracle.makedsn('localhost', 1521, service_name='orcl')
        conexion = cx_Oracle.connect(user='tu_usuario', password='tu_contraseña', dsn=dsn)
        return conexion
    except Exception as e:
        print(f"Error de conexión: {e}")
        return None

def obtener_tipos_documento():
    """
    Obtiene lista de tipos de documento de la BD con una sola consulta
    Retorna: lista de diccionarios con id y descripción
    """
    conexion = conectar_bd()
    if not conexion:
        return []
    
    try:
        cursor = conexion.cursor()
        # Única consulta para traer los tipos de documento
        cursor.execute("SELECT idTipoDoc, descTipoDoc FROM TIPODOCUMENTO ORDER BY idTipoDoc")
        tipos = [{'id': row[0], 'desc': row[1]} for row in cursor.fetchall()]
        cursor.close()
        return tipos
    except Exception as e:
        print(f"Error al obtener tipos: {e}")
        return []
    finally:
        conexion.close()

def obtener_cliente(cod_cliente):
    """
    Obtiene datos del cliente mediante una única consulta
    Retorna: diccionario con datos del cliente o None
    """
    conexion = conectar_bd()
    if not conexion:
        return None
    
    try:
        cursor = conexion.cursor()
        # Una sola consulta para obtener todos los datos del cliente
        query = """
        SELECT c.codCliente, c.nomCliente, c.apellCliente, c.nDocumento, 
               c.idTipoDoc, t.descTipoDoc
        FROM CLIENTE c
        JOIN TIPODOCUMENTO t ON c.idTipoDoc = t.idTipoDoc
        WHERE c.codCliente = :cod
        """
        cursor.execute(query, {'cod': cod_cliente})
        resultado = cursor.fetchone()
        cursor.close()
        
        if resultado:
            return {
                'codCliente': resultado[0],
                'nomCliente': resultado[1],
                'apellCliente': resultado[2],
                'nDocumento': resultado[3],
                'idTipoDoc': resultado[4],
                'descTipoDoc': resultado[5]
            }
        return None
    except Exception as e:
        print(f"Error al obtener cliente: {e}")
        return None
    finally:
        conexion.close()

def registrar_cliente(request):
    """
    Vista principal para registro y búsqueda de clientes
    Métodos soportados: GET (mostrar formulario), POST (procesar datos)
    """
    if request.method == 'GET':
        tipos_documento = obtener_tipos_documento()
        context = {
            'tipos_documento': tipos_documento,
            'titulo': 'Registro de Clientes - Gabinete de Abogados'
        }
        return render(request, 'clientes/registro_cliente.html', context)
    
    elif request.method == 'POST':
        # Procesar guardado de cliente
        return guardar_cliente(request)

def buscar_cliente_ajax(request):
    """
    Endpoint AJAX para búsqueda de cliente mediante lupa
    Retorna: JSON con datos del cliente o error
    """
    if request.method == 'POST':
        cod_cliente = request.POST.get('codCliente', '').strip()
        
        if not cod_cliente:
            return JsonResponse({
                'exito': False,
                'mensaje': 'Por favor ingrese un código de cliente'
            })
        
        cliente = obtener_cliente(cod_cliente)
        
        if cliente:
            return JsonResponse({
                'exito': True,
                'datos': cliente
            })
        else:
            return JsonResponse({
                'exito': False,
                'mensaje': f'Cliente con código {cod_cliente} no encontrado'
            })
    
    return JsonResponse({'exito': False, 'mensaje': 'Método no permitido'})

def guardar_cliente(request):
    """
    Procesa el guardado de datos del cliente en la BD
    Realiza validaciones y actualiza o inserta según corresponda
    """
    codCliente = request.POST.get('codCliente', '').strip()
    nomCliente = request.POST.get('nomCliente', '').strip()
    apellCliente = request.POST.get('apellCliente', '').strip()
    nDocumento = request.POST.get('nDocumento', '').strip()
    idTipoDoc = request.POST.get('idTipoDoc', '').strip()
    
    # Validaciones
    if not all([codCliente, nomCliente, apellCliente, nDocumento, idTipoDoc]):
        return JsonResponse({
            'exito': False,
            'mensaje': 'Todos los campos son obligatorios'
        })
    
    if len(codCliente) > 5:
        return JsonResponse({
            'exito': False,
            'mensaje': 'Código de cliente no puede exceder 5 caracteres'
        })
    
    if len(nomCliente) > 30 or len(apellCliente) > 30:
        return JsonResponse({
            'exito': False,
            'mensaje': 'Nombre y apellido no pueden exceder 30 caracteres'
        })
    
    if len(nDocumento) > 15:
        return JsonResponse({
            'exito': False,
            'mensaje': 'Número de documento no puede exceder 15 caracteres'
        })
    
    conexion = conectar_bd()
    if not conexion:
        return JsonResponse({
            'exito': False,
            'mensaje': 'Error de conexión a la base de datos'
        })
    
    try:
        cursor = conexion.cursor()
        
        # Verificar si el cliente existe
        cursor.execute("SELECT COUNT(*) FROM CLIENTE WHERE codCliente = :cod", 
                      {'cod': codCliente})
        existe = cursor.fetchone()[0] > 0
        
        if existe:
            # Actualizar cliente existente
            cursor.execute("""
                UPDATE CLIENTE 
                SET nomCliente = :nom, apellCliente = :apel, 
                    nDocumento = :ndoc, idTipoDoc = :tipo
                WHERE codCliente = :cod
            """, {
                'nom': nomCliente,
                'apel': apellCliente,
                'ndoc': nDocumento,
                'tipo': idTipoDoc,
                'cod': codCliente
            })
            mensaje = f'Cliente {codCliente} actualizado correctamente'
        else:
            # Insertar nuevo cliente
            cursor.execute("""
                INSERT INTO CLIENTE (codCliente, nomCliente, apellCliente, nDocumento, idTipoDoc)
                VALUES (:cod, :nom, :apel, :ndoc, :tipo)
            """, {
                'cod': codCliente,
                'nom': nomCliente,
                'apel': apellCliente,
                'ndoc': nDocumento,
                'tipo': idTipoDoc
            })
            mensaje = f'Cliente {codCliente} registrado correctamente'
        
        conexion.commit()
        cursor.close()
        
        return JsonResponse({
            'exito': True,
            'mensaje': mensaje
        })
    
    except cx_Oracle.DatabaseError as e:
        conexion.rollback()
        error_msg = str(e)
        return JsonResponse({
            'exito': False,
            'mensaje': f'Error en la base de datos: {error_msg}'
        })
    except Exception as e:
        conexion.rollback()
        return JsonResponse({
            'exito': False,
            'mensaje': f'Error inesperado: {str(e)}'
        })
    finally:
        conexion.close()

# Ruta adicional para obtener tipos de documento en AJAX
def obtener_tipos_ajax(request):
    """
    Retorna tipos de documento en formato JSON
    """
    tipos = obtener_tipos_documento()
    return JsonResponse({'tipos': tipos})
