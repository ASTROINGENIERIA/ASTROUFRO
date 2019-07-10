-- TMCDB SQL TABLE DEFINITIONS Version 2.2.1 2010-08-22T0000:00:00.0
--
-- /////////////////////////////////////////////////////////////////
-- // WARNING!  DO NOT MODIFY THIS FILE!                          //
-- //  ---------------------------------------------------------  //
-- // | This is generated code!  Do not modify this file.       | //
-- // | Any changes will be lost when the file is re-generated. | //
-- //  ---------------------------------------------------------  //
-- /////////////////////////////////////////////////////////////////
 
CREATE TABLE HWConfiguration (
	ConfigurationId NUMBER (10) NOT NULL,
	GlobalConfigId NUMBER (10) NULL,
	SwConfigurationId NUMBER (10) NOT NULL,
	TelescopeName VARCHAR2 (128) NOT NULL,
	ArrayReferenceX BINARY_DOUBLE NULL,
	ArrayReferenceY BINARY_DOUBLE NULL,
	ArrayReferenceZ BINARY_DOUBLE NULL,
	XPDelayBLLocked CHAR (1) NULL,
	XPDelayBLIncreaseVersion CHAR (1) NULL,
	XPDelayBLCurrentVersion NUMBER (10) NULL,
	XPDelayBLWho VARCHAR2 (128) NULL,
	XPDelayBLChangeDesc VARCHAR2 (1024) NULL,
	CONSTRAINT HWConfXPDelaBLL CHECK (XPDelayBLLocked IN ('0', '1')),
	CONSTRAINT HWConfXPDelaBLIV CHECK (XPDelayBLIncreaseVersion IN ('0', '1')),
	CONSTRAINT HWConfAltKey UNIQUE (SwConfigurationId),
	CONSTRAINT SwConfigId FOREIGN KEY (SwConfigurationId) REFERENCES Configuration,
	CONSTRAINT HWConfKey PRIMARY KEY (ConfigurationId)
);

CREATE SEQUENCE HWConf_seq;

CREATE TABLE SystemCounters (
	ConfigurationId NUMBER (10) NOT NULL,
	UpdateTime NUMBER (19) NOT NULL,
	AutoArrayCount NUMBER (5) NOT NULL,
	ManArrayCount NUMBER (5) NOT NULL,
	DataCaptureCount NUMBER (5) NOT NULL,
	CONSTRAINT SystemCountersConfig FOREIGN KEY (ConfigurationId) REFERENCES HWConfiguration,
	CONSTRAINT SystemCKey PRIMARY KEY (ConfigurationId)
);


CREATE TABLE LRUType (
	LRUName VARCHAR2 (128) NOT NULL,
	FullName VARCHAR2 (256) NOT NULL,
	ICD VARCHAR2 (256) NOT NULL,
	ICDDate NUMBER (19) NOT NULL,
	Description VARCHAR2 (1024) NOT NULL,
	Notes VARCHAR2 (1024) NULL,
	CONSTRAINT LRUTypeKey PRIMARY KEY (LRUName)
);


CREATE TABLE AssemblyType (
	AssemblyTypeName VARCHAR2 (256) NOT NULL,
	BaseElementType VARCHAR2 (24) NOT NULL,
	LRUName VARCHAR2 (128) NOT NULL,
	FullName VARCHAR2 (256) NOT NULL,
	Description VARCHAR2 (1024) NOT NULL,
	Notes VARCHAR2 (1024) NULL,
	ComponentTypeId NUMBER (10) NOT NULL,
	ProductionCode VARCHAR2 (256) NOT NULL,
	SimulatedCode VARCHAR2 (256) NOT NULL,
	CONSTRAINT AssemblyTypeLRUName FOREIGN KEY (LRUName) REFERENCES LRUType,
	CONSTRAINT AssemblyTypeCompType FOREIGN KEY (ComponentTypeId) REFERENCES ComponentType,
	CONSTRAINT AssemblyTypeBEType CHECK (BaseElementType IN ('Antenna', 'Pad', 'FrontEnd', 'WeatherStationController', 'CorrQuadrant', 'AcaCorrSet', 'CentralLO', 'AOSTiming', 'PhotonicReference', 'HolographyTower', 'Array')),
	CONSTRAINT AssemblyTypeKey PRIMARY KEY (AssemblyTypeName)
);


CREATE TABLE HwSchemas (
	SchemaId NUMBER (10) NOT NULL,
	URN VARCHAR2 (512) NOT NULL,
	ConfigurationId NUMBER (10) NOT NULL,
	AssemblyTypeName VARCHAR2 (256) NOT NULL,
	Schema XMLTYPE NULL,
	CONSTRAINT HwSchemasAltKey UNIQUE (URN, ConfigurationId),
	CONSTRAINT AssemblySchemasConfig FOREIGN KEY (ConfigurationId) REFERENCES HWConfiguration,
	CONSTRAINT HwSchemaAssemblyType FOREIGN KEY (AssemblyTypeName) REFERENCES AssemblyType,
	CONSTRAINT HwSchemasKey PRIMARY KEY (SchemaId)
) XMLTYPE COLUMN Schema STORE AS CLOB;

CREATE SEQUENCE HwSchemas_seq;

CREATE TABLE Assembly (
	AssemblyId NUMBER (10) NOT NULL,
	AssemblyTypeName VARCHAR2 (256) NOT NULL,
	ConfigurationId NUMBER (10) NOT NULL,
	SerialNumber VARCHAR2 (256) NOT NULL,
	Data XMLTYPE NULL,
	CONSTRAINT AssemblyAltKey UNIQUE (SerialNumber, ConfigurationId),
	CONSTRAINT AssemblyConfig FOREIGN KEY (ConfigurationId) REFERENCES HWConfiguration,
	CONSTRAINT AssemblyName FOREIGN KEY (AssemblyTypeName) REFERENCES AssemblyType,
	CONSTRAINT AssemblyKey PRIMARY KEY (AssemblyId)
) XMLTYPE COLUMN Data STORE AS CLOB;

CREATE SEQUENCE Assembly_seq;

CREATE TABLE AssemblyRole (
	RoleName VARCHAR2 (128) NOT NULL,
	AssemblyTypeName VARCHAR2 (256) NOT NULL,
	CONSTRAINT AssemblyRoleAssembly FOREIGN KEY (AssemblyTypeName) REFERENCES AssemblyType,
	CONSTRAINT AssemblyRoleKey PRIMARY KEY (RoleName)
);


CREATE TABLE BaseElement (
	BaseElementId NUMBER (10) NOT NULL,
	BaseType VARCHAR2 (24) NOT NULL,
	BaseElementName VARCHAR2 (24) NOT NULL,
	ConfigurationId NUMBER (10) NOT NULL,
	CONSTRAINT BaseElementAltKey UNIQUE (BaseElementName, BaseType, ConfigurationId),
	CONSTRAINT BEConfig FOREIGN KEY (ConfigurationId) REFERENCES HWConfiguration,
	CONSTRAINT BEType CHECK (BaseType IN ('Antenna', 'Pad', 'FrontEnd', 'WeatherStationController', 'CentralLO', 'AOSTiming', 'HolographyTower', 'PhotonicReference', 'CorrQuadrant', 'AcaCorrSet', 'CorrQuadrantRack', 'CorrStationBin', 'CorrBin')),
	CONSTRAINT BaseElementKey PRIMARY KEY (BaseElementId)
);

CREATE SEQUENCE BaseElement_seq;

CREATE TABLE AcaCorrSet (
	BaseElementId NUMBER (10) NOT NULL,
	BaseBand VARCHAR2 (128) NOT NULL,
	IP VARCHAR2 (128) NOT NULL,
	CONSTRAINT AcaCSetBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT AcaCSetBBEnum CHECK (BaseBand IN ('BB_1', 'BB_2', 'BB_3', 'BB_4')),
	CONSTRAINT AcaCorrSetKey PRIMARY KEY (BaseElementId)
);


CREATE TABLE Antenna (
	BaseElementId NUMBER (10) NOT NULL,
	AntennaName VARCHAR2 (128) NULL,
	AntennaType VARCHAR2 (4) NOT NULL,
	DishDiameter BINARY_DOUBLE NOT NULL,
	CommissionDate NUMBER (19) NOT NULL,
	XPosition BINARY_DOUBLE NOT NULL,
	YPosition BINARY_DOUBLE NOT NULL,
	ZPosition BINARY_DOUBLE NOT NULL,
	XPositionErr BINARY_DOUBLE NULL,
	YPositionErr BINARY_DOUBLE NULL,
	ZPositionErr BINARY_DOUBLE NULL,
	XOffset BINARY_DOUBLE NOT NULL,
	YOffset BINARY_DOUBLE NOT NULL,
	ZOffset BINARY_DOUBLE NOT NULL,
	PosObservationTime NUMBER (19) NULL,
	PosExecBlockUID VARCHAR (100) NULL,
	PosScanNumber NUMBER (10) NULL,
	Comments VARCHAR2 (1024) NULL,
	Delay BINARY_DOUBLE NOT NULL,
	DelayError BINARY_DOUBLE NULL,
	DelObservationTime NUMBER (19) NULL,
	DelExecBlockUID VARCHAR (100) NULL,
	DelScanNumber NUMBER (10) NULL,
	XDelayRef BINARY_DOUBLE NULL,
	YDelayRef BINARY_DOUBLE NULL,
	ZDelayRef BINARY_DOUBLE NULL,
	LOOffsettingIndex NUMBER (10) NOT NULL,
	WalshSeq NUMBER (10) NOT NULL,
	CaiBaseline NUMBER (10) NULL,
	CaiAca NUMBER (10) NULL,
	Locked CHAR (1) NULL,
	IncreaseVersion CHAR (1) NULL,
	CurrentVersion NUMBER (10) NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	DelayBLLocked CHAR (1) NULL,
	DelayBLIncreaseVersion CHAR (1) NULL,
	DelayBLCurrentVersion NUMBER (10) NULL,
	DelayBLWho VARCHAR2 (128) NULL,
	DelayBLChangeDesc VARCHAR2 (1024) NULL,
	CONSTRAINT AntennaLocked CHECK (Locked IN ('0', '1')),
	CONSTRAINT AntennaIncreaV CHECK (IncreaseVersion IN ('0', '1')),
	CONSTRAINT AntennaDelayBLL CHECK (DelayBLLocked IN ('0', '1')),
	CONSTRAINT AntennaDelayBLIV CHECK (DelayBLIncreaseVersion IN ('0', '1')),
	CONSTRAINT AntennaBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT AntennaType CHECK (AntennaType IN ('VA', 'AEC', 'ACA')),
	CONSTRAINT AntennaKey PRIMARY KEY (BaseElementId)
);


CREATE TABLE AcaCorrDelays (
	AntennaId NUMBER (10) NOT NULL,
	BbOneDelay BINARY_DOUBLE NOT NULL,
	BbTwoDelay BINARY_DOUBLE NOT NULL,
	BbThreeDelay BINARY_DOUBLE NOT NULL,
	BbFourDelay BINARY_DOUBLE NOT NULL,
	Locked CHAR (1) NULL,
	IncreaseVersion CHAR (1) NULL,
	CurrentVersion NUMBER (10) NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	CONSTRAINT AcaCorDLocked CHECK (Locked IN ('0', '1')),
	CONSTRAINT AcaCorDIncreaV CHECK (IncreaseVersion IN ('0', '1')),
	CONSTRAINT AcaCDelAntId FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT AcaCorDKey PRIMARY KEY (AntennaId)
);


CREATE TABLE Pad (
	BaseElementId NUMBER (10) NOT NULL,
	PadName VARCHAR2 (128) NULL,
	CommissionDate NUMBER (19) NOT NULL,
	XPosition BINARY_DOUBLE NOT NULL,
	YPosition BINARY_DOUBLE NOT NULL,
	ZPosition BINARY_DOUBLE NOT NULL,
	XPositionErr BINARY_DOUBLE NULL,
	YPositionErr BINARY_DOUBLE NULL,
	ZPositionErr BINARY_DOUBLE NULL,
	PosObservationTime NUMBER (19) NULL,
	PosExecBlockUID VARCHAR (100) NULL,
	PosScanNumber NUMBER (10) NULL,
	Delay BINARY_DOUBLE NOT NULL,
	DelayError BINARY_DOUBLE NULL,
	DelObservationTime NUMBER (19) NULL,
	DelExecBlockUID VARCHAR (100) NULL,
	DelScanNumber NUMBER (10) NULL,
	Locked CHAR (1) NULL,
	IncreaseVersion CHAR (1) NULL,
	CurrentVersion NUMBER (10) NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	CONSTRAINT PadLocked CHECK (Locked IN ('0', '1')),
	CONSTRAINT PadIncreaV CHECK (IncreaseVersion IN ('0', '1')),
	CONSTRAINT PadBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT PadKey PRIMARY KEY (BaseElementId)
);


CREATE TABLE FrontEnd (
	BaseElementId NUMBER (10) NOT NULL,
	CommissionDate NUMBER (19) NOT NULL,
	CONSTRAINT FrontEndBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT FrontEndKey PRIMARY KEY (BaseElementId)
);


CREATE TABLE PhotonicReference (
	BaseElementId NUMBER (10) NOT NULL,
	CommissionDate NUMBER (19) NOT NULL,
	CONSTRAINT PhotRefBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT PhotonRKey PRIMARY KEY (BaseElementId)
);


CREATE TABLE WeatherStationController (
	BaseElementId NUMBER (10) NOT NULL,
	CommissionDate NUMBER (19) NOT NULL,
	CONSTRAINT WeatherStationBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT WeatheSCKey PRIMARY KEY (BaseElementId)
);


CREATE TABLE CentralLO (
	BaseElementId NUMBER (10) NOT NULL,
	CommissionDate NUMBER (19) NOT NULL,
	CONSTRAINT CentralLOBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT CentralLOKey PRIMARY KEY (BaseElementId)
);


CREATE TABLE AOSTiming (
	BaseElementId NUMBER (10) NOT NULL,
	CommissionDate NUMBER (19) NOT NULL,
	CONSTRAINT AOSTimingBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT AOSTimingKey PRIMARY KEY (BaseElementId)
);


CREATE TABLE HolographyTower (
	BaseElementId NUMBER (10) NOT NULL,
	CommissionDate NUMBER (19) NOT NULL,
	XPosition BINARY_DOUBLE NOT NULL,
	YPosition BINARY_DOUBLE NOT NULL,
	ZPosition BINARY_DOUBLE NOT NULL,
	CONSTRAINT HolographyTowerBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT HologrTKey PRIMARY KEY (BaseElementId)
);


CREATE TABLE AntennaToPad (
	AntennaToPadId NUMBER (10) NOT NULL,
	AntennaId NUMBER (10) NOT NULL,
	PadId NUMBER (10) NOT NULL,
	StartTime NUMBER (19) NOT NULL,
	EndTime NUMBER (19) NULL,
	Planned CHAR (1) NOT NULL,
	MountMetrologyAN0Coeff BINARY_DOUBLE NULL,
	MountMetrologyAW0Coeff BINARY_DOUBLE NULL,
	Locked CHAR (1) NULL,
	IncreaseVersion CHAR (1) NULL,
	CurrentVersion NUMBER (10) NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	CONSTRAINT AntennaToPadPlanned CHECK (Planned IN ('0', '1')),
	CONSTRAINT AntennaToPadLocked CHECK (Locked IN ('0', '1')),
	CONSTRAINT AntennaToPadIncreaV CHECK (IncreaseVersion IN ('0', '1')),
	CONSTRAINT AntennaToPadAltKey UNIQUE (AntennaId, PadId, StartTime),
	CONSTRAINT AntennaToPadAntennaId FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT AntennaToPadPadId FOREIGN KEY (PadId) REFERENCES Pad,
	CONSTRAINT AntennaToPadKey PRIMARY KEY (AntennaToPadId)
);

CREATE SEQUENCE AntennaToPad_seq;

CREATE TABLE WeatherStationToPad (
	WeatherStationId NUMBER (10) NOT NULL,
	PadId NUMBER (10) NOT NULL,
	StartTime NUMBER (19) NOT NULL,
	EndTime NUMBER (19) NULL,
	Planned CHAR (1) NOT NULL,
	CONSTRAINT WeatheSTPPlanned CHECK (Planned IN ('0', '1')),
	CONSTRAINT WSToPadWeatherStationId FOREIGN KEY (WeatherStationId) REFERENCES WeatherStationController,
	CONSTRAINT WSToPadPadId FOREIGN KEY (PadId) REFERENCES Pad,
	CONSTRAINT WeatheSTPKey PRIMARY KEY (WeatherStationId, PadId, StartTime)
);


CREATE TABLE HolographyTowerToPad (
	TowerToPadId NUMBER (10) NOT NULL,
	HolographyTowerId NUMBER (10) NOT NULL,
	PadId NUMBER (10) NOT NULL,
	Azimuth BINARY_DOUBLE NOT NULL,
	Elevation BINARY_DOUBLE NOT NULL,
	CONSTRAINT HologrTTPAltKey UNIQUE (HolographyTowerId, PadId),
	CONSTRAINT HoloTowerToPadHoloTower FOREIGN KEY (HolographyTowerId) REFERENCES HolographyTower,
	CONSTRAINT HoloTowerToPadPad FOREIGN KEY (PadId) REFERENCES Pad,
	CONSTRAINT HologrTTPKey PRIMARY KEY (TowerToPadId)
);

CREATE SEQUENCE HologrTTP_seq;

CREATE TABLE FEDelay (
	FEDelayId NUMBER (10) NOT NULL,
	AntennaId NUMBER (10) NOT NULL,
	ReceiverBand VARCHAR2 (128) NOT NULL,
	Polarization VARCHAR2 (128) NOT NULL,
	SideBand VARCHAR2 (128) NOT NULL,
	Delay BINARY_DOUBLE NOT NULL,
	DelayError BINARY_DOUBLE NULL,
	ObservationTime NUMBER (19) NULL,
	ExecBlockUID VARCHAR (100) NULL,
	ScanNumber NUMBER (10) NULL,
	CONSTRAINT FEDelayAltKey UNIQUE (AntennaId, ReceiverBand, Polarization, SideBand),
	CONSTRAINT AntennaFEDelay FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT FEDelRecBandEnum CHECK (ReceiverBand IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT FEDelPolEnum CHECK (Polarization IN ('X', 'Y')),
	CONSTRAINT FEDelSideBandEnum CHECK (SideBand IN ('LSB', 'USB')),
	CONSTRAINT FEDelayKey PRIMARY KEY (FEDelayId)
);

CREATE SEQUENCE FEDelay_seq;

CREATE TABLE IFDelay (
	IFDelayId NUMBER (10) NOT NULL,
	AntennaId NUMBER (10) NOT NULL,
	BaseBand VARCHAR2 (128) NOT NULL,
	Polarization VARCHAR2 (128) NOT NULL,
	IFSwitch VARCHAR2 (128) NOT NULL,
	Delay BINARY_DOUBLE NOT NULL,
	DelayError BINARY_DOUBLE NULL,
	ObservationTime NUMBER (19) NULL,
	ExecBlockUID VARCHAR (100) NULL,
	ScanNumber NUMBER (10) NULL,
	CONSTRAINT IFDelayAltKey UNIQUE (AntennaId, BaseBand, Polarization, IFSwitch),
	CONSTRAINT AntennaIFDelay FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT IFDelBaseBandEnum CHECK (BaseBand IN ('BB_1', 'BB_2', 'BB_3', 'BB_4')),
	CONSTRAINT IFDelIFSwitchEnum CHECK (IFSwitch IN ('USB_HIGH', 'USB_LOW', 'LSB_HIGH', 'LSB_LOW')),
	CONSTRAINT IFDelPolEnum CHECK (Polarization IN ('X', 'Y')),
	CONSTRAINT IFDelayKey PRIMARY KEY (IFDelayId)
);

CREATE SEQUENCE IFDelay_seq;

CREATE TABLE LODelay (
	LODelayId NUMBER (10) NOT NULL,
	AntennaId NUMBER (10) NOT NULL,
	BaseBand VARCHAR2 (128) NOT NULL,
	Delay BINARY_DOUBLE NOT NULL,
	DelayError BINARY_DOUBLE NULL,
	ObservationTime NUMBER (19) NULL,
	ExecBlockUID VARCHAR (100) NULL,
	ScanNumber NUMBER (10) NULL,
	CONSTRAINT LODelayAltKey UNIQUE (AntennaId, BaseBand),
	CONSTRAINT AntennaLODelay FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT LODelBaseBandEnum CHECK (BaseBand IN ('BB_1', 'BB_2', 'BB_3', 'BB_4')),
	CONSTRAINT LODelayKey PRIMARY KEY (LODelayId)
);

CREATE SEQUENCE LODelay_seq;

CREATE TABLE XPDelay (
	XPDelayId NUMBER (10) NOT NULL,
	ConfigurationId NUMBER (10) NOT NULL,
	ReceiverBand VARCHAR2 (128) NOT NULL,
	SideBand VARCHAR2 (128) NOT NULL,
	BaseBand VARCHAR2 (128) NOT NULL,
	Delay BINARY_DOUBLE NOT NULL,
	DelayError BINARY_DOUBLE NULL,
	ObservationTime NUMBER (19) NULL,
	ExecBlockUID VARCHAR (100) NULL,
	ScanNumber NUMBER (10) NULL,
	CONSTRAINT XPDelayAltKey UNIQUE (ConfigurationId, ReceiverBand, SideBand, BaseBand),
	CONSTRAINT HWConfigXPDelay FOREIGN KEY (ConfigurationId) REFERENCES HWConfiguration,
	CONSTRAINT XPDelBaseBandEnum CHECK (BaseBand IN ('BB_1', 'BB_2', 'BB_3', 'BB_4')),
	CONSTRAINT XPDelSideBandEnum CHECK (SideBand IN ('LSB', 'USB')),
	CONSTRAINT XPDelFreqBandEnum CHECK (ReceiverBand IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT XPDelayKey PRIMARY KEY (XPDelayId)
);

CREATE SEQUENCE XPDelay_seq;

CREATE TABLE CorrQuadrant (
	BaseElementId NUMBER (10) NOT NULL,
	BaseBand VARCHAR2 (128) NOT NULL,
	Quadrant NUMBER (3) NOT NULL,
	ChannelNumber NUMBER (3) NOT NULL,
	CONSTRAINT CorrQuadBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT CorrQuadNumber CHECK (Quadrant IN (0, 1, 2, 3)),
	CONSTRAINT CorrQuadBBEnum CHECK (BaseBand IN ('BB_1', 'BB_2', 'BB_3', 'BB_4')),
	CONSTRAINT CorrQuadrantKey PRIMARY KEY (BaseElementId)
);


CREATE TABLE CorrQuadrantRack (
	BaseElementId NUMBER (10) NOT NULL,
	CorrQuadrantId NUMBER (10) NOT NULL,
	RackName VARCHAR2 (128) NOT NULL,
	RackType VARCHAR2 (10) NOT NULL,
	CONSTRAINT CorrQuadRackBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT CorrQuad FOREIGN KEY (CorrQuadrantId) REFERENCES CorrQuadrant,
	CONSTRAINT CorrRackType CHECK (RackType IN ('Station', 'Correlator')),
	CONSTRAINT CorrQuRKey PRIMARY KEY (BaseElementId)
);


CREATE TABLE CorrStationBin (
	BaseElementId NUMBER (10) NOT NULL,
	CorrQuadrantRackId NUMBER (10) NOT NULL,
	StationBinName VARCHAR2 (128) NOT NULL,
	CONSTRAINT CorrStBinBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT CorrStBinRack FOREIGN KEY (CorrQuadrantRackId) REFERENCES CorrQuadrantRack,
	CONSTRAINT CorrStBKey PRIMARY KEY (BaseElementId)
);


CREATE TABLE CorrelatorBin (
	BaseElementId NUMBER (10) NOT NULL,
	CorrQuadrantRackId NUMBER (10) NOT NULL,
	CorrelatorBinName VARCHAR2 (128) NOT NULL,
	CONSTRAINT CorrBinBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT CorrBinRack FOREIGN KEY (CorrQuadrantRackId) REFERENCES CorrQuadrantRack,
	CONSTRAINT CorrelBKey PRIMARY KEY (BaseElementId)
);


CREATE TABLE Startup (
	StartupId NUMBER (10) NOT NULL,
	ConfigurationId NUMBER (10) NOT NULL,
	StartupName VARCHAR2 (256) NOT NULL,
	CONSTRAINT StartupAltKey UNIQUE (StartupName, ConfigurationId),
	CONSTRAINT StartupConfig FOREIGN KEY (ConfigurationId) REFERENCES HWConfiguration,
	CONSTRAINT StartupKey PRIMARY KEY (StartupId)
);

CREATE SEQUENCE Startup_seq;

CREATE TABLE BaseElementStartup (
	BaseElementStartupId NUMBER (10) NOT NULL,
	BaseElementId NUMBER (10) NULL,
	StartupId NUMBER (10) NULL,
	BaseElementType VARCHAR (24) NOT NULL,
	Parent NUMBER (10) NULL,
	IsGeneric VARCHAR (5) NOT NULL,
	Simulated CHAR (1) NOT NULL,
	CONSTRAINT BaseElSSimulated CHECK (Simulated IN ('0', '1')),
	CONSTRAINT BaseElSAltKey UNIQUE (StartupId, BaseElementId, Parent, BaseElementType),
	CONSTRAINT BEStartupId FOREIGN KEY (StartupId) REFERENCES Startup,
	CONSTRAINT BEStartupIdBE FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT BEStartupParent FOREIGN KEY (Parent) REFERENCES BaseElementStartup,
	CONSTRAINT BEStartupBEType CHECK (BaseElementType IN ('Antenna', 'Pad', 'FrontEnd', 'WeatherStationController', 'CentralLO', 'AOSTiming', 'HolographyTower', 'Array', 'PhotonicReference1', 'PhotonicReference2', 'PhotonicReference3', 'PhotonicReference4', 'PhotonicReference5', 'PhotonicReference6')),
	CONSTRAINT BaseElSKey PRIMARY KEY (BaseElementStartupId)
);

CREATE SEQUENCE BaseElS_seq;

CREATE TABLE AssemblyStartup (
	AssemblyStartupId NUMBER (10) NOT NULL,
	RoleName VARCHAR2 (128) NOT NULL,
	BaseElementStartupId NUMBER (10) NOT NULL,
	Simulated CHAR (1) NOT NULL,
	CONSTRAINT AssembSSimulated CHECK (Simulated IN ('0', '1')),
	CONSTRAINT AssembSAltKey UNIQUE (BaseElementStartupId, RoleName),
	CONSTRAINT AssemblyStartupRole FOREIGN KEY (RoleName) REFERENCES AssemblyRole,
	CONSTRAINT AssemblyStartupBEStartup FOREIGN KEY (BaseElementStartupId) REFERENCES BaseElementStartup,
	CONSTRAINT AssembSKey PRIMARY KEY (AssemblyStartupId)
);

CREATE SEQUENCE AssembS_seq;

CREATE TABLE DefaultCanAddress (
	ComponentId NUMBER (10) NOT NULL,
	IsEthernet CHAR (1) NOT NULL,
	NodeAddress VARCHAR (16) NULL,
	ChannelNumber NUMBER (3) NULL,
	Hostname VARCHAR (80) NULL,
	Port NUMBER (10) NULL,
	MacAddress VARCHAR (80) NULL,
	Retries NUMBER (5) NULL,
	TimeOutRxTx BINARY_DOUBLE NULL,
	LingerTime NUMBER (10) NULL,
	CONSTRAINT DefaulCAIsEthernet CHECK (IsEthernet IN ('0', '1')),
	CONSTRAINT DefCanAddComp FOREIGN KEY (ComponentId) REFERENCES Component,
	CONSTRAINT DefaulCAKey PRIMARY KEY (ComponentId)
);


CREATE TABLE PointingModel (
	PointingModelId NUMBER (10) NOT NULL,
	AntennaId NUMBER (10) NOT NULL,
	ObservationTime NUMBER (19) NULL,
	ExecBlockUID VARCHAR (100) NULL,
	ScanNumber NUMBER (10) NULL,
	SoftwareVersion VARCHAR (100) NULL,
	Comments VARCHAR2 (1024) NULL,
	SourceNumber NUMBER (10) NULL,
	MetrologyMode VARCHAR (100) NULL,
	MetrologyFlag VARCHAR (100) NULL,
	SourceDensity BINARY_DOUBLE NULL,
	PointingRMS BINARY_DOUBLE NULL,
	Locked CHAR (1) NULL,
	IncreaseVersion CHAR (1) NULL,
	CurrentVersion NUMBER (10) NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	CONSTRAINT PointiMLocked CHECK (Locked IN ('0', '1')),
	CONSTRAINT PointiMIncreaV CHECK (IncreaseVersion IN ('0', '1')),
	CONSTRAINT PointiMAltKey UNIQUE (AntennaId),
	CONSTRAINT AntennaPMAntenna FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT PointiMKey PRIMARY KEY (PointingModelId)
);

CREATE SEQUENCE PointiM_seq;

CREATE TABLE PointingModelCoeff (
	PointingModelCoeffId NUMBER (10) NOT NULL,
	PointingModelId NUMBER (10) NOT NULL,
	CoeffName VARCHAR2 (128) NOT NULL,
	CoeffValue BINARY_DOUBLE NOT NULL,
	CONSTRAINT PointiMCAltKey UNIQUE (PointingModelId, CoeffName),
	CONSTRAINT AntPMTermPointingModelId FOREIGN KEY (PointingModelId) REFERENCES PointingModel,
	CONSTRAINT PointiMCKey PRIMARY KEY (PointingModelCoeffId)
);

CREATE SEQUENCE PointiMC_seq;

CREATE TABLE PointingModelCoeffOffset (
	PointingModelCoeffId NUMBER (10) NOT NULL,
	ReceiverBand VARCHAR2 (128) NOT NULL,
	Offset BINARY_DOUBLE NOT NULL,
	CONSTRAINT AntPMCoeffOffToCoeff FOREIGN KEY (PointingModelCoeffId) REFERENCES PointingModelCoeff,
	CONSTRAINT AntennaPMCoeffOffBand CHECK (ReceiverBand IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT PointiMCOKey PRIMARY KEY (PointingModelCoeffId, ReceiverBand)
);


CREATE TABLE FocusModel (
	FocusModelId NUMBER (10) NOT NULL,
	AntennaId NUMBER (10) NOT NULL,
	ObservationTime NUMBER (19) NULL,
	ExecBlockUID VARCHAR (100) NULL,
	ScanNumber NUMBER (10) NULL,
	SoftwareVersion VARCHAR (100) NULL,
	Comments VARCHAR2 (1024) NULL,
	SourceDensity BINARY_DOUBLE NULL,
	Locked CHAR (1) NULL,
	IncreaseVersion CHAR (1) NULL,
	CurrentVersion NUMBER (10) NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	CONSTRAINT FocusModelLocked CHECK (Locked IN ('0', '1')),
	CONSTRAINT FocusModelIncreaV CHECK (IncreaseVersion IN ('0', '1')),
	CONSTRAINT FocusModelAltKey UNIQUE (AntennaId),
	CONSTRAINT AntennaFMAntenna FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT FocusModelKey PRIMARY KEY (FocusModelId)
);

CREATE SEQUENCE FocusModel_seq;

CREATE TABLE FocusModelCoeff (
	FocusModelCoeffId NUMBER (10) NOT NULL,
	FocusModelId NUMBER (10) NOT NULL,
	CoeffName VARCHAR2 (128) NOT NULL,
	CoeffValue BINARY_DOUBLE NOT NULL,
	CONSTRAINT FocusMCAltKey UNIQUE (FocusModelId, CoeffName),
	CONSTRAINT AntFMTermFocusModelId FOREIGN KEY (FocusModelId) REFERENCES FocusModel,
	CONSTRAINT FocusMCKey PRIMARY KEY (FocusModelCoeffId)
);

CREATE SEQUENCE FocusMC_seq;

CREATE TABLE FocusModelCoeffOffset (
	FocusModelCoeffId NUMBER (10) NOT NULL,
	ReceiverBand VARCHAR2 (128) NOT NULL,
	Offset BINARY_DOUBLE NOT NULL,
	CONSTRAINT AntFMCoeffOffToCoeff FOREIGN KEY (FocusModelCoeffId) REFERENCES FocusModelCoeff,
	CONSTRAINT AntennaFMCoeffOffBand CHECK (ReceiverBand IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT FocusMCOKey PRIMARY KEY (FocusModelCoeffId, ReceiverBand)
);


CREATE TABLE DefaultComponent (
	DefaultComponentId NUMBER (10) NOT NULL,
	ComponentTypeId NUMBER (10) NOT NULL,
	AssemblyTypeName VARCHAR2 (256) NOT NULL,
	`ImplLang` VARCHAR2 (6) NOT NULL,
	RealTime CHAR (1) NOT NULL,
	Code VARCHAR2 (256) NOT NULL,
	Path VARCHAR2 (256) NOT NULL,
	IsAutostart CHAR (1) NOT NULL,
	IsDefault CHAR (1) NOT NULL,
	IsStandaloneDefined CHAR (1) NULL,
	KeepAliveTime NUMBER (10) NOT NULL,
	MinLogLevel NUMBER (3) DEFAULT -1,
	MinLogLevelLocal NUMBER (3) DEFAULT -1,
	XMLDoc XMLTYPE NULL,
	CONSTRAINT DefaulCRealTime CHECK (RealTime IN ('0', '1')),
	CONSTRAINT DefaulCIsAutostart CHECK (IsAutostart IN ('0', '1')),
	CONSTRAINT DefaulCIsDefault CHECK (IsDefault IN ('0', '1')),
	CONSTRAINT DefaulCIsStanD CHECK (IsStandaloneDefined IN ('0', '1')),
	CONSTRAINT DefaultComponentTypeId FOREIGN KEY (ComponentTypeId) REFERENCES ComponentType,
	CONSTRAINT DefaultComponentAssemblyId FOREIGN KEY (AssemblyTypeName) REFERENCES AssemblyType,
	CONSTRAINT `DefaultComponentImplLang` CHECK (`ImplLang` IN ('java', 'cpp', 'py')),
	CONSTRAINT DefaulCKey PRIMARY KEY (DefaultComponentId)
) XMLTYPE COLUMN XMLDoc STORE AS CLOB;


CREATE TABLE DefaultBaciProperty (
	DefaultBaciPropId NUMBER (10) NOT NULL,
	DefaultComponentId NUMBER (10) NOT NULL,
	PropertyName VARCHAR2 (128) NOT NULL,
	description VARCHAR2 (1024) NOT NULL,
	format VARCHAR2 (16) NOT NULL,
	units VARCHAR2 (24) NOT NULL,
	resolution VARCHAR2 (10) NOT NULL,
	archive_priority NUMBER (10) NOT NULL,
	archive_min_int BINARY_DOUBLE NOT NULL,
	archive_max_int BINARY_DOUBLE NOT NULL,
	archive_mechanism VARCHAR2 (24) NOT NULL,
	archive_suppress CHAR (1) NOT NULL,
	default_timer_trig BINARY_DOUBLE NOT NULL,
	min_timer_trig BINARY_DOUBLE NOT NULL,
	initialize_devio CHAR (1) NOT NULL,
	min_delta_trig BINARY_DOUBLE NULL,
	default_value VARCHAR2 (1024) NOT NULL,
	graph_min BINARY_DOUBLE NULL,
	graph_max BINARY_DOUBLE NULL,
	min_step BINARY_DOUBLE NULL,
	archive_delta BINARY_DOUBLE NOT NULL,
	archive_delta_percent BINARY_DOUBLE NULL,
	alarm_high_on BINARY_DOUBLE NULL,
	alarm_low_on BINARY_DOUBLE NULL,
	alarm_high_off BINARY_DOUBLE NULL,
	alarm_low_off BINARY_DOUBLE NULL,
	alarm_timer_trig BINARY_DOUBLE NULL,
	min_value BINARY_DOUBLE NULL,
	max_value BINARY_DOUBLE NULL,
	bitDescription VARCHAR2 (1024) NULL,
	whenSet VARCHAR2 (1024) NULL,
	whenCleared VARCHAR2 (1024) NULL,
	statesDescription VARCHAR2 (1024) NULL,
	condition VARCHAR2 (1024) NULL,
	alarm_on VARCHAR2 (1024) NULL,
	alarm_off VARCHAR2 (1024) NULL,
	alarm_fault_family VARCHAR2 (1024) NULL,
	alarm_fault_member VARCHAR2 (1024) NULL,
	alarm_level NUMBER (10) NULL,
	Data VARCHAR2 (1024) NULL,
	CONSTRAINT DefaulBParchiv CHECK (archive_suppress IN ('0', '1')),
	CONSTRAINT DefaulBPinitia CHECK (initialize_devio IN ('0', '1')),
	CONSTRAINT DefBACIDefaultComponentTypeId FOREIGN KEY (DefaultComponentId) REFERENCES DefaultComponent,
	CONSTRAINT DefaulBPKey PRIMARY KEY (DefaultBaciPropId)
);


CREATE TABLE DefaultMonitorPoint (
	DefaultMonitorPointId NUMBER (10) NOT NULL,
	DefaultBACIPropertyId NUMBER (10) NOT NULL,
	MonitorPointName VARCHAR2 (128) NOT NULL,
	Indice NUMBER (10) NOT NULL,
	DataType VARCHAR2 (16) NOT NULL,
	RCA VARCHAR2 (16) NOT NULL,
	TeRelated CHAR (1) NOT NULL,
	RawDataType VARCHAR2 (24) NOT NULL,
	WorldDataType VARCHAR2 (24) NOT NULL,
	Units VARCHAR2 (24) NULL,
	Scale BINARY_DOUBLE NULL,
	Offset BINARY_DOUBLE NULL,
	MinRange VARCHAR2 (24) NULL,
	MaxRange VARCHAR2 (24) NULL,
	Description VARCHAR2 (1024) NOT NULL,
	CONSTRAINT DefaulMPTeRelated CHECK (TeRelated IN ('0', '1')),
	CONSTRAINT DefaulPntId FOREIGN KEY (DefaultBACIPropertyId) REFERENCES DefaultBaciProperty,
	CONSTRAINT DefaulMPKey PRIMARY KEY (DefaultMonitorPointId)
);


CREATE TABLE MonitorPoint (
	MonitorPointId NUMBER (10) NOT NULL,
	BACIPropertyId NUMBER (10) NOT NULL,
	MonitorPointName VARCHAR2 (128) NOT NULL,
	AssemblyId NUMBER (10) NOT NULL,
	Indice NUMBER (10) NOT NULL,
	DataType VARCHAR2 (16) NOT NULL,
	RCA VARCHAR2 (16) NOT NULL,
	TeRelated CHAR (1) NOT NULL,
	RawDataType VARCHAR2 (24) NOT NULL,
	WorldDataType VARCHAR2 (24) NOT NULL,
	Units VARCHAR2 (24) NULL,
	Scale BINARY_DOUBLE NULL,
	Offset BINARY_DOUBLE NULL,
	MinRange VARCHAR2 (24) NULL,
	MaxRange VARCHAR2 (24) NULL,
	Description VARCHAR2 (1024) NOT NULL,
	CONSTRAINT MonitorPointTeRelated CHECK (TeRelated IN ('0', '1')),
	CONSTRAINT MonitorPointAltKey UNIQUE (BACIPropertyId, AssemblyId, Indice),
	CONSTRAINT MonitorPointAssemblyId FOREIGN KEY (AssemblyId) REFERENCES Assembly,
	CONSTRAINT MonitorPointBACIPropertyId FOREIGN KEY (BACIPropertyId) REFERENCES BACIProperty,
	CONSTRAINT MonitorPointDatatype CHECK (DataType IN ('float', 'double', 'boolean', 'string', 'integer', 'enum', 'clob')),
	CONSTRAINT MonitorPointKey PRIMARY KEY (MonitorPointId)
);

CREATE SEQUENCE MonitorPoint_seq;

CREATE TABLE MonitorData (
	MonitorPointId NUMBER (10) NOT NULL,
	StartTime NUMBER (19) NOT NULL,
	EndTime NUMBER (19) NOT NULL,
	MonitorTS TIMESTAMP (6) NOT NULL,
	SampleSize NUMBER (10) NOT NULL,
	MonitorClob CLOB NOT NULL,
	MinStat BINARY_DOUBLE NULL,
	MaxStat BINARY_DOUBLE NULL,
	MeanStat BINARY_DOUBLE NULL,
	StdDevStat BINARY_DOUBLE NULL,
	CONSTRAINT MonitorDataMonitorPointId FOREIGN KEY (MonitorPointId) REFERENCES MonitorPoint,
	CONSTRAINT MonitorDataKey PRIMARY KEY (MonitorPointId, MonitorTS)
);


CREATE TABLE BaseElementOnline (
	BaseElementOnlineId NUMBER (10) NOT NULL,
	BaseElementId NUMBER (10) NOT NULL,
	ConfigurationId NUMBER (10) NOT NULL,
	StartTime NUMBER (19) NOT NULL,
	EndTime NUMBER (19) NULL,
	NormalTermination CHAR (1) NOT NULL,
	CONSTRAINT BaseElONormalT CHECK (NormalTermination IN ('0', '1')),
	CONSTRAINT BaseElOAltKey UNIQUE (BaseElementId, ConfigurationId, StartTime),
	CONSTRAINT BEOnlineId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT BEOnlineConfig FOREIGN KEY (ConfigurationId) REFERENCES HWConfiguration,
	CONSTRAINT BaseElOKey PRIMARY KEY (BaseElementOnlineId)
);

CREATE SEQUENCE BaseElO_seq;

CREATE TABLE AssemblyOnline (
	AssemblyOnlineId NUMBER (10) NOT NULL,
	AssemblyId NUMBER (10) NOT NULL,
	BaseElementOnlineId NUMBER (10) NOT NULL,
	RoleName VARCHAR2 (128) NOT NULL,
	StartTime NUMBER (19) NOT NULL,
	EndTime NUMBER (19) NULL,
	CONSTRAINT AssembOAltKey UNIQUE (AssemblyId, BaseElementOnlineId),
	CONSTRAINT BEAssemblyListId FOREIGN KEY (BaseElementOnlineId) REFERENCES BaseElementOnline,
	CONSTRAINT BEAssemblyListAssemblyId FOREIGN KEY (AssemblyId) REFERENCES Assembly,
	CONSTRAINT AssembOKey PRIMARY KEY (AssemblyOnlineId)
);

CREATE SEQUENCE AssembO_seq;

CREATE TABLE Array (
	ArrayId NUMBER (10) NOT NULL,
	BaseElementId NUMBER (10) NOT NULL,
	Type VARCHAR2 (9) NOT NULL,
	UserId VARCHAR2 (256) NULL,
	StartTime NUMBER (19) NOT NULL,
	EndTime NUMBER (19) NULL,
	NormalTermination CHAR (1) NOT NULL,
	CONSTRAINT ArrayNormalT CHECK (NormalTermination IN ('0', '1')),
	CONSTRAINT ArrayAltKey UNIQUE (StartTime, BaseElementId),
	CONSTRAINT ArrayBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT ArrayType CHECK (Type IN ('automatic', 'manual')),
	CONSTRAINT ArrayKey PRIMARY KEY (ArrayId)
);

CREATE SEQUENCE Array_seq;

CREATE TABLE AntennaToArray (
	AntennaId NUMBER (10) NOT NULL,
	ArrayId NUMBER (10) NOT NULL,
	CONSTRAINT AntennaToArrayAntennaId FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT AntennaToArrayArrayid FOREIGN KEY (ArrayId) REFERENCES Array,
	CONSTRAINT AntennTAKey PRIMARY KEY (AntennaId, ArrayId)
);


CREATE TABLE SBExecution (
	ArrayId NUMBER (10) NOT NULL,
	SbUID VARCHAR2 (256) NOT NULL,
	StartTime NUMBER (19) NOT NULL,
	EndTime NUMBER (19) NULL,
	NormalTermination CHAR (1) NOT NULL,
	CONSTRAINT SBExecutionNormalT CHECK (NormalTermination IN ('0', '1')),
	CONSTRAINT SBExecutionArrayId FOREIGN KEY (ArrayId) REFERENCES Array,
	CONSTRAINT SBExecutionKey PRIMARY KEY (ArrayId, SbUID, StartTime)
);


CREATE TABLE AntennaToFrontEnd (
	AntennaToFrontEndId NUMBER (10) NOT NULL,
	AntennaId NUMBER (10) NOT NULL,
	FrontEndId NUMBER (10) NOT NULL,
	StartTime NUMBER (19) NOT NULL,
	EndTime NUMBER (19) NULL,
	CONSTRAINT AntennTFEAltKey UNIQUE (AntennaId, FrontEndId, StartTime),
	CONSTRAINT AntennaToFEAntennaId FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT AntennaToFEFrontEndId FOREIGN KEY (FrontEndId) REFERENCES FrontEnd,
	CONSTRAINT AntennTFEKey PRIMARY KEY (AntennaToFrontEndId)
);

CREATE SEQUENCE AntennTFE_seq;

CREATE TABLE BL_VersionInfo (
	TableName VARCHAR2 (128) NOT NULL,
	SwConfigurationId NUMBER (10) NOT NULL,
	EntityId NUMBER (10) NOT NULL,
	Locked CHAR (1) NOT NULL,
	IncreaseVersion CHAR (1) NOT NULL,
	CurrentVersion NUMBER (10) NOT NULL,
	Who VARCHAR2 (128) NOT NULL,
	ChangeDesc VARCHAR2 (1024) NOT NULL,
	CONSTRAINT BL_VerILocked CHECK (Locked IN ('0', '1')),
	CONSTRAINT BL_VerIIncreaV CHECK (IncreaseVersion IN ('0', '1')),
	CONSTRAINT VersionInfoSwCnfId FOREIGN KEY (SwConfigurationId) REFERENCES Configuration,
	CONSTRAINT BL_VerIKey PRIMARY KEY (TableName, SwConfigurationId, EntityId)
);


CREATE TABLE BL_PointingModelCoeff (
	Version NUMBER (10) NOT NULL,
	ModTime NUMBER (19) NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	PointingModelId NUMBER (10) NOT NULL,
	CoeffName VARCHAR2 (128) NOT NULL,
	CoeffValue BINARY_DOUBLE NOT NULL,
	CONSTRAINT BL_PointingModelCoeffOp CHECK (Operation IN ('I', 'U', 'D')),
	CONSTRAINT BL_PoiMCKey PRIMARY KEY (Version, ModTime, Operation, PointingModelId, CoeffName)
);


CREATE TABLE BL_PointingModelCoeffOffset (
	Version NUMBER (10) NOT NULL,
	ModTime NUMBER (19) NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	PointingModelId NUMBER (10) NOT NULL,
	CoeffName VARCHAR2 (128) NOT NULL,
	ReceiverBand VARCHAR2 (128) NOT NULL,
	Offset BINARY_DOUBLE NOT NULL,
	CONSTRAINT BL_AntennaPMCoeffOffOp CHECK (Operation IN ('I', 'U', 'D')),
	CONSTRAINT BL_AntennaPMCoeffOffBand CHECK (ReceiverBand IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT BL_PoiMCOKey PRIMARY KEY (Version, ModTime, Operation, PointingModelId, CoeffName, ReceiverBand)
);


CREATE TABLE BL_FocusModelCoeff (
	Version NUMBER (10) NOT NULL,
	ModTime NUMBER (19) NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	FocusModelId NUMBER (10) NOT NULL,
	CoeffName VARCHAR2 (128) NOT NULL,
	CoeffValue BINARY_DOUBLE NOT NULL,
	CONSTRAINT BL_FocusModelCoeffOp CHECK (Operation IN ('I', 'U', 'D')),
	CONSTRAINT BL_FocMCKey PRIMARY KEY (Version, ModTime, Operation, FocusModelId, CoeffName)
);


CREATE TABLE BL_FocusModelCoeffOffset (
	Version NUMBER (10) NOT NULL,
	ModTime NUMBER (19) NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	FocusModelId NUMBER (10) NOT NULL,
	CoeffName VARCHAR2 (128) NOT NULL,
	ReceiverBand VARCHAR2 (128) NOT NULL,
	Offset BINARY_DOUBLE NOT NULL,
	CONSTRAINT BL_AntennaFMCoeffOffOp CHECK (Operation IN ('I', 'U', 'D')),
	CONSTRAINT BL_AntennaFMCoeffOffBand CHECK (ReceiverBand IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT BL_FocMCOKey PRIMARY KEY (Version, ModTime, Operation, FocusModelId, CoeffName, ReceiverBand)
);


CREATE TABLE BL_FEDelay (
	Version NUMBER (10) NOT NULL,
	ModTime NUMBER (19) NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	FEDelayId NUMBER (10) NOT NULL,
	AntennaId NUMBER (10) NOT NULL,
	ReceiverBand VARCHAR2 (128) NOT NULL,
	Polarization VARCHAR2 (128) NOT NULL,
	SideBand VARCHAR2 (128) NOT NULL,
	Delay BINARY_DOUBLE NOT NULL,
	CONSTRAINT BL_FEDelayOp CHECK (Operation IN ('I', 'U', 'D')),
	CONSTRAINT BL_FEDelayKey PRIMARY KEY (Version, ModTime, Operation, FEDelayId)
);


CREATE TABLE BL_IFDelay (
	Version NUMBER (10) NOT NULL,
	ModTime NUMBER (19) NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	IFDelayId NUMBER (10) NOT NULL,
	AntennaId NUMBER (10) NOT NULL,
	BaseBand VARCHAR2 (128) NOT NULL,
	Polarization VARCHAR2 (128) NOT NULL,
	IFSwitch VARCHAR2 (128) NOT NULL,
	Delay BINARY_DOUBLE NOT NULL,
	CONSTRAINT BL_IFDelayOp CHECK (Operation IN ('I', 'U', 'D')),
	CONSTRAINT BL_IFDelayKey PRIMARY KEY (Version, ModTime, Operation, IFDelayId)
);


CREATE TABLE BL_LODelay (
	Version NUMBER (10) NOT NULL,
	ModTime NUMBER (19) NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	LODelayId NUMBER (10) NOT NULL,
	AntennaId NUMBER (10) NOT NULL,
	BaseBand VARCHAR2 (128) NOT NULL,
	Delay BINARY_DOUBLE NOT NULL,
	CONSTRAINT BL_LODelayOp CHECK (Operation IN ('I', 'U', 'D')),
	CONSTRAINT BL_LODelayKey PRIMARY KEY (Version, ModTime, Operation, LODelayId)
);


CREATE TABLE BL_XPDelay (
	Version NUMBER (10) NOT NULL,
	ModTime NUMBER (19) NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	XPDelayId NUMBER (10) NOT NULL,
	ConfigurationId NUMBER (10) NOT NULL,
	ReceiverBand VARCHAR2 (128) NOT NULL,
	SideBand VARCHAR2 (128) NOT NULL,
	BaseBand VARCHAR2 (128) NOT NULL,
	Delay BINARY_DOUBLE NOT NULL,
	CONSTRAINT BL_XPDelayOp CHECK (Operation IN ('I', 'U', 'D')),
	CONSTRAINT BL_XPDelayKey PRIMARY KEY (Version, ModTime, Operation, XPDelayId)
);


CREATE TABLE BL_AntennaDelay (
	Version NUMBER (10) NOT NULL,
	ModTime NUMBER (19) NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	BaseElementId NUMBER (10) NOT NULL,
	Delay BINARY_DOUBLE NOT NULL,
	CONSTRAINT BL_AntDKey PRIMARY KEY (Version, ModTime, Operation, BaseElementId)
);


CREATE TABLE BL_Antenna (
	Version NUMBER (10) NOT NULL,
	ModTime NUMBER (19) NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	BaseElementId NUMBER (10) NOT NULL,
	AntennaType VARCHAR2 (4) NOT NULL,
	DishDiameter BINARY_DOUBLE NOT NULL,
	CommissionDate NUMBER (19) NOT NULL,
	XPosition BINARY_DOUBLE NOT NULL,
	YPosition BINARY_DOUBLE NOT NULL,
	ZPosition BINARY_DOUBLE NOT NULL,
	XOffset BINARY_DOUBLE NOT NULL,
	YOffset BINARY_DOUBLE NOT NULL,
	ZOffset BINARY_DOUBLE NOT NULL,
	LOOffsettingIndex NUMBER (10) NOT NULL,
	WalshSeq NUMBER (10) NOT NULL,
	CaiBaseline NUMBER (10) NULL,
	CaiAca NUMBER (10) NULL,
	CONSTRAINT BL_AntennaKey PRIMARY KEY (Version, ModTime, Operation, BaseElementId)
);


CREATE TABLE BL_Pad (
	Version NUMBER (10) NOT NULL,
	ModTime NUMBER (19) NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	BaseElementId NUMBER (10) NOT NULL,
	CommissionDate NUMBER (19) NOT NULL,
	XPosition BINARY_DOUBLE NOT NULL,
	YPosition BINARY_DOUBLE NOT NULL,
	ZPosition BINARY_DOUBLE NOT NULL,
	Delay BINARY_DOUBLE NOT NULL,
	CONSTRAINT BL_PadKey PRIMARY KEY (Version, ModTime, Operation, BaseElementId)
);


CREATE TABLE BL_AntennaToPad (
	Version NUMBER (10) NOT NULL,
	ModTime NUMBER (19) NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	AntennaToPadId NUMBER (10) NOT NULL,
	MountMetrologyAN0Coeff BINARY_DOUBLE NULL,
	MountMetrologyAW0Coeff BINARY_DOUBLE NULL,
	CONSTRAINT BL_AntTPKey PRIMARY KEY (Version, ModTime, Operation, AntennaToPadId)
);


CREATE TABLE BL_AcaCorrDelays (
	Version NUMBER (10) NOT NULL,
	ModTime NUMBER (19) NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR2 (128) NULL,
	ChangeDesc VARCHAR2 (1024) NULL,
	AntennaId NUMBER (10) NOT NULL,
	BbOneDelay BINARY_DOUBLE NOT NULL,
	BbTwoDelay BINARY_DOUBLE NOT NULL,
	BbThreeDelay BINARY_DOUBLE NOT NULL,
	BbFourDelay BINARY_DOUBLE NOT NULL,
	CONSTRAINT BL_AcaCDKey PRIMARY KEY (Version, ModTime, Operation, AntennaId)
);


CREATE TABLE AntennaEfficiency (
	AntennaEfficiencyId NUMBER (10) NOT NULL,
	AntennaId NUMBER (10) NOT NULL,
	ObservationTime NUMBER (19) NOT NULL,
	ExecBlockUID VARCHAR (100) NOT NULL,
	ScanNumber NUMBER (10) NOT NULL,
	ThetaMinorPolX BINARY_DOUBLE NOT NULL,
	ThetaMinorPolY BINARY_DOUBLE NOT NULL,
	ThetaMajorPolX BINARY_DOUBLE NOT NULL,
	ThetaMajorPolY BINARY_DOUBLE NOT NULL,
	PositionAngleBeamPolX BINARY_DOUBLE NOT NULL,
	PositionAngleBeamPolY BINARY_DOUBLE NOT NULL,
	SourceName VARCHAR (100) NOT NULL,
	SourceSize BINARY_DOUBLE NOT NULL,
	Frequency BINARY_DOUBLE NOT NULL,
	ApertureEff BINARY_DOUBLE NOT NULL,
	ApertureEffError BINARY_DOUBLE NOT NULL,
	ForwardEff BINARY_DOUBLE NOT NULL,
	ForwardEffError BINARY_DOUBLE NOT NULL,
	CONSTRAINT AntEffToAntenna FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT AntennEKey PRIMARY KEY (AntennaEfficiencyId)
);

CREATE SEQUENCE AntennE_seq;

CREATE TABLE ReceiverQuality (
	ReceiverQualityId NUMBER (10) NOT NULL,
	AntennaId NUMBER (10) NOT NULL,
	ObservationTime NUMBER (19) NOT NULL,
	ExecBlockUID VARCHAR (100) NOT NULL,
	ScanNumber NUMBER (10) NOT NULL,
	CONSTRAINT RecQualityToAntenna FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT ReceivQKey PRIMARY KEY (ReceiverQualityId)
);

CREATE SEQUENCE ReceivQ_seq;

CREATE TABLE ReceiverQualityParameters (
	ReceiverQualityParamId NUMBER (10) NOT NULL,
	ReceiverQualityId NUMBER (10) NOT NULL,
	Frequency BINARY_DOUBLE NOT NULL,
	SidebandRatio BINARY_DOUBLE NOT NULL,
	Trx BINARY_DOUBLE NOT NULL,
	Polarization BINARY_DOUBLE NOT NULL,
	BandPassQuality BINARY_DOUBLE NOT NULL,
	CONSTRAINT RecQualityParamToRecQual FOREIGN KEY (ReceiverQualityId) REFERENCES ReceiverQuality,
	CONSTRAINT ReceivQPKey PRIMARY KEY (ReceiverQualityParamId)
);

CREATE SEQUENCE ReceivQP_seq;

CREATE TABLE Holography (
	HolographyId NUMBER (10) NOT NULL,
	AntennaId NUMBER (10) NOT NULL,
	ObservationTime NUMBER (19) NOT NULL,
	ExecBlockUID VARCHAR (100) NOT NULL,
	ScanNumber NUMBER (10) NOT NULL,
	ObservationDuration BINARY_DOUBLE NOT NULL,
	LowElevation BINARY_DOUBLE NOT NULL,
	HighElevation BINARY_DOUBLE NOT NULL,
	MapSize BINARY_DOUBLE NOT NULL,
	SoftwareVersion VARCHAR (100) NOT NULL,
	ObsMode VARCHAR (80) NOT NULL,
	Comments VARCHAR2 (1024) NULL,
	Frequency BINARY_DOUBLE NOT NULL,
	ReferenceAntenna NUMBER (10) NOT NULL,
	AstigmatismX2Y2 BINARY_DOUBLE NOT NULL,
	AstigmatismXY BINARY_DOUBLE NOT NULL,
	AstigmatismErr BINARY_DOUBLE NOT NULL,
	PhaseRMS BINARY_DOUBLE NOT NULL,
	SurfaceRMS BINARY_DOUBLE NOT NULL,
	SurfaceRMSNoAstig BINARY_DOUBLE NOT NULL,
	Ring1RMS BINARY_DOUBLE NOT NULL,
	Ring2RMS BINARY_DOUBLE NOT NULL,
	Ring3RMS BINARY_DOUBLE NOT NULL,
	Ring4RMS BINARY_DOUBLE NOT NULL,
	Ring5RMS BINARY_DOUBLE NOT NULL,
	Ring6RMS BINARY_DOUBLE NOT NULL,
	Ring7RMS BINARY_DOUBLE NOT NULL,
	Ring8RMS BINARY_DOUBLE NOT NULL,
	BeamMapFitUID VARCHAR (100) NOT NULL,
	SurfaceMapFitUID VARCHAR (100) NOT NULL,
	XFocus BINARY_DOUBLE NOT NULL,
	XFocusErr BINARY_DOUBLE NOT NULL,
	YFocus BINARY_DOUBLE NOT NULL,
	YFocusErr BINARY_DOUBLE NOT NULL,
	ZFocus BINARY_DOUBLE NOT NULL,
	ZFocusErr BINARY_DOUBLE NOT NULL,
	CONSTRAINT HolographyToAntenna FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT HolographyRefAntenna FOREIGN KEY (ReferenceAntenna) REFERENCES Antenna,
	CONSTRAINT HolographyObsMode CHECK (ObsMode IN ('TOWER', 'ASTRO')),
	CONSTRAINT HolographyKey PRIMARY KEY (HolographyId)
);

CREATE SEQUENCE Holography_seq;




