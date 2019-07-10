-- TMCDB SQL TABLE DEFINITIONS Version 2.2.1 2010-08-22T0000:00:00.0
--
-- /////////////////////////////////////////////////////////////////
-- // WARNING!  DO NOT MODIFY THIS FILE!                          //
-- //  ---------------------------------------------------------  //
-- // | This is generated code!  Do not modify this file.       | //
-- // | Any changes will be lost when the file is re-generated. | //
-- //  ---------------------------------------------------------  //
-- /////////////////////////////////////////////////////////////////

CREATE TABLE `HWConfiguration` (
	`ConfigurationId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`GlobalConfigId` INTEGER NULL,
	`SwConfigurationId` INTEGER NOT NULL,
	`TelescopeName` VARCHAR (128) NOT NULL,
	`ArrayReferenceX` DOUBLE NULL,
	`ArrayReferenceY` DOUBLE NULL,
	`ArrayReferenceZ` DOUBLE NULL,
	`XPDelayBLLocked` BOOLEAN NULL,
	`XPDelayBLIncreaseVersion` BOOLEAN NULL,
	`XPDelayBLCurrentVersion` INTEGER NULL,
	`XPDelayBLWho` VARCHAR (128) NULL,
	`XPDelayBLChangeDesc` MEDIUMTEXT NULL,
	CONSTRAINT `SwConfigId` FOREIGN KEY (`SwConfigurationId`) REFERENCES `Configuration` (`ConfigurationId`),
	CONSTRAINT `HWConfAltKey` UNIQUE (`SwConfigurationId`)
) ENGINE=INNODB;
CREATE TABLE `SystemCounters` (
	`ConfigurationId` INTEGER NOT NULL,
	`UpdateTime` BIGINT NOT NULL,
	`AutoArrayCount` SMALLINT NOT NULL,
	`ManArrayCount` SMALLINT NOT NULL,
	`DataCaptureCount` SMALLINT NOT NULL,
	CONSTRAINT `SystemCountersConfig` FOREIGN KEY (`ConfigurationId`) REFERENCES `HWConfiguration` (`ConfigurationId`),
	CONSTRAINT `SystemCKey` PRIMARY KEY (`ConfigurationId`)
) ENGINE=INNODB;
CREATE TABLE `LRUType` (
	`LRUName` VARCHAR (128) NOT NULL,
	`FullName` VARCHAR (256) NOT NULL,
	`ICD` VARCHAR (256) NOT NULL,
	`ICDDate` BIGINT NOT NULL,
	`Description` MEDIUMTEXT NOT NULL,
	`Notes` MEDIUMTEXT NULL,
	CONSTRAINT `LRUTypeKey` PRIMARY KEY (`LRUName`)
) ENGINE=INNODB;
CREATE TABLE `AssemblyType` (
	`AssemblyTypeName` VARCHAR (256) NOT NULL,
	`BaseElementType` VARCHAR (24) NOT NULL,
	`LRUName` VARCHAR (128) NOT NULL,
	`FullName` VARCHAR (256) NOT NULL,
	`Description` MEDIUMTEXT NOT NULL,
	`Notes` MEDIUMTEXT NULL,
	`ComponentTypeId` INTEGER NOT NULL,
	`ProductionCode` VARCHAR (256) NOT NULL,
	`SimulatedCode` VARCHAR (256) NOT NULL,
	CONSTRAINT `AssemblyTypeLRUName` FOREIGN KEY (`LRUName`) REFERENCES `LRUType` (`LRUName`),
	CONSTRAINT `AssemblyTypeCompType` FOREIGN KEY (`ComponentTypeId`) REFERENCES `ComponentType` (`ComponentTypeId`),
	CONSTRAINT `AssemblyTypeBEType` CHECK (`BaseElementType` IN ('Antenna', 'Pad', 'FrontEnd', 'WeatherStationController', 'CorrQuadrant', 'AcaCorrSet', 'CentralLO', 'AOSTiming', 'PhotonicReference', 'HolographyTower', 'Array')),
	CONSTRAINT `AssemblyTypeKey` PRIMARY KEY (`AssemblyTypeName`)
) ENGINE=INNODB;
CREATE TABLE `HwSchemas` (
	`SchemaId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`URN` VARCHAR (512) NOT NULL,
	`ConfigurationId` INTEGER NOT NULL,
	`AssemblyTypeName` VARCHAR (256) NOT NULL,
	`Schema` MEDIUMTEXT NULL,
	CONSTRAINT `AssemblySchemasConfig` FOREIGN KEY (`ConfigurationId`) REFERENCES `HWConfiguration` (`ConfigurationId`),
	CONSTRAINT `HwSchemaAssemblyType` FOREIGN KEY (`AssemblyTypeName`) REFERENCES `AssemblyType` (`AssemblyTypeName`),
	CONSTRAINT `HwSchemasAltKey` UNIQUE (`URN`, `ConfigurationId`)
) ENGINE=INNODB;
CREATE TABLE `Assembly` (
	`AssemblyId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`AssemblyTypeName` VARCHAR (256) NOT NULL,
	`ConfigurationId` INTEGER NOT NULL,
	`SerialNumber` VARCHAR (256) NOT NULL,
	`Data` MEDIUMTEXT NULL,
	CONSTRAINT `AssemblyConfig` FOREIGN KEY (`ConfigurationId`) REFERENCES `HWConfiguration` (`ConfigurationId`),
	CONSTRAINT `AssemblyName` FOREIGN KEY (`AssemblyTypeName`) REFERENCES `AssemblyType` (`AssemblyTypeName`),
	CONSTRAINT `AssemblyAltKey` UNIQUE (`SerialNumber`, `ConfigurationId`)
) ENGINE=INNODB;
CREATE TABLE `AssemblyRole` (
	`RoleName` VARCHAR (128) NOT NULL,
	`AssemblyTypeName` VARCHAR (256) NOT NULL,
	CONSTRAINT `AssemblyRoleAssembly` FOREIGN KEY (`AssemblyTypeName`) REFERENCES `AssemblyType` (`AssemblyTypeName`),
	CONSTRAINT `AssemblyRoleKey` PRIMARY KEY (`RoleName`)
) ENGINE=INNODB;
CREATE TABLE `BaseElement` (
	`BaseElementId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`BaseType` VARCHAR (24) NOT NULL,
	`BaseElementName` VARCHAR (24) NOT NULL,
	`ConfigurationId` INTEGER NOT NULL,
	CONSTRAINT `BEConfig` FOREIGN KEY (`ConfigurationId`) REFERENCES `HWConfiguration` (`ConfigurationId`),
	CONSTRAINT `BEType` CHECK (`BaseType` IN ('Antenna', 'Pad', 'FrontEnd', 'WeatherStationController', 'CentralLO', 'AOSTiming', 'HolographyTower', 'PhotonicReference', 'CorrQuadrant', 'AcaCorrSet', 'CorrQuadrantRack', 'CorrStationBin', 'CorrBin')),
	CONSTRAINT `BaseElementAltKey` UNIQUE (`BaseElementName`, `BaseType`, `ConfigurationId`)
) ENGINE=INNODB;
CREATE TABLE `AcaCorrSet` (
	`BaseElementId` INTEGER NOT NULL,
	`BaseBand` VARCHAR (128) NOT NULL,
	`IP` VARCHAR (128) NOT NULL,
	CONSTRAINT `AcaCSetBEId` FOREIGN KEY (`BaseElementId`) REFERENCES `BaseElement` (`BaseElementId`),
	CONSTRAINT `AcaCSetBBEnum` CHECK (`BaseBand` IN ('BB_1', 'BB_2', 'BB_3', 'BB_4')),
	CONSTRAINT `AcaCorrSetKey` PRIMARY KEY (`BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `Antenna` (
	`BaseElementId` INTEGER NOT NULL,
	`AntennaName` VARCHAR (128) NULL,
	`AntennaType` VARCHAR (4) NOT NULL,
	`DishDiameter` DOUBLE NOT NULL,
	`CommissionDate` BIGINT NOT NULL,
	`XPosition` DOUBLE NOT NULL,
	`YPosition` DOUBLE NOT NULL,
	`ZPosition` DOUBLE NOT NULL,
	`XPositionErr` DOUBLE NULL,
	`YPositionErr` DOUBLE NULL,
	`ZPositionErr` DOUBLE NULL,
	`XOffset` DOUBLE NOT NULL,
	`YOffset` DOUBLE NOT NULL,
	`ZOffset` DOUBLE NOT NULL,
	`PosObservationTime` BIGINT NULL,
	`PosExecBlockUID` VARCHAR (100) NULL,
	`PosScanNumber` INTEGER NULL,
	`Comments` MEDIUMTEXT NULL,
	`Delay` DOUBLE NOT NULL,
	`DelayError` DOUBLE NULL,
	`DelObservationTime` BIGINT NULL,
	`DelExecBlockUID` VARCHAR (100) NULL,
	`DelScanNumber` INTEGER NULL,
	`XDelayRef` DOUBLE NULL,
	`YDelayRef` DOUBLE NULL,
	`ZDelayRef` DOUBLE NULL,
	`LOOffsettingIndex` INTEGER NOT NULL,
	`WalshSeq` INTEGER NOT NULL,
	`CaiBaseline` INTEGER NULL,
	`CaiAca` INTEGER NULL,
	`Locked` BOOLEAN NULL,
	`IncreaseVersion` BOOLEAN NULL,
	`CurrentVersion` INTEGER NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	`DelayBLLocked` BOOLEAN NULL,
	`DelayBLIncreaseVersion` BOOLEAN NULL,
	`DelayBLCurrentVersion` INTEGER NULL,
	`DelayBLWho` VARCHAR (128) NULL,
	`DelayBLChangeDesc` MEDIUMTEXT NULL,
	CONSTRAINT `AntennaBEId` FOREIGN KEY (`BaseElementId`) REFERENCES `BaseElement` (`BaseElementId`),
	CONSTRAINT `AntennaType` CHECK (`AntennaType` IN ('VA', 'AEC', 'ACA')),
	CONSTRAINT `AntennaKey` PRIMARY KEY (`BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `AcaCorrDelays` (
	`AntennaId` INTEGER NOT NULL,
	`BbOneDelay` DOUBLE NOT NULL,
	`BbTwoDelay` DOUBLE NOT NULL,
	`BbThreeDelay` DOUBLE NOT NULL,
	`BbFourDelay` DOUBLE NOT NULL,
	`Locked` BOOLEAN NULL,
	`IncreaseVersion` BOOLEAN NULL,
	`CurrentVersion` INTEGER NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	CONSTRAINT `AcaCDelAntId` FOREIGN KEY (`AntennaId`) REFERENCES `Antenna` (`BaseElementId`),
	CONSTRAINT `AcaCorDKey` PRIMARY KEY (`AntennaId`)
) ENGINE=INNODB;
CREATE TABLE `Pad` (
	`BaseElementId` INTEGER NOT NULL,
	`PadName` VARCHAR (128) NULL,
	`CommissionDate` BIGINT NOT NULL,
	`XPosition` DOUBLE NOT NULL,
	`YPosition` DOUBLE NOT NULL,
	`ZPosition` DOUBLE NOT NULL,
	`XPositionErr` DOUBLE NULL,
	`YPositionErr` DOUBLE NULL,
	`ZPositionErr` DOUBLE NULL,
	`PosObservationTime` BIGINT NULL,
	`PosExecBlockUID` VARCHAR (100) NULL,
	`PosScanNumber` INTEGER NULL,
	`Delay` DOUBLE NOT NULL,
	`DelayError` DOUBLE NULL,
	`DelObservationTime` BIGINT NULL,
	`DelExecBlockUID` VARCHAR (100) NULL,
	`DelScanNumber` INTEGER NULL,
	`Locked` BOOLEAN NULL,
	`IncreaseVersion` BOOLEAN NULL,
	`CurrentVersion` INTEGER NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	CONSTRAINT `PadBEId` FOREIGN KEY (`BaseElementId`) REFERENCES `BaseElement` (`BaseElementId`),
	CONSTRAINT `PadKey` PRIMARY KEY (`BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `FrontEnd` (
	`BaseElementId` INTEGER NOT NULL,
	`CommissionDate` BIGINT NOT NULL,
	CONSTRAINT `FrontEndBEId` FOREIGN KEY (`BaseElementId`) REFERENCES `BaseElement` (`BaseElementId`),
	CONSTRAINT `FrontEndKey` PRIMARY KEY (`BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `PhotonicReference` (
	`BaseElementId` INTEGER NOT NULL,
	`CommissionDate` BIGINT NOT NULL,
	CONSTRAINT `PhotRefBEId` FOREIGN KEY (`BaseElementId`) REFERENCES `BaseElement` (`BaseElementId`),
	CONSTRAINT `PhotonRKey` PRIMARY KEY (`BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `WeatherStationController` (
	`BaseElementId` INTEGER NOT NULL,
	`CommissionDate` BIGINT NOT NULL,
	CONSTRAINT `WeatherStationBEId` FOREIGN KEY (`BaseElementId`) REFERENCES `BaseElement` (`BaseElementId`),
	CONSTRAINT `WeatheSCKey` PRIMARY KEY (`BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `CentralLO` (
	`BaseElementId` INTEGER NOT NULL,
	`CommissionDate` BIGINT NOT NULL,
	CONSTRAINT `CentralLOBEId` FOREIGN KEY (`BaseElementId`) REFERENCES `BaseElement` (`BaseElementId`),
	CONSTRAINT `CentralLOKey` PRIMARY KEY (`BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `AOSTiming` (
	`BaseElementId` INTEGER NOT NULL,
	`CommissionDate` BIGINT NOT NULL,
	CONSTRAINT `AOSTimingBEId` FOREIGN KEY (`BaseElementId`) REFERENCES `BaseElement` (`BaseElementId`),
	CONSTRAINT `AOSTimingKey` PRIMARY KEY (`BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `HolographyTower` (
	`BaseElementId` INTEGER NOT NULL,
	`CommissionDate` BIGINT NOT NULL,
	`XPosition` DOUBLE NOT NULL,
	`YPosition` DOUBLE NOT NULL,
	`ZPosition` DOUBLE NOT NULL,
	CONSTRAINT `HolographyTowerBEId` FOREIGN KEY (`BaseElementId`) REFERENCES `BaseElement` (`BaseElementId`),
	CONSTRAINT `HologrTKey` PRIMARY KEY (`BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `AntennaToPad` (
	`AntennaToPadId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`AntennaId` INTEGER NOT NULL,
	`PadId` INTEGER NOT NULL,
	`StartTime` BIGINT NOT NULL,
	`EndTime` BIGINT NULL,
	`Planned` BOOLEAN NOT NULL,
	`MountMetrologyAN0Coeff` DOUBLE NULL,
	`MountMetrologyAW0Coeff` DOUBLE NULL,
	`Locked` BOOLEAN NULL,
	`IncreaseVersion` BOOLEAN NULL,
	`CurrentVersion` INTEGER NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	CONSTRAINT `AntennaToPadAntennaId` FOREIGN KEY (`AntennaId`) REFERENCES `Antenna` (`BaseElementId`),
	CONSTRAINT `AntennaToPadPadId` FOREIGN KEY (`PadId`) REFERENCES `Pad` (`BaseElementId`),
	CONSTRAINT `AntennaToPadAltKey` UNIQUE (`AntennaId`, `PadId`, `StartTime`)
) ENGINE=INNODB;
CREATE TABLE `WeatherStationToPad` (
	`WeatherStationId` INTEGER NOT NULL,
	`PadId` INTEGER NOT NULL,
	`StartTime` BIGINT NOT NULL,
	`EndTime` BIGINT NULL,
	`Planned` BOOLEAN NOT NULL,
	CONSTRAINT `WSToPadWeatherStationId` FOREIGN KEY (`WeatherStationId`) REFERENCES `WeatherStationController` (`BaseElementId`),
	CONSTRAINT `WSToPadPadId` FOREIGN KEY (`PadId`) REFERENCES `Pad` (`BaseElementId`),
	CONSTRAINT `WeatheSTPKey` PRIMARY KEY (`WeatherStationId`, `PadId`, `StartTime`)
) ENGINE=INNODB;
CREATE TABLE `HolographyTowerToPad` (
	`TowerToPadId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`HolographyTowerId` INTEGER NOT NULL,
	`PadId` INTEGER NOT NULL,
	`Azimuth` DOUBLE NOT NULL,
	`Elevation` DOUBLE NOT NULL,
	CONSTRAINT `HoloTowerToPadHoloTower` FOREIGN KEY (`HolographyTowerId`) REFERENCES `HolographyTower` (`BaseElementId`),
	CONSTRAINT `HoloTowerToPadPad` FOREIGN KEY (`PadId`) REFERENCES `Pad` (`BaseElementId`),
	CONSTRAINT `HologrTTPAltKey` UNIQUE (`HolographyTowerId`, `PadId`)
) ENGINE=INNODB;
CREATE TABLE `FEDelay` (
	`FEDelayId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`AntennaId` INTEGER NOT NULL,
	`ReceiverBand` VARCHAR (128) NOT NULL,
	`Polarization` VARCHAR (128) NOT NULL,
	`SideBand` VARCHAR (128) NOT NULL,
	`Delay` DOUBLE NOT NULL,
	`DelayError` DOUBLE NULL,
	`ObservationTime` BIGINT NULL,
	`ExecBlockUID` VARCHAR (100) NULL,
	`ScanNumber` INTEGER NULL,
	CONSTRAINT `AntennaFEDelay` FOREIGN KEY (`AntennaId`) REFERENCES `Antenna` (`BaseElementId`),
	CONSTRAINT `FEDelRecBandEnum` CHECK (`ReceiverBand` IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT `FEDelPolEnum` CHECK (`Polarization` IN ('X', 'Y')),
	CONSTRAINT `FEDelSideBandEnum` CHECK (`SideBand` IN ('LSB', 'USB')),
	CONSTRAINT `FEDelayAltKey` UNIQUE (`AntennaId`, `ReceiverBand`, `Polarization`, `SideBand`)
) ENGINE=INNODB;
CREATE TABLE `IFDelay` (
	`IFDelayId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`AntennaId` INTEGER NOT NULL,
	`BaseBand` VARCHAR (128) NOT NULL,
	`Polarization` VARCHAR (128) NOT NULL,
	`IFSwitch` VARCHAR (128) NOT NULL,
	`Delay` DOUBLE NOT NULL,
	`DelayError` DOUBLE NULL,
	`ObservationTime` BIGINT NULL,
	`ExecBlockUID` VARCHAR (100) NULL,
	`ScanNumber` INTEGER NULL,
	CONSTRAINT `AntennaIFDelay` FOREIGN KEY (`AntennaId`) REFERENCES `Antenna` (`BaseElementId`),
	CONSTRAINT `IFDelBaseBandEnum` CHECK (`BaseBand` IN ('BB_1', 'BB_2', 'BB_3', 'BB_4')),
	CONSTRAINT `IFDelIFSwitchEnum` CHECK (`IFSwitch` IN ('USB_HIGH', 'USB_LOW', 'LSB_HIGH', 'LSB_LOW')),
	CONSTRAINT `IFDelPolEnum` CHECK (`Polarization` IN ('X', 'Y')),
	CONSTRAINT `IFDelayAltKey` UNIQUE (`AntennaId`, `BaseBand`, `Polarization`, `IFSwitch`)
) ENGINE=INNODB;
CREATE TABLE `LODelay` (
	`LODelayId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`AntennaId` INTEGER NOT NULL,
	`BaseBand` VARCHAR (128) NOT NULL,
	`Delay` DOUBLE NOT NULL,
	`DelayError` DOUBLE NULL,
	`ObservationTime` BIGINT NULL,
	`ExecBlockUID` VARCHAR (100) NULL,
	`ScanNumber` INTEGER NULL,
	CONSTRAINT `AntennaLODelay` FOREIGN KEY (`AntennaId`) REFERENCES `Antenna` (`BaseElementId`),
	CONSTRAINT `LODelBaseBandEnum` CHECK (`BaseBand` IN ('BB_1', 'BB_2', 'BB_3', 'BB_4')),
	CONSTRAINT `LODelayAltKey` UNIQUE (`AntennaId`, `BaseBand`)
) ENGINE=INNODB;
CREATE TABLE `XPDelay` (
	`XPDelayId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`ConfigurationId` INTEGER NOT NULL,
	`ReceiverBand` VARCHAR (128) NOT NULL,
	`SideBand` VARCHAR (128) NOT NULL,
	`BaseBand` VARCHAR (128) NOT NULL,
	`Delay` DOUBLE NOT NULL,
	`DelayError` DOUBLE NULL,
	`ObservationTime` BIGINT NULL,
	`ExecBlockUID` VARCHAR (100) NULL,
	`ScanNumber` INTEGER NULL,
	CONSTRAINT `HWConfigXPDelay` FOREIGN KEY (`ConfigurationId`) REFERENCES `HWConfiguration` (`ConfigurationId`),
	CONSTRAINT `XPDelBaseBandEnum` CHECK (`BaseBand` IN ('BB_1', 'BB_2', 'BB_3', 'BB_4')),
	CONSTRAINT `XPDelSideBandEnum` CHECK (`SideBand` IN ('LSB', 'USB')),
	CONSTRAINT `XPDelFreqBandEnum` CHECK (`ReceiverBand` IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT `XPDelayAltKey` UNIQUE (`ConfigurationId`, `ReceiverBand`, `SideBand`, `BaseBand`)
) ENGINE=INNODB;
CREATE TABLE `CorrQuadrant` (
	`BaseElementId` INTEGER NOT NULL,
	`BaseBand` VARCHAR (128) NOT NULL,
	`Quadrant` TINYINT NOT NULL,
	`ChannelNumber` TINYINT NOT NULL,
	CONSTRAINT `CorrQuadBEId` FOREIGN KEY (`BaseElementId`) REFERENCES `BaseElement` (`BaseElementId`),
	CONSTRAINT `CorrQuadNumber` CHECK (`Quadrant` IN (0, 1, 2, 3)),
	CONSTRAINT `CorrQuadBBEnum` CHECK (`BaseBand` IN ('BB_1', 'BB_2', 'BB_3', 'BB_4')),
	CONSTRAINT `CorrQuadrantKey` PRIMARY KEY (`BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `CorrQuadrantRack` (
	`BaseElementId` INTEGER NOT NULL,
	`CorrQuadrantId` INTEGER NOT NULL,
	`RackName` VARCHAR (128) NOT NULL,
	`RackType` VARCHAR (10) NOT NULL,
	CONSTRAINT `CorrQuadRackBEId` FOREIGN KEY (`BaseElementId`) REFERENCES `BaseElement` (`BaseElementId`),
	CONSTRAINT `CorrQuad` FOREIGN KEY (`CorrQuadrantId`) REFERENCES `CorrQuadrant` (`BaseElementId`),
	CONSTRAINT `CorrRackType` CHECK (`RackType` IN ('Station', 'Correlator')),
	CONSTRAINT `CorrQuRKey` PRIMARY KEY (`BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `CorrStationBin` (
	`BaseElementId` INTEGER NOT NULL,
	`CorrQuadrantRackId` INTEGER NOT NULL,
	`StationBinName` VARCHAR (128) NOT NULL,
	CONSTRAINT `CorrStBinBEId` FOREIGN KEY (`BaseElementId`) REFERENCES `BaseElement` (`BaseElementId`),
	CONSTRAINT `CorrStBinRack` FOREIGN KEY (`CorrQuadrantRackId`) REFERENCES `CorrQuadrantRack` (`BaseElementId`),
	CONSTRAINT `CorrStBKey` PRIMARY KEY (`BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `CorrelatorBin` (
	`BaseElementId` INTEGER NOT NULL,
	`CorrQuadrantRackId` INTEGER NOT NULL,
	`CorrelatorBinName` VARCHAR (128) NOT NULL,
	CONSTRAINT `CorrBinBEId` FOREIGN KEY (`BaseElementId`) REFERENCES `BaseElement` (`BaseElementId`),
	CONSTRAINT `CorrBinRack` FOREIGN KEY (`CorrQuadrantRackId`) REFERENCES `CorrQuadrantRack` (`BaseElementId`),
	CONSTRAINT `CorrelBKey` PRIMARY KEY (`BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `Startup` (
	`StartupId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`ConfigurationId` INTEGER NOT NULL,
	`StartupName` VARCHAR (256) NOT NULL,
	CONSTRAINT `StartupConfig` FOREIGN KEY (`ConfigurationId`) REFERENCES `HWConfiguration` (`ConfigurationId`),
	CONSTRAINT `StartupAltKey` UNIQUE (`StartupName`, `ConfigurationId`)
) ENGINE=INNODB;
CREATE TABLE `BaseElementStartup` (
	`BaseElementStartupId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`BaseElementId` INTEGER NULL,
	`StartupId` INTEGER NULL,
	`BaseElementType` VARCHAR (24) NOT NULL,
	`Parent` INTEGER NULL,
	`IsGeneric` VARCHAR (5) NOT NULL,
	`Simulated` BOOLEAN NOT NULL,
	CONSTRAINT `BEStartupId` FOREIGN KEY (`StartupId`) REFERENCES `Startup` (`StartupId`),
	CONSTRAINT `BEStartupIdBE` FOREIGN KEY (`BaseElementId`) REFERENCES `BaseElement` (`BaseElementId`),
	CONSTRAINT `BEStartupParent` FOREIGN KEY (`Parent`) REFERENCES `BaseElementStartup` (`BaseElementStartupId`),
	CONSTRAINT `BEStartupBEType` CHECK (`BaseElementType` IN ('Antenna', 'Pad', 'FrontEnd', 'WeatherStationController', 'CentralLO', 'AOSTiming', 'HolographyTower', 'Array', 'PhotonicReference1', 'PhotonicReference2', 'PhotonicReference3', 'PhotonicReference4', 'PhotonicReference5', 'PhotonicReference6')),
	CONSTRAINT `BaseElSAltKey` UNIQUE (`StartupId`, `BaseElementId`, `Parent`, `BaseElementType`)
) ENGINE=INNODB;
CREATE TABLE `AssemblyStartup` (
	`AssemblyStartupId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`RoleName` VARCHAR (128) NOT NULL,
	`BaseElementStartupId` INTEGER NOT NULL,
	`Simulated` BOOLEAN NOT NULL,
	CONSTRAINT `AssemblyStartupRole` FOREIGN KEY (`RoleName`) REFERENCES `AssemblyRole` (`RoleName`),
	CONSTRAINT `AssemblyStartupBEStartup` FOREIGN KEY (`BaseElementStartupId`) REFERENCES `BaseElementStartup` (`BaseElementStartupId`),
	CONSTRAINT `AssembSAltKey` UNIQUE (`BaseElementStartupId`, `RoleName`)
) ENGINE=INNODB;
CREATE TABLE `DefaultCanAddress` (
	`ComponentId` INTEGER NOT NULL,
	`IsEthernet` BOOLEAN NOT NULL,
	`NodeAddress` VARCHAR (16) NULL,
	`ChannelNumber` TINYINT NULL,
	`Hostname` VARCHAR (80) NULL,
	`Port` INTEGER NULL,
	`MacAddress` VARCHAR (80) NULL,
	`Retries` SMALLINT NULL,
	`TimeOutRxTx` DOUBLE NULL,
	`LingerTime` INTEGER NULL,
	CONSTRAINT `DefCanAddComp` FOREIGN KEY (`ComponentId`) REFERENCES `Component` (`ComponentId`),
	CONSTRAINT `DefaulCAKey` PRIMARY KEY (`ComponentId`)
) ENGINE=INNODB;
CREATE TABLE `PointingModel` (
	`PointingModelId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`AntennaId` INTEGER NOT NULL,
	`ObservationTime` BIGINT NULL,
	`ExecBlockUID` VARCHAR (100) NULL,
	`ScanNumber` INTEGER NULL,
	`SoftwareVersion` VARCHAR (100) NULL,
	`Comments` MEDIUMTEXT NULL,
	`SourceNumber` INTEGER NULL,
	`MetrologyMode` VARCHAR (100) NULL,
	`MetrologyFlag` VARCHAR (100) NULL,
	`SourceDensity` DOUBLE NULL,
	`PointingRMS` DOUBLE NULL,
	`Locked` BOOLEAN NULL,
	`IncreaseVersion` BOOLEAN NULL,
	`CurrentVersion` INTEGER NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	CONSTRAINT `AntennaPMAntenna` FOREIGN KEY (`AntennaId`) REFERENCES `Antenna` (`BaseElementId`),
	CONSTRAINT `PointiMAltKey` UNIQUE (`AntennaId`)
) ENGINE=INNODB;
CREATE TABLE `PointingModelCoeff` (
	`PointingModelCoeffId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`PointingModelId` INTEGER NOT NULL,
	`CoeffName` VARCHAR (128) NOT NULL,
	`CoeffValue` DOUBLE NOT NULL,
	CONSTRAINT `AntPMTermPointingModelId` FOREIGN KEY (`PointingModelId`) REFERENCES `PointingModel` (`PointingModelId`),
	CONSTRAINT `PointiMCAltKey` UNIQUE (`PointingModelId`, `CoeffName`)
) ENGINE=INNODB;
CREATE TABLE `PointingModelCoeffOffset` (
	`PointingModelCoeffId` INTEGER NOT NULL,
	`ReceiverBand` VARCHAR (128) NOT NULL,
	`Offset` DOUBLE NOT NULL,
	CONSTRAINT `AntPMCoeffOffToCoeff` FOREIGN KEY (`PointingModelCoeffId`) REFERENCES `PointingModelCoeff` (`PointingModelCoeffId`),
	CONSTRAINT `AntennaPMCoeffOffBand` CHECK (`ReceiverBand` IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT `PointiMCOKey` PRIMARY KEY (`PointingModelCoeffId`, `ReceiverBand`)
) ENGINE=INNODB;
CREATE TABLE `FocusModel` (
	`FocusModelId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`AntennaId` INTEGER NOT NULL,
	`ObservationTime` BIGINT NULL,
	`ExecBlockUID` VARCHAR (100) NULL,
	`ScanNumber` INTEGER NULL,
	`SoftwareVersion` VARCHAR (100) NULL,
	`Comments` MEDIUMTEXT NULL,
	`SourceDensity` DOUBLE NULL,
	`Locked` BOOLEAN NULL,
	`IncreaseVersion` BOOLEAN NULL,
	`CurrentVersion` INTEGER NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	CONSTRAINT `AntennaFMAntenna` FOREIGN KEY (`AntennaId`) REFERENCES `Antenna` (`BaseElementId`),
	CONSTRAINT `FocusModelAltKey` UNIQUE (`AntennaId`)
) ENGINE=INNODB;
CREATE TABLE `FocusModelCoeff` (
	`FocusModelCoeffId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`FocusModelId` INTEGER NOT NULL,
	`CoeffName` VARCHAR (128) NOT NULL,
	`CoeffValue` DOUBLE NOT NULL,
	CONSTRAINT `AntFMTermFocusModelId` FOREIGN KEY (`FocusModelId`) REFERENCES `FocusModel` (`FocusModelId`),
	CONSTRAINT `FocusMCAltKey` UNIQUE (`FocusModelId`, `CoeffName`)
) ENGINE=INNODB;
CREATE TABLE `FocusModelCoeffOffset` (
	`FocusModelCoeffId` INTEGER NOT NULL,
	`ReceiverBand` VARCHAR (128) NOT NULL,
	`Offset` DOUBLE NOT NULL,
	CONSTRAINT `AntFMCoeffOffToCoeff` FOREIGN KEY (`FocusModelCoeffId`) REFERENCES `FocusModelCoeff` (`FocusModelCoeffId`),
	CONSTRAINT `AntennaFMCoeffOffBand` CHECK (`ReceiverBand` IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT `FocusMCOKey` PRIMARY KEY (`FocusModelCoeffId`, `ReceiverBand`)
) ENGINE=INNODB;
CREATE TABLE `DefaultComponent` (
	`DefaultComponentId` INTEGER NOT NULL,
	`ComponentTypeId` INTEGER NOT NULL,
	`AssemblyTypeName` VARCHAR (256) NOT NULL,
	`ImplLang` VARCHAR (6) NOT NULL,
	`RealTime` BOOLEAN NOT NULL,
	`Code` VARCHAR (256) NOT NULL,
	`Path` VARCHAR (256) NOT NULL,
	`IsAutostart` BOOLEAN NOT NULL,
	`IsDefault` BOOLEAN NOT NULL,
	`IsStandaloneDefined` BOOLEAN NULL,
	`KeepAliveTime` INTEGER NOT NULL,
	`MinLogLevel` TINYINT DEFAULT -1,
	`MinLogLevelLocal` TINYINT DEFAULT -1,
	`XMLDoc` MEDIUMTEXT NULL,
	CONSTRAINT `DefaultComponentTypeId` FOREIGN KEY (`ComponentTypeId`) REFERENCES `ComponentType` (`ComponentTypeId`),
	CONSTRAINT `DefaultComponentAssemblyId` FOREIGN KEY (`AssemblyTypeName`) REFERENCES `AssemblyType` (`AssemblyTypeName`),
	CONSTRAINT `DefaultComponentImplLang` CHECK (`ImplLang` IN ('java', 'cpp', 'py')),
	CONSTRAINT `DefaulCKey` PRIMARY KEY (`DefaultComponentId`)
) ENGINE=INNODB;
CREATE TABLE `DefaultBaciProperty` (
	`DefaultBaciPropId` INTEGER NOT NULL,
	`DefaultComponentId` INTEGER NOT NULL,
	`PropertyName` VARCHAR (128) NOT NULL,
	`description` MEDIUMTEXT NOT NULL,
	`format` VARCHAR (16) NOT NULL,
	`units` VARCHAR (24) NOT NULL,
	`resolution` VARCHAR (10) NOT NULL,
	`archive_priority` INTEGER NOT NULL,
	`archive_min_int` DOUBLE NOT NULL,
	`archive_max_int` DOUBLE NOT NULL,
	`archive_mechanism` VARCHAR (24) NOT NULL,
	`archive_suppress` BOOLEAN NOT NULL,
	`default_timer_trig` DOUBLE NOT NULL,
	`min_timer_trig` DOUBLE NOT NULL,
	`initialize_devio` BOOLEAN NOT NULL,
	`min_delta_trig` DOUBLE NULL,
	`default_value` MEDIUMTEXT NOT NULL,
	`graph_min` DOUBLE NULL,
	`graph_max` DOUBLE NULL,
	`min_step` DOUBLE NULL,
	`archive_delta` DOUBLE NOT NULL,
	`archive_delta_percent` DOUBLE NULL,
	`alarm_high_on` DOUBLE NULL,
	`alarm_low_on` DOUBLE NULL,
	`alarm_high_off` DOUBLE NULL,
	`alarm_low_off` DOUBLE NULL,
	`alarm_timer_trig` DOUBLE NULL,
	`min_value` DOUBLE NULL,
	`max_value` DOUBLE NULL,
	`bitDescription` MEDIUMTEXT NULL,
	`whenSet` MEDIUMTEXT NULL,
	`whenCleared` MEDIUMTEXT NULL,
	`statesDescription` MEDIUMTEXT NULL,
	`condition` MEDIUMTEXT NULL,
	`alarm_on` MEDIUMTEXT NULL,
	`alarm_off` MEDIUMTEXT NULL,
	`alarm_fault_family` MEDIUMTEXT NULL,
	`alarm_fault_member` MEDIUMTEXT NULL,
	`alarm_level` INTEGER NULL,
	`Data` MEDIUMTEXT NULL,
	CONSTRAINT `DefBACIDefaultComponentTypeId` FOREIGN KEY (`DefaultComponentId`) REFERENCES `DefaultComponent` (`DefaultComponentId`),
	CONSTRAINT `DefaulBPKey` PRIMARY KEY (`DefaultBaciPropId`)
) ENGINE=INNODB;
CREATE TABLE `DefaultMonitorPoint` (
	`DefaultMonitorPointId` INTEGER NOT NULL,
	`DefaultBACIPropertyId` INTEGER NOT NULL,
	`MonitorPointName` VARCHAR (128) NOT NULL,
	`Indice` INTEGER NOT NULL,
	`DataType` VARCHAR (16) NOT NULL,
	`RCA` VARCHAR (16) NOT NULL,
	`TeRelated` BOOLEAN NOT NULL,
	`RawDataType` VARCHAR (24) NOT NULL,
	`WorldDataType` VARCHAR (24) NOT NULL,
	`Units` VARCHAR (24) NULL,
	`Scale` DOUBLE NULL,
	`Offset` DOUBLE NULL,
	`MinRange` VARCHAR (24) NULL,
	`MaxRange` VARCHAR (24) NULL,
	`Description` MEDIUMTEXT NOT NULL,
	CONSTRAINT `DefaulPntId` FOREIGN KEY (`DefaultBACIPropertyId`) REFERENCES `DefaultBaciProperty` (`DefaultBaciPropId`),
	CONSTRAINT `DefaulMPKey` PRIMARY KEY (`DefaultMonitorPointId`)
) ENGINE=INNODB;
CREATE TABLE `MonitorPoint` (
	`MonitorPointId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`BACIPropertyId` INTEGER NOT NULL,
	`MonitorPointName` VARCHAR (128) NOT NULL,
	`AssemblyId` INTEGER NOT NULL,
	`Indice` INTEGER NOT NULL,
	`DataType` VARCHAR (16) NOT NULL,
	`RCA` VARCHAR (16) NOT NULL,
	`TeRelated` BOOLEAN NOT NULL,
	`RawDataType` VARCHAR (24) NOT NULL,
	`WorldDataType` VARCHAR (24) NOT NULL,
	`Units` VARCHAR (24) NULL,
	`Scale` DOUBLE NULL,
	`Offset` DOUBLE NULL,
	`MinRange` VARCHAR (24) NULL,
	`MaxRange` VARCHAR (24) NULL,
	`Description` MEDIUMTEXT NOT NULL,
	CONSTRAINT `MonitorPointAssemblyId` FOREIGN KEY (`AssemblyId`) REFERENCES `Assembly` (`AssemblyId`),
	CONSTRAINT `MonitorPointBACIPropertyId` FOREIGN KEY (`BACIPropertyId`) REFERENCES `BACIProperty` (`BACIPropertyId`),
	CONSTRAINT `MonitorPointDatatype` CHECK (`DataType` IN ('float', 'double', 'boolean', 'string', 'integer', 'enum', 'clob')),
	CONSTRAINT `MonitorPointAltKey` UNIQUE (`BACIPropertyId`, `AssemblyId`, `Indice`)
) ENGINE=INNODB;
CREATE TABLE `MonitorData` (
	`MonitorPointId` INTEGER NOT NULL,
	`StartTime` BIGINT NOT NULL,
	`EndTime` BIGINT NOT NULL,
	`MonitorTS` TIMESTAMP NOT NULL,
	`SampleSize` INTEGER NOT NULL,
	`MonitorClob` MEDIUMTEXT NOT NULL,
	`MinStat` DOUBLE NULL,
	`MaxStat` DOUBLE NULL,
	`MeanStat` DOUBLE NULL,
	`StdDevStat` DOUBLE NULL,
	CONSTRAINT `MonitorDataMonitorPointId` FOREIGN KEY (`MonitorPointId`) REFERENCES `MonitorPoint` (`MonitorPointId`),
	CONSTRAINT `MonitorDataKey` PRIMARY KEY (`MonitorPointId`, `MonitorTS`)
) ENGINE=INNODB;
CREATE TABLE `BaseElementOnline` (
	`BaseElementOnlineId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`BaseElementId` INTEGER NOT NULL,
	`ConfigurationId` INTEGER NOT NULL,
	`StartTime` BIGINT NOT NULL,
	`EndTime` BIGINT NULL,
	`NormalTermination` BOOLEAN NOT NULL,
	CONSTRAINT `BEOnlineId` FOREIGN KEY (`BaseElementId`) REFERENCES `BaseElement` (`BaseElementId`),
	CONSTRAINT `BEOnlineConfig` FOREIGN KEY (`ConfigurationId`) REFERENCES `HWConfiguration` (`ConfigurationId`),
	CONSTRAINT `BaseElOAltKey` UNIQUE (`BaseElementId`, `ConfigurationId`, `StartTime`)
) ENGINE=INNODB;
CREATE TABLE `AssemblyOnline` (
	`AssemblyOnlineId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`AssemblyId` INTEGER NOT NULL,
	`BaseElementOnlineId` INTEGER NOT NULL,
	`RoleName` VARCHAR (128) NOT NULL,
	`StartTime` BIGINT NOT NULL,
	`EndTime` BIGINT NULL,
	CONSTRAINT `BEAssemblyListId` FOREIGN KEY (`BaseElementOnlineId`) REFERENCES `BaseElementOnline` (`BaseElementOnlineId`),
	CONSTRAINT `BEAssemblyListAssemblyId` FOREIGN KEY (`AssemblyId`) REFERENCES `Assembly` (`AssemblyId`),
	CONSTRAINT `AssembOAltKey` UNIQUE (`AssemblyId`, `BaseElementOnlineId`)
) ENGINE=INNODB;
CREATE TABLE `Array` (
	`ArrayId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`BaseElementId` INTEGER NOT NULL,
	`Type` VARCHAR (9) NOT NULL,
	`UserId` VARCHAR (256) NULL,
	`StartTime` BIGINT NOT NULL,
	`EndTime` BIGINT NULL,
	`NormalTermination` BOOLEAN NOT NULL,
	CONSTRAINT `ArrayBEId` FOREIGN KEY (`BaseElementId`) REFERENCES `BaseElement` (`BaseElementId`),
	CONSTRAINT `ArrayType` CHECK (`Type` IN ('automatic', 'manual')),
	CONSTRAINT `ArrayAltKey` UNIQUE (`StartTime`, `BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `AntennaToArray` (
	`AntennaId` INTEGER NOT NULL,
	`ArrayId` INTEGER NOT NULL,
	CONSTRAINT `AntennaToArrayAntennaId` FOREIGN KEY (`AntennaId`) REFERENCES `Antenna` (`BaseElementId`),
	CONSTRAINT `AntennaToArrayArrayid` FOREIGN KEY (`ArrayId`) REFERENCES `Array` (`ArrayId`),
	CONSTRAINT `AntennTAKey` PRIMARY KEY (`AntennaId`, `ArrayId`)
) ENGINE=INNODB;
CREATE TABLE `SBExecution` (
	`ArrayId` INTEGER NOT NULL,
	`SbUID` VARCHAR (256) NOT NULL,
	`StartTime` BIGINT NOT NULL,
	`EndTime` BIGINT NULL,
	`NormalTermination` BOOLEAN NOT NULL,
	CONSTRAINT `SBExecutionArrayId` FOREIGN KEY (`ArrayId`) REFERENCES `Array` (`ArrayId`),
	CONSTRAINT `SBExecutionKey` PRIMARY KEY (`ArrayId`, `SbUID`, `StartTime`)
) ENGINE=INNODB;
CREATE TABLE `AntennaToFrontEnd` (
	`AntennaToFrontEndId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`AntennaId` INTEGER NOT NULL,
	`FrontEndId` INTEGER NOT NULL,
	`StartTime` BIGINT NOT NULL,
	`EndTime` BIGINT NULL,
	CONSTRAINT `AntennaToFEAntennaId` FOREIGN KEY (`AntennaId`) REFERENCES `Antenna` (`BaseElementId`),
	CONSTRAINT `AntennaToFEFrontEndId` FOREIGN KEY (`FrontEndId`) REFERENCES `FrontEnd` (`BaseElementId`),
	CONSTRAINT `AntennTFEAltKey` UNIQUE (`AntennaId`, `FrontEndId`, `StartTime`)
) ENGINE=INNODB;
CREATE TABLE `BL_VersionInfo` (
	`TableName` VARCHAR (128) NOT NULL,
	`SwConfigurationId` INTEGER NOT NULL,
	`EntityId` INTEGER NOT NULL,
	`Locked` BOOLEAN NOT NULL,
	`IncreaseVersion` BOOLEAN NOT NULL,
	`CurrentVersion` INTEGER NOT NULL,
	`Who` VARCHAR (128) NOT NULL,
	`ChangeDesc` MEDIUMTEXT NOT NULL,
	CONSTRAINT `VersionInfoSwCnfId` FOREIGN KEY (`SwConfigurationId`) REFERENCES `Configuration` (`ConfigurationId`),
	CONSTRAINT `BL_VerIKey` PRIMARY KEY (`TableName`, `SwConfigurationId`, `EntityId`)
) ENGINE=INNODB;
CREATE TABLE `BL_PointingModelCoeff` (
	`Version` INTEGER NOT NULL,
	`ModTime` BIGINT NOT NULL,
	`Operation` CHAR (1) NOT NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	`PointingModelId` INTEGER NOT NULL,
	`CoeffName` VARCHAR (128) NOT NULL,
	`CoeffValue` DOUBLE NOT NULL,
	CONSTRAINT `BL_PointingModelCoeffOp` CHECK (`Operation` IN ('I', 'U', 'D')),
	CONSTRAINT `BL_PoiMCKey` PRIMARY KEY (`Version`, `ModTime`, `Operation`, `PointingModelId`, `CoeffName`)
) ENGINE=INNODB;
CREATE TABLE `BL_PointingModelCoeffOffset` (
	`Version` INTEGER NOT NULL,
	`ModTime` BIGINT NOT NULL,
	`Operation` CHAR (1) NOT NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	`PointingModelId` INTEGER NOT NULL,
	`CoeffName` VARCHAR (128) NOT NULL,
	`ReceiverBand` VARCHAR (128) NOT NULL,
	`Offset` DOUBLE NOT NULL,
	CONSTRAINT `BL_AntennaPMCoeffOffOp` CHECK (`Operation` IN ('I', 'U', 'D')),
	CONSTRAINT `BL_AntennaPMCoeffOffBand` CHECK (`ReceiverBand` IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT `BL_PoiMCOKey` PRIMARY KEY (`Version`, `ModTime`, `Operation`, `PointingModelId`, `CoeffName`, `ReceiverBand`)
) ENGINE=INNODB;
CREATE TABLE `BL_FocusModelCoeff` (
	`Version` INTEGER NOT NULL,
	`ModTime` BIGINT NOT NULL,
	`Operation` CHAR (1) NOT NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	`FocusModelId` INTEGER NOT NULL,
	`CoeffName` VARCHAR (128) NOT NULL,
	`CoeffValue` DOUBLE NOT NULL,
	CONSTRAINT `BL_FocusModelCoeffOp` CHECK (`Operation` IN ('I', 'U', 'D')),
	CONSTRAINT `BL_FocMCKey` PRIMARY KEY (`Version`, `ModTime`, `Operation`, `FocusModelId`, `CoeffName`)
) ENGINE=INNODB;
CREATE TABLE `BL_FocusModelCoeffOffset` (
	`Version` INTEGER NOT NULL,
	`ModTime` BIGINT NOT NULL,
	`Operation` CHAR (1) NOT NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	`FocusModelId` INTEGER NOT NULL,
	`CoeffName` VARCHAR (128) NOT NULL,
	`ReceiverBand` VARCHAR (128) NOT NULL,
	`Offset` DOUBLE NOT NULL,
	CONSTRAINT `BL_AntennaFMCoeffOffOp` CHECK (`Operation` IN ('I', 'U', 'D')),
	CONSTRAINT `BL_AntennaFMCoeffOffBand` CHECK (`ReceiverBand` IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT `BL_FocMCOKey` PRIMARY KEY (`Version`, `ModTime`, `Operation`, `FocusModelId`, `CoeffName`, `ReceiverBand`)
) ENGINE=INNODB;
CREATE TABLE `BL_FEDelay` (
	`Version` INTEGER NOT NULL,
	`ModTime` BIGINT NOT NULL,
	`Operation` CHAR (1) NOT NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	`FEDelayId` INTEGER NOT NULL,
	`AntennaId` INTEGER NOT NULL,
	`ReceiverBand` VARCHAR (128) NOT NULL,
	`Polarization` VARCHAR (128) NOT NULL,
	`SideBand` VARCHAR (128) NOT NULL,
	`Delay` DOUBLE NOT NULL,
	CONSTRAINT `BL_FEDelayOp` CHECK (`Operation` IN ('I', 'U', 'D')),
	CONSTRAINT `BL_FEDelayKey` PRIMARY KEY (`Version`, `ModTime`, `Operation`, `FEDelayId`)
) ENGINE=INNODB;
CREATE TABLE `BL_IFDelay` (
	`Version` INTEGER NOT NULL,
	`ModTime` BIGINT NOT NULL,
	`Operation` CHAR (1) NOT NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	`IFDelayId` INTEGER NOT NULL,
	`AntennaId` INTEGER NOT NULL,
	`BaseBand` VARCHAR (128) NOT NULL,
	`Polarization` VARCHAR (128) NOT NULL,
	`IFSwitch` VARCHAR (128) NOT NULL,
	`Delay` DOUBLE NOT NULL,
	CONSTRAINT `BL_IFDelayOp` CHECK (`Operation` IN ('I', 'U', 'D')),
	CONSTRAINT `BL_IFDelayKey` PRIMARY KEY (`Version`, `ModTime`, `Operation`, `IFDelayId`)
) ENGINE=INNODB;
CREATE TABLE `BL_LODelay` (
	`Version` INTEGER NOT NULL,
	`ModTime` BIGINT NOT NULL,
	`Operation` CHAR (1) NOT NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	`LODelayId` INTEGER NOT NULL,
	`AntennaId` INTEGER NOT NULL,
	`BaseBand` VARCHAR (128) NOT NULL,
	`Delay` DOUBLE NOT NULL,
	CONSTRAINT `BL_LODelayOp` CHECK (`Operation` IN ('I', 'U', 'D')),
	CONSTRAINT `BL_LODelayKey` PRIMARY KEY (`Version`, `ModTime`, `Operation`, `LODelayId`)
) ENGINE=INNODB;
CREATE TABLE `BL_XPDelay` (
	`Version` INTEGER NOT NULL,
	`ModTime` BIGINT NOT NULL,
	`Operation` CHAR (1) NOT NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	`XPDelayId` INTEGER NOT NULL,
	`ConfigurationId` INTEGER NOT NULL,
	`ReceiverBand` VARCHAR (128) NOT NULL,
	`SideBand` VARCHAR (128) NOT NULL,
	`BaseBand` VARCHAR (128) NOT NULL,
	`Delay` DOUBLE NOT NULL,
	CONSTRAINT `BL_XPDelayOp` CHECK (`Operation` IN ('I', 'U', 'D')),
	CONSTRAINT `BL_XPDelayKey` PRIMARY KEY (`Version`, `ModTime`, `Operation`, `XPDelayId`)
) ENGINE=INNODB;
CREATE TABLE `BL_AntennaDelay` (
	`Version` INTEGER NOT NULL,
	`ModTime` BIGINT NOT NULL,
	`Operation` CHAR (1) NOT NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	`BaseElementId` INTEGER NOT NULL,
	`Delay` DOUBLE NOT NULL,
	CONSTRAINT `BL_AntDKey` PRIMARY KEY (`Version`, `ModTime`, `Operation`, `BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `BL_Antenna` (
	`Version` INTEGER NOT NULL,
	`ModTime` BIGINT NOT NULL,
	`Operation` CHAR (1) NOT NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	`BaseElementId` INTEGER NOT NULL,
	`AntennaType` VARCHAR (4) NOT NULL,
	`DishDiameter` DOUBLE NOT NULL,
	`CommissionDate` BIGINT NOT NULL,
	`XPosition` DOUBLE NOT NULL,
	`YPosition` DOUBLE NOT NULL,
	`ZPosition` DOUBLE NOT NULL,
	`XOffset` DOUBLE NOT NULL,
	`YOffset` DOUBLE NOT NULL,
	`ZOffset` DOUBLE NOT NULL,
	`LOOffsettingIndex` INTEGER NOT NULL,
	`WalshSeq` INTEGER NOT NULL,
	`CaiBaseline` INTEGER NULL,
	`CaiAca` INTEGER NULL,
	CONSTRAINT `BL_AntennaKey` PRIMARY KEY (`Version`, `ModTime`, `Operation`, `BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `BL_Pad` (
	`Version` INTEGER NOT NULL,
	`ModTime` BIGINT NOT NULL,
	`Operation` CHAR (1) NOT NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	`BaseElementId` INTEGER NOT NULL,
	`CommissionDate` BIGINT NOT NULL,
	`XPosition` DOUBLE NOT NULL,
	`YPosition` DOUBLE NOT NULL,
	`ZPosition` DOUBLE NOT NULL,
	`Delay` DOUBLE NOT NULL,
	CONSTRAINT `BL_PadKey` PRIMARY KEY (`Version`, `ModTime`, `Operation`, `BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `BL_AntennaToPad` (
	`Version` INTEGER NOT NULL,
	`ModTime` BIGINT NOT NULL,
	`Operation` CHAR (1) NOT NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	`AntennaToPadId` INTEGER NOT NULL,
	`MountMetrologyAN0Coeff` DOUBLE NULL,
	`MountMetrologyAW0Coeff` DOUBLE NULL,
	CONSTRAINT `BL_AntTPKey` PRIMARY KEY (`Version`, `ModTime`, `Operation`, `AntennaToPadId`)
) ENGINE=INNODB;
CREATE TABLE `BL_AcaCorrDelays` (
	`Version` INTEGER NOT NULL,
	`ModTime` BIGINT NOT NULL,
	`Operation` CHAR (1) NOT NULL,
	`Who` VARCHAR (128) NULL,
	`ChangeDesc` MEDIUMTEXT NULL,
	`AntennaId` INTEGER NOT NULL,
	`BbOneDelay` DOUBLE NOT NULL,
	`BbTwoDelay` DOUBLE NOT NULL,
	`BbThreeDelay` DOUBLE NOT NULL,
	`BbFourDelay` DOUBLE NOT NULL,
	CONSTRAINT `BL_AcaCDKey` PRIMARY KEY (`Version`, `ModTime`, `Operation`, `AntennaId`)
) ENGINE=INNODB;
CREATE TABLE `AntennaEfficiency` (
	`AntennaEfficiencyId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`AntennaId` INTEGER NOT NULL,
	`ObservationTime` BIGINT NOT NULL,
	`ExecBlockUID` VARCHAR (100) NOT NULL,
	`ScanNumber` INTEGER NOT NULL,
	`ThetaMinorPolX` DOUBLE NOT NULL,
	`ThetaMinorPolY` DOUBLE NOT NULL,
	`ThetaMajorPolX` DOUBLE NOT NULL,
	`ThetaMajorPolY` DOUBLE NOT NULL,
	`PositionAngleBeamPolX` DOUBLE NOT NULL,
	`PositionAngleBeamPolY` DOUBLE NOT NULL,
	`SourceName` VARCHAR (100) NOT NULL,
	`SourceSize` DOUBLE NOT NULL,
	`Frequency` DOUBLE NOT NULL,
	`ApertureEff` DOUBLE NOT NULL,
	`ApertureEffError` DOUBLE NOT NULL,
	`ForwardEff` DOUBLE NOT NULL,
	`ForwardEffError` DOUBLE NOT NULL,
	CONSTRAINT `AntEffToAntenna` FOREIGN KEY (`AntennaId`) REFERENCES `Antenna` (`BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `ReceiverQuality` (
	`ReceiverQualityId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`AntennaId` INTEGER NOT NULL,
	`ObservationTime` BIGINT NOT NULL,
	`ExecBlockUID` VARCHAR (100) NOT NULL,
	`ScanNumber` INTEGER NOT NULL,
	CONSTRAINT `RecQualityToAntenna` FOREIGN KEY (`AntennaId`) REFERENCES `Antenna` (`BaseElementId`)
) ENGINE=INNODB;
CREATE TABLE `ReceiverQualityParameters` (
	`ReceiverQualityParamId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`ReceiverQualityId` INTEGER NOT NULL,
	`Frequency` DOUBLE NOT NULL,
	`SidebandRatio` DOUBLE NOT NULL,
	`Trx` DOUBLE NOT NULL,
	`Polarization` DOUBLE NOT NULL,
	`BandPassQuality` DOUBLE NOT NULL,
	CONSTRAINT `RecQualityParamToRecQual` FOREIGN KEY (`ReceiverQualityId`) REFERENCES `ReceiverQuality` (`ReceiverQualityId`)
) ENGINE=INNODB;
CREATE TABLE `Holography` (
	`HolographyId` INTEGER PRIMARY KEY AUTO_INCREMENT,
	`AntennaId` INTEGER NOT NULL,
	`ObservationTime` BIGINT NOT NULL,
	`ExecBlockUID` VARCHAR (100) NOT NULL,
	`ScanNumber` INTEGER NOT NULL,
	`ObservationDuration` DOUBLE NOT NULL,
	`LowElevation` DOUBLE NOT NULL,
	`HighElevation` DOUBLE NOT NULL,
	`MapSize` DOUBLE NOT NULL,
	`SoftwareVersion` VARCHAR (100) NOT NULL,
	`ObsMode` VARCHAR (80) NOT NULL,
	`Comments` MEDIUMTEXT NULL,
	`Frequency` DOUBLE NOT NULL,
	`ReferenceAntenna` INTEGER NOT NULL,
	`AstigmatismX2Y2` DOUBLE NOT NULL,
	`AstigmatismXY` DOUBLE NOT NULL,
	`AstigmatismErr` DOUBLE NOT NULL,
	`PhaseRMS` DOUBLE NOT NULL,
	`SurfaceRMS` DOUBLE NOT NULL,
	`SurfaceRMSNoAstig` DOUBLE NOT NULL,
	`Ring1RMS` DOUBLE NOT NULL,
	`Ring2RMS` DOUBLE NOT NULL,
	`Ring3RMS` DOUBLE NOT NULL,
	`Ring4RMS` DOUBLE NOT NULL,
	`Ring5RMS` DOUBLE NOT NULL,
	`Ring6RMS` DOUBLE NOT NULL,
	`Ring7RMS` DOUBLE NOT NULL,
	`Ring8RMS` DOUBLE NOT NULL,
	`BeamMapFitUID` VARCHAR (100) NOT NULL,
	`SurfaceMapFitUID` VARCHAR (100) NOT NULL,
	`XFocus` DOUBLE NOT NULL,
	`XFocusErr` DOUBLE NOT NULL,
	`YFocus` DOUBLE NOT NULL,
	`YFocusErr` DOUBLE NOT NULL,
	`ZFocus` DOUBLE NOT NULL,
	`ZFocusErr` DOUBLE NOT NULL,
	CONSTRAINT `HolographyToAntenna` FOREIGN KEY (`AntennaId`) REFERENCES `Antenna` (`BaseElementId`),
	CONSTRAINT `HolographyRefAntenna` FOREIGN KEY (`ReferenceAntenna`) REFERENCES `Antenna` (`BaseElementId`),
	CONSTRAINT `HolographyObsMode` CHECK (`ObsMode` IN ('TOWER', 'ASTRO'))
) ENGINE=INNODB;
 


