USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_PEDIDO_VERSUGERIDOS]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>

-- Create date: 02/09/2018
-- Description:	Se Agrega Unidad de medida.

-- =============================================
--EXEC INV_PEDIDO_VERSUGERIDOS 7819, 17
CREATE PROCEDURE [dbo].[INV_PEDIDO_VERSUGERIDOS] 
	-- Add the parameters for the stored procedure here
	 @ID_NROPEDIDO NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*
	SELECT * FROM Inventario_Detalle_Trx_Pedidos
	
	SELECT * FROM dbo.Inventario_Pedido_Movimiento
	*/
	
	SELECT --ID_NroPedido
		   PROD.Cod_Item
		  ,PROD.DESCRIPTOR_CORTA
		  ,DETALLE.Nro_Linea
		  ,DETALLE.Nro_SubLinea
		  ,DETALLE.ID_Pdo_Movmto
		  ,DETALLE.Cant_Pedida
		  ,DETALLE.Cant_Pendiente
		  ,DETALLE.Cant_Pickeada
		  ,DETALLE.Cant_Despacho
		  ,TIPO_UNIDAD.Unidad_Medida
		  ,DETALLE.ID_Lote
		  ,DETALLE.ID_Localizador_Origen
		  ,LOC.COMBINACION_LOCALIZADOR Localizador_Origen
		  ,DETALLE.ID_Localizador_Destino
		  ,'STAGE' Localizador_Destino
		  --,ID_TRX_Pedido
		  --,Nro_Entrega
		  ,EST_LINEA.NOMBRE_Estado_Linea
		  ,DETALLE.Nomb_Sgte_Estado
		  --,Fech_Creacion
		  --,Fech_Actualiza
		  --,ID_Usro_Crea
		  --,ID_Usro_Act
		  ,LOTE.LOTE_PROVEEDOR
		  ,SUBINV.DESCRIPCION SUBINVENTARIO
		  ,(SELECT CRUZ.VALOR_REFERENCIA FROM Inventario_Referencias_Cruzadas CRUZ
		    WHERE PROD.Cod_Item = CRUZ.COD_ITEM AND PROD.ID_Org = CRUZ.ID_Org
			AND CRUZ.ID_REF_PRED = 1003) SkuAntiguo
		  ,ISNULL(CONVERT(VARCHAR(10),CONVERT(DATE,LOTE.FECHA_EXPIRA,106),103), '') FechaVencimiento
		  ,PROP.NOMBRE Propietario
		  ,CONTACTO.NOMBRES + ' ' + CONTACTO.APELLIDO_PATERNO + ' ' + CONTACTO.APELLIDO_MATERNO Dueno
		  ,DIR.CALLE + ' ' + '#' + DIR.NUMERO + ' ' + COMUNA.NOMBRE Direccion	
			,CASE 
				WHEN DATEDIFF(DAY, LOTE.FECHA_EXPIRA + PROD.DIAS_EN_ESTANTE, GETDATE()) >= 0 THEN 'S' 
				ELSE 'N'
			 END VENCIDO
	FROM Inventario_Detalle_Trx_Pedidos DETALLE
		INNER JOIN Inventario_Items PROD
			ON DETALLE.Cod_Item = PROD.COD_ITEM AND DETALLE.ID_Org = PROD.ID_ORG
		INNER JOIN Inventario_Unidad_Medida_Primaria TIPO_UNIDAD
			ON TIPO_UNIDAD.ID_UM = PROD.ID_UM
		INNER JOIN Inventario_Items_Prop_Dueños PROPDUENO
			ON PROD.COD_ITEM = PROPDUENO.COD_ITEM  
		INNER JOIN Inventario_Estado_Linea_Pedidos EST_LINEA
			ON DETALLE.Cod_Estado_Linea = EST_LINEA.COD_ESTADO_LINEA 
		INNER JOIN Inventario_SubInv_Localizadores LOC
			ON DETALLE.ID_Localizador_Origen = LOC.ID_Localizador AND DETALLE.ID_Org = LOC.ID_ORG
		INNER JOIN Inventario_Lotes LOTE
			ON DETALLE.ID_Lote = LOTE.ID_LOTE AND DETALLE.ID_Org = LOTE.ID_ORG AND PROPDUENO.ID_DUEÑO = LOTE.ID_DUEÑO
		INNER JOIN Inventario_SubInventarios SUBINV
			ON LOC.ID_SUBINV = SUBINV.ID_SUBINV
		--Información cabecera de impresión
		INNER JOIN Inventario_CABECERA_Pedidos CABPED
			ON DETALLE.ID_NROPEDIDO = CABPED.ID_NROPEDIDO AND DETALLE.ID_ORG = CABPED.ID_ORG	
		INNER JOIN INVENTARIO_CABECERA_DOCUMENTOS CABDOC
			ON CABPED.FOLIO_DOCUMENTO = CABDOC.FOLIO_DOCUMENTO AND CABPED.ID_ORG = CABDOC.ID_ORG AND CABDOC.ID_DOCU = 20
		INNER JOIN ADM_SYSTEM_HOLDING PROP
			ON PROPDUENO.ID_PROPIETARIO = PROP.ID_HOLDING AND PROPDUENO.ID_ORG = PROP.ID_ORG AND PROP.ESPROPIETARIO = 1
		INNER JOIN ADM_SYSTEM_DUEÑOS DUENO
			ON PROPDUENO.ID_DUEÑO = DUENO.ID_DUEÑO AND PROPDUENO.ID_ORG = DUENO.ID_ORG
		INNER JOIN Adm_System_Contactos CONTACTO
			ON DUENO.ID_CONTACTO = CONTACTO.ID_CONTACTO AND DUENO.ID_ORG = CONTACTO.ID_ORG			
		INNER JOIN ADM_SYSTEM_HOLDING CLISUC
			ON CABDOC.ID_CLISUC = CLISUC.ID_HOLDING AND PROPDUENO.ID_ORG = CLISUC.ID_ORG
		INNER JOIN Adm_System_Direcciones DIR
			ON CLISUC.ID_DIRECCION = DIR.ID_DIRECCION
		INNER JOIN Adm_System_Comunas COMUNA
			ON DIr.ID_COMUNA = COMUNA.ID_COMUNA	
	WHERE DETALLE.ID_NROPEDIDO = @ID_NROPEDIDO 
		AND DETALLE.ID_ORG = @ID_ORG	
		--AND DETALLE.Nomb_Sgte_Estado != 'Enviado' 
		--and DETALLE.Nomb_Sgte_Estado != 'Cancelada'
		--and est_linea.Nombre_Estado_Linea != 'En Etapas/Con Seleccion Confirmada'
		--AND CRUZ.ID_REF_PRED = 1003
	ORDER BY DETALLE.NRO_LINEA ASC, DETALLE.NRO_SUBLINEA ASC


	--SELECT * FROM Inventario_SubInv_Localizadores
	
	--SELECT * FROM Inventario_SubInventarios

	
	
END
GO
