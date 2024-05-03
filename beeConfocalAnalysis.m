%{
DATASETS: Reshma Basak
AUTHOR: Kambadur Ananthamurthy
PURPOSE: Floads the various .tif files in "~/Desktop/DATA/beeConfocal/", labels brain segments, and plots the surface area for each.
NOTES:
%}

tic %Start time for code run

clear
close all

zProjectAlgoList = ["Average Intensity"; "Max Intensity"; "Min Intensity"; "Median"; "Standard Deviation"; "Sum Slices"];

%Operations
saveData = 0; % Binary switch. 0: No (for testing). 1: Yes (for production run).
removeRed = 0; % Binary switch. 0: No; 1: Yes.
plotPlanes = 0; % Binary switch. 0: No; 1: Yes.
zProject = 1; % Binary switch. 0: No; 1: Yes.
gaussianSmoothing = 0; % Binary switch. 0: Nco; 1: Yes
brainReconstruct = 0; % Binary switch. 0: No; 1: Yes.
brainReconstructAlgorithm = 2; % Integer from 1 to 2. Here, 1. Iterative Shape Algorithm (ISA); 2. Virtual Insect Brain (VIB)
MenzelData = 1; % Categorical Switch. 0: Use normal data

HOME_DIR = '/Users/ananth/Documents/Bee/beeConfocalAnalysis';
DATA_DIR = '/Users/ananth/Desktop/Work/DATA/beeConfocal';
nPlanes = 30; % number of Z-planes (may vary with dataset)
startPlane = 1;

% Load each confocal plane, independently
allPlanes_gray = loadConfocalPlanes(MenzelData, DATA_DIR, startPlane, nPlanes, removeRed, plotPlanes);

if zProject
    plotZProjections(allPlanes_gray, zProjectAlgoList)
end

if brainReconstruct
    reconstructBrain(allPlanes_gray, gaussianSmoothing)
end

estimatedTime = toc;
disp("[INFO] ... All Done!")