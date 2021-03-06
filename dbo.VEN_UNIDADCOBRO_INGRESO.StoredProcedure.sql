USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_UNIDADCOBRO_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_UNIDADCOBRO_INGRESO]
	 @Cod_Unidad numeric(18, 0)
	,@ID_Holding_Propietario numeric(18, 0)
	,@ID_Org numeric(18, 0)
	,@Cod_Servicio numeric(18, 0)
	,@Cod_Moneda numeric(18, 0)
	,@Valor_Costo numeric(18, 5)
	,@Valor_Venta numeric(18, 5)
	,@Valor_Utilidad numeric(18, 5)
	,@Dias_Mes numeric(18, 0)
	,@Total_Pos_Base numeric(18, 0)
	,@Tarifa_Diaria numeric(18, 5)
	,@ID_Usro numeric(18, 0)
	,@Vigencia varchar(1)
	,@Posicion_Proporcional varchar(2)
AS
	SET NOCOUNT ON;
	--DECLARE @NUEVO_ID NUMERIC(18, 0);
	
	IF NOT EXISTS(SELECT * FROM Ventas_Unidades_Cobro 
				  WHERE Cod_Unidad = @Cod_Unidad) BEGIN

		INSERT INTO Ventas_Unidades_Cobro
           (ID_Holding_Propietario
           ,ID_Org
           ,Cod_Servicio
           ,Cod_Moneda
           ,Valor_Costo
           ,Valor_Venta
           ,Valor_Utilidad
           ,Dias_Mes
           ,Total_Pos_Base
           ,Tarifa_Diaria
           ,Fech_Creacion
           ,ID_Usro_Crea
           ,Vigencia
           ,Posicion_Proporcional)
		VALUES
			(@ID_Holding_Propietario
			,@ID_Org
			,@Cod_Servicio
			,@Cod_Moneda
			,@Valor_Costo
			,@Valor_Venta
			,@Valor_Utilidad
			,@Dias_Mes
			,@Total_Pos_Base
			,@Tarifa_Diaria
			,GETDATE()
			,@ID_Usro
			,@Vigencia
			,@Posicion_Proporcional)
		---RETORNO IDENTIFICADOR NUEVO USUARIO---
		--SET @NUEVO_ID = @@IDENTITY
		
		SELECT 1 AS ID
		
	END
	ELSE BEGIN
		
		update Ventas_Unidades_Cobro
		SET  ID_Holding_Propietario = @ID_Holding_Propietario
			,Cod_Servicio = @Cod_Servicio
			,Cod_Moneda = @Cod_Moneda
			,Valor_Costo = @Valor_Costo
			,Valor_Venta = @Valor_Venta
			,Valor_Utilidad = @Valor_Utilidad
			,Dias_Mes = @Dias_Mes
			,Total_Pos_Base = @Total_Pos_Base
			,Tarifa_Diaria = @Tarifa_Diaria
			,Fech_Actualiza = GETDATE()
			,ID_Usro_Act = @ID_Usro
			,Vigencia = @Vigencia
			,Posicion_Proporcional = @Posicion_Proporcional
		WHERE Cod_Unidad = @Cod_Unidad AND ID_Org = @ID_Org

		--- RETORNO FILAS AFECTADAS ---
		SELECT @@ROWCOUNT AS ID

	END


GO
