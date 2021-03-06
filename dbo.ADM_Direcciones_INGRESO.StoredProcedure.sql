USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_Direcciones_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : Ingresar un nuevo Registro
Parametros
@ID_Direccion  : 
@ID_Org  : 
@ID_Comuna  : 
@ID_Pais  : 
@Calle  : 
@Numero  : 
@Observaciones  : 
@Direccion_Completa  : 
Creado : 10/04/2017.
Modifado : 1.
***********************************************
--Forma de Invocar.
***********************************************
WMS_MAN_ 
***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_Direcciones_INGRESO]
@ID_Direccion  int,
@ID_Org  numeric,
@ID_Comuna  numeric,
@ID_Pais  numeric,
@Calle  varchar(max),
@Numero  varchar(50),
@Observaciones  varchar(max),
@Direccion_Completa  varchar(max)
AS
SET NOCOUNT ON;
IF @ID_Direccion=0
BEGIN
--- INGRESA NUEVO REGISTRO ---
INSERT INTO Adm_System_Direcciones
(
--ID_Direccion  ,
ID_Org  ,
ID_Comuna  ,
ID_Pais  ,
Calle  ,
Numero  ,
Observaciones  ,
Direccion_Completa  
)
VALUES
(
--@ID_Direccion  ,
@ID_Org  ,
@ID_Comuna  ,
@ID_Pais  ,
@Calle  ,
@Numero  ,
@Observaciones  ,
@Direccion_Completa  
)
---RETORNO IDENTIFICADOR NUEVO USUARIO---
SELECT @@IDENTITY AS  ID  
END
ELSE
BEGIN
---MODIFICA REGISTRO EXISTENTE---
DECLARE @ID_tabla  int
SET   @ID_tabla  =@ID_Direccion

UPDATE Adm_System_Direcciones
SET 
ID_Org  =@ID_Org,
ID_Comuna  =@ID_Comuna,
ID_Pais  =@ID_Pais,
Calle  =@Calle,
Numero  =@Numero,
Observaciones  =@Observaciones,
Direccion_Completa  =@Direccion_Completa
WHERE

ID_Direccion=@ID_tabla

--- RETORNO IDENTIFICADOR NUEVO USUARIO ---
SELECT @@ROWCOUNT FILAS_AFECTADAS


END

GO
