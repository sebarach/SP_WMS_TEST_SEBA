USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_MENU_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADM_MENU_LISTAR]
	-- Add the parameters for the stored procedure here
	@ID_USER NUMERIC(18, 0),
	@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT
	 R.ID_RESPONSABILIDAD RESP_ID
	,R.NOMBRE RESP_NOMBRE
	,SUP.ID_SUPERIOR SUP_ID
	,SUP.NOMBRE SUP_NOMBRE
	,SR.ID_SUBRESP SUBRESP_ID
	,SR.NOMBRE SUBRESP_NOMBRE
	,ISNULL(SR.ACCION, '') ACCION
FROM Adm_System_Usuarios U
	INNER JOIN Adm_System_Perfiles_Usuarios PU
		ON U.ID_USRO = PU.ID_USRO 
	--INNER JOIN Adm_System_Tipo_Usuarios TU		
	--	ON PU.ID_TIPOUSRO = TU.ID_TIPOUSRO
	INNER JOIN Adm_System_Origen_Usuarios O
		ON PU.ID_ORIGEN = O.ID_ORIGEN
	INNER JOIN Adm_System_Asignacion_Responsabilidades AR
		ON PU.ID_PERFIL = AR.ID_PERFIL
	INNER JOIN Adm_System_Sub_Responsabilidades SR
		ON AR.ID_SUBRESP = SR.ID_SUBRESP
	INNER JOIN Adm_System_Responsabilidades R		
		ON SR.ID_RESPONSABILIDAD = R.ID_RESPONSABILIDAD	
	INNER JOIN Adm_System_OrdenResp SUP
		ON SR.ID_SUPERIOR = SUP.ID_SUPERIOR
	WHERE U.ID_USRO = @ID_USER
		AND U.VIGENCIA = 'S'
		--AND TU.VIGENCIA = 'S'
		AND PU.VIGENCIA = 'S'
		AND AR.VIGENCIA = 'S'
		AND SR.VIGENCIA = 'S'
		AND R.VIGENCIA = 'S'
		AND U.ID_ORG = @ID_ORG
	ORDER BY SUP.ORDEN ASC, SR.NOMBRE ASC




	
END
GO
