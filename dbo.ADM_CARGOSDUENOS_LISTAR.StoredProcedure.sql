USE [iwmscl_testwms2]
GO
/****** Object:  StoredProcedure [dbo].[ADM_CARGOSDUENOS_LISTAR]    Script Date: 20-07-2020 11:56:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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
