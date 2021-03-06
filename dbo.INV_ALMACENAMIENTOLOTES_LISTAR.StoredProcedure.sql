USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_ALMACENAMIENTOLOTES_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_ALMACENAMIENTOLOTES_LISTAR 15, 17
CREATE PROCEDURE [dbo].[INV_ALMACENAMIENTOLOTES_LISTAR] 
	-- Add the parameters for the stored procedure here
	 @ID_REPCEPCION NUMERIC(18, 0)
	,@ID_Org numeric(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @t TABLE (resultado VARCHAR(250), id_localizador numeric(18, 0))
	DECLARE @tResumen TABLE (id_localizador numeric(18, 0))
	
	declare @tabla table(
	 Folio_Documento numeric(18, 0)
	,Id_recepcion numeric(18, 0)
	,Fecha_Recep varchar(10)
	,Cod_Item numeric(18, 0)
	,DESCRIPTOR_CORTA varchar(256)
	,ID_Lote varchar(50)
	,Lote_Proveedor varchar(50)
	,Fecha_Expira varchar(10)
	,cantidad numeric(18, 0)
	,RESPONSABLE VARCHAR(50)
	,SUBINV_ORIGEN varchar(50)	
	,LOCALIZADOR_ORIGEN varchar(50)	
	,volumen_total	numeric(18, 5)
	,x_docking numeric(18, 0)
	,SUGERIDO VARCHAR(250)		
	)
	
	
	DECLARE 
	 @Folio_Documento numeric(18, 0)
	,@Id_recepcion numeric(18, 0)
	,@Fecha_Recep varchar(10)
	,@Cod_Item numeric(18, 0)
	,@DESCRIPTOR_CORTA varchar(256)
	,@ID_Lote varchar(50)
	,@Lote_Proveedor varchar(50)
	,@Fecha_Expira varchar(10)
	,@cantidad numeric(18, 0)
	,@RESPONSABLE VARCHAR(50)	
	,@SUBINV_ORIGEN varchar(50)	
	,@LOCALIZADOR_ORIGEN varchar(50)
	,@volumen_total	numeric(18, 5)
	,@x_docking numeric(18, 0)


	-- Declaración del cursor
	DECLARE cLotes CURSOR FOR
	SELECT RECEP.FOLIO_DOCUMENTO
		  ,RECEP.ID_RECEPCION
		  ,ISNULL(Convert(varchar(10),CONVERT(date,RECEP.FECHA_RECEP,106),103), '') FECHA_RECEP
		  ,DET.Cod_Item
		  ,PRODUCTO.DESCRIPTOR_CORTA
		  ,LOTE.ID_Lote --Lote interno
		  ,LOTE.Lote_Proveedor
		  ,ISNULL(Convert(varchar(10),CONVERT(date,LOTE.Fecha_Expira,106),103), '') Fecha_Expira --Fecha vencimiento		  
		  ,STOCK.EN_MANO
		  ,RECEP.RESPONSABLE
		  ,'1-RECEPCION' SUBINV_ORIGEN
		  ,'' LOCALIZADOR_ORIGEN
		  --,'' SUBINV_DESTINO --SUGERIDOS
		  --,'' LOCALIZADOR_DESTINO --SUGERIDOS
		  --,DBO.FNC_GET_LOC_SUGERIDO(PRODUCTO.VOLUMEN * STOCK.EN_MANO) SUGERIDO --SUGERIDO
		  ,CAST((PRODUCTO.VOLUMEN * STOCK.EN_MANO) AS NUMERIC(18, 5)) volumen_total
		  ,CASE WHEN TRX.ID_LOTE IS NULL THEN 0 ELSE 1 END XDOCKING
	  FROM dbo.Inventario_Lotes LOTE
		INNER JOIN Inventario_Detalle_Recepcion DET
			ON LOTE.Cod_Item = DET.Cod_Item AND LOTE.ID_Lote = DET.ID_Lote AND LOTE.ID_Org = DET.ID_Org
		INNER JOIN Inventario_Cabecera_Recepcion RECEP
			ON DET.ID_Recepcion = RECEP.ID_Recepcion AND DET.ID_Org = RECEP.ID_Org
		INNER JOIN Inventario_Items PRODUCTO
			ON DET.Cod_Item = PRODUCTO.COD_ITEM AND DET.ID_Org = PRODUCTO.ID_Org
		INNER JOIN Inventario_Stock_Lotes STOCK
			ON det.ID_Lote = stock.id_lote and det.ID_Lote = stock.id_lote
		--VERIFICA SI EXISTE UN PEDIDO DE DESPACHO LANZADO Y SI EL LOTE SE ENCUENTRA EN RECEPCIÓN, SI ES ASÍ, NO SE ALMACENA
		LEFT JOIN INVENTARIO_DETALLE_TRX_PEDIDOS TRX
			ON LOTE.ID_LOTE = TRX.ID_LOTE AND STOCK.ID_LOCALIZADOR = TRX.ID_LOCALIZADOR_ORIGEN AND TRX.COD_ESTADO_LINEA IN(10) AND LOTE.ID_ORG = TRX.ID_ORG
	  WHERE --LOTE.Cod_Item = @Cod_Item AND 
		RECEP.ID_Org = @ID_Org AND RECEP.ID_Recepcion = @ID_REPCEPCION AND STOCK.ID_LOCALIZADOR = (SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 20) 
		AND STOCK.EN_MANO > 0 
		--AND STOCK.DISPONIBLE > 0
	  ORDER BY DET.Nro_Linea ASC
	  
	-- Apertura del cursor
	OPEN cLotes

	-- Lectura de la primera fila del cursor
	FETCH cLotes INTO
	 @Folio_Documento
	,@Id_recepcion
	,@Fecha_Recep
	,@Cod_Item
	,@DESCRIPTOR_CORTA
	,@ID_Lote
	,@Lote_Proveedor
	,@Fecha_Expira
	,@cantidad 
	,@RESPONSABLE
	,@SUBINV_ORIGEN
	,@LOCALIZADOR_ORIGEN
	,@volumen_total
	,@x_docking

	WHILE (@@FETCH_STATUS = 0 ) BEGIN
	
	DELETE FROM @t;
	INSERT INTO @t	
	exec SP_GET_LOC_SUGERIDO @volumen_total
	--PRINT 'HOLA'
	insert into @tResumen
	select id_localizador from @t;
	
	insert into @tabla
	select @Folio_Documento
	,@Id_recepcion
	,@Fecha_Recep
	,@Cod_Item
	,@DESCRIPTOR_CORTA
	,@ID_Lote
	,@Lote_Proveedor
	,@Fecha_Expira
	,@cantidad 
	,@RESPONSABLE	
	,@SUBINV_ORIGEN
	,@LOCALIZADOR_ORIGEN	
	,@volumen_total
	,@x_docking
	,(SELECT resultado FROM @T);

	-- Lectura de la siguiente fila del cursor
	FETCH cLotes INTO
	 @Folio_Documento
	,@Id_recepcion
	,@Fecha_Recep
	,@Cod_Item
	,@DESCRIPTOR_CORTA
	,@ID_Lote
	,@Lote_Proveedor
	,@Fecha_Expira
	,@cantidad 
	,@RESPONSABLE	
	,@SUBINV_ORIGEN
	,@LOCALIZADOR_ORIGEN
	,@volumen_total
	,@x_docking
	
	

	END	  
	  
	  
	-- Cierre del cursor
	CLOSE cLotes

	-- Liberar los recursos
	DEALLOCATE cLotes	  


	--Al finzalizar el ejercicio se actualiza el campo sugerido (Esto si solamente una persona recepciona.)
	UPDATE Inventario_SubInv_Localizadores
	SET SUGERIDO = 0
	WHERE ID_LOCALIZADOR IN(SELECT id_localizador FROM @tresumen);	

	
	SELECT * FROM @tabla  
	  
	  
	  /*
	  
	  SELECT * FROM Inventario_Stock_Lotes
	  
SELECT  *  FROM    
OPENQUERY('EXEC MyProc @parameters')
	  
	SELECT [ID_Lote]
		  ,[Fecha_Origen]
		  ,[Fecha_Expira]
		  ,[Lote_Proveedor]
		  ,[Cod_Item]
		  ,[ID_Org]
		  ,[ID_Usro_Crea]
		  ,[ID_Usro_Act]
		  ,[Fech_Creacion]
		  ,[Fech_Actualiza]
	  FROM [dbo].[Inventario_Lotes]	  
	  
	SELECT [ID_Recepcion]
		  ,[Nro_Linea]
		  ,[Cod_Item]
		  ,[Cantidad]
		  ,[Cantidad_Excede]
		  ,[Cantidad_Falta]
		  ,[ID_Lote]
		  ,[ID_Org]
		  ,[ID_TRX_Recep]
	  FROM [dbo].[Inventario_Detalle_Recepcion]	  
	  
	  
		SELECT [Folio_Documento]
			  ,[Id_Docu]
			  ,[Nro_Linea]
			  ,[Descriptor]
			  ,[Cod_Item]
			  ,[Cantidad]
			  ,[Cantidad_Pdte]
			  ,[Precio]
			  ,[Id_Org]
			  ,[ID_Lote]
		  FROM [dbo].[Inventario_Detalle_documentos]	  
	   
	  
	  
	  SELECT * FROM Inventario_Folios_Todos
	  
	  */
	  
	  
	  
END
GO
