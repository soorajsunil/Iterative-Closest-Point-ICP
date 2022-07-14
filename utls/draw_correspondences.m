function draw_correspondences(P, Q, correspondences)
% animate correspondences 
x1 = P(1,correspondences(1,:));
y1 = P(2,correspondences(1,:));
x2 = Q(1,correspondences(2,:));
y2 = Q(2,correspondences(2,:));
plot_2Dpoints(P, Q, 'P', 'Q')
hold on;
plot([x1(:)'; x2(:)'], [y1(:)'; y2(:)'], 'k-', HandleVisibility='off');
hold off;
drawnow
end  

