function [ ] = db_open_figures_in_folder( varargin )
%db_open_figures_in_folder Opens all the figures in a specified folder
%default is current working directory. Otherwise, specify path.

if nargin == 0
    directory = pwd;
else
    directory = varargin{1};
end

list_of_figures = dir([directory '/*.fig']);

for i = 1:length(list_of_figures)
    openfig(list_of_figures(i).name)
end

db_view_all_figures()


end

