USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_PEDIDOPROD_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_PEDIDOPROD_LISTAR 303, 17
CREATE PROCEDURE [dbo].[INV_PEDIDOPROD_LISTAR]
	-- Add the parameters for the stored procedure here	
	 @Folio_Documento NUMERIC(18, 0)
	,@nroPedido NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0) --[INV_PEDIDOPROD_LISTAR]  9162,9108,17
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Id_Pedido NUMERIC(18, 0);
	
	IF @nroPedido > 0 BEGIN
		SET @Id_Pedido = @nroPedido;
	END
	ELSE BEGIN
		SET @Id_Pedido = (SELECT ID_NROPEDIDO FROM Inventario_Cabecera_Pedidos 
							 WHERE Folio_Documento = @Folio_Documento 
								AND ID_ORG = @ID_ORG);
	END

	IF @Id_Pedido IS NULL BEGIN	
		SELECT --C.ID_PROPIETARIO
			  --,C.Id_DUEÑO
			  --,
			   D.Nro_Linea
			  ,D.Cod_Item
			  ,D.Descriptor
			  ,D.Cantidad CANT_PEDIDA    --Cantidad pedida
			  ,D.Cantidad CANT_PENDIENTE --Cantidad pendiente
			  ,0 CANT_PICKEADA 
			  ,0 CANT_DESPACHO 
			  ,0 ID_TRX_PEDIDO
			  ,ISNULL('De ' + REPLACE(REPLACE(CONVERT(varchar(20), (CAST(GRUPO.MONTO_DESDE AS money)), 1), '.00', ''), ',', '.') + ' a ' + 
			   REPLACE(REPLACE(CONVERT(varchar(20), (CAST(GRUPO.MONTO_HASTA AS money)), 1), '.00', ''), ',', '.'), '') RANGO
			  ,ISNULL(GRUPO.MONTO_HASTA, 0) MONTO_HASTA	
			  ,ISNULL((PROD.PRECIO_COMPRA * D.Cantidad), 0) PRECIO				  
		  FROM dbo.Inventario_Detalle_Documentos D
			INNER JOIN Inventario_CABECERA_Documentos C
				ON D.FOLIO_DOCUMENTO = C.FOLIO_DOCUMENTO AND D.ID_DOCU = C.ID_DOCU AND D.ID_ORG = C.ID_ORG
			INNER JOIN INVENTARIO_ITEMS PROD
				ON D.COD_ITEM = PROD.COD_ITEM AND D.ID_ORG = PROD.ID_ORG				
			LEFT JOIN Adm_System_Asignacion_Grupo_Aprobacion BANDA
				ON C.ID_PROPIETARIO = BANDA.ID_HOLDING_PROPIETARIO
					AND C.ID_DUEÑO = BANDA.ID_DUEÑO
					AND C.ID_ORG = BANDA.ID_ORG
			LEFT JOIN Adm_System_Grupo_Aprobacion GRUPO
				ON BANDA.ID_GRUPO = GRUPO.ID_GRUPO AND BANDA.ID_ORG = GRUPO.ID_ORG					
		  WHERE D.Id_Docu = 20 
			AND D.Folio_Documento = @Folio_Documento AND D.ID_ORG = @ID_ORG --AND C.VIGENCIA = 'S'
	      ORDER BY D.Nro_Linea ASC
	END
	ELSE BEGIN
	
		SELECT --C.ID_PROPIETARIO
			  --,C.Id_DUEÑO
			  --,
			   PED.Nro_Linea
			  ,PED.Cod_Item
			  ,SOL.Descriptor
			  ,PED.CANT_PEDIDA    --Cantidad pedida
			  ,PED.CANT_PENDIENTE --Cantidad pendiente
			  ,PED.CANT_PICKEADA 
			  ,PED.CANT_DESPACHO 
			  ,PED.ID_TRX_PEDIDO
			  ,ISNULL('De ' + REPLACE(REPLACE(CONVERT(varchar(20), (CAST(GRUPO.MONTO_DESDE AS money)), 1), '.00', ''), ',', '.') + ' a ' + 
			   REPLACE(REPLACE(CONVERT(varchar(20), (CAST(GRUPO.MONTO_HASTA AS money)), 1), '.00', ''), ',', '.'), '') RANGO
			  ,ISNULL(GRUPO.MONTO_HASTA, 0) MONTO_HASTA	
			  ,ISNULL((PROD.PRECIO_COMPRA * PED.CANT_PEDIDA), 0) PRECIO		  
		  FROM dbo.Inventario_Detalle_Documentos SOL
			INNER JOIN Inventario_Detalle_Pedidos PED
				ON SOL.COD_ITEM = PED.COD_ITEM AND SOL.ID_ORG = PED.ID_ORG AND PED.ID_NROPEDIDO = @Id_Pedido
			INNER JOIN Inventario_CABECERA_Pedidos CABPED
				ON PED.ID_NROPEDIDO = CABPED.ID_NROPEDIDO AND PED.ID_ORG = CABPED.ID_ORG
			INNER JOIN Inventario_Cabecera_Documentos DOC
				ON SOL.FOLIO_DOCUMENTO = DOC.FOLIO_DOCUMENTO AND doc.Id_Docu = 20
			INNER JOIN INVENTARIO_ITEMS PROD
				ON PED.COD_ITEM = PROD.COD_ITEM AND PED.ID_ORG = PROD.ID_ORG								
			LEFT JOIN Adm_System_Asignacion_Grupo_Aprobacion BANDA
				ON DOC.ID_PROPIETARIO = BANDA.ID_HOLDING_PROPIETARIO
					AND DOC.ID_DUEÑO = BANDA.ID_DUEÑO
					AND DOC.ID_ORG = BANDA.ID_ORG
			LEFT JOIN Adm_System_Grupo_Aprobacion GRUPO
				ON BANDA.ID_GRUPO = GRUPO.ID_GRUPO AND BANDA.ID_ORG = GRUPO.ID_ORG				
		  WHERE SOL.Id_Docu = 20
			AND SOL.Folio_Documento = @Folio_Documento AND SOL.ID_ORG = @ID_ORG --AND C.VIGENCIA = 'S'
			--GROUP BY C.ID_PROPIETARIO, C.Id_DUEÑO, SOL.Nro_Linea, SOL.Descriptor, SOL.Cod_Item, SOL.Precio
			ORDER BY SOL.Nro_Linea ASC
	
	END	
		
	/*	
	
	SELECT * FROM Inventario_CABECERA_Documentos
	
	SELECT * FROM dbo.Inventario_Detalle_Documentos
	
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
	
	
SELECT TOP 1000 [ID_Lote]
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
  
  
SELECT [ID_TRX]
      ,[ID_Origen_TRX]
      ,[Fecha_TRX]
      ,[Cod_Item]
      ,[ID_Org]
      ,[Cod_Subinv_Origen]
      ,[Localizador_Origen]
      ,[Cod_Subinv_Destino]
      ,[Localizador_Destino]
      ,[Origen_TRX]
      ,[Nro_Entrega]
      ,[Documento]
      ,[Razon_Social]
      ,[ID_Lote]
      ,[Cantidad_TRX]
      ,[Unidad_Medida]
      ,[ID_Usuario]
      ,[Precio_Compra]
  FROM [dbo].[Inventario_Detalle_Transacciones]


SELECT [ID_Org]
      ,[Folio_OT]
      ,[Folio_Prefijo_Lote]
      ,[Correlativo_Lote]
      ,[Folio_Num_Entrega]
      ,[ID_TRX_Pedido]
      ,[ID_TRX_Recep]
  FROM [dbo].[Inventario_Folios_Todos]


  
SELECT [ID_Lote]
      ,[ID_Localizador]
      ,[ID_Org]
      ,[En_Mano]
      ,[Disponible]
      ,[Reserva]
      ,[ID_Usro_Crea]
      ,[ID_Usro_Act]
      ,[Fech_Creacion]
      ,[Fech_Actualiza]
  FROM [dbo].[Inventario_Stock_Lotes]


  
  
  
  
	*/
	
	
	
	
END
GO
