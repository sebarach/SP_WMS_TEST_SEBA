USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_PRODUCTO_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_PRODUCTO_LISTAR]
	-- Add the parameters for the stored procedure here	
	@Descriptor_Corta VARCHAR(256),
	@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT H.ID_HOLDING
		  ,H.NOMBRE PROPIETARIO
		  ,D.ID_DUEÑO
		  ,C.NOMBRES + ' ' + C.APELLIDO_PATERNO  CONTACTO
		  ,P.COD_ITEM
		  ,P.Descriptor_Corta Descriptor_Larga
	FROM Inventario_Items_Prop_Dueños PD
		INNER JOIN Inventario_Items P
			ON PD.Cod_Item = P.Cod_Item AND PD.ID_Org = P.ID_Org
		INNER JOIN Adm_System_Holding H
			ON PD.ID_Propietario = H.ID_HOLDING AND PD.ID_Org = H.ID_ORG
		INNER JOIN Adm_System_Dueños D
			ON PD.ID_Dueño = D.ID_DUEÑO AND PD.ID_Org = D.ID_ORG
		INNER JOIN Adm_System_Contactos C
			ON D.ID_CONTACTO = C.ID_CONTACTO AND D.ID_ORG = C.ID_ORG
	WHERE --H.ESPROPIETARIO = 1 AND 
			P.ID_Org = @ID_ORG
		AND P.Vigencia = 'S'
		AND H.VIGENCIA = 'S'
		AND D.VIGENCIA = 'S'
		AND C.VIGENCIA = 'S'
		AND P.Descriptor_Corta LIKE @Descriptor_Corta + '%'
		
	/*	
	SELECT * FROM Inventario_Items_Prop_Dueños
	
	SELECT * FROM Inventario_Items
	
	SELECT * FROM dbo.Adm_System_Holding
	
	SELECT * FROM dbo.Adm_System_Dueños
	
	SELECT * FROM Adm_System_Contactos
	
	*/
	
END
GO
