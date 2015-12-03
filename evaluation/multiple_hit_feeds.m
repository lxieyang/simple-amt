function [ new_lines ] = multiple_hit_feeds(lines, number_of_imgs, number_of_hits)
    
    sample_idx = [ 2 5 19 21 29 70 ];
    number_of_sample = 6;
    
    for i = 1 : numel(sample_idx)
        sample_entry{i} = lines{sample_idx(i)};
        lines{sample_idx(i)} = [];
    end
    
    size = numel(lines);
    i = 1;
    while i <= size
        if (numel(lines{i}) == 0)
            lines(:, i) = [];
        end
        i = i + 1;
        size = numel(lines);
    end
    
    selected_idx = generate_random_int(number_of_imgs - number_of_sample, 0, numel(lines));
    
    group_line_number = floor((number_of_imgs - number_of_sample) / number_of_hits);
    group_sample_number = floor(number_of_sample / number_of_hits);
    
    for i = 1 : number_of_hits
        for it = 1 : group_sample_number
            selected_lines{it} = sample_entry{(i - 1) * group_sample_number + it};
        end
        %selected_lines{1} = sample_entry{mod(i, number_of_sample)};
        %selected_lines{2} = sample_entry{mod(i+1, number_of_sample)};
        %selected_lines{3} = sample_entry{mod(i+2, number_of_sample)};
        for jj = 1 : group_line_number
            selected_lines{group_sample_number + jj} = lines{selected_idx((i-1)*group_line_number + jj)};
        end
        new_lines{i} = generate_single_hit(selected_lines);
        while numel(selected_lines) > 0
            selected_lines(:,1) = [];
        end
    end

end