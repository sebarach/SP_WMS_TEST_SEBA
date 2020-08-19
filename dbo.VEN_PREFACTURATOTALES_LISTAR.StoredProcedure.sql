USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_PREFACTURATOTALES_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_PREFACTURATOTALES_LISTAR]
--DECLARE
	 @Folio_Pref numeric(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SELECT [Folio_Pref] Folio
      ,[Sub_Total] SubTotal
      ,[Porc_Desc] PorcDesc
      ,[Valor_Descuento] ValorDescuento
      ,[Valor_Neto] ValorNeto
      ,[Cod_Iva] CodIva
      ,[Valor_Iva] ValorIva
      ,[Valor_Total] ValorTotal
      --,[ID_Org] 
	FROM [Ventas_Totales_Factura]
	WHERE FOLIO_PREF = @FOLIO_PREF


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
