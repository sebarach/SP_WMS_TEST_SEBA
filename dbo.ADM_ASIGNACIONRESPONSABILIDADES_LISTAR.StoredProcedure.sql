USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_ASIGNACIONRESPONSABILIDADES_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADM_ASIGNACIONRESPONSABILIDADES_LISTAR]
	-- Add the parameters for the stored procedure here
	@ID_PERFIL NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT
	 R.ID_RESPONSABILIDAD RESP_ID
	,ISNULL(R.NOMBRE, '') RESP_NOMBRE
	,ISNULL(SUP.ID_SUPERIOR, 0) SUP_ID
	,ISNULL(SUP.NOMBRE, '') SUP_NOMBRE
	,SR.ID_SUBRESP SUBRESP_ID
	,SR.NOMBRE SUBRESP_NOMBRE
	,(SELECT COUNT(1) FROM Adm_System_Asignacion_Responsabilidades ASIGRESP WHERE ASIGRESP.ID_PERFIL = @ID_PERFIL AND ASIGRESP.ID_SUBRESP = SR.ID_SUBRESP) TIQUEADO
FROM Adm_System_Sub_Responsabilidades SR
	INNER JOIN Adm_System_Responsabilidades R		
		ON SR.ID_RESPONSABILIDAD = R.ID_RESPONSABILIDAD	
	INNER JOIN Adm_System_OrdenResp SUP
		ON SR.ID_SUPERIOR = SUP.ID_SUPERIOR
	WHERE SR.VIGENCIA = 'S'
		AND R.VIGENCIA = 'S'
	ORDER BY R.NOMBRE ASC, SUP.ORDEN ASC, SR.NOMBRE ASC
	
END
GO
