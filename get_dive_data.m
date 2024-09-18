function [logValues,logErrors] = get_dive_data(logFormat,filePath,diveNum)
    % Open file
    %filePath = "p6650088.log";
    fileName = strsplit(filePath,"\");
    
%     disp(fileName(end));

    fin = fopen(filePath);
    
    % initiate table to add values - delete at the end -> logValues(1,:)=[]
    logValues =  table(-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, ...
            'VariableNames',["dive_num","gc","st_secs","end_secs","depth","vbd_secs","pitch_secs","roll_secs","vbd_i","pitch_i","roll_i", ...
            "deltaVbd1","deltaVbd2","deltaVbd","vbdRate1","vbdRate2","vbdRate","deltaPitch","pitchRate","deltaRoll","rollRate", ...
            "vbd_volts","pitch_volts","roll_volts","vbd_errors","pitch_errors","roll_errors"]);
    
    errorFlag = false; % flag turns true when $ERRORS line is found, otherwise remains false
  

    % loop reading each line
    while true
        line = fgetl(fin);
        if ~ischar(line)
            break;
        end
    
        % store DIVE values (GC=1)
        if contains(line, "begin dive")
%             disp("...START DIVE...");
            while true
                line = fgetl(fin); % start reading in inner loop
                if contains(line, "end dive")
%                     disp("...DIVE FINISHED...");
                    break;
                end
    
                if startsWith(line,"$GC")    
                    a=get_values(line, 1, diveNum,logFormat);
    %                 logValues=[logValues;a;b]; % append values
                    logValues=[logValues;a];
    
                end
            end
        end
    
        % store APOGEE values (GC=2)
        if contains(line,"begin apogee")
%             disp("...APOGEE START...");
            line = fgetl(fin); % read only 1 line for apogee
            a=get_values(line, 2, diveNum, logFormat);
    %         logValues=[logValues;a;b]; % append values  
            logValues=[logValues;a];
%             disp("...APOGEE FINISHED...")
        end
    
        % store CLIMB values (GC=3)
        if contains(line, "begin climb")
%             disp("...START CLIMB...");
            while true
                line = fgetl(fin); % start reading in inner loop
                if contains(line, "end climb")
%                     disp("...CLIMB FINISHED...");
                    break;
                end
    
                if startsWith(line,"$GC")
                    a=get_values(line, 3, diveNum,logFormat);
    %                 logValues=[logValues;a;b]; % append values 
                    logValues=[logValues;a];
                end
            end
        end
        if contains(line, "$ERRORS,")
            logErrors = get_errors(line,diveNum,logFormat); % one of these per log
            errorFlag = true;
        end

    end
    
    fclose(fin);
    
    % delete first row
    logValues(1,:)=[];

    % if $ERRORS line wasn't found then assign zeros
    if errorFlag == false
            logErrors = table(diveNum,0,0,0,0,0,0, ...
        'VariableNames',["dive_num","pitchError","rollError","vbdError","pitchRetries","rollRetries","vbdRetries"]);
    end

    
end


