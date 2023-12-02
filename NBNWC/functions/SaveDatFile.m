function SaveDatFile(Time, MMOresult, fesArray, DatFileFolderName, FuncID, reputationIth, D)
if length(Time(:, 1)) == 1
    Time = Time';
end
if length(fesArray(:, 1)) == 1
    fesArray = fesArray';
end
equalsymbol = repmat({'='}, length(Time), 1);
ATsymble = repmat({'@'}, length(Time), 1);
datarecorder = [num2cell(MMOresult(:, 1 : end - 1)) equalsymbol num2cell(MMOresult(:, end)) (ATsymble) num2cell(fesArray) num2cell(Time)];
DatFile = fopen([DatFileFolderName, 'problem', num2str(FuncID, '%03d'), 'run', num2str(reputationIth, '%03d'), '.dat'], 'wt');
formatSpec = [repmat('%.15f ', 1, D), '%2s %.15f %2s %15d %.15f\n'];
[nrows, ~] = size(datarecorder);
for row = 1 : nrows
    fprintf(DatFile, formatSpec, datarecorder{row,:});
end
fclose(DatFile);
end