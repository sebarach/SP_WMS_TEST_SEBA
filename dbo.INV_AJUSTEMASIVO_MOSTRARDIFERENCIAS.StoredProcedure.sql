USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_AJUSTEMASIVO_MOSTRARDIFERENCIAS]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_AJUSTEMASIVO_MOSTRARDIFERENCIAS]
	-- Add the parameters for the stored procedure here
	 @FOLIO NUMERIC(18, 0)
	,@ID_ORG numeric(18, 0)	
	,@CICLO_ACTUAL NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	SELECT
		  FIS.Folio_TomaInv Folio
		 ,FIS.ID_ETIQUETA NumeroEtiqueta --FIS.FOLIO_TOMAINV Folio
		 ,PROP.ID_HOLDING Propietario
		 --,DUENO.ID_DUEÑO DuenoId
		 ,C.NOMBRES + ' ' + C.APELLIDO_PATERNO + ' ' + C.APELLIDO_MATERNO Dueno
		 ,ISNULL(FIS.COD_ITEM, 0) Sku
		 ,ISNULL(FIS.ID_Lote, '') LoteId 
		 ,SUBINV_CONG.ID_SUBINV SubInventarioId
		 ,SUBINV_CONG.DESCRIPCION SubInvinventario
		 ,CONG.ID_LOCALIZADOR LocalizadorId
		 ,LOC_CONG.COMBINACION_LOCALIZADOR Localizador
		 ,ISNULL(CONG.EN_MANO, 0) EnMano
		 ,ISNULL(CONG.DISPONIBLE, 0) Disponible
		 ,ISNULL(CONG.RESERVA, 0) Reserva		 
		 ,ISNULL(FIS.Cantidad_Fisica, 0) CantidadFisica
		 ,ISNULL(SUBINV_FIS.ID_SUBINV, 0) SubInventarioFisicoId
		 ,ISNULL(SUBINV_FIS.DESCRIPCION, '') SubInventarioFisico
		 ,ISNULL(FIS.ID_LOCALIZADOR, ISNULL(CONG.ID_LOCALIZADOR, 0)) LocalizadorFisicoId
		 ,ISNULL(LOC_FIS.COMBINACION_LOCALIZADOR, '') LocalizadorFisico		 
		 ,(ISNULL(FIS.Cantidad_Fisica, 0) - ISNULL(CONG.EN_MANO, 0)) Diferencia
		 --,@DESCRIPCION Observacion
		 ,ISNULL(CONG.CICLO, 0) CICLO
		,ISNULL(LOC_FIS.SEGMENTO5, '') Fila
		,ISNULL(LOC_FIS.SEGMENTO6, '') Columna   
		,ISNULL(LOC_FIS.SEGMENTO4, '') Pasillo 
		,ISNULL(PROD.DESCRIPTOR_CORTA, '') DESCRIPTOR	
		,UM.UNIDAD_MEDIDA_ABREVIADA UnidadMedida	
		,ISNULL(PROD.PRECIO_COMPRA, 0) PRECIO_COMPRA	
		,ISNULL(FAMILIA.NOMBRE_CATEG1, '') Familia 
	FROM Inventario_Toma_Fisica_Inv FIS
		LEFT JOIN Inventario_Congelar_Toma_Inv CONG
			ON FIS.ID_ETIQUETA = CONG.ID_Etiqueta AND FIS.ID_ORG = CONG.ID_Org
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
		INNER JOIN Adm_System_Contactos C
			ON DUENO.ID_CONTACTO = C.ID_CONTACTO AND DUENO.ID_ORG = C.ID_ORG			
		INNER JOIN Adm_System_Holding PROP
			ON DUENO.ID_HOLDING_PROPIETARIO = PROP.ID_HOLDING AND DUENO.ID_ORG = PROP.ID_ORG
		INNER JOIN Inventario_SubInv_Localizadores LOC_FIS
			ON FIS.ID_LOCALIZADOR = LOC_FIS.ID_LOCALIZADOR AND FIS.ID_ORG = LOC_FIS.ID_ORG 
		INNER JOIN Inventario_SubInventarios SUBINV_FIS
			ON LOC_FIS.ID_SUBINV = SUBINV_FIS.ID_SUBINV
		INNER JOIN Inventario_SubInv_Localizadores LOC_CONG
			ON CONG.ID_LOCALIZADOR = LOC_CONG.ID_LOCALIZADOR AND CONG.ID_ORG = LOC_CONG.ID_ORG 
		--Solicitado para comparar con Export de Visualización de Stock
		INNER JOIN Inventario_Stock_Lotes STOCK
			ON LOTE.ID_LOTE = STOCK.ID_LOTE AND LOC_CONG.ID_LOCALIZADOR = STOCK.ID_LOCALIZADOR AND LOTE.ID_ORG = STOCK.ID_ORG
		INNER JOIN Inventario_SubInventarios SUBINV_CONG
			ON LOC_CONG.ID_SUBINV = SUBINV_CONG.ID_SUBINV
		LEFT JOIN Inventario_Categoria1 FAMILIA
			ON FAMILIA.COD_CATEG1 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 1, 4)						
	WHERE PROP.VIGENCIA = 'S'
		AND DUENO.VIGENCIA = 'S'
		AND CONG.VIGENCIA = 'S'
		AND FIS.FOLIO_TOMAINV = @FOLIO
		AND PROD.ID_Org = @ID_ORG	
		AND ISNULL(CONG.CICLO, 0) = @CICLO_ACTUAL
		--Solicitado para comparar con Export de Visualización de Stock
		AND ISNULL(STOCK.EN_MANO, 0) > 0 
	ORDER BY PROD.COD_ITEM ASC

	
END
GO
