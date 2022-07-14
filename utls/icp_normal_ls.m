function [Pcorrected, chi_per_iter] = icp_normal_ls(P, Q, maxIterations)
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

    % Compute normals of Q
    if iter == 1
        step = 1;
        Qnormals = compute_normal(Q, step);
    end
    % Find correspondences for each point in P
    switch uniqueCorrespondences
        case true
            unique = true;
            correspondences = get_correspondence_indices(Piter, Q, unique);
        case false
            correspondences = get_correspondence_indices(Piter, Q);
    end
    if drawCorrespondences
        fprintf('\n Iteration number: %d \n', iter)
        switch iter
            case 1
                f = figure(Name='Correspondences');
                draw_correspondences(Piter, Q, correspondences);
            case maxIterations
                close(f)
            otherwise
                draw_correspondences(Piter, Q, correspondences);
        end
    end
    % Gauss Newton
    [H, g, chi_per_iter(iter,:)] = point2plane_initialize(x, Piter, Q, Qnormals, correspondences);

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

function [Qnormals] = compute_normal(Q, step, drawNormals)

if nargin < 3
    drawNormals = false;
end

Qnormals = zeros(2, size(Q,2));
Qnormal_at_points = zeros(2,2,size(Q,2)-2);

for k = (1+step):(size(Q,2)-step)
    prev   = Q(:,k-step);
    curr   = Q(:,k);
    nxt    = Q(:,k+step);

    dx     = nxt(1) - prev(1);
    dy     = nxt(2) - prev(2);
    normal = [0 0; -dy dx];
    normal = normal/norm(normal);
    Qnormals(:,k) = normal(2,:);
    Qnormal_at_points(:,:,k-step) = curr' + normal;
end

if drawNormals
    figure(Name='Normals');
    plot(Q(1,:), Q(2,:), ':o', color='#D95319', MarkerFaceColor='#D95319', ...
        DisplayName= 'Q', MarkerSize= 6);
    hold on;
    for k = 1:size(Qnormal_at_points,3)
        plot(Qnormal_at_points(:,1,k), Qnormal_at_points(:,2,k), color=[0.7 0.7 0.7])
    end
end

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

function [H, g, chi] = point2plane_initialize(x, P, Q, Qnormals, correspondences)
% Gauss Newton : point-to-plane 
H   = zeros(3,3); % Hessian
g   = zeros(3,1); % gradient
chi = 0;

P_i = P(:,correspondences(1,:));
Q_j = Q(:,correspondences(2,:));
N_j = Qnormals(:,correspondences(2,:)); % normals of Q

for k = 1:size(correspondences,2)
    p_k  = P_i(:, k);
    q_k  = Q_j(:, k);
    n_k  = N_j(:,k);
    e_ij = n_k'*error_function(x, p_k, q_k);
    chi  = chi + e_ij'*e_ij;        % squared error
    J    = jacobian_matrix(x, p_k); % Jacobian
    J    = n_k'*J;
    H    = H + J'*J;             % Hessian
    g    = g + J'*e_ij;          % gradient
end
end