USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[CONTINGENCIA_ENVIO_CONFIRMAR]    Script Date: 19-08-2020 16:12:38 ******/
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
EXEC INV_ENVIO_CONFIRMAR 17, 4,
'<root>
  <f id="1" solicitudid="304" pedidoid="21" chkseleccion="True" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="12" dueno="PERCY ROSS STANLEY" direccionid="6030" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="4" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="1" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000033" loteproveedor="S/L" fechavencimiento="25/06/2017" cantidadpedida="80" cantidadpendiente="80" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
  <f id="2" solicitudid="304" pedidoid="21" chkseleccion="True" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="12" dueno="PERCY ROSS STANLEY" direccionid="6030" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="4" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="2" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000032" loteproveedor="S/L" fechavencimiento="30/06/2017" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
</root>'

*/
CREATE PROCEDURE [dbo].[CONTINGENCIA_ENVIO_CONFIRMAR]
	-- Add the parameters for the stored procedure here
--DECLARE
	 @ID_Org numeric(18, 0)
	,@ID_USRO_ACT NUMERIC(18, 0)		
	,@FECHA_TRANSACCION DATETIME
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


--	SET @ID_Org = 17
--	SET @ID_USRO_ACT = 4
--	SET @XML = '<root>
--  <f id="1" 
--  solicitudid="22" 
--  pedidoid="14" 
--  chkseleccion="True" 
--  chkdistribucion="False" 
--  propietarioid="52" 
--  propietario="PROCTER &amp; GAMBLE CHILE LIMITADA" 
--  duenoid="228" dueno="STACY BURGER " 
--  direccionid="2330" 
--  direccion="CAMILO HENRÍQUEZ #898 , CURICÓ" 
--  nombredestinatario="MAYORISTA 10 CURICÓ" 
--  numeroentrega="4" 
--  estadolineaactualid="20" 
--  estadolineaactual="En Etapas/Con Seleccion Confirmada" 
--  estadolineasiguiente="Espera Confirmacion de Envio" 
--  nrolinea="1" 
--  nrosublinea="1" 
--  productoid="51111" 
--  descriptor="DEV.BOLSO PAMPERS BLANCO(CIGUEÑA)" 
--  loteid="201707002207" 
--  loteproveedor="" 
--  fechavencimiento="31/12/2015" 
--  cantidadpedida="500" 
--  cantidadpendiente="500" 
--  cantidadpickeada="8" 
--  cantidadenviar="8" 
--  precio="5000" 
--  subinventarioorigenid="60" 
--  subinventarioorigen="1-STAGE" 
--  localizadororigenid="2793" 
--  localizadororigen="" 
--  subinventariodestino="" 
--  operario="LUIS" />
--</root>'

	DECLARE @ID_LOCALIZADOR_STAGE NUMERIC(18, 0) = (SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 60)
	--DECLARE @FECHA_TRANSACCION DATETIME = (SELECT GETDATE());	

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
	WHERE Tbl.Col.value('@chkseleccion', 'varchar(6)') = 'True'

	--SELECT * FROM Inventario_Detalle_Trx_Pedidos
	--SELECT * 
	--FROM @TABLAXML T
	--	INNER JOIN Inventario_Detalle_Trx_Pedidos TRX
	--		ON T.pedidoid = TRX.ID_NroPedido
	--			AND T.productoid = TRX.Cod_Item
	--			AND T.nrolinea = TRX.Nro_Linea
	--			AND T.nrosublinea = TRX.Nro_SubLinea
	--			AND T.loteid = TRX.ID_Lote
	--	INNER JOIN Inventario_Items PRODUCTO
	--		ON T.productoid = PRODUCTO.COD_ITEM AND @ID_ORG = PRODUCTO.ID_ORG	
	--	INNER JOIN Inventario_Unidad_Medida_Primaria UM
	--		ON PRODUCTO.ID_UM = UM.ID_UM
	
	IF EXISTS(SELECT * FROM @TABLAXML WHERE numeroentrega = 0) BEGIN
	
		RAISERROR ('Debe generar un número de entrega para confirmar envío', 
		16, -- Severidad 
		1   -- Estado
		)
		
	END
	

BEGIN TRAN
BEGIN TRY
	
	--select * from @TABLAXML

	--MOVIMIENTO ORIGEN
	INSERT INTO [dbo].[Inventario_Detalle_Transacciones]
	SELECT
		 ID_TRX_PEDIDO
		,@FECHA_TRANSACCION
		,TRX.COD_ITEM
		,@ID_Org
		,subinventarioorigen
		,localizadororigen
		,'' Cod_Subinv_Destino
		,'' Localizador_Destino
		,'STAGE' Origen_TRX
		,TRX.Nro_Entrega
		,NULL Documento
		,NULL Razon_Social
		,TRX.ID_LOTE
		,-T.cantidadenviar Cantidad_TRX
		,UM.Unidad_Medida_Abreviada Unidad_Medida
		,@ID_USRO_ACT ID_Usuario
		,PRODUCTO.Precio_Compra
	FROM @TABLAXML T
		INNER JOIN Inventario_Detalle_Trx_Pedidos TRX
			ON T.pedidoid = TRX.ID_NroPedido
				AND T.productoid = TRX.Cod_Item
				AND T.nrolinea = TRX.Nro_Linea
				AND T.nrosublinea = TRX.Nro_SubLinea
				AND T.loteid = TRX.ID_Lote
		INNER JOIN Inventario_Items PRODUCTO
			ON T.productoid = PRODUCTO.COD_ITEM AND @ID_ORG = PRODUCTO.ID_ORG	
		INNER JOIN Inventario_Unidad_Medida_Primaria UM
			ON PRODUCTO.ID_UM = UM.ID_UM
	WHERE TRX.cod_estado_linea <> 100;
	
	----MOVIMIENTO DESTINO
	--INSERT INTO [dbo].[Inventario_Detalle_Transacciones]
	--SELECT
	--	 ID_TRX_PEDIDO
	--	,@FECHA_TRANSACCION
	--	,TRX.COD_ITEM
	--	,@ID_Org
	--	,'' subinventarioorigenid
	--	,'' localizadororigen
	--	,'' Cod_Subinv_Destino
	--	,'' Localizador_Destino
	--	,'INVENTARIO' Origen_TRX
	--	,TRX.Nro_Entrega
	--	,NULL Documento
	--	,nombredestinatario Razon_Social
	--	,TRX.ID_LOTE
	--	,T.cantidadenviar Cantidad_TRX
	--	,UM.Unidad_Medida_Abreviada Unidad_Medida
	--	,@ID_USRO_ACT ID_Usuario
	--	,PRODUCTO.Precio_Compra
	--FROM @TABLAXML T
	--	INNER JOIN Inventario_Detalle_Trx_Pedidos TRX
	--		ON T.pedidoid = TRX.ID_NroPedido
	--			AND T.productoid = TRX.Cod_Item
	--			AND T.nrolinea = TRX.Nro_Linea
	--			AND T.nrosublinea = TRX.Nro_SubLinea
	--			AND T.loteid = TRX.ID_Lote
	--	INNER JOIN Inventario_Items PRODUCTO
	--		ON T.productoid = PRODUCTO.COD_ITEM AND @ID_ORG = PRODUCTO.ID_ORG	
	--	INNER JOIN Inventario_Unidad_Medida_Primaria UM
	--		ON PRODUCTO.ID_UM = UM.ID_UM;		
	
	
	
	
	
	
	
	
	--SELECT --ID_NroPedido
	--	   PROD.Cod_Item
	--	  ,DETALLE.ID_Lote
	--	  ,T.cantidadenviar --DETALLE.Cant_Pickeada
	--	  ,T.localizadororigenid --DETALLE.ID_Localizador_Origen
	--	  ,PROD.VOLUMEN 
	--	  ,DETALLE.NRO_LINEA
	--	  ,DETALLE.NRO_SUBLINEA
	--	  ,T.pedidoid
	--FROM Inventario_Detalle_Trx_Pedidos DETALLE
	--	INNER JOIN Inventario_Items PROD
	--		ON DETALLE.Cod_Item = PROD.COD_ITEM AND DETALLE.ID_Org = PROD.ID_ORG 
	--	INNER JOIN Inventario_Estado_Linea_Pedidos EST_LINEA
	--		ON DETALLE.Cod_Estado_Linea = EST_LINEA.COD_ESTADO_LINEA 
	--	INNER JOIN Inventario_SubInv_Localizadores LOC
	--		ON DETALLE.ID_Localizador_Origen = LOC.ID_Localizador AND DETALLE.ID_Org = LOC.ID_ORG
	--	INNER JOIN @TABLAXML T
	--		ON DETALLE.Cod_Item = T.productoid
	--			AND DETALLE.ID_Lote = T.loteid
	--			AND DETALLE.Nro_Linea = T.nrolinea
	--			AND DETALLE.Nro_SubLinea = T.nrosublinea
	--			AND DETALLE.ID_NROPEDIDO = T.pedidoid
	--	INNER JOIN Inventario_Unidad_Medida_Primaria UM
	--		ON PROD.ID_UM = UM.ID_UM
	--	INNER JOIN dbo.Inventario_SubInventarios SUBINV
	--		ON LOC.ID_SUBINV = SUBINV.ID_SUBINV 
	--WHERE --DETALLE.ID_NROPEDIDO = T.pedidoid
	--	--AND 
	--	DETALLE.ID_ORG = @ID_ORG
	--ORDER BY DETALLE.NRO_LINEA ASC, DETALLE.NRO_SUBLINEA ASC	
	
	
	
	
	
	
	
	
	
	--ACTUALIZACIÓN STOCK_LOTES, DETALLE_TRX_PEDIDOS Y DETALLE_PEDIDOS	
	DECLARE 
		 @COD_ITEM NUMERIC(18, 0)
		,@ID_LOTE VARCHAR(50)
		,@CANT_PICKEADA NUMERIC(18, 0)
		,@ID_LOCALIZADOR_ORIGEN NUMERIC(18, 0)
		,@VOLUMEN NUMERIC(18, 5)	
		,@NRO_LINEA NUMERIC(18, 0)
		,@NRO_SUBLINEA NUMERIC(18, 0)		
		,@ID_NROPEDIDO NUMERIC(18, 0)
		
		
	--SELECT --ID_NroPedido
	--	   PROD.Cod_Item
	--	  ,DETALLE.ID_Lote
	--	  ,T.cantidadenviar --DETALLE.Cant_Pickeada
	--	  ,T.localizadororigenid --DETALLE.ID_Localizador_Origen
	--	  ,PROD.VOLUMEN 
	--	  ,DETALLE.NRO_LINEA
	--	  ,DETALLE.NRO_SUBLINEA
	--	  ,T.pedidoid
	--FROM Inventario_Detalle_Trx_Pedidos DETALLE
	--	INNER JOIN Inventario_Items PROD
	--		ON DETALLE.Cod_Item = PROD.COD_ITEM AND DETALLE.ID_Org = PROD.ID_ORG 
	--	INNER JOIN Inventario_Estado_Linea_Pedidos EST_LINEA
	--		ON DETALLE.Cod_Estado_Linea = EST_LINEA.COD_ESTADO_LINEA 
	--	INNER JOIN Inventario_SubInv_Localizadores LOC
	--		ON DETALLE.ID_Localizador_Origen = LOC.ID_Localizador AND DETALLE.ID_Org = LOC.ID_ORG
	--	INNER JOIN @TABLAXML T
	--		ON DETALLE.Cod_Item = T.productoid
	--			AND DETALLE.ID_Lote = T.loteid
	--			AND DETALLE.Nro_Linea = T.nrolinea
	--			AND DETALLE.Nro_SubLinea = T.nrosublinea
	--			AND DETALLE.ID_NROPEDIDO = T.pedidoid
	--	INNER JOIN Inventario_Unidad_Medida_Primaria UM
	--		ON PROD.ID_UM = UM.ID_UM
	--	INNER JOIN dbo.Inventario_SubInventarios SUBINV
	--		ON LOC.ID_SUBINV = SUBINV.ID_SUBINV 
	--WHERE --DETALLE.ID_NROPEDIDO = T.pedidoid
	--	--AND 
	--	DETALLE.ID_ORG = @ID_ORG
	--ORDER BY DETALLE.NRO_LINEA ASC, DETALLE.NRO_SUBLINEA ASC				
		
	DECLARE CLOTES CURSOR FOR
	SELECT --ID_NroPedido
		   PROD.Cod_Item
		  ,DETALLE.ID_Lote
		  ,T.cantidadenviar --DETALLE.Cant_Pickeada
		  ,T.localizadororigenid --DETALLE.ID_Localizador_Origen
		  ,PROD.VOLUMEN 
		  ,DETALLE.NRO_LINEA
		  ,DETALLE.NRO_SUBLINEA
		  ,T.pedidoid
	FROM Inventario_Detalle_Trx_Pedidos DETALLE
		INNER JOIN Inventario_Items PROD
			ON DETALLE.Cod_Item = PROD.COD_ITEM AND DETALLE.ID_Org = PROD.ID_ORG 
		INNER JOIN Inventario_Estado_Linea_Pedidos EST_LINEA
			ON DETALLE.Cod_Estado_Linea = EST_LINEA.COD_ESTADO_LINEA 
		INNER JOIN Inventario_SubInv_Localizadores LOC
			ON DETALLE.ID_Localizador_Origen = LOC.ID_Localizador AND DETALLE.ID_Org = LOC.ID_ORG
		INNER JOIN @TABLAXML T
			ON DETALLE.Cod_Item = T.productoid
				AND DETALLE.ID_Lote = T.loteid
				AND DETALLE.Nro_Linea = T.nrolinea
				AND DETALLE.Nro_SubLinea = T.nrosublinea
				AND DETALLE.ID_NROPEDIDO = T.pedidoid
		INNER JOIN Inventario_Unidad_Medida_Primaria UM
			ON PROD.ID_UM = UM.ID_UM
		INNER JOIN dbo.Inventario_SubInventarios SUBINV
			ON LOC.ID_SUBINV = SUBINV.ID_SUBINV 
	WHERE --DETALLE.ID_NROPEDIDO = T.pedidoid
		--AND 
		DETALLE.ID_ORG = @ID_ORG
		AND DETALLE.cod_estado_linea<>100
	ORDER BY DETALLE.NRO_LINEA ASC, DETALLE.NRO_SUBLINEA ASC	
	
	-- Apertura del cursor
	OPEN CLOTES

	-- Lectura de la primera fila del cursor
	FETCH CLOTES INTO		
		 @COD_ITEM
		,@ID_LOTE
		,@CANT_PICKEADA --ENVIADA
		,@ID_LOCALIZADOR_ORIGEN	
		,@VOLUMEN
		,@NRO_LINEA 
		,@NRO_SUBLINEA
		,@ID_NROPEDIDO
		
	WHILE (@@FETCH_STATUS = 0 ) BEGIN
		
		--ACTUALIZA LA TABLA TRX_PEDIDOS
		
		IF @CANT_PICKEADA > 0 BEGIN
			PRINT CAST(@CANT_PICKEADA AS VARCHAR(30))
			--SELECT * FROM Inventario_Detalle_Trx_Pedidos WHERE NRO_ENTREGA = 11
			UPDATE Inventario_Detalle_Trx_Pedidos
				SET COD_ESTADO_LINEA = 30,
					NOMB_SGTE_ESTADO = (SELECT NOMBRE_ESTADO_LINEA FROM Inventario_Estado_Linea_Pedidos WHERE COD_ESTADO_LINEA = 40),
					ID_USRO_ACT = @ID_USRO_ACT,
					FECH_ACTUALIZA = @FECHA_TRANSACCION,
					--CANT_PENDIENTE = (CANT_PENDIENTE - @CANT_PICKEADA),
					CANT_DESPACHO = @CANT_PICKEADA
			WHERE ID_NROPEDIDO = @ID_NROPEDIDO
				AND COD_ITEM = @COD_ITEM
				AND NRO_LINEA = @NRO_LINEA
				AND NRO_SUBLINEA = @NRO_SUBLINEA
				AND ID_LOTE = @ID_LOTE
				AND cod_estado_linea<>100
				--AND ID_LOCALIZADOR_DESTINO = @ID_LOCALIZADOR_ORIGEN;
				
			
			--REBAJA STOCK DEL STAGE
			--SELECT * FROM Inventario_Stock_Lotes WHERE ID_LOCALIZADOR = 2793
			UPDATE Inventario_Stock_Lotes
				SET EN_MANO = (EN_MANO - @CANT_PICKEADA), 
					DISPONIBLE = (DISPONIBLE - @CANT_PICKEADA),
					ID_Usro_Act = @ID_USRO_ACT,
					Fech_Actualiza = @FECHA_TRANSACCION
			WHERE ID_LOTE = @ID_LOTE 
				AND ID_LOCALIZADOR = @ID_LOCALIZADOR_ORIGEN
				AND ID_ORG = @ID_ORG
				AND EN_MANO > 0;
				--AND DISPONIBLE > 0;
				
			UPDATE @TABLAXML
				SET estadolineaactualid = 30,
					estadolineaactual = (SELECT NOMBRE_ESTADO_LINEA FROM Inventario_Estado_Linea_Pedidos WHERE COD_ESTADO_LINEA = 30),
					estadolineasiguiente = (SELECT NOMBRE_ESTADO_LINEA FROM Inventario_Estado_Linea_Pedidos WHERE COD_ESTADO_LINEA = 40)
			WHERE loteid = @ID_LOTE
				AND nrolinea = @NRO_LINEA
				AND nrosublinea = @NRO_SUBLINEA
				AND pedidoid = @ID_NROPEDIDO
				AND productoid = @COD_ITEM;
				
		END 
		
		FETCH CLOTES INTO		
			 @COD_ITEM
			,@ID_LOTE
			,@CANT_PICKEADA
			,@ID_LOCALIZADOR_ORIGEN			
			,@VOLUMEN
			,@NRO_LINEA 
			,@NRO_SUBLINEA			
			,@ID_NROPEDIDO
	END	  
	  
	  
	-- Cierre del cursor
	CLOSE cLotes

	-- Liberar los recursos
	DEALLOCATE cLotes


	--RECORRER A NIVEL DE PRODUCTO Inventario_Detalle_Pedidos
	DECLARE CPRODUCTOS CURSOR FOR
	SELECT --ID_NroPedido
		   PROD.Cod_Item
		  --,DETALLE.ID_Lote
		  --,T.cantidadenviar --DETALLE.Cant_Pickeada
		  --,T.localizadororigenid --DETALLE.ID_Localizador_Origen
		  --,PROD.VOLUMEN 
		  --,DETALLE.NRO_LINEA
		  --,DETALLE.NRO_SUBLINEA
		  ,T.pedidoid
	FROM Inventario_Detalle_Trx_Pedidos DETALLE
		INNER JOIN Inventario_Items PROD
			ON DETALLE.Cod_Item = PROD.COD_ITEM AND DETALLE.ID_Org = PROD.ID_ORG 
		INNER JOIN Inventario_Estado_Linea_Pedidos EST_LINEA
			ON DETALLE.Cod_Estado_Linea = EST_LINEA.COD_ESTADO_LINEA 
		INNER JOIN Inventario_SubInv_Localizadores LOC
			ON DETALLE.ID_Localizador_Origen = LOC.ID_Localizador AND DETALLE.ID_Org = LOC.ID_ORG
		INNER JOIN @TABLAXML T
			ON DETALLE.Cod_Item = T.productoid
				AND DETALLE.ID_Lote = T.loteid
				AND DETALLE.Nro_Linea = T.nrolinea
				AND DETALLE.Nro_SubLinea = T.nrosublinea
				AND DETALLE.ID_NROPEDIDO = T.pedidoid
		INNER JOIN Inventario_Unidad_Medida_Primaria UM
			ON PROD.ID_UM = UM.ID_UM
		INNER JOIN dbo.Inventario_SubInventarios SUBINV
			ON LOC.ID_SUBINV = SUBINV.ID_SUBINV 
	WHERE DETALLE.ID_ORG = @ID_ORG
		AND DETALLE.cod_estado_linea <> 100 and DETALLE.cant_despacho>0
	GROUP BY T.pedidoid, PROD.Cod_Item--, T.localizadororigenid
	--ORDER BY DETALLE.NRO_LINEA ASC, DETALLE.NRO_SUBLINEA ASC	
	
	-- Apertura del cursor
	OPEN CPRODUCTOS

	-- Lectura de la primera fila del cursor
	FETCH CPRODUCTOS INTO		
		 @COD_ITEM
		--,@ID_LOCALIZADOR_ORIGEN	
		,@ID_NROPEDIDO
		
	WHILE (@@FETCH_STATUS = 0 ) BEGIN
		PRINT 'PASO'
		--ACTUALIZA LA TABLA TRX_PEDIDOS
		UPDATE Inventario_Detalle_Trx_Pedidos
			SET CANT_PENDIENTE = CANT_PENDIENTE - (SELECT ISNULL(SUM(CANT_DESPACHO), 0)
												   FROM Inventario_Detalle_Trx_Pedidos TRX
												   WHERE TRX.ID_NROPEDIDO = @ID_NROPEDIDO AND TRX.Cod_Estado_Linea NOT IN(30, 40)
												   AND TRX.COD_ITEM = @COD_ITEM)
		WHERE ID_NROPEDIDO = @ID_NROPEDIDO
			AND COD_ITEM = @COD_ITEM
			AND NRO_SUBLINEA = 1
			AND cod_estado_linea <> 100 and Cant_Despacho>0;

		--SELECT * FROM Inventario_Detalle_Pedidos
		UPDATE Inventario_Detalle_Pedidos	
			SET CANT_PENDIENTE = CANT_PENDIENTE - (SELECT ISNULL(SUM(CANT_DESPACHO), 0)
												   FROM Inventario_Detalle_Trx_Pedidos TRX
												   WHERE TRX.ID_NROPEDIDO = @ID_NROPEDIDO AND TRX.Cod_Estado_Linea NOT IN(30, 40)
												   AND TRX.COD_ITEM = @COD_ITEM),
			    --CANT_PICKEADA = CANT_PICKEADA - (SELECT SUM(CANT_DESPACHO)
							--					   FROM Inventario_Detalle_Trx_Pedidos TRX
							--					   WHERE TRX.ID_NROPEDIDO = @ID_NROPEDIDO
							--					   AND TRX.COD_ITEM = @COD_ITEM),
				CANT_DESPACHO = (SELECT SUM(CANT_DESPACHO)
												   FROM Inventario_Detalle_Trx_Pedidos TRX
												   WHERE TRX.ID_NROPEDIDO = @ID_NROPEDIDO
												   AND TRX.COD_ITEM = @COD_ITEM),
				ID_USRO_ACT = @ID_USRO_ACT,
				FECH_ACTUALIZA = @FECHA_TRANSACCION
		WHERE ID_NROPEDIDO = @ID_NROPEDIDO
			AND COD_ITEM = @COD_ITEM;
		
		
		FETCH CPRODUCTOS INTO		
			 @COD_ITEM
			--,@ID_LOCALIZADOR_ORIGEN	
			,@ID_NROPEDIDO
			
	END	  
	  
	  
	-- Cierre del cursor
	CLOSE CPRODUCTOS

	-- Liberar los recursos
	DEALLOCATE CPRODUCTOS

	--SELECT @@TRANCOUNT--ROLLBACK


/*
SELECT * FROM Inventario_Detalle_Transacciones ORDER BY FECHA_TRX DESC

SELECT * FROM dbo.Inventario_Stock_Lotes WHERE ID_LOTE = '201707002207'

--UPDATE Inventario_Stock_Lotes SET EN_MANO = 8, DISPONIBLE = 8 WHERE ID_LOTE = '201707002207' AND ID_LOCALIZADOR = 2793

SELECT * FROM dbo.Inventario_Detalle_Trx_Pedidos WHERE NRO_ENTREGA = 4

SELECT * FROM dbo.Inventario_Detalle_Pedidos WHERE ID_NROPEDIDO = 14


-------------------------------------
SELECT * FROM Inventario_Folios_Todos
SELECT * FROM Inventario_Cabecera_Documentos --LA ACTUALIZO AL ÚLTIMO CUANDO GUARDE LA GUIA DE DESPACHO
SELECT * FROM Inventario_Detalle_Trx_Pedidos

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
	
	SELECT id, estadolineaactualid, estadolineaactual, estadolineasiguiente FROM @TABLAXML
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
