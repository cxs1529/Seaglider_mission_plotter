function logErrors = get_errors(line,diveNum, logFormat)
%GET_ERRORS Summary of this function goes here
    if logFormat == 1 % NEW
        %$ERRORS,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0
        line2arr = strsplit(line,",");
        pitchError = str2num(convertCharsToStrings(line2arr(2)));
        rollError = str2num(convertCharsToStrings(line2arr(3)));
        vbdError = str2num(convertCharsToStrings(line2arr(4)));
        pitchRetries = str2num(convertCharsToStrings(line2arr(5)));
        rollRetries = str2num(convertCharsToStrings(line2arr(6)));
        vbdRetries = str2num(convertCharsToStrings(line2arr(7)));

    else % OLD
        %$ERRORS,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0
        line2arr = strsplit(line,",");
        pitchError = str2num(convertCharsToStrings(line2arr(10)));
        rollError = str2num(convertCharsToStrings(line2arr(11)));
        vbdError = str2num(convertCharsToStrings(line2arr(12)));
        pitchRetries = str2num(convertCharsToStrings(line2arr(13)));
        rollRetries = str2num(convertCharsToStrings(line2arr(14)));
        vbdRetries = str2num(convertCharsToStrings(line2arr(15)));
    
    end
    
    logErrors = table(diveNum,pitchError,rollError,vbdError,pitchRetries,rollRetries,vbdRetries, ...
        'VariableNames',["dive_num","pitchError","rollError","vbdError","pitchRetries","rollRetries","vbdRetries"]);
%     disp(logErrors); 
end

