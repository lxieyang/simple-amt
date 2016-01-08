function [ percentage, reject ] = reject_by_intersection_union(sample_coord, test_coord, threshold)
    
    % first rect
    % max_x_1 = max(sample_coord(:,1));
    % min_x_1 = min(sample_coord(:,1));
    % max_y_1 = max(sample_coord(:,2));
    % min_y_1 = min(sample_coord(:,2));
    max_x_1 = sample_coord(4,1);
    min_x_1 = sample_coord(1,1);
    max_y_1 = sample_coord(2,2);
    min_y_1 = sample_coord(1,2);
    sample_side_1 = max_x_1 - min_x_1;
    sample_side_2 = max_y_1 - min_y_1;
    sample_area = sample_side_1 * sample_side_2;
    %second rect
    % max_x_2 = max(test_coord(:,1));
    % min_x_2 = min(test_coord(:,1));
    % max_y_2 = max(test_coord(:,2));
    % min_y_2 = min(test_coord(:,2));
    max_x_2 = test_coord(4,1);
    min_x_2 = test_coord(1,1);
    max_y_2 = test_coord(2,2);
    min_y_2 = test_coord(1,2);
    test_side_1 = max_x_2 - min_x_2;
    test_side_2 = max_y_2 - min_y_2;
    test_area = test_side_1 * test_side_2;
    
    if (max_x_1 <= min_x_2) || (max_y_1 <= min_y_2) || (max_x_2 <= min_x_1) || (max_y_2 <= min_y_1)
        percentage = 0;
    else
        intersection = (min(max_y_1,max_y_2) - max(min_y_1,min_y_2))*(min(max_x_1,max_x_2) - max(min_x_1,min_x_2));
        union = test_area + sample_area - intersection;
        percentage = intersection / union;
    end
    
    if percentage < threshold
        reject = 1;
    else
        reject = 0;
    end
    
end