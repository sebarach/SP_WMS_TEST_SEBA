USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_DIASPERMANENCIA_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_DIASPERMANENCIA_LISTAR] 
--DECLARE	
	 @ANIO NUMERIC(18, 0)
	,@MES NUMERIC(18, 0)
--	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--SET @ANIO = 2017
	--SET @MES = 8
	
	-- Insert statements for procedure here	
	--DECLARE @CADENA VARCHAR(10)
	--DECLARE CSTOCKLOTES CURSOR FOR
	
	SELECT 
	   DP.ID_Holding_Propietario PropietarioId
	  ,PROP.NOMBRE Propietario
      ,DP.Mes Mes
      ,DP.Año Anio
      ,DP.ID_Dueño DuenoId
      ,ISNULL(C.NOMBRES, '') + ' ' + ISNULL(C.APELLIDO_PATERNO, '') + ' ' + ISNULL(C.APELLIDO_MATERNO, '') Dueno 
      ,DP.Cod_Item ProductoId
      ,PROD.DESCRIPTOR_CORTA Descriptor
      ,DP.ID_Lote LoteId
      ,DP.EnMano
      ,DP.Dias_Permanencia Dias
      ,DP.Total_Pos_Enteras TotalPosEntera
      ,DP.Total_Pos_Proporcional TotalPorProporcional
      ,dp.SubInventario
      ,DP.Localizador
      ,PROD.PRECIO_COMPRA PrecioCompra
      ,PROD.VOLUMEN SkuVolumen
      ,dp.LocalizadorVolumen
      ,DP.TIPO_TRANSACCION TipoTransaccion
      ,ISNULL(CATEGORIA.NOMBRE_CATEG2, '') Categoria
      ,ISNULL(MARCA.NOMBRE_CATEG3, '') Marca
      ,PROD.Total_Cajas_Pallets TotalCajasPallets
      ,PROD.Unidades_Cajas UnidadesCajas
      ,PROD.Total_Unidades_Pallets TotalUnidadesPallets      
	FROM Ventas_Dias_Permanencia DP
		INNER JOIN ADM_SYSTEM_HOLDING PROP
			ON DP.ID_Holding_Propietario = PROP.ID_HOLDING AND PROP.ESPROPIETARIO = 1
		INNER JOIN Adm_System_Dueños D
			ON DP.ID_DUEÑO = D.ID_DUEÑO
		INNER JOIN Adm_System_Contactos C
			ON D.ID_CONTACTO = C.ID_CONTACTO AND D.ID_ORG = C.ID_ORG
		INNER JOIN INVENTARIO_ITEMS PROD
			ON DP.Cod_Item = PROD.COD_ITEM --AND LOTE.ID_Org = PROD.ID_ORG	
		LEFT JOIN Inventario_Categoria2 CATEGORIA
			ON CATEGORIA.COD_CATEG2 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 6, 4)
			AND CATEGORIA.COD_CATEG1 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 1, 4)
		LEFT JOIN Inventario_Categoria3 MARCA
			ON MARCA.COD_CATEG3 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 11, 4)		
			AND MARCA.COD_CATEG2 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 6, 4)
	WHERE DP.Año = @ANIO
		AND DP.Mes = @MES

	/*		
	
	SELECT * FROM ADM_SYSTEM_HOLDING
	
	SELECT * FROM INVENTARIO_STOCK_LOTES
	
	select * from Inventario_SubInv_Localizadores WHERE ID_SUBINV = 10
	
	select * from Inventario_SubInvENTARIOS --10 NORMAL --50 SOBREDIMENSIONADO
	
	SELECT * FROM INVENTARIO_LOTES
	
	SELECT * FROM INVENTARIO_ITEMS
	
	SELECT * FROM ADM_SYSTEM_DUEÑOS
	
	SELECT * FROM Inventario_Items_Prop_Dueños
		--INNER JOIN Inventario_Items_Prop_Dueños PROPDUENO
		--	ON DUENO.ID_DUEÑO = PROPDUENO.ID_DUEÑO AND DUENO.ID_ORG = PROPDUENO.ID_ORG

	--DELETE FROM Ventas_Dias_Permanencia
	
	SELECT * FROM Ventas_Dias_Permanencia
	
	*/	
		


	--OPEN CSTOCKLOTES
	 

	--FETCH CSTOCKLOTES INTO @CADENA
	
	
	--WHILE (@@FETCH_STATUS = 0) BEGIN
	
	--	PRINT @CADENA

	

	--	FETCH CSTOCKLOTES INTO @CADENA


	--END 


	--CLOSE CSTOCKLOTES

	--DEALLOCATE CSTOCKLOTES






END
GO
