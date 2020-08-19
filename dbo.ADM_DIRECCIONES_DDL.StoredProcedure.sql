USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_DIRECCIONES_DDL]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADM_DIRECCIONES_DDL]
	-- Add the parameters for the stored procedure here
	@ID_COMUNA NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here   

	SELECT C.ID_DIRECCION VALOR, C.CALLE + ' ' + '#' + C.NUMERO ELEMENTO 
	FROM Adm_System_Direcciones C
	WHERE ID_COMUNA = @ID_COMUNA
	ORDER BY ELEMENTO ASC   
    

    
    --SELECT * FROM Adm_System_Dueños
    
    --SELECT * FROM Adm_System_Contactos

	
END
GO
