function DKL_to_MWL = Convert_DKL_to_MWL(DKL_array)%Taken from Webster (contained in multiple pubs)
    SngTemp(3) = zeros;
    SngTemp(1) = 1955 * (DKL_array(1) - 0.6568);
    SngTemp(2) = 5533 * (DKL_array(2) - 0.01825);
    SngTemp(3) = DKL_array(3);
    DKL_to_MWL = SngTemp;
end