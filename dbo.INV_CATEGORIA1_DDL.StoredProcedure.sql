USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_CATEGORIA1_DDL]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_CATEGORIA1_DDL]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here   

	SELECT C.Cod_Categ1 VALOR, C.Nombre_Categ1 ELEMENTO
	FROM Inventario_Categoria1 C
	WHERE C.Vigente = 'S'
	ORDER BY ELEMENTO ASC   
    
    --SELECT * FROM Adm_System_Dueños
    
    --SELECT * FROM Adm_System_Contactos

	
END
GO
