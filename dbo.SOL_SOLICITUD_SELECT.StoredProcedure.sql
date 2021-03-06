USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[SOL_SOLICITUD_SELECT]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SOL_SOLICITUD_SELECT]
	-- Add the parameters for the stored procedure here	
	 @Folio_Documento NUMERIC(18, 0)
	,@Id_Docu NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
	,@ID_ORIGEN NUMERIC(18, 0)
	,@ID_PROP NUMERIC(18, 0)
	,@ID_DUENO NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@ID_ORIGEN = 300) BEGIN

		-- Insert statements for procedure here
		SELECT CAB.Folio_Documento
			  ,CAB.Id_Docu
			  ,CAB.Id_Propietario
			  ,CAB.Id_Dueño
			  ,CAB.Id_Direccion Id_Direccion
			  ,CASE WHEN CAB.Id_Direccion > 0 THEN DIR.CALLE + ', #' + DIR.NUMERO ELSE '' END DIRECCION
			  ,CAB.Orden_Compra_Cte
			  --,Orden_Trabajo
			  ,CAB.Id_Proveedor
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Solicitud,106),103), '') Fecha_Solicitud --Sistema
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Entrega,106),103), '') Fecha_Entrega
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Vencimiento,106),103), '') Fecha_Vencimiento
			  --,Nro_Entrega
			  --,Solicitud_Maquila
			  ,CAB.Nota
			  ,ISNULL(COM.ID_COMUNA, 0) ID_COMUNA
			  ,ISNULL(COM.NOMBRE, '') COMUNA
			  ,ISNULL(COM.ID_PROVINCIA, 0) ID_PROVINCIA
			  ,ISNULL(COM.NOMBRE, '') PROVINCIA	  	  
			  ,CAB.ID_ESTADO
			  ,EST.Estado
				,CAB.NOMBRE_DESTINATARIO
				,CAB.RUT_DESTINATARIO
				,CAB.ID_CLISUC
		  FROM dbo.Inventario_Cabecera_Documentos CAB  
			INNER JOIN Inventario_Estado_Documentos EST
				ON CAB.ID_ESTADO = EST.Id_Estado
			LEFT JOIN Adm_System_Direcciones DIR
				ON CAB.ID_DIRECCION = DIR.ID_DIRECCION AND CAB.Id_Org = DIR.ID_ORG
			LEFT JOIN Adm_System_Comunas COM
				ON DIR.ID_COMUNA = COM.ID_COMUNA
			LEFT JOIN Adm_System_Provincias PROV
				ON COM.ID_PROVINCIA = PROV.ID_PROVINCIA
		  WHERE CAB.Id_Docu = @Id_Docu AND CAB.ID_ORG = @ID_ORG
			-- AND CAB.Vigencia = 'S'
			AND CAST(CAB.Folio_Documento AS VARCHAR(18)) LIKE CAST(@Folio_Documento AS VARCHAR(18)) + '%'
			ORDER BY Folio_Documento ASC
		
	END 
	ELSE BEGIN
	
		-- Insert statements for procedure here
		SELECT CAB.Folio_Documento
			  ,CAB.Id_Docu
			  ,CAB.Id_Propietario
			  ,CAB.Id_Dueño
			  ,CAB.Id_Direccion Id_Direccion
			  ,CASE WHEN CAB.Id_Direccion > 0 THEN DIR.CALLE + ', #' + DIR.NUMERO ELSE '' END DIRECCION
			  ,CAB.Orden_Compra_Cte
			  --,Orden_Trabajo
			  ,CAB.Id_Proveedor
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Solicitud,106),103), '') Fecha_Solicitud --Sistema
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Entrega,106),103), '') Fecha_Entrega
			  ,ISNULL(Convert(varchar(10),CONVERT(date,CAB.Fecha_Vencimiento,106),103), '') Fecha_Vencimiento
			  --,Nro_Entrega
			  --,Solicitud_Maquila
			  ,CAB.Nota
			  ,ISNULL(COM.ID_COMUNA, 0) ID_COMUNA
			  ,ISNULL(COM.NOMBRE, '') COMUNA
			  ,ISNULL(COM.ID_PROVINCIA, 0) ID_PROVINCIA
			  ,ISNULL(COM.NOMBRE, '') PROVINCIA	  	  
			  ,CAB.ID_ESTADO
			  ,EST.Estado
				,CAB.NOMBRE_DESTINATARIO
				,CAB.RUT_DESTINATARIO
				,CAB.ID_CLISUC
		  FROM dbo.Inventario_Cabecera_Documentos CAB  
			INNER JOIN Inventario_Estado_Documentos EST
				ON CAB.ID_ESTADO = EST.Id_Estado
			LEFT JOIN Adm_System_Direcciones DIR
				ON CAB.ID_DIRECCION = DIR.ID_DIRECCION AND CAB.Id_Org = DIR.ID_ORG
			LEFT JOIN Adm_System_Comunas COM
				ON DIR.ID_COMUNA = COM.ID_COMUNA
			LEFT JOIN Adm_System_Provincias PROV
				ON COM.ID_PROVINCIA = PROV.ID_PROVINCIA
		  WHERE CAB.Id_Docu = @Id_Docu AND CAB.ID_ORG = @ID_ORG
			AND CAB.Id_Propietario = @ID_PROP
			--AND CAB.Id_Dueño = @ID_DUENO
			AND CAB.Vigencia = 'S'
			AND CAST(CAB.Folio_Documento AS VARCHAR(18)) LIKE CAST(@Folio_Documento AS VARCHAR(18)) + '%'
			ORDER BY Folio_Documento ASC	
	
	END
		
	/*	
	SELECT * FROM dbo.Adm_System_Direcciones
	
	SELECT * FROM dbo.Adm_System_Comunas
	
	SELECT * FROM dbo.Adm_System_Provincias
	*/
	
END
GO
