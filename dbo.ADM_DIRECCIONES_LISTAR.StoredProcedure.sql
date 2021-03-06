USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_DIRECCIONES_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ADM_DIRECCIONES_LISTAR]
	@ID_ORG NUMERIC(18, 0)
AS
SET NOCOUNT ON;

SELECT 
	di.ID_Direccion  ,
	di.ID_Org  ,
	org.Nombre as Nombre_organizacion,
	di.ID_Comuna  ,
	com.Nombre as nombre_comuna,
	di.ID_Pais  ,
	pas.Nombre as nombre_pais,
	di.Calle  ,
	di.Numero  ,
	di.Observaciones  ,
	di.Direccion_Completa  
FROM 
Adm_System_Direcciones  di 
INNER JOIN  Adm_System_Organizaciones org  ON  org.ID_Org = di.ID_Org
INNER JOIN  Adm_System_Paises pas  ON  pas.ID_Pais = di.ID_Pais
INNER JOIN  Adm_System_Comunas com  ON  com.ID_Comuna = di.ID_Comuna
	WHERE di.ID_Org = @ID_ORG

GO
