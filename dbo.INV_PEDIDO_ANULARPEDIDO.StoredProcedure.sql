USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_PEDIDO_ANULARPEDIDO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_PEDIDO_ANULARPEDIDO 21, 17, 4, 4
CREATE PROCEDURE [dbo].[INV_PEDIDO_ANULARPEDIDO]
	-- Add the parameters for the stored procedure here
--DECLARE
	 @ID_NROPEDIDO numeric(18, 0)	 
	,@ID_Org numeric(18, 0)
	,@ID_USRO_CREA NUMERIC(18, 0)	
	,@ID_USRO_ACT NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	--SET @ID_NROPEDIDO = 21
	--SET @ID_Org = 17
	--SET @ID_USRO_CREA = 4
	--SET @ID_USRO_ACT = 4
	
	DECLARE @FECHA_TRANSACCION DATETIME = (SELECT GETDATE());
	DECLARE @NROFOLIO numeric(18,0)
		
	IF NOT EXISTS(SELECT ID_PDO_MOVMTO, ID_LOTE, CANT_SUGERIDA, ID_LOCALIZADOR_ORIGEN 
				  FROM dbo.Inventario_Pedido_Movimiento WHERE ID_NROPEDIDO = @ID_NROPEDIDO) BEGIN
		
		SELECT 1 FILAS_AFECTADAS, 0 CORRECTO, 'El pedido no se puede anular porque no se encuentra registrado y lanzado'+ CHAR(13) + CHAR(10) +'(Debe anular la Solicitud)' MENSAJE		
		RETURN	
	END
	
	IF EXISTS(SELECT * FROM dbo.Inventario_Detalle_Trx_Pedidos
			  WHERE ID_NROPEDIDO = @ID_NROPEDIDO AND COD_ESTADO_LINEA in (20,30)) BEGIN
		
		SELECT 1 FILAS_AFECTADAS, 0 CORRECTO, 'El pedido no se puede anular porque al menos un producto ha sido pickeado' MENSAJE		
		RETURN	
	END	
	
	
	
BEGIN TRAN
BEGIN TRY	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE 
		 --@ID_NROPEDIDO NUMERIC(18, 0)
		 @ID_PDO_MOVMTO NUMERIC(18, 0)
		,@ID_LOTE VARCHAR(50)
		,@CANT_SUGERIDA NUMERIC(18, 3)
		,@ID_LOCALIZADOR_ORIGEN NUMERIC(18, 0)
		
	DECLARE CMOVIMIENTO CURSOR FOR
	SELECT 
		 ID_PDO_MOVMTO 
		,ID_LOTE 
		,CANT_SUGERIDA 
		,ID_LOCALIZADOR_ORIGEN 
	FROM dbo.Inventario_Pedido_Movimiento 
	WHERE ID_NROPEDIDO = @ID_NROPEDIDO
	
	
	OPEN CMOVIMIENTO
	
	FETCH CMOVIMIENTO INTO 
		 @ID_PDO_MOVMTO 
		,@ID_LOTE 
		,@CANT_SUGERIDA 
		,@ID_LOCALIZADOR_ORIGEN 
	
	
	WHILE (@@FETCH_STATUS = 0) BEGIN
		
		--VOLVER LAS CANTIDADES A COMO ESTABAN
		UPDATE Inventario_Stock_Lotes
			SET Reserva = (Reserva - @CANT_SUGERIDA),
				Disponible = (Disponible + @CANT_SUGERIDA),
				ID_Usro_Act = @ID_USRO_ACT,
				Fech_Actualiza = @FECHA_TRANSACCION
		WHERE ID_Lote = @ID_LOTE
			AND ID_Localizador = @ID_LOCALIZADOR_ORIGEN
		
		
		--ACTUALIZACIÓN DE LOS FLAGS
		UPDATE Inventario_Pedido_Movimiento
			SET CANCELAR_PED_MVTO = 'SI',
				ID_USRO_ACT = @ID_USRO_ACT,
				FECH_ACTUALIZA = @FECHA_TRANSACCION
		WHERE ID_PDO_MOVMTO = @ID_PDO_MOVMTO
			AND ID_NROPEDIDO = @ID_NROPEDIDO
			AND ID_LOTE = @ID_LOTE
			AND CANT_SUGERIDA = @CANT_SUGERIDA
			AND ID_LOCALIZADOR_ORIGEN = @ID_LOCALIZADOR_ORIGEN

	
		FETCH CMOVIMIENTO INTO 
			 @ID_PDO_MOVMTO 
			,@ID_LOTE 
			,@CANT_SUGERIDA 
			,@ID_LOCALIZADOR_ORIGEN 	
	
	END
	
	CLOSE CMOVIMIENTO
	
	DEALLOCATE CMOVIMIENTO
	
	
	--Actualziación de la vigencia a N
	--UPDATE Inventario_Cabecera_Documentos 	
	--	SET VIGENCIA = 'N',
--			ID_ESTADO = 90
--	WHERE FOLIO_DOCUMENTO = (SELECT FOLIO_DOCUMENTO FROM Inventario_Cabecera_Pedidos WHERE ID_NROPEDIDO = @ID_NROPEDIDO)
	
	
	--ACTUALIZACIÓN DEL ESTADO ABIERTO A ANULADO
	UPDATE Inventario_Cabecera_Pedidos
		SET ESTADO = 'ANULADO',
		ID_USRO_ACT = @ID_USRO_ACT,
		FECH_ACTUALIZA = @FECHA_TRANSACCION
	WHERE ID_NROPEDIDO = @ID_NROPEDIDO

	--seba 26-02
	set @NROFOLIO =(select folio_documento from Inventario_Cabecera_Pedidos where ID_NroPedido =@ID_NROPEDIDO)
	update Inventario_Cabecera_Documentos
	set ID_ESTADO = 130
	where Folio_Documento = @NROFOLIO
	--seba 26-02
	
	/*
	
	SELECT * FROM dbo.Inventario_Cabecera_Pedidos  
	
	SELECT * FROM Inventario_Pedido_Movimiento
	
	SELECT * FROM Inventario_Stock_Lotes
	WHERE ID_LOTE IN('201705000033',
					 '201705000032')
	
	*/
	
	--SELECT @@TRANCOUNT --ROLLBACK	
	
	COMMIT TRAN
	
	SELECT 1 FILAS_AFECTADAS, 1 CORRECTO, 'El pedido se ha anulado exitosamente' MENSAJE
	
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
