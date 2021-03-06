USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_PRODUCTO_SELECT]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_PRODUCTO_SELECT]
	-- Add the parameters for the stored procedure here	
	@ID_PROPIETARIO NUMERIC(18, 0),
	@ID_DUENO NUMERIC(18, 0),
	@ID_PRODUCTO NUMERIC(18, 0),
	@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE 
	@TABLA TABLE(CODIGO NUMERIC(18, 0));
	DECLARE @CODIGO_CAMP NUMERIC(18, 0) = 0;
	
	INSERT INTO @TABLA
	SELECT COD_CAMPAÑA FROM [Inventario_Campaña_Propietarios_Dueños]
	WHERE COD_ITEM = @ID_PRODUCTO
	and ID_Usro_Act = 1
	ORDER BY FECHA_INICIO DESC
	
	--Si tiene campaña realiza el join para traerse el cógigo y nombre de campaña
	IF EXISTS(SELECT TOP 1 CODIGO FROM @TABLA) BEGIN
		SET @CODIGO_CAMP = (SELECT TOP 1 CODIGO FROM @TABLA)
		
		SELECT Descriptor_Corta
			  ,Descriptor_Larga
			  ,P.ID_UM
			  ,Ficha_Imagen
			  ,Largo
			  ,Ancho
			  ,Alto
			  ,Volumen
			  ,Dias_En_Estante
			  ,CAMP.Cod_Campaña
			  ,Precio_Compra
			  ,Control_Lote
			  ,Combinacion_Categoria
			  ,Nota
			  ,UM.Unidad_Medida_Abreviada
			  ,CAMP.Nombre_Campaña
			  ,ISNULL(P.Total_Cajas_Pallets, 0) Total_Cajas_Pallets
			  ,ISNULL(P.Unidades_Cajas, 0) Unidades_Cajas
			  ,ISNULL(P.Total_Unidades_Pallets, 0) Total_Unidades_Pallets
			  ,ISNULL(P.Peso_Gramos, 0) Peso_Gramos
			  ,P.Codigo_Prod_Cliente Codigo_Prod_Cliente
		FROM Inventario_Items_Prop_Dueños PD
			INNER JOIN Inventario_Items P
				ON PD.Cod_Item = P.Cod_Item AND PD.ID_Org = P.ID_Org
			INNER JOIN Inventario_Unidad_Medida_Primaria UM
				ON P.ID_UM = UM.ID_UM
			INNER JOIN Inventario_Campaña_Propietarios_Dueños CAMP
				ON P.COD_ITEM = CAMP.COD_ITEM AND CAMP.Cod_Campaña = @CODIGO_CAMP
			--INNER JOIN Adm_System_Holding H
			--	ON PD.ID_Propietario = H.ID_HOLDING AND PD.ID_Org = H.ID_ORG
			--INNER JOIN Adm_System_Dueños D
			--	ON PD.ID_Dueño = D.ID_DUEÑO AND PD.ID_Org = D.ID_ORG
			--INNER JOIN Adm_System_Contactos C
		WHERE --H.ESPROPIETARIO = 1 AND 
				P.ID_Org = @ID_ORG
			AND P.Vigencia = 'S'
			and CAMP.vigencia = 'S'
			--AND H.VIGENCIA = 'S'
			--AND D.VIGENCIA = 'S'
			AND PD.ID_Propietario = @ID_PROPIETARIO
			AND PD.ID_Dueño = @ID_DUENO
			AND PD.Cod_Item = @ID_PRODUCTO
			and camp.ID_Usro_Act = 1
		
	END ELSE BEGIN
    --Si no tiene campaña no realiza join con la tabla
	SELECT Descriptor_Corta
		  ,Descriptor_Larga
		  ,P.ID_UM
		  ,Ficha_Imagen
		  ,Largo
		  ,Ancho
		  ,Alto
		  ,Volumen
		  ,Dias_En_Estante
		  ,0 Cod_Campaña
		  ,Precio_Compra
		  ,Control_Lote
		  ,Combinacion_Categoria
		  ,Nota
		  ,UM.Unidad_Medida_Abreviada
		  ,'' Nombre_Campaña
		  ,ISNULL(P.Total_Cajas_Pallets, 0) Total_Cajas_Pallets
		  ,ISNULL(P.Unidades_Cajas, 0) Unidades_Cajas
		  ,ISNULL(P.Total_Unidades_Pallets, 0) Total_Unidades_Pallets
		  ,ISNULL(P.Peso_Gramos, 0) Peso_Gramos
		  ,P.Codigo_Prod_Cliente Codigo_Prod_Cliente  
	FROM Inventario_Items_Prop_Dueños PD
		INNER JOIN Inventario_Items P
			ON PD.Cod_Item = P.Cod_Item AND PD.ID_Org = P.ID_Org
		INNER JOIN Inventario_Unidad_Medida_Primaria UM
			ON P.ID_UM = UM.ID_UM
		--INNER JOIN Inventario_Campaña_Propietarios_Dueños CAMP
		--	ON P.COD_ITEM = CAMP.COD_ITEM AND CAMP.Cod_Campaña = @CODIGO_CAMP
		--INNER JOIN Adm_System_Holding H
		--	ON PD.ID_Propietario = H.ID_HOLDING AND PD.ID_Org = H.ID_ORG
		--INNER JOIN Adm_System_Dueños D
		--	ON PD.ID_Dueño = D.ID_DUEÑO AND PD.ID_Org = D.ID_ORG
		--INNER JOIN Adm_System_Contactos C
	WHERE --H.ESPROPIETARIO = 1 AND 
			P.ID_Org = @ID_ORG
		AND P.Vigencia = 'S'
		--AND H.VIGENCIA = 'S'
		--AND D.VIGENCIA = 'S'
		AND PD.ID_Propietario = @ID_PROPIETARIO
		AND PD.ID_Dueño = @ID_DUENO
		AND PD.Cod_Item = @ID_PRODUCTO
	END
	/*	
	SELECT * FROM Inventario_Items_Prop_Dueños
	
	SELECT * FROM Inventario_Items
	
	SELECT * FROM dbo.Adm_System_Holding
	
	SELECT * FROM dbo.Adm_System_Dueños
	*/
	
END
GO
