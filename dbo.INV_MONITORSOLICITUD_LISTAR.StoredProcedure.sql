USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_MONITORSOLICITUD_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_MONITORSOLICITUD_LISTAR]
	-- Add the parameters for the stored procedure here
--DECLARE 
	 @ID_DOCU NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SET @ID_DOCU = 20
	--SET @ID_ORG = 17
	
	DECLARE 
		 @VAR_IDDOCU VARCHAR(100) = ''
		,@VAR_IDORG VARCHAR(100) = ''
		,@STR_QUERY VARCHAR(MAX)	
	
	IF @ID_DOCU > 0 BEGIN
		SET @VAR_IDDOCU = ' AND DOC.ID_DOCU = ' + CAST(@ID_DOCU AS VARCHAR(25))
	END 	
	
	IF @ID_ORG > 0 BEGIN
		SET @VAR_IDORG = CAST(@ID_ORG AS VARCHAR(25))
	END 	

	
	SET @STR_QUERY = 'SELECT 
		 ISNULL(CONVERT(VARCHAR(10),CONVERT(DATE,DOC.FECHA_SOLICITUD,106),103), '''') FechaSolicitud
		,DOC.FOLIO_DOCUMENTO NroSolicitud
		,TIPO.Nombre_Docu TipoSolicitud
		,PROP.NOMBRE Propietario
		,CONTACTO.NOMBRES + '' '' + APELLIDO_PATERNO + '' '' + APELLIDO_MATERNO Dueno
		,ESTADO.ESTADO EstadoSolicitud
		,DOC.ID_DOCU
	FROM Inventario_Cabecera_Documentos DOC
		INNER JOIN Inventario_Tipo_Documentos TIPO
			ON DOC.Id_Docu = TIPO.Id_Docu 
		INNER JOIN Adm_System_Holding PROP
			ON DOC.ID_PROPIETARIO = PROP.ID_HOLDING AND DOC.ID_ORG = PROP.ID_ORG AND PROP.ESPROPIETARIO = 1
		INNER JOIN Adm_System_Dueños DUENO
			ON DOC.ID_DUEÑO = DUENO.ID_DUEÑO AND DOC.ID_ORG = DUENO.ID_ORG
		INNER JOIN Adm_System_Contactos CONTACTO
			ON DUENO.ID_CONTACTO = CONTACTO.ID_CONTACTO AND DUENO.ID_ORG = CONTACTO.ID_ORG			
		INNER JOIN INVENTARIO_ESTADO_DOCUMENTOS ESTADO
			ON DOC.ID_ESTADO = ESTADO.ID_ESTADO AND DOC.Id_Docu = ESTADO.ID_DOCU	
	WHERE DOC.Id_Org = ' + @VAR_IDORG
		+ @VAR_IDDOCU
	+ ' ORDER BY DOC.FECHA_SOLICITUD ASC';
	
	--PRINT @STR_QUERY
	
	EXEC (@STR_QUERY); 
	
	/*
	SELECT * FROM Adm_System_Holding
	
	SELECT * FROM Inventario_Cabecera_Documentos
	
	SELECT * FROM Inventario_Tipo_Documentos
	
	SELECT * FROM INVENTARIO_ESTADO_DOCUMENTOS
	*/
	
	
	
END
GO
