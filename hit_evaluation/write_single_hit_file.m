function [  ] = write_single_hit_file( file, hit_line )

fid = fopen(file,'w');
fprintf(fid, '%s', hit_line);
fprintf(fid,'\n');
fclose(fid);

end

