USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_AsigResp_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : LISTAR Informacion de tabla 
Parametros
@ID_Asignacion  : identificador de la tabla
Creado : .
Modifado : 1.
***********************************************
--Forma de Invocar.
***********************************************
***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_AsigResp_LISTAR]
AS

SET NOCOUNT ON;

SELECT 
	are.ID_Asignacion  ,
	are.Fech_Creacion  ,
	are.Fech_Actualiza  ,	
	are.ID_SubResp,
	sres.Nombre	as sub_reponsa,		
	are.ID_Perfil  ,	
	per.nombre as perfil_nombre,
	are.ID_Usro_Crea  ,
	usuc.UserName as usu_crea,
	are.ID_Usro_Act  ,
	usua.UserName as  usu_act,	
	are.Vigencia  
		
 FROM 
  
    Adm_System_Asignacion_Responsabilidades are                          
    INNER JOIN  Adm_System_Perfiles_Usuarios per  ON  per.ID_Perfil = are.ID_Perfil        
    INNER JOIN  Adm_System_Sub_Responsabilidades sres  ON  sres.ID_SubResp = are.ID_SubResp                  
    INNER JOIN  Adm_System_Usuarios usuc  ON  usuc.ID_Usro = are.ID_Usro_Crea
    INNER JOIN  Adm_System_Usuarios usua  ON  usua.ID_Usro = are.ID_Usro_Act 
              


GO
