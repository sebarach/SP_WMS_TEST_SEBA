USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_ORGANIZACIONES_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : LISTAR Informacion de tabla 
 Parametros
@ID_Org  : identificador de la tabla
 Creado : .
 Modifado : 1.
 ***********************************************
 --Forma de Invocar.
 ***********************************************

 ***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_ORGANIZACIONES_LISTAR]
 AS
 SET NOCOUNT ON;
 
SELECT 
	org.ID_Org  ,
	org.Fech_Creacion  ,
	org.Fech_Actualiza  ,		
	org.ID_Org_Padre  ,
	orgp.Nombre  as orga_padre,
	org.ID_Direccion  ,
	org.ID_Usro_Crea  ,
	usuc.UserName as usu_crea,
	org.ID_Usro_Act  ,
	usua.UserName as  usu_act,		
	
	org.Nombre  ,
	org.Vigencia  
FROM 
	Adm_System_Organizaciones org 		
				
	LEFT JOIN  Adm_System_Organizaciones orgp  ON  orgp.ID_Org = org.ID_Org_Padre		
    INNER JOIN  Adm_System_Usuarios usuc  ON  usuc.ID_Usro = org.ID_Usro_Crea
    INNER JOIN  Adm_System_Usuarios usua  ON  usua.ID_Usro = org.ID_Usro_Act
    
GO
