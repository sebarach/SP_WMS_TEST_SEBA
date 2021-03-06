USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_CargosDueños_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : Ingresar un nuevo Registro
Parametros
@ID_Cargo  : 
@Fech_Creacion  : 
@Fech_Actualiza  : 
@ID_Org  : 
@ID_Usro_Crea  : 
@ID_Usro_Act  : 
@Descripcion  : 
@Vigencia  : 
Creado : 10/04/2017.
Modifado : 1.
***********************************************
--Forma de Invocar.
***********************************************
***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_CargosDueños_INGRESO]
@ID_Cargo  int,
@ID_Org  numeric,
@ID_Usro_Crea  numeric,
@ID_Usro_Act  numeric,
@Descripcion  varchar(max),
@Vigencia  varchar(1)
AS
SET NOCOUNT ON;
IF @ID_Cargo=0
BEGIN
--- INGRESA NUEVO REGISTRO ---
INSERT INTO Adm_System_Cargos_Dueños
(
--ID_Cargo  ,
Fech_Creacion  ,
ID_Org  ,
ID_Usro_Crea  ,
Descripcion  ,
Vigencia  
)

VALUES

(
-- @ID_Cargo,
GETDATE() ,
@ID_Org  ,
@ID_Usro_Crea  ,
@Descripcion  ,
@Vigencia  

)
--- RETORNO IDENTIFICADOR NUEVO CARGO ---
SELECT @@IDENTITY AS  ID  
END
ELSE
BEGIN
---MODIFICA REGISTRO EXISTENTE---
DECLARE @ID_tabla  int
SET   @ID_tabla  =@ID_Cargo
UPDATE Adm_System_Cargos_Dueños
SET 
--ID_Cargo  =@ID_Cargo,
Fech_Actualiza  =GETDATE(),
ID_Org  =@ID_Org,
ID_Usro_Act  =@ID_Usro_Act,
Descripcion  =@Descripcion,
Vigencia  =@Vigencia
WHERE
ID_Cargo=@ID_tabla
--- RETORNO FILAS AFECTADAS ---
 SELECT @@ROWCOUNT AS FILAS_AFECTADAS 
END


GO
