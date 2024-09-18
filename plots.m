function plots(logValues)
%PLOTS Summary of this function goes here
%   Detailed explanation goes here

    % Plot limits
    x = logValues.st_secs/60; % shared axis=time since start of dive
    xMin = min(logValues.st_secs)/60;
    xMax = max(logValues.st_secs)/60;
    % vbd y limits
    yvbdLeftMin = 0;
    yvbdLeftMax = 6;
    yvbdRightMin = 0;
    yvbdRightMax = 150;
    % pitch y limits
    ypitchLeftMin = 0;
    ypitchLeftMax = 1000;
    ypitchRightMin = 0;
    ypitchRightMax = 40;
    % roll y limits
    yrollLeftMin = 0;
    yrollLeftMax = 1500;
    yrollRightMin = 0;
    yrollRightMax = 20;

    % Value filters
    vbdMinTime = 0.01;
    pitchMintime = 0.01;
    rollMinTime = 0.01;
    % Plot Font size
    sz = 10;

    % create figure 
    figure    
    
    % VBD        
    subplot(3,1,1); %m-row,n-col,p-position    
    grid on

    % plot pot1
    plot(x(logValues.vbd_secs >= vbdMinTime),abs(logValues.vbdRate1(logValues.vbd_secs >= vbdMinTime)),"m:.",MarkerSize=10);
      
    % plot pot2
    hold on
    plot(x(logValues.vbd_secs >= vbdMinTime),abs(logValues.vbdRate2(logValues.vbd_secs >= vbdMinTime)),"c:.",MarkerSize=10);
        
    % plot pot average
    hold on
    plot(x(logValues.vbd_secs >= vbdMinTime),abs(logValues.vbdRate(logValues.vbd_secs >= vbdMinTime)),"k:.",MarkerSize=10);
    
    % plot vbd current
    hold on   
    plot(x(logValues.vbd_secs >= vbdMinTime),logValues.vbd_i(logValues.vbd_secs >= vbdMinTime),"b:.",MarkerSize=10);
    
    grid on
    xlim([xMin xMax]);
    ylim([yvbdLeftMin yvbdLeftMax]);
%     xlabel("DiveTime [min]");
    ylabel("Rate [AD/sec] / Current [A]", FontSize=sz);
    
    % Plot on second Y axis
    yyaxis right
    % plot vbd time
    area(x,logValues.vbd_secs,FaceAlpha=0.1,FaceColor='r',EdgeAlpha=0.1,EdgeColor='r'); 
    hold on
    % plot vbd voltage    
    plot(x((logValues.vbd_secs >= vbdMinTime)),logValues.vbd_volts((logValues.vbd_secs >= vbdMinTime)),"r:.",MarkerSize=10);
    % plot depth
    plot(x,logValues.depth/10,"g--");
    
    ylim([yvbdRightMin yvbdRightMax]);
    ylabel("Time[s] Voltage[V] Depth[m]", FontSize=sz);
    ax = gca;
    ax.YColor = 'r';

    legend("pot1","pot2", "pot average", "current", "time", "voltage", "depth/10");
    title("VBD");
    
    % PITCH
    subplot(3,1,2);     
    grid on

    % plot pitch rate
    plot(x(logValues.pitch_secs >= pitchMintime),abs(logValues.pitchRate(logValues.pitch_secs >= pitchMintime)),"k:.",MarkerSize=10);
    
    % plot pitch current mA 
    hold on
    plot(x(logValues.pitch_secs >= pitchMintime),logValues.pitch_i(logValues.pitch_secs >= pitchMintime)*1000,"b:.",MarkerSize=10);
    
    ylim([ypitchLeftMin ypitchLeftMax]);
    ylabel("Rate[AD/sec] Current[mA]", FontSize=sz);
    
    % plot pitch time
    yyaxis right
    area(x,logValues.pitch_secs * 100,FaceAlpha=0.1,FaceColor='r',EdgeAlpha=0.1,EdgeColor='r');
    
    % plot pitch volts
    hold on
    plot(x(logValues.pitch_secs >= pitchMintime),logValues.pitch_volts(logValues.pitch_secs >= pitchMintime),"r:.",MarkerSize=10);
    
    ylim([ypitchRightMin ypitchRightMax]);
    ylabel("Time[ms] Voltage[V]", FontSize=sz);
    ax = gca;
    ax.YColor = 'r';
    
    grid on

    legend("rate", "current", "time/10", "voltage");
    title("PITCH");
    
    % ROLL
    subplot(3,1,3); 
    title("ROLL");
    grid on
    % plot roll rate
    plot(x(logValues.roll_secs >= rollMinTime),abs(logValues.rollRate(logValues.roll_secs >= rollMinTime)),"k:.",MarkerSize=10);
    
    % plot roll current mA
    hold on
    plot(x(logValues.roll_secs >= rollMinTime),logValues.roll_i(logValues.roll_secs >= rollMinTime)*1000,"b:.",MarkerSize=10);
    
    ylim([yrollLeftMin yrollLeftMax]);
    ylabel("Rate[AD/sec] Current[mA]", FontSize=sz);

    % plot roll time
    yyaxis right
    area(x,logValues.roll_secs,FaceAlpha=0.1,FaceColor='r',EdgeAlpha=0.1,EdgeColor='r');
    
    % plot pitch volts
    hold on
    plot(x(logValues.roll_secs >= rollMinTime),logValues.roll_volts(logValues.roll_secs >= rollMinTime),"r:.",MarkerSize=10);
    
    ylim([yrollRightMin yrollRightMax]);
    ylabel("Time[s] Voltage[V]", FontSize=sz);
    ax = gca;
    ax.YColor = 'r';    

    xlim([xMin xMax]);
    grid on

    legend("rate", "current", "time", "voltage");
    title("ROLL");

    figure
    % plot rate vs depth
    scatter(logValues.depth( (logValues.vbd_secs>0)&(logValues.vbdRate<0) ),abs( logValues.vbdRate( (logValues.vbd_secs>0)&(logValues.vbdRate<0) ) ), ...
        logValues.vbd_secs((logValues.vbd_secs>0)&(logValues.vbdRate<0)));

    ylabel("Rate[AD/sec] Current[A]", FontSize=sz);
    xlabel("Depth [m]", FontSize=sz);

    hold on
    % plot current vs depth
    scatter(logValues.depth( (logValues.vbd_secs>0)&(logValues.vbdRate<0) ),logValues.vbd_i( (logValues.vbd_secs>0)&(logValues.vbdRate<0) ), ...
        logValues.vbd_secs((logValues.vbd_secs>0)&(logValues.vbdRate<0)),'+','blue');

    % plot i x v = ave power
    yyaxis right
    scatter(logValues.depth( (logValues.vbd_secs>0)&(logValues.vbdRate<0) ), ...
        logValues.vbd_i( (logValues.vbd_secs>0)&(logValues.vbdRate<0) ) .* logValues.vbd_volts( (logValues.vbd_secs>0)&(logValues.vbdRate<0)), ...
        logValues.vbd_secs((logValues.vbd_secs>0)&(logValues.vbdRate<0)),'*',"magenta");
    ylabel("Average Power [W]", FontSize=sz);
    ax = gca;
    ax.YColor = 'm';   

    figure
    % plot rate vs current
    scatter(logValues.vbd_i( (logValues.vbd_secs>0)&(logValues.vbdRate<0) ),abs(logValues.vbdRate( (logValues.vbd_secs>0)&(logValues.vbdRate<0)) ), ...
        logValues.vbd_secs((logValues.vbd_secs>0)&(logValues.vbdRate<0)),'blue');
    


end

