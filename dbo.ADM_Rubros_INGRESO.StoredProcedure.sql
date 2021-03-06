USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_Rubros_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : Ingresar un nuevo Registro
Parametros
@ID_Rubro  : 
@ID_Org  : 
@Descripcion  : 
@Vigencia  : 
Creado : 16/04/2017.
Modifado : 1.
***********************************************
--Forma de Invocar.
***********************************************
WMS_MAN_ 
***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_Rubros_INGRESO]
@ID_Rubro  int,
@ID_Org  numeric,
@Descripcion  varchar(max),
@Vigencia  varchar(1)
AS
SET NOCOUNT ON;
IF @ID_Rubro=0
BEGIN
--- INGRESA NUEVO REGISTRO ---
INSERT INTO Adm_System_Rubros
(
--ID_Rubro  ,
ID_Org  ,
Descripcion  ,
Vigencia  
)
VALUES
(
--@ID_Rubro  ,
@ID_Org  ,
@Descripcion  ,
@Vigencia  
)
---RETORNO IDENTIFICADOR NUEVO USUARIO---
SELECT @@IDENTITY AS ID 
END
ELSE
BEGIN
---MODIFICA REGISTRO EXISTENTE---
DECLARE @ID_tabla  int
SET   @ID_tabla  =@ID_Rubro
UPDATE Adm_System_Rubros
SET 
--ID_Rubro  =@ID_Rubro,
ID_Org  =@ID_Org,
Descripcion  =@Descripcion,
Vigencia  =@Vigencia
WHERE
ID_Rubro=@ID_tabla
--- RETORNO FILAS AFECTADAS ---
SELECT @@ROWCOUNT AS  FILAS_AFECTADAS
END

GO
