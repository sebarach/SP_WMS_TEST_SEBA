USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_COMUNAS_DDL]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADM_COMUNAS_DDL]
	-- Add the parameters for the stored procedure here
	@ID_PROVINCIA NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here   

	SELECT C.ID_Comuna VALOR, C.Nombre ELEMENTO
	FROM Adm_System_Comunas C
	WHERE ID_PROVINCIA = @ID_PROVINCIA
	ORDER BY ELEMENTO ASC   
    

    
    --SELECT * FROM Adm_System_Dueños
    
    --SELECT * FROM Adm_System_Contactos

	
END
GO
