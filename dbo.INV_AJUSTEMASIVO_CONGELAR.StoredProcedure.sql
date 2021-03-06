USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_AJUSTEMASIVO_CONGELAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_AJUSTEMASIVO_CONGELAR 0, 'PRUEBA CICLICO', 52, 24, 2, 17, 20, ''
CREATE PROCEDURE [dbo].[INV_AJUSTEMASIVO_CONGELAR]
--DECLARE
	-- Add the parameters for the stored procedure here	
	@FOLIO NUMERIC(18, 0),
	@DESCRIPCION VARCHAR(250),
	@PROPIETARIO NUMERIC(18, 0),
	@DUENO NUMERIC(18, 0),
	@ID_USRO NUMERIC(18, 0),
	@ID_ORG NUMERIC(18, 0),
	@CICLOS NUMERIC(18, 0),
	@LISTA_PRODUCTOS VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--SET @DESCRIPCION = 'PRUEBA'
	--SET @PROPIETARIO = 52
	--SET @DUENO = 24
	--SET @ID_USRO = 2
	--SET @ID_ORG = 17
	--SET @CICLOS= 20
	--SET @LISTA_PRODUCTOS = '51889000'
	
    -- Insert statements for procedure here
    IF EXISTS(SELECT * FROM Inventario_Congelar_Toma_Inv WHERE FOLIO_TOMAINV = @FOLIO AND ID_ORG = @ID_ORG) BEGIN    
		SELECT 0 CORRECTO, 'El Folio ya se encuentra congelado' MENSAJE, 0 NUMERO_FOLIO, Convert(varchar(10),CONVERT(date,GETDATE(),106),103) FECHA, 0 COD_ESTADO, '' ESTADO, 0 CICLICO, 0 CICLOS_GENERADOS
		RETURN
    END
    
    
    
	DECLARE 
		 @VAR_PROPIETARIO VARCHAR(100) = ''
		,@VAR_DUENO VARCHAR(100) = ''
		--,@VAR_FAMILIA VARCHAR(100) = ''
		--,@VAR_CATEGORIA VARCHAR(100) = ''
		--,@VAR_MARCA VARCHAR(100) = ''
		,@VAR_DESCRIPTOR VARCHAR(500) = ''
		,@VAR_IDORG VARCHAR(100) = ''
		,@VAR_LISTA_PRODUCTOS VARCHAR(MAX) = ''
		,@STR_QUERY VARCHAR(MAX)
		
		
	IF @PROPIETARIO > 0 BEGIN
		SET @VAR_PROPIETARIO = ' AND DUENO.ID_HOLDING_PROPIETARIO = ' + CAST(@PROPIETARIO AS VARCHAR(25))
	END 	
	
	IF @DUENO > 0 BEGIN
		SET @VAR_DUENO = ' AND DUENO.ID_DUEÑO = ' + CAST(@DUENO AS VARCHAR(25))
	END	
	
	--IF @FAMILIA > 0 BEGIN
	--	SET @VAR_FAMILIA = ' AND FAMILIA.COD_CATEG1 = ' + CAST(@FAMILIA AS VARCHAR(100))
	--END 	
	
	--IF @CATEGORIA > 0 BEGIN
	--	SET @VAR_CATEGORIA = ' AND CATEGORIA.COD_CATEG2 = ' + CAST(@CATEGORIA AS VARCHAR(100))
	--END 				
	
	--IF @MARCA > 0 BEGIN
	--	SET @VAR_MARCA = ' AND MARCA.COD_CATEG3 = ' + CAST(@MARCA AS VARCHAR(100))
	--END 
	
	IF @LISTA_PRODUCTOS <> '' BEGIN
		SET @VAR_LISTA_PRODUCTOS = ' AND PROD.COD_ITEM IN(' + CAST(@LISTA_PRODUCTOS AS VARCHAR(MAX)) + ')'
	END 

		    
    /*
    SELECT * FROM Inventario_Lotes
	SELECT * FROM Inventario_Items_Prop_Dueños
	SELECT * FROM Inventario_Items
	SELECT * FROM dbo.Adm_System_Holding
	SELECT * FROM dbo.Adm_System_Dueños
	SELECT * FROM Adm_System_Contactos   
	SELECT * FROM Inventario_Stock_Lotes 
	SELECT * FROM Inventario_SubInv_Localizadores
	SELECT * FROM Inventario_SubInventarios
    */   
    
	DECLARE @ULTIMO_FOLIO NUMERIC(18, 0), @FILTROS VARCHAR(500)
	
	SELECT @ULTIMO_FOLIO = MAX(Folio_TomaInv) + 1 FROM Inventario_Folios_Todos
	UPDATE Inventario_Folios_Todos
		SET Folio_TomaInv = @ULTIMO_FOLIO

	--SET @FECHA_CONGELADO = GETDATE()    
	SET @FILTROS =  CAST(@PROPIETARIO AS VARCHAR(10)) + '~' + CAST(@DUENO AS VARCHAR(10))
					--CAST(@FAMILIA AS VARCHAR(10)) + '~' + 
					--CAST(@CATEGORIA AS VARCHAR(10)) + '~' + 
					--CAST(@MARCA AS VARCHAR(10)) + '~' + 
					--CAST(@Descriptor_Corta AS VARCHAR(10))
        
	SET @STR_QUERY = '   
	SELECT 
		 ' + CAST(@ULTIMO_FOLIO AS VARCHAR(6)) + ' Folio
		 ,''' + CAST(CONVERT(date,getdate(),106) AS VARCHAR(20)) + ''' FechaCongelacion
		 ,''' + @DESCRIPCION + ''' Descripcion
		 ,''' + @FILTROS + ''' Filtro
		 ,PROP.ID_HOLDING PropietarioId
		--,PROP.NOMBRE Propietario
		--,DUENO.ID_DUEÑO DuenoId
		--,C.NOMBRES + '' '' + C.APELLIDO_PATERNO + '' '' + C.APELLIDO_MATERNO Dueno
		,PROD.COD_ITEM Sku
		--,(SELECT CRUZ.VALOR_REFERENCIA
		--  F-R-O-M Inventario_Referencias_Cruzadas CRUZ
		--  WHERE LOTE.Cod_Item = CRUZ.COD_ITEM AND LOTE.ID_Org = CRUZ.ID_Org AND CRUZ.ID_REF_PRED = 1003) CodigoAntiguo		
		--,PROD.DESCRIPTOR_CORTA Descriptor		
		,LOTE.ID_Lote LoteId
		,ISNULL(LOTE.Etiq_Pallet_Antiguo, '''') EtiquetaPalletAntiguo
		--,LOTE.Lote_Proveedor LoteProveedor
		,LOC.ID_LOCALIZADOR LocalizadorId
		--,LOTE.Fecha_Expira FechaVencimiento
		,ISNULL(STOCK.EN_MANO, 0) EnMano
		,ISNULL(STOCK.DISPONIBLE, 0) Disponible
		,ISNULL(STOCK.RESERVA, 0) Reserva
		--,UM.UNIDAD_MEDIDA_ABREVIADA UnidadMedida   	
		--,ISNULL(FAMILIA.NOMBRE_CATEG1, '''') Familia 
	    --,ISNULL(CATEGORIA.NOMBRE_CATEG2, '''') Categoria
	    --,ISNULL(MARCA.NOMBRE_CATEG3, '''') Marca	
		--,SUBINV.ID_SUBINV SubInventarioId
		--,SUBINV.DESCRIPCION SubInvinventario
		--,LOC.ID_LOCALIZADOR LocalizadorId
		--,LOC.COMBINACION_LOCALIZADOR Localizador	    
	    --,PROD.PRECIO_COMPRA PrecioCompra			
	    ,' + CAST(@ID_USRO AS VARCHAR(10)) + ' Usuario
	    ,' + CAST(@ID_ORG AS VARCHAR(3)) + ' IdOrg
	    ,''S'' Vigencia
	    ,1 CodEstado,NULL CICLO	    
	FROM Inventario_Items PROD
		INNER JOIN INVENTARIO_LOTES LOTE
			ON PROD.COD_ITEM = LOTE.COD_ITEM AND PROD.ID_ORG = LOTE.ID_ORG
		INNER JOIN Inventario_Unidad_Medida_Primaria UM
			ON PROD.ID_UM = UM.ID_UM				
		INNER JOIN Adm_System_Dueños DUENO
			ON LOTE.ID_DUEÑO = DUENO.ID_DUEÑO AND LOTE.ID_ORG = DUENO.ID_ORG
		INNER JOIN Adm_System_Holding PROP
			ON DUENO.ID_HOLDING_PROPIETARIO = PROP.ID_HOLDING AND DUENO.ID_ORG = PROP.ID_ORG
		INNER JOIN Inventario_Stock_Lotes STOCK
			ON LOTE.ID_LOTE = STOCK.ID_LOTE AND LOTE.ID_ORG = STOCK.ID_ORG
		INNER JOIN Inventario_SubInv_Localizadores LOC
			ON STOCK.ID_LOCALIZADOR = LOC.ID_LOCALIZADOR AND STOCK.ID_ORG = LOC.ID_ORG 
		INNER JOIN Inventario_SubInventarios SUBINV
			ON LOC.ID_SUBINV = SUBINV.ID_SUBINV
		INNER JOIN Adm_System_Contactos C
			ON DUENO.ID_CONTACTO = C.ID_CONTACTO AND DUENO.ID_ORG = C.ID_ORG	
		LEFT JOIN Inventario_Categoria1 FAMILIA
			ON FAMILIA.COD_CATEG1 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 1, 4)						
		LEFT JOIN Inventario_Categoria2 CATEGORIA
			ON CATEGORIA.COD_CATEG2 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 6, 4)
			AND CATEGORIA.COD_CATEG1 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 1, 4)
		LEFT JOIN Inventario_Categoria3 MARCA
			ON MARCA.COD_CATEG3 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 11, 4)		
			AND MARCA.COD_CATEG2 = SUBSTRING(PROD.COMBINACION_CATEGORIA, 6, 4)							
	WHERE PROP.VIGENCIA = ''S''
		AND DUENO.VIGENCIA = ''S''
		--AND PROD.VIGENCIA 
		AND LOC.COD_TIPO_SUBINV = 200
		AND PROD.ID_Org = ' + CAST(@ID_ORG AS VARCHAR(3))
		+ @VAR_PROPIETARIO
		+ @VAR_DUENO
		+ @VAR_LISTA_PRODUCTOS;
	
    IF @CICLOS > 0 BEGIN

		DECLARE 
			@CANTIDAD INT, 
			@contador INT, 
			@COCIENTE NUMERIC(18, 0), 
			@TEMP_COCIENTE NUMERIC(18, 0),
			@SUMADOR NUMERIC(18, 0),
			@RESTO NUMERIC(18, 0), 
			@CASE_CICLOS VARCHAR(MAX), 
			@N_QUERY NVARCHAR(MAX),
			@CICLOS_GENERADOS NUMERIC(18, 0)
			
		SET @N_QUERY = REPLACE(SUBSTRING(@STR_QUERY, CHARINDEX('FROM', @STR_QUERY), LEN(@STR_QUERY)), 'FROM', 'SELECT @CANT=COUNT(*) FROM')
		--PRINT @N_QUERY
		EXEC SP_EXECUTESQL @N_QUERY, N'@CANT INT OUTPUT', @CANT = @CANTIDAD OUTPUT;
		--SET @CANTIDAD = @@ROWCOUNT
		PRINT CAST(@CANTIDAD AS VARCHAR(20))
		
		SET @COCIENTE = CAST(ROUND((CAST(@CANTIDAD AS NUMERIC(18,2)) / CAST(@CICLOS AS NUMERIC(18, 2))), 0, -1) AS NUMERIC(8, 0))
		SET @RESTO = (@CANTIDAD % @CICLOS)
		
		SET @CASE_CICLOS = ', CASE '
		
		SET @contador = 0
		SET @SUMADOR = 0
		WHILE (@contador < @CICLOS)
		BEGIN
     		SET @contador = @contador + 1
			
			IF @RESTO > 0 BEGIN
				SET @RESTO = @RESTO - 1
				SET @TEMP_COCIENTE = @COCIENTE + 1
				--PRINT 'RESTO > 0' + cast(@RESTO AS varchar)
				--PRINT '@TEMP_COCIENTE ' + cast(@TEMP_COCIENTE AS varchar)
			END
			ELSE BEGIN
				SET @TEMP_COCIENTE = @COCIENTE
				--PRINT 'RESTO ' + cast(@RESTO AS varchar)
				--PRINT '@TEMP_COCIENTE ' + cast(@TEMP_COCIENTE AS varchar)
			END 			
			
			SET @SUMADOR = @SUMADOR + @TEMP_COCIENTE
			
			--PRINT 'Iteracion del bucle @TEMP_COCIENTE: ' + cast(@TEMP_COCIENTE AS varchar)
			--PRINT 'Iteracion del bucle @contador: ' + cast(@contador AS varchar)
			SET @CASE_CICLOS = @CASE_CICLOS + '	WHEN ROW_NUMBER() OVER (ORDER BY LOTE.ID_LOTE ASC) <= ' + CAST(@SUMADOR AS VARCHAR) + ' THEN ' + CAST(@contador AS VARCHAR(6))
    		    		
		END		
		
		SET @CASE_CICLOS = @CASE_CICLOS + '	ELSE ROW_NUMBER() OVER (ORDER BY LOTE.ID_LOTE ASC) END CICLO ' 

		SET @STR_QUERY = REPLACE(@STR_QUERY, ',1 CodEstado,NULL CICLO', ',1 CodEstado' + @CASE_CICLOS)		
		
		
		--OBTENEMOS LA CANTIDAD DE CICLOS QUE SE GENERARON REALMENTE, YA QUE PODRIAN SER MENOS QUE LOS INGRESADOS POR EL USUARIO
		SET @N_QUERY = 'SELECT @CANT=MAX(CICLO) FROM (' + @STR_QUERY + ') TABLA'
		PRINT @N_QUERY
		EXEC SP_EXECUTESQL @N_QUERY, N'@CANT INT OUTPUT', @CANT = @CANTIDAD OUTPUT;
		--SET @CANTIDAD = @@ROWCOUNT
		--PRINT CAST(@CANTIDAD AS VARCHAR(20))		
		SET @CICLOS_GENERADOS = @CANTIDAD
		
    END	
	
	--PRINT @STR_QUERY;
	

BEGIN TRY
	
	SET @STR_QUERY = '
	INSERT INTO Inventario_Congelar_Toma_Inv (
		 Folio_TomaInv
		,Fecha_Inv
		,Descripcion_Inv
		,Filtro
		,ID_Propietario
		,Cod_Item
		,ID_Lote
		,Etiq_Pallet_Antiguo
		,ID_Localizador
		,En_Mano
		,Disponible
		,Reserva
		,ID_Usro_Crea
		,ID_Org
		,Vigencia
		,Cod_Estado	
		,Ciclo	
	)' + @STR_QUERY;
	
	--print @str_query;
	EXEC (@STR_QUERY);
	
	IF @@ROWCOUNT > 0 BEGIN
		
		IF @CICLOS = 0 BEGIN
		
			SELECT 1 CORRECTO 
				  ,'Toma de inventario congelada exitosamente. Ahora puede Exportar el inventario número ' + CAST(@ULTIMO_FOLIO AS VARCHAR(6)) MENSAJE
				  ,@ULTIMO_FOLIO NUMERO_FOLIO
				  ,(SELECT DISTINCT Convert(varchar(10),CONVERT(date,Fecha_Inv,106),103) FROM Inventario_Congelar_Toma_Inv WHERE Folio_TomaInv = @ULTIMO_FOLIO) FECHA
				  ,1 COD_ESTADO
				  ,(SELECT ESTADO FROM Inventario_Estado_Toma_Inv WHERE COD_ESTADO = 1) ESTADO
				  ,0 CICLICO
				  ,0 CICLOS_GENERADOS  
		
		END
		ELSE BEGIN
		
			SELECT 1 CORRECTO 
				  ,'Toma de inventario congelada exitosamente (' + CAST(@CICLOS_GENERADOS AS VARCHAR(6)) + ' ciclos generados). Ahora puede Exportar el inventario número ' + CAST(@ULTIMO_FOLIO AS VARCHAR(6)) MENSAJE
				  ,@ULTIMO_FOLIO NUMERO_FOLIO
				  ,(SELECT DISTINCT Convert(varchar(10),CONVERT(date,Fecha_Inv,106),103) FROM Inventario_Congelar_Toma_Inv WHERE Folio_TomaInv = @ULTIMO_FOLIO) FECHA
				  ,1 COD_ESTADO
				  ,(SELECT ESTADO FROM Inventario_Estado_Toma_Inv WHERE COD_ESTADO = 1) ESTADO	
				  ,1 CICLICO
				  ,@CICLOS_GENERADOS CICLOS_GENERADOS	
		
		END
			  
		
	END
	ELSE BEGIN
	
		SELECT 0 CORRECTO 
			  ,'No se encontraron datos para congelar el inventario. Intente con otros filtros' MENSAJE
			  ,@ULTIMO_FOLIO NUMERO_FOLIO
			  ,Convert(varchar(10),CONVERT(date,GETDATE(),106),103) FECHA
			  ,0 COD_ESTADO
			  ,'' ESTADO
			  ,0 CICLICO	
			  ,0 CICLOS_GENERADOS  
	END 
				  
END TRY
BEGIN CATCH
	
	/* Hay un error, deshacemos los cambios*/ 
	--ROLLBACK TRANSACTION -- O solo ROLLBACK
	
	DECLARE @MENSAJEERROR VARCHAR(MAX) = ERROR_MESSAGE();
	DECLARE @SEVERIDADERROR BIGINT = ERROR_SEVERITY();
	DECLARE @ESTADOERROR BIGINT = ERROR_STATE();
	DECLARE @LINEAERROR VARCHAR(5) = CAST(ERROR_LINE() AS VARCHAR(5));
	DECLARE @ERRORMENSAJE VARCHAR(MAX);
	SET @ERRORMENSAJE = (@LINEAERROR + ' - ' + @MENSAJEERROR);
	
    --RAISERROR (@ERRORMENSAJE, @SEVERIDADERROR, @ESTADOERROR)
	
	SELECT 0 CORRECTO, @ERRORMENSAJE MENSAJE, 0 NUMERO_FOLIO, Convert(varchar(10),CONVERT(date,GETDATE(),106),103) FECHA, 0 COD_ESTADO, '' ESTADO, 0 CICLICO, 0 CICLOS_GENERADOS, 0 INSERTADOS
		 
     --PRINT ERROR_SEVERITY()    
     --PRINT ERROR_STATE()  
     --PRINT ERROR_PROCEDURE()   
     --PRINT ERROR_LINE()   
     --PRINT ERROR_MESSAGE() 
	
END CATCH	
	
	
	
END
GO
