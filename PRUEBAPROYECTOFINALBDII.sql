DROP DATABASE DaddysGiovaGym;
CREATE DATABASE DaddysGiovaGym;
USE DaddysGiovaGym;
CREATE TABLE SUCURSAL
(
    ID_sucursal INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(60) NOT NULL,
    Direccion VARCHAR(150) NOT NULL 
);

CREATE TABLE MEMBRESIA
(
    ID_membresia INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(60) NOT NULL,
    Descripcion VARCHAR(150) NULL,
    Precio MONEY NOT NULL CHECK (Precio >= 0),
    Periodo VARCHAR(60) NOT NULL
);

CREATE TABLE METODO_PAGO
(
    ID_metodo_pago INT PRIMARY KEY IDENTITY(1,1),
    Tipo VARCHAR(30) NOT NULL
);

CREATE TABLE ROL
(
    ID_rol INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(60) NOT NULL
);

CREATE TABLE SALARIO
(
    ID_salario INT PRIMARY KEY IDENTITY(1,1),
    Salario_total MONEY NOT NULL CHECK (Salario_total > 0)
);

CREATE TABLE TURNO
(
    ID_turno INT PRIMARY KEY IDENTITY(1,1),
    Horas_rango VARCHAR(25) NOT NULL
);

CREATE TABLE CLIENTE
(
    ID_cliente INT PRIMARY KEY IDENTITY(1,1),
    Nombres VARCHAR(60) NOT NULL,
    Apellidos VARCHAR(60) NOT NULL,
    Telefono CHAR(8) NULL CHECK (Telefono LIKE '[267][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'), --amigos hay q ver si dejamos el CHECK y los 3 primeros digitos a validar el codigo d cada num
    Direccion VARCHAR(150) NULL,
    ID_sucursal INT NOT NULL FOREIGN KEY REFERENCES SUCURSAL(ID_sucursal),
    ID_membresia INT NOT NULL FOREIGN KEY REFERENCES MEMBRESIA(ID_membresia),
    ID_metodo_pago INT NOT NULL FOREIGN KEY REFERENCES METODO_PAGO(ID_metodo_pago)
);

CREATE TABLE ENTRENADOR
(
    ID_entrenador INT PRIMARY KEY IDENTITY(1,1),
    Nombres VARCHAR(60) NOT NULL,
    Apellidos VARCHAR(60) NOT NULL,
    Telefono CHAR(8) NULL CHECK (Telefono LIKE '[267][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    ID_sucursal INT NOT NULL FOREIGN KEY REFERENCES SUCURSAL(ID_sucursal),
    ID_salario INT NOT NULL FOREIGN KEY REFERENCES SALARIO(ID_salario),
    ID_turno INT NOT NULL FOREIGN KEY REFERENCES TURNO(ID_turno)
);

CREATE TABLE EMPLEADO
(
    ID_empleado INT PRIMARY KEY IDENTITY(1,1),
    Nombres VARCHAR(60) NOT NULL,
    Apellidos VARCHAR(60) NOT NULL,
    Telefono CHAR(8) NOT NULL CHECK (Telefono LIKE '[267][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    ID_rol INT NOT NULL FOREIGN KEY REFERENCES ROL(ID_rol),
    ID_sucursal INT NOT NULL FOREIGN KEY REFERENCES SUCURSAL(ID_sucursal),
    ID_salario INT NOT NULL FOREIGN KEY REFERENCES SALARIO(ID_salario),
    ID_turno INT NOT NULL FOREIGN KEY REFERENCES TURNO(ID_turno)
);

CREATE TABLE CLIENTE_ENTRENADOR
(
    ID_cliente_entrenador INT PRIMARY KEY IDENTITY(1,1),
    ID_cliente INT NOT NULL FOREIGN KEY REFERENCES CLIENTE(ID_cliente),
    ID_entrenador INT NOT NULL FOREIGN KEY REFERENCES ENTRENADOR(ID_entrenador),
    Fecha_Clase DATE NOT NULL,      
    Hora_Clase TIME NOT NULL       
);

CREATE TABLE FACTURA
(
    ID_factura INT PRIMARY KEY IDENTITY(1,1),
    ID_cliente INT NOT NULL FOREIGN KEY REFERENCES CLIENTE(ID_cliente),
    ID_metodo_pago INT NOT NULL FOREIGN KEY REFERENCES METODO_PAGO(ID_metodo_pago),
    Fecha_emision DATE NOT NULL DEFAULT GETDATE(),
    Monto MONEY NOT NULL CHECK (Monto >= 0),
    Estado VARCHAR(20) NOT NULL DEFAULT 'Pagado'
);

alter table CLIENTE add foreign key (ID_membresia) references MEMBRESIA(ID_membresia);
alter table CLIENTE add foreign key (ID_metodo_pago) references METODO_PAGO(ID_metodo_pago);
alter table CLIENTE add foreign key (ID_sucursal) references SUCURSAL(ID_sucursal);

alter table EMPLEADO add foreign key (ID_rol) references ROL(ID_rol);
alter table EMPLEADO add foreign key (ID_turno) references TURNO(ID_turno);
alter table EMPLEADO add foreign key (ID_salario) references SALARIO(ID_salario);
alter table EMPLEADO add foreign key (ID_sucursal) references SUCURSAL(ID_sucursal);

alter table ENTRENADOR add foreign key (ID_turno) references TURNO(ID_turno);
alter table ENTRENADOR add foreign key (ID_salario) references SALARIO(ID_salario);
alter table ENTRENADOR add foreign key (ID_sucursal) references SUCURSAL(ID_sucursal);

alter table CLIENTE_ENTRENADOR add foreign key (ID_cliente) references CLIENTE(ID_cliente);
alter table CLIENTE_ENTRENADOR add foreign key (ID_entrenador) references ENTRENADOR(ID_entrenador);
alter table TURNO alter column Horas_rango varchar(25);

alter table FACTURA add foreign key (ID_cliente) references CLIENTE(ID_cliente);
alter table FACTURA add foreign key (ID_metodo_pago) references METODO_PAGO(ID_metodo_pago);

INSERT INTO SUCURSAL (Nombre, Direccion)
VALUES
('DaddysGiovaGym San Benito', 'Bulevar del Hipódromo, San Salvador'),
('DaddysGiovaGym Santa Elena', 'Bulevar Orden de Malta, Antiguo Cuscatlán'),
('DaddysGiovaGym Escalón', 'Paseo General Escalón, San Salvador'),
('DaddysGiovaGym Santa Tecla', 'Plaza Merliot, Santa Tecla'),
('DaddysGiovaGym Lourdes', 'Centro Comercial El Encuentro, Lourdes Colón');

INSERT INTO MEMBRESIA (Nombre, Descripcion, Precio, Periodo)
VALUES
('Basica','Acceso general',20,'Mensual'),
('Premium','Acceso total',35,'Mensual'),
('VIP','Acceso VIP',50,'Mensual'),
('Estudiante','Descuento estudiante',15,'Mensual'),
('Empresarial','Plan empresarial',30,'Mensual'),
('Trimestral','3 meses',75,'Trimestral'),
('Semestral','6 meses',140,'Semestral'),
('Anual','12 meses',250,'Anual'),
('Pareja','2 personas',40,'Mensual'),
('Familiar','Grupo familiar',60,'Mensual');

INSERT INTO METODO_PAGO (Tipo)
VALUES
('Efectivo'),
('Tarjeta Credito'),
('Tarjeta Debito'),
('Transferencia'),
('PayPal'),
('Bitcoin'),
('Deposito Bancario'),
('Cheque'),
('Pago Movil'),
('Apple Pay');

INSERT INTO ROL (Nombre)
VALUES
('Recepcionista'),
('Administrador'),
('Gerente'),
('Contador'),
('Limpieza'),
('Seguridad'),
('Asistente'),
('Marketing'),
('Supervisor'),
('Coordinador');

INSERT INTO SALARIO (Salario_total)
VALUES
(400),
(450),
(500),
(550),
(600),
(650),
(700),
(750),
(800),
(900);

INSERT INTO TURNO (Horas_rango)
VALUES
('12:00 AM - 8:00 AM'), 
('2:00 AM - 10:00 AM'),  
('4:00 AM - 12:00 PM'),  
('6:00 AM - 2:00 PM'),   
('8:00 AM - 4:00 PM'),   
('10:00 AM - 6:00 PM'),  
('12:00 PM - 8:00 PM'),  
('2:00 PM - 10:00 PM'),  
('4:00 PM - 12:00 AM'),  
('6:00 PM - 2:00 AM');   

INSERT INTO EMPLEADO
(Nombres,Apellidos,Telefono,ID_rol,ID_salario,ID_turno, ID_sucursal)
VALUES
('André','González','70000001',2,10,4,1),   
('Carlos','Amaya','70000002',1,1,5,2),     
('Fernando','Calvo','70000003',9,5,6,3),    
('Marcos','Flores','70000004',3,9,8,4),     
('Diego','González','70000005',7,3,10,5);

INSERT INTO ENTRENADOR
(Nombres,Apellidos,Telefono,ID_salario,ID_turno, ID_sucursal)
VALUES
('Jonathan David','Alvarado Hernández','71000001',5,2, 1),
('Sara Abigail','Arévalo Esperanza','71000002',5,3, 2),
('Camila Arantza','Berganza Espinoza','71000003',6,5, 2),
('Natalia Jimena','Díaz Beltrán','71000004',7,8, 5),
('Víctor Alejandro','Solano Ramírez','71000005',10,10, 3);


INSERT INTO CLIENTE (Nombres, Apellidos, Telefono, Direccion, ID_sucursal, ID_membresia, ID_metodo_pago)
VALUES
('Jonathan David', 'Alvarado Hernández', '72000001', 'San Salvador', 1, 1, 1),
('Carlos Andrés', 'Amaya Rengifo', '72000002', 'San Salvador', 2, 2, 2),
('Sara Abigail', 'Arévalo Esperanza', '72000003', 'San Salvador', 3, 3, 3),
('David Ignacio', 'Argueta Valles', '72000004', 'San Salvador', 4, 4, 4),
('Nathaly Elizabeth', 'Avilés Monzón', '72000005', 'San Salvador', 5, 5, 5),
('Camila Arantza', 'Berganza Espinoza', '72000006', 'San Salvador', 1, 6, 6),
('Katherine Sofía', 'Cabezas Miranda', '72000007', 'San Salvador', 2, 7, 7),
('Fernando Alonso', 'Calvo Recinos', '72000008', 'San Salvador', 3, 8, 8),
('Abigail Alexandra', 'Canizales Rivas', '72000009', 'San Salvador', 4, 9, 9),
('Alan Enrique de Sedas', 'Villar', '72000010', 'San Salvador', 5, 10, 10),
('Natalia Jimena', 'Díaz Beltrán', '72000011', 'San Salvador', 1, 1, 1),
('Joel Steven', 'Elías Esperanza', '72000012', 'San Salvador', 2, 2, 2),
('Mariela Nicole', 'Flores Arévalo', '72000013', 'San Salvador', 3, 3, 3),
('Marcos David', 'Flores Cruz', '72000014', 'San Salvador', 4, 4, 4),
('Andrés Iván', 'Fuentes Menjívar', '72000015', 'San Salvador', 5, 5, 5),
('Jessica Karina', 'González Clímaco', '72000016', 'San Salvador', 1, 6, 6),
('Diego Alejandro', 'González Inglés', '72000017', 'San Salvador', 2, 7, 7),
('Cristian Xavier', 'Gonzalez Mejia', '72000018', 'San Salvador', 3, 8, 8),
('Luis Mario', 'Hernández Ruiz', '72000019', 'San Salvador', 4, 9, 9),
('Iliana Abigail', 'Huezo Cañas', '72000020', 'San Salvador', 5, 10, 10),
('Gerardo Ismael', 'Jacinto Cruz', '72000021', 'San Salvador', 1, 1, 1),
('Jonathan Daniel', 'López Arévalo', '72000022', 'San Salvador', 2, 2, 2),
('Victor Rene', 'Lopez Huezo', '72000023', 'San Salvador', 3, 3, 3),
('Rodrigo Antonio', 'López López', '72000024', 'San Salvador', 4, 4, 4),
('Eduardo', 'Machado Arana', '72000025', 'San Salvador', 5, 5, 5);


INSERT INTO CLIENTE_ENTRENADOR (ID_cliente, ID_entrenador, Fecha_Clase, Hora_Clase)
VALUES
(1, 1, '2026-06-01', '08:00'),
(2, 2, '2026-06-01', '09:00'),
(3, 3, '2026-06-01', '10:00'),
(4, 4, '2026-06-02', '14:00'),
(5, 5, '2026-06-02', '15:00'),
(6, 1, '2026-06-02', '16:00'),
(7, 2, '2026-06-03', '07:00'),
(8, 3, '2026-06-03', '08:00'),
(9, 4, '2026-06-03', '09:00'),
(10, 5, '2026-06-04', '18:00'),
(11, 1, '2026-06-04', '19:00'),
(12, 2, '2026-06-04', '20:00'),
(13, 3, '2026-06-05', '06:00'),
(14, 4, '2026-06-05', '07:00'),
(15, 5, '2026-06-05', '08:00'),
(16, 1, '2026-06-06', '09:00'),
(17, 2, '2026-06-06', '10:00'),
(18, 3, '2026-06-06', '11:00'),
(19, 4, '2026-06-07', '14:00'),
(20, 5, '2026-06-07', '15:00');

INSERT INTO FACTURA (ID_cliente, ID_metodo_pago, Fecha_emision, Monto, Estado)
VALUES
(1, 1, '2026-05-01', 20.00, 'Pagado'),  
(2, 2, '2026-05-02', 35.00, 'Pagado'),  
(3, 3, '2026-05-05', 50.00, 'Pagado'),  
(4, 4, '2026-05-10', 15.00, 'Pagado'),  
(5, 5, '2026-05-12', 30.00, 'Pagado'),  
(6, 6, '2026-05-15', 75.00, 'Pagado'),  
(7, 7, '2026-05-18', 140.00, 'Pagado'), 
(8, 8, '2026-05-20', 250.00, 'Pagado'), 
(9, 9, '2026-05-25', 40.00, 'Pagado'),  
(10, 10, '2026-06-01', 60.00, 'Pagado');

--@Gabo
GO
CREATE SCHEMA seguridad;
GO

CREATE TABLE seguridad.AuditoriaCambios(
    idAuditoria INT PRIMARY KEY IDENTITY(1,1),
    nombreTabla NVARCHAR(100) NOT NULL,
    usuario NVARCHAR(100) NOT NULL,
    fechaCambio DATETIME DEFAULT GETDATE(), 
    descripcion NVARCHAR(255) NOT NULL
);
GO

CREATE ROLE rol_operador;
CREATE ROLE rol_registro;
CREATE ROLE rol_consultas; 
GO

--Franco
-- Funcion 1: dias desde el ultimo pago del cliente
CREATE FUNCTION dbo.fn_DiasDesdeUltimoPago (@ID_cliente INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT DATEDIFF(DAY, MAX(Fecha_emision), GETDATE())
            FROM FACTURA WHERE ID_cliente = @ID_cliente AND Estado = 'Pagado');
END;
GO

-- Funcion 2: estado de la membresia
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

-- Funcion 3: Total pagos clientes
CREATE FUNCTION dbo.fn_TotalPagosCliente (@ID_cliente INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @Total MONEY;
    SELECT @Total = ISNULL(SUM(Monto), 0) 
    FROM FACTURA 
    WHERE ID_cliente = @ID_cliente AND Estado = 'Pagado';
    RETURN @Total;
END;
GO

-- Funcion 4: Clientes por sucursal
CREATE FUNCTION dbo.fn_ClientesPorSucursal (@ID_sucursal INT)
RETURNS TABLE
AS
RETURN (
    SELECT ID_cliente, Nombres, Apellidos, Telefono, ID_membresia
    FROM CLIENTE
    WHERE ID_sucursal = @ID_sucursal
);
GO


--Gaby
-- 1. Vista de registros activos (Movida al esquema de seguridad requerido)
CREATE VIEW seguridad.vw_ClientesActivos AS
SELECT 
    C.ID_cliente,
    C.Nombres + ' ' + C.Apellidos AS Nombre_Completo,
    C.Telefono,
    M.Nombre AS Membresia,
    M.Precio,
    S.Nombre AS Sucursal_Asignada
FROM CLIENTE C
INNER JOIN MEMBRESIA M ON C.ID_membresia = M.ID_membresia
INNER JOIN SUCURSAL S ON C.ID_sucursal = S.ID_sucursal;
GO

-- 2. Vista con el historial de operaciones realizadas 
CREATE VIEW seguridad.vw_HistorialOperaciones AS
SELECT 
    C.ID_cliente,
    C.Nombres + ' ' + C.Apellidos AS Nombre_Completo_Cliente,
    C.Direccion,
    M.Nombre AS Plan_Membresia,
    M.Periodo,
    MP.Tipo AS Forma_Pago,
    dbo.fn_TotalPagosCliente(C.ID_cliente) AS Total_Pagado_Historico
FROM CLIENTE C
INNER JOIN MEMBRESIA M ON C.ID_membresia = M.ID_membresia
INNER JOIN METODO_PAGO MP ON C.ID_metodo_pago = MP.ID_metodo_pago;
GO

-- 3. Vista de información detallada de cada registro 
CREATE VIEW seguridad.vw_InformacionDetalladaClientes AS
SELECT 
    C.ID_cliente,
    C.Nombres + ' ' + C.Apellidos AS Cliente,
    C.Telefono AS Telefono_Cliente,
    C.Direccion AS Direccion_Cliente,
    S.Nombre AS Sucursal_Inscrito,
    M.Nombre AS Plan_Membresia,
    M.Precio AS Precio_Membresia,
    M.Periodo AS Periodo_Membresia,
    MP.Tipo AS Metodo_Pago_Preferido,
    E.Nombres + ' ' + E.Apellidos AS Entrenador_Asignado,
    CE.Fecha_Clase,
    CE.Hora_Clase,
    dbo.fn_TotalPagosCliente(C.ID_cliente) AS Total_Pagado_Historico
FROM CLIENTE C
INNER JOIN SUCURSAL S ON C.ID_sucursal = S.ID_sucursal
INNER JOIN MEMBRESIA M ON C.ID_membresia = M.ID_membresia
INNER JOIN METODO_PAGO MP ON C.ID_metodo_pago = MP.ID_metodo_pago
LEFT JOIN CLIENTE_ENTRENADOR CE ON C.ID_cliente = CE.ID_cliente
LEFT JOIN ENTRENADOR E ON CE.ID_entrenador = E.ID_entrenador;
GO

-- 4. Vista de actividades realizadas durante el último mes
CREATE VIEW seguridad.vw_ActividadesUltimoMes AS
SELECT 
    CE.ID_cliente_entrenador AS ID_Reserva,
    C.Nombres + ' ' + C.Apellidos AS Cliente,
    E.Nombres + ' ' + E.Apellidos AS Entrenador,
    CE.Fecha_Clase,
    CE.Hora_Clase,
    T.Horas_rango AS Horario_Turno
FROM CLIENTE_ENTRENADOR CE
INNER JOIN CLIENTE C ON CE.ID_cliente = C.ID_cliente
INNER JOIN ENTRENADOR E ON CE.ID_entrenador = E.ID_entrenador
INNER JOIN TURNO T ON E.ID_turno = T.ID_turno
WHERE CE.Fecha_Clase >= DATEADD(MONTH, -1, GETDATE());
GO

-- 5. Vista de estadísticas por categoría
CREATE VIEW seguridad.vw_EstadisticasPorCategoria AS
SELECT 
    M.Nombre AS Tipo_Membresia,
    COUNT(C.ID_cliente) AS Total_Clientes_Inscritos,
    SUM(M.Precio) AS Ingreso_Potencial_Mensual,
    AVG(M.Precio) AS Precio_Promedio
FROM MEMBRESIA M
LEFT JOIN CLIENTE C ON M.ID_membresia = C.ID_membresia
GROUP BY M.Nombre;
GO

-- 6. Vista de ranking de entrenadores mas solicitados
CREATE VIEW seguridad.vw_RankingElementosMasUsados AS
SELECT TOP 5
    E.ID_entrenador,
    E.Nombres + ' ' + E.Apellidos AS Entrenador,
    S.Nombre AS Sucursal,
    COUNT(CE.ID_cliente_entrenador) AS Total_Clases_Impartidas,
    RANK() OVER (ORDER BY COUNT(CE.ID_cliente_entrenador) DESC) AS Posicion_Ranking
FROM ENTRENADOR E
INNER JOIN SUCURSAL S ON E.ID_sucursal = S.ID_sucursal
LEFT JOIN CLIENTE_ENTRENADOR CE ON E.ID_entrenador = CE.ID_entrenador
GROUP BY E.ID_entrenador, E.Nombres, E.Apellidos, S.Nombre;
GO

--Calvo
CREATE OR ALTER PROCEDURE seguridad.sp_RegistrarCliente
(
    @Nombres VARCHAR(60),
    @Apellidos VARCHAR(60),
    @Telefono CHAR(8),
    @Direccion VARCHAR(150),
    @ID_sucursal INT,
    @ID_membresia INT,
    @ID_metodo_pago INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO CLIENTE
        (Nombres,Apellidos,Telefono,Direccion,ID_sucursal,ID_membresia,ID_metodo_pago)
        VALUES
        (@Nombres,@Apellidos,@Telefono,@Direccion,@ID_sucursal,@ID_membresia,@ID_metodo_pago);
        COMMIT TRANSACTION;
        PRINT 'Cliente registrado correctamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE seguridad.sp_ActualizarCliente
(
    @ID_cliente INT,
    @Telefono CHAR(8),
    @Direccion VARCHAR(150),
    @ID_sucursal INT,
    @ID_membresia INT,
    @ID_metodo_pago INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        UPDATE CLIENTE
        SET Telefono=@Telefono,
            Direccion=@Direccion,
            ID_sucursal=@ID_sucursal,
            ID_membresia=@ID_membresia,
            ID_metodo_pago=@ID_metodo_pago
        WHERE ID_cliente=@ID_cliente;

        IF @@ROWCOUNT=0
            RAISERROR('No existe el cliente indicado.',16,1);

        COMMIT TRANSACTION;
        PRINT 'Cliente actualizado correctamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE seguridad.sp_BuscarClienteDinamico
(
    @Busqueda VARCHAR(60)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        C.ID_cliente,
        C.Nombres,
        C.Apellidos,
        C.Telefono,
        C.Direccion,
        S.Nombre AS Sucursal,
        M.Nombre AS Membresia
    FROM CLIENTE C
    INNER JOIN SUCURSAL S ON C.ID_sucursal=S.ID_sucursal
    INNER JOIN MEMBRESIA M ON C.ID_membresia=M.ID_membresia
    WHERE C.Nombres LIKE '%' + @Busqueda + '%'
       OR C.Apellidos LIKE '%' + @Busqueda + '%'
       OR C.Telefono LIKE '%' + @Busqueda + '%'
       OR C.Direccion LIKE '%' + @Busqueda + '%'
    ORDER BY C.Nombres,C.Apellidos;
END;
GO

CREATE OR ALTER PROCEDURE seguridad.sp_ReporteFacturacionFechas
(
    @FechaInicio DATE,
    @FechaFin DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        F.ID_factura,
        F.Fecha_emision,
        C.ID_cliente,
        C.Nombres + ' ' + C.Apellidos AS Cliente,
        MP.Tipo AS Metodo_Pago,
        F.Monto,
        F.Estado
    FROM FACTURA F
    INNER JOIN CLIENTE C ON F.ID_cliente=C.ID_cliente
    INNER JOIN METODO_PAGO MP ON F.ID_metodo_pago=MP.ID_metodo_pago
    WHERE F.Fecha_emision BETWEEN @FechaInicio AND @FechaFin
    ORDER BY F.Fecha_emision, Cliente;
END;
GO

--Medrano
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

--Esteban
--Asignación de permisos utilizando el esquema correcto (seguridad) 

-- Rol Operador
GRANT EXECUTE ON seguridad.sp_RegistrarCliente TO rol_operador;
GRANT EXECUTE ON seguridad.sp_ActualizarCliente TO rol_operador;
GRANT EXECUTE ON seguridad.sp_BuscarClienteDinamico TO rol_operador;
GRANT EXECUTE ON seguridad.sp_ReporteFacturacionFechas TO rol_operador;

GRANT SELECT ON seguridad.vw_ClientesActivos TO rol_operador;
GRANT SELECT ON seguridad.vw_HistorialOperaciones TO rol_operador;
GRANT SELECT ON seguridad.vw_InformacionDetalladaClientes TO rol_operador;
GRANT SELECT ON seguridad.vw_ActividadesUltimoMes TO rol_operador;
GRANT SELECT ON seguridad.vw_EstadisticasPorCategoria TO rol_operador;
GRANT SELECT ON seguridad.vw_RankingElementosMasUsados TO rol_operador;
GO

-- Rol Registro
GRANT EXECUTE ON seguridad.sp_RegistrarCliente TO rol_registro;
GRANT EXECUTE ON seguridad.sp_ActualizarCliente TO rol_registro;
GRANT EXECUTE ON seguridad.sp_BuscarClienteDinamico TO rol_registro;
GO

-- Rol Consultas
GRANT EXECUTE ON seguridad.sp_BuscarClienteDinamico TO rol_consultas;
GRANT EXECUTE ON seguridad.sp_ReporteFacturacionFechas TO rol_consultas;

GRANT SELECT ON seguridad.vw_ClientesActivos TO rol_consultas;
GRANT SELECT ON seguridad.vw_HistorialOperaciones TO rol_consultas;
GRANT SELECT ON seguridad.vw_InformacionDetalladaClientes TO rol_consultas;
GRANT SELECT ON seguridad.vw_ActividadesUltimoMes TO rol_consultas;
GRANT SELECT ON seguridad.vw_EstadisticasPorCategoria TO rol_consultas;
GRANT SELECT ON seguridad.vw_RankingElementosMasUsados TO rol_consultas;
GO


-- Crear logins en el contexto del servidor
USE master;
GO

CREATE LOGIN login_operador WITH PASSWORD='Operador123!';
GO
CREATE LOGIN login_registro WITH PASSWORD='Registro123!';
GO
CREATE LOGIN login_consultas WITH PASSWORD='Consultas123!';
GO


-- Crear usuarios mapeados en la base de datos del gimnasio
USE DaddysGiovaGym;
GO

CREATE USER operador FOR LOGIN login_operador;
GO
CREATE USER registro FOR LOGIN login_registro;
GO
CREATE USER consultas FOR LOGIN login_consultas;
GO


-- Asignar usuarios a sus respectivos roles corporativos
ALTER ROLE rol_operador ADD MEMBER operador;
GO
ALTER ROLE rol_registro ADD MEMBER registro;
GO
ALTER ROLE rol_consultas ADD MEMBER consultas;
GO


-- Prueba 1: El operador puede consultar las vistas autorizadas
EXECUTE AS USER='operador';
    PRINT 'Prueba 1: Operador consultando Clientes Activos (VÁLIDA):';
    SELECT * FROM seguridad.vw_ClientesActivos;
REVERT;
GO

-- Prueba 2: El usuario de registro puede buscar dinámicamente
EXECUTE AS USER='registro';
    PRINT 'Prueba 2: Registro ejecutando búsqueda de cliente (VÁLIDA):';
    EXEC seguridad.sp_BuscarClienteDinamico @Busqueda='Jonathan';
REVERT;
GO

-- Prueba 3: El usuario de consultas puede extraer reportes financieros
EXECUTE AS USER='consultas';
    PRINT 'Prueba 3: Consultas generando reporte de facturas por fechas (VÁLIDA):';
    EXEC seguridad.sp_ReporteFacturacionFechas '2026-05-01', '2026-06-30';
REVERT;
GO

-- Prueba 4: El usuario de consultas NO debe poder registrar clientes (Control de errores)
EXECUTE AS USER='consultas';
    PRINT 'Prueba 4: Consultas intentando insertar un cliente (DEBE DENEGAR ACCESO):';
    BEGIN TRY
        EXEC seguridad.sp_RegistrarCliente
            'Juan', 'Perez', '70001111', 'San Salvador', 1, 1, 1;
    END TRY
    BEGIN CATCH
        PRINT 'Acceso denegado correctamente de acuerdo al Principio de Mínimo Privilegio.';
        PRINT 'Mensaje de SQL Server: ' + ERROR_MESSAGE();
    END CATCH
REVERT;
GO