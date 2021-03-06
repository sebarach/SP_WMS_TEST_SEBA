USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_USUARIO_ACTUALIZAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADM_USUARIO_ACTUALIZAR]
	-- Add the parameters for the stored procedure here
	@ID_Usro numeric(18,0),
	@ID_Org numeric(18,0),
	@Nombre_Usro varchar(max),
	@Pass_Usro varchar(500),
	@ID_Usro_Act numeric(18,0),
	@Vigencia varchar(1),
	@UserName varchar(20),
	@Nombres varchar(80),
	@Apellido_Paterno varchar(100),
	@Apellido_Materno varchar(100)
AS
BEGIN
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	
	DECLARE @RETORNO TABLE(ID NUMERIC(18, 0));

    -- Insert statements for procedure here
	UPDATE [dbo].[Adm_System_Usuarios]
	SET 	[ID_Org] = @ID_Org,
			[Nombre_Usro] = @Nombre_Usro,
			[Pass_Usro]  = @Pass_Usro,
			[Fech_Actualiza] = GETDATE(),
			[ID_Usro_Act] = @ID_Usro_Act,
			[Vigencia] = @Vigencia,
			[UserName] = @UserName,
			[Nombres] = @Nombres,
			[Apellido_Paterno] = @Apellido_Paterno,
			[Apellido_Materno] = @Apellido_Materno
	WHERE ID_Usro = @ID_Usro
	
	SELECT @@ROWCOUNT FILAS_AFECTADAS
	
END
GO
