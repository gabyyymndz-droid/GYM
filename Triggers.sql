USE DaddysGiovaGym;
GO

CREATE TRIGGER dbo.tr_ValidarMontoFactura
ON dbo.FACTURA
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Evaluamos si hay facturas recién insertadas o actualizadas con Monto <= 0
    IF EXISTS (
        SELECT 1 
        FROM inserted 
        WHERE Monto <= 0
    )
    BEGIN
        RAISERROR ('Error de Integridad: El monto de la factura no puede ser menor o igual a cero.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

USE DaddysGiovaGym;
GO
-----------------------------------------------------------------
CREATE TRIGGER dbo.tr_AuditoriaClientes
ON dbo.CLIENTE
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Accion VARCHAR(10);

    -- 1. Determinar el tipo de operación
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
        SET @Accion = 'UPDATE';
    ELSE IF EXISTS (SELECT 1 FROM inserted)
        SET @Accion = 'INSERT';
    ELSE IF EXISTS (SELECT 1 FROM deleted)
        SET @Accion = 'DELETE';
    ELSE
        RETURN;

    -- 2. Registrar en seguridad.AuditoriaCambios
    -- Omitimos 'fechaCambio' porque la tabla ya tiene un DEFAULT GETDATE()
    
    IF @Accion = 'INSERT' OR @Accion = 'UPDATE'
    BEGIN
        INSERT INTO seguridad.AuditoriaCambios (nombreTabla, usuario, descripcion)
        SELECT 
            'CLIENTE', 
            SYSTEM_USER, 
            'Se realizó un ' + @Accion + ' en el cliente ID: ' + CAST(ID_cliente AS NVARCHAR(50))
        FROM inserted;
    END
    ELSE IF @Accion = 'DELETE'
    BEGIN
        INSERT INTO seguridad.AuditoriaCambios (nombreTabla, usuario, descripcion)
        SELECT 
            'CLIENTE', 
            SYSTEM_USER, 
            'Se realizó un DELETE en el cliente ID: ' + CAST(ID_cliente AS NVARCHAR(50))
        FROM deleted;
    END
END;
GO