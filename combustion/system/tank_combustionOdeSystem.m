function [dXdt,fuelMassFlow,regressionRate,ccPressureVariation,temperatureGradient_l,temperatureGradient_g,internalEnegeryGradient,oxidizerMassFlow,thrust,ccTemperature, tankPressure,tankTemperature,wallTemperature_l, wallTemperature_g] = tank_combustionOdeSystem(t, X, tankModel, opts)

if tankModel == 0 
    [dXdt, regressionRate,ccPressureVariation,oxidizerMassFlow,fuelMassFlow,thrust,ccTemperature,tankPressure] = ...
        combustionOdeSystem(t, X, opts);
    temperatureGradient_l = NaN; temperatureGradient_g = NaN; internalEnegeryGradient = NaN; wallTemperature_l = NaN; wallTemperature_g = NaN; tankTemperature = NaN;
elseif tankModel == 1
    Xcombustion = X(1:3);
    Xtank = X(4:7);
    [dXtank_dt, temperatureGradient_l, temperatureGradient_g, internalEnegeryGradient, oxidizerMassFlow, tankPressure,tankTemperature,wallTemperature_l, wallTemperature_g] =...
        tankOdeSystem(t, Xtank, Xcombustion, opts);
    [dXcombustion_dt, regressionRate,ccPressureVariation,fuelMassFlow,thrust,ccTemperature] = ...
        combustionOdeSystem_tankModel(t, Xtank, Xcombustion, oxidizerMassFlow, opts);    
    dXdt = [dXcombustion_dt; dXtank_dt];
elseif tankModel == 2
    Xcombustion = NaN;
    [dXdt, temperatureGradient_l, temperatureGradient_g, internalEnegeryGradient, oxidizerMassFlow, tankPressure,tankTemperature,wallTemperature_l, wallTemperature_g] =...
        tankOdeSystem(t, X, Xcombustion, opts);
    fuelMassFlow = NaN; regressionRate = NaN; ccPressureVariation = NaN; thrust = NaN; ccTemperature = NaN;
end

disp(['t = ' num2str(t) ' Ox mass remaining: ' num2str(100*X(end) / (opts.OxidizerMass)) ' %'])
end
