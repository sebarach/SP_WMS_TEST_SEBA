USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_PRODUCTO_OBTENERFECHASLOTES]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_PRODUCTO_OBTENERFECHASLOTES]
	-- Add the parameters for the stored procedure here
	 @COD_ITEM NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT ID_LOTE LOTE, ISNULL(Convert(varchar(10),CONVERT(date,Fecha_Expira,106),103), '') FECHA
	FROM Inventario_Lotes
	WHERE Cod_Item = @COD_ITEM --51903
		AND ID_Org = @ID_ORG
	ORDER BY Fecha_Expira DESC


END
GO
