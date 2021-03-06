USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_ContactosHolding_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : Ingresar un nuevo Registro
Parametros
@IsPrincipal  : 
@Fech_Creacion  : 
@Fech_Actualiza  : 
@ID_Holding  : 
@ID_Contacto  : 
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

CREATE PROCEDURE [dbo].[ADM_ContactosHolding_INGRESO]
@ID_Holding  numeric,
@ID_Contacto  numeric,
@IsPrincipal  int,
@ID_Usro_Crea  numeric,
@ID_Usro_Act  numeric,
@Vigencia  varchar(1)
AS
BEGIN
SET NOCOUNT ON;

	--- INGRESA NUEVO REGISTRO ---
	INSERT INTO Adm_System_Contactos_Holding
	(
	IsPrincipal  ,
	Fech_Creacion  ,
	Fech_Actualiza  ,
	ID_Holding  ,
	ID_Contacto  ,
	ID_Usro_Crea  ,
	ID_Usro_Act  ,
	Vigencia  
	)
	VALUES

	(
	@IsPrincipal  ,
	GETDATE()  ,
	GETDATE() ,
	@ID_Holding  ,
	@ID_Contacto  ,
	@ID_Usro_Crea  ,
	@ID_Usro_Act  ,
	@Vigencia  
	);

	---RETORNO IDENTIFICADOR NUEVO USUARIO---
	SELECT @@ROWCOUNT AS ID 

END
GO
