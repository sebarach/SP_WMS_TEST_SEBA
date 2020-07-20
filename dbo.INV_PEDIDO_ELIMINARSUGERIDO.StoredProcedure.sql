USE [iwmscl_testwms2]
GO
/****** Object:  StoredProcedure [dbo].[INV_PEDIDO_ELIMINARSUGERIDO]    Script Date: 20-07-2020 11:56:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_PEDIDO_CAMBIARSUGERIDO 21, 53150, '201705000033', 2783, 0, '201705000033', 2783, 40, 4, 17
CREATE PROCEDURE [dbo].[INV_PEDIDO_ELIMINARSUGERIDO]
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
	
	--SET @ID_NROPEDIDO = 44
	--SET @COD_ITEM = 51175
	--SET @ID_LOTE_ACTUAL = '201707006671'
	--SET @ID_LOCALIZADOR_ACTUAL = 2583
	--SET @CANTIDAD_ACTUAL = 13
	--SET @ID_LOTE_NUEVO = ''
	--SET @ID_LOCALIZADOR_NUEVO = 0
	--SET @CANTIDAD_NUEVO = 0
	--SET @ID_USRO  = 4
	--SET @ID_ORG = 17
	--SET @NRO_LINEA = 1
	--SET @NRO_SUBLINEA = 2

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @FECHA_TRANSACCION DATETIME = (SELECT GETDATE());
	DECLARE @DISPONIBLE NUMERIC(18, 0) = 0;
	--SI LA CANTIDAD A PICKEAR ES MAYOR A LA DEL LOCALIZADOR NO PUEDE CAMBIAR
	
	--IF @ID_LOTE_ACTUAL = @ID_LOTE_NUEVO AND @ID_LOCALIZADOR_ACTUAL = @ID_LOCALIZADOR_NUEVO BEGIN
		
	--	SELECT @DISPONIBLE = (Disponible + @CANTIDAD_ACTUAL)--, (Reserva - @CANTIDAD_ACTUAL) Reserva
	--	FROM Inventario_Stock_Lotes
	--	WHERE ID_Lote = @ID_LOTE_ACTUAL 
	--		AND ID_Localizador = @ID_LOCALIZADOR_ACTUAL			
		
	--	IF (@DISPONIBLE < @CANTIDAD_NUEVO) BEGIN	
	--		SELECT 0 FILAS_AFECTADAS, 0 CORRECTO, 'No puede pickear más cantidad que la que existe en el localizador' MENSAJE
	--		RETURN 
	--	END	
	
	--END
	--ELSE BEGIN
	
	--	SELECT @DISPONIBLE = Disponible 			
	--	FROM Inventario_Stock_Lotes
	--	WHERE ID_Lote = @ID_LOTE_NUEVO 
	--		AND ID_Localizador = @ID_LOCALIZADOR_NUEVO;
		
	--	IF (@DISPONIBLE < @CANTIDAD_NUEVO) BEGIN	
	--		SELECT 0 FILAS_AFECTADAS, 0 CORRECTO, 'No puede pickear más cantidad que la que existe en el localizador' MENSAJE
	--		RETURN 
	--	END
	
	
	--END
	
	--DECLARE @CANTIDAD_TOTALPEDIDA NUMERIC(18, 0)
	--DECLARE @CANTIDAD_PICKEADA_TOTAL NUMERIC(18, 0)
	--DECLARE @CANTIDAD_PICKEADA NUMERIC(18, 0)
	
	--SELECT @CANTIDAD_TOTALPEDIDA = SUM(Cant_Pedida) 
	--FROM Inventario_Detalle_Trx_Pedidos
	--WHERE ID_NroPedido = @ID_NROPEDIDO
	
	
	--SELECT @CANTIDAD_PICKEADA_TOTAL = SUM(Cant_Pickeada)
	--FROM Inventario_Detalle_Trx_Pedidos
	--WHERE ID_NroPedido = @ID_NROPEDIDO
	--	AND ID_ORG = @ID_ORG 
	--	AND Cod_Item = @COD_ITEM
	
	--SELECT @CANTIDAD_PICKEADA = SUM(Cant_Pickeada)
	--FROM Inventario_Detalle_Trx_Pedidos
	--WHERE ID_NroPedido = @ID_NROPEDIDO
	--	AND ID_ORG = @ID_ORG 
	--	AND Cod_Item = @COD_ITEM
	--	AND NRO_LINEA = @NRO_LINEA
	--	AND NRO_SUBLINEA = @NRO_SUBLINEA
	--	AND ID_Lote = @ID_LOTE_ACTUAL --@ID_LOTE_NUEVO
	--	AND ID_Localizador_Origen = @ID_LOCALIZADOR_ACTUAL; --@ID_LOCALIZADOR_NUEVO;	
	
	--SET @CANTIDAD_PICKEADA_TOTAL = (@CANTIDAD_PICKEADA_TOTAL - @CANTIDAD_PICKEADA) + @CANTIDAD_NUEVO;
	
	
	--IF @CANTIDAD_TOTALPEDIDA < @CANTIDAD_PICKEADA_TOTAL  BEGIN	
	--	SELECT 0 FILAS_AFECTADAS, 0 CORRECTO, 'La cantidad a pickear no puede ser mayor que la cantidad pedida' MENSAJE
	--	RETURN	
	--END
	
	
BEGIN TRAN
BEGIN TRY
	
	--select * from Inventario_Detalle_Trx_Pedidos where ID_NROPEDIDO = 44
	
    --ACTUALIZAMOS LA CANTIDAD PICKEADA EN TABLA Inventario_Detalle_Trx_Pedidos
	UPDATE Inventario_Detalle_Trx_Pedidos
		SET --Cant_Pickeada = @CANTIDAD_NUEVO,
		--	ID_Lote = @ID_LOTE_NUEVO,
		--	ID_Localizador_Origen = @ID_LOCALIZADOR_NUEVO,
			cod_estado_linea = 100,
			Nomb_Sgte_Estado = 'Cancelada',
			ID_Usro_Act = @ID_USRO ,
			Fech_Actualiza = @FECHA_TRANSACCION
	WHERE ID_NroPedido = @ID_NROPEDIDO
		AND ID_ORG = @ID_ORG 
		AND Cod_Item = @COD_ITEM
		AND NRO_LINEA = @NRO_LINEA
		AND NRO_SUBLINEA = @NRO_SUBLINEA
		AND ID_Lote = @ID_LOTE_ACTUAL --@ID_LOTE_NUEVO
		AND ID_Localizador_Origen = @ID_LOCALIZADOR_ACTUAL; --@ID_LOCALIZADOR_NUEVO;
	
	
	--select * from Inventario_Pedido_Movimiento where ID_NROPEDIDO = 44
	--ACTUALIZAMOS LA CANTIDAD PICKEADA 
	UPDATE Inventario_Pedido_Movimiento
		SET --CANT_SUGERIDA = @CANTIDAD_NUEVO,
			--ID_Lote = @ID_LOTE_NUEVO,
			--ID_Localizador_Origen = @ID_LOCALIZADOR_NUEVO,					
			ID_Usro_Act = @ID_USRO,
			Fech_Actualiza = @FECHA_TRANSACCION,
			--CANCELAR_PED_MVTO = DBO.SI_VALOR_CERO(@CANTIDAD_NUEVO)
			cancelar_ped_mvto = 'SI',
			Pickeado = 'NO'
	WHERE ID_NroPedido = @ID_NROPEDIDO
		AND ID_ORG = @ID_ORG 
		AND COD_ITEM = @COD_ITEM
		AND ID_Lote = @ID_LOTE_ACTUAL --@ID_LOTE_NUEVO
		AND ID_Localizador_Origen = @ID_LOCALIZADOR_ACTUAL; --@ID_LOCALIZADOR_NUEVO;
	
	
	--ACTUALIZAMOS EL DISPONIBLE Y RESERVA ACTUALES	
	UPDATE Inventario_Stock_Lotes
		SET RESERVA = (RESERVA - @CANTIDAD_ACTUAL),
			DISPONIBLE = (DISPONIBLE + @CANTIDAD_ACTUAL),
			ID_USRO_ACT = @ID_USRO,
			FECH_ACTUALIZA = @FECHA_TRANSACCION
	WHERE ID_LOTE = @ID_LOTE_ACTUAL
		AND ID_LOCALIZADOR = @ID_LOCALIZADOR_ACTUAL;
			
	--SELECT * FROM dbo.Inventario_Stock_Lotes WHERE ID_LOTE IN ('201705000032', '201705000033')
	/*
	--ACTUALIZAMOS EL DISPONIBLE Y RESERVA NUEVOS
	UPDATE Inventario_Stock_Lotes
		SET RESERVA = (RESERVA + @CANTIDAD_NUEVO),
			DISPONIBLE = (DISPONIBLE - @CANTIDAD_NUEVO),
			ID_USRO_ACT = @ID_USRO,
			FECH_ACTUALIZA = @FECHA_TRANSACCION
	WHERE ID_LOTE = @ID_LOTE_NUEVO
		AND ID_LOCALIZADOR = @ID_LOCALIZADOR_NUEVO;
	*/
	
	--SELECT * FROM dbo.Inventario_Stock_Lotes WHERE ID_LOTE IN ('201705000032', '201705000033')
	
	--SELECT @@TRANCOUNT--ROLLBACK
	
	/*
	SELECT * FROM dbo.Inventario_Detalle_Trx_Pedidos WHERE ID_NROPEDIDO = 21
	SELECT * FROM dbo.Inventario_Pedido_Movimiento  WHERE ID_NROPEDIDO = 21
	SELECT * FROM dbo.Inventario_Stock_Lotes WHERE ID_LOTE IN ('201705000032', '201705000033')
	*/
	
	COMMIT TRAN
	
	SELECT 1 FILAS_AFECTADAS, 1 CORRECTO, 'Sugerido eliminado exitosamente' MENSAJE	
	
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
