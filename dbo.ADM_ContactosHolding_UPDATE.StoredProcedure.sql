USE [iwmscl_testwms2]
GO
/****** Object:  StoredProcedure [dbo].[ADM_ContactosHolding_UPDATE]    Script Date: 20-07-2020 11:56:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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
