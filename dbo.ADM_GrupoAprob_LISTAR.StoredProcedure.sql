USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_GrupoAprob_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : LISTAR Informacion de tabla 
 Parametros
@ID_Grupo  : identificador de la tabla
 Creado : .
 Modifado : 1.
 ***********************************************
 --Forma de Invocar.
 ***********************************************

 ***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_GrupoAprob_LISTAR]
	@ID_ORG NUMERIC(18, 0)
AS
SET NOCOUNT ON;

SELECT 
	grp.ID_Grupo  ,
	grp.Fech_Creacion  ,
	grp.Fech_Actualiza  ,
	grp.ID_Holding_Propietario  ,
	hop.Nombre as holding_propi,		
	grp.ID_ClasCargo  ,
	clas.Clasificacion_Cargo,	
	grp.ID_PosCargo  ,	
	pos.Posicion_Cargo ,	
	grp.ID_Tipo_Documento  ,	
	tipo.Tipo_Documento ,
	grp.ID_Org  ,
	org.Nombre as Nombre_organizacion,
	grp.Monto_Desde  ,
	grp.Monto_Hasta  ,				
	grp.Grupo_Aprobacion  ,
	grp.Vigencia  		
FROM
 
Adm_System_Grupo_Aprobacion  grp 
INNER JOIN  Adm_System_Organizaciones org  ON  org.ID_Org = grp.ID_Org 	
INNER JOIN  Adm_System_Holding hop  ON  hop.ID_Holding = grp.ID_Holding_Propietario
INNER JOIN  Adm_System_Clas_Cargos clas  ON  clas.ID_ClasCargo = grp.ID_ClasCargo
INNER JOIN  Adm_System_Posicion_Cargos pos  ON  pos.ID_PosCargo = grp.ID_PosCargo
INNER JOIN  Adm_System_Tipo_Doc_Aprobacion tipo  ON  tipo.ID_Tipo_Documento = grp.ID_Tipo_Documento
	WHERE grp.ID_Org = @ID_ORG

GO
