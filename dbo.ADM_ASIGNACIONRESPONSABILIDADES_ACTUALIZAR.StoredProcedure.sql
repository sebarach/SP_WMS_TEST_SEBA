USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_ASIGNACIONRESPONSABILIDADES_ACTUALIZAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADM_ASIGNACIONRESPONSABILIDADES_ACTUALIZAR]
	-- Add the parameters for the stored procedure here
	@ID_PERFIL NUMERIC(18, 0),
	@ID_USRO NUMERIC(18, 0),
	@XML VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @oxml XML;

	SET @oxml = N'''' + @XML + '''';
    -- Insert statements for procedure here
	
	
	DELETE FROM Adm_System_Asignacion_Responsabilidades WHERE ID_PERFIL = @ID_PERFIL;	
	
	INSERT INTO Adm_System_Asignacion_Responsabilidades
	SELECT 		
		 Tbl.Col.value('@v', 'numeric(18, 0)') SUBRESPID
		,@ID_PERFIL
		,GETDATE()
		,GETDATE()
		,@ID_USRO
		,@ID_USRO
		,'S'
	FROM @oxml.nodes('//root/f') Tbl(Col)	
	
	--SELECT * FROM Adm_System_Asignacion_Responsabilidades
	SELECT @@ROWCOUNT AS FILAS_AFECTADAS


END
GO
