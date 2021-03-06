USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_RECEPCION_SELECT]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_RECEPCION_SELECT NULL, 1, 17 
CREATE PROCEDURE [dbo].[INV_RECEPCION_SELECT]
	-- Add the parameters for the stored procedure here	
	 @Folio_Documento NUMERIC(18, 0)
	,@ID_Recepcion NUMERIC(18, 0)
	--,@Id_Docu NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--Búsqueda solicitudes
	
	IF @Folio_Documento = -1 BEGIN

		SELECT CAB.Folio_Documento
			  ,CAB.Id_Docu
			  ,CAB.Id_Propietario
			  ,PROP.NOMBRE PROPIETARIO
			  ,CAB.Id_Dueño
			  ,CONTACTO.Nombres + ' ' + Apellido_Paterno + ' ' + ISNULL(Apellido_Materno,'') CONTACTO_NOMBRE
			  --,CAB.Id_Direccion Id_Direccion
			  --,CASE WHEN CAB.Id_Direccion > 0 THEN DIR.CALLE + ', #' + DIR.NUMERO ELSE '' END DIRECCION
			  ,CAB.Orden_Compra_Cte
			  --,Orden_Trabajo
			  ,CAB.Id_Proveedor
			  ,PROV.NOMBRE PROVEEDOR --DEBE CAMBIARSE
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Solicitud,106),103), '') Fecha_Solicitud --Sistema
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Entrega,106),103), '') Fecha_Entrega
			  --,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Vencimiento,106),103), '') Fecha_Vencimiento
			  ,RECEP.Nota	  
			  ,CAB.ID_ESTADO
			  ,EST.Estado
			  --DATOS RECEPCION
			  ,RECEP.Cod_Subinv
			  ,ISNULL(Convert(varchar(10),CONVERT(date,RECEP.Fecha_Recep,106),103), '') Fecha_Recep
			  ,RECEP.Nro_Guia_Prov
			  ,RECEP.Nota
			  ,isnull(RECEP.Id_Recepcion, 0) Id_Recepcion
		  FROM dbo.Inventario_Cabecera_Documentos CAB 
			INNER JOIN dbo.Adm_System_Holding PROP
				ON CAB.Id_Propietario = PROP.ID_HOLDING AND PROP.EsPropietario = 1 AND PROP.ID_TIPO_CONTACTO = 1 AND PROP.VIGENCIA = 'S'
			INNER JOIN dbo.Adm_System_Dueños DUENO
				ON CAB.Id_Dueño = DUENO.ID_Dueño AND DUENO.Vigencia = 'S'
			INNER JOIN dbo.Adm_System_Contactos CONTACTO
				ON DUENO.ID_Contacto = CONTACTO.ID_Contacto AND CONTACTO.VIGENCIA = 'S'
			INNER JOIN Inventario_Estado_Documentos EST
				ON CAB.ID_ESTADO = EST.Id_Estado
			LEFT JOIN Inventario_Cabecera_Recepcion RECEP
				ON CAB.Id_Docu = RECEP.ID_DOCU AND CAB.ID_ORG = RECEP.ID_ORG AND CAB.Folio_Documento = RECEP.Folio_Documento
			INNER JOIN dbo.Adm_System_Holding PROV
				ON CAB.Id_Proveedor = PROV.ID_HOLDING AND PROV.EsPropietario = 0 AND PROV.ID_TIPO_CONTACTO = 4 AND PROV.VIGENCIA = 'S'				
		  WHERE CAB.Id_Docu = 10 --AND CAB.ID_ESTADO > 100
			AND CAB.ID_ORG = @ID_ORG
			AND CAB.Vigencia = 'S'
			--AND CAST(CAB.Folio_Documento AS VARCHAR(18)) LIKE CAST(@Folio_Documento AS VARCHAR(18)) + '%'
			ORDER BY Folio_Documento ASC

	END
	
	IF @Folio_Documento > 0 BEGIN

		SELECT CAB.Folio_Documento
			  ,CAB.Id_Docu
			  ,CAB.Id_Propietario
			  ,PROP.NOMBRE PROPIETARIO
			  ,CAB.Id_Dueño
			  ,CONTACTO.Nombres + ' ' + Apellido_Paterno + ' ' + ISNULL(Apellido_Materno,'') CONTACTO_NOMBRE
			  --,CAB.Id_Direccion Id_Direccion
			  --,CASE WHEN CAB.Id_Direccion > 0 THEN DIR.CALLE + ', #' + DIR.NUMERO ELSE '' END DIRECCION
			  ,CAB.Orden_Compra_Cte
			  --,Orden_Trabajo
			  ,CAB.Id_Proveedor
			  ,PROV.NOMBRE PROVEEDOR --DEBE CAMBIARSE
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Solicitud,106),103), '') Fecha_Solicitud --Sistema
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Entrega,106),103), '') Fecha_Entrega
			  --,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Vencimiento,106),103), '') Fecha_Vencimiento
			  ,RECEP.Nota	  
			  ,CAB.ID_ESTADO
			  ,EST.Estado
			  --DATOS RECEPCION
			  ,RECEP.Cod_Subinv
			  ,ISNULL(Convert(varchar(10),CONVERT(date,RECEP.Fecha_Recep,106),103), '') Fecha_Recep
			  ,RECEP.Nro_Guia_Prov
			  ,RECEP.Nota
			  ,isnull(RECEP.Id_Recepcion, 0) Id_Recepcion
		  FROM dbo.Inventario_Cabecera_Documentos CAB 
			INNER JOIN dbo.Adm_System_Holding PROP
				ON CAB.Id_Propietario = PROP.ID_HOLDING AND PROP.EsPropietario = 1 AND PROP.ID_TIPO_CONTACTO = 1 AND PROP.VIGENCIA = 'S'
			INNER JOIN dbo.Adm_System_Dueños DUENO
				ON CAB.Id_Dueño = DUENO.ID_Dueño AND DUENO.Vigencia = 'S'
			INNER JOIN dbo.Adm_System_Contactos CONTACTO
				ON DUENO.ID_Contacto = CONTACTO.ID_Contacto AND CONTACTO.VIGENCIA = 'S'
			INNER JOIN Inventario_Estado_Documentos EST
				ON CAB.ID_ESTADO = EST.Id_Estado
			LEFT JOIN Inventario_Cabecera_Recepcion RECEP
				ON CAB.Id_Docu = RECEP.ID_DOCU AND CAB.ID_ORG = RECEP.ID_ORG AND CAB.Folio_Documento = RECEP.Folio_Documento
			INNER JOIN dbo.Adm_System_Holding PROV
				ON CAB.Id_Proveedor = PROV.ID_HOLDING AND PROV.EsPropietario = 0 AND PROV.ID_TIPO_CONTACTO = 4 AND PROV.VIGENCIA = 'S'					
		  WHERE CAB.Id_Docu = 10 --AND CAB.ID_ESTADO > 100
			AND CAB.ID_ORG = @ID_ORG
			AND CAB.Vigencia = 'S'
			AND CAST(CAB.Folio_Documento AS VARCHAR(18)) LIKE CAST(@Folio_Documento AS VARCHAR(18)) + '%'
			ORDER BY Folio_Documento ASC

	END	
	
	
	--Búsqueda Recepciones
	
	IF @ID_Recepcion = -1 BEGIN
	
		SELECT CAB.Folio_Documento
			  ,CAB.Id_Docu
			  ,CAB.Id_Propietario
			  ,PROP.NOMBRE PROPIETARIO
			  ,CAB.Id_Dueño
			  ,CONTACTO.Nombres + ' ' + Apellido_Paterno + ' ' + ISNULL(Apellido_Materno,'') CONTACTO_NOMBRE
			  --,CAB.Id_Direccion Id_Direccion
			  --,CASE WHEN CAB.Id_Direccion > 0 THEN DIR.CALLE + ', #' + DIR.NUMERO ELSE '' END DIRECCION
			  ,CAB.Orden_Compra_Cte
			  --,Orden_Trabajo
			  ,CAB.Id_Proveedor
			  ,PROV.NOMBRE PROVEEDOR --DEBE CAMBIARSE			  
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Solicitud,106),103), '') Fecha_Solicitud --Sistema
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Entrega,106),103), '') Fecha_Entrega
			  --,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Vencimiento,106),103), '') Fecha_Vencimiento
			  ,RECEP.Nota	  
			  ,CAB.ID_ESTADO
			  ,EST.Estado
			  --DATOS RECEPCION
			  ,RECEP.Cod_Subinv
			  ,ISNULL(Convert(varchar(10),CONVERT(date,RECEP.Fecha_Recep,106),103), '') Fecha_Recep
			  ,RECEP.Nro_Guia_Prov
			  ,RECEP.Nota
			  ,isnull(RECEP.Id_Recepcion, 0) Id_Recepcion
		  FROM dbo.Inventario_Cabecera_Documentos CAB 
			INNER JOIN dbo.Adm_System_Holding PROP
				ON CAB.Id_Propietario = PROP.ID_HOLDING AND PROP.EsPropietario = 1 AND PROP.ID_TIPO_CONTACTO = 1 AND PROP.VIGENCIA = 'S'
			INNER JOIN dbo.Adm_System_Dueños DUENO
				ON CAB.Id_Dueño = DUENO.ID_Dueño AND DUENO.Vigencia = 'S'
			INNER JOIN dbo.Adm_System_Contactos CONTACTO
				ON DUENO.ID_Contacto = CONTACTO.ID_Contacto AND CONTACTO.VIGENCIA = 'S'
			INNER JOIN Inventario_Estado_Documentos EST
				ON CAB.ID_ESTADO = EST.Id_Estado
			LEFT JOIN Inventario_Cabecera_Recepcion RECEP
				ON CAB.Id_Docu = RECEP.ID_DOCU AND CAB.ID_ORG = RECEP.ID_ORG AND CAB.Folio_Documento = RECEP.Folio_Documento
			INNER JOIN dbo.Adm_System_Holding PROV
				ON CAB.Id_Proveedor = PROV.ID_HOLDING AND PROV.EsPropietario = 0 AND PROV.ID_TIPO_CONTACTO = 4 AND PROV.VIGENCIA = 'S'					
		  WHERE RECEP.Id_Docu = 10
			AND RECEP.ID_ORG = @ID_ORG
		--	AND CAB.Vigencia = 'S'
			--AND CAST(RECEP.ID_Recepcion AS VARCHAR(18)) LIKE CAST(@ID_Recepcion AS VARCHAR(18)) + '%'
			ORDER BY Folio_Documento ASC		
	
	
	END 	
	
	IF @ID_Recepcion > 0 BEGIN
	
		SELECT CAB.Folio_Documento
			  ,CAB.Id_Docu
			  ,CAB.Id_Propietario
			  ,PROP.NOMBRE PROPIETARIO
			  ,CAB.Id_Dueño
			  ,CONTACTO.Nombres + ' ' + Apellido_Paterno + ' ' + Apellido_Materno CONTACTO_NOMBRE
			  --,CAB.Id_Direccion Id_Direccion
			  --,CASE WHEN CAB.Id_Direccion > 0 THEN DIR.CALLE + ', #' + DIR.NUMERO ELSE '' END DIRECCION
			  ,CAB.Orden_Compra_Cte
			  --,Orden_Trabajo
			  ,CAB.Id_Proveedor
			  ,PROV.NOMBRE PROVEEDOR --DEBE CAMBIARSE			  
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Solicitud,106),103), '') Fecha_Solicitud --Sistema
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Entrega,106),103), '') Fecha_Entrega
			  --,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Vencimiento,106),103), '') Fecha_Vencimiento
			  ,RECEP.Nota	  
			  ,CAB.ID_ESTADO
			  ,EST.Estado
			  --DATOS RECEPCION
			  ,RECEP.Cod_Subinv
			  ,ISNULL(Convert(varchar(10),CONVERT(date,RECEP.Fecha_Recep,106),103), '') Fecha_Recep
			  ,RECEP.Nro_Guia_Prov
			  ,RECEP.Nota
			  ,isnull(RECEP.Id_Recepcion, 0) Id_Recepcion
		  FROM dbo.Inventario_Cabecera_Documentos CAB 
			INNER JOIN dbo.Adm_System_Holding PROP
				ON CAB.Id_Propietario = PROP.ID_HOLDING AND PROP.EsPropietario = 1 AND PROP.ID_TIPO_CONTACTO = 1 AND PROP.VIGENCIA = 'S'
			INNER JOIN dbo.Adm_System_Dueños DUENO
				ON CAB.Id_Dueño = DUENO.ID_Dueño AND DUENO.Vigencia = 'S'
			INNER JOIN dbo.Adm_System_Contactos CONTACTO
				ON DUENO.ID_Contacto = CONTACTO.ID_Contacto AND CONTACTO.VIGENCIA = 'S'
			INNER JOIN Inventario_Estado_Documentos EST
				ON CAB.ID_ESTADO = EST.Id_Estado
			LEFT JOIN Inventario_Cabecera_Recepcion RECEP
				ON CAB.Id_Docu = RECEP.ID_DOCU AND CAB.ID_ORG = RECEP.ID_ORG AND CAB.Folio_Documento = RECEP.Folio_Documento
			INNER JOIN dbo.Adm_System_Holding PROV
				ON CAB.Id_Proveedor = PROV.ID_HOLDING AND PROV.EsPropietario = 0 AND PROV.ID_TIPO_CONTACTO = 4 AND PROV.VIGENCIA = 'S'					
		  WHERE RECEP.Id_Docu = 10 AND 
            RECEP.ID_ORG = @ID_ORG
			--AND CAB.Vigencia = 'S'
			AND CAST(RECEP.ID_Recepcion AS VARCHAR(18)) LIKE CAST(@ID_Recepcion AS VARCHAR(18)) + '%'
			ORDER BY Folio_Documento ASC		
	
	
	END 
	
	
	
END
GO
