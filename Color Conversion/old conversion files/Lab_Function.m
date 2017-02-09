%     Private Function Lab_Function(ByVal SngDatum As Single) As Single 'For converstion to Lab
%         If SngDatum > (6 / 29) ^ 3 Then
%             Lab_Function = SngDatum ^ (1 / 3)
%         Else
%             Lab_Function = (1 / 3) * ((29 / 6) ^ 2) * SngDatum + (4 / 29)
%         End If
%     End Function

function LabFunction = Lab_Function(SngDatum) %For Conversion to Lab
if SngDatum > (6 / 29) ^ 3
    LabFunction = SngDatum ^ (1 / 3);
else
    LabFunction = (1 / 3) * ((29 / 6) ^ 2) * SngDatum + (4 / 29);
end
end