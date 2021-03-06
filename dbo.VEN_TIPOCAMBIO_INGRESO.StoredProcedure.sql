USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_TIPOCAMBIO_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_TIPOCAMBIO_INGRESO]
	 @Cod_Moneda numeric(18, 0)
	,@Año numeric(18, 0)
	,@Mes numeric(18, 0)
	,@Dia numeric(18, 0)
	,@Valor numeric(18, 8)
	,@Vigencia varchar(1)
	,@usuario numeric(18, 0)
	--,@id_org numeric(18, 0)
AS
	SET NOCOUNT ON;
	--DECLARE @NUEVO_ID NUMERIC(18, 0);
	
	IF NOT EXISTS(SELECT * FROM Ventas_Tipo_Cambio 
				  WHERE Cod_Moneda = @Cod_Moneda 
					AND Año = @Año
					AND Mes = @Mes
					AND Dia = @Dia) BEGIN

		INSERT INTO Ventas_Tipo_Cambio
		(Cod_Moneda
		,Año
		,Mes
		,Dia
		,Valor
		,Fech_Creacion
		,Fech_Actualiza
		,ID_Usro_Crea
		,ID_Usro_Act
		,Vigencia)
		VALUES
		(@Cod_Moneda
		,@Año
		,@Mes
		,@Dia
		,@Valor
		,GETDATE()
		,NULL
		,@usuario
		,NULL
		,@Vigencia 
		)
		---RETORNO IDENTIFICADOR NUEVO USUARIO---
		--SET @NUEVO_ID = @@IDENTITY
		
		SELECT 1 AS ID
		
	END
	ELSE BEGIN
		
		update Ventas_Tipo_Cambio
		SET  Valor = @Valor
			,Fech_Actualiza = GETDATE()
			,ID_Usro_Act = @usuario
			,Vigencia = @Vigencia
		WHERE Cod_Moneda = @Cod_Moneda
			and Año = @Año
			AND Mes = @Mes
			AND Dia = @Dia

		--- RETORNO FILAS AFECTADAS ---
		SELECT @@ROWCOUNT AS ID

	END


GO
