USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_SUCURSALCLIENTE_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_SUCURSALCLIENTE_LISTAR]
	-- Add the parameters for the stored procedure here	
--DECLARE
	 @Descriptor_Corta VARCHAR(MAX)
	,@ID_PROPIETARIO NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--SET @Descriptor_Corta = 'MA'
	--SET @ID_PROPIETARIO = 52
	--SET @ID_ORG	= 17
	
    -- Insert statements for procedure here
	SELECT H.RUT
		  ,H.NOMBRE
		  ,H.ID_HOLDING
		  ,H.ESPROPIETARIO
		  ,H.ID_TIPO_CONTACTO
		  --,D.ID_DIRECCION VALOR
		  ,D.CALLE + ' ' + '#' + D.NUMERO + ', ' + C.NOMBRE + ', ' + P.NOMBRE DIRECCION
	FROM Adm_System_Holding H
		INNER JOIN Adm_System_Direcciones D
			ON H.ID_DIRECCION = D.ID_DIRECCION AND H.ID_ORG = D.ID_ORG
		INNER JOIN Adm_System_Comunas C
			ON D.ID_COMUNA = C.ID_COMUNA
		INNER JOIN ADM_SYSTEM_PROVINCIAS P
			ON C.ID_PROVINCIA = P.ID_PROVINCIA
	WHERE H.ID_HOLDING_PROPIETARIO = @ID_PROPIETARIO
		AND	H.ID_Org = @ID_ORG
		AND H.VIGENCIA = 'S'
		AND H.ESPROPIETARIO = 0
		AND H.ID_TIPO_CONTACTO IN(2, 3)
		AND (H.NOMBRE LIKE '%'+ LTRIM(RTRIM(@Descriptor_Corta)) 
		+'%' OR D.Calle LIKE '%'+ LTRIM(RTRIM(@Descriptor_Corta)) +'%')

--SELECT * FROM Adm_System_Holding WHERE ID_TIPO_CONTACTO = 1

		--EXEC INV_SUCURSALCLIENTE_LISTAR 'pajaritos',1,17
	/*	
	SELECT * FROM Inventario_Items_Prop_Dueños
	
	SELECT * FROM Inventario_Items
	
	SELECT * FROM dbo.Adm_System_Holding
	
	SELECT * FROM dbo.Adm_System_Dueños
	
	SELECT * FROM Adm_System_Contactos
	
	*/
	
END
GO
