USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[CONTINGENCIA_PEDIDO_CERRARPEDIDO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
/*
EXEC INV_PEDIDO_CERRARPEDIDO
2,
17,
4,
4,
'<root>
  <f sku="58843" lot="201705000018" cantpick="20" locoid="3" loco="DSC.0.1.A.3.001" />
  <f sku="58843" lot="201705000019" cantpick="6" locoid="3" loco="DSC.0.1.A.3.001" />
  <f sku="58843" lot="201705000036" cantpick="1474" locoid="1413" loco="DSC.0.1.A.3.004" />
  <f sku="53235" lot="201705000037" cantpick="20" locoid="1233" loco="DSC.0.1.P.3.001" />
  <f sku="53235" lot="201705000037" cantpick="4980" locoid="1233" loco="DSC.0.1.P.3.001" />
</root>'

--yyyy-mm-dd hh:mi:ss.mmm(24h)

*/
create PROCEDURE [dbo].[CONTINGENCIA_PEDIDO_CERRARPEDIDO]
--DECLARE
	-- Add the parameters for the stored procedure here	
	 @ID_NROPEDIDO numeric(18, 0)	 
	,@ID_Org numeric(18, 0)
	,@ID_USRO_CREA NUMERIC(18, 0)	
	,@ID_USRO_ACT NUMERIC(18, 0)	
	,@FECHA_INSERT DATETIME	
	,@XML_LOTES varchar(MAX)	
AS
BEGIN

--SET @ID_NROPEDIDO = 2
--SET @ID_Org = 17
--SET @ID_USRO_CREA = 4
--SET @ID_USRO_ACT = 4
--SET @XML_LOTES = '<root>
--  <f sku="58843" l="1" sl="1" lot="201705000018" cantpick="20" locoid="3" loco="DSC.0.1.A.3.001" />
--  <f sku="58843" l="1" sl="2" lot="201705000019" cantpick="6" locoid="3" loco="DSC.0.1.A.3.001" />
--  <f sku="58843" l="1" sl="3" lot="201705000036" cantpick="1474" locoid="1413" loco="DSC.0.1.A.3.004" />
--  <f sku="53235" l="2" sl="1" lot="201705000037" cantpick="20" locoid="1233" loco="DSC.0.1.P.3.001" />
--  <f sku="53235" l="2" sl="2" lot="201705000037" cantpick="4980" locoid="1233" loco="DSC.0.1.P.3.001" />
--</root>'



BEGIN TRANSACTION -- O solo BEGIN TRAN		
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;

	--DECLARE @FECHA_INSERT DATETIME = (SELECT GETDATE());	
	--DECLARE @AGREGO INT = 0;
	DECLARE @ID_LOCALIZADOR_STAGE NUMERIC(18, 0) = (SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 60)
	--Carga de productos en detalle de documentos
	--DECLARE @oxml XML;
	DECLARE @oxmlLotes XML;
	SET @oxmlLotes = N'''' + @XML_LOTES + '''';

BEGIN TRY

	--SELECT
	--	 Tbl.Col.value('@sku', 'numeric(18, 0)') COD_ITEM
	--	,Tbl.Col.value('@lot', 'varchar(50)') COD_ITEM
	--	,Tbl.Col.value('@cantpick', 'numeric(18, 0)') Cant_Pickeada
	--	,Tbl.Col.value('@locoid', 'numeric(18, 0)') ID_Localizador_Origen
	--	,Tbl.Col.value('@loco', 'varchar(50)') Localizador_Origen
	--FROM @OXMLLOTES.nodes('//root/f') Tbl(Col)
	
	--SELECT --ID_NroPedido
	--	   PROD.Cod_Item
	--	  ,PROD.DESCRIPTOR_CORTA
	--	  ,DETALLE.Nro_Linea
	--	  ,DETALLE.Nro_SubLinea
	--	  ,DETALLE.ID_Pdo_Movmto
	--	  ,DETALLE.Cant_Pedida
	--	  ,DETALLE.Cant_Pendiente
	--	  ,Tbl.Col.value('@cantpick', 'numeric(18, 0)') Cant_Pickeada --DETALLE.Cant_Pickeada
	--	  ,DETALLE.Cant_Despacho
	--	  ,DETALLE.ID_Lote
	--	  ,SUBINV.DESCRIPCION SUBINV_ORIGEN
	--	  ,Tbl.Col.value('@locoid', 'numeric(18, 0)') ID_Localizador_Origen --DETALLE.ID_Localizador_Origen
	--	  ,Tbl.Col.value('@loco', 'varchar(50)') Localizador_Origen --LOC.COMBINACION_LOCALIZADOR Localizador_Origen
	--	  ,DETALLE.ID_Localizador_Destino
	--	  ,'STAGE' Localizador_Destino
	--	  ,EST_LINEA.NOMBRE_Estado_Linea
	--	  ,DETALLE.Nomb_Sgte_Estado
	--	  ,UM.Unidad_Medida_Abreviada Unidad_Medida --PROD.ID_UM
	--	  ,DETALLE.ID_TRX_Pedido 
	--FROM Inventario_Detalle_Trx_Pedidos DETALLE
	--	INNER JOIN Inventario_Items PROD
	--		ON DETALLE.Cod_Item = PROD.COD_ITEM AND DETALLE.ID_Org = PROD.ID_ORG
	--	INNER JOIN Inventario_Estado_Linea_Pedidos EST_LINEA
	--		ON DETALLE.Cod_Estado_Linea = EST_LINEA.COD_ESTADO_LINEA 
	--	INNER JOIN Inventario_SubInv_Localizadores LOC
	--		ON DETALLE.ID_Localizador_Origen = LOC.ID_Localizador AND DETALLE.ID_Org = LOC.ID_ORG
	--	INNER JOIN @OXMLLOTES.nodes('//root/f') Tbl(Col)
	--		ON DETALLE.Cod_Item = Tbl.Col.value('@sku', 'numeric(18, 0)') AND DETALLE.ID_Lote = Tbl.Col.value('@lot', 'varchar(50)')
	--	INNER JOIN Inventario_Unidad_Medida_Primaria UM
	--		ON PROD.ID_UM = UM.ID_UM
	--	INNER JOIN dbo.Inventario_SubInventarios SUBINV
	--		ON LOC.ID_SUBINV = SUBINV.ID_SUBINV 
	--WHERE DETALLE.ID_NROPEDIDO = @ID_NROPEDIDO
	--	AND DETALLE.ID_ORG = @ID_ORG
	--ORDER BY DETALLE.NRO_LINEA ASC, DETALLE.NRO_SUBLINEA ASC
	
	/*
	CÓDIGO PARA EDITAR LA TABLA Inventario_Pedido_Movimiento
	SELECT * FROM dbo.Inventario_Pedido_Movimiento
	
	
	*/	
	
	--MOVIMIENTO ORIGEN
	INSERT INTO [dbo].[Inventario_Detalle_Transacciones]
	SELECT
		 DETALLE.ID_TRX_Pedido 
		,@FECHA_INSERT
		,PROD.Cod_Item
		,@ID_Org
		,SUBINV.DESCRIPCION SUBINV_ORIGEN
		,Tbl.Col.value('@loco', 'varchar(50)') Localizador_Origen
		,'STAGE' Cod_Subinv_Destino
		,NULL Localizador_Destino
		,'INVENTARIO' Origen_TRX
		,0 Nro_Entrega
		,NULL Documento
		,NULL Razon_Social
		,DETALLE.ID_Lote
		,-Tbl.Col.value('@cantpick', 'numeric(18, 0)') Cantidad_TRX
		,UM.Unidad_Medida_Abreviada Unidad_Medida
		,@ID_USRO_CREA ID_Usuario
		,PROD.Precio_Compra
	FROM Inventario_Detalle_Trx_Pedidos DETALLE
		INNER JOIN Inventario_Items PROD
			ON DETALLE.Cod_Item = PROD.COD_ITEM AND DETALLE.ID_Org = PROD.ID_ORG
		INNER JOIN Inventario_Estado_Linea_Pedidos EST_LINEA
			ON DETALLE.Cod_Estado_Linea = EST_LINEA.COD_ESTADO_LINEA 
		INNER JOIN Inventario_SubInv_Localizadores LOC
			ON DETALLE.ID_Localizador_Origen = LOC.ID_Localizador AND DETALLE.ID_Org = LOC.ID_ORG
		INNER JOIN @OXMLLOTES.nodes('//root/f') Tbl(Col)
			ON DETALLE.Cod_Item = Tbl.Col.value('@sku', 'numeric(18, 0)') 
				AND DETALLE.ID_Lote = Tbl.Col.value('@lot', 'varchar(50)')
				AND DETALLE.Nro_Linea = Tbl.Col.value('@l', 'numeric(18, 0)')
				AND DETALLE.Nro_SubLinea = Tbl.Col.value('@sl', 'numeric(18, 0)')
		INNER JOIN Inventario_Unidad_Medida_Primaria UM
			ON PROD.ID_UM = UM.ID_UM
		INNER JOIN dbo.Inventario_SubInventarios SUBINV
			ON LOC.ID_SUBINV = SUBINV.ID_SUBINV 			
	WHERE DETALLE.ID_NROPEDIDO = @ID_NROPEDIDO
		AND DETALLE.ID_ORG = @ID_ORG
		AND DETALLE.cod_estado_linea <> 100
	ORDER BY DETALLE.NRO_LINEA ASC, DETALLE.NRO_SUBLINEA ASC;
	
	
	--MOVIMIENTO DESTINO
	INSERT INTO [dbo].[Inventario_Detalle_Transacciones]
	SELECT
		 DETALLE.ID_TRX_Pedido 
		,@FECHA_INSERT
		,PROD.Cod_Item
		,@ID_Org
		,NULL SUBINV_ORIGEN
		,NULL Localizador_Origen
		,'STAGE' Cod_Subinv_Destino
		,NULL Localizador_Destino
		,'INVENTARIO' Origen_TRX
		,0 Nro_Entrega
		,NULL Documento
		,NULL Razon_Social
		,DETALLE.ID_Lote
		,Tbl.Col.value('@cantpick', 'numeric(18, 0)') Cantidad_TRX
		,UM.Unidad_Medida_Abreviada Unidad_Medida
		,@ID_USRO_CREA ID_Usuario
		,PROD.Precio_Compra
	FROM Inventario_Detalle_Trx_Pedidos DETALLE
		INNER JOIN Inventario_Items PROD
			ON DETALLE.Cod_Item = PROD.COD_ITEM AND DETALLE.ID_Org = PROD.ID_ORG
		INNER JOIN Inventario_Estado_Linea_Pedidos EST_LINEA
			ON DETALLE.Cod_Estado_Linea = EST_LINEA.COD_ESTADO_LINEA 
		INNER JOIN Inventario_SubInv_Localizadores LOC
			ON DETALLE.ID_Localizador_Origen = LOC.ID_Localizador AND DETALLE.ID_Org = LOC.ID_ORG
		INNER JOIN @OXMLLOTES.nodes('//root/f') Tbl(Col)
			ON DETALLE.Cod_Item = Tbl.Col.value('@sku', 'numeric(18, 0)') 
				AND DETALLE.ID_Lote = Tbl.Col.value('@lot', 'varchar(50)')
				AND DETALLE.Nro_Linea = Tbl.Col.value('@l', 'numeric(18, 0)')
				AND DETALLE.Nro_SubLinea = Tbl.Col.value('@sl', 'numeric(18, 0)')
		INNER JOIN Inventario_Unidad_Medida_Primaria UM
			ON PROD.ID_UM = UM.ID_UM
		INNER JOIN dbo.Inventario_SubInventarios SUBINV
			ON LOC.ID_SUBINV = SUBINV.ID_SUBINV 			
	WHERE DETALLE.ID_NROPEDIDO = @ID_NROPEDIDO
		AND DETALLE.ID_ORG = @ID_ORG
		AND DETALLE.cod_estado_linea <> 100
	ORDER BY DETALLE.NRO_LINEA ASC, DETALLE.NRO_SUBLINEA ASC;	
	
	--SELECT * FROM Inventario_Detalle_Transacciones WHERE Cod_Subinv_Destino = 'STAGE'
	
	
	
	----1º MOVIMIENTO EN STOCK DE LOTES (LO QUE QUEDA EN LOCALIZADOR ORIGEN)
	----INSERCIÓN DE STOCK DE LOTES
	----DELETE FROM Inventario_Stock_Lotes
	----WHERE ID_LOTE IN (SELECT Tbl.Col.value('@lot', 'varchar(50)') FROM @OXMLLOTES.nodes('//root/f') Tbl(Col))
	----	AND Id_Org = @Id_Org AND ID_Localizador = 3;
	
	--REBAJAR DE STOCK LOTES
	
	DECLARE 
		 @COD_ITEM NUMERIC(18, 0)
		,@ID_LOTE VARCHAR(50)
		,@CANT_PICKEADA NUMERIC(18, 0)
		,@ID_LOCALIZADOR_ORIGEN NUMERIC(18, 0)
		,@VOLUMEN NUMERIC(18, 5)	
		,@NRO_LINEA NUMERIC(18, 0)
		,@NRO_SUBLINEA NUMERIC(18, 0)		
	
	DECLARE CLOTES CURSOR FOR
	SELECT --ID_NroPedido
		   PROD.Cod_Item
		  ,DETALLE.ID_Lote
		  ,Tbl.Col.value('@cantpick', 'numeric(18, 0)') Cant_Pickeada --DETALLE.Cant_Pickeada
		  ,Tbl.Col.value('@locoid', 'numeric(18, 0)') ID_Localizador_Origen --DETALLE.ID_Localizador_Origen
		  ,PROD.VOLUMEN 
		  ,DETALLE.NRO_LINEA
		  ,DETALLE.NRO_SUBLINEA
	FROM Inventario_Detalle_Trx_Pedidos DETALLE
		INNER JOIN Inventario_Items PROD
			ON DETALLE.Cod_Item = PROD.COD_ITEM AND DETALLE.ID_Org = PROD.ID_ORG 
		INNER JOIN Inventario_Estado_Linea_Pedidos EST_LINEA
			ON DETALLE.Cod_Estado_Linea = EST_LINEA.COD_ESTADO_LINEA 
		INNER JOIN Inventario_SubInv_Localizadores LOC
			ON DETALLE.ID_Localizador_Origen = LOC.ID_Localizador AND DETALLE.ID_Org = LOC.ID_ORG
		INNER JOIN @OXMLLOTES.nodes('//root/f') Tbl(Col)
			ON DETALLE.Cod_Item = Tbl.Col.value('@sku', 'numeric(18, 0)') 
				AND DETALLE.ID_Lote = Tbl.Col.value('@lot', 'varchar(50)')
				AND DETALLE.Nro_Linea = Tbl.Col.value('@l', 'numeric(18, 0)')
				AND DETALLE.Nro_SubLinea = Tbl.Col.value('@sl', 'numeric(18, 0)')
		INNER JOIN Inventario_Unidad_Medida_Primaria UM
			ON PROD.ID_UM = UM.ID_UM
		INNER JOIN dbo.Inventario_SubInventarios SUBINV
			ON LOC.ID_SUBINV = SUBINV.ID_SUBINV 
	WHERE DETALLE.ID_NROPEDIDO = @ID_NROPEDIDO
		AND DETALLE.ID_ORG = @ID_ORG
		AND DETALLE.cod_estado_linea <> 100
	ORDER BY DETALLE.NRO_LINEA ASC, DETALLE.NRO_SUBLINEA ASC	
	
	-- Apertura del cursor
	OPEN CLOTES

	-- Lectura de la primera fila del cursor
	FETCH CLOTES INTO		
		 @COD_ITEM
		,@ID_LOTE
		,@CANT_PICKEADA
		,@ID_LOCALIZADOR_ORIGEN	
		,@VOLUMEN
		,@NRO_LINEA 
		,@NRO_SUBLINEA
		
	WHILE (@@FETCH_STATUS = 0 ) BEGIN
		
		--ACTUALIZA LA TABLA TRX_PEDIDOS
		UPDATE Inventario_Detalle_Trx_Pedidos
			SET COD_ESTADO_LINEA = 20,
				NOMB_SGTE_ESTADO = (SELECT NOMBRE_ESTADO_LINEA FROM Inventario_Estado_Linea_Pedidos WHERE COD_ESTADO_LINEA = 30),
				ID_USRO_ACT = @ID_USRO_ACT,
				FECH_ACTUALIZA = @FECHA_INSERT
		WHERE ID_NROPEDIDO = @ID_NROPEDIDO
			AND COD_ITEM = @COD_ITEM
			AND NRO_LINEA = @NRO_LINEA
			AND NRO_SUBLINEA = @NRO_SUBLINEA
			AND ID_LOTE = @ID_LOTE
			AND ID_LOCALIZADOR_ORIGEN = @ID_LOCALIZADOR_ORIGEN
			AND cod_estado_linea <> 100;
			
			
		--ACTUALIZA LA TABLA Inventario_Pedido_Movimiento
		UPDATE Inventario_Pedido_Movimiento	
			SET PICKEADO = 'SI',
				ID_USRO_ACT = @ID_USRO_ACT,
				FECH_ACTUALIZA = @FECHA_INSERT
		WHERE ID_NROPEDIDO = @ID_NROPEDIDO
			AND COD_ITEM = @COD_ITEM
			AND ID_LOTE = @ID_LOTE
			AND ID_LOCALIZADOR_ORIGEN = @ID_LOCALIZADOR_ORIGEN;
		
		--REBAJA DE STOCK
		UPDATE Inventario_Stock_Lotes
			SET EN_MANO = (EN_MANO - @CANT_PICKEADA), 
				RESERVA = (RESERVA - @CANT_PICKEADA),
				ID_Usro_Act = @ID_USRO_ACT,
				Fech_Actualiza = @FECHA_INSERT
		WHERE ID_LOTE = @ID_LOTE 
			AND ID_LOCALIZADOR = @ID_LOCALIZADOR_ORIGEN
			AND ID_ORG = @ID_ORG
			AND EN_MANO > 0;
			--AND DISPONIBLE > 0;
			
		PRINT 'REBAJA DE STOCK'
		
		--REGISTRAR LOTE EN STAGE
		IF NOT EXISTS(SELECT * FROM Inventario_Stock_Lotes WHERE ID_LOCALIZADOR = @ID_LOCALIZADOR_STAGE AND ID_LOTE = @ID_LOTE AND ID_ORG = @ID_ORG) BEGIN
			
			INSERT INTO Inventario_Stock_Lotes
				   (ID_Lote
				   ,ID_Localizador
				   ,ID_Org
				   ,En_Mano
				   ,Disponible
				   ,Reserva
				   ,ID_Usro_Crea
				   ,Fech_Creacion)
			 VALUES
				   (@ID_LOTE
				   ,@ID_LOCALIZADOR_STAGE
				   ,@ID_ORG
				   ,@CANT_PICKEADA
				   ,@CANT_PICKEADA
				   ,0
				   ,@ID_USRO_CREA
				   ,@FECHA_INSERT);
			
		END ELSE BEGIN
		
			--SELECT * FROM Inventario_Stock_Lotes
			UPDATE Inventario_Stock_Lotes
			   SET   En_Mano = En_Mano + @CANT_PICKEADA
					,Disponible = Disponible + @CANT_PICKEADA
					,ID_Usro_Act = @ID_USRO_ACT
					,Fech_Actualiza = @FECHA_INSERT
			 WHERE ID_LOCALIZADOR = @ID_LOCALIZADOR_STAGE AND ID_LOTE = @ID_LOTE AND ID_ORG = @ID_ORG;
		
		END		
		
		--REBAJA DE ESPACIO UTILIZADO EN LOCALIZADOR
		--SELECT * FROM Inventario_SubInv_Localizadores
		UPDATE Inventario_SubInv_Localizadores
			SET ESPACIO_UTILIZADO = ESPACIO_UTILIZADO - (@CANT_PICKEADA * @VOLUMEN),
				ESPACIO_DISPONIBLE = ESPACIO_DISPONIBLE + (@CANT_PICKEADA * @VOLUMEN),
				ID_Usro_Act = @ID_USRO_ACT,
				Fech_Actualiza = @FECHA_INSERT
		FROM Inventario_SubInv_Localizadores
		WHERE COD_ESTADO = 1
			AND CONTROL_LOCALIZADOR = 'S'
			AND VIGENCIA = 'S'
			AND ID_LOCALIZADOR = @ID_LOCALIZADOR_ORIGEN;
		
		FETCH CLOTES INTO		
			 @COD_ITEM
			,@ID_LOTE
			,@CANT_PICKEADA
			,@ID_LOCALIZADOR_ORIGEN			
			,@VOLUMEN
			,@NRO_LINEA 
			,@NRO_SUBLINEA			
			
	END	  
	  
	  
	-- Cierre del cursor
	CLOSE cLotes

	-- Liberar los recursos
	DEALLOCATE cLotes
	
	--SELECT * FROM Inventario_Estado_Documentos
	UPDATE Inventario_Cabecera_Documentos
		SET ID_ESTADO = 170
	WHERE Id_Docu = 20
		AND Folio_Documento = 
		(SELECT DISTINCT FOLIO_DOCUMENTO 
		FROM dbo.Inventario_Cabecera_Pedidos
		WHERE ID_NROPEDIDO = @ID_NROPEDIDO);
	
	----SELECT * FROM Inventario_Cabecera_Pedidos
	--UPDATE Inventario_Cabecera_Pedidos
	--	SET ESTADO = 'CERRADO'
	--WHERE ID_NROPEDIDO = @ID_NROPEDIDO;
	
	
	
	--ACTUALIZAMOS LA TABLA DETALLE PEDIDOS CON LA CANTIDAD PICKEADA
	DECLARE 
		 @DET_PED_PRODUCTOID NUMERIC(18, 0)
		,@DET_PED_SUMAPICKEADA NUMERIC(18, 0)
	
	DECLARE CPICKING CURSOR FOR	
	SELECT COD_ITEM, SUM(CANT_PICKEADA) TOTAL
	FROM Inventario_Detalle_Trx_Pedidos
	WHERE ID_NROPEDIDO = @ID_NROPEDIDO
		AND cod_estado_linea <> 100
	GROUP BY COD_ITEM
	
	OPEN CPICKING
	
	FETCH CPICKING INTO @DET_PED_PRODUCTOID, @DET_PED_SUMAPICKEADA
	
	WHILE (@@FETCH_STATUS = 0) BEGIN
		
		--SELECT * FROM dbo.Inventario_Detalle_Pedidos
		UPDATE Inventario_Detalle_Pedidos
			SET CANT_PICKEADA = @DET_PED_SUMAPICKEADA
		WHERE ID_NROPEDIDO = @ID_NROPEDIDO
			AND COD_ITEM = @DET_PED_PRODUCTOID
			AND ID_ORG = @ID_ORG
		
		FETCH CPICKING INTO @DET_PED_PRODUCTOID, @DET_PED_SUMAPICKEADA
	
	END
	
	CLOSE CPICKING
	
	DEALLOCATE CPICKING
	
	
	
	
	--SELECT * FROM Inventario_Stock_Lotes
	
	--SELECT @@TRANCOUNT --ROLLBACK		

/*
SELECT * FROM Inventario_Cabecera_Documentos

SELECT * FROM Inventario_Cabecera_Pedidos

SELECT * FROM dbo.Inventario_Detalle_Pedidos

SELECT * FROM Inventario_Stock_Lotes

SELECT * FROM Inventario_Detalle_Transacciones

SELECT * FROM Inventario_SubInv_Localizadores	WHERE ID_LOCALIZADOR = 2783

SELECT * FROM dbo.Inventario_Detalle_Trx_Pedidos

SELECT * FROM dbo.Inventario_Pedido_Movimiento 

*/
	
/*


select * from Inventario_Stock_Lotes
WHERE ID_Lote IN (
'201705000032',
'201705000033'
)
AND ID_Localizador <> 2790

*/	
	
	
	
	COMMIT TRANSACTION;

	SELECT 1 FILAS_AFECTADAS; --@@ROWCOUNT
	
	
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
