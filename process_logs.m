function [statsTable,regressionValues] = process_logs(glider_id,dirPath,minDiveNum,maxDiveNum,logFormat,minTime, ecsv, plots) % minDive, maxdive
%PROCESS_LOGS Summary of this function goes here
%     use parameters like these to use without the gui:
%     glider_id = "665";
%     dirPath = "C:\Users\christian.saiz\Documents\0_NOAA\1_NOAA_work\2_GLIDERS\Scripts\MissionBackups\M12_2022";
%     minDiveNum = 10;
%     maxDiveNum = 2000;
%     logFormat = 0; % 0-old / 1-new
%     minTime.vbd = 0.01;
%     minTime.pitch = 0.01;
%     minTime.roll = 0.01;
%     ecsv = false;

    
    % list log files with filter by id
    fileList = dir(fullfile( dirPath,strcat("p",glider_id,"*.log") )); % returns a cell with all the files filtered by id
    fileList = string(struct2table(fileList).name); % array of strings with log file names
    
    % create mission table, then delete
    missionTable =  table(-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, ...
            'VariableNames',["dive_num","gc","st_secs","end_secs","depth","vbd_secs","pitch_secs","roll_secs","vbd_i","pitch_i","roll_i", ...
            "deltaVbd1","deltaVbd2","deltaVbd","vbdRate1","vbdRate2","vbdRate","deltaPitch","pitchRate","deltaRoll","rollRate", ...
            "vbd_volts","pitch_volts","roll_volts","vbd_errors","pitch_errors","roll_errors"]);
    
    missionErrors = table(-1,-1,-1,-1,-1,-1,-1,'VariableNames',["dive_num","pitchError","rollError","vbdError","pitchRetries","rollRetries","vbdRetries"]);

    % read each log file and return values as table
    bar = waitbar(0,"Processing files...");
    len = length(fileList);
    for i = 1:len
        waitbar(i/len,bar,fileList(i));
        logFilePath = fullfile(dirPath,fileList(i)) ; % use this file name as input for get_dive_data
        diveNumber = get_diveNumber(logFilePath);       
        if ((diveNumber >= minDiveNum) & (diveNumber <= maxDiveNum))            
            [thisDiveTable,thisDiveErrors] = get_dive_data(logFormat,logFilePath,diveNumber);
            missionTable = [missionTable;thisDiveTable];
            missionErrors = [missionErrors;thisDiveErrors];               
        end
        if (diveNumber > maxDiveNum)
            break;
        end
    end
    close(bar);

    missionTable(1,:)=[]; % delete 1st row
    missionErrors(1,:)=[]; % delete 1st row

    outDirName = strcat("output_",glider_id);
    outDirPath = fullfile(pwd,outDirName);
    mkdir(outDirPath);

%     disp(missionTable);
    outputName = strcat("table_",glider_id,".mat");
    save(fullfile(outDirPath,outputName),"missionTable");

%     disp(missionErrors);

    % VBD
    stats.vbdMean_i = mean(missionTable.vbd_i(missionTable.vbd_secs>minTime.vbd));
    stats.vbdMin_i = min(missionTable.vbd_i(missionTable.vbd_secs>minTime.vbd));
    stats.vbdMax_i = max(missionTable.vbd_i(missionTable.vbd_secs>minTime.vbd));

    stats.vbdMeanRate = mean(abs(missionTable.vbdRate(missionTable.vbd_secs>minTime.vbd)));
    stats.vbdMinRate = min(abs(missionTable.vbdRate(missionTable.vbd_secs>minTime.vbd)));
    stats.vbdMaxRate = max(abs(missionTable.vbdRate(missionTable.vbd_secs>minTime.vbd)));

    stats.vbdRetries = sum(missionErrors.vbdRetries);
    stats.vbdError = sum(missionErrors.vbdError);
%     ["dive_num","pitchError","rollError","vbdError","pitchRetries","rollRetries","vbdRetries"]

%     % PITCH
    stats.pitchMean_i = mean(missionTable.pitch_i(missionTable.pitch_secs>minTime.pitch));
    stats.pitchMin_i = min(missionTable.pitch_i(missionTable.pitch_secs>minTime.pitch));
    stats.pitchMax_i = max(missionTable.pitch_i(missionTable.pitch_secs>minTime.pitch));

    stats.pitchMeanRate = mean(abs(missionTable.pitchRate(missionTable.pitch_secs>minTime.pitch)));
    stats.pitchMinRate = min(abs(missionTable.pitchRate(missionTable.pitch_secs>minTime.pitch)));
    stats.pitchMaxRate = max(abs(missionTable.pitchRate(missionTable.pitch_secs>minTime.pitch)));

    stats.pitchRetries = sum(missionErrors.pitchRetries);
    stats.pitchError = sum(missionErrors.pitchError);

%     % ROLL
    stats.rollMean_i = mean(missionTable.roll_i(missionTable.vbd_secs>minTime.roll));
    stats.rollMin_i = min(missionTable.roll_i(missionTable.vbd_secs>minTime.roll));
    stats.rollMax_i = max(missionTable.roll_i(missionTable.vbd_secs>minTime.roll));

    stats.rollMeanRate = mean(abs(missionTable.rollRate(missionTable.vbd_secs>minTime.roll)));
    stats.rollMinRate = min(abs(missionTable.rollRate(missionTable.vbd_secs>minTime.roll)));
    stats.rollMaxRate = max(abs(missionTable.rollRate(missionTable.vbd_secs>minTime.roll)));

    stats.rollRetries = sum(missionErrors.rollRetries);
    stats.rollError = sum(missionErrors.rollError);
   
    
    statsTable = table([stats.vbdMinRate;stats.pitchMinRate;stats.rollMinRate], ...
        [stats.vbdMeanRate; stats.pitchMeanRate; stats.rollMeanRate], ...
        [stats.vbdMaxRate; stats.pitchMaxRate; stats.rollMaxRate], ...
        [stats.vbdMin_i;stats.pitchMin_i;stats.rollMin_i], ...
        [stats.vbdMean_i; stats.pitchMean_i; stats.rollMean_i], ...
        [stats.vbdMax_i; stats.pitchMax_i; stats.rollMax_i], ...
        [stats.vbdRetries; stats.pitchRetries; stats.rollRetries], ...
        [stats.vbdError; stats.pitchError; stats.rollError], ...
        'VariableNames',["MIN RATE","MEAN RATE","MAX RATE","MIN CURRENT","MEAN CURRENT","MAX CURRENT","RETRIES","ERRORS"], ...
        'RowNames',["VBD";"PITCH";"ROLL"]);
%     disp(statsTable);
    
    if plots == true
        regressionValues = mission_plots(missionTable,missionErrors, outDirPath,minTime);  
    else
        regressionValues = [];
    end
    
    if ecsv == true
        csvName = fullfile(outDirPath,strcat("missionTable_",string(glider_id),".csv"));
        writetable(missionTable,csvName);
    end

end


function n = get_diveNumber(path)    
    fileName = strsplit(path,"\");
    fileName = fileName(end); % "p6650002.log"
    diveNum = char(fileName); % 'p6650002.log'
    diveNum = diveNum(5:8); % '0002'
    n = str2num(diveNum); % 2

end