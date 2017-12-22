clear all
close all

% Limits of variables (size of field in meters)
w = 15;
l = 28.65;

% Basket position
xb = 0;
yb = 1.6;

% Discretization
xn = 100;
yn = 100;
[x,y] = meshgrid(linspace(-w/2, w/2, xn), linspace(0, l, yn));

% Model evaluation
d = sqrt((x-xb).^2 + (y-yb).^2);
norm_d = max(max(d));
d = d./norm_d; % Normalization


% Linear model
p1 = 1-d;

% Nonlinear athlete skill model
p2 = 1 - (0.5 + 0.5*erf(4.*(d - 1/3)));


% Plot

% Nonlinear model
figure(1)
plot(linspace(0,norm_d,100), 1 - (0.5 + 0.5*erf(4.*(linspace(0,1,100) - 1/3))));
xlabel('Distance of shooting');
ylabel('Probability of scoring');
axis([0 l 0 1]);
grid on

% Probabilities
figure(2);
court = imread('fullcourt.png');                 % Court image
courtAlpha = rgb2gray(1.0 * (court < 200));      % Alpha channel
court_size = size(court);
black = cat(3, ...                               % Black image
  zeros(court_size(1:2)),...
  zeros(court_size(1:2)),...
  zeros(court_size(1:2)));

% Rescale the grid to fit the court background
x = linspace(0,court_size(2), xn);
y = linspace(0,court_size(1), yn);

subplot(1,2,1);

% Plot the probabilities contours
[C,h] = contourf(x, y, p1, 9);
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

subplot(1,2,2);
[C,h] = contourf(x, y, p2, 9);
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
