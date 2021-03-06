USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_PEDIDO_LANZAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_PEDIDO_LANZAR 10, 17, 4, 4
CREATE PROCEDURE [dbo].[INV_PEDIDO_LANZAR] 
	-- Add the parameters for the stored procedure here
--DECLARE
	 @ID_NroPedido numeric(18, 0)
	,@ID_Org numeric(18, 0)
	,@ID_Usro_Crea numeric(18, 0)
	,@ID_Usro_Act numeric(18, 0)
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--SET @ID_NroPedido = 31
	--SET @ID_Org = 17
	--SET @ID_Usro_Crea = 4
	--SET @ID_Usro_Act = 4

DECLARE @SEGUIR_SUGERIENDO VARCHAR(1) = 'S'
DECLARE @FECHA_TRANSACCION DATETIME = (SELECT GETDATE());

BEGIN TRAN
BEGIN TRY

	DECLARE @DUENO_ID NUMERIC(18, 0) = (SELECT DOC.ID_DUEÑO
	FROM INVENTARIO_CABECERA_PEDIDOS PED
		INNER JOIN INVENTARIO_CABECERA_DOCUMENTOS DOC
			ON PED.FOLIO_DOCUMENTO = DOC.FOLIO_DOCUMENTO AND PED.ID_ORG = DOC.ID_ORG			
	WHERE PED.ID_NROPEDIDO = @ID_NroPedido AND DOC.ID_DOCU = 20 AND PED.Estado<>'ANULADO');
	
	--OBTENCIÓN DE LOTES POR SKU DEL PEDIDO (OBTIENE TODOS LOS LOTES SIN IMPORTAR EL DUEÑO)
	DECLARE @TABLA_LOTES_LOCALIZADORES TABLE(ID_LOTE VARCHAR(50)
											,DISPONIBLE NUMERIC(18, 3)
											,FECHA_ORIGEN DATETIME
											,FECHA_EXPIRA DATETIME
											,COD_ITEM NUMERIC(18, 0)
											,ID_LOCALIZADOR NUMERIC(18, 0)
											,COMBINACION_LOCALIZADOR VARCHAR(50)
											,SEGMENTO1 VARCHAR(50) 
											,SEGMENTO2 VARCHAR(50)
											,SEGMENTO3 VARCHAR(50)
											,SEGMENTO4 VARCHAR(50)
											,SEGMENTO5 VARCHAR(50)
											,SEGMENTO6 VARCHAR(50)
											,SUGERIDO NUMERIC(18, 0));
	
	INSERT INTO @TABLA_LOTES_LOCALIZADORES
	SELECT --*
		 STOCK.ID_LOTE
		,STOCK.DISPONIBLE
		,LOTE.FECHA_ORIGEN
		,LOTE.FECHA_EXPIRA
		,LOTE.COD_ITEM
		,LOC.ID_LOCALIZADOR
		,LOC.COMBINACION_LOCALIZADOR
		,LOC.SEGMENTO1 --ORGANIZACION 
		,LOC.SEGMENTO2 --ZONA
		,LOC.SEGMENTO3 --SUBZONA
		,LOC.SEGMENTO4 --PASILLO
		,LOC.SEGMENTO5 --FILA
		,LOC.SEGMENTO6 --COLUMNA
		,0 SUGERIDO
	FROM Inventario_Stock_Lotes STOCK
		INNER JOIN Inventario_Lotes LOTE
			ON STOCK.ID_Lote = LOTE.ID_Lote AND STOCK.ID_ORG = LOTE.ID_ORG 
		INNER JOIN Inventario_SubInv_Localizadores LOC
			ON STOCK.ID_LOCALIZADOR = LOC.ID_LOCALIZADOR AND STOCK.ID_ORG = LOC.ID_ORG
		--INNER JOIN Inventario_Items_Prop_Dueños PROPDUENO
		--	ON LOTE.COD_ITEM = PROPDUENO.COD_ITEM
	WHERE 
		STOCK.Disponible > 0 
	AND STOCK.ID_ORG = @ID_Org
	AND LOC.COD_ESTADO = 1
	AND LOC.VIGENCIA = 'S'
	--AND LOC.COD_TIPO_SUBINV IN (100,200)
	AND LOTE.ID_DUEÑO = @DUENO_ID
	AND STOCK.ID_Lote IN (	
		SELECT --* 
			ID_Lote 
		FROM Inventario_Lotes
		WHERE Cod_Item IN (
			SELECT DETALLE.Cod_Item 
			FROM dbo.Inventario_Detalle_Pedidos DETALLE
			WHERE DETALLE.ID_NroPedido = @ID_NroPedido
			)
	)	
	
	--DECLARE cREGLAS CURSOR FOR
	--SELECT * FROM dbo.Inventario_Regla_Picking ORDER BY ORDEN_PRIORIDAD ASC
	
	--SELECT * FROM dbo.Inventario_Regla_Picking WHERE ORDEN_PRIORIDAD = 1
	DECLARE @CANTIDAD_SUGERIDA_SUMA NUMERIC(18, 0) = 0;
	DECLARE @LINEA_SUGERENCIA NUMERIC(18, 0) = 0;
	
	DECLARE @ACTUAL_PDO_MOVMTO NUMERIC(18, 0) = (SELECT MAX(ID_PDO_MOVMTO) FROM dbo.Inventario_Folios_Todos)
	
	UPDATE Inventario_Folios_Todos
		SET ID_PDO_MOVMTO = @ACTUAL_PDO_MOVMTO + 1
	WHERE ID_PDO_MOVMTO = @ACTUAL_PDO_MOVMTO;
	

	DECLARE
		@DET_COD_ITEM NUMERIC(18, 0),
		@DET_NRO_LINEA NUMERIC(18, 0),
		@DET_CANT_PEDIDA NUMERIC(18, 3),
		@DET_CANT_PENDIENTE NUMERIC(18, 3),
		@DET_CANT_PICKEADA NUMERIC(18, 3),
		@DET_CANT_DESPACHO NUMERIC(18, 3),
		@DET_ID_TRX_PEDIDO NUMERIC(18, 0)
	
	----LO QUE SE MANDÓ A PICKEAR
	--SELECT
	--	 COD_ITEM
	--	,NRO_LINEA
	--	,CANT_PEDIDA 
	--	,CANT_PENDIENTE
	--	,CANT_PICKEADA 
	--	,CANT_DESPACHO 
	--	,ID_TRX_PEDIDO
	--FROM INVENTARIO_DETALLE_PEDIDOS WHERE ID_NROPEDIDO = @ID_NroPedido AND ID_ORG = @ID_Org		
	
	DECLARE CDETALLEPROD CURSOR FOR
	SELECT
		 COD_ITEM
		,NRO_LINEA
		,CANT_PEDIDA 
		,CANT_PENDIENTE
		,CANT_PICKEADA 
		,CANT_DESPACHO 
		,ID_TRX_PEDIDO
	FROM INVENTARIO_DETALLE_PEDIDOS WHERE ID_NROPEDIDO = @ID_NroPedido AND ID_ORG = @ID_Org
	
	-- Apertura del cursor
	OPEN CDETALLEPROD
	
	--Lectura de la primera fila del cursor
	FETCH CDETALLEPROD INTO
		@DET_COD_ITEM,
		@DET_NRO_LINEA,
		@DET_CANT_PEDIDA, 
		@DET_CANT_PENDIENTE,
		@DET_CANT_PICKEADA, 
		@DET_CANT_DESPACHO, 
		@DET_ID_TRX_PEDIDO 

	--DETALLE PRODUCTOS
	WHILE (@@FETCH_STATUS = 0 ) BEGIN	
		
		--INCIALIZACIÓN VARIABLES CUANDO COMIENZA A BUSCAR EL PRODUCTO
		SET @SEGUIR_SUGERIENDO = 'S';
		SET @CANTIDAD_SUGERIDA_SUMA = 0;
		SET @LINEA_SUGERENCIA = 0;
	
		--PRIMERA REGLA FEFO
		DECLARE
			@FEFO_ID_LOTE VARCHAR(50),
			@FEFO_DISPONIBLE NUMERIC(18, 3),
			@FEFO_ID_LOCALIZADOR NUMERIC(18, 3),
			@FEFO_COD_ITEM NUMERIC(18, 3)
		
		----SELECT PARA FEFO
		--SELECT --*
		--	 ID_LOTE
		--	,DISPONIBLE 
		--	,ID_LOCALIZADOR 
		--	,COD_ITEM
		--	--,SUGERIDO
		--FROM @TABLA_LOTES_LOCALIZADORES 
		--WHERE SUGERIDO = 0 AND COD_ITEM = @DET_COD_ITEM
		--ORDER BY FECHA_EXPIRA ASC		
		
		DECLARE CFEFO CURSOR FOR
		SELECT --*
			 ID_LOTE
			,DISPONIBLE 
			,ID_LOCALIZADOR 
			,COD_ITEM
			--,SUGERIDO
		FROM @TABLA_LOTES_LOCALIZADORES 
		WHERE SUGERIDO = 0 AND COD_ITEM = @DET_COD_ITEM
		ORDER BY FECHA_EXPIRA ASC
			  
		-- Apertura del cursor
		OPEN CFEFO
		
		--Lectura de la primera fila del cursor
		FETCH CFEFO INTO
			@FEFO_ID_LOTE,
			@FEFO_DISPONIBLE,
			@FEFO_ID_LOCALIZADOR,
			@FEFO_COD_ITEM	
		
		--REGLA FEFO
		WHILE (@@FETCH_STATUS = 0) BEGIN	
			
			IF @SEGUIR_SUGERIENDO = 'S' BEGIN
			
				IF @DET_CANT_PEDIDA > @CANTIDAD_SUGERIDA_SUMA BEGIN
					
					PRINT CAST(@DET_CANT_PEDIDA AS VARCHAR(15)) + ' - ' + CAST(@FEFO_DISPONIBLE AS VARCHAR(15))
					
					SET @CANTIDAD_SUGERIDA_SUMA = @CANTIDAD_SUGERIDA_SUMA + @FEFO_DISPONIBLE
					SET @LINEA_SUGERENCIA = @LINEA_SUGERENCIA + 1
					
					--LIMITA LA CANTIDAD A PICKEAR SI SE EXCEDE A LA CANTIDAD PEDIDA
					IF @DET_CANT_PEDIDA < @CANTIDAD_SUGERIDA_SUMA BEGIN
						SET @FEFO_DISPONIBLE = @FEFO_DISPONIBLE - (@CANTIDAD_SUGERIDA_SUMA - @DET_CANT_PEDIDA);						
						SET @CANTIDAD_SUGERIDA_SUMA = @DET_CANT_PEDIDA;
					END						
					
					--INSERT EN LA TABLA Inventario_Detalle_Trx_Pedidos Y Inventario_Pedido_Movimiento --ID_PDO_MOVMTO
					--SELECT * FROM Inventario_Detalle_Trx_Pedidos					
					INSERT INTO Inventario_Detalle_Trx_Pedidos
					SELECT @ID_NROPEDIDO ID_NroPedido
						  ,@DET_COD_ITEM Cod_Item
						  ,@DET_NRO_LINEA NroLinea
						  ,@LINEA_SUGERENCIA Nro_SubLinea
						  ,@ACTUAL_PDO_MOVMTO ID_Pdo_Movmto
						  ,DBO.SI(@LINEA_SUGERENCIA, 1, @DET_CANT_PEDIDA) Cant_Pedida
						  ,DBO.SI(@LINEA_SUGERENCIA, 1, @DET_CANT_PENDIENTE) Cant_Pendiente
						  ,@FEFO_DISPONIBLE Cant_Pickeada 
						  ,@DET_CANT_DESPACHO Cant_Despacho
						  ,@FEFO_ID_LOTE ID_Lote
						  ,@FEFO_ID_LOCALIZADOR ID_Localizador_Origen						  
						  ,(SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 60) ID_Localizador_Destino --DESTINO STAGE
						  ,@DET_ID_TRX_PEDIDO _ID_TRX_Pedido
						  ,0 Nro_Entrega
						  ,10 Cod_Estado_Linea --(SELECT * FROM Inventario_Estado_Linea_Pedidos WHERE COD_ESTADO_LINEA = 10)
						  ,(SELECT NOMBRE_ESTADO_LINEA FROM Inventario_Estado_Linea_Pedidos WHERE COD_ESTADO_LINEA = 20) Nombre_Sgte_Estado
						  ,@FECHA_TRANSACCION Fech_Creacion
						  ,NULL Fech_Actualiza
						  ,@ID_Usro_Crea ID_Usro_Crea
						  ,NULL ID_Usro_Act
						  ,@ID_Org ID_Org
					
					
					UPDATE @TABLA_LOTES_LOCALIZADORES
						SET SUGERIDO = 1
					WHERE COD_ITEM = @DET_COD_ITEM AND ID_LOTE = @FEFO_ID_LOTE AND ID_LOCALIZADOR = @FEFO_ID_LOCALIZADOR;					
					
					--SELECT * FROM Inventario_Pedido_Movimiento
					INSERT INTO Inventario_Pedido_Movimiento
					SELECT --ID_SEC
						   @ID_NROPEDIDO ID_NroPedido
						  ,@ACTUAL_PDO_MOVMTO ID_Pdo_Movmto
						  ,@DET_COD_ITEM Cod_Item
						  ,DBO.SI(@LINEA_SUGERENCIA, 1, @DET_CANT_PEDIDA)	Cant_Pedida
						  ,@FEFO_DISPONIBLE Cant_Sugerida
						  ,@FEFO_ID_LOTE ID_Lote
						  ,@FEFO_ID_LOCALIZADOR ID_Localizador_Origen
						  ,(SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 60) ID_Localizador_Destino --DESTINO STAGE
						  ,@FECHA_TRANSACCION Fech_Creacion
						  ,NULL Fech_Actualiza
						  ,@ID_Usro_Crea ID_Usro_Crea
						  ,NULL ID_Usro_Act
						  ,@ID_Org ID_Org
						  ,'NO' Cancelar_Ped_Mvto
						  ,'NO' Pickeado	
						  
					--SELECT * FROM dbo.Inventario_Stock_Lotes WHERE ID_LOTE = 201705000033
					UPDATE Inventario_Stock_Lotes
						SET DISPONIBLE = (DISPONIBLE - @FEFO_DISPONIBLE),
							RESERVA = (RESERVA + @FEFO_DISPONIBLE)
					WHERE ID_LOCALIZADOR = @FEFO_ID_LOCALIZADOR
						AND ID_LOTE = @FEFO_ID_LOTE;						  
					
				END
				ELSE BEGIN
					
					SET @SEGUIR_SUGERIENDO = 'N'
					PRINT CAST(@CANTIDAD_SUGERIDA_SUMA AS VARCHAR(15))
					--SET @CANTIDAD_SUGERIDA_SUMA = 0;
					
				END
			
			END 
			
			--Lectura de las siguientes filas del cursor
			FETCH CFEFO INTO
				@FEFO_ID_LOTE,
				@FEFO_DISPONIBLE,
				@FEFO_ID_LOCALIZADOR,
				@FEFO_COD_ITEM			
		
		END
		
		-- Cierre del cursor
		CLOSE CFEFO

		-- Liberar los recursos
		DEALLOCATE CFEFO			
		
		
		--INCIALIZACIÓN VARIABLES CUANDO COMIENZA A BUSCAR POR SEGUNDA REGLA
		SET @SEGUIR_SUGERIENDO = 'S';
		--SET @CANTIDAD_SUGERIDA_SUMA = 0;
		--SET @LINEA_SUGERENCIA = 0;
		
		
		
		
		
		
		
		--SEGUNDA REGLA FECHA RECEPCION ASC
		DECLARE
			@FERE_ID_LOTE VARCHAR(50),
			@FERE_DISPONIBLE NUMERIC(18, 3),
			@FERE_ID_LOCALIZADOR NUMERIC(18, 3),
			@FERE_COD_ITEM NUMERIC(18, 3)
		
		DECLARE CFECHA_RECEPCION CURSOR FOR
		SELECT --*
			 ID_LOTE
			,DISPONIBLE 
			,ID_LOCALIZADOR 
			,COD_ITEM
			--,SUGERIDO
		FROM @TABLA_LOTES_LOCALIZADORES 
		WHERE SUGERIDO = 0 AND COD_ITEM = @DET_COD_ITEM
		ORDER BY FECHA_ORIGEN ASC
	    
		-- Apertura del cursor
		OPEN CFECHA_RECEPCION
		
		--Lectura de la primera fila del cursor
		FETCH CFECHA_RECEPCION INTO
			@FERE_ID_LOTE,
			@FERE_DISPONIBLE,
			@FERE_ID_LOCALIZADOR,
			@FERE_COD_ITEM	
		
		--REGLA FECHA RECEPCION ASC
		WHILE (@@FETCH_STATUS = 0) BEGIN	
			
			IF @SEGUIR_SUGERIENDO = 'S' BEGIN
			
				IF @DET_CANT_PEDIDA > @CANTIDAD_SUGERIDA_SUMA BEGIN
					
					PRINT CAST(@DET_CANT_PEDIDA AS VARCHAR(15)) + ' - ' + CAST(@FERE_DISPONIBLE AS VARCHAR(15))
					
					SET @CANTIDAD_SUGERIDA_SUMA = @CANTIDAD_SUGERIDA_SUMA + @FERE_DISPONIBLE
					SET @LINEA_SUGERENCIA = @LINEA_SUGERENCIA + 1
					
					--LIMITA LA CANTIDAD A PICKEAR SI SE EXCEDE A LA CANTIDAD PEDIDA
					IF @DET_CANT_PEDIDA < @CANTIDAD_SUGERIDA_SUMA BEGIN
						SET @FERE_DISPONIBLE = @FERE_DISPONIBLE - (@CANTIDAD_SUGERIDA_SUMA - @DET_CANT_PEDIDA);						
						SET @CANTIDAD_SUGERIDA_SUMA = @DET_CANT_PEDIDA;
					END						
					
					--INSERT EN LA TABLA Inventario_Detalle_Trx_Pedidos Y Inventario_Pedido_Movimiento --ID_PDO_MOVMTO
					--SELECT * FROM Inventario_Detalle_Trx_Pedidos					
					INSERT INTO Inventario_Detalle_Trx_Pedidos
					SELECT @ID_NROPEDIDO ID_NroPedido
						  ,@DET_COD_ITEM Cod_Item
						  ,@DET_NRO_LINEA NroLinea
						  ,@LINEA_SUGERENCIA Nro_SubLinea
						  ,@ACTUAL_PDO_MOVMTO ID_Pdo_Movmto
						  ,DBO.SI(@LINEA_SUGERENCIA, 1, @DET_CANT_PEDIDA)	Cant_Pedida
						  ,DBO.SI(@LINEA_SUGERENCIA, 1, @DET_CANT_PENDIENTE) Cant_Pendiente
						  ,@FERE_DISPONIBLE Cant_Pickeada 
						  ,@DET_CANT_DESPACHO Cant_Despacho
						  ,@FERE_ID_LOTE ID_Lote
						  ,@FERE_ID_LOCALIZADOR ID_Localizador_Origen						  
						  ,(SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 60) ID_Localizador_Destino --DESTINO STAGE
						  ,@DET_ID_TRX_PEDIDO _ID_TRX_Pedido
						  ,0 Nro_Entrega
						  ,10 Cod_Estado_Linea --(SELECT * FROM Inventario_Estado_Linea_Pedidos WHERE COD_ESTADO_LINEA = 10)
						  ,(SELECT NOMBRE_ESTADO_LINEA FROM Inventario_Estado_Linea_Pedidos WHERE COD_ESTADO_LINEA = 20) Nombre_Sgte_Estado
						  ,@FECHA_TRANSACCION Fech_Creacion
						  ,NULL Fech_Actualiza
						  ,@ID_Usro_Crea ID_Usro_Crea
						  ,NULL ID_Usro_Act
						  ,@ID_Org ID_Org
					
					
					UPDATE @TABLA_LOTES_LOCALIZADORES
						SET SUGERIDO = 1
					WHERE COD_ITEM = @DET_COD_ITEM AND ID_LOTE = @FERE_ID_LOTE AND ID_LOCALIZADOR = @FERE_ID_LOCALIZADOR;					
					
					--SELECT * FROM Inventario_Pedido_Movimiento
					INSERT INTO Inventario_Pedido_Movimiento
					SELECT --ID_SEC
						   @ID_NROPEDIDO ID_NroPedido
						  ,@ACTUAL_PDO_MOVMTO ID_Pdo_Movmto
						  ,@DET_COD_ITEM Cod_Item
						  ,DBO.SI(@LINEA_SUGERENCIA, 1, @DET_CANT_PEDIDA)	Cant_Pedida
						  ,@FERE_DISPONIBLE Cant_Sugerida
						  ,@FERE_ID_LOTE ID_Lote
						  ,@FERE_ID_LOCALIZADOR ID_Localizador_Origen
						  ,(SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 60) ID_Localizador_Destino --DESTINO STAGE
						  ,@FECHA_TRANSACCION Fech_Creacion
						  ,NULL Fech_Actualiza
						  ,@ID_Usro_Crea ID_Usro_Crea
						  ,NULL ID_Usro_Act
						  ,@ID_Org ID_Org
						  ,'NO' Cancelar_Ped_Mvto
						  ,'NO' Pickeado	
					
					--SELECT * FROM dbo.Inventario_Stock_Lotes WHERE ID_LOTE = 201705000033
					UPDATE Inventario_Stock_Lotes
						SET DISPONIBLE = (DISPONIBLE - @FERE_DISPONIBLE),
							RESERVA = (RESERVA + @FERE_DISPONIBLE) 
					WHERE ID_LOCALIZADOR = @FERE_ID_LOCALIZADOR
						AND ID_LOTE = @FERE_ID_LOTE;					
					
					
				END
				ELSE BEGIN
					
					SET @SEGUIR_SUGERIENDO = 'N'
					PRINT CAST(@CANTIDAD_SUGERIDA_SUMA AS VARCHAR(15))
					--SET @CANTIDAD_SUGERIDA_SUMA = 0;
					
				END
			
			END 
			
			--Lectura de las siguientes filas del cursor
			FETCH CFECHA_RECEPCION INTO
				@FERE_ID_LOTE,
				@FERE_DISPONIBLE,
				@FERE_ID_LOCALIZADOR,
				@FERE_COD_ITEM				
		
		END
		
		-- Cierre del cursor
		CLOSE CFECHA_RECEPCION

		-- Liberar los recursos
		DEALLOCATE CFECHA_RECEPCION			
		
		
		
		
		
		
		
		
		
		
		
		
		
		--SEGUNDA REGLA LOCALIZADOR ASC
		DECLARE
			@LOC_ID_LOTE VARCHAR(50),
			@LOC_DISPONIBLE NUMERIC(18, 3),
			@LOC_ID_LOCALIZADOR NUMERIC(18, 3),
			@LOC_COD_ITEM NUMERIC(18, 3)
		
		DECLARE CLOCALIZADOR CURSOR FOR
		SELECT --*
			 ID_LOTE
			,DISPONIBLE 
			,ID_LOCALIZADOR 
			,COD_ITEM
			--,SUGERIDO
		FROM @TABLA_LOTES_LOCALIZADORES 
		WHERE SUGERIDO = 0 AND COD_ITEM = @DET_COD_ITEM
		ORDER BY
			SEGMENTO1 ASC, --ORGANIZACION 
			SEGMENTO2 ASC, --ZONA
			SEGMENTO3 ASC, --SUBZONA
			SEGMENTO4 ASC, --PASILLO
			SEGMENTO5 ASC, --FILA
			SEGMENTO6 ASC; --COLUMNA
	    
		-- Apertura del cursor
		OPEN CLOCALIZADOR
		
		--Lectura de la primera fila del cursor
		FETCH CLOCALIZADOR INTO
			@LOC_ID_LOTE,
			@LOC_DISPONIBLE,
			@LOC_ID_LOCALIZADOR,
			@LOC_COD_ITEM	
		
		--REGLA LOCALIZADOR ASC
		WHILE (@@FETCH_STATUS = 0) BEGIN	
			
			IF @SEGUIR_SUGERIENDO = 'S' BEGIN
			
				IF @DET_CANT_PEDIDA > @CANTIDAD_SUGERIDA_SUMA BEGIN
					
					PRINT CAST(@DET_CANT_PEDIDA AS VARCHAR(15)) + ' - ' + CAST(@LOC_DISPONIBLE AS VARCHAR(15))
					
					SET @CANTIDAD_SUGERIDA_SUMA = @CANTIDAD_SUGERIDA_SUMA + @FERE_DISPONIBLE
					SET @LINEA_SUGERENCIA = @LINEA_SUGERENCIA + 1
					
					--LIMITA LA CANTIDAD A PICKEAR SI SE EXCEDE A LA CANTIDAD PEDIDA
					IF @DET_CANT_PEDIDA < @CANTIDAD_SUGERIDA_SUMA BEGIN
						SET @LOC_DISPONIBLE = @LOC_DISPONIBLE - (@CANTIDAD_SUGERIDA_SUMA - @DET_CANT_PEDIDA);						
						SET @CANTIDAD_SUGERIDA_SUMA = @DET_CANT_PEDIDA;
					END						
					
					--INSERT EN LA TABLA Inventario_Detalle_Trx_Pedidos Y Inventario_Pedido_Movimiento --ID_PDO_MOVMTO
					--SELECT * FROM Inventario_Detalle_Trx_Pedidos					
					INSERT INTO Inventario_Detalle_Trx_Pedidos
					SELECT @ID_NROPEDIDO ID_NroPedido
						  ,@DET_COD_ITEM Cod_Item
						  ,@DET_NRO_LINEA NroLinea
						  ,@LINEA_SUGERENCIA Nro_SubLinea
						  ,@ACTUAL_PDO_MOVMTO ID_Pdo_Movmto
						  ,DBO.SI(@LINEA_SUGERENCIA, 1, @DET_CANT_PEDIDA)	Cant_Pedida
						  ,DBO.SI(@LINEA_SUGERENCIA, 1, @DET_CANT_PENDIENTE) Cant_Pendiente
						  ,@LOC_DISPONIBLE Cant_Pickeada 
						  ,@DET_CANT_DESPACHO Cant_Despacho
						  ,@LOC_ID_LOTE ID_Lote
						  ,@LOC_ID_LOCALIZADOR ID_Localizador_Origen						  
						  ,(SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 60) ID_Localizador_Destino --DESTINO STAGE
						  ,@DET_ID_TRX_PEDIDO _ID_TRX_Pedido
						  ,0 Nro_Entrega
						  ,10 Cod_Estado_Linea --(SELECT * FROM Inventario_Estado_Linea_Pedidos WHERE COD_ESTADO_LINEA = 10)
						  ,(SELECT NOMBRE_ESTADO_LINEA FROM Inventario_Estado_Linea_Pedidos WHERE COD_ESTADO_LINEA = 20) Nombre_Sgte_Estado
						  ,@FECHA_TRANSACCION Fech_Creacion
						  ,NULL Fech_Actualiza
						  ,@ID_Usro_Crea ID_Usro_Crea
						  ,NULL ID_Usro_Act
						  ,@ID_Org ID_Org
					
					
					UPDATE @TABLA_LOTES_LOCALIZADORES
						SET SUGERIDO = 1
					WHERE COD_ITEM = @DET_COD_ITEM AND ID_LOTE = @LOC_ID_LOTE AND ID_LOCALIZADOR = @LOC_ID_LOCALIZADOR;					
					
					--SELECT * FROM Inventario_Pedido_Movimiento
					INSERT INTO Inventario_Pedido_Movimiento
					SELECT --ID_SEC
						   @ID_NROPEDIDO ID_NroPedido
						  ,@ACTUAL_PDO_MOVMTO ID_Pdo_Movmto
						  ,@DET_COD_ITEM Cod_Item
						  ,DBO.SI(@LINEA_SUGERENCIA, 1, @DET_CANT_PEDIDA)	Cant_Pedida
						  ,@LOC_DISPONIBLE Cant_Sugerida
						  ,@LOC_ID_LOTE ID_Lote
						  ,@LOC_ID_LOCALIZADOR ID_Localizador_Origen
						  ,(SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 60) ID_Localizador_Destino --DESTINO STAGE
						  ,@FECHA_TRANSACCION Fech_Creacion
						  ,NULL Fech_Actualiza
						  ,@ID_Usro_Crea ID_Usro_Crea
						  ,NULL ID_Usro_Act
						  ,@ID_Org ID_Org
						  ,'NO' Cancelar_Ped_Mvto
						  ,'NO' Pickeado	
					
					--SELECT * FROM dbo.Inventario_Stock_Lotes WHERE ID_LOTE = 201705000033
					UPDATE Inventario_Stock_Lotes
						SET DISPONIBLE = (DISPONIBLE - @LOC_DISPONIBLE),
							RESERVA = (RESERVA + @LOC_DISPONIBLE)
					WHERE ID_LOCALIZADOR = @LOC_ID_LOCALIZADOR
						AND ID_LOTE = @LOC_ID_LOTE;					
					
				END
				ELSE BEGIN
					
					SET @SEGUIR_SUGERIENDO = 'N'
					PRINT CAST(@CANTIDAD_SUGERIDA_SUMA AS VARCHAR(15))
					--SET @CANTIDAD_SUGERIDA_SUMA = 0;
					
				END
			
			END 
			
			--Lectura de las siguientes filas del cursor
			FETCH CLOCALIZADOR INTO
				@LOC_ID_LOTE,
				@LOC_DISPONIBLE,
				@LOC_ID_LOCALIZADOR,
				@LOC_COD_ITEM				
		
		END
		
		-- Cierre del cursor
		CLOSE CLOCALIZADOR

		-- Liberar los recursos
		DEALLOCATE CLOCALIZADOR			
		
		
		
		--VERIFICACIÓN DE PENDIENTES. SI EXISTEN SE AGREGA UNA LÍNEA CON LOTE EN BLANCO A DETALLE_TRX_PEDIDOS Y PEDIDO_MVMTO
		IF @DET_CANT_PEDIDA > @CANTIDAD_SUGERIDA_SUMA BEGIN
			
			SET @LINEA_SUGERENCIA = @LINEA_SUGERENCIA + 1
			
			--INSERT EN LA TABLA Inventario_Detalle_Trx_Pedidos Y Inventario_Pedido_Movimiento --ID_PDO_MOVMTO
			--SELECT * FROM Inventario_Detalle_Trx_Pedidos					
			INSERT INTO Inventario_Detalle_Trx_Pedidos
			SELECT @ID_NROPEDIDO ID_NroPedido
				  ,@DET_COD_ITEM Cod_Item
				  ,@DET_NRO_LINEA NroLinea
				  ,@LINEA_SUGERENCIA Nro_SubLinea
				  ,@ACTUAL_PDO_MOVMTO ID_Pdo_Movmto
				  ,DBO.SI(@LINEA_SUGERENCIA, 1, @DET_CANT_PEDIDA)	Cant_Pedida
				  ,DBO.SI(@LINEA_SUGERENCIA, 1, @DET_CANT_PENDIENTE) Cant_Pendiente
				  ,(@DET_CANT_PEDIDA - @CANTIDAD_SUGERIDA_SUMA) Cant_Pickeada 
				  ,@DET_CANT_DESPACHO Cant_Despacho
				  ,'''' ID_Lote
				  ,0 ID_Localizador_Origen						  
				  ,0 ID_Localizador_Destino --DESTINO STAGE
				  ,@DET_ID_TRX_PEDIDO _ID_TRX_Pedido
				  ,0 Nro_Entrega
				  ,90 Cod_Estado_Linea --(SELECT * FROM Inventario_Estado_Linea_Pedidos WHERE COD_ESTADO_LINEA = 90)
				  ,(SELECT NOMBRE_ESTADO_LINEA FROM Inventario_Estado_Linea_Pedidos WHERE COD_ESTADO_LINEA = 90) Nombre_Sgte_Estado
				  ,@FECHA_TRANSACCION Fech_Creacion
				  ,NULL Fech_Actualiza
				  ,@ID_Usro_Crea ID_Usro_Crea
				  ,NULL ID_Usro_Act
				  ,@ID_Org ID_Org;			
			
			
			--SELECT * FROM Inventario_Pedido_Movimiento
			INSERT INTO Inventario_Pedido_Movimiento
			SELECT --ID_SEC
				   @ID_NROPEDIDO ID_NroPedido
				  ,@ACTUAL_PDO_MOVMTO ID_Pdo_Movmto
				  ,@DET_COD_ITEM Cod_Item
				  ,DBO.SI(@LINEA_SUGERENCIA, 1, @DET_CANT_PEDIDA)	Cant_Pedida
				  ,(@DET_CANT_PEDIDA - @CANTIDAD_SUGERIDA_SUMA) Cant_Sugerida
				  ,'''' ID_Lote
				  ,0 ID_Localizador_Origen
				  ,0 ID_Localizador_Destino --DESTINO STAGE
				  ,@FECHA_TRANSACCION Fech_Creacion
				  ,NULL Fech_Actualiza
				  ,@ID_Usro_Crea ID_Usro_Crea
				  ,NULL ID_Usro_Act
				  ,@ID_Org ID_Org
				  ,'NO' Cancelar_Ped_Mvto
				  ,'NO' Pickeado;					
		
		END		
				
		
		
		
		
		
	
	
		--Lectura de las siguientes filas del cursor
		FETCH CDETALLEPROD INTO
			@DET_COD_ITEM,
			@DET_NRO_LINEA,
			@DET_CANT_PEDIDA, 
			@DET_CANT_PENDIENTE,
			@DET_CANT_PICKEADA, 
			@DET_CANT_DESPACHO, 
			@DET_ID_TRX_PEDIDO 	
		
	END	  
	  
	  
	-- Cierre del cursor
	CLOSE CDETALLEPROD

	-- Liberar los recursos
	DEALLOCATE CDETALLEPROD
	
	--SELECT @@TRANCOUNT--ROLLBACK
	

	COMMIT TRANSACTION


END TRY
BEGIN CATCH
	
	/* Hay un error, deshacemos los cambios*/ 
	ROLLBACK TRANSACTION -- O solo ROLLBACK
	
	DECLARE @MENSAJEERROR VARCHAR(MAX) = ERROR_MESSAGE();
	DECLARE @SEVERIDADERROR BIGINT = ERROR_SEVERITY();
	DECLARE @ESTADOERROR BIGINT = ERROR_STATE();
	DECLARE @LINEAERROR VARCHAR(5) = CAST(ERROR_LINE() AS VARCHAR(5));
	DECLARE @ERRORMENSAJE VARCHAR(MAX);
	SET @ERRORMENSAJE = (@LINEAERROR + ' - ' + @MENSAJEERROR);
	
     RAISERROR (@ERRORMENSAJE, @SEVERIDADERROR, @ESTADOERROR)
				 
     --PRINT ERROR_SEVERITY()    
     --PRINT ERROR_STATE()  
     --PRINT ERROR_PROCEDURE()   
     --PRINT ERROR_LINE()   
     --PRINT ERROR_MESSAGE() 
	
END CATCH	

END
GO
