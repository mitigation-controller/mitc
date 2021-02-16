% Code by Bruno Luong
% https://nl.mathworks.com/matlabcentral/answers/397219-how-to-find-all-possible-routes-with-a-given-node-matrix

function p = allpaths(A,start,last)
% find all direct paths from start to last
% A is (n x 2) each row is an edges
A = sortrows(A);
b = true(size(A,1),1);
p = gapengine(A,b,start,last);
end


function p = gapengine(A,b,start,last)
% recursive engine
if start==last
    p = {last};
else
    bs = A(:,1) == start;
    next = A(bs & b,2);
    p = {};
    b(bs) = false;
    for k=1:length(next)
        i = next(k);
        pk = gapengine(A,b,i,last);
        pk = cellfun(@(p) [start, p], pk, 'unif', 0);
        p = [p, pk];
    end
end
end