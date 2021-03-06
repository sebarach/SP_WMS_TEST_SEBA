USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_SERVICIO_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_SERVICIO_INGRESO]
	 @Cod_Servicio numeric(18, 0)
	,@Nombre varchar(MAX)
	,@Id_Org numeric(18, 0)
	,@ID_Usro numeric(18, 0)
	,@Vigencia varchar(1)
AS
	SET NOCOUNT ON;
	--DECLARE @NUEVO_ID NUMERIC(18, 0);
	
	IF NOT EXISTS(SELECT * FROM Ventas_Servicios 
				  WHERE Cod_Servicio = @Cod_Servicio) BEGIN

		INSERT INTO Ventas_Servicios
           (Cod_Servicio
           ,Nombre
           ,Id_Org
           ,Fech_Creacion
           ,ID_Usro_Crea
           ,Vigencia)
		VALUES
			(@Cod_Servicio
			,@Nombre
			,@Id_Org
			,GETDATE()
			,@ID_Usro
			,@Vigencia)
		---RETORNO IDENTIFICADOR NUEVO USUARIO---
		--SET @NUEVO_ID = @@IDENTITY
		
		SELECT 1 AS ID
		
	END
	ELSE BEGIN
		
		update Ventas_Servicios
		SET  Nombre = @Nombre
			,Fech_Actualiza = GETDATE()
			,ID_Usro_Act = @ID_Usro
			,Vigencia = @Vigencia
		WHERE Cod_Servicio = @Cod_Servicio AND Id_Org = @Id_Org

		--- RETORNO FILAS AFECTADAS ---
		SELECT @@ROWCOUNT AS ID

	END


GO
