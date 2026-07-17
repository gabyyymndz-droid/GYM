USE DaddysGiovaGym;
GO




/* Asignación de permisos */

-- Rol Operador
GRANT EXECUTE ON seguridad.sp_RegistrarCliente TO rol_operador;
GRANT EXECUTE ON seguridad.sp_ActualizarCliente TO rol_operador;
GRANT EXECUTE ON seguridad.sp_BuscarClienteDinamico TO rol_operador;
GRANT EXECUTE ON seguridad.sp_ReporteFacturacionFechas TO rol_operador;

GRANT SELECT ON dbo.vw_ClientesActivos TO rol_operador;
GRANT SELECT ON dbo.vw_HistorialOperaciones TO rol_operador;
GRANT SELECT ON dbo.vw_InformacionDetallada TO rol_operador;
GRANT SELECT ON dbo.vw_ActividadesUltimoMes TO rol_operador;
GRANT SELECT ON dbo.vw_EstadisticasCategoria TO rol_operador;
GRANT SELECT ON dbo.vw_RankingElementos TO rol_operador;
GO

-- Rol Registro
GRANT EXECUTE ON seguridad.sp_RegistrarCliente TO rol_registro;
GRANT EXECUTE ON seguridad.sp_ActualizarCliente TO rol_registro;
GRANT EXECUTE ON seguridad.sp_BuscarClienteDinamico TO rol_registro;
GO

-- Rol Consultas
GRANT EXECUTE ON seguridad.sp_BuscarClienteDinamico TO rol_consultas;
GRANT EXECUTE ON seguridad.sp_ReporteFacturacionFechas TO rol_consultas;

GRANT SELECT ON dbo.vw_ClientesActivos TO rol_consultas;
GRANT SELECT ON dbo.vw_HistorialOperaciones TO rol_consultas;
GRANT SELECT ON dbo.vw_InformacionDetallada TO rol_consultas;
GRANT SELECT ON dbo.vw_ActividadesUltimoMes TO rol_consultas;
GRANT SELECT ON dbo.vw_EstadisticasCategoria TO rol_consultas;
GRANT SELECT ON dbo.vw_RankingElementos TO rol_consultas;
GO


--Crear logins 

USE master;
GO

CREATE LOGIN login_operador
WITH PASSWORD='Operador123!';
GO

CREATE LOGIN login_registro
WITH PASSWORD='Registro123!';
GO

CREATE LOGIN login_consultas
WITH PASSWORD='Consultas123!';
GO


--Crear usuarios 

USE DaddysGiovaGym;
GO

CREATE USER operador
FOR LOGIN login_operador;
GO

CREATE USER registro
FOR LOGIN login_registro;
GO

CREATE USER consultas
FOR LOGIN login_consultas;
GO


--Asignar usuarios a los roles 

ALTER ROLE rol_operador
ADD MEMBER operador;
GO

ALTER ROLE rol_registro
ADD MEMBER registro;
GO

ALTER ROLE rol_consultas
ADD MEMBER consultas;
GO



--PRUEBA 1 el operador puede consultar las vistas


EXECUTE AS USER='operador';

SELECT * FROM dbo.vw_ClientesActivos;

REVERT;
GO



--PRUEBA 2 el usuario de registro puede registrar clientes

EXECUTE AS USER='registro';

EXEC seguridad.sp_BuscarClienteDinamico
@Busqueda='Jonathan';

REVERT;
GO



--PRUEBA 3 el usuario de consultas puede consultar reportes


EXECUTE AS USER='consultas';

EXEC seguridad.sp_ReporteFacturacionFechas
'2026-05-01',
'2026-06-30';

REVERT;
GO



--PRUEBA 4 el usuario de consultas NO puede registrar clientes


EXECUTE AS USER='consultas';

BEGIN TRY

EXEC seguridad.sp_RegistrarCliente
'Juan',
'Perez',
'70001111',
'San Salvador',
1,
1,
1;

END TRY

BEGIN CATCH

PRINT 'Acceso denegado correctamente.';
PRINT ERROR_MESSAGE();

END CATCH

REVERT;
GO
