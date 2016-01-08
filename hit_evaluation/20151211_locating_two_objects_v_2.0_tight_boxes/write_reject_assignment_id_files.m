function [] = write_reject_assignment_id_files(threshold, sample_result_file_name, result_file_name)
    reject_dir = './approve_reject/';
    reject_id_file_name = 'reject_assignment_ids.txt';
    
    if ~exist(reject_dir,'dir')
        mkdir(reject_dir);
    end
    
    % TODO: also examine the second set of coordinates, in this case, around the bicycles    
    [ assignment_id, image_url, coord_first, coord_second, worker_id, hit_id, duration ] = parse_result(result_file_name);
    [ Sassignment_id, Simage_url, Scoord_first, Scoord_second, Sworker_id, Shit_id, Sduration ] = parse_result(sample_result_file_name);
    
    % obtaining sample entry urls
    for i = 1 : numel(Simage_url)
        sample_entry_url{i} = Simage_url{i};
    end
    sample_entry_url = sample_entry_url{1};
    
    % auto-rejecting
    [ave, reject_or_approve] ...
        = generate_approve_reject(threshold, sample_entry_url, ...
                                  Scoord_first{1}, Scoord_second{1}, ...
                                  assignment_id, image_url, ...,
                                  coord_first, coord_second);
    
    % writing reject file
    rejectCount = 0;
    reject_id{1} = [];
    for i = 1 : numel(reject_or_approve)
        if reject_or_approve(i) == 1
            rejectCount = rejectCount + 1;
            reject_id{rejectCount} = assignment_id{i};
        end
    end
    
    fprintf('\nWARNING: %d out of %d individual assignments will be rejected.\nThe rejected assignments are: \n', ...
            rejectCount, numel(assignment_id));
    
    fullfilename = fullfile(reject_dir, reject_id_file_name);
    fid = fopen(fullfilename,'w');
    for i = 1:numel(reject_id)
        fprintf(fid,'%s',reject_id{i});
        fprintf('%d. %s\n',i, reject_id{i});
        if i ~= numel(reject_id)
            fprintf(fid,'\n');
        end
    end
    fclose(fid);
    
end