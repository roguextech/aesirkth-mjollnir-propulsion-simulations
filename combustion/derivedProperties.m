% This file is run in combustionSimulation.m
% Do not run this file as it is.
%
% This file contains derived properties for the combustion simulation of the Eyjafjallaj??kull hybrid rocket engine.
%
% DO NOT EDIT THIS FILE UNLESS YOU NEED TO ADD MORE DERIVED PROPERTIES. 
% ASSUMPTIONS AND INPUTS DO NOT GO IN THIS FILE

global tankTemperature
tankTemperature = opts.OxidizerTemperature;

opts = oxidizerProperties_create_interpolationtables(opts, 200,305,0.1,1e5,60e5,1000);


airProperties = airProperties(opts.AmbientPressure, opts.AmbientTemperature);
opts.air.cp = airProperties.cp;
opts.air.rho = airProperties.rho;
opts.air.mu = airProperties.mu;
opts.air.k = airProperties.k;
oxInitialProperties = oxidizerPropertiesTemperature('interp',opts.OxidizerTemperature, {'p', 'rho_l', 'u_l'}, opts);    % get initital properties for initital tank pressure
opts.OxidizerPressure = oxInitialProperties.p;
opts.OxidizerDensity = oxInitialProperties.rho_l;                       % only liquid phase of oxidizer in the beginning
opts.OxidizerSpecificInternalEnergy = oxInitialProperties.u_l;          % only liquid phase of oxidizer in the beginning

opts.CombustionChamberDiameter = opts.CombustionChamberDiameterInCm / 100;
opts.CombustionChamberRadius = opts.CombustionChamberDiameter / 2;
opts.CombustionChamberWallThickness = opts.CombustionChamberWallThicknessInMm / 1000;
opts.FuelGrainContainerWallThickness = opts.FuelGrainContainerWallThicknessInMm / 1000;
opts.FuelGrainInitialPortRadius = opts.FuelGrainInitialPortRadiusInCm / 100;
opts.UnusableFuelMarginThickness = opts.UnusableFuelMarginThicknessInCm / 100;

% Fuel shape correction factor
R = opts.FuelGrainInitialPortRadius;
a = opts.CombustionChamberSinusShapeAmplitude;
dc = @(theta) sqrt((0.94*R+R*a*sin(8*theta)).^2+(R*a*8*cos(8*theta)).^2);
opts.CombustionChamberInitialPerimeter = integral(dc,0,2*pi);

opts.TotalFuelGrainRadius = opts.CombustionChamberRadius - opts.CombustionChamberWallThickness - opts.FuelGrainContainerWallThickness;
opts.UsableFuelGrainRadius = opts.TotalFuelGrainRadius - opts.UnusableFuelMarginThickness;

opts.FuelGrainLength = opts.FuelGrainLengthInCm / 100;

% Carbon additive impacts on fuel density
opts.FuelGrainDensity = opts.FuelDensity * (1 - opts.CarbonAdditiveFraction) + opts.CarbonDensity * opts.CarbonAdditiveFraction;

opts.TotalFuelVolume = ((opts.TotalFuelGrainRadius)^2 * pi - opts.FuelGrainInitialPortRadius^2 * pi)* opts.FuelGrainLength;
opts.FuelVolume = ((opts.UsableFuelGrainRadius)^2 * pi - opts.FuelGrainInitialPortRadius^2 * pi) * opts.FuelGrainLength;
opts.UnusableFuelVolume = opts.TotalFuelVolume - opts.FuelVolume;

opts.TotalFuelMass = opts.TotalFuelVolume * opts.FuelGrainDensity;
opts.FuelMass = opts.FuelVolume * opts.FuelGrainDensity;
opts.UnusableFuelMass = opts.UnusableFuelVolume * opts.FuelGrainDensity;

opts.PropellantMass = opts.FuelMass * (1 + opts.DesignOFRatio);
opts.OxidizerMass = opts.PropellantMass * opts.DesignOFRatio / (opts.DesignOFRatio + 1);
opts.OxidizerVolume = opts.OxidizerMass / opts.OxidizerDensity;

opts.InjectorsArea = pi*(opts.InjectorsDiameter/2)^2 * opts.NumberOfInjectors;

opts.ThrustEfficiency = opts.CombustionEfficiency * nozzleState.NozzleEfficiency;

opts.OxidizerInternalEnergy = opts.OxidizerMass * opts.OxidizerSpecificInternalEnergy;


%% change:


opts.tankDiameter = opts.tankDiameterInCm / 1e2;

opts.OxidizerTankDiameter = opts.OxidizerTankDiameterInCm / 100; % External diameter
opts.OxidizerTankRadius = opts.OxidizerTankDiameter / 2; % External radius

opts.OxidizerVolumeWithExtraVolume = opts.OxidizerVolume * (1 + opts.ExtraVolumeFactor);
opts.OxidizerVolumeWithExtraVolumeInLiter = opts.OxidizerVolumeWithExtraVolume * 10*10*10;

rounding = 0.1;
[oxTankLength, oxTankMinThickness, oxTankThickness, oxTankMass, oxTankVolume] = correctedCapsuleTank(...
  opts.OxidizerTankRadius, ...
  opts.OxidizerVolumeWithExtraVolume, ...
  opts.OxidizerTankPressure * opts.OxidizerTankSafetyMargin, ...
  opts.OxidizerTankSigma, ...
  opts.OxidizerTankDensity, ...
  rounding);


opts.tankLength = oxTankLength;

opts.tankThickness = oxTankThickness;
opts.tankDensity = opts.OxidizerTankDensity;
opts.tankThermalConductivity = opts.OxidizerTankThermalConductivity;
opts.tankSpecificHeat = opts.OxidizerTankSpecificHeat;


run("./properties/cstarInterpolationTable")

Height = 21;
Width = length(cstarTable) / Height;

pressures = cstarTable(:,1);
ofRatios = cstarTable(:,2);
cStars = cstarTable(:,3);

opts.cstarInterpol.pressures = reshape(pressures, Height, Width)';
opts.cstarInterpol.ofRatios = reshape(ofRatios, Height, Width)';
opts.cstarInterpol.cStars = reshape(cStars, Height, Width)';


