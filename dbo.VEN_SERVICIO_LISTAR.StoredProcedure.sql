USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_SERVICIO_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_SERVICIO_LISTAR]
	-- Add the parameters for the stored procedure here
	@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Cod_Servicio Id
      ,Nombre Nombre
      ,Id_Org OrganizacionId
      ,Vigencia Vigencia
	FROM Ventas_Servicios
  
	--SELECT * FROM Adm_System_Holding
	
	
END
GO
