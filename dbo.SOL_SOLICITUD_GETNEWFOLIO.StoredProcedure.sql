USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[SOL_SOLICITUD_GETNEWFOLIO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SOL_SOLICITUD_GETNEWFOLIO]
	-- Add the parameters for the stored procedure here	
	@Id_Docu NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT MAX(Ultimo_Folio) + 1 NUEVO_FOLIO
    FROM dbo.Inventario_Tipo_Documentos
    WHERE Id_Docu = @Id_Docu

	/*	
    SELECT MAX(Ultimo_Folio) + 1 FROM dbo.Inventario_Tipo_Documentos
    WHERE Id_Docu = 10
	*/
	
END
GO
