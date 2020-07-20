USE [iwmscl_testwms2]
GO
/****** Object:  StoredProcedure [dbo].[INV_CATEGORIA2_DDL]    Script Date: 20-07-2020 11:56:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_CATEGORIA2_DDL]
	-- Add the parameters for the stored procedure here
	@ID_CATEGO1 VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here   

	SELECT C.Cod_Categ2 VALOR, C.Nombre_Categ2 ELEMENTO
	FROM Inventario_Categoria2 C
	WHERE C.Vigente = 'S'
		AND C.Cod_Categ1 = @ID_CATEGO1
	ORDER BY ELEMENTO ASC   
    
    --SELECT * FROM Adm_System_Dueños
    
    --SELECT * FROM Adm_System_Contactos

	
END
GO
