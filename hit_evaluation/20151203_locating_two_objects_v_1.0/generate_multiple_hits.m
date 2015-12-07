function [ new_lines ] = generate_multiple_hits( lines, number_of_hits )

% setting up delimiters
quotation_mark = '"';
comma = ',';

group_line_number = floor(numel(lines) / (number_of_hits));
%residual_line_number = mod(numel(lines), (number_of_hits));

for i = 1 : number_of_hits
    new_line = '[';
    for j = 1 : group_line_number - 1
        new_line = strcat(new_line, quotation_mark,lines{(i-1)*group_line_number + j},quotation_mark,comma);
    end
    new_line = strcat(new_line, quotation_mark, lines{i*group_line_number}, quotation_mark);
    new_line = strcat(new_line, ']');
    new_lines{i} = new_line;
end

%{
new_line = '[';
for j = 1 : residual_line_number - 1
    new_line = strcat(new_line, quotation_mark,lines{number_of_hits*group_line_number + j},quotation_mark,comma);
end
new_line = strcat(new_line, quotation_mark, lines{numel(lines)}, quotation_mark);
new_line = strcat(new_line, ']');
new_lines{number_of_hits + 1} = new_line;
%}

end
