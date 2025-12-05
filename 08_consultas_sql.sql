================================================================================
CONSULTAS SQL - GABINETE DE ABOGADOS
Ejemplos de consultas útiles para validación y análisis
================================================================================

================================================================================
1. VALIDACIONES Y CONTEOS
================================================================================

-- Contar registros en tablas principales
SELECT 'CLIENTE' as Tabla, COUNT(*) as Cantidad FROM CLIENTE
UNION ALL
SELECT 'ABOGADO', COUNT(*) FROM ABOGADO
UNION ALL
SELECT 'CASO', COUNT(*) FROM CASO
UNION ALL
SELECT 'PAGO', COUNT(*) FROM PAGO
ORDER BY Tabla;

-- Verificar integridad de datos
SELECT COUNT(*) as Clientes_Sin_Contacto
FROM CLIENTE c
WHERE NOT EXISTS (
    SELECT 1 FROM CONTACTO ct WHERE ct.codCliente = c.codCliente
);

-- Casos sin expediente registrado
SELECT noCaso, fechaInicio FROM CASO c
WHERE NOT EXISTS (
    SELECT 1 FROM EXPEDIENTE e WHERE e.noCaso = c.noCaso
);

================================================================================
2. CONSULTAS DE BÚSQUEDA
================================================================================

-- Buscar cliente por código (UNA SOLA CONSULTA)
SELECT c.codCliente, c.nomCliente, c.apellCliente, c.nDocumento, 
       c.idTipoDoc, t.descTipoDoc
FROM CLIENTE c
JOIN TIPODOCUMENTO t ON c.idTipoDoc = t.idTipoDoc
WHERE c.codCliente = 'C0001';

-- Buscar cliente por nombre (búsqueda LIKE)
SELECT c.codCliente, c.nomCliente, c.apellCliente, c.nDocumento
FROM CLIENTE c
WHERE UPPER(c.nomCliente) LIKE UPPER('%Juan%')
   OR UPPER(c.apellCliente) LIKE UPPER('%Pérez%');

-- Obtener todos los contactos de un cliente
SELECT c.codCliente, c.nomCliente, 
       ct.valorContacto, tc.descTipoConta, ct.notificacion
FROM CLIENTE c
JOIN CONTACTO ct ON c.codCliente = ct.codCliente
JOIN TIPOCONTACTO tc ON ct.idTipoConta = tc.idTipoConta
WHERE c.codCliente = 'C0001'
ORDER BY tc.descTipoConta;

-- Tipos de documento disponibles (para combos)
SELECT idTipoDoc, descTipoDoc FROM TIPODOCUMENTO ORDER BY idTipoDoc;

-- Abogados por especialización
SELECT a.cedula, a.nombre, a.apellido, a.nTarjetaProfesional,
       e.codEspecializacion, e.nomEspecializacion
FROM ABOGADO a
JOIN ESPECIALIZACION e ON a.codEspecializacion = e.codEspecializacion
ORDER BY e.nomEspecializacion, a.apellido;

================================================================================
3. CONSULTAS DE CASOS
================================================================================

-- Todos los casos con información completa
SELECT ca.noCaso, ca.fechaInicio, ca.fechaFin, ca.valor,
       cl.nomCliente || ' ' || cl.apellCliente as Cliente,
       ab.nombre || ' ' || ab.apellido as Abogado,
       e.nomEspecializacion as Especialidad,
       lg.nomLugar as Juzgado
FROM CASO ca
JOIN CLIENTE cl ON ca.codCliente = cl.codCliente
JOIN ABOGADO ab ON ca.cedula = ab.cedula
JOIN ESPECIALIZACION e ON ab.codEspecializacion = e.codEspecializacion
JOIN LUGAR lg ON ca.codLugar = lg.codLugar
ORDER BY ca.fechaInicio DESC;

-- Casos activos (sin fecha fin)
SELECT noCaso, fechaInicio, valor
FROM CASO
WHERE fechaFin IS NULL
ORDER BY fechaInicio DESC;

-- Casos cerrados (con fecha fin)
SELECT noCaso, fechaInicio, fechaFin, valor,
       TRUNC((fechaFin - fechaInicio)) as Días_Duración
FROM CASO
WHERE fechaFin IS NOT NULL
ORDER BY fechaFin DESC;

-- Casos por especialización del abogado
SELECT e.nomEspecializacion, COUNT(ca.noCaso) as Total_Casos,
       SUM(TO_NUMBER(ca.valor)) as Monto_Total
FROM CASO ca
JOIN ABOGADO ab ON ca.cedula = ab.cedula
JOIN ESPECIALIZACION e ON ab.codEspecializacion = e.codEspecializacion
GROUP BY e.nomEspecializacion
ORDER BY Total_Casos DESC;

-- Carga de trabajo por abogado
SELECT ab.cedula, ab.nombre, ab.apellido,
       COUNT(ca.noCaso) as Casos_Asignados,
       SUM(CASE WHEN ca.fechaFin IS NULL THEN 1 ELSE 0 END) as Casos_Activos
FROM ABOGADO ab
LEFT JOIN CASO ca ON ab.cedula = ca.cedula
GROUP BY ab.cedula, ab.nombre, ab.apellido
ORDER BY Casos_Activos DESC;

================================================================================
4. CONSULTAS DE PAGOS
================================================================================

-- Resumen de pagos por caso
SELECT ca.noCaso, cl.nomCliente, SUM(p.valorPago) as Total_Pagado,
       COUNT(p.consecPago) as Num_Pagos,
       TRUNC(AVG(p.valorPago)) as Pago_Promedio
FROM PAGO p
JOIN CASO ca ON p.noCaso = ca.noCaso
JOIN CLIENTE cl ON ca.codCliente = cl.codCliente
GROUP BY ca.noCaso, cl.nomCliente
ORDER BY Total_Pagado DESC;

-- Pagos pendientes (comparar valor caso vs pagos realizados)
SELECT ca.noCaso, cl.nomCliente,
       TO_NUMBER(ca.valor) as Valor_Caso,
       COALESCE(SUM(p.valorPago), 0) as Pagado,
       TO_NUMBER(ca.valor) - COALESCE(SUM(p.valorPago), 0) as Pendiente
FROM CASO ca
JOIN CLIENTE cl ON ca.codCliente = cl.codCliente
LEFT JOIN PAGO p ON ca.noCaso = p.noCaso
GROUP BY ca.noCaso, cl.nomCliente, ca.valor
HAVING TO_NUMBER(ca.valor) > COALESCE(SUM(p.valorPago), 0)
ORDER BY Pendiente DESC;

-- Pagos por forma de pago
SELECT fp.descFormaPago, COUNT(p.consecPago) as Cantidad,
       SUM(p.valorPago) as Total
FROM PAGO p
JOIN FORMAPAGO fp ON p.idFormaPago = fp.idFormaPago
GROUP BY fp.descFormaPago
ORDER BY Total DESC;

-- Pagos con tarjeta (identificar franquicias usadas)
SELECT COALESCE(f.nomFranquisia, 'SIN ESPECIFICAR') as Franquicia,
       COUNT(p.consecPago) as Cantidad,
       SUM(p.valorPago) as Total
FROM PAGO p
LEFT JOIN FRANQUICIA f ON p.codFranquisia = f.codFranquisia
WHERE p.idFormaPago = 'TJT'
GROUP BY f.nomFranquisia
ORDER BY Total DESC;

================================================================================
5. CONSULTAS DE EXPEDIENTES Y ETAPAS
================================================================================

-- Expediente completo de un caso
SELECT ex.consecExpe, ex.fechaEtapa, ep.codEtapa, ep.nomEtapa, ca.noCaso
FROM EXPEDIENTE ex
JOIN ETAPAPROCESAL ep ON ex.codEtapa = ep.codEtapa
JOIN CASO ca ON ex.noCaso = ca.noCaso
WHERE ca.noCaso = 10001
ORDER BY ex.fechaEtapa;

-- Timeline de un caso (Sucesos, Documentos, Resultados)
SELECT ca.noCaso as Caso, 'SUCESO' as Tipo, s.descSuceso as Descripción,
       NULL as Ubicación, NULL as Resultado
FROM SUCESO s
JOIN CASO ca ON s.noCaso = ca.noCaso
WHERE ca.noCaso = 10001
UNION ALL
SELECT ca.noCaso, 'DOCUMENTO', d.ubicaDoc, d.ubicaDoc, NULL
FROM DOCUMENTO d
JOIN CASO ca ON d.noCaso = ca.noCaso
WHERE ca.noCaso = 10001
UNION ALL
SELECT ca.noCaso, 'RESULTADO', r.descResul, NULL, r.descResul
FROM RESULTADO r
JOIN CASO ca ON r.noCaso = ca.noCaso
WHERE ca.noCaso = 10001
ORDER BY Tipo;

-- Juzgados y Tribunales con jerarquía
SELECT tl.descTipoLugar, l.nomLugar, l.direLugar, l.telLugar, l.emailLugar
FROM LUGAR l
JOIN TIPOLUGAR tl ON l.idTipoLugar = tl.idTipoLugar
ORDER BY tl.descTipoLugar, l.nomLugar;

-- Instancias disponibles
SELECT nInstancia, 
       CASE nInstancia 
           WHEN 1 THEN 'Primera Instancia'
           WHEN 2 THEN 'Segunda Instancia (Apelación)'
           WHEN 3 THEN 'Tercera Instancia (Casación)'
           ELSE 'Otra Instancia'
       END as Descripción
FROM INSTANCIA
ORDER BY nInstancia;

================================================================================
6. CONSULTAS ANALÍTICAS
================================================================================

-- Ingresos por mes
SELECT EXTRACT(MONTH FROM p.fechaPago) as Mes,
       EXTRACT(YEAR FROM p.fechaPago) as Año,
       COUNT(p.consecPago) as Num_Pagos,
       SUM(p.valorPago) as Ingresos
FROM PAGO p
GROUP BY EXTRACT(YEAR FROM p.fechaPago), EXTRACT(MONTH FROM p.fechaPago)
ORDER BY Año DESC, Mes DESC;

-- Promedio de duración de casos
SELECT 'GENERAL' as Categoria,
       COUNT(ca.noCaso) as Total_Casos_Cerrados,
       TRUNC(AVG(ca.fechaFin - ca.fechaInicio)) as Días_Promedio,
       MIN(ca.fechaFin - ca.fechaInicio) as Mínimo,
       MAX(ca.fechaFin - ca.fechaInicio) as Máximo
FROM CASO ca
WHERE ca.fechaFin IS NOT NULL;

-- Especialización más demandada
SELECT e.nomEspecializacion,
       COUNT(ca.noCaso) as Demanda,
       COUNT(DISTINCT ab.cedula) as Abogados,
       TRUNC(SUM(TO_NUMBER(ca.valor))/1000000) as Ingresos_Millones
FROM CASO ca
JOIN ABOGADO ab ON ca.cedula = ab.cedula
JOIN ESPECIALIZACION e ON ab.codEspecializacion = e.codEspecializacion
GROUP BY e.nomEspecializacion
ORDER BY Demanda DESC;

-- Clientes con más casos
SELECT cl.codCliente, cl.nomCliente, cl.apellCliente,
       COUNT(ca.noCaso) as Total_Casos,
       COUNT(CASE WHEN ca.fechaFin IS NULL THEN 1 END) as Casos_Activos,
       TRUNC(SUM(TO_NUMBER(ca.valor))/1000000) as Inversión_Millones
FROM CLIENTE cl
LEFT JOIN CASO ca ON cl.codCliente = ca.codCliente
GROUP BY cl.codCliente, cl.nomCliente, cl.apellCliente
ORDER BY Total_Casos DESC;

================================================================================
7. CONSULTAS DE AUDITORÍA
================================================================================

-- Todos los datos de un cliente completo
SELECT c.*, t.descTipoDoc
FROM CLIENTE c
JOIN TIPODOCUMENTO t ON c.idTipoDoc = t.idTipoDoc
WHERE c.codCliente = 'C0001';

-- Todos los contactos del cliente
SELECT c.codCliente, c.nomCliente,
       STRING_AGG(ct.valorContacto, ', ') as Contactos
FROM CLIENTE c
JOIN CONTACTO ct ON c.codCliente = ct.codCliente
GROUP BY c.codCliente, c.nomCliente;

-- Números de documentos duplicados (validación de integridad)
SELECT nDocumento, COUNT(*) as Repeticiones, 
       LISTAGG(codCliente, ', ') WITHIN GROUP (ORDER BY codCliente) as Clientes
FROM CLIENTE
GROUP BY nDocumento
HAVING COUNT(*) > 1;

-- Tarjetas profesionales duplicadas
SELECT nTarjetaProfesional, COUNT(*) as Repeticiones,
       LISTAGG(cedula, ', ') WITHIN GROUP (ORDER BY cedula) as Abogados
FROM ABOGADO
GROUP BY nTarjetaProfesional
HAVING COUNT(*) > 1;

================================================================================
NOTAS IMPORTANTES
================================================================================

- Todas estas consultas retornan resultados en UNA SOLA ejecución
- Usar para validación de datos antes de demostración
- En la aplicación web, simplificar al máximo para obtener datos específicos
- Implementar índices en columnas frecuentemente consultadas:
  CREATE INDEX idx_cliente_cod ON CLIENTE(codCliente);
  CREATE INDEX idx_caso_cliente ON CASO(codCliente);
  CREATE INDEX idx_caso_abogado ON CASO(cedula);

================================================================================
Fin de Consultas SQL | Versión 1.0
================================================================================
