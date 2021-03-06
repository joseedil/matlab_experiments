clear all
close all

% Limits of variables (size of pitch in meters)
w = 75;
l = 100;

% Goal position
x0 = 0;
y0 = 0;
x1 = -3.65;
y1 = 0;
x2 = 3.65;
y2 = 0;

% Discretization
xn = 99;
yn = 99;
[x,y] = meshgrid(linspace(-w/2, w/2, xn), linspace(0, l, yn));

% Model evaluation
d = sqrt((x-x0).^2 + (y-y0).^2);
d1 = sqrt((x-x1).^2 + (y-y1).^2);
d2 = sqrt((x-x2).^2 + (y-y2).^2);
ap = (d1.^2 + d2.^2 - 7.3^2)./(2.*d1.*d2);
angle = abs(acos(ap));

N = 8; % Compression parameter.
angle = log(1+2^N.*angle)/log(1+2^N); % Compression: mu-law inspired. 
angle = angle/max(max(angle)); % Normalization

% Athelete skill model
p1 = 1 - (0.5 + 0.5*erf(5.*((d./max(max(d))) - 1/3)));
p2 = (0.5 + 0.5*erf(5.*((angle./max(max(angle))) - 1/3)));
p = p1.*p2;


% Linear model
% p1 = 1-d;
% 
% % Nonlinear athlete skill model
% p2 = 1 - (0.5 + 0.5*erf(4.*(d - 1/3)));
% 
% 
% % Plot
% 
% % Nonlinear model
% figure(1)
% plot(linspace(0,norm_d,100), 1 - (0.5 + 0.5*erf(4.*(linspace(0,1,100) - 1/3))));
% xlabel('Distance of shooting');
% ylabel('Probability of scoring');
% axis([0 l 0 1]);
% grid on
% 
% Probabilities
figure(2);
court = imread('pitch.png');                     % Pitch image
courtAlpha = rgb2gray(1.0 * (court < 200));      % Alpha channel
court_size = size(court);
black = cat(3, ...                               % Black image
zeros(court_size(1:2)),...
zeros(court_size(1:2)),...
zeros(court_size(1:2)));

% Rescale the grid to fit the court background
x = linspace(0,court_size(2), xn);
y = linspace(0,court_size(1), yn);

% Angle
subplot(1,3,1);

% Plot the probabilities contours
[C,h] = contourf(x, y, angle*180, 50);
%[C,h] = contourf(x, y, p1, 9);
hold on

% Overlay court
ii = imshow(black);
ii.AlphaData = courtAlpha;

% Embelishments... 
h.LineStyle = 'none';
pbaspect([w l w]);
axis tight;
c = colorbar;
c.Label.String = 'Aperture angle';
c.Limits = [0 180];

% Distance
subplot(1,3,2);

% Plot the probabilities contours
[C,h] = contourf(x, y, d, 50);
%[C,h] = contourf(x, y, p2, 9);
hold on

% Overlay court
ii = imshow(black);
ii.AlphaData = courtAlpha;

% Embelishments... 
h.LineStyle = 'none';
pbaspect([w l w]);
axis tight;
c = colorbar;
c.Label.String = 'Distance';
c.Limits = [0 max(max(d))];

% Nonlinear model
% Distance
subplot(1,3,3);

% Plot the probabilities contours
[C,h] = contourf(x, y, p, 50);
hold on

% Overlay court
ii = imshow(black);
ii.AlphaData = courtAlpha;

% Embelishments... 
h.LineStyle = 'none';
pbaspect([w l w]);
axis tight;
c = colorbar;
c.Label.String = 'Probability of scoring';
c.Limits = [0 1];