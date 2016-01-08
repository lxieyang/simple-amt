function [ assignment_id, ...
            image_url, ...
            coord_first, ...
            coord_second, ...
            worker_id, ...
            hit_id, ...
            duration] = parse_single_line(result_line)
    % locating hit_id
    asId_loc = strfind(result_line, '"');
    hit_id = result_line(asId_loc(3) + 1 : asId_loc(4) - 1);
    
    % locating assignment_id        
    assignment_id = result_line(asId_loc(7) + 1 : asId_loc(8) - 1);
    
    % locating worker_id
    worker_id = result_line(asId_loc(15) + 1 : asId_loc(16) - 1);
    
    % locating accept time and submit time
    accept_time = result_line(asId_loc(19) + 1 : asId_loc(20) - 1);
    submit_time = result_line(asId_loc(11) + 1 : asId_loc(12) - 1);
    acc_t = [str2num(accept_time(1 : 4)) ... % year
             str2num(accept_time(6 : 7)) ... % month
             str2num(accept_time(9 : 10)) ... % date
             str2num(accept_time(12 : 13)) ... % hour
             str2num(accept_time(15 : 16)) ... % minute
             str2num(accept_time(18 : 19)) ... % second
             ];
    sub_t = [str2num(submit_time(1 : 4)) ... % year
             str2num(submit_time(6 : 7)) ... % month
             str2num(submit_time(9 : 10)) ... % date
             str2num(submit_time(12 : 13)) ... % hour
             str2num(submit_time(15 : 16)) ... % minute
             str2num(submit_time(18 : 19)) ... % second
             ];
    duration = etime(sub_t, acc_t);
    
    
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


end