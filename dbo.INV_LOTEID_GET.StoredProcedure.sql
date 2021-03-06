USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_LOTEID_GET]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_LOTEID_GET]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Para crear el loteid
	declare @LOTE_PREFIJO numeric(18, 0) = (SELECT MAX(CAST(Folio_Prefijo_Lote AS NUMERIC(18, 0))) FROM Inventario_Folios_Todos);
	declare @LOTE_CORRELATIVO numeric(18, 0) = (SELECT Correlativo_Lote FROM Inventario_Folios_Todos WHERE Folio_Prefijo_Lote = @LOTE_PREFIJO);
	DECLARE @LOTE_ID NUMERIC(18, 0) = 
	(SELECT CAST(Folio_Prefijo_Lote AS VARCHAR(6)) + cast(REPLICATE('0', 6 - len(cast(@LOTE_CORRELATIVO as varchar(6)))) as varchar(6)) + cast(@LOTE_CORRELATIVO as varchar(6))
	FROM Inventario_Folios_Todos
	WHERE Folio_Prefijo_Lote = @LOTE_PREFIJO);
		
	UPDATE Inventario_Folios_Todos SET Correlativo_Lote = (Correlativo_Lote + 1) 
	--SELECT * FROM Inventario_Folios_Todos
	WHERE Folio_Prefijo_Lote = @LOTE_PREFIJO;
	
	select @LOTE_ID LOTE_ID
	
	
	
END
GO
