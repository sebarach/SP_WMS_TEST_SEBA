USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_PROPDUENOS_DDL]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_PROPDUENOS_DDL]
	-- Add the parameters for the stored procedure here
	@ID_PROP NUMERIC(18, 0),
	@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here   

	SELECT D.ID_DUEÑO VALOR, ISNULL(C.NOMBRES, '') + ' ' + ISNULL(C.APELLIDO_PATERNO, '') + ' ' + ISNULL(C.APELLIDO_MATERNO, '') ELEMENTO 
	FROM Adm_System_Dueños D
		INNER JOIN Adm_System_Contactos C
			ON D.ID_CONTACTO = C.ID_CONTACTO
	WHERE D.ID_ORG = @ID_ORG
		AND D.ID_HOLDING_PROPIETARIO = @ID_PROP
		AND D.VIGENCIA = 'S'
		AND C.VIGENCIA = 'S'
	ORDER BY ELEMENTO ASC   
    
    --SELECT * FROM Adm_System_Dueños
    
    --SELECT * FROM Adm_System_Contactos

	
END
GO
