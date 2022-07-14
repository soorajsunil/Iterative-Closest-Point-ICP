function correspondences = get_correspondence_indices(P, Q, uniqueCorrespondences)
% For each point in P find closest one in Q.

if nargin < 3
    uniqueCorrespondences = false; % for one-to-one correspondences
end

Plen = size(P,2);
Qlen = size(Q,2);
correspondences = zeros(3,1);

for p = 1:Plen % iterate moving scan
    minDistance = inf;
    idx         = 0;
    if all(~isnan(P(:,p))) % check if not NaNs (P)
        for q = 1:Qlen % iterate fixed scan
            if all(~isnan(Q(:,q)))         % check if not NaNs (Q)
                dist = norm(Q(:,q)-P(:,p));% distance between two points
                if (dist<minDistance)
                    minDistance = dist; % update minimum distance
                    idx         = q;    % update index
                end
            end
        end
        % create correspondence list
        correspondences(1,p) = p;          % moving scan index
        correspondences(2,p) = idx;        % fixed scan index
        correspondences(3,p) = minDistance;
    end
end

if uniqueCorrespondences
    correspondences = select_unique_correspondence(correspondences);
end

end

function correspondences = select_unique_correspondence(correspondences)
% >> OPTIONAL: select one-to-one correspondences
for i = 1:size(correspondences,2)
    for j = 1:size(correspondences,2)
        if (i~=j) && (correspondences(2,i)~=0) && (correspondences(2,j)~=0)
            if correspondences(2,i) == correspondences(2,j)
                if correspondences(3,i) <= correspondences(3,j)
                    correspondences(2,j) = 0;
                    correspondences(3,j) = 0;
                else
                    correspondences(2,i) = 0;
                    correspondences(3,i) = 0;
                end
            end
        end
    end
end
correspondences(:, ~all(correspondences,1)) = []; % delete all zero columns
end
