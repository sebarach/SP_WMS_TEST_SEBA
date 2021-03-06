USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[Adm_Contactos_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : LISTAR Informacion de tabla 
Parametros
@ID_Contacto  : identificador de la tabla
 Creado : .
 Modifado : 1.
 ***********************************************
 --Forma de Invocar.
 ***********************************************
 ***********************************************
*/
CREATE PROCEDURE [dbo].[Adm_Contactos_LISTAR]
	@ID_ORG NUMERIC(18, 0)
AS
SET NOCOUNT ON;

SELECT 
	con.ID_Contacto  ,
	con.ID_Org  ,
	org.Nombre as Nombre_organizacion,		
	con.Nombres  ,
	con.Apellido_Paterno  ,
	con.Apellido_Materno  ,
	con.Fono  ,
	con.Celular  ,
	con.Correo  ,
	con.Nombre_Completo  ,
	CON.ID_USRO UsuarioId,
	USU.USERNAME + ' - ' +  USU.NOMBRES + ' ' + USU.APELLIDO_PATERNO Usuario,
	con.Vigencia  	
FROM 
	Adm_System_Contactos  con 
	INNER JOIN  Adm_System_Organizaciones org   ON  org.ID_Org = con.ID_Org    
	INNER JOIN Adm_System_Usuarios USU ON CON.ID_USRO = USU.ID_USRO AND CON.ID_ORG = USU.ID_ORG
	WHERE con.ID_Org = @ID_ORG

GO
