USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_RUBROS_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : LISTAR Informacion de tabla 
 Parametros
@ID_Rubro  : identificador de la tabla
 Creado : .
 Modifado : 1.
 ***********************************************
 --Forma de Invocar.
 ***********************************************
 ***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_RUBROS_LISTAR]
	@ID_ORG NUMERIC(18, 0)
 AS
 SET NOCOUNT ON;
SELECT 
	rub.ID_Rubro  ,
	rub.ID_Org  ,
	org.nombre as organi,
	rub.Descripcion  ,
	rub.Vigencia  	
FROM 
	Adm_System_Rubros rub 
	INNER  JOIN  Adm_System_Organizaciones org  ON  org.ID_Org = rub.ID_Org		
		WHERE rub.ID_Org = @ID_ORG
GO
