USE [iwmscl_testwms2]
GO
/****** Object:  StoredProcedure [dbo].[ADM_PROVINCIAS_DDL]    Script Date: 20-07-2020 11:56:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADM_PROVINCIAS_DDL]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here   

	SELECT C.ID_Provincia VALOR, C.Nombre ELEMENTO
	FROM Adm_System_Provincias C
	ORDER BY ELEMENTO ASC   
    
    --SELECT * FROM Adm_System_Dueños
    
    --SELECT * FROM Adm_System_Contactos

	
END


GO
