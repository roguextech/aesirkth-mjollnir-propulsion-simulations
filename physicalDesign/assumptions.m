% This file is run in physicalDesignSimulationAssumptions.m
% Do not run this file as it is.
%
% This file contains assumptions for the physical design simulation of the Eyjafjallaj??kull hybrid rocket engine.

opts.RocketExternalDiameterInCm = 16;

[density, sigma, thermalConductivity, specificHeat] = oxidizerTankMaterialProperties()

opts.ExtraVolumeFactor = 0; % Factor of "extra" volume added to the oxidizer tank
opts.OxidizerTankDiameterInCm = opts.RocketExternalDiameterInCm;
opts.OxidizerTankDensity  = density;
opts.OxidizerTankSigma  = sigma;
opts.OxidizerTankThermalConductivity = thermalConductivity;
opts.OxidizerTankSpecificHeat = specificHeat;

[density, sigma] = combustionChamberMaterialProperties()

opts.ccDensity  = density;
opts.ccSigma  = sigma;

opts.EngineFixedMass = 10;