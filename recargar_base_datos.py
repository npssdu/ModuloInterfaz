"""
Script para recargar la base de datos desde cero
Ejecuta los archivos .sql en orden
"""

import oracledb

# Configuración
ORACLE_CLIENT = r"C:\oraclexe\app\oracle\product\11.2.0\server\bin"
USER = 'BD85'
PASSWORD = 'bd85'
DSN = 'localhost:1521/XE'

def ejecutar_sql_file(cursor, archivo):
    """Lee y ejecuta un archivo SQL línea por línea"""
    print(f"\n{'='*60}")
    print(f"Ejecutando: {archivo}")
    print('='*60)
    
    with open(archivo, 'r', encoding='utf-8') as f:
        contenido = f.read()
        
    # Dividir por punto y coma
    comandos = contenido.split(';')
    
    exitosos = 0
    errores = 0
    
    for comando in comandos:
        comando = comando.strip()
        
        # Ignorar comentarios y líneas vacías
        if not comando or comando.startswith('--') or comando == 'COMMIT':
            continue
            
        try:
            cursor.execute(comando)
            exitosos += 1
            print(f"✓ Comando ejecutado")
        except Exception as e:
            errores += 1
            print(f"✗ Error: {str(e)[:100]}")
    
    print(f"\nResumen: {exitosos} exitosos, {errores} errores")
    return exitosos, errores

def main():
    try:
        # Inicializar Oracle Client
        print("Inicializando Oracle Client...")
        oracledb.init_oracle_client(lib_dir=ORACLE_CLIENT)
        
        # Conectar
        print(f"Conectando a Oracle como {USER}...")
        conn = oracledb.connect(user=USER, password=PASSWORD, dsn=DSN)
        cursor = conn.cursor()
        print("✓ Conexión exitosa\n")
        
        # PASO 1: Eliminar tablas existentes (opcional)
        print("\n¿Deseas eliminar las tablas existentes? (s/n): ", end='')
        respuesta = input().strip().lower()
        
        if respuesta == 's':
            print("\nEliminando tablas existentes...")
            tablas = [
                'PAGO', 'EXPEDIENTE', 'RESULTADO', 'DOCUMENTO', 'SUCESO',
                'CASO', 'ESPECIA_ETAPA', 'ABOGADO', 'LUGAR', 'CONTACTO',
                'CLIENTE', 'IMPUGNACION', 'INSTANCIA', 'ETAPAPROCESAL',
                'ESPECIALIZACION', 'FRANQUICIA', 'FORMAPAGO', 'TIPOLUGAR',
                'TIPOCONTACTO', 'TIPODOCUMENTO'
            ]
            
            for tabla in tablas:
                try:
                    cursor.execute(f"DROP TABLE {tabla} CASCADE CONSTRAINTS")
                    print(f"✓ Tabla {tabla} eliminada")
                except:
                    print(f"- Tabla {tabla} no existe")
            
            conn.commit()
        
        # PASO 2: Crear tablas
        print("\n\nCreando tablas...")
        exitosos1, errores1 = ejecutar_sql_file(cursor, '01_crear_tablas.sql')
        conn.commit()
        
        # PASO 3: Insertar datos
        print("\n\nInsertando datos...")
        exitosos2, errores2 = ejecutar_sql_file(cursor, '02_inserciones_datos.sql')
        conn.commit()
        
        # PASO 4: Verificar
        print("\n\n" + "="*60)
        print("VERIFICACIÓN FINAL")
        print("="*60)
        
        cursor.execute("SELECT COUNT(*) FROM user_tables")
        total_tablas = cursor.fetchone()[0]
        print(f"✓ Total de tablas: {total_tablas}")
        
        cursor.execute("SELECT COUNT(*) FROM CLIENTE")
        total_clientes = cursor.fetchone()[0]
        print(f"✓ Total de clientes: {total_clientes}")
        
        cursor.execute("SELECT COUNT(*) FROM TIPODOCUMENTO")
        total_tipos = cursor.fetchone()[0]
        print(f"✓ Total de tipos de documento: {total_tipos}")
        
        print("\n✓ Base de datos cargada exitosamente!")
        
        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"\n✗ Error: {e}")

if __name__ == "__main__":
    main()
