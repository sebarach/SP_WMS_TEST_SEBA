USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_AJUSTEMASIVO_SELECCIONAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_AJUSTEMASIVO_SELECCIONAR 23, 17
CREATE PROCEDURE [dbo].[INV_AJUSTEMASIVO_SELECCIONAR]
--DECLARE
	-- Add the parameters for the stored procedure here	
	@FOLIO NUMERIC(18, 0),
	--@DESCRIPCION VARCHAR(250),
	--@PROPIETARIO NUMERIC(18, 0),
	--@FAMILIA NUMERIC(18, 0),
	--@CATEGORIA NUMERIC(18, 0),
	--@MARCA NUMERIC(18, 0),
	--@DESCRIPTOR_CORTA VARCHAR(256),
	--@ID_USRO NUMERIC(18, 0),
	@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--SET @FOLIO = 23
	--SET @ID_ORG = 17
	
    -- Insert statements for procedure here
		    
    /*
    SELECT * FROM Inventario_Congelar_Toma_Inv WHERE FOLIO_TOMAINV = 23
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
		 CONG.FOLIO_TOMAINV Folio
		 ,ISNULL(Convert(varchar(10),CONVERT(date,CONG.FECHA_INV,106),103), '') Fecha
		 ,CONG.DESCRIPCION_INV Descripcion
		 ,TOMA_ESTADO.ESTADO Estado
		 --,CONG.FILTRO Filtro
		 ,CONG.ID_ETIQUETA NumeroEtiqueta
		 --,PROP.ID_HOLDING PropietarioId
		 ,PROP.NOMBRE Propietario
		--,DUENO.ID_DUEÑO DuenoId
		,C.NOMBRES + ' ' + C.APELLIDO_PATERNO + ' ' + C.APELLIDO_MATERNO Dueno
		,PROD.COD_ITEM Sku
		,(SELECT CRUZ.VALOR_REFERENCIA
		  FROM Inventario_Referencias_Cruzadas CRUZ
		  WHERE LOTE.Cod_Item = CRUZ.COD_ITEM AND LOTE.ID_Org = CRUZ.ID_Org AND CRUZ.ID_REF_PRED = 1003) CodigoAntiguo		
		,PROD.DESCRIPTOR_CORTA Descriptor		
		,ISNULL(LOTE.Etiq_Pallet_Antiguo, '') EtiquetaPalletAntiguo
		,LOTE.ID_Lote LoteId		
		,LOTE.Lote_Proveedor LoteProveedor
		,ISNULL(Convert(varchar(10),CONVERT(date,LOTE.Fecha_Expira,106),103), '') FechaVencimiento
		,ISNULL(CONG.EN_MANO, 0) EnMano
		,ISNULL(CONG.DISPONIBLE, 0) Disponible
		,ISNULL(CONG.RESERVA, 0) Reserva
		,UM.UNIDAD_MEDIDA_ABREVIADA UnidadMedida   	
		,ISNULL(FAMILIA.NOMBRE_CATEG1, '') Familia 
	    ,ISNULL(CATEGORIA.NOMBRE_CATEG2, '') Categoria
	    ,ISNULL(MARCA.NOMBRE_CATEG3, '') Marca	
		--,SUBINV.ID_SUBINV SubInventarioId
		,SUBINV.DESCRIPCION SubInvinventario
		--,LOC.ID_LOCALIZADOR LocalizadorId
		,LOC.COMBINACION_LOCALIZADOR Localizador	    
	    ,PROD.PRECIO_COMPRA PrecioCompra
	    ,ISNULL(LOC.SEGMENTO4, '') Pasillo
	    ,CAST(ISNULL(LOC.SEGMENTO6, 0) AS NUMERIC(18, 0)) Sentido
	    ,ISNULL(CONG.CICLO, 0) CICLO
		,DBO.SI((SELECT CASE
			WHEN CONG.COD_ESTADO IN(1, 2) THEN MIN(ISNULL(CICLO, 0))
			ELSE 0
		END	FROM Inventario_Congelar_Toma_Inv WHERE FOLIO_TOMAINV = CONG.FOLIO_TOMAINV AND ID_ORG = CONG.ID_ORG), CONG.CICLO, CONG.CICLO) CICLO_ACTUAL 	
		,ISNULL(LOC.SEGMENTO5, '') Fila
		,ISNULL(LOC.SEGMENTO6, '') Columna    
	FROM Inventario_Congelar_Toma_Inv CONG
		INNER JOIN Inventario_Estado_Toma_Inv TOMA_ESTADO
			ON CONG.COD_ESTADO = TOMA_ESTADO.COD_ESTADO
		INNER JOIN INVENTARIO_LOTES LOTE
			ON CONG.ID_LOTE = LOTE.ID_LOTE AND CONG.ID_ORG = LOTE.ID_ORG
		INNER JOIN Inventario_Items PROD
			ON LOTE.COD_ITEM = PROD.COD_ITEM AND LOTE.ID_ORG = PROD.ID_ORG AND CONG.COD_ITEM = PROD.COD_ITEM AND CONG.ID_ORG = PROD.ID_ORG
		INNER JOIN Inventario_Unidad_Medida_Primaria UM
			ON PROD.ID_UM = UM.ID_UM				
		INNER JOIN Adm_System_Dueños DUENO
			ON LOTE.ID_DUEÑO = DUENO.ID_DUEÑO AND LOTE.ID_ORG = DUENO.ID_ORG
		INNER JOIN Adm_System_Holding PROP
			ON DUENO.ID_HOLDING_PROPIETARIO = PROP.ID_HOLDING AND DUENO.ID_ORG = PROP.ID_ORG
		INNER JOIN Inventario_SubInv_Localizadores LOC
			ON CONG.ID_LOCALIZADOR = LOC.ID_LOCALIZADOR AND CONG.ID_ORG = LOC.ID_ORG 
		--Solicitado para comparar con Export de Visualización de Stock
		INNER JOIN Inventario_Stock_Lotes STOCK
			ON LOTE.ID_LOTE = STOCK.ID_LOTE AND LOC.ID_LOCALIZADOR = STOCK.ID_LOCALIZADOR AND LOTE.ID_ORG = STOCK.ID_ORG	
		INNER JOIN Inventario_SubInventarios SUBINV
			ON LOC.ID_SUBINV = SUBINV.ID_SUBINV
		INNER JOIN Adm_System_Contactos C
			ON DUENO.ID_CONTACTO = C.ID_CONTACTO AND DUENO.ID_ORG = C.ID_ORG	
		LEFT JOIN Inventario_Categoria1 FAMILIA
			ON FAMILIA.COD_CATEG1 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 1, 4)						
		LEFT JOIN Inventario_Categoria2 CATEGORIA
			ON CATEGORIA.COD_CATEG2 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 6, 4)
			AND CATEGORIA.COD_CATEG1 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 1, 4)
		LEFT JOIN Inventario_Categoria3 MARCA
			ON MARCA.COD_CATEG3 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 11, 4)		
			AND MARCA.COD_CATEG2 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 6, 4)	 							
	WHERE PROP.VIGENCIA = 'S'
		AND DUENO.VIGENCIA = 'S'
		AND CONG.VIGENCIA = 'S'
		AND LOC.COD_TIPO_SUBINV = 200
		AND CONG.FOLIO_TOMAINV = @FOLIO
		AND PROD.ID_Org = @ID_ORG
		--Solicitado para comparar con Export de Visualización de Stock
		AND ISNULL(STOCK.EN_MANO, 0) > 0
	ORDER BY CICLO ASC, PROD.COD_ITEM ASC
		
	
END
GO
