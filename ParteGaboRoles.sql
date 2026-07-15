GO
CREATE SCHEMA seguridad;
GO

CREATE TABLE seguridad.AuditoriaCambios(
    idAuditoria INT PRIMARY KEY IDENTITY(1,1),
    nombreTabla NVARCHAR(100) NOT NULL,
    usuario NVARCHAR(100) NOT NULL,
    fechaCambio DATE DEFAULT GETDATE(),
    descripcion NVARCHAR(255) NOT NULL
);

GO
CREATE ROLE rol_operador;
CREATE ROLE rol_registro;
CREATE ROLE rol_consultas;
GO