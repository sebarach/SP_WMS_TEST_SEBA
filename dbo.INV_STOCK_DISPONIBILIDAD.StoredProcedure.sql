USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_STOCK_DISPONIBILIDAD]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_STOCK_DISPONIBILIDAD]
	-- Add the parameters for the stored procedure here
--DECLARE
	 @SUBINV NUMERIC(18, 0)
	,@ID_LOTE1 VARCHAR(50) 
	,@ID_LOTE2 VARCHAR(50)
	,@COD_ITEM1 NUMERIC(18, 0)
	,@COD_ITEM2 NUMERIC(18, 0)	
	,@ID_ORG NUMERIC(18, 0)
	,@LOCALIZADOR VARCHAR(50)
	,@DEVUELVE_DUENO NUMERIC(1)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--SET @SUBINV = 50
	--SET @ID_LOTE1 = '201705000010'
	--SET @ID_LOTE2 = '201705000033'
	--SET @COD_ITEM1 = 53150
	--SET @COD_ITEM2 = 53150
	--SET @ID_ORG = 17	
	
	
	DECLARE 
		 @VAR_SUBINV VARCHAR(200) = ''
		,@VAR_IDLOTE VARCHAR(400) = ''
		,@VAR_CODITEM VARCHAR(100) = ''
		,@VAR_IDORG VARCHAR(100) = ''
		,@VAR_LOCALIZADOR VARCHAR(200) = ''
		,@STR_QUERY VARCHAR(MAX)
	
	IF @SUBINV > 0 BEGIN
		SET @VAR_SUBINV = ' AND SUBINV.ID_SUBINV = ' + CAST(@SUBINV AS VARCHAR(100))
	END 

	IF @ID_LOTE1 <> '' AND @ID_LOTE2 <> '' BEGIN
		PRINT 'FILTROS LOTE'
		SET @VAR_IDLOTE = ' AND LOTE.ID_LOTE BETWEEN ''' + CAST(@ID_LOTE1 AS VARCHAR(100)) + ''' AND ''' + CAST(@ID_LOTE2 AS VARCHAR(100)) + ''''
	END 
	
	IF @COD_ITEM1 > 0 AND @COD_ITEM2 > 0 BEGIN
		PRINT 'FILTROS SKU'
		SET @VAR_CODITEM = ' AND LOTE.COD_ITEM BETWEEN ' + CAST(@COD_ITEM1 AS VARCHAR(100)) + ' AND ' + CAST(@COD_ITEM2 AS VARCHAR(100)) 
	END 				
	
	IF @ID_ORG > 0 BEGIN
		SET @VAR_IDORG = CAST(@ID_ORG AS VARCHAR(25))
	END 	
	
	IF @LOCALIZADOR <> '' BEGIN
		PRINT 'FILTROS LOCALIZADOR'
		SET @VAR_LOCALIZADOR = ' AND LOC.Combinacion_Localizador LIKE ''' + @LOCALIZADOR + '%'''
	END 	
	
	PRINT @VAR_CODITEM

	IF @DEVUELVE_DUENO = 0 BEGIN
		SET @STR_QUERY = 'SELECT		
			 '''' Propietario
			,'''' Dueno
			,PROD.COD_ITEM ProductoId
			,PROD.DESCRIPTOR_CORTA Descriptor
			,STOCK.ID_LOTE Lote	
			,LOTE.LOTE_PROVEEDOR LoteProveedor	
			,ISNULL(CONVERT(VARCHAR(10),CONVERT(DATE,LOTE.Fecha_Expira,106),103), '''') FechaVencimiento
			,STOCK.En_Mano EnMano
			,STOCK.DISPONIBLE Disponible
			,STOCK.Reserva Reserva
			,UM.UNIDAD_MEDIDA UnidadMedida
			,SUBINV.Descripcion SubInventario
			,LOC.COMBINACION_LOCALIZADOR Localizador	
			,ISNULL(CONVERT(VARCHAR(10),CONVERT(DATE,LOTE.FECH_CREACION,106),103), '''') FechaCreacion
		FROM Inventario_Stock_Lotes STOCK
			INNER JOIN Inventario_SubInv_Localizadores LOC
				ON STOCK.ID_Localizador = LOC.ID_LOCALIZADOR AND STOCK.ID_Org = LOC.ID_ORG
			INNER JOIN Inventario_LOTES LOTE
				ON STOCK.ID_Lote = LOTE.ID_LOTE AND STOCK.ID_Org = LOTE.ID_ORG
			INNER JOIN Inventario_Items PROD
				ON LOTE.COD_ITEM = PROD.COD_ITEM AND LOTE.ID_ORG = PROD.ID_ORG
			INNER JOIN INVENTARIO_SUBINVENTARIOS SUBINV
				ON LOC.ID_SUBINV = SUBINV.ID_SUBINV
			INNER JOIN Inventario_Unidad_Medida_Primaria UM
				ON PROD.ID_UM = UM.ID_UM 
		WHERE PROD.VIGENCIA = ''S'' AND  STOCK.ID_ORG = ' + @VAR_IDORG
			+ @VAR_SUBINV
			+ @VAR_IDLOTE
			+ @VAR_CODITEM
			+ @VAR_LOCALIZADOR;
	END
	ELSE BEGIN

		SET @STR_QUERY = 'SELECT		
			 '''' Propietario
			,C.NOMBRES + '' '' + C.APELLIDO_PATERNO + '' '' + C.APELLIDO_MATERNO Dueno
			,PROD.COD_ITEM ProductoId
			,PROD.DESCRIPTOR_CORTA Descriptor
			,STOCK.ID_LOTE Lote	
			,LOTE.LOTE_PROVEEDOR LoteProveedor	
			,ISNULL(CONVERT(VARCHAR(10),CONVERT(DATE,LOTE.Fecha_Expira,106),103), '''') FechaVencimiento
			,STOCK.En_Mano EnMano
			,STOCK.DISPONIBLE Disponible
			,STOCK.Reserva Reserva
			,UM.UNIDAD_MEDIDA UnidadMedida
			,SUBINV.Descripcion SubInventario
			,LOC.COMBINACION_LOCALIZADOR Localizador	
			,ISNULL(CONVERT(VARCHAR(10),CONVERT(DATE,LOTE.FECH_CREACION,106),103), '''') FechaCreacion
		FROM Inventario_Stock_Lotes STOCK
			INNER JOIN Inventario_SubInv_Localizadores LOC
				ON STOCK.ID_Localizador = LOC.ID_LOCALIZADOR AND STOCK.ID_Org = LOC.ID_ORG
			INNER JOIN Inventario_LOTES LOTE
				ON STOCK.ID_Lote = LOTE.ID_LOTE AND STOCK.ID_Org = LOTE.ID_ORG
			INNER JOIN Adm_System_Dueños DUENO
				ON LOTE.ID_DUEÑO = DUENO.ID_DUEÑO AND LOTE.ID_ORG = DUENO.ID_ORG
			INNER JOIN Adm_System_Contactos C
				ON DUENO.ID_CONTACTO = C.ID_CONTACTO AND DUENO.ID_ORG = C.ID_ORG					
			INNER JOIN Inventario_Items PROD
				ON LOTE.COD_ITEM = PROD.COD_ITEM AND LOTE.ID_ORG = PROD.ID_ORG
			INNER JOIN INVENTARIO_SUBINVENTARIOS SUBINV
				ON LOC.ID_SUBINV = SUBINV.ID_SUBINV
			INNER JOIN Inventario_Unidad_Medida_Primaria UM
				ON PROD.ID_UM = UM.ID_UM 
		WHERE  PROD.VIGENCIA = ''S'' AND STOCK.ID_ORG = ' + @VAR_IDORG
			+ @VAR_SUBINV
			+ @VAR_IDLOTE
			+ @VAR_CODITEM
			+ @VAR_LOCALIZADOR;

	END

	--PRINT @STR_QUERY;
	
    -- Insert statements for procedure here
	EXEC (@STR_QUERY);
	
	
	
	
	
	
	/*
	SELECT * FROM Inventario_Stock_Lotes
	
	SELECT * FROM Inventario_SubInv_Localizadores
	
	SELECT * FROM Inventario_LOTES
	
	SELECT * FROM Inventario_Items
	
	SELECT * FROM Inventario_Items_Prop_Dueños
	
	SELECT * FROM Adm_System_Dueños
	
	SELECT * FROM Adm_System_Contactos
	
	SELECT * FROM dbo.Adm_System_Holding
	
	SELECT * FROM INVENTARIO_SUBINVENTARIOS
	
	SELECT * FROM Inventario_Unidad_Medida_Primaria
	
	*/
	
	/*
SELECT		
		-- PROP.NOMBRE Propietario
		--,CONTACTO.NOMBRES + ' ' + APELLIDO_PATERNO + ' ' + APELLIDO_MATERNO Dueno
		 PROD.COD_ITEM ProductoId
		,PROD.DESCRIPTOR_CORTA Descriptor
		,STOCK.ID_LOTE Lote	
		,LOTE.LOTE_PROVEEDOR LoteProveedor	
		,ISNULL(CONVERT(VARCHAR(10),CONVERT(DATE,LOTE.Fecha_Expira,106),103), '') FechaVencimiento
		,STOCK.En_Mano EnMano
		,STOCK.DISPONIBLE Disponible
		,STOCK.Reserva Reserva
		,UM.UNIDAD_MEDIDA UnidadMedida
		,SUBINV.Descripcion SubInventario
		,LOC.COMBINACION_LOCALIZADOR Localizador	
		,ISNULL(CONVERT(VARCHAR(10),CONVERT(DATE,LOTE.FECH_CREACION,106),103), '') FechaCreacion
	FROM Inventario_Stock_Lotes STOCK
		INNER JOIN Inventario_SubInv_Localizadores LOC
			ON STOCK.ID_Localizador = LOC.ID_LOCALIZADOR AND STOCK.ID_Org = LOC.ID_ORG
		INNER JOIN Inventario_LOTES LOTE
			ON STOCK.ID_Lote = LOTE.ID_LOTE AND STOCK.ID_Org = LOTE.ID_ORG
		INNER JOIN Inventario_Items PROD
			ON LOTE.COD_ITEM = PROD.COD_ITEM AND LOTE.ID_ORG = PROD.ID_ORG
		INNER JOIN INVENTARIO_SUBINVENTARIOS SUBINV
			ON LOC.ID_SUBINV = SUBINV.ID_SUBINV
		INNER JOIN Inventario_Unidad_Medida_Primaria UM
			ON PROD.ID_UM = UM.ID_UM 
		--INNER JOIN Inventario_Items_Prop_Dueños PROPDUENO
		--	ON PROD.COD_ITEM = PROPDUENO.COD_ITEM AND PROD.ID_ORG = PROPDUENO.ID_ORG
		--INNER JOIN Adm_System_Holding PROP
		--	ON PROPDUENO.ID_PROPIETARIO = PROP.ID_HOLDING AND PROPDUENO.ID_ORG = PROP.ID_ORG AND ESPROPIETARIO = 1
		--INNER JOIN Adm_System_Dueños DUENO
		--	ON PROPDUENO.ID_DUEÑO = DUENO.ID_DUEÑO AND PROPDUENO.ID_ORG = DUENO.ID_ORG
		--INNER JOIN Adm_System_Contactos CONTACTO
		--	ON DUENO.ID_CONTACTO = CONTACTO.ID_CONTACTO AND DUENO.ID_ORG = CONTACTO.ID_ORG	
	*/
	
	
	
END
GO
