USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_SUCUSARLES_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : LISTAR Informacion de tabla 
 Parametros
@ID_Holding  : identificador de la tabla
 Creado : .
 Modifado : 1.
 ***********************************************
 --Forma de Invocar.
 ***********************************************
 ***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_SUCUSARLES_LISTAR]
	@ID_PROPIETARIO NUMERIC(18, 0),
	@ID_ORG NUMERIC(18, 0) --,
	--@TIPO_CONTACTO NUMERIC(18, 0)
AS
SET NOCOUNT ON;

SELECT 
	hol.ID_Holding  ,
	hol.EsPropietario  ,
	hol.Fech_Creacion  ,
	hol.Fech_Actualiza  ,
	hol.ID_Org  ,
	org.Nombre as Nombre_organizacion,
	hol.ID_Holding_Propietario  ,	
	hol.Nombre as holding_propi,		
	hol.ID_Direccion  ,
	D.CALLE + ' ' + '#' + D.NUMERO + ' ' + C.NOMBRE direccion,
	hol.ID_Rubro  ,
	rub.Descripcion as rubro,		
	hol.RUT    ,
	hol.Nombre ,
	hol.id_tipo_contacto,
	tico.Descripcion Tipo  ,
	hol.Id_Procedencia  ,
	pro.Descripcion Procedencia  ,
	hol.Vigencia  
	
 FROM 
 
	Adm_System_Holding  hol 	
INNER JOIN  Adm_System_Organizaciones org  ON  org.ID_Org = hol.ID_Org	  
INNER JOIN  Adm_System_Rubros rub  ON  rub.ID_Rubro = hol.ID_Rubro	  
INNER JOIN  Adm_System_Holding hop  ON  hop.ID_Holding = hol.ID_Holding_Propietario	
INNER JOIN Adm_System_Direcciones D ON HOL.ID_DIRECCION = D.ID_DIRECCION
INNER JOIN Adm_System_Comunas C ON D.ID_COMUNA = C.ID_COMUNA
inner join Adm_System_Procedencias pro on hol.id_Procedencia = pro.id_procedencia
inner join Adm_Tipo_Contacto tico on hol.id_tipo_contacto = tico.id_tipo_contacto
	WHERE hol.EsPropietario = 0
		AND (HOL.ID_TIPO_CONTACTO = 2 or HOL.ID_TIPO_CONTACTO = 3)
		AND HOL.ID_Holding_Propietario = @ID_PROPIETARIO		
		AND hol.ID_Org = @ID_ORG
GO
