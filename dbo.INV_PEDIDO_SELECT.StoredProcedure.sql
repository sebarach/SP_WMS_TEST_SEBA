USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_PEDIDO_SELECT]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_PEDIDO_SELECT -1, 0, 17 
CREATE PROCEDURE [dbo].[INV_PEDIDO_SELECT]
	-- Add the parameters for the stored procedure here	
	 @Folio_Documento NUMERIC(18, 0)
	,@ID_Pedido NUMERIC(18, 0)
	--,@Id_Docu NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--Búsqueda solicitudes
	
	IF @Folio_Documento = -1 BEGIN

		SELECT DISTINCT CAB.Folio_Documento
			  ,CAB.Id_Docu
			  ,CAB.Id_Propietario
			  ,PROP.NOMBRE PROPIETARIO
			  ,CAB.Id_Dueño
			  ,CONTACTO.Nombres + ' ' + Apellido_Paterno CONTACTO_NOMBRE
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Solicitud,106),103), '') Fecha_Solicitud --Sistema
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Entrega,106),103), '') Fecha_Entrega
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Vencimiento,106),103), '') Fecha_Vencimiento
			  ,0 ID_PROVINCIA
			  ,'' PROVINCIA
			  ,0 ID_COMUNA
			  ,'' COMUNA
			  ,0 Id_Direccion
			  ,'' DIRECCION --CASE WHEN CAB.Id_Direccion > 0 THEN DIR.CALLE + ', #' + DIR.NUMERO ELSE '' END DIRECCION
			  --,PEDIDO.Nota	  
			  ,CAB.ID_ESTADO
			  ,EST.Estado
			  --DATOS PEDIDO
			  ,isnull(PEDIDO.Id_NROPEDIDO, 0) Id_NROPEDIDO
			  ,ISNULL(Convert(varchar(10),CONVERT(date,PEDIDO.Fecha_EMISION,106),103), '') Fecha_EMISION
			  ,ISNULL(PEDIDO.ESTADO, '') ESTADO_PEDIDO
			  ,ISNULL(PEDIDO.VIGENCIA, '') VIGENCIA_PEDIDO
			  ,ISNULL(TRX_PEDIDOS.COD_ITEM, 0) PEDIDO_LANZADO
			  ,CAB.Nombre_Destinatario
		  FROM dbo.Inventario_Cabecera_Documentos CAB 
			INNER JOIN dbo.Adm_System_Holding PROP
				ON CAB.Id_Propietario = PROP.ID_HOLDING AND PROP.EsPropietario = 1 AND PROP.ID_TIPO_CONTACTO = 1 AND PROP.VIGENCIA = 'S'
			INNER JOIN dbo.Adm_System_Dueños DUENO
				ON CAB.Id_Dueño = DUENO.ID_Dueño AND DUENO.Vigencia = 'S'
			INNER JOIN dbo.Adm_System_Contactos CONTACTO
				ON DUENO.ID_Contacto = CONTACTO.ID_Contacto AND CONTACTO.VIGENCIA = 'S'
			INNER JOIN Inventario_Estado_Documentos EST
				ON CAB.ID_ESTADO = EST.Id_Estado
			--INNER JOIN Adm_System_Direcciones DIR
			--	ON CAB.ID_DIRECCION = DIR.ID_DIRECCION AND CAB.Id_Org = DIR.ID_ORG
			--INNER JOIN Adm_System_Comunas COM
			--	ON DIR.ID_COMUNA = COM.ID_COMUNA
			--INNER JOIN Adm_System_Provincias PROV
			--	ON COM.ID_PROVINCIA = PROV.ID_PROVINCIA				
			LEFT JOIN Inventario_Cabecera_Pedidos PEDIDO
				ON CAB.ID_ORG = PEDIDO.ID_ORG AND CAB.Folio_Documento = PEDIDO.Folio_Documento AND PEDIDO.ESTADO <> 'ANULADO'
			LEFT JOIN Inventario_Detalle_Trx_Pedidos TRX_PEDIDOS
				ON PEDIDO.ID_NROPEDIDO = TRX_PEDIDOS.ID_NROPEDIDO AND PEDIDO.ID_ORG = TRX_PEDIDOS.ID_ORG AND TRX_PEDIDOS.NRO_LINEA = 1						
		  WHERE CAB.Id_Docu = 20 --AND CAB.ID_ESTADO > 100
			AND CAB.ID_ORG = @ID_ORG
			AND CAB.Vigencia = 'S'
			--AND PEDIDO.VIGENCIA = 'S'
			--AND CAST(CAB.Folio_Documento AS VARCHAR(18)) LIKE CAST(@Folio_Documento AS VARCHAR(18)) + '%'
			ORDER BY Folio_Documento ASC

	END
	
	IF @Folio_Documento > 0 BEGIN

		SELECT DISTINCT CAB.Folio_Documento
			  ,CAB.Id_Docu
			  ,CAB.Id_Propietario
			  ,PROP.NOMBRE PROPIETARIO
			  ,CAB.Id_Dueño
			  ,CONTACTO.Nombres + ' ' + Apellido_Paterno  CONTACTO_NOMBRE
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Solicitud,106),103), '') Fecha_Solicitud --Sistema
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Entrega,106),103), '') Fecha_Entrega
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Vencimiento,106),103), '') Fecha_Vencimiento
			  ,0 ID_PROVINCIA
			  ,'' PROVINCIA
			  ,0 ID_COMUNA
			  ,'' COMUNA
			  ,0 Id_Direccion
			  ,'' DIRECCION --CASE WHEN CAB.Id_Direccion > 0 THEN DIR.CALLE + ', #' + DIR.NUMERO ELSE '' END DIRECCION
			  --,PEDIDO.Nota	  
			  ,CAB.ID_ESTADO
			  ,EST.Estado
			  --DATOS PEDIDO
			  ,isnull(PEDIDO.Id_NROPEDIDO, 0) Id_NROPEDIDO
			  ,ISNULL(Convert(varchar(10),CONVERT(date,PEDIDO.Fecha_EMISION,106),103), '') Fecha_EMISION
			  ,ISNULL(PEDIDO.ESTADO, '') ESTADO_PEDIDO
			  ,ISNULL(PEDIDO.VIGENCIA, '') VIGENCIA_PEDIDO
			  ,ISNULL(TRX_PEDIDOS.COD_ITEM, 0) PEDIDO_LANZADO
			  ,CAB.Nombre_Destinatario
		  FROM dbo.Inventario_Cabecera_Documentos CAB 
			INNER JOIN dbo.Adm_System_Holding PROP
				ON CAB.Id_Propietario = PROP.ID_HOLDING AND PROP.EsPropietario = 1 AND PROP.ID_TIPO_CONTACTO = 1 AND PROP.VIGENCIA = 'S'
			INNER JOIN dbo.Adm_System_Dueños DUENO
				ON CAB.Id_Dueño = DUENO.ID_Dueño AND DUENO.Vigencia = 'S'
			INNER JOIN dbo.Adm_System_Contactos CONTACTO
				ON DUENO.ID_Contacto = CONTACTO.ID_Contacto AND CONTACTO.VIGENCIA = 'S'
			INNER JOIN Inventario_Estado_Documentos EST
				ON CAB.ID_ESTADO = EST.Id_Estado
			--INNER JOIN Adm_System_Direcciones DIR
			--	ON CAB.ID_DIRECCION = DIR.ID_DIRECCION AND CAB.Id_Org = DIR.ID_ORG
			--INNER JOIN Adm_System_Comunas COM
			--	ON DIR.ID_COMUNA = COM.ID_COMUNA
			--INNER JOIN Adm_System_Provincias PROV
			--	ON COM.ID_PROVINCIA = PROV.ID_PROVINCIA				
			LEFT JOIN Inventario_Cabecera_Pedidos PEDIDO
				ON CAB.ID_ORG = PEDIDO.ID_ORG AND CAB.Folio_Documento = PEDIDO.Folio_Documento --AND PEDIDO.ESTADO <> 'ANULADO'
			LEFT JOIN Inventario_Detalle_Trx_Pedidos TRX_PEDIDOS
				ON PEDIDO.ID_NROPEDIDO = TRX_PEDIDOS.ID_NROPEDIDO AND PEDIDO.ID_ORG = TRX_PEDIDOS.ID_ORG AND TRX_PEDIDOS.NRO_LINEA = 1						
		  WHERE CAB.Id_Docu = 20 --AND CAB.ID_ESTADO > 100
			AND CAB.ID_ORG = @ID_ORG
			--AND CAB.Vigencia = 'S'
			AND CAST(CAB.Folio_Documento AS VARCHAR(18)) LIKE CAST(@Folio_Documento AS VARCHAR(18)) + '%'
			ORDER BY Folio_Documento ASC

	END	
	
	
	--Búsqueda Recepciones
	
	IF @ID_Pedido = -1 BEGIN
	
		SELECT DISTINCT CAB.Folio_Documento
			  ,CAB.Id_Docu
			  ,CAB.Id_Propietario
			  ,PROP.NOMBRE PROPIETARIO
			  ,CAB.Id_Dueño
			  ,CONTACTO.Nombres + ' ' + Apellido_Paterno CONTACTO_NOMBRE
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Solicitud,106),103), '') Fecha_Solicitud --Sistema
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Entrega,106),103), '') Fecha_Entrega
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Vencimiento,106),103), '') Fecha_Vencimiento
			  ,0 ID_PROVINCIA
			  ,'' PROVINCIA
			  ,0 ID_COMUNA
			  ,'' COMUNA
			  ,0 Id_Direccion
			  ,'' DIRECCION --CASE WHEN CAB.Id_Direccion > 0 THEN DIR.CALLE + ', #' + DIR.NUMERO ELSE '' END DIRECCION
			  --,PEDIDO.Nota	  
			  ,CAB.ID_ESTADO
			  ,EST.Estado
			  --DATOS PEDIDO
			  ,isnull(PEDIDO.Id_NROPEDIDO, 0) Id_NROPEDIDO
			  ,ISNULL(Convert(varchar(10),CONVERT(date,PEDIDO.Fecha_EMISION,106),103), '') Fecha_EMISION
			  ,ISNULL(PEDIDO.ESTADO, '') ESTADO_PEDIDO
			  ,ISNULL(PEDIDO.VIGENCIA, '') VIGENCIA_PEDIDO
			  ,ISNULL(TRX_PEDIDOS.COD_ITEM, 0) PEDIDO_LANZADO
			  ,CAB.Nombre_Destinatario
		  FROM dbo.Inventario_Cabecera_Documentos CAB 
			INNER JOIN dbo.Adm_System_Holding PROP
				ON CAB.Id_Propietario = PROP.ID_HOLDING AND PROP.EsPropietario = 1 AND PROP.ID_TIPO_CONTACTO = 1 AND PROP.VIGENCIA = 'S'
			INNER JOIN dbo.Adm_System_Dueños DUENO
				ON CAB.Id_Dueño = DUENO.ID_Dueño AND DUENO.Vigencia = 'S'
			INNER JOIN dbo.Adm_System_Contactos CONTACTO
				ON DUENO.ID_Contacto = CONTACTO.ID_Contacto AND CONTACTO.VIGENCIA = 'S'
			INNER JOIN Inventario_Estado_Documentos EST
				ON CAB.ID_ESTADO = EST.Id_Estado
			--INNER JOIN Adm_System_Direcciones DIR
			--	ON CAB.ID_DIRECCION = DIR.ID_DIRECCION AND CAB.Id_Org = DIR.ID_ORG
			--INNER JOIN Adm_System_Comunas COM
			--	ON DIR.ID_COMUNA = COM.ID_COMUNA
			--INNER JOIN Adm_System_Provincias PROV
			--	ON COM.ID_PROVINCIA = PROV.ID_PROVINCIA				
			LEFT JOIN Inventario_Cabecera_Pedidos PEDIDO
				ON CAB.ID_ORG = PEDIDO.ID_ORG AND CAB.Folio_Documento = PEDIDO.Folio_Documento -- AND PEDIDO.ESTADO <> 'ANULADO'
			LEFT JOIN Inventario_Detalle_Trx_Pedidos TRX_PEDIDOS
				ON PEDIDO.ID_NROPEDIDO = TRX_PEDIDOS.ID_NROPEDIDO AND PEDIDO.ID_ORG = TRX_PEDIDOS.ID_ORG AND TRX_PEDIDOS.NRO_LINEA = 1						
		  WHERE CAB.Id_Docu = 20
			AND CAB.ID_ORG = @ID_ORG
			AND CAB.Vigencia = 'S'
			--AND CAST(RECEP.ID_Recepcion AS VARCHAR(18)) LIKE CAST(@ID_Pedido AS VARCHAR(18)) + '%'
			ORDER BY Folio_Documento ASC		
	
	
	END 	
	
	IF @ID_Pedido > 0 BEGIN
	
		SELECT DISTINCT CAB.Folio_Documento
			  ,CAB.Id_Docu
			  ,CAB.Id_Propietario
			  ,PROP.NOMBRE PROPIETARIO
			  ,CAB.Id_Dueño
			  ,CONTACTO.Nombres + ' ' + Apellido_Paterno  CONTACTO_NOMBRE
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Solicitud,106),103), '') Fecha_Solicitud --Sistema
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Entrega,106),103), '') Fecha_Entrega
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Vencimiento,106),103), '') Fecha_Vencimiento
			  ,0 ID_PROVINCIA
			  ,'' PROVINCIA
			  ,0 ID_COMUNA
			  ,'' COMUNA
			  ,0 Id_Direccion
			  ,'' DIRECCION --CASE WHEN CAB.Id_Direccion > 0 THEN DIR.CALLE + ', #' + DIR.NUMERO ELSE '' END DIRECCION
			  --,PEDIDO.Nota	  
			  ,CAB.ID_ESTADO
			  ,EST.Estado
			  --DATOS PEDIDO
			  ,isnull(PEDIDO.Id_NROPEDIDO, 0) Id_NROPEDIDO
			  ,ISNULL(Convert(varchar(10),CONVERT(date,PEDIDO.Fecha_EMISION,106),103), '') Fecha_EMISION
			  ,ISNULL(PEDIDO.ESTADO, '') ESTADO_PEDIDO
			  ,ISNULL(PEDIDO.VIGENCIA, '') VIGENCIA_PEDIDO
			  ,ISNULL(TRX_PEDIDOS.COD_ITEM, 0) PEDIDO_LANZADO
			  ,CAB.Nombre_Destinatario
		  FROM dbo.Inventario_Cabecera_Documentos CAB 
			INNER JOIN dbo.Adm_System_Holding PROP
				ON CAB.Id_Propietario = PROP.ID_HOLDING AND PROP.EsPropietario = 1 AND PROP.ID_TIPO_CONTACTO = 1 AND PROP.VIGENCIA = 'S'
			INNER JOIN dbo.Adm_System_Dueños DUENO
				ON CAB.Id_Dueño = DUENO.ID_Dueño AND DUENO.Vigencia = 'S'
			INNER JOIN dbo.Adm_System_Contactos CONTACTO
				ON DUENO.ID_Contacto = CONTACTO.ID_Contacto AND CONTACTO.VIGENCIA = 'S'
			INNER JOIN Inventario_Estado_Documentos EST
				ON CAB.ID_ESTADO = EST.Id_Estado
			--INNER JOIN Adm_System_Direcciones DIR
			--	ON CAB.ID_DIRECCION = DIR.ID_DIRECCION AND CAB.Id_Org = DIR.ID_ORG
			--INNER JOIN Adm_System_Comunas COM
			--	ON DIR.ID_COMUNA = COM.ID_COMUNA
			--INNER JOIN Adm_System_Provincias PROV
			--	ON COM.ID_PROVINCIA = PROV.ID_PROVINCIA				
			LEFT JOIN Inventario_Cabecera_Pedidos PEDIDO
				ON CAB.ID_ORG = PEDIDO.ID_ORG AND CAB.Folio_Documento = PEDIDO.Folio_Documento -- AND PEDIDO.ESTADO <> 'ANULADO'
			LEFT JOIN Inventario_Detalle_Trx_Pedidos TRX_PEDIDOS
				ON PEDIDO.ID_NROPEDIDO = TRX_PEDIDOS.ID_NROPEDIDO AND PEDIDO.ID_ORG = TRX_PEDIDOS.ID_ORG AND TRX_PEDIDOS.NRO_LINEA = 1							
		  WHERE CAB.Id_Docu = 20
			AND CAB.ID_ORG = 17
			--AND CAB.Vigencia = 'S'
			AND CAST(PEDIDO.ID_NROPEDIDO AS VARCHAR(18)) LIKE CAST(@ID_Pedido AS VARCHAR(18)) + '%'
			ORDER BY Folio_Documento ASC		
	
	
	END 
	
	
	
END
GO
