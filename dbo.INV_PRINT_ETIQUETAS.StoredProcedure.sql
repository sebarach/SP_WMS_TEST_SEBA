USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_PRINT_ETIQUETAS]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_PRINT_ETIQUETAS]
	-- Add the parameters for the stored procedure here
--DECLARE
	 @ID_RECEPCION NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--SET @ID_DOCU = 10
	--SET @ID_RECEPCION = 15
	--SET @ID_ORG = 17

    -- Insert statements for procedure here
	SELECT 
		 PROD.DESCRIPTOR_CORTA Descriptor
		,PROP.NOMBRE Propietario
		,CONTACTO.NOMBRES + ' ' + APELLIDO_PATERNO + ' ' + APELLIDO_MATERNO Dueno
		,LOTE.COD_ITEM Sku
		,DET.CANTIDAD_FALTA CantidadLote
		,UM.UNIDAD_MEDIDA_ABREVIADA Udm
		,DET.ID_LOTE Lote
		,LOTE.LOTE_PROVEEDOR LoteProvedor
		,ISNULL(Convert(varchar(10),CONVERT(date,CAB_REC.Fecha_RECEP,106),103), '') FechaRecepcion
		,CAB_REC.NRO_GUIA_PROV NroDocumento
		,CAB_REC.PROVEEDOR Proveedor
		,PROD.UNIDADES_CAJAS NroBultos
		,PROD.TOTAL_CAJAS_PALLETS CantidadCaja
		,CAB_REC.RESPONSABLE Responsable
	FROM dbo.Inventario_Cabecera_Documentos CAB_DOC
		INNER JOIN Inventario_Cabecera_Recepcion CAB_REC
			ON CAB_DOC.Folio_Documento = CAB_REC.FOLIO_DOCUMENTO AND CAB_DOC.Id_Org = CAB_REC.ID_ORG
		INNER JOIN Inventario_DETALLE_Recepcion DET
			ON CAB_REC.ID_RECEPCION = DET.ID_RECEPCION AND CAB_REC.ID_ORG = DET.ID_ORG
		INNER JOIN Inventario_Lotes LOTE
			ON DET.ID_LOTE = LOTE.ID_LOTE AND DET.ID_ORG = LOTE.ID_ORG
		INNER JOIN Inventario_Items PROD
			ON LOTE.COD_ITEM = PROD.COD_ITEM AND LOTE.ID_ORG = PROD.ID_ORG
		INNER JOIN Inventario_Unidad_Medida_Primaria UM
			ON PROD.ID_UM = UM.ID_UM
		INNER JOIN Adm_System_Dueños DUENO
			ON CAB_DOC.Id_Dueño = DUENO.ID_DUEÑO AND CAB_DOC.Id_Org = DUENO.ID_ORG 
		INNER JOIN Adm_System_Contactos CONTACTO
			ON DUENO.ID_CONTACTO = CONTACTO.ID_CONTACTO AND DUENO.ID_ORG = CONTACTO.ID_ORG 
		INNER JOIN Adm_System_Holding PROP
			ON DUENO.ID_HOLDING_PROPIETARIO = PROP.ID_HOLDING AND DUENO.Id_Org = PROP.ID_ORG AND PROP.ESPROPIETARIO = 1
	WHERE CAB_DOC.ID_DOCU = 10 
		AND CAB_REC.ID_RECEPCION = @ID_RECEPCION
		AND CAB_DOC.VIGENCIA = 'S'
		AND DUENO.VIGENCIA = 'S'
		AND PROP.VIGENCIA = 'S'
		AND PROP.ESPROPIETARIO = 1
	ORDER BY DET.ID_LOTE ASC
	
	--CONTACTO.NOMBRES + ' ' + APELLIDO_PATERNO + ' ' + APELLIDO_MATERNO Dueno
	
	SELECT * FROM Adm_System_Contactos
	
	SELECT * FROM Adm_System_Dueños
	
	SELECT * FROM Adm_System_Holding
		
	/*
	SELECT * FROM INVENTARIO_CABECERA_DOCUMENTOS WHERE ID_DOCU = 10
	
	SELECT * FROM Inventario_Cabecera_Recepcion
	
	SELECT * FROM Inventario_DETALLE_Recepcion
	
	SELECT * FROM Inventario_Lotes
	
	SELECT * FROM Inventario_Items
	
	SELECT * FROM Inventario_Unidad_Medida_Primaria	
	
	SELECT * FROM Adm_System_Contactos
	
	SELECT * FROM Adm_System_Dueños
	
	SELECT * FROM Adm_System_Holding	
	*/	
		
		
		
		
END
GO
