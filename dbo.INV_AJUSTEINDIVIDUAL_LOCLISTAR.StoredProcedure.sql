USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_AJUSTEINDIVIDUAL_LOCLISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[INV_AJUSTEINDIVIDUAL_LOCLISTAR]
	-- Add the parameters for the stored procedure here	
	 @LOCALIZADOR VARCHAR(50)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--DECLARE @LOCALIZADOR VARCHAR(50), @ID_ORG NUMERIC(18, 0)
	--SET @LOCALIZADOR = ''
	--SET @ID_ORG = 17
	
    -- Insert statements for procedure here
    /*
    SELECT * FROM Inventario_Lotes
	SELECT * FROM Inventario_Items_Prop_Dueños
	SELECT * FROM Inventario_Items
	SELECT * FROM dbo.Adm_System_Holding
	SELECT * FROM dbo.Adm_System_Dueños
	SELECT * FROM Adm_System_Contactos   
	SELECT * FROM Inventario_Stock_Lotes 
	SELECT * FROM Inventario_SubInv_Localizadores
	SELECT * FROM Inventario_SubInventarios
    */
    
	SELECT
		 SUBINV.ID_SUBINV SubInventarioFisicoId
		,SUBINV.DESCRIPCION SubInventarioFisico
		,LOC.ID_LOCALIZADOR LocalizadorFisicoId
		,LOC.COMBINACION_LOCALIZADOR LocalizadorFisico
	FROM Inventario_SubInv_Localizadores LOC
		INNER JOIN Inventario_SubInventarios SUBINV
			ON LOC.ID_SUBINV = SUBINV.ID_SUBINV
	WHERE LOC.ID_ORG = @ID_ORG
		--AND LOC.COD_TIPO_SUBINV = 200
		AND LOC.COMBINACION_LOCALIZADOR LIKE + @LOCALIZADOR + '%'
	

	
END
GO
