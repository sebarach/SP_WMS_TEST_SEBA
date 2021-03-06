USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_USUARIO_VERIFICAR_CORREO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADM_USUARIO_VERIFICAR_CORREO]
	-- Add the parameters for the stored procedure here
	@CORREO VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(select * from Adm_System_Contactos where correo = @CORREO) BEGIN

		DECLARE 
			@RANDOM INT,
			@UPPER INT,
			@LOWER INT,
			@PASS_TEMP VARCHAR(4);

		SET @LOWER = 1 
		SET @UPPER = 9999

		SELECT @RANDOM = ROUND(((@UPPER - @LOWER - 1) * RAND() + @LOWER), 0)
		--SELECT @RANDOM

		SET @PASS_TEMP = REPLICATE('0', 4 - LEN(@RANDOM)) + '' + CAST(@RANDOM AS VARCHAR)
		
		--SELECT * FROM ADM_SYSTEM_USUARIOS
		BEGIN TRY 
			UPDATE ADM_SYSTEM_USUARIOS SET RECUPERACION_CLAVE = 1, PASS_USRO = @PASS_TEMP
			WHERE ID_USRO = (select ID_USRO from Adm_System_Contactos where correo = @CORREO) --'luiszamorano29@gmail.com')
			SELECT 1 CORRECTO, '' MENSAJE, @PASS_TEMP TEMP_PASS	
		END TRY
		BEGIN CATCH			
			SELECT 0 CORRECTO, 'Ocurrió un error al momento de crear la clave temporal' MENSAJE, '' TEMP_PASS
		END CATCH
	END
	ELSE BEGIN
		SELECT 0 CORRECTO, 'El correo no se encuentra registrado en nuestra base' MENSAJE, '' TEMP_PASS
	END
	
	
	
END
GO
