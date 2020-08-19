USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_GUIAS_FOLIOS]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_GUIAS_FOLIOS]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT (SELECT Ultimo_Folio FOLIO FROM Inventario_Tipo_Documentos WHERE Id_Docu = 40) FOLIO_INT, 
		(SELECT Ultimo_Folio FOLIO FROM Inventario_Tipo_Documentos WHERE Id_Docu = 50) FOLIO_EXT, 
		(SELECT Ultimo_Folio FOLIO FROM Inventario_Tipo_Documentos WHERE Id_Docu = 60) FOLIO_EXT2 	
	
END
GO
