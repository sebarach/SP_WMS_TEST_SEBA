USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_PerfilesUsuarios_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : LISTAR Informacion de tabla 
 Parametros
@ID_Perfil  : identificador de la tabla
 Creado : .
 Modifado : 1.
 ***********************************************
 --Forma de Invocar.
 ***********************************************
 ***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_PerfilesUsuarios_LISTAR]
	@ID_ORG NUMERIC(18, 0)
AS
SET NOCOUNT ON;
SELECT 
	per.ID_Perfil  ,
	per.Fech_Creacion  ,
	per.Fech_Actualiza  ,
	per.ID_Usro  ,	
	usu.UserName as usuario_perfil ,
	per.ID_TipoUsro  ,
	tdu.Tipo as tipo_usuario ,		
	per.ID_Origen  ,	
	orgu.Tipo_Origen ,
	per.ID_Org  ,
	org.Nombre as Nombre_organizacion,
	per.Nombre  Nombre,
	per.Vigencia  
	
 FROM Adm_System_Perfiles_Usuarios  per   
 INNER JOIN   Adm_System_Usuarios usu   ON  usu.ID_Usro = per.ID_Usro 
 INNER JOIN   Adm_System_Organizaciones org  ON  org.ID_Org = per.ID_Org
 INNER JOIN   Adm_System_Tipo_Usuarios tdu  ON  tdu.ID_TipoUsro = per.ID_TipoUsro  
 INNER JOIN   Adm_System_Origen_Usuarios orgu  ON  orgu.ID_Origen = per.ID_Origen  
	WHERE per.ID_Org = @ID_ORG

GO
