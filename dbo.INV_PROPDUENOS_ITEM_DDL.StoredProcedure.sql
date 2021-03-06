USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_PROPDUENOS_ITEM_DDL]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_PROPDUENOS_ITEM_DDL]
	-- Add the parameters for the stored procedure here
	@ID_PROP NUMERIC(18, 0),
	@ID_DUENO NUMERIC(18, 0),
	@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here   

	SELECT P.Cod_Item VALOR, CAST(P.Cod_Item AS VARCHAR(20)) + ' - ' + P.Descriptor_corta ELEMENTO
	FROM Inventario_Items_Prop_Dueños PD
		INNER JOIN Inventario_Items P
			ON PD.COD_ITEM = P.COD_ITEM AND PD.ID_Org = P.ID_ORG
	WHERE PD.ID_ORG = @ID_ORG
		AND PD.ID_PROPIETARIO = @ID_PROP
		AND PD.ID_Dueño = @ID_DUENO		
	ORDER BY ELEMENTO ASC   
    
    --SELECT * FROM Inventario_Items_Prop_Dueños
    
    --SELECT * FROM Inventario_Items
    
    --SELECT * FROM Adm_System_Dueños
    
    --SELECT * FROM Adm_System_Contactos

	
END
GO
