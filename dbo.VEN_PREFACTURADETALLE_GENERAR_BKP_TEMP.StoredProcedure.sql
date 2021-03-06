USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_PREFACTURADETALLE_GENERAR_BKP_TEMP]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_PREFACTURADETALLE_GENERAR_BKP_TEMP]
--DECLARE
	 @Folio_Pref numeric(18, 0)
	,@Mes numeric(18, 0)
	,@Año numeric(18, 0)
	,@ID_Holding_Propietario numeric(18, 0)
	,@ID_Dueño numeric(18, 0)
	,@Cod_Centro numeric(18, 0)
	,@Atencion_a varchar(MAX)
	,@ID_Org numeric(18, 0)
	,@ID_Usro numeric(18, 0)
	,@Cod_Estado numeric(18, 0)
	,@Observaciones varchar(MAX)
	,@Email varchar(MAX)
	--,@Cod_Categ numeric(18, 0)
	--,@Cod_Familia numeric(18, 0)
	--,@Cod_Marca numeric(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	--SET @Folio_Pref = 0
	--SET @Mes = 8
	--SET @Año = 2017
	--SET @ID_Holding_Propietario = 52--234
	--SET @ID_Dueño = 12--492
	--SET @Cod_Centro = 2
	--SET @Atencion_a = 'ALEJANDRO COBIAN STEVENSON'
	--SET @ID_Org = 17
	--SET @ID_Usro = 4
	--SET @Cod_Estado = 0
	--SET @Observaciones = ''
	--SET @Email = 'LAL1@C.CL' 	
	
	
	SET NOCOUNT ON;
	
	DECLARE @FOLIO_ACTUAL NUMERIC(18, 0)
	DECLARE @FECHA DATETIME = GETDATE();

--BEGIN TRAN
	
	IF NOT EXISTS(SELECT * FROM Ventas_Cabecera_Prefactura WHERE FOLIO_PREF = @Folio_Pref) BEGIN
		
		SELECT @FOLIO_ACTUAL = FOLIO_PREF FROM Inventario_Folios_Todos 
		
		INSERT INTO Ventas_Cabecera_Prefactura		
           ([Folio_Pref]
           ,[Mes]
           ,[Año]
           ,[ID_Holding_Propietario]
           ,[ID_Dueño]
           ,[Cod_Centro]
           ,[Atencion_a]
           ,[Fecha_Emision]
           ,[ID_Org]
           ,[Fech_Creacion]
           ,[ID_Usro_Crea]
           ,[Cod_Estado]
           ,[Observaciones]
           ,[Email])
     VALUES
           ( @FOLIO_ACTUAL
			,@Mes
			,@Año
			,@ID_Holding_Propietario
			,@ID_Dueño
			,@Cod_Centro
			,@Atencion_a
			,@FECHA
			,@ID_Org
			,@FECHA
			,@ID_Usro
			,10 --@Cod_Estado SELECT * FROM dbo.Ventas_Estado_Prefact
			,@Observaciones
			,@Email)
			
		SET @Folio_Pref = @FOLIO_ACTUAL
		
		UPDATE Inventario_Folios_Todos 
		SET FOLIO_PREF = @FOLIO_ACTUAL + 1
		
	END	
	--ELSE BEGIN
		
	--	UPDATE Ventas_Cabecera_Prefactura
	--	SET 
	--	WHERE Folio_Pref = @Folio_Pref
	
	
	--END
	
	
	DELETE FROM Ventas_Detalle_Prefactura WHERE Folio_Pref = @Folio_Pref
	
	--SERVICIO BASE
	DECLARE 
		@POS_PROPORCIONAL VARCHAR(2),
		@VALOR_VENTA NUMERIC(18, 5),
		@Valor_Costo NUMERIC(18, 5),
		@Dias_Mes NUMERIC(18, 0),
		@Tarifa_Diaria NUMERIC(18, 5),
		@Total_Pos_Base NUMERIC(18, 0)	
			
	SELECT 
		 @POS_PROPORCIONAL = POSICION_PROPORCIONAL
		,@VALOR_VENTA = VALOR_VENTA
		,@Valor_Costo = Valor_Costo
		,@Dias_Mes = Dias_Mes
		,@Tarifa_Diaria = Tarifa_Diaria
		,@Total_Pos_Base = Total_Pos_Base
	FROM Ventas_Unidades_Cobro --UC
		--INNER JOIN Ventas_Monedas M
		--	ON UC.COD_MONEDA = M.COD_MONEDA
	WHERE ID_Holding_Propietario = @ID_Holding_Propietario
		AND VIGENCIA = 'S'
		AND COD_SERVICIO = 10
		
		
	--SERVICIO ADICIONAL
	DECLARE 
		@APOS_PROPORCIONAL VARCHAR(2),
		@AVALOR_VENTA NUMERIC(18, 5),
		@AValor_Costo NUMERIC(18, 5),
		@ADias_Mes NUMERIC(18, 0),
		@ATarifa_Diaria NUMERIC(18, 5),
		@ATotal_Pos_Base NUMERIC(18, 0)	
		
	SELECT 
		 @APOS_PROPORCIONAL = POSICION_PROPORCIONAL
		,@AVALOR_VENTA = VALOR_VENTA
		,@AValor_Costo = Valor_Costo
		,@ADias_Mes = Dias_Mes
		,@ATarifa_Diaria = Tarifa_Diaria
		,@ATotal_Pos_Base = Total_Pos_Base
	FROM Ventas_Unidades_Cobro --UC
		--INNER JOIN Ventas_Monedas M
		--	ON UC.COD_MONEDA = M.COD_MONEDA
	WHERE ID_Holding_Propietario = @ID_Holding_Propietario
		AND VIGENCIA = 'S'
		AND COD_SERVICIO = 20
		
	DECLARE @SERVICIO_BASE VARCHAR(MAX), @SERVICIO_ADICIONAL VARCHAR(MAX), @VALOR_UF NUMERIC(18, 8)
	SELECT @SERVICIO_BASE = NOMBRE + ' Días ' FROM Ventas_Servicios WHERE COD_SERVICIO = 10
	SELECT @SERVICIO_ADICIONAL = NOMBRE + ' Días ' FROM Ventas_Servicios WHERE COD_SERVICIO = 20
	
	--SELECT * FROM Ventas_Unidades_Cobro
	
	--SELECT @POS_PROPORCIONAL, @VALOR_VENTA
	--SELECT @APOS_PROPORCIONAL, @AVALOR_VENTA
	
	SELECT TOP 1 @VALOR_UF = VALOR 
	FROM VENTAS_TIPO_CAMBIO
	WHERE COD_MONEDA = 3
		AND VIGENCIA = 'S'
	ORDER BY AÑO DESC, MES DESC, DIA DESC	
	
	DECLARE 
		@CDP_FOLIO NUMERIC(18, 0),
		@CDP_LINEA NUMERIC(18, 0),
		@CDP_DIAS_PERMANENCIA NUMERIC(18, 0),
		@CDP_CANT_UBICACIONES NUMERIC(18, 0),
		@CDP_SUMA_PROPORCIONAL NUMERIC(18, 5)	
	
	DECLARE @SUMA_CANT_UBICACIONES NUMERIC(18, 0) = 0;	
	DECLARE @SUMA_CANT_REMAIN NUMERIC(18, 0) = 0;
	DECLARE @SUMA_PROPORCIONAL_REMAIN NUMERIC(18, 5) = 0;
	
    -- Insert statements for procedure here
    IF (@POS_PROPORCIONAL = 'SI') BEGIN
    
		DECLARE CDP_GRUPODIAS CURSOR FOR		
		SELECT 
			 @Folio_Pref FolioPref
			,ROW_NUMBER() OVER(ORDER BY DIAS_PERMANENCIA DESC) NroLinea
			--,10
			--,@SERVICIO_BASE
			,DIAS_PERMANENCIA
			,SUM(CANTIDAD_UBICACIONES) CANTIDAD_UBICACIONES 
			,SUM(SUMA_PROPORCIONAL) SUMA_PROPORCIONAL
			--,@Total_Pos_Base
			FROM 
		(SELECT 
			 --DP.*, LOTE.FECHA_ORIGEN
			 --@SERVICIO_BASE
			 CASE 
				WHEN DP.DIAS_PERMANENCIA > 30 THEN 30
				ELSE DP.DIAS_PERMANENCIA
			 END DIAS_PERMANENCIA
			,COUNT(*) CANTIDAD_UBICACIONES
			,SUM(TOTAL_POS_PROPORCIONAL) SUMA_PROPORCIONAL
		FROM Ventas_Dias_Permanencia DP
			INNER JOIN INVENTARIO_LOTES LOTE
				ON DP.ID_LOTE = LOTE.ID_LOTE
		WHERE DP.Año = @Año 
			AND DP.Mes = @Mes
			AND DP.ID_Holding_Propietario = @ID_Holding_Propietario
			AND DP.ID_Dueño = @ID_Dueño
		GROUP BY DP.DIAS_PERMANENCIA
		) TABLA
		GROUP BY DIAS_PERMANENCIA
		ORDER BY DIAS_PERMANENCIA DESC			
	
	END
	ELSE BEGIN
	
		DECLARE CDP_GRUPODIAS CURSOR FOR		
		SELECT 
			 @Folio_Pref FolioPref
			,ROW_NUMBER() OVER(ORDER BY DIAS_PERMANENCIA DESC) NroLinea
			--,10
			--,@SERVICIO_BASE
			,DIAS_PERMANENCIA
			,SUM(CANTIDAD_UBICACIONES) CANTIDAD_UBICACIONES 
			,SUM(SUMA_PROPORCIONAL) SUMA_PROPORCIONAL
			--,@Total_Pos_Base
			FROM 
		(SELECT 
			 --DP.*, LOTE.FECHA_ORIGEN
			 --@SERVICIO_BASE
			 CASE 
				WHEN DP.DIAS_PERMANENCIA > 30 THEN 30
				ELSE DP.DIAS_PERMANENCIA
			 END DIAS_PERMANENCIA
			,COUNT(*) CANTIDAD_UBICACIONES
			,SUM(Total_Pos_Enteras) SUMA_PROPORCIONAL
		FROM Ventas_Dias_Permanencia DP
			INNER JOIN INVENTARIO_LOTES LOTE
				ON DP.ID_LOTE = LOTE.ID_LOTE
		WHERE DP.Año = @Año 
			AND DP.Mes = @Mes
			AND DP.ID_Holding_Propietario = @ID_Holding_Propietario
			AND DP.ID_Dueño = @ID_Dueño
		GROUP BY DP.DIAS_PERMANENCIA
		) TABLA
		GROUP BY DIAS_PERMANENCIA
		ORDER BY DIAS_PERMANENCIA DESC		
	
	END
	
	DECLARE @DET_LINEA NUMERIC(18, 0) = 0;
	
	--SELECT 
	--	 @Folio_Pref FolioPref
	--	,ROW_NUMBER() OVER(ORDER BY DIAS_PERMANENCIA DESC) NroLinea
	--	--,10
	--	--,@SERVICIO_BASE
	--	,DIAS_PERMANENCIA
	--	,SUM(CANTIDAD_UBICACIONES) CANTIDAD_UBICACIONES 
	--	,SUM(SUMA_PROPORCIONAL) SUMA_PROPORCIONAL
	--	FROM 
	--(SELECT 
	--	 --DP.*, LOTE.FECHA_ORIGEN
	--	 --@SERVICIO_BASE
	--	 CASE 
	--		WHEN DP.DIAS_PERMANENCIA > 30 THEN 30
	--		ELSE DP.DIAS_PERMANENCIA
	--	 END DIAS_PERMANENCIA
	--	,COUNT(*) CANTIDAD_UBICACIONES
	--	,SUM(TOTAL_POS_PROPORCIONAL) SUMA_PROPORCIONAL
	--FROM Ventas_Dias_Permanencia DP
	--	INNER JOIN INVENTARIO_LOTES LOTE
	--		ON DP.ID_LOTE = LOTE.ID_LOTE
	--WHERE DP.Año = @Año 
	--	AND DP.Mes = @Mes
	--	AND DP.ID_Holding_Propietario = @ID_Holding_Propietario
	--	AND DP.ID_Dueño = @ID_Dueño
	--GROUP BY DP.DIAS_PERMANENCIA
	--) TABLA
	--GROUP BY DIAS_PERMANENCIA
	--ORDER BY DIAS_PERMANENCIA DESC

	
	OPEN CDP_GRUPODIAS

	FETCH CDP_GRUPODIAS INTO
		@CDP_FOLIO,
		@CDP_LINEA,
		@CDP_DIAS_PERMANENCIA,
		@CDP_CANT_UBICACIONES,
		@CDP_SUMA_PROPORCIONAL		
	
	WHILE (@@FETCH_STATUS = 0) BEGIN
		SET @DET_LINEA = @DET_LINEA + 1
		--PRINT @CADENA
		SET @SUMA_CANT_UBICACIONES = @SUMA_CANT_UBICACIONES + @CDP_CANT_UBICACIONES		
		
		IF @SUMA_CANT_UBICACIONES <= @Total_Pos_Base BEGIN 
			
			SET @SUMA_CANT_REMAIN = @CDP_CANT_UBICACIONES
			SET @SUMA_PROPORCIONAL_REMAIN = @CDP_SUMA_PROPORCIONAL
			
			--SELECT * FROM Ventas_Detalle_Prefactura
			INSERT INTO Ventas_Detalle_Prefactura
			   ([Folio_Pref]
			   ,[Nro_Linea]
			   ,[Cod_Servicio]
			   ,[Descripcion_Detalle]
			   ,[Total_Posiciones]
			   ,[Dias_Permanencia]
			   ,[PrecioxDia]
			   ,[Precio_Unitario]
			   ,[Valor_Total])				
			VALUES
				(@CDP_FOLIO
				,@DET_LINEA
				,10
				,@SERVICIO_BASE
				,@CDP_CANT_UBICACIONES
				,@CDP_DIAS_PERMANENCIA
				,(@VALOR_UF * @Tarifa_Diaria) --@Precio_Unitario
				,((@VALOR_UF * @Tarifa_Diaria) * @CDP_DIAS_PERMANENCIA) --@Precio_Unitario
				,(((@VALOR_UF * @Tarifa_Diaria) * @CDP_DIAS_PERMANENCIA) * @CDP_SUMA_PROPORCIONAL))--@Valor_Total
		
		END
		ELSE BEGIN
			
			IF @SUMA_CANT_REMAIN > 0 BEGIN
				
				DECLARE @RESTA NUMERIC(18, 0) = @Total_Pos_Base - @SUMA_CANT_REMAIN		
				--DECLARE @PROPORCION NUMERIC(18, 5) = (@SUMA_PROPORCIONAL_REMAIN)
				--DECLARE 
				--	@RCDP_CANT_UBICACIONES NUMERIC(18, 0),
				--	@RCDP_SUMA_PROPORCIONAL NUMERIC(18, 5)	
				
				--SELECT * FROM Ventas_Detalle_Prefactura
				INSERT INTO Ventas_Detalle_Prefactura
				   ([Folio_Pref]
				   ,[Nro_Linea]
				   ,[Cod_Servicio]
				   ,[Descripcion_Detalle]
				   ,[Total_Posiciones]
				   ,[Dias_Permanencia]
				   ,[PrecioxDia]
				   ,[Precio_Unitario]
				   ,[Valor_Total])				
				VALUES
					(@CDP_FOLIO
					,@DET_LINEA
					,10
					,@SERVICIO_BASE
					,@RESTA --@CDP_CANT_UBICACIONES
					,@CDP_DIAS_PERMANENCIA
					,(@VALOR_UF * @Tarifa_Diaria) --@Precio_Unitario
					,((@VALOR_UF * @Tarifa_Diaria) * @CDP_DIAS_PERMANENCIA) --@Precio_Unitario
					,(((@VALOR_UF * @Tarifa_Diaria) * @CDP_DIAS_PERMANENCIA) * ((@SUMA_PROPORCIONAL_REMAIN / @SUMA_CANT_REMAIN) * @RESTA)))--@Valor_Total					
					
				PRINT CAST(@VALOR_UF AS VARCHAR(20))
				PRINT CAST(@Tarifa_Diaria AS VARCHAR(20))
				PRINT CAST(@CDP_DIAS_PERMANENCIA AS VARCHAR(20))
				PRINT CAST(@SUMA_PROPORCIONAL_REMAIN AS VARCHAR(20))
				PRINT CAST(@SUMA_CANT_REMAIN AS VARCHAR(20))
				PRINT CAST(@RESTA AS VARCHAR(20))
				
				SET @DET_LINEA = @DET_LINEA + 1
				
				INSERT INTO Ventas_Detalle_Prefactura
				   ([Folio_Pref]
				   ,[Nro_Linea]
				   ,[Cod_Servicio]
				   ,[Descripcion_Detalle]
				   ,[Total_Posiciones]
				   ,[Dias_Permanencia]
				   ,[PrecioxDia]
				   ,[Precio_Unitario]
				   ,[Valor_Total])				
				VALUES
					(@CDP_FOLIO
					,@DET_LINEA
					,20
					,@SERVICIO_ADICIONAL
					,(@SUMA_CANT_UBICACIONES - @Total_Pos_Base) --@CDP_CANT_UBICACIONES
					,@CDP_DIAS_PERMANENCIA
					,(@VALOR_UF * @ATarifa_Diaria) --@Precio_Unitario
					,((@VALOR_UF * @ATarifa_Diaria) * @CDP_DIAS_PERMANENCIA) --@Precio_Unitario
					,(((@VALOR_UF * @ATarifa_Diaria) * @CDP_DIAS_PERMANENCIA) * ((@CDP_SUMA_PROPORCIONAL * @CDP_CANT_UBICACIONES) / (@SUMA_CANT_UBICACIONES - @Total_Pos_Base))))--@Valor_Total				
				
				
				
				SET @SUMA_CANT_REMAIN = 0
			END
			ELSE BEGIN
		
				--SELECT * FROM Ventas_Detalle_Prefactura
				INSERT INTO Ventas_Detalle_Prefactura
				   ([Folio_Pref]
				   ,[Nro_Linea]
				   ,[Cod_Servicio]
				   ,[Descripcion_Detalle]
				   ,[Total_Posiciones]
				   ,[Dias_Permanencia]
				   ,[PrecioxDia]
				   ,[Precio_Unitario]
				   ,[Valor_Total])				
				VALUES
					(@CDP_FOLIO
					,@DET_LINEA
					,20
					,@SERVICIO_ADICIONAL
					,@CDP_CANT_UBICACIONES
					,@CDP_DIAS_PERMANENCIA
					,(@VALOR_UF * @ATarifa_Diaria) --@Precio_Unitario
					,((@VALOR_UF * @ATarifa_Diaria) * @CDP_DIAS_PERMANENCIA) --@Precio_Unitario
					,(((@VALOR_UF * @ATarifa_Diaria) * @CDP_DIAS_PERMANENCIA) * @CDP_SUMA_PROPORCIONAL))--@Valor_Total			
			
			END			
		
		END
		
		FETCH CDP_GRUPODIAS INTO
			@CDP_FOLIO,
			@CDP_LINEA,
			@CDP_DIAS_PERMANENCIA,
			@CDP_CANT_UBICACIONES,
			@CDP_SUMA_PROPORCIONAL

	END 


	CLOSE CDP_GRUPODIAS

	DEALLOCATE CDP_GRUPODIAS			
	
	
	--SELECT Folio_Pref
	--	  ,Nro_Linea
	--	  ,Cod_Servicio
	--	  ,Descripcion_Detalle
	--	  ,Total_Posiciones
	--	  ,Dias_Permanencia
	--	  ,PrecioxDia
	--	  ,Precio_Unitario
	--	  ,Valor_Total
	--  FROM [Ventas_Detalle_Prefactura]
	--WHERE FOLIO_PREF = @FOLIO_PREF
	--ORDER BY Nro_Linea ASC
	DECLARE @SUBTOTAL NUMERIC(18, 0) = 0;
	
	SELECT @SUBTOTAL = SUM(Valor_Total) 
	FROM Ventas_Detalle_Prefactura 
	WHERE FOLIO_PREF = @Folio_Pref	
	
	DELETE FROM Ventas_Totales_Factura WHERE Folio_Pref = @Folio_Pref
		
	INSERT INTO Ventas_Totales_Factura	
	SELECT @Folio_Pref Folio
		  ,@SUBTOTAL SubTotal
		  ,0 PorcDesc
		  ,0 ValorDescuento
		  ,(@SUBTOTAL - 0) ValorNeto 
		  ,10 CodIva
		  ,((@SUBTOTAL - 0) * (select IVA from Ventas_Iva where Cod_Iva = 10)) / 100 ValorIva
		  ,(@SUBTOTAL - 0) + (((@SUBTOTAL - 0) * (select IVA from Ventas_Iva where Cod_Iva = 10)) / 100) ValorTotal
		  ,@ID_Org OrganizacionId

	SELECT 
	   [Folio_Pref] Folio
      ,[Mes] Mes
      ,[Año] Anio
      ,[ID_Holding_Propietario] PropietarioId
      ,[ID_Dueño] DuenoId
      ,[Cod_Centro] CodCentro
      ,ISNULL([Observaciones], '') Nota
      ,ISNULL([Email], '') Email
	  ,1 CORRECTO, 'Detalle generado exitosamente' MENSAJE      
  FROM [Ventas_Cabecera_Prefactura]
  WHERE Folio_Pref = @Folio_Pref


	
					

	--SELECT 
	--	 DP.*, LOTE.FECHA_ORIGEN
	--FROM Ventas_Dias_Permanencia DP
	--	INNER JOIN INVENTARIO_LOTES LOTE
	--		ON DP.ID_LOTE = LOTE.ID_LOTE
	--WHERE DP.Año = @Año 
	--	AND DP.Mes = @Mes
	--	AND DP.ID_Holding_Propietario = @ID_Holding_Propietario
	--	AND DP.ID_Dueño = @ID_Dueño	

			
		
	
	
	

	--ELSE BEGIN 
	
	
	--END	

	--ROLLBACK
	
	/*
	SELECT * FROM Ventas_Cabecera_Prefactura
	
	SELECT * FROM Ventas_Detalle_Prefactura
	
	SELECT * FROM Ventas_Totales_Factura
	
	
	*/
	

	
	
END
GO
