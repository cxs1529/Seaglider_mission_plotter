% NEW LOG FORMAT
% 1-$GCHEAD,
% 2-st_secs, XX 
% 3-flags,
% 4-vbd_ctl,  Position of the VBD, in cc, relative to $C_VBD (positive buoyant)
% 5-pitch_ctl,  Position of the pitch mass, in centimeters, relative to the $C_PITCH (positive aft)
% 6-roll_ctl,  Position of the roll, in degrees, relative to the $C_ROLL
% 7-vbd_ad_start, XX Average position of vbd linear potentiometers 1 and 2, in AD counts, at the beginning of the motor move
% 8-vbd_pot1_ad_start, 
% 9-vbd_pot2_ad_start, 
% 10-pitch_ad_start, 
% 11-roll_ad_start, 
% 12-depth, XX
% 13-ob_vertv,
% 14-data_pts,
% 15-end_secs, XX Elapsed time from the start of the dive to the end of GC
% 16-vbd_secs, XX Number of seconds the VBD was on
% 17-pitch_secs, XX Number of seconds the pitch motor was on
% 18-roll_secs, XX Number of seconds the roll motor was on
% 19-vbd_i, XX Average current used by the VBD, in amps
% 20-pitch_i, XX
% 21-roll_i, XX
% 22-vbd_ad,  Position of the VBD motor, in AD counts, at the end of the motor move
% 23-vbd_pot1_ad,
% 24-vbd_pot2_ad,
% 25-pitch_ad,  Position of the pitch motor, in AD counts, at the end of the motor move
% 26-roll_ad,  Position of the roll motor, in AD counts, at the end of the motor move
% 27-vbd_errors, XX
% 28-pitch_errors, XX
% 29-roll_errors, XX
% 30-vbd_volts, XX
% 31-pitch_volts, XX
% 32-roll_volts XX

% OLD LOG FORMAT
% 1-$GCHEAD,
% 2-st_secs,
% 3-pitch_ctl,
% 4-vbd_ctl,
% 5-pitch_ad_start,
% 6-roll_ad_start,
% 7-vbd_pot1_ad_start
% 8-vbd_pot2_ad_start
% 9-depth,
% 10-ob_vertv,
% 11-data_pts,
% 12-end_secs,
% 13-pitch_secs,
% 14-roll_secs,
% 15-vbd_secs,
% 16-vbd_i,
% 17-gcphase,
% 18-pitch_i,
% 19-roll_i,
% 20-pitch_ad,
% 21-roll_ad,
% 22-vbd_ad,
% 23-vbd_pot1_ad,
% 24-vbd_pot2_ad
% 25-pitch_retries,
% 26-pitch_errors,
% 27-roll_retries,
% 28-roll_errors
% 29-vbd_retries,
% 30-vbd_errors,
% 31-pitch_volts,
% 32-roll_volts,
% 33-vbd_volts

function [valuesTable_start,valuesTable_end] = get_values(line,gc,diveNum,logFormat)

    % array to store values of interest
    % lineArray = [1-GC, 2-st_secs, 3-end_secs, 4-depth, 5-vbd_secs, 6-pitch_secs, 7-roll_secs, 8-vbd_i, 9-pitch_i, 10-roll_i, 
    % 11-dvbd1, 12-dvbd2, 13-dvbd, 14-vbdrate1, 15-vbdrate2, 16-vbdrate, 17-dpitch, 18-pitchrate, 19-droll, 20-rollrate, 21-vbd_volts,
    % 22-pitch_volts, 23-roll_volts, 24-vbd_errors, 25-pitch_errors, 26-roll_errors]
    line2arr = strsplit(line,",");   
    len = length(line2arr);
    %splitLine = [];
    
    if logFormat == 1
        % NEW LOG FORMAT
        % convert values to number
        st_secs = str2num(convertCharsToStrings(line2arr(2)));
        end_secs = str2num(convertCharsToStrings(line2arr(15)));
        depth = str2num(convertCharsToStrings(line2arr(12)));
        vbd_secs = str2num(convertCharsToStrings(line2arr(16)));
        pitch_secs = str2num(convertCharsToStrings(line2arr(17)));
        roll_secs = str2num(convertCharsToStrings(line2arr(18)));
        vbd_i = str2num(convertCharsToStrings(line2arr(19)));
        pitch_i = str2num(convertCharsToStrings(line2arr(20)));
        roll_i = str2num(convertCharsToStrings(line2arr(21)));
        vbd_pot1_ad = str2num(convertCharsToStrings(line2arr(23)));
        vbd_pot1_ad_start = str2num(convertCharsToStrings(line2arr(8)));
        vbd_pot2_ad = str2num(convertCharsToStrings(line2arr(24)));
        vbd_pot2_ad_start = str2num(convertCharsToStrings(line2arr(9)));
        vbd_ad = str2num(convertCharsToStrings(line2arr(22)));
        vbd_ad_start = str2num(convertCharsToStrings(line2arr(7)));
        pitch_ad = str2num(convertCharsToStrings(line2arr(25)));
        pitch_ad_start = str2num(convertCharsToStrings(line2arr(10)));
        roll_ad = str2num(convertCharsToStrings(line2arr(26)));
        roll_ad_start = str2num(convertCharsToStrings(line2arr(11)));
        vbd_volts = str2num(convertCharsToStrings(line2arr(30)));
        pitch_volts = str2num(convertCharsToStrings(line2arr(31)));
        roll_volts = str2num(convertCharsToStrings(line2arr(32)));
        vbd_errors = str2num(convertCharsToStrings(line2arr(27)));
        pitch_errors = str2num(convertCharsToStrings(line2arr(28)));
        roll_errors = str2num(convertCharsToStrings(line2arr(29)));
    else
        % OLD LOG FORMAT
        st_secs = str2num(convertCharsToStrings(line2arr(2)));
        end_secs = str2num(convertCharsToStrings(line2arr(12)));
        depth = str2num(convertCharsToStrings(line2arr(9)));
        vbd_secs = str2num(convertCharsToStrings(line2arr(15)));
        pitch_secs = str2num(convertCharsToStrings(line2arr(13)));
        roll_secs = str2num(convertCharsToStrings(line2arr(14)));
        vbd_i = str2num(convertCharsToStrings(line2arr(16)));
        pitch_i = str2num(convertCharsToStrings(line2arr(18)));
        roll_i = str2num(convertCharsToStrings(line2arr(19)));
        vbd_pot1_ad = str2num(convertCharsToStrings(line2arr(23)));
        vbd_pot1_ad_start = str2num(convertCharsToStrings(line2arr(7)));
        vbd_pot2_ad = str2num(convertCharsToStrings(line2arr(24)));
        vbd_pot2_ad_start = str2num(convertCharsToStrings(line2arr(8)));
        vbd_ad = str2num(convertCharsToStrings(line2arr(22)));
        vbd_ad_start = (vbd_pot2_ad_start + vbd_pot1_ad_start)/2;
        pitch_ad = str2num(convertCharsToStrings(line2arr(20)));
        pitch_ad_start = str2num(convertCharsToStrings(line2arr(5)));
        roll_ad = str2num(convertCharsToStrings(line2arr(21)));
        roll_ad_start = str2num(convertCharsToStrings(line2arr(6)));
        vbd_volts = str2num(convertCharsToStrings(line2arr(33)));
        pitch_volts = str2num(convertCharsToStrings(line2arr(31)));
        roll_volts = str2num(convertCharsToStrings(line2arr(32)));
        vbd_errors = str2num(convertCharsToStrings(line2arr(30)));
        pitch_errors = str2num(convertCharsToStrings(line2arr(26)));
        roll_errors = str2num(convertCharsToStrings(line2arr(28)));

    end

    % determine rates
    % VBD
    deltaVbd1 = vbd_pot1_ad - vbd_pot1_ad_start;
    deltaVbd2 = vbd_pot2_ad - vbd_pot2_ad_start;
    deltaVbd = vbd_ad - vbd_ad_start;
    if vbd_secs == 0
        vbdRate1 = 0;
        vbdRate2 = 0;
        vbdRate = 0;
    else
        vbdRate1 = deltaVbd1 / vbd_secs;
        vbdRate2 = deltaVbd2 / vbd_secs;
        vbdRate = deltaVbd / vbd_secs;
    end
    % PITCH
    deltaPitch = pitch_ad - pitch_ad_start;
    if pitch_secs == 0
        pitchRate = 0;
    else
        pitchRate = deltaPitch / pitch_secs;
    end
    % ROLL
    deltaRoll = roll_ad - roll_ad_start;
    if roll_secs == 0
        rollRate = 0;
    else
        rollRate = deltaRoll / roll_secs;
    end
    
    %store values of interest
    valuesTable_start = table(diveNum,gc,st_secs,end_secs,depth,vbd_secs,pitch_secs,roll_secs,vbd_i,pitch_i,roll_i, ...
        deltaVbd1,deltaVbd2,deltaVbd,vbdRate1,vbdRate2,vbdRate,deltaPitch,pitchRate,deltaRoll,rollRate, ...
        vbd_volts,pitch_volts,roll_volts,vbd_errors,pitch_errors,roll_errors, ...
        'VariableNames',["dive_num","gc","st_secs","end_secs","depth","vbd_secs","pitch_secs","roll_secs","vbd_i","pitch_i","roll_i", ...
        "deltaVbd1","deltaVbd2","deltaVbd","vbdRate1","vbdRate2","vbdRate","deltaPitch","pitchRate","deltaRoll","rollRate", ...
        "vbd_volts","pitch_volts","roll_volts","vbd_errors","pitch_errors","roll_errors"]);
    
end

