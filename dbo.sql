-- Vista de registros activos
GO
CREATE VIEW dbo.vw_ClientesActivos AS
SELECT 
    C.ID_cliente,
    C.Nombres + " " + C.Apellidos AS Nombre_Completo,
    C.Telefono,
    M.Nombre AS Membresia,
    M.Precio,
    S.Nombre AS Sucursal_Asignada
FROM CLIENTE C
INNER JOIN MEMBRESIA M ON C.ID_membresia = M.ID_membresia
INNER JOIN SUCURSAL S ON C.ID_sucursal = S.ID_sucursal;
GO

-- 2.  Vista con el historial de operaciones realizadas
GO
CREATE VIEW dbo.vw_InformacionDetalladaClientes AS
SELECT 
    C.ID_cliente,
    C.Nombres + " " + C.Apellidos AS Nombre_Completo_Cliente,
    C.Direccion,
    M.Nombre AS Plan_Membresia,
    M.Periodo,
    MP.Tipo AS Forma_Pago,
    -- Usamos la función de Franco para traer el total histórico que ha gastado el cliente:
    dbo.fn_TotalPagosCliente(C.ID_cliente) AS Total_Pagado_Historico
FROM CLIENTE C
INNER JOIN MEMBRESIA M ON C.ID_membresia = M.ID_membresia
INNER JOIN METODO_PAGO MP ON C.ID_metodo_pago = MP.ID_metodo_pago;
GO

-- 2. Vista de información detallada de cada registro (Expediente Maestro Completo)
GO
CREATE VIEW dbo.vw_InformacionDetalladaClientes AS
SELECT 
    C.ID_cliente,
    C.Nombres + " " + C.Apellidos AS Cliente,
    C.Telefono AS Telefono_Cliente,
    C.Direccion AS Direccion_Cliente,
    S.Nombre AS Sucursal_Inscrito,
    M.Nombre AS Plan_Membresia,
    M.Precio AS Precio_Membresia,
    M.Periodo AS Periodo_Membresia,
    MP.Tipo AS Metodo_Pago_Preferido,
    E.Nombres + " " + E.Apellidos AS Entrenador_Asignado,
    CE.Fecha_Clase,
    CE.Hora_Clase,
    -- Aquí integramos limpiamente la FUNCIÓN 1 de Franco para ver su histórico financiero:
    dbo.fn_TotalPagosCliente(C.ID_cliente) AS Total_Pagado_Historico
FROM CLIENTE C
INNER JOIN SUCURSAL S ON C.ID_sucursal = S.ID_sucursal
INNER JOIN MEMBRESIA M ON C.ID_membresia = M.ID_membresia
INNER JOIN METODO_PAGO MP ON C.ID_metodo_pago = MP.ID_metodo_pago
LEFT JOIN CLIENTE_ENTRENADOR CE ON C.ID_cliente = CE.ID_cliente
LEFT JOIN ENTRENADOR E ON CE.ID_entrenador = E.ID_entrenador;
GO

-- 3. Vista de actividades realizadas durante el último mes
GO
CREATE VIEW dbo.vw_ActividadesUltimoMes AS
SELECT 
    CE.ID_cliente_entrenador AS ID_Reserva,
    C.Nombres + " " + C.Apellidos AS Cliente,
    E.Nombres + " " + E.Apellidos AS Entrenador,
    CE.Fecha_Clase,
    CE.Hora_Clase,
    T.Horas_rango AS Horario_Turno
FROM CLIENTE_ENTRENADOR CE
INNER JOIN CLIENTE C ON CE.ID_cliente = C.ID_cliente
INNER JOIN ENTRENADOR E ON CE.ID_entrenador = E.ID_entrenador
INNER JOIN TURNO T ON E.ID_turno = T.ID_turno
WHERE CE.Fecha_Clase >= DATEADD(MONTH, -1, GETDATE());
GO

-- 4. Vista de estadísticas por categoría
GO
CREATE VIEW dbo.vw_EstadisticasPorCategoria AS
SELECT 
    M.Nombre AS Tipo_Membresia,
    COUNT(C.ID_cliente) AS Total_Clientes_Inscritos,
    SUM(M.Precio) AS Ingreso_Potencial_Mensual,
    AVG(M.Precio) AS Precio_Promedio
FROM MEMBRESIA M
LEFT JOIN CLIENTE C ON M.ID_membresia = C.ID_membresia
GROUP BY M.Nombre;
GO

-- 5. Vista de ranking de entrenadores mas solicitados
GO
CREATE VIEW dbo.vw_RankingElementosMasUsados AS
SELECT TOP 5
    E.ID_entrenador,
    E.Nombres + " " + E.Apellidos AS Entrenador,
    S.Nombre AS Sucursal,
    COUNT(CE.ID_cliente_entrenador) AS Total_Clases_Impartidas,
    RANK() OVER (ORDER BY COUNT(CE.ID_cliente_entrenador) DESC) AS Posicion_Ranking
FROM ENTRENADOR E
INNER JOIN SUCURSAL S ON E.ID_sucursal = S.ID_sucursal
LEFT JOIN CLIENTE_ENTRENADOR CE ON E.ID_entrenador = CE.ID_entrenador
GROUP BY E.ID_entrenador, E.Nombres, E.Apellidos, S.Nombre;
GO
