USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_CARGOSDUENOS_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : LISTAR Informacion de tabla 
 Parametros
@ID_Cargo  : identificador de la tabla
Creado : .
Modifado : 1.
***********************************************
--Forma de Invocar.
***********************************************
***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_CARGOSDUENOS_LISTAR]
	@ID_ORG NUMERIC(18, 0)
AS
SET NOCOUNT ON;

SELECT 
du.ID_Cargo  ,
du.Fech_Creacion  ,
du.Fech_Actualiza  ,
du.ID_Org  ,
org.Nombre as Nombre_organizacion,
du.Descripcion  ,
du.Vigencia  
FROM 
			Adm_System_Cargos_Dueños  du  
INNER JOIN  Adm_System_Organizaciones org  ON  org.ID_Org = du.ID_Org
	WHERE DU.ID_ORG = @ID_ORG

GO
