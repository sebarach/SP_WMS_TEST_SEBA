USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_SOLICITUD_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_SOLICITUD_INGRESO]
	-- Add the parameters for the stored procedure here	
	 @Folio_Documento numeric(18, 0)
	,@Id_Docu numeric(18, 0)
	,@Id_Org numeric(18, 0)
	,@Id_Propietario numeric(18, 0)
	,@Id_Dueño numeric(18, 0)
	,@Id_Direccion numeric(18)
	,@Orden_Compra_Cte varchar(50)
	--,@Orden_Trabajo varchar(50)
	,@Id_Proveedor numeric(18, 0)
	,@Fecha_Entrega datetime
	,@Fecha_Vencimiento datetime
	--,@Nro_Entrega numeric(18, 0)
	--,@Solicitud_Maquila numeric(18, 0)
	,@Nota varchar(MAX)
	,@ID_Usro_Crea numeric(18, 0)
	,@ID_Usro_Act numeric(18, 0)
	,@Vigencia varchar(1)
	,@id_estado numeric(18, 0)
	,@NOMBRE_DESTINATARIO VARCHAR(MAX)
	,@RUT_DESTINATARIO VARCHAR(12)
	,@ID_CLISUC	NUMERIC(18, 0)
	,@XML varchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	--Carga de productos en detalle de documentos
	DECLARE @oxml XML;
	declare @nro_pedido numeric(18,0);

	SET @oxml = N'''' + @XML + '''';	

    -- Insert statements for procedure here
    IF NOT EXISTS(SELECT Folio_Documento FROM Inventario_Cabecera_Documentos WHERE Folio_Documento = @Folio_Documento AND Id_Org = @Id_Org AND Id_Docu = @Id_Docu) BEGIN
    
		DECLARE @NUEVO_FOLIO NUMERIC(18, 0) = (SELECT MAX(Ultimo_Folio) + 1 NUEVO_FOLIO
												FROM dbo.Inventario_Tipo_Documentos
												WHERE Id_Docu = @Id_Docu);
    
		DECLARE @FECHA_INSERT DATETIME = (SELECT GETDATE());
    
		INSERT INTO [dbo].[Inventario_Cabecera_Documentos]
			   ([Folio_Documento]
			   ,[Id_Docu]
			   ,[Id_Org]
			   ,[Id_Propietario]
			   ,[Id_Dueño]
			   ,[Id_Direccion]
			   ,[Orden_Compra_Cte]
			   ,[Id_Proveedor]
			   ,[Fecha_Solicitud]
			   ,[Fecha_Entrega]
			   ,[Fecha_Vencimiento]
			   ,[Nota]
			   ,[Fech_Creacion]
			   ,[ID_Usro_Crea]
			   ,[Vigencia]
			   ,id_estado
			   ,NOMBRE_DESTINATARIO
			   ,RUT_DESTINATARIO
			   ,ID_CLISUC)		   
		 VALUES
			   (@NUEVO_FOLIO
			   ,@Id_Docu
			   ,@Id_Org
			   ,@Id_Propietario
			   ,@Id_Dueño
			   ,@Id_Direccion
			   ,@Orden_Compra_Cte
			   ,@Id_Proveedor
			   ,@FECHA_INSERT
			   ,@Fecha_Entrega
			   ,@Fecha_Vencimiento
			   ,@Nota
			   ,@FECHA_INSERT
			   ,@ID_Usro_Crea
			   ,@Vigencia
			   ,@id_estado
				,@NOMBRE_DESTINATARIO
				,@RUT_DESTINATARIO
				,@ID_CLISUC);		

		UPDATE [dbo].[Inventario_Tipo_Documentos]
		   SET Ultimo_Folio = @NUEVO_FOLIO
		 WHERE Id_Docu = @Id_Docu;
		
		
		
		INSERT INTO INVENTARIO_OBSERVACIONES_SOLICITUDES
				([Folio_Documento]
				,[Id_Docu]
				,[Id_Org]
				,[Fech_Transaccion]
				,[Nota]
				,[ID_Usro])
		VALUES
				(@NUEVO_FOLIO
				,@Id_Docu
				,@Id_Org
				,@FECHA_INSERT
				,@Nota
				,@ID_Usro_Crea);				
		
		INSERT INTO [dbo].[Inventario_Detalle_Documentos]
		SELECT 	
			 @NUEVO_FOLIO
			,@Id_Docu
			,Tbl.Col.value('@id', 'numeric(18, 0)') --nro linea
			,Tbl.Col.value('@d', 'varchar(max)') --descriptor
			,Tbl.Col.value('@pid', 'numeric(18, 0)') --Código producto
			,Tbl.Col.value('@c', 'numeric(18, 0)') --cantidad
			,Tbl.Col.value('@c', 'numeric(18, 0)') --cantidad pendiente
			,Tbl.Col.value('@p', 'numeric(18, 0)') --precio
			,@Id_Org
			,NULL --,Tbl.Col.value('@l', 'varchar(50)') --lote
		FROM @oxml.nodes('//root/f') Tbl(Col);
		
		SELECT @NUEVO_FOLIO ID, 100 ESTADO_ID, (SELECT ESTADO FROM Inventario_Estado_Documentos WHERE ID_ESTADO = 100) ESTADO;
				
	END

	ELSE BEGIN

	--seba
	IF  EXISTS(select id_nropedido from Inventario_Cabecera_Pedidos where folio_documento = @Folio_Documento and ID_NroPedido> 8000) BEGIN
		--SELECT 1 FILAS_AFECTADAS, 0 CORRECTO, 'El pedido no se puede anular porque se encuentra registrado y lanzado' MENSAJE		
		SELECT @@ROWCOUNT FILAS_AFECTADAS;
		RETURN	
	END
	--seba
	
		DECLARE @FECHA_UPDATE DATETIME = (SELECT GETDATE());
	
		IF @Vigencia <> 'N' BEGIN
			
			IF @id_estado = 0 OR 
			   @id_estado = 100 OR 
			   @id_estado = 130 OR --ANULADO
			   @id_estado = 150 OR
			   @id_estado = 210 OR --ANULADO 
			   @id_estado = 230 OR 
			   @id_estado IS NULL BEGIN
			
				UPDATE [dbo].[Inventario_Cabecera_Documentos]
				SET 
					 Folio_Documento = @Folio_Documento
					,Id_Docu = @Id_Docu
					,Id_Org = @Id_Org
					,Id_Propietario = @Id_Propietario
					,Id_Dueño = @Id_Dueño
					,Id_Direccion = @Id_Direccion
					,Orden_Compra_Cte = @Orden_Compra_Cte
					,Id_Proveedor = @Id_Proveedor
					,Fecha_Entrega = @Fecha_Entrega
					,Fecha_Vencimiento = @Fecha_Vencimiento
					,Nota = @Nota
					,Fech_Actualiza = @FECHA_UPDATE
					,ID_Usro_Act = @ID_Usro_Act
					--,Vigencia = @Vigencia
					,id_estado = @id_estado
					,NOMBRE_DESTINATARIO = @NOMBRE_DESTINATARIO
					,RUT_DESTINATARIO = @RUT_DESTINATARIO
					,ID_CLISUC = @ID_CLISUC					
				WHERE Folio_Documento = @Folio_Documento AND Id_Org = @Id_Org AND Id_Docu = @Id_Docu;
				
				IF NOT EXISTS(SELECT Nota FROM INVENTARIO_OBSERVACIONES_SOLICITUDES WHERE Nota = @Nota AND Folio_Documento = Folio_Documento AND Id_Docu = @Id_Docu AND Id_Org = @Id_Org) BEGIN
					INSERT INTO INVENTARIO_OBSERVACIONES_SOLICITUDES
							([Folio_Documento]
							,[Id_Docu]
							,[Id_Org]
							,[Fech_Transaccion]
							,[Nota]
							,[ID_Usro])
					VALUES
							(@Folio_Documento
							,@Id_Docu
							,@Id_Org
							,@FECHA_UPDATE
							,@Nota
							,@ID_Usro_Act);			
				END
				
				
				DELETE FROM [dbo].[Inventario_Detalle_Documentos] WHERE Folio_Documento = @Folio_Documento and Id_Docu = @Id_Docu and ID_Org = @Id_Org
				INSERT INTO [dbo].[Inventario_Detalle_Documentos]
				SELECT 	
					 @Folio_Documento
					,@Id_Docu
					,Tbl.Col.value('@id', 'numeric(18, 0)') --nro linea
					,Tbl.Col.value('@d', 'varchar(max)') --descriptor
					,Tbl.Col.value('@pid', 'numeric(18, 0)') --Código producto
					,Tbl.Col.value('@c', 'numeric(18, 0)') --cantidad
					,Tbl.Col.value('@c', 'numeric(18, 0)') --cantidad pendiente
					,Tbl.Col.value('@p', 'numeric(18, 0)') --precio
					,@Id_Org
					,NULL --,Tbl.Col.value('@l', 'varchar(50)') --lote
				FROM @oxml.nodes('//root/f') Tbl(Col);
				
				--SELECT @NUEVO_FOLIO ID;		
			
			
				SELECT @@ROWCOUNT FILAS_AFECTADAS;

			END 
			
			ELSE BEGIN

				UPDATE [dbo].[Inventario_Cabecera_Documentos]
				SET 
					-- Folio_Documento = @Folio_Documento
					--,Id_Docu = @Id_Docu
					--,Id_Org = @Id_Org
					--,Id_Propietario = @Id_Propietario
					--,Id_Dueño = @Id_Dueño
					--,Id_Direccion = @Id_Direccion
					--,Orden_Compra_Cte = @Orden_Compra_Cte
					--,Id_Proveedor = @Id_Proveedor
					--,Fecha_Entrega = @Fecha_Entrega
					--,Fecha_Vencimiento = @Fecha_Vencimiento
					--,
					 Nota = @Nota
					,Fech_Actualiza = @FECHA_UPDATE
					,ID_Usro_Act = @ID_Usro_Act
					--,Vigencia = @Vigencia
					--seba
					--,id_estado = @id_estado
					--,ID_ESTADO = 130
				WHERE Folio_Documento = @Folio_Documento AND Id_Org = @Id_Org AND Id_Docu = @Id_Docu;
				
				IF NOT EXISTS(SELECT Nota FROM INVENTARIO_OBSERVACIONES_SOLICITUDES WHERE Nota = @Nota AND Folio_Documento = Folio_Documento AND Id_Docu = @Id_Docu AND Id_Org = @Id_Org) BEGIN
					INSERT INTO INVENTARIO_OBSERVACIONES_SOLICITUDES
							([Folio_Documento]
							,[Id_Docu]
							,[Id_Org]
							,[Fech_Transaccion]
							,[Nota]
							,[ID_Usro])
					VALUES
							(@Folio_Documento
							,@Id_Docu
							,@Id_Org
							,@FECHA_UPDATE
							,@Nota
							,@ID_Usro_Act);			
				END			
				
				SELECT @@ROWCOUNT FILAS_AFECTADAS;
			END
			
			
			
		END ELSE BEGIN
		
			UPDATE [dbo].[Inventario_Cabecera_Documentos]
			SET 
				 Fech_Actualiza = @FECHA_UPDATE
				,ID_Usro_Act = @ID_Usro_Act
				,Vigencia = @Vigencia,
				--seba
				ID_ESTADO = 130
			WHERE Folio_Documento = @Folio_Documento AND Id_Org = @Id_Org AND Id_Docu = @Id_Docu;
			
			SELECT @@ROWCOUNT FILAS_AFECTADAS;				
		
		END
	
	
	END

	/*	
	SELECT * FROM Inventario_Items_Prop_Dueños
	
	SELECT * FROM Inventario_Items
	
	SELECT * FROM dbo.Adm_System_Holding
	
	SELECT * FROM dbo.Adm_System_Dueños
	*/
	
END







GO
