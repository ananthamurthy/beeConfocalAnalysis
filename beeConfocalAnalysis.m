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
zProjectAlgorithm = 6; % Integer from 1 to 6. Here, 1. Average Intensity; 2. Maximum Intensity; 3. Minimum Intensity; 4. Median; 5. Standard Deviation; 6. Sum slices
brainReconstruct = 1; % Binary switch. 0: No; 1: Yes.
brainReconstructAlgorithm = 2; % Integer from 1 to 2. Here, 1. Iterative Shape Algorithm (ISA); 2. Virtual Insect Brain (VIB)

HOME_DIR = '/Users/ananth/Documents/Bee/beeConfocalAnalysis';
DATA_DIR = '/Users/ananth/Desktop/Work/DATA/beeConfocal/GuardBee2_HiveG';

nPlanes = 30; % number of Z-planes (may vary with dataset)
allPlanes_gray = zeros(nPlanes+1, 4016, 4016);
startPlane = 12;

%nPlanes = 1;
for plane = startPlane:nPlanes
    if plane < 10
        filename = sprintf("%s/Image 1_z0%i.tif", DATA_DIR, plane);
    else
        filename = sprintf("%s/Image 1_z%i.tif", DATA_DIR, plane);
    end

    disp(strcat("[INFO] Currently on dataset: ", filename))

    t = Tiff(filename, 'r');
    myImage = read(t);

    if removeRed
        myImage(:, :, 1) = 0; %removing red channel
        disp(">>> [INFO] Red channel values set to 0 ...")
    end

    % Convert to grayscale
    myImage_gray = rgb2gray(myImage);
    disp(">>> [INFO] Converted to grayscale ...")

    if plotPlanes
        % Visualize
        fig1 = figure(1);
        set(fig1,'Position', [0, 0, 1200, 400]);
        clf
        subplot(1, 2, 1)
        imagesc(myImage)
        title(sprintf("Z-plane: %i (-red)", plane))
        colorbar

        subplot(1, 2, 2)
        imagesc(myImage_gray)
        title("Grayscale")
        colormap("gray")
        colorbar
    end

    close(t) %Close tiff object

    allPlanes_gray(plane+1, :, :) = myImage_gray;
end

if zProject
    %Z-Projection
    if zProjectAlgorithm == 1 % Average across slices
        zProject_gray = squeeze(mean(allPlanes_gray, 1));
    elseif zProjectAlgorithm == 2 % Maximum Intensity
        zProject_gray = squeeze(max(allPlanes_gray, 1));
    elseif zProjectAlgorithm == 3 % Minimum Intensity
        zProject_gray = squeeze(min(allPlanes_gray, 1));
    elseif zProjectAlgorithm == 4 % Median
        zProject_gray = squeeze(prctile(allPlanes_gray, 50, 1)); %50th percentile = median
    elseif zProjectAlgorithm == 5 % Standard Deviation
        zProject_gray = squeeze(stddev(allPlanes_gray, 1));
    elseif zProjectAlgorithm == 6 % Sum slices
        zProject_gray = squeeze(sum(allPlanes_gray, 1));
    else
        error('Unknown Z-Projection Algorithm ... Aborting.')
    end

    % Visualize z-projection
    fig2 = figure(2);
    set(fig2, 'Position', [0, 0, 650, 600])
    clf
    imagesc(zProject_gray)
    title(sprintf("Z-Projection in Grayscale with algorithm: %s", zProjectAlgoList(zProjectAlgorithm)))
    colorbar
    colormap("gray")
    
end

if brainReconstruct
    disp("[INFO] Reconstructing the brain ...")
    
    if gaussianSmoothing
        sigma = 2;
        X = imgaussfilt(allPlanes_gray, sigma); %Main/Processed set of slices
    else
        X = allPlanes_gray;
    end

    if brainReconstructAlgorithm == 1 % Iterative Shape Algorithm/Method (ISA)
        %{
            NOTE: this algorithm is usually used when registering many different
            brains to the same averaged sample image. It removes
            variabliity.
            
            STEPS:
            1. Choose a random image to register to from z-stack (per
            animal)
            2. Affine registration of all images to this initial reference
            image
            3. Iterative non-rigid registration
        %}
    elseif brainReconstructAlgorithm == 2 % Virtual Insect Brain (VIB)
        %{
            NOTE: this algorithm is usually used when it is required to
            preserve the variability differences across samples.
        %}
    else
        error("Unknown Brain Reconstruction Algorithm ... Aborting.")
    end
    disp("[INFO] ... Done!")
end

estimatedTime = toc;