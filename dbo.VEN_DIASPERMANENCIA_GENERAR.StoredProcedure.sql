USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_DIASPERMANENCIA_GENERAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_DIASPERMANENCIA_GENERAR] 
--DECLARE	
	 @ANIO NUMERIC(18, 0)
	,@MES NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--SET @ANIO = 2017
	--SET @MES = 7
	--SET @ID_ORG = 17
	
	-- Insert statements for procedure here	
	--DECLARE @CADENA VARCHAR(10)
	--DECLARE CSTOCKLOTES CURSOR FOR
	DECLARE @mydate DATETIME
	DECLARE @FECHA_CORTE DATETIME
	DECLARE @DIASMES NUMERIC(18, 0)
	DECLARE @PALLET NUMERIC(18,5)
	--SOLUCION MES 12
	DECLARE @PROXIMO_MES VARCHAR(2), @PROXIMO_ANIO VARCHAR(4)
	IF(@MES = 12) BEGIN 
		SET @PROXIMO_MES = CAST(1 AS VARCHAR(2));
		SET @PROXIMO_ANIO = CAST(@ANIO + 1 AS VARCHAR(4));
	END 
	ELSE BEGIN
		SET @PROXIMO_MES = CAST(@MES + 1 AS VARCHAR(2))
		SET @PROXIMO_ANIO = CAST(@ANIO AS VARCHAR(4))
	END
	
	SELECT @mydate = @PROXIMO_ANIO + '-' + @PROXIMO_MES + '-01'	
	SELECT @FECHA_CORTE = CONVERT(VARCHAR(25), DATEADD(dd, -(DAY(@mydate)), @mydate),101)		
	SELECT @PALLET =VOL_PALLET FROM Inventario_Pallet
	
	SET @DIASMES = DATEPART(DD, @FECHA_CORTE) --REQUERIDO
	
	--SELECT @mydate MYDATE, @FECHA_CORTE FECHA_CORTE, @DIASMES ULTIMODIA

	DECLARE @FECHA_CORTE_INICIO DATETIME
	DECLARE @DIASMES_INICIO NUMERIC(18, 0) = 1
	SELECT @FECHA_CORTE_INICIO = CAST(@ANIO AS VARCHAR(4)) + '-' + CAST(@MES AS VARCHAR(2)) + '-01'

		
	--SELECT @FECHA_CORTE_INICIO
	
	DELETE FROM Ventas_Dias_Permanencia WHERE AÑO = @ANIO AND Mes = @MES;
	
	--TIPO RECEPCION	
	--TIPO RECEPCION
	--TIPO RECEPCION
	
	
	INSERT INTO Ventas_Dias_Permanencia
	SELECT 
		 (SELECT ID_HOLDING_PROPIETARIO
		  FROM ADM_SYSTEM_DUEÑOS 
		  WHERE ID_DUEÑO = LOTE.ID_DUEÑO AND ID_ORG = LOTE.ID_ORG) PropietarioId
		,@MES Mes
		,@ANIO Anio		
		,LOTE.ID_DUEÑO Dueno
		,LOTE.Cod_Item ProductoId
		,LOTE.ID_Lote LoteId
		,CASE 
			WHEN DATEDIFF(DAY, FECHA_ORIGEN, @FECHA_CORTE) > @DIASMES THEN @DIASMES
			WHEN DATEDIFF(DAY, FECHA_ORIGEN, @FECHA_CORTE) = 0 THEN 1
			ELSE DATEDIFF(DAY, FECHA_ORIGEN, @FECHA_CORTE)
		 END DiasPermanencia
		,CASE 
			WHEN STOCK.En_Mano > 0 AND LOC.ID_SUBINV = 50 THEN ISNULL(DBO.FN_CALCULOF22(STOCK.En_Mano, PROD.VOLUMEN, LOC.VOLUMEN), 0)
			WHEN STOCK.En_Mano > 0 AND LOC.ID_SUBINV = 10 THEN 1
			ELSE 0
		END TotalPosEnteras		
		,CASE 
			WHEN STOCK.En_Mano > 0 AND LOC.ID_SUBINV = 50 THEN ISNULL(DBO.FN_CALCULOF22(STOCK.En_Mano, PROD.VOLUMEN + @PALLET, LOC.VOLUMEN), 0)
			WHEN STOCK.En_Mano > 0 AND LOC.ID_SUBINV = 10 THEN ISNULL(ROUND(((STOCK.En_Mano * PROD.VOLUMEN) / LOC.VOLUMEN)+@PALLET, 2), 0)
			ELSE 0
		END TotalPosProporcional
		,SUBINV.DESCRIPCION SubInventario
		,LOC.COMBINACION_LOCALIZADOR Localizador
		,STOCK.En_Mano
		,Isnull(LOC.VOLUMEN,0) Volumen
		,'Recepción' TipoTransaccion		
	FROM INVENTARIO_STOCK_LOTES STOCK
		INNER JOIN INVENTARIO_LOTES LOTE
			ON STOCK.ID_LOTE = LOTE.ID_LOTE AND STOCK.ID_ORG = LOTE.ID_ORG
		INNER JOIN Inventario_SubInv_Localizadores LOC
			ON STOCK.ID_Localizador = LOC.ID_LOCALIZADOR AND STOCK.ID_Org = LOC.ID_ORG
		INNER JOIN Inventario_SubInventarios SUBINV
			ON LOC.ID_SUBINV = SUBINV.ID_SUBINV
		INNER JOIN INVENTARIO_ITEMS PROD
			ON LOTE.Cod_Item = PROD.COD_ITEM AND LOTE.ID_Org = PROD.ID_ORG
	WHERE LOC.VIGENCIA = 'S'
		AND LOC.COD_ESTADO = 1
		AND LOC.COD_TIPO_SUBINV IN (100,200)
		AND FECHA_ORIGEN <= @FECHA_CORTE
		AND STOCK.ID_ORG = @ID_ORG
		AND STOCK.En_Mano > 0
	ORDER BY 
		 PropietarioId ASC
		,Mes ASC
		,Anio ASC	
		,Dueno ASC
		,ProductoId ASC
		,LoteId ASC
		,DiasPermanencia ASC
		,SubInventario ASC
		,Localizador ASC	
	
	
	------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------
	
	--TIPO DESPACHO
	--TIPO DESPACHO
	--TIPO DESPACHO
	
	INSERT INTO Ventas_Dias_Permanencia
	SELECT 
		 (SELECT ID_HOLDING_PROPIETARIO
		  FROM ADM_SYSTEM_DUEÑOS 
		  WHERE ID_DUEÑO = LOTE.ID_DUEÑO AND ID_ORG = LOTE.ID_ORG) PropietarioId
		,@MES Mes
		,@ANIO Anio		
		,LOTE.ID_DUEÑO Dueno
		,LOTE.Cod_Item ProductoId
		,LOTE.ID_Lote LoteId
		,CASE			
			WHEN (LOTE.Fecha_Origen >= @FECHA_CORTE_INICIO AND LOTE.Fecha_Origen <= @FECHA_CORTE) AND DATEDIFF(DAY, LOTE.FECHA_ORIGEN, TRX.Fech_Actualiza) > 0 THEN DATEDIFF(DAY, LOTE.FECHA_ORIGEN, TRX.Fech_Actualiza)	
			WHEN DATEDIFF(DAY, LOTE.FECHA_ORIGEN, TRX.Fech_Actualiza) = 0 THEN 1
			ELSE DATEPART(DD, TRX.Fech_Actualiza) 
		END DiasPermanencia
		,CASE 
			WHEN LOC.ID_SUBINV = 50 THEN ISNULL(DBO.FN_CALCULOF22(TRX.Cant_Despacho, PROD.VOLUMEN, LOC.VOLUMEN), 0)
			WHEN LOC.ID_SUBINV = 10 THEN 1
			ELSE 0
		END TotalPosEnteras		
		,CASE 
			WHEN LOC.ID_SUBINV = 50 THEN ISNULL(DBO.FN_CALCULOF22(TRX.Cant_Despacho, PROD.VOLUMEN + @PALLET, LOC.VOLUMEN), 0)
			WHEN LOC.ID_SUBINV = 10 THEN ISNULL(ROUND(((TRX.Cant_Despacho * PROD.VOLUMEN) / LOC.VOLUMEN)+@PALLET, 2), 0)
			ELSE 0
		END TotalPosProporcional
		,SUBINV.DESCRIPCION SubInventario
		,LOC.COMBINACION_LOCALIZADOR Localizador
		,TRX.Cant_Despacho EnMano
		,Isnull(LOC.VOLUMEN,0) Volumen
		,'Despacho' TipoTransaccion		
	FROM Inventario_Detalle_Trx_Pedidos TRX
		INNER JOIN INVENTARIO_LOTES LOTE
			ON TRX.ID_LOTE = LOTE.ID_LOTE AND TRX.ID_ORG = LOTE.ID_ORG	
		INNER JOIN Inventario_SubInv_Localizadores LOC
			ON TRX.ID_Localizador_Origen = LOC.ID_LOCALIZADOR AND TRX.ID_Org = LOC.ID_ORG
		INNER JOIN Inventario_SubInventarios SUBINV
			ON LOC.ID_SUBINV = SUBINV.ID_SUBINV
		INNER JOIN INVENTARIO_ITEMS PROD
			ON TRX.Cod_Item = PROD.COD_ITEM AND TRX.ID_Org = PROD.ID_ORG
	WHERE TRX.Nomb_Sgte_Estado = 'Enviado'
		AND LOC.COD_ESTADO = 1
		AND LOC.COD_TIPO_SUBINV IN (100,200)
		AND CONVERT(DATE,TRX.Fech_Actualiza,103) >= @FECHA_CORTE_INICIO AND CONVERT(DATE,TRX.Fech_Actualiza,103) <= @FECHA_CORTE
		AND TRX.ID_ORG = @ID_ORG
		AND TRX.Cant_Despacho > 0
	ORDER BY 
		 PropietarioId ASC
		,Mes ASC
		,Anio ASC	
		,Dueno ASC
		,ProductoId ASC
		,LoteId ASC
		,DiasPermanencia ASC
		,SubInventario ASC
		,Localizador ASC		
	
	SELECT 1 Correcto, 'Los días de permanencia se generaron exitosamente' Mensaje
	

END
GO
