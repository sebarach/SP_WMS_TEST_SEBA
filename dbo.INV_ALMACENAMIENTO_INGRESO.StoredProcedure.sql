USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_ALMACENAMIENTO_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
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
EXEC INV_ALMACENAMIENTO_INGRESO
17, 
'<root>
  <f cant="7" cantalm="7" desc="Clorex" fr="23/05/2017 0:00:00" fv="26/10/2017" nl="2" locd="DSC.0.1.A.1.005" locdid="9" loco="" lot="201705000023" lotp="S/L" sku="25581" nrec="17" r="pross" nsol="207" invd="SUBINVENTARIO F-22" invdid="10" invo="1-RECEPCION" />
  <f cant="6" cantalm="6" desc="Clorex" fr="23/05/2017 0:00:00" fv="31/05/2017" nl="1" locd="DSC.0.1.A.1.005" locdid="9" loco="" lot="201705000022" lotp="S/L" sku="25581" nrec="17" r="pross" nsol="207" invd="SUBINVENTARIO F-22" invdid="10" invo="1-RECEPCION" />
</root>',
2
--yyyy-mm-dd hh:mi:ss.mmm(24h)

*/
CREATE PROCEDURE [dbo].[INV_ALMACENAMIENTO_INGRESO]
	-- Add the parameters for the stored procedure here	
	 --@ID_Recepcion numeric(18, 0)
	--,@Folio_Documento numeric(18, 0)
	 @ID_Org numeric(18, 0)
	,@XML_LOTES varchar(MAX)
	,@ID_USRO NUMERIC(18, 0)
AS
BEGIN

BEGIN TRANSACTION -- O solo BEGIN TRAN		
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;

	DECLARE @FECHA_INSERT DATETIME = (SELECT GETDATE());	
	--DECLARE @AGREGO INT = 0;
	
	--Carga de productos en detalle de documentos
	--DECLARE @oxml XML;
	DECLARE @oxmlLotes XML;
	SET @oxmlLotes = N'''' + @XML_LOTES + '''';

BEGIN TRY
	
	
	--MOVIMIENTO ORIGEN
	INSERT INTO [dbo].[Inventario_Detalle_Transacciones]
	SELECT
		 null ID_TRX_RECEP
		,@FECHA_INSERT
		,Tbl.Col.value('@sku', 'numeric(18, 0)')
		,@ID_Org
		,Tbl.Col.value('@invo', 'varchar(50)') Cod_Subinv_Origen
		,Tbl.Col.value('@loco', 'varchar(50)') Localizador_Origen
		,Tbl.Col.value('@invd', 'varchar(50)') Cod_Subinv_Destino
		,Tbl.Col.value('@locd', 'varchar(50)') Localizador_Destino
		,'INVENTARIO' Origen_TRX
		,0 Nro_Entrega
		,NULL Documento
		,NULL Razon_Social
		,Tbl.Col.value('@lot', 'varchar(50)')
		,-Tbl.Col.value('@cantalm', 'numeric(18, 0)') Cantidad_TRX
		,UM.Unidad_Medida_Abreviada Unidad_Medida
		,@ID_USRO ID_Usuario
		,PRODUCTO.Precio_Compra
	FROM @OXMLLOTES.nodes('//root/f') Tbl(Col)
		INNER JOIN Inventario_Items PRODUCTO
			ON Tbl.Col.value('@sku', 'numeric(18, 0)') = PRODUCTO.COD_ITEM AND @ID_ORG = PRODUCTO.ID_ORG	
		INNER JOIN Inventario_Unidad_Medida_Primaria UM
			ON PRODUCTO.ID_UM = UM.ID_UM
	WHERE Tbl.Col.value('@xd', 'varchar(50)') = '';
	--SELECT
	--	 null ID_TRX_RECEP
	--	,@FECHA_INSERT
	--	,Tbl.Col.value('@sku', 'numeric(18, 0)')
	--	,@ID_Org
	--	,'' Cod_Subinv_Origen
	--	,'' Localizador_Origen
	--	,Tbl.Col.value('@invd', 'varchar(50)') Cod_Subinv_Destino
	--	,Tbl.Col.value('@locd', 'varchar(50)') Localizador_Destino
	--	,'INVENTARIO' Origen_TRX
	--	,0 Nro_Entrega
	--	,NULL Documento
	--	,NULL Razon_Social
	--	,Tbl.Col.value('@lot', 'varchar(50)')
	--	,Tbl.Col.value('@cantalm', 'numeric(18, 0)') Cantidad_TRX
	--	,PRODUCTO.ID_UM Unidad_Medida
	--	,@ID_USRO ID_Usuario
	--	,PRODUCTO.Precio_Compra
	--FROM @OXMLLOTES.nodes('//root/f') Tbl(Col)
	--	INNER JOIN Inventario_Items PRODUCTO
	--		ON Tbl.Col.value('@sku', 'numeric(18, 0)') = PRODUCTO.COD_ITEM AND @ID_ORG = PRODUCTO.ID_ORG;	
	
	
	--MOVIMIENTO DESTINO
	INSERT INTO [dbo].[Inventario_Detalle_Transacciones]
	SELECT
		 null ID_TRX_RECEP
		,@FECHA_INSERT
		,Tbl.Col.value('@sku', 'numeric(18, 0)')
		,@ID_Org
		,'' Cod_Subinv_Origen
		,'' Localizador_Origen
		,Tbl.Col.value('@invd', 'varchar(50)') Cod_Subinv_Destino
		,Tbl.Col.value('@locd', 'varchar(50)') Localizador_Destino
		,'INVENTARIO' Origen_TRX
		,0 Nro_Entrega
		,NULL Documento
		,NULL Razon_Social
		,Tbl.Col.value('@lot', 'varchar(50)')
		,Tbl.Col.value('@cantalm', 'numeric(18, 0)') Cantidad_TRX
		,UM.Unidad_Medida_Abreviada Unidad_Medida
		,@ID_USRO ID_Usuario
		,PRODUCTO.Precio_Compra
	FROM @OXMLLOTES.nodes('//root/f') Tbl(Col)
		INNER JOIN Inventario_Items PRODUCTO
			ON Tbl.Col.value('@sku', 'numeric(18, 0)') = PRODUCTO.COD_ITEM AND @ID_ORG = PRODUCTO.ID_ORG
		INNER JOIN Inventario_Unidad_Medida_Primaria UM
			ON PRODUCTO.ID_UM = UM.ID_UM
	WHERE Tbl.Col.value('@xd', 'varchar(50)') = '';	
	
	


	
	--1º MOVIMIENTO EN STOCK DE LOTES (LO QUE QUEDA EN LOCALIZADOR ORIGEN)
	--INSERCIÓN DE STOCK DE LOTES
	DELETE FROM Inventario_Stock_Lotes
	WHERE ID_LOTE IN (SELECT Tbl.Col.value('@lot', 'varchar(50)') FROM @oxmlLotes.nodes('//root/f') Tbl(Col) WHERE Tbl.Col.value('@xd', 'varchar(50)') = '')
		AND Id_Org = @Id_Org AND ID_Localizador = (SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 20);
	
	
	--SELECT  Tbl.Col.value('@lot', 'varchar(50)') ID_Lote
	--	   ,3 --Tbl.Col.value('@locdid', 'numeric(18, 0)') ID_Localizador
	--	   ,@Id_Org
	--	   ,Tbl.Col.value('@cant', 'numeric(18, 0)') - Tbl.Col.value('@cantalm', 'numeric(18, 0)')  --En_Mano 
	--	   ,Tbl.Col.value('@cant', 'numeric(18, 0)') - Tbl.Col.value('@cantalm', 'numeric(18, 0)') [Disponible]
	--	   ,0 [Reserva]
	--	   ,@ID_USRO
	--	   ,@ID_USRO
	--	   ,@FECHA_INSERT
	--	   ,@FECHA_INSERT
	--FROM @oxmlLotes.nodes('//root/f') Tbl(Col);		
	
	--SELECT * FROM Inventario_Stock_Lotes
	INSERT INTO [dbo].[Inventario_Stock_Lotes]
	SELECT  Tbl.Col.value('@lot', 'varchar(50)') ID_Lote
		   ,(SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 20) --Tbl.Col.value('@locdid', 'numeric(18, 0)') ID_Localizador
		   ,@Id_Org
		   ,Tbl.Col.value('@cant', 'numeric(18, 0)') - Tbl.Col.value('@cantalm', 'numeric(18, 0)')  --En_Mano 
		   ,Tbl.Col.value('@cant', 'numeric(18, 0)') - Tbl.Col.value('@cantalm', 'numeric(18, 0)') [Disponible]
		   ,0 [Reserva]
		   ,@ID_USRO
		   ,@ID_USRO
		   ,@FECHA_INSERT
		   ,@FECHA_INSERT
	FROM @oxmlLotes.nodes('//root/f') Tbl(Col) 
	WHERE Tbl.Col.value('@xd', 'varchar(50)') = '';	

	
	--SELECT  Tbl.Col.value('@lot', 'varchar(50)') ID_Lote
	--	   ,Tbl.Col.value('@locdid', 'numeric(18, 0)') ID_Localizador
	--	   ,@Id_Org
	--	   ,Tbl.Col.value('@cantalm', 'numeric(18, 0)')  --En_Mano 
	--	   ,Tbl.Col.value('@cantalm', 'numeric(18, 0)') [Disponible]
	--	   ,0 [Reserva]
	--	   ,@ID_USRO
	--	   ,@ID_USRO
	--	   ,@FECHA_INSERT
	--	   ,@FECHA_INSERT
	--FROM @oxmlLotes.nodes('//root/f') Tbl(Col);	
	
	--2º MOVIMIENTO EN STOCK DE LOTES (LO QUE QUEDA EN LOCALIZADOR DESTINO)
	--SELECT * FROM Inventario_Stock_Lotes
	INSERT INTO [dbo].[Inventario_Stock_Lotes]
	SELECT  Tbl.Col.value('@lot', 'varchar(50)') ID_Lote
		   ,Tbl.Col.value('@locdid', 'numeric(18, 0)') ID_Localizador
		   ,@Id_Org
		   ,Tbl.Col.value('@cantalm', 'numeric(18, 0)')  --En_Mano 
		   ,Tbl.Col.value('@cantalm', 'numeric(18, 0)') [Disponible]
		   ,0 [Reserva]
		   ,@ID_USRO
		   ,@ID_USRO
		   ,@FECHA_INSERT
		   ,@FECHA_INSERT
	FROM @oxmlLotes.nodes('//root/f') Tbl(Col)
	WHERE Tbl.Col.value('@xd', 'varchar(50)') = '';	


	--ACTUALIZAR ESPACIO UTILIZADO DE LOS LOCALIZADORES


	DECLARE
		 @ID_LOTE VARCHAR(50)
		,@CANTIDAD_ALMACENAR NUMERIC(18, 3)
		,@ID_LOCALIZADOR_DESTINO NUMERIC(18, 0)
		,@VOLUMEN NUMERIC(18, 5)	
		
	
	DECLARE CLOTES CURSOR FOR
	SELECT 
		 Tbl.Col.value('@lot', 'varchar(50)') lote_id
		,Tbl.Col.value('@cantalm', 'numeric(18, 0)') cant_almacenar
		,Tbl.Col.value('@locdid', 'numeric(18, 0)') localizador_id
		,PROD.VOLUMEN --CAST((Tbl.Col.value('@cantalm', 'numeric(18, 5)') * PROD.VOLUMEN) AS NUMERIC(18, 5)) TOTAL_VOL
	FROM @OXMLLOTES.nodes('//root/f') Tbl(Col)	
		INNER JOIN Inventario_Items PROD
			ON PROD.COD_ITEM = Tbl.Col.value('@sku', 'numeric(18, 0)')
	WHERE Tbl.Col.value('@xd', 'varchar(50)') = ''
	
	OPEN CLOTES
	
	FETCH CLOTES INTO
		 @ID_LOTE
		,@CANTIDAD_ALMACENAR 
		,@ID_LOCALIZADOR_DESTINO 
		,@VOLUMEN		
	
	
	WHILE (@@FETCH_STATUS = 0 ) BEGIN
	
		--SELECT * FROM Inventario_SubInv_Localizadores
		UPDATE Inventario_SubInv_Localizadores
			SET  ESPACIO_UTILIZADO = (@CANTIDAD_ALMACENAR * @VOLUMEN),
				 ESPACIO_DISPONIBLE = VOLUMEN - (@CANTIDAD_ALMACENAR * @VOLUMEN)
		WHERE id_localizador = @ID_LOCALIZADOR_DESTINO
			AND COD_ESTADO = 1
			AND VIGENCIA = 'S'
			AND CONTROL_LOCALIZADOR = 'S';		
		
		FETCH CLOTES INTO
			 @ID_LOTE
			,@CANTIDAD_ALMACENAR 
			,@ID_LOCALIZADOR_DESTINO 
			,@VOLUMEN		

	END
	
	CLOSE CLOTES
	
	DEALLOCATE cLotes
	
	
		
		--SELECT ID_LOCALIZADOR FROM Inventario_Stock_Lotes 
		--WHERE ID_LOTE IN(
		--	SELECT Tbl.Col.value('@lot', 'varchar(50)') FROM @oxmlLotes.nodes('//root/f') Tbl(Col) 	
		--) AND EN_MANO = 0 AND DISPONIBLE = 0

	----SubInventario_Localizadores	
	--UPDATE Inventario_SubInv_Localizadores
	--SET  cod_estado = 1
	--WHERE id_localizador IN (
	--	SELECT ID_LOCALIZADOR FROM Inventario_Stock_Lotes 
	--	WHERE ID_LOTE IN(
	--		SELECT Tbl.Col.value('@lot', 'varchar(50)') FROM @oxmlLotes.nodes('//root/f') Tbl(Col) 	
	--	) AND EN_MANO = 0 AND DISPONIBLE = 0
	--);

	
	--	--SELECT Tbl.Col.value('@locdid', 'numeric(18, 0)') FROM @OXMLLOTES.nodes('//root/f') Tbl(Col)	
	--	--	WHERE Tbl.Col.value('@cantalm', 'numeric(18, 0)') > 0

	--UPDATE Inventario_SubInv_Localizadores
	--SET  cod_estado = 2
	--WHERE id_localizador IN (
	--	SELECT Tbl.Col.value('@locdid', 'numeric(18, 0)') FROM @OXMLLOTES.nodes('//root/f') Tbl(Col)	
	--		WHERE Tbl.Col.value('@cantalm', 'numeric(18, 0)') > 0
	--);

	
	--SELECT * FROM Inventario_Detalle_Transacciones	
	--SELECT * FROM Inventario_Stock_Lotes
	
	--select @@trancount --rollback transaction	
		--CAMBIA DE ESTADO LA RECEPCION
	UPDATE Inventario_Cabecera_Documentos
	SET ID_ESTADO = 120
	WHERE Folio_Documento = (SELECT distinct Tbl.Col.value('@nsol', 'numeric(18, 0)')FROM @OXMLLOTES.nodes('//root/f') Tbl(Col)) 
	AND ID_DOCU = 10 AND ID_ORG = @ID_Org;

	
--SELECT * FROM Inventario_Stock_Lotes

--SELECT * FROM Inventario_Detalle_Transacciones

--SELECT * FROM Inventario_SubInv_Localizadores	
	
	--COMMIT TRANSACTION
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
