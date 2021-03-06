USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[SOL_SOLICITUDNOTAS_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SOL_SOLICITUDNOTAS_LISTAR]
	-- Add the parameters for the stored procedure here	
	 @Folio_Documento NUMERIC(18, 0)
	,@Id_Docu NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ISNULL(OBS.Nota, '') NOTA
		  ,ISNULL(USU.NOMBRES, '') + ' ' + ISNULL(USU.APELLIDO_PATERNO, '') + ' ' + ISNULL(APELLIDO_MATERNO, '') USUARIO
		  ,Convert(varchar(10),CONVERT(datetime,OBS.Fech_Transaccion,106),103) + ' ' + Convert(varchar(10), CONVERT(datetime,OBS.Fech_Transaccion,106), 8) Fech_Transaccion
	  FROM dbo.Inventario_Observaciones_Solicitudes OBS
		INNER JOIN Adm_System_Usuarios USU
			ON OBS.ID_USRO = USU.ID_USRO
	  WHERE OBS.Folio_Documento = @Folio_Documento AND OBS.Id_Docu = @Id_Docu AND OBS.ID_ORG = @ID_ORG
		ORDER BY OBS.Fech_Transaccion DESC
	/*	
	SELECT * FROM Adm_System_Usuarios
	*/
	
END
GO
