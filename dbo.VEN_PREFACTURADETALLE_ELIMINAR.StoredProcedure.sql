USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_PREFACTURADETALLE_ELIMINAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_PREFACTURADETALLE_ELIMINAR]
--DECLARE
	 @Folio_Pref numeric(18, 0)
	,@Nro_Linea numeric(18, 0)
	,@ID_Org numeric(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	--SET @Folio_Pref = 25
	--SET @Nro_Linea = 1
	--SET @ID_Org = 17
	--BEGIN TRAN
	
	SET NOCOUNT ON;
	
	DECLARE @FOLIO_ACTUAL NUMERIC(18, 0)
	DECLARE @FECHA DATETIME = GETDATE();

	
	DECLARE @ELIMINADO NUMERIC(1) = 0;
	--DELETE FROM Ventas_Detalle_Prefactura WHERE Folio_Pref = @Folio_Pref AND Cod_Servicio IN(10, 20, 80)
	--ROW_NUMBER() OVER(ORDER BY DIAS_PERMANENCIA DESC) NroLinea	
	DECLARE @NUEVA_LINEA NUMERIC(18, 0) = 0;
	
	DECLARE @LINEA_TABLA NUMERIC(18, 0)
	
	DECLARE CDETALLE CURSOR FOR
	SELECT Nro_Linea
	FROM Ventas_Detalle_Prefactura 
	WHERE Folio_Pref = @Folio_Pref 
	ORDER BY Nro_Linea ASC
	
	OPEN CDETALLE
	
	FETCH CDETALLE INTO @LINEA_TABLA
	
	WHILE (@@FETCH_STATUS = 0) BEGIN
	
	    IF (@LINEA_TABLA = @Nro_Linea AND @ELIMINADO = 0) BEGIN
			--PRINT 'ELIMINA'
			DELETE 
			FROM Ventas_Detalle_Prefactura 
			WHERE Folio_Pref = @Folio_Pref AND Nro_Linea = @Nro_Linea
			
			SET @ELIMINADO = 1
			
		END
		ELSE BEGIN
			--PRINT 'ACTUALIZA'
			SET @NUEVA_LINEA = @NUEVA_LINEA + 1
			
			UPDATE Ventas_Detalle_Prefactura
				SET Nro_Linea = @NUEVA_LINEA
			WHERE Folio_Pref = @Folio_Pref AND Nro_Linea = @LINEA_TABLA
			
			
		
		END
		
		FETCH CDETALLE INTO @LINEA_TABLA
	
	END
	
	
	CLOSE CDETALLE
	
	DEALLOCATE CDETALLE
	
	
	
	
	
	
	
	
	
	
	--CÁLCULO TOTALES
	DECLARE @SUBTOTAL NUMERIC(18, 0) = 0;
	
	SELECT @SUBTOTAL = SUM(Valor_Total) 
	FROM Ventas_Detalle_Prefactura 
	WHERE FOLIO_PREF = @Folio_Pref	
	
	DECLARE @Porc_Desc NUMERIC(18, 5) = 0;
	
	SELECT @Porc_Desc = Porc_Desc FROM Ventas_Totales_Factura WHERE Folio_Pref = @Folio_Pref;
	
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
	  ,1 CORRECTO, 'Línea eliminada del Detalle exitosamente' MENSAJE      
  FROM [Ventas_Cabecera_Prefactura]
  WHERE Folio_Pref = @Folio_Pref



	
END
GO
