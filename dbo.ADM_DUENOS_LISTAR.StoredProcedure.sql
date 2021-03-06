USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_DUENOS_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : LISTAR Informacion de tabla 
 Parametros
@ID_Dueño  : identificador de la tabla
 Creado : .
 Modifado : 1.
 ***********************************************
 --Forma de Invocar.
 ***********************************************
 ***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_DUENOS_LISTAR]
	@VIGENCIA VARCHAR(1),
	@ID_ORG NUMERIC(18, 0)
AS
SET NOCOUNT ON;
 
SELECT 
	du.ID_Dueño  ,
	du.Fech_Creacion  ,
	du.Fech_Actualiza  ,
	du.ID_Contacto  ,
	ISNULL(CONTACTO.NOMBRES, '') + ' ' + ISNULL(CONTACTO.APELLIDO_PATERNO, '') + ' ' + ISNULL(CONTACTO.APELLIDO_MATERNO, '')   NOMBRE_COMPLETO,
	du.ID_Org  ,
	org.Nombre as Nombre_organizacion,
	du.ID_Holding_Propietario  ,
	hol.Nombre as nombre_holding ,	
	du.ID_Cargo  ,	
	cdu.Descripcion as cargo_dueno,
	du.ID_Usro_Crea  ,
	du.ID_Usro_Act  ,
	du.Vigencia  
 FROM  
  Adm_System_Dueños  du
  INNER JOIN  Adm_System_Organizaciones org  ON  org.ID_Org = du.ID_Org
  INNER JOIN  Adm_System_Cargos_Dueños  cdu  ON  cdu.ID_Cargo = du.ID_Cargo  and cdu.ID_Org =  org.ID_Org
  INNER JOIN  Adm_System_Holding  hol  ON  hol.ID_Holding = du.ID_Holding_Propietario   
	INNER JOIN Adm_System_Contactos CONTACTO ON DU.ID_CONTACTO = CONTACTO.ID_CONTACTO
		WHERE du.ID_Org = @ID_ORG
			AND du.VIGENCIA = @VIGENCIA

GO
