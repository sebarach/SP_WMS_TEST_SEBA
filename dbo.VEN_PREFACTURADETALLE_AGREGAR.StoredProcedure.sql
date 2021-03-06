USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_PREFACTURADETALLE_AGREGAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_PREFACTURADETALLE_AGREGAR]
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
	,@Cod_Servicio numeric(18, 0)
	,@Descripcion_Detalle varchar(MAX)
	,@Total_Posiciones numeric(18, 0)
	,@Dias_Permanencia numeric(18, 0)
	,@PrecioxDia numeric(18, 0)
	,@Precio_Unitario numeric(18, 0)
	,@Valor_Total numeric(18, 0)
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
	
	
	--DELETE FROM Ventas_Detalle_Prefactura WHERE Folio_Pref = @Folio_Pref AND Cod_Servicio IN(10, 20, 80)
	--ROW_NUMBER() OVER(ORDER BY DIAS_PERMANENCIA DESC) NroLinea	
	DECLARE @NRO_LINEA NUMERIC(18, 0) = 1;
	
	IF EXISTS(SELECT * FROM Ventas_Detalle_Prefactura WHERE Folio_Pref = @Folio_Pref) BEGIN
		
		SELECT @NRO_LINEA = MAX(Nro_Linea) + 1 FROM Ventas_Detalle_Prefactura WHERE Folio_Pref = @Folio_Pref
	
	END 	
	    		
	INSERT INTO Ventas_Detalle_Prefactura
	SELECT
		 @Folio_Pref
		,@NRO_LINEA
		,@Cod_Servicio 
		,@Descripcion_Detalle 
		,@Total_Posiciones 
		,@Dias_Permanencia
		,@PrecioxDia 
		,@Precio_Unitario 
		,@Valor_Total		
	
	DECLARE @SUBTOTAL NUMERIC(18, 0) = 0;
	
	SELECT @SUBTOTAL = SUM(Valor_Total) 
	FROM Ventas_Detalle_Prefactura 
	WHERE FOLIO_PREF = @Folio_Pref	
	
	DELETE FROM Ventas_Totales_Factura WHERE Folio_Pref = @Folio_Pref
		
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
	  ,1 CORRECTO, 'Detalle agregado exitosamente' MENSAJE      
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
