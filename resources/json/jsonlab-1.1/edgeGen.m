%% edgeGen: generates the edges based on a Grouch json file
function edgeGen(fname, outname)
    data = loadjson(fname);
    edges = [];
    for x = 1:length(data)
        st = data{x};
        if any(strcmp(fieldnames(st),'prerequisites'))
            prereqs = allprereq(st.prerequisites.courses);
            for y = 1:length(prereqs)
                edges = [edges; {st.identifier, prereqs{y}}];
            end
        end       
    end
    edges(~ismember(edges(:,2), edges(:,1)), :) = [];
    json = struct('from', edges(:,2), 'to', edges(:,1), 'arrows', 'to');
    strjson = savejson('', json);
    strjson = ['var edges = ', strjson(2:end-3), ';'];
    fh = fopen(outname, 'w');
    fprintf(fh, strjson);
    fclose(fh);
end

%allprereq returns a cell array containing the prerequisites of the input
%structure
function out = allprereq(ca)
    out = {};
    for x = 1:length(ca)
        if isstruct(ca{x})
            out = [out, allprereq(ca{x}.courses)];
        else
            out = [out, ca{x}];
        end
    end
end