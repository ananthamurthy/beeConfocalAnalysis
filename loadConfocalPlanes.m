function allPlanes_gray = loadConfocalPlanes(filename, removeRed, plotPlanes)

t = Tiff(filename, 'r');
myImage = read(t);
if removeRed
    myImage(:, :, 1) = 0; %removing red channel
    disp(">>>>>> [INFO] Red channel values set to 0 ...")
end

% Convert to grayscale
disp(">>>>>> [INFO] Converting to grayscale ...")
myImage_gray = rgb2gray(myImage);

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
allPlanes_gray(plane, :, :) = myImage_gray;

end