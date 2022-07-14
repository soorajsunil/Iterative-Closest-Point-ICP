function plot_2Dpoints(P, Q, DisplayName_P, DisplayName_Q, MarkerSize_P, MarkerSize_Q)
% plot 2D points (xy coordinates) 
switch nargin
    case 2 
        DisplayName_P = 'P: moved data' ;
        DisplayName_Q = 'Q: true data' ; 
        MarkerSize_P  = 6; 
        MarkerSize_Q  = 6; 
    case 4
        MarkerSize_P  = 6; 
        MarkerSize_Q  = 6; 
end 
plot(Q(1,:), Q(2,:), ':o', color='#D95319', MarkerFaceColor='#D95319', ...
    DisplayName= DisplayName_Q, MarkerSize= MarkerSize_Q); 
hold on; box on; 
plot(P(1,:), P(2,:), ':o', color='#0072BD', MarkerFaceColor='#0072BD',...
    DisplayName= DisplayName_P,  MarkerSize= MarkerSize_P);
legend show 
xlabel('x'); ylabel('y')
hold off; 
end 