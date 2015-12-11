function [sample_entry] = generate_sample_entry(file_name)
    sample_idx = [ 2 5 19 21 29 70 ];
    lines = read_in_file_lines(file_name);
    
    for i = 1 : numel(sample_idx)
        sample_entry{i} = lines{sample_idx(i)};
    end
end