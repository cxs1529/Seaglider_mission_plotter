function regressionValues = mission_plots(missionTable, missionErrors, outDir, minTime)
%MISSION_PLOTS Summary of this function goes here
%   Detailed explanation goes here

    bar = waitbar(0,"Creating mission plots...");
    totalPlots = 10;

    % 1-VBD PLOTS

    % FIGURE 1
    % plot vbd rate, vbd current vs depth
    waitbar(1/totalPlots,bar,"VBD Rates vs depth...");
    figure("Name","Rates_depth");
    % plot vbd rate vs depth
    subplot(2,1,1);
    scatter(missionTable.depth( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) ),abs( missionTable.vbdRate( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) ) ), ...
        missionTable.vbd_secs((missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0)),'r');
    xlabel("Depth [m]");
    ylabel("Rate [AD/s]");
    title("VBD");

    % fit linear eq
    x= missionTable.depth( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) );
    best_fit = polyfit(x, abs( missionTable.vbdRate( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) ) ),1);    
    hold on
    y = polyval(best_fit,x);
    plot(x,y,"m-.");
    linear = strcat("regression: ",string(best_fit(1))," x + ", string(best_fit(2)));
    legend("data",linear);

    % plot vbd current vs depth
%     yyaxis right
    subplot(2,1,2);
    scatter(missionTable.depth( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) ),abs( missionTable.vbd_i( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) ) ), ...
        missionTable.vbd_secs((missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0)),'b');
    ylabel("Current [A]");

    % fit linear eq
    x= missionTable.depth( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) );
    best_fit = polyfit(x, abs( missionTable.vbd_i( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) ) ),1);
    hold on
    y = polyval(best_fit,x);
    plot(x,y,"m-.");
    linear = strcat("regression: ",string(best_fit(1))," x + ", string(best_fit(2)));
    legend("data",linear);


    % save fig 1
    savefig(fullfile(outDir,'VBD_rate_depth.fig'));
    
    
    % FIGURE 2
    waitbar(2/totalPlots,bar,"VBD Rates histogram...");
    figure("Name","Rates_histogram");
    histogram2(abs( missionTable.vbdRate( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) ) ),...
        missionTable.vbd_i( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) ),20);
    xlabel("Rate [AD/s]");
    ylabel("Current [A]");
    title("VBD");
    % save fig 2
    savefig(fullfile(outDir,'VBD_rate_histogram.fig'));
    
    
    % FIGURE 3
    % plot vbd rate, vbd current vs divenum
    waitbar(3/totalPlots,bar,"VBD Rates vs divenum...");
    figure("Name","Rates_diveNum");
    subplot(2,1,1);
    % plot vbd rate vs depth
    scatter(missionTable.dive_num( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) ),abs( missionTable.vbdRate( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) ) ), ...
        missionTable.vbd_secs((missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0)),'r');
    xlabel("Dive");
    ylabel("Rate [AD/s]");
    title("VBD");   

    % fit linear eq
    x= missionTable.dive_num( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) );
    best_fit = polyfit(x, abs( missionTable.vbdRate( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) ) ),1);
    regressionValues.vbdRate = best_fit(1);
    hold on
    y = polyval(best_fit,x);
    plot(x,y,"m-.");
    linear = strcat("regression: ",string(best_fit(1))," x + ", string(best_fit(2)));
    legend("data",linear);

    % plot vbd current vs divenum
%     yyaxis right
    subplot(2,1,2);
    scatter(missionTable.dive_num( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) ),abs( missionTable.vbd_i( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) ) ), ...
        missionTable.vbd_secs((missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0)),'b');
    ylabel("Current [A]");
    
    % fit linear eq
    x= missionTable.dive_num( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) );
    best_fit = polyfit(x, abs( missionTable.vbd_i( (missionTable.vbd_secs>minTime.vbd)&(missionTable.vbdRate<0) ) ),1);
    regressionValues.vbd_i = best_fit(1);
    hold on
    y = polyval(best_fit,x);
    plot(x,y,"m-.");
    linear = strcat("regression: ",string(best_fit(1))," x + ", string(best_fit(2)));
    legend("data",linear);


    savefig(fullfile(outDir,'VBD_rates_divenum.fig'));
    


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PITCH PLOTS

    % FIGURE 4
    waitbar(4/totalPlots,bar,"PITCH Rates vs depth...");
    figure("Name","Rates_depth");
    subplot(2,1,1);
    scatter(missionTable.depth(missionTable.pitch_secs>minTime.pitch),abs( missionTable.pitchRate(missionTable.pitch_secs>minTime.pitch)), ...
        missionTable.pitch_secs(missionTable.pitch_secs>minTime.pitch)*20,'r');
    xlabel("Depth [m]");
    ylabel("Rate [AD/s]"); 
    title("PITCH");

    % fit linear eq
    x= missionTable.depth(missionTable.pitch_secs>minTime.pitch);
    best_fit = polyfit(x, abs( missionTable.pitchRate(missionTable.pitch_secs>minTime.pitch)),1);
    hold on
    y = polyval(best_fit,x);
    plot(x,y,"m-.");
    linear = strcat("regression: ",string(best_fit(1))," x + ", string(best_fit(2)));
    legend("data",linear);

%     yyaxis right
    subplot(2,1,2);
    scatter(missionTable.depth(missionTable.pitch_secs>minTime.pitch),missionTable.pitch_i(missionTable.pitch_secs>minTime.pitch)*1000, ...
        missionTable.pitch_secs(missionTable.pitch_secs>minTime.pitch)*20,'b');
    ylabel("Current [mA]");

    % fit linear eq
    x= missionTable.depth(missionTable.pitch_secs>minTime.pitch);
    best_fit = polyfit(x, abs( missionTable.pitch_i(missionTable.pitch_secs>minTime.pitch))*1000,1);
    hold on
    y = polyval(best_fit,x);
    plot(x,y,"m-.");
    linear = strcat("regression: ",string(best_fit(1))," x + ", string(best_fit(2)));
    legend("data",linear);

    savefig(fullfile(outDir,'PITCH_rates_depth.fig'));
    
    
    % FIGURE 5
    waitbar(5/totalPlots,bar,"PITCH Rates histogram...");
    figure("Name","Rates_histogram");
    histogram2(abs( missionTable.pitchRate(missionTable.pitch_secs>minTime.pitch)),missionTable.pitch_i(missionTable.pitch_secs>minTime.pitch)*1000, 20);
    xlabel("Rate [AD/s]");
    ylabel("Current [mA]");
    title("PITCH");
    savefig(fullfile(outDir,'PITCH_rate_histogram.fig'));
    

    % FIGURE 6
    waitbar(6/totalPlots,bar,"PITCH rates vs diveNum...");
    figure("Name","Rates_diveNum");
    subplot(2,1,1);
    scatter(missionTable.dive_num(missionTable.pitch_secs>minTime.pitch),abs( missionTable.pitchRate(missionTable.pitch_secs>minTime.pitch)), ...
        missionTable.pitch_secs(missionTable.pitch_secs>minTime.pitch)*20,'r');
    xlabel("Dive");
    ylabel("Rate [AD/s]");
    title("PITCH");

    % fit linear eq
    x= missionTable.dive_num(missionTable.pitch_secs>minTime.pitch);
    best_fit = polyfit(x, abs( missionTable.pitchRate(missionTable.pitch_secs>minTime.pitch)),1);
    regressionValues.pitchRate = best_fit(1);
    hold on
    y = polyval(best_fit,x);
    plot(x,y,"m-.");
    linear = strcat("regression: ",string(best_fit(1))," x + ", string(best_fit(2)));
    legend("data",linear);

%     yyaxis right
    subplot(2,1,2);
    scatter(missionTable.dive_num(missionTable.pitch_secs>minTime.pitch),missionTable.pitch_i(missionTable.pitch_secs>minTime.pitch)*1000, ...
        missionTable.pitch_secs(missionTable.pitch_secs>minTime.pitch)*20,'b');
    ylabel("Current [mA]");

    % fit linear eq
    x= missionTable.dive_num(missionTable.pitch_secs>minTime.pitch);
    best_fit = polyfit(x, abs( missionTable.pitch_i(missionTable.pitch_secs>minTime.pitch))*1000,1);
    regressionValues.pitch_i = best_fit(1);
    hold on
    y = polyval(best_fit,x);
    plot(x,y,"m-.");
    linear = strcat("regression: ",string(best_fit(1))," x + ", string(best_fit(2)));
    legend("data",linear);

    savefig(fullfile(outDir,'PITCH_rates_divenum.fig'));
    
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ROLL PLOTS

    % FIGURE 7
    waitbar(7/totalPlots,bar,"ROLL Rates vs depth...");
    figure("Name","Rates_depth");
    subplot(2,1,1);
    scatter(missionTable.depth(missionTable.roll_secs>minTime.roll),abs( missionTable.rollRate(missionTable.roll_secs>minTime.roll)), ...
        missionTable.roll_secs(missionTable.roll_secs>minTime.roll)*10,'r');
    xlabel("Depth [m]");
    ylabel("Rate [AD/s]");
    title("ROLL");

    % fit linear eq
    x= missionTable.depth(missionTable.roll_secs>minTime.roll);
    best_fit = polyfit(x, abs( missionTable.rollRate(missionTable.roll_secs>minTime.roll)),1);
    hold on
    y = polyval(best_fit,x);
    plot(x,y,"m-.");
    linear = strcat("regression: ",string(best_fit(1))," x + ", string(best_fit(2)));
    legend("data",linear);

%     yyaxis right    
    subplot(2,1,2);
    scatter(missionTable.depth(missionTable.roll_secs>minTime.roll),missionTable.roll_i(missionTable.roll_secs>minTime.roll)*1000, ...
        missionTable.roll_secs(missionTable.roll_secs>minTime.roll)*2,'b');
    ylabel("Current [mA]");

    % fit linear eq
    x= missionTable.depth(missionTable.roll_secs>minTime.roll);
    best_fit = polyfit(x, missionTable.roll_i(missionTable.roll_secs>minTime.roll)*1000,1);
    hold on
    y = polyval(best_fit,x);
    plot(x,y,"m-.");
    linear = strcat("regression: ",string(best_fit(1))," x + ", string(best_fit(2)));
    legend("data",linear);

    savefig(fullfile(outDir,'ROLL_rates_depth.fig'));
    

    % FIGURE 8
    waitbar(8/totalPlots,bar,"ROLL Rates histogram...");
    figure("Name","Rates_histogram");
    histogram2(abs( missionTable.rollRate(missionTable.roll_secs>minTime.roll)),missionTable.roll_i(missionTable.roll_secs>minTime.roll)*1000, 20);
    xlabel("Rate [AD/s]");
    ylabel("Current [mA]");
    title("ROLL");
    savefig(fullfile(outDir,'ROLL_rate_histogram.fig'));
    
    
    % FIGURE 9
    waitbar(9/totalPlots,bar,"ROLL Rates vs diveNum...");
    figure("Name","Rates_diveNum");
    subplot(2,1,1);
    scatter(missionTable.dive_num(missionTable.roll_secs>minTime.roll),abs( missionTable.rollRate(missionTable.roll_secs>minTime.roll)), ...
        missionTable.roll_secs(missionTable.roll_secs>minTime.roll)*10,'r');
    xlabel("Dive");
    ylabel("Rate [AD/s]");
    title("ROLL");

    % fit linear eq
    x= missionTable.dive_num(missionTable.roll_secs>minTime.roll);
    best_fit = polyfit(x, abs( missionTable.rollRate(missionTable.roll_secs>minTime.roll)),1);
    regressionValues.rollRate = best_fit(1);
    hold on
    y = polyval(best_fit,x);
    plot(x,y,"m-.");
    linear = strcat("regression: ",string(best_fit(1))," x + ", string(best_fit(2)));
    legend("data",linear);

%     yyaxis right    
    subplot(2,1,2);
    scatter(missionTable.dive_num(missionTable.roll_secs>minTime.roll),missionTable.roll_i(missionTable.roll_secs>minTime.roll)*1000, ...
        missionTable.roll_secs(missionTable.roll_secs>minTime.roll)*2,'b');
    ylabel("Current [mA]");

    % fit linear eq
    x= missionTable.dive_num(missionTable.roll_secs>minTime.roll);
    best_fit = polyfit(x, missionTable.roll_i(missionTable.roll_secs>minTime.roll)*1000,1);
    regressionValues.roll_i = best_fit(1);
    hold on
    y = polyval(best_fit,x);
    plot(x,y,"m-.");
    linear = strcat("regression: ",string(best_fit(1))," x + ", string(best_fit(2)));
    legend("data",linear);

    savefig(fullfile(outDir,'ROLL_rates_divenum.fig'));
    

    % PLOT ERRORS
    waitbar(10/totalPlots,bar,"Errors...");
    figure("Name","Errors")
    scatter(missionErrors.dive_num(missionErrors.vbdRetries>0),missionErrors.vbdRetries(missionErrors.vbdRetries>0),"+");
    hold on
    scatter(missionErrors.dive_num(missionErrors.pitchRetries>0),missionErrors.pitchRetries(missionErrors.pitchRetries>0),"+");
    hold on
    scatter(missionErrors.dive_num(missionErrors.rollRetries>0),missionErrors.rollRetries(missionErrors.rollRetries>0),"+");
    hold on

    scatter(missionErrors.dive_num(missionErrors.vbdError>0),missionErrors.vbdError(missionErrors.vbdError>0));
    hold on
    scatter(missionErrors.dive_num(missionErrors.pitchError>0),missionErrors.pitchError(missionErrors.pitchError>0));
    hold on
    scatter(missionErrors.dive_num(missionErrors.rollError>0),missionErrors.rollError(missionErrors.rollError>0));

    legend("vbd retries","pitch retries", "roll retries", "vbd errors", "pitch errors", "roll errors");
    xlabel("Dive");
    ylabel("Number");

    close(bar);
end

