USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_GrupoAprobacion_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : Ingresar un nuevo Registro
Parametros
@ID_Grupo  : 
@Fech_Creacion  : 
@Fech_Actualiza  : 
@ID_Holding_Propietario  : 
@ID_ClasCargo  : 
@ID_PosCargo  : 
@ID_Tipo_Documento  : 
@ID_Org  : 
@Monto_Desde  : 
@Monto_Hasta  : 
@ID_Usro_Crea  : 
@ID_Usro_Act  : 
@Grupo_Aprobacion  : 
@Vigencia  : 
Creado : 10/04/2017.
Modifado : 1.
***********************************************
--Forma de Invocar.
***********************************************
*/

CREATE PROCEDURE [dbo].[ADM_GrupoAprobacion_INGRESO]

@ID_Grupo  int,
@ID_Holding_Propietario  numeric,
@ID_ClasCargo  numeric,
@ID_PosCargo  numeric,
@ID_Tipo_Documento  numeric,
@ID_Org  numeric,
@Monto_Desde  numeric,
@Monto_Hasta  numeric,
@ID_Usro_Crea  numeric,
@ID_Usro_Act  numeric,
@Grupo_Aprobacion  varchar(max),
@Vigencia  varchar(1)

AS
SET NOCOUNT ON;

IF @ID_Grupo=0
BEGIN
--- INGRESA NUEVO REGISTRO ---
INSERT INTO Adm_System_Grupo_Aprobacion
(
--ID_Grupo  ,
Fech_Creacion  ,
ID_Holding_Propietario  ,
ID_ClasCargo  ,
ID_PosCargo  ,
ID_Tipo_Documento  ,
ID_Org  ,
Monto_Desde  ,
Monto_Hasta  ,
ID_Usro_Crea  ,
Grupo_Aprobacion  ,
Vigencia  
)
VALUES
(
--@ID_Grupo  ,
GETDATE()   ,
@ID_Holding_Propietario  ,
@ID_ClasCargo  ,
@ID_PosCargo  ,
@ID_Tipo_Documento  ,
@ID_Org  ,
@Monto_Desde  ,
@Monto_Hasta  ,
@ID_Usro_Crea  ,
@Grupo_Aprobacion  ,
@Vigencia  
)

---RETORNO IDENTIFICADOR NUEVO USUARIO---
SELECT @@IDENTITY AS  ID  
END
ELSE
BEGIN
---MODIFICA REGISTRO EXISTENTE---
DECLARE @ID_tabla  int
SET   @ID_tabla  =@ID_Grupo
UPDATE Adm_System_Grupo_Aprobacion
SET 
Fech_Actualiza  =getdate(),
ID_Holding_Propietario  =@ID_Holding_Propietario,
ID_ClasCargo  =@ID_ClasCargo,
ID_PosCargo  =@ID_PosCargo,
ID_Tipo_Documento  =@ID_Tipo_Documento,
ID_Org  =@ID_Org,
Monto_Desde  =@Monto_Desde,
Monto_Hasta  =@Monto_Hasta,
ID_Usro_Act  =@ID_Usro_Act,
Grupo_Aprobacion  =@Grupo_Aprobacion,
Vigencia  =@Vigencia
WHERE
ID_Grupo=@ID_tabla
--- RETORNO FILAS AFECTADAS ---
SELECT @@ROWCOUNT AS FILAS_AFECTADAS
END


GO
