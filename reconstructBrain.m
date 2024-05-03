function reconstructBrain(allPlanes_gray, gaussianSmoothing)
    disp(">>> [INFO] Reconstructing the brain ...")

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
    disp(">>>>>> [INFO] ... Done!")
end