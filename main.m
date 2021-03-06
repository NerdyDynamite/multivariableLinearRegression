%% Initialization

%% ================ Part 1: Feature Normalization ================

%% Clear and Close Figures
clear ; close all; clc

fprintf('Loading data ...\n');

%% Load Data
data = load('housingData.txt');
X = data(:, 1:2);
y = data(:, 3);
m = length(y);

% Print out some data points
fprintf('First 10 examples from the dataset: \n');
fprintf(' x = [%.0f %.0f], y = %.0f \n', [X(1:10,:) y(1:10,:)]');

fprintf('Program paused. Press enter to continue.\n');
pause;

% Scale features and set them to zero mean
fprintf('Normalizing Features ...\n');

[X mu sigma] = featureNormalize(X);

% Add intercept term to X
X = [ones(m, 1) X];


%% ================ Part 2: Gradient Descent ================

fprintf('Running gradient descent ...\n');

% Choose some alpha value
alpha = 0.3;
num_iters = 50;

% Init Theta and Run Gradient Descent 
theta = zeros(3, 1);
[theta, J_history] = gradientDescentMulti(X, y, theta, alpha, num_iters);

% Plot the convergence graph
figure;
plot(1:numel(J_history), J_history, '-b', 'LineWidth', 2);
xlabel('Number of iterations');
ylabel('Cost J');

% Display gradient descent's result
fprintf('Theta computed from gradient descent: \n');
fprintf(' %f \n', theta);
fprintf('\n');

% Estimate the price of a 1650 sq-ft, 3 br house
houseData = [1650 3]';

for k=1:length(houseData)
    houseData(k) = (houseData(k)-mu(k))/sigma(k);
end

houseData = [1 houseData']';

price = theta'*houseData;

% ============================================================

fprintf(['Predicted price of a 1650 sq-ft, 3 br house ' ...
         '(using gradient descent):\n $%f\n'], price);

fprintf('Program paused. Press enter to continue.\n');

% plot out given data points vs. hypothesis equation line
figure
plot3(X(:,2),X(:,3),y,'xr','MarkerSize',10) % actual data
grid on
hold on
xlabel('Square Feet')
ylabel('Number of Rooms')
zlabel('Price ($)')
title('Predicted Housing Prices Based on Several Parameters')
sqft = linspace(min(data(:,1)),max(data(:,1)),100)';
numRooms = linspace(min(data(:,2)),max(data(:,2)),100)';

sqft = (sqft - mu(1))./sigma(1);
numRooms = (numRooms - mu(2))./sigma(2);

[sqftMesh,numRoomsMesh] = meshgrid(sqft,numRooms);

hypoMatrix = theta(1)+theta(2).*sqftMesh+theta(3).*numRoomsMesh;

surf(sqftMesh,numRoomsMesh,hypoMatrix) % plot surface corresponding to generated hypothesis

plot3(houseData(2),houseData(3),price,'xg','MarkerSize',10) % plot predicted house price
pause;

%% ================ Part 3: Normal Equations ================

fprintf('Solving with normal equations...\n');

%% Load Data
data = csvread('housingData.txt');
X = data(:, 1:2);
y = data(:, 3);
m = length(y);

% Add intercept term to X
X = [ones(m, 1) X];

% Calculate the parameters from the normal equation
theta = normalEqn(X, y);

% Display normal equation's result
fprintf('Theta computed from the normal equations: \n');
fprintf(' %f \n', theta);
fprintf('\n');


% Estimate the price of a 1650 sq-ft, 3 br house

houseData = [1650 3]';

houseData = [1 houseData']';

price = theta'*houseData;

fprintf(['Predicted price of a 1650 sq-ft, 3 br house ' ...
         '(using normal equations):\n $%f\n'], price);