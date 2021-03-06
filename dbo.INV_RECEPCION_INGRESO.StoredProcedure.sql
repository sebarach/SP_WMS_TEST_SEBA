USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_RECEPCION_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
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
EXEC INV_RECEPCION_INGRESO
4,
212,
10,
17,
'1-RECEPCION',
'2017-05-28 00:00:00.000',
'123456',
'PROVEEDOR PROVISORIO',
'123456',
'Recepcionado',
'pross',
'<root>
  <f id="1" pid="55863" d="PANTENE SHAMPOO RESTAURACION 200MLX12IT" c="10" cp="0" cs="0" p="1800" l="0" oti="1" ot="RECEPCION MERCADERIA" />
  <f id="2" pid="53235" d="ACE NATURALS 200 X 30IT (80293557)" c="20" cp="0" cs="0" p="6898" l="0" oti="1" ot="RECEPCION MERCADERIA" />
</root>',
'<root>
  <f id="1" l="201705000006" fv="31/05/2017" lp="S/L" pid="55863" c="10" cp="45" cs="35" />
  <f id="1" l="201705000007" fv="31/05/2017" lp="S/L" pid="53235" c="20" cp="20" cs="0" />
</root>',
2

--yyyy-mm-dd hh:mi:ss.mmm(24h)

*/
CREATE PROCEDURE [dbo].[INV_RECEPCION_INGRESO]
	-- Add the parameters for the stored procedure here	
	 @ID_Recepcion numeric(18, 0)
	,@Folio_Documento numeric(18, 0)
	,@Id_Docu numeric(18, 0)
	,@ID_Org numeric(18, 0)
	,@Cod_Subinv varchar(MAX)
	,@Fecha_Recep datetime
	,@Nro_Guia_Prov varchar(50)
	,@Proveedor varchar(MAX)
	,@Nro_OC numeric(18, 0)
	,@Nota varchar(MAX)
	,@Responsable varchar(50)
	,@XML varchar(MAX)
	,@XML_LOTES varchar(MAX)
	,@ID_USRO NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	DECLARE @FECHA_INSERT DATETIME = (SELECT GETDATE());	
	DECLARE @AGREGO INT = 0;
	
	--Carga de productos en detalle de documentos
	DECLARE @oxml XML;
	DECLARE @oxmlLotes XML;

BEGIN TRANSACTION -- O solo BEGIN TRAN
BEGIN TRY

	DECLARE @ULTIMOFOLIO NUMERIC(18, 0) = (SELECT MAX(ID_TRX_Recep) FROM Inventario_Folios_Todos);
	DECLARE @NUEVOFOLIO NUMERIC(18, 0);
	
	SET @oxml = N'''' + @XML + '''';	
	SET @oxmlLotes = N'''' + @XML_LOTES + '''';
	

	--CREAR TEMPORAL DETALLE RECEPCION
	DECLARE @TABLA_DETALLE TABLE (ID_Lote varchar(50)
								,CANTIDAD numeric(18, 3)
								,ID_TRX_Recep numeric(18, 0));	
	 
	INSERT INTO @TABLA_DETALLE
	SELECT DETALLE.ID_Lote, DETALLE.Cantidad_Falta, DETALLE.ID_TRX_Recep
	FROM Inventario_Detalle_Recepcion DETALLE
		INNER JOIN @oxmlLotes.nodes('//root/f') LOTES(Col)
			ON LOTES.Col.value('@l', 'varchar(50)') = DETALLE.ID_Lote	
		INNER JOIN @oxml.nodes('//root/f') Tbl(Col)
			ON Tbl.Col.value('@pid', 'numeric(18, 0)') = LOTES.Col.value('@pid', 'numeric(18, 0)');-- AND @Id_Org = Id_Org;	
		
	--Eliminar datos DETALLE RECEPCION SI EXISTIERAN
	DELETE FROM [dbo].Inventario_Detalle_Recepcion
	WHERE ID_Lote IN(SELECT ID_Lote FROM @TABLA_DETALLE) AND Id_Org = @Id_Org;

	 
	----INSERT INTO @TABLA_DETALLE
	--SELECT DETALLE.ID_Lote, DETALLE.ID_TRX_Recep
	--FROM Inventario_Detalle_Recepcion DETALLE
	--	INNER JOIN @oxmlLotes.nodes('//root/f') LOTES(Col)
	--		ON LOTES.Col.value('@l', 'varchar(50)') = DETALLE.ID_Lote	
	--	INNER JOIN @oxml.nodes('//root/f') Tbl(Col)
	--		ON Tbl.Col.value('@pid', 'numeric(18, 0)') = LOTES.Col.value('@pid', 'numeric(18, 0)');-- AND @Id_Org = Id_Org;	
		
	----Eliminar datos DETALLE RECEPCION
	--DELETE FROM [dbo].Inventario_Detalle_Recepcion
	--WHERE ID_Lote IN(SELECT ID_Lote FROM @TABLA_DETALLE) AND Id_Org = @Id_Org;		
	
	
	----CREAR TABLA TEMPORAL Inventario_Lotes y cargarla
	--DECLARE @TABLA_LOTES TABLE ( ID_Lote varchar(50)
	--							,Fecha_Origen datetime
	--							--,ID_Org numeric(18, 0)
								--)
	
	--INSERT INTO @TABLA_LOTES
	--SELECT LOTES.ID_Lote, LOTES.Fecha_Origen
	--FROM Inventario_Lotes LOTES
	--	INNER JOIN @oxmlLotes.nodes('//root/f') Tbl(Col)
	--		ON Tbl.Col.value('@l', 'varchar(50)') = LOTES.ID_Lote;--AND @Id_Org = Id_Org;
	
	----Eliminar datos Inventario_Lotes
	--DELETE FROM [dbo].Inventario_Lotes
	--WHERE ID_Lote IN(SELECT ID_Lote FROM @TABLA_LOTES) AND Id_Org = @Id_Org;	

	--SELECT * FROM Inventario_Cabecera_Recepcion
    -- Insert statements for procedure here
    IF NOT EXISTS(SELECT ID_Recepcion FROM Inventario_Cabecera_Recepcion 
				  WHERE Folio_Documento = @Folio_Documento AND Id_Org = @Id_Org AND Id_Docu = @Id_Docu AND ID_Recepcion = @ID_Recepcion) BEGIN
		PRINT 'INSERTA'
		--DECLARE @NUEVO_FOLIO NUMERIC(18, 0) = (SELECT MAX(Ultimo_Folio) + 1 NUEVO_FOLIO
		--										FROM dbo.Inventario_Tipo_Documentos
		--										WHERE Id_Docu = @Id_Docu);
		
		DECLARE @RETORNO TABLE(ID NUMERIC(18, 0));
		--DECLARE @NUEVOID NUMERIC(18, 0);		
    
		INSERT INTO [dbo].[Inventario_Cabecera_Recepcion]
			   ([Folio_Documento]
			   ,[Id_Docu]
			   ,[ID_Org]
			   ,[Cod_Subinv]
			   ,[Fecha_Recep]
			   ,[Nro_Guia_Prov]
			   ,[Proveedor]
			   ,[Nro_OC]
			   ,[Nota]
			   ,[Responsable])
			   OUTPUT INSERTED.ID_RECEPCION 
			   INTO @RETORNO(ID)			   
		 VALUES
			   ( @Folio_Documento
				,@Id_Docu
				,@ID_Org
				,@Cod_Subinv
				,@Fecha_Recep
				,@Nro_Guia_Prov
				,@Proveedor
				,@Nro_OC
				,@Nota
				,@Responsable);
		
		--CAMBIA DE ESTADO LA RECEPCION
		UPDATE Inventario_Cabecera_Documentos
		SET ID_ESTADO = 110
		WHERE Folio_Documento = @Folio_Documento AND ID_DOCU = @Id_Docu AND ID_ORG = @ID_Org;
		
		--GRABA HISTORIAL DE OBSERVACIONES
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
				,@FECHA_INSERT
				,@Nota
				,@ID_USRO);				
		
			--SELECT ID FROM @RETORNO;		
PRINT 'antes de insertar Inventario_Lotes'
		--SELECT * FROM Inventario_Lotes	
		--Insertar los datos a Lotes
		INSERT INTO [dbo].Inventario_Lotes
		SELECT 
			 Tbl.Col.value('@l', 'varchar(50)') --Lote id
			,@FECHA_INSERT --Fecha Origen
			,CONVERT(date, Tbl.Col.value('@fv', 'varchar(10)'),103) --Fecha expira --'datetime'
			,Tbl.Col.value('@lp', 'varchar(50)') --Lote proveedor
			,Tbl.Col.value('@pid', 'numeric(18, 0)') --Cod item
			,@Id_Org --IdOrg
			,@ID_USRO --Usu crea
			,@ID_USRO --usu actualiza
			,@FECHA_INSERT --fecha crea
			,@FECHA_INSERT --fecah actualiza
			,(SELECT ID_DUEÑO FROM Inventario_Cabecera_Documentos WHERE Folio_Documento = @Folio_Documento AND ID_DOCU = @Id_Docu AND ID_ORG = @ID_Org)
			,NULL
		FROM @oxmlLotes.nodes('//root/f') Tbl(Col);			
	PRINT 'no cae'
		--SELECT * FROM Inventario_Lotes		
	
		/*
			Utilización de ROW_NUMBER
			SELECT 			  
			  name, recovery_model_desc,
			  20 + ROW_NUMBER() OVER(ORDER BY recovery_model_desc asc, name asc) AS Row#
			FROM sys.databases 
			WHERE database_id < 5;
		
		SELECT * FROM Inventario_Lotes a
		SELECT * FROM [dbo].Inventario_Detalle_Recepcion
		*/	
		
		--DECLARE @ULTIMOFOLIO NUMERIC(18, 0) = (SELECT MAX(ID_TRX_Recep) FROM Inventario_Folios_Todos)
		PRINT 'OBTUVO ULTIMO FOLIO: ' + CAST(@ULTIMOFOLIO AS VARCHAR(30));
		--PARA ASEGURARNOS QUE LA TABLA QUEDÓ TOMADA Y QUE NO OBTENGAN IDS YA CONSULTADOS Y USADOS
		UPDATE Inventario_Folios_Todos
		SET ID_TRX_Recep = @ULTIMOFOLIO
		WHERE ID_TRX_Recep = @ULTIMOFOLIO;		
		PRINT 'ACTUALIZÓ LA TABLA Inventario_Folios_Todos para dejarla tomada';		
	
		--EN ESTE SELECT SE PODRIAN OBTENER LAS DIFERENCIAS POR CORRECCIÓN
		/* --SELECT * FROM @TABLA_DETALLE
		SELECT 	
			 (SELECT ID FROM @RETORNO) --ID_RECEPCION
			,LOTES.Col.value('@id', 'numeric(18, 0)') --nro linea
			,Tbl.Col.value('@pid', 'numeric(18, 0)') --Código producto
			,LOTES.Col.value('@c', 'numeric(18, 0)') - DETALLE.CANTIDAD --cantidad
			,LOTES.Col.value('@cs', 'numeric(18, 0)') --cantidad execede
			,LOTES.Col.value('@cp', 'numeric(18, 0)') --cantidad falta
			,LOTES.Col.value('@l', 'varchar(50)') --lote id
			,@Id_Org
			--,CASE
			--	WHEN DETALLE.ID_TRX_Recep IS NULL THEN @ULTIMOFOLIO + ROW_NUMBER() OVER(ORDER BY DETALLE.ID_TRX_Recep ASC) - 1 --,TRANSACCION --MENOS UNO YA QUE SE AGREGA UNO AL NUEVO FOLIO AL FINAL DEL EJERCICIO
			--	WHEN DETALLE.ID_TRX_Recep IS NOT NULL THEN DETALLE.ID_TRX_Recep
			--END
		FROM @oxml.nodes('//root/f') Tbl(Col)  
			INNER JOIN @oxmlLotes.nodes('//root/f') LOTES(Col)
				ON Tbl.Col.value('@pid', 'numeric(18, 0)') = LOTES.Col.value('@pid', 'numeric(18, 0)')
			LEFT JOIN @TABLA_DETALLE DETALLE
				ON LOTES.Col.value('@l', 'varchar(50)') = DETALLE.ID_Lote;	
		*/
		
		INSERT INTO [dbo].Inventario_Detalle_Recepcion
		SELECT 	
			 (SELECT ID FROM @RETORNO)
			,LOTES.Col.value('@id', 'numeric(18, 0)') --nro linea
			,Tbl.Col.value('@pid', 'numeric(18, 0)') --Código producto
			,LOTES.Col.value('@c', 'numeric(18, 3)') --cantidad
			,LOTES.Col.value('@cs', 'numeric(18, 3)') --cantidad execede
			,LOTES.Col.value('@cp', 'numeric(18, 3)') --cantidad falta
			,LOTES.Col.value('@l', 'varchar(50)') --lote id
			,@Id_Org
			,CASE
				WHEN DETALLE.ID_TRX_Recep IS NULL THEN @ULTIMOFOLIO + ROW_NUMBER() OVER(ORDER BY DETALLE.ID_TRX_Recep ASC) - 1 --,TRANSACCION --MENOS UNO YA QUE SE AGREGA UNO AL NUEVO FOLIO AL FINAL DEL EJERCICIO
				WHEN DETALLE.ID_TRX_Recep IS NOT NULL THEN DETALLE.ID_TRX_Recep
			END
		FROM @oxml.nodes('//root/f') Tbl(Col)  
			INNER JOIN @oxmlLotes.nodes('//root/f') LOTES(Col)
				ON Tbl.Col.value('@pid', 'numeric(18, 0)') = LOTES.Col.value('@pid', 'numeric(18, 0)')
			LEFT JOIN @TABLA_DETALLE DETALLE
				ON LOTES.Col.value('@l', 'varchar(50)') = DETALLE.ID_Lote;	
		PRINT 'INSERTO A LA TABLA Inventario_Detalle_Recepcion';

		--OBTENER EL MAXIMO FOLIO QUE SE ALCANZÓ A REGISTRAR
		SET @NUEVOFOLIO = (SELECT MAX(TRANSACCIONADOS) + 1 FROM
		(SELECT 	
			 (SELECT ID FROM @RETORNO) ID_Recepcion
			,Tbl.Col.value('@id', 'numeric(18, 0)') NRO_LINEA --nro linea
			,Tbl.Col.value('@pid', 'numeric(18, 0)') PROD_ID --Código producto
			,LOTES.Col.value('@c', 'numeric(18, 3)') CANTIDAD --cantidad
			,LOTES.Col.value('@cs', 'numeric(18, 3)') CANT_EXCEDE --cantidad execede
			,LOTES.Col.value('@cp', 'numeric(18, 3)') CANT_FALTA --cantidad falta
			,LOTES.Col.value('@l', 'varchar(50)') LOTE_ID --lote id
			,@Id_Org ID_ORG
			,CASE
				WHEN DETALLE.ID_TRX_Recep IS NULL THEN @ULTIMOFOLIO + ROW_NUMBER() OVER(ORDER BY DETALLE.ID_TRX_Recep ASC) - 1 --,TRANSACCION --MENOS UNO YA QUE SE AGREGA UNO AL NUEVO FOLIO AL FINAL DEL EJERCICIO
				WHEN DETALLE.ID_TRX_Recep IS NOT NULL THEN DETALLE.ID_TRX_Recep
			END TRANSACCIONADOS
		FROM @oxml.nodes('//root/f') Tbl(Col)  
			INNER JOIN @oxmlLotes.nodes('//root/f') LOTES(Col)
				ON Tbl.Col.value('@pid', 'numeric(18, 0)') = LOTES.Col.value('@pid', 'numeric(18, 0)')
			LEFT JOIN @TABLA_DETALLE DETALLE
				ON LOTES.Col.value('@l', 'varchar(50)') = DETALLE.ID_Lote
			WHERE DETALLE.ID_TRX_Recep IS NULL) TABLA_TRANSACCIONADOS);								
		
		--ACTUALIZAMOS FINALMENTE LA TABLA DE FOLIOS
		UPDATE Inventario_Folios_Todos
		SET ID_TRX_Recep = @NUEVOFOLIO
		WHERE ID_TRX_Recep = @ULTIMOFOLIO;	
		
		PRINT 'NUEVO FOLIO:' + CAST(@NUEVOFOLIO AS VARCHAR(5))
	
		/*
		--DETALLE RECEPCION
		SELECT 
			 Tbl.Col.value('@id', 'numeric(18, 0)') [linea]
			,Tbl.Col.value('@pid', 'numeric(18, 0)') [Producto Id]
			,Tbl.Col.value('@d', 'varchar(256)') [Descriptor]
			,Tbl.Col.value('@c', 'numeric(18, 0)') [Cant]
			,Tbl.Col.value('@cp', 'numeric(18, 0)') [Cant. Pen]
			,Tbl.Col.value('@cs', 'numeric(18, 0)') [Cant. Sobra]
			,Tbl.Col.value('@p', 'numeric(18, 0)') [Precio]	
			,Tbl.Col.value('@l', 'varchar(50)') [lote --En este campo está malo]
			,Tbl.Col.value('@oti', 'varchar(10)') [Origen Transacción Id]
			,Tbl.Col.value('@ot', 'varchar(100)') [Origen Transacción]
		FROM @oxml.nodes('//root/f') Tbl(Col)		
		--LOTES
		SELECT 
			 Tbl.Col.value('@id', 'numeric(18, 0)') [linea]
			,Tbl.Col.value('@l', 'varchar(50)') [lote]
			,Tbl.Col.value('@fv', 'varchar(10)') [Fecha Vencimiento]
			,Tbl.Col.value('@lp', 'varchar(100)') [Lote proveedor]
			,Tbl.Col.value('@pid', 'numeric(18, 0)') [Producto Id]
			,Tbl.Col.value('@c', 'numeric(18, 0)') [Cant]
			,Tbl.Col.value('@cp', 'numeric(18, 0)') [Cant. Pen]
			,Tbl.Col.value('@cs', 'numeric(18, 0)') [Cant. Sobra]
		FROM @oxmlLotes.nodes('//root/f') Tbl(Col)		
		*/
		--INSERCIÓN DETALLE DE TRANSACCION (KARDEX)
		/*
		SELECT * FROM Inventario_Lotes a
		SELECT * FROM [dbo].Inventario_Detalle_Recepcion
		SELECT * FROM Inventario_Detalle_Transacciones
		*/
		INSERT INTO [dbo].[Inventario_Detalle_Transacciones]
		SELECT
			 DETALLE.ID_TRX_RECEP
			,@FECHA_INSERT
			,DETALLE.Cod_Item
			,DETALLE.ID_Org
			,'1-RECEPCION' Cod_Subinv_Origen
			,'' Localizador_Origen
			,'' Cod_Subinv_Destino
			,'' Localizador_Destino
			,'RECEPCION MERCADERIA' Origen_TRX
			,0 Nro_Entrega
			,@Nro_Guia_Prov Documento
			,@Proveedor Razon_Social
			,DETALLE.ID_Lote
			,DETALLE.CANTIDAD_FALTA --QUEDÓ AHORA COMO CANTIDAD RECIBIDA --,DETALLE.CANTIDAD Cantidad_TRX -- CANTIDAD SOLICITUD
			,UM.Unidad_Medida_Abreviada Unidad_Medida
			,@ID_USRO ID_Usuario
			,PRODUCTO.Precio_Compra
		FROM Inventario_Detalle_Recepcion DETALLE
			INNER JOIN Inventario_Items PRODUCTO
				ON DETALLE.COD_ITEM = PRODUCTO.COD_ITEM AND DETALLE.ID_ORG = PRODUCTO.ID_ORG
			INNER JOIN Inventario_Unidad_Medida_Primaria UM
				ON PRODUCTO.ID_UM = UM.ID_UM				
			LEFT JOIN Inventario_Detalle_Transacciones KARDEX
				ON DETALLE.ID_TRX_RECEP = KARDEX.ID_Origen_TRX AND DETALLE.ID_ORG = KARDEX.ID_ORG
		WHERE KARDEX.ID_Origen_TRX IS NULL;		



		/*         
		SELECT * FROM Inventario_Detalle_Recepcion
		--SELECT * FROM Inventario_Detalle_Transacciones
		SELECT * FROM Inventario_Stock_Lotes           
		*/	
		--INSERCIÓN DE STOCK DE LOTES
		--DELETE FROM [dbo].[Inventario_Stock_Lotes] 
		--WHERE ID_LOTE IN (SELECT Tbl.Col.value('@l', 'varchar(50)') FROM @oxmlLotes.nodes('//root/f') Tbl(Col));

		INSERT INTO [dbo].[Inventario_Stock_Lotes]
		SELECT  DET.ID_Lote
			   ,(SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 20) ID_Localizador
			   ,@Id_Org
			   ,DET.CANTIDAD_FALTA --QUEDÓ AHORA COMO CANTIDAD RECIBIDA --,DET.CANTIDAD --En_Mano 
			   ,DET.CANTIDAD_FALTA [Disponible] --QUEDÓ AHORA COMO CANTIDAD RECIBIDA --,DET.CANTIDAD --Disponible
			   ,0 [Reserva]
			   ,@ID_USRO
			   ,@ID_USRO
			   ,@FECHA_INSERT
			   ,@FECHA_INSERT
		FROM Inventario_Detalle_Recepcion DET
			INNER JOIN @oxmlLotes.nodes('//root/f') Tbl(Col)
				ON DET.ID_Lote = Tbl.Col.value('@l', 'varchar(50)') AND DET.Id_Org = @Id_Org;
	
		/*
		SELECT * FROM Inventario_Lotes
		SELECT * FROM Inventario_Cabecera_Recepcion
		SELECT * FROM Inventario_Folios_Todos
		SELECT * FROM Inventario_Detalle_Recepcion
		SELECT * FROM Inventario_Detalle_Transacciones
		SELECT * FROM Inventario_Stock_Lotes
		*/		
		SET @AGREGO	= 1;
	END  		
	ELSE BEGIN
	
		DECLARE @FECHA_UPDATE DATETIME = (SELECT GETDATE());
	
		--IF @Vigencia <> 'N' BEGIN
		
		DECLARE @id_estado NUMERIC(18, 0) = (SELECT ID_ESTADO FROM Inventario_Cabecera_Documentos WHERE Folio_Documento = @Folio_Documento AND Id_Docu = @Id_Docu AND ID_Org = @ID_Org);
		
		IF @id_estado = 110 BEGIN
		
			UPDATE [dbo].[Inventario_Cabecera_Recepcion]
			SET  Folio_Documento = @Folio_Documento
				,Id_Docu = @Id_Docu
				,ID_Org = @ID_Org
				,Cod_Subinv = @Cod_Subinv
				,Fecha_Recep = @Fecha_Recep
				,Nro_Guia_Prov = @Nro_Guia_Prov
				,Proveedor = @Proveedor
				,Nro_OC = @Nro_OC
				,Nota = @Nota
				,Responsable = @Responsable
			WHERE ID_Recepcion = @ID_Recepcion AND Id_Org = @Id_Org;
			
			IF NOT EXISTS(SELECT Nota FROM INVENTARIO_OBSERVACIONES_SOLICITUDES WHERE Nota = @Nota AND Folio_Documento = Folio_Documento AND Id_Docu = @Id_Docu AND Id_Org = @Id_Org) BEGIN
				--GRABA HISTORIAL DE OBSERVACIONES
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
						,@ID_USRO);			
			END
		
			--SELECT @@ROWCOUNT FILAS_AFECTADAS;
		END ELSE BEGIN
		
			--UPDATE [dbo].[Inventario_Cabecera_Recepcion]
			--SET 
			--	Nota = @Nota
			--	,Fech_Actualiza = @FECHA_UPDATE
			--	,ID_Usro_Act = @ID_USRO
			--WHERE Folio_Documento = @Folio_Documento AND Id_Org = @Id_Org AND Id_Docu = @Id_Docu;
			
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
						,@ID_USRO);			
			END			
			
			--SELECT @@ROWCOUNT FILAS_AFECTADAS;
		END
			
		--END ELSE BEGIN
		
		--	UPDATE [dbo].[Inventario_Cabecera_Documentos]
		--	SET 
		--		 Fech_Actualiza = @FECHA_UPDATE
		--		,ID_Usro_Act = @ID_Usro_Act
		--		,Vigencia = @Vigencia
		--	WHERE Folio_Documento = @Folio_Documento AND Id_Org = @Id_Org AND Id_Docu = @Id_Docu;
			
		--	SELECT @@ROWCOUNT FILAS_AFECTADAS;				
		
		--END
	
		/*
			SELECT 			  
			  name, recovery_model_desc,
			  20 + ROW_NUMBER() OVER(ORDER BY recovery_model_desc asc, name asc) AS Row#
			FROM sys.databases 
			WHERE database_id < 5;
		
		SELECT * FROM Inventario_Lotes a
		SELECT * FROM [dbo].Inventario_Detalle_Recepcion
		*/	
		
		--Actualizamos los datos a Lotes
		UPDATE Inventario_Lotes
		SET -- Tbl.Col.value('@l', 'varchar(50)') --Lote id
			--,@FECHA_INSERT --Fecha Origen
			 FECHA_EXPIRA = (SELECT CONVERT(date, Tbl.Col.value('@fv', 'varchar(10)'),103) FROM @oxmlLotes.nodes('//root/f') Tbl(Col) WHERE Tbl.Col.value('@l', 'varchar(50)') = Inventario_Lotes.ID_LOTE) --Fecha expira --'datetime'
			,LOTE_PROVEEDOR = (SELECT Tbl.Col.value('@lp', 'varchar(50)') FROM @oxmlLotes.nodes('//root/f') Tbl(Col) WHERE Tbl.Col.value('@l', 'varchar(50)') = Inventario_Lotes.ID_LOTE) --Lote proveedor
			--,Tbl.Col.value('@pid', 'numeric(18, 0)') --Cod item
			,ID_ORG = @Id_Org --IdOrg
			--,ID_USRO_CREA = @ID_USRO --Usu crea
			,ID_USRO_ACT = @ID_USRO --usu actualiza
			--,FECH_CREACION = @FECHA_INSERT --fecha crea
			,FECH_ACTUALIZA = @FECHA_UPDATE --fecah actualiza
		WHERE ID_LOTE IN(SELECT Tbl.Col.value('@l', 'varchar(50)') FROM @oxmlLotes.nodes('//root/f') Tbl(Col));		
		/* --EJEMPLO UPDATE MASIVO
		UPDATE tCoches
		SET  marca = (SELECT CODIGO FROM tMarcas WHERE tMarcas.Marca = tCoches.Marca )
		WHERE marca IN ('FORD','RENAULT','SEAT');
		*/






		
		--ACTUALIZAMOS LA TABLA DE DETALLE RECEPCIÓN
				
		--DECLARE @ULTIMOFOLIO NUMERIC(18, 0) = (SELECT MAX(ID_TRX_Recep) FROM Inventario_Folios_Todos)
		PRINT 'OBTUVO ULTIMO FOLIO: ' + CAST(@ULTIMOFOLIO AS VARCHAR(30));
		--PARA ASEGURARNOS QUE LA TABLA QUEDÓ TOMADA Y QUE NO OBTENGAN IDS YA CONSULTADOS Y USADOS
		UPDATE Inventario_Folios_Todos
		SET ID_TRX_Recep = @ULTIMOFOLIO
		WHERE ID_TRX_Recep = @ULTIMOFOLIO;		
		PRINT 'ACTUALIZÓ LA TABLA Inventario_Folios_Todos para dejarla tomada';		
	
		--EN ESTE SELECT SE PODRIAN OBTENER LAS DIFERENCIAS POR CORRECCIÓN

		DECLARE @TABLA_DETALLE_DIFERENCIA TABLE (ID_Lote varchar(50)
										,CANTIDAD numeric(18, 3)
										,CORRECCION varchar(50));	
		
		----SELECT * FROM @TABLA_DETALLE
		----VERIFICACIÓN DATOS DE CORRECCIÓN
		--SELECT 	
		--	 LOTES.Col.value('@l', 'varchar(50)') --lote id
		--	,CASE 
		--		WHEN (DETALLE.CANTIDAD - LOTES.Col.value('@cp', 'numeric(18, 0)')) < 0 THEN ABS(DETALLE.CANTIDAD - LOTES.Col.value('@cp', 'numeric(18, 0)'))
		--		WHEN (DETALLE.CANTIDAD - LOTES.Col.value('@cp', 'numeric(18, 0)')) > 0 THEN (DETALLE.CANTIDAD - LOTES.Col.value('@cp', 'numeric(18, 0)')) - ((DETALLE.CANTIDAD - LOTES.Col.value('@cp', 'numeric(18, 0)')) * 2)
		--	END CANTIDAD
		--   ,CASE 
		--		WHEN (DETALLE.CANTIDAD - LOTES.Col.value('@cp', 'numeric(18, 0)')) < 0 THEN 'Corrección valor'
		--		WHEN (DETALLE.CANTIDAD - LOTES.Col.value('@cp', 'numeric(18, 0)')) > 0 THEN 'Corrección valor'
		--	END 
		--FROM @oxml.nodes('//root/f') Tbl(Col)  
		--	INNER JOIN @oxmlLotes.nodes('//root/f') LOTES(Col)
		--		ON Tbl.Col.value('@pid', 'numeric(18, 0)') = LOTES.Col.value('@pid', 'numeric(18, 0)')
		--	LEFT JOIN @TABLA_DETALLE DETALLE
		--		ON LOTES.Col.value('@l', 'varchar(50)') = DETALLE.ID_Lote		
		
		INSERT INTO @TABLA_DETALLE_DIFERENCIA
		SELECT 	
			 LOTES.Col.value('@l', 'varchar(50)') --lote id
			,CASE 
				WHEN (DETALLE.CANTIDAD - LOTES.Col.value('@cp', 'numeric(18, 3)')) < 0 THEN ABS(DETALLE.CANTIDAD - LOTES.Col.value('@cp', 'numeric(18, 3)'))
				WHEN (DETALLE.CANTIDAD - LOTES.Col.value('@cp', 'numeric(18, 3)')) > 0 THEN (DETALLE.CANTIDAD - LOTES.Col.value('@cp', 'numeric(18, 3)')) - ((DETALLE.CANTIDAD - LOTES.Col.value('@cp', 'numeric(18, 3)')) * 2)
			END CANTIDAD
		   ,CASE 
				WHEN (DETALLE.CANTIDAD - LOTES.Col.value('@cp', 'numeric(18, 3)')) < 0 THEN 'Corrección valor'
				WHEN (DETALLE.CANTIDAD - LOTES.Col.value('@cp', 'numeric(18, 3)')) > 0 THEN 'Corrección valor'
			END 
		FROM @oxml.nodes('//root/f') Tbl(Col)  
			INNER JOIN @oxmlLotes.nodes('//root/f') LOTES(Col)
				ON Tbl.Col.value('@pid', 'numeric(18, 0)') = LOTES.Col.value('@pid', 'numeric(18, 0)')
			LEFT JOIN @TABLA_DETALLE DETALLE
				ON LOTES.Col.value('@l', 'varchar(50)') = DETALLE.ID_Lote;	
			
		INSERT INTO [dbo].Inventario_Detalle_Recepcion
		SELECT 	
			 @ID_Recepcion
			,LOTES.Col.value('@id', 'numeric(18, 0)') --nro linea
			,Tbl.Col.value('@pid', 'numeric(18, 0)') --Código producto
			,LOTES.Col.value('@c', 'numeric(18, 3)') --cantidad
			,LOTES.Col.value('@cs', 'numeric(18, 3)') --cantidad execede
			,LOTES.Col.value('@cp', 'numeric(18, 3)') --cantidad falta
			,LOTES.Col.value('@l', 'varchar(50)') --lote id
			,@Id_Org
			,CASE
				WHEN DETALLE.ID_TRX_Recep IS NULL THEN @ULTIMOFOLIO + ROW_NUMBER() OVER(ORDER BY DETALLE.ID_TRX_Recep ASC) - 1 --,TRANSACCION --MENOS UNO YA QUE SE AGREGA UNO AL NUEVO FOLIO AL FINAL DEL EJERCICIO
				WHEN DETALLE.ID_TRX_Recep IS NOT NULL THEN DETALLE.ID_TRX_Recep
			END
		FROM @oxml.nodes('//root/f') Tbl(Col)  
			INNER JOIN @oxmlLotes.nodes('//root/f') LOTES(Col)
				ON Tbl.Col.value('@pid', 'numeric(18, 0)') = LOTES.Col.value('@pid', 'numeric(18, 0)')
			LEFT JOIN @TABLA_DETALLE DETALLE
				ON LOTES.Col.value('@l', 'varchar(50)') = DETALLE.ID_Lote;	
		PRINT 'INSERTO A LA TABLA Inventario_Detalle_Recepcion';

		--OBTENER EL MAXIMO FOLIO QUE SE ALCANZÓ A REGISTRAR
		SET @NUEVOFOLIO = (SELECT MAX(TRANSACCIONADOS) + 1 FROM
		(SELECT 	
			 (SELECT ID FROM @RETORNO) ID_Recepcion
			,Tbl.Col.value('@id', 'numeric(18, 0)') NRO_LINEA --nro linea
			,Tbl.Col.value('@pid', 'numeric(18, 0)') PROD_ID --Código producto
			,LOTES.Col.value('@c', 'numeric(18, 3)') CANTIDAD --cantidad
			,LOTES.Col.value('@cs', 'numeric(18, 3)') CANT_EXCEDE --cantidad execede
			,LOTES.Col.value('@cp', 'numeric(18, 3)') CANT_FALTA --cantidad falta
			,LOTES.Col.value('@l', 'varchar(50)') LOTE_ID --lote id
			,@Id_Org ID_ORG
			,CASE
				WHEN DETALLE.ID_TRX_Recep IS NULL THEN @ULTIMOFOLIO + ROW_NUMBER() OVER(ORDER BY DETALLE.ID_TRX_Recep ASC) - 1 --,TRANSACCION --MENOS UNO YA QUE SE AGREGA UNO AL NUEVO FOLIO AL FINAL DEL EJERCICIO
				WHEN DETALLE.ID_TRX_Recep IS NOT NULL THEN DETALLE.ID_TRX_Recep
			END TRANSACCIONADOS
		FROM @oxml.nodes('//root/f') Tbl(Col)  
			INNER JOIN @oxmlLotes.nodes('//root/f') LOTES(Col)
				ON Tbl.Col.value('@pid', 'numeric(18, 0)') = LOTES.Col.value('@pid', 'numeric(18, 0)')
			LEFT JOIN @TABLA_DETALLE DETALLE
				ON LOTES.Col.value('@l', 'varchar(50)') = DETALLE.ID_Lote
			WHERE DETALLE.ID_TRX_Recep IS NULL) TABLA_TRANSACCIONADOS);								
		
		
		
		--ACTUALIZAMOS FINALMENTE LA TABLA DE FOLIOS
		IF (@NUEVOFOLIO IS NULL) BEGIN
			SET @NUEVOFOLIO = @ULTIMOFOLIO
		END 		
		
		UPDATE Inventario_Folios_Todos
		SET ID_TRX_Recep = @NUEVOFOLIO
		WHERE ID_TRX_Recep = @ULTIMOFOLIO;	
		
		PRINT 'NUEVO FOLIO:' + CAST(@NUEVOFOLIO AS VARCHAR(5))			
		
		/*
		--DETALLE RECEPCION
		SELECT 
			 Tbl.Col.value('@id', 'numeric(18, 0)') [linea]
			,Tbl.Col.value('@pid', 'numeric(18, 0)') [Producto Id]
			,Tbl.Col.value('@d', 'varchar(256)') [Descriptor]
			,Tbl.Col.value('@c', 'numeric(18, 0)') [Cant]
			,Tbl.Col.value('@cp', 'numeric(18, 0)') [Cant. Pen]
			,Tbl.Col.value('@cs', 'numeric(18, 0)') [Cant. Sobra]
			,Tbl.Col.value('@p', 'numeric(18, 0)') [Precio]	
			,Tbl.Col.value('@l', 'varchar(50)') [lote --En este campo está malo]
			,Tbl.Col.value('@oti', 'varchar(10)') [Origen Transacción Id]
			,Tbl.Col.value('@ot', 'varchar(100)') [Origen Transacción]
		FROM @oxml.nodes('//root/f') Tbl(Col)		
		--LOTES
		SELECT 
			 Tbl.Col.value('@id', 'numeric(18, 0)') [linea]
			,Tbl.Col.value('@l', 'varchar(50)') [lote]
			,Tbl.Col.value('@fv', 'varchar(10)') [Fecha Vencimiento]
			,Tbl.Col.value('@lp', 'varchar(100)') [Lote proveedor]
			,Tbl.Col.value('@pid', 'numeric(18, 0)') [Producto Id]
			,Tbl.Col.value('@c', 'numeric(18, 0)') [Cant]
			,Tbl.Col.value('@cp', 'numeric(18, 0)') [Cant. Pen]
			,Tbl.Col.value('@cs', 'numeric(18, 0)') [Cant. Sobra]
		FROM @oxmlLotes.nodes('//root/f') Tbl(Col)		
		*/
		
		
		--INSERCIÓN DETALLE DE TRANSACCION (KARDEX)
		/*
		SELECT * FROM Inventario_Lotes a
		SELECT * FROM [dbo].Inventario_Detalle_Recepcion
		SELECT * FROM Inventario_Detalle_Transacciones
		*/
		INSERT INTO [dbo].[Inventario_Detalle_Transacciones]
		SELECT
			 DETALLE.ID_TRX_RECEP
			,@FECHA_INSERT
			,DETALLE.Cod_Item
			,DETALLE.ID_Org
			,'1-RECEPCION' Cod_Subinv_Origen
			,'' Localizador_Origen
			,'' Cod_Subinv_Destino
			,'' Localizador_Destino
			,'RECEPCION MERCADERIA' Origen_TRX
			,0 Nro_Entrega
			,@Nro_Guia_Prov Documento
			,@Proveedor Razon_Social
			,DETALLE.ID_Lote
			,DETALLE.CANTIDAD_FALTA --QUEDÓ AHORA COMO CANTIDAD RECIBIDA --,DETALLE.CANTIDAD Cantidad_TRX
			,UM.Unidad_Medida_Abreviada Unidad_Medida
			,@ID_USRO ID_Usuario
			,PRODUCTO.Precio_Compra
		FROM Inventario_Detalle_Recepcion DETALLE
			INNER JOIN Inventario_Items PRODUCTO
				ON DETALLE.COD_ITEM = PRODUCTO.COD_ITEM AND DETALLE.ID_ORG = PRODUCTO.ID_ORG
			INNER JOIN Inventario_Unidad_Medida_Primaria UM
				ON PRODUCTO.ID_UM = UM.ID_UM
			LEFT JOIN Inventario_Detalle_Transacciones KARDEX
				ON DETALLE.ID_TRX_RECEP = KARDEX.ID_Origen_TRX AND DETALLE.ID_ORG = KARDEX.ID_ORG
		WHERE KARDEX.ID_Origen_TRX IS NULL;		
		
		IF (SELECT COUNT(*) FROM @TABLA_DETALLE_DIFERENCIA WHERE CORRECCION IS NOT NULL) > 0 BEGIN
		
			PRINT 'PASA POR AQUI'
			
			INSERT INTO [dbo].[Inventario_Detalle_Transacciones]
			SELECT
				 DETALLE.ID_TRX_RECEP
				,@FECHA_INSERT
				,DETALLE.Cod_Item
				,DETALLE.ID_Org
				,'1-RECEPCION' Cod_Subinv_Origen
				,'' Localizador_Origen
				,'' Cod_Subinv_Destino
				,'' Localizador_Destino
				,DIFERENCIA.CORRECCION Origen_TRX
				,0 Nro_Entrega
				,@Nro_Guia_Prov Documento
				,@Proveedor Razon_Social
				,DETALLE.ID_Lote
				,DIFERENCIA.CANTIDAD Cantidad_TRX
				,UM.Unidad_Medida_Abreviada Unidad_Medida
				,@ID_USRO ID_Usuario
				,PRODUCTO.Precio_Compra
			FROM Inventario_Detalle_Recepcion DETALLE
				INNER JOIN Inventario_Items PRODUCTO
					ON DETALLE.COD_ITEM = PRODUCTO.COD_ITEM AND DETALLE.ID_ORG = PRODUCTO.ID_ORG
				INNER JOIN Inventario_Unidad_Medida_Primaria UM
					ON PRODUCTO.ID_UM = UM.ID_UM
				INNER JOIN @TABLA_DETALLE_DIFERENCIA DIFERENCIA
					ON DETALLE.ID_LOTE = DIFERENCIA.ID_LOTE
				--LEFT JOIN Inventario_Detalle_Transacciones KARDEX
				--	ON DETALLE.ID_TRX_RECEP = KARDEX.ID_Origen_TRX AND DETALLE.ID_ORG = KARDEX.ID_ORG
				WHERE DIFERENCIA.CORRECCION IS NOT NULL
			--SELECT * FROM @TABLA_DETALLE_DIFERENCIA
		
		END
				
		--INSERCIÓN DE STOCK DE LOTES
		DELETE FROM [dbo].[Inventario_Stock_Lotes] 
		WHERE ID_LOTE IN (SELECT Tbl.Col.value('@l', 'varchar(50)') FROM @oxmlLotes.nodes('//root/f') Tbl(Col))
			AND Id_Org = @Id_Org AND ID_Localizador = (SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 20);
		
		INSERT INTO [dbo].[Inventario_Stock_Lotes]
		SELECT  DET.ID_Lote
			   ,(SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 20) ID_Localizador
			   ,@Id_Org
			   ,DET.CANTIDAD_FALTA --QUEDÓ AHORA COMO CANTIDAD RECIBIDA --,DET.CANTIDAD --En_Mano 
			   ,DET.CANTIDAD_FALTA [Disponible] --QUEDÓ AHORA COMO CANTIDAD RECIBIDA --,DET.CANTIDAD --Disponible
			   ,0 [Reserva]
			   ,@ID_USRO
			   ,@ID_USRO
			   ,@FECHA_UPDATE
			   ,@FECHA_UPDATE
		FROM Inventario_Detalle_Recepcion DET
			INNER JOIN @oxmlLotes.nodes('//root/f') Tbl(Col)
				ON DET.ID_Lote = Tbl.Col.value('@l', 'varchar(50)') AND DET.Id_Org = @Id_Org;
	
	
		/* --EJEMPLO UPDATE MASIVO
		UPDATE tCoches
		SET  marca = (SELECT CODIGO FROM tMarcas WHERE tMarcas.Marca = tCoches.Marca )
		WHERE marca IN ('FORD','RENAULT','SEAT');
		*/	
	
		/*
		SELECT * FROM Inventario_Lotes
		SELECT * FROM Inventario_Cabecera_Recepcion
		SELECT * FROM Inventario_Folios_Todos
		SELECT * FROM Inventario_Detalle_Recepcion
		SELECT * FROM Inventario_Detalle_Transacciones
		SELECT * FROM Inventario_Stock_Lotes
		*/			
		
	END		
		
	--SELECT @@TRANCOUNT --ROLLBACK --@FECHA_UPDATE
	
	COMMIT TRANSACTION
	
	IF @AGREGO = 1 BEGIN
		SELECT ID, 'RECIBIDO EN PULMON' ESTADO FROM @RETORNO;
		--SELECT @@TRANCOUNT
	END ELSE BEGIN
		SELECT 1 FILAS_AFECTADAS; --@@ROWCOUNT 
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
