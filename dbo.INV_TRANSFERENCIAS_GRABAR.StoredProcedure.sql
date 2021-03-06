USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_TRANSFERENCIAS_GRABAR]    Script Date: 19-08-2020 16:12:38 ******/
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
EXEC INV_TRANSFERENCIAS_GRABAR
17, 
'<root>
  <f cant="7" cantalm="7" desc="Clorex" fr="23/05/2017 0:00:00" fv="26/10/2017" nl="2" locd="DSC.0.1.A.1.005" locdid="9" loco="" lot="201705000023" lotp="S/L" sku="25581" nrec="17" r="pross" nsol="207" invd="SUBINVENTARIO F-22" invdid="10" invo="1-RECEPCION" />
  <f cant="6" cantalm="6" desc="Clorex" fr="23/05/2017 0:00:00" fv="31/05/2017" nl="1" locd="DSC.0.1.A.1.005" locdid="9" loco="" lot="201705000022" lotp="S/L" sku="25581" nrec="17" r="pross" nsol="207" invd="SUBINVENTARIO F-22" invdid="10" invo="1-RECEPCION" />
</root>',
2
--yyyy-mm-dd hh:mi:ss.mmm(24h)

*/
CREATE PROCEDURE [dbo].[INV_TRANSFERENCIAS_GRABAR]
--DECLARE
	 @ID_USRO NUMERIC(18, 0)
	,@ID_Org numeric(18, 0)
	,@XML_LOTES varchar(MAX)	
AS
BEGIN

--	SET @ID_USRO = 4
--	SET @ID_Org = 17
--	SET @XML_LOTES = '<root>
--  <f 
--	id="1" 
--	Sku="53151" 
--	Descriptor="CORPOREO AMPOLLA PANTENE PRO-V EN MADERA" 
--	SubinvOrigenId="50" 
--	SubinvOrigen="SUBINVENTARIO F-16" 
--	LocalizadorOrigenId="2617" 
--	LocalizadorOrigen="DSC.0.1.P.1.006" 
--	SubinvDestinoId="50" 
--	SubinvDestino="SUBINVENTARIO F-16" 
--	LocalizadorDestinoId="2789" 
--	LocalizadorDestino="DSC.0.1.S.4.044" 
--	Lote="201706000042" 
--	LoteProveedor="lote2" 
--	FechaVencimiento="31/08/2017" 
--	Cantidad="80.000" 
--	UnidadManejo="UNIDAD" />
--</root>'


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
		,Tbl.Col.value('@Sku', 'numeric(18, 0)')
		,@ID_Org
		,Tbl.Col.value('@SubinvOrigen', 'varchar(50)') Cod_Subinv_Origen
		,Tbl.Col.value('@LocalizadorOrigen', 'varchar(50)') Localizador_Origen
		,Tbl.Col.value('@SubinvDestino', 'varchar(50)') Cod_Subinv_Destino
		,Tbl.Col.value('@LocalizadorDestino', 'varchar(50)') Localizador_Destino
		,'TRANSFERENCIA SUBINVENTARIOS' Origen_TRX
		,0 Nro_Entrega
		,NULL Documento
		,NULL Razon_Social
		,Tbl.Col.value('@Lote', 'varchar(50)')
		,-Tbl.Col.value('@Cantidad', 'numeric(18, 0)') Cantidad_TRX
		,UM.Unidad_Medida_Abreviada Unidad_Medida--UnidadManejo
		,@ID_USRO ID_Usuario
		,PRODUCTO.Precio_Compra
	FROM @OXMLLOTES.nodes('//root/f') Tbl(Col)
		INNER JOIN Inventario_Items PRODUCTO
			ON Tbl.Col.value('@Sku', 'numeric(18, 0)') = PRODUCTO.COD_ITEM AND @ID_ORG = PRODUCTO.ID_ORG	
		INNER JOIN Inventario_Unidad_Medida_Primaria UM
			ON PRODUCTO.ID_UM = UM.ID_UM;
	
	
	--MOVIMIENTO DESTINO
	INSERT INTO [dbo].[Inventario_Detalle_Transacciones]
	SELECT
		 null ID_TRX_RECEP
		,@FECHA_INSERT
		,Tbl.Col.value('@Sku', 'numeric(18, 0)')
		,@ID_Org
		,'' Cod_Subinv_Origen
		,'' Localizador_Origen
		,Tbl.Col.value('@SubinvDestino', 'varchar(50)') Cod_Subinv_Destino
		,Tbl.Col.value('@LocalizadorDestino', 'varchar(50)') Localizador_Destino
		,'TRANSFERENCIA SUBINVENTARIOS' Origen_TRX
		,0 Nro_Entrega
		,NULL Documento
		,NULL Razon_Social
		,Tbl.Col.value('@Lote', 'varchar(50)')
		,Tbl.Col.value('@Cantidad', 'numeric(18, 3)') Cantidad_TRX
		,UM.Unidad_Medida_Abreviada Unidad_Medida
		,@ID_USRO ID_Usuario
		,PRODUCTO.Precio_Compra
	FROM @OXMLLOTES.nodes('//root/f') Tbl(Col)
		INNER JOIN Inventario_Items PRODUCTO
			ON Tbl.Col.value('@Sku', 'numeric(18, 0)') = PRODUCTO.COD_ITEM AND @ID_ORG = PRODUCTO.ID_ORG
		INNER JOIN Inventario_Unidad_Medida_Primaria UM
			ON PRODUCTO.ID_UM = UM.ID_UM;	

	
	----1º MOVIMIENTO EN STOCK DE LOTES (LO QUE QUEDA EN LOCALIZADOR ORIGEN)
	--DELETE FROM Inventario_Stock_Lotes
	--WHERE ID_LOTE IN (SELECT Tbl.Col.value('@lot', 'varchar(50)') FROM @oxmlLotes.nodes('//root/f') Tbl(Col))
	--	AND Id_Org = @Id_Org AND ID_Localizador = (SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 20);
	
	
	----SELECT * FROM Inventario_Stock_Lotes
	--INSERT INTO [dbo].[Inventario_Stock_Lotes]
	--SELECT  Tbl.Col.value('@lot', 'varchar(50)') ID_Lote
	--	   ,(SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 20) --Tbl.Col.value('@locdid', 'numeric(18, 0)') ID_Localizador
	--	   ,@Id_Org
	--	   ,Tbl.Col.value('@cant', 'numeric(18, 0)') - Tbl.Col.value('@cantalm', 'numeric(18, 0)')  --En_Mano 
	--	   ,Tbl.Col.value('@cant', 'numeric(18, 0)') - Tbl.Col.value('@cantalm', 'numeric(18, 0)') [Disponible]
	--	   ,0 [Reserva]
	--	   ,@ID_USRO
	--	   ,@ID_USRO
	--	   ,@FECHA_INSERT
	--	   ,@FECHA_INSERT
	--FROM @oxmlLotes.nodes('//root/f') Tbl(Col);	
	
	----2º MOVIMIENTO EN STOCK DE LOTES (LO QUE QUEDA EN LOCALIZADOR DESTINO)
	----SELECT * FROM Inventario_Stock_Lotes
	--INSERT INTO [dbo].[Inventario_Stock_Lotes]
	--SELECT  Tbl.Col.value('@lot', 'varchar(50)') ID_Lote
	--	   ,Tbl.Col.value('@locdid', 'numeric(18, 0)') ID_Localizador
	--	   ,@Id_Org
	--	   ,Tbl.Col.value('@Cantidad', 'numeric(18, 0)')  --En_Mano 
	--	   ,Tbl.Col.value('@Cantidad', 'numeric(18, 0)') [Disponible]
	--	   ,0 [Reserva]
	--	   ,@ID_USRO
	--	   ,@ID_USRO
	--	   ,@FECHA_INSERT
	--	   ,@FECHA_INSERT
	--FROM @oxmlLotes.nodes('//root/f') Tbl(Col);	


	--ACTUALIZAR ESPACIO UTILIZADO DE LOS LOCALIZADORES
	DECLARE
		 @LOTE VARCHAR(50)
		,@SUBINV_ORIGEN NUMERIC(18, 0)
		,@LOC_ORIGEN NUMERIC(18, 0)
		,@CANTIDAD NUMERIC(18, 3)		
		,@SUBINV_DESTINO NUMERIC(18, 0)
		,@LOC_DESTINO NUMERIC(18, 0)		
		,@VOLUMEN NUMERIC(18, 5)			
	
	DECLARE CLOTES CURSOR FOR
	SELECT 
		 Tbl.Col.value('@Lote', 'varchar(50)') 
		,Tbl.Col.value('@SubinvOrigenId', 'numeric(18, 0)') 
		,Tbl.Col.value('@LocalizadorOrigenId', 'numeric(18, 0)') 
		,Tbl.Col.value('@Cantidad', 'numeric(18, 3)')
		,Tbl.Col.value('@SubinvDestinoId', 'numeric(18, 0)') 
		,Tbl.Col.value('@LocalizadorDestinoId', 'numeric(18, 0)') 
		,PROD.VOLUMEN --CAST((Tbl.Col.value('@Cantidad', 'numeric(18, 3)') * PROD.VOLUMEN) AS NUMERIC(18, 5)) TOTAL_VOL
	FROM @OXMLLOTES.nodes('//root/f') Tbl(Col)	
		INNER JOIN Inventario_Items PROD
			ON PROD.COD_ITEM = Tbl.Col.value('@Sku', 'numeric(18, 0)');
			
			

	OPEN CLOTES
	
	FETCH CLOTES INTO
		 @LOTE
		,@SUBINV_ORIGEN
		,@LOC_ORIGEN
		,@CANTIDAD 
		,@SUBINV_DESTINO 
		,@LOC_DESTINO
		,@VOLUMEN		
	
	
	WHILE (@@FETCH_STATUS = 0 ) BEGIN
	
		--SELECT * FROM Inventario_Stock_Lotes
		--REBAJAR STOCK DE ORIGEN (DEBIERA EXISTIR SIEMPRE)
		IF EXISTS(SELECT * FROM Inventario_Stock_Lotes WHERE ID_LOTE = @LOTE AND ID_LOCALIZADOR = @LOC_ORIGEN AND ID_ORG = @ID_ORG) BEGIN
			
			UPDATE Inventario_Stock_Lotes
				SET  EN_MANO = (EN_MANO - @CANTIDAD)
					,DISPONIBLE = (DISPONIBLE - @CANTIDAD)
					,ID_USRO_ACT = @ID_USRO
					,FECH_ACTUALIZA = @FECHA_INSERT
			WHERE ID_LOTE = @LOTE 
				AND ID_LOCALIZADOR = @LOC_ORIGEN 
				AND ID_ORG = @ID_ORG			
			
			--SELECT * FROM Inventario_SubInv_Localizadores
			UPDATE Inventario_SubInv_Localizadores
				SET  ESPACIO_UTILIZADO = ESPACIO_UTILIZADO - (@CANTIDAD * @VOLUMEN),
					 ESPACIO_DISPONIBLE = VOLUMEN - ESPACIO_UTILIZADO,
					 ID_USRO_ACT = @ID_USRO,
					 FECH_ACTUALIZA = @FECHA_INSERT
			WHERE id_localizador = @LOC_ORIGEN
				AND COD_ESTADO = 1
				AND VIGENCIA = 'S'
				AND CONTROL_LOCALIZADOR = 'S';			
		
		END
	
		--SELECT * FROM Inventario_Stock_Lotes
		--AUMENTAR STOCK DE DESTINO (PROBABLEMENTE EL STOCK DE DESTINO NO EXISTA SIEMPRE)
		IF EXISTS(SELECT * FROM Inventario_Stock_Lotes WHERE ID_LOTE = @LOTE AND ID_LOCALIZADOR = @LOC_DESTINO AND ID_ORG = @ID_ORG) BEGIN
			
			UPDATE Inventario_Stock_Lotes
				SET  EN_MANO = (EN_MANO + @CANTIDAD)
					,DISPONIBLE = (DISPONIBLE + @CANTIDAD)
					,ID_USRO_ACT = @ID_USRO
					,FECH_ACTUALIZA = @FECHA_INSERT
			WHERE ID_LOTE = @LOTE 
				AND ID_LOCALIZADOR = @LOC_DESTINO 
				AND ID_ORG = @ID_ORG			
			
			--SELECT * FROM Inventario_SubInv_Localizadores
			UPDATE Inventario_SubInv_Localizadores
				SET  ESPACIO_UTILIZADO = ESPACIO_UTILIZADO - (@CANTIDAD * @VOLUMEN),
					 ESPACIO_DISPONIBLE = VOLUMEN - (ESPACIO_UTILIZADO - (@CANTIDAD * @VOLUMEN)),
					 ID_USRO_ACT = @ID_USRO,
					 FECH_ACTUALIZA = @FECHA_INSERT
			WHERE id_localizador = @LOC_DESTINO
				AND COD_ESTADO = 1
				AND VIGENCIA = 'S'
				AND CONTROL_LOCALIZADOR = 'S';			
		
		END	
		ELSE BEGIN
			
			--SELECT * FROM Inventario_Stock_Lotes
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
			(@LOTE
			,@LOC_DESTINO
			,@ID_ORG
			,@CANTIDAD
			,@CANTIDAD
			,0
			,@ID_USRO
			,@FECHA_INSERT)						
			
			--SELECT * FROM Inventario_SubInv_Localizadores
			UPDATE Inventario_SubInv_Localizadores
				SET  ESPACIO_UTILIZADO = ESPACIO_UTILIZADO + (@CANTIDAD * @VOLUMEN),
					 ESPACIO_DISPONIBLE = VOLUMEN - (ESPACIO_UTILIZADO + (@CANTIDAD * @VOLUMEN)),
					 ID_USRO_ACT = @ID_USRO,
					 FECH_ACTUALIZA = @FECHA_INSERT
			WHERE id_localizador = @LOC_DESTINO
				AND COD_ESTADO = 1
				AND VIGENCIA = 'S'
				AND CONTROL_LOCALIZADOR = 'S';				
		
		END
	

		
		FETCH CLOTES INTO
			 @LOTE
			,@SUBINV_ORIGEN
			,@LOC_ORIGEN
			,@CANTIDAD 
			,@SUBINV_DESTINO 
			,@LOC_DESTINO
			,@VOLUMEN		

	END
	
	CLOSE CLOTES
	
	DEALLOCATE cLotes
	
	
	
	--SELECT @@TRANCOUNT --ROLLBACK
	
/*	

SELECT * FROM Inventario_Detalle_Transacciones
ORDER BY FECHA_TRX DESC

SELECT * FROM Inventario_Stock_Lotes WHERE ID_LOTE = '201706000042'
ORDER BY FECH_ACTUALIZA DESC

SELECT * FROM Inventario_SubInv_Localizadores WHERE ID_LOCALIZADOR IN(2617,2789)
ORDER BY FECH_ACTUALIZA DESC


SELECT * FROM Inventario_Stock_Lotes
ORDER BY FECH_CREACION DESC

SELECT * FROM Inventario_SubInv_Localizadores
ORDER BY FECH_CREACION DESC


*/	

	COMMIT TRANSACTION;

	SELECT 1 CORRECTO, 'Transferencia realizada con exito' MENSAJE; --@@ROWCOUNT
	
	
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
