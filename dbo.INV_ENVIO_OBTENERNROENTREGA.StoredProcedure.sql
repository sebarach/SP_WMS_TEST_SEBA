USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_ENVIO_OBTENERNROENTREGA]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_ENVIO_OBTENERNROENTREGA 17
CREATE PROCEDURE [dbo].[INV_ENVIO_OBTENERNROENTREGA]
	-- Add the parameters for the stored procedure here
	 --@ID_DUENO NUMERIC(18, 0)
	--,
	@ID_Org NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--DECLARE @DESTINATARIO VARCHAR(200)
	
	--SET @DESTINATARIO = (SELECT NOMBRE FROM Adm_System_Holding 
	--					WHERE ID_DIRECCION = @ID_DUENO
	--						AND ESPROPIETARIO = 0
	--						AND VIGENCIA = 'S')
	
    -- Insert statements for procedure here
	--SELECT * FROM Inventario_Folios_Todos
	UPDATE Inventario_Folios_Todos
		SET Folio_Num_Entrega = Folio_Num_Entrega + 1
	WHERE ID_Org = @ID_Org;
	
	SELECT (Folio_Num_Entrega - 1) Folio_Num_Entrega --, @DESTINATARIO DESTINATARIO
	FROM dbo.Inventario_Folios_Todos
	WHERE ID_Org = @ID_Org	
	
END
GO
