USE [iwmscl_testwms2]
GO
/****** Object:  StoredProcedure [dbo].[ADM_CONTACTOSHOLDING_LISTAR]    Script Date: 20-07-2020 11:56:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ADM_CONTACTOSHOLDING_LISTAR]
	@ID_ORG NUMERIC(18, 0)
AS
SET NOCOUNT ON;

SELECT 

	coh.IsPrincipal    ,
	coh.ID_Holding  ,
	hol.Nombre as nombre_holding,
	coh.ID_Contacto  ,
	cto.NOMBRES + ' ' + cto.APELLIDO_PATERNO + ' ' + cto.APELLIDO_MATERNO as nombre_contacto,	
	coh.Vigencia 
FROM 
	Adm_System_Contactos_Holding  coh 
		
INNER JOIN  Adm_System_Holding	hol   ON  hol.ID_Holding = coh.ID_Holding
INNER JOIN  Adm_System_Contactos_Holding  ctoh  ON  ctoh.ID_Contacto = coh.ID_Contacto and ctoh.ID_Holding = hol.ID_Holding
INNER JOIN  Adm_System_Contactos cto  ON  cto.ID_Contacto = ctoh.ID_Contacto
	WHERE HOL.ID_ORG = @ID_ORG 







GO
