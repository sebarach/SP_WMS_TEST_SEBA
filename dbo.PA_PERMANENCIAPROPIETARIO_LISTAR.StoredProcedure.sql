USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[PA_PERMANENCIAPROPIETARIO_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- 
CREATE PROCEDURE [dbo].[PA_PERMANENCIAPROPIETARIO_LISTAR]
	-- Add the parameters for the stored procedure here
	 @ID_PROPIETARIO NUMERIC(18,0)
	,@TIPO_COBRO NUMERIC(2)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE 
		 @VALOR_UF NUMERIC(18, 8) = 0
		,@PALLET NUMERIC(18,5)
		,@VALOR_VENTA NUMERIC(18, 5) = 0
		,@NOMBRE_SERVICIO VARCHAR(250)
		
	SELECT @VALOR_VENTA = VALOR_VENTA FROM Ventas_Unidades_Cobro
	WHERE ID_HOLDING_PROPIETARIO = @ID_PROPIETARIO
		AND VIGENCIA = 'S'
		AND COD_SERVICIO = @TIPO_COBRO
		

    
	-- IF @VALOR_VENTA = 0 BEGIN
--   SELECT * FROM Ventas_Servicios


	--	select @NOMBRE_SERVICIO = 'Este propietario no cuenta con el servicio ' + Nombre from Ventas_Servicios where cod_servicio = @TIPO_COBRO
	--	RAISERROR (@NOMBRE_SERVICIO, 
	--		16, -- Severidad 
	--		1   -- Estado
	--		)
--		RETURN	
--	END 	

	

    
		-- PYG
    IF @ID_PROPIETARIO = 52 BEGIN 

    	SELECT TOP 1 @VALOR_UF = VALOR 
	FROM VENTAS_TIPO_CAMBIO
	WHERE COD_MONEDA = 3
		AND VIGENCIA = 'S'
		AND AÑO = DATEPART(YYYY, GETDATE())
		AND MES = DATEPART(MM, GETDATE())
		AND DIA = DATEPART(DD, GETDATE())	
		
	IF @VALOR_UF = 0 BEGIN
		
		select @NOMBRE_SERVICIO = 'Valor UF no cargada en el sistema, para continuar favor cargar la UF del día de hoy.'
		
		RAISERROR (@NOMBRE_SERVICIO, 
			16, -- Severidad 
			1   -- Estado
			)
		RETURN	
	END 


	SELECT @PALLET = VOL_PALLET FROM Inventario_Pallet

    -- Insert statements for procedure here
	SELECT
		 PROP.NOMBRE Propietario	
		,PROD.COD_ITEM SKU	
		,PROD.DESCRIPTOR_CORTA Descripcion	
		,LOTE.ID_Lote Lote
		,STOCK.Disponible Stock	
		,UNIDAD.UNIDAD_MEDIDA Unidad	
		,ISNULL(Convert(varchar(10),CONVERT(date,LOTE.Fecha_Origen,106),103), '') FechaIngreso
		,ISNULL(Convert(varchar(10),CONVERT(date,LOTE.Fecha_Expira,106),103), '') FechaVencimiento
		,Convert(varchar(10),CONVERT(date,getdate(),106),103) FechaHoy
		,ISNULL(Convert(varchar(10),CONVERT(date,LOTE.Fecha_Origen+PROD.Dias_En_Estante,106),103), '') FechaTope --CALCULADO
		,DATEDIFF(DAY, getdate(), LOTE.Fecha_Origen + PROD.Dias_En_Estante) / 30 MesesPermanencia --CALCULADO
		,CASE 
			WHEN (DATEDIFF(DAY, getdate(), LOTE.Fecha_Origen + PROD.Dias_En_Estante) / 30) < 0 THEN 'VENCIDO'
			WHEN (DATEDIFF(DAY, getdate(), LOTE.Fecha_Origen + PROD.Dias_En_Estante) / 30) >= 0 AND (DATEDIFF(DAY, getdate(), LOTE.Fecha_Origen + PROD.Dias_En_Estante) / 30) <= 3 THEN 'POR VENCER'
			WHEN (DATEDIFF(DAY, getdate(), LOTE.Fecha_Origen + PROD.Dias_En_Estante) / 30) > 3 THEN 'VIGENTE'
		 END Estatus --CALCULADO
		,FAMILIA.NOMBRE_CATEG1 Familia	
		,CATEGORIA.NOMBRE_CATEG2 Categoría
		,MARCA.NOMBRE_CATEG3 Marca	
		,PROD.PRECIO_COMPRA PrecioUnidad
		,STOCK.Disponible * PROD.PRECIO_COMPRA Total
		,ISNULL(CONTACTO.NOMBRES, '') + ' ' + ISNULL(CONTACTO.APELLIDO_PATERNO, '') + ' ' + ISNULL(CONTACTO.APELLIDO_MATERNO, '') Dueño	
		,CASE 
			WHEN STOCK.En_Mano > 0 AND LOC.ID_SUBINV = 50 THEN ISNULL(DBO.FN_CALCULOF22(STOCK.En_Mano, PROD.VOLUMEN + @PALLET, LOC.VOLUMEN), 0)
			WHEN STOCK.En_Mano > 0 AND LOC.ID_SUBINV = 10 THEN ISNULL(ROUND(((STOCK.En_Mano * PROD.VOLUMEN) / LOC.VOLUMEN)+@PALLET, 2), 0)
			ELSE 0
		END Posiciones	
		,CASE 
			WHEN STOCK.En_Mano > 0 AND LOC.ID_SUBINV = 50 THEN ROUND(ISNULL(DBO.FN_CALCULOF22(STOCK.En_Mano, PROD.VOLUMEN + @PALLET, LOC.VOLUMEN), 0) * (@VALOR_VENTA * @VALOR_UF), 3)
			WHEN STOCK.En_Mano > 0 AND LOC.ID_SUBINV = 10 THEN ROUND(ISNULL(ROUND(((STOCK.En_Mano * PROD.VOLUMEN) / LOC.VOLUMEN)+@PALLET, 2), 0) * (@VALOR_VENTA * @VALOR_UF), 3)
			ELSE 0
		END ValorPosicion
		,@VALOR_VENTA ValorVenta
		,@VALOR_UF ValorUfActual
		,ROUND(@VALOR_VENTA * @VALOR_UF, 2) ValorEnPesos
	FROM INVENTARIO_STOCK_LOTES STOCK
		INNER JOIN INVENTARIO_LOTES LOTE
			ON STOCK.ID_LOTE = LOTE.ID_LOTE AND STOCK.ID_ORG = LOTE.ID_ORG
		INNER JOIN Inventario_SubInv_Localizadores LOC
			ON STOCK.ID_Localizador = LOC.ID_LOCALIZADOR AND STOCK.ID_Org = LOC.ID_ORG
		INNER JOIN Inventario_SubInventarios SUBINV
			ON LOC.ID_SUBINV = SUBINV.ID_SUBINV
		INNER JOIN INVENTARIO_ITEMS PROD
			ON LOTE.Cod_Item = PROD.COD_ITEM AND LOTE.ID_Org = PROD.ID_ORG
		INNER JOIN Inventario_Unidad_Medida_Primaria UNIDAD --SELECT * FROM Inventario_Unidad_Medida_Primaria
			ON PROD.ID_UM = UNIDAD.ID_UM
		INNER JOIN Adm_System_Dueños DUENO
			ON LOTE.ID_Dueño = DUENO.ID_DUEÑO AND LOTE.ID_Org = DUENO.ID_ORG 
		INNER JOIN Adm_System_Contactos CONTACTO
			ON DUENO.ID_CONTACTO = CONTACTO.ID_CONTACTO AND DUENO.ID_ORG = CONTACTO.ID_ORG			
		INNER JOIN Adm_System_Holding PROP
			ON DUENO.ID_HOLDING_PROPIETARIO = PROP.ID_HOLDING AND DUENO.ID_Org = PROP.ID_ORG 	
		LEFT JOIN Inventario_Categoria1 FAMILIA
			ON FAMILIA.COD_CATEG1 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 1, 4)						
		LEFT JOIN Inventario_Categoria2 CATEGORIA
			ON CATEGORIA.COD_CATEG2 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 6, 4)
			AND CATEGORIA.COD_CATEG1 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 1, 4)
		LEFT JOIN Inventario_Categoria3 MARCA
			ON MARCA.COD_CATEG3 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 11, 4)		
			AND MARCA.COD_CATEG2 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 6, 4)						
	WHERE LOC.VIGENCIA = 'S'
		AND LOC.COD_ESTADO = 1
		AND STOCK.ID_ORG = @ID_ORG
		AND STOCK.En_Mano > 0
		AND PROP.ID_HOLDING = @ID_PROPIETARIO

        END


        -- OTROSS CLIENTES
        ELSE
        
        BEGIN

            SELECT
		 PROP.NOMBRE Propietario	
		,PROD.COD_ITEM SKU	
		,PROD.DESCRIPTOR_CORTA Descripcion	
		,LOTE.ID_Lote Lote
		,STOCK.Disponible Stock	
		,UNIDAD.UNIDAD_MEDIDA Unidad	
		,ISNULL(Convert(varchar(10),CONVERT(date,LOTE.Fecha_Origen,106),103), '') FechaIngreso
		,ISNULL(Convert(varchar(10),CONVERT(date,LOTE.Fecha_Expira,106),103), '') FechaVencimiento
		,Convert(varchar(10),CONVERT(date,getdate(),106),103) FechaHoy
		,ISNULL(Convert(varchar(10),CONVERT(date,LOTE.Fecha_Origen+PROD.Dias_En_Estante,106),103), '') FechaTope --CALCULADO
		,DATEDIFF(DAY, getdate(), LOTE.Fecha_Origen + PROD.Dias_En_Estante) / 30 MesesPermanencia --CALCULADO
		,CASE 
			WHEN (DATEDIFF(DAY, getdate(), LOTE.Fecha_Origen + PROD.Dias_En_Estante) / 30) < 0 THEN 'VENCIDO'
			WHEN (DATEDIFF(DAY, getdate(), LOTE.Fecha_Origen + PROD.Dias_En_Estante) / 30) >= 0 AND (DATEDIFF(DAY, getdate(), LOTE.Fecha_Origen + PROD.Dias_En_Estante) / 30) <= 3 THEN 'POR VENCER'
			WHEN (DATEDIFF(DAY, getdate(), LOTE.Fecha_Origen + PROD.Dias_En_Estante) / 30) > 3 THEN 'VIGENTE'
		 END Estatus --CALCULADO
		,FAMILIA.NOMBRE_CATEG1 Familia	
		,CATEGORIA.NOMBRE_CATEG2 Categoría
		,MARCA.NOMBRE_CATEG3 Marca	
		,PROD.PRECIO_COMPRA PrecioUnidad
		,STOCK.Disponible * PROD.PRECIO_COMPRA Total
		,ISNULL(CONTACTO.NOMBRES, '') + ' ' + ISNULL(CONTACTO.APELLIDO_PATERNO, '') + ' ' + ISNULL(CONTACTO.APELLIDO_MATERNO, '') Dueño	
	FROM INVENTARIO_STOCK_LOTES STOCK
		INNER JOIN INVENTARIO_LOTES LOTE
			ON STOCK.ID_LOTE = LOTE.ID_LOTE AND STOCK.ID_ORG = LOTE.ID_ORG
		INNER JOIN Inventario_SubInv_Localizadores LOC
			ON STOCK.ID_Localizador = LOC.ID_LOCALIZADOR AND STOCK.ID_Org = LOC.ID_ORG
		INNER JOIN Inventario_SubInventarios SUBINV
			ON LOC.ID_SUBINV = SUBINV.ID_SUBINV
		INNER JOIN INVENTARIO_ITEMS PROD
			ON LOTE.Cod_Item = PROD.COD_ITEM AND LOTE.ID_Org = PROD.ID_ORG
		INNER JOIN Inventario_Unidad_Medida_Primaria UNIDAD --SELECT * FROM Inventario_Unidad_Medida_Primaria
			ON PROD.ID_UM = UNIDAD.ID_UM
		INNER JOIN Adm_System_Dueños DUENO
			ON LOTE.ID_Dueño = DUENO.ID_DUEÑO AND LOTE.ID_Org = DUENO.ID_ORG 
		INNER JOIN Adm_System_Contactos CONTACTO
			ON DUENO.ID_CONTACTO = CONTACTO.ID_CONTACTO AND DUENO.ID_ORG = CONTACTO.ID_ORG			
		INNER JOIN Adm_System_Holding PROP
			ON DUENO.ID_HOLDING_PROPIETARIO = PROP.ID_HOLDING AND DUENO.ID_Org = PROP.ID_ORG 	
		LEFT JOIN Inventario_Categoria1 FAMILIA
			ON FAMILIA.COD_CATEG1 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 1, 4)						
		LEFT JOIN Inventario_Categoria2 CATEGORIA
			ON CATEGORIA.COD_CATEG2 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 6, 4)
			AND CATEGORIA.COD_CATEG1 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 1, 4)
		LEFT JOIN Inventario_Categoria3 MARCA
			ON MARCA.COD_CATEG3 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 11, 4)		
			AND MARCA.COD_CATEG2 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 6, 4)						
	WHERE LOC.VIGENCIA = 'S'
		AND LOC.COD_ESTADO = 1
		AND STOCK.ID_ORG =@ID_ORG
		AND STOCK.En_Mano > 0
		AND PROP.ID_HOLDING =@ID_PROPIETARIO

        END
     
END
GO
