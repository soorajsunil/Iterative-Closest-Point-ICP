function [Pcorrected, chi_per_iter] = icp_ls(P, Q, maxIterations)
% Transform 2D point set P to coordinates of 2D point set Q using iterative
% closest point (ICP) algorithm based on nonlinear optimization

drawCorrespondences   = true; % animation per iteration
uniqueCorrespondences = false; % for one-to-one correspondences

switch nargin
    case 2
        maxIterations         = 10;
end

x       = zeros(3,1); % intial pose
Piter   = P; %
chi_per_iter = zeros(maxIterations,1); % squared error

for iter = 1:maxIterations
    % Find correspondences for each point in P
    switch uniqueCorrespondences
        case true
            unique = true;
            correspondences = get_correspondence_indices(Piter, Q, unique);
        case false
            correspondences = get_correspondence_indices(Piter, Q);
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
    % Gauss Newton
    [H, g, chi_per_iter(iter,:)] = point2point_initialize(x, Piter, Q, correspondences);

    dx   = lsqr(H, -g); % least squares
    x    = x + dx;
    x(3) = atan2(sin(x(3)), cos(x(3))); % normalize angle
    R    = rotation_matrix(x(3));       % rotation matrix
    t    = x(1:2);                      % translation vector

    % Apply the rotation and translation
    Piter = R*Piter + t;
end

Pcorrected = Piter;
end

function [R, Rderivative] =  rotation_matrix(theta)
R           =  [cos(theta), -sin(theta);
    sin(theta),  cos(theta)]; % rotation matrix
Rderivative = [-sin(theta), -cos(theta);  % derivative of a rotation matrix
    cos(theta), -sin(theta)];
end

function J = jacobian_matrix(x, p_point)
J          = zeros(2,3);
theta      = x(3);
J(:,1:2)   = eye(2);
[~, Rdiff] =  rotation_matrix(theta);
J(:,3)     = Rdiff*p_point;
end

function error =  error_function(x, p_point, q_point)
R          = rotation_matrix(x(3)); % rotation matrix
t          = x(1:2);                % translation vector
prediction = R*(p_point) + t;
error      =  prediction - q_point; % <- minimize
end

function [H, g, chi] = point2point_initialize(x, P, Q, correspondences)
H   = zeros(3,3); % Hessian
g   = zeros(3,1); % gradient
chi = 0;
P_i =  P(:,correspondences(1,:));
Q_j =  Q(:,correspondences(2,:));

for k = 1:size(correspondences,2)
    p_point = P_i(:, k);
    q_point = Q_j(:, k);
    e       = error_function(x, p_point, q_point);
    chi     = chi + e'*e;                  % squared error
    J       = jacobian_matrix(x, p_point); % Jacobian
    H       = H + J'*J;                    % Hessian
    g       = g + J'*e;                    % gradient
end
end
