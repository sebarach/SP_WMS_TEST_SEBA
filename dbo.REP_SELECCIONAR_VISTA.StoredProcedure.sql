USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[REP_SELECCIONAR_VISTA]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[REP_SELECCIONAR_VISTA] 
	-- Add the parameters for the stored procedure here
	 @REPORTE NUMERIC(18, 0)
	,@COD_ITEM NUMERIC(18, 0)
	,@DESCRIPTOR_CORTA VARCHAR(250)
	,@USUARIO VARCHAR(20)
	,@ANIO NUMERIC(18, 0)
	,@SOL_FECHAINI VARCHAR(10)
	,@SOL_FECHAFIN VARCHAR(10)
	,@CLIENTE VARCHAR(10)		
AS
BEGIN
--exec REP_SELECCIONAR_VISTA 1,0,'','',0,'','',143
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @FILTROS VARCHAR(2000) = '';
	
    -- Insert statements for procedure here
    --REP_SELECCIONAR_VISTA 1, 51679, '', '', 0
	--REP_SELECCIONAR_VISTA 1, 0, 'STAND BCI (12', '', 0
	--REP_SELECCIONAR_VISTA 1, 51679, 'STAND BCI (12', '', 0
	
	IF @REPORTE = 1 BEGIN
	
		IF @COD_ITEM > 0 BEGIN
			SET @FILTROS = 'WHERE COD_ITEM = ' + CAST(@COD_ITEM AS VARCHAR(18))
		END 
		
		IF @DESCRIPTOR_CORTA <> '' BEGIN 
			IF @FILTROS = '' BEGIN 
				SET @FILTROS = 'WHERE DESCRIPTOR_CORTA = ''' + @DESCRIPTOR_CORTA + ''''
			END 
			ELSE BEGIN
				SET @FILTROS = @FILTROS + ' AND DESCRIPTOR_CORTA = ''' + @DESCRIPTOR_CORTA + ''''
			END
		END 

		IF @CLIENTE <> 0 BEGIN 
			IF @FILTROS = '' BEGIN 
				SET @FILTROS = 'WHERE ID_Holding = ' + CAST(@CLIENTE AS VARCHAR (18)) + ' '
			END 
			ELSE BEGIN
				SET @FILTROS = @FILTROS + ' AND ID_Holding = ' + CAST(@CLIENTE AS VARCHAR (18))  + ' '
			END
		END 
		
		PRINT 'SELECT  
				 ISNULL(Propietario, '''') Propietario
				,ISNULL(Cod_Item, 0) Cod_Item
				,ISNULL(Descriptor_Corta, '''') Descriptor_Corta
				,ISNULL(Convert(varchar(10),CONVERT(date,Fecha_TRX,106),103), '''') Fecha_TRX
				,ISNULL(Origen_TRX, '''') Origen_TRX
				,ISNULL(Tipo_Transaccion, '''') Tipo_Transaccion
				,ISNULL(Ingreso, 0) Ingreso
				,ISNULL(Salida, 0) Salida
				,ISNULL(ID_Lote, '''') ID_Lote
				,ISNULL(Lote_Proveedor, '''') Lote_Proveedor
				,ISNULL(Convert(varchar(10),CONVERT(date,Fecha_Expira,106),103), '''') Fecha_Expira
				,ISNULL(Precio_Compra, 0) Precio_Compra
				,ISNULL(Razon_Social, '''') Razon_Social
				,ISNULL(Documento, '''') Documento
				,ISNULL(Familia, '''') Familia
				,ISNULL(Categoria, '''') Categoria
				,ISNULL(Marca, '''') Marca
				,ISNULL(UserName, '''') UserName
				,ISNULL(Rut_Destinatario, '''') Rut_Destinatario
				,ISNULL(Nombre_Destinatario, '''') Nombre_Destinatario
				,ISNULL(Folio_Documento, 0) Folio_Documento		
			FROM VISTA_KARDEX_CLIENTES ' + @FILTROS + ' ORDER BY CONVERT(date,Fecha_TRX,106) ASC';
			
		EXEC ('SELECT  
				 ISNULL(Propietario, '''') Propietario
				,ISNULL(Cod_Item, 0) Cod_Item
				,ISNULL(Descriptor_Corta, '''') Descriptor_Corta
				,ISNULL(Convert(varchar(10),CONVERT(date,Fecha_TRX,106),103), '''') Fecha_TRX
				,ISNULL(Origen_TRX, '''') Origen_TRX
				,ISNULL(Tipo_Transaccion, '''') Tipo_Transaccion
				,ISNULL(Ingreso, 0) Ingreso
				,ISNULL(Salida, 0) Salida
				,ISNULL(ID_Lote, '''') ID_Lote
				,ISNULL(Lote_Proveedor, '''') Lote_Proveedor
				,ISNULL(Convert(varchar(10),CONVERT(date,Fecha_Expira,106),103), '''') Fecha_Expira
				,ISNULL(Precio_Compra, 0) Precio_Compra
				,ISNULL(Razon_Social, '''') Razon_Social
				,ISNULL(Documento, '''') Documento
				,ISNULL(Familia, '''') Familia
				,ISNULL(Categoria, '''') Categoria
				,ISNULL(Marca, '''') Marca
				,ISNULL(UserName, '''') UserName
				,ISNULL(Rut_Destinatario, '''') Rut_Destinatario
				,ISNULL(Nombre_Destinatario, '''') Nombre_Destinatario
				,ISNULL(Folio_Documento, 0) Folio_Documento		
			FROM VISTA_KARDEX_CLIENTES ' + @FILTROS + ' ORDER BY CONVERT(date,Fecha_TRX,106) ASC')
			
	
	END
	

	--REP_SELECCIONAR_VISTA 2, 0, '', '', 2017
	--REP_SELECCIONAR_VISTA 2, 0, '', 'LVENEGAS', 0
	--REP_SELECCIONAR_VISTA 2, 0, '', 'LVENEGAS', 2017
	IF @REPORTE = 2 BEGIN
	
		IF @ANIO > 0 BEGIN
			SET @FILTROS = 'WHERE SUBSTRING(CONVERT(CHAR,MESAÑO),6,4) = ' + CAST(@ANIO AS VARCHAR(18))
		END 
		
		IF @USUARIO <> '' BEGIN 
			IF @FILTROS = '' BEGIN 
				SET @FILTROS = 'WHERE USUARIO = ''' + @USUARIO + ''''
			END 
			ELSE BEGIN
				SET @FILTROS = @FILTROS + ' AND USUARIO = ''' + @USUARIO + ''''
			END
		END 

		IF @CLIENTE <> 0 BEGIN 
			IF @FILTROS = '' BEGIN 
				SET @FILTROS = 'WHERE ID_Holding = ' + CAST(@CLIENTE AS VARCHAR (18)) + ' '
			END 
			ELSE BEGIN
				SET @FILTROS = @FILTROS + ' AND ID_Holding = ' + CAST(@CLIENTE AS VARCHAR (18))  + ' '
			END
		END 
		
		PRINT 'SELECT * FROM VISTA_KPI_INGRESO_DOCUMENTOS_X_USUARIO ' + @FILTROS
		EXEC ('SELECT 
				 ISNULL(MesAño, '''') MesAño
				,ISNULL(Propietario, '''') Propietario
				,ISNULL(Proveedor, '''') Proveedor
				,ISNULL(Usuario, '''') Usuario
				,ISNULL(Total_Documentos, 0) Total_Documentos
				FROM VISTA_KPI_INGRESO_DOCUMENTOS_X_USUARIO ' + @FILTROS)		
	
	END
	


	--REP_SELECCIONAR_VISTA 3, 0, '', '', 2017
	--REP_SELECCIONAR_VISTA 3, 0, '', 'LVENEGAS', 0
	--REP_SELECCIONAR_VISTA 3, 0, '', 'LVENEGAS', 2017	
	IF @REPORTE = 3 BEGIN
	
		IF @ANIO > 0 BEGIN
			SET @FILTROS = 'WHERE SUBSTRING(CONVERT(CHAR,MESAÑO),6,4) = ' + CAST(@ANIO AS VARCHAR(18))
		END 
		
		IF @USUARIO <> '' BEGIN 
			IF @FILTROS = '' BEGIN 
				SET @FILTROS = 'WHERE USUARIO = ''' + @USUARIO + ''''
			END 
			ELSE BEGIN
				SET @FILTROS = @FILTROS + ' AND USUARIO = ''' + @USUARIO + ''''
			END
		END 

		IF @CLIENTE <> 0 BEGIN 
			IF @FILTROS = '' BEGIN 
				SET @FILTROS = 'WHERE ID_Holding = ' + CAST(@CLIENTE AS VARCHAR (18)) + ' '
			END 
			ELSE BEGIN
				SET @FILTROS = @FILTROS + ' AND ID_Holding = ' + CAST(@CLIENTE AS VARCHAR (18))  + ' '
			END
		END 
		
		PRINT 'SELECT * FROM VISTA_KPI_PICKING_X_USUARIO ' + @FILTROS
		EXEC ('SELECT 
				 ISNULL(MesAño, '''') MesAño
				,ISNULL(Propietario, '''') Propietario
				,ISNULL(Usuario, '''') Usuario
				,ISNULL(Total_Localizadores_Pickeados, 0) Total_Localizadores_Pickeados		
				FROM VISTA_KPI_PICKING_X_USUARIO ' + @FILTROS)	
	
	END

	
	--REP_SELECCIONAR_VISTA 4, 0, '', '', 2017
	--REP_SELECCIONAR_VISTA 4, 0, '', 'LVENEGAS', 0
	--REP_SELECCIONAR_VISTA 4, 0, '', 'LVENEGAS', 2017			
	IF @REPORTE = 4 BEGIN
	
		IF @ANIO > 0 BEGIN
			SET @FILTROS = 'WHERE SUBSTRING(CONVERT(CHAR,MESAÑO),6,4) = ' + CAST(@ANIO AS VARCHAR(18))
		END 
		
		IF @USUARIO <> '' BEGIN 
			IF @FILTROS = '' BEGIN 
				SET @FILTROS = 'WHERE USUARIO = ''' + @USUARIO + ''''
			END 
			ELSE BEGIN
				SET @FILTROS = @FILTROS + ' AND USUARIO = ''' + @USUARIO + ''''
			END
		END 

		IF @CLIENTE <> 0 BEGIN 
			IF @FILTROS = '' BEGIN 
				SET @FILTROS = 'WHERE ID_Holding = ' + CAST(@CLIENTE AS VARCHAR (18)) + ' '
			END 
			ELSE BEGIN
				SET @FILTROS = @FILTROS + ' AND ID_Holding = ' + CAST(@CLIENTE AS VARCHAR (18))  + ' '
			END
		END 
		
		PRINT 'SELECT * FROM VISTA_KPI_DESPACHO_X_USUARIO ' + @FILTROS
		EXEC ('SELECT 
				 ISNULL(MesAño, '''') MesAño
				,ISNULL(Propietario, '''') Propietario
				,ISNULL(Usuario, '''') Usuario
				,ISNULL(Total_Guias_Despacho, 0) Total_Guias_Despacho		
				FROM VISTA_KPI_DESPACHO_X_USUARIO ' + @FILTROS)		
	
	END
	

	--REP_SELECCIONAR_VISTA 5, 0, '', '', 2017
	IF @REPORTE = 5 BEGIN
	
		IF @ANIO > 0 BEGIN
			SET @FILTROS = 'WHERE AÑO = ' + CAST(@ANIO AS VARCHAR(18))
		END 

		IF @CLIENTE <> 0 BEGIN 
			IF @FILTROS = '' BEGIN 
				SET @FILTROS = 'WHERE ID_Holding = ' + CAST(@CLIENTE AS VARCHAR (18)) + ' '
			END 
			ELSE BEGIN
				SET @FILTROS = @FILTROS + ' AND ID_Holding = ' + CAST(@CLIENTE AS VARCHAR (18))  + ' '
			END
		END 
				
		PRINT 'SELECT * FROM VISTA_VENTAS_X_CENTRO_COSTO ' + @FILTROS
		EXEC ('SELECT
				 ISNULL(Nombre, '''') Nombre
				,ISNULL(Centro_Costo, '''') Centro_Costo
				,ISNULL(Año, 0) Año
				,ISNULL(Mes, 0) Mes
				,ISNULL(Total_Neto, 0) Total_Neto
				,ISNULL(Total_Iva, 0) Total_Iva
				,ISNULL(Total_Venta, 0) Total_Venta		
				FROM VISTA_VENTAS_X_CENTRO_COSTO ' + @FILTROS)		
	
	END
	
	--REP_SELECCIONAR_VISTA 6, 0, '', '', 2017
	IF @REPORTE = 6 BEGIN
	
		IF @ANIO > 0 BEGIN
			SET @FILTROS = 'WHERE AÑO = ' + CAST(@ANIO AS VARCHAR(18))
		END 

		IF @CLIENTE <> 0 BEGIN 
			IF @FILTROS = '' BEGIN 
				SET @FILTROS = 'WHERE ID_Holding = ' + CAST(@CLIENTE AS VARCHAR (18)) + ' '
			END 
			ELSE BEGIN
				SET @FILTROS = @FILTROS + ' AND ID_Holding = ' + CAST(@CLIENTE AS VARCHAR (18))  + ' '
			END
		END 
				
		PRINT 'SELECT * FROM VISTA_VENTAS_X_SERVICIOS ' + @FILTROS
		EXEC ('SELECT 
				 ISNULL(Propietario, '''') Propietario
				,ISNULL(Año, 0) Año
				,ISNULL(Mes, 0) Mes
				,ISNULL(Servicio, '''') Servicio
				,ISNULL(Total_Neto, 0) Total_Neto
				,ISNULL(Total_Posiciones, 0) Total_Posiciones		
				FROM VISTA_VENTAS_X_SERVICIOS ' + @FILTROS)		
	
	END
	
	--REP_SELECCIONAR_VISTA 7, 0, '', '', 2017
	IF @REPORTE = 7 BEGIN
	
		IF @ANIO > 0 BEGIN
			SET @FILTROS = 'WHERE AÑO = ' + CAST(@ANIO AS VARCHAR(18))
		END 

		IF @CLIENTE <> 0 BEGIN 
			IF @FILTROS = '' BEGIN 
				SET @FILTROS = 'WHERE ID_Holding = ' + CAST(@CLIENTE AS VARCHAR (18)) + ' '
			END 
			ELSE BEGIN
				SET @FILTROS = @FILTROS + ' AND ID_Holding = ' + CAST(@CLIENTE AS VARCHAR (18))  + ' '
			END
		END 
				
		PRINT 'SELECT * FROM VISTA_VENTAS_X_DIAS_PERMANENCIA ' + @FILTROS
		EXEC ('SELECT 
				 ISNULL(Propietario, '''') Propietario
				,ISNULL(Año, 0) Año
				,ISNULL(Mes, 0) Mes
				,ISNULL(Servicio, '''') Servicio
				,ISNULL(Total_Neto, 0) Total_Neto
				,ISNULL(Total_Posiciones, 0) Total_Posiciones
				,ISNULL(Dias_Permanencia, 0) Dias_Permanencia
				,ISNULL(PrecioxDia, 0) PrecioxDia
				,ISNULL(Precio_Unitario, 0) Precio_Unitario
				FROM VISTA_VENTAS_X_DIAS_PERMANENCIA ' + @FILTROS)		
	
	END
	
	--REP_SELECCIONAR_VISTA 8, 0, '', '', 2017, '13-07-2017', '14-07-2017'
	IF @REPORTE = 8 BEGIN
		
		IF @SOL_FECHAINI <> '' AND @SOL_FECHAFIN <> '' BEGIN
			SET @FILTROS = 'WHERE CONVERT(date,Fecha_Solicitud, 103) BETWEEN CONVERT(date,''' + @SOL_FECHAINI + ''', 103) AND CONVERT(date,''' + @SOL_FECHAFIN + ''', 103)'
		END 
				
		PRINT 'SELECT * FROM VISTA_KPI_PYG_2 ' + @FILTROS
		EXEC ('SELECT 
				 ISNULL(Propietario, '''') Propietario
				,ISNULL(Nro_Solicitud, 0) Nro_Solicitud
				,ISNULL(Convert(varchar(25),Fecha_Solicitud,121), '''') Fecha_Solicitud
				,ISNULL(Convert(varchar(25),Fecha_Picking,121), '''') Fecha_Picking
				,ISNULL(Convert(varchar(25),Fecha_Shipping,121), '''') Fecha_Shipping
				,ISNULL(Dias_Solic_a_Pick, 0) Dias_Solic_a_Pick
				,ISNULL(Horas_Solic_a_Pick, 0) Horas_Solic_a_Pick
				,ISNULL(Minutos_Solic_a_Pick, 0) Minutos_Solic_a_Pick
				,ISNULL(Dias_Pick_a_Ship, 0) Dias_Pick_a_Ship
				,ISNULL(Horas_Pick_a_Ship, 0) Horas_Pick_a_Ship
				,ISNULL(Minutos_Pick_a_Ship, 0) Minutos_Pick_a_Ship
				,ISNULL(Guia_Despacho, 0) Guia_Despacho
			  FROM VISTA_KPI_PYG_2 ' + @FILTROS)		
	
	END	


    --exec rEP_SELECCIONAR_VISTA 9,0,'','', 0, '','','52'
	IF @REPORTE = 9 BEGIN
		
		IF @cliente <> 0 BEGIN
			SET @FILTROS += ' and id_propietario = ' + cast(@cliente as varchar(18))
		END 

        IF @COD_ITEM <> 0 BEGIN
			SET @FILTROS += ' and sku = ' + cast(@COD_ITEM as varchar(18))
		END 
				
		PRINT 'VISTA_TOTAL_INVENTARIO_POSICION where id_empresa = 17 ' + @FILTROS
		EXEC ('SELECT 
        propietario,
        nombre_dueño,
        ubicacion,
        pasillo,
        nivel,
        fila,
        sku,
        descripcion,
        familia,
        um,
        disponible
         from VISTA_TOTAL_INVENTARIO_POSICION where id_empresa = 17 ' + @FILTROS)		
	
	END	


    --select top 100 * from [dbo].[VISTA_STOCK_MANAGER] order by codigo desc

    --exec rEP_SELECCIONAR_VISTA 10,0,'','', 0, '','','0'
    	IF @REPORTE = 10 BEGIN
			
		PRINT 'VISTA_STOCK_MANAGER'
		EXEC ('SELECT top 100
        codigo,
        nombre,
        tipo,
        imputable,
        Unidad_Medida_Abreviada,
        monevta,
        precvta,
        paisori
        from VISTA_STOCK_MANAGER order by codigo desc')		
	
	END	
	
	
	
	
END
GO
