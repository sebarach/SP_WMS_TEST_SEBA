USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_CATEG_FAMILIA_DDL]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_CATEG_FAMILIA_DDL]
	-- Add the parameters for the stored procedure here
	 @ID_HOLDING NUMERIC(18, 0)
	,@ID_DUENO NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here   

	IF @ID_DUENO > 0 BEGIN

		SELECT DISTINCT C.Cod_Categ1 VALOR, C.Nombre_Categ1 ELEMENTO
		FROM Inventario_Categoria1 C
			INNER JOIN INVENTARIO_ITEMS PROD
				ON C.Cod_Categ1 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 1, 4)
			INNER JOIN Inventario_Items_Prop_Dueños PD
				ON PROD.COD_ITEM = PD.COD_ITEM AND PROD.ID_ORG = PD.ID_ORG			
		WHERE C.Vigente = 'S'
			AND PROD.ID_ORG = @ID_ORG
			AND PD.ID_PROPIETARIO = @ID_HOLDING 
			AND PD.ID_DUEÑO = @ID_DUENO
		ORDER BY ELEMENTO ASC   

    END 
    ELSE BEGIN 
    
		SELECT DISTINCT C.Cod_Categ1 VALOR, C.Nombre_Categ1 ELEMENTO
		FROM Inventario_Categoria1 C
			INNER JOIN INVENTARIO_ITEMS PROD
				ON C.Cod_Categ1 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 1, 4)
			INNER JOIN Inventario_Items_Prop_Dueños PD
				ON PROD.COD_ITEM = PD.COD_ITEM AND PROD.ID_ORG = PD.ID_ORG			
		WHERE C.Vigente = 'S'
			AND PROD.ID_ORG = @ID_ORG
			AND PD.ID_PROPIETARIO = @ID_HOLDING 
		ORDER BY ELEMENTO ASC     
    
    END 
    --SELECT * FROM Adm_System_Dueños
    
    --SELECT * FROM Adm_System_Contactos
	
	--SELECT * FROM dbo.Inventario_Items_Prop_Dueños
	
END
GO
