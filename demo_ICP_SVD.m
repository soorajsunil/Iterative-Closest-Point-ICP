% Demostrtaion of iterative closest point (ICP) algorithm based on
% singular value decomposition
% 1) Numerical simulated example
% 2) LIDAR scan matching

clc; clear; close all;
demo = 'SIMULATION' ;  % Options = {'lidar', 'simulation'}

switch upper(demo)
    case 'SIMULATION'
        % Simulate data points
        demo_data_simulation
        % ICP
        maxIteration = 10;
        [Pcorrected, norm_per_iter] = icp_svd(P, Q, maxIteration);
        % Plot corrected data
        figure(Name='After ICP');
        plot_2Dpoints(Pcorrected,Q,'P: corrected data', 'Q: true data', 6, 8)
        % Plot squared differences P->Q
        lgnd = {'$\sum_{i,j}$ $\vert \vert p_i- q_j \vert \vert$'};
        plot_error(norm_per_iter, lgnd)
    case 'LIDAR'
        % Get lidar data points
        demo_lidar_scans
        % ICP
        maxIteration = 10;
        [P_corrected, norm_per_iter] = icp_svd(P, Q, maxIteration);
        % Plot corrected data
        figure(Name='After ICP');
        plot_2Dpoints(P_corrected,Q,'P: corrected scan', 'Q: fixed scan', 6, 8)
        % Plot squared differences P->Q
        lgnd = {'$\sum_{i,j}$ $\vert \vert p_i- q_j \vert \vert$'};
        plot_error(norm_per_iter, lgnd)
end
