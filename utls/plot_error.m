function plot_error(vals_per_iter, lgnd)
% Plot error norms per iteration 
figure(Name='Error'); 
hold on; grid on; 
plot(vals_per_iter, LineWidth=2)
legend(lgnd, Interpreter="latex")
xlabel('Iteration Number'); 
axis tight 
end

