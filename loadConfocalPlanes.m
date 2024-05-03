function allPlanes_gray = loadConfocalPlanes(MenzelData, DATA_DIR, startPlane, nPlanes, removeRed, plotPlanes, stepSize)

for plane = startPlane:stepSize:nPlanes
    if MenzelData == 1
        if plane == 1
            continue
        end

        if plane > 1 && plane <10
            filename = sprintf("%s/HBSGrey/HBSGrey000%i.tif", DATA_DIR, plane);
        elseif plane >= 10 && plane < 100
            filename = sprintf("%s/HBSGrey/HBSGrey00%i.tif", DATA_DIR, plane);
        else
            filename = sprintf("%s/HBSGrey/HBSGrey0%i.tif", DATA_DIR, plane);
        end
    else
        if plane < 10
            filename = sprintf("%s/GuardBee2_HiveG/Image 1_z0%i.tif", DATA_DIR, plane);
        else
            filename = sprintf("%s/GuardBee2_HiveG/Image 1_z%i.tif", DATA_DIR, plane);
        end
    end

    fprintf(">>> [INFO] Currently on plane %i ...\n", plane)
    t = Tiff(filename, 'r');
    myImage = read(t);

    if removeRed
        myImage(:, :, 1) = 0; %removing red channel
        disp(">>>>>> [INFO] Red channel values set to 0 ...")
    end

    % Convert to grayscale
    disp(">>>>>> [INFO] Converting to grayscale ...")
    if MenzelData == 1
        myImage_gray = im2gray(myImage);
    else
        myImage_gray = rgb2gray(myImage);
    end

    if plotPlanes
        % Visualize
        fig1 = figure(1);
        % set(fig1,'Position', [0, 0, 1200, 400]);
        % clf
        % subplot(1, 2, 1)
        % imagesc(myImage)
        % title(sprintf("Z-plane: %i (-red)", plane))
        % colorbar
        % 
        % subplot(1, 2, 2)
        imagesc(myImage_gray)
        title("Grayscale")
        colormap("gray")
        colorbar

        %pause(0.5)
    end

    close(t) %Close tiff object
    allPlanes_gray(plane, :, :) = myImage_gray;
end
end