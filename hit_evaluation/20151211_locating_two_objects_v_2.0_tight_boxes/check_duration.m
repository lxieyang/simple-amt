function [ ] = check_duration(result_file)
    [assignment_id, ...
            image_url, ...
            coord_first, ...
            coord_second, ...
            worker_id, ...
            hit_id, ...
            duration] = parse_result(result_file);
    total = 0;
    min = duration{1};
    min_loc = 1;
    max = duration{1};
    max_loc = 1;
    for i = 1 : numel(duration)
        total = total + duration{i};
        if min > duration{i}
            min = duration{i};
            min_loc = i;
        end
        if max < duration{i}
            max = duration{i};
            max_loc = i;
        end
    end
    
    ave = total / numel(duration);
    fprintf('The average time used to complete each hit is %.2f sec;\n', ave);
    fprintf('Worker %s took the LONGEST time (%.2f sec) on hit %s;\n', worker_id{max_loc}, duration{max_loc}, hit_id{max_loc});
    fprintf('Worker %s took the SHORTEST time (%.2f sec) on hit %s;\n', worker_id{min_loc}, duration{min_loc}, hit_id{min_loc});
    
end