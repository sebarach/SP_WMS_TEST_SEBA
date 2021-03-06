USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_USUARIO_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADM_USUARIO_LISTAR]
	-- Add the parameters for the stored procedure here
	@ID_ORG NUMERIC(18, 0)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [ID_Usro]
		  ,USU.[ID_Org]
		  ,ORG.NOMBRE
		  ,[Nombre_Usro]
		  ,[Pass_Usro]
		  --,[Fech_Creacion]
		  ,USU.[Vigencia]		  
		  ,[UserName]
		  ,[Nombres]
		  ,[Apellido_Paterno]
		  ,[Apellido_Materno]
	  FROM [dbo].[Adm_System_Usuarios] USU
		INNER JOIN Adm_System_Organizaciones ORG
			ON USU.[ID_Org] = ORG.[ID_Org]
		WHERE USU.[ID_Org] = @ID_ORG
	
END
GO
