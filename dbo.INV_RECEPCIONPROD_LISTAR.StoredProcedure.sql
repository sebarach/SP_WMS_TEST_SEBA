USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_RECEPCIONPROD_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_RECEPCIONPROD_LISTAR 201, 17
CREATE PROCEDURE [dbo].[INV_RECEPCIONPROD_LISTAR]
	-- Add the parameters for the stored procedure here	
	 @Folio_Documento NUMERIC(18, 0)
	--,@Id_Recepcion NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Id_Recepcion NUMERIC(18, 0);
	
	SET @Id_Recepcion = (SELECT ID_RECEPCION FROM Inventario_Cabecera_Recepcion 
						 WHERE Folio_Documento = @Folio_Documento 
							AND ID_ORG = @ID_ORG 
							AND ID_DOCU = 10);

	IF @Id_Recepcion IS NULL BEGIN
	
		SELECT C.ID_PROPIETARIO
			  ,C.Id_DUEÑO
			  --,
			  ,D.Nro_Linea
			  ,D.Descriptor
			  ,D.Cod_Item
			  ,D.Cantidad
			  ,0 CANTIDAD_FALTA --CALCULADO Cantidad Recibida
			  ,0 CANTIDAD_EXCEDE --CALCULADO Excede/Falta
			  ,D.Precio
			  ,D.ID_Lote
			  ,1 ID_ORIGEN_TRX
			  ,'RECEPCION MERCADERIA' ORIGEN_TRX
		  FROM dbo.Inventario_Detalle_Documentos D
			INNER JOIN Inventario_CABECERA_Documentos C
				ON D.FOLIO_DOCUMENTO = C.FOLIO_DOCUMENTO AND D.ID_DOCU = C.ID_DOCU AND D.ID_ORG = C.ID_ORG
		  WHERE D.Id_Docu = 10 
			AND D.Folio_Documento = @Folio_Documento AND D.ID_ORG = @ID_ORG --AND C.VIGENCIA = 'S'
	      ORDER BY D.Nro_Linea ASC
	END
	ELSE BEGIN
	
		SELECT C.ID_PROPIETARIO
			  ,C.Id_DUEÑO
			  --,
			  ,SOL.Nro_Linea
			  ,SOL.Descriptor
			  ,SOL.Cod_Item
			  ,ISNULL(SUM(REC.Cantidad), 0) Cantidad
			  ,ISNULL(SUM(REC.CANTIDAD_FALTA), 0) CANTIDAD_FALTA --CALCULADO Cantidad Recibida
			  ,ISNULL(SUM(REC.CANTIDAD_EXCEDE), 0) CANTIDAD_EXCEDE --CALCULADO Excede/Falta
			  ,SOL.Precio
			  ,NULL ID_Lote
			  ,1 ID_ORIGEN_TRX
			  ,'RECEPCION MERCADERIA' ORIGEN_TRX
		  FROM dbo.Inventario_Detalle_Documentos SOL
			INNER JOIN Inventario_CABECERA_Documentos C
				ON SOL.FOLIO_DOCUMENTO = C.FOLIO_DOCUMENTO AND SOL.ID_DOCU = C.ID_DOCU AND SOL.ID_ORG = C.ID_ORG
			LEFT JOIN Inventario_Detalle_Recepcion REC
				ON SOL.Cod_Item = REC.COD_ITEM  AND SOL.ID_ORG = REC.ID_ORG		
		  WHERE SOL.Id_Docu = 10 
			AND SOL.Folio_Documento = @Folio_Documento AND SOL.ID_ORG = @ID_ORG --AND C.VIGENCIA = 'S'
			AND REC.ID_RECEPCION = @Id_Recepcion
			GROUP BY C.ID_PROPIETARIO, C.Id_DUEÑO, SOL.Nro_Linea, SOL.Descriptor, SOL.Cod_Item, SOL.Precio
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
