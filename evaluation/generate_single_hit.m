function [ new_line ] = generate_single_hit( lines )

% setting up delimiters
quotation_mark = '"';
comma = ',';

% processing all but the last line
new_line = '[';
for i = 1 : numel(lines) - 1
    new_line = strcat(new_line, quotation_mark,lines{i},quotation_mark,comma);
end
% dealing with the last line
new_line = strcat(new_line, quotation_mark, lines{numel(lines)}, quotation_mark);
new_line = strcat(new_line, ']');

end

