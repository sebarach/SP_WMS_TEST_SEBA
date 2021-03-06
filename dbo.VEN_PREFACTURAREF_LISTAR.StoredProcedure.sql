USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_PREFACTURAREF_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC VEN_PREFACTURAREF_LISTAR 52, 17
CREATE PROCEDURE [dbo].[VEN_PREFACTURAREF_LISTAR]
--DECLARE
	 @Id_Holding numeric(18, 0),
	 @COD_SERVICIO NUMERIC(18, 0),
	 @ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @VALOR_UF NUMERIC(18, 2)
	
	SELECT TOP 1 @VALOR_UF = VALOR
	FROM VENTAS_TIPO_CAMBIO
	WHERE COD_MONEDA = 3
		AND VIGENCIA = 'S'
	ORDER BY AÑO DESC, MES DESC, DIA DESC	

	SELECT @VALOR_UF Uf
		  ,[Valor_Venta] ValorVenta
		  ,[Tarifa_Diaria] TarifaDiaria
		  ,Cod_moneda CodigoMoneda
	  FROM [Ventas_Unidades_Cobro]
	WHERE ID_HOLDING_PROPIETARIO = @Id_Holding
		AND COD_SERVICIO = 	 @COD_SERVICIO 
		AND ID_ORG = @ID_ORG
		
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
