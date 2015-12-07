function [] = write_approve_and_reject_id_files(url_file_name, sample_coord_result_file_name, result_file_name, threshold, ...
                                                approve_id_file_name, reject_id_file_name)
    [ assignment_id, image_url, coord_first, coord_second, worker_id, hit_id ] = parse_result(result_file_name);
    [ Sassignment_id, Simage_url, Scoord_first, Scoord_second, Sworker_id, Shit_id ] = parse_result(sample_coord_result_file_name);
    sample_entry = generate_sample_entry(url_file_name);
    [ave, roj] = generate_approve_reject(sample_entry, Scoord_first{1}, threshold, assignment_id, image_url, coord_first, coord_second, worker_id, hit_id);
    
    approveCount = 0;
    rejectCount = 0;
    approve_id{1} = [];
    reject_id{1} = [];
    for i = 1 : numel(roj)
        if roj(i) == 1
            rejectCount = rejectCount + 1;
            reject_id{rejectCount} = hit_id{i};
        else
            approveCount = approveCount + 1;
            approve_id{approveCount} = hit_id{i};
        end
    end
    
    write_multiple_hit_file(approve_id_file_name, approve_id);
    write_multiple_hit_file(reject_id_file_name, reject_id);
    
    
end