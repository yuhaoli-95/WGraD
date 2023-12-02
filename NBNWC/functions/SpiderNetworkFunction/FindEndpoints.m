function [PA, PB, PC, PE, minfit] = FindEndpoints(temppoint, oldconnectpoint, input, output, nodelist, old_nodelist)
%maxmizetion problem
if output(temppoint) > output(oldconnectpoint)
    PAIndex = temppoint;
    PBIndex = oldconnectpoint;
    PA = input(PAIndex, :);
    PB = input(PBIndex, :);
    PCIndex = nodelist(PBIndex, 2);
    PC = input(PCIndex, :);
    PEIndex = old_nodelist(PAIndex, 2);
    PE = input(PEIndex, :);
    minfit = output(oldconnectpoint);
else
    PAIndex = oldconnectpoint;
    PBIndex = temppoint;
    PA = input(PAIndex, :);
    PB = input(PBIndex, :);
    PCIndex = nodelist(PBIndex, 2);
    PC = input(PCIndex, :);
    PEIndex = old_nodelist(PAIndex, 2);
    PE = input(PEIndex, :);
    minfit = output(temppoint);
end
end