%% nodeGen: generates the nodes based on a Grouch json file

function nodeGen(fname, outname)
    data = loadjson(fname);
    ind = [];
    groups = {};
    for x = 1:length(data)
        st = data{x};
        [group, num] = strtok(data{x}.identifier);
        if any(contains(data{x}.fullname,{'Special Topics', 'Special Problems', 'Undergrad', 'Graduate', 'Research', 'Seminar'})) ...
            || ~isfield(data{x}, 'sections') ...
            || any(num == 'X') ...
            || str2num(num) > 5000 ...
            || (isfield(data{x}, 'restrictions') && isfield(data{x}.restrictions, 'Campuses') && ~contains(data{x}.restrictions.Campuses.requirements, 'Atlanta'))
            ind = [ind, x];
        end
        groups = [groups, group];
    end
    fhin = fopen(fname);
    fhout = fopen(outname, 'w');
    fprintf(fhout, 'var nodes = ');
    line = fgets(fhin);
    linenum = 0;
    while ischar(line)
        if all(ind-linenum ~= 0)
            if length(line) > 20
                line = [line(1:end-4), ', "level": ', groups{1}, line(end-3:end)];
                groups(1) = [];
            end
            fprintf(fhout, line);
        end
        linenum = linenum + 1;
        line = fgets(fhin);
    end
    fprintf(fhout, ';');
    fclose(fhin);
    fclose(fhout);
end