USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_USUARIO_INSERTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADM_USUARIO_INSERTAR]
	-- Add the parameters for the stored procedure here
	@ID_Org numeric(18,0),
	@Nombre_Usro varchar(max),
	@Pass_Usro varchar(500),
	@ID_Usro_Crea numeric(18,0),
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
	SET NOCOUNT ON;
	
	DECLARE @RETORNO TABLE(ID NUMERIC(18, 0));
	DECLARE @EXISTE INT = -1;
	

	IF NOT EXISTS(SELECT * FROM Adm_System_Usuarios WHERE USERNAME = @UserName) BEGIN

		-- Insert statements for procedure here
		INSERT INTO [dbo].[Adm_System_Usuarios]
				   ([ID_Org]
				   ,[Nombre_Usro]
				   ,[Pass_Usro]
				   ,[Fech_Creacion]
				   ,[Fech_Actualiza]
				   ,[ID_Usro_Crea]
				   ,[ID_Usro_Act]
				   ,[Vigencia]
				   ,[UserName]
				   ,[Nombres]
				   ,[Apellido_Paterno]
				   ,[Apellido_Materno])
				   OUTPUT INSERTED.ID_USRO 
				   INTO @RETORNO(ID)
			 VALUES
				   (@ID_Org,
					@Nombre_Usro,
					@Pass_Usro,
					GETDATE(),
					GETDATE(),
					@ID_Usro_Crea,
					@ID_Usro_Act,
					@Vigencia,
					@UserName,
					@Nombres,
					@Apellido_Paterno,
					@Apellido_Materno)
		
		SELECT ID FROM @RETORNO
	END
	ELSE BEGIN
	
		SELECT @EXISTE AS ID
	
	END
	--SELECT SCOPE_IDENTITY() 
	
END
GO
