clear
close all

path(pathdef);

addpath('./nozzle');
addpath('./combustion');
addpath('./physicalDesign');
addpath('./plotting');

%%
global plotDirectory;
[dir] = fileparts(mfilename('fullpath'));
clear dir;
plotDirectory = fullfile(dir, "/plots");

%%
% setPlotMode("save");
setPlotMode("show");

%%
nozzleAssumptions = nozzleSimulationAssumptions()
nozzleState = nozzleSimulation(nozzleAssumptions)
%%
combustionAssumptions = combustionSimulationAssumptions()
combustionState = combustionSimulation(combustionAssumptions, nozzleState)
combustionOpts = combustionState.opts
%%
figure('Name', 'Combustion');
%%
plotCombustion(combustionState);
%%
physicalDesignAssumptions = physicalDesignSimulationAssumptions(nozzleState, combustionState)
physicalDesignState = physicalDesignSimulation(physicalDesignAssumptions, nozzleState, combustionState)
physicalDesignOpts = physicalDesignState.opts
%%
figure('Name', 'Physical design');
%%
plotPhysicalDesign(physicalDesignState);

%%