
import oracledb
import sys

# Configuración
ORACLE_USER = 'BD85'
ORACLE_PASSWORD = 'bd85'
ORACLE_HOST = 'localhost'
ORACLE_PORT = 1521
ORACLE_SERVICE = 'XE'
ORACLE_CLIENT_PATH = r"C:\oraclexe\app\oracle\product\11.2.0\server\bin"

try:
    oracledb.init_oracle_client(lib_dir=ORACLE_CLIENT_PATH)
except Exception as e:
    pass

def check_client(cod_cliente):
    try:
        dsn = f"{ORACLE_HOST}:{ORACLE_PORT}/{ORACLE_SERVICE}"
        conn = oracledb.connect(user=ORACLE_USER, password=ORACLE_PASSWORD, dsn=dsn)
        cursor = conn.cursor()
        
        print(f"--- Verificando cliente {cod_cliente} ---")
        
        # 1. Verificar existencia
        cursor.execute("SELECT * FROM CLIENTE WHERE codCliente = :cod", {'cod': cod_cliente})
        row = cursor.fetchone()
        if row:
            print(f"Cliente encontrado: {row}")
        else:
            print("Cliente NO encontrado")
            conn.close()
            return

        # 2. Verificar dependencias en CONTACTO
        cursor.execute("SELECT COUNT(*) FROM CONTACTO WHERE codCliente = :cod", {'cod': cod_cliente})
        count_contacto = cursor.fetchone()[0]
        print(f"Registros en CONTACTO: {count_contacto}")

        # 3. Verificar dependencias en CASO
        cursor.execute("SELECT COUNT(*) FROM CASO WHERE codCliente = :cod", {'cod': cod_cliente})
        count_caso = cursor.fetchone()[0]
        print(f"Registros en CASO: {count_caso}")

        # 4. Intentar eliminar (REAL)
        print("--- Intentando eliminar (REAL) ---")
        try:
            cursor.execute("DELETE FROM CLIENTE WHERE codCliente = :cod", {'cod': cod_cliente})
            print(f"Delete ejecutado. Filas afectadas: {cursor.rowcount}")
            conn.commit() 
            print("Commit ejecutado")
        except oracledb.DatabaseError as e:
            print(f"ERROR AL ELIMINAR: {e}")
            conn.rollback()
        
        # 5. Verificar post-delete
        cursor.execute("SELECT COUNT(*) FROM CLIENTE WHERE codCliente = :cod", {'cod': cod_cliente})
        count = cursor.fetchone()[0]
        print(f"Existencia post-delete: {count}")

        
        conn.close()

    except Exception as e:
        print(f"Error general: {e}")

if __name__ == "__main__":
    check_client('C0008')
