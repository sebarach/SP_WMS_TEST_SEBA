USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_TRANSFERENCIAS_BUSCARSTOCKLOC]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_TRANSFERENCIAS_BUSCARSTOCKLOC 10, 'DSC.0.1.A.3.00', 17
CREATE PROCEDURE [dbo].[INV_TRANSFERENCIAS_BUSCARSTOCKLOC]
	-- Add the parameters for the stored procedure here
	 @ID_SUBINV NUMERIC(18, 0)
	,@COMBINACION_LOCALIZADOR VARCHAR(250)
	,@COD_ITEM NUMERIC(18, 0)
	,@SOURCE VARCHAR(10)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @COD_ITEM = 0 BEGIN
		
		IF @SOURCE = 'origen' BEGIN 
		
			-- Insert statements for procedure here    
			SELECT
				 PROD.COD_ITEM Sku
				,PROD.DESCRIPTOR_CORTA Descriptor
				,LOC.ID_LOCALIZADOR LocalizadorId
				,LOC.COMBINACION_LOCALIZADOR CombinacionLocalizador
				,LOTE.ID_LOTE Lote
				,LOTE.LOTE_PROVEEDOR LoteProveedor
				,ISNULL(CONVERT(VARCHAR(10),CONVERT(DATE,LOTE.FECHA_EXPIRA,106),103), '') FechaVencimiento
				,STOCK.Disponible Cantidad
				,UM.UNIDAD_MEDIDA UnidadManejo
				,LOC.VOLUMEN Volumen
			FROM 
				 Inventario_Stock_Lotes STOCK INNER JOIN
				 Inventario_Lotes LOTE ON stock.ID_Lote = lote.ID_Lote AND 
				 STOCK.ID_Org = LOTE.ID_Org INNER JOIN
				 Inventario_Items PROD ON LOTE.Cod_Item = PROD.Cod_Item AND 
				 LOTE.ID_Org = PROD.ID_Org INNER JOIN
				 Inventario_Unidad_Medida_Primaria UM ON PROD.ID_UM = UM.ID_UM RIGHT OUTER JOIN
				 Inventario_SubInv_Localizadores LOC ON STOCK.ID_Org = LOC.ID_Org AND 
				 STOCK.ID_Localizador = LOC.ID_Localizador
			--Inventario_Stock_Lotes STOCK
		--		INNER JOIN Inventario_SubInv_Localizadores LOC
		--			ON STOCK.ID_Localizador = LOC.ID_LOCALIZADOR AND STOCK.ID_Org = LOC.ID_ORG
		--		INNER JOIN INVENTARIO_LOTES LOTE
		--			ON STOCK.ID_Lote = LOTE.ID_LOTE AND STOCK.ID_ORG = LOTE.ID_ORG 
		--	INNER JOIN Inventario_Items PROD
		--			ON LOTE.COD_ITEM = PROD.COD_ITEM AND LOTE.ID_ORG = PROD.ID_ORG
		--		INNER JOIN Inventario_Unidad_Medida_Primaria UM
		--			ON PROD.ID_UM = UM.ID_UM
			WHERE LOC.COMBINACION_LOCALIZADOR LIKE @COMBINACION_LOCALIZADOR + '%'
				AND LOC.ID_SUBINV = @ID_SUBINV
				AND LOC.ID_Org = @ID_ORG
				AND LOC.Cod_Estado=1
				AND STOCK.Disponible > 0
		END 
		ELSE BEGIN
		
			-- Insert statements for procedure here    
			SELECT
				 PROD.COD_ITEM Sku
				,PROD.DESCRIPTOR_CORTA Descriptor
				,LOC.ID_LOCALIZADOR LocalizadorId
				,LOC.COMBINACION_LOCALIZADOR CombinacionLocalizador
				,LOTE.ID_LOTE Lote
				,LOTE.LOTE_PROVEEDOR LoteProveedor
				,ISNULL(CONVERT(VARCHAR(10),CONVERT(DATE,LOTE.FECHA_EXPIRA,106),103), '') FechaVencimiento
				,STOCK.Disponible Cantidad
				,UM.UNIDAD_MEDIDA UnidadManejo
				,LOC.VOLUMEN Volumen
			FROM 
				 Inventario_Stock_Lotes STOCK INNER JOIN
				 Inventario_Lotes LOTE ON stock.ID_Lote = lote.ID_Lote AND 
				 STOCK.ID_Org = LOTE.ID_Org INNER JOIN
				 Inventario_Items PROD ON LOTE.Cod_Item = PROD.Cod_Item AND 
				 LOTE.ID_Org = PROD.ID_Org INNER JOIN
				 Inventario_Unidad_Medida_Primaria UM ON PROD.ID_UM = UM.ID_UM RIGHT OUTER JOIN
				 Inventario_SubInv_Localizadores LOC ON STOCK.ID_Org = LOC.ID_Org AND 
				 STOCK.ID_Localizador = LOC.ID_Localizador
			--Inventario_Stock_Lotes STOCK
		--		INNER JOIN Inventario_SubInv_Localizadores LOC
		--			ON STOCK.ID_Localizador = LOC.ID_LOCALIZADOR AND STOCK.ID_Org = LOC.ID_ORG
		--		INNER JOIN INVENTARIO_LOTES LOTE
		--			ON STOCK.ID_Lote = LOTE.ID_LOTE AND STOCK.ID_ORG = LOTE.ID_ORG 
		--	INNER JOIN Inventario_Items PROD
		--			ON LOTE.COD_ITEM = PROD.COD_ITEM AND LOTE.ID_ORG = PROD.ID_ORG
		--		INNER JOIN Inventario_Unidad_Medida_Primaria UM
		--			ON PROD.ID_UM = UM.ID_UM
			WHERE LOC.COMBINACION_LOCALIZADOR LIKE @COMBINACION_LOCALIZADOR + '%'
				AND LOC.ID_SUBINV = @ID_SUBINV
				AND LOC.ID_Org = @ID_ORG
				AND LOC.Cod_Estado=1
				--AND STOCK.Disponible > 0		
		
		END
		
		
		
	END 
	ELSE BEGIN 
		
		
		IF @SOURCE = 'origen' BEGIN 
			-- Insert statements for procedure here    
			SELECT
				 PROD.COD_ITEM Sku
				,PROD.DESCRIPTOR_CORTA Descriptor
				,LOC.ID_LOCALIZADOR LocalizadorId
				,LOC.COMBINACION_LOCALIZADOR CombinacionLocalizador
				,LOTE.ID_LOTE Lote
				,LOTE.LOTE_PROVEEDOR LoteProveedor
				,ISNULL(CONVERT(VARCHAR(10),CONVERT(DATE,LOTE.FECHA_EXPIRA,106),103), '') FechaVencimiento
				,STOCK.Disponible Cantidad
				,UM.UNIDAD_MEDIDA UnidadManejo
				,LOC.VOLUMEN Volumen
			FROM 
				 Inventario_Stock_Lotes STOCK INNER JOIN
				 Inventario_Lotes LOTE ON stock.ID_Lote = lote.ID_Lote AND 
				 STOCK.ID_Org = LOTE.ID_Org INNER JOIN
				 Inventario_Items PROD ON LOTE.Cod_Item = PROD.Cod_Item AND 
				 LOTE.ID_Org = PROD.ID_Org INNER JOIN
				 Inventario_Unidad_Medida_Primaria UM ON PROD.ID_UM = UM.ID_UM RIGHT OUTER JOIN
				 Inventario_SubInv_Localizadores LOC ON STOCK.ID_Org = LOC.ID_Org AND 
				 STOCK.ID_Localizador = LOC.ID_Localizador
			--Inventario_Stock_Lotes STOCK
		--		INNER JOIN Inventario_SubInv_Localizadores LOC
		--			ON STOCK.ID_Localizador = LOC.ID_LOCALIZADOR AND STOCK.ID_Org = LOC.ID_ORG
		--		INNER JOIN INVENTARIO_LOTES LOTE
		--			ON STOCK.ID_Lote = LOTE.ID_LOTE AND STOCK.ID_ORG = LOTE.ID_ORG 
		--	INNER JOIN Inventario_Items PROD
		--			ON LOTE.COD_ITEM = PROD.COD_ITEM AND LOTE.ID_ORG = PROD.ID_ORG
		--		INNER JOIN Inventario_Unidad_Medida_Primaria UM
		--			ON PROD.ID_UM = UM.ID_UM
			WHERE LOC.COMBINACION_LOCALIZADOR LIKE @COMBINACION_LOCALIZADOR + '%'
				AND LOC.ID_SUBINV = @ID_SUBINV
				AND LOC.ID_Org = @ID_ORG
				AND LOC.Cod_Estado=1
				AND LOTE.COD_ITEM = @COD_ITEM 	
				AND STOCK.Disponible > 0
		END
		ELSE BEGIN
		
			-- Insert statements for procedure here    
			SELECT
				 PROD.COD_ITEM Sku
				,PROD.DESCRIPTOR_CORTA Descriptor
				,LOC.ID_LOCALIZADOR LocalizadorId
				,LOC.COMBINACION_LOCALIZADOR CombinacionLocalizador
				,LOTE.ID_LOTE Lote
				,LOTE.LOTE_PROVEEDOR LoteProveedor
				,ISNULL(CONVERT(VARCHAR(10),CONVERT(DATE,LOTE.FECHA_EXPIRA,106),103), '') FechaVencimiento
				,STOCK.Disponible Cantidad
				,UM.UNIDAD_MEDIDA UnidadManejo
				,LOC.VOLUMEN Volumen
			FROM 
				 Inventario_Stock_Lotes STOCK INNER JOIN
				 Inventario_Lotes LOTE ON stock.ID_Lote = lote.ID_Lote AND 
				 STOCK.ID_Org = LOTE.ID_Org INNER JOIN
				 Inventario_Items PROD ON LOTE.Cod_Item = PROD.Cod_Item AND 
				 LOTE.ID_Org = PROD.ID_Org INNER JOIN
				 Inventario_Unidad_Medida_Primaria UM ON PROD.ID_UM = UM.ID_UM RIGHT OUTER JOIN
				 Inventario_SubInv_Localizadores LOC ON STOCK.ID_Org = LOC.ID_Org AND 
				 STOCK.ID_Localizador = LOC.ID_Localizador
			--Inventario_Stock_Lotes STOCK
		--		INNER JOIN Inventario_SubInv_Localizadores LOC
		--			ON STOCK.ID_Localizador = LOC.ID_LOCALIZADOR AND STOCK.ID_Org = LOC.ID_ORG
		--		INNER JOIN INVENTARIO_LOTES LOTE
		--			ON STOCK.ID_Lote = LOTE.ID_LOTE AND STOCK.ID_ORG = LOTE.ID_ORG 
		--	INNER JOIN Inventario_Items PROD
		--			ON LOTE.COD_ITEM = PROD.COD_ITEM AND LOTE.ID_ORG = PROD.ID_ORG
		--		INNER JOIN Inventario_Unidad_Medida_Primaria UM
		--			ON PROD.ID_UM = UM.ID_UM
			WHERE LOC.COMBINACION_LOCALIZADOR LIKE @COMBINACION_LOCALIZADOR + '%'
				AND LOC.ID_SUBINV = @ID_SUBINV
				AND LOC.ID_Org = @ID_ORG
				AND LOC.Cod_Estado=1
				AND LOTE.COD_ITEM = @COD_ITEM 		
		
		END
	END 

	/*	
	select * from Inventario_Stock_Lotes
	
	SELECT * FROM Inventario_SubInv_Localizadores
	
	SELECT * FROM Inventario_Unidad_Medida_Primaria
	
	*/
	
	
	
	
END
GO
