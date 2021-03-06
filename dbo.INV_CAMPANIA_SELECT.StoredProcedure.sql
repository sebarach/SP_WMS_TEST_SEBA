USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_CAMPANIA_SELECT]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_CAMPANIA_SELECT]
	-- Add the parameters for the stored procedure here	
	 @Cod_Campaña NUMERIC(18, 0),
	 @cod_item numeric(18, 0),
	 @ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    IF @Cod_Campaña = 0 BEGIN
    
		SELECT Cod_Campaña
			  ,Nombre_Campaña
			  ,Convert(varchar(10),CONVERT(date,Fecha_Inicio,106),103) Fecha_Inicio
			  ,Convert(varchar(10),CONVERT(date,Fecha_Termino,106),103) Fecha_Termino
		  FROM [dbo].[Inventario_Campaña_Propietarios_Dueños]
		  WHERE Vigencia = 'S' AND ID_ORG = @ID_ORG
		    AND cod_item = @cod_item
			AND Fecha_Inicio = (SELECT MAX(Fecha_Inicio) FROM [Inventario_Campaña_Propietarios_Dueños])
	END
	ELSE BEGIN
	
		SELECT Cod_Campaña
			  ,Nombre_Campaña
			  ,Convert(varchar(10),CONVERT(date,Fecha_Inicio,106),103) Fecha_Inicio
			  ,Convert(varchar(10),CONVERT(date,Fecha_Termino,106),103) Fecha_Termino
		  FROM [dbo].[Inventario_Campaña_Propietarios_Dueños]
		  WHERE Vigencia = 'S' AND ID_ORG = @ID_ORG
			AND cod_item = @cod_item
			AND [Cod_Campaña] = @Cod_Campaña
	
	END 
		
	/*	
	SELECT * FROM Inventario_Items_Prop_Dueños
	
	SELECT * FROM Inventario_Items
	
	SELECT * FROM dbo.Adm_System_Holding
	
	SELECT * FROM dbo.Adm_System_Dueños
	*/
	
END
GO
