USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_PEDIDO_REGISTRAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_PEDIDO_REGISTRAR]
	-- Add the parameters for the stored procedure here
	 @ID_NroPedido numeric(18, 0)
	,@Folio_Documento numeric(18, 0)
	,@Fecha_Emision datetime
	,@Fecha_Entrega datetime
	,@ID_Org numeric(18, 0)
	,@ID_Usro_Crea numeric(18, 0)
	,@ID_Usro_Act numeric(18, 0)
	,@Estado varchar(50)
	,@Vigencia varchar(1)
	,@XML varchar(MAX)
	,@ACCION VARCHAR(1)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @FECHA_TRANSACCION DATETIME = (SELECT GETDATE());	
	DECLARE @AGREGO INT = 0;
	
	--Carga de productos en detalle de documentos
	DECLARE @oxml XML;	
	SET @oxml = N'''' + @XML + '''';

	DECLARE @MENSAJE VARCHAR(MAX);
	
	IF @ACCION = 'n' BEGIN
		
		--IF EXISTS
		--rollback;
		
		--(SELECT COUNT(*) FROM Inventario_Pedido_Movimiento)
		
		--VERIFICA SI EL PEDIDO ESTA LANZADO
		--IF (SELECT COUNT(*) FROM Inventario_Pedido_Movimiento where ID_NroPedido = @ID_NroPedido AND ID_Org = @Id_Org) = 
		--	(SELECT COUNT(*) FROM Inventario_Pedido_Movimiento where ID_NroPedido = @ID_NroPedido AND Pickeado = 'NO' AND ID_Org = @Id_Org)
		-- BEGIN
			
		--	SET @MENSAJE = 'El pedido se encuentra registrado y lanzado, ahora debe confirmarlo. Luego podrá crear un nuevo pedido'
		--	SELECT 1 ID, 'PEDIDO_REGISTRADO' ESTADO_PEDIDO, 1 CORRECTO, @MENSAJE MENSAJE; --@@ROWCOUNT 
		--	RETURN;
		--END		

		----VERIFICA SI EL PEDIDO SE ENCUENTRA REGISTRADO
		--IF EXISTS(SELECT * FROM Inventario_Detalle_Pedidos 
		--			where ID_NroPedido = @ID_NroPedido
		--			and ID_Org = @Id_Org) BEGIN
			
		--	SET @MENSAJE = 'El pedido se encuentra registrado, ahora debe lanzarlo'
		--	SELECT 0 ID, 'PEDIDO_REGISTRADO' ESTADO_PEDIDO, 1 CORRECTO, @MENSAJE MENSAJE; --@@ROWCOUNT 
		--	RETURN;
		--END
		
		IF (SELECT ISNULL(SUM(Cant_Pendiente), 0)
			FROM INVENTARIO_DETALLE_TRX_PEDIDOS
			WHERE ID_NROPEDIDO = @ID_NroPedido AND Id_Org = @Id_Org
				AND Cod_Estado_Linea = 90) = 0 BEGIN
			
			SET @MENSAJE = 'El pedido actual no registra pendientes para generar un nuevo pedido'
			SELECT 0 ID, 'PEDIDO_REGISTRADO' ESTADO_PEDIDO, 1 CORRECTO, @MENSAJE MENSAJE; --@@ROWCOUNT 
			RETURN;			
		
		END
		
		SET @ACCION = 'r';
		set @ID_NroPedido = 0;
		
	END	
	
BEGIN TRAN
BEGIN TRY

	DECLARE @ULTIMOFOLIO NUMERIC(18, 0) = (SELECT MAX(ID_TRX_Pedido) FROM Inventario_Folios_Todos);
	DECLARE @NUEVOFOLIO NUMERIC(18, 0);
		
	IF @ACCION = 'r' BEGIN
	
		IF NOT EXISTS(SELECT ID_NroPedido FROM Inventario_Cabecera_Pedidos 
					  WHERE Folio_Documento = @Folio_Documento AND Id_Org = @Id_Org AND ID_NROPEDIDO = @ID_NroPedido) BEGIN	
		
			PRINT 'REGISTRA PEDIDO'
			DECLARE @RETORNO TABLE(ID NUMERIC(18, 0));
			
			INSERT INTO dbo.Inventario_Cabecera_Pedidos
				   (Folio_Documento
				   ,Fecha_Emision
				   ,Fecha_Entrega
				   ,ID_Org
				   ,Fech_Creacion
				   ,ID_Usro_Crea
				   ,Estado
				   ,Vigencia)
				   OUTPUT INSERTED.ID_NROPEDIDO 
				   INTO @RETORNO(ID)				   
			 VALUES
				   ( @Folio_Documento
					,@Fecha_Emision
					,@Fecha_Entrega
					,@ID_Org
					,@FECHA_TRANSACCION
					,@ID_Usro_Crea
					,'ABIERTO'
					,'S')

			----¿CAMBIA DE ESTADO LA SOLICITUD DE DESPACHO?
			--UPDATE Inventario_Cabecera_Documentos
			--SET ID_ESTADO = 170
			--WHERE Folio_Documento = @Folio_Documento AND ID_DOCU = 20 AND ID_ORG = @ID_Org;
			
			PRINT 'OBTUVO ULTIMO FOLIO: ' + CAST(@ULTIMOFOLIO AS VARCHAR(30));
			--PARA ASEGURARNOS QUE LA TABLA QUEDÓ TOMADA Y QUE NO OBTENGAN IDS YA CONSULTADOS Y USADOS
			UPDATE Inventario_Folios_Todos
			SET ID_TRX_PEDIDO = @ULTIMOFOLIO
			WHERE ID_TRX_PEDIDO = @ULTIMOFOLIO;		
			PRINT 'ACTUALIZÓ LA TABLA Inventario_Folios_Todos para dejarla tomada';				
			
			
			--OBTENER EL MAXIMO FOLIO QUE SE ALCANZÓ A REGISTRAR
			SET @NUEVOFOLIO = (SELECT MAX(TRANSACCIONADOS) + 1 FROM
			(SELECT 	
				 (SELECT ID FROM @RETORNO) ID_NROPEDIDO
				,TBL.Col.value('@pid', 'numeric(18, 0)') PRODUCTO_ID
				,TBL.Col.value('@id', 'numeric(18, 0)') LINEA
				,TBL.Col.value('@cp', 'numeric(18, 3)') CANTIDAD_PEDIDA
				,TBL.Col.value('@cpend', 'numeric(18, 3)') CANTIDAD_PENDIENTE
				,TBL.Col.value('@cpick', 'numeric(18, 3)') CANTIDAD_PICKEADA					
				,TBL.Col.value('@cd', 'numeric(18, 3)') CANTIDAD_DESPACHO
				,CASE
					WHEN DETALLE.ID_TRX_Pedido IS NULL THEN @ULTIMOFOLIO + ROW_NUMBER() OVER(ORDER BY DETALLE.ID_TRX_Pedido ASC) - 1 --,TRANSACCION --MENOS UNO YA QUE SE AGREGA UNO AL NUEVO FOLIO AL FINAL DEL EJERCICIO
					WHEN DETALLE.ID_TRX_Pedido IS NOT NULL THEN DETALLE.ID_TRX_Pedido
				END TRANSACCIONADOS
				,@FECHA_TRANSACCION FECH_CREACION
				,NULL FECH_ACTUALIZA
				,@ID_Usro_Crea ID_USRO_CREA
				,NULL ID_USRO_ACT
				,@Id_Org ID_ORG		
			FROM @oxml.nodes('//root/f') Tbl(Col)  
				LEFT JOIN Inventario_Detalle_Pedidos DETALLE
					ON Tbl.Col.value('@pid', 'numeric(18, 0)') = DETALLE.COD_ITEM
						AND DETALLE.ID_NROPEDIDO = (SELECT ID FROM @RETORNO)
				WHERE DETALLE.ID_TRX_PEDIDO IS NULL) TABLA_TRANSACCIONADOS);			
			
			
			
			INSERT INTO [dbo].Inventario_Detalle_Pedidos
			SELECT 	
				 (SELECT ID FROM @RETORNO)
				,TBL.Col.value('@pid', 'numeric(18, 0)') PRODUCTO_ID
				,TBL.Col.value('@id', 'numeric(18, 0)') LINEA
				,TBL.Col.value('@cp', 'numeric(18, 3)') CANTIDAD_PEDIDA
				,TBL.Col.value('@cpend', 'numeric(18, 3)') CANTIDAD_PENDIENTE
				,TBL.Col.value('@cpick', 'numeric(18, 3)') CANTIDAD_PICKEADA					
				,TBL.Col.value('@cd', 'numeric(18, 3)') CANTIDAD_DESPACHO
				,CASE
					WHEN DETALLE.ID_TRX_Pedido IS NULL THEN @ULTIMOFOLIO + ROW_NUMBER() OVER(ORDER BY DETALLE.ID_TRX_Pedido ASC) - 1 --,TRANSACCION --MENOS UNO YA QUE SE AGREGA UNO AL NUEVO FOLIO AL FINAL DEL EJERCICIO
					WHEN DETALLE.ID_TRX_Pedido IS NOT NULL THEN DETALLE.ID_TRX_Pedido
				END ID_TRX_PEDIDO
				,@FECHA_TRANSACCION
				,NULL
				,@ID_Usro_Crea
				,NULL
				,@Id_Org
			FROM @oxml.nodes('//root/f') Tbl(Col)  
				LEFT JOIN Inventario_Detalle_Pedidos DETALLE
					ON Tbl.Col.value('@pid', 'numeric(18, 0)') = DETALLE.COD_ITEM
						AND DETALLE.ID_NROPEDIDO = (SELECT ID FROM @RETORNO);	
						
			PRINT 'INSERTO A LA TABLA Inventario_Detalle_Pedidos';			
					
			--SELECT * FROM dbo.Inventario_Detalle_Pedidos						
			
			--ACTUALIZAMOS FINALMENTE LA TABLA DE FOLIOS
			IF (@NUEVOFOLIO IS NULL) BEGIN
				SET @NUEVOFOLIO = @ULTIMOFOLIO
			END 			
			
			UPDATE Inventario_Folios_Todos
			SET ID_TRX_PEDIDO = @NUEVOFOLIO
			WHERE ID_TRX_PEDIDO = @ULTIMOFOLIO;	
			
			PRINT 'NUEVO FOLIO:' + CAST(@NUEVOFOLIO AS VARCHAR(15))
			
			SET @AGREGO	= 1;
			COMMIT TRANSACTION
			SELECT ID, 'ABIERTO' ESTADO_PEDIDO, 1 CORRECTO, 'Pedido registrado con exito' MENSAJE FROM @RETORNO;		
			--SELECT @@TRANCOUNT --ROLLBACK			
			/*
			SELECT * FROM dbo.Inventario_Cabecera_Pedidos
			SELECT * FROM dbo.Inventario_Detalle_Pedidos						
			SELECT * FROM dbo.Inventario_Folios_Todos			
			*/
			
		END 
		
	END		
	
	
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
