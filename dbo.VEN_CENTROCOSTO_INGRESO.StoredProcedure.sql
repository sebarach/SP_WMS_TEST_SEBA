USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_CENTROCOSTO_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_CENTROCOSTO_INGRESO]
	 @Cod_Centro numeric(18, 0)
	,@ID_Holding_Propietario numeric(18, 0)
	,@Nombre_CC varchar(MAX)
	,@ID_Org numeric(18, 0)
	,@ID_Usro numeric(18, 0)
	,@Vigencia varchar(1)
AS
	SET NOCOUNT ON;
	--DECLARE @NUEVO_ID NUMERIC(18, 0);
	
	IF NOT EXISTS(SELECT * FROM Ventas_Centros_Costos_Propietarios 
				  WHERE Cod_Centro = @Cod_Centro) BEGIN

		INSERT INTO Ventas_Centros_Costos_Propietarios
			(ID_Holding_Propietario
			,Nombre_CC
			,ID_Org
			,Fech_Creacion
			,ID_Usro_Crea
			,Vigencia)
		VALUES
			(@ID_Holding_Propietario
			,@Nombre_CC
			,@ID_Org
			,GETDATE()
			,@ID_Usro
			,@Vigencia)
		---RETORNO IDENTIFICADOR NUEVO USUARIO---
		--SET @NUEVO_ID = @@IDENTITY
		
		SELECT 1 AS ID
		
	END
	ELSE BEGIN
		
		update Ventas_Centros_Costos_Propietarios
		SET  Nombre_CC = @Nombre_CC
			,Fech_Actualiza = GETDATE()
			,ID_Usro_Act = @ID_Usro
			,Vigencia = @Vigencia
		WHERE Cod_Centro = @Cod_Centro AND ID_Org = @ID_Org AND ID_Holding_Propietario = @ID_Holding_Propietario

		--- RETORNO FILAS AFECTADAS ---
		SELECT @@ROWCOUNT AS ID

	END


GO
