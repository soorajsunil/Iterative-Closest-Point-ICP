function [Pcorrected, error_per_iter] = icp_svd(P, Q, maxIterations)
% Transform 2D point set "P" to coordinates of 2D point set "Q"
% using iterative closest point (ICP) algorithm based on
% singular value decomposition (SVD)

if nargin < 3
    maxIterations = 10;
end

drawCorrespondences   = true; % animation per iteration
uniqueCorrespondences = false; % for one-to-one correspondences

% initialize parameters
Piter          = P; % copy P for iteation update
error_per_iter = zeros(maxIterations,1);

for iter = 1:maxIterations
    % Make data centered by subtracting the mean
    if iter == 1
        [Qcntrd, Q0] = center_data(Q);
    end
    [Pcntrd, P0] = center_data(Piter);
    % Find correspondences for each point in P
    switch uniqueCorrespondences
        case true
            unique = true;
            correspondences = get_correspondence_indices(Pcntrd, Qcntrd, unique);
        case false
            correspondences = get_correspondence_indices(Pcntrd, Qcntrd);
    end
    % Optional animation:
    if drawCorrespondences
        fprintf('\n ICP Iteration number: %d / %d\n', iter, maxIterations)
        filename = 'correspondences.gif' ;
        switch iter
            case 1
                f = figure('rend','painters','pos',[100 100 800 600]); clf;
                set(gcf, 'Color', [1,1,1]);
                draw_correspondences(Piter, Q, correspondences);
                frame = getframe(f);                                    % capture frame for file-writing
                im = frame2im(frame);
                [imind,cm] = rgb2ind(im,256);
                imwrite(imind,cm,filename,'gif', 'Loopcount',inf, 'DelayTime', 1);
            case maxIterations
                close(f)
            otherwise
                draw_correspondences(Piter, Q, correspondences);
                frame = getframe(f);                                    % capture frame for file-writing
                im = frame2im(frame);
                [imind,cm] = rgb2ind(im,256);
                imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime', 1);
        end
    end
    % Compute cross_covariance
    covariance = compute_cross_covariance(Pcntrd, Qcntrd, correspondences);
    error_per_iter(iter,:) = norm(Qcntrd-Pcntrd);
    % Singular value decomposition based alignment
    [U,~,Vtrans] = svd(covariance); % H = U*S*V'
    R = U*Vtrans;                   % rotation
    t = Q0 - R*P0;                  % translation
    % Apply the rotation and translation
    Piter = R*Piter + t;  % transformed point set
end
Pcorrected = Piter;
end

function [dataCentered, dataMean] = center_data(data)
% mean shift the points
dataMean     = mean(data,2);
dataCentered = data - dataMean;
end

function covariance = compute_cross_covariance(P, Q, correspondences)
Pn =  P(:,correspondences(1,:));
Qn =  Q(:,correspondences(2,:));
covariance = Qn*Pn';
% Pending.. weighted covariance
end


