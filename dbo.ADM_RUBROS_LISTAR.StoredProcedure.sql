USE [iwmscl_testwms2]
GO
/****** Object:  StoredProcedure [dbo].[ADM_RUBROS_LISTAR]    Script Date: 20-07-2020 11:56:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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
