function MWL_to_DKL = Convert_MWL_to_DKL(MWL_array)
    SngTemp(3) = zeros;
    SngTemp(1) = (MWL_array(1) / 1955) + 0.6568;
    SngTemp(2) = (MWL_array(2) / 5533) + 0.01825;
    SngTemp(3) = MWL_array(3);
    MWL_to_DKL = SngTemp;
end