USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_ENVIO_ASIGNAR_NROENTREGA]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- ================================================
---- Template generated from Template Explorer using:
---- Create Procedure (New Menu).SQL
----
---- Use the Specify Values for Template Parameters 
---- command (Ctrl-Shift-M) to fill in the parameter 
---- values below.
----
---- This block of comments will not be included in
---- the definition of the procedure.
---- ================================================
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
/*
EXEC INV_ENVIO_ASIGNAR_NROENTREGA 304, 21, 17, 4,
'<root>
  <f id="1" solicitudid="304" pedidoid="21" chkseleccion="True" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="12" dueno="PERCY ROSS STANLEY" direccionid="6030" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="4" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="1" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000033" loteproveedor="S/L" fechavencimiento="25/06/2017" cantidadpedida="80" cantidadpendiente="80" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
  <f id="2" solicitudid="304" pedidoid="21" chkseleccion="True" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="12" dueno="PERCY ROSS STANLEY" direccionid="6030" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="4" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="2" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000032" loteproveedor="S/L" fechavencimiento="30/06/2017" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
</root>'

*/
CREATE PROCEDURE [dbo].[INV_ENVIO_ASIGNAR_NROENTREGA]
	-- Add the parameters for the stored procedure here
--DECLARE
	 @FOLIO_DOCUMENTO NUMERIC(18, 0)	
	,@ID_NROPEDIDO numeric(18, 0)	 
	,@ID_Org numeric(18, 0)
	,@ID_USRO_ACT NUMERIC(18, 0)		
	,@XML varchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

/*


'<root>
  <f id="1" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="12" dueno="PERCY ROSS STANLEY A" direccionid="6030" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="1" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000033" loteproveedor="S/L" fechavencimiento="25/06/2017" cantidadpedida="80" cantidadpendiente="80" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
  <f id="2" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="13" dueno="PERCY ROSS STANLEY B" direccionid="6030" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="2" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000032" loteproveedor="S/L" fechavencimiento="30/06/2017" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />  
  <f id="3" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="14" dueno="PERCY ROSS STANLEY C" direccionid="6040" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="2" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000032" loteproveedor="S/L" fechavencimiento="30/06/2017" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
  <f id="4" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="15" dueno="PERCY ROSS STANLEY D" direccionid="6050" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="2" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000032" loteproveedor="S/L" fechavencimiento="30/06/2017" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
  <f id="5" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="16" dueno="PERCY ROSS STANLEY E" direccionid="6060" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="1" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000033" loteproveedor="S/L" fechavencimiento="25/06/2017" cantidadpedida="80" cantidadpendiente="80" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
  <f id="6" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="16" dueno="PERCY ROSS STANLEY E" direccionid="6060" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="2" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000032" loteproveedor="S/L" fechavencimiento="30/06/2017" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />  
  <f id="7" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="17" dueno="PERCY ROSS STANLEY F" direccionid="6060" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="2" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000032" loteproveedor="S/L" fechavencimiento="30/06/2017" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
  <f id="8" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="17" dueno="PERCY ROSS STANLEY F" direccionid="6060" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="2" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000032" loteproveedor="S/L" fechavencimiento="30/06/2017" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />  
</root>'

*/

--	SET @FOLIO_DOCUMENTO = 304
--	SET @ID_NROPEDIDO = 21
--	SET @ID_Org = 17
--	SET @ID_USRO_ACT = 4
--	SET @XML = '<root>
--  <f id="1" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="12" dueno="PERCY ROSS STANLEY" direccionid="6030" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="1" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000033" loteproveedor="S/L" fechavencimiento="25/06/2017" cantidadpedida="80" cantidadpendiente="80" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
--  <f id="2" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="12" dueno="PERCY ROSS STANLEY" direccionid="6030" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="2" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000032" loteproveedor="S/L" fechavencimiento="30/06/2017" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
--</root>'


	DECLARE @FECHA_TRANSACCION DATETIME = (SELECT GETDATE());	

	DECLARE @OXML XML;
	SET @OXML = N'''' + @XML + '''';
	
	--TABLA TEMPORAL DEL XML
	DECLARE @TABLAXML TABLE(
		id numeric(18, 0)	,
		solicitudid numeric(18, 0)	,
		pedidoid numeric(18, 0)	,
		chkseleccion varchar(6)	,
		chkdistribucion varchar(6)	,
		propietarioid numeric(18, 0)	,
		propietario varchar(250)	,
		duenoid numeric(18, 0)	,
		dueno varchar(250)	,
		direccionid numeric(18, 0)	,
		direccion varchar(300)	,
		nombredestinatario varchar(250)	,
		numeroentrega numeric(18, 0)	,
		estadolineaactualid numeric(18, 0)	,
		estadolineaactual varchar(250)	,
		estadolineasiguiente varchar(250)	,
		nrolinea numeric(18, 0)	,
		nrosublinea numeric(18, 0)	,
		productoid numeric(18, 0)	,
		descriptor varchar(250)	,
		loteid varchar(50)	,
		loteproveedor varchar(250)	,
		fechavencimiento varchar(20)	,
		cantidadpedida numeric(18, 0)	,
		cantidadpendiente numeric(18, 0)	,
		cantidadpickeada numeric(18, 0)	,
		cantidadenviar numeric(18, 0)	,
		precio numeric(18, 0)	,
		subinventarioorigenid numeric(18, 0)	,
		subinventarioorigen varchar(250)	,
		localizadororigenid numeric(18, 0)	,
		localizadororigen varchar(250)	,
		subinventariodestino varchar(250)	,
		operario varchar(250)	
	)
	
	
	INSERT INTO @TABLAXML
	SELECT
		 Tbl.Col.value('@id', 'numeric(18, 0)') id
		,Tbl.Col.value('@solicitudid', 'numeric(18, 0)') solicitudid
		,Tbl.Col.value('@pedidoid', 'numeric(18, 0)') pedidoid
		,Tbl.Col.value('@chkseleccion', 'varchar(6)') chkseleccion
		,Tbl.Col.value('@chkdistribucion', 'varchar(6)') chkdistribucion
		,Tbl.Col.value('@propietarioid', 'numeric(18, 0)') propietarioid
		,Tbl.Col.value('@propietario', 'varchar(250)') propietario
		,Tbl.Col.value('@duenoid', 'numeric(18, 0)') duenoid
		,Tbl.Col.value('@dueno', 'varchar(250)') dueno
		,Tbl.Col.value('@direccionid', 'numeric(18, 0)') direccionid
		,Tbl.Col.value('@direccion', 'varchar(300)') direccion
		,Tbl.Col.value('@nombredestinatario', 'varchar(250)') nombredestinatario
		,Tbl.Col.value('@numeroentrega', 'numeric(18, 0)') numeroentrega
		,Tbl.Col.value('@estadolineaactualid', 'numeric(18, 0)') estadolineaactualid
		,Tbl.Col.value('@estadolineaactual', 'varchar(250)') estadolineaactual
		,Tbl.Col.value('@estadolineasiguiente', 'varchar(250)') estadolineasiguiente
		,Tbl.Col.value('@nrolinea', 'numeric(18, 0)') nrolinea
		,Tbl.Col.value('@nrosublinea', 'numeric(18, 0)') nrosublinea
		,Tbl.Col.value('@productoid', 'numeric(18, 0)') productoid
		,Tbl.Col.value('@descriptor', 'varchar(250)') descriptor
		,Tbl.Col.value('@loteid', 'varchar(50)') loteid
		,Tbl.Col.value('@loteproveedor', 'varchar(250)') loteproveedor
		,Tbl.Col.value('@fechavencimiento', 'varchar(20)') fechavencimiento
		,Tbl.Col.value('@cantidadpedida', 'numeric(18, 0)') cantidadpedida
		,Tbl.Col.value('@cantidadpendiente', 'numeric(18, 0)') cantidadpendiente
		,Tbl.Col.value('@cantidadpickeada', 'numeric(18, 0)') cantidadpickeada
		,Tbl.Col.value('@cantidadenviar', 'numeric(18, 0)') cantidadenviar
		,Tbl.Col.value('@precio', 'numeric(18, 0)') precio
		,Tbl.Col.value('@subinventarioorigenid', 'numeric(18, 0)') subinventarioorigenid
		,Tbl.Col.value('@subinventarioorigen', 'varchar(250)') subinventarioorigen
		,Tbl.Col.value('@localizadororigenid', 'numeric(18, 0)') localizadororigenid
		,Tbl.Col.value('@localizadororigen', 'varchar(250)') localizadororigen
		,Tbl.Col.value('@subinventariodestino', 'varchar(250)') subinventariodestino
		,Tbl.Col.value('@operario', 'varchar(250)') operario
	FROM @OXML.nodes('//root/f') Tbl(Col)	


BEGIN TRAN
BEGIN TRY

	--ASIGNAR NRO DE ENTREGA
	DECLARE @NRO_ENTREGA NUMERIC(18, 0) = (SELECT (FOLIO_NUM_ENTREGA - 1) FROM Inventario_Folios_Todos);
	DECLARE @NRO_ACTUAL NUMERIC(18, 0) = @NRO_ENTREGA+1;
	UPDATE Inventario_Folios_Todos
		SET FOLIO_NUM_ENTREGA = FOLIO_NUM_ENTREGA
	WHERE FOLIO_NUM_ENTREGA = @NRO_ACTUAL;
	
	DECLARE @TEMP_DIR NUMERIC(18, 0) = 0;
	DECLARE @TEMP_DUENO NUMERIC(18, 0) = 0;
	
	DECLARE 
		 @CDIR_DIRECCION NUMERIC(18, 0)
		,@CDIR_DUENO NUMERIC(18, 0)
		,@CDIR_NRO_ENTREGA NUMERIC(18, 0)
		,@CDIR_NRO_PEDIDO NUMERIC(18, 0)
	
	--SELECT
	--	 direccionid
	--	,duenoid
	--	,numeroentrega
	--	,pedidoid
	--FROM @TABLAXML
	--ORDER BY direccionid ASC, duenoid ASC	
	
	DECLARE CDIRECCION CURSOR FOR
	SELECT
		 direccionid
		,duenoid
		,numeroentrega
		,pedidoid
	FROM @TABLAXML
	WHERE chkseleccion = 'True'
	--GROUP BY direccionid, duenoid, numeroentrega
	ORDER BY direccionid ASC, duenoid ASC
	
	OPEN CDIRECCION
	
	FETCH CDIRECCION INTO 
		 @CDIR_DIRECCION
		,@CDIR_DUENO
		,@CDIR_NRO_ENTREGA
		,@CDIR_NRO_PEDIDO		
		
	WHILE (@@FETCH_STATUS = 0) BEGIN
		
		IF @TEMP_DIR <> @CDIR_DIRECCION BEGIN
			
			SET @TEMP_DIR = @CDIR_DIRECCION;
			
			IF @TEMP_DUENO <> @CDIR_DUENO BEGIN
				
				IF @CDIR_NRO_ENTREGA = 0 BEGIN
					SET @TEMP_DUENO = @CDIR_DUENO;
					--TOMAMOS EL ULTIMO FOLIO
					SET @NRO_ENTREGA = @NRO_ENTREGA + 1
					
					PRINT 'DIRECCIONES DISTINTAS, DUEÑOS DISTINTOS - ASIGNAR: ' + CAST(@NRO_ENTREGA AS VARCHAR(20))
					
					
					--SELECT * FROM Inventario_Detalle_Trx_Pedidos
					UPDATE Inventario_Detalle_Trx_Pedidos
						SET Nro_Entrega = @NRO_ENTREGA
							,ID_Usro_Act = @ID_USRO_ACT
							,Fech_Actualiza = @FECHA_TRANSACCION
					WHERE ID_NroPedido = @CDIR_NRO_PEDIDO 
						AND ID_Org = @ID_Org
						AND cod_estado_linea <> 100;
					
					UPDATE @TABLAXML
						SET numeroentrega = @NRO_ENTREGA
					WHERE direccionid = @CDIR_DIRECCION AND duenoid = @CDIR_DUENO AND pedidoid = @CDIR_NRO_PEDIDO
					
				END 
			
			END
			ELSE BEGIN
				
				IF @CDIR_NRO_ENTREGA = 0 BEGIN
					--TOMAMOS EL ULTIMO FOLIO
					SET @NRO_ENTREGA = @NRO_ENTREGA + 1
					
					PRINT 'DIRECCIONES DISTINTAS, CON IGUAL DUEÑO - ASIGNAR: ' + CAST(@NRO_ENTREGA AS VARCHAR(20))	
					
					--SELECT * FROM Inventario_Detalle_Trx_Pedidos
					UPDATE Inventario_Detalle_Trx_Pedidos
						SET Nro_Entrega = @NRO_ENTREGA
							,ID_Usro_Act = @ID_USRO_ACT
							,Fech_Actualiza = @FECHA_TRANSACCION
					WHERE ID_NroPedido = @CDIR_NRO_PEDIDO 
						AND ID_Org = @ID_Org
						AND cod_estado_linea <> 100;

					UPDATE @TABLAXML
						SET numeroentrega = @NRO_ENTREGA
					WHERE direccionid = @CDIR_DIRECCION AND duenoid = @CDIR_DUENO AND pedidoid = @CDIR_NRO_PEDIDO					
						
				END
			
			END			
			
			
		END
		ELSE BEGIN
			
			IF @TEMP_DUENO <> @CDIR_DUENO BEGIN
				
				SET @TEMP_DUENO = @CDIR_DUENO;
					IF @CDIR_NRO_ENTREGA = 0 BEGIN
					--TOMAMOS EL ULTIMO FOLIO
					SET @NRO_ENTREGA = @NRO_ENTREGA + 1
					
					PRINT 'DIRECCIONES IGUALES, DUEÑOS DISTINTOS - ASIGNAR: ' + CAST(@NRO_ENTREGA AS VARCHAR(20))
					
					--SELECT * FROM Inventario_Detalle_Trx_Pedidos
					UPDATE Inventario_Detalle_Trx_Pedidos
						SET Nro_Entrega = @NRO_ENTREGA
							,ID_Usro_Act = @ID_USRO_ACT
							,Fech_Actualiza = @FECHA_TRANSACCION
					WHERE ID_NroPedido = @CDIR_NRO_PEDIDO 
						AND ID_Org = @ID_Org
						AND cod_estado_linea <> 100;					
					
					UPDATE @TABLAXML
						SET numeroentrega = @NRO_ENTREGA
					WHERE direccionid = @CDIR_DIRECCION AND duenoid = @CDIR_DUENO AND pedidoid = @CDIR_NRO_PEDIDO					
					
				END 
				
			
			END
			ELSE BEGIN
				
				PRINT 'DIRECCIONES IGUALES, DUEÑO IGUALES - NO ASIGNAR: ' + CAST(@NRO_ENTREGA AS VARCHAR(20))
				
					--SELECT * FROM Inventario_Detalle_Trx_Pedidos
					UPDATE Inventario_Detalle_Trx_Pedidos
						SET Nro_Entrega = @NRO_ENTREGA
							,ID_Usro_Act = @ID_USRO_ACT
							,Fech_Actualiza = @FECHA_TRANSACCION
					WHERE ID_NroPedido = @CDIR_NRO_PEDIDO 
						AND ID_Org = @ID_Org
						AND cod_estado_linea <> 100;					
					
					UPDATE @TABLAXML
						SET numeroentrega = @NRO_ENTREGA
					WHERE direccionid = @CDIR_DIRECCION AND duenoid = @CDIR_DUENO AND pedidoid = @CDIR_NRO_PEDIDO					
				
			END			
			
			
			
		
		END
	
			
		
		
	
		FETCH CDIRECCION INTO 
			 @CDIR_DIRECCION
			,@CDIR_DUENO
			,@CDIR_NRO_ENTREGA	
			,@CDIR_NRO_PEDIDO
			
	END
	
	
	CLOSE CDIRECCION
	
	DEALLOCATE CDIRECCION
	
	UPDATE Inventario_Folios_Todos
		SET FOLIO_NUM_ENTREGA = (@NRO_ENTREGA + 1)
	WHERE FOLIO_NUM_ENTREGA = @NRO_ACTUAL;	

	--SELECT @@TRANCOUNT--ROLLBACK

/*


SELECT * FROM Inventario_Folios_Todos

SELECT * FROM Inventario_Cabecera_Documentos --LA ACTUALIZO AL ÚLTIMO CUANDO GUARDE LA GUIA DE DESPACHO

SELECT * FROM Inventario_Detalle_Trx_Pedidos


SELECT * FROM Inventario_Detalle_Transacciones
*/




/*
SELECT 'SELECT * FROM ' + O.name TABLA, C.name COLUMNA, * 
FROM SYS.all_columns C
	INNER JOIN SYS.all_objects O
		ON C.object_id = O.object_id
WHERE C.name IN('Folio_Num_Entrega', 'Nro_Entrega')


SELECT * FROM SYS.all_objects
*/


	COMMIT TRANSACTION
	
	SELECT id, numeroentrega FROM @TABLAXML
	order by id asc
	
END TRY
BEGIN CATCH
	
	/* Hay un error, deshacemos los cambios*/ 
	ROLLBACK TRANSACTION -- O solo ROLLBACK
	
	DECLARE @MENSAJEERROR VARCHAR(MAX) = ERROR_MESSAGE();
	DECLARE @SEVERIDADERROR BIGINT = ERROR_SEVERITY();
	DECLARE @ESTADOERROR BIGINT = ERROR_STATE();
	DECLARE @LINEAERROR VARCHAR(5) = CAST(ERROR_LINE() AS VARCHAR(5));
	DECLARE @ERRORMENSAJE VARCHAR(MAX);
	SET @ERRORMENSAJE = (@LINEAERROR + ' - ' + @MENSAJEERROR);
	
     RAISERROR (@ERRORMENSAJE, @SEVERIDADERROR, @ESTADOERROR)
				 
     --PRINT ERROR_SEVERITY()    
     --PRINT ERROR_STATE()  
     --PRINT ERROR_PROCEDURE()   
     --PRINT ERROR_LINE()   
     --PRINT ERROR_MESSAGE() 
	
END CATCH

	
END
GO
