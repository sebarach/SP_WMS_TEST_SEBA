USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_ContactosHolding_UPDATE]    Script Date: 19-08-2020 16:12:38 ******/
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

CREATE PROCEDURE [dbo].[ADM_ContactosHolding_UPDATE]
@ID_Holding  numeric,
@ID_Contacto  numeric,
@IsPrincipal  int,
@ID_Usro_Crea  numeric,
@ID_Usro_Act  numeric,
@Vigencia  varchar(1)
AS
BEGIN
SET NOCOUNT ON;

	---MODIFICA REGISTRO EXISTENTE---
	UPDATE Adm_System_Contactos_Holding
	SET 
	IsPrincipal  =@IsPrincipal,
	Fech_Actualiza  =GETDATE(),
	ID_Holding  =@ID_Holding,
	ID_Contacto  =@ID_Contacto,
	ID_Usro_Act  =@ID_Usro_Act,
	Vigencia  =@Vigencia
	WHERE
	ID_Holding  = @ID_Holding
	and ID_Contacto = @ID_Contacto

	--- RETORNO FILAS  AFECTADAS ---
	SELECT @@ROWCOUNT AS FILAS_AFECTADAS 


END


GO
