USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_CENTROCOSTO_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_CENTROCOSTO_LISTAR]
	-- Add the parameters for the stored procedure here
	 @ID_HOLDING NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT CC.Cod_Centro Id
		  ,CC.Nombre_CC CentroCosto
		  ,CC.ID_Holding_Propietario PropietarioId
		  ,P.NOMBRE Propietario
		  ,CC.ID_Org OrganizacionId
		  ,CC.Vigencia Vigencia
	FROM Ventas_Centros_Costos_Propietarios CC
		INNER JOIN Adm_System_Holding P
			ON CC.ID_Holding_Propietario = P.ID_HOLDING AND CC.ID_ORG = P.ID_ORG AND P.ESPROPIETARIO = 1
	WHERE CC.ID_Holding_Propietario = @ID_HOLDING
		AND CC.ID_ORG = @ID_ORG;

	--SELECT * FROM Adm_System_Holding
	
	
END
GO
