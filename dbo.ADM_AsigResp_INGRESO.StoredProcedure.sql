USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_AsigResp_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : Ingresar un nuevo Registro
Parametros
@ID_Asignacion  : 
@Fech_Creacion  : 
@Fech_Actualiza  : 
@ID_SubResp  : 
@ID_Perfil  : 
@ID_Usro_Crea  : 
@ID_Usro_Act  : 
@Vigencia  : 
Creado : 10/04/2017.
Modifado : 1.
***********************************************
--Forma de Invocar.
***********************************************
***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_AsigResp_INGRESO]
@ID_Asignacion  int,
@ID_SubResp  numeric,
@ID_Perfil  numeric,
@ID_Usro_Crea  numeric,
@ID_Usro_Act  numeric,
@Vigencia  varchar(1)
AS
SET NOCOUNT ON;
IF @ID_Asignacion=0
BEGIN
--- INGRESA NUEVO REGISTRO ---
INSERT INTO Adm_System_Asignacion_Responsabilidades
(
--ID_Asignacion  ,
Fech_Creacion  ,
Fech_Actualiza  ,
ID_SubResp  ,
ID_Perfil  ,
ID_Usro_Crea  ,
ID_Usro_Act  ,
Vigencia  
)
VALUES
(
--@ID_Asignacion  ,
GETDATE()  ,
GETDATE() ,
@ID_SubResp  ,
@ID_Perfil  ,
@ID_Usro_Crea  ,
@ID_Usro_Act  ,
@Vigencia  
)
---RETORNO IDENTIFICADOR NUEVO ASIG---
SELECT @@IDENTITY AS ID  
END
ELSE
BEGIN
---MODIFICA REGISTRO EXISTENTE---
DECLARE @ID_tabla  int
SET   @ID_tabla  = @ID_Asignacion
UPDATE Adm_System_Asignacion_Responsabilidades
SET 
--ID_Asignacion  =@ID_Asignacion,
Fech_Actualiza  = GETDATE(),
ID_SubResp  = @ID_SubResp,
ID_Perfil  = @ID_Perfil,
ID_Usro_Act  = @ID_Usro_Act,
Vigencia  = @Vigencia

WHERE
ID_Asignacion= @ID_tabla
--- RETORNO FILAS AFECTADAS ---
SELECT @@ROWCOUNT AS  FILAS_AFECTADAS

END



GO
