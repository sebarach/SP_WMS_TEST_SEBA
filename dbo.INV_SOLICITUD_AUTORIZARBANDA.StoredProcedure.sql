USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_SOLICITUD_AUTORIZARBANDA]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec INV_SOLICITUD_AUTORIZARBANDA 'Q7429', 17
CREATE PROCEDURE [dbo].[INV_SOLICITUD_AUTORIZARBANDA]
	-- Add the parameters for the stored procedure here
	 @PASS_USRO VARCHAR(500)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT * FROM ADM_SYSTEM_USUARIOS WHERE AUTORIZABANDA = 'S' AND PASS_USRO = @PASS_USRO) BEGIN
		
		SELECT '' MENSAJE, 1 CORRECTO
	
	END
	ELSE BEGIN
	
		SELECT 'Contraseña inválida' MENSAJE, 0 CORRECTO
	
	END



END
GO
