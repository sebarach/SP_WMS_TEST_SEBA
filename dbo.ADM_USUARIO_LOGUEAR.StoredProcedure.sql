USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_USUARIO_LOGUEAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADM_USUARIO_LOGUEAR]
	-- Add the parameters for the stored procedure here
	@USERNAME varchar(20),
	@USERPASS VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		U.ID_USRO,
		U.[USERNAME],				
		U.NOMBRES,
		U.APELLIDO_PATERNO,
		U.APELLIDO_MATERNO,
		ORIGEN.ID_ORIGEN,
		ORIGEN.TIPO_ORIGEN,
		TIPO.ID_TIPOUSRO,		
		TIPO.TIPO,
		U.ID_ORG,
		ORG.NOMBRE NOMBRE_ORG,
		ISNULL((select ID_HOLDING_PROPIETARIO
			from Adm_System_Contactos CONTACTOPROP
				INNER JOIN dbo.Adm_System_Dueños DUENOPROP
			ON CONTACTOPROP.ID_CONTACTO = DUENOPROP.ID_CONTACTO AND CONTACTOPROP.ID_ORG = DUENOPROP.ID_ORG AND CONTACTOPROP.VIGENCIA = 'S' AND DUENOPROP.VIGENCIA = 'S'
			WHERE CONTACTOPROP.ID_USRO = U.ID_USRO), 0) ID_PROPIETARIO, --AND CONTACTO.VIGENCIA = 'S' AND DUENO.VIGENCIA = 'S'
		ISNULL((select ID_DUEÑO
			from Adm_System_Contactos CONTACTODUE
				INNER JOIN dbo.Adm_System_Dueños DUENODUE
					ON CONTACTODUE.ID_CONTACTO = DUENODUE.ID_CONTACTO AND CONTACTODUE.ID_ORG = DUENODUE.ID_ORG AND DUENODUE.VIGENCIA = 'S' AND CONTACTODUE.VIGENCIA = 'S'
			WHERE CONTACTODUE.ID_USRO = U.ID_USRO), 0) ID_DUENO --AND CONTACTO.VIGENCIA = 'S' AND DUENO.VIGENCIA = 'S'
	,ISNULL(U.RECUPERACION_CLAVE, 0) RECUPERACION_CLAVE
	FROM Adm_System_Usuarios U
		INNER JOIN Adm_System_Perfiles_Usuarios ROL
			ON U.ID_USRO = ROL.ID_USRO
		INNER JOIN Adm_System_Origen_Usuarios ORIGEN
			ON ROL.ID_ORIGEN = ORIGEN.ID_ORIGEN
		INNER JOIN Adm_System_Tipo_Usuarios TIPO
			ON ROL.ID_TIPOUSRO = TIPO.ID_TIPOUSRO
		INNER JOIN Adm_System_Organizaciones ORG
			ON U.ID_ORG = ORG.ID_ORG
	WHERE U.USERNAME = @USERNAME AND U.PASS_USRO = @USERPASS AND U.VIGENCIA = 'S'
	
END
GO
