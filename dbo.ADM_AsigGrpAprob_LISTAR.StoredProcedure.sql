USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_AsigGrpAprob_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : LISTAR Informacion de tabla 
Parametros
Creado : .
Modifado : 1.
***********************************************
--Forma de Invocar.
***********************************************
***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_AsigGrpAprob_LISTAR]
	@ID_ORG NUMERIC(18, 0)
AS
SET NOCOUNT ON;
SELECT 
	asg.Fech_Creacion  ,
	asg.Fech_Actualiza ,
	asg.ID_Grupo  ,
	grp.Grupo_Aprobacion,
	asg.ID_Holding_Propietario ,	
	hop.Nombre as holding_propi,
	asg.ID_Dueño,
	asg.ID_Org						 ,
	org.Nombre as Nombre_organizacion,									
	asg.Vigencia  ,
	CONTACTO.NOMBRES + ' ' + CONTACTO.APELLIDO_PATERNO + ' ' + CONTACTO.APELLIDO_MATERNO NOMBRE_COMPLETO
		
FROM

 	Adm_System_Asignacion_Grupo_Aprobacion asg  	
 	INNER JOIN  Adm_System_Organizaciones org   ON  org.ID_Org = asg.ID_Org 	 
 	INNER JOIN  Adm_System_Holding hop  ON  hop.ID_Holding = asg.ID_Holding_Propietario	 
 	INNER JOIN  dbo.Adm_System_Grupo_Aprobacion grp  ON  grp.ID_Grupo = asg.ID_Grupo 	 			 	
 	INNER JOIN  dbo.Adm_System_Dueños due  ON due.ID_Dueño = asg.ID_Dueño 
	INNER JOIN Adm_System_Contactos CONTACTO ON DUE.ID_CONTACTO = CONTACTO.ID_CONTACTO
		WHERE org.ID_Org = @ID_ORG
GO
