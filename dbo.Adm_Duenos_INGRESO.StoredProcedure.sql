USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[Adm_Duenos_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : Ingresar un nuevo Registro
Parametros
@ID_Dueño  : 
@Fech_Creacion  : 
@Fech_Actualiza  : 
@ID_Contacto  : 
@ID_Org  : 
@ID_Holding_Propietario  : 
@ID_Cargo  : 
@ID_Usro_Crea  : 
@ID_Usro_Act  : 
@Vigencia  : 
Creado : 10/04/2017.
Modifado : 1.
***********************************************
--Forma de Invocar.
***********************************************
WMS_MAN_ 
***********************************************
*/
CREATE PROCEDURE [dbo].[Adm_Duenos_INGRESO]
@ID_Dueño  int,
@ID_Contacto  numeric,
@ID_Org  numeric,
@ID_Holding_Propietario  numeric,
@ID_Cargo  numeric,
@ID_Usro_Crea  numeric,
@ID_Usro_Act  numeric,
@Vigencia  varchar(1)
AS
SET NOCOUNT ON;
IF @ID_Dueño=0
BEGIN
--- INGRESA NUEVO REGISTRO ---
INSERT INTO Adm_System_Dueños
(
--ID_Dueño  ,
Fech_Creacion  ,
ID_Contacto  ,
ID_Org  ,
ID_Holding_Propietario  ,
ID_Cargo  ,
ID_Usro_Crea  ,
Vigencia  
)
VALUES
(
--@ID_Dueño  ,
GETDATE()  ,
@ID_Contacto  ,
@ID_Org  ,
@ID_Holding_Propietario  ,
@ID_Cargo  ,
@ID_Usro_Crea  ,
@Vigencia  
)
---RETORNO NUEVO IDENTIFICADOR ---
	SELECT @@IDENTITY AS ID  
END 

ELSE

BEGIN
---MODIFICA REGISTRO EXISTENTE---
DECLARE @ID_tabla  int
SET   @ID_tabla  =@ID_Dueño
UPDATE Adm_System_Dueños
SET 
--ID_Dueño  =@ID_Dueño,
Fech_Actualiza  =GETDATE(),
ID_Contacto  =@ID_Contacto,
ID_Org  =@ID_Org,
ID_Holding_Propietario  =@ID_Holding_Propietario,
ID_Cargo  =@ID_Cargo,
ID_Usro_Act  =@ID_Usro_Act,
Vigencia  =@Vigencia
WHERE
ID_Dueño=@ID_tabla

--- RETORNO IDENTIFICADOR NUEVO USUARIO ---

SELECT @@ROWCOUNT AS FILAS_AFECTADAS
END


GO
