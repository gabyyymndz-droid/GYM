USE DaddysGiovaGym;
GO

-- Funcion 1: dias desde el ultimo pago del cliente
CREATE FUNCTION dbo.fn_DiasDesdeUltimoPago (@ID_cliente INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT DATEDIFF(DAY, MAX(Fecha_emision), GETDATE())
            FROM FACTURA WHERE ID_cliente = @ID_cliente AND Estado = 'Pagado');
END;
GO

-- Funcion 2 (placeholder de la funcion de Gaby): estado de la membresia
CREATE FUNCTION dbo.fn_EstadoMembresia (@ID_cliente INT)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @Dias INT = dbo.fn_DiasDesdeUltimoPago(@ID_cliente);
    RETURN CASE WHEN @Dias IS NULL THEN 'Sin pagos'
                WHEN @Dias <= 30 THEN 'Activa'
                ELSE 'Vencida' END;
END;
GO


#FALTAN 2 FUNCIONES/ IGNORAR VISTAS
-- 1. Clientes activos: clientes con pagos registrados, con total y cantidad de facturas
CREATE VIEW dbo.vw_ClientesActivos AS
SELECT c.ID_cliente, c.Nombres, c.Apellidos, m.Nombre AS Membresia,
       COUNT(f.ID_factura) AS FacturasPagadas,
       SUM(f.Monto)        AS TotalPagado
FROM CLIENTE c
INNER JOIN MEMBRESIA m ON c.ID_membresia = m.ID_membresia
INNER JOIN FACTURA f   ON f.ID_cliente = c.ID_cliente AND f.Estado = 'Pagado'
GROUP BY c.ID_cliente, c.Nombres, c.Apellidos, m.Nombre
HAVING COUNT(f.ID_factura) > 0;
GO

-- 2. Historial de operaciones: resumen mensual de pagos por cliente
CREATE VIEW dbo.vw_HistorialOperaciones AS
SELECT c.ID_cliente, c.Nombres + ' ' + c.Apellidos AS Cliente,
       YEAR(f.Fecha_emision) AS Anio, MONTH(f.Fecha_emision) AS Mes,
       COUNT(f.ID_factura) AS CantidadOperaciones,
       SUM(f.Monto)        AS MontoTotal
FROM FACTURA f
INNER JOIN CLIENTE c ON f.ID_cliente = c.ID_cliente
GROUP BY c.ID_cliente, c.Nombres, c.Apellidos, YEAR(f.Fecha_emision), MONTH(f.Fecha_emision);
GO

-- 3. Informacion detallada: usa las 2 funciones + totales de facturas y clases
CREATE VIEW dbo.vw_InformacionDetallada AS
SELECT c.ID_cliente, c.Nombres, c.Apellidos, m.Nombre AS Membresia,
       dbo.fn_EstadoMembresia(c.ID_cliente)     AS EstadoMembresia,
       dbo.fn_DiasDesdeUltimoPago(c.ID_cliente)  AS DiasDesdeUltimoPago,
       COUNT(DISTINCT f.ID_factura)             AS CantidadFacturas,
       ISNULL(SUM(f.Monto), 0)                  AS TotalPagado,
       COUNT(DISTINCT ce.ID_cliente_entrenador) AS CantidadClases
FROM CLIENTE c
INNER JOIN MEMBRESIA m       ON c.ID_membresia = m.ID_membresia
LEFT JOIN FACTURA f          ON f.ID_cliente = c.ID_cliente AND f.Estado = 'Pagado'
LEFT JOIN CLIENTE_ENTRENADOR ce ON ce.ID_cliente = c.ID_cliente
GROUP BY c.ID_cliente, c.Nombres, c.Apellidos, m.Nombre;
GO

-- 4. Actividades del ultimo mes: clases por cliente-entrenador en los ultimos 30 dias
CREATE VIEW dbo.vw_ActividadesUltimoMes AS
SELECT c.ID_cliente, c.Nombres + ' ' + c.Apellidos AS Cliente,
       e.ID_entrenador, e.Nombres + ' ' + e.Apellidos AS Entrenador,
       COUNT(*)              AS CantidadClases,
       MAX(ce.Fecha_Clase)   AS UltimaClase
FROM CLIENTE_ENTRENADOR ce
INNER JOIN CLIENTE c    ON ce.ID_cliente = c.ID_cliente
INNER JOIN ENTRENADOR e ON ce.ID_entrenador = e.ID_entrenador
WHERE ce.Fecha_Clase >= DATEADD(MONTH, -1, GETDATE())
GROUP BY c.ID_cliente, c.Nombres, c.Apellidos, e.ID_entrenador, e.Nombres, e.Apellidos;
GO

-- 5. Estadisticas por categoria (membresia): clientes e ingresos por membresia
CREATE VIEW dbo.vw_EstadisticasCategoria AS
SELECT m.Nombre AS Categoria,
       COUNT(DISTINCT c.ID_cliente) AS CantidadClientes,
       ISNULL(SUM(f.Monto), 0)      AS IngresoTotal,
       ISNULL(AVG(f.Monto), 0)      AS IngresoPromedio
FROM MEMBRESIA m
INNER JOIN CLIENTE c ON c.ID_membresia = m.ID_membresia
LEFT JOIN FACTURA f   ON f.ID_cliente = c.ID_cliente AND f.Estado = 'Pagado'
GROUP BY m.Nombre;
GO

-- 6. Ranking de entrenadores mas solicitados (por cantidad de clases impartidas)
CREATE VIEW dbo.vw_RankingElementos AS
SELECT TOP 100 PERCENT e.Nombres + ' ' + e.Apellidos AS Entrenador,
       COUNT(*) AS CantidadClases
FROM ENTRENADOR e
INNER JOIN CLIENTE_ENTRENADOR ce ON ce.ID_entrenador = e.ID_entrenador
GROUP BY e.Nombres, e.Apellidos
HAVING COUNT(*) > 0
ORDER BY CantidadClases DESC;
GO
