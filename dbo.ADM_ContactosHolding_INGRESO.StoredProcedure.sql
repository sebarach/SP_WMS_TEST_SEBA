USE [iwmscl_testwms2]
GO
/****** Object:  StoredProcedure [dbo].[ADM_ContactosHolding_INGRESO]    Script Date: 20-07-2020 11:56:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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
