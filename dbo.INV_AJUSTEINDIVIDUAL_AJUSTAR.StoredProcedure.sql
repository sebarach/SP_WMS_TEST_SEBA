USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_AJUSTEINDIVIDUAL_AJUSTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
/*
EXEC INV_AJUSTEINDIVIDUAL_AJUSTAR 17, 4,
'<root>	<f Id="1" 	PropietarioId="52" 	Propietario="PROCTER &amp; GAMBLE CHILE LIMITADA" 	DuenoId="756" 	Dueno="FERNANDA BIJIT " 	Sku="53265" 	Descriptor="MUEBLE BODEGA FICTICIO AFEITADO Y DEPILACION SALCO BRAND" 	LoteId="201710010320" 	LoteProveedor="S/L" 	FechaVencimiento="20/10/2018 0:00:00" 	SubInventarioId="10" 	SubInvinventario="SUBINVENTARIO F-22" 	LocalizadorId="1714" 	Localizador="DSC.0.1.D.2.022" 	EnMano="2" 	Disponible="2" 	Reserva="0" 	CantidadFisica="10" 	SubInventarioFisicoId="10" 	SubInventarioFisico="SUBINVENTARIO F-22" 	LocalizadorFisicoId="3088" 	LocalizadorFisico="DSC.0.1.O.2.001" 	Diferencia="8" 	Observacion="prueba" /></root>'

*/
CREATE PROCEDURE [dbo].[INV_AJUSTEINDIVIDUAL_AJUSTAR]
	-- Add the parameters for the stored procedure here
--DECLARE
	 @ID_Org numeric(18, 0)
	,@ID_USRO_ACT NUMERIC(18, 0)		
	,@XML varchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

/*
	SET @ID_Org = 17
	SET @ID_USRO_ACT = 4
	SET @XML = '<root>
	<f Id="1" 
	PropietarioId="52" 
	Propietario="PROCTER &amp; GAMBLE CHILE LIMITADA" 
	DuenoId="756" 
	Dueno="FERNANDA BIJIT " 
	Sku="53265" 
	Descriptor="MUEBLE BODEGA FICTICIO AFEITADO Y DEPILACION SALCO BRAND" 
	LoteId="201710010320" 
	LoteProveedor="S/L" 
	FechaVencimiento="20/10/2018 0:00:00" 
	SubInventarioId="10" 
	SubInventario="SUBINVENTARIO F-22" 
	LocalizadorId="1714" 
	Localizador="DSC.0.1.D.2.022" 
	EnMano="2" 
	Disponible="2" 
	Reserva="0" 
	CantidadFisica="10" 
	SubInventarioFisicoId="10" 
	SubInventarioFisico="SUBINVENTARIO F-22" 
	LocalizadorFisicoId="3088" 
	LocalizadorFisico="DSC.0.1.O.2.001" 
	Diferencia="8" 
	Observacion="prueba" />
</root>'
*/

	--DECLARE @ID_LOCALIZADOR_STAGE NUMERIC(18, 0) = (SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 60)
	DECLARE @FECHA_TRANSACCION DATETIME = (SELECT GETDATE());	

	DECLARE @OXML XML;
	SET @OXML = N'''' + @XML + '''';
	
	--TABLA TEMPORAL DEL XML
	DECLARE @TABLAXML TABLE(
		Id numeric(18, 0)	,
		PropietarioId numeric(18, 0)	,
		DuenoId numeric(18, 0)	,
		Sku numeric(18, 0)	,
		LoteId varchar(50)	,
		SubInventarioId numeric(18, 0),
		SubInventario varchar(50),
		LocalizadorId numeric(18, 0),
		Localizador varchar(50),
		EnMano numeric(18, 0)	,
		Disponible numeric(18, 0)	,
		Reserva numeric(18, 0)	,
		CantidadFisica numeric(18, 0)	,
		SubInventarioFisicoId numeric(18, 0),
		SubInventarioFisico varchar(50),
		LocalizadorFisicoId numeric(18, 0),
		LocalizadorFisico varchar(50),
		Diferencia numeric(18, 0),
		Observacion varchar(250)	
	)
	
	
	INSERT INTO @TABLAXML
	SELECT
		Tbl.Col.value('@Id', 'numeric(18, 0)') Id,
		Tbl.Col.value('@PropietarioId', 'numeric(18, 0)') PropietarioId,
		Tbl.Col.value('@DuenoId', 'numeric(18, 0)') DuenoId,
		Tbl.Col.value('@Sku', 'numeric(18, 0)') Sku,
		Tbl.Col.value('@LoteId', 'varchar(50)') LoteId,
		Tbl.Col.value('@SubInventarioId', 'numeric(18, 0)') SubInventarioId,
		Tbl.Col.value('@SubInventario', 'varchar(50)') SubInventario,
		Tbl.Col.value('@LocalizadorId', 'numeric(18, 0)') LocalizadorId,
		Tbl.Col.value('@Localizador', 'varchar(50)') Localizador,
		Tbl.Col.value('@EnMano', 'numeric(18, 0)') EnMano,
		Tbl.Col.value('@Disponible', 'numeric(18, 0)') Disponible,
		Tbl.Col.value('@Reserva', 'numeric(18, 0)') Reserva,
		Tbl.Col.value('@CantidadFisica', 'numeric(18, 0)') CantidadFisica,
		Tbl.Col.value('@SubInventarioFisicoId', 'numeric(18, 0)') SubInventarioFisicoId,
		Tbl.Col.value('@SubInventarioFisico', 'varchar(50)') SubInventarioFisico,
		Tbl.Col.value('@LocalizadorFisicoId', 'numeric(18, 0)') LocalizadorFisicoId,
		Tbl.Col.value('@LocalizadorFisico', 'varchar(50)') LocalizadorFisico,
		Tbl.Col.value('@Diferencia', 'numeric(18, 0)') Diferencia,
		Tbl.Col.value('@Observacion', 'varchar(250)') Observacion
	FROM @OXML.nodes('//root/f') Tbl(Col)
	
	--SELECT * FROM Inventario_Detalle_Transacciones ORDER BY FECHA_TRX DESC
	--SELECT * FROM @TABLAXML
	
BEGIN TRAN
BEGIN TRY
	
	--select * from @TABLAXML
	
	DECLARE 
		@Id numeric(18, 0),
		@PropietarioId numeric(18, 0),
		@DuenoId numeric(18, 0),
		@Sku numeric(18, 0),
		@LoteId varchar(50),
		@SubInventarioId numeric(18, 0),
		@SubInventario varchar(50),
		@LocalizadorId numeric(18, 0),
		@Localizador varchar(50),
		@EnMano numeric(18, 0),
		@Disponible numeric(18, 0),
		@Reserva numeric(18, 0),
		@CantidadFisica numeric(18, 0),
		@SubInventarioFisicoId numeric(18, 0),
		@SubInventarioFisico varchar(50),
		@LocalizadorFisicoId numeric(18, 0),
		@LocalizadorFisico varchar(50),
		@Diferencia numeric(18, 0),
		@Observacion varchar(250)	
		
	DECLARE CLOTES CURSOR FOR
	SELECT * FROM @TABLAXML
	
	-- Apertura del cursor
	OPEN CLOTES

	-- Lectura de la primera fila del cursor
	FETCH CLOTES INTO	
		@Id	,
		@PropietarioId,
		@DuenoId,
		@Sku,
		@LoteId,
		@SubInventarioId,
		@SubInventario,
		@LocalizadorId,
		@Localizador,
		@EnMano,
		@Disponible,
		@Reserva,
		@CantidadFisica,
		@SubInventarioFisicoId,
		@SubInventarioFisico,
		@LocalizadorFisicoId,
		@LocalizadorFisico,
		@Diferencia,
		@Observacion
		
	WHILE (@@FETCH_STATUS = 0 ) BEGIN
			
		IF @Reserva = 0 BEGIN
			
			--Verifico si existe el localizador de destino en el inventario
			IF NOT EXISTS(SELECT * FROM Inventario_SubInv_Localizadores WHERE COMBINACION_LOCALIZADOR = @LocalizadorFisico) BEGIN
				ROLLBACK
				SELECT 0 CORRECTO, 'Al menos un localizador físico no existe en los subinventarios' MENSAJE
				RETURN
			END
			
			--SELECT * FROM Inventario_Detalle_Transacciones ORDER BY FECHA_TRX DESC
			IF (@LocalizadorId = @LocalizadorFisicoId) BEGIN
			
				--MOVIMIENTO ÚNICO
				INSERT INTO [dbo].[Inventario_Detalle_Transacciones]
				SELECT
					 NULL ID_TRX_PEDIDO
					,@FECHA_TRANSACCION
					,@Sku COD_ITEM
					,@ID_Org
					,@SubInventario subinventarioorigen
					,@Localizador localizadororigen
					,@SubInventarioFisico Cod_Subinv_Destino
					,@LocalizadorFisico Localizador_Destino
					,'AJUSTE INVENTARIO' + '~' + @Observacion Origen_TRX
					,0 Nro_Entrega
					,NULL Documento
					,NULL Razon_Social
					,@LoteId ID_Lote
					,@Diferencia Cantidad_TRX
					,UM.Unidad_Medida_Abreviada Unidad_Medida
					,@ID_USRO_ACT ID_Usuario
					,PRODUCTO.Precio_Compra
				FROM @TABLAXML T
					INNER JOIN INVENTARIO_LOTES LOTE
						ON T.LOTEID = LOTE.ID_LOTE AND LOTE.ID_ORG = @ID_Org 			
					INNER JOIN Inventario_Items PRODUCTO
						ON LOTE.COD_ITEM = PRODUCTO.COD_ITEM AND @ID_ORG = PRODUCTO.ID_ORG	
					INNER JOIN Inventario_Unidad_Medida_Primaria UM
						ON PRODUCTO.ID_UM = UM.ID_UM
				WHERE T.Id = @Id;			
			
			END
			ELSE BEGIN
				--MOVIMIENTO ORIGEN
				INSERT INTO [dbo].[Inventario_Detalle_Transacciones]
				SELECT
					 NULL ID_TRX_PEDIDO
					,@FECHA_TRANSACCION
					,@Sku COD_ITEM
					,@ID_Org
					,@SubInventario subinventarioorigen
					,@Localizador localizadororigen
					,@SubInventarioFisico Cod_Subinv_Destino
					,@LocalizadorFisico Localizador_Destino
					,'AJUSTE INVENTARIO' + '~' + @Observacion Origen_TRX
					,0 Nro_Entrega
					,NULL Documento
					,NULL Razon_Social
					,@LoteId ID_Lote
					,-@EnMano Cantidad_TRX
					,UM.Unidad_Medida_Abreviada Unidad_Medida
					,@ID_USRO_ACT ID_Usuario
					,PRODUCTO.Precio_Compra
				FROM @TABLAXML T
					INNER JOIN INVENTARIO_LOTES LOTE
						ON T.LOTEID = LOTE.ID_LOTE AND LOTE.ID_ORG = @ID_Org 			
					INNER JOIN Inventario_Items PRODUCTO
						ON LOTE.COD_ITEM = PRODUCTO.COD_ITEM AND @ID_ORG = PRODUCTO.ID_ORG	
					INNER JOIN Inventario_Unidad_Medida_Primaria UM
						ON PRODUCTO.ID_UM = UM.ID_UM
				WHERE T.Id = @Id;
				
				
				--MOVIMIENTO DESTINO
				INSERT INTO [dbo].[Inventario_Detalle_Transacciones]
				SELECT
					 NULL ID_TRX_PEDIDO
					,@FECHA_TRANSACCION
					,PRODUCTO.COD_ITEM
					,@ID_Org
					,'' subinventarioorigenid
					,'' localizadororigen
					,@SubInventarioFisico Cod_Subinv_Destino
					,@LocalizadorFisico Localizador_Destino
					,'AJUSTE INVENTARIO' + '~' + @Observacion Origen_TRX
					,0 Nro_Entrega
					,NULL Documento
					,NULL Razon_Social
					,@LoteId ID_Lote
					,@CantidadFisica Cantidad_TRX
					,UM.Unidad_Medida_Abreviada Unidad_Medida
					,@ID_USRO_ACT ID_Usuario
					,PRODUCTO.Precio_Compra
				FROM @TABLAXML T
					INNER JOIN INVENTARIO_LOTES LOTE
						ON T.LOTEID = LOTE.ID_LOTE AND LOTE.ID_ORG = @ID_Org 			
					INNER JOIN Inventario_Items PRODUCTO
						ON LOTE.COD_ITEM = PRODUCTO.COD_ITEM AND @ID_ORG = PRODUCTO.ID_ORG	
					INNER JOIN Inventario_Unidad_Medida_Primaria UM
						ON PRODUCTO.ID_UM = UM.ID_UM	
					WHERE T.Id = @Id;			
			END

	
			--ACTUALIZAR STOCK_LOTES
			--SELECT * FROM Inventario_Stock_Lotes
			
			IF EXISTS(SELECT * FROM Inventario_Stock_Lotes WHERE ID_LOCALIZADOR = @LocalizadorFisicoId AND ID_LOTE = @LoteId) BEGIN
				
				--ACTUALIZAR LOCALIZADOR Y LOTE ORIGEN 
				UPDATE Inventario_Stock_Lotes
					SET  EN_MANO = 0 
						,DISPONIBLE = 0  
						,ID_USRO_ACT = @ID_USRO_ACT
						,FECH_ACTUALIZA = @FECHA_TRANSACCION
				WHERE ID_LOCALIZADOR = @LocalizadorId AND ID_LOTE = @LoteId
				
				--ACTUALIZAR LOCALIZADOR Y LOTE DESTINO
				UPDATE Inventario_Stock_Lotes
					SET  EN_MANO = @EnMano + @Diferencia
						,DISPONIBLE = @Disponible + @Diferencia 
						,ID_USRO_ACT = @ID_USRO_ACT
						,FECH_ACTUALIZA = @FECHA_TRANSACCION							
				WHERE ID_LOCALIZADOR = @LocalizadorFisicoId AND ID_LOTE = @LoteId					
				
			END
			ELSE BEGIN
				
				DECLARE 
					@EN_MANO1 NUMERIC(18, 0) = 0,
					@DISPONIBLE1 NUMERIC(18, 0) = 0,
					@RESERVA1 NUMERIC(18, 0) = 0
				
				--OBTENCIÓN VALORES ANTERIORES
				SELECT 
					 @EN_MANO1 = EN_MANO
					,@DISPONIBLE1 = DISPONIBLE
					,@RESERVA1 = RESERVA
				FROM Inventario_Stock_Lotes
				WHERE ID_LOCALIZADOR = @LocalizadorId AND ID_LOTE = @LoteId	
				
				
				--ACTUALIZAR LOCALIZADOR Y LOTE ORIGEN 
				UPDATE Inventario_Stock_Lotes
					SET  EN_MANO = 0 
						,DISPONIBLE = 0  
						,ID_USRO_ACT = @ID_USRO_ACT
						,FECH_ACTUALIZA = @FECHA_TRANSACCION							
				WHERE ID_LOCALIZADOR = @LocalizadorId AND ID_LOTE = @LoteId					
				
				
				--INSERTAR LOCALIZADOR Y LOTE DESTINO
				INSERT INTO Inventario_Stock_Lotes
				(ID_LOTE
				,ID_LOCALIZADOR
				,ID_ORG
				,EN_MANO
				,DISPONIBLE
				,RESERVA
				,ID_USRO_CREA
				,FECH_CREACION
				)
				VALUES( 
					 @LoteId
					,@LocalizadorFisicoId
					,@ID_Org
					,@EN_MANO1 + @Diferencia
					,@DISPONIBLE1 + @Diferencia
					,@RESERVA1
					,@ID_USRO_ACT
					,@FECHA_TRANSACCION
				)				
				
			
			END
				
		END
		
		

		--Lectura siguientes líneas del cursor
		FETCH CLOTES INTO	
			@Id,	
			@PropietarioId,
			@DuenoId,
			@Sku,
			@LoteId,
			@SubInventarioId,
			@SubInventario,
			@LocalizadorId,
			@Localizador,
			@EnMano,
			@Disponible,
			@Reserva,
			@CantidadFisica,
			@SubInventarioFisicoId,
			@SubInventarioFisico,
			@LocalizadorFisicoId,
			@LocalizadorFisico,
			@Diferencia,
			@Observacion
	END	  
	  
	  
	-- Cierre del cursor
	CLOSE cLotes

	-- Liberar los recursos
	DEALLOCATE cLotes



	--SELECT @@TRANCOUNT--ROLLBACK


/*
SELECT * FROM Inventario_Detalle_Transacciones ORDER BY FECHA_TRX DESC

SELECT * FROM dbo.Inventario_Stock_Lotes WHERE ID_LOTE = '201707002207'

--UPDATE Inventario_Stock_Lotes SET EN_MANO = 8, DISPONIBLE = 8 WHERE ID_LOTE = '201707002207' AND ID_LOCALIZADOR = 2793

SELECT * FROM dbo.Inventario_Detalle_Trx_Pedidos WHERE NRO_ENTREGA = 4

SELECT * FROM dbo.Inventario_Detalle_Pedidos WHERE ID_NROPEDIDO = 14


-------------------------------------
SELECT * FROM Inventario_Folios_Todos
SELECT * FROM Inventario_Cabecera_Documentos --LA ACTUALIZO AL ÚLTIMO CUANDO GUARDE LA GUIA DE DESPACHO
SELECT * FROM Inventario_Detalle_Trx_Pedidos

*/




/*
SELECT 'SELECT * FROM ' + O.name TABLA, C.name COLUMNA, * 
FROM SYS.all_columns C
	INNER JOIN SYS.all_objects O
		ON C.object_id = O.object_id
WHERE C.name IN('Folio_Num_Entrega', 'Nro_Entrega')


SELECT * FROM SYS.all_objects
*/

	COMMIT TRANSACTION
	
	SELECT 1 CORRECTO, 'Lote(s) ajustado(s) exitosamente' MENSAJE
		
	
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
