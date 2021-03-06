USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_AsigGrpAprob_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : Ingresar un nuevo Registro
Parametros
@Fech_Creacion  : 
@Fech_Actualiza  : 
@ID_Grupo  : 
@ID_Holding_Propietario  : 
@ID_Dueño  : 
@ID_Org  : 
@ID_Usro_Crea  : 
@ID_Usro_Act  : 
@Vigencia  : 
Creado : 15/04/2017.
Modifado : 1.
***********************************************
--Forma de Invocar.
***********************************************
WMS_MAN_ 
***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_AsigGrpAprob_INGRESO]
@ID_Grupo  numeric,
@ID_Holding_Propietario  numeric,
@ID_Dueño  numeric,
@ID_Org  numeric,
@ID_Usro_Crea  numeric,
@Vigencia  varchar(1)

AS
SET NOCOUNT ON;
BEGIN
	--- INGRESA NUEVO REGISTRO ---
	INSERT INTO Adm_System_Asignacion_Grupo_Aprobacion
	(
	Fech_Creacion  ,
	ID_Grupo  ,
	ID_Holding_Propietario  ,
	ID_Dueño  ,
	ID_Org  ,
	ID_Usro_Crea  ,
	Vigencia  
	)
	VALUES
	(
	GETDATE()  ,
	@ID_Grupo  ,
	@ID_Holding_Propietario  ,
	@ID_Dueño  ,
	@ID_Org  ,
	@ID_Usro_Crea  ,
	@Vigencia 	
	)
	
	---RETORNO IDENTIFICADOR NUEVO REGISTRO---
	SELECT @@ROWCOUNT AS ID 
	



END


GO
