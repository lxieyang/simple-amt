function [ assignment_id, ...
            image_url, ...
            coord_first, ...
            coord_second, ...
            worker_id, ...
            hit_id ] = parse_single_line(result_line)
    % locating assignment_id        
    asId_loc = strfind(result_line, '"');
    assignment_id = result_line(asId_loc(3) + 1 : asId_loc(4) - 1);
    
    leftBracket_loc = strfind(result_line, '[');
    rightBracket_loc = strfind(result_line, ']');
    urlAndCoord = result_line(leftBracket_loc + 1 : rightBracket_loc - 1);
    
    % breaking up each img
    lefts = strfind(urlAndCoord, '{');
    rights = strfind(urlAndCoord, '}');
    num_of_imgs = numel(lefts);
    for i = 1 : num_of_imgs
        % ioslating each img and its annotations
        tempUrlAndCoord{i} = urlAndCoord(lefts(i) + 1 : rights(i) - 1); 
        
        % extract url infor
        quotation_loc = strfind(tempUrlAndCoord{i}, '"');
        image_url{i} = tempUrlAndCoord{i}(quotation_loc(3) + 1 : quotation_loc(4) - 1);
        
        % extract coords
        tempUrlAndCoord{i} = tempUrlAndCoord{i}(quotation_loc(7) + 2 : quotation_loc(8) - 1);
        vert_loc = strfind(tempUrlAndCoord{i}, '|');
        tempCoordFirst{i} = tempUrlAndCoord{i}(1 : vert_loc - 2);
        tempCoordSecond{i} = tempUrlAndCoord{i}(vert_loc + 3 : numel(tempUrlAndCoord{i}));
        
        
        tempCoordFirst{i} = strrep(tempCoordFirst{i}, '(', '');
        tempCoordFirst{i} = strrep(tempCoordFirst{i}, ')', '');
        tempCoordFirst{i} = strrep(tempCoordFirst{i}, ',', '');
        first{i} = strsplit(tempCoordFirst{i});
        
        tempCoordSecond{i} = strrep(tempCoordSecond{i}, '(', '');
        tempCoordSecond{i} = strrep(tempCoordSecond{i}, ')', '');
        tempCoordSecond{i} = strrep(tempCoordSecond{i}, ',', '');
        second{i} = strsplit(tempCoordSecond{i});
        
        for j = 1 : floor(numel(first{i}) / 2)
            coord_first{i}(j, 1) = str2num(char(first{i}(2 * j - 1)));
            coord_first{i}(j, 2) = str2num(char(first{i}(2 * j)));
        end
        
        for k = 1 : floor(numel(second{i}) / 2)
            coord_second{i}(k, 1) = str2num(char(second{i}(2 * k - 1)));
            coord_second{i}(k, 2) = str2num(char(second{i}(2 * k)));
        end
    end
    
    % locating worker id
    workerId_loc = strfind(result_line, '"worker_id":');
    workerAndHitId = result_line(workerId_loc : numel(result_line));
    quotation_loc = strfind(workerAndHitId, '"');
    worker_id = workerAndHitId(quotation_loc(3) + 1 : quotation_loc(4) - 1);
    hit_id = workerAndHitId(quotation_loc(7) + 1 : quotation_loc(8) - 1);

end