USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_CAMBIODUENO_PRODUCTOSLISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_CAMBIODUENO_PRODUCTOSLISTAR]
	-- Add the parameters for the stored procedure here
	 @PROPIETARIO_ID NUMERIC(18, 0)
	,@DUENO_ID NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT 
			PROD.COD_ITEM SKU
			,PROD.DESCRIPTOR_CORTA DESCRIPTOR
		FROM Inventario_Items PROD
		INNER JOIN Inventario_Items_Prop_Dueños PROPDUENO
			ON PROD.COD_ITEM = PROPDUENO.COD_ITEM AND PROD.ID_ORG = PROPDUENO.ID_ORG		
		WHERE PROD.ID_ORG = @ID_ORG
			AND PROPDUENO.ID_Propietario = @PROPIETARIO_ID
			AND PROPDUENO.ID_Dueño = @DUENO_ID
		ORDER BY PROD.DESCRIPTOR_CORTA ASC

END
GO
