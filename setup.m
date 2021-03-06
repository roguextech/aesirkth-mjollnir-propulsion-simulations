clear

path(pathdef);

addpath('./nozzle');
addpath('./combustion');
addpath('./physicalDesign');
addpath('./flight');
addpath('./plotting');

global plotDirectory;
[dir] = fileparts(mfilename('fullpath'));
plotDirectory = fullfile(dir, "/plots");
clear dir;
