function [ave, reject_or_approve] ...
            = generate_approve_reject(sample_entry, sample_coord, threshold, assignment_id, image_url, ... 
                                    coord_first, coord_second, worker_id, hit_id)
    for i = 1 : numel(assignment_id)
        for j = 1 : numel(image_url{i})
            count = 0;
            for k = 1 : numel(sample_entry)
                if strcmp(char(sample_entry{k}), char(image_url{i}{j}))
                    count = count + 1;
                    [percentage{i}(count), temp(count)] = reject_by_intersection_union(sample_coord{k}, coord_first{i}{j}, threshold);
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