%     Private Function Lab_Function_Inverse(ByVal SngDatum As Single) As Single 'For conversion from Lab
%         If SngDatum > 6 / 29 Then
%             Lab_Function_Inverse = SngDatum ^ 3
%         Else
%             Lab_Function_Inverse = 3 * ((6 / 29) ^ 2) * (SngDatum - 4 / 29)
%         End If
%     End Function

function LabFunctionInverse = Lab_Function_Inverse(SngDatum)
if SngDatum > 6 / 29
    LabFunctionInverse = SngDatum ^ 3;
else
    LabFunctionInverse = 3 * ((6 / 29) ^ 2) * (SngDatum - 4 / 29);
end
end