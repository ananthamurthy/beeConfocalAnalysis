function plotZProjections(allPlanes_gray, zProjectAlgoList)
fprintf(">>> [INFO] Establishing Z-Projections ...\n")
%zProject_gray = zeros(squeeze(size(allPlanes_gray, 2, 3))); %Initialization

% Visualize z-projection
fig2 = figure(2);
set(fig2, 'Position', [0, 0, 1500, 800])
clf
for algo = 1:length(zProjectAlgoList)
    fprintf(">>>>>> Algorithm: %s ...\n", zProjectAlgoList(algo))
    %Z-Projection
    if algo == 1 % Average across slices
        zProject_gray = squeeze(mean(allPlanes_gray, 1));
    elseif algo == 2 % Maximum Intensity
        zProject_gray = squeeze(max(allPlanes_gray));
    elseif algo == 3 % Minimum Intensity
        zProject_gray = squeeze(min(allPlanes_gray));
    elseif algo == 4 % Median
        zProject_gray = squeeze(prctile(allPlanes_gray, 50, 1)); %50th percentile = median
    elseif algo == 5 % Standard Deviation
        zProject_gray = squeeze(std(double(allPlanes_gray), 0, 1)); % w = 0
    elseif algo == 6 % Sum slices
        zProject_gray = squeeze(sum(allPlanes_gray, 1));
    else
        error('Unknown Z-Projection Algorithm ... Aborting.')
    end

    % Visualize z-projection
    if ndims(zProject_gray) == 2
        subplot(2, 3, algo) %algo = 1 to 6
        imagesc(zProject_gray)
        title(sprintf("Z-Projection | %s", zProjectAlgoList(algo)))
        colorbar
        colormap("gray")
    else
        warning("The Z-Projection image is not 2D for Algo %i ... Skipping plot.", algo)
        continue
    end
end
disp(">>>>>> [INFO] ... Done!")
end