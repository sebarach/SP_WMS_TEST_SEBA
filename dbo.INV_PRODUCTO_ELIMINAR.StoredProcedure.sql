USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_PRODUCTO_ELIMINAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_PRODUCTO_ELIMINAR]
	-- Add the parameters for the stored procedure here	
	 @Cod_Item	numeric(18, 0)
	,@ID_Org	numeric(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	UPDATE [dbo].[Inventario_Items]
	SET Vigencia = 'N'
	WHERE [ID_Org] = @ID_Org AND Cod_Item = @Cod_Item

	SELECT @@ROWCOUNT FILAS_AFECTADAS

	/*	
	SELECT * FROM Inventario_Items_Prop_Dueños
	
	SELECT * FROM Inventario_Items
	
	SELECT * FROM dbo.Adm_System_Holding
	
	SELECT * FROM dbo.Adm_System_Dueños
	*/
	
END
GO
