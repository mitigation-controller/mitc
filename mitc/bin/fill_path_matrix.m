function P_ki = fill_path_matrix(R_ii, N)
%
%
%
%

[row,col] = find(R_ii); %find the interdependent activities
A = [col,row]; %store the indices in a two-column matrix that shows which activity depends on which activity (link matrix)
P_all = transpose(allpaths(A,1,N)); %use the function all path to find all possible paths from point 1 to point N

P_ki=zeros(length(P_all),N); % create matrix P-K to store the paths

% for-loop to fill the P_ki matrix
for k=1:length(P_all)
    for i=1:length(P_all{k})
        P_ki(k,P_all{k}(i))=1;
    end
end

end