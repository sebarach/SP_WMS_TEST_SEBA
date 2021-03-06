USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_PREFACTURADETALLE_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_PREFACTURADETALLE_LISTAR]
--DECLARE
	 @Folio_Pref numeric(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SELECT Folio_Pref Folio
		  ,Nro_Linea id
		  ,Cod_Servicio CodServicio
		  ,Descripcion_Detalle Detalle
		  ,Total_Posiciones TotalPosiciones
		  ,Dias_Permanencia DiasPermanencia
		  ,PrecioxDia PrecioDia
		  ,Precio_Unitario PrecioUnitario
		  ,Valor_Total ValorTotal
	  FROM [Ventas_Detalle_Prefactura]
	WHERE FOLIO_PREF = @FOLIO_PREF
	ORDER BY Nro_Linea ASC
	
	

					

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
