USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[Adm_Contactos_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : Ingresar un nuevo Registro
Parametros
@ID_Contacto  : 
@Fech_Creacion  : 
@Fech_Actualiza  : 
@ID_Org  : 
@ID_Usro_Crea  : 
@ID_Usro_Act  : 
@Nombres  : 
@Apellido_Paterno  : 
@Apellido_Materno  : 
@Fono  : 
@Celular  : 
@Correo  : 
@Nombre_Completo  : 
@Vigencia  : 
Creado : 10/04/2017.
Modifado : 1.
***********************************************
--Forma de Invocar.
***********************************************
***********************************************
*/
CREATE PROCEDURE [dbo].[Adm_Contactos_INGRESO]
@ID_Contacto  int,
@ID_Org  numeric,
@ID_Usro_Crea  numeric,
@ID_Usro_Act  numeric,
@Nombres  varchar(max),
@Apellido_Paterno  varchar(max),
@Apellido_Materno  varchar(max),
@Fono  varchar(max),
@Celular  varchar(max),
@Correo  varchar(max),
@Nombre_Completo  varchar(max),
@Vigencia  varchar(1),
@ID_Usro numeric
AS

SET NOCOUNT ON;
IF @ID_Contacto=0
BEGIN
--- INGRESA NUEVO REGISTRO ---
INSERT INTO Adm_System_Contactos
(
--ID_Contacto  ,
Fech_Creacion  ,
ID_Org  ,
ID_Usro_Crea  ,
Nombres  ,
Apellido_Paterno  ,
Apellido_Materno  ,
Fono  ,
Celular  ,
Correo  ,
Nombre_Completo  ,
Vigencia,
ID_Usro  
)
VALUES
(
--@ID_Contacto  ,
GETDATE()  ,
@ID_Org  ,
@ID_Usro_Crea  ,
@Nombres  ,
@Apellido_Paterno  ,
@Apellido_Materno  ,
@Fono  ,
@Celular  ,
@Correo  ,
@Nombre_Completo  ,
@Vigencia ,
@ID_Usro 
)
---RETORNO IDENTIFICADOR NUEVO USUARIO---
SELECT @@IDENTITY AS  ID  
END
ELSE
BEGIN
---MODIFICA REGISTRO EXISTENTE---
DECLARE @ID_tabla  int
SET   @ID_tabla  =@ID_Contacto
UPDATE Adm_System_Contactos
SET 
Fech_Actualiza  =GETDATE(),
ID_Org  =@ID_Org,
ID_Usro_Act  =@ID_Usro_Act,
Nombres  =@Nombres,
Apellido_Paterno  =@Apellido_Paterno,
Apellido_Materno  =@Apellido_Materno,
Fono  =@Fono,
Celular  =@Celular,
Correo  =@Correo,
Nombre_Completo  =@Nombre_Completo,
Vigencia  =@Vigencia,
ID_Usro = @ID_Usro
WHERE
ID_Contacto=@ID_tabla
--- RETORNO IDENTIFICADOR NUEVO USUARIO ---
	SELECT @@ROWCOUNT AS FILAS_AFECTADAS
END


GO
