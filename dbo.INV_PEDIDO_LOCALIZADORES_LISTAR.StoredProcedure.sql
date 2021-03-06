USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_PEDIDO_LOCALIZADORES_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_PEDIDO_LOCALIZADORES_LISTAR 21, 2783, 'DSC.0.1.S.2.042', '201705000033', 17, 40
CREATE PROCEDURE [dbo].[INV_PEDIDO_LOCALIZADORES_LISTAR] 
	-- Add the parameters for the stored procedure here
	 @ID_NROPEDIDO NUMERIC(18, 0)
	,@ID_LOCALIZADOR NUMERIC(18, 0)
	,@COMBINACION_LOCALIZADOR VARCHAR(50)
	,@ID_LOTE VARCHAR(50)
	,@ID_ORG NUMERIC(18, 0)	
	,@CANTIDAD NUMERIC(18, 3)
	,@LINEA NUMERIC(18, 3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @PRODUCTOID NUMERIC(18, 0) = (SELECT COD_ITEM FROM Inventario_Lotes WHERE ID_LOTE = @ID_LOTE)
	
	IF (@LINEA = 0) BEGIN
		
		SELECT --*
			 STOCK.ID_LOTE
			--,CASE
			--	WHEN STOCK.ID_LOTE = @ID_LOTE AND LOC.ID_LOCALIZADOR = @ID_LOCALIZADOR THEN (STOCK.DISPONIBLE + @CANTIDAD)
			--	ELSE STOCK.DISPONIBLE 
			-- END cantidadpickeada
			,STOCK.DISPONIBLE cantidadpickeada
			,LOTE.FECHA_ORIGEN
			--,LOTE.FECHA_EXPIRA
			,LOTE.COD_ITEM
			,LOC.ID_LOCALIZADOR
			,LOC.COMBINACION_LOCALIZADOR
			,LOC.SEGMENTO1 --ORGANIZACION 
			,LOC.SEGMENTO2 --ZONA
			,LOC.SEGMENTO3 --SUBZONA
			,LOC.SEGMENTO4 --PASILLO
			,LOC.SEGMENTO5 --FILA
			,LOC.SEGMENTO6 --COLUMNA
			,0 SUGERIDO
			,LOTE.LOTE_PROVEEDOR
			,ISNULL(Convert(varchar(10),CONVERT(date,LOTE.Fecha_Expira,106),103), '') Fecha_Expira --Fecha vencimiento		
		FROM Inventario_Stock_Lotes STOCK
			INNER JOIN Inventario_Lotes LOTE
				ON STOCK.ID_Lote = LOTE.ID_Lote AND STOCK.ID_ORG = LOTE.ID_ORG 
			INNER JOIN Inventario_SubInv_Localizadores LOC
				ON STOCK.ID_LOCALIZADOR = LOC.ID_LOCALIZADOR AND STOCK.ID_ORG = LOC.ID_ORG 			
		WHERE 
			STOCK.Disponible > 0 
		AND STOCK.ID_ORG = @ID_Org
		AND LOC.COD_ESTADO = 1
		AND LOC.VIGENCIA = 'S'
		--AND LOC.COD_TIPO_SUBINV = 200
		AND LOC.ID_LOCALIZADOR <> 2791
		AND LOTE.Cod_Item = @PRODUCTOID
		--AND STOCK.ID_Lote IN (	
		--	SELECT --* 
		--		ID_Lote 
		--	FROM Inventario_Lotes
		--	WHERE Cod_Item IN (
		--		SELECT DETALLE.Cod_Item 
		--		FROM dbo.Inventario_Detalle_Pedidos DETALLE
		--		WHERE DETALLE.ID_NroPedido = @ID_NroPedido
		--		)
		--)		
	
	
	END 
	ELSE BEGIN
	
		-- Insert statements for procedure here
		SELECT --*
			 STOCK.ID_LOTE
			--,CASE
			--	WHEN STOCK.ID_LOTE = @ID_LOTE AND LOC.ID_LOCALIZADOR = @ID_LOCALIZADOR THEN (STOCK.DISPONIBLE + @CANTIDAD)
			--	ELSE STOCK.DISPONIBLE 
			-- END cantidadpickeada
			,STOCK.DISPONIBLE cantidadpickeada
			,LOTE.FECHA_ORIGEN
			--,LOTE.FECHA_EXPIRA
			,LOTE.COD_ITEM
			,LOC.ID_LOCALIZADOR
			,LOC.COMBINACION_LOCALIZADOR
			,LOC.SEGMENTO1 --ORGANIZACION 
			,LOC.SEGMENTO2 --ZONA
			,LOC.SEGMENTO3 --SUBZONA
			,LOC.SEGMENTO4 --PASILLO
			,LOC.SEGMENTO5 --FILA
			,LOC.SEGMENTO6 --COLUMNA
			,0 SUGERIDO
			,LOTE.LOTE_PROVEEDOR
			,ISNULL(Convert(varchar(10),CONVERT(date,LOTE.Fecha_Expira,106),103), '') Fecha_Expira --Fecha vencimiento		
		FROM Inventario_Stock_Lotes STOCK
			INNER JOIN Inventario_Lotes LOTE
				ON STOCK.ID_Lote = LOTE.ID_Lote AND STOCK.ID_ORG = LOTE.ID_ORG 
			INNER JOIN Inventario_SubInv_Localizadores LOC
				ON STOCK.ID_LOCALIZADOR = LOC.ID_LOCALIZADOR AND STOCK.ID_ORG = LOC.ID_ORG 			
		WHERE 
			STOCK.Disponible > 0 
		AND STOCK.ID_ORG = @ID_Org
		AND LOC.COD_ESTADO = 1
		AND LOC.VIGENCIA = 'S'
		--AND LOC.COD_TIPO_SUBINV = 200
		AND LOC.ID_LOCALIZADOR <> 2791
		AND LOTE.Cod_Item = @PRODUCTOID
		AND STOCK.ID_Lote IN (	
			SELECT --* 
				ID_Lote 
			FROM Inventario_Lotes
			WHERE Cod_Item IN (
				SELECT DETALLE.Cod_Item 
				FROM dbo.Inventario_Detalle_Pedidos DETALLE
				WHERE DETALLE.ID_NroPedido = @ID_NroPedido
				)
		)
	
	END
	
--UNION
--	SELECT --*
--		 STOCK.ID_LOTE
--		,CASE
--			WHEN STOCK.ID_LOTE = @ID_LOTE AND LOC.ID_LOCALIZADOR = @ID_LOCALIZADOR THEN (STOCK.DISPONIBLE + @CANTIDAD)
--			ELSE STOCK.DISPONIBLE 
--		 END cantidadpickeada
--		,LOTE.FECHA_ORIGEN
--		--,LOTE.FECHA_EXPIRA
--		,LOTE.COD_ITEM
--		,LOC.ID_LOCALIZADOR
--		,LOC.COMBINACION_LOCALIZADOR
--		,LOC.SEGMENTO1 --ORGANIZACION 
--		,LOC.SEGMENTO2 --ZONA
--		,LOC.SEGMENTO3 --SUBZONA
--		,LOC.SEGMENTO4 --PASILLO
--		,LOC.SEGMENTO5 --FILA
--		,LOC.SEGMENTO6 --COLUMNA
--		,0 SUGERIDO
--		,LOTE.LOTE_PROVEEDOR
--		,ISNULL(Convert(varchar(10),CONVERT(date,LOTE.Fecha_Expira,106),103), '') Fecha_Expira --Fecha vencimiento		
--	FROM Inventario_Stock_Lotes STOCK
--		INNER JOIN Inventario_Lotes LOTE
--			ON STOCK.ID_Lote = LOTE.ID_Lote AND STOCK.ID_ORG = LOTE.ID_ORG 
--		INNER JOIN Inventario_SubInv_Localizadores LOC
--			ON STOCK.ID_LOCALIZADOR = LOC.ID_LOCALIZADOR AND STOCK.ID_ORG = LOC.ID_ORG 			
--	WHERE 
--	    STOCK.ID_ORG = @ID_Org
--	AND LOC.COD_ESTADO = 1
--	AND LOC.VIGENCIA = 'S'
--	AND LOC.COD_TIPO_SUBINV = 200
--	AND LOTE.Cod_Item = @PRODUCTOID
--	AND STOCK.ID_Lote = @ID_LOTE AND LOC.ID_LOCALIZADOR = @ID_LOCALIZADOR	
--	ORDER BY 
--		 FECHA_EXPIRA ASC
--		,FECHA_ORIGEN ASC 
--		,LOC.SEGMENTO1 --ORGANIZACION 
--		,LOC.SEGMENTO2 --ZONA
--		,LOC.SEGMENTO3 --SUBZONA
--		,LOC.SEGMENTO4 --PASILLO
--		,LOC.SEGMENTO5 --FILA
--		,LOC.SEGMENTO6 --COLUMNA				

END

--SELECT * FROM Inventario_SubInv_Localizadores
GO
