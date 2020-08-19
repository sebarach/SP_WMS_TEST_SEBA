USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_STOCK_VISUALIZACION]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_STOCK_VISUALIZACION 0, '', '', 0, 17, 0, 0, 0, 0, 'MAXIMIZACION'''' ARIEL Y ACE'
CREATE PROCEDURE [dbo].[INV_STOCK_VISUALIZACION]
	-- Add the parameters for the stored procedure here --[INV_STOCK_VISUALIZACION] 0,'','',0,0,21983,0,0,0,''
--DECLARE
	 @COD_ITEM NUMERIC(18, 0)
	,@VALOR_REFERENCIA VARCHAR(100)
	,@DESCRIPTOR VARCHAR(250)	 
	,@ID_DUEÑO NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
	,@ID_PROPIETARIO NUMERIC(18, 0)
	,@FAMLIA NUMERIC(18, 0)
	,@CATEGORIA NUMERIC(18, 0)
	,@MARCA NUMERIC(18, 0)
	,@CAMPANIA VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--SET @COD_ITEM = 0--52810
	--SET @VALOR_REFERENCIA = ''--'23315'
	--SET @DESCRIPTOR = ''
	--SET @ID_DUEÑO = 0--372
	--SET @ID_ORG = 17
	--SET @ID_PROPIETARIO = 0
	--SET @FAMLIA = 0
	--SET @CATEGORIA = 0
	--SET @MARCA = 3105
	--SET @CAMPANIA = ''
	
	DECLARE 
		 @VAR_CODITEM VARCHAR(100) = ''
		,@VAR_VALORREFERENCIA VARCHAR(200) = ''
		,@VAR_DESCRIPTOR VARCHAR(500) = ''
		,@VAR_@IDDUEÑO VARCHAR(100) = ''
		,@VAR_IDORG VARCHAR(100) = ''
		,@VAR_IDPROPIETARIO VARCHAR(100) = ''
		,@VAR_FAMILIA VARCHAR(100) = ''
		,@VAR_CATEGORIA VARCHAR(100) = ''
		,@VAR_MARCA VARCHAR(100) = ''
		,@VAR_CAMPANIA VARCHAR(MAX) = ''
		,@VAR_VIGENCIA VARCHAR(100) = '' 
		,@STR_QUERY VARCHAR(MAX)
	
	--[INV_STOCK_VISUALIZACION] 0,'','',0,0,24323,0,0,0,''
	SET @VAR_VIGENCIA = ' PROD.VIGENCIA = ''s'''
	IF @COD_ITEM > 0 BEGIN
		SET @VAR_CODITEM = ' AND PROD.COD_ITEM = ' + CAST(@COD_ITEM AS VARCHAR(100)) + ''
	END 		
	
	IF @VALOR_REFERENCIA <> '' BEGIN
		SET @VAR_VALORREFERENCIA = ' AND CRUZ.VALOR_REFERENCIA = ''' + @VALOR_REFERENCIA + ''''
	END 
	
	IF @DESCRIPTOR <> '' BEGIN
		SET @VAR_DESCRIPTOR = ' AND PROD.DESCRIPTOR_CORTA LIKE ''' + CAST(@DESCRIPTOR AS VARCHAR(100)) + '%'''
	END 	
	
	IF @ID_DUEÑO > 0 BEGIN
		SET @VAR_@IDDUEÑO = ' AND LOTE.ID_Dueño = ' + CAST(@ID_DUEÑO AS VARCHAR(25))
	END				
	
	IF @ID_ORG > 0 BEGIN
		SET @VAR_IDORG = CAST(@ID_ORG AS VARCHAR(25))
	END 
	ELSE
	BEGIN
		SET @VAR_IDORG = ' STOCK.ID_Org '
	END
	
	IF @ID_PROPIETARIO > 0 BEGIN
		SET @VAR_IDPROPIETARIO = ' AND DUENO.ID_HOLDING_PROPIETARIO = ' + CAST(@ID_PROPIETARIO AS VARCHAR(25))
	END 	
	
	IF @FAMLIA > 0 BEGIN
		SET @VAR_FAMILIA = ' AND FAMILIA.COD_CATEG1 = ' + CAST(@FAMLIA AS VARCHAR(100))
	END 	
	
	IF @CATEGORIA > 0 BEGIN
		SET @VAR_CATEGORIA = ' AND CATEGORIA.COD_CATEG2 = ' + CAST(@CATEGORIA AS VARCHAR(100))
	END 				
	
	IF @MARCA > 0 BEGIN
		SET @VAR_MARCA = ' AND MARCA.COD_CATEG3 = ' + CAST(@MARCA AS VARCHAR(100))
	END 	
	
	IF @CAMPANIA <> '' BEGIN
		SET @VAR_CAMPANIA = ' AND CAMPANIA.Nombre_Campaña LIKE ''' + CAST(@CAMPANIA AS VARCHAR(MAX)) + '%'''
	END		
	
	--Verificamos si el dueño es ejecutivo. Si lo es dejamos la variable @VAR_@IDDUEÑO con filtro propietario
	DECLARE @ORIGEN NUMERIC(18, 0), @PROP NUMERIC(18, 0)
	
	select @ORIGEN = ORIGEN.id_origen, @PROP = DUENO.ID_HOLDING_PROPIETARIO
	from Adm_System_Usuarios U
	INNER JOIN Adm_System_Perfiles_Usuarios ROL
		ON U.ID_USRO = ROL.ID_USRO
	INNER JOIN Adm_System_Origen_Usuarios ORIGEN
		ON ROL.ID_ORIGEN = ORIGEN.ID_ORIGEN
	INNER JOIN adm_system_contactos CONTACTO
		ON U.ID_USRO = CONTACTO.ID_USRO AND U.ID_ORG = CONTACTO.ID_ORG
	INNER JOIN Adm_System_Dueños DUENO
		ON CONTACTO.ID_CONTACTO = DUENO.ID_CONTACTO AND CONTACTO.ID_ORG = DUENO.ID_ORG
	where DUENO.ID_DUEÑO = ISNULL(@ID_DUEÑO,DUENO.ID_DUEÑO)

	--[INV_STOCK_VISUALIZACION] 0,'','',0,0,44213,0,0,0,''
	
	IF (@ORIGEN = 900) BEGIN
		SET @VAR_@IDDUEÑO = ' AND DUENO.ID_HOLDING_PROPIETARIO = ' + CAST(@PROP AS VARCHAR(25))
	END
	
	IF (@VAR_VALORREFERENCIA = '') BEGIN	
		SET @STR_QUERY = '	SELECT 
			 LOTE.Cod_Item ProductoId
			--,LOTE.ID_LOTE
			,(SELECT CRUZ.VALOR_REFERENCIA 
			  FROM Inventario_Referencias_Cruzadas CRUZ
			  WHERE LOTE.Cod_Item = CRUZ.COD_ITEM AND LOTE.ID_Org = CRUZ.ID_Org AND CRUZ.ID_REF_PRED = 1003) CodigoAntiguo
			,PROD.DESCRIPTOR_CORTA Descriptor
			,FLOOR(SUM(STOCK.Disponible)) CantidadDisponible
			,COUNT(LOC.ID_LOCALIZADOR) Localizadores
			,LOTE.ID_DUEÑO ID_DUENO
			,ISNULL(CONTACTO.NOMBRES, '''') + '' '' + ISNULL(CONTACTO.APELLIDO_PATERNO, '''') + '' ''  + ISNULL(CONTACTO.APELLIDO_MATERNO, '''') DUENO	
			,DUENO.ID_HOLDING_PROPIETARIO	
			,ISNULL(FAMILIA.NOMBRE_CATEG1, '''') Familia 
		    ,ISNULL(CATEGORIA.NOMBRE_CATEG2, '''') Categoria
		    ,ISNULL(MARCA.NOMBRE_CATEG3, '''') Marca	
		    ,PROP.NOMBRE Propietario
			,PROD.PRECIO_COMPRA PrecioCompra	
			,UM.UNIDAD_MEDIDA_ABREVIADA UnidadMedida   	
			,ISNULL(CAMPANIA.Nombre_Campaña, '''') NombreCampania
			,ISNULL(PROD.FICHA_IMAGEN, ''/images/productos/none-image.jpg'') FICHA_IMAGEN
		FROM Inventario_Stock_Lotes STOCK
			INNER JOIN Inventario_Lotes LOTE
				ON STOCK.ID_Lote = LOTE.ID_Lote AND STOCK.ID_Org = LOTE.ID_Org
			INNER JOIN Inventario_Items PROD
				ON LOTE.Cod_Item = PROD.COD_ITEM AND LOTE.ID_Org = PROD.ID_Org
			INNER JOIN Inventario_Unidad_Medida_Primaria UM
				ON PROD.ID_UM = UM.ID_UM				
			INNER JOIN Inventario_SubInv_Localizadores LOC
				ON STOCK.ID_Localizador = LOC.ID_LOCALIZADOR AND STOCK.ID_Org = LOC.ID_Org
			INNER JOIN ADM_SYSTEM_DUEÑOS DUENO
				ON LOTE.ID_DUEÑO = DUENO.ID_DUEÑO AND LOTE.ID_ORG = DUENO.ID_ORG
			INNER JOIN ADM_SYSTEM_HOLDING PROP
				ON DUENO.ID_HOLDING_PROPIETARIO = PROP.ID_HOLDING AND DUENO.ID_ORG = PROP.ID_ORG AND PROP.ESPROPIETARIO = 1
			INNER JOIN adm_system_contactos CONTACTO
				ON DUENO.ID_CONTACTO = CONTACTO.ID_CONTACTO	AND DUENO.ID_ORG = CONTACTO.ID_ORG	
			LEFT JOIN Inventario_Campaña_Propietarios_Dueños CAMPANIA
				ON PROD.COD_ITEM = CAMPANIA.COD_ITEM AND PROD.ID_ORG = CAMPANIA.ID_ORG	
					AND CAMPANIA.Fech_actualiza = (SELECT MAX(MAXCAMP.Fech_actualiza) FROM Inventario_Campaña_Propietarios_Dueños MAXCAMP WHERE PROD.COD_ITEM = MAXCAMP.COD_ITEM)
			LEFT JOIN Inventario_Categoria1 FAMILIA
				ON FAMILIA.COD_CATEG1 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 1, 4)						
			LEFT JOIN Inventario_Categoria2 CATEGORIA
				ON CATEGORIA.COD_CATEG2 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 6, 4)
				AND CATEGORIA.COD_CATEG1 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 1, 4)
			LEFT JOIN Inventario_Categoria3 MARCA
				ON MARCA.COD_CATEG3 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 11, 4)		
				AND MARCA.COD_CATEG2 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 6, 4)						
		WHERE 
			--CRUZ.ID_REF_PRED = 1003 AND'
			+ @VAR_VIGENCIA + '
			STOCK.ID_Org = ' + @VAR_IDORG
			+ @VAR_@IDDUEÑO
			+ @VAR_CODITEM
			+ @VAR_VALORREFERENCIA
			+ @VAR_DESCRIPTOR
			+ @VAR_IDPROPIETARIO
			+ @VAR_FAMILIA
			+ @VAR_CATEGORIA
			+ @VAR_MARCA
			+ @VAR_CAMPANIA
			+ ' AND STOCK.Disponible > 0 '
			+ '	GROUP BY
			 LOTE.ID_Org
			,LOTE.Cod_Item 
			--,LOTE.ID_LOTE
			,PROD.DESCRIPTOR_CORTA
			,LOTE.ID_DUEÑO
			,ISNULL(CONTACTO.NOMBRES, '''') + '' '' + ISNULL(CONTACTO.APELLIDO_PATERNO, '''') + '' ''  + ISNULL(CONTACTO.APELLIDO_MATERNO, '''')
			,DUENO.ID_HOLDING_PROPIETARIO
			,PROD.PRECIO_COMPRA
			,FAMILIA.NOMBRE_CATEG1
			,CATEGORIA.NOMBRE_CATEG2
			,MARCA.NOMBRE_CATEG3
			,PROP.NOMBRE
			,UM.UNIDAD_MEDIDA_ABREVIADA
			,CAMPANIA.Nombre_Campaña
			,PROD.FICHA_IMAGEN';
	
	END
	ELSE BEGIN --[INV_STOCK_VISUALIZACION] 0,'','',0,0,44213,0,0,0,''
	
		SET @STR_QUERY = '	SELECT 
			 LOTE.Cod_Item ProductoId
			--,LOTE.ID_LOTE
			,CRUZ.VALOR_REFERENCIA CodigoAntiguo
			,PROD.DESCRIPTOR_CORTA Descriptor
			,FLOOR(SUM(STOCK.Disponible)) CantidadDisponible
			,COUNT(LOC.ID_LOCALIZADOR) Localizadores
			,LOTE.ID_DUEÑO ID_DUENO
			,ISNULL(CONTACTO.NOMBRES, '''') + '' '' + ISNULL(CONTACTO.APELLIDO_PATERNO, '''') + '' ''  + ISNULL(CONTACTO.APELLIDO_MATERNO, '''') DUENO	
			,DUENO.ID_HOLDING_PROPIETARIO	
			,ISNULL(FAMILIA.NOMBRE_CATEG1, '''') Familia 
		    ,ISNULL(CATEGORIA.NOMBRE_CATEG2, '''') Categoria
		    ,ISNULL(MARCA.NOMBRE_CATEG3, '''') Marca	
		    ,PROP.NOMBRE Propietario	
			,PROD.PRECIO_COMPRA PrecioCompra	
			,UM.UNIDAD_MEDIDA_ABREVIADA UnidadMedida	
			,ISNULL(CAMPANIA.Nombre_Campaña, '''') NombreCampania	
			,ISNULL(PROD.FICHA_IMAGEN, ''/images/productos/none-image.jpg'') FICHA_IMAGEN				
		FROM Inventario_Stock_Lotes STOCK
			INNER JOIN Inventario_Lotes LOTE
				ON STOCK.ID_Lote = LOTE.ID_Lote AND STOCK.ID_Org = LOTE.ID_Org
			INNER JOIN Inventario_Referencias_Cruzadas CRUZ
				ON LOTE.Cod_Item = CRUZ.COD_ITEM AND LOTE.ID_Org = CRUZ.ID_Org
			INNER JOIN Inventario_Items PROD
				ON LOTE.Cod_Item = PROD.COD_ITEM AND LOTE.ID_Org = PROD.ID_Org
			INNER JOIN Inventario_Unidad_Medida_Primaria UM
				ON PROD.ID_UM = UM.ID_UM				
			INNER JOIN Inventario_SubInv_Localizadores LOC
				ON STOCK.ID_Localizador = LOC.ID_LOCALIZADOR AND STOCK.ID_Org = LOC.ID_Org
			INNER JOIN ADM_SYSTEM_DUEÑOS DUENO			
				ON LOTE.ID_DUEÑO = DUENO.ID_DUEÑO AND LOTE.ID_ORG = DUENO.ID_ORG
			INNER JOIN ADM_SYSTEM_HOLDING PROP
				ON DUENO.ID_HOLDING_PROPIETARIO = PROP.ID_HOLDING AND DUENO.ID_ORG = PROP.ID_ORG AND PROP.ESPROPIETARIO = 1				
			INNER JOIN adm_system_contactos CONTACTO
				ON DUENO.ID_CONTACTO = CONTACTO.ID_CONTACTO	AND DUENO.ID_ORG = CONTACTO.ID_ORG
			LEFT JOIN Inventario_Campaña_Propietarios_Dueños CAMPANIA
				ON PROD.COD_ITEM = CAMPANIA.COD_ITEM AND PROD.ID_ORG = CAMPANIA.ID_ORG							
					AND CAMPANIA.Fech_actualiza = (SELECT MAX(MAXCAMP.Fech_actualiza) FROM Inventario_Campaña_Propietarios_Dueños MAXCAMP WHERE PROD.COD_ITEM = MAXCAMP.COD_ITEM)				
			LEFT JOIN Inventario_Categoria1 FAMILIA
				ON FAMILIA.COD_CATEG1 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 1, 4)						
			LEFT JOIN Inventario_Categoria2 CATEGORIA
				ON CATEGORIA.COD_CATEG2 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 6, 4)
				AND CATEGORIA.COD_CATEG1 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 1, 4)
			LEFT JOIN Inventario_Categoria3 MARCA
				ON MARCA.COD_CATEG3 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 11, 4)		
				AND MARCA.COD_CATEG2 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 6, 4)								
		WHERE CRUZ.ID_REF_PRED = 1003 AND '
			+ @VAR_VIGENCIA + '
			AND STOCK.ID_Org = ' + @VAR_IDORG
			+ @VAR_@IDDUEÑO
			+ @VAR_CODITEM
			+ @VAR_VALORREFERENCIA
			+ @VAR_DESCRIPTOR
			+ @VAR_IDPROPIETARIO
			+ @VAR_FAMILIA
			+ @VAR_CATEGORIA
			+ @VAR_MARCA	
			+ @VAR_CAMPANIA		
			+ ' AND STOCK.Disponible > 0 '
			+ '	GROUP BY
			 LOTE.Cod_Item 
			--,LOTE.ID_LOTE
			,CRUZ.VALOR_REFERENCIA
			,PROD.DESCRIPTOR_CORTA
			,LOTE.ID_DUEÑO
			,ISNULL(CONTACTO.NOMBRES, '''') + '' '' + ISNULL(CONTACTO.APELLIDO_PATERNO, '''') + '' ''  + ISNULL(CONTACTO.APELLIDO_MATERNO, '''')
			,DUENO.ID_HOLDING_PROPIETARIO
			,PROD.PRECIO_COMPRA
			,FAMILIA.NOMBRE_CATEG1
			,CATEGORIA.NOMBRE_CATEG2
			,MARCA.NOMBRE_CATEG3
			,PROP.NOMBRE
			,UM.UNIDAD_MEDIDA_ABREVIADA
			,CAMPANIA.Nombre_Campaña
			,PROD.FICHA_IMAGEN';	
	
	END 
	
	--PRINT @STR_QUERY
   -- print @str_query;
	EXEC (@STR_QUERY);
	
	
	
		
	
END

--select * from Inventario_Items prod
--LEFT JOIN Inventario_Campaña_Propietarios_Dueños CAMPANIA
--ON PROD.COD_ITEM = CAMPANIA.COD_ITEM AND PROD.ID_ORG = CAMPANIA.ID_ORG							
--AND CAMPANIA.COD_CAMPAÑA = (

--SELECT * FROM Inventario_Campaña_Propietarios_Dueños  
--group by Fech_Actualiza,Cod_Campaña,Cod_Item
--having Fech_Actualiza = 
--(max(Fech_Actualiza)) and Cod_Item = 56621 



--a.Cod_Item = 56621 a.ID_Usro_Act !=NULL and prod.Cod_Item = CAMPANIA.Cod_Item)
--where prod.Cod_Item = 56621

--select * from Inventario_Campaña_Propietarios_Dueños where Cod_Item = 56621
GO
