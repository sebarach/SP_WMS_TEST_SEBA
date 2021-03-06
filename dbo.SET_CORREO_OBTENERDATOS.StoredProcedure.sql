USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[SET_CORREO_OBTENERDATOS]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SET_CORREO_OBTENERDATOS] 
	-- Add the parameters for the stored procedure here
	 @ID_USRO NUMERIC(18, 0) 
	,@ID_DOCU NUMERIC(18, 0)
	,@ID_FOLIO NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @CORREO_SOLICITANTE VARCHAR(100)
	
    -- Insert statements for procedure here
	SELECT @CORREO_SOLICITANTE = C.CORREO
	FROM Adm_System_Usuarios U
		INNER JOIN Adm_System_Contactos C
			ON U.ID_USRO = C.ID_USRO 
	WHERE U.ID_USRO = @ID_USRO --26
	
	IF (@ID_DOCU = 10) BEGIN
	
		SELECT 
			 @CORREO_SOLICITANTE CORREO_SOLICITANTE
			,'Solicitud de Recepción Nº ' + cast(@ID_FOLIO as varchar(20)) ASUNTO
			,'Se ha generado la Solicitud de Recepción con Folio ' + cast(@ID_FOLIO as varchar(20)) + '. ' MENSAJE
			,CORR_HOST HOST
			,CORR_PUERTO PUERTO
			,CORR_USUARIO USUARIO
			,CORR_PASSWORD PASS
			,CORR_REMITENTE CORREO_REMITENTE
			,CORR_CC_RECEPCION CORREOS_DISECOM
			FROM CORREO_AJUSTE
	END 



	IF (@ID_DOCU = 20) BEGIN
	
		SELECT 
			 @CORREO_SOLICITANTE CORREO_SOLICITANTE
			,'Solicitud de Despacho Nº ' + cast(@ID_FOLIO as varchar(20)) ASUNTO
			,'Se ha generado la Solicitud de Despacho con Folio ' + cast(@ID_FOLIO as varchar(20)) + '. ' MENSAJE
			,CORR_HOST HOST
			,CORR_PUERTO PUERTO
			,CORR_USUARIO USUARIO
			,CORR_PASSWORD PASS			
			,CORR_REMITENTE CORREO_REMITENTE
			,CORR_CC_DESPACHO CORREOS_DISECOM
			FROM CORREO_AJUSTE
	END 





END
GO
