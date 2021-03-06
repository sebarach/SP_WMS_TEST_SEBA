USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_SOLICITUD_OBTENERMONTOAPROB]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec INV_SOLICITUD_OBTENERMONTOAPROB 52, 12, 17
CREATE PROCEDURE [dbo].[INV_SOLICITUD_OBTENERMONTOAPROB]
	-- Add the parameters for the stored procedure here
	 @ID_HOLDING NUMERIC(18, 0)
	,@ID_DUENO NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 G.MONTO_HASTA Monto
				FROM Adm_System_Asignacion_Grupo_Aprobacion A
					INNER JOIN Adm_System_Grupo_Aprobacion G
						ON G.ID_GRUPO = A.ID_GRUPO AND G.ID_HOLDING_PROPIETARIO = A.ID_HOLDING_PROPIETARIO AND G.ID_ORG = A.ID_ORG
				WHERE A.ID_HOLDING_PROPIETARIO = @ID_HOLDING
					AND A.ID_DUEÑO = @ID_DUENO
					AND A.ID_ORG = @ID_ORG
					AND A.VIGENCIA = 'S'
					AND G.VIGENCIA = 'S') BEGIN
		
		SELECT TOP 1 1 ConBanda, G.MONTO_HASTA Monto
		FROM Adm_System_Asignacion_Grupo_Aprobacion A
			INNER JOIN Adm_System_Grupo_Aprobacion G
				ON G.ID_GRUPO = A.ID_GRUPO AND G.ID_HOLDING_PROPIETARIO = A.ID_HOLDING_PROPIETARIO AND G.ID_ORG = A.ID_ORG
		WHERE A.ID_HOLDING_PROPIETARIO = @ID_HOLDING
			AND A.ID_DUEÑO = @ID_DUENO
			AND A.ID_ORG = @ID_ORG
			AND A.VIGENCIA = 'S'
			AND G.VIGENCIA = 'S'	
		ORDER BY G.MONTO_HASTA DESC
	
	END
	ELSE BEGIN
	
		SELECT 0 ConBanda, 0 Monto
	
	END



END
GO
