function [ave, reject_or_approve] ...
         = generate_approve_reject(threshold, sample_entry_url, ...
                                   sample_coord_first, sample_coord_second, ...
                                   assignment_id, image_url, ... 
                                   coord_first, coord_second)
    for i = 1 : numel(assignment_id)
        for j = 1 : numel(image_url{i})
            count = 0;
            for k = 1 : numel(sample_entry_url)
                if strcmp(char(sample_entry_url{k}), char(image_url{i}{j}))
                    count = count + 1;
                    [percent_first, temp_first] ...
                        = reject_by_intersection_union(sample_coord_first{k}, ...
                                                       coord_first{i}{j}, threshold);
                    [percent_second, temp_second] ...
                        = reject_by_intersection_union(sample_coord_second{k}, ...
                                                       coord_second{i}{j}, threshold);  
                    percentage{i}(count) = (percent_first + percent_second) / 2;
                    break;
                end
            end
        end
        ave(i) = sum(percentage{i}) / numel(percentage{i});
        if(ave(i) > threshold)
            reject_or_approve(i) = 0;
        else
            reject_or_approve(i) = 1;
        end
    end

end