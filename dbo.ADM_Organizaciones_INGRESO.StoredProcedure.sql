USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_Organizaciones_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : Ingresar un nuevo Registro
Parametros
@ID_Org  : 
@Fech_Creacion  : 
@Fech_Actualiza  : 
@ID_Org_Padre  : 
@ID_Direccion  : 
@ID_Usro_Crea  : 
@ID_Usro_Act  : 
@Nombre  : 
@Vigencia  : 
Creado : 10/04/2017.
Modifado : 1.
***********************************************
--Forma de Invocar.
***********************************************
WMS_MAN_ 
***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_Organizaciones_INGRESO]
@ID_Org  int,
@Fech_Creacion  datetime,
@Fech_Actualiza  datetime,
@ID_Org_Padre  numeric,
@ID_Direccion  numeric,
@ID_Usro_Crea  numeric,
@ID_Usro_Act  numeric,
@Nombre  varchar(max),
@Vigencia  varchar(max)
AS
SET NOCOUNT ON;
IF @ID_Org=0
BEGIN
--- INGRESA NUEVO REGISTRO ---
INSERT INTO Adm_System_Organizaciones
(
--ID_Org  ,
Fech_Creacion  ,
Fech_Actualiza  ,
ID_Org_Padre  ,
ID_Direccion  ,
ID_Usro_Crea  ,
ID_Usro_Act  ,
Nombre  ,
Vigencia  
)
VALUES
(
--@ID_Org  ,
@Fech_Creacion  ,
@Fech_Actualiza  ,
@ID_Org_Padre  ,
@ID_Direccion  ,
@ID_Usro_Crea  ,
@ID_Usro_Act  ,
@Nombre  ,
@Vigencia  
)
---RETORNO IDENTIFICADOR NUEVO USUARIO---
SELECT @@IDENTITY AS  NUEVOID  , 'AGREGO' AS ACCION
END
ELSE
BEGIN
---MODIFICA REGISTRO EXISTENTE---
DECLARE @ID_tabla  int
SET   @ID_tabla  =@ID_Org
UPDATE Adm_System_Organizaciones
SET 
--ID_Org  =@ID_Org,
Fech_Creacion  =@Fech_Creacion,
Fech_Actualiza  =@Fech_Actualiza,
ID_Org_Padre  =@ID_Org_Padre,
ID_Direccion  =@ID_Direccion,
ID_Usro_Crea  =@ID_Usro_Crea,
ID_Usro_Act  =@ID_Usro_Act,
Nombre  =@Nombre,
Vigencia  =@Vigencia
WHERE
ID_Org=@ID_tabla
--- RETORNO IDENTIFICADOR NUEVO USUARIO ---
SELECT  @ID_Org AS NUEVOID , 'MODIFICO' AS ACCION
END

GO
