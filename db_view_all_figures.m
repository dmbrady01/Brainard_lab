function [ ] = db_view_all_figures( )
%db_view_all_figures Opens all figures in the current workspace, even
%hidden ones.
%   Uses findall to find figures, then sets them to 'visible'

%finds all figures in current working environment
list_of_figures = findall(0,'type','fig');

%sets visible to 'on'
for i = 1:length(list_of_figures)
    set(i,'visible','on');
end


end

