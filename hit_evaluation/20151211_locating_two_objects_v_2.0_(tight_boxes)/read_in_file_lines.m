function [ lines ] = read_in_file_lines( file )

fid   = fopen(file,'r');
lines = textscan(fid,'%s',-1,'delimiter',{'\n'});
lines = lines{1};
lines = transpose(lines);
fclose(fid);

end
