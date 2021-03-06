USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_PEDIDO_AGREGARLOTE]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_PEDIDO_AGREGARLOTE 21, 53150, '201705000033', 2783, 0, '201705000033', 2783, 40, 4, 17
CREATE PROCEDURE [dbo].[INV_PEDIDO_AGREGARLOTE]
	-- Add the parameters for the stored procedure here
--DECLARE
	 @ID_NROPEDIDO NUMERIC(18, 0)
	,@COD_ITEM NUMERIC(18, 0)
	,@ID_LOTE_ACTUAL VARCHAR(50)
	,@ID_LOCALIZADOR_ACTUAL NUMERIC(18, 0)
	,@CANTIDAD_ACTUAL NUMERIC(18, 0)	
	,@ID_LOTE_NUEVO VARCHAR(50)	
	,@ID_LOCALIZADOR_NUEVO NUMERIC(18, 0)
	,@CANTIDAD_NUEVO NUMERIC(18, 0)
	,@ID_USRO NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
	,@NRO_LINEA NUMERIC(18, 0)
	,@NRO_SUBLINEA NUMERIC(18, 0)
AS
BEGIN
	
	--SET @ID_NROPEDIDO = 852
	--SET @COD_ITEM = 50577
	--SET @ID_LOTE_ACTUAL = '201707006460'
	--SET @ID_LOCALIZADOR_ACTUAL = 2296
	--SET @CANTIDAD_ACTUAL = 43
	--SET @ID_LOTE_NUEVO = '201707006460' --REPEATED
	--SET @ID_LOCALIZADOR_NUEVO = 2296 --REPEATED
	--SET @CANTIDAD_NUEVO = 43 --REPEATED
	--SET @ID_USRO  = 4
	--SET @ID_ORG = 17
	--SET @NRO_LINEA = 1
	--SET @NRO_SUBLINEA = 1

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @FECHA_TRANSACCION DATETIME = (SELECT GETDATE());
	DECLARE @DISPONIBLE NUMERIC(18, 0) = 0;
	--SI LA CANTIDAD A PICKEAR ES MAYOR A LA DEL LOCALIZADOR NO PUEDE CAMBIAR
	
	IF @ID_LOTE_ACTUAL = @ID_LOTE_NUEVO AND @ID_LOCALIZADOR_ACTUAL = @ID_LOCALIZADOR_NUEVO BEGIN
		
		SELECT @DISPONIBLE = (Disponible + @CANTIDAD_ACTUAL)--, (Reserva - @CANTIDAD_ACTUAL) Reserva
		FROM Inventario_Stock_Lotes
		WHERE ID_Lote = @ID_LOTE_ACTUAL 
			AND ID_Localizador = @ID_LOCALIZADOR_ACTUAL			
		
		IF (@DISPONIBLE < @CANTIDAD_NUEVO) BEGIN	
			SELECT 0 FILAS_AFECTADAS, 0 CORRECTO, 'No puede pickear más cantidad que la que existe en el localizador' MENSAJE
			RETURN 
		END	
	
	END
	ELSE BEGIN
	
		SELECT @DISPONIBLE = Disponible 			
		FROM Inventario_Stock_Lotes
		WHERE ID_Lote = @ID_LOTE_NUEVO 
			AND ID_Localizador = @ID_LOCALIZADOR_NUEVO;
		
		IF (@DISPONIBLE < @CANTIDAD_NUEVO) BEGIN	
			SELECT 0 FILAS_AFECTADAS, 0 CORRECTO, 'No puede pickear más cantidad que la que existe en el localizador' MENSAJE
			RETURN 
		END
	
	
	END
	
	DECLARE @CANTIDAD_TOTALPEDIDA NUMERIC(18, 0)
	DECLARE @CANTIDAD_PICKEADA_TOTAL NUMERIC(18, 0)
	DECLARE @CANTIDAD_PICKEADA NUMERIC(18, 0)
	
	SELECT @CANTIDAD_TOTALPEDIDA = SUM(Cant_Pedida) 
	FROM Inventario_Detalle_Trx_Pedidos
	WHERE ID_NroPedido = @ID_NROPEDIDO
		AND ID_ORG = @ID_ORG 		
		--AND cod_estado_linea <> 100
	
	
	SELECT @CANTIDAD_PICKEADA_TOTAL = SUM(Cant_Pickeada)
	FROM Inventario_Detalle_Trx_Pedidos
	WHERE ID_NroPedido = @ID_NROPEDIDO
		AND ID_ORG = @ID_ORG 				
		AND cod_estado_linea <> 100	
	
	SET @CANTIDAD_PICKEADA_TOTAL = @CANTIDAD_PICKEADA_TOTAL + @CANTIDAD_NUEVO;
	
	IF @CANTIDAD_TOTALPEDIDA < @CANTIDAD_PICKEADA_TOTAL  BEGIN	
		SELECT 0 FILAS_AFECTADAS, 0 CORRECTO, 'La cantidad a pickear no puede ser mayor que la cantidad pedida' MENSAJE
		RETURN	
	END
	
	
BEGIN TRAN
BEGIN TRY


    --Código para insertar nuevo lote en el pedido
	--INSERT EN LA TABLA Inventario_Detalle_Trx_Pedidos Y Inventario_Pedido_Movimiento --ID_PDO_MOVMTO
	--SELECT * FROM Inventario_Detalle_Trx_Pedidos		
	
	IF NOT EXISTS(SELECT * FROM Inventario_Detalle_Trx_Pedidos 
				  WHERE ID_NROPEDIDO = @ID_NROPEDIDO 
					AND COD_ITEM = @COD_ITEM
					AND ID_Lote = @ID_LOTE_NUEVO
					AND ID_Localizador_Origen = @ID_LOCALIZADOR_NUEVO) BEGIN
		
		
		--SELECT * FROM Inventario_Detalle_Trx_Pedidos
		INSERT INTO Inventario_Detalle_Trx_Pedidos
		SELECT @ID_NROPEDIDO ID_NroPedido
			  ,@COD_ITEM Cod_Item
			  ,@NRO_LINEA NroLinea
			  ,(SELECT MAX(Nro_SubLinea) + 1 FROM Inventario_Detalle_Trx_Pedidos WHERE ID_NROPEDIDO = @ID_NROPEDIDO) Nro_SubLinea
			  ,(SELECT DISTINCT ID_Pdo_Movmto FROM Inventario_Detalle_Trx_Pedidos WHERE ID_NROPEDIDO = @ID_NROPEDIDO) ID_Pdo_Movmto
			  ,0 Cant_Pedida
			  ,0 Cant_Pendiente
			  ,@CANTIDAD_NUEVO Cant_Pickeada 
			  ,0 Cant_Despacho
			  ,@ID_LOTE_NUEVO ID_Lote
			  ,@ID_LOCALIZADOR_NUEVO ID_Localizador_Origen						  
			  ,(SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 60) ID_Localizador_Destino --DESTINO STAGE
			  ,(SELECT DISTINCT ID_TRX_Pedido FROM Inventario_Detalle_Pedidos WHERE ID_NROPEDIDO = @ID_NROPEDIDO AND COD_ITEM = @COD_ITEM) _ID_TRX_Pedido
			  ,0 Nro_Entrega
			  ,10 Cod_Estado_Linea --(SELECT * FROM Inventario_Estado_Linea_Pedidos WHERE COD_ESTADO_LINEA = 10)
			  ,(SELECT NOMBRE_ESTADO_LINEA FROM Inventario_Estado_Linea_Pedidos WHERE COD_ESTADO_LINEA = 20) Nombre_Sgte_Estado
			  ,@FECHA_TRANSACCION Fech_Creacion
			  ,NULL Fech_Actualiza
			  ,@ID_USRO ID_Usro_Crea
			  ,NULL ID_Usro_Act
			  ,@ID_Org ID_Org    		
		
		--SELECT * FROM Inventario_Pedido_Movimiento
		INSERT INTO Inventario_Pedido_Movimiento
		SELECT --ID_SEC
			   @ID_NROPEDIDO ID_NroPedido
			  ,(SELECT DISTINCT ID_Pdo_Movmto FROM Inventario_Detalle_Trx_Pedidos WHERE ID_NROPEDIDO = @ID_NROPEDIDO) ID_Pdo_Movmto
			  ,@COD_ITEM Cod_Item
			  ,0 Cant_Pedida
			  ,@CANTIDAD_NUEVO Cant_Sugerida
			  ,@ID_LOTE_NUEVO ID_Lote
			  ,@ID_LOCALIZADOR_NUEVO ID_Localizador_Origen
			  ,(SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 60) ID_Localizador_Destino --DESTINO STAGE
			  ,@FECHA_TRANSACCION Fech_Creacion
			  ,NULL Fech_Actualiza
			  ,@ID_USRO ID_Usro_Crea
			  ,NULL ID_Usro_Act
			  ,@ID_Org ID_Org
			  ,'NO' Cancelar_Ped_Mvto
			  ,'NO' Pickeado	
			  
		--SELECT * FROM dbo.Inventario_Stock_Lotes WHERE ID_LOTE = 201705000033
		UPDATE Inventario_Stock_Lotes
			SET DISPONIBLE = (DISPONIBLE - @CANTIDAD_NUEVO),
				RESERVA = (RESERVA + @CANTIDAD_NUEVO)
		WHERE ID_LOCALIZADOR = @ID_LOCALIZADOR_NUEVO
			AND ID_LOTE = @ID_LOTE_NUEVO;	
			
		--COMMIT TRAN
		
    END 
    ELSE BEGIN
    	
		SELECT 0 FILAS_AFECTADAS, 0 CORRECTO, 'El lote ya se encuentra agregado al pedido' MENSAJE
    
    END 
    
    
    
    
    
    
    
    
    
    
    
    
	
	
	--SELECT * FROM dbo.Inventario_Stock_Lotes WHERE ID_LOTE IN ('201705000032', '201705000033')
	
	--SELECT @@TRANCOUNT--ROLLBACK
	
	/*
	SELECT * FROM dbo.Inventario_Detalle_Trx_Pedidos WHERE ID_NROPEDIDO = 21
	SELECT * FROM dbo.Inventario_Pedido_Movimiento  WHERE ID_NROPEDIDO = 21
	SELECT * FROM dbo.Inventario_Stock_Lotes WHERE ID_LOTE IN ('201705000032', '201705000033')
	*/
	
	COMMIT TRAN
	
	SELECT 1 FILAS_AFECTADAS, 1 CORRECTO, '' MENSAJE	
	
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
