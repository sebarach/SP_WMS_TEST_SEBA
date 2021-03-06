USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_PerfilesUsuarios_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : Ingresar un nuevo Registro
Parametros
@ID_Perfil  : 
@Fech_Creacion  : 
@Fech_Actualiza  : 
@ID_Usro  : 
@ID_TipoUsro  : 
@ID_Origen  : 
@ID_Org  : 
@ID_Usro_Crea  : 
@Nombre  : 
@Vigencia  : 
Creado : 15/04/2017.
Modifado : 1.
***********************************************
--Forma de Invocar.
***********************************************
***********************************************
*/

CREATE PROCEDURE [dbo].[ADM_PerfilesUsuarios_INGRESO]
@ID_Perfil  int,
@ID_Usro  numeric,
@ID_TipoUsro  numeric,
@ID_Origen  numeric,
@ID_Org  numeric,
@ID_Usro_Crea  numeric,
@Nombre  varchar(MAX),
@Vigencia  varchar(1)

AS
SET NOCOUNT ON;

IF @ID_Perfil=0
BEGIN
--- INGRESA NUEVO REGISTRO ---
INSERT INTO Adm_System_Perfiles_Usuarios
(
--ID_Perfil  ,
Fech_Creacion  ,
Fech_Actualiza  ,
ID_Usro  ,
ID_TipoUsro  ,
ID_Origen  ,
ID_Org  ,
ID_Usro_Crea  ,
Nombre  ,
Vigencia  
)
VALUES
(
--@ID_Perfil  ,
GETDATE()  ,
GETDATE()  ,
@ID_Usro  ,
@ID_TipoUsro  ,
@ID_Origen  ,
@ID_Org  ,
@ID_Usro_Crea  ,
@Nombre  ,
@Vigencia  
)
---RETORNO IDENTIFICADOR NUEVO USUARIO---
SELECT @@IDENTITY AS  ID  
END
ELSE
BEGIN
---MODIFICA REGISTRO EXISTENTE---
DECLARE @ID_tabla  int
SET   @ID_tabla  =@ID_Perfil
UPDATE Adm_System_Perfiles_Usuarios
SET 
-- ID_Perfil  =@ID_Perfil,
Fech_Actualiza  =GETDATE(),
ID_Usro  =@ID_Usro,
ID_TipoUsro  =@ID_TipoUsro,
ID_Origen  =@ID_Origen,
ID_Org  =@ID_Org,
ID_Usro_Crea  =@ID_Usro_Crea,
Nombre  =@Nombre,
Vigencia  =@Vigencia
WHERE
ID_Perfil=@ID_tabla

--- RETORNO FILAS AFECTADAS ---
SELECT @@ROWCOUNT AS FILAS_AFECTADAS

END



GO
