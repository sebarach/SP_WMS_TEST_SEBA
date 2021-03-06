USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_CAMBIODUENO_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--INV_CAMBIODUENO_LISTAR '16-04-2018', '16-04-2018', 17
CREATE PROCEDURE [dbo].[INV_CAMBIODUENO_LISTAR]
	-- Add the parameters for the stored procedure here
	 --@COD_ITEM NUMERIC(18, 0)
	 @FECHAINI VARCHAR(10)
	,@FECHAFIN VARCHAR(10)	
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @FECHA_TERMINO DATETIME
	SELECT @FECHA_TERMINO = CONVERT(date,@FECHAFIN, 103)
	SET @FECHA_TERMINO = @FECHA_TERMINO + 1

    -- Insert statements for procedure here
	SELECT 
		 PROP.NOMBRE Propietario
		,(SELECT C1.NOMBRES + ' ' + C1.APELLIDO_PATERNO + ' ' + C1.APELLIDO_MATERNO ELEMENTO 
		FROM Adm_System_Dueños D1
			INNER JOIN Adm_System_Contactos C1
				ON D1.ID_CONTACTO = C1.ID_CONTACTO AND D1.ID_ORG = C1.ID_ORG
		WHERE D1.ID_ORG = @ID_ORG AND D1.ID_DUEÑO = HIST.ID_DUEÑO_ORIGEN) Origen
		,(SELECT C2.NOMBRES + ' ' + C2.APELLIDO_PATERNO + ' ' + C2.APELLIDO_MATERNO ELEMENTO 
		FROM Adm_System_Dueños D2
			INNER JOIN Adm_System_Contactos C2
				ON D2.ID_CONTACTO = C2.ID_CONTACTO AND D2.ID_ORG = C2.ID_ORG
		WHERE D2.ID_ORG = @ID_ORG AND D2.ID_DUEÑO = HIST.ID_DUEÑO_DESTINO) Destino
		,COD_ITEM Sku
		,USU.USERNAME Usuario -- + ' - ' + USU.NOMBRES + ' ' + USU.APELLIDO_PATERNO Usuario
		,ISNULL(Convert(varchar(10),CONVERT(date,HIST.FECHA_CAMBIO,106),103), '') FechaCambio
		--,HIST.*
	FROM Inventario_Historial_CambioDueños HIST
		INNER JOIN Adm_System_Holding PROP
			ON HIST.ID_PROPIETARIO = PROP.ID_HOLDING AND HIST.ID_ORG = PROP.ID_ORG
		INNER JOIN Adm_System_Usuarios USU
			ON HIST.ID_USRO = USU.ID_USRO AND HIST.ID_ORG = USU.ID_ORG
	WHERE --HIST.COD_ITEM = @COD_ITEM
		CONVERT(date,HIST.FECHA_CAMBIO, 103) BETWEEN CONVERT(date,@FECHAINI, 103) AND CONVERT(date,@FECHA_TERMINO, 103)
		AND HIST.ID_ORG = @ID_ORG
	
	
END


--select * from Inventario_Historial_CambioDueños
/*
DECLARE @FECHA DATETIME

SELECT @FECHA = CONVERT(date,'16-04-2018', 103)

SET @FECHA = @FECHA + 1

SELECT @FECHA 
*/
GO
