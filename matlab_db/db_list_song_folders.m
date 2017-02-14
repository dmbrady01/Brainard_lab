function [song_folders] = db_list_song_folders(phrase, varargin )
%db_list_song_folders List folders that have songs in them (but must be
%organized in the DB way, (the date is first)). Ex: 020313_WN_day1 will be
%recognized as a song folder. Second input (optional) is omit number (how many folders
%from most recent date should be omitted). Third input (optional) is the directory to
%run the program in.
%   If no input is given will run on current directory and omit = 0, otherwise will run
%   on specified directory. Lists all folders and files in directory, finds
%   folder with the date first and specifies them as a song folder. Makes a
%   text file with the list of folders. Makes a .mat file with standardized
%   dates.

%if a directory is not specified, it will use the current directory. If
%omit is not specified, it will set it to zero. Omit is the number of songs
%folders from most recent you do not want to include in your list.
if isempty(varargin) == 1
    directory = pwd;
    omit = 0;
elseif length(varargin) == 1
    omit = varargin{1};
    directory = pwd;
elseif length(varargin) == 2
    omit = varargin{1};
    directory = varargin{2};
end

%gets directory list from 'directory'
list_all = dir([directory '/*' phrase '*']);

%makes a list of the folders
j = 1;
for i = 1:length(list_all)
    if list_all(i).isdir == 1 && strcmpi(list_all(i).name,'.') == 0 && strcmpi(list_all(i).name,'..') == 0
        folders{j} = list_all(i).name;
        j = j+1;
    end
end
folders = folders';


%goes through each folder to see if there are songs in it
j = 1;
for i = 1:max(size(folders))
    %gets the list of filenames in the folder of interest
    folder_contents = db_list_folder_contents([directory '/' folders{i}]);
    
    %see if there is a .cbin file in the folder, if so, the name of the
    %folder is written into 'song_folders_phrase.txt'
    if sum(~cellfun('isempty',strfind(folder_contents, '.cbin'))) > 0
        %for the text file
        text_folders{j} = folders{i};
        
        
        %puts date of folder in standard format (ex: 13Mar2013)
        underscore = strfind(folders{i},'_');
        raw_date = folders{i}(1:underscore(1)-1);
        month = str2double(raw_date(1:2));
        day = str2double(raw_date(3:4));
        year = str2double(['20' raw_date(5:end)]);
        
        song_folders{j} = datestr(datenum(year,month,day),'ddmmmyyyy');
        
        j = j+1;
       
    else
    end
end
song_folders = song_folders(1:end-omit);
song_folders = song_folders';

%creates a text file called
fid = fopen([directory '/song_folders_' phrase '.txt'],'w');
for i = 1:length(text_folders)
    %writes the folder name into the txt file
    fprintf(fid, '%s\n', text_folders{i});
end
    


fclose(fid);
save([directory '/song_folders_' phrase '.mat'],'song_folders')

end

