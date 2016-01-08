% this function performs visualization of the annotations. It could get
% inefficient when used with writing rejecting file simultaneously.

function [] = visualization(sample_result_file_name, result_file_name)
    [ assignment_id, image_url, coord_first, coord_second, worker_id, hit_id, duration ] ...
        = parse_result(result_file_name);
    [ Sassignment_id, Simage_url, Scoord_first, Scoord_second, Sworker_id, Shit_id, Sduration ] ...
        = parse_result(sample_result_file_name);
    % obtaining sample entry urls
    for i = 1 : numel(Simage_url)
        sample_entry_url{i} = Simage_url{i};
    end
    sample_entry_url = sample_entry_url{1};
    
    vis_im_name = 'Asgmnt_';
    
    vis_polygon(assignment_id, image_url, vis_im_name, coord_first, coord_second, ...
                          Scoord_first{1}, Scoord_second{1}, sample_entry_url);
end
