USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[SET_CORREO_SMTP]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SET_CORREO_SMTP] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT 
		 CORR_HOST HOST
		,CORR_PUERTO PUERTO
		,CORR_USUARIO USUARIO
		,CORR_PASSWORD PASS		
		FROM CORREO_AJUSTE


END
GO
