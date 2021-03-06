USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_PREFACTURADETALLE_GENERAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_PREFACTURADETALLE_GENERAR]
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
	,@Porc_Desc numeric(18, 5)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	--SET @Folio_Pref = 23
	--SET @Mes = 7
	--SET @Año = 2017
	--SET @ID_Holding_Propietario = 52--234
	--SET @ID_Dueño = 12--492
	--SET @Cod_Centro = 3
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
	ELSE BEGIN
		
		UPDATE Ventas_Cabecera_Prefactura
		SET  Mes = @Mes
			,Año = @Año
			,ID_Holding_Propietario = @ID_Holding_Propietario
			,ID_Dueño = @ID_Dueño
			,Cod_Centro = @Cod_Centro
			,Atencion_a = @Atencion_a
			,Fecha_Emision = @FECHA
			,ID_Org = @ID_Org
			,Fech_Actualiza = @FECHA
			,ID_Usro_Act = @ID_Usro
			,Cod_Estado = 10 --@Cod_Estado
			,Observaciones = @Observaciones
			,Email = @Email
		WHERE Folio_Pref = @Folio_Pref
	
	END
	
	
	DELETE FROM Ventas_Detalle_Prefactura WHERE Folio_Pref = @Folio_Pref AND Cod_Servicio IN(10, 20, 80)
	
	--SERVICIO BASE
	DECLARE 
		@POS_PROPORCIONAL VARCHAR(2),
		@VALOR_VENTA NUMERIC(18, 5),
		@Valor_Costo NUMERIC(18, 5),
		@Dias_Mes NUMERIC(18, 0),
		@Tarifa_Diaria NUMERIC(18, 5),
		@Total_Pos_Base NUMERIC(18, 0)	
			

		
	--SERVICIO ADICIONAL
	DECLARE 
		@APOS_PROPORCIONAL VARCHAR(2),
		@AVALOR_VENTA NUMERIC(18, 5),
		@AValor_Costo NUMERIC(18, 5),
		@ADias_Mes NUMERIC(18, 0),
		@ATarifa_Diaria NUMERIC(18, 5),
		@ATotal_Pos_Base NUMERIC(18, 0)	
		

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
	
	IF EXISTS(SELECT * FROM Ventas_Unidades_Cobro WHERE ID_Holding_Propietario = @ID_Holding_Propietario AND VIGENCIA = 'S' AND COD_SERVICIO = 10) BEGIN
		
		SELECT 
			 @POS_PROPORCIONAL = POSICION_PROPORCIONAL
			,@VALOR_VENTA = VALOR_VENTA
			,@Dias_Mes = Dias_Mes
			,@Tarifa_Diaria = Tarifa_Diaria
			,@Total_Pos_Base = Total_Pos_Base
		FROM Ventas_Unidades_Cobro --UC
			--INNER JOIN Ventas_Monedas M
			--	ON UC.COD_MONEDA = M.COD_MONEDA
		WHERE ID_Holding_Propietario = @ID_Holding_Propietario
			AND VIGENCIA = 'S'
			AND COD_SERVICIO = 10		
		
		--SI ES MAYOR A CERO CALCULAMOS POSICIONES ADICIONALES
		IF @Total_Pos_Base > 0 BEGIN
			
			--AQUI CALCULA CON SERVICIO BASE 10 Y 20
			
			SELECT 
				 @APOS_PROPORCIONAL = POSICION_PROPORCIONAL
				,@AVALOR_VENTA = VALOR_VENTA
				,@ADias_Mes = Dias_Mes
				,@ATarifa_Diaria = Tarifa_Diaria
			FROM Ventas_Unidades_Cobro --UC
				--INNER JOIN Ventas_Monedas M
				--	ON UC.COD_MONEDA = M.COD_MONEDA
			WHERE ID_Holding_Propietario = @ID_Holding_Propietario
				AND VIGENCIA = 'S'
				AND COD_SERVICIO = 20	
			
			--CALCULO 10
			--IF (@POS_PROPORCIONAL = 'SI') BEGIN
		    
				--SELECT * FROM Ventas_Dias_Permanencia WHERE  DIAS_PERMANENCIA = 13
				--AGRUPACIÓN PARA MOSTRAR EN TABLA DETALLE DE FACTURA		    				
				INSERT INTO Ventas_Detalle_Prefactura
				SELECT 
					 @Folio_Pref FolioPref
					,ROW_NUMBER() OVER(ORDER BY DIAS_PERMANENCIA DESC) NroLinea
					,10 CodigoServicio
					,@SERVICIO_BASE	Descripcion				
					,FLOOR(CANTIDAD_UBICACIONES) TOTAL_POSICIONES
					,DIAS_PERMANENCIA 
					,@VALOR_UF * @Tarifa_Diaria PrecioDia
					,@VALOR_UF * @Tarifa_Diaria * DIAS_PERMANENCIA PrecioUnitario
					,((@VALOR_UF * @Tarifa_Diaria) * DIAS_PERMANENCIA) * CANTIDAD_UBICACIONES ValorTotal										
					FROM 
				(SELECT 
					 DIAS_PERMANENCIA
					,DBO.FN_CALCULOPOSICION(SUM(TOTAL_POS_PROPORCIONAL)) CANTIDAD_UBICACIONES
				FROM Ventas_Dias_Permanencia DP
					INNER JOIN INVENTARIO_LOTES LOTE
						ON DP.ID_LOTE = LOTE.ID_LOTE
				WHERE DP.Año = @Año 
					AND DP.Mes = @Mes
					AND DP.ID_Holding_Propietario = @ID_Holding_Propietario --52--
					AND  TOTAL_POS_PROPORCIONAL > 0
				GROUP BY DP.DIAS_PERMANENCIA) TABLA
				GROUP BY DIAS_PERMANENCIA, CANTIDAD_UBICACIONES
				ORDER BY DIAS_PERMANENCIA DESC
				
				--SI TOTAL POSICIONES MAYOR A CANTIDAD DE POSICIONES
				DECLARE @FOLIO_TOTAL_POSICIONES NUMERIC(18, 0)
				
				SELECT @FOLIO_TOTAL_POSICIONES = SUM(TOTAL_POSICIONES)
					FROM Ventas_Detalle_Prefactura DP
					WHERE Folio_Pref = @Folio_Pref
				
				IF @FOLIO_TOTAL_POSICIONES > @Total_Pos_Base BEGIN 
					
					--ACTUALIZACIÓN DE TOTAL_POSICIONES MAYOR CANTIDAD DE DIAS DE PERMANENCIA
					UPDATE Ventas_Detalle_Prefactura 
						SET TOTAL_POSICIONES = (TOTAL_POSICIONES - (@FOLIO_TOTAL_POSICIONES - @Total_Pos_Base))
					WHERE Folio_Pref = @Folio_Pref
						AND DIAS_PERMANENCIA = (SELECT MAX(DIAS_PERMANENCIA) FROM Ventas_Detalle_Prefactura WHERE Folio_Pref = @Folio_Pref);	
						
					--
					UPDATE Ventas_Detalle_Prefactura 
						SET  PRECIOXDIA = @VALOR_UF * @Tarifa_Diaria --PrecioDia
							,PRECIO_UNITARIO = (@VALOR_UF * @Tarifa_Diaria) * DIAS_PERMANENCIA --PrecioUnitario
							,VALOR_TOTAL = ((@VALOR_UF * @Tarifa_Diaria) * DIAS_PERMANENCIA) * TOTAL_POSICIONES --ValorTotal	
					WHERE Folio_Pref = @Folio_Pref;						
								
					
					INSERT INTO Ventas_Detalle_Prefactura
					SELECT TOP 1
						 @Folio_Pref
						,(SELECT MAX(NRO_LINEA) + 1 FROM Ventas_Detalle_Prefactura WHERE Folio_Pref = @Folio_Pref)
						,20
						,@SERVICIO_ADICIONAL
						,(@FOLIO_TOTAL_POSICIONES - @Total_Pos_Base) POSICIONES
						,DIAS_PERMANENCIA
						,@VALOR_UF * @ATarifa_Diaria PrecioDia
						,(@VALOR_UF * @ATarifa_Diaria) * DIAS_PERMANENCIA PrecioUnitario
						,((@VALOR_UF * @ATarifa_Diaria) * DIAS_PERMANENCIA) * (@FOLIO_TOTAL_POSICIONES - @Total_Pos_Base) ValorTotal							
					FROM Ventas_Detalle_Prefactura
					WHERE Folio_Pref = @Folio_Pref
						AND DIAS_PERMANENCIA = (SELECT MAX(DIAS_PERMANENCIA) FROM Ventas_Detalle_Prefactura WHERE Folio_Pref = @Folio_Pref)
					GROUP BY DIAS_PERMANENCIA 
					
				END
	
			
			--END			
			
			
			
			 
			
			
			--CALCULO 20
							
			
		
		
		END 
		--ELSE BEGIN 
		
		--	--AQUI CALCULA CON SERVICIO BASE 10 
			
		
		
		
		
		
		--END
	
	END
	
	
	/*
	ELSE BEGIN
		IF EXISTS(SELECT * FROM Ventas_Unidades_Cobro WHERE ID_Holding_Propietario = @ID_Holding_Propietario AND VIGENCIA = 'S' AND COD_SERVICIO = 20) BEGIN
			
			SELECT 
				 @APOS_PROPORCIONAL = POSICION_PROPORCIONAL
				,@AVALOR_VENTA = VALOR_VENTA
				,@ADias_Mes = Dias_Mes
				,@ATarifa_Diaria = Tarifa_Diaria
			FROM Ventas_Unidades_Cobro --UC
				--INNER JOIN Ventas_Monedas M
				--	ON UC.COD_MONEDA = M.COD_MONEDA
			WHERE ID_Holding_Propietario = @ID_Holding_Propietario
				AND VIGENCIA = 'S'
				AND COD_SERVICIO = 20	
							

		
		
		
		END
	END 
	*/		
	
	DECLARE @SUBTOTAL NUMERIC(18, 0) = 0;
	
	SELECT @SUBTOTAL = SUM(Valor_Total) 
	FROM Ventas_Detalle_Prefactura 
	WHERE FOLIO_PREF = @Folio_Pref	
	
	DELETE FROM Ventas_Totales_Factura WHERE Folio_Pref = @Folio_Pref
		
	--INSERT INTO Ventas_Totales_Factura	
	--SELECT @Folio_Pref Folio
	--	  ,@SUBTOTAL SubTotal
	--	  ,0 PorcDesc
	--	  ,0 ValorDescuento
	--	  ,(@SUBTOTAL - 0) ValorNeto 
	--	  ,10 CodIva
	--	  ,((@SUBTOTAL - 0) * (select IVA from Ventas_Iva where Cod_Iva = 10)) / 100 ValorIva
	--	  ,(@SUBTOTAL - 0) + (((@SUBTOTAL - 0) * (select IVA from Ventas_Iva where Cod_Iva = 10)) / 100) ValorTotal
	--	  ,@ID_Org OrganizacionId
	INSERT INTO Ventas_Totales_Factura	
	SELECT @Folio_Pref Folio
		  ,@SUBTOTAL SubTotal
		  ,@Porc_Desc PorcDesc
		  ,((@SUBTOTAL * @Porc_Desc) / 100) ValorDescuento
		  ,(@SUBTOTAL - ((@SUBTOTAL * @Porc_Desc) / 100)) ValorNeto 
		  ,10 CodIva
		  ,((@SUBTOTAL - ((@SUBTOTAL * @Porc_Desc) / 100)) * (select IVA from Ventas_Iva where Cod_Iva = 10)) / 100 ValorIva
		  ,((@SUBTOTAL - ((@SUBTOTAL * @Porc_Desc) / 100))) + (((@SUBTOTAL - ((@SUBTOTAL * @Porc_Desc) / 100)) * (select IVA from Ventas_Iva where Cod_Iva = 10)) / 100) ValorTotal
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
