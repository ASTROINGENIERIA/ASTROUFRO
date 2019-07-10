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
	ConfigurationId INTEGER IDENTITY,
	GlobalConfigId INTEGER NULL,
	SwConfigurationId INTEGER NOT NULL,
	TelescopeName VARCHAR (128) NOT NULL,
	ArrayReferenceX DOUBLE NULL,
	ArrayReferenceY DOUBLE NULL,
	ArrayReferenceZ DOUBLE NULL,
	XPDelayBLLocked BOOLEAN NULL,
	XPDelayBLIncreaseVersion BOOLEAN NULL,
	XPDelayBLCurrentVersion INTEGER NULL,
	XPDelayBLWho VARCHAR (128) NULL,
	XPDelayBLChangeDesc LONGVARCHAR NULL,
	CONSTRAINT SwConfigId FOREIGN KEY (SwConfigurationId) REFERENCES Configuration,
	CONSTRAINT HWConfAltKey UNIQUE (SwConfigurationId)
);
CREATE TABLE SystemCounters (
	ConfigurationId INTEGER NOT NULL,
	UpdateTime BIGINT NOT NULL,
	AutoArrayCount SMALLINT NOT NULL,
	ManArrayCount SMALLINT NOT NULL,
	DataCaptureCount SMALLINT NOT NULL,
	CONSTRAINT SystemCountersConfig FOREIGN KEY (ConfigurationId) REFERENCES HWConfiguration,
	CONSTRAINT SystemCKey PRIMARY KEY (ConfigurationId)
);
CREATE TABLE LRUType (
	LRUName VARCHAR (128) NOT NULL,
	FullName VARCHAR (256) NOT NULL,
	ICD VARCHAR (256) NOT NULL,
	ICDDate BIGINT NOT NULL,
	Description LONGVARCHAR NOT NULL,
	Notes LONGVARCHAR NULL,
	CONSTRAINT LRUTypeKey PRIMARY KEY (LRUName)
);
CREATE TABLE AssemblyType (
	AssemblyTypeName VARCHAR (256) NOT NULL,
	BaseElementType LONGVARCHAR NOT NULL,
	LRUName VARCHAR (128) NOT NULL,
	FullName VARCHAR (256) NOT NULL,
	Description LONGVARCHAR NOT NULL,
	Notes LONGVARCHAR NULL,
	ComponentTypeId INTEGER NOT NULL,
	ProductionCode VARCHAR (256) NOT NULL,
	SimulatedCode VARCHAR (256) NOT NULL,
	CONSTRAINT AssemblyTypeLRUName FOREIGN KEY (LRUName) REFERENCES LRUType,
	CONSTRAINT AssemblyTypeCompType FOREIGN KEY (ComponentTypeId) REFERENCES ComponentType,
	CONSTRAINT AssemblyTypeBEType CHECK (BaseElementType IN ('Antenna', 'Pad', 'FrontEnd', 'WeatherStationController', 'CorrQuadrant', 'AcaCorrSet', 'CentralLO', 'AOSTiming', 'PhotonicReference', 'HolographyTower', 'Array')),
	CONSTRAINT AssemblyTypeKey PRIMARY KEY (AssemblyTypeName)
);
CREATE TABLE HwSchemas (
	SchemaId INTEGER IDENTITY,
	URN LONGVARCHAR NOT NULL,
	ConfigurationId INTEGER NOT NULL,
	AssemblyTypeName VARCHAR (256) NOT NULL,
	Schema LONGVARCHAR NULL,
	CONSTRAINT AssemblySchemasConfig FOREIGN KEY (ConfigurationId) REFERENCES HWConfiguration,
	CONSTRAINT HwSchemaAssemblyType FOREIGN KEY (AssemblyTypeName) REFERENCES AssemblyType,
	CONSTRAINT HwSchemasAltKey UNIQUE (URN, ConfigurationId)
);
CREATE TABLE Assembly (
	AssemblyId INTEGER IDENTITY,
	AssemblyTypeName VARCHAR (256) NOT NULL,
	ConfigurationId INTEGER NOT NULL,
	SerialNumber VARCHAR (256) NOT NULL,
	Data LONGVARCHAR NULL,
	CONSTRAINT AssemblyConfig FOREIGN KEY (ConfigurationId) REFERENCES HWConfiguration,
	CONSTRAINT AssemblyName FOREIGN KEY (AssemblyTypeName) REFERENCES AssemblyType,
	CONSTRAINT AssemblyAltKey UNIQUE (SerialNumber, ConfigurationId)
);
CREATE TABLE AssemblyRole (
	RoleName VARCHAR (128) NOT NULL,
	AssemblyTypeName VARCHAR (256) NOT NULL,
	CONSTRAINT AssemblyRoleAssembly FOREIGN KEY (AssemblyTypeName) REFERENCES AssemblyType,
	CONSTRAINT AssemblyRoleKey PRIMARY KEY (RoleName)
);
CREATE TABLE BaseElement (
	BaseElementId INTEGER IDENTITY,
	BaseType LONGVARCHAR NOT NULL,
	BaseElementName LONGVARCHAR NOT NULL,
	ConfigurationId INTEGER NOT NULL,
	CONSTRAINT BEConfig FOREIGN KEY (ConfigurationId) REFERENCES HWConfiguration,
	CONSTRAINT BEType CHECK (BaseType IN ('Antenna', 'Pad', 'FrontEnd', 'WeatherStationController', 'CentralLO', 'AOSTiming', 'HolographyTower', 'PhotonicReference', 'CorrQuadrant', 'AcaCorrSet', 'CorrQuadrantRack', 'CorrStationBin', 'CorrBin')),
	CONSTRAINT BaseElementAltKey UNIQUE (BaseElementName, BaseType, ConfigurationId)
);
CREATE TABLE AcaCorrSet (
	BaseElementId INTEGER NOT NULL,
	BaseBand VARCHAR (128) NOT NULL,
	IP VARCHAR (128) NOT NULL,
	CONSTRAINT AcaCSetBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT AcaCSetBBEnum CHECK (BaseBand IN ('BB_1', 'BB_2', 'BB_3', 'BB_4')),
	CONSTRAINT AcaCorrSetKey PRIMARY KEY (BaseElementId)
);
CREATE TABLE Antenna (
	BaseElementId INTEGER NOT NULL,
	AntennaName VARCHAR (128) NULL,
	AntennaType LONGVARCHAR NOT NULL,
	DishDiameter DOUBLE NOT NULL,
	CommissionDate BIGINT NOT NULL,
	XPosition DOUBLE NOT NULL,
	YPosition DOUBLE NOT NULL,
	ZPosition DOUBLE NOT NULL,
	XPositionErr DOUBLE NULL,
	YPositionErr DOUBLE NULL,
	ZPositionErr DOUBLE NULL,
	XOffset DOUBLE NOT NULL,
	YOffset DOUBLE NOT NULL,
	ZOffset DOUBLE NOT NULL,
	PosObservationTime BIGINT NULL,
	PosExecBlockUID VARCHAR (100) NULL,
	PosScanNumber INTEGER NULL,
	Comments LONGVARCHAR NULL,
	Delay DOUBLE NOT NULL,
	DelayError DOUBLE NULL,
	DelObservationTime BIGINT NULL,
	DelExecBlockUID VARCHAR (100) NULL,
	DelScanNumber INTEGER NULL,
	XDelayRef DOUBLE NULL,
	YDelayRef DOUBLE NULL,
	ZDelayRef DOUBLE NULL,
	LOOffsettingIndex INTEGER NOT NULL,
	WalshSeq INTEGER NOT NULL,
	CaiBaseline INTEGER NULL,
	CaiAca INTEGER NULL,
	Locked BOOLEAN NULL,
	IncreaseVersion BOOLEAN NULL,
	CurrentVersion INTEGER NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	DelayBLLocked BOOLEAN NULL,
	DelayBLIncreaseVersion BOOLEAN NULL,
	DelayBLCurrentVersion INTEGER NULL,
	DelayBLWho VARCHAR (128) NULL,
	DelayBLChangeDesc LONGVARCHAR NULL,
	CONSTRAINT AntennaBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT AntennaType CHECK (AntennaType IN ('VA', 'AEC', 'ACA')),
	CONSTRAINT AntennaKey PRIMARY KEY (BaseElementId)
);
CREATE TABLE AcaCorrDelays (
	AntennaId INTEGER NOT NULL,
	BbOneDelay DOUBLE NOT NULL,
	BbTwoDelay DOUBLE NOT NULL,
	BbThreeDelay DOUBLE NOT NULL,
	BbFourDelay DOUBLE NOT NULL,
	Locked BOOLEAN NULL,
	IncreaseVersion BOOLEAN NULL,
	CurrentVersion INTEGER NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	CONSTRAINT AcaCDelAntId FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT AcaCorDKey PRIMARY KEY (AntennaId)
);
CREATE TABLE Pad (
	BaseElementId INTEGER NOT NULL,
	PadName VARCHAR (128) NULL,
	CommissionDate BIGINT NOT NULL,
	XPosition DOUBLE NOT NULL,
	YPosition DOUBLE NOT NULL,
	ZPosition DOUBLE NOT NULL,
	XPositionErr DOUBLE NULL,
	YPositionErr DOUBLE NULL,
	ZPositionErr DOUBLE NULL,
	PosObservationTime BIGINT NULL,
	PosExecBlockUID VARCHAR (100) NULL,
	PosScanNumber INTEGER NULL,
	Delay DOUBLE NOT NULL,
	DelayError DOUBLE NULL,
	DelObservationTime BIGINT NULL,
	DelExecBlockUID VARCHAR (100) NULL,
	DelScanNumber INTEGER NULL,
	Locked BOOLEAN NULL,
	IncreaseVersion BOOLEAN NULL,
	CurrentVersion INTEGER NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	CONSTRAINT PadBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT PadKey PRIMARY KEY (BaseElementId)
);
CREATE TABLE FrontEnd (
	BaseElementId INTEGER NOT NULL,
	CommissionDate BIGINT NOT NULL,
	CONSTRAINT FrontEndBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT FrontEndKey PRIMARY KEY (BaseElementId)
);
CREATE TABLE PhotonicReference (
	BaseElementId INTEGER NOT NULL,
	CommissionDate BIGINT NOT NULL,
	CONSTRAINT PhotRefBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT PhotonRKey PRIMARY KEY (BaseElementId)
);
CREATE TABLE WeatherStationController (
	BaseElementId INTEGER NOT NULL,
	CommissionDate BIGINT NOT NULL,
	CONSTRAINT WeatherStationBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT WeatheSCKey PRIMARY KEY (BaseElementId)
);
CREATE TABLE CentralLO (
	BaseElementId INTEGER NOT NULL,
	CommissionDate BIGINT NOT NULL,
	CONSTRAINT CentralLOBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT CentralLOKey PRIMARY KEY (BaseElementId)
);
CREATE TABLE AOSTiming (
	BaseElementId INTEGER NOT NULL,
	CommissionDate BIGINT NOT NULL,
	CONSTRAINT AOSTimingBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT AOSTimingKey PRIMARY KEY (BaseElementId)
);
CREATE TABLE HolographyTower (
	BaseElementId INTEGER NOT NULL,
	CommissionDate BIGINT NOT NULL,
	XPosition DOUBLE NOT NULL,
	YPosition DOUBLE NOT NULL,
	ZPosition DOUBLE NOT NULL,
	CONSTRAINT HolographyTowerBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT HologrTKey PRIMARY KEY (BaseElementId)
);
CREATE TABLE AntennaToPad (
	AntennaToPadId INTEGER IDENTITY,
	AntennaId INTEGER NOT NULL,
	PadId INTEGER NOT NULL,
	StartTime BIGINT NOT NULL,
	EndTime BIGINT NULL,
	Planned BOOLEAN NOT NULL,
	MountMetrologyAN0Coeff DOUBLE NULL,
	MountMetrologyAW0Coeff DOUBLE NULL,
	Locked BOOLEAN NULL,
	IncreaseVersion BOOLEAN NULL,
	CurrentVersion INTEGER NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	CONSTRAINT AntennaToPadAntennaId FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT AntennaToPadPadId FOREIGN KEY (PadId) REFERENCES Pad,
	CONSTRAINT AntennaToPadAltKey UNIQUE (AntennaId, PadId, StartTime)
);
CREATE TABLE WeatherStationToPad (
	WeatherStationId INTEGER NOT NULL,
	PadId INTEGER NOT NULL,
	StartTime BIGINT NOT NULL,
	EndTime BIGINT NULL,
	Planned BOOLEAN NOT NULL,
	CONSTRAINT WSToPadWeatherStationId FOREIGN KEY (WeatherStationId) REFERENCES WeatherStationController,
	CONSTRAINT WSToPadPadId FOREIGN KEY (PadId) REFERENCES Pad,
	CONSTRAINT WeatheSTPKey PRIMARY KEY (WeatherStationId, PadId, StartTime)
);
CREATE TABLE HolographyTowerToPad (
	TowerToPadId INTEGER IDENTITY,
	HolographyTowerId INTEGER NOT NULL,
	PadId INTEGER NOT NULL,
	Azimuth DOUBLE NOT NULL,
	Elevation DOUBLE NOT NULL,
	CONSTRAINT HoloTowerToPadHoloTower FOREIGN KEY (HolographyTowerId) REFERENCES HolographyTower,
	CONSTRAINT HoloTowerToPadPad FOREIGN KEY (PadId) REFERENCES Pad,
	CONSTRAINT HologrTTPAltKey UNIQUE (HolographyTowerId, PadId)
);
CREATE TABLE FEDelay (
	FEDelayId INTEGER IDENTITY,
	AntennaId INTEGER NOT NULL,
	ReceiverBand VARCHAR (128) NOT NULL,
	Polarization VARCHAR (128) NOT NULL,
	SideBand VARCHAR (128) NOT NULL,
	Delay DOUBLE NOT NULL,
	DelayError DOUBLE NULL,
	ObservationTime BIGINT NULL,
	ExecBlockUID VARCHAR (100) NULL,
	ScanNumber INTEGER NULL,
	CONSTRAINT AntennaFEDelay FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT FEDelRecBandEnum CHECK (ReceiverBand IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT FEDelPolEnum CHECK (Polarization IN ('X', 'Y')),
	CONSTRAINT FEDelSideBandEnum CHECK (SideBand IN ('LSB', 'USB')),
	CONSTRAINT FEDelayAltKey UNIQUE (AntennaId, ReceiverBand, Polarization, SideBand)
);
CREATE TABLE IFDelay (
	IFDelayId INTEGER IDENTITY,
	AntennaId INTEGER NOT NULL,
	BaseBand VARCHAR (128) NOT NULL,
	Polarization VARCHAR (128) NOT NULL,
	IFSwitch VARCHAR (128) NOT NULL,
	Delay DOUBLE NOT NULL,
	DelayError DOUBLE NULL,
	ObservationTime BIGINT NULL,
	ExecBlockUID VARCHAR (100) NULL,
	ScanNumber INTEGER NULL,
	CONSTRAINT AntennaIFDelay FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT IFDelBaseBandEnum CHECK (BaseBand IN ('BB_1', 'BB_2', 'BB_3', 'BB_4')),
	CONSTRAINT IFDelIFSwitchEnum CHECK (IFSwitch IN ('USB_HIGH', 'USB_LOW', 'LSB_HIGH', 'LSB_LOW')),
	CONSTRAINT IFDelPolEnum CHECK (Polarization IN ('X', 'Y')),
	CONSTRAINT IFDelayAltKey UNIQUE (AntennaId, BaseBand, Polarization, IFSwitch)
);
CREATE TABLE LODelay (
	LODelayId INTEGER IDENTITY,
	AntennaId INTEGER NOT NULL,
	BaseBand VARCHAR (128) NOT NULL,
	Delay DOUBLE NOT NULL,
	DelayError DOUBLE NULL,
	ObservationTime BIGINT NULL,
	ExecBlockUID VARCHAR (100) NULL,
	ScanNumber INTEGER NULL,
	CONSTRAINT AntennaLODelay FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT LODelBaseBandEnum CHECK (BaseBand IN ('BB_1', 'BB_2', 'BB_3', 'BB_4')),
	CONSTRAINT LODelayAltKey UNIQUE (AntennaId, BaseBand)
);
CREATE TABLE XPDelay (
	XPDelayId INTEGER IDENTITY,
	ConfigurationId INTEGER NOT NULL,
	ReceiverBand VARCHAR (128) NOT NULL,
	SideBand VARCHAR (128) NOT NULL,
	BaseBand VARCHAR (128) NOT NULL,
	Delay DOUBLE NOT NULL,
	DelayError DOUBLE NULL,
	ObservationTime BIGINT NULL,
	ExecBlockUID VARCHAR (100) NULL,
	ScanNumber INTEGER NULL,
	CONSTRAINT HWConfigXPDelay FOREIGN KEY (ConfigurationId) REFERENCES HWConfiguration,
	CONSTRAINT XPDelBaseBandEnum CHECK (BaseBand IN ('BB_1', 'BB_2', 'BB_3', 'BB_4')),
	CONSTRAINT XPDelSideBandEnum CHECK (SideBand IN ('LSB', 'USB')),
	CONSTRAINT XPDelFreqBandEnum CHECK (ReceiverBand IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT XPDelayAltKey UNIQUE (ConfigurationId, ReceiverBand, SideBand, BaseBand)
);
CREATE TABLE CorrQuadrant (
	BaseElementId INTEGER NOT NULL,
	BaseBand VARCHAR (128) NOT NULL,
	Quadrant TINYINT NOT NULL,
	ChannelNumber TINYINT NOT NULL,
	CONSTRAINT CorrQuadBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT CorrQuadNumber CHECK (Quadrant IN (0, 1, 2, 3)),
	CONSTRAINT CorrQuadBBEnum CHECK (BaseBand IN ('BB_1', 'BB_2', 'BB_3', 'BB_4')),
	CONSTRAINT CorrQuadrantKey PRIMARY KEY (BaseElementId)
);
CREATE TABLE CorrQuadrantRack (
	BaseElementId INTEGER NOT NULL,
	CorrQuadrantId INTEGER NOT NULL,
	RackName VARCHAR (128) NOT NULL,
	RackType LONGVARCHAR NOT NULL,
	CONSTRAINT CorrQuadRackBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT CorrQuad FOREIGN KEY (CorrQuadrantId) REFERENCES CorrQuadrant,
	CONSTRAINT CorrRackType CHECK (RackType IN ('Station', 'Correlator')),
	CONSTRAINT CorrQuRKey PRIMARY KEY (BaseElementId)
);
CREATE TABLE CorrStationBin (
	BaseElementId INTEGER NOT NULL,
	CorrQuadrantRackId INTEGER NOT NULL,
	StationBinName VARCHAR (128) NOT NULL,
	CONSTRAINT CorrStBinBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT CorrStBinRack FOREIGN KEY (CorrQuadrantRackId) REFERENCES CorrQuadrantRack,
	CONSTRAINT CorrStBKey PRIMARY KEY (BaseElementId)
);
CREATE TABLE CorrelatorBin (
	BaseElementId INTEGER NOT NULL,
	CorrQuadrantRackId INTEGER NOT NULL,
	CorrelatorBinName VARCHAR (128) NOT NULL,
	CONSTRAINT CorrBinBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT CorrBinRack FOREIGN KEY (CorrQuadrantRackId) REFERENCES CorrQuadrantRack,
	CONSTRAINT CorrelBKey PRIMARY KEY (BaseElementId)
);
CREATE TABLE Startup (
	StartupId INTEGER IDENTITY,
	ConfigurationId INTEGER NOT NULL,
	StartupName VARCHAR (256) NOT NULL,
	CONSTRAINT StartupConfig FOREIGN KEY (ConfigurationId) REFERENCES HWConfiguration,
	CONSTRAINT StartupAltKey UNIQUE (StartupName, ConfigurationId)
);
CREATE TABLE BaseElementStartup (
	BaseElementStartupId INTEGER IDENTITY,
	BaseElementId INTEGER NULL,
	StartupId INTEGER NULL,
	BaseElementType VARCHAR (24) NOT NULL,
	Parent INTEGER NULL,
	IsGeneric VARCHAR (5) NOT NULL,
	Simulated BOOLEAN NOT NULL,
	CONSTRAINT BEStartupId FOREIGN KEY (StartupId) REFERENCES Startup,
	CONSTRAINT BEStartupIdBE FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT BEStartupParent FOREIGN KEY (Parent) REFERENCES BaseElementStartup,
	CONSTRAINT BEStartupBEType CHECK (BaseElementType IN ('Antenna', 'Pad', 'FrontEnd', 'WeatherStationController', 'CentralLO', 'AOSTiming', 'HolographyTower', 'Array', 'PhotonicReference1', 'PhotonicReference2', 'PhotonicReference3', 'PhotonicReference4', 'PhotonicReference5', 'PhotonicReference6')),
	CONSTRAINT BaseElSAltKey UNIQUE (StartupId, BaseElementId, Parent, BaseElementType)
);
CREATE TABLE AssemblyStartup (
	AssemblyStartupId INTEGER IDENTITY,
	RoleName VARCHAR (128) NOT NULL,
	BaseElementStartupId INTEGER NOT NULL,
	Simulated BOOLEAN NOT NULL,
	CONSTRAINT AssemblyStartupRole FOREIGN KEY (RoleName) REFERENCES AssemblyRole,
	CONSTRAINT AssemblyStartupBEStartup FOREIGN KEY (BaseElementStartupId) REFERENCES BaseElementStartup,
	CONSTRAINT AssembSAltKey UNIQUE (BaseElementStartupId, RoleName)
);
CREATE TABLE DefaultCanAddress (
	ComponentId INTEGER NOT NULL,
	IsEthernet BOOLEAN NOT NULL,
	NodeAddress VARCHAR (16) NULL,
	ChannelNumber TINYINT NULL,
	Hostname VARCHAR (80) NULL,
	Port INTEGER NULL,
	MacAddress VARCHAR (80) NULL,
	Retries SMALLINT NULL,
	TimeOutRxTx DOUBLE NULL,
	LingerTime INTEGER NULL,
	CONSTRAINT DefCanAddComp FOREIGN KEY (ComponentId) REFERENCES Component,
	CONSTRAINT DefaulCAKey PRIMARY KEY (ComponentId)
);
CREATE TABLE PointingModel (
	PointingModelId INTEGER IDENTITY,
	AntennaId INTEGER NOT NULL,
	ObservationTime BIGINT NULL,
	ExecBlockUID VARCHAR (100) NULL,
	ScanNumber INTEGER NULL,
	SoftwareVersion VARCHAR (100) NULL,
	Comments LONGVARCHAR NULL,
	SourceNumber INTEGER NULL,
	MetrologyMode VARCHAR (100) NULL,
	MetrologyFlag VARCHAR (100) NULL,
	SourceDensity DOUBLE NULL,
	PointingRMS DOUBLE NULL,
	Locked BOOLEAN NULL,
	IncreaseVersion BOOLEAN NULL,
	CurrentVersion INTEGER NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	CONSTRAINT AntennaPMAntenna FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT PointiMAltKey UNIQUE (AntennaId)
);
CREATE TABLE PointingModelCoeff (
	PointingModelCoeffId INTEGER IDENTITY,
	PointingModelId INTEGER NOT NULL,
	CoeffName VARCHAR (128) NOT NULL,
	CoeffValue DOUBLE NOT NULL,
	CONSTRAINT AntPMTermPointingModelId FOREIGN KEY (PointingModelId) REFERENCES PointingModel,
	CONSTRAINT PointiMCAltKey UNIQUE (PointingModelId, CoeffName)
);
CREATE TABLE PointingModelCoeffOffset (
	PointingModelCoeffId INTEGER NOT NULL,
	ReceiverBand VARCHAR (128) NOT NULL,
	Offset DOUBLE NOT NULL,
	CONSTRAINT AntPMCoeffOffToCoeff FOREIGN KEY (PointingModelCoeffId) REFERENCES PointingModelCoeff,
	CONSTRAINT AntennaPMCoeffOffBand CHECK (ReceiverBand IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT PointiMCOKey PRIMARY KEY (PointingModelCoeffId, ReceiverBand)
);
CREATE TABLE FocusModel (
	FocusModelId INTEGER IDENTITY,
	AntennaId INTEGER NOT NULL,
	ObservationTime BIGINT NULL,
	ExecBlockUID VARCHAR (100) NULL,
	ScanNumber INTEGER NULL,
	SoftwareVersion VARCHAR (100) NULL,
	Comments LONGVARCHAR NULL,
	SourceDensity DOUBLE NULL,
	Locked BOOLEAN NULL,
	IncreaseVersion BOOLEAN NULL,
	CurrentVersion INTEGER NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	CONSTRAINT AntennaFMAntenna FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT FocusModelAltKey UNIQUE (AntennaId)
);
CREATE TABLE FocusModelCoeff (
	FocusModelCoeffId INTEGER IDENTITY,
	FocusModelId INTEGER NOT NULL,
	CoeffName VARCHAR (128) NOT NULL,
	CoeffValue DOUBLE NOT NULL,
	CONSTRAINT AntFMTermFocusModelId FOREIGN KEY (FocusModelId) REFERENCES FocusModel,
	CONSTRAINT FocusMCAltKey UNIQUE (FocusModelId, CoeffName)
);
CREATE TABLE FocusModelCoeffOffset (
	FocusModelCoeffId INTEGER NOT NULL,
	ReceiverBand VARCHAR (128) NOT NULL,
	Offset DOUBLE NOT NULL,
	CONSTRAINT AntFMCoeffOffToCoeff FOREIGN KEY (FocusModelCoeffId) REFERENCES FocusModelCoeff,
	CONSTRAINT AntennaFMCoeffOffBand CHECK (ReceiverBand IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT FocusMCOKey PRIMARY KEY (FocusModelCoeffId, ReceiverBand)
);
CREATE TABLE DefaultComponent (
	DefaultComponentId INTEGER NOT NULL,
	ComponentTypeId INTEGER NOT NULL,
	AssemblyTypeName VARCHAR (256) NOT NULL,
	ImplLang LONGVARCHAR CHECK (ImplLang IN ('java', 'cpp', 'py')) NOT NULL,
	RealTime BOOLEAN NOT NULL,
	Code VARCHAR (256) NOT NULL,
	Path VARCHAR (256) NOT NULL,
	IsAutostart BOOLEAN NOT NULL,
	IsDefault BOOLEAN NOT NULL,
	IsStandaloneDefined BOOLEAN NULL,
	KeepAliveTime INTEGER NOT NULL,
	MinLogLevel TINYINT DEFAULT -1,
	MinLogLevelLocal TINYINT DEFAULT -1,
	XMLDoc LONGVARCHAR NULL,
	CONSTRAINT DefaultComponentTypeId FOREIGN KEY (ComponentTypeId) REFERENCES ComponentType,
	CONSTRAINT DefaultComponentAssemblyId FOREIGN KEY (AssemblyTypeName) REFERENCES AssemblyType,
	CONSTRAINT DefaulCKey PRIMARY KEY (DefaultComponentId)
);
CREATE TABLE DefaultBaciProperty (
	DefaultBaciPropId INTEGER NOT NULL,
	DefaultComponentId INTEGER NOT NULL,
	PropertyName VARCHAR (128) NOT NULL,
	description LONGVARCHAR NOT NULL,
	format LONGVARCHAR NOT NULL,
	units LONGVARCHAR NOT NULL,
	resolution LONGVARCHAR NOT NULL,
	archive_priority INTEGER NOT NULL,
	archive_min_int DOUBLE NOT NULL,
	archive_max_int DOUBLE NOT NULL,
	archive_mechanism LONGVARCHAR NOT NULL,
	archive_suppress BOOLEAN NOT NULL,
	default_timer_trig DOUBLE NOT NULL,
	min_timer_trig DOUBLE NOT NULL,
	initialize_devio BOOLEAN NOT NULL,
	min_delta_trig DOUBLE NULL,
	default_value LONGVARCHAR NOT NULL,
	graph_min DOUBLE NULL,
	graph_max DOUBLE NULL,
	min_step DOUBLE NULL,
	archive_delta DOUBLE NOT NULL,
	archive_delta_percent DOUBLE NULL,
	alarm_high_on DOUBLE NULL,
	alarm_low_on DOUBLE NULL,
	alarm_high_off DOUBLE NULL,
	alarm_low_off DOUBLE NULL,
	alarm_timer_trig DOUBLE NULL,
	min_value DOUBLE NULL,
	max_value DOUBLE NULL,
	bitDescription LONGVARCHAR NULL,
	whenSet LONGVARCHAR NULL,
	whenCleared LONGVARCHAR NULL,
	statesDescription LONGVARCHAR NULL,
	condition LONGVARCHAR NULL,
	alarm_on LONGVARCHAR NULL,
	alarm_off LONGVARCHAR NULL,
	alarm_fault_family LONGVARCHAR NULL,
	alarm_fault_member LONGVARCHAR NULL,
	alarm_level INTEGER NULL,
	Data LONGVARCHAR NULL,
	CONSTRAINT DefBACIDefaultComponentTypeId FOREIGN KEY (DefaultComponentId) REFERENCES DefaultComponent,
	CONSTRAINT DefaulBPKey PRIMARY KEY (DefaultBaciPropId)
);
CREATE TABLE DefaultMonitorPoint (
	DefaultMonitorPointId INTEGER NOT NULL,
	DefaultBACIPropertyId INTEGER NOT NULL,
	MonitorPointName VARCHAR (128) NOT NULL,
	Indice INTEGER NOT NULL,
	DataType LONGVARCHAR NOT NULL,
	RCA LONGVARCHAR NOT NULL,
	TeRelated BOOLEAN NOT NULL,
	RawDataType LONGVARCHAR NOT NULL,
	WorldDataType LONGVARCHAR NOT NULL,
	Units LONGVARCHAR NULL,
	Scale DOUBLE NULL,
	Offset DOUBLE NULL,
	MinRange LONGVARCHAR NULL,
	MaxRange LONGVARCHAR NULL,
	Description LONGVARCHAR NOT NULL,
	CONSTRAINT DefaulPntId FOREIGN KEY (DefaultBACIPropertyId) REFERENCES DefaultBaciProperty,
	CONSTRAINT DefaulMPKey PRIMARY KEY (DefaultMonitorPointId)
);
CREATE TABLE MonitorPoint (
	MonitorPointId INTEGER IDENTITY,
	BACIPropertyId INTEGER NOT NULL,
	MonitorPointName VARCHAR (128) NOT NULL,
	AssemblyId INTEGER NOT NULL,
	Indice INTEGER NOT NULL,
	DataType LONGVARCHAR NOT NULL,
	RCA LONGVARCHAR NOT NULL,
	TeRelated BOOLEAN NOT NULL,
	RawDataType LONGVARCHAR NOT NULL,
	WorldDataType LONGVARCHAR NOT NULL,
	Units LONGVARCHAR NULL,
	Scale DOUBLE NULL,
	Offset DOUBLE NULL,
	MinRange LONGVARCHAR NULL,
	MaxRange LONGVARCHAR NULL,
	Description LONGVARCHAR NOT NULL,
	CONSTRAINT MonitorPointAssemblyId FOREIGN KEY (AssemblyId) REFERENCES Assembly,
	CONSTRAINT MonitorPointBACIPropertyId FOREIGN KEY (BACIPropertyId) REFERENCES BACIProperty,
	CONSTRAINT MonitorPointDatatype CHECK (DataType IN ('float', 'double', 'boolean', 'string', 'integer', 'enum', 'clob')),
	CONSTRAINT MonitorPointAltKey UNIQUE (BACIPropertyId, AssemblyId, Indice)
);
CREATE TABLE MonitorData (
	MonitorPointId INTEGER NOT NULL,
	StartTime BIGINT NOT NULL,
	EndTime BIGINT NOT NULL,
	MonitorTS TIMESTAMP (6) NOT NULL,
	SampleSize INTEGER NOT NULL,
	MonitorClob LONGVARCHAR NOT NULL,
	MinStat DOUBLE NULL,
	MaxStat DOUBLE NULL,
	MeanStat DOUBLE NULL,
	StdDevStat DOUBLE NULL,
	CONSTRAINT MonitorDataMonitorPointId FOREIGN KEY (MonitorPointId) REFERENCES MonitorPoint,
	CONSTRAINT MonitorDataKey PRIMARY KEY (MonitorPointId, MonitorTS)
);
CREATE TABLE BaseElementOnline (
	BaseElementOnlineId INTEGER IDENTITY,
	BaseElementId INTEGER NOT NULL,
	ConfigurationId INTEGER NOT NULL,
	StartTime BIGINT NOT NULL,
	EndTime BIGINT NULL,
	NormalTermination BOOLEAN NOT NULL,
	CONSTRAINT BEOnlineId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT BEOnlineConfig FOREIGN KEY (ConfigurationId) REFERENCES HWConfiguration,
	CONSTRAINT BaseElOAltKey UNIQUE (BaseElementId, ConfigurationId, StartTime)
);
CREATE TABLE AssemblyOnline (
	AssemblyOnlineId INTEGER IDENTITY,
	AssemblyId INTEGER NOT NULL,
	BaseElementOnlineId INTEGER NOT NULL,
	RoleName VARCHAR (128) NOT NULL,
	StartTime BIGINT NOT NULL,
	EndTime BIGINT NULL,
	CONSTRAINT BEAssemblyListId FOREIGN KEY (BaseElementOnlineId) REFERENCES BaseElementOnline,
	CONSTRAINT BEAssemblyListAssemblyId FOREIGN KEY (AssemblyId) REFERENCES Assembly,
	CONSTRAINT AssembOAltKey UNIQUE (AssemblyId, BaseElementOnlineId)
);
CREATE TABLE Array (
	ArrayId INTEGER IDENTITY,
	BaseElementId INTEGER NOT NULL,
	Type LONGVARCHAR NOT NULL,
	UserId VARCHAR (256) NULL,
	StartTime BIGINT NOT NULL,
	EndTime BIGINT NULL,
	NormalTermination BOOLEAN NOT NULL,
	CONSTRAINT ArrayBEId FOREIGN KEY (BaseElementId) REFERENCES BaseElement,
	CONSTRAINT ArrayType CHECK (Type IN ('automatic', 'manual')),
	CONSTRAINT ArrayAltKey UNIQUE (StartTime, BaseElementId)
);
CREATE TABLE AntennaToArray (
	AntennaId INTEGER NOT NULL,
	ArrayId INTEGER NOT NULL,
	CONSTRAINT AntennaToArrayAntennaId FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT AntennaToArrayArrayid FOREIGN KEY (ArrayId) REFERENCES Array,
	CONSTRAINT AntennTAKey PRIMARY KEY (AntennaId, ArrayId)
);
CREATE TABLE SBExecution (
	ArrayId INTEGER NOT NULL,
	SbUID VARCHAR (256) NOT NULL,
	StartTime BIGINT NOT NULL,
	EndTime BIGINT NULL,
	NormalTermination BOOLEAN NOT NULL,
	CONSTRAINT SBExecutionArrayId FOREIGN KEY (ArrayId) REFERENCES Array,
	CONSTRAINT SBExecutionKey PRIMARY KEY (ArrayId, SbUID, StartTime)
);
CREATE TABLE AntennaToFrontEnd (
	AntennaToFrontEndId INTEGER IDENTITY,
	AntennaId INTEGER NOT NULL,
	FrontEndId INTEGER NOT NULL,
	StartTime BIGINT NOT NULL,
	EndTime BIGINT NULL,
	CONSTRAINT AntennaToFEAntennaId FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT AntennaToFEFrontEndId FOREIGN KEY (FrontEndId) REFERENCES FrontEnd,
	CONSTRAINT AntennTFEAltKey UNIQUE (AntennaId, FrontEndId, StartTime)
);
CREATE TABLE BL_VersionInfo (
	TableName VARCHAR (128) NOT NULL,
	SwConfigurationId INTEGER NOT NULL,
	EntityId INTEGER NOT NULL,
	Locked BOOLEAN NOT NULL,
	IncreaseVersion BOOLEAN NOT NULL,
	CurrentVersion INTEGER NOT NULL,
	Who VARCHAR (128) NOT NULL,
	ChangeDesc LONGVARCHAR NOT NULL,
	CONSTRAINT VersionInfoSwCnfId FOREIGN KEY (SwConfigurationId) REFERENCES Configuration,
	CONSTRAINT BL_VerIKey PRIMARY KEY (TableName, SwConfigurationId, EntityId)
);
CREATE TABLE BL_PointingModelCoeff (
	Version INTEGER NOT NULL,
	ModTime BIGINT NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	PointingModelId INTEGER NOT NULL,
	CoeffName VARCHAR (128) NOT NULL,
	CoeffValue DOUBLE NOT NULL,
	CONSTRAINT BL_PointingModelCoeffOp CHECK (Operation IN ('I', 'U', 'D')),
	CONSTRAINT BL_PoiMCKey PRIMARY KEY (Version, ModTime, Operation, PointingModelId, CoeffName)
);
CREATE TABLE BL_PointingModelCoeffOffset (
	Version INTEGER NOT NULL,
	ModTime BIGINT NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	PointingModelId INTEGER NOT NULL,
	CoeffName VARCHAR (128) NOT NULL,
	ReceiverBand VARCHAR (128) NOT NULL,
	Offset DOUBLE NOT NULL,
	CONSTRAINT BL_AntennaPMCoeffOffOp CHECK (Operation IN ('I', 'U', 'D')),
	CONSTRAINT BL_AntennaPMCoeffOffBand CHECK (ReceiverBand IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT BL_PoiMCOKey PRIMARY KEY (Version, ModTime, Operation, PointingModelId, CoeffName, ReceiverBand)
);
CREATE TABLE BL_FocusModelCoeff (
	Version INTEGER NOT NULL,
	ModTime BIGINT NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	FocusModelId INTEGER NOT NULL,
	CoeffName VARCHAR (128) NOT NULL,
	CoeffValue DOUBLE NOT NULL,
	CONSTRAINT BL_FocusModelCoeffOp CHECK (Operation IN ('I', 'U', 'D')),
	CONSTRAINT BL_FocMCKey PRIMARY KEY (Version, ModTime, Operation, FocusModelId, CoeffName)
);
CREATE TABLE BL_FocusModelCoeffOffset (
	Version INTEGER NOT NULL,
	ModTime BIGINT NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	FocusModelId INTEGER NOT NULL,
	CoeffName VARCHAR (128) NOT NULL,
	ReceiverBand VARCHAR (128) NOT NULL,
	Offset DOUBLE NOT NULL,
	CONSTRAINT BL_AntennaFMCoeffOffOp CHECK (Operation IN ('I', 'U', 'D')),
	CONSTRAINT BL_AntennaFMCoeffOffBand CHECK (ReceiverBand IN ('ALMA_RB_01', 'ALMA_RB_02', 'ALMA_RB_03', 'ALMA_RB_04', 'ALMA_RB_05', 'ALMA_RB_06', 'ALMA_RB_07', 'ALMA_RB_08', 'ALMA_RB_09', 'ALMA_RB_10')),
	CONSTRAINT BL_FocMCOKey PRIMARY KEY (Version, ModTime, Operation, FocusModelId, CoeffName, ReceiverBand)
);
CREATE TABLE BL_FEDelay (
	Version INTEGER NOT NULL,
	ModTime BIGINT NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	FEDelayId INTEGER NOT NULL,
	AntennaId INTEGER NOT NULL,
	ReceiverBand VARCHAR (128) NOT NULL,
	Polarization VARCHAR (128) NOT NULL,
	SideBand VARCHAR (128) NOT NULL,
	Delay DOUBLE NOT NULL,
	CONSTRAINT BL_FEDelayOp CHECK (Operation IN ('I', 'U', 'D')),
	CONSTRAINT BL_FEDelayKey PRIMARY KEY (Version, ModTime, Operation, FEDelayId)
);
CREATE TABLE BL_IFDelay (
	Version INTEGER NOT NULL,
	ModTime BIGINT NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	IFDelayId INTEGER NOT NULL,
	AntennaId INTEGER NOT NULL,
	BaseBand VARCHAR (128) NOT NULL,
	Polarization VARCHAR (128) NOT NULL,
	IFSwitch VARCHAR (128) NOT NULL,
	Delay DOUBLE NOT NULL,
	CONSTRAINT BL_IFDelayOp CHECK (Operation IN ('I', 'U', 'D')),
	CONSTRAINT BL_IFDelayKey PRIMARY KEY (Version, ModTime, Operation, IFDelayId)
);
CREATE TABLE BL_LODelay (
	Version INTEGER NOT NULL,
	ModTime BIGINT NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	LODelayId INTEGER NOT NULL,
	AntennaId INTEGER NOT NULL,
	BaseBand VARCHAR (128) NOT NULL,
	Delay DOUBLE NOT NULL,
	CONSTRAINT BL_LODelayOp CHECK (Operation IN ('I', 'U', 'D')),
	CONSTRAINT BL_LODelayKey PRIMARY KEY (Version, ModTime, Operation, LODelayId)
);
CREATE TABLE BL_XPDelay (
	Version INTEGER NOT NULL,
	ModTime BIGINT NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	XPDelayId INTEGER NOT NULL,
	ConfigurationId INTEGER NOT NULL,
	ReceiverBand VARCHAR (128) NOT NULL,
	SideBand VARCHAR (128) NOT NULL,
	BaseBand VARCHAR (128) NOT NULL,
	Delay DOUBLE NOT NULL,
	CONSTRAINT BL_XPDelayOp CHECK (Operation IN ('I', 'U', 'D')),
	CONSTRAINT BL_XPDelayKey PRIMARY KEY (Version, ModTime, Operation, XPDelayId)
);
CREATE TABLE BL_AntennaDelay (
	Version INTEGER NOT NULL,
	ModTime BIGINT NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	BaseElementId INTEGER NOT NULL,
	Delay DOUBLE NOT NULL,
	CONSTRAINT BL_AntDKey PRIMARY KEY (Version, ModTime, Operation, BaseElementId)
);
CREATE TABLE BL_Antenna (
	Version INTEGER NOT NULL,
	ModTime BIGINT NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	BaseElementId INTEGER NOT NULL,
	AntennaType LONGVARCHAR NOT NULL,
	DishDiameter DOUBLE NOT NULL,
	CommissionDate BIGINT NOT NULL,
	XPosition DOUBLE NOT NULL,
	YPosition DOUBLE NOT NULL,
	ZPosition DOUBLE NOT NULL,
	XOffset DOUBLE NOT NULL,
	YOffset DOUBLE NOT NULL,
	ZOffset DOUBLE NOT NULL,
	LOOffsettingIndex INTEGER NOT NULL,
	WalshSeq INTEGER NOT NULL,
	CaiBaseline INTEGER NULL,
	CaiAca INTEGER NULL,
	CONSTRAINT BL_AntennaKey PRIMARY KEY (Version, ModTime, Operation, BaseElementId)
);
CREATE TABLE BL_Pad (
	Version INTEGER NOT NULL,
	ModTime BIGINT NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	BaseElementId INTEGER NOT NULL,
	CommissionDate BIGINT NOT NULL,
	XPosition DOUBLE NOT NULL,
	YPosition DOUBLE NOT NULL,
	ZPosition DOUBLE NOT NULL,
	Delay DOUBLE NOT NULL,
	CONSTRAINT BL_PadKey PRIMARY KEY (Version, ModTime, Operation, BaseElementId)
);
CREATE TABLE BL_AntennaToPad (
	Version INTEGER NOT NULL,
	ModTime BIGINT NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	AntennaToPadId INTEGER NOT NULL,
	MountMetrologyAN0Coeff DOUBLE NULL,
	MountMetrologyAW0Coeff DOUBLE NULL,
	CONSTRAINT BL_AntTPKey PRIMARY KEY (Version, ModTime, Operation, AntennaToPadId)
);
CREATE TABLE BL_AcaCorrDelays (
	Version INTEGER NOT NULL,
	ModTime BIGINT NOT NULL,
	Operation CHAR (1) NOT NULL,
	Who VARCHAR (128) NULL,
	ChangeDesc LONGVARCHAR NULL,
	AntennaId INTEGER NOT NULL,
	BbOneDelay DOUBLE NOT NULL,
	BbTwoDelay DOUBLE NOT NULL,
	BbThreeDelay DOUBLE NOT NULL,
	BbFourDelay DOUBLE NOT NULL,
	CONSTRAINT BL_AcaCDKey PRIMARY KEY (Version, ModTime, Operation, AntennaId)
);
CREATE TABLE AntennaEfficiency (
	AntennaEfficiencyId INTEGER IDENTITY,
	AntennaId INTEGER NOT NULL,
	ObservationTime BIGINT NOT NULL,
	ExecBlockUID VARCHAR (100) NOT NULL,
	ScanNumber INTEGER NOT NULL,
	ThetaMinorPolX DOUBLE NOT NULL,
	ThetaMinorPolY DOUBLE NOT NULL,
	ThetaMajorPolX DOUBLE NOT NULL,
	ThetaMajorPolY DOUBLE NOT NULL,
	PositionAngleBeamPolX DOUBLE NOT NULL,
	PositionAngleBeamPolY DOUBLE NOT NULL,
	SourceName VARCHAR (100) NOT NULL,
	SourceSize DOUBLE NOT NULL,
	Frequency DOUBLE NOT NULL,
	ApertureEff DOUBLE NOT NULL,
	ApertureEffError DOUBLE NOT NULL,
	ForwardEff DOUBLE NOT NULL,
	ForwardEffError DOUBLE NOT NULL,
	CONSTRAINT AntEffToAntenna FOREIGN KEY (AntennaId) REFERENCES Antenna
);
CREATE TABLE ReceiverQuality (
	ReceiverQualityId INTEGER IDENTITY,
	AntennaId INTEGER NOT NULL,
	ObservationTime BIGINT NOT NULL,
	ExecBlockUID VARCHAR (100) NOT NULL,
	ScanNumber INTEGER NOT NULL,
	CONSTRAINT RecQualityToAntenna FOREIGN KEY (AntennaId) REFERENCES Antenna
);
CREATE TABLE ReceiverQualityParameters (
	ReceiverQualityParamId INTEGER IDENTITY,
	ReceiverQualityId INTEGER NOT NULL,
	Frequency DOUBLE NOT NULL,
	SidebandRatio DOUBLE NOT NULL,
	Trx DOUBLE NOT NULL,
	Polarization DOUBLE NOT NULL,
	BandPassQuality DOUBLE NOT NULL,
	CONSTRAINT RecQualityParamToRecQual FOREIGN KEY (ReceiverQualityId) REFERENCES ReceiverQuality
);
CREATE TABLE Holography (
	HolographyId INTEGER IDENTITY,
	AntennaId INTEGER NOT NULL,
	ObservationTime BIGINT NOT NULL,
	ExecBlockUID VARCHAR (100) NOT NULL,
	ScanNumber INTEGER NOT NULL,
	ObservationDuration DOUBLE NOT NULL,
	LowElevation DOUBLE NOT NULL,
	HighElevation DOUBLE NOT NULL,
	MapSize DOUBLE NOT NULL,
	SoftwareVersion VARCHAR (100) NOT NULL,
	ObsMode VARCHAR (80) NOT NULL,
	Comments LONGVARCHAR NULL,
	Frequency DOUBLE NOT NULL,
	ReferenceAntenna INTEGER NOT NULL,
	AstigmatismX2Y2 DOUBLE NOT NULL,
	AstigmatismXY DOUBLE NOT NULL,
	AstigmatismErr DOUBLE NOT NULL,
	PhaseRMS DOUBLE NOT NULL,
	SurfaceRMS DOUBLE NOT NULL,
	SurfaceRMSNoAstig DOUBLE NOT NULL,
	Ring1RMS DOUBLE NOT NULL,
	Ring2RMS DOUBLE NOT NULL,
	Ring3RMS DOUBLE NOT NULL,
	Ring4RMS DOUBLE NOT NULL,
	Ring5RMS DOUBLE NOT NULL,
	Ring6RMS DOUBLE NOT NULL,
	Ring7RMS DOUBLE NOT NULL,
	Ring8RMS DOUBLE NOT NULL,
	BeamMapFitUID VARCHAR (100) NOT NULL,
	SurfaceMapFitUID VARCHAR (100) NOT NULL,
	XFocus DOUBLE NOT NULL,
	XFocusErr DOUBLE NOT NULL,
	YFocus DOUBLE NOT NULL,
	YFocusErr DOUBLE NOT NULL,
	ZFocus DOUBLE NOT NULL,
	ZFocusErr DOUBLE NOT NULL,
	CONSTRAINT HolographyToAntenna FOREIGN KEY (AntennaId) REFERENCES Antenna,
	CONSTRAINT HolographyRefAntenna FOREIGN KEY (ReferenceAntenna) REFERENCES Antenna,
	CONSTRAINT HolographyObsMode CHECK (ObsMode IN ('TOWER', 'ASTRO'))
);
 


