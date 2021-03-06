%% FF and entropy analysis over several days

% % %batch files must have this 'date' format and name
% !ls *bk46_19*cbin.not.mat > bk90bk46_19Jun2012

%% Making an all calls pitch folder on your computer

% write the name of your computer and/or directory here, it will make an
% all_calls_analysis folder that will save your three large structure
% variables and folders with figures and workspace variables for each bird.

which_computer = input('Bluejay number? ');
multiple_pitch.parameters.computer = ['/bluejay' num2str(which_computer) '/dbrady'];
clear which_computer

if exist([multiple_pitch.parameters.computer '/all_calls_analysis_pitch'], 'dir') ~= 7
    mkdir([multiple_pitch.parameters.computer '/all_calls_analysis_pitch'])
else
end


%% Entering or loading parameters for your bird

% asks for name of bird. your batch file should be named birdname_date.
% if you have trouble with findwnote later, make sure that the bird
% name is the name of batch file up to (but not including) the hyphen
% before the date.
multiple_pitch.parameters.nameofbird = input('What is the name of your bird? \n(format should be name of batch file excluding date)  ', 's');

%asks for experiment type (either pitch, seq, or entropy)
multiple_pitch.parameters.experiment_type = [input('What type of experiment did you do? \n(pitch, sequence, entropy)  ', 's') '/'];

% makes a directory for a particular bird if it does not exist yet.
if exist([multiple_pitch.parameters.computer '/all_calls_analysis_pitch/' multiple_pitch.parameters.experiment_type...
        multiple_pitch.parameters.nameofbird], 'dir') ~= 7;
    mkdir([multiple_pitch.parameters.computer '/all_calls_analysis_pitch/' multiple_pitch.parameters.experiment_type...
        multiple_pitch.parameters.nameofbird])
else
end

% tries to load structure with data from previous runs
try
    load([ multiple_pitch.parameters.computer '/all_calls_analysis_pitch/' multiple_pitch.parameters.experiment_type...
        multiple_pitch.parameters.nameofbird '/' multiple_pitch.parameters.nameofbird '.mat'])
catch err
    display('Cannot find files, hope this is your first time running this program on this bird')
    display(' ')
    
    
    % asks for the syllables for the particular bird
    multiple_pitch.parameters.syllables =...
        input(['What are the syllables for ' multiple_pitch.parameters.nameofbird '?\n(no spaces between letters)  '], 's');
    
    multiple_pitch.parameters.days{1} =...
        input(['What is the first day for ' multiple_pitch.parameters.nameofbird '?\n(format should be day month year. i.e. 06Jun2012)    '], 's');
    multiple_pitch.parameters.days{3} = datenum(multiple_pitch.parameters.days{1});
    
    % Asks for the frequency range and refractory period for each syllable
    for i = 1:length(multiple_pitch.parameters.syllables)
        multiple_pitch.parameters.frequency_range.(multiple_pitch.parameters.syllables(i)) =...
            input(['Frequency range for ' multiple_pitch.parameters.syllables(i) ' for ' multiple_pitch.parameters.nameofbird '?\n(format [start stop])  ']);
        multiple_pitch.parameters.refractory_period.(multiple_pitch.parameters.syllables(i)) =...
            input(['Refractory period for ' multiple_pitch.parameters.syllables(i) ' for ' multiple_pitch.parameters.nameofbird '?  ']);
    end
    
    % Asks for length before WN delivery, pitch shift, consolidation, etc.
    multiple_pitch.parameters.duration.begin = input('How many days before WN delivery?  ');
    multiple_pitch.parameters.duration.shift = input('How many days of driving learning?  ');
    multiple_pitch.parameters.duration.consolidation = input('How many days of consolidation?  ');

end

% puts a time stamp on all figures and variables when you did the analysis
multiple_pitch.parameters.today_date = datestr(now, 'ddmmmyyyy_HHMMAM');
multiple_pitch.parameters.today_date = multiple_pitch.parameters.today_date(multiple_pitch.parameters.today_date ~= ' ');


% adds the last date  for the bird. you must have already created batch
% files for the dates of interest.
multiple_pitch.parameters.days{2} =...
    input(['What is the last day for ' multiple_pitch.parameters.nameofbird '?\n(format should be day month year. i.e. 31Dec2013)   '], 's');
multiple_pitch.parameters.days{4} = datenum(multiple_pitch.parameters.days{2});

%checks to make sure you have at least two days
if multiple_pitch.parameters.days{3} == multiple_pitch.parameters.days{4}
    display('Sorry, need to have at least two days before you can run this program')
    return
else
end




%% Making structures for results of pitch contour and FF analysis

fprintf('\nCalculating pitch contours...')

for i = 1:length(multiple_pitch.parameters.syllables)
    for j = multiple_pitch.parameters.days{3}:multiple_pitch.parameters.days{4}
        
        %if ~isempty checks to see if cell has been made
        %for this bird, syllable, and day
        try
            iscell(multiple_pitch.fvalsstr_all.(multiple_pitch.parameters.syllables(i)){j-multiple_pitch.parameters.days{3}+1});
        catch err
            multiple_pitch.fvalsstr_all.(multiple_pitch.parameters.syllables(i)){j-multiple_pitch.parameters.days{3}+1} = {};
        end
        
        try
            iscell(multiple_pitch.fvalsstr_forpc_all.(multiple_pitch.parameters.syllables(i)){j-multiple_pitch.parameters.days{3}+1});
        catch err
            multiple_pitch.fvalsstr_forpc_all.(multiple_pitch.parameters.syllables(i)){j-multiple_pitch.parameters.days{3}+1} = {};
        end
        
        try
            iscell(multiple_pitch.pc_all.(multiple_pitch.parameters.syllables(i)){j-multiple_pitch.parameters.days{3}+1});
        catch err
            multiple_pitch.pc_all.(multiple_pitch.parameters.syllables(i)){j-multiple_pitch.parameters.days{3}+1} = {};
        end
        
    end
end


%% Calculating pitch contours


% this part takes a long time to process (specifically, the jc_pitchcontour
% analysis)

curr_directory = pwd;

for i = 1:length(multiple_pitch.parameters.syllables)
    for j = multiple_pitch.parameters.days{3}:multiple_pitch.parameters.days{4}
        
        %if ~isempty checks to see if findnote2tw or jc_pitchcontour
        %has been performed on this bird, syllable, and day
        try
            cd([multiple_pitch.parameters.computer '/' multiple_pitch.parameters.nameofbird '/all_calls/' datestr(j, 'ddmmmyyyy')])
            try
                if ~isempty(multiple_pitch.fvalsstr_all.(multiple_pitch.parameters.syllables(i)){j-multiple_pitch.parameters.days{3}+1})
                    continue
                else
                    [multiple_pitch.fvalsstr_all.(multiple_pitch.parameters.syllables(i)){j-multiple_pitch.parameters.days{3}+1}] =...
                        findwnote2tw([multiple_pitch.parameters.nameofbird '_' ...
                        datestr(j, 'ddmmmyyyy')],...
                        multiple_pitch.parameters.syllables(i),'',...
                        multiple_pitch.parameters.refractory_period.(multiple_pitch.parameters.syllables(i)),...
                        multiple_pitch.parameters.frequency_range.(multiple_pitch.parameters.syllables(i)),1024,0,'obs0');
                end
            catch err
                continue
            end
            
            try
                if ~isempty(multiple_pitch.fvalsstr_forpc_all.(multiple_pitch.parameters.syllables(i)){j-multiple_pitch.parameters.days{3}+1})
                    continue
                else
                    [multiple_pitch.fvalsstr_forpc_all.(multiple_pitch.parameters.syllables(i)){j-multiple_pitch.parameters.days{3}+1}] =...
                        findwnote2tw([multiple_pitch.parameters.nameofbird '_' ...
                        datestr(j, 'ddmmmyyyy')],...
                        multiple_pitch.parameters.syllables(i),'',-0.016,...
                        multiple_pitch.parameters.frequency_range.(multiple_pitch.parameters.syllables(i)),8000,0,'obs0');
                end
            catch err
                continue
            end
            
            try
                if ~isempty(multiple_pitch.pc_all.(multiple_pitch.parameters.syllables(i)){j-multiple_pitch.parameters.days{3}+1})
                    continue
                else
                    multiple_pitch.pc_all.(multiple_pitch.parameters.syllables(i)){j-multiple_pitch.parameters.days{3}+1} = ...
                        jc_pitchcontourFV(multiple_pitch.fvalsstr_forpc_all.(multiple_pitch.parameters.syllables(i)){j-multiple_pitch.parameters.days{3}+1},...
                        1024,1020,1, min(multiple_pitch.parameters.frequency_range.(multiple_pitch.parameters.syllables(i))),...
                        max(multiple_pitch.parameters.frequency_range.(multiple_pitch.parameters.syllables(i))),[1 2],'obs0');
                end
            catch err
                continue
            end
            
            cd([multiple_pitch.parameters.computer '/' multiple_pitch.parameters.nameofbird '/all_calls'])
        catch err
            display([ datestr(j, 'ddmmmyyyy') ' is missing'])
            continue
        end
    end
end

cd(curr_directory)
clear curr_directory

fprintf('done!\n')


%% Figure of pitch contour comparing mean (and sd) over time

fprintf('\nCreating figures of pitch contours over time...')

for i = 1:length(multiple_pitch.parameters.syllables)
    figure(i), hold on
    title([multiple_pitch.parameters.nameofbird '   duration: '...
        num2str(multiple_pitch.parameters.days{4}-multiple_pitch.parameters.days{3}+1) ' days'...
        '   syllable: ' multiple_pitch.parameters.syllables(i)])
    xlabel('Time (10^-4 sec)')
    ylabel('Frequency (Hz)')
    for j = multiple_pitch.parameters.days{3}:multiple_pitch.parameters.days{4}
        %plots the mean
        try
            plot(mean(multiple_pitch.pc_all.(multiple_pitch.parameters.syllables(i)){j-multiple_pitch.parameters.days{3}+1}'),...
                'Linewidth',2,...
                'Color',[1-(j-multiple_pitch.parameters.days{3})./(multiple_pitch.parameters.days{4} - multiple_pitch.parameters.days{3})...
                0 0+(j-multiple_pitch.parameters.days{3})./(multiple_pitch.parameters.days{4} - multiple_pitch.parameters.days{3})])
            %             %plots mean + sd
            %             plot(mean(pc_all.(nameofbirds{jj}).(syllables{jj}(i)){j-days.(nameofbirds{jj}){3}+1}')...
            %                 +std(pc_all.(nameofbirds{jj}).(syllables{jj}(i)){j-days.(nameofbirds{jj}){3}+1}'),...
            %                 'Color',[1-(j-days.(nameofbirds{jj}){3})./(days.(nameofbirds{jj}){4} - days.(nameofbirds{jj}){3})...
            %                 0 0+(j-days.(nameofbirds{jj}){3})./(days.(nameofbirds{jj}){4} - days.(nameofbirds{jj}){3})])
            %             %plots mean -sd
            %              plot(mean(pc_all.(nameofbirds{jj}).(syllables{jj}(i)){j-days.(nameofbirds{jj}){3}+1}')...
            %                 -std(pc_all.(nameofbirds{jj}).(syllables{jj}(i)){j-days.(nameofbirds{jj}){3}+1}'),...
            %                 'Color',[1-(j-days.(nameofbirds{jj}){3})./(days.(nameofbirds{jj}){4} - days.(nameofbirds{jj}){3})...
            %                 0 0+(j-days.(nameofbirds{jj}){3})./(days.(nameofbirds{jj}){4} - days.(nameofbirds{jj}){3})])
        catch err
            continue
        end
    end
    saveas(figure(i), [multiple_pitch.parameters.computer '/all_calls_analysis_pitch/' multiple_pitch.parameters.experiment_type...
        multiple_pitch.parameters.nameofbird ...
        '/PC_over_time_' multiple_pitch.parameters.nameofbird '_' 'duration_'...
        num2str(multiple_pitch.parameters.days{4}-multiple_pitch.parameters.days{3}+1)...
        'days' '_' multiple_pitch.parameters.syllables(i)], 'fig')
end

fprintf('done!\n')

%% Variable for time range for calculating FF

% need to enter time range to calculate entropy, use the entropy contour figure to
% determine the best time range.

for i = 1:length(multiple_pitch.parameters.syllables)
    if isfield(multiple_pitch.parameters, 'time_range') == 1
        if isfield(multiple_pitch.parameters.time_range, multiple_pitch.parameters.syllables(i)) == 1
            if strcmpi(input(['Do you want to select a new time range for ' multiple_pitch.parameters.syllables(i) '?\n'...
                      'Current range:  [' num2str(multiple_pitch.parameters.time_range.(multiple_pitch.parameters.syllables(i))) ']  ' ],'s'),'y')
                multiple_pitch.parameters.time_range.(multiple_pitch.parameters.syllables(i)) =...
                    input(['Start and stop time for FF plotting of ' multiple_pitch.parameters.nameofbird...
                    ' ' multiple_pitch.parameters.syllables(i) '?\n(format [start stop])  ']);

                multiple_pitch.FF = rmfield(multiple_pitch.FF,multiple_pitch.parameters.syllables(i));
                
            else
            end
        else
           multiple_pitch.parameters.time_range.(multiple_pitch.parameters.syllables(i)) =...
            input(['Start and stop time for FF plotting of ' multiple_pitch.parameters.nameofbird...
            ' ' multiple_pitch.parameters.syllables(i) '?\n(format [start stop])  ']);
        end
    else
        multiple_pitch.parameters.time_range.(multiple_pitch.parameters.syllables(i)) =...
            input(['Start and stop time for FF plotting of ' multiple_pitch.parameters.nameofbird...
            ' ' multiple_pitch.parameters.syllables(i) '?\n(format [start stop])  ']);
    end
end

%% FF Plots over several days



% Calculates FF value, time during day, and gets rid of outliers
fprintf('\nCalculating FF over time and getting rid of outliers...')
for i = 1:length(multiple_pitch.parameters.syllables)
    for j = multiple_pitch.parameters.days{3}:multiple_pitch.parameters.days{4}
        try
            %calculates time of note during the day
            multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).time_and_FF{j-multiple_pitch.parameters.days{3}+1}(:,1) = ...
                (db_timing4(multiple_pitch.fvalsstr_all.(multiple_pitch.parameters.syllables(i)){j-multiple_pitch.parameters.days{3}+1})-...
                floor(db_timing4(multiple_pitch.fvalsstr_all.(multiple_pitch.parameters.syllables(i)){1}(1)))-...
                multiple_pitch.parameters.duration.begin);
            
            %calculates FF of each note during day
            multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).time_and_FF{j-multiple_pitch.parameters.days{3}+1}(:,2) = ...
                mean(multiple_pitch.pc_all.(multiple_pitch.parameters.syllables(i)){j-multiple_pitch.parameters.days{3}+1} ...
                (min(multiple_pitch.parameters.time_range.(multiple_pitch.parameters.syllables(i))):...
                max(multiple_pitch.parameters.time_range.(multiple_pitch.parameters.syllables(i))),:))';
            
            %gets rid of outliers (Tukey's method)
            [multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).time_and_FF{j-multiple_pitch.parameters.days{3}+1} ...
                multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).outliers_high{j-multiple_pitch.parameters.days{3}+1}...
                multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).outliers_low{j-multiple_pitch.parameters.days{3}+1}] = ...
                db_tukey_outlier(multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).time_and_FF{j-multiple_pitch.parameters.days{3}+1},2);
            
            %calculates mean for day
            multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).mean_FF{j-multiple_pitch.parameters.days{3}+1} = ...
                mean(multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).time_and_FF{j-multiple_pitch.parameters.days{3}+1}(:,2));
            
            %calculates sd for day
            multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).sd_FF{j-multiple_pitch.parameters.days{3}+1} = ...
                std(multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).time_and_FF{j-multiple_pitch.parameters.days{3}+1}(:,2));
            
        catch err
            % print(num2str(j))
            continue
        end
    end
end
fprintf('done!\n')

%Calculates baseline pitch
fprintf('\nCalculating baseline FF...')
for i = 1:length(multiple_pitch.parameters.syllables)
    %calcualtes baseline frequency (kHz), sd (kHz), and cv
    try
        for j = 1:multiple_pitch.parameters.duration.begin
            temp_base.mean{j} = multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).mean_FF{j};
        end
        temp_base.mean = temp_base.mean(~cellfun('isempty',temp_base.mean));
        temp_base.mean = cell2mat(temp_base.mean);
        multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).baseline_mean = mean(temp_base.mean);
    catch err
        continue
    end
    
    clear('temp_base')
    
end
fprintf('done!\n')

    
%Determining the color for the various conditions (grey = preWN, red =
%shift, blue = consolidation, black = postWN)
fprintf('\nDetermining color of each day according to epoch during paradigm...')
for i = 1:length(multiple_pitch.parameters.syllables)
    for j = 1:multiple_pitch.parameters.days{4}-multiple_pitch.parameters.days{3}+1
        if j <= multiple_pitch.parameters.duration.begin
            multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).color{j} = [.6 .6 .6];
        elseif j > multiple_pitch.parameters.duration.begin && j <= multiple_pitch.parameters.duration.begin+multiple_pitch.parameters.duration.shift
            multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).color{j} = [1 0 0];
        elseif j > multiple_pitch.parameters.duration.begin+multiple_pitch.parameters.duration.shift &&...
                j <= multiple_pitch.parameters.duration.begin+multiple_pitch.parameters.duration.shift+multiple_pitch.parameters.duration.consolidation
            multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).color{j} = [0 0 1];
        elseif j > multiple_pitch.parameters.duration.begin+multiple_pitch.parameters.duration.shift+multiple_pitch.parameters.duration.consolidation
            multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).color{j} = [.3 .3 .3];
        end
    end
end
fprintf('done!\n')


% Makes a figure of FF for each day during learning
fprintf('\nCreating figures of FF over time...')
for i = 1:length(multiple_pitch.parameters.syllables)
    figure(), hold on
    title([multiple_pitch.parameters.nameofbird '   duration: ' num2str(multiple_pitch.parameters.days{4}-multiple_pitch.parameters.days{3}+1)...
        ' days   syllable: ' multiple_pitch.parameters.syllables(i)])
    ylabel('Frequency (Hz)')
    xlabel('Time (days)')
    if isempty(multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).time_and_FF{end}) == 0
        xlim([-1-multiple_pitch.parameters.duration.begin...
            ceil(multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).time_and_FF{end}(end,1))+1])
    else
        xlim([-1-multiple_pitch.parameters.duration.begin ...
           -1-multiple_pitch.parameters.duration.begin + length(multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).time_and_FF)])
    end
    for j = multiple_pitch.parameters.days{3}:multiple_pitch.parameters.days{4}
        try

            %plots FF for time range
            plot(multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).time_and_FF{j-multiple_pitch.parameters.days{3}+1}(:,1),...
                multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).time_and_FF{j-multiple_pitch.parameters.days{3}+1}(:,2),...
                '.',...
                'Color', multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).color{j-multiple_pitch.parameters.days{3}+1})
            
            %plots FF mean per day
            plot(median(multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).time_and_FF{j-multiple_pitch.parameters.days{3}+1}(:,1)),...
                multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).mean_FF{j-multiple_pitch.parameters.days{3}+1},...
                'ko',...
                'MarkerFaceColor','k',...
                'LineWidth',2)
            
            %plots FF sd per day
            errorbar(median(multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).time_and_FF{j-multiple_pitch.parameters.days{3}+1}(:,1)),...
                multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).mean_FF{j-multiple_pitch.parameters.days{3}+1},...
                multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).sd_FF{j-multiple_pitch.parameters.days{3}+1},...
                'ko',...
                'LineWidth',2)
            

        catch err
            continue
        end
    end
    
    %plots lines for WN begin, consolidation begin, and WN end
    %line for WN begin 
    try
        line([0-.25 0-.25],...
            get(gca, 'YLim'),...
            'Color', [0 0 0],...
            'LineStyle', '--')
    catch err
        continue
    end
    %line for consolidation begin
    try
        line([multiple_pitch.parameters.duration.shift-.25...
            multiple_pitch.parameters.duration.shift-.25],...
            get(gca, 'YLim'),...
            'Color', [0 0 0],...
            'LineStyle', '--')
    catch err
        continue
    end
    %line for WN end
    try
        line([multiple_pitch.parameters.duration.shift+multiple_pitch.parameters.duration.consolidation-.25...
            multiple_pitch.parameters.duration.shift+multiple_pitch.parameters.duration.consolidation-.25],...
            get(gca, 'YLim'),...
            'Color', [0 0 0],...
            'LineStyle', '--')
    catch err
        continue
    end
    %line for baseline pitch
    try
        line(get(gca, 'XLim'),...
            [multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).baseline_mean...
            multiple_pitch.FF.(multiple_pitch.parameters.syllables(i)).baseline_mean],...
            'Color', [.3 .3 .3],...
            'LineStyle', '--')
    catch err
        continue
    end
    
    
    
    saveas(figure(gcf), [multiple_pitch.parameters.computer '/all_calls_analysis_pitch/' multiple_pitch.parameters.experiment_type...
        multiple_pitch.parameters.nameofbird...
        '/FF_over_time_' multiple_pitch.parameters.nameofbird '_' 'duration_'...
         num2str(multiple_pitch.parameters.days{4}-multiple_pitch.parameters.days{3}+1)...
        'days' '_' multiple_pitch.parameters.syllables(i)], 'fig')
end
fprintf('done!\n')


%% Save workspace

clear i
clear j

fprintf('\nSaving data...')

save([multiple_pitch.parameters.computer '/all_calls_analysis_pitch/' multiple_pitch.parameters.experiment_type...
        multiple_pitch.parameters.nameofbird '/' multiple_pitch.parameters.nameofbird '.mat'], 'multiple_pitch', '-v7.3')

fprintf('done!\n')

%% Do want to run db_FF_mult_bootstrap

run_FF = input('Do you want to run FF_mult_bootstrap?  (y or n)  ', 's');

if strcmpi(run_FF,'y') == 1
    close all
    clear all
    db_FF_mult_bootstrap
else
    clear run_FF
    return
end